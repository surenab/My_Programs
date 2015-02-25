#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////This scrip take your cir file and cell name and return all ports ,ip and op port./////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc get_all_pins {netlist cell_name} {
	puts "\n//////////////////////////////////////////////////////Starting get all pin procedure//////////////////////////////////"
	puts "Hi this is program for geting ip op and other port from cir file.Give me cir file and cell name and I am return all ports"
	set all_port [list]
	set ipv_port [list]
	set iph_port [list]
	set opv_port [list]
	set oph_port [list]
	set port_without [list]
	
	
	if {[file isfile $netlist]} {
		puts "I am found the yor cir file"
	} else {
		puts "File name is not correct,please give me correct file name"
		errorMessage "File name is not correct,please give me correct file name"
		return -1
	}
	
	set fileid [open $netlist "r"]
	set text_file [read $fileid]
	close $fileid
	#puts "text_file = $text_file"
	set lf [llength $text_file]
	set index 0
	for {set i 0} {$i<$lf} {set i [expr $i+1]} {
		if {([lindex $text_file $i] == ".subckt") && ([lindex $text_file [expr $i+1]] == $cell_name)} {
			set index [expr $i+2]
			puts "I am found the your cell"
		} 
	}
	if {$index == 0} {
		puts "I am can not found you cell in cir file"
		errorMessage "I am can not found you cell in cir file"
		return -1
	}
	#puts $index
	for {set i $index} {$i<$lf} {incr i} {
		if {([string index [lindex $text_file $i] 0] == "x") || ([string index [lindex $text_file $i] 0] == "*")} {
			#puts [lindex $text_file $i] 
			if {!(([string index [lindex $text_file $i] 0] == "x") && ([string match *adr* [lindex $text_file $i]]))} {
				set end_index $i
				break
			}
		}
	}
	#puts "end_index = $end_index"
	
	#///////////////////////////////geting sub cells/////////////////////////////////////////////
	for {set i $end_index} {$i<$lf} {incr i} {
		if {([lindex $text_file $i] == ".ends") } {
			set cellend_index $i
			break
		}
	}
	#puts "cellend_index = $cellend_index"
	set cell_count_index [list]
	for {set i $end_index} {$i<$cellend_index} {incr i} {
		if {([string index [lindex $text_file $i] 0] == "x")} {
			if {!([string match *adr* [lindex $text_file $i]])} {
				lappend cell_count_index $i
			}
		}
		
	}
	#puts "cell_count_index = $cell_count_index"
	
	set cell_names [list]
	foreach ii $cell_count_index {
		#puts "$ii cell name is [lindex $text_file $ii]"
		for {set i [expr $ii+1]} {$i<=$cellend_index} {incr i} {
			if {([string index [lindex $text_file $i] 0] == "x") || ([string index [lindex $text_file $i] 0] == "*") || [lindex $text_file $i] == ".ends"} {
				if {(!(([string index [lindex $text_file $i] 0] == "x") && ([string match *adr* [lindex $text_file $i]])))  || ([lindex $text_file $i] == ".ends")} {
					lappend cell_names [lindex $text_file [expr $i-1]]
					break
				}
			}
		}
	}
	#puts "cell_names = $cell_names"
	
	set cells_info [list]
	set cell_names_one [list]
	set cells_count [list]
	foreach ii $cell_names {
		if {[lsearch $cell_names_one $ii] == -1} {
			lappend cell_names_one $ii
		}
	}
	#puts "cell_names_one = $cell_names_one"
	foreach ii $cell_names_one {
		lappend cells_count [llength [lsearch -all $cell_names $ii]]
	}
	#puts "cells_count = $cells_count"
	
	lappend cells_info $cell_names_one
	lappend cells_info $cells_count
	
	#puts "cells_info = $cells_info\n"
	
	#///////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	for {set i $index} {$i<$end_index} {incr i} {
		lappend all_port [lindex $text_file $i]
	}
	
	set new_port [list]
	for {set i 0} {$i<[llength $all_port]} {incr i} {
		if {[lindex $all_port $i] != "+"} {
			lappend new_port [lindex $all_port $i]
		}
	}
	set all_port $new_port
	#puts "all_ports = $all_port\n"
	
	
	for {set i 0} {$i<[llength $all_port]} {incr i} {
		if {!(([string match *ipv* [lindex $all_port $i]]) || ([string match *iph* [lindex $all_port $i]]) || ([string match *opv* [lindex $all_port $i]]) || ([string match *oph* [lindex $all_port $i]]))} {
			lappend  port_without [lindex $all_port $i]
		} 
		if {([string match *ipv* [lindex $all_port $i]])} {
			lappend  ipv_port [lindex $all_port $i]
		} 
		if {([string match *iph* [lindex $all_port $i]])} {
			lappend  iph_port [lindex $all_port $i]
		}
		if {([string match *opv* [lindex $all_port $i]])} {
			lappend  opv_port [lindex $all_port $i]
		} 
		if {([string match *oph* [lindex $all_port $i]])} {
			lappend  oph_port [lindex $all_port $i]
		}
	}
	puts "port_without = $port_without \n"
	if {[llength $ipv_port] == 0} {
		puts "None ipv ports"
	} else {
		puts "ipv_port = $ipv_port \n"
	}
	if {[llength $iph_port] == 0} {
		puts "None iph ports"
	} else {
		puts "iph_port = $iph_port \n"
	}
	puts "Starting add ports"
	set pp [list $all_port $port_without $ipv_port $iph_port $cells_info $opv_port $oph_port]
	puts "//////////////////////////////////////////////////////Finish get all pin procedure//////////////////////////////////\n"
	return $pp	
	
}
#get_all_pins "~/Desktop/chcell.cir" "hd1p_chredgio4_c16"
