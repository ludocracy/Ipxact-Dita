require_relative '../../../lib/ipxact/ruby_ext/string'
require 'test/unit'

class StringTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @a = '0x89ABCD'
    @b = "'h89ABCD"
  end
  attr_reader :a, :b

  def test_to_bin
    omit
    assert_equal '100010011010101111001101', a.to_bin
    assert_equal '24b100010011010101111001101', a.to_bin(:pre)
    assert_equal '0000 0000 1000 1001 1010 1011 1100 1101', a.to_bin(:pad, :sep)
    assert_equal '100010011010101111001101b', a.to_bin(:post)
  end

  def test_to_dec
    assert_equal 9022413, a.to_dec
    assert_equal 9022413, b.to_dec
  end
end