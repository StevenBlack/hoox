##
# Class AbstractHook is the highest-level hook class wherein common
# hook interfaces are defined.

class AbstractHook

  ##
  # The @oHook member is designed to hold other instances of this class,
  # thus making all hooks potentially self-referential

  @oHook = nil

  ##
  # The main interface for hooks.  The process method delegates to this
  # instance's execute method, then delegates down the hook chain.

  def process(*args)
    if preprocess(args)
      execute(args)
    end

    if ! @hook.nil?
      @hook.process(args)
    end
    postprocess(args)
  end

  ##
  # This method fires before the execute method and ultimately determines
  # if the execute method fires at all.

  def preprocess(*args)
    # Override to implement whether this hook executes
    true
  end

  ##
  # This method fires after the hook chain processes returns.  This is a good
  # place for cleanup code.

  def postprocess(*args)
  end

  ##
  # This is where the meat of the hook lives.

  def execute(*args)
    # Implement the hook here
  end

  ##
  # Add a hook reference to this hook.  If the hook member is nil, keep the
  # reference here.  If the hook member is not nil, delegate the hook to its
  # sethook method.

  def sethook(*args)
    args.each { |arg|
      return if arg.nil?
      arg = resolve_to_hook(arg)
      return if arg.nil?  # Which it could be.
      case
      when @hook.nil?
        @hook = arg    # hook stays here
      when @hook.is_a?(AbstractHook)
        @hook.sethook(arg)  # Delegate immediately
      end
    }
  end

  ##
  # Pass it a hook instance or a string and, in the case of string, creates a
  # hook of that class bame.

  def resolve_to_hook(arg)
    ret = nil
    case
    when arg.is_a?(AbstractHook)
      ret = arg
    when arg.is_a?(String) && Kernel.const_defined?(arg)
      tmp = Kernel.const_get(arg).new
      if tmp.is_a?(AbstractHook)
        ret = tmp
      end
    end
    ret
  end
end

##
# Class HookAnchor can carry several hook chains and can serve to anchor a
# directed graph of hooks.

class HookAnchor < AbstractHook
  attr_accessor :ahook

  def initialize(*args)
    self.ahook = [] # on object creation initialize this to an array
    args.each { |arg|
      arg = resolve_to_hook(arg)
      if ! arg.nil?
        self.ahook << arg
      end
    }
  end

  def execute(*args)
    @ahook.each { | hook |
      if hook.is_a?(AbstractHook)
        hook.process(args)
      end
    }
  end
end
