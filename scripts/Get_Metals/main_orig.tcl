#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                                     Creator:surenab@synopsys.com					////////////////////////////////////////
#		Script is need for getitin all metal shapes width,space and serios			////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
set m4layer [list "M4" "drawing"]
set m3layer [list "M3" "drawing"]
set m2layer [list "M2" "drawing"]
set m1layer [list "M1" "drawing"]

set checkm4 1
set checkm3 0
set checkm2 0

set layernum1 14
set layernum2 16
set layernum3 18
set layernum4 20

set netlist "/slowfs/am04dwt2p013/projects/layout/ss10/hd1p/users/suren/hd1p_chcells.cir.nodummy_lvt_lvs_chcells"






set net_doexin_lay [list]
set all_lay_exist_ports [list]
proc Get_Poly_info {shp layer } {
	
	#puts "Run Polygon"
	set points  [db::getAttr points -of $shp]
	set lenpoint [llength $points]
	
}
#//////////////////////////////////////////////  Getting all top metals [pin_name,width,real_place_width,space_left,space_ritgh,length,netlist_exist,metal_type]   ///////////////////////////////////
proc be_get_cell__mx {ll cc layer} {
	global m3layer m2layer m4layer netlist net_doexin_lay all_lay_exist_ports
	set currentOaDesign [oa::DesignFind $ll $cc layout]
	set shp4 [db::getShapes -lpp $layer -of $currentOaDesign]
	set all_metals [list]
	set all_layout_ports [Get_all_ports_lay $ll $cc]
	set m2layports [lindex $all_layout_ports 2] 
	set m3layports [lindex $all_layout_ports 1] 
	set m4layports [lindex $all_layout_ports 0] 
	set all_schem_ports  [Get_all_ports_sch $cc $netlist]
	set all_layout_exist [list]
	
	while {[set shp [db::getNext $shp4]] != ""} {
		set xtype [db::getAttr type -of $shp]
		if {$xtype == "Path"} {
			set box [db::getAttr bBox -of $shp]
			if {[lindex [lindex $box 0] 0] < [lindex [lindex $box 1] 0]} {
				set x [lindex [lindex $box 0] 0]
				set xmax [lindex [lindex $box 1] 0]
			} else {
				set x [lindex [lindex $box 1] 0]
				set xmax [lindex [lindex $box 0] 0]
			}
			if {[lindex [lindex $box 0] 1] > [lindex [lindex $box 1] 1]} {
				set y [lindex [lindex $box 1] 1]
				set ymax [lindex [lindex $box 0] 1]
			} else {
				set y [lindex [lindex $box 0] 1]
				set ymax [lindex [lindex $box 1] 1]
			}
			set tmppname "unknown"
			if {$layer == $m2layer} {
				#puts "Run for m2"
				for {set i 0} { $i<[llength $m2layports]} {incr i} {
					set tmpport [lindex $m2layports $i]
					set tmpportp [lindex $tmpport 1]
					#puts "port cood = $tmpportp"
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			} elseif {$layer == $m3layer} {
				#puts "Run for m3"
				for {set i 0} { $i<[llength $m3layports]} {incr i} {
					set tmpport [lindex $m3layports $i]
					set tmpportp [lindex $tmpport 1]
					#puts "port cood = $tmpportp"
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			} else {
				#puts "Run for m4"
				for {set i 0} { $i<[llength $m4layports]} {incr i} {
					set tmpport [lindex $m4layports $i]
					set tmpportp [lindex $tmpport 1]
					#puts "port cood = $tmpportp"
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			}
			if {[lsearch $all_schem_ports $tmppname] == -1} { 
				set port_in_net_status "NO"
			} else {
				set port_in_net_status "YES"
				lappend all_lay_exist_ports $tmppname
			}
			
			set tmpc [list $x $y $xtype $shp $xmax $ymax $tmppname $port_in_net_status]
		} elseif {$xtype == "Rect"} {
			set box [db::getAttr bBox -of $shp]
			if {[lindex [lindex $box 0] 0] > [lindex [lindex $box 1] 0]} {
				set x [lindex [lindex $box 1] 0]
				set xmax [lindex [lindex $box 0] 0]
			} else {
				set x [lindex [lindex $box 0] 0]
				set xmax [lindex [lindex $box 1] 0]
			}
			if {[lindex [lindex $box 0] 1] > [lindex [lindex $box 1] 1]} {
				set y [lindex [lindex $box 1] 1]
				set ymax [lindex [lindex $box 0] 1]
			} else {
				set y [lindex [lindex $box 0] 1]
				set ymax [lindex [lindex $box 1] 1]
			}
			set tmppname "unknown"
			if {$layer == $m2layer} {
				for {set i 0} { $i<[llength $m2layports]} {incr i} {
					set tmpport [lindex $m2layports $i]
					set tmpportp [lindex $tmpport 1]
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			} elseif {$layer == $m3layer} {
				for {set i 0} { $i<[llength $m3layports]} {incr i} {
					set tmpport [lindex $m3layports $i]
					set tmpportp [lindex $tmpport 1]
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			} else {
				#puts "Run for m4"
				for {set i 0} { $i<[llength $m4layports]} {incr i} {
					set tmpport [lindex $m4layports $i]
					#puts "port cood = $tmpport"
					set tmpportp [lindex $tmpport 1]
					#puts "port cood = $tmpportp"
					if {([lindex $tmpportp 0]>=$x) && ([lindex $tmpportp 0]<=$xmax) && ([lindex $tmpportp 1]>=$y) && ([lindex $tmpportp 1]<=$ymax)} {
						set tmppname [lindex $tmpport 0]
						break
					}
				}
			}
			if {[lsearch $all_schem_ports $tmppname] == -1} { 
				set port_in_net_status "NO"
			} else {
				set port_in_net_status "YES"
				lappend all_lay_exist_ports $tmppname
			}
			
			set tmpc [list $x $y $xtype $shp $xmax $ymax $tmppname $port_in_net_status]
		} else {
			#puts "POLYGON"
			set points  [db::getAttr points -of $shp]
			set old_p $points
			#puts "points = $points"
			set points [lsort -real -index 0 $points] 
			set x [lindex [lindex $points 0] 0]
			set xmax [lindex [lindex $points  [expr [llength $points]-1]] 0]
			set points [lsort -real -index 1 $points] 
			set y [lindex [lindex $points 0] 1]
			set ymax [lindex [lindex $points  [expr [llength $points]-1]] 1]
			#puts "points = $points"
			#puts "min x = $x"
			#puts "min y = $y"
			set tmppname "unknown"
			set lenpoint [llength $old_p]
			
			if {$layer == $m2layer} {
				for {set ii 0} { $ii<[llength $m2layports]} {incr ii} {
					set tmpport [lindex $m2layports $ii]
					set tmpportp [lindex $tmpport 1]
					
					
					set j [expr $lenpoint - 1]
					
					set xx [lindex $tmpportp 0]
					set yy [lindex $tmpportp 1]
					#puts "lenpoint = $lenpoint"
					for {set i 0} { $i<$lenpoint} {incr i} {
						
						set pyi [lindex [lindex $points $i] 1]
						set pxi [lindex [lindex $points $i] 0]
						set pyj [lindex [lindex $points $j] 1]
						set pxj [lindex [lindex $points $i] 0]
						if {((($pyi<$yy) && ($pyj>=$yy)) || (($pyj<$yy) && ($pyi>=$yy)))} {
							if {($pxi+($yy-$pyi)/($pyj-$pyi)*($pxj-$pxi))} {
								set tmppname [lindex $tmpport 0]
								break
							}
						}
						set j $i
					}
				}
			
			
			} elseif {$layer == $m3layer} {
				for {set ii 0} { $ii<[llength $m3layports]} {incr ii} {
					set tmpport [lindex $m3layports $ii]
					set tmpportp [lindex $tmpport 1]
					set lenpoint [llength $points]
					set j [expr $lenpoint - 1]
					set lenpoint [llength $points]
					set xx [lindex $tmpportp 0]
					set yy [lindex $tmpportp 1]
					for {set i 0} { $i<$lenpoint} {incr i} {
						
						set pyi [lindex [lindex $points $i] 1]
						set pxi [lindex [lindex $points $i] 0]
						set pyj [lindex [lindex $points $j] 1]
						set pxj [lindex [lindex $points $i] 0]
						if {((($pyi<$yy) && ($pyj>=$yy)) || (($pyj<$yy) && ($pyi>=$yy)))} {
							if {($pxi+($yy-$pyi)/($pyj-$pyi)*($pxj-$pxi))} {
								set tmppname [lindex $tmpport 0]
								break
							}
						}
						set j $i
					}
				}
			} else {
				#puts "Run for m4"
				for {set ii 0} { $ii<[llength $m4layports]} {incr ii} {
					set tmpport [lindex $m4layports $ii]
					#puts "port cood = $tmpport"
					set tmpportp [lindex $tmpport 1]
					#puts "port cood = $tmpportp"
					set lenpoint [llength $points]
					set j [expr $lenpoint - 1]
					set lenpoint [llength $points]
					set xx [lindex $tmpportp 0]
					set yy [lindex $tmpportp 1]
					for {set i 0} { $i<$lenpoint} {incr i} {
						#puts "1"
						set pyi [lindex [lindex $points $i] 1]
						set pxi [lindex [lindex $points $i] 0]
						set pyj [lindex [lindex $points $j] 1]
						set pxj [lindex [lindex $points $i] 0]
						if {((($pyi<$yy) && ($pyj>=$yy)) || (($pyj<$yy) && ($pyi>=$yy)))} {
							if {($pxi+($yy-$pyi)/($pyj-$pyi)*($pxj-$pxi))} {
								set tmppname [lindex $tmpport 0]
								break
							}
						}
						set j $i
					}
				}
			}
			if {[lsearch $all_schem_ports $tmppname] == -1} { 
				set port_in_net_status "NO"
			} else {
				set port_in_net_status "YES"
				lappend all_lay_exist_ports $tmppname
			}
			set tmpc [list $x $y $xtype $shp $xmax $ymax $tmppname $port_in_net_status]
		}
		#puts "tmpc = $tmpc"
		lappend all_metals $tmpc
	}
	#puts "all_metals = $all_metals"
	if {$layer == $m3layer } {
		set all_metals [lsort -real -index 1 $all_metals]
	} else {
		set all_metals [lsort -real -index 0 $all_metals]
	}
	#puts "all_metals = $all_metals"
	set get_all_m [get_cell_m $all_metals $layer]
	#puts "end"
	return $get_all_m
}
proc get_cell_m {all_mx layer} {
	global m3layer
	set start_cood 0
	set all_metals [list]
	if {$layer == $m3layer } {
		for {set i 0} { $i<[llength $all_mx]} {incr i} {
			set tmpm [lindex $all_mx $i]
			set xtype [lindex $tmpm 2]
			set shp [lindex $tmpm 3]
			set xmin [lindex $tmpm 0]
			set ymin [lindex $tmpm 1]
			set xmax [lindex $tmpm 4]
			set ymax [lindex $tmpm 5]
			set port_name [lindex $tmpm 6]
			set port_status [lindex $tmpm 7]
			#puts "type = $xtype"
			if {$i == 0} {
				set ymax_n_m 0
			} else {
				set ymax_n_m [lindex [lindex $all_mx [expr $i-1]] 5]
			}
			set ymin_n_p [lindex [lindex $all_mx [expr $i+1]] 1]
			
			
			if {$xtype == "Path"} {
				set w [expr $ymax - $ymin]
				set l [expr $xmax - $xmin]
				set real_w $w
				set space_before [expr $ymin- $ymax_n_m]
				set space_after  [expr $ymin_n_p - $ymax]
				
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts "prun $i = $prun"
				
			} elseif {$xtype == "Rect"} {
				set w [expr $ymax - $ymin]
				set l [expr $xmax - $xmin]
				set real_w $w
				set space_before [expr $ymin- $ymax_n_m]
				set space_after  [expr $ymin_n_p - $ymax]
				
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts "prun $i = $prun"
				
			} else {
				#puts "Polygon"
				set real_w [expr $ymax - $ymin]
				set w [expr $ymax - $ymin]
				set l [expr $xmax - $xmin]
				set space_before [expr $ymin- $ymax]
				set space_after  [expr $ymin - $ymax]
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts $prun
				#set prun [list    	        $real_w                            $layer             ]
			}
			
			
			
			
			lappend all_metals $prun
		}
	} else {
		for {set i 0} { $i<[llength $all_mx]} {incr i} {
			set tmpm [lindex $all_mx $i]
			set xtype [lindex $tmpm 2]
			set shp [lindex $tmpm 3]
			set xmin [lindex $tmpm 0]
			set ymin [lindex $tmpm 1]
			set xmax [lindex $tmpm 4]
			set ymax [lindex $tmpm 5]
			set port_name [lindex $tmpm 6]
			set port_status [lindex $tmpm 7]
			#puts "type = $xtype"
			if {$i == 0} {
				set xmax_n_m 0
			} else {
				set xmax_n_m [lindex [lindex $all_mx [expr $i-1]] 4]
			}
			if {$i == [expr [llength $all_mx]-1]} {
				set xmin_n_p $xmax
			} else {
				set xmin_n_p [lindex [lindex $all_mx [expr $i+1]] 0]
			}
			
			
			if {$xtype == "Path"} {
				set w [expr $xmax - $xmin]
				set l [expr $ymax - $ymin]
				set real_w $w
				set space_before [expr $xmin- $xmax_n_m]
				set space_after  [expr $xmin_n_p - $xmax]
				
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts "prun $i = $prun"
				
			} elseif {$xtype == "Rect"} {
				set w [expr $xmax - $xmin]
				set l [expr $ymax - $ymin]
				set real_w $w
				set space_before [expr $xmin- $xmax_n_m]
				set space_after  [expr $xmin_n_p - $xmax]
				
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts "prun $i = $prun"
				
			} else {
				#puts "Polygon"
				set real_w [expr $ymax - $ymin]
				set w [expr $ymax - $ymin]
				set l [expr $xmax - $xmin]
				set space_before [expr $ymin- $ymax]
				set space_after  [expr $ymin - $ymax]
				set prun [list $port_name $w $l $real_w $space_before $space_after $layer $port_status $xtype]
				#puts $prun
			}
			lappend all_metals $prun
		}
	}
	return $all_metals	
}
#///////////////////////////////////////////////////////////////////////////////   Getting all top cell names and lib names   /////////////////////////////////////////////////////////////////////////
proc Get_all_Insts {lib cell view} {
    	set clist [list]
    	set master [oa::DesignOpen $lib $cell $view [oa::ViewTypeFind maskLayout] r]
    	set top [oa::getTopBlock $master]
    	set count 0
    	set insts [oa::getInsts $top]
    	while {[set inst [oa::getNext $insts]] != ""} {
	 	set cellname [oa::getCellName $inst]
	 	set libname  [oa::getLibName $inst]
	 	set name [list $cellname $libname]
	 	lappend clist $name
	 	set count [ expr {$count + 1}]
    	}
    	puts "$count insts"
    	return $clist
}
#///////////////////////////////////////////////////////////////////////////////   Getting activ window all top cell and lib names   //////////////////////////////////////////////////////////////////
proc get_active_cell {} {
	set pCurCellViewId [de::getActiveEditorWindow]
	set inst [db::getAttr cell -of [db::getAttr cellView -of [db::getAttr hierarchy -of [de::getContexts -window $pCurCellViewId]]]]
	set libname [db::getAttr libName -of $inst]
	puts "Lib Name is $libname :"
	set cellname [db::getAttr name -of $inst]
	puts "Cell Name is $cellname :"		
	set cell_list [Get_all_Insts $libname $cellname layout]
	return $cell_list
}
#///////////////////////////////////////////////////////////////////////////////   Getting All M4 width spaces and names           //////////////////////////////////////////////////////////////////
proc get_mx {all_cells} {
	global checkm4 checkm3 checkm2 m4layer m3layer m2layer netlist all_lay_exist_ports net_doexin_lay
	set all_cells_m4 [list]
	for {set ix 0} { $ix<[llength $all_cells]} {incr ix} {
		set all_lay_exist_ports [list]
		set net_doexin_lay [list]
		set l1 [lindex [lindex $all_cells $ix] 1]
		puts "libname is $l1"
		set c1 [lindex [lindex $all_cells $ix] 0]
		puts "cellname is $c1"
		set tmp_m4 [list]
		set tmp_m3 [list]
		set tmp_m2 [list]
		if {$checkm4} {
			set tmp_m4 [be_get_cell__mx $l1 $c1 $m4layer]
		}
		if {$checkm3} {
			set tmp_m3 [be_get_cell__mx $l1 $c1 $m3layer]
		}
		if {$checkm2} {
			set tmp_m2 [be_get_cell__mx $l1 $c1 $m2layer]
		}
		
		
		set all_schem_ports  [Get_all_ports_sch $c1 $netlist]
		for {set i 0} { $i<[llength $all_schem_ports]} {incr i} {
			set tmp_net_port [lindex $all_schem_ports $i]
			if {[lsearch $all_lay_exist_ports $tmp_net_port] == -1} { 
				lappend net_doexin_lay $tmp_net_port
			}
		}
		set cell_tmp [list $c1 $l1 $tmp_m4 $tmp_m3 $tmp_m2 $net_doexin_lay]
		lappend all_cells_m4 $cell_tmp
		#puts $net_doexin_lay
	}
	return $all_cells_m4
}
proc Get_all_ports_lay {lname cname} {
	global layernum4 layernum3 layernum2
	set cell_dell [oa::DesignOpen $lname $cname layout readOnly]
	set lay_ports [db::getShapes -of $cell_dell -filter {(%type=="Text" || %type=="AttrDisplay")  && (%layerNum == $layernum4 )}]
	set all_ports [list]
	set port_info2 [list]
	set port_info3 [list]
	set port_info4 [list]
	db::foreach lay_pin $lay_ports {
		set lay_pin_name [db::getAttr text -of $lay_pin]
        	set lay_pin_name_lower [string tolower $lay_pin_name]
		set origin [db::getAttr origin -of $lay_pin]
		set tmp [list $lay_pin_name_lower $origin]
		lappend port_info4 $tmp 
	}
	set lay_ports [db::getShapes -of $cell_dell -filter {(%type=="Text" || %type=="AttrDisplay")  && (%layerNum==$layernum3 )}]
	db::foreach lay_pin $lay_ports {
		set lay_pin_name [db::getAttr text -of $lay_pin]
        	set lay_pin_name_lower [string tolower $lay_pin_name]
		set origin [db::getAttr origin -of $lay_pin]
		set tmp [list $lay_pin_name_lower $origin]
		lappend port_info3 $tmp 
	}
	set lay_ports [db::getShapes -of $cell_dell -filter {(%type=="Text" || %type=="AttrDisplay")  && (%layerNum==$layernum2 )}]
	db::foreach lay_pin $lay_ports {
		set lay_pin_name [db::getAttr text -of $lay_pin]
        	set lay_pin_name_lower [string tolower $lay_pin_name]
		set origin [db::getAttr origin -of $lay_pin]
		set tmp [list $lay_pin_name_lower $origin]
		lappend port_info2 $tmp 
	}
	lappend all_ports $port_info4
	lappend all_ports $port_info3
	lappend all_ports $port_info2
	return $all_ports
}

proc Get_all_ports_sch {cell_name netlist} {
	set all_port [list]
	if {[file isfile $netlist]} {
		#puts "I am found  cir file"
	} else {
		puts "File name is not correct,please give me correct file name"
		errorMessage "File name is not correct,please give me correct file name"
		return -1
	}
	set fileid [open $netlist "r"]
	set text_file [read $fileid]
	close $fileid
	set lf [llength $text_file]
	set index 0
	for {set i 0} {$i<$lf} {set i [expr $i+1]} {
		if {([lindex $text_file $i] == ".subckt") && ([lindex $text_file [expr $i+1]] == $cell_name)} {
			set index [expr $i+2]
			#puts "I am found the your cell"
		} 
	}
	if {$index == 0} {
		puts "I am can not found you cell in cir file"
		return -1
	}
	for {set i $index} {$i<$lf} {incr i} {
		if {([string index [lindex $text_file $i] 0] == "x") || ([string index [lindex $text_file $i] 0] == "*")} {
			if {!(([string index [lindex $text_file $i] 0] == "x") && ([string match *adr* [lindex $text_file $i]]))} {
				set end_index $i
				break
			}
		}
	}
	for {set i $index} {$i<$end_index} {incr i} {
		lappend all_port [lindex $text_file $i]
	}
	
	set new_port [list]
	for {set i 0} {$i<[llength $all_port]} {incr i} {
		if {[lindex $all_port $i] != "+"} {
			lappend new_port [lindex $all_port $i]
		}
	}
	set all_ports $new_port
	#puts "all_ports = $all_ports\n"
	return $all_ports
}
proc main_m {} {
	global net_doexin_lay all_lay_exist_ports
	puts "START"
	set all_cells [get_active_cell]
	puts "all_cells = $all_cells"
	set gnx [get_mx $all_cells]
	#puts "gnx = [llength $gnx]"
	set fdhtml [open ./metal_result.html "w"]
	set fd [open ./metal_result.txt "w"]
	set now [clock seconds]
	set fmt "%c:%m"
	set tmp_now [clock format $now -format $fmt]
	puts $tmp_now
	set start_text "--------This file was generated by Metal Getting Script in $tmp_now--------"
	set start_html_1 "<!DOCTYPE html>
<html>
    <head>
        <title>Metal Shapes </title>
        <style>
            table {margin:auto;border:1px solid black;}
            th {color:blue;background-color:#C0C0C0;}
            td {background-color:#C0C0C0;}
        </style>
    </head>
    <body >
     <table border=\"2px\">
    <thead>
                <tr>
                    <th colspan=\"9\"><b>\"				$start_text\"</b></th></th>
                </tr>
		
		
            </thead>
            <tbody>"
    	puts $fdhtml $start_html_1
	for {set it 0} { $it<[llength $gnx]} {incr it} {
		set t_gnx [lindex $gnx $it]
		set tmp_cname [lindex $t_gnx 0]
		puts "Starting make report files for $tmp_cname cell"
		set tmp_lname [lindex $t_gnx 1]
		set tmp_m4    [lindex $t_gnx 2]
		set tmp_m3    [lindex $t_gnx 3]
		set tmp_m2    [lindex $t_gnx 4]
		set tmp_doexpin [lindex $t_gnx 5]
		puts $fd "				$start_text"
		puts  $fd "					Library name is $tmp_lname,Cell name is $tmp_cname" 
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts  $fd "									------------Metal 4 layers------------   "
		puts  $fd "Port Name		|	Width	|	Length	|	Real Width	|	Space 1	|	Space2	|	Metal Layer	|	Port in netlist	|	Type of shape	|"  
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		for {set i 0} {$i<[llength $tmp_m4]} {incr i} {
			set tm [lindex $tmp_m4 $i]
			puts -nonewline $fd [lindex $tm 0]
			puts -nonewline $fd "			|	[lindex $tm 1]	"
			puts -nonewline $fd "|	[lindex $tm 2]" 
			puts -nonewline $fd "	|	[lindex $tm 3]"
			puts -nonewline $fd "		|	[lindex $tm 4]"
			puts -nonewline $fd "	|	[lindex $tm 5]"
			puts -nonewline $fd "	|	[lindex $tm 6]"
			puts -nonewline $fd "	|	[lindex $tm 7]"
			puts  $fd "		|	[lindex $tm 8]		|"
		
		}
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts  $fd "									------------Metal 3 layers------------   "
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts  $fd "Port Name		|	Width	|	Length	|	Real Width	|	Space 1	|	Space2	|	Metal Layer	|	Port in netlist	|	Type of shape	|"  
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		for {set i 0} {$i<[llength $tmp_m3]} {incr i} {
			set tm [lindex $tmp_m3 $i]
			puts -nonewline $fd [lindex $tm 0]
			puts -nonewline $fd "			|	[lindex $tm 1]	"
			puts -nonewline $fd "|	[lindex $tm 2]" 
			puts -nonewline $fd "	|	[lindex $tm 3]"
			puts -nonewline $fd "		|	[lindex $tm 4]"
			puts -nonewline $fd "	|	[lindex $tm 5]"
			puts -nonewline $fd "	|	[lindex $tm 6]"
			puts -nonewline $fd "	|	[lindex $tm 7]"
			puts  $fd "		|	[lindex $tm 8]		|"
		
		}
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts  $fd "									------------Metal 3 layers------------   "
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts  $fd "Port Name		|	Width	|	Length	|	Real Width	|	Space 1	|	Space2	|	Metal Layer	|	Port in netlist	|	Type of shape	|"  
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		for {set i 0} {$i<[llength $tmp_m2]} {incr i} {
			set tm [lindex $tmp_m2 $i]
			puts -nonewline $fd [lindex $tm 0]
			puts -nonewline $fd "			|	[lindex $tm 1]	"
			puts -nonewline $fd "|	[lindex $tm 2]" 
			puts -nonewline $fd "	|	[lindex $tm 3]"
			puts -nonewline $fd "		|	[lindex $tm 4]"
			puts -nonewline $fd "	|	[lindex $tm 5]"
			puts -nonewline $fd "	|	[lindex $tm 6]"
			puts -nonewline $fd "	|	[lindex $tm 7]"
			puts  $fd "		|	[lindex $tm 8]		|"
		
		}
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts $fd "									------------Ports didn't exits in Layout------------   "
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts $fd $tmp_doexpin
		puts $fd "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		puts "Starting make HTML file"
		#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		set start_html "
		<tr>
                    <th colspan=\"9\"><b>\"					Library name is $tmp_lname,Cell name is $tmp_cname\"</b></th></th>
                </tr>"
		puts $fdhtml $start_html
		puts $fdhtml "<tr>
                    <th colspan=\"9\"><b>\"				Metal 4 ports\"</b></th></th>
                </tr>
                <tr>
                    <th ><i>Port Name</i></th>
                    <th><i>Width</i></th>
                    <th><i>Length<i></th>
		    <th ><i>Real Width</i></th>
                    <th><i>Space 1</i></th>
                    <th><i>Space2<i></th>
		    <th ><i>Metal Layer</i></th>
                    <th><i>Port exist in netlist</i></th>
                    <th><i>Type of shape<i></th>
                </tr>"
		for {set i 0} {$i<[llength $tmp_m4]} {incr i} {
			set tm [lindex $tmp_m4 $i]
			puts $fdhtml "                <tr>"
			if {[lindex $tm 0] == "unknown"} {
				puts $fdhtml "                    <td style = 'color:red'><b>[lindex $tm 0]</b></td>"
			} else {
				puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 0]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 1])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 2])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 3])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 4])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 5])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:purple'><b>[lindex $tm 6]</b></td>" 
			if {[lindex $tm 7] == "NO"} {
				puts $fdhtml "                    <td style = 'color:darkred'><b>[lindex $tm 7]</b></td>" 
			} else {
				puts $fdhtml "                    <td style = 'color:darkgreen'><b>[lindex $tm 7]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 8]</b></td>" 
			puts $fdhtml "                </tr>" 
		
		}
		puts $fdhtml "<tr>
                    <th colspan=\"9\"><b>\"				Metal 3 ports\"</b></th></th>
                </tr>
                <tr>
                    <th ><i>Port Name</i></th>
                    <th><i>Width</i></th>
                    <th><i>Length<i></th>
		    <th ><i>Real Width</i></th>
                    <th><i>Space 1</i></th>
                    <th><i>Space2<i></th>
		    <th ><i>Metal Layer</i></th>
                    <th><i>Port exist in netlist</i></th>
                    <th><i>Type of shape<i></th>
                </tr>"
		for {set i 0} {$i<[llength $tmp_m3]} {incr i} {
			set tm [lindex $tmp_m3 $i]
			puts $fdhtml "                <tr>"
			if {[lindex $tm 0] == "unknown"} {
				puts $fdhtml "                    <td style = 'color:red'><b>[lindex $tm 0]</b></td>"
			} else {
				puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 0]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 1])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 2])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 3])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 4])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 5])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:green'><b>[lindex $tm 6]</b></td>" 
			if {[lindex $tm 7] == "NO"} {
				puts $fdhtml "                    <td style = 'color:darkred'><b>[lindex $tm 7]</b></td>" 
			} else {
				puts $fdhtml "                    <td style = 'color:darkgreen'><b>[lindex $tm 7]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 8]</b></td>" 
			puts $fdhtml "                </tr>" 
		
		}
		puts $fdhtml "<tr>
                    <th colspan=\"9\"><b>\"				Metal 2 ports\"</b></th></th>
                </tr>
                <tr>
                    <th ><i>Port Name</i></th>
                    <th><i>Width</i></th>
                    <th><i>Length<i></th>
		    <th ><i>Real Width</i></th>
                    <th><i>Space 1</i></th>
                    <th><i>Space2<i></th>
		    <th ><i>Metal Layer</i></th>
                    <th><i>Port exist in netlist</i></th>
                    <th><i>Type of shape<i></th>
                </tr>"
		for {set i 0} {$i<[llength $tmp_m2]} {incr i} {
			set tm [lindex $tmp_m2 $i]
			puts $fdhtml "                <tr>"
			if {[lindex $tm 0] == "unknown"} {
				puts $fdhtml "                    <td style = 'color:red'><b>[lindex $tm 0]</b></td>"
			} else {
				puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 0]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 1])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 2])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 3])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 4])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[expr abs([lindex $tm 5])]</b></td>" 
			puts $fdhtml "                    <td style = 'color:red'><b>[lindex $tm 6]</b></td>" 
			if {[lindex $tm 7] == "NO"} {
				puts $fdhtml "                    <td style = 'color:darkred'><b>[lindex $tm 7]</b></td>" 
			} else {
				puts $fdhtml "                    <td style = 'color:darkgreen'><b>[lindex $tm 7]</b></td>"
			}
			puts $fdhtml "                    <td style = 'color:darkslateblue'><b>[lindex $tm 8]</b></td>" 
			puts $fdhtml "                </tr>" 
		
		}
		puts $fdhtml "<tr>
		    <th colspan=\"9\"><b>\"In below you can see Netlsit ports who doesn't exist in Layout\"</b></th></th>
                </tr>"
		puts $fdhtml "
		
		<tr>
		    <th colspan=\"9\" style = 'color:red'><b>\"$tmp_doexpin\"</b></th></th>
                </tr>
		"
	}
	puts $fdhtml " 		</tbody>"
	puts $fdhtml "        </table>"
	puts $fdhtml "    </body>"
	puts $fdhtml "</html>"
	close $fd
	close $fdhtml
	puts "End"
	set dlgmet [gi::createDialog dialog1 -title "Status" -showApply 0 -showHelp 0]
      	set lbl [gi::createLabel label1 -parent $dlgmet -label " -----  Getting Metals Script Complated  ----- "] 
	exec firefox ./metal_result.html &
	
}
set winType [gi::getWindowTypes leLayout]
set toolbar [gi::getToolbars leDRCToolbar -from $winType]

gi::createAction m4_get -title "Get Matals" -history true  -command {main_m}
gi::addActions m4_get  -to $toolbar

