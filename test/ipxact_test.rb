require 'test/unit'
require_relative '../lib/ipxact'
require 'con_duxml'

class IpxactTest < Test::Unit::TestCase
  include Ipxact
  include ConDuxml

  XFORM_PATH = File.expand_path(File.dirname(__FILE__) + '/../xml/ipxact_to_dita.xml')
  SOURCE_PATH = File.expand_path(File.dirname(__FILE__) + '/../xml/uart_scml.xml')
  OUTPUT_PATH = File.expand_path(File.dirname(__FILE__) + '/../xml/uart_scml.dita')

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_vanilla_xform
    output = transform(XFORM_PATH, SOURCE_PATH)
    save(OUTPUT_PATH, output)
  end
end