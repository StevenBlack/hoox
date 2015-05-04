module Hoox
  # Public: A trivial parser hook
  class LowerHook < Hoox::ParserHook
    # Public: The main method for ParserHooks.  We assume the argument is text.
    def execute(arg)
      arg.downcase!
    end
  end

  # Public: A trivial parser hook
  class UpperHook < Hoox::ParserHook
    # Public: The main method for ParserHooks.  We assume the argument is text.
    def execute(arg)
      arg.upcase!
    end
  end
end
