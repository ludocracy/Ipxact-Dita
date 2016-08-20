# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require 'con_dux'

module Addressable
  include ConDuxml
  include Tabulable
  include Mappable
  include Describable
  include Enumerable

  HEX_POSTFIX = 'h'
  HEX_PREFIX = '0x'
  HEX_MAG_DIGS = 4
  HEX_SEP = '_'

  DEC_POSTFIX = 'd'
  DEC_MAG_DIGS = 3
  DEC_SEP = ','

  BIN_POSTFIX = 'b'
  BIN_MAG_DIGS = 4
  BIN_SEP = ' '

  @base
  @position
  @word
  @parent
  @width
  @rows

  attr_reader :base, :position, :word, :parent, :width, :rows

  # 0 is lsb
  def set_addr!(args={})
    args = self if args.empty?
    w = args[:width] || 8
    @position = args[:offset] || args[:pos] || args[:position] || 0
    @bits = args[:bits] if args[:bits]
    @width = args[:width].to_i || args[:size].to_i || args[:range].to_i || rows.size
    @rows = @bits || args[:rows] || Array.new(width)
    @base = args[:base] || 0
    @word = args[:word] || w
  end

  def addressable?
    true
  end

  def get_range
    [position, position+width]
  end

  def absolute_addr
    base + position
  end

  # :post, :pre, :sep, :pad
  def to_hex(*opts)
    s = to_bin.to_i(2).to_s(16).upcase

    if opts.include?(:pad)
      s = add_padding(s, 4)
    end

    if opts.include?(:sep)
      s = add_separators(s, HEX_MAG_DIGS, HEX_SEP)
    end

    if opts.include?(:post)
      s+HEX_POSTFIX
    else
      HEX_PREFIX+s
    end
  end

  def to_bin(*opts)
    s = bits.collect do |b| b.to_s end.join

    if opts.include?(:pad)
      s = add_padding(s, 1)
    end

    if opts.include?(:sep)
      s = add_separators(s, BIN_MAG_DIGS, BIN_SEP)
      prefix = word
    end

    prefix ||= size

    if opts.include?(:post)
      s+BIN_POSTFIX
    elsif opts.include?(:pre)
      prefix.to_s+BIN_POSTFIX+s
    else
      s.strip
    end
  end

  def to_dec(*opts)
    s = to_bin.to_i(2).to_s

    if opts.include?(:pad)
      s = add_padding(s, 10)
    end

    if opts.include?(:sep)
      s = add_separators(s, DEC_MAG_DIGS, DEC_SEP)
    end

    if opts.include?(:post)
      s+DEC_POSTFIX
    else
      s
    end
  end


  def add_padding(str, div)
    padding = ''
    ((word-str.size*div)/div).times do padding << '0' end
    padding + str
  end

  def bits
    @bits ||= Array.new(width, 0)
  end

  def add_separators(str, mag, sep)
    expr = Regexp.new("\\w{#{mag}}")
    s = str.reverse.gsub(expr) do |m| m+sep end.reverse
    str.size%mag == 0 ? s[1..-1] : s
  end

  private :add_separators, :add_padding

  def each(&block)
    yield rows.each
  end

  def <=>(obj)
    absolute_addr <=> obj.absolute_addr
  end

  alias_method :to_i, :to_dec
  alias_method :size, :width
  alias_method :range, :width
  alias_method :index, :position
  alias_method :offset, :position

  private

  def get_bin_value
    av = reset_value.value
    self[:value].to_s(2).split(//)
  end
end