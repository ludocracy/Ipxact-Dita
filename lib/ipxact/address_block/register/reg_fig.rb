# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require 'ruby-dita'
require_relative '../access'
require_relative '../addressable'
require_relative 'fig_field'

module Ipxact
  module RegFig
    include Ipxact
    include Dita

    @word_ct

    attr_reader :word_ct

    def reg_fig(*args)
      set_addr!
      table = Element.new('table')
      table[:id] = object_id.to_s+"_regFigure"
      table[:frame] = 'all'
      table[:outputclass] = 'crr.regFigure regtable'
      @word_ct = 0
      input = nodes.select do |n| n.name.include? 'bit_field' end.reverse
      tgroup = nil
      until input.empty? do
        field = input.pop
        field.extend FigField
        index = row_relative_index field
        if tgroup.nil?
          tgroup = gen_tgroup
          table << tgroup
        end
        if index > REGFIG_MAX_ROWBITS
          table << tgroup = gen_tgroup
          input << field.split do |bit| bit end
          next
        else
          entries = field.gen_dita(word_ct)
          tgroup.tbody.nodes[1] << entries.first
          tgroup.tbody.nodes[2] << entries[1] if entries.size > 2
          tgroup.tbody.nodes[3] << entries.last if entries.last.is_a?(Array)
        end
        if field.position == 0 || index >= REGFIG_MAX_ROWBITS
          @word_ct += 1 unless field.position == 0
        end
      end
      table
    end

    def row_relative_index(field)
      p = field.position
      s = field.width
      w = word_ct
      r = REGFIG_MAX_ROWBITS
      field.position.to_i + field.width.to_i - word_ct*REGFIG_MAX_ROWBITS
    end

    def small?
      size < REGFIG_MAX_ROWBITS
    end

    def large?
      size > 64
    end

    def gen_tgroup
      tgroup = Element.new('tgroup')
      tgroup[:cols] ||= num_cols
      num_cols.times do |i|
        tgroup << colspec = Element.new('colspec')
        colspec[:align] = 'center'
        colspec[:colname] = i.to_s
      end

      tgroup << Element.new('tbody')
      %w(Bits R W Reset).each do |heading|
        tgroup.tbody << row = Element.new('row')
        row << Element.new('entry')
        row.entry << heading
      end

      set_bit_heading! tgroup.tbody.nodes.first
      tgroup
    end

    def set_bit_heading!(bit_row)
      fig_bit_width.times do |i|
        bit_row << e = Element.new('entry')
        e << (fig_bit_width - i-1).to_s
      end
    end

    def fig_bit_width
      REGFIG_MAX_ROWBITS > width ? width : REGFIG_MAX_ROWBITS
    end

    def num_cols
      fig_bit_width+1
    end
  end
end