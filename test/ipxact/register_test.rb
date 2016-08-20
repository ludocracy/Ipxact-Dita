require_relative '../../lib/ipxact/register'
require 'test/unit'

class RegisterTest < Test::Unit::TestCase
  include CRR

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup

  end

  attr_reader :r

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_header
    assert_equal %w(offset range base word docs), r.to_header
    assert_equal %w(offset range base word), r.to_header('docs')
  end

  def test_to_row
    assert_equal ['0xF0', 32, 0, 32, ['EXAMPLE', 'Example Register', nil]], r.to_row
    assert_equal ['0xF0', 32, 0], r.to_row(%w(word docs))
  end

  def test_to_table
    # TODO when BitField is done
  end
end