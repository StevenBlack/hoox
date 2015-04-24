require 'minitest/autorun'
require './trivialparserhooks.rb'

class TestAnchor < Minitest::Test

  def setup
    @lowerhook   = LowerHook.new
  end

  # VANILLA HOOKS
  # A process call must not mutate the argument
  def test_lowerhook
  	teststring = "Short, sharp shocked"
    assert_equal( teststring.downcase, @lowerhook.process(teststring), "Functional error in class LowerHook")
  end

end
