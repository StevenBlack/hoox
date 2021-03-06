require 'minitest_helper'

class TestAnchor < Minitest::Test

  def setup
    @vanillahook   = Hoox::Hook.new
    @vanillaanchor = Hoox::Anchor.new
  end

  # Do we have a version number
  def test_that_it_has_a_version_number
    refute_nil ::Hoox::VERSION
  end

  # VANILLA HOOKS
  # A process call must not mutate the argument
  def test_hook_process_call_does_not_mutate
  	teststring = "Short, sharp shocked"
    assert_equal( teststring, @vanillahook.process(teststring), "Vanilla hooks must not mutate arguments")
  end


  # VANILLA ANCHOR
  # The Anchor.ahook member must be an array
  def test_anchor_ahook_member_is_array
    assert_kind_of( Array, @vanillaanchor.ahook, "Member ahook is not Array" )
  end
  # A process call must not mutate the argument
  def test_anchor_process_call_does_not_mutate
  	teststring = "Short, sharp shocked"
    assert_equal( teststring, @vanillaanchor.process(teststring), "Vanilla hooks must not mutate arguments")
  end

end
