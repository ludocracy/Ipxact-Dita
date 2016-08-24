# Copyright (c) 2016 Freescale Semiconductor Inc.
require_relative 'ipxact/dita/reg_fig'
require_relative 'ipxact/addr'

module Ipxact
  # @param node [Element] for now, just outputs one address from <ipxact:addressOffset/>
  # @return [Element] table with columns for register name and address offset
  def offset_table(node)
    table(%w())
  end

  def bit_range(node)
    'bit_range'
  end
end