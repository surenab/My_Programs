#!/bin/wish -f
#!/bin/tcsh -f
set check_tool "icv"
set text [list]
set cell_list {hd1p_giom4x1 hd1p_sacm4x1 hd1p_bcen hd1p_gcen hd1p_lcen}
set vt_list [list]
set lvs_cell_list [list]
set check 0
set check_cell normal ;# normal or active or disabled
set st 0
set statelog 0
set cell_list $argv
set colorx "royal blue"
set ini_file "./drc_lvs/drc_lvs.ini"
set fd [open /u/arpih/bin/from_suren/lvs_drc_ss10/sourceme_lvsdrc "r"]
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
	}
close $fd



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
	}
	close $fd
}	


set oldNetPath "/slowfs/am04dwt2p013/projects/layout/ts16/hd1p_hd6t/users/proj_files/netlist/hd1p_chcells_hd6t_28jan.cir.nodummy_svt_lvs"
set icv_lvs_script "/remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/run_lvs.csh"
set calibre_lvs_script "/remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/run_lvs_calibre.csh"
set drc_script "/remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/run_drc.csh"
#GET CELL NAMES ###########################
set types {
		  {{All Files}        *                  }
                  {{Netlist Files}    {.cir}             }
                  {{TCL Scripts}      {.tcl}             }
		  {{GDS Files}        {.gds}             }
          }
set x [llength $cell_list]
if ($x==0) {
		set x 5
}
set scrollsize [expr 27*$x+60]
set sclist [list 0 0 0 $scrollsize]
#END CELL NAMES FUNCTION#################################################################
wm title . LVS
#wm geometry . 600x300+200+100 
wm geometry . 1200x500+200+100 
wm resizable . 1 1
frame .framemenu -borderwidth 2 -relief ridge -width 40 -height 20 -bg $colorx
menubutton .framemenu.mb -text "File" -menu .framemenu.mb.menu -activebackground brown -fg $colorx -relief groove
set m [menu .framemenu.mb.menu -tearoff 1]
$m add cascade -label "Choose Verification" -menu $m.sub1
set m0 [menu $m.sub1 -tearoff 0]
$m0 add command -label LVS -command LVS_WINDOW
$m0 add separator
$m0 add command -label DRC -command DRC_WINDOW
$m add command -label Exit -command exit
#//////////////////////////////////////
menubutton .framemenu.mb2 -text "CHECKS" -menu .framemenu.mb2.menu -activebackground brown -fg $colorx -relief groove
set m2 [menu .framemenu.mb2.menu -tearoff 1]
$m2 add command -label "Run LVS" -command LVSNOCLOSE
$m2 add command -label "Run DRC" -command RUN_DRC
$m2 add separator


menubutton .framemenu.mb3 -text "Help" -menu .framemenu.mb3.menu -activebackground brown -fg $colorx -relief groove
set m3 [menu .framemenu.mb3.menu -tearoff 1]
$m3 add command -label "DRC_LVS_TOOL Help" -command HELP
$m3 add command -label "About" -command ABOUT

grid .framemenu.mb -row 0 -column 0
grid .framemenu.mb2 -row 0 -column 1
grid .framemenu.mb3 -row 0 -column 2
pack .framemenu -side top -anchor w
#Creating checkbuttons for cells and scrollbar#####################################################################################
#
#
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    frame .frame -borderwidth 2 -relief ridge -width 20 -height 20 -bg $colorx
	scrollbar .frame.scroll  -command ".frame.canvas yview " -relief ridge -orient vertical -width 20 -bg blue 
	canvas .frame.canvas  -scrollregion $sclist -relief raised  -confine true  -width 270   -yscrollcommand ".frame.scroll set"  -yscrollincrement 25 -xscrollincrement 25
	
    pack append .frame .frame.scroll    {left frame center filly}  .frame.canvas    {left frame center filly} 
    pack append . .frame   {left frame center filly} 
	label .frame.canvas.lput -text "Choose cells for running Lvs Verification\nOr check \"All CELLS\" for lvs check all cells" -relief ridge
	.frame.canvas create window 1 25 -anchor w -window .frame.canvas.lput
	for {set i 0} {$i<[llength $cell_list]} {incr i} {
         checkbutton .frame.canvas.button$i  -relief raised  -text "[lindex $cell_list $i]" -height 1 -width 25 -state $check_cell -variable cellcount($i) -onvalue 1 -offvalue 0 -fg $colorx
         set id [.frame.canvas create window [expr $i%2] [expr ($i+4)*25] -anchor w -window .frame.canvas.button$i ]
		
	}
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#Creating button for control#############################################################
#
#
#////////////////////////////////////////////////////////////////////////////////////////	
	frame .framebuttons -borderwidth 2 -relief ridge -width 40 -height 20 
	checkbutton .framebuttons.grd  -relief raised  -text "LOCAL"  -variable grd_or_local -height 1 -width 12 -fg $colorx
	button .framebuttons.runlvs -relief raised  -text "Run LVS" -command LVSRUN -fg $colorx
	button .framebuttons.close -relief raised  -text "Close" -command exit -fg $colorx
	button .framebuttons.applay -relief raised  -text "Apply" -command LVSNOCLOSE -fg $colorx
	set lshow [button .framebuttons.show -relief raised  -text "Show Logs" -command SHOWLOG -fg $colorx]
	grid .framebuttons.runlvs -row 2 -column 0
	grid .framebuttons.applay -row 2 -column 1
	grid .framebuttons.show -row 2 -column 2
	grid .framebuttons.close -row 2 -column 3
	grid .framebuttons.grd -row 2 -column 4
	pack .framebuttons -side bottom
#////////////////////////////////////////////////////////////////////////////////////////
#Creating VT checkbuttons
#////////////////////////////////////////////////////////////////////////////////////////
	frame .framevt -borderwidth 4 -relief ridge -width 400 -height 200 -bg $colorx
	set i 0
	foreach vt {svt lvt ulvt } {
		checkbutton .framevt.$vt  -relief raised  -text [string toupper $vt]  -variable my($vt) -height 1 -width 6 -fg $colorx
		grid .framevt.$vt -row 0 -column $i
		incr i
	}
	pack .framevt -side top 
	#////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	frame .framevtnet -borderwidth 4 -relief ridge -width 400 -height 200  
	label .framevtnet.netpathen -width 100  -relief sunken -textvariable NetPathsvt  -text "*.cir"      -bg white -relief sunken -width 95 -height 2 -anchor w -font {times 12 bold} -wraplength 750 
	button .framevtnet.netpath -text "SVT  Netlist" -command [namespace code {set NetPathsvt [tk_getOpenFile -filetypes $types -initialdir $NetPathsvt  -initialfile $oldNetPath]}] -height 2 -fg $colorx
	grid .framevtnet.netpath -row 0 -column 0
	grid .framevtnet.netpathen -row 0 -column 1
	label .framevtnet.netpathen2 -width 100  -relief sunken -textvariable NetPathlvt  -text "*.cir"      -bg white -relief sunken -width 95 -height 2 -anchor w -font {times 12 bold} -wraplength 750
	button .framevtnet.netpath2 -text "LVT  Netlist" -command [namespace code {set NetPathlvt [tk_getOpenFile -filetypes $types -initialdir $NetPathlvt  -initialfile $oldNetPath]}] -height 2 -fg $colorx
	grid .framevtnet.netpath2 -row 1 -column 0
	grid .framevtnet.netpathen2 -row 1 -column 1
	label .framevtnet.netpathen3 -width 100  -relief sunken -textvariable NetPathulvt  -text "*.cir"      -bg white -relief sunken -width 95 -height 2 -anchor w -font {times 12 bold} -wraplength 750
	button .framevtnet.netpath3 -text "ULVT Netlist" -command [namespace code {set NetPathulvt [tk_getOpenFile -filetypes $types -initialdir $NetPathulvt  -initialfile $oldNetPath]}] -height 2 -fg $colorx
	grid .framevtnet.netpath3 -row 2 -column 0
	grid .framevtnet.netpathen3 -row 2 -column 1
	pack .framevtnet -side top
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	set logx [frame .framelog -borderwidth 4 -relief ridge -width 400 -height 100  -bg $colorx]
	label  .framelog.title -width 100  -relief sunken   -text "Logs"      -relief flat -width 170 -height 1 -anchor w -font {times 8 italic} 
	set logxout [text .framelog.log  -selectbackground blue -selectforeground brown -width 116 -height 14 -borderwidth 2 -relief raised -setgrid false -bg grey -fg brown -font {times 10 bold} -yscrollcommand {.framelog.scrolly set} -xscrollcommand {.framelog.scrollx set}]
	scrollbar .framelog.scrolly -command  {.framelog.log yview} -orient vertical -width 20
	scrollbar .framelog.scrollx -command  {.framelog.log xview} -orient horizontal -width 20
	grid .framelog.title
	grid .framelog.log .framelog.scrolly   -sticky news
	grid .framelog.scrollx  -sticky ew
#	Creating LOG text viewer
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	frame .t -width 50 -height 100
	set log [text .t.log -width 50 -height 100 -borderwidth 2 -relief raised  ] 
	pack .t.log -side left -fill both   -expand true 
	#pack .t -side top -fill both  -expand true 
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#
#	Creating All cells check BUTTON
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	set allbut [button .frame.canvas.all  -relief raised  -text "ALL CELLS CHECK" -command changestatus -height 1 -width 20 ]
    .frame.canvas create window 1 75 -anchor w -window .frame.canvas.all
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#
#	Creating changestatus procedure for ALL_CELL_CHECK button
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
frame .frameop -borderwidth 4 -relief ridge -width 400 -height 200 -bg $colorx
checkbutton .frameop.html  -relief raised  -text "Open HTML"  -variable myhtml -height 1 -width 12 -fg $colorx
checkbutton .frameop.vue   -relief raised  -text "Open VUE"   -variable myvue  -height 1 -width 12 -fg $colorx
grid .frameop.html -row 0 -column 0
grid .frameop.vue -row 0 -column 1
pack .frameop -side top 
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
frame .frametool -borderwidth 4 -relief ridge -width 400 -height 200 -bg $colorx
#checkbutton .frametool.icv  	 -relief raised  -text "ICV"  	   -variable icv_check 	    -height 1 -width 12 -fg $colorx
#checkbutton .frametool.calibre   -relief raised  -text "Calibre"   -variable calibre_check  -height 1 -width 12 -fg $colorx
radiobutton .frametool.icv  	 -relief raised  -text "ICV"  	   -variable check_tool  -value "icv" 	  -height 1 -width 12 -fg $colorx 
radiobutton .frametool.calibre   -relief raised  -text "Calibre"   -variable check_tool  -value "calibre" -height 1 -width 12 -fg $colorx
#label .frametool.xcv -text "es" -textvariable $check_tool
#grid .frametool.xcv -row 2 -column 0
grid .frametool.icv -row 0 -column 0
grid .frametool.calibre -row 0 -column 1
pack .frametool -side top 

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




		
	proc changestatus {} {
		global st cellcount  cell_count  text log cell_list allbut
		set text [list]
		if (!$st) {
			for {set i 0} {$i<[llength $cell_list]} {incr i} {
				set cellcount($i) 1
				lappend text "Added for lvs check [lindex $cell_list $i] cell \n"
			} 
			$allbut configure -text "ALL CELLS UNCHECK"
			set st [expr !$st]
		} else {
			for {set i 0} {$i<[llength $cell_list]} {incr i} {
				set cellcount($i) 0
				lappend text "Removed for lvs check [lindex $cell_list $i] cell\n"
			}
			$allbut configure -text "ALL CELLS CHECK"
			set st [expr !$st]
		}
		
	}
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#
#	Run LVS procedure
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	proc LVSRUN {} {
		global my cellcount cell_list vt_list lvs_cell_list log text NetPathsvt NetPathlvt NetPathulvt icv_lvs_script calibre_lvs_script myhtml myvue check_tool grd_or_local
		if ([string equal $check_tool  "icv"]) {
			set new_lvs_script $icv_lvs_script
		} else {
			set new_lvs_script $calibre_lvs_script
		}
		
		
		set lvs_cell_list [list]
		set vt_list [list]
		foreach vt {svt lvt ulvt } {
			if (!($my($vt)==0)) {
				lappend vt_list $vt
			}
		}
		if ($grd_or_local) {
			set grd_or_localx "LOCAL"
		} else {
			set grd_or_localx "GRD"
		}
		
		
		set fini [open ./drc_lvs/drc_lvs.ini "w"]
		puts $fini "The file is auto ganarated drc_lvs tool for saveing local parameters"
	
		puts $fini "NetPathsvt  $NetPathsvt"
		puts $fini "NetPathlvt  $NetPathlvt"
		puts $fini "NetPathulvt $NetPathulvt"
	
		foreach vt {svt lvt ulvt } {
			if (!($my($vt)==0)) {
				puts $fini "$vt 1"
			} else {
				puts $fini "$vt 0"
			}
		}
		puts $fini "End of File"
	
		close $fini
		
		
		
		for {set i 0} {$i<[llength $cell_list]} {incr i} {
			if (!($cellcount($i)==0)) {
				lappend lvs_cell_list [lindex $cell_list $i]
			}
		}
		
	
		exec rm -rf ./drc_lvs/cell_list
		set fileId [open ./drc_lvs/cell_list "w"]
		for {set i 0} {$i<[llength $lvs_cell_list]} {incr i} {
			puts $fileId [lindex $lvs_cell_list $i]
		}
		close $fileId
		
		#wm withdraw .
		
		
		if ([llength $lvs_cell_list]>0) {
			foreach vtt $vt_list {
				if ([string equal $vtt  "svt"]) {
						if ([string equal $NetPathsvt  ""]) {
							tk_messageBox -message "Choose svt netlist Please!"
						} else {
							#exec exportStream -logFile exportStream_1.log -lib $libName -libDefFile ./lib.defs -gds ./drc_lvs/gds/gds.gds -blockageType 0 -cell $exportcellName -donutNumSides 64 -ellipseNumSides 64 -hierDepth 13 -layerMap $vtt -noOutputBlockages -rectAsBoundary -view layout -text cdba -ver 3 -toLowerLabel > ex.log

							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathsvt $myhtml $myvue  $grd_or_localx -noVNC" -t "LVS_SVT"} ffff]} { 
								puts ""
							}
						}
				}
				if ([string equal $vtt  "lvt"]) {
						if ([string equal $NetPathlvt  ""]) {
							tk_messageBox -message "Choose lvt netlist Please!"
						} else {
							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathlvt $myhtml $myvue  $grd_or_localx -noVNC" -t "LVS_LVT"} ffff]} {
								puts ""
							}
						}
				}
				if ([string equal $vtt  "ulvt"]) {
						if ([string equal $NetPathulvt  ""]) {
							tk_messageBox -message "Choose ulvt netlist Please!"
						} else {
						
							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathulvt $myhtml $myvue  $grd_or_localx -noVNC" -t "LVS_ULVT"} ffff]} { 
								puts ""
							}
						}
				}	
			}
			exit
		} else {
			tk_messageBox -message "Choose cell Please!"
		}
	}		
	
		
proc LVSNOCLOSE {} {
		global my cellcount cell_list vt_list lvs_cell_list log text NetPathsvt NetPathlvt NetPathulvt icv_lvs_script calibre_lvs_script myhtml myvue check_tool grd_or_local
		
		if ([string equal $check_tool  "icv"]) {
			set new_lvs_script $icv_lvs_script
		} else {
			set new_lvs_script $calibre_lvs_script
		}
		if ($grd_or_local) {
			set grd_or_localx "LOCAL"
		} else {
			set grd_or_localx "GRD"
		}
		
		set lvs_cell_list [list]
		set vt_list [list]
		foreach vt {svt lvt ulvt } {
			if (!($my($vt)==0)) {
				lappend vt_list $vt
			}
		}
		
		set fini [open ./drc_lvs/drc_lvs.ini "w"]
		puts $fini "The file is auto ganarated drc_lvs tool for saveing local parameters"
	
		puts $fini "NetPathsvt  $NetPathsvt"
		puts $fini "NetPathlvt  $NetPathlvt"
		puts $fini "NetPathulvt $NetPathulvt"
	
		foreach vt {svt lvt ulvt } {
			if (!($my($vt)==0)) {
				puts $fini "$vt 1"
			} else {
				puts $fini "$vt 0"
			}
		}
		puts $fini "End of File"
	
		close $fini
		
		
		
		
		for {set i 0} {$i<[llength $cell_list]} {incr i} {
			if (!($cellcount($i)==0)) {
				lappend lvs_cell_list [lindex $cell_list $i]
			}
		}
		exec rm -rf ./drc_lvs/cell_list
		set fileId [open ./drc_lvs/cell_list "w"]
		for {set i 0} {$i<[llength $lvs_cell_list]} {incr i} {
			puts $fileId [lindex $lvs_cell_list $i]
		}
		close $fileId
		if ([llength $lvs_cell_list]>0) {
			foreach vtt $vt_list {
				if ([string equal $vtt  "svt"]) {
						if ([string equal $NetPathsvt  ""]) {
							tk_messageBox -message "Choose svt netlist Please!"
						} else {
							#exec exportStream -logFile exportStream_1.log -lib $libName -libDefFile ./lib.defs -gds ./drc_lvs/gds/gds.gds -blockageType 0 -cell $exportcellName -donutNumSides 64 -ellipseNumSides 64 -hierDepth 13 -layerMap $vtt -noOutputBlockages -rectAsBoundary -view layout -text cdba -ver 3 -toLowerLabel > ex.log

							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathsvt $myhtml $myvue  $grd_or_localx -noVNC " -t "LVS_SVT"} ffff]} { 
								
								puts ""
							}
						}
				}
				if ([string equal $vtt  "lvt"]) {
						if ([string equal $NetPathlvt  ""]) {
							tk_messageBox -message "Choose lvt netlist Please!"
						} else {
							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathlvt $myhtml $myvue  $grd_or_localx -noVNC" -t "LVS_LVT"} ffff]} {
								
								puts ""
							}
						}
				}
				if ([string equal $vtt  "ulvt"]) {
						if ([string equal $NetPathulvt  ""]) {
							tk_messageBox -message "Choose ulvt netlist Please!"
						} else {
						
							if { [catch {exec gnome-terminal -e "$new_lvs_script $vtt $NetPathulvt $myhtml $myvue  $grd_or_localx -noVNC" -t "LVS_ULVT"} ffff]} { 
								puts ""
							}
						}
				}	
			}
			
		} else {
			tk_messageBox -message "Choose cell Please!"
		}
	}	
proc HELP {} {
	#set user $tcl_platform(user)
	tk_messageBox -message "Ches karum ashxates ay Mard,lav eli ,mi ban el du haskaci eli!!!!! \n\n"
}
proc ABOUT {} {
	tk_messageBox -message "DRC_LVS_TOOL V.1.0V , C.2013-2014 Synopsys \nSend comments/suggestions to: surenab@synopsys.com. \n\n"
}
proc RUN_DRC {} {
	global logxout drc_script
	exec gnome-terminal -e "$drc_script svt "
}

proc SHOWLOG {} {
	global statelog lshow
	if (!$statelog) {
		pack .framelog -side top
		$lshow configure -text "HIDE LOG"
		set statelog [expr !$statelog]
	} else {
		pack forget .framelog
		$lshow configure -text "SHOW LOG"
		set statelog [expr !$statelog]
	}
}
proc Refresh {} {
	}
