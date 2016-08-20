require_relative '../../lib/ipxact/address_block'
require 'test/unit'

REGSFILE = File.expand_path(File.dirname(__FILE__) + '/../../xml/iregs.xml')

class AddressBlockTest < Test::Unit::TestCase
  include Ipxact
  include Duxml

  def setup
    load REGSFILE
    @ab = doc.root.address_block
  end

  def test_dita_map
    # TODO turn demo from few weeks ago into proper code and tests
    # have transform method get split/merge args from attributes of instance containing multiple instances
    # use to merge two almost identical instances of same block and produce single memory map
    # topicize with figures to create pseudo block guide
  end
end