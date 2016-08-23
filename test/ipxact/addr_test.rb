require_relative '../../lib/ipxact/addr'
require 'test/unit'

class AddrTest < Test::Unit::TestCase
  include Addr
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @a = '0b100010011010101111001101'
  end

  attr_reader :a

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_hex
    assert_equal '89ABCD', to_hex(a)
    assert_equal '0089_ABCD', to_hex(a, {sep: true, pad: 8})
    assert_equal "'h89ABCD", to_hex(a, pre: "'h")
    assert_equal '89ABCDh', to_hex(a, post: true)
  end

  def test_to_bin
    assert_equal '100010011010101111001101', to_bin(a)
    assert_equal '0b100010011010101111001101', to_bin(a, pre: true)
    assert_equal '100010011010101111001101b', to_bin(a, post: true)
    assert_equal '1000 1001 1010 1011 1100 1101', to_bin(a, {sep: true})
  end

  def test_to_dec
    assert_equal '9022413', to_dec(a)
    assert_equal '9,022,413', to_dec(a, sep: true)
    assert_equal '9.022.413', to_dec(a, sep: '.')
    assert_equal '9022413d', to_dec(a, post: true)
  end
end