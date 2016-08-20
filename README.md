Ipxact is a ruby interface for the Ipxact electronic component design XML format. XML elements are dynamically extended
by methods defined in this module as well as by the user to transform the data into other formats either for interchange
or publication.

Features:
    - Supports extensions of <ipxact:memoryMap> and its child nodes
    - Built-in extensions can generate Dita-formatted documentation 
    - Documentation generation can be customized with user-defined formatting using ConDuxml transform API (Ruby-based XML transforms)
    - Including Ipxact into user's project means user-defined transform methods automatically override
    
From console:
The Ipxact source file can contain links to a directives file to customize its output or the directives file can be provided as final argument
    
    ruby bin/gen_dita <output_path> <design_file> [<directives_file>] [options]
    
Options (TODO!)
-v  verbose mode
-pdf    output to PDF