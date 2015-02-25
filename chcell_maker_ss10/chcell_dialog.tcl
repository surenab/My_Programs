set netlist "*"
set chcell_name "*"
set orient "Horizontal"
set ini_f "./chcell_creator.ini"
set chcell_lib_name "chcell_lay"
set NetFileId ""
set TopCellNameId ""
set TopCellLibNameId "" 
set OrientId ""

if {[file exists $ini_f] == 1 } {
	set fd [open $ini_f "r"]
	set frd [read $fd]
	for {set i 0} {$i<[llength $frd]} {incr i} {
		if {[lindex $frd $i] == "netlist"} {
			set netlist  [lindex $frd [expr $i+1]]
		}
		if {[lindex $frd $i] == "chcell"} {
			set chcell_name  [lindex $frd [expr $i+1]]
		}
		if {[lindex $frd $i] == "orient"} {
			set orient  [lindex $frd [expr $i+1]]
		}
		if {[lindex $frd $i] == "chcell_lib_name"} {
			set chcell_lib_name  [lindex $frd [expr $i+1]]
		}
	}
	close $fd
}	



proc dial {} {
	global netlist chcell_name orient chcell_lib_name NetFileId TopCellNameId TopCellLibNameId OrientId
	set pCurCellViewId [de::getActiveEditorWindow]
	if {[db::isEmpty [gi::getDialogs chcelldial -parent $pCurCellViewId]] == 1 } {
		set myGUI [gi::createDialog  chcelldial -parent $pCurCellViewId -title "Chcell Creator Dialog" -execProc obrobot -showApply 0 -showHelp 0 ]
		
		
		
		set NetFileId [gi::createFileInput wNetFile \
                    -parent $myGUI \
                    -label "Netlist File:" \
                    -value $netlist \
                    -mode select ]
		   
		set TopCellNameId [gi::createTextInput wTopCellName \
                    -parent $myGUI \
                    -label "Top Chcell Name:" \
                    -value $chcell_name \
                    -readOnly 0 \
                    -valid 1]
		    
		    
		set TopCellLibNameId [gi::createTextInput wTopCellLibName \
                    -parent $myGUI \
                    -label "Top Chcell Library Name:" \
                    -value $chcell_lib_name \
                    -readOnly 0 \
                    -valid 1]
		    
		
		set OrientId  [gi::createMutexInput wOrient \
                    -parent $myGUI \
                    -label "Cell Orientation:" \
                    -enum { "Horizontal" "Vertical"} \
                    -toolTip "Horizontal means cells sorted horizontal, Vertical means cells sorted vertical" \
                    -viewType radio \
                    -value $orient]
                    
	}
	


}

proc obrobot {dialog} {
	global netlist chcell_name orient chcell_lib_name NetFileId TopCellNameId TopCellLibNameId OrientId
	
	set netlist [db::getAttr value -of $NetFileId]
	set chcell_name [db::getAttr value -of $TopCellNameId]
	set orient [db::getAttr value -of $OrientId]
	set chcell_lib_name [db::getAttr value -of $TopCellLibNameId]
	
	if {[file isfile $netlist] == 0} {
        	set errmsg "ERROR: Incorrect value specified in \"Source netlist\" field!\n Argument $ccvCheck(sNetFile) is not file."
        	errorMessage $errmsg
        	return -1
    	}
	
	set fd [open ./chcell_creator.ini "w"]
	puts  $fd "netlist  $netlist" 
	puts  $fd "chcell $chcell_name"
	puts  $fd "orient $orient"
	puts  $fd "chcell_lib_name $chcell_lib_name"
	close $fd
	
	main $netlist $chcell_name $chcell_lib_name $orient
}
