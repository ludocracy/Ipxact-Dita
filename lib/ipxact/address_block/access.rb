# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require_relative '../../../ConDux/lib/con_dux/tabulable'
require_relative '../../../ConDux/lib/con_dux/describable'

module Ipxact
  module Access
    include ConDuxml
    include Tabulable
    include Describable

    @writable
    @readable

    @on_write
    @on_read

    @sticky

    attr_reader :on_write, :on_read, :sticky
    attr_accessor :writable, :readable

    def set_access
      if self[:access]
        sidsc2attrs! self[:access]
      else
        @writable, @readable, @on_write, @on_read, @sticky =
            self[:writable], self[:readable], self[:on_write], self[:on_read], self[:sticky]
      end
    end

    private

    def sidsc2attrs!(str)
      @readable = @writable = false
      str.split(//).each do |c|
        case c
          when 'R' then @readable = true
          when 'W' then @writable = true
          when '1' then @on_write = [clear: 1]
          else next
        end
      end
      s = ''
      s << 'R' if readable
      s << 'O' unless writable
      s << 'W' if writable
      s << 'O' unless readable
      s << '1C' if on_write == [clear: 1]
      s << 'U' if on_write.nil? && on_read.nil?
    end
  end
end