source /remote/am04home1/arpih/bin/from_suren/chcell_maker_ss10/get_ip_op_pin.tcl
source /remote/am04home1/arpih/bin/from_suren/chcell_maker_ss10/chcell_dialog.tcl
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////VIA sizes
set via12_size_x 0.024
set via12_size_y 0.024
set via23_size_x 0.024
set via23_size_y 0.024
set via34_size_x 0.024
set via34_size_y 0.024
set via45_size_x 0.024
set via45_size_y 0.024
#//////////////////////////Extansion nets
set shape_power_pin [list "vddp" "vss" "vddpi" "vdda" "vnwa" "vnwp" "vddwl" "vsscl" "vsscr" "wlvss"]
set bacar_pins [list "vpulldn"]
set net_dont_p [list "log0" "log1"]
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
set outl_layer [list "OUTL" "internal"]
set instb_layer [list "INST_B" "drawing"]
set m1_layer [ list "M1" "drawing"]
set m2_layer [ list "M2" "drawing"]
set m3_layer [ list "M3" "drawing"]
set m4_layer [ list "M4" "drawing"]
set m5_layer [ list "M5" "drawing"]
set v12_layer [ list "VIA12" "drawing"]
set v23_layer [ list "VIA23" "drawing"]
set v34_layer [ list "VIA34" "drawing"]
set v45_layer [ list "VIA45" "drawing"]
set lvsm1_layer [list "M1" "label"]
set lvsm2_layer [list "M2" "label"]
set lvsm3_layer [list "M3" "label"]
set lvsm4_layer [list "M4" "label"]
#//////////////////////////////seting edge cell names and lib name//////////////////////////////////////////////////////////////////////
set edge_libname "chcell_lay"
set edge_cellname_h_t "shift_edge_horizon_top"
set edge_cellname_h_b "shift_edge_horizon_bot"
set edge_cellname_v "centr_edge_vertical"
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////////////////////////////////////Main MENU part/////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
proc CDCreateLayoutPulldownMenuc_chcell {} {
        set cMenu [gi::createMenu c -title chcell_creator]
        set x1 [gi::createAction creatchcell \
                    -command main \
                    -title "Create_chcell"]
		set x2 [gi::createAction dial \
                    -command dial \
                    -title "Chcel Creator"]
	gi::addActions [list  $x2 ] -to $cMenu
	return $cMenu
}
set cMenu [CDCreateLayoutPulldownMenuc_chcell]
gi::addMenu $cMenu -to [gi::getWindowTypes leLayout]
#/////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////Starting declaration used functions/////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
proc get_flatten_shapes {cname lname} {
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	#////////give me cell name and lib name and I will copy that cell in same lib				 //////
	#////////and after that I will to make that cell flat and return flaten metal 1,2,3,4 shapes //////
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	puts "Copying cell"
	puts "cellname = $cname;libname  = $lname"
	dm::copyCells [dm::findCell $cname -libName $lname] -libDestName $lname  -cellDestName for_chcell
	#puts "point 0"
	set cell_dell_tmp [oa::DesignOpen $lname for_chcell layout readOnly]
	set ctx [de::open [dm::findCellView layout -cellName for_chcell -libName $lname] -headless true]
	#puts "cell_dell_tmp = $cell_dell_tmp"
	puts "Fllating cell"
	le::flatten [de::getFigures {{-20 -20} {100 100 }} -design $cell_dell_tmp] -levels 20
	#puts "point 1"
	#de::save $cell_dell_tmp
	#puts "point 2"
	set metal1 [db::getShapes -of $cell_dell_tmp -lpp [ list "M1" "drawing"]]
	set metal2 [db::getShapes -of $cell_dell_tmp -lpp [ list "M2" "drawing"]]
	set metal3 [db::getShapes -of $cell_dell_tmp -lpp [ list "M3" "drawing"]]
	set metal4 [db::getShapes -of $cell_dell_tmp -lpp [ list "M4" "drawing"]]
	#puts "point 3"
	puts "Closing tmp cell"
	#de::save $cell_dell_tmp
	oa::close $cell_dell_tmp
	puts "returning metal shapes"
	set metalx ""
	lappend metalx $metal1
	lappend metalx $metal2
	lappend metalx $metal3
	lappend metalx $metal4
	return $metalx
}
#/////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
proc get_layout_pins_first {lay_pins_list edd} {
	#/////////////////////////////////////////////////////////////////////////////////////////////
    #////////////////////////////////Give me layout shapes and Design and I return you    ////////
	#////////////////////////////////all layout pins with bbox coordinates and layer type //////// 
	#/////////////////////////////////////////////////////////////////////////////////////////////
	set text_pins_list [list]
    set text_name [list]
    set text_name_num [list]
    db::foreach lay_pin $lay_pins_list {
		### get the port name
		set lay_pin_name [db::getAttr text -of $lay_pin]
		#puts "lay_pin_name = $lay_pin_name"
		set lay_pin_name_lower [string tolower $lay_pin_name]
		set layerNum [db::getAttr layerNum -of $lay_pin]
		#puts "layerNum = $layerNum"
		set lay_pin_layer [oa::getName [oa::LayerFind [db::getAttr tech -of $edd ] $layerNum]]
		#puts "lay_pin_layer = $lay_pin_layer"
		set max_lay_num [string range $lay_pin_layer [expr [string length $lay_pin_layer]-1] [expr [string length $lay_pin_layer]-1]]
		if {$lay_pin_name_lower == "qt"} {puts "Find one qt and it's max_lay_num is $max_lay_num"}
		if {[lsearch $text_name $lay_pin_name_lower] == -1} {
			set lay_pin_bbox [db::getAttr bBox -of $lay_pin]
			set tmp_list [list $lay_pin_name_lower $lay_pin_name $lay_pin_bbox $max_lay_num]
			lappend text_pins_list $tmp_list 
			lappend text_name $lay_pin_name_lower
			lappend text_name_num $max_lay_num
		} elseif {[lindex $text_name_num [lsearch $text_name $lay_pin_name_lower]]<$max_lay_num} {
			set lay_pin_bbox [db::getAttr bBox -of $lay_pin]
			set tmp_list [list $lay_pin_name_lower $lay_pin_name $lay_pin_bbox $max_lay_num]
			if {$lay_pin_name_lower == "qt"} {puts "FOR qt before [lindex $text_pins_list [lsearch $text_name $lay_pin_name_lower]] \ntmp_lsit = $tmp_list \nmax_lay_num = $max_lay_num\n"}
			set text_pins_list [lreplace  $text_pins_list [lsearch $text_name $lay_pin_name_lower] [lsearch $text_name $lay_pin_name_lower] $tmp_list ]
			if {$lay_pin_name_lower == "qt"} {puts "FOR qt after [lindex $text_pins_list [lsearch $text_name $lay_pin_name_lower]]"}
			set text_name [lreplace $text_name [lsearch $text_name $lay_pin_name_lower] [lsearch $text_name $lay_pin_name_lower] $lay_pin_name_lower]
			set text_name_num [lreplace $text_name_num [lsearch $text_name $lay_pin_name_lower] [lsearch $text_name $lay_pin_name_lower] $max_lay_num]
		}
		  
    }
	return $text_pins_list
}
#/////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////
proc get_x_y_edge {} {
	#/////////////////////////////////////////////////////////////////////////////////////////////////
	#///////////////Getting Edge cell X and Y coordinates/////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////////////////////////////////
	global edge_libname edge_cellname_h_t edge_cellname_h_b edge_cellname_v outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer
	set cell_dell [oa::DesignOpen $edge_libname $edge_cellname_h_t layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx_h [lindex [lindex $bboxT 1] 0]
	set dy_h [lindex [lindex $bboxT 1] 1]
	if {$dx_h == ""} {set dx_h 0}
	if {$dy_h == ""} {set dy_h 0}
	set cell_dell [oa::DesignOpen $edge_libname $edge_cellname_v layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx_v [lindex [lindex $bboxT 1] 0]
	set dy_v [lindex [lindex $bboxT 1] 1]
	if {$dx_v == ""} {set dx_v 0}
	if {$dy_v == ""} {set dy_v 0}
	set xy_edge [list $dx_h $dy_h $dx_v $dy_v]
	return $xy_edge
}	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////get active window cell name and lib name//////////////////////////////////////////////////
proc get_lib_cell_names {} {
	set pCurCellViewId [de::getActiveEditorWindow]
	set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
	set libname [db::getAttr libName -of $inst]
	puts "Lib Name is $libname :"
	set cellname [db::getAttr name -of $inst]
	puts "Cell Name is $cellname :"
	set my_cell [list $libname $cellname]
	return $my_cell
}
#///////////////////////////////////////////This function create 0 lavel of chcell//////////////////////////////////////////////////////
proc level0 {design lname cname count orient} {
	global edge_libname edge_cellname_h_t edge_cellname_h_b edge_cellname_v outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	puts "dx = $dx"
	if {$dx == ""} {
		puts "ERROR:: I can not find $outl_layer layer in your design.Please check it"
		return -1 
	}
	set dy [lindex [lindex $bboxT 1] 1]
	puts "dy = $dy"
	if {$orient == "h"} {
		set chcell_length [expr $count*$dx]
		set chcell_he $dy
	} else {
		set chcell_length $dx
		set chcell_he [expr $count*$dy]
	}
	#set edge_xy [get_x_y_edge]
	#set edge_h_count [expr $chcell_length/[lindex $edge_xy 0]+1]
	#set edge_h_count [expr int($edge_h_count)]
	#set edge_v_count [expr $chcell_he/[lindex $edge_xy 3]+3]
	#set edge_v_count [expr int($edge_v_count)]
	set x 0
	set y 0	
	set count1 $count
	while {$count} {
		set point [list $x $y ]
		le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout 
		if {$orient == "h"} {
			set x [expr $x+$dx]
		} else {
			set y [expr $y+$dy]
		}
		set count [expr $count-1]
	}
	#if {$orient == "h"} {
	#	set count $count1
	#} else {
	#	set count 1
	#}
	#set x 0	
	#set y 0
	#for {set i 0} {$i<$edge_h_count} {incr i} {
	#	set new_y_h [expr 0-[lindex $edge_xy 1]]
	#	set point1 [list $x $new_y_h]
	#	set point2 [list $x $chcell_he]
	#	le::createInst -design $design -origin $point1 -libName $edge_libname -cellName $edge_cellname_h_b -viewName layout 
	#	le::createInst -design $design -origin $point2 -libName $edge_libname -cellName $edge_cellname_h_t -viewName layout
	#	set x [expr $x+[lindex $edge_xy 0]]
	#}
	#set y -0.27	
	#for {set i 0} {$i<$edge_v_count} {incr i} {
	#	set new_x [expr 0-[lindex $edge_xy 2]]
	#	set point1 [list $new_x  $y]
	#	set new_xx [expr $count*$dx]
	#	set point2 [list $new_xx $y]
	#	le::createInst -design $design -origin $point1 -libName $edge_libname -cellName $edge_cellname_v -viewName layout 
	#	le::createInst -design $design -origin $point2 -libName $edge_libname -cellName $edge_cellname_v -viewName layout
	#	set y [expr $y+[lindex $edge_xy 3]]
	#}
}
#//////////////////////////////////Function return high low left and rigth coordinat for that shapes////////////////////////////////////
proc shapes_max_min {shapes} {
	set high 0
	set low 0
	set left 0
	set rigth 0
	db::foreach lay_pin $shapes {
		#puts "2+++"
		set lay_pin_bbox [db::getAttr bBox -of $lay_pin]
		set x1 [lindex [lindex $lay_pin_bbox 0] 0]
		set x2 [lindex [lindex $lay_pin_bbox 1] 0]
		#puts "3+++"
		if {$x1>$rigth} {set rigth $x1}
		if {$x2>$rigth} {set rigth $x2}
		if {$x1<$left} {set left $x1}
		if {$x2<$left} {set left $x2}
		#puts "4+++"
		set y1 [lindex [lindex $lay_pin_bbox 0] 1]
		set y2 [lindex [lindex $lay_pin_bbox 1] 1]
		if {$y1>$high} {set high $y1}
		if {$y2>$high} {set high $y2}
		if {$y1<$low} {set low $y1}
		if {$y2<$low} {set low $y2}
	}
	set ret_list [list $high $low $left $rigth]
	return $ret_list
}
#///////////////////////////////////////////This function create 1 lavel of chcell//////////////////////////////////////////////////////
proc level1 {edd lname cname count orient metal1} {
	
	global outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	puts "1+++"
	#set metal1 [get_flatten_shapes $cname $lname {M1 drawing }]
	#set metal1 [db::getShapes -of $cell_dell -lpp {M1 drawing }]
	#set lay_ports1 [db::getShapes -of $cell_dell -lpp lvsm1_layer]
	set m1_cood [shapes_max_min $metal1]
	puts "m1_cood = $m1_cood"
	#puts "2++"
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		puts "x++++"
		set x1y1 [list [expr [lindex $m1_cood 2]-0.081] [expr [lindex $m1_cood 1]-0.081]]
		set x2y2 [list [expr [lindex $m1_cood 2]-0.081-0.096] [expr [lindex $m1_cood 0]+0.081]]
		puts "0.5+++"
		set x3y3 [list [expr $cxn+[lindex $m1_cood 3]+0.081+0.096]  [expr [lindex $m1_cood 0]+0.081+0.096]]
		set x4y4 [list [expr $cxn+[lindex $m1_cood 3]+0.081]  [expr [lindex $m1_cood 1]-0.081-0.096]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set x1y1 [list [expr [lindex $m1_cood 2]-0.081] [expr [lindex $m1_cood 1]-0.081]]
		set x2y2 [list [expr [lindex $m1_cood 2]-0.081-0.096] [expr $cxn+[lindex $m1_cood 0]+0.081]]
		set x3y3 [list [expr [lindex $m1_cood 3]+0.081+0.096]  [expr $cxn+[lindex $m1_cood 0]+0.081+0.096]]
		set x4y4 [list [expr [lindex $m1_cood 3]+0.081]  [expr [lindex $m1_cood 1]-0.081-0.096]]
	}
	puts "3++"
	set s1 [list $x1y1 $x2y2]
	set s2 [list $x2y2 $x3y3]
	set s3 [list $x3y3 $x4y4]
	set s4 [list $x4y4 $x1y1]
	le::createRectangle $s1 -lpp $m1_layer -design $edd
	le::createRectangle $s2 -lpp $m1_layer -design $edd
	le::createRectangle $s3 -lpp $m1_layer -design $edd
	le::createRectangle $s4 -lpp $m1_layer -design $edd
	puts "Created m1 shapes"
}
#///////////////////////////////////////////This function create 2 lavel of chcell//////////////////////////////////////////////////////
proc level2 {edd lname cname count orient metal2 metal1} {
	global via12_size_y via12_size_x outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer v12_layer  v23_layer v34_layer v45_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	#set metal2 [get_flatten_shapes $cname $lname {M2 drawing }]
	#set metal2 [db::getShapes -of $cell_dell -lpp {M2 drawing }]
	set lay_ports2 [db::getShapes -of $cell_dell -lpp lvsm2_layer]
	set m2_cood [shapes_max_min $metal2]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set x1y1 [list [expr [lindex $m2_cood 2]-0.081] [expr [lindex $m2_cood 1]-0.3]]
		set x2y2 [list [expr [lindex $m2_cood 2]-0.081-0.096] [expr [lindex $m2_cood 0]+0.3]]
		set x3y3 [list [expr $cxn+[lindex $m2_cood 3]+0.081+0.096]  [expr [lindex $m2_cood 0]+0.3]]
		set x4y4 [list [expr $cxn+[lindex $m2_cood 3]+0.081]  [expr [lindex $m2_cood 1]-0.3]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set x1y1 [list [expr [lindex $m2_cood 2]-0.081] [expr [lindex $m2_cood 1]-0.3]]
		set x2y2 [list [expr [lindex $m2_cood 2]-0.081-0.096] [expr $cxn+[lindex $m2_cood 0]+0.3]]
		set x3y3 [list [expr [lindex $m2_cood 3]+0.081+0.096]  [expr $cxn+[lindex $m2_cood 0]+0.3]]
		set x4y4 [list [expr [lindex $m2_cood 3]+0.081]  [expr [lindex $m2_cood 1]-0.3]]
	}
	set s1 [list $x1y1 $x2y2]
	set s3 [list $x3y3 $x4y4]
	le::createRectangle $s1 -lpp $m2_layer -design $edd
	le::createRectangle $s3 -lpp $m2_layer -design $edd
	puts "Created m2 shapes"
	#set metal1 [get_flatten_shapes $cname $lname {M1 drawing }]
	#set metal1 [db::getShapes -of $cell_dell -lpp {M1 drawing }]
	set m1_cood [shapes_max_min $metal1]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set m1x1y1 [list [expr [lindex $m1_cood 2]-0.081] [expr [lindex $m1_cood 1]-0.081]]
		set m1x2y2 [list [expr [lindex $m1_cood 2]-0.081-0.096] [expr [lindex $m1_cood 0]+0.081]]
		set m1x3y3 [list [expr $cxn+[lindex $m1_cood 3]+0.081+0.096]  [expr [lindex $m1_cood 0]+0.081+0.096]]
		set m1x4y4 [list [expr $cxn+[lindex $m1_cood 3]+0.081]  [expr [lindex $m1_cood 1]-0.081-0.096]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set m1x1y1 [list [expr [lindex $m1_cood 2]-0.081] [expr [lindex $m1_cood 1]-0.081]]
		set m1x2y2 [list [expr [lindex $m1_cood 2]-0.081-0.096] [expr $cxn+[lindex $m1_cood 0]+0.081]]
		set m1x3y3 [list [expr [lindex $m1_cood 3]+0.081+0.096]  [expr $cxn+[lindex $m1_cood 0]+0.081+0.096]]
		set m1x4y4 [list [expr [lindex $m1_cood 3]+0.081]  [expr [lindex $m1_cood 1]-0.081-0.096]]
	}
	#//////////////////////Starting creat vias////////////////////////////////////////////////////////////////
	if {([lindex $x1y1 1]>=[lindex $m1x4y4 1]) && ([lindex $m1x1y1 0]>=[lindex $x1y1 0])} {
		set vxy1 [list [lindex $x1y1 0] [lindex $m1x4y4 1]]
		set vxy2 [list [expr $via12_size_x+[lindex $x1y1 0]] [expr $via12_size_y+[lindex $m1x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v12_layer -design $edd
	}
	if {([lindex $x2y2 1]>=[lindex $m1x3y3 1]) && ([lindex $x2y2 0]>=[lindex $m1x2y2 0])} {
		set vxy1 [list [lindex $x2y2 0] [lindex $m1x2y2 1]]
		set vxy2 [list [expr $via12_size_x+[lindex $x2y2 0]] [expr $via12_size_y+[lindex $m1x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v12_layer -design $edd
	}
	if {([lindex $x3y3 1]>=[lindex $m1x3y3 1]) && ([lindex $x3y3 0]<=[lindex $m1x3y3 0])} {
		set vxy1 [list [lindex $x4y4 0] [lindex $m1x2y2 1]]
		set vxy2 [list [expr $via12_size_x+[lindex $x4y4 0]] [expr $via12_size_y+[lindex $m1x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v12_layer -design $edd
	}
	if {([lindex $x4y4 1]<=[lindex $m1x4y4 1]) && ([lindex $x3y3 0]<=[lindex $m1x3y3 0])} {
		set vxy1 [list [lindex $x4y4 0] [lindex $m1x4y4 1]]
		set vxy2 [list [expr $via12_size_x+[lindex $x4y4 0]] [expr $via12_size_y+[lindex $m1x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v12_layer -design $edd
	}
	
}
#///////////////////////////////////////////This function create 3 lavel of chcell//////////////////////////////////////////////////////
proc level3 {edd lname cname count orient metal3 metal2} {
	global via23_size_y via23_size_x outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer v12_layer  v23_layer v34_layer v45_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	#set metal3 [get_flatten_shapes $cname $lname {M3 drawing }]
	#set metal3 [db::getShapes -of $cell_dell -lpp {M3 drawing }]
	set lay_ports3 [db::getShapes -of $cell_dell -lpp lvsm3_layer]
	set m3_cood [shapes_max_min $metal3]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set x1y1 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 1]-0.081]]
		set x4y4 [list [expr $cxn+[lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 1]-0.081-0.096]]
		set x2y2 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 0]+0.081]]
		set x3y3 [list [expr $cxn+[lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 0]+0.081+0.096]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set x1y1 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 1]-0.081]]
		set x4y4 [list [expr [lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 1]-0.081-0.096]]
		set x2y2 [list [expr [lindex $m3_cood 2]-0.3] [expr $cxn+[lindex $m3_cood 0]+0.081]]
		set x3y3 [list [expr [lindex $m3_cood 3]+0.3]  [expr $cxn+[lindex $m3_cood 0]+0.081+0.096]]
	}
	set s2 [list $x2y2 $x3y3]
	set s4 [list $x4y4 $x1y1]
	le::createRectangle $s2 -lpp $m3_layer -design $edd
	le::createRectangle $s4 -lpp $m3_layer -design $edd
	puts "Created m3 shapes"
	#set metal2 [get_flatten_shapes $cname $lname {M2 drawing }]
	#set metal2 [db::getShapes -of $cell_dell -lpp {M2 drawing }]
	set m2_cood [shapes_max_min $metal2]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set m2x1y1 [list [expr [lindex $m2_cood 2]-0.081] [expr [lindex $m2_cood 1]-0.3]]
		set m2x2y2 [list [expr [lindex $m2_cood 2]-0.081-0.096] [expr [lindex $m2_cood 0]+0.3]]
		set m2x3y3 [list [expr $cxn+[lindex $m2_cood 3]+0.081+0.096]  [expr [lindex $m2_cood 0]+0.3]]
		set m2x4y4 [list [expr $cxn+[lindex $m2_cood 3]+0.081]  [expr [lindex $m2_cood 1]-0.3]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set m2x1y1 [list [expr [lindex $m2_cood 2]-0.081] [expr [lindex $m2_cood 1]-0.3]]
		set m2x2y2 [list [expr [lindex $m2_cood 2]-0.081-0.096] [expr $cxn+[lindex $m2_cood 0]+0.3]]
		set m2x3y3 [list [expr [lindex $m2_cood 3]+0.081+0.096]  [expr $cxn+[lindex $m2_cood 0]+0.3]]
		set m2x4y4 [list [expr [lindex $m2_cood 3]+0.081]  [expr [lindex $m2_cood 1]-0.3]]
	}
	#////////////////////////////////starting creat vias/////////////////////////////////////////////////////////////
	if {([lindex $x4y4 1]>=[lindex $m2x1y1 1]) && ([lindex $m2x1y1 0]>=[lindex $x1y1 0])} {
		set vxy1 [list [lindex $m2x2y2 0] [lindex $x4y4 1]]
		set vxy2 [list [expr $via23_size_x+[lindex $m2x2y2 0]] [expr $via23_size_y+[lindex $x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v23_layer -design $edd
	}
	if {([lindex $x2y2 1]<=[lindex $m2x2y2 1]) && ([lindex $x2y2 0]<=[lindex $m2x2y2 0])} {
		set vxy1 [list [lindex $m2x2y2 0] [lindex $x2y2 1]]
		set vxy2 [list [expr $via23_size_x+[lindex $m2x2y2 0]] [expr $via23_size_y+[lindex $x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v23_layer -design $edd
	}
	if {([lindex $x3y3 1]<=[lindex $m2x3y3 1]) && ([lindex $x3y3 0]>=[lindex $m2x3y3 0])} {
		set vxy1 [list [lindex $m2x4y4 0] [lindex $x2y2 1]]
		set vxy2 [list [expr $via23_size_x+[lindex $m2x4y4 0]] [expr $via23_size_y+[lindex $x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v23_layer -design $edd
	}
	if {([lindex $x4y4 1]>=[lindex $m2x4y4 1]) && ([lindex $x3y3 0]>=[lindex $m2x3y3 0])} {
		set vxy1 [list [lindex $m2x4y4 0] [lindex $x4y4 1]]
		set vxy2 [list [expr $via23_size_x+[lindex $m2x4y4 0]] [expr $via23_size_y+[lindex $x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v23_layer -design $edd
	}
}
#///////////////////////////////////////////This function create 4 lavel of chcell//////////////////////////////////////////////////////
proc level4 {edd lname cname count orient metal4 metal3} {
	global via34_size_y via34_size_x outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer v12_layer  v23_layer v34_layer v45_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	#set metal4 [get_flatten_shapes $cname $lname {M4 drawing }]
	#set metal4 [db::getShapes -of $cell_dell -lpp {M4 drawing }]
	set lay_ports4 [db::getShapes -of $cell_dell -lpp lvsm4_layer]
	set m4_cood [shapes_max_min $metal4]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set x1y1 [list [expr [lindex $m4_cood 2]-0.081] [expr [lindex $m4_cood 1]-0.3]]
		set x2y2 [list [expr [lindex $m4_cood 2]-0.081-0.096] [expr [lindex $m4_cood 0]+0.3]]
		set x3y3 [list [expr $cxn+[lindex $m4_cood 3]+0.081+0.096]  [expr [lindex $m4_cood 0]+0.3]]
		set x4y4 [list [expr $cxn+[lindex $m4_cood 3]+0.081]  [expr [lindex $m4_cood 1]-0.3]]
	} else { 
		set cn [expr $count -1]
		set cxn [expr $cn*$dy]
		set x1y1 [list [expr [lindex $m4_cood 2]-0.081] [expr [lindex $m4_cood 1]-0.3]]
		set x2y2 [list [expr [lindex $m4_cood 2]-0.081-0.096] [expr $cxn+[lindex $m4_cood 0]+0.3]]
		set x3y3 [list [expr [lindex $m4_cood 3]+0.081+0.096]  [expr $cxn+[lindex $m4_cood 0]+0.3]]
		set x4y4 [list [expr [lindex $m4_cood 3]+0.081]  [expr [lindex $m4_cood 1]-0.3]]
	}
	set s1 [list $x1y1 $x2y2]
	set s3 [list $x3y3 $x4y4]
	le::createRectangle $s1 -lpp $m4_layer -design $edd
	le::createRectangle $s3 -lpp $m4_layer -design $edd
	puts "Created m4 shapes"
	#set metal3 [get_flatten_shapes $cname $lname {M3 drawing }]
	#set metal3 [db::getShapes -of $cell_dell -lpp {M3 drawing }]
	set m3_cood [shapes_max_min $metal3]
	if {$orient == "h"} {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set m4x1y1 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 1]-0.081]]
		set m4x4y4 [list [expr $cxn+[lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 1]-0.081-0.096]]
		set m4x2y2 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 0]+0.081]]
		set m4x3y3 [list [expr $cxn+[lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 0]+0.081+0.096]]
	} else {
		set cn [expr $count -1]
		set cxn [expr $cn*$dx]
		set m4x1y1 [list [expr [lindex $m3_cood 2]-0.3] [expr [lindex $m3_cood 1]-0.081]]
		set m4x4y4 [list [expr [lindex $m3_cood 3]+0.3]  [expr [lindex $m3_cood 1]-0.081-0.096]]
		set m4x2y2 [list [expr [lindex $m3_cood 2]-0.3] [expr $cxn+[lindex $m3_cood 0]+0.081]]
		set m4x3y3 [list [expr [lindex $m3_cood 3]+0.3]  [expr $cxn+[lindex $m3_cood 0]+0.081+0.096]]
	}
	#///////////////////////////Starting creat vias//////////////////////////////////////////////////////////////
	if {([lindex $x1y1 1]<=[lindex $m4x4y4 1]) && ([lindex $m4x1y1 0]<=[lindex $x2y2 0])} {
		set vxy1 [list [lindex $x2y2 0] [lindex $m4x4y4 1]]
		set vxy2 [list [expr $via34_size_x+[lindex $x2y2 0]] [expr $via34_size_y+[lindex $m4x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v34_layer -design $edd
	}
	if {([lindex $x2y2 1]>=[lindex $m4x3y3 1]) && ([lindex $x2y2 0]>=[lindex $m4x2y2 0])} {
		set vxy1 [list [lindex $x2y2 0] [lindex $m4x2y2 1]]
		set vxy2 [list [expr $via34_size_x+[lindex $x2y2 0]] [expr $via34_size_y+[lindex $m4x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v34_layer -design $edd
	}
	if {([lindex $x3y3 1]>=[lindex $m4x3y3 1]) && ([lindex $x3y3 0]<=[lindex $m4x3y3 0])} {
		set vxy1 [list [lindex $x4y4 0] [lindex $m4x2y2 1]]
		set vxy2 [list [expr $via34_size_x+[lindex $x4y4 0]] [expr $via34_size_y+[lindex $m4x2y2 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v34_layer -design $edd
	}
	if {([lindex $x4y4 1]<=[lindex $m4x4y4 1]) && ([lindex $x3y3 0]<=[lindex $m4x3y3 0])} {
		set vxy1 [list [lindex $x4y4 0] [lindex $m4x4y4 1]]
		set vxy2 [list [expr $via34_size_x+[lindex $x4y4 0]] [expr $via34_size_y+[lindex $m4x4y4 1]]]
		set vi1 [list $vxy1 $vxy2]
		le::createRectangle $vi1 -lpp $v34_layer -design $edd
	}
}
#///////////////////////////////////////////This function create 5 lavel of chcell//////////////////////////////////////////////////////
proc level5 {edd lname cname count orient} {
	global via45_size_y via45_size_x outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer v12_layer  v23_layer v34_layer v45_layer
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx [lindex [lindex $bboxT 1] 0]
	set dy [lindex [lindex $bboxT 1] 1]
	set metal4 [db::getShapes -of $cell_dell -lpp {M4 drawing }]
	set lay_ports4 [db::getShapes -of $cell_dell -lpp lvsm4_layer]
	set m4_cood [shapes_max_min $metal4]
	set x1y1 [list [expr [lindex $m4_cood 2]-0.3] [expr [lindex $m4_cood 1]-0.35]]
	if {$orient == "h"} {
		set x3y3 [list [expr $count*[lindex $m4_cood 3]+0.3+0.096]  [expr [lindex $m4_cood 0]+0.35]]
	} else {
		set x3y3 [list [expr [lindex $m4_cood 3]+0.3+0.096]  [expr $count*[lindex $m4_cood 0]+0.35]]
	}
	set s1 [list $x1y1 $x3y3]
	le::createRectangle $s1 -lpp $m5_layer -design $edd
	puts "Created m5 shapes"
	#//////////////////////////////Creating M4-M5 Via/////////////////////////////////////////////////////////////////////
	set metal4 [db::getShapes -of $cell_dell -lpp {M4 drawing }]
	set m4_cood [shapes_max_min $metal4]
	set x1y1 [list [expr [lindex $m4_cood 2]-0.081] [expr [lindex $m4_cood 1]-0.3]]
	set vxy1 [list [expr [lindex $x1y1 0]-0.096] [lindex $x1y1 1]]
	set vxy2 [list [expr $via45_size_x+[expr [lindex $x1y1 0]-0.096]] [expr $via45_size_y+[lindex $x1y1 1]]]
	set vi1 [list $vxy1 $vxy2]
	le::createRectangle $vi1 -lpp $v45_layer -design $edd
}
#//////////////////////////////Creating ports without ipv iph ports//////////////////////////////////////////////////////////////////
proc port_without {netlist edd lname cname count chcell_cellname orient} {
	global outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer v12_layer  v23_layer v34_layer v45_layer shape_power_pin bacar_pins net_dont_p
	#/////get schematic ports without ipv and iph////////////////////////
	puts "Geting schematic ports without ip op"
	set all_ports [get_all_pins $netlist $chcell_cellname]
	set ports_without [lindex $all_ports 1]
	set all_ports_ipv [lindex $all_ports 2]
	set all_ports_iph [lindex $all_ports 3]
	#/////get layout ports without ipv and iph////////////////////////
	puts "Geting layput ports"
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set outl_shape [db::getShapes -lpp $outl_layer -of $cell_dell]
	set outl_bbox [db::getAttr bBox -of $outl_shape]
	set outl_x [lindex [lindex $outl_bbox 1] 0]
	set outl_y [lindex [lindex $outl_bbox 1] 1]
	set lay_ports [db::getShapes -of $cell_dell -filter {(%type=="Text" || %type=="AttrDisplay")  && (%layerNum==14 || %layerNum==16 || %layerNum==18 || %layerNum==20 )}]
	set port_info [list]
	db::foreach lay_pin $lay_ports {
		set lay_pin_name [db::getAttr text -of $lay_pin]
        	set lay_pin_name_lower [string tolower $lay_pin_name]
		set layerNum [db::getAttr layerNum -of $lay_pin]
        	set lay_pin_layer [oa::getName [oa::LayerFind [db::getAttr tech -of $edd ] $layerNum]]
		set origin [db::getAttr origin -of $lay_pin]
		set tmp [list $lay_pin_name $lay_pin_name_lower $lay_pin_layer $origin]
		lappend port_info $tmp 
	}
	set port_does_exist [list]
	#////////////////////////////////////////////////////////////////////////////////////////////
	puts "Starting create port without ip and op in layout"
	for {set i 0} {$i<[llength $port_info]} {incr i} {
		set pin_name_h [lindex [lindex $port_info $i] 0]
		set pin_length [string length $pin_name_h]
		set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
		set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
		if {[string is integer $pl12] ==1} {
			set sf [expr [string length $pin_name_h ]-2]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl1] ==1} {
			set sf [expr [string length $pin_name_h ]-1]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} else {
			set sf [string length $pin_name_h ]
			if {(($count>1) && ($orient == "h")) || ([lsearch $bacar_pins $pin_name_h] != -1)} {
				set new_s2 0
			} else {
				set new_s2 ""
			}
		}
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		set pin_name_h   $new_s1
		set old_pin_name $pin_name_h
		if {[lsearch $shape_power_pin $pin_name_h] == -1} { 
			append pin_name_h   $new_s2
		}
		set pin_name_h_lower [string tolower $pin_name_h]
		if {([lsearch $ports_without $pin_name_h]!=-1) || ([lsearch $ports_without $pin_name_h_lower]!=-1)} { 
			set tmp_origin [lindex [lindex $port_info $i] 3]
			set tmpx [lindex $tmp_origin 0]
			set tmpy [lindex $tmp_origin 1]
			if {$orient == "h"} {
				if {$count == 1} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
				}
				if {$count == 2} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					if {(($orient == "h") || ([lsearch $bacar_pins $old_pin_name] != -1)) && ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 1*$outl_x+$tmpx] $tmpy] -height 0.02
				}
				if {$count == 3} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					if {(($orient == "h")|| ([lsearch $bacar_pins $old_pin_name] != -1))&& ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 1*$outl_x+$tmpx] $tmpy] -height 0.02
					if {(($orient == "h")|| ([lsearch $bacar_pins $old_pin_name] != -1))&& ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 2*$outl_x+$tmpx] $tmpy] -height 0.02
				}
				if {$count == 4} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					if {(($orient == "h")|| ([lsearch $bacar_pins $old_pin_name] != -1))&& ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 1*$outl_x+$tmpx] $tmpy] -height 0.02
					if {(($orient == "h")|| ([lsearch $bacar_pins $old_pin_name] != -1))&& ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 2*$outl_x+$tmpx] $tmpy] -height 0.02
					if {(($orient == "h")|| ([lsearch $bacar_pins $old_pin_name] != -1))&& ([lsearch $net_dont_p $pin_name_h] == -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list [expr 3*$outl_x+$tmpx] $tmpy] -height 0.02
				}
			} else {
				if {$count == 1} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
				}
				if {$count == 2} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 1*$outl_y+$tmpy]] -height 0.02
				}
				if {$count == 3} {
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 1*$outl_y+$tmpy]] -height 0.02
					if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 2*$outl_y+$tmpy]] -height 0.02
				
				}
				if {$count == 4} {
					puts "pin_name_h = $pin_name_h" 
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx $tmpy] -height 0.02
					#if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 1*$outl_y+$tmpy]] -height 0.02
					#if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 2*$outl_y+$tmpy]] -height 0.02
					#if {([lsearch $bacar_pins $old_pin_name] != -1)} {set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]}
					set pin_name_h [plus_fin_char_count $pin_name_h $ports_without $count]
					le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "label"] -origin [list $tmpx [expr 3*$outl_y+$tmpy]] -height 0.02
				}
			}
		} else {
			lappend $port_does_exist $pin_name_h_lower
		}
	}
	set all_does_exist [list $port_does_exist $all_ports_ipv $all_ports_iph]
	puts "Finishing create ports without ipv opv"
	return $all_does_exist
}
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc rem_io {a} {
	set new_list [list]
	for {set i 0} {$i<[llength $a]} {incr i} {
 		set sf [string first "_ip" [lindex $a $i] ]
		set new_s1 [string range [lindex $a $i] 0 [expr $sf-1]]
		set new_s2 [string range [lindex $a $i] [expr $sf+4] [string length [lindex $a $i]] ]
		set new_s $new_s1$new_s2
		lappend new_list $new_s
		lappend new_list $new_s1
	}
	set ret_new [list]
	for {set i 0} {$i<[llength $new_list]} {incr i} {
		if {[lsearch $ret_new [lindex $new_list $i]] == -1} {
			lappend ret_new [lindex $new_list $i]
		}
	}
	return $ret_new
}


proc get_shapes_ip_suren {hs edd} {
	#puts "/////////////////////////////////////////WE are in get_shapes_ip_suren proc/////////////////////////////////////////////"
	set ports_inf [list]
	db::foreach hset $hs {
       	if {[db::getCount [de::getHighlighted -set $hset]] != 0} {
       		set sh [de::getHighlighted -set $hset]
			db::foreach hsets $sh {
				set hhh1 [db::getAttr type -of $hsets]
				set fig_attr [db::listAttrs -of $hsets]
				set fig_obj [db::getAttr object -of $hsets]
				set fig_obj_Num [db::getAttr layerNum -of $fig_obj]
				set fig_obj_box [db::getAttr bBox -of $fig_obj]
				set lay_pin_layer [oa::getName [oa::LayerFind [db::getAttr tech -of $edd ] $fig_obj_Num]]
				set p_inf [list $lay_pin_layer $fig_obj_box]
				lappend ports_inf $p_inf
			}
		}
	}
	return $ports_inf
}
#//////////////////////////////////////////////////////////////////////////////////////////////////
proc get_my_nets {xx lshape_name} {
	set new_xx [list]
	foreach ix $xx {
		set net_name [lindex $ix 0]
		set net_shapes [lindex $ix 1]
		set new_shapes1 [list]
		foreach i2 $net_shapes {
			if {[lsearch $lshape_name [lindex $i2 0]]!=-1} {
				if {[lsearch  $new_shapes1 $i2]==-1} {
					lappend new_shapes1 $i2
				}
			}
		}
		set tmp_l [list $net_name $new_shapes1]
		lappend new_xx $tmp_l
	}
	return $new_xx
}
#////////////////////////////////////////////////////////////////////////////////////
proc get_max_xy {xy} {
	set max 0
	set max_index 0
	for {set ix 0} {$ix<[llength $xy]} {incr ix} {
		if {[lindex $xy $ix]>$max} {
			set max [lindex $xy $ix]
			set max_index $ix
		}
	}
	return $max_index
}
#//////////////////////////////////////////////////////////////////////////////////////

proc max_xs {xx} { 
	set xy_list [list]
	foreach ix $xx {
		set net_shapes [lindex $ix 1]
		set tmp_max [expr [lindex [lindex $net_shapes 1] 0]-[lindex [lindex $net_shapes 0] 0]]
		lappend xy_list $tmp_max
	}
	return $xy_list
}
proc max_ys {xx} { 
	set xy_list [list]
	foreach ix $xx {
		set net_shapes [lindex $ix 1]
		set tmp_max [expr [lindex [lindex $net_shapes 1] 1]-[lindex [lindex $net_shapes 0] 1]]
		lappend xy_list $tmp_max
	}
	return $xy_list
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc get_cons_shape_iph {port_with_shapes_iph} {
	set new_final_list [list]
	for {set i 0} {$i<[llength $port_with_shapes_iph]} {incr i} {
		set tmp1 [lindex  $port_with_shapes_iph $i]
		set tmp2 [lindex $tmp1 1]
		set xs_max [max_xs $tmp2]
		set max_index_x [get_max_xy $xs_max]
		set tmp_name [lindex $tmp1 0]
		set tmp_fin [lindex $tmp2 $max_index_x]
		set tmp_list [list $tmp_name $tmp_fin]
		if {[lsearch $new_final_list $tmp_list] == -1} {
			lappend new_final_list $tmp_list
		}
	}
	return $new_final_list
}
proc get_cons_shape_ipv {port_with_shapes_ipv} {
	set new_final_list [list]
	for {set i 0} {$i<[llength $port_with_shapes_ipv]} {incr i} {
		set tmp1 [lindex  $port_with_shapes_ipv $i]
		set tmp2 [lindex $tmp1 1]
		set ys_max [max_ys $tmp2]
		set max_index_x [get_max_xy $ys_max]
		set tmp_name [lindex $tmp1 0]
		set tmp_fin [lindex $tmp2 $max_index_x]
		set tmp_list [list $tmp_name $tmp_fin]
		if {[lsearch $new_final_list $tmp_list] == -1} {
			lappend new_final_list $tmp_list
		}
	}
	return $new_final_list
}	
proc get_fin_char {stri} {
	set lx [string length $stri]
	set xi [string range $stri [expr $lx-1] $lx]
	return $xi
}	
proc plus_fin_char_count {stri all_ports count} {
	set pin_length [string length $stri]
	set pl1 [string range $stri [expr $pin_length -1] [expr $pin_length -1]]
	set pl12 [string range $stri [expr $pin_length -2] [expr $pin_length -1]]
	if {[string is integer $pl12] ==1} {
		set minco 2
	} elseif {[string is integer $pl1] ==1} {
		set minco 1
	} else {
		set minco 0
	}
	set new_st [string range $stri 0 [expr $pin_length -1-$minco]]
	set one_cell_pin_co 0
	for {set i 0} {$i<[llength $all_ports]} {incr i} {
		if {([regexp ^$new_st\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) } {
			set one_cell_pin_co [expr $one_cell_pin_co+1]
		}
	}
	puts "new_st = $new_st"
	set one_cell_pin_co [expr $one_cell_pin_co/$count]
	puts "one_cell_pin_co = $one_cell_pin_co"
	set tmp_stri $stri
	set xi [get_fin_char $stri]
	if {[string is integer $xi] == 1} {
		set xi [expr $xi+$one_cell_pin_co]
		set new_str [string range $stri 0 [expr [string length $stri]-2]]
		set new_str $new_str$xi
		return $new_str
	} else {
		return $tmp_stri
	}
}
proc plus_fin_char {stri all_ports count} {
	set tmp_stri $stri
	set xi [get_fin_char $stri]
	set lx [string length $stri]
	set xi_full [string range $stri 0 [expr $lx-2] ]
	set one_cell_pin_co 0
	for {set i 0} {$i<[llength $all_ports]} {incr i} {
		if {$i == 2 || $i == 3} {
			for {set ic 0} {$ic<[llength [lindex $all_ports $i]]} {incr ic} {
				if {([regexp ^$xi_full\[0-9\]$ [lindex [lindex $all_ports $i] $ic]] == 1)} {
					set one_cell_pin_co [expr $one_cell_pin_co+1]
				}
			}
		}
		
	}
	set one_cell_pin_co [expr $one_cell_pin_co/$count]
	if {[string is integer $xi] == 1} {
		set xi [expr $xi+$one_cell_pin_co]
		set new_str [string range $stri 0 [expr [string length $stri]-2]]
		set new_str $new_str$xi
		return $new_str
	} else {
		return $tmp_stri
	}
}
proc plus_fin_char_op {stri all_ports count} {

	set tmp_stri $stri
	set xi [get_fin_char $stri]
	puts "xi = $xi"
	set lx [string length $stri]
	set xi_full [string range $stri 0 [expr $lx-2] ]
	puts "xi_full = $xi_full"
	set one_cell_pin_co 0
	for {set i 0} {$i<[llength $all_ports]} {incr i} {
		if {$i == 5 || $i == 6} {
			puts "all_ports $i  = [lindex $all_ports $i]"
			for {set ic 0} {$ic<[llength [lindex $all_ports $i]]} {incr ic} {
				if {([regexp ^$xi_full\[0-9\]$ [lindex [lindex $all_ports $i] $ic]] == 1)} {
					set one_cell_pin_co [expr $one_cell_pin_co+1]
					puts "+1"
				}
			}
		}
		
	}
	puts "one_cell_pin_co = $one_cell_pin_co"
	set one_cell_pin_co [expr $one_cell_pin_co/$count]
	puts "one_cell_pin_co_after = $one_cell_pin_co"	
	
	#puts "xi = $xi"
	if {[string is integer $xi] == 1} {
		set xi [expr $xi+$one_cell_pin_co]
		#puts "xi+1 = $xi"
		set new_str [string range $stri 0 [expr [string length $stri]-2]]
		set new_str $new_str$xi
		#puts "new_str = $new_str"
		return $new_str
	} else {
		return $tmp_stri
	}
}


#//////////////////////////////////Creating ip op ports//////////////////////////////////////////////////////////////////////////////////////
proc port_ip {netlist edd lname cname count chcell_cellname orient} {
	puts "//////////////////////////////////////////////////WE are in port_ip procedure//////////////////////////////////////////////////////"
	global outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer	
	set layer_sram 	[list "COD_V" "EXCLVS" "M1 drawing5" "SRMD10" "COD_H" "OD_DA" "M1 drawing6" "PO1SRAM" "VIA0 drawing1" "VIA0 drawing2"]
	set layer_0_lev [list "PARAPOLY marker" "VT1_N internal" "VT2_N internal" "VT3_N internal" "VT4_N internal" "VT1_P internal" "VT2_P internal" "VT3_P internal" "VT4_P internal" "DIFF_CUT drawing" "LVTN drawing" "LVTP drawing" "M0DIFF2 drawing" "FIN_CUT drawing" "POLY_CUT drawing" "PPLUS drawing" "NPLUS drawing" "DIFF drawing" "VTL_N" "VTL_P" "FIN" "M5" "PODE" "FB_1" "VT2_P" "VT2_N" "TEXT" "NWELL drawing" "CA drawing"  "M0OD drawing" "CX drawing" "CMD drawing" "RC drawing" "M0OD drawing1" "FFB_1 drawing1" "M0PO drawing" "CB drawing" "R0 drawing" "R0BAR drawing" "VIA0 drawing" "CON1 drawing" "ALLDIFF drawing" "PDIFF drawing" "PSEL drawing" "PSELTAP drawing" "NDIFF drawing" "NSEL drawing" "NSELTAP drawing" "SR_DPO drawing" "CPO drawing" "CT drawing" "SR_DPO drawing" "PC drawing" "POLY drawing"]
	set layer_1_lev [list "M1 label"  "M1_E1 drawing" "M1_E2 drawing" "M1 drawing" "M4 label" "M3 label" "M2 label" "M1 label"]
	set layer_2_lev [list "M2 label" "V1BAR drawing" "VA12 drawing" "M2_E1 drawing" "M2_E2 drawing" "M2 drawing" "M4 label" "M3 label" "M2 label" "M1 label"]
	set layer_3_lev [list "M3 label" "V2BAR drawing" "VA23 drawing" "M3_E1 drawing" "M3_E2 drawing" "M3 drawing" "M4 label" "M3 label" "M2 label" "M1 label"]
	set layer_4_lev [list "M4 label" "J3BAR drawing" "J3 drawing" "VA34 drawing" "M4_E1 drawing" "M4_E2 drawing" "C4 drawing" "M4 drawing" "M4 label" "M3 label" "M2 label" "M1 label"]
	set layer_5_lev [list "M5 label" "A4BAR drawing" "A4 drawing" "VA45 drawing" "C5 drawing" "M5 drawing" "M4 label" "M3 label" "M2 label" "M1 label"]
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set all_ports [get_all_pins $netlist $chcell_cellname]
	set ports_iph [lindex $all_ports 3]
	set ports_iph_without [rem_io $ports_iph]
	set ports_ipv [lindex $all_ports 2]
	set ports_ipv_without [rem_io $ports_ipv]
	set port_with_shapes_iph [list]
	set port_with_shapes_ipv [list]
	puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Getting horizontal ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	LSV $layer_0_lev
	if {[llength $ports_iph] == 0} { 
		puts "That cell does not horizontal ip op ports" 
	} else {
		#puts "1+++"
		
		#LSV $layer_sram
		puts "2+++"
		set lay_port [db::getShapes -of $cell_dell  -filter {(%type=="Text" || %type=="AttrDisplay")   && (%layerNum==14 || %layerNum==16 || %layerNum==18 || %layerNum==20 )}]
		puts "lay_port = $lay_port"
		puts "3++++"
		set layAllTextPins [get_layout_pins_first $lay_port $cell_dell]
		puts "layAllTextPins = $layAllTextPins"
		for {set ix 0} {$ix<[llength $ports_iph_without]} {incr ix} {
			set tmpport [lindex $ports_iph_without $ix]
			de::fit
   			de::clearHighlights -design $edd
			set temp_high -1
			for {set i 0} {$i<[llength $layAllTextPins]} {incr i} {
				set c [lindex $layAllTextPins $i]
				set lvsnum [lindex $c 03]
				if {[lindex [lindex $c 0] 0] == $tmpport} {
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_3_lev  $layer_4_lev  $layer_1_lev]
						LSV $all_lay
					} 
					set pin_point1 [lindex [lindex $c 2] 0]
					set pin_point2 [lindex [lindex $c 2] 1]
					set x1 [expr [lindex $pin_point2 0]-[lindex $pin_point1 0]]
					set x1 [expr $x1/2]
					set x1 [expr $x1 + [lindex $pin_point1 0]]
					set y1 [expr [lindex $pin_point2 1]-[lindex $pin_point1 1]]
					set y1 [expr $y1/2]
					set y1 [expr $y1 + [lindex $pin_point1 1]]
					set pin_point [list $x1 $y1]
					gi::setField {stopLevel} -value {33} -in [gi::getToolbars {leHierarchy} -from [de::getActiveEditorWindow]]
					de::fit
					de::clearHighlights -design $edd
					ile::highlightConnected
					de::setCursor -point $pin_point
					de::addPoint $pin_point
        				de::abortCommand
					set hs [de::getHighlightSets  -design $edd]
					set shapes_ip [list $tmpport [get_shapes_ip_suren $hs $edd]]
					lappend port_with_shapes_iph $shapes_ip
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_3_lev  $layer_4_lev  $layer_1_lev]
						LSV $all_lay
					} 
					break
				}
			}
		}
		
		#LSV $layer_sram
		puts "end1+++"
	}
	
	puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Finish geting horizontal ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Geting vertical ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"	
	
	if {[llength $ports_ipv] == 0} { 
		puts "That cell does not vertical ip op ports" 
	} else {
		
		#LSV $layer_sram
		set lay_port [db::getShapes -of $cell_dell  -filter {(%type=="Text" || %type=="AttrDisplay")   && (%layerNum==14 || %layerNum==16 || %layerNum==18 || %layerNum==20 )}]
		set layAllTextPins [get_layout_pins_first $lay_port $cell_dell]
		puts "layAllTextPins = $layAllTextPins"
		for {set ix 0} {$ix<[llength $ports_ipv_without]} {incr ix} {
			set tmpport [lindex $ports_ipv_without $ix]
			de::fit
   			de::clearHighlights -design $edd
			set temp_high -1
			for {set i 0} {$i<[llength $layAllTextPins]} {incr i} {
				set c [lindex $layAllTextPins $i]
				set lvsnum [lindex $c 03]
				if {[lindex [lindex $c 0] 0] == $tmpport} {
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay $layer_1_lev
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_3_lev $layer_4_lev]
						LSV $all_lay
					}
					set pin_point1 [lindex [lindex $c 2] 0]
					set pin_point2 [lindex [lindex $c 2] 1]
					set x1 [expr [lindex $pin_point2 0]-[lindex $pin_point1 0]]
					set x1 [expr $x1/2]
					set x1 [expr $x1 + [lindex $pin_point1 0]]
					set y1 [expr [lindex $pin_point2 1]-[lindex $pin_point1 1]]
					set y1 [expr $y1/2]
					set y1 [expr $y1 + [lindex $pin_point1 1]]
					set pin_point [list $x1 $y1]
					gi::setField {stopLevel} -value {33} -in [gi::getToolbars {leHierarchy} -from [de::getActiveEditorWindow]]
					de::fit
					de::clearHighlights -design $edd
					ile::highlightConnected
					de::setCursor -point $pin_point
					de::addPoint $pin_point
       				de::abortCommand
					set hs [de::getHighlightSets  -design $edd]
					set shapes_ip [list $tmpport [get_shapes_ip_suren $hs $edd]]
					lappend port_with_shapes_ipv $shapes_ip
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay $layer_1_lev
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
					#puts "tmpport = $tmpport"
						set all_lay [concat $layer_3_lev $layer_4_lev]
						LSV $all_lay
					}
					break
				}
			}
		}
	}
	puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Finish getting vertical ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	set port_with_shapes_iph [get_my_nets $port_with_shapes_iph [list "M3" "M1" "M2"]]
	set port_with_shapes_ipv [get_my_nets $port_with_shapes_ipv [list "M2" "M1" "M4"]]
	set port_with_shapes_iph [get_cons_shape_iph $port_with_shapes_iph]
	set port_with_shapes_ipv [get_cons_shape_ipv $port_with_shapes_ipv]
	puts "\n\n\nport_with_shapes_ipv = $port_with_shapes_ipv\n\n"
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx_cell [lindex [lindex $bboxT 1] 0]
	set dy_cell [lindex [lindex $bboxT 1] 1]
	set ex_ipv [list]
	puts "count of port_with_shapes_ipv is [llength $port_with_shapes_ipv]"
	for {set i 0} {$i<[llength $port_with_shapes_ipv]} {incr i} {
		puts " $i -rd port_with_shapes_ipv is \n[lindex $port_with_shapes_ipv $i]"
		set tmp_port_h [lindex $port_with_shapes_ipv $i]
		set pin_name_h [lindex $tmp_port_h 0]
		set pin_length [string length $pin_name_h]
		set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
		set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
		if {[string is integer $pl12] ==1} {
			set sf [expr [string length $pin_name_h ]-2]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl1] ==1} {
			set sf [expr [string length $pin_name_h ]-1]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} else {
			set sf [string length $pin_name_h ]
			if {($count>1) && ($orient == "h")} {
				set new_s2 0
			} else {
				set new_s2 ""
			}
		}
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		set pin_name_oph $new_s1
		set pin_name_h   $new_s1
		append pin_name_oph "_opv"
		append pin_name_h   "_ipv"
		append pin_name_oph $new_s2
		append pin_name_h   $new_s2
		set pin_cod_h [lindex [lindex $tmp_port_h 1] 1]
		set pin_layer_h [lindex [lindex $tmp_port_h 1] 0]
		set x_origin_h [expr [lindex [lindex $pin_cod_h 1] 0]-[lindex [lindex $pin_cod_h 0] 0]]
		set x_origin_h [expr $x_origin_h/2+[lindex [lindex $pin_cod_h 0] 0]]
		set tmp_my_y [lindex [lindex $pin_cod_h 1] 1]
		if {$x_origin_h == ""} {
			set x_origin_h 0
		}
		if {$tmp_my_y == ""} {
			set tmp_my_y 0
		}
		
		if {$tmp_my_y<$dy_cell} {
			set end_op_y [expr $count*$tmp_my_y-0.005]
			puts "end_op_y = $end_op_y"
		} else {
			set end_op_y  [expr $count*$dy_cell-0.005]
		}
		set y_origin_h [expr [lindex [lindex $pin_cod_h 1] 1]-[lindex [lindex $pin_cod_h 0] 1]]
		if {$y_origin_h == ""} {
			set y_origin_h 0
		}
		
		if {$y_origin_h>=$dy_cell} { set y_origin_h $dy_cell}
		if {[lindex [lindex $pin_cod_h 0] 1]>0} { 
			set y_start_h [expr [lindex [lindex $pin_cod_h 0] 1]+0.005]
		} else {set y_start_h 0.005}
		if {$orient == "v"} {
			set ip_cood [list $x_origin_h $y_start_h]
			set op_cood [list $x_origin_h [expr $end_op_y]]
			set lvs_layer "$pin_layer_h"
			set xlvs_layer "$pin_layer_h"
			le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
			lappend ex_ipv $pin_name_h
			le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
		} else {
				if {$count == 1} {
				#////////////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_origin_h $y_start_h]
					set op_cood [list $x_origin_h $end_op_y]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 2} {
				#////////////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_origin_h $y_start_h]
					set op_cood [list $x_origin_h [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 3} {
				#////////////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_origin_h $y_start_h]
					set op_cood [list $x_origin_h [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-2)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-2)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=3///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 4} {
				#////////////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_origin_h $y_start_h]
					set op_cood [list $x_origin_h [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-3)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-3)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=3///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-2)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-2)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#////////////////////////////////////count=4///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] $y_start_h]
					set op_cood [list [expr ($count-1)*$dx_cell+$x_origin_h] [expr $dy_cell-0.005]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_ipv $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
			}
		}
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	set ex_iph [list]
	puts "count of port_with_shapes_iph is [llength $port_with_shapes_iph]"
	for {set i 0} {$i<[llength $port_with_shapes_iph]} {incr i} {
		puts " $i -rd port_with_shapes_iph is \n[lindex $port_with_shapes_iph $i]\n"
		set tmp_port_h [lindex $port_with_shapes_iph $i]
		set pin_name_h [lindex $tmp_port_h 0]
		set pin_length [string length $pin_name_h]
		set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
		set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
		if {[string is integer $pl12] ==1} {
			set sf [expr [string length $pin_name_h ]-2]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl1] ==1} {
			set sf [expr [string length $pin_name_h ]-1]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} else {
			set sf [string length $pin_name_h ]
			set new_s2 ""
		}
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		set pin_name_oph $new_s1
		set pin_name_h   $new_s1
		append pin_name_oph "_oph"
		append pin_name_h   "_iph"
		append pin_name_oph $new_s2
		append pin_name_h   $new_s2
		set pin_cod_h [lindex [lindex $tmp_port_h 1] 1]
		set pin_layer_h [lindex [lindex $tmp_port_h 1] 0]
		set y_origin_h [expr [lindex [lindex $pin_cod_h 1] 1]-[lindex [lindex $pin_cod_h 0] 1]]
		set y_origin_h [expr $y_origin_h/2+[lindex [lindex $pin_cod_h 0] 1]]
		set x_origin_h [expr [lindex [lindex $pin_cod_h 1] -0]-[lindex [lindex $pin_cod_h 0] 0]]
		if {$x_origin_h>=$dx_cell} { set x_origin_h $dx_cell}
		if {[lindex [lindex $pin_cod_h 0] 0]>0} { 
			set x_start_h [expr $dx_cell+0.05]
		} else {set x_start_h 0.005}
		if {$orient == "h"} {
			set ip_cood [list $x_start_h $y_origin_h]
			set op_cood [list [expr $count*$x_origin_h-0.005] $y_origin_h]
			set lvs_layer "$pin_layer_h"
			set xlvs_layer "$pin_layer_h"
			le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
			lappend ex_iph $pin_name_h
			le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
			 
		} else {
				
				#puts "////////////////////YOU ARE CHOOSE VERTICAL AND I AM CREATING IPH PORTS////////////////////"
				if {$count == 1} {
					set ip_cood [list $x_start_h $y_origin_h]
					set op_cood [list [expr $count*$x_origin_h-0.005] $y_origin_h]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 2} {
				#///////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_start_h $y_origin_h]
					set op_cood [list [expr $count*$x_origin_h-0.005] $y_origin_h]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////
					set pin_name_h [plus_fin_char $pin_name_h  $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph  $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-1)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-1)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 3} {
				#///////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_start_h $y_origin_h]
					set op_cood [list [expr $count*$x_origin_h-0.005] $y_origin_h]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////	
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-2)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-2)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=3///////////////////////////////////////////////////////////////////////////////	
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-1)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-1)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
				if {$count == 4} {
				#///////////////////////////////count=1///////////////////////////////////////////////////////////////////////////////
					set ip_cood [list $x_start_h $y_origin_h]
					set op_cood [list [expr $count*$x_origin_h-0.005] $y_origin_h]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=2///////////////////////////////////////////////////////////////////////////////	
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-3)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-3)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=3///////////////////////////////////////////////////////////////////////////////	
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-2)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-2)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				#///////////////////////////////count=4///////////////////////////////////////////////////////////////////////////////	
					set pin_name_h [plus_fin_char $pin_name_h $all_ports $count]
					set pin_name_oph [plus_fin_char_op $pin_name_oph $all_ports $count]
					set ip_cood [list $x_start_h [expr ($count-1)*$dy_cell+$y_origin_h]]
					set op_cood [list [expr $count*$x_origin_h-0.005] [expr ($count-1)*$dy_cell+$y_origin_h]]
					set lvs_layer "$pin_layer_h"
					set xlvs_layer "$pin_layer_h"
					le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "label"] -origin $ip_cood -height 0.02
					lappend ex_iph $pin_name_h
					le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "xlabel"] -origin $op_cood -height 0.02
				}
		}
	}
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	set d_ex_iph [list]
	foreach xc $ports_iph {
		if {[lsearch $ex_iph $xc] == -1} {
			lappend d_ex_iph $xc
		}
	}
	set d_ex_ipv [list]
	foreach xc $ports_ipv {
		if {[lsearch $ex_ipv $xc] == -1} {
			lappend d_ex_ipv $xc
		}
	}
	set ret_list [list $d_ex_iph $d_ex_ipv]
	return $ret_list
}
#////////////////////////////////////creating chcell cell and returning <design> for chcell cell////////////////////////////////////////
#//////////////////////////////creating chcell cell/////////////////////////////////////////////////////////////////////////////////////
proc create_chcell {chcell_cellname chcell_libname} {
	puts "Creating $chcell_cellname chcell "
	dm::createCell $chcell_cellname -libName $chcell_libname
	set chcell [dm::createCellView layout -cell [dm::getCells $chcell_cellname -libName $chcell_libname] -viewType maskLayout]
	puts "Open $chcell_cellname cell for changes"
	set ctx [de::open $chcell -readOnly false -headless false]
	set design [db::getAttr editDesign -of $ctx]
	return $design
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
source /remote/am04home1/arpih/bin/from_suren/chcell_maker_ss10/exceptions_array.tcl	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc main {netlist chcell_cellname chcell_libname or} {
	set res_char [regexp (char) $chcell_cellname]
	set res_red  [regexp (redgio) $chcell_cellname]
	if {($res_char == 0) } {
		set my_cell [get_lib_cell_names]
		set cell_name [lindex $my_cell 1]
		puts "my call name is $cell_name"
		set lib_name [lindex $my_cell 0]
		puts "my lib name is $lib_name"
		set count 4
		if {$or == "Horizontal"} {
			set orient "h"
		} else {
			set orient "v"
		}
		set err1 [set all_ports_main [get_all_pins $netlist $chcell_cellname]]
		if {$err1!=-1} {
			set count [lindex [lindex [lindex $all_ports_main 4] 1] 0]
			set desoa [create_chcell $chcell_cellname $chcell_libname]
			puts "Getting Metal Shapes"
			set metal_shapes [get_flatten_shapes $cell_name $lib_name]
			puts "\n//////////////////////////////Stsrting level 0//////////////////////////////////////////////////////////"
			set l0 [level0 $desoa $lib_name $cell_name $count $orient]
			if {$l0 != -1} {
				puts "level 0 is complate"
				puts "desoa = $desoa"
				puts "lib_name = $lib_name"
				puts "cell_name = $cell_name"
				puts "count = $count"
				puts "orient = $orient"
				puts "metal_shapes 0 = [lindex $metal_shapes 0]"
				level1 $desoa $lib_name $cell_name $count $orient [lindex $metal_shapes 0]
				puts "level 1 is complate"
				level2 $desoa $lib_name $cell_name $count $orient [lindex $metal_shapes 1] [lindex $metal_shapes 0]
				puts "level 2 is complate"
				level3 $desoa $lib_name $cell_name $count $orient [lindex $metal_shapes 2] [lindex $metal_shapes 1]
				puts "level 3 is complate"
				level4 $desoa $lib_name $cell_name $count $orient [lindex $metal_shapes 3] [lindex $metal_shapes 2]
				puts "level 4 is complate"
				level5 $desoa $lib_name $cell_name $count $orient
				puts "level 5 is complate"
				puts "//////////////////////////////Finish Creating Shapes And Starting Create Ports//////////////////////////////////////////////////////////\n"
				set p_does_exist [port_without $netlist $desoa $lib_name $cell_name $count $chcell_cellname $orient]
				set ip_does_exist [port_ip $netlist $desoa $lib_name $cell_name $count $chcell_cellname  $orient]
				puts "\n//////////////////////////////Finish Creating  Ports//////////////////////////////////////////////////////////////////////////////////\n"
				de::save $desoa
				set pd_ex [lindex $p_does_exist 0]
				set ipv_ex [lindex $ip_does_exist 1]
				set iph_ex [lindex $ip_does_exist 0]
				set dlg [gi::createDialog dialog1 \
                			-title "Status" \
                			-showApply 0 \
                			-showHelp 0]
      				set lbl [gi::createLabel label1 \
                			-parent $dlg \
                			-label " -----  Chcell Creating Complated Without Thats ports ----- "] 
				set lbl1 [gi::createLabel label11 \
                			-parent $dlg \
                			-label " -----  Ports without ipv or iph ----- $pd_ex \n  -----"] 
				set lbl2 [gi::createLabel label12 \
                			-parent $dlg \
                			-label " -----  Ports wit ipv ----- $ipv_ex \n  -----"] 
				set lbl3 [gi::createLabel label13 \
                			-parent $dlg \
                			-label " -----  Ports wit iph ----- $iph_ex \n  -----"] 
				db::destroy [dm::getCells for_chcell -libName $lib_name]
			}
	
		} else {
			errorMessage "Chcell Creating Abort"
		}
	} elseif {$res_char == 0} {
		puts "Running redgio chcell making"
		
	} else {
		puts "Running char chcell making"
		main_exp_char $netlist $chcell_cellname $chcell_libname $or
	}
}
