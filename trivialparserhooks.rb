require './hooks'

# Public: A trivial parser hook
class LowerHook < Hoox::AbstractHook
  # Public: The main method for ParserHooks.  We assume the argument is text.
  def execute(arg)
    arg.downcase!
  end
end

# Public: A trivial parser hook
class UpperHook < Hoox::AbstractHook
  # Public: The main method for ParserHooks.  We assume the argument is text.
  def execute(arg)
    arg.upcase!
  end
end
