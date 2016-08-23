# Copyright (c) 2016 Freescale Semiconductor Inc.

require 'con_duxml'
require_relative 'ruby_ext/string'

module Addr
  include ConDuxml

  HEX_POSTFIX = 'h'
  HEX_PREFIX = '0x'
  HEX_MAG_DIGS = 4
  HEX_SEP = '_'

  DEC_POSTFIX = 'd'
  DEC_MAG_DIGS = 3
  DEC_SEP = ','

  BIN_POSTFIX = 'b'
  BIN_PREFIX = '0b'
  BIN_MAG_DIGS = 4
  BIN_SEP = ' '

  def bit_range
    [position, position+width]
  end

  # @param str [String] string representing number; can be in any base
  # @param opts [Hash] options are:
  #   :pre  => true # radix notation goes at beginning e.g. '0x000F' - default setting
  #   :post => true # radix notation goes at end e.g. 'Fh'
  #   :sep  => true # adds separator characters ('_' for hex) every 4 digits
  #   :pad  => [Fixnum] # given value indicates total digit width of number e.g. 4 => '000Fh'
  # @return [String] string representation of hex number
  def to_hex(str, opts={})
    s = str.to_dec.to_s(16).upcase
    s = add_padding(s, opts[:pad]) if opts[:pad]

    if opts[:sep]
      separator = opts[:sep] == true ? HEX_SEP : opts[:sep]
      s = add_separators(s, HEX_MAG_DIGS, separator)
    end

    if opts[:post]
      s += opts[:post] == true ? HEX_POSTFIX : opts[:post]
    end
    if opts[:pre]
      s = opts[:pre] == true ? HEX_PREFIX : opts[:pre] + s
    end
    s
  end

  # @param str [String] string representing number; can be in any base
  # @param opts [Hash] options are:
  #   :pre  => [boolean, String] # if String, notation, by default '0b'; hash key indicates position; if true,
  #   :post => [boolean, String] # radix notation goes at end e.g. '10b'; cannot contradict :pre
  #   :sep  => [boolean] # adds separator characters ('_' for hex) every 4 digits
  #   :pad  => [Fixnum] # given value indicates total digit width of number e.g. 4 => '000Fh'
  # @return [String] string representation of hex number
  def to_bin(str, opts={})
    s = str.to_dec.to_s(2)
    s = add_padding(s, 1) if opts[:pad]

    if opts[:sep]
      separator = opts[:sep] == true ? BIN_SEP : opts[:sep]
      s = add_separators(s, BIN_MAG_DIGS, separator)
    end

    if opts[:post]
      s += opts[:post] == true ? BIN_POSTFIX : opts[:post]
    end
    if opts[:pre]
      s = (opts[:pre] == true ? BIN_PREFIX : opts[:pre]) + s
    end
    s
  end

  # @param str [String] number as string; can be any base or notation
  # @return [String] formatted string
  def to_dec(str, opts={})
    s = str.to_dec.to_s
    s = add_padding(s, opts[:pad])     if opts[:pad]

    if opts[:sep]
      separator = opts[:sep] == true ? DEC_SEP : opts[:sep]
      s = add_separators(s, DEC_MAG_DIGS, separator)
    end

    if opts[:post]
      s += opts[:post] == true ? DEC_POSTFIX : opts[:post]
    end
    s
  end

  # @param str [String] number as string
  # @param places [Fixnum] number of digits for the whole number
  # @return [String] string representing number
  def add_padding(str, places)
    padding = ''
    (places - str.size).times do padding << '0' end
    padding + str
  end

  def add_separators(str, mag, sep)
    expr = Regexp.new("\\w{#{mag}}")
    s = str.reverse.gsub(expr) do |m| m+sep end.reverse
    str.size%mag == 0 ? s[1..-1] : s
  end

  private :add_separators, :add_padding

  private

  def get_bin_value
    av = reset_value.value
    self[:value].to_s(2).split(//)
  end
end