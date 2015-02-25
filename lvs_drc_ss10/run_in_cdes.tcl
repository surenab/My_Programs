
set script_path "/remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10"
set wka [pwd]
#===============================================================================
# Procedure creates TX menu and action items for Custom Designer layout editor
#===============================================================================
proc CDCreateLayoutPulldownMenu_Checks {} {
        set TMenu [gi::createMenu TX -title RUN_DRC_LVS]
	set TMenu_DRC_ICV [gi::createMenu TX_DRC -title RUN_DRC_ICV]
	set TMenu_DRC_CAL [gi::createMenu TX_LVS -title RUN_DRC_CAL]
        	
		gi::createAction I_DRCSVT  -command ICV_DRCSVT 	-title "ICV_SVT"
		gi::createAction I_DRCLVT  -command ICV_DRCLVT 	-title "ICV_LVT"
		gi::createAction I_DRCULVT -command ICV_DRCULVT -title "ICV_ULVT"
		gi::createAction C_DRCSVT  -command CAL_DRCSVT 	-title "CALIBRE_SVT"
		gi::createAction C_DRCLVT  -command CAL_DRCLVT 	-title "CALIBRE_LVT"
		gi::createAction C_DRCULVT -command CAL_DRCULVT -title "CALIBRE_ULVT"
		
		
		
		
		gi::createAction 	RUNERC 	-command RUNERC 	-title "RUN_ERC" 
		gi::createAction 	LVS 	-command LVS 		-title "RUN_LVS"
        	gi::createAction 	aboutx 	-command ShowMyAbout  	-title "About ..."  
		
		
		
		
      gi::addActions [list I_DRCSVT I_DRCLVT I_DRCULVT ] -to $TMenu_DRC_ICV
      gi::addActions [list C_DRCSVT C_DRCLVT C_DRCULVT ] -to $TMenu_DRC_CAL
      gi::createAction ICV_DRC -menu $TMenu_DRC_ICV -title "ICV DRC"
      gi::createAction CAL_DRC -menu $TMenu_DRC_CAL -title "Calibre DRC"	            
      gi::addActions [list LVS  RUNERC ICV_DRC CAL_DRC] -to $TMenu
      #gi::addMenu -to $TMenu
      return $TMenu
}
#===============================================================================
# The procedure shows ABOUT information for the scripts
#===============================================================================
proc ShowMyAbout {} {
      set aboutDlg [gi::createDialog wAbout \
                    -title "About VIRAGE PDK" \
                    -showApply 0 \
                    -showHelp 0]

      set aboutLbl [gi::createLabel lAbout \
                    -parent $aboutDlg \
                    -label "DRC_LVS_TOOL V.1.0V , C.2013-2014 Synopsys \
\nSend comments/suggestions to: surenab@synopsys.com. \
\n\nDRC_LVS_TOOL V.1.0V , C.2013-2014 Synopsys \
\nUnder Construction\n\n"]
}
#===============================================================================

#;;;;;;;;;;;;;;;;;;;;;;;;;;   M A I N  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#===============================================================================
set TMenu [CDCreateLayoutPulldownMenu_Checks]
gi::addMenu $TMenu -to [gi::getWindowTypes leLayout]
#===============================================================================

##########################   E N D   #############################

#===============================================================================
#==================================================================================================================================================
#==================================================================================================================================================
#==================================================================================================================================================
#==================================================================================================================================================
set winType_l [gi::getWindowTypes leLayout]
set toolbar_l [gi::getToolbars leDRCToolbar -from $winType_l]
set vdk_l ""
db::createPref loctogrd -value 0 


set locgrd 0
proc execute {args} {
    	set pb [ gi::createBooleanInput locorgrdl -label "LOCAL RUN" -prefName loctogrd]
    	return $pb
}
set act_l [gi::createAction lorg -widgetProc execute -label LorG -prompt Change -toolTip "Change VDK_POOL,IF checked VDK is LOCAL" ]
gi::addActions "lorg" -to $toolbar_l 
#==================================================================================================================================================
#==================================================================================================================================================
#==================================================================================================================================================
#==================================================================================================================================================





proc getcellname {} {
	if {![file isdirectory ./drc_lvs/]} {exec mkdir ./drc_lvs/}
	set pCurCellViewId [de::getActiveEditorWindow]
	set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
	set libname [db::getAttr libName -of $inst]
	puts "Lib Name is $libname :"
	set cellname [db::getAttr name -of $inst]
	puts "Cell Name is $cellname :"
	set fd [open ./drc_lvs/cell_drc "w"]
	puts -nonewline $fd $libname 
	puts -nonewline $fd "   "
	puts -nonewline $fd $cellname
	close $fd
	return $cellname
	
}	



proc streamstatus {xtjob} {
	set sstatus [db::getAttr "status" -of $xtjob]
	if { $sstatus == "FINISHED" } {
		puts "Job is Finishing,And Openning VUE"
		set cellname [getcellname]
		xt::createJob drc_ulvt -cmdLine "icv_vue -load ./drc_lvs/cells/icv_drc/$cellname/$cellname.vue  -lay CDesignerLE" -type dp -runDesc "DRC"
	} elseif { $sstatus == "FAILED" } { 
		xt::openTextViewer -files ./drc_lvs/cover.log 
	}
}
proc streamstatus_calibre {xtjob} {
	global wka
	set sstatus [db::getAttr "status" -of $xtjob]
	if { $sstatus == "FINISHED" } {
		puts "Job is Finishing,And Openning VUE"
		set cellname [getcellname]
		#xt::createJob drc_ulvt -cmdLine "icv_vue -load ./drc_lvs/cells/calibre_drc/$cellname/DRC.gds.ascii  -lay CDesignerLE" -type dp -runDesc "DRC"
		uev $wka/drc_lvs/cells/calibre_drc/$cellname/DRC.gds.ascii calibre drc
	} elseif { $sstatus == "FAILED" } { 
		xt::openTextViewer -files ./drc_lvs/cover.log 
	}
}
proc streamstatuserc {xtjob} {
	set sstatus [db::getAttr "status" -of $xtjob]
	if { $sstatus == "FINISHED" } {
		puts "Job is Finishing,And Openning VUE"
		set cellname [getcellname]
		xt::createJob drc_ulvt -cmdLine "icv_vue -load ./drc_lvs/cells/icv_erc/$cellname/$cellname.vue  -lay CDesignerLE" -type dp -runDesc "DRC"
	} elseif { $sstatus == "FAILED" } { 
		xt::openTextViewer -files ./drc_lvs/cover.log 
	}
}



proc printInsts {lib cell view} {
    	set clist [list]
    	set master [oa::DesignOpen $lib $cell $view [oa::ViewTypeFind maskLayout] r]
    	set top [oa::getTopBlock $master]
    	set count 0
    	set insts [oa::getInsts $top]
    	while {[set inst [oa::getNext $insts]] != ""} {
	 set name [oa::getCellName $inst]
	 lappend clist $name
	 set count [ expr {$count + 1}]
    	}
    	puts "$count insts"
    	return $clist
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#////////Verification With ICV TOOL/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
proc ICV_DRCSVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	puts "vdkpool = $vdkpool"
	set cellname [getcellname]
	xt::createJob run_drc_svt -cmdLine "gnome-terminal -e \"$script_path/run_drc.csh svt $vdkpool  -t DRC_SVT\"" -type native -runDesc "RUNIMG DRC SVT" -exitProc streamstatus
	#exec $script_path/run_drc.csh svt $vdkpool
}
proc ICV_DRCLVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	set cellname [getcellname]
	xt::createJob run_drc_lvt -cmdLine "gnome-terminal -e \"$script_path/run_drc.csh lvt $vdkpool  -t DRC_LVT\"" -type batch -runDesc "RUNIMG DRC LVT" -exitProc streamstatus
}
proc ICV_DRCULVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	set cellname [getcellname]
	xt::createJob run_drc_ulvt -cmdLine "gnome-terminal -e \"$script_path/run_drc.csh ulvt $vdkpool  -t DRC_ULVT\"" -type batch -runDesc "RUNIMG DRC ULVT" -exitProc streamstatus 
}
#////////Verification With Calibre TOOL///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc CAL_DRCSVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	set cellname [getcellname]
	xt::createJob run_drc_svt -cmdLine "gnome-terminal -e \"$script_path/run_drc_calibre.csh svt $vdkpool  -t DRC_SVT\"" -type batch -runDesc "RUNIMG DRC SVT" -exitProc streamstatus_calibre
}
proc CAL_DRCLVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	set cellname [getcellname]
	xt::createJob run_drc_lvt -cmdLine "gnome-terminal -e \"$script_path/run_drc_calibre.csh lvt $vdkpool  -t DRC_LVT\"" -type batch -runDesc "RUNIMG DRC LVT" -exitProc streamstatus_calibre
}
proc CAL_DRCULVT {} {
	global script_path
	
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	set cellname [getcellname]
	xt::createJob run_drc_ulvt -cmdLine "gnome-terminal -e \"$script_path/run_drc_calibre.csh ulvt $vdkpool  -t DRC_ULVT\"" -type batch -runDesc "RUNIMG DRC ULVT" -exitProc streamstatus_calibre 
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#//////////////////////////////END of DRC Verifications////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	










proc RUNERC {} {
	global script_path
	set vdk [db::getPrefValue loctogrd]
	if {$vdk} {
		set vdkpool "LOCAL"
	} else {
		set vdkpool "GRD"
	} 
	
	set cellname [getcellname]
	
	xt::createJob run_erc -cmdLine "gnome-terminal -e \"$script_path/run_erc.csh   $vdkpool  -t ERC\"" -type batch -runDesc "RUNIMG ERC" -exitProc streamstatuserc 
	#xt::createJob drc_ulvt -cmdLine "icv_vue -load ./drc_lvs/cells/icv_drc/$cellname/$cellname.vue  -lay CDesignerLE" -type dp -runDesc "DRC"
}

proc LVS {} {
	global script_path	
	if {![file isdirectory ./drc_lvs/]} {exec mkdir ./drc_lvs/}
	set pCurCellViewId [de::getActiveEditorWindow]
	set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
	set libname [db::getAttr libName -of $inst]
	puts "Lib Name is $libname :"
	set cellname [db::getAttr name -of $inst]
	puts "Cell Name is $cellname :"		
	set fd [open ./drc_lvs/cell_drc "w"]
	puts -nonewline $fd $libname 
	puts -nonewline $fd "   "
	puts -nonewline $fd $cellname
	close $fd		
	set cell_list [printInsts $libname $cellname layout]
	#puts "cell_list1 = $cell_list"
	lappend cell_list $cellname
	#puts "cell_list2 = $cell_list \n"	
	set fd [open ./drc_lvs/all_cell_list "w"]
	foreach cn $cell_list {
		puts $fd $cn
	}
	close $fd
	#puts "cell_list2.5 = $cell_list \n"	
	set cell_list [lsort -unique $cell_list]
	puts "cell_list = $cell_list"
	#xt::createJob run_lvs_window -cmdLine "gnome-terminal --geometry 1x1 --maximize --zoom 0.01 --hide-menubar -e \"wish $script_path/win.tcl $cell_list \" & " -type native  -runDesc "RUNIMG LVS WINDOW"
	
	xt::createJob run_lvs_window -cmdLine "gnome-terminal --geometry 1x1 --maximize --zoom 0.01 --hide-menubar -e \"$script_path/run_win.csh $cell_list \" & " -type native  -runDesc "RUNIMG LVS WINDOW"
	#xt::createJob run_lvs_window -cmdLine "$script_path/run_win.csh $cell_list" -type batch -runDesc "RUNING LVS WINDOW"
	#exec wish $script_path/win.tcl $cell_list &
	#exec $script_path/run_win.csh $cell_list &
	
	puts "END"
}


proc get_params_run_lvs {} {
	global script_path
	set ini_file "./drc_lvs/drc_lvs.ini"
	if {[file exists $ini_file] == 1 } {
		set fd [open $ini_file "r"]
		set frd [read $fd]
		for {set i 0} {$i<[llength $frd]} {incr i} {
			if {[lindex $frd $i] == "NetPathsvt"} {
				set NetPathsvt  [lindex $frd [expr $i+1]]
			}
			if {[lindex $frd $i] == "NetPathlvt"} {
				set NetPathlvt  [lindex $frd [expr $i+1]]
			}
			if {[lindex $frd $i] == "NetPathulvt"} {
				set NetPathulvt  [lindex $frd [expr $i+1]]
			}
			if {[lindex $frd $i] == "svt"} {
				set svt  [lindex $frd [expr $i+1]]
			}
			if {[lindex $frd $i] == "lvt"} {
				set lvt  [lindex $frd [expr $i+1]]
			}
			if {[lindex $frd $i] == "ulvt"} {
				set ulvt  [lindex $frd [expr $i+1]]
			}
		}
		close $fd
	}
	if {$svt == 1} {	
		xt::createJob run_lvs_svt -cmdLine  "gnome-terminal -e \"$script_path/run_lvs.csh \"svt\" $NetPathsvt -noVNC -t LVS_svt_Running\"" -type batch -runDesc "RUNIMG LVS"
	}
	if {$lvt == 1} {	
		xt::createJob run_lvs_svt -cmdLine  "gnome-terminal -e \"$script_path/run_lvs.csh \"lvt\" $NetPathsvt -noVNC -t LVS_lvt_Running\"" -type batch -runDesc "RUNIMG LVS"
	}
	if {$ulvt == 1} {	
		xt::createJob run_lvs_svt -cmdLine  "gnome-terminal -e \"$script_path/run_lvs.csh \"ulvt\" $NetPathsvt -noVNC -t LVS_ulvt_Running\"" -type batch -runDesc "RUNIMG LVS"
	}
}

set winType [gi::getWindowTypes leLayout]
set toolbar [gi::getToolbars leDRCToolbar -from $winType]

gi::createAction Run_LVS -title RUN_LVS -history true -toolTip "Run Lvs by latest parameters" -command {get_params_run_lvs}
gi::createAction DRC_SVT -title RUN_DRC -history true -toolTip "Run Drc Svt" -command {DRCSVT}
gi::createAction DRC_LVT -title DRC_LVT -history true -toolTip "Run Drc Lvt" -command {DRCLVT}
gi::createAction DRC_ULVT -title DRC_ULVT -history true -toolTip "Run Drc Ulvt" -command {DRCULVT}
gi::addActions Run_LVS  -to $toolbar
gi::addActions DRC_SVT  -to $toolbar
#gi::addActions DRC_LVT  -to $toolbar
#gi::addActions DRC_ULVT  -to $toolbar
gi::addActions RUNERC  -to $toolbar


gi::createBinding -event "Alt-Shift-s" -command {DRCSVT}
gi::createBinding -event "Alt-Shift-l" -command {DRCLVT}
gi::createBinding -event "Alt-Shift-u" -command {DRCULVT}


#===============================================================================

##########################   E N D   #############################

#===============================================================================
		
