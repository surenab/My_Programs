#!/bin/tcsh -f
setenv script_path "/remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10"
unsetenv TCLLIBPATH
setenv TCLLIBPATH "$HOME/.synopsys_custom  /remote/cad-rep/emll/tools/CD_utilities /global/apps3/customdesigner_2013.03/auxx /global/apps3/customdesigner_2013.03/amd64/tcl/lib/tcl8.4 global/apps3/customdesigner_2013.03/amd64/tclpython/4.1-PY2.6.2"
wish $script_path/win.tcl $argv 
