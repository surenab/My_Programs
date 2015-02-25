###procedur for add prefix ################ 
proc addprefix {cells pref} {
	set new_cells [list]
	foreach ss $cells {
		set bb $pref$ss
		lappend new_cells $bb
	}
	return $new_cells
}
###########################################
set center_cells	[addprefix $center_cells	$prefix]
set shift_cells		[addprefix $shift_cells   	$prefix]
set buffer_cells	[addprefix $buffer_cells	$prefix]
set redio_cells		[addprefix $redio_cells		$prefix]
set rebuf_cells		[addprefix $rebuf_cells		$prefix]
set cap_cells		[addprefix $cap_cells     	$prefix]
set left_cap_cells	[addprefix $left_cap_cells	$prefix]
set array_cells		[addprefix $array_cells		$prefix]
set io_cells_cm1	[addprefix $io_cells_cm1	$prefix]
set io_cells_cm2	[addprefix $io_cells_cm2	$prefix]
set io_cells_cm4	[addprefix $io_cells_cm4	$prefix]
set io_cells_cm8	[addprefix $io_cells_cm8	$prefix]
set io_cells_cm16	[addprefix $io_cells_cm16	$prefix]
set left_shift_cells	[addprefix $left_shift_cells	$prefix]
set left_buffer_cells	[addprefix $left_buffer_cells	$prefix]
set letf_rebuf_cells	[addprefix $letf_rebuf_cells	$prefix]
set doesnt_exist_cells [list]
#			0		1		2	3		4	5		6		7	8		9		10		11	12			13			14	15
set all_cells [list $center_cells $shift_cells $buffer_cells $redio_cells $rebuf_cells $cap_cells $array_cells $io_cells_cm1 $io_cells_cm2 $io_cells_cm4 $io_cells_cm8 $io_cells_cm16 $left_shift_cells $left_buffer_cells $letf_rebuf_cells $left_cap_cells] 
#puts $all_cells
###Procedure who create row from list1 cells names;Give him cell list and state cordinats
proc createrow { list1 px1 py1 rot}	{
	global design libname all_cell_list doesnt_exist_cells
	foreach cname $list1 {
		set cellexist 0
		set tmp_i 0
		for {set i 0} {$i<[llength [lindex $all_cell_list 0]]} {incr i} {
			if {$cname == [lindex [lindex $all_cell_list 0] $i]} {
				set cellexist 1
				set tmp_i $i
				break;
			}
		}
		if {$cellexist == 1} {
			set lname [lindex [lindex $all_cell_list 1] $tmp_i]
			set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
			set rec [db::getShapes -of $cell_dell -lpp [list "OUTL" "internal"] ]
			set bboxT [db::getAttr bBox -of $rec]
			set dx [lindex [lindex $bboxT 1] 0]
			set dy [lindex [lindex $bboxT 1] 1]
			if {$dx == ""} {set dx 0}
			if {$dy == ""} {set dy 0}
			set py_old $py1
			set point [list $px1 $py1]
			#puts "----------------------------------------"
			#puts "dy = $dy"
			#puts -nonewline ".....Creating $cname instance in allabut cell\n" 
			if {[string compare $rot "R0"] != 0} {
				set py1 [expr $py1+$dy]
				set point [list $px1 $py1]
			}
			#puts "py1 = $py1"
			#puts "----------------------------------------"
			le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout -orient $rot
			set py1 $py_old
			set px1 [expr $px1+$dx]
			
		}
		if {$cellexist == 0} {
			set next_state 0
			for {set i 0} {$i<[llength $doesnt_exist_cells]} {incr i} {
				if {$cname == [lindex $doesnt_exist_cells $i]} {
					set next_state 1
				}
			}
			if {$next_state == 0} {
				lappend doesnt_exist_cells $cname;
			}
			#puts "---------Does not find $cname cell---------"
		}
	}
}
proc createrowminus { list1 px1 py1 rot}	{
	global design libname io_cells_cm1 io_cells_cm2 io_cells_cm4 io_cells_cm8 io_cells_cm16 redio_cells all_cell_list doesnt_exist_cells
	foreach cname $list1 {
		set cellexist 0
		set tmp_i 0
		for {set i 0} {$i<[llength [lindex $all_cell_list 0]]} {incr i} {
			if {$cname == [lindex [lindex $all_cell_list 0] $i]} {
				set cellexist 1
				set tmp_i $i
				break;
			}
		}
		if {$cellexist == 1} {
			set lname [lindex [lindex $all_cell_list 1] $tmp_i]
			set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
			set rec [db::getShapes -of $cell_dell -lpp [list "OUTL" "internal"] ]
			set bboxT [db::getAttr bBox -of $rec]
			set dx [lindex [lindex $bboxT 1] 0]
			set dy [lindex [lindex $bboxT 1] 1]
			if {$dx == ""} {set dx 0}
			if {$dy == ""} {set dy 0}
			set point [list $px1 $py1]
			set py_old $py1
			if {[lsearch $io_cells_cm1 $cname] == -1 && [lsearch $io_cells_cm2 $cname] == -1 && [lsearch $io_cells_cm4 $cname] == -1 && [lsearch $io_cells_cm8 $cname] == -1 && [lsearch $io_cells_cm16 $cname] == -1 && [lsearch $redio_cells $cname] == -1} {
				if {[string compare $rot "R0"] == 0} {
					le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout -orient MY 
					set px1 [expr $px1-$dx]
				} else {
					set py1 [expr $py1+$dy]
					set point [list $px1 $py1]
					le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout -orient R180
					set px1 [expr $px1-$dx]
				}
			} else {
					set px1 [expr $px1-$dx]
					set point [list $px1 $py1]
					le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout
			}
			set py1 $py_old
			
		}
		if {$cellexist == 0} {
			set next_state 0
			for {set i 0} {$i<[llength $doesnt_exist_cells]} {incr i} {
				if {$cname == [lindex $doesnt_exist_cells $i]} {
					set next_state 1
				}
			}
			if {$next_state == 0} {
				lappend doesnt_exist_cells $cname;
			}
			#puts "---------Does not find $cname cell---------"
		}
	}
}
#Get cell y 
proc get_y {cellname} {
	global design libname all_cell_list
	set yy 0
	
	for {set i 0} {$i<[llength [lindex $all_cell_list 0]]} {incr i} {
		if {$cellname == [lindex [lindex $all_cell_list 0] $i]} {
			set cellexist 1
			set tmp_i $i
			set lname [lindex [lindex $all_cell_list 1] $tmp_i]
			#puts "KA $lname libum"
			#puts "Get $cellname cell"
			#puts "Opening $cellname cell for geting his outl points"
			set cell_dell [oa::DesignOpen $lname $cellname layout readOnly]
			set rec [db::getShapes -of $cell_dell -lpp [list "OUTL" "internal"] ]
			set bboxT [db::getAttr bBox -of $rec]
			#puts "bboxT=$bboxT"
			#puts $bboxT
			set dy [lindex [lindex $bboxT 1] 1]
			set yy $dy
			#puts "dy=$dy"
			return $yy
			
		}
	}
	
}
#cd1    dr1   redex1
proc cm1cd1dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {

		#puts "[lindex [lindex $all_cells 0] [lindex $number 0]]"
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]]    [lindex [lindex $all_cells 1] [lindex $number 0]]      [lindex [lindex $all_cells 2] [lindex $number 0]]        [lindex [lindex $all_cells 3] [lindex $number 0]]       [lindex [lindex $all_cells 7] [lindex $number 0]]       [lindex [lindex $all_cells 7] [lindex $number 0]]        [lindex [lindex $all_cells 4] [lindex $number 0]]        [lindex [lindex $all_cells 7] [lindex $number 0]]      [lindex [lindex $all_cells 7] [lindex $number 0]]      [lindex [lindex $all_cells 5] [lindex $number 0]]]
		
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		
		createrow  $new_list_rigth $x $yy  [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm2cd1dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}		
}	
proc cm4cd1dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm8cd1dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}		
			
}	
proc cm16cd1dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd1 dr1 redex0
proc cm1cd1dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]]    [lindex [lindex $all_cells 1] [lindex $number 0]]    [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}		
}	
proc cm2cd1dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells  0] [lindex $number 0]] [lindex [lindex $all_cells  1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm4cd1dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0]  [lindex $number 0]] [lindex [lindex $all_cells 1]  [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}		
}	
proc cm8cd1dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm16cd1dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list [lindex [lindex $all_cells 12] [lindex $number 0]] [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	

#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd1    dr0   redex1
proc cm1cd1dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm2cd1dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm4cd1dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm8cd1dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm16cd1dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	

#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd1    dr0   redex0
proc cm1cd1dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm2cd1dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm4cd1dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list  [lindex [lindex $all_cells 0]  [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]]   [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		#puts "starting rigth row"
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		#puts "rigth row is complated"
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm8cd1dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	
proc cm16cd1dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		set new_list_left  [list  [lindex [lindex $all_cells 13] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 14] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]]  [lindex [lindex $all_cells 15] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		createrowminus $new_list_left $x $yy [lindex $number 1]	
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
}	

#cd0    dr1   redex1
proc cm1cd0dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm2cd0dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm4cd0dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
		
}	
proc cm8cd0dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm16cd0dr1redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]] [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd0 dr1 redex0
proc cm1cd0dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm2cd0dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm4cd0dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
		
}	
proc cm8cd0dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm16cd0dr1redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 1] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	

#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd0    dr0   redex1
proc cm1cd0dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm2cd0dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
		
}	
proc cm4cd0dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
		#puts "verj"
	}
	
}	
proc cm8cd0dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm16cd0dr0redex1 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]  [lindex [lindex $all_cells 3] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	

#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#cd0    dr0   redex0
proc cm1cd0dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 7] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		#puts "new_list_rigth = $new_list_rigth"
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm2cd0dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 8] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm4cd0dr0redex0 {all_cells numbers x y} {
	set yy $y
	set xxx 0
	foreach number $numbers {
		#puts $xxx
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 9] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		incr xxx
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		#puts "new_dy=$new_dy"
		set yy [expr $yy+$new_dy]
		#puts "yy=$yy"
	}
	
}	
proc cm8cd0dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 10] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	
proc cm16cd0dr0redex0 {all_cells numbers x y} {
	set yy $y
	foreach number $numbers {
		set new_list_rigth [list [lindex [lindex $all_cells 0] [lindex $number 0]] [lindex [lindex $all_cells 2] [lindex $number 0]]   [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 4] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 11] [lindex $number 0]] [lindex [lindex $all_cells 5] [lindex $number 0]]]
		createrow  $new_list_rigth $x $yy [lindex $number 1]
		set new_dy [get_y [lindex [lindex $all_cells 0] [lindex $number 0]]]
		if {$new_dy == ""} {set new_dy 0.5}
		set yy [expr $yy+$new_dy]
	}
	
}	

proc abut_cm_to_cd_to_dr_to_redex {all_cells number_list cdd dr cmx redex x y} {
	if {$redex ==1} {
		#puts "r=1"
		if {$cmx == 1} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm1cd1dr1redex1 $all_cells $number_list $x $y
				} else {
					cm1cd1dr0redex1 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm1cd0dr1redex1 $all_cells $number_list $x $y
				} else {
					cm1cd0dr0redex1 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 2} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm2cd1dr1redex1 $all_cells $number_list $x $y
				} else {
					cm2cd1dr0redex1 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm2cd0dr1redex1 $all_cells $number_list $x $y
				} else {
					cm2cd0dr0redex1 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 4} {
			#puts "cm = 4"
			if {$cdd == 1} {
				if {$dr == 1} {
					cm4cd1dr1redex1 $all_cells $number_list $x $y
				} else {
					cm4cd1dr0redex1 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm4cd0dr1redex1 $all_cells $number_list $x $y
				} else {
					cm4cd0dr0redex1 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 8} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm8cd1dr1redex1 $all_cells $number_list $x $y
				} else {
					cm8cd1dr0redex1 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm8cd0dr1redex1 $all_cells $number_list $x $y
				} else {
					cm8cd0dr0redex1 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 16} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm16cd1dr1redex1 $all_cells $number_list $x $y
				} else {
					cm16cd1dr0redex1 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm16cd0dr1redex1 $all_cells $number_list $x $y
				} else {
					cm16cd0dr0redex1 $all_cells $number_list $x $y
				}
			}
		}
	} else {
		#puts "r=0"
		if {$cmx == 1} {
			if {$cdd == 1} {
				#puts "cm = 1"
				if {$dr == 1} {
					cm1cd1dr1redex0 $all_cells $number_list $x $y
					
				} else {
					cm1cd1dr0redex0 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm1cd0dr1redex0 $all_cells $number_list $x $y
				} else {
					cm1cd0dr0redex0 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 2} {
			#puts "cm = 2"
			if {$cdd == 1} {
				if {$dr == 1} {
					cm2cd1dr1redex0 $all_cells $number_list $x $y
				} else {
					cm2cd1dr0redex0 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm2cd0dr1redex0 $all_cells $number_list $x $y
				} else {
					cm2cd0dr0redex0 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 4} {
			#puts "cm = 4"
			if {$cdd == 1} {
				if {$dr == 1} {
					cm4cd1dr1redex0 $all_cells $number_list $x $y
				} else {
					cm4cd1dr0redex0 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm4cd0dr1redex0 $all_cells $number_list $x $y
				} else {
					cm4cd0dr0redex0 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 8} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm8cd1dr1redex0 $all_cells $number_list $x $y
				} else {
					cm8cd1dr0redex0 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm8cd0dr1redex0 $all_cells $number_list $x $y
				} else {
					cm8cd0dr0redex0 $all_cells $number_list $x $y
				}
			}
		} elseif {$cmx == 16} {
			if {$cdd == 1} {
				if {$dr == 1} {
					cm16cd1dr1redex0 $all_cells $number_list $x $y
				} else {
					cm16cd1dr0redex0 $all_cells $number_list $x $y
				}
			} else {
				if {$dr == 1} {
					cm16cd0dr1redex0 $all_cells $number_list $x $y
				} else {
					cm16cd0dr0redex0 $all_cells $number_list $x $y
				}
			}
		}
	}
}

proc all_abutment {all_cells bex redex pg cdd dr cmx wa bk x y  } {
	if {$wa == 1} {
		if {$bex == 1} {
			if {$redex == 1} {
				if {$pg == 1} {
					if {$bk == 1} {
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+red+gcen+gpg+bcen"
						puts "0+1+2+3+4+5+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+red+gcen+gpg+bcen"
						puts "0+1+2+3+4+5+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen+bcen"
						puts "0+1+3+4+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen+bcen"
						puts "0+1+3+4+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen+bcen"
						puts "0+1+3+4+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			} else {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg+bcen"
						puts "0+1+2+3+5+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg+bcen"
						puts "0+1+2+3+5+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg+bcen"
						puts "0+1+2+3+5+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+wa+gcen+bcen"
						puts "0+1+3+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}  {4  "R0"} {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+wa+gcen+bcen"
						puts "0+1+3+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}  {4  "R0"} {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+wa+gcen+bcen"
						puts "0+1+3+5+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}  {4  "R0"} {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			}
		} else {
			if {$redex == 0} {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg"
						puts "2+3+5+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg"
						puts "2+3+5+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+gcen+gpg"
						puts "2+3+5+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+wa+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+wa+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+wa+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			} else {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+red+gcen+gpg"
						puts "2+3+5+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"} {3  "R0"} {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+red+gcen+gpg  bk=2"
						puts "2+3+5+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"} {3  "R0"}   {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+wa+red+gcen+gpg    bk=4"
						puts "2+3+5+6+7+8+9+9+10"
						#puts "0+"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}  {3  "R0"}   {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						#puts "0.5+"
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
						#puts "1+"
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+wa+red+gcen"
						puts "3+5+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {4  "R0"} {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			}	
		}
	} else {
		if {$bex == 1} {
			if {$redex == 1} {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg+bcen"
						puts "0+1+2+3+4+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg+bcen"
						puts "0+1+2+3+4+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg+bcen"
						puts "0+1+2+3+4+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+red+gcen+bcen"
						puts "0+1+3+4+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"}  {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+red+gcen+bcen"
						puts "0+1+3+4+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"}  {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+red+gcen+bcen"
						puts "0+1+3+4+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"} {3  "R0"}  {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			} else {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg+bcen"
						puts "0+1+2+3+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg+bcen"
						puts "0+1+2+3+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg+bcen"
						puts "0+1+2+3+6+7+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"} {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+gcen+bcen"
						puts "0+1+3+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}   {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+gcen+bcen"
						puts "0+1+3+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}   {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+sac+gcen+bcen"
						puts "0+1+3+6+8+9+9+10"
						set number_list {{12 "R0"} {0 "R0"}  {2  "R0"}   {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			}
		} else {
			if {$redex ==0} {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"} {3  "R0"}  {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} elseif {$bk == 4} {
						puts "point 3" 					
						puts "rar+xdec+xdec+cmux+sac+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"}   {2  "R0"} {3  "R0"}  {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"} {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx $redex $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				
				}
			} else {
				if {$pg == 1} {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 4} { 
						puts "rar+xdec+xdec+cmux+lpg+sac+red+gcen+gpg"
						puts "2+3+6+7+8+9+9+10"
						set number_list {{13 "R0"}  {1  "R0"} {2  "R0"}   {5  "R0"} {6  "R0"} {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				} else {
					if {$bk == 1} {
						puts "rar+xdec+xdec+cmux+sac+red+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"} {2  "R0"}   {5  "R0"}  {16  "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 2} { 
						puts "rar+xdec+xdec+cmux+sac+red+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"}  {2  "R0"}   {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"}  {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} elseif {$bk == 4} { 
						puts "point 2"
						puts "rar+xdec+xdec+cmux+sac+red+gcen"
						puts "3+6+8+9+9+10"
						set number_list {{11 "R0"}  {2  "R0"}   {5  "R0"}  {14  "R0"} {8  "MX"} {8 "MX"} {7 "R0"} {8 "R0"} {8 "R0"} {10 "R0"}  {8  "MX"} {8 "MX"} {15 "R0"} {8  "R0"} {8 "R0"} {9 "R0"} {17 "R0"}}
						abut_cm_to_cd_to_dr_to_redex $all_cells $number_list $cdd $dr $cmx 0 $x $y
					} else {
						puts "Attantion!!!!!!Wrong bk "
					}
				}
			}
			
		}
	}
	puts "FINISH.....CREATING REGULAR ABUT IS COMPLATE."
}
proc make_abut {cells_list lbname clname } {
	global all_cells libname design doesnt_exist_cells wa_prefix count_io_pin gpg_pin_name gio_pin_name bio_pin_name pin_lib_name prefix all_cell_list io_cells_cm1 io_cells_cm2 io_cells_cm4 io_cells_cm8 io_cells_cm16 redio_cells
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "/////////////////////////////////Starting creat abut////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////
	#/////////////Startin Main program//////////////////////////////////////////////////////////////////////////
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////
	if {$count_io_pin == 4} {
		set pin_status [pin_count_add $gpg_pin_name $gio_pin_name $bio_pin_name $pin_lib_name 11 12 13 $prefix]
		set x1 [lindex $all_cell_list 0]
		set x2 [lindex $all_cell_list 1]
		lappend  x1  [lindex $io_cells_cm1 11];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm2 11];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm4 11];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm8 11];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm16 11];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm1 12];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm2 12];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm4 12];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm8 12];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm16 12];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm1 13];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm2 13];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm4 13];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm8 13];lappend  x2  $pin_lib_name
		lappend  x1  [lindex $io_cells_cm16 13];lappend  x2  $pin_lib_name
		set all_cell_list [list]
		lappend all_cell_list $x1
		lappend all_cell_list $x2
		
	}
	###Craeate allabut cell in cluster lib###################################################################### 
	puts "Creating $clname cell"
	if { [ catch {db::destroy [dm::getCells $clname -libName $lbname]} excpt] } {
			puts "Normal destroying"
		}
	dm::createCell $clname -libName $lbname
	set abut [dm::createCellView layout -cell [dm::getCells $clname -libName $lbname] -viewType maskLayout]
	###open allabut cell for changing
	puts "Open $clname cell for changes"
	set ctx [de::open $abut -readOnly false -headless true]
	puts "Get edit design"
	set design [db::getAttr editDesign -of $ctx]
	###Starting cordinat
	set x 0
	set y 0
	############################################################################################################
	set xx 0
	set yy 0
	set deltax 120
	set deltay 60
	set count  0
	foreach list $cells_list {
		lappend list  $xx
		lappend list  $yy
		all_abutment $all_cells [lindex $list 0] [lindex $list 1] [lindex $list 2] [lindex $list 3] [lindex $list 4] [lindex $list 5] [lindex $list 6] [lindex $list 7] [lindex $list 8] [lindex $list 9] 
		set xx [expr $xx+$deltax]
		#puts $xx
		incr count
		#puts $count
		if {$count>5} {
			set yy [expr $yy+$deltay]
			set xx 0
			#puts $yy
			set count 0
		}

	}
	
	
	puts "doesnt_exist_cells = $doesnt_exist_cells"
	exec rm -rf ./abut_creator_$wa_prefix.log
	set fd [open ./abut_creator_$wa_prefix.log "w"]
	set log_start "////////////////////////////////////////////////////////////////////////////////////////////////////\n////////////////////////////////////////////////////////////////////////////////////////////////////\n////////////////////////////////////////////////////////////////////////////////////////////////////\n////////////////////////   FINISH.....CREATING ABUT IS COMPLATED.   ////////////////////////////////\n///////////////////////For any question mailto:surenab@synopsys.com/////////////////////////////////\n////////////////////////////////////////////////////////////////////////////////////////////////////\n////////////////////////////////////////////////////////////////////////////////////////////////////\n////////////////////////////////////////////////////////////////////////////////////////////////////\nThis file was generated bu abut_creator script.\nIn this file you can find error from abut creating.\nIn bellow I wrote all cells who doesn't exist in all_cells or their name are not same."
	puts  $fd $log_start 
	puts $fd "////////////////////////////////////////////////////////////////////////////////////////////////////"
	for {set i 0} {$i<[llength $doesnt_exist_cells]} {incr i} {
		puts  $fd [lindex $doesnt_exist_cells $i]
	}
	puts $fd "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts $fd "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts $fd "///////////////////////////////////////////////THATS ALL////////////////////////////////////////////"
	puts $fd "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts $fd "////////////////////////////////////////////////////////////////////////////////////////////////////"
	close $fd
	xt::openTextViewer -files ./abut_creator_$wa_prefix.log
	#saving design and close it
	de::save $design
	de::close $ctx
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////   FINISH.....CREATING ABUT IS COMPLATED.   /////////////////////////////////"
	puts "///////////////////////For any question mailto:surenab@synopsys.com/////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"
	puts "////////////////////////////////////////////////////////////////////////////////////////////////////"

}
 
