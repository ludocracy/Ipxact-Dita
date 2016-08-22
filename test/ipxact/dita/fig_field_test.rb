require_relative '../../lib/ipxact/addressable'
require 'test/unit'

class Klass
  include Addr
  def initialize(a,w) @bits, @word = a, w end
end

class AddressableTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @a = Klass.new([1,0,0,0,
                    1,0,0,1,
                    1,0,1,0,
                    1,0,1,1,
                    1,1,0,0,
                    1,1,0,1], 32)
  end

  attr_reader :a

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_hex
    assert_equal '0x89ABCD', a.to_hex
    assert_equal '0x0089_ABCD', a.to_hex(:sep, :pad)
    assert_equal '89ABCDh', a.to_hex(:post)
  end

  def test_to_bin
    assert_equal '100010011010101111001101', a.to_bin
    assert_equal '24b100010011010101111001101', a.to_bin(:pre)
    assert_equal '0000 0000 1000 1001 1010 1011 1100 1101', a.to_bin(:pad, :sep)
    assert_equal '100010011010101111001101b', a.to_bin(:post)
  end

  def test_to_dec
    assert_equal '9022413', a.to_dec
    assert_equal '9,022,413', a.to_dec(:sep)
    assert_equal '9022413d', a.to_dec(:post)
  end
end