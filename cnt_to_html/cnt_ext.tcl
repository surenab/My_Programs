#!/depot/tcl8.4.19/bin/tclsh 
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
#//////////////For any question mailto:surenab@synopsys.com//////////////////
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
puts "GET_LVS_RESILT::-> Starting create result.html lvs reprot file"
puts "GET_LVS_RESILT::-> For any question mailto:surenab@synopsys.com"
source /u/arpih/bin/from_suren/cnt_to_html/aforizm.tcl
set fl [lindex $argv 0]
if {$fl == ""} {puts "GET_LVS_RESILT::-> You didn't give me cnt file...Please puts in terminal <<<cnt_ext.tcl *.cnt>>>.";exit}
set start_html_file "/u/arpih/bin/from_suren/cnt_to_html/start_html.html"
set end_html_file "/u/arpih/bin/from_suren/cnt_to_html/end_html.html"
set cell_nms [list]
set cell_lvs [list]
set cell_lay [list]
puts "GET_LVS_RESILT::-> Getting cell names from cnt file"
if {[file exists $fl] == 1 } {
	set fd [open $fl "r"]
	set frd [read $fd]
	for {set i 0} {$i<[llength $frd]} {incr i} {
		if {[lindex $frd $i] == "cell"} {
			lappend cell_nms [lindex $frd [expr $i+1]]
		}
	}
	close $fd
} else {
	puts "GET_LVS_RESILT::-> Can't found $fl file,or in $fl file does not have cells"
}
puts "GET_LVS_RESILT::-> Get results"
for {set i 0} {$i<[llength $cell_nms]} {incr i} {
	set tmp_cell [lindex $cell_nms $i]
	set flvs "./cells/icv_lvs/$tmp_cell/$tmp_cell.LVS_ERRORS"	 
	set flay "./cells/icv_lvs/$tmp_cell/$tmp_cell.LAYOUT_ERRORS"
	if {[file exists $flvs] == 1 } {
		set lvs_res [exec cat $flvs | grep Final]
		set lvs_res [string range $lvs_res end-3 end]
		lappend cell_lvs $lvs_res
	} else {
		lappend cell_lvs "File doesn't exist"
	}
	if {[file exists $flay] == 1 } {
		set lay_res [exec cat $flay | grep RESULTS]
		for {set j 0} {$j < [string length $lay_res]} {incr j} {
			if {[string range $lay_res $j $j] == ":"} {
				set indx $j
			}
		}
		set lay_res [string range $lay_res [expr $indx+2] end]
		lappend cell_lay $lay_res
	} else {
		lappend cell_lay "File doesn't exist"
	}
}
set fwd [open "./result.html" "w"]
puts "GET_LVS_RESILT::-> Creating HTML file"
#creatin top html file---------------------------------
if {[file exists $start_html_file] == 1 } {
	set fd [open $start_html_file "r"]
	set start_html [read $fd]
	close $fd
	puts $fwd $start_html
} else {
	puts "GET_LVS_RESILT::-> Doesn't find start_html file"
}
#------------------------------------------------------
for {set i 0} {$i<[llength $cell_nms]} {incr i} {
	set tmp_cell [lindex $cell_nms $i]
	set tmp_lvs  [lindex $cell_lvs $i]
	set tmp_lay  [lindex $cell_lay $i]
	puts $fwd "                <tr>" 
	puts $fwd "                    <td style = 'color:darkslateblue'><b>$tmp_cell</b></td>"
	if {$tmp_lvs != "File doesn't exist" } {
		if {$tmp_lvs == "PASS"} {
			puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/$tmp_cell.LVS_ERRORS' style = 'color:green'><center >$tmp_lvs</center></td>"
		} else {
			puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/$tmp_cell.LVS_ERRORS' style = 'color:red'><center >$tmp_lvs</center></td>"
		}
	} else {
		puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/icv_lvs.log' ><center>icv_lvs.log</center></td>"
	}
	if {$tmp_lay != "File doesn't exist" } {
		if {$tmp_lay == "CLEAN"} {
			puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/$tmp_cell.LAYOUT_ERRORS' style = 'color:green'><center>CLEAN</center></td>"
		} else {
			puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/$tmp_cell.LAYOUT_ERRORS' style = 'color:red'><center>$tmp_lay</center></td>"
		}
	} else {
		puts $fwd "                    <td ><a href = './cells/icv_lvs/$tmp_cell/icv_nettran.log' ><center>icv_nettran.log</center></td>"
	}
	puts $fwd "                </tr>" 
}
puts $fwd " 		</tbody>"
puts $fwd "        </table>"
set xind [expr {round(rand()*10)}]
puts $fwd "		<p style='bottom: 0px; width:100%; text-align: center'><b style ='color:brown;font-size:1em;'>For any question:surenab@synopsys.com</b></p>"
puts $fwd "		<p style='bottom: 25px; width:100%; text-align: center'><b style ='color:#ebf4fa;font-size:2em;'>[lindex $afor $xind]</b></p>"     
puts $fwd "    </body>"
puts $fwd "</html>"
#------------------------------------------------------
close $fwd
puts "GET_LVS_RESILT::-> Finish.You can open result.html file"
