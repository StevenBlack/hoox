require 'minitest/autorun'
require './transformationhooks.rb'

class TestTransformations < Minitest::Test

  def setup
    @tab_hide_hook = TabHideHook.new
  end

  # TabHideHook
  def test_tab_hide_hook
  	test_string = "\t\tShort,\tsharp,\tshocked"
    assert_equal( test_string, @tab_hide_hook.process( test_string ), "TabHideHook has side-effects.")
  end
end
