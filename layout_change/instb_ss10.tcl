#!/depot/tcl8.4.19/bin/tclsh
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
#//////////////For any question mailto:surenab@synopsys.com//////////////////
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
set instb "INST_B"
set outl "OUTL"


proc CDCreateLayoutPulldownMenuOULN {} {
        set CheckMenu [gi::createMenu Checks -title Check_Tools]

        # create action items in XXX menu
        set x1 [gi::createAction INSTBP \
                    -command INSTBP \
                    -title "Check OUTL and shape INSTB"]

	set x11 [gi::createAction CHECKOUTL \
                    -command CHECKOUTL \
                    -title "Check OUTL"]

      gi::addActions [list $x1 $x11 ] -to $CheckMenu

      return $CheckMenu
      

}
#===============================================================================

#;;;;;;;;;;;;;;;;;;;;;;;;;;   M A I N  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#===============================================================================
set CheckMenu [CDCreateLayoutPulldownMenuOULN]
gi::addMenu $CheckMenu -to [gi::getWindowTypes leLayout]
#===============================================================================

##########################   E N D   #############################

#===============================================================================
proc INSTBP {} {
	global instb outl
	set pCurCellViewId [de::getActiveEditorWindow]
		set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
		set libName [db::getAttr libName -of $inst]
		puts "Layer Creator::-> Lib Name is $libName :"
		set cellName [db::getAttr name -of $inst]
		puts "Layer Creator::-> Cell Name is $cellName :"
	### Get our design
		if { [ catch {set oaDesign [oa::DesignFind $libName $cellName layout] } excpt] } {
			puts "Layer Creator::-> Could not find the layout design $libName/$cellName/layout\n$excpt"
			return
		} else {
			puts "Layer Creator::-> Design $libName/$cellName/layout was found\n"
		}
	### Now get all instances to dive into
		if { [ catch { set instanceCollection [db::getInsts -of $oaDesign] } excpt] } {
			puts "Layer Creator::-> Instance get failed\n$excpt"
			return
		} else {
			puts "Layer Creator::-> Found [db::getCount $instanceCollection] instances\n"
		}
	
	
	### Iterating through all instances
		set cellnames {}
		set libnames {}
		db::foreach oaInst $instanceCollection {
			set cn [db::getAttr cellName -of $oaInst]
			if { [lsearch -exact $cellnames $cn] == -1 } {
				lappend cellnames $cn
				set ln [db::getAttr libName -of $oaInst]
				lappend libnames $ln
			}
	}
	#Write in file cellnames and libnames
		puts "Layer Creator::-> #------------------------STARTING----------------------------#"
		puts "Layer Creator::-> cellnames = $cellnames"
		puts "Layer Creator::-> libnames = $libnames"
		set error_cells {}
		set readonlycells {}
		set erroutl {}
		set outl_norect {}
		for {set i 0} { $i<[llength $cellnames]} {incr i} {
			puts "Layer Creator::-> #----------------------------------------------------#"
			puts "Layer Creator::-> Running script \n" 
			#puts " i = $i"
			set l1 [lindex $libnames $i]
			#puts "libname is $l1"
			set c1 [lindex $cellnames $i]
			#puts "cellname is $c1"
			puts "Layer Creator::-> Start creating INST_B shape in $c1 " 
			set currentCV [dm::findCellView layout -cellName $c1 -libName $l1]
			if { ![ catch { set ctx [de::open $currentCV -headless true]} ] } {
				puts "Layer Creator::-> Get design"
				set currentOaDesign [oa::DesignFind $l1 $c1 layout]
				puts "Layer Creator::-> Remove INST_B layers"
				set shp2 [db::getShapes -lpp [list $instb "drawing"] -of $currentOaDesign]
				if {[db::getCount $shp2] > 0} {
					if {[db::getCount $shp2] >= 2} {
						le::merge $shp2
					}
					if { [catch {le::delete $shp2}]} {
						puts "Layer Creator::-> Removed INST_B layer"
					}
				}
				puts "Layer Creator::-> Get OUTL shapes"
				set shp1 [db::getShapes -lpp [list $outl "internal"] -of $currentOaDesign]
				#puts "merge opjects"
				if {[db::getCount $shp1] >= 2} {
					le::merge $shp1
				}
				#puts "get box of shapes"
				set rectBBox [db::getAttr bBox -of $shp1]
				set t [string toupper [db::getAttr type -of $shp1]]
				if { $t == "RECT" } {
					#puts "create INST_B layer"
					if {[lindex [lindex $rectBBox 0] 0] == 0 & [lindex [lindex $rectBBox 0] 1] == 0} {
						if {[catch {le::createRectangle $rectBBox -lpp [ list $instb "drawing"] -design $currentOaDesign} excpt]} {
							puts "Layer Creator::-> Please create OUTL in $c1 cell"
							de::save $currentOaDesign
							de::close $ctx
							set cnerr $l1/$c1
							lappend error_cells $cnerr
							continue
						} else {
							puts "Layer Creator::-> All Rigths"
						}
					} else {
						puts "Layer Creator::-> In cell $l1/$c1 OUTL layer is not in {0:0} cordinate "
						set cnerr $l1/$c1
						lappend erroutl $cnerr
					}
				} else {
					puts  "Layer Creator::-> In cell $l1/$c1 OUTL is none Rectangle"
					set cnerr $l1/$c1
					lappend outl_norect $cnerr
				}
	
					
		
			} else {
				puts  "Layer Creator::-> The cell $l1/$c1 doesn't open write mode.It is Read Only.Pleace check it"
				set cnerr $l1/$c1
				lappend readonlycells $cnerr
			}

			
			
			puts "Layer Creator::-> Saving design"
			de::save $currentOaDesign
			oa::close $currentOaDesign
			de::close $ctx	
		}
		puts "Layer Creator::-> All is OK\n"
		if {[llength $error_cells]>0} {
			puts "Layer Creator::-> Cells with errors \n$error_cells"
		}
		if {[llength $readonlycells]>0} {
			puts "Layer Creator::-> Cells Read Only \n$readonlycells"
		}
		if {[llength $erroutl]>0} {
			puts "Layer Creator::-> Cells Wrong OUTL \n$erroutl"
		}
		if {[llength $outl_norect]>0} {
			puts "Layer Creator::-> Cells None_Rectangle OUTL \n$outl_norect"
		}
	
		set fd [open ./instb_report "w"]
		set c1 [llength $$cellnames]
		set e1 [llength $error_cells]
		set e2 [llength $readonlycells]
		set e3 [llength $erroutl]
		set e4 [llength $outl_norect]
		puts -nonewline $fd "This file created instb creator script\n"
		puts -nonewline $fd "Cells count $c1 \n"
		puts -nonewline $fd "I am cann't creat INST_B layer in folowing cells\n$e1\n"
		puts -nonewline $fd $error_cells
		puts -nonewline $fd "\nThis cells is Read Only Cells\n$e2\n"
		puts -nonewline $fd $readonlycells
		puts -nonewline $fd "\nIn this cell OUTL layer is not in {0:0} point\n$e3\n"
		puts -nonewline $fd $erroutl
		puts -nonewline $fd "\nIn this cell OUTL layer is not Rectangle\n$e4\n"
		puts -nonewline $fd $outl_norect
		close $fd
		puts "Layer Creator::-> CHECK ./instb_report report file"
		puts "Layer Creator::-> #-------------------------FINSH------------------------------#"
}



proc CHECKOUTL {} {
	global instb outl
	set pCurCellViewId [de::getActiveEditorWindow]
		set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
		set libName [db::getAttr libName -of $inst]
		puts "Layer Creator::-> Lib Name is $libName :"
		set cellName [db::getAttr name -of $inst]
		puts "Layer Creator::-> Cell Name is $cellName :"
	### Get our design
		if { [ catch {set oaDesign [oa::DesignFind $libName $cellName layout] } excpt] } {
			puts "Layer Creator::-> Could not find the layout design $libName/$cellName/layout\n$excpt"
			return
		} else {
			puts "Layer Creator::-> Design $libName/$cellName/layout was found\n"
		}
	### Now get all instances to dive into
		if { [ catch { set instanceCollection [db::getInsts -of $oaDesign] } excpt] } {
			puts "Layer Creator::-> Instance get failed\n$excpt"
			return
		} else {
			puts "Layer Creator::-> Found [db::getCount $instanceCollection] instances\n"
		}
	
	
	### Iterating through all instances
		set cellnames {}
		set libnames {}
		db::foreach oaInst $instanceCollection {
			set cn [db::getAttr cellName -of $oaInst]
			if { [lsearch -exact $cellnames $cn] == -1 } {
				lappend cellnames $cn
				set ln [db::getAttr libName -of $oaInst]
				lappend libnames $ln
			}
	}
	#Write in file cellnames and libnames
		puts "Layer Creator::-> #------------------------STARTING----------------------------#"
		puts "Layer Creator::-> cellnames = $cellnames"
		puts "Layer Creator::-> libnames = $libnames"
		
		set nooutl {}
		set outlnotouch {}
		set outl_norect {}
		set outl_no00 {}
		for {set i 0} { $i<[llength $cellnames]} {incr i} {
			puts "#----------------------------------------------------#"
			puts "Layer Creator::-> Running script \n" 
			puts " i = $i"
			set l1 [lindex $libnames $i]
			#puts "libname is $l1"
			set c1 [lindex $cellnames $i]
			#puts "cellname is $c1"
			set currentCV [dm::findCellView layout -cellName $c1 -libName $l1]
			set ctx [de::open $currentCV -headless true]
			puts "Layer Creator::-> Get design"
			set currentOaDesign [oa::DesignFind $l1 $c1 layout]
			puts "Layer Creator::-> Get OUTL shapes"
			set shp1 [db::getShapes -lpp [list $outl "internal"] -of $currentOaDesign]
			#puts "merge opjects"
			if {[db::getCount $shp1] > 0} {
				puts "Layer Creator::-> For $l1/$c1 cell OUTL is exist"
				if {[db::getCount $shp1] > 1} {
					le::merge $shp1
				}
				if {[db::getCount $shp1] >= 2} {
					puts "Layer Creator::-> The OUTL is 2 count for $l1/$c1 cell, and their not touched"
					set cnerr $l1/$c1
					lappend outlnotouch $cnerr
				} else {
					set t [string toupper [db::getAttr type -of $shp1]]
					if { $t == "RECT" } {
						puts "Layer Creator::-> For $l1/$c1 cell OUTL is Rectangle"
						set rectBBox [db::getAttr bBox -of $shp1]
						if {[lindex [lindex $rectBBox 0] 0] == 0 & [lindex [lindex $rectBBox 0] 1] == 0} {
							puts "Layer Creator::-> For $l1/$c1 cell OUTL in {0:0} point"
						} else {
							puts "Layer Creator::-> For $l1/$c1 cell OUTL not in {0:0} point"
							set cnerr $l1/$c1
							lappend outl_no00 $cnerr
						}
					} else { 
						puts "Layer Creator::-> For $l1/$c1 cell OUTL is not Rectangle"
						set cnerr $l1/$c1
						lappend outl_norect $cnerr
					}
					
				}
			} else {
				puts "Layer Creator::-> For $l1/$c1 cell OUTL does not exist"
				set cnerr $l1/$c1
				lappend nooutl $cnerr
			}
			puts "Layer Creator::-> saving design"
			de::save $currentOaDesign
			oa::close $currentOaDesign
			de::close $ctx	
		}
		puts "Layer Creator::-> All is OK\n"
		if {[llength $nooutl]>0} {
			puts "Layer Creator::-> Cells with Does not exist OUTL \n$nooutl"
		}
		if {[llength $outlnotouch]>0} {
			puts "Layer Creator::-> The count of OUTL is 2 and their not touched \n$outlnotouch"
		}
		if {[llength $outl_no00]>0} {
			puts "Layer Creator::-> OUTL is not {0:0} point \n$outl_no00"
		}
		if {[llength $outl_norect]>0} {
			puts "Layer Creator::-> Cells None_Rectangle OUTL \n$outl_norect"
		}
	
		set fd [open ./checkoutl_report "w"]
		set ll [llength $cellnames]
		set e1 [llength $nooutl]
		set e2 [llength $outlnotouch]
		set e3 [llength $outl_no00]
		set e4 [llength $outl_norect]
		puts -nonewline $fd "This file created OUTL checker script\n"
		puts -nonewline $fd "The Script ic check $ll cells\n"
		puts -nonewline $fd "Cells with Does not exist OUTL\n$e1\n"
		puts -nonewline $fd $nooutl
		puts -nonewline $fd "\nThe count of OUTL is 2 and their not touched\n$e2\n"
		puts -nonewline $fd $outlnotouch
		puts -nonewline $fd "\nIn this cell OUTL layer is not in {0:0} point\n$e3\n"
		puts -nonewline $fd $outl_no00
		puts -nonewline $fd "\nIn this cell OUTL layer is not Rectangle\n$e4\n"
		puts -nonewline $fd $outl_norect
		close $fd
		puts "Layer Creator::-> CHECK ./checkoutl_report report file"
		puts "Layer Creator::-> #-------------------------FINSH------------------------------#"
}

xt::openTextViewer -files checkoutl_report 
