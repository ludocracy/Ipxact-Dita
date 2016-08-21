require_relative '../../lib/ipxact/register'

require 'test/unit'
require 'ruby-dita'

class RegFigTest < Test::Unit::TestCase
  include Dita
  include ConDuxml

  REGS_FILE = File.expand_path(File.dirname(__FILE__) + '/../../xml/uart_scml.xml')
  XFORM_FILE = File.expand_path(File.dirname(__FILE__) + '/../../xml/ipxact_transforms.xml')

  def setup
    load REGS_FILE
  end

  def test_to_figure
    a = transform XFORM_FILE, doc

  end
end