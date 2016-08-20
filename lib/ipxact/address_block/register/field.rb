# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require_relative 'access'
require_relative 'addressable'

module Ipxact
  module Field
    include Access
    include Addressable

    def width
      self[:width].to_i
    end

    def ls_pos
      self[:position].to_i
    end

    def ms_pos
      ls_pos+width
    end
  end
end