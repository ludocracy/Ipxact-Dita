require_relative 'addressable'

module Ipxact
  module AddressBlock
    include Addressable

    # e.g. register descriptions
    def dita_map(args={})
      ditamap = super args
      ditamap << dita_descr
      RegisterDef().each do |reg_def|
        ditamap.link reg_def.dita_map
      end
    end

    def dita_descr
      self[:name] || brief_descr || long_descr
    end
  end
end