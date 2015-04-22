require 'minitest/autorun'
require './hooks'

class TestAnchor < Minitest::Test

  def setup
    @vanillaanchor = HookAnchor.new
  end

  def test_ahook_member_is_array
    assert_kind_of Array, @vanillaanchor.ahook, "Member ahook is not Array"
  end

end
