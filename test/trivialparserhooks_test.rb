require 'minitest_helper'

class TestTrivialHooks < Minitest::Test

  def setup
    @lower_hook   = Hoox::LowerHook.new
    @upper_hook   = Hoox::UpperHook.new
  end

  # VANILLA HOOKS
  # A process call must not mutate the argument
  def test_lowerhook
  	test_string = "Short, sharp, shocked"
    assert_equal( test_string.downcase, @lower_hook.process( test_string ), "Functional error in class LowerHook")
  end

  # Last hook wins
  def test_last_hook_wins
  	test_string = "Short, sharp, shocked"
  	@lower_hook.sethook( @upper_hook )
  	result1 = test_string.downcase.upcase
    assert_equal( result1, @lower_hook.process( test_string ), "Last hook should 'win'")
  end

end
