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

  # test vanilla generation from ip xact

  # test permutations of presentation

  # test permutations of register type

  # devolve to ConDuxml tests and ip-xact::component tests

  def test_vanilla_xform
    save OUTPUT_PATH, transform(XFORM_PATH, SOURCE_PATH)
  end
end