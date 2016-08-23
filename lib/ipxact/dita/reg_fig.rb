# Copyright (c) 2016 Freescale Semiconductor Inc.

require 'con_duxml'
require 'ruby-dita'
require_relative 'fig_field'

module Ipxact
  include Dita

  # counts number of words of figure generated so far, where size of word is defined by REGFIG_MAX_ROWBITS
  @word_ct

  attr_reader :word_ct


  # @param src [Element] register definition from <ipxact:register/>
  # @param opts [Hash] no options currently supported TODO add options for hide access, hide reset value, etc.
  # @return [Element] visual rendering of register and its fields in Dita table form
  def reg_fig(src, opts={})
    table = Element.new('table')
    table[:id] = object_id.to_s+"_regFigure"
    table[:frame] = 'all'
    table[:outputclass] = 'crr.regFigure regtable'
    @word_ct = 0
    input = src.locate(src_ns + ':field')
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