# Copyright (c) 2016 Freescale Semiconductor Inc.
PREFIX_HEX = /^('h|0x)[0-9A-Fa-f]+$/
POSTFIX_HEX = /^[0-9A-Fa-f]+h$/
PREFIX_BIN = /^['0]b[01]+$/
POSTFIX_BIN = /^[0-1]+b$/
DECIMAL = /^[0-9]+$/
NAKED_HEX = /^[0-9A-Fa-f]+$/

class String
  # @return [Fixnum] returns base of number represented by this string e.g. '0x0F' => 16
  def base
    case self
      when PREFIX_BIN, POSTFIX_BIN
        2
      when PREFIX_HEX, POSTFIX_HEX, NAKED_HEX
        16
      when DECIMAL
        10
      else
        nil
    end
  end

  # @return [Fixnum] returns numerical value of string in decimal form
  def to_dec
    case self
      when PREFIX_BIN, PREFIX_HEX   then self[2..-1]
      when POSTFIX_HEX, POSTFIX_BIN then self[0..-2]
      when DECIMAL, NAKED_HEX       then self
      else
        raise Exception, "'#{self}' is not a numerical string!"
    end.to_i(base)
  end
end