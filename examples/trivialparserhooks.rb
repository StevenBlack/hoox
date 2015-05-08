module Hoox
  # Public: A trivial parser hook
  class LowerHook < Hoox::Hook
    def execute(arg)
      arg.downcase!
    end
  end

  # Public: A trivial parser hook
  class UpperHook < Hoox::Hook
    def execute(arg)
      arg.upcase!
    end
  end
end
