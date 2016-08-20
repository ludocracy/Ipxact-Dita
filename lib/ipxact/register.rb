# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require_relative 'field'
require_relative 'register/reg_fig'

module Ipxact
  module Register
    include Addressable
    include Access
    include Mappable
    include CRR::RegFig

    # making it output topic for now, not ditamap, for backward compatibility
    def dita_topic(args={})
      topic = Element.new('topic')
      topic << dita_descr
      #topic << dita_table(:address)
      topic << long_description.nodes
      topic << reg_fig
      #topic << dita_table(:fields)
    end

    def dita_descr
      "#{brief_description.text} (#{self[:name]})"
    end
  end
end

