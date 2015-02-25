proc pin_count_add {gpg_pin_name gcen_pin_name bcen_pin_name pin_lib_name gcen_id bcen_id gpg_id prefix} {
	global  io_cells_cm1 io_cells_cm2 io_cells_cm4 io_cells_cm8 io_cells_cm16
	set prefix_new [string range $prefix 0 end-1]
	set cell_dell [oa::DesignOpen $pin_lib_name $gcen_pin_name layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp [list "OUTL" "drawing"] ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	if {$dx == ""} {set dx 0;puts "I can found outl layer in pin cell"}
	set all_pf [list "1x4" "2x2" "4x1" "8x1" "16x1"]
	set all_cf [list "1" "2" "4" "8" "16"] 
	puts "dx = $dx"
	
	puts "Starting create pin cell for gpgs//////////////////////////////////////////////////////////////////////////////////////////////////////////////"
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		if {$cf == 1} {
			set io $io_cells_cm1
		} elseif {$cf == 2} {
			set io $io_cells_cm2
		} elseif {$cf == 4} {
			set io $io_cells_cm4
		} elseif {$cf == 8} {
			set io $io_cells_cm8
		} else {
			set io $io_cells_cm16
		} 
		set gpg_pin_$pf [lindex $io $gpg_id]
	}
	puts "length all_pf =  [llength $all_pf]"
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		puts "pf = $pf"
		if { [ catch {db::destroy [dm::getCells $prefix_new\_gpgsm_pin_$pf -libName $pin_lib_name]} excpt] } {
			puts "Normal destroying"
		}
		dm::createCell $prefix_new\_gpgsm_pin_$pf -libName $pin_lib_name
		set pin_x [dm::createCellView layout -cell [dm::getCells $prefix_new\_gpgsm_pin_$pf -libName $pin_lib_name] -viewType maskLayout]
		set ctx [de::open $pin_x -readOnly false -headless true]
		set design [db::getAttr editDesign -of $ctx]
		set cn 0
		if {($cf == 1) || ($cf == 4)} {
			set cn 4
		} elseif {$cf == 2} {
			set cn 2
		} elseif {$cf == 8} {
			set cn 8
		} else {
			set cn 16
		} 
		set px1 0
		for {set iu 0} {$iu<$cn} {incr iu} {
			set point [list $px1 0]
			le::createInst -design $design -origin $point -libName $pin_lib_name -cellName $gpg_pin_name -viewName layout 
			set px1 [expr $px1+$dx]
		}
		set rectBBox [list [list 0 0] [list [expr $cn*$dx] $dy]]
		le::createRectangle $rectBBox -lpp [ list "OUTL" "drawing"] -design $design
		le::createBoundary  $rectBBox -design $design -type pr  -force on
		de::save $design
		de::close $ctx
	}
	puts "Starting create pin cell for gios//////////////////////////////////////////////////////////////////////////////////////////////////////////////"
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		if {$cf == 1} {
			set io $io_cells_cm1
		} elseif {$cf == 2} {
			set io $io_cells_cm2
		} elseif {$cf == 4} {
			set io $io_cells_cm4
		} elseif {$cf == 8} {
			set io $io_cells_cm8
		} else {
			set io $io_cells_cm16
		} 
		set gio_pin_$pf [lindex $io $gcen_id]
	}
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		puts "pf = $pf"
		if { [ catch {db::destroy [dm::getCells $prefix_new\_gio_pin_$pf -libName $pin_lib_name]} excpt] } {
			puts "Normal destroying"
		}
		dm::createCell $prefix_new\_gio_pin_$pf -libName $pin_lib_name
		set pin_x [dm::createCellView layout -cell [dm::getCells $prefix_new\_gio_pin_$pf -libName $pin_lib_name] -viewType maskLayout]
		set ctx [de::open $pin_x -readOnly false -headless true]
		set design [db::getAttr editDesign -of $ctx]
		set cn 0
		if {($cf == 1) || ($cf == 4)} {
			set cn 4
		} elseif {$cf == 2} {
			set cn 2
		} elseif {$cf == 8} {
			set cn 8
		} else {
			set cn 16
		} 
		set px1 0
		for {set iu 0} {$iu<$cn} {incr iu} {
			set point [list $px1 0]
			le::createInst -design $design -origin $point -libName $pin_lib_name -cellName $gcen_pin_name -viewName layout 
			set px1 [expr $px1+$dx]
		}
		set rectBBox [list [list 0 0] [list [expr $cn*$dx] $dy]]
		le::createRectangle $rectBBox -lpp [ list "OUTL" "drawing"] -design $design
		le::createBoundary  $rectBBox -design $design -type pr  -force on
		de::save $design
		de::close $ctx
	}
	puts "Starting create pin cell for bios//////////////////////////////////////////////////////////////////////////////////////////////////////////////"
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		if {$cf == 1} {
			set io $io_cells_cm1
		} elseif {$cf == 2} {
			set io $io_cells_cm2
		} elseif {$cf == 4} {
			set io $io_cells_cm4
		} elseif {$cf == 8} {
			set io $io_cells_cm8
		} else {
			set io $io_cells_cm16
		} 
		set bio_pin_$pf [lindex $io $bcen_id]
	}
	for {set i 0} {$i<[llength $all_pf]} {incr i} {
		set pf [lindex $all_pf $i]
		set cf [lindex $all_cf $i] 
		puts "pf = $pf"
		
		if { [ catch {db::destroy [dm::getCells $prefix_new\_bio_pin_$pf -libName $pin_lib_name]} excpt] } {
			puts "Normal destroying"
		}
		
		dm::createCell $prefix_new\_bio_pin_$pf -libName $pin_lib_name
		set pin_x [dm::createCellView layout -cell [dm::getCells $prefix_new\_bio_pin_$pf -libName $pin_lib_name] -viewType maskLayout]
		set ctx [de::open $pin_x -readOnly false -headless true]
		set design [db::getAttr editDesign -of $ctx]
		set cn 0
		if {($cf == 1) || ($cf == 4)} {
			set cn 4
		} elseif {$cf == 2} {
			set cn 2
		} elseif {$cf == 8} {
			set cn 8
		} else {
			set cn 16
		} 
		set px1 0
		for {set iu 0} {$iu<$cn} {incr iu} {
			set point [list $px1 0]
			le::createInst -design $design -origin $point -libName $pin_lib_name -cellName $bcen_pin_name -viewName layout 
			set px1 [expr $px1+$dx]
		}
		set rectBBox [list [list 0 0] [list [expr $cn*$dx] $dy]]
		le::createRectangle $rectBBox -lpp [ list "OUTL" "drawing"] -design $design
		le::createBoundary  $rectBBox -design $design -type pr  -force on
		de::save $design
		de::close $ctx
	}
	puts "Finished creatin pin cells"

}
