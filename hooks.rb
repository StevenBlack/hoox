# Public: The highest-level self-referential and chainable hook class wherein
# common hook interfaces are defined.
#
# Examples
#
#   Hook.process(some_string)
#   # => some_transformed_text
class AbstractHook

  # Internal: The @oHook member is designed to hold other instances of this
  # type, thus making all hooks potentially self-referential
  @oHook = nil

  # Public: The main method for hooks.  The process method delegates to this
  # instance's execute method, then delegates down the hook chain.
  def process(arg)
    ret = preprocess(arg)
    if ret
      ret = execute(ret)
    end

    if ! @hook.nil?
      ret=@hook.process(ret)
    end
    postprocess(ret)
  end

  # Internal: The preprocess method fires before the execute method and
  # ultimately determines if the execute method fires at all.
  def preprocess(arg)
    # Override to implement whether this hook executes
    arg
  end

  # Internal: The postprocess method fires after the hook chain processes
  # returns.  This is a good place for cleanup code.
  def postprocess(arg)
    arg
  end

  # Internal: This is where the meat of the hook lives.
  def execute(arg)
    # Implement the hook here
    arg
  end

  # Public: Add a hook reference to this hook.  If the hook member is nil,
  # keep the reference here.  If the hook member is not nil, delegate the
  # hook to its sethook method.
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

  # Internal: Pass it a hook instance or a string and, in the case of string,
  # creates a hook of that class bame.
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


# Public: HookAnchor can carry several hook chains and can serve to anchor a
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

  # Internal: Anchors execute by firing upon its array of hooks.
  def execute(arg)
    @ahook.each { | hook |
      if hook.is_a?(AbstractHook)
        arg=hook.process(arg)
      end
    }
    arg
  end
end

# Public: ParserHooks specialize in processing text.
class ParserHook < AbstractHook

  # We cache what was passed-in
  @content_in  = ""

  def execute(arg)
    @content_in = arg
    new_content = self.parse(arg)
    new_content == @content_in ? @content_in : @content_in.gsub!(new_content)
  end

  def parse(arg)
    # implement me!
    arg
  end
end
