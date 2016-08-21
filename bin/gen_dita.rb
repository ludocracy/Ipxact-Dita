require 'con_duxml'
require_relative '../lib/ipxact'

# params: ip-xact file or formatting file, options

# @return dita file

include ConDuxml

save('output.dita', transform(dita_xform_file, ipxact_file))
