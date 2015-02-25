#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
set abut_script_path "/remote/am04home1/arpih/bin/from_suren/abut_script"
set wa_prefix "64"
set all_wa [list ]
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#/////////////Description for call all_abut function//////////////////////////////////////////////////////////#
#///////////////////////////////////////////////////////////////////////////// ///////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#all_abutment all_cells bex redex pg cdd dr cmx wa x y               	//////////////////////////////////////#
#1.all_cells --->list of list all cells				     	//////////////////////////////////////#
#2.b---------->bist enable or disable(1 or 0)			    	//////////////////////////////////////#
#3.r-------->red enable or disable(1 or 0)			    	//////////////////////////////////////#
#4.pg----------->lpg and gpg row enable or disable(1 or 0)	    	//////////////////////////////////////#	
#5.cd---------->left version enable or disable(1 or 0)		    	//////////////////////////////////////#
#6.dr----------->shifters include or not(1 or 0)		    	//////////////////////////////////////#
#7.cm---------->what version cm you wont(1 or 2 or 4 or 8 or 16)	//////////////////////////////////////#
#8.wa----------->sac_wa row enable or disable(1 or 0)			//////////////////////////////////////#
#9.x------------>x cordinate for startin drawing			//////////////////////////////////////#
#10.y------------>y cordinate for startin drawing			//////////////////////////////////////#
#11.bk----------->bank for memory					//////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////#
#//////////////  		 b   r   pg  cd   dr cm  wa    bk
set cell_list_hd1p {		{1   1   1    1   1   4   1    4}
				{1   1   1    1   0   4   1    4}
				{1   0   0    0   0   4   1    4}
				{1   0   0    1   0   4   1    2}
				{1   0   0    1   1   4   1    2}
				{1   0   0    1   1   4   0    2}
				{1   0   0    1   0   4   0    2}
				{1   0   0    0   0   4   0    2}
				{0   0   0    1   1   4   0    2}									       
				{0   0   0    1   0   4   0    2}
				{0   0   0    0   0   4   0    2}
			   	{1   1   0    0   0   4   1    1}
				{1   1   0    1   0   4   1    1}
				{1   1   0    1   1   4   1    1}
				{0   0   0    1   1   4   1    1}
				{0   0   0    0   0   4   1    1}
				{0   0   0    1   0   4   1    1}
				{0   0   1    1   0   4   1    1}
				{0   0   1    1   1   4   1    1}
				{0   0   1    0   1   4   1    1}
				{1   0   0    1   1   4   0    1}
				{1   0   0    1   0   4   0    1}
				{1   0   0    0   0   4   0    1}
				{0   0   0    1   1   4   0    1}
				{0   0   0    1   0   4   0    1}
				{0   0   0    0   0   4   0    1}}
				
set cell_list_hdrf2p {		{1   1   1    1   1   1   1    4}
				{1   1   1    1   0   1   1    4}
				{1   0   0    0   0   1   1    4}
				{1   0   0    1   0   1   1    2}
				{1   0   0    1   1   1   1    2}
				{1   0   0    1   1   1   0    2}
				{1   0   0    1   0   1   0    2}
				{1   0   0    0   0   1   0    2}
				{0   0   0    1   1   1   0    2}									       
				{0   0   0    1   0   1   0    2}
				{0   0   0    0   0   1   0    2}
			   	{1   1   0    0   0   1   1    1}
				{1   1   0    1   0   1   1    1}
				{1   1   0    1   1   1   1    1}
				{0   0   0    1   1   1   1    1}
				{0   0   0    0   0   1   1    1}
				{0   0   0    1   0   1   1    1}
				{0   0   1    1   0   1   1    1}
				{0   0   1    1   1   1   1    1}
				{0   0   1    0   1   1   1    1}
				{1   0   0    1   1   1   0    1}
				{1   0   0    1   0   1   0    1}
				{1   0   0    0   0   1   0    1}
				{0   0   0    1   1   1   0    1}
				{0   0   0    1   0   1   0    1}
				{0   0   0    0   0   1   0    1}}

set cell_list_diff_wa {		{1   1   1    1   1   1   1    4}}
	
	


#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc obrobot {dialog} {
	global abut_cell_name  abut_lib_name TopCellNameId  TopCellLibNameId compiler  OrientId cell_list_diff_wa count_io_pin  cell_list_hdrf2p cell_list_hd1p abut_script_path all_wa wa_prefix all_cells libname design doesnt_exist_cells wa_prefix  gpg_pin_name gio_pin_name bio_pin_name pin_lib_name prefix all_cell_list io_cells_cm1 io_cells_cm2 io_cells_cm4 io_cells_cm8 io_cells_cm16 redio_cells
	set abut_cell_name [db::getAttr value -of $TopCellNameId]
	set compiler [db::getAttr value -of $OrientId]
	set abut_lib_name [db::getAttr value -of $TopCellLibNameId]
	set xxtt "_"
	set prefix $compiler$xxtt
	set mylibname $abut_lib_name
	set cellname $abut_cell_name
	puts "abut_cell_name = $cellname"
	puts "compiler = $prefix"
	puts "abut_lib_name = $mylibname"
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	if {$prefix == "hdrf2p_"} {
		set architecture "new"
		set all_cells_name "hdrf2p_allcells"
		set all_cells_lib_name "hdrf2p_db"
		set count_io_pin 4
		set gpg_pin_name "hdrf2p_io_pin"
		set gio_pin_name "hdrf2p_io_pin"
		set bio_pin_name "hdrf2p_io_pin"
		set pin_lib_name "hdrf2p_pincells"
		set pin_lib_name "hdrf2p_db"
		set cell_list_choice $cell_list_hdrf2p
	} elseif {$prefix == "hd1p_"} {
		set architecture "standart"
		set all_cells_name "hd1p_allcells"
		set all_cells_lib_name "hd1p_db"
		set count_io_pin 1
		set cell_list_choice $cell_list_hd1p
	} elseif {$prefix == "hd2p_"} {
		set architecture "standart"
		set all_cells_name "hd2p_allcells"
		set all_cells_lib_name "hd2p_cluster"
		set count_io_pin 1
		set cell_list_choice $cell_list_hd2p
	} elseif {$prefix == "hdrf1p_"} {
		set architecture "standart"
		set all_cells_name "hdrf1p_allcells"
		set all_cells_lib_name "hdrf1p_cluster"
		set count_io_pin 1
		set cell_list_choice $cell_list_hdrf1p
	} elseif {$prefix == "hs1p_"} {
		set architecture "standart"
		set all_cells_name "hdsp_allcells"
		set all_cells_lib_name "hs1p_cluster"
		set count_io_pin 1
		set cell_list_choice $cell_list_hs1p
	}
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	#/////////////////////////////////////////////////////////////////////
	source $abut_script_path/get_cell_libnames.tcl	
	source $abut_script_path/pin_adder.tcl	
	set all_cell_list [getInsts $all_cells_lib_name $all_cells_name layout]
	source $abut_script_path/cell_name_temp.tcl
	if {$architecture == "standart"} {
		puts "You choose $architecture architecture"
		source $abut_script_path/abut_standart_architecture.tcl	
	} else {
		puts "You choose $architecture architecture"
		source $abut_script_path/abut_new_architecture.tcl
	}	
	set current_cell_name $cellname
	set cellname "$cellname\_$wa_prefix"
	
	
	make_abut $cell_list_choice $mylibname $cellname 
	foreach wa_p $all_wa {
		set cellname "allabut_$wa_p"
		set wa_prefix $wa_p
		source $abut_script_path/get_cell_libnames.tcl	
		set all_cell_list [getInsts $all_cells_lib_name $all_cells_name layout]
		source $abut_script_path/cell_name_temp.tcl
		if {$architecture == "standart"} {
			puts "You choose $architecture architecture"
			source $abut_script_path/abut_standart_architecture.tcl	
		} else {
			puts "You choose $architecture architecture"
			source $abut_script_path/abut_new_architecture.tcl
		}	
		make_abut $cell_list_diff_wa $mylibname $cellname 
	}


	
}
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
set abut_cell_name "*my_abut"
set abut_lib_name "*cluster"
set OrientId ""
set compiler "hd1p"
set TopCellNameId ""
set TopCellLibNameId "" 
proc dial_abut {} {
	global abut_cell_name  abut_lib_name TopCellNameId  TopCellLibNameId compiler  OrientId
	set getwindow [gi::getActiveWindow]
	if {[db::isEmpty [gi::getDialogs abutldial -parent $getwindow]] == 1 } {
		set myGUI [gi::createDialog  abutldial -parent $getwindow -title "Abut Creator" -execProc obrobot -showApply 0 -showHelp 0 ]
		set TopCellNameId    [gi::createTextInput wTopCellName      -parent $myGUI   -label "Abut Cell Name:"     -value $abut_cell_name   -readOnly 0  -valid 1]
		set TopCellLibNameId [gi::createTextInput wTopCellLibName   -parent $myGUI   -label "Abut Library Name:"  -value $abut_lib_name    -readOnly 0  -valid 1]
		set OrientId  [gi::createMutexInput wOrient -parent $myGUI -label "Compiler Type:" -enum { "hd1p" "hdrf2p" "hd2p" "hdrf1p" "hs1p"} -toolTip "Choose Compiler type please" -viewType radio -value $compiler]
        }
}
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
proc abut_menu {} {
        set cMenu [gi::createMenu c -title "Create Abut"]
        set x2 [gi::createAction dial  -command dial_abut  -title "Abut Creator"]
	gi::addActions [list  $x2 ] -to $cMenu
	return $cMenu
}
set cabutMenu [abut_menu]
gi::addMenu $cabutMenu -to [gi::getWindowTypes leLayout]


set winType [gi::getWindowTypes giConsole]
set toolbar [gi::getToolbars -filter { %name == "giConsoleStandard" } -from $winType]
gi::createAction Run_Abut_Creator -title "Create Abut" -history true -toolTip "To Create Abut" -command dial_abut
gi::addActions Run_Abut_Creator  -to $toolbar
gi::createBinding -event "Alt-Shift-a" -command {Run_Abut_Creator}
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
