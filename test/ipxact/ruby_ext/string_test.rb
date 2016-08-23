require_relative '../../../lib/ipxact/ruby_ext/string'
require 'test/unit'

class StringTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @a = %w(0x89ABCD 'h89ABCD 0b100010011010101111001101)

  end
  attr_reader :a

  def test_to_dec
    assert_equal 9022413, a[0].to_dec
    assert_equal 9022413, a[1].to_dec
    assert_equal 9022413, a[2].to_dec
  end
end