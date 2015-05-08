require "hoox/version"

# stdlib
require 'securerandom'


module Hoox
  # Public: The highest-level self-referential and chainable hook class wherein
  # common hook interfaces are defined.
  #
  # Examples
  #
  #   Hook.process(some_string)
  #   # => some_transformed_text
  class Hook

    def initialize
      # Internal: The @oHook member is designed to hold other instances of this
      # type, thus making all hooks potentially self-referential
      @oHook = nil
    end

    # Public: Use this method to short-circuit the hook if it doesn't apply.
    def applies( arg )
      true
    end

    # Public: The main method for hooks.  The process method delegates to this
    # instance's execute method, then delegates down the hook chain.
    def process( arg )
      if applies( arg )
          execute( preprocess( arg ))
      end
      if ! @hook.nil?
        @hook.process( arg )
      end
      postprocess( arg )
    end

    # Internal: The preprocess method fires before the execute method and
    # ultimately determines if the execute method fires at all.
    def preprocess( arg )
      # Override to implement whether this hook executes
      arg
    end

    # Internal: The postprocess method fires after the hook chain processes
    # returns.  This is a good place for cleanup code.
    def postprocess( arg )
      arg
    end

    # Internal: This is where the meat of the hook lives.
    def execute( arg )
      # Implement the hook here
      arg
    end

    # Public: Add a hook reference to this hook.  If the hook member is nil,
    # keep the reference here.  If the hook member is not nil, delegate the
    # hook to its sethook method.
    def sethook(*args)
      args.each { |arg|
        return if arg.nil?
        arg = resolve_to_hook( arg )
        return if arg.nil?  # Which it could be.
        case
        when @hook.nil?
          @hook = arg    # hook stays here
        when @hook.is_a?( Hook )
          @hook.sethook( arg )  # Delegate immediately
        end
      }
    end

    # Internal: Pass it a hook instance or a string and, in the case of string,
    # creates a hook of that class bame.
    def resolve_to_hook( arg )
      ret = nil
      case
      when arg.is_a?( Hook )
        ret = arg
      when arg.is_a?( String ) && Kernel.const_defined?( arg )
        tmp = Kernel.const_get( arg ).new
        if tmp.is_a?( Hook )
          ret = tmp
        end
      end
      ret
    end
  end

  # Public: HookAnchor can carry several hook chains and can serve to anchor a
  # directed graph of hooks.
  class Anchor < Hook
    attr_accessor :ahook

    def initialize( *args )
      super
      self.ahook = [] # on object creation initialize this to an array
      args.each { |arg|
        arg = resolve_to_hook( arg )
        if ! arg.nil?
          self.ahook << arg
        end
      }
    end

    # Internal: Anchors execute by firing upon its array of hooks.
    def execute( arg )
      @ahook.each { | hook |
        if hook.is_a?(Hook)
          arg.gsub!(hook.process( arg ))
        end
      }
      arg
    end
  end

  # Publlic: Regex-based hider hook
  class RegexHideHook < Hoox::Hook
    def initialize(*args)
      super
      @@token_prefix = " <!-- "
      @@token_suffix = " --> "
      @matches = Hash.new
    end

    # Remove all HTML tags
    def preprocess( arg )
      if @regex
        next_match = arg[/#{@regex}/im ]
        while next_match
          next_token = SecureRandom.urlsafe_base64( 20 )
          next_swap  = @@token_prefix + next_token + @@token_suffix
          @matches[ next_token ] = next_match
          arg.gsub!( next_match, next_swap )
          next_match = arg[/#{@regex}/im ]
        end
      end
      arg
    end

    # Restore all HTML tags
    def postprocess( arg )
      @matches.keys.each{ |k|
        arg.gsub!( @@token_prefix + k + @@token_suffix, @matches[k] )
      }
      arg
    end
  end
end
