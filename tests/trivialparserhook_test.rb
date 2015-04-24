require 'minitest/autorun'
require './trivialparserhooks.rb'

class TestAnchor < Minitest::Test

  def setup
    @lowerhook   = LowerHook.new
    @upperhook   = UpperHook.new
  end

  # VANILLA HOOKS
  # A process call must not mutate the argument
  def test_lowerhook
  	teststring = "Short, sharp, shocked"
    assert_equal( teststring.downcase, @lowerhook.process(teststring), "Functional error in class LowerHook")
  end

  # Last hook wins
  def test_last_hook_wins
  	teststring = "Short, sharp, shocked"
  	@lowerhook.sethook( @upperhook )
  	result1 = teststring.downcase.upcase
    assert_equal( result1, @lowerhook.process(teststring), "Last hook should 'win'")
  end

end
