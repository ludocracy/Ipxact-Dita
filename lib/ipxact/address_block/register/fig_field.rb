require_relative '../field'

module Ipxact
  REGFIG_MAX_ROWBITS = 32

  module FigField
    include Ipxact
    include Dita

    def gen_dita(_word_ct)
      @word_ct = _word_ct

      entry = Element.new('entry')
      if width == 1
        entry[:colname] = col_start_index.to_s
      else
        entry[:namest] = col_start_index.to_s
        entry[:nameend] = col_end_index.to_s
      end
      entry[:valign] = 'middle'
      # entry[:outputclass] = 'rotate' if get_bit_width(name) > fig_bit_width # TODO fix this!!!
      #set_docs
      set_access
      entries = gen_field_access entry
      entries << get_value_entries
    end

    def split(&block)
      yield bits.each
    end

    private

    attr_reader :word_ct

    def gen_field_access(entry)
      read = entry
      write = Element.new('entry')

      #TODO pull out into Duxml#dclone?
      entry.attributes.each do |k,v| write[k] = v end
      unless readable
        read[:outputclass] = 'shaded'
      end
      if readable == writable
        read[:morerows] = '1'
        name = readable ? gen_field_name(read) : 'Reserved'
        return [name]
      elsif !writable
        gen_field_name(read)
        write[:outputclass] = 'shaded'
      elsif !readable
        gen_field_name(write)
      elsif on_write.any? do |action| action.last == 1 end
        write << 'w1c'
      else
        # do nothing
      end
      [read, write]
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
      if name.nil?
        entry << '-'
      else
        entry << Element.new('xref')
        entry.xref[:href] = get_xref
        entry.xref << name
      end
      entry
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
  end
end