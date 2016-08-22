# Copyright (c) 2016 Freescale Semiconductor Inc.
# All rights reserved. FIUO - Freescale Internal Use Only.

require 'con_duxml'
require_relative 'ruby_ext/string'

module Addr
  class << self
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
      s = to_dec(str).to_i(10).to_s(16).upcase

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

    # @param str [String] string representing number; can be in any base
    # @param opts [Hash] options are:
    #   :pre  => [boolean, String] # if String, notation, by default '0b'; hash key indicates position; if true,
    #   :post => [boolean, String] # radix notation goes at end e.g. '10b'; cannot contradict :pre
    #   :sep  => [boolean] # adds separator characters ('_' for hex) every 4 digits
    #   :pad  => [Fixnum] # given value indicates total digit width of number e.g. 4 => '000Fh'
    # @return [String] string representation of hex number
    def to_bin(str, opts={})
      s = to_dec(str).collect do |b| b.to_s end.join

      if opts[:pad]
        s = add_padding(s, 1)
      end

      if opts[:sep]
        s = add_separators(s, BIN_MAG_DIGS, BIN_SEP)
        prefix = word
      end

      prefix ||= size

      if opts[:post]
        s+BIN_POSTFIX
      elsif opts.include?(:pre)
        prefix.to_s+BIN_POSTFIX+s
      else
        s.strip
      end
    end

    def to_dec(str, opts={})
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

    # @param str [String] number as string
    # @param places [Fixnum] number of digits to add
    # @return [String] string representing number
    def add_padding(str, places)
      padding = ''
      places.times do padding << '0' end
      padding + str
    end

    def add_separators(str, mag, sep)
      expr = Regexp.new("\\w{#{mag}}")
      s = str.reverse.gsub(expr) do |m| m+sep end.reverse
      str.size%mag == 0 ? s[1..-1] : s
    end

    private :add_separators, :add_padding

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
end