Ipxact-Dita automates generation of Dita documentation from IPXACT register data. It uses ConDuxml transforms and defines custom methods to generate topics and register figures.

Features:
    - Generates guaranteed-valid Dita documentation 
    - Documentation generation can be customized with user-defined formatting using ConDuxml transform API (Ruby-based XML transforms)
    - Can easily incorporate vendor extensions of IPXACT by including modules defining their transform methods. 
    
From console:
    
    ruby bin/gen_dita <output_path> <ipxact_file> [<transform_file>] [options]
    
Options (TODO!)
-v  verbose mode
-pdf    output to PDF
-strict raise Exception if invalid Dita generated