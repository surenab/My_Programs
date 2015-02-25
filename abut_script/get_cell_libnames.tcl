proc getInsts {lib cell view} {
    	set clist [list]
	set llist [list]
    	set master [oa::DesignOpen $lib $cell $view [oa::ViewTypeFind maskLayout] r]
    	set top [oa::getTopBlock $master]
    	set count 0
    	set insts [oa::getInsts $top]
    	while {[set inst [oa::getNext $insts]] != ""} {
	 	set cellname [oa::getCellName $inst]
	 	set libname  [oa::getLibName  $inst]
		set state 0
		for {set i 0} {$i<[llength $clist]} {incr i} {
			if {$cellname == [lindex $clist $i]} {
				set state 1
			}
		}
		if {$state == 0} {
	 		lappend clist $cellname
	 		lappend llist $libname
	 		set count [ expr {$count + 1}]
		}
    	}
	set all_names [list]
	lappend all_names $clist
	lappend all_names $llist
 	#puts "$count insts"
    	return $all_names
}
