require_relative '../../lib/ipxact/register'

require 'test/unit'
require 'ruby-dita'

class RegFigTest < Test::Unit::TestCase
  include Dita
  include ConDuxml

  TEMPFILE = File.expand_path(File.dirname(__FILE__) + '/../../xml/temp.xml')
  REGSFILE = File.expand_path(File.dirname(__FILE__) + '/../../xml/iregs.xml')

  def setup
    load REGSFILE
  end

  def test_to_figure
    omit
    fields = [
        BitField.new({name: 'field0', pos: 0, size: 16, access: 'RW', value: 0xFFFF}),
        BitField.new({name: 'field1', pos: 16, size: 16, access: 'RO', value: 0x1111})
    ]

    h = {name: 'EXAMPLE',
         brief_descr: 'Example Register',
         pos: '0xF0',
         size: 32,
         fields: fields
    }

    h.extend RegFig
    t = h.reg_fig
    File.write(TEMPFILE, %(<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">#{t.root.to_s}))
  end

  include Mappable
  include CRR

  def test_load_iregs
    ab = doc.root.nodes[1].register_defs.address_block
    figures = ab.nodes.collect do |reg_def|
      if reg_def.name == 'register_def'
        reg_def.extend RegisterDef
        reg_def.reg_fig
      end
    end
    topic = topicize 'reg figs', *figures
    File.write(TEMPFILE, %(<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">#{topic.root.to_s}))
  end
end