#!/usr/bin/env ruby

require 'con_duxml'
require_relative '../lib/ipxact'

include ConDuxml

# params: ip-xact file or formatting file, options

# @return dita file

HELP = %(Argument format: gen_dita.rb <output_path> <transform_file> <ipxact_file>)

output_path = ARGV.first
xform_path = ARGV[1]
ipxact_src = ARGV[2]

raise ArgumentError, HELP unless ARGV.size == 3
raise ArgumentError, "#{output_path} already exists! #{HELP}" if File.exists?(output_path)

save(output_path, transform(xform_path, ipxact_src))
