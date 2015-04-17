##
# Class AbstractHook is the highest-level hook class wherein all the common 
# hook interfaces are defined.

class AbstractHook

  ##
  # The @oHook member is designed to hold other instances of this class, thus
  # making all hooks potentially self-referential

  @oHook =  nil

  def sethook( *args )
    args.each { |arg|
      if @hook.nil?
        case 
        when arg.is_a?( AbstractHook )
          @hook = arg
        when arg.is_a?( String )
          @hook = Kernel.const_get( arg ).new
        end
      else
        @hook.sethook( arg )
      end
    }
  end

  def process( *args )
    if preprocess( args )
      execute( args )
    end

    if ! @hook.nil?
      @hook.process( args )
    end
    postprocess( args )

  end

  def preprocess( *args )
    # Override to implement whether this hook executes
    true
  end

  def postprocess( *args )

  end

  def execute( *args )
    # Implement the hook here
  end
end

class HookAnchor < AbstractHook
  attr_accessor :ahook

  def initialize( *args )
    self.ahook = [] # on object creation initialize this to an array
    args.each { |arg|
      self.ahook << arg
    }
  end

  def execute( *args )
    @ahook.each { | hook |
      if hook.is_a?( AbstractHook )
        hook.process( args )
      end
    }
  end
end

