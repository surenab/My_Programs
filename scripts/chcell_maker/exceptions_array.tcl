set char_edge_lib 	"my_lib"
set char_edge_left_y  	"empty"
set char_edge_right_y 	"empty"
set char_edge_00	"empty"
set char_edge_01	"empty"
set char_edge_10	"empty"
set char_edge_11	"empty"
set char_edge_top   	"bulk"
set char_edge_bot   	"bulk"


proc get_x_y_main {lname cname main_layer} {


	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $main_layer ]
	if {[db::getCount $rec] == 1} {
		set bboxT [db::getAttr bBox -of $rec]
		set d [lindex $bboxT 1]
		#puts "d_1 = $d"
		return $d
	} else {
		if { [ catch { set instanceCollection [db::getInsts -of $cell_dell] } excpt] } {
			puts "Instance get failed\n$excpt"
			return
		} else {
			puts "Found [db::getCount $instanceCollection] instances\n"
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

	
		for {set i 0} {$i < [llength $cellnames]} {incr i} {
			set cell_delli [oa::DesignOpen [lindex $libnames $i] [lindex $cellnames $i] layout readOnly]
			set rec [db::getShapes -of $cell_delli -lpp $main_layer ]
			if {[db::getCount $rec] == 1} {
				set bboxT_x [db::getAttr width  -of $rec]
				set bboxT_y [db::getAttr height -of $rec]
				set bboxT [list $bboxT_x $bboxT_y]
				return $bboxT
			}
		}
	} 
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc exp_level0 {design lname cname rx cx } {

	global instb_layer outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer char_edge_lib char_edge_left_y char_edge_right_y char_edge_00 char_edge_01 char_edge_10 char_edge_11 char_edge_top char_edge_bot
	
	set const_countr $rx
	set const_countc $cx
	
	set bboxT [get_x_y_main $lname $cname $outl_layer]
	set dx [lindex $bboxT  0]
	#puts "dx = $dx"
	set dy [lindex $bboxT 1]
	#puts "dy = $dy"
	
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	set bboxT [get_x_y_main $char_edge_lib $char_edge_00 $instb_layer]
	set dx00 [expr 0-[lindex $bboxT 0]]
	#puts "dx00 = $dx00"
	set dy00 [expr 0-[lindex $bboxT 1]]
	#puts "dy00 = $dy00"
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	set bboxT [get_x_y_main $char_edge_lib $char_edge_01 $instb_layer]
	set dx01 [lindex $bboxT 0]
	set dy01 [lindex $bboxT 1]
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	set bboxT [get_x_y_main $char_edge_lib $char_edge_10 $instb_layer]
	set dx10 [lindex $bboxT 0]
	set dy10 [lindex $bboxT 1]
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	set bboxT [get_x_y_main $char_edge_lib $char_edge_11 $instb_layer]
	set dx11 [lindex $bboxT 0]
	set dy11 [lindex $bboxT 1]
	#//////////////Creating 00 edge//////////////////////////////////////////////////////////////////////////////////////////////////
	set point [list $dx00 $dy00 ]
	set point [list 0 0 ]
	le::createInst -design $design -origin $point -libName $char_edge_lib -cellName $char_edge_00  -viewName layout 
	#//////////////Creating 01 edge//////////////////////////////////////////////////////////////////////////////////////////////////
	set point [list 0 [expr $const_countr*$dy]  ]
	le::createInst -design $design -origin $point -libName $char_edge_lib -cellName $char_edge_01  -viewName layout -orient "MX"
	#//////////////Creating 10 edge//////////////////////////////////////////////////////////////////////////////////////////////////
	set point [list [expr $const_countc*$dx]  0 ]
	le::createInst -design $design -origin $point -libName $char_edge_lib -cellName $char_edge_10  -viewName layout -orient "MY"
	#//////////////Creating 11 edge//////////////////////////////////////////////////////////////////////////////////////////////////
	set point [list [expr $const_countc*$dx]  [expr $const_countr*$dy] ]
	le::createInst -design $design -origin $point -libName $char_edge_lib -cellName $char_edge_11  -viewName layout -orient "R180"
	#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	set ii $rx
	while {$ii} {
		le::createInst -design $design -origin [list 0 [expr ($ii-1)*$dy]] -libName $char_edge_lib -cellName $char_edge_left_y 	-viewName layout -orient "R0" -rows 1 -dy [expr $dy/2]
		set ii [expr $ii -1]
	}
	
	set ii $rx
	while {$ii} {
		le::createInst -design $design -origin [list [expr $const_countc*$dx] [expr ($ii-1)*$dy]] -libName $char_edge_lib -cellName $char_edge_right_y  	-viewName layout -orient "MY" -rows 1 -dy [expr $dy/2]
		set ii [expr $ii -1]
	}
	
	set ii $cx
	while {$ii} {
		le::createInst -design $design -origin [list [expr ($ii-1)*$dx] 0] -libName $char_edge_lib -cellName $char_edge_bot  	-viewName layout -orient "R0" -cols 2 -dx [expr $dx/2]
		set ii [expr $ii -1]
	}
	
	set ii $cx
	while {$ii} {
		le::createInst -design $design -origin [list [expr ($ii-1)*$dx] [expr $const_countr*$dy]] -libName $char_edge_lib -cellName $char_edge_top  	-viewName layout -orient "MX" -cols 2 -dx [expr $dx/2]
		set ii [expr $ii -1]
	}
	set x 0
	set y 0	
	set st_y $y
	set count1 $cx
	set count2 $rx
	#puts "count2 = $count2"
	#set const_count [expr { sqrt ($count) }]
	for {set i 0} {$i<$count2} {incr i} {
		for {set ij 0} {$ij<$count1} {incr ij} {
			#puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			set point [list $x $y ]
			le::createInst -design $design -origin $point -libName $lname -cellName $cname -viewName layout 
			#puts "Create $count -rd $cname cell in chcell"
			set x [expr $x+$dx]
			
		}
		#puts "--------------------------------------------------------------------------"
		set x 0
		set y [expr ($i+1)*$dy+$st_y]
		#puts "y = $y"
		#puts "new_count1 = $count1"
	}
	
	
	#puts "Created 0 shapes"
}
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////////////////////////Creating ports without ipv iph ports//////////////////////////////////////////////////////////////////
proc port_without_char16 {netlist edd lname cname  chcell_cellname } {
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
	#puts "outl_bbox = $outl_bbox"
	set outl_x [lindex [lindex $outl_bbox 1] 0]
	set outl_y [lindex [lindex $outl_bbox 1] 1]
	#puts "outl_x = $outl_x"
	
	set lay_ports [db::getShapes -of $cell_dell -filter {(%type=="Text" || %type=="AttrDisplay")  && (%layerNum==58 || %layerNum==59 || %layerNum==60 || %layerNum==48 )}]
	
	set port_info [list]
	db::foreach lay_pin $lay_ports {
		set lay_pin_name [db::getAttr text -of $lay_pin]
		#puts -nonewline "lay_pin_name = $lay_pin_name ---"
        	set lay_pin_name_lower [string tolower $lay_pin_name]
		set layerNum [db::getAttr layerNum -of $lay_pin]
        	set lay_pin_layer [oa::getName [oa::LayerFind [db::getAttr tech -of $edd ] $layerNum]]
		#puts -nonewline "lay_pin_layer = $lay_pin_layer ---"
		set origin [db::getAttr origin -of $lay_pin]
		#puts -nonewline "origin = $origin ---\n"
		set tmp [list $lay_pin_name $lay_pin_name_lower $lay_pin_layer $origin]
		lappend port_info $tmp 
	}
	set port_does_exist [list]
	#////////////////////////////////////////////////////////////////////////////////////////////
	#///////////////////////////////////////////////////////////////////////////////////////////////
	puts "Starting create port without ip and op in layout"
	for {set i 0} {$i<[llength $port_info]} {incr i} {
		
		set pin_name_h [lindex [lindex $port_info $i] 0]
		#puts "pin_name_h = $pin_name_h"
		
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
			if {([lsearch $bacar_pins $pin_name_h] != -1)} {
				set new_s2 0
			} else {
				set new_s2 ""
			}
		}
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		set pin_name_h   $new_s1
		set old_pin_name $pin_name_h
		#puts "pin_name_h1 = $pin_name_h"
		if {[lsearch $shape_power_pin $pin_name_h] == -1} { 
			append pin_name_h   $new_s2
		}
		#puts "pin_name_h_end = $pin_name_h" 
		set pin_name_h_lower [string tolower $pin_name_h]
		set tm_lists [list]
		if {([lsearch $ports_without $pin_name_h]!=-1) || ([lsearch $ports_without $pin_name_h_lower]!=-1)} { 
			set tmp_origin [lindex [lindex $port_info $i] 3]
			set tmpx [lindex $tmp_origin 0]
			#puts "tmpx = $tmpx"
			set tmpy [lindex $tmp_origin 1]
			#puts "tmpy = $tmpy"
			for {set iii 0} {$iii<4} {incr iii} {
				for {set j 0} {$j<4} {incr j} {
					if {[lsearch $tm_lists $pin_name_h] == -1} {
						le::createLabel $pin_name_h -parent $edd -lpp [list [lindex [lindex $port_info $i] 2] "drawing"] -origin [list [expr $j*$outl_x+$tmpx] [expr $iii*$outl_y+$tmpy]] -height 0.02
						lappend tm_lists $pin_name_h
					}
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
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////////////////////////////Function return high low left and rigth coordinat for that shapes////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

proc plus_fin_char_count_char16 {stri all_ports count} {
	set pin_length [string length $stri]
	set pl1 [string range $stri [expr $pin_length -1] [expr $pin_length -1]]
	set pl12 [string range $stri [expr $pin_length -2] [expr $pin_length -1]]
	set pl13 [string range $stri [expr $pin_length -3] [expr $pin_length -1]]
	set pl14 [string range $stri [expr $pin_length -4] [expr $pin_length -1]]
	set pl15 [string range $stri [expr $pin_length -5] [expr $pin_length -1]]
	set pl16 [string range $stri [expr $pin_length -6] [expr $pin_length -1]]
	
	
	
	if {[string is integer $pl16] ==1} {
		set minco 6
	} elseif {[string is integer $pl15] ==1} {
		set minco 5
	} elseif {[string is integer $pl14] ==1} {
		set minco 4
	} elseif {[string is integer $pl13] ==1} {
		set minco 3
	} elseif {[string is integer $pl12] ==1} {
		set minco 2
	} elseif {[string is integer $pl1] ==1} {
		set minco 1
	} else {
		set minco 0
	}
	set new_st [string range $stri 0 [expr $pin_length -1-$minco]]
	#puts "plus fin->new_st = $new_st"
	
	set one_cell_pin_co 0
	for {set i 0} {$i<[llength $all_ports]} {incr i} {
		#puts "all_ports $i  = [lindex $all_ports $i]"
		
		if {([regexp ^$new_st\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) || ([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex $all_ports $i]] == 1) } {
			set one_cell_pin_co [expr $one_cell_pin_co+1]
		}
		
	}
	set one_cell_pin_co [expr $one_cell_pin_co/$count]
	
	#puts "one_cell_pin_co = $one_cell_pin_co"
	
	
	set tmp_stri $stri
	#puts "stri=$stri"
	
	if {([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ $stri] == 1) } {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-6] $lx]
		set new_str [string range $stri 0 end-6]
		#puts "2 numb xi=$xi"
	} elseif {([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ $stri] == 1) } {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-5] $lx]
		set new_str [string range $stri 0 end-5]
		#puts "2 numb xi=$xi"
	} elseif {([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ $stri] == 1) } {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-4] $lx]
		set new_str [string range $stri 0 end-4]
		#puts "2 numb xi=$xi"
	} elseif {([regexp ^$new_st\[0-9\]\[0-9\]\[0-9\]$ $stri] == 1) } {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-3] $lx]
		set new_str [string range $stri 0 end-3]
		#puts "2 numb xi=$xi"
	} elseif {([regexp ^$new_st\[0-9\]\[0-9\]$ $stri] == 1) } {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-2] $lx]
		set new_str [string range $stri 0 end-2]
		#puts "2 numb xi=$xi"
	} else {
		set lx [string length $stri]
		set xi [string range $stri [expr $lx-1] $lx]
		set new_str [string range $stri 0 end-1]
		#puts "1 numb xi=$xi"
	}
	#puts "xi = $xi"
	if {[string is integer $xi] == 1} {
		set xi [expr $xi+$one_cell_pin_co]
		#puts "xi+1 = $xi"
		#set new_str [string range $stri 0 [expr [string length $stri]-3]]
		#puts "befor new_str=$new_str" 
		set new_str $new_str$xi
		#puts "after new_str=$new_str"
		#puts "new_str = $new_str"
		return $new_str
	} else {
		return $tmp_stri
	}
}




proc port_ip_char16 {netlist edd lname cname  chcell_cellname rx cx} {
	puts "//////////////////////////////////////////////////WE are in port_ip procedure//////////////////////////////////////////////////////"
	global outl_layer m1_layer m2_layer m3_layer m4_layer m5_layer	
	set layer_sram 	[list "COD_V" "EXCLVS" "M1 drawing5" "SRMD10" "COD_H" "OD_DA" "M1 drawing6" "PO1SRAM" "VIA0 drawing1" "VIA0 drawing2" "M2 drawing6" "M2 drawing5" "ARY drawing" "FB_SRM drawing1" "VIA0 drawing8" "VTS_P drawing" "VTS_N drawing" "INST_B drawing"]
	set layer_0_lev [list "VTL_N" "VTL_P" "FIN" "M5" "PODE" "FB_1" "VT2_P" "VT2_N" "TEXT" "NWELL drawing" "CA drawing"  "M0OD drawing" "CX drawing" "CMD drawing" "RC drawing" "M0OD drawing1" "FFB_1 drawing1" "M0PO drawing" "CB drawing" "R0 drawing" "R0BAR drawing" "VIA0 drawing" "CON1 drawing" "ALLDIFF drawing" "PDIFF drawing" "PSEL drawing" "PSELTAP drawing" "NDIFF drawing" "NSEL drawing" "NSELTAP drawing" "SR_DPO drawing" "CPO drawing" "CT drawing" "SR_DPO drawing" "PC drawing" "POLY drawing"]
	set layer_1_lev [list "LVSM1 drawing"  "M1_E1 drawing" "M1_E2 drawing" "M1 drawing"]
	set layer_2_lev [list "LVSM2 drawing" "V1BAR drawing" "VA12 drawing" "M2_E1 drawing" "M2_E2 drawing" "M2 drawing"]
	set layer_3_lev [list "LVSM3 drawing" "V2BAR drawing" "VA23 drawing" "M3_E1 drawing" "M3_E2 drawing" "M3 drawing"]
	set layer_4_lev [list "LVSM4 drawing" "J3BAR drawing" "J3 drawing" "VA34 drawing" "M4_E1 drawing" "M4_E2 drawing" "C4 drawing" "M4 drawing"]
	set layer_5_lev [list "LVSM5 drawing" "A4BAR drawing" "A4 drawing" "VA45 drawing" "C5 drawing" "M5 drawing"]
	
	
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set all_ports [get_all_pins $netlist $chcell_cellname]
	set ports_iph [lindex $all_ports 3]
	set ports_iph_without [rem_io $ports_iph]
	set ports_ipv [lindex $all_ports 2]
	set ports_opv [lindex $all_ports 6]
	set ports_oph [lindex $all_ports 5]
	set ports_ipv_without [rem_io $ports_ipv]
	set port_with_shapes_iph [list]
	set port_with_shapes_ipv [list]
	puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Getting horizontal ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	if {[llength $ports_iph] == 0} { 
		puts "That cell does not horizontal ip op ports" 
	} else {
		set get_pins_origin_h [list]
		set get_pins_origin_h_name [list]
		set get_pins_origin_h_point [list]
		LSV $layer_0_lev
		LSV $layer_sram
		set lay_port [db::getShapes -of $cell_dell  -filter {(%type=="Text" || %type=="AttrDisplay")   && (%layerNum==58 || %layerNum==59 || %layerNum==60 || %layerNum==48 )}]
		set layAllTextPins [get_layout_pins_suren $lay_port $cell_dell]
		for {set ix 0} {$ix<[llength $ports_iph_without]} {incr ix} {
			set tmpport [lindex $ports_iph_without $ix]
			#puts "tmpport = $tmpport"
			de::fit
    			de::clearHighlights -design $edd
			set temp_high -1
			for {set i 0} {$i<[llength $layAllTextPins]} {incr i} {
				set c [lindex $layAllTextPins $i]
				#puts "c = $c"
				#puts "c00 = [lindex [lindex $c 0] 0]"
				set lvsnum [lindex $c 03]
				if {[lindex [lindex $c 0] 0] == $tmpport} {
					#set pin_point [lindex [lindex $c 2] 0]
					
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_1_lev $layer_3_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==1 } {
						set all_lay [concat $layer_2_lev $layer_3_lev $layer_4_lev ]
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
					lappend get_pins_origin_h_name [lindex [lindex $c 0] 0]
					lappend get_pins_origin_h_point   $pin_point
					#puts "pin_point = $pin_point"
					gi::setField {stopLevel} -value {33} -in [gi::getToolbars {leHierarchy} -from [de::getActiveEditorWindow]]
					de::fit
					#puts "clear high"
					de::clearHighlights -design $edd
					ile::highlightConnected
					de::setCursor -point $pin_point
					
					
					
					if {$cx>1024 || $rx>1024} {
						de::zoom -factor 300 -center [de::getCursor]
					} elseif {$cx>512 || $rx>512} {
						de::zoom -factor 65 -center [de::getCursor] 
					} elseif {$cx>128 || $rx>128 } {
						de::zoom -factor 25 -center [de::getCursor]
					} else {
						de::zoom -factor 10 -center [de::getCursor]
					}
					
					de::addPoint $pin_point
					#after 1000
        				de::abortCommand
					#puts "high"
					set hs [de::getHighlightSets  -design $edd]
					#puts "hs = $hs"
					set shapes_ip [list $tmpport [get_shapes_ip_suren $hs $edd]]
					lappend port_with_shapes_iph $shapes_ip
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_1_lev $layer_3_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==1 } {
						set all_lay [concat $layer_2_lev $layer_3_lev $layer_4_lev ]
						LSV $all_lay
					}	
					
					break
					
				}
				
				
			}
		}
		
		LSV $layer_0_lev
		LSV $layer_sram
	}
	lappend get_pins_origin_h [list $get_pins_origin_h_name $get_pins_origin_h_point]
	#puts "get_pins_origin_h = $get_pins_origin_h"
	puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Finish geting horizontal ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Geting vertical ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"	
	if {[llength $ports_ipv] == 0} { 
		puts "That cell does not vertical ip op ports" 
	} else {
		set get_pins_origin_v [list]
		set get_pins_origin_v_name [list]
		set get_pins_origin_v_point [list]
		LSV $layer_0_lev
		LSV $layer_sram
		set lay_port [db::getShapes -of $cell_dell  -filter {(%type=="Text" || %type=="AttrDisplay")   && (%layerNum==58 || %layerNum==59 || %layerNum==60 || %layerNum==48 )}]
		set layAllTextPins [get_layout_pins_suren $lay_port $cell_dell]
		#puts "layAllTextPins = $layAllTextPins"
		#set layAllTextPins [cleanup_layout_pins_suren $layAllTextPins]
		#puts "layAllTextPins = $layAllTextPins"
		for {set ix 0} {$ix<[llength $ports_ipv_without]} {incr ix} {
			set tmpport [lindex $ports_ipv_without $ix]
			#puts "tmpport = $tmpport"
			de::fit
    			de::clearHighlights -design $edd
			set temp_high -1
			for {set i 0} {$i<[llength $layAllTextPins]} {incr i} {
				set c [lindex $layAllTextPins $i]
				#puts "c = $c"
				#puts "c00 = [lindex [lindex $c 0] 0]"
				set lvsnum [lindex $c 03]
				if {[lindex [lindex $c 0] 0] == $tmpport} {
					
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_1_lev $layer_3_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==1 } {
						set all_lay [concat $layer_3_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					}
					#set pin_point [lindex [lindex $c 2] 0]
					set pin_point1 [lindex [lindex $c 2] 0]
					set pin_point2 [lindex [lindex $c 2] 1]
					set x1 [expr [lindex $pin_point2 0]-[lindex $pin_point1 0]]
					set x1 [expr $x1/2]
					set x1 [expr $x1 + [lindex $pin_point1 0]]
					set y1 [expr [lindex $pin_point2 1]-[lindex $pin_point1 1]]
					set y1 [expr $y1/2]
					set y1 [expr $y1 + [lindex $pin_point1 1]]
					set pin_point [list $x1 $y1]
					lappend get_pins_origin_v_name [lindex [lindex $c 0] 0]
					lappend get_pins_origin_v_point   $pin_point
					#puts "$tmpport point is $pin_point"
					gi::setField {stopLevel} -value {33} -in [gi::getToolbars {leHierarchy} -from [de::getActiveEditorWindow]]
					de::fit
					#puts "clear high"
					de::clearHighlights -design $edd
					ile::highlightConnected
					de::setCursor -point $pin_point
					
					if {$cx>1024 || $rx>1024} {
						de::zoom -factor 300 -center [de::getCursor]
					} elseif {$cx>512 || $rx>512} {
						de::zoom -factor 65 -center [de::getCursor] 
					} elseif {$cx>128 || $rx>128 } {
						de::zoom -factor 25 -center [de::getCursor]
					} else {
						de::zoom -factor 10 -center [de::getCursor]
					}
					
					de::addPoint $pin_point
        				de::abortCommand
					#puts "high"
					
					set hs [de::getHighlightSets  -design $edd] 
					#puts "hs = $hs"
					set shapes_ip [list $tmpport [get_shapes_ip_suren $hs $edd]]
					lappend port_with_shapes_ipv $shapes_ip
					if {$lvsnum ==4 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_3_lev ]
						LSV $all_lay
					} elseif {$lvsnum ==3 } {
						set all_lay [concat $layer_1_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==2 } {
						set all_lay [concat $layer_1_lev $layer_3_lev $layer_4_lev ]
						LSV $all_lay
					
					} elseif {$lvsnum ==1 } {
						set all_lay [concat $layer_3_lev $layer_2_lev $layer_4_lev ]
						LSV $all_lay
					}
					
					break
				}
				
				
			}
		}
		#LSV $layer_0_lev
		#LSV $layer_sram
	}
	lappend get_pins_origin_v [list $get_pins_origin_v_name $get_pins_origin_v_point]
	#puts "get_pins_origin_v = $get_pins_origin_v"
	puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Finish getting vertical ip op ports>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	#puts "port_with_shapes_ipv BEFORE= $port_with_shapes_ipv"
	#puts "port_with_shapes_iph_BEFORE = $port_with_shapes_iph"
	set port_with_shapes_iph [get_my_nets $port_with_shapes_iph [list "M3" "M1" "M2"]]
	set port_with_shapes_ipv [get_my_nets $port_with_shapes_ipv [list "M2" "M1" "M4"]]
	#puts "port_with_shapes_ipv_MIDLE = $port_with_shapes_ipv"
	#puts "port_with_shapes_iph_MIDDLE = $port_with_shapes_iph"
	set port_with_shapes_iph [get_cons_shape_iph $port_with_shapes_iph]
	set port_with_shapes_ipv [get_cons_shape_ipv $port_with_shapes_ipv]
	#puts "port_with_shapes_iph_after = $port_with_shapes_iph"
	#puts "port_with_shapes_ipv_after = $port_with_shapes_ipv"
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
	set bboxT [db::getAttr bBox -of $rec]
	set dx_cell [lindex [lindex $bboxT 1] 0]
	set dy_cell [lindex [lindex $bboxT 1] 1]
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	set ex_ipv [list]
	#puts "count of port_with_shapes_ipv is [llength $port_with_shapes_ipv]"
	for {set i 0} {$i<[llength $port_with_shapes_ipv]} {incr i} {
		#puts " $i -rd port_with_shapes_ipv is \n[lindex $port_with_shapes_ipv $i]"
		set tmp_port_h [lindex $port_with_shapes_ipv $i]
		#puts "tmp_port_h = $tmp_port_h"
		set pin_name_h [lindex $tmp_port_h 0]
		#puts "-----------------------------------------------------------------"
		#puts "pin_name_h = $pin_name_h"
		#puts "-----------------------------------------------------------------"		
		set pin_length [string length $pin_name_h]
		set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
		set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
		set pl13 [string range $pin_name_h [expr $pin_length -3] [expr $pin_length -1]]
		set pl14 [string range $pin_name_h [expr $pin_length -4] [expr $pin_length -1]]
		set pl15 [string range $pin_name_h [expr $pin_length -5] [expr $pin_length -1]]
		set pl16 [string range $pin_name_h [expr $pin_length -6] [expr $pin_length -1]]
		
		if {[string is integer $pl16] ==1} {
			set sf [expr [string length $pin_name_h ]-6]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl15] ==1} {
			set sf [expr [string length $pin_name_h ]-5]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl14] ==1} {
			set sf [expr [string length $pin_name_h ]-4]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl13] ==1} {
			set sf [expr [string length $pin_name_h ]-3]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl12] ==1} {
			set sf [expr [string length $pin_name_h ]-2]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl1] ==1} {
			set sf [expr [string length $pin_name_h ]-1]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} else {
			set sf [string length $pin_name_h ]
			set new_s2 0			
		}
		#puts "sf = $sf"
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		#puts "new_s1=$new_s1"
		set pin_name_oph $new_s1
		set pin_name_h   $new_s1
		#puts "pin_name_h1 = $pin_name_h" 
		#puts "pin_name_oph1 = $pin_name_oph"
		append pin_name_oph "_opv"
		append pin_name_h   "_ipv"
		#puts "pin_name_h2 = $pin_name_h"
		#puts "pin_name_oph2 = $pin_name_oph" 
		
		append pin_name_oph $new_s2
		append pin_name_h   $new_s2
		#puts "pin_name_h = $pin_name_h" 
		#puts "pin_name_oph = $pin_name_oph" 
		
		
		
		set pin_cod_h [lindex [lindex $tmp_port_h 1] 1]
		#puts "pin_cod_h = $pin_cod_h"
		set pin_layer_h [lindex [lindex $tmp_port_h 1] 0]
		#puts "pin_layer_h = $pin_layer_h"
		
		set x_origin_h [expr [lindex [lindex $pin_cod_h 1] 0]-[lindex [lindex $pin_cod_h 0] 0]]
		#puts "x_origin_h = $x_origin_h"
		set x_origin_h [expr $x_origin_h/2+[lindex [lindex $pin_cod_h 0] 0]]
		#puts "x_origin_h = $x_origin_h"
		
		set tmp_my_y [lindex [lindex $pin_cod_h 1] 1]
		
		#puts "dy_cell = $dy_cell"
		#puts "tmp_my_y = $tmp_my_y"
		 
		if {$tmp_my_y<$dy_cell} {
			set end_op_y [expr $rx*$tmp_my_y-0.005]
			#puts "end_op_y = $end_op_y"
		} else {
			set end_op_y  [expr $rx*$dy_cell-0.005]
		}
		
		set y_origin_h [expr [lindex [lindex $pin_cod_h 1] 1]-[lindex [lindex $pin_cod_h 0] 1]]
		#puts "x_origin_h = $x_origin_h"
		
		if {$y_origin_h>=$dy_cell} { set y_origin_h $dy_cell}
		#puts "x_origin_h = $x_origin_h"
		
		if {[lindex [lindex $pin_cod_h 0] 1]>0} { 
			set y_start_h [expr [lindex [lindex $pin_cod_h 0] 1]+0.005]
		} else {set y_start_h 0.005}
		
		#puts "x_start_h = $x_start_h"
		
			
		#puts "////////////////////YOU ARE CHOOSE HORIZONTAL AND I AM CREATING IPV PORTS////////////////////\n"
		#puts "cx = $cx"	
		for {set ix 0} {$ix<$cx} {incr ix} {
			#puts "----------------------------------------------------------\n-----cx i-rd $cx -----\n------------------------------------------------------------------------"  
			#puts "\n---------------------------------------------------------------\n pin_name_h = $pin_name_h"
			
			if {[string is integer [string range $pin_name_h end-6 end ]]== 1} {
				set index_f [string range $pin_name_h end-6 end ]
			} elseif {[string is integer [string range $pin_name_h end-5 end ]]== 1} {
				set index_f [string range $pin_name_h end-5 end ]
			} elseif {[string is integer [string range $pin_name_h end-4 end ]]== 1} {
				set index_f [string range $pin_name_h end-4 end ]
			} elseif {[string is integer [string range $pin_name_h end-3 end ]]== 1} {
				set index_f [string range $pin_name_h end-3 end ]
			} elseif {[string is integer [string range $pin_name_h end-2 end ]]== 1} {
				set index_f [string range $pin_name_h end-2 end ]
			} elseif {[string is integer [string range $pin_name_h end-1 end ]]== 1} {
				set index_f [string range $pin_name_h end-1 end ]
			} elseif {[string is integer [string range $pin_name_h end end ]]== 1} {
				set index_f [string range $pin_name_h end end ]
			}
			#puts "index_f = $index_f"
			set pin_length [string length $pin_name_h]
			set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
			set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
			set pl13 [string range $pin_name_h [expr $pin_length -3] [expr $pin_length -1]]
			set pl14 [string range $pin_name_h [expr $pin_length -4] [expr $pin_length -1]]
			set pl15 [string range $pin_name_h [expr $pin_length -5] [expr $pin_length -1]]
			set pl16 [string range $pin_name_h [expr $pin_length -6] [expr $pin_length -1]]
			
			
			
			
			
			
			if {[string is integer $pl16] ==1} {
				set minco 6
			} elseif {[string is integer $pl15] ==1} {
				set minco 5
			} elseif {[string is integer $pl14] ==1} {
				set minco 4
			} elseif {[string is integer $pl13] ==1} {
				set minco 3
			} elseif {[string is integer $pl12] ==1} {
				set minco 2
			} elseif {[string is integer $pl1] ==1} {
				set minco 1
			} else {
				set minco 0
			}
			
			set new_st [string range $pin_name_h 0 [expr $pin_length -4-$minco]]
			#puts "new_st = $new_st"
	
			set one_cell_pin_co 0
			#puts "all_ports = [lindex $all_ports 0]"
			for {set in 0} {$in<[llength [lindex $all_ports 0]]} {incr in} {
			#puts "all_ports $i  = [lindex $all_ports $i]"
				set nnn "ipv"
				set nnn $new_st$nnn
				if {([regexp ^$nnn\[0-9\]$ [lindex [lindex $all_ports 0] $in ]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1)} {
					set one_cell_pin_co [expr $one_cell_pin_co+1]
					#puts "+1"
				}
		
			}
			set one_cell_pin_co [expr $one_cell_pin_co/$cx]
			#puts "one_cell_pin_co = $one_cell_pin_co"
			if {$one_cell_pin_co != 0} {
				set pport_num [expr $index_f%$one_cell_pin_co]
			} else {
				set pport_num $index_f
			}
			#puts "pport_num = $pport_num"
			if {$one_cell_pin_co != 0} {
				set tmp_et [expr $index_f%$one_cell_pin_co]
				set pport_count [expr ($index_f-$tmp_et)/$one_cell_pin_co]
			} else {
				set pport_count 0
			}
			#puts "pport_count = $pport_count"
			set new_st [string range $new_st 0 end-1]
			set new_x_port $new_st$pport_num
			#puts "new_x_port = $new_x_port"
			set index2 [lsearch [lindex [lindex $get_pins_origin_v 0] 0 ] $new_x_port]
			#puts "index2 = $index2"
			set coodx [lindex [lindex [lindex $get_pins_origin_v 0] 1] $index2]
			#puts "coodx = $coodx"
			
			#puts "index_f = $index_f -----;;;;;;;;;;------ one_cell_pin_co = $one_cell_pin_co"
			
			
			
			if {$ix != 0} {
				set or_x [expr [lindex $coodx 0]+($pport_count+1)*$dx_cell]
				#puts "+1"
			} else {
				set or_x [lindex $coodx 0]
			}
			
			set or_cood [list $or_x [lindex $coodx 1]]
			#puts "or_cood = $or_cood \n"
			#puts "created 2 pin names" 
	       		set ip_cood [list [expr $ix*$dx_cell+$x_origin_h] $y_start_h]
	       		set op_cood [list [expr $ix*$dx_cell+$x_origin_h] [expr $rx*$dy_cell-0.005]]
			
			
	       		set lvs_layer "LVS$pin_layer_h"
	       		set xlvs_layer "XLVS$pin_layer_h"
			if {[lindex $or_cood 1] != ""} {
				#puts "+1"
				#puts "or_cood1 = [lindex $or_cood 1]"
				set ip_cood $or_cood
				set op_cood [list [lindex $or_cood 0] [expr $rx*$dy_cell-0.005]]
	       		}
			#puts "op_cood = $op_cood"
			#puts "ip_cood = $ip_cood \n--------------------------------------------------------------------------------------" 
			if {$ix == 0} {
				
	       			set lvs_layer "LVS$pin_layer_h"
	       			set xlvs_layer "XLVS$pin_layer_h"
	       			le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "drawing"] -origin $ip_cood -height 0.02
	       			lappend ex_ipv $pin_name_h
	       			le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "drawing"] -origin $op_cood -height 0.02
			} else {
				
				
				
				set pin_name_h [plus_fin_char_count_char16 $pin_name_h $ports_ipv $cx]
	       			set pin_name_oph [plus_fin_char_count_char16 $pin_name_oph $ports_opv $cx]
			
				le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "drawing"] -origin $ip_cood -height 0.02
	       			lappend ex_ipv $pin_name_h
	       			le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "drawing"] -origin $op_cood -height 0.02

			}
		}
		
		
	}
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	set ex_iph [list]
	#puts "count of port_with_shapes_iph is [llength $port_with_shapes_iph]"
	for {set i 0} {$i<[llength $port_with_shapes_iph]} {incr i} {
		#puts " $i -rd port_with_shapes_iph is \n[lindex $port_with_shapes_iph $i]\n"
		set tmp_port_h [lindex $port_with_shapes_iph $i]
		#puts "tmp_port_h = $tmp_port_h"
		set pin_name_h [lindex $tmp_port_h 0]
		#puts "pin_name_h = $pin_name_h"
		#set p_ind_h [lsearch $ports_iph_without $pin_name_h]
		#puts "p_ind_h = $p_ind_h"
		
		#puts "pin_name_h_after = $pin_name_h"
		
		set pin_length [string length $pin_name_h]
		set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
		set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
		set pl13 [string range $pin_name_h [expr $pin_length -3] [expr $pin_length -1]]
		set pl14 [string range $pin_name_h [expr $pin_length -4] [expr $pin_length -1]]
		set pl15 [string range $pin_name_h [expr $pin_length -5] [expr $pin_length -1]]
		set pl16 [string range $pin_name_h [expr $pin_length -6] [expr $pin_length -1]]
			
		
		
		if {[string is integer $pl16] ==1} {
			set sf [expr [string length $pin_name_h ]-6]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl15] ==1} {
			set sf [expr [string length $pin_name_h ]-5]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl14] ==1} {
			set sf [expr [string length $pin_name_h ]-4]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl13] ==1} {
			set sf [expr [string length $pin_name_h ]-3]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl12] ==1} {
			set sf [expr [string length $pin_name_h ]-2]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} elseif {[string is integer $pl1] ==1} {
			set sf [expr [string length $pin_name_h ]-1]
			set new_s2 [string range $pin_name_h [expr $sf] [expr [string length $pin_name_h]-1] ]
		} else {
			set sf [string length $pin_name_h ]
			set new_s2 0			
		}
		
		#puts "sf = $sf"
		set new_s1 [string range $pin_name_h 0 [expr $sf-1]]
		#puts "new_s1 = $new_s1" 
		#set new_s2 [string range $pin_name_h [expr $sf+3] [expr [string length $pin_name_h]-1] ]
		#puts "new_s2 = $new_s2" 
		set pin_name_oph $new_s1
		set pin_name_h   $new_s1
		#puts "pin_name_h1 = $pin_name_h" 
		#puts "pin_name_oph1 = $pin_name_oph"
		append pin_name_oph "_oph"
		append pin_name_h   "_iph"
		#puts "pin_name_h2 = $pin_name_h"
		#puts "pin_name_oph2 = $pin_name_oph" 
		append pin_name_oph $new_s2
		append pin_name_h   $new_s2
		#puts "pin_name_h3 = $pin_name_h" 
		#puts "pin_name_oph3 = $pin_name_oph" 
		
		
		#puts "pin_name_h = $pin_name_h"
		set pin_cod_h [lindex [lindex $tmp_port_h 1] 1]
		#puts "pin_cod_h = $pin_cod_h"
		set pin_layer_h [lindex [lindex $tmp_port_h 1] 0]
		#puts "pin_layer_h = $pin_layer_h"
		
		set y_origin_h [expr [lindex [lindex $pin_cod_h 1] 1]-[lindex [lindex $pin_cod_h 0] 1]]
		#puts "y_origin_h = $y_origin_h"
		set y_origin_h [expr $y_origin_h/2+[lindex [lindex $pin_cod_h 0] 1]]
		#puts "y_origin_h = $y_origin_h"
		
		
		set x_origin_h [expr [lindex [lindex $pin_cod_h 1] -0]-[lindex [lindex $pin_cod_h 0] 0]]
		#puts "x_origin_h = $x_origin_h"
		
		if {$x_origin_h>=$dx_cell} { set x_origin_h $dx_cell}
		#puts "x_origin_h = $x_origin_h"
		
		if {[lindex [lindex $pin_cod_h 0] 0]>0} { 
			set x_start_h [expr $dx_cell+0.05]
		} else {set x_start_h 0.005}
		
		#puts "x_start_h = $x_start_h"
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
		for {set ix 0} {$ix<$rx} {incr ix} {
			#puts "rx i = $ix"
			#puts "\n---------------------------------------------------------------\n pin_name_h = $pin_name_h"
			if {[string is integer [string range $pin_name_h end-6 end ]]== 1} {
				set index_f [string range $pin_name_h end-6 end ]
			} elseif {[string is integer [string range $pin_name_h end-5 end ]]== 1} {
				set index_f [string range $pin_name_h end-5 end ]
			} elseif {[string is integer [string range $pin_name_h end-4 end ]]== 1} {
				set index_f [string range $pin_name_h end-4 end ]
			} elseif {[string is integer [string range $pin_name_h end-3 end ]]== 1} {
				set index_f [string range $pin_name_h end-3 end ]
			} elseif {[string is integer [string range $pin_name_h end-2 end ]]== 1} {
				set index_f [string range $pin_name_h end-2 end ]
			} elseif {[string is integer [string range $pin_name_h end-1 end ]]== 1} {
				set index_f [string range $pin_name_h end-1 end ]
			} elseif {[string is integer [string range $pin_name_h end end ]]== 1} {
				set index_f [string range $pin_name_h end end ]
			}
			#puts "index_f = $index_f"
			set pin_length [string length $pin_name_h]
			set pl1 [string range $pin_name_h [expr $pin_length -1] [expr $pin_length -1]]
			set pl12 [string range $pin_name_h [expr $pin_length -2] [expr $pin_length -1]]
			set pl13 [string range $pin_name_h [expr $pin_length -3] [expr $pin_length -1]]
			set pl14 [string range $pin_name_h [expr $pin_length -4] [expr $pin_length -1]]
			set pl15 [string range $pin_name_h [expr $pin_length -5] [expr $pin_length -1]]
			set pl16 [string range $pin_name_h [expr $pin_length -6] [expr $pin_length -1]]
			
			if {[string is integer $pl16] ==1} {
				set minco 6
			} elseif {[string is integer $pl15] ==1} {
				set minco 5
			} elseif {[string is integer $pl14] ==1} {
				set minco 4
			} elseif {[string is integer $pl13] ==1} {
				set minco 3
			} elseif {[string is integer $pl12] ==1} {
				set minco 2
			} elseif {[string is integer $pl1] ==1} {
				set minco 1
			} else {
				set minco 0
			}
			
			set new_st [string range $pin_name_h 0 [expr $pin_length -4-$minco]]
			#puts "new_st = $new_st"
	
			set one_cell_pin_co 0
			#puts "all_ports = [lindex $all_ports 0]"
			for {set in 0} {$in<[llength [lindex $all_ports 0]]} {incr in} {
			#puts "all_ports $i  = [lindex $all_ports $i]"
				set nnn "iph"
				set nnn $new_st$nnn
				if {([regexp ^$nnn\[0-9\]$ [lindex [lindex $all_ports 0] $in ]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1) || ([regexp ^$nnn\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\]$ [lindex [lindex $all_ports 0] $in]] == 1)} {
					set one_cell_pin_co [expr $one_cell_pin_co+1]
					#puts "+1"
				}
		
			}
			set one_cell_pin_co [expr $one_cell_pin_co/$rx]
			#puts "one_cell_pin_co = $one_cell_pin_co"
			if {$one_cell_pin_co != 0} {
				set pport_num [expr $index_f%$one_cell_pin_co]
			} else {
				set pport_num $index_f
			}
			#puts "pport_num = $pport_num"
			if {$one_cell_pin_co != 0} {
				set tmp_et [expr $index_f%$one_cell_pin_co]
				set pport_count [expr ($index_f-$tmp_et)/$one_cell_pin_co]
			} else {
				set pport_count 0
			}
			#puts "pport_count = $pport_count"
			set new_st [string range $new_st 0 end-1]
			set new_x_port $new_st$pport_num
			#puts "new_x_port = $new_x_port"
			#puts "lindex get_pins_origin_h 1 = [lindex [lindex $get_pins_origin_h 0] 1]"
			set index2 [lsearch [lindex [lindex $get_pins_origin_h 0] 0] $new_x_port]
			#puts "index2xxxx = $index2"
			set coodx [lindex [lindex [lindex $get_pins_origin_h 0] 1] $index2]
			#puts "coodxxxx = $coodx"
			
			#puts "index_f = $index_f -----;;;;;;;;;;------ one_cell_pin_co = $one_cell_pin_co"
			
			
			#puts "pport_count = $pport_count"
			if {$ix != 0} {
				set or_y [expr [lindex $coodx 1]+($pport_count+1)*$dy_cell]
				#puts "+1"
			} else {
				set or_y [lindex $coodx 1]
			}
			
			set or_cood [list [lindex $coodx 0] $or_y ]
			#puts "or_cood = $or_cood \n"
			#puts "created 2 pin names" 
	       		set ip_cood [list $x_start_h [expr $ix*$dy_cell+$y_origin_h]]
	        	set op_cood [list [expr $rx*$x_origin_h-0.005] [expr $ix*$dy_cell+$y_origin_h]]
			
			
	       		set lvs_layer "LVS$pin_layer_h"
	       		set xlvs_layer "XLVS$pin_layer_h"
			if {[lindex $or_cood 0] != ""} {
				#puts "+1"
				#puts "or_cood1 = [lindex $or_cood 1]"
				set ip_cood $or_cood
				set op_cood [list  [expr $cx*$dx_cell-0.005] [lindex $or_cood 1]]
	       		}
			#puts "op_cood = $op_cood"
			#puts "ip_cood = $ip_cood \n--------------------------------------------------------------------------------------" 
			if {$ix == 0} {
				
	       			set lvs_layer "LVS$pin_layer_h"
	        	      	set xlvs_layer "XLVS$pin_layer_h"
	        	      	le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "drawing"] -origin $ip_cood -height 0.02
	        	      	lappend ex_iph $pin_name_h
	        	      	le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "drawing"] -origin $op_cood -height 0.02
			} else {
				
				
				
				set pin_name_h [plus_fin_char_count_char16 $pin_name_h $ports_iph $rx]
	       			set pin_name_oph [plus_fin_char_count_char16 $pin_name_oph $ports_oph $rx]
				#puts "pin_name_h = $pin_name_h"
				#puts "point = $ip_cood"
				le::createLabel $pin_name_h -parent $edd -lpp [list  $lvs_layer "drawing"] -origin $ip_cood -height 0.02
	        	      	lappend ex_iph $pin_name_h
	        	      	le::createLabel $pin_name_oph -parent $edd -lpp [list $xlvs_layer "drawing"] -origin $op_cood -height 0.02

			}
		}
		
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
		#puts "---------------------------------------------------------------------------------------------------------------------------------"  
	       
		
	}
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
	set d_ex_iph [list]
	foreach xc $ports_iph {
		#puts "xc = $xc"
		#puts "ex_iph = $ex_iph" 
		if {[lsearch $ex_iph $xc] == -1} {
			#puts "xc = $xc" 
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
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc main_exp_char {netlist chcell_cellname chcell_libname or} {
	global instb_layer outl_layer
	
	
	set rxcx [regexp r*c* $chcell_cellname]
	#puts "rxcx = $rxcx"
	#puts "get cx"
	if {$rxcx == 1} {
		if {[string is integer [string range $chcell_cellname end-5 end]] == 1} {
			set cx  [string range $chcell_cellname end-5 end]
			set cx [expr $cx*1]
			set cxind 5
		} elseif {[string is integer [string range $chcell_cellname end-4 end]] == 1} {
			set cx  [string range $chcell_cellname end-4 end]
			set cx [expr $cx*1]
			set cxind 4
		} elseif {[string is integer [string range $chcell_cellname end-3 end]] == 1} {
			set cx  [string range $chcell_cellname end-3 end]
			set cx [expr $cx*1]
			set cxind 3
		} elseif {[string is integer [string range $chcell_cellname end-2 end]] == 1} {
			set cx  [string range $chcell_cellname end-2 end]
			set cx [expr $cx*1]
			set cxind 2
		} elseif {[string is integer [string range $chcell_cellname end-1 end]] == 1} {
			set cx  [string range $chcell_cellname end-1 end]
			set cx [expr $cx*1]
			set cxind 1
		} else {
			set cx  [string range $chcell_cellname end end]
			set cx [expr $cx*1]
			set cxind 0
		}
		#puts "cx = $cx ----- cxind = $cxind"
		#puts "get rx"
		
		set lstr [string length $$chcell_cellname]
		#puts "lstr = $lstr "
		
		if {[string is integer [string range $chcell_cellname [expr $lstr-$cxind-9] [expr $lstr-$cxind-4]]] == 1} {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-9] [expr $lstr-$cxind-4]]
			#puts "rx5 str = $rx"
			set rx [expr $rx*1]
			#puts "rx5 = $rx"
		} elseif {[string is integer [string range $chcell_cellname [expr $lstr-$cxind-8] [expr $lstr-$cxind-4]]] == 1} {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-8] [expr $lstr-$cxind-4]]
			#puts "rx4 str = $rx"
			set rx [expr $rx*1]
			#puts "rx4 = $rx"
		} elseif {[string is integer [string range $chcell_cellname [expr $lstr-$cxind-7] [expr $lstr-$cxind-4]]] == 1} {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-7] [expr $lstr-$cxind-4]]
			#puts "rx3 str = $rx"
			set rx [expr $rx*1]
			#puts "rx3 = $rx"
		} elseif {[string is integer [string range $chcell_cellname [expr $lstr-$cxind-6] [expr $lstr-$cxind-4]]] == 1} {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-6] [expr $lstr-$cxind-4]]
			#puts "rx2 str = $rx"
			set rx [expr $rx*1]
			#puts "rx2 = $rx"
		} elseif {[string is integer [string range $chcell_cellname [expr $lstr-$cxind-5] [expr $lstr-$cxind-4]]] == 1} {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-5] [expr $lstr-$cxind-4]]
			#puts "rx1 str = $rx"
			set rx [expr $rx*1]
			#puts "rx1 num = $rx"
		} else {
			set rx  [string range $chcell_cellname [expr $lstr-$cxind-4] [expr $lstr-$cxind-4]]
			#puts "rx0 str = $rx"
			set rx [expr $rx*1]
			#puts "rx0 = $rx"
		}
		#puts "cx = $cx \n rx = $rx"
		set cx [expr $cx/4]
		set rx [expr $rx/4]
		puts "cx = $cx \n rx = $rx"
		
		#puts "Run chcell maker for r4c16 char"
		set my_cell [get_lib_cell_names]
		set cell_name [lindex $my_cell 1]
		#puts "my call name is $cell_name"
		set lib_name [lindex $my_cell 0]
		#puts "my lib name is $lib_name"
		#////////////////set chcell lib and cell names////////////////////
		#set chcell_libname "suren_gcen"
		#set chcell_cellname "hd1p_chgio16_c16"
		set count 4
		#set netlist "~/Desktop/chcell.cir"
		if {$or == "Horizontal"} {
			set orient "h"
		} else {
			set orient "v"
		}
		
		
		set cell_dell [oa::DesignOpen $lib_name $cell_name layout readOnly]
		set rec [db::getShapes -of $cell_dell -lpp $outl_layer ]
		set bboxT [db::getAttr bBox -of $rec]
		set dx_cell [lindex [lindex $bboxT 1] 0]
		#puts "dx_xell = $dx_cell"
		set dy_cell [lindex [lindex $bboxT 1] 1]
		#puts "dy_cell = $dy_cell"
	
	
		set desoa [create_chcell $chcell_cellname $chcell_libname]
		puts "\n//////////////////////////////Stsrting level 0//////////////////////////////////////////////////////////"
		exp_level0  $desoa $lib_name $cell_name $rx $cx
		puts "level 0 is complate"
		port_without_char16 $netlist $desoa $lib_name $cell_name  $chcell_cellname
		port_ip_char16 $netlist $desoa $lib_name $cell_name  $chcell_cellname $rx $cx
		puts "FINISH"
		
	}
}
