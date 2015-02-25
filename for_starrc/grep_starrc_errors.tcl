#!/depot/tcl8.4.19/bin/tclsh
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
#//////////////For any question mailto:surenab@synopsys.com//////////////////
#////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////
puts "GREP_STARRC::-> Getting fail rpt files"
set pth [lindex $argv 0]
if {$pth == ""} {puts "You didn't give me STARRC generated folder...Please puts in terminal <<<grep_starrc_error.tcl cell_\prefix\>>>.";exit}
set x1 "/*/cells/chcellsverify/*/chcellsverify.rpt"
set all_pth $pth$x1
set gerr "FAIL"
set err [eval exec grep -i {{FAIL}} [glob $all_pth]]
set listerr [split $err "/" ]
set newl1 [list]
puts "GREP_STARRC::-> Checking fail reports"
for {set ie 2} {$ie<[llength $listerr]} {set ie [expr $ie+3]} {
	set cellname [lindex $listerr $ie] 
	lappend newl1 $cellname
}
exec rm -rf fail_rpt
puts "GREP_STARRC::-> Creating fail_rpt folder"
exec mkdir fail_rpt
puts "GREP_STARRC::-> Starting copy all fail reports"
for {set ie 2} {$ie<[llength $newl1]} {incr ie} {
	set cellname [lindex $newl1 $ie]
	exec cp $pth/$cellname/cells/chcellsverify/$cellname/chcellsdetails.rpt ./fail_rpt/$cellname\_chcellsdetails.rpt
}
puts "GREP_STARRC::-> Grep all fail and write in all_fails.log file"
eval exec grep  -A 1 FAIL [glob ./fail_rpt/*] > ./fail_rpt/all_fails.log
exec tar czf fail_rpt.tar.gz fail_rpt
puts "GREP_STARRC::-> Finish "
puts "GREP_STARRC::-> You can check <<fail_rpt.tar.gz>> file in ran path "





