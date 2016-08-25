# Copyright (c) 2016 Freescale Semiconductor Inc.
module Ipxact
  REGFIG_MAX_ROWBITS = 32

  module FigField
    include Dita

    @field

    def gen_field_entries(_field, _word_ct)
      @field = _field
      @word_ct = _word_ct

      entry = Element.new('entry')
      if width == 1
        entry[:colname] = col_start_index.to_s
      else
        entry[:namest] = (col_start_index).to_s
        entry[:nameend] = (col_end_index+1).to_s
      end
      entry[:valign] = 'middle'
      # entry[:outputclass] = 'rotate' if get_bit_width(name) > fig_bit_width # TODO fix this!!!
      entries = gen_field_access(entry)
      #entries << get_value_entries
    end

    private

    attr_reader :word_ct, :field

    def gen_field_access(entry)
      read = entry
      write = Element.new('entry')

      #TODO pull out into Duxml#dclone?
      entry.attributes.each do |k,v| write[k] = v end
      unless readable?
        read[:outputclass] = 'shaded'
      end
      if readable? == writable?
        read[:morerows] = '1'
        name = readable? ? gen_field_name(read) : 'Reserved'
        return [name]
      elsif !writable?
        gen_field_name(read)
        write[:outputclass] = 'shaded'
      elsif !readable?
        gen_field_name(write)
      else
        # do nothing
      end
      [read, write]
    end

    def readable?
      access = field.locate('ipxact:access').first
      access = source.access.text unless access
      access.include?('read')
    end

    def writable?
      access = field.locate('ipxact:access').first
      access = source.access.text unless access
      access.include?('write')
    end

    def get_value_entries
      v = []
      width.times do |i|
        b = bits[i] ? bits[i] : 0
        v << e = Element.new('entry')
        e << b.to_s
      end
      v
    end

    def gen_field_name(entry)
      if field_name.nil?
        entry << '-'
      else
        entry << Element.new('xref')
        entry.xref[:href] = get_xref
        entry.xref << field_name
      end
      entry
    end

    def field_name
      n = field.locate('ipxact:name')
      n.empty? ? nil : n.first.text
    end

    def get_xref
      "NOT_IMPLEMENTED" # TODO
    end

    def col_end_index
      ms_pos - word_ct * REGFIG_MAX_ROWBITS
    end

    def col_start_index
      ls_pos - word_ct * REGFIG_MAX_ROWBITS + 1
    end

    def width
      field.bitWidth.text.to_i
    end

    def ls_pos
      field.bitOffset.text.to_i
    end

    def ms_pos
      field.bitOffset.text.to_i + field.bitWidth.text.to_i - 1
    end
  end
end