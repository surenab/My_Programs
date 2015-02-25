#!/bin/tcsh -f

echo "\033[1;27mHi dear $USER.I'm script for running lvs and now starting run LVS verification.Thanks for using me.\n\033[0m"
#######################changed variables##############################################
setenv WorkPath `pwd`
echo "\033[1;29mWorking Path is $WorkPath\033[0m"
######################################################################################
if (-f /remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/sourceme_lvsdrc ) then
        source /remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/sourceme_lvsdrc
else
	echo "\033[1;29m\nDoes not exist <sourceme_lvsdrc>  file \nPlease copy sourceme_lvsdrc fle in your work area.\n\033[0m"
	echo "print anything if you wont close"
	while ([set answer = $<]=="yes")
		echo "Close the window"
	end
endif

#module load $icv_lvs

echo "ICV Version is"
which icv
setenv VDK_POOL $5
setenv vuei $4
setenv htmli $3
setenv NetPath $2
echo "\033[1;29m\nNetlist File is $NetPath\n\033[0m"

if ($1 == "svt") then
	setenv vt_map $svt_icv
	echo "\033[1;29mvt_map is $vt_map\033[0m"
else if ($1 == "lvt") then
	setenv vt_map $lvt_icv
	echo "\033[1;29mvt_map is $vt_map\033[0m"
else if ($1 == "ulvt") then
	setenv vt_map $ulvt_icv
	echo "\033[1;29mvt_map is $vt_map\033[0m"
else
	echo "\033[1;29mRun with correct parameter please (svt or lvt or ulvt) \033[0m"
	exit
endif
########################################GET LIBNAME AND CELLNAME ####################
if (-f $WorkPath/drc_lvs/cell_drc) then
	setenv libName `cat $WorkPath/drc_lvs/cell_drc | awk '{print $1}'`
	echo "\033[1;29mlibName is $libName\033[0m"
else
	echo "\033[1;29m\nDoes not exist <lib Name> in file \nPlease write lib Name and become run script\n\033[0m"
	exit
endif	

if (-f $WorkPath/drc_lvs/cell_drc) then
	setenv exportcellName `cat $WorkPath/drc_lvs/cell_drc | awk '{print $2}'`
else
	echo "\033[1;29m\nDoes not exist <cell_list> in file \nPlease write cell_list and become run script\n\033[0m"
	exit
endif	
######################################################################################
cd $WorkPath/drc_lvs/
#export gds ################
echo "VDK_POOL is $VDK_POOL"
if !(-d $WorkPath/drc_lvs/gds/) then
	echo "\033[1;29mDoesn't exist gds Directory,I create gds Directory now\033[0m"
	mkdir $WorkPath/drc_lvs/gds/
endif
if (-f $WorkPath/drc_lvs/gds/gds.gds) then
	rm -rf $WorkPath/drc_lvs/gds/*
endif
which exportStream
rm -rf $WorkPath/drc_lvs/ex.log 
echo "\033[1;29mStarting export gds file\033[0m"
exportStream -logFile exportStream_1.log -lib $libName -libDefFile $WorkPath/lib.defs -gds $WorkPath/drc_lvs/gds/gds_$1.gds -blockageType 0 -cell $exportcellName -donutNumSides 64 -ellipseNumSides 64 -hierDepth 13 -layerMap $vt_map -noOutputBlockages -rectAsBoundary -view layout -text cdba -ver 3 -toLowerLabel > ex.log
tail $WorkPath/drc_lvs/ex.log -n 6
echo "\033[1;29mFinished export gds file\033[0m"
#######################################################################################
echo "\033[1;29mLoading new Envariment\033[0m"
unsetenv ICV_HOME_DIR
unsetenv MANPATH
unsetenv _LMFILES_
unsetenv PATH
unsetenv VOV_ENV
unsetenv PRIMEYIELD_INCLUDES
unsetenv PRIMEYIELD_HOME_DIR
unsetenv LOADED_VDK_icv
unsetenv LOADEDMODULES



unsetenv TCL_LIBRARY
unsetenv TCLDP_PATH
unsetenv TCLLIBPATH
unsetenv LD_LIBRARY_PATH

setenv TCL_LIBRARY "/global/apps3/customdesigner_2013.03/amd64/tcl/lib/tcl8.4"
setenv TCLDP_PATH "/global/apps3/customdesigner_2013.03/amd64/ext/lib/tcl-dp"
setenv TCLLIBPATH "$HOME/.synopsys_custom  /remote/cad-rep/emll/tools/CD_utilities /global/apps3/customdesigner_2013.03/auxx /global/apps3/customdesigner_2013.03/amd64/tcl/lib/tcl8.4 global/apps3/customdesigner_2013.03/amd64/tclpython/4.1-PY2.6.2"
setenv LD_LIBRARY_PATH  "/global/apps3/customdesigner_2013.03/amd64/platform/lib:/global/apps3/customdesigner_2013.03/amd64/lib:/global/apps3/customdesigner_2013.03/amd64/OA/lib/linux_rhel40_32/opt:/global/apps3/customdesigner_2013.03/amd64/ext/lib/vcd:/global/apps3/customdesigner_2013.03/amd64/ext/lib/webworks:/global/apps3/customdesigner_2013.03/amd64/boost/lib:/global/apps3/customdesigner_2013.03/amd64/tcl/lib:/global/apps3/customdesigner_2013.03/amd64/tdk/lib:/global/apps3/customdesigner_2013.03/amd64/qt/lib:/global/apps3/customdesigner_2013.03/amd64/qt/plugins/imageformats:/global/apps3/customdesigner_2013.03/amd64/Python/2.6.2/lib:/global/apps3/customdesigner_2013.03/amd64/qwt/lib:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/lib:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/3rd/oa/lib/linux_rhel30_gcc411_64/opt:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/3rd/lib:/remote/sge/default/lib/lx24-amd64:/depot/gcc-4.2.2/lib:/usr/openwin/lib:/usr/dt/lib:/usr/local/lib:/usr/local/ssl/lib:/remote/cliosoft/old_am_virl_cad/fsb/rtda/2011.03/linux/lib"

source ~/.cshrc
module unload emll_cadutilities_queryccs
module load emll_cadutilities_queryccs
setenv QUERYCCS_ENABLE 1
echo "VDK_POOL is $VDK_POOL"
setenv VDK_POOL $5


######################creat new cnt file for run#######################################
if !(-d $WorkPath/drc_lvs/lvs_$1/) then
	echo "\033[1;29mDoesn't exist lvs_$1/ Directory,I am creating gds Directory\033[0m"
	mkdir $WorkPath/drc_lvs/lvs_$1/
endif

cd $WorkPath/drc_lvs/lvs_$1/




if (-f $WorkPath/drc_lvs/lvs_$1/cover_lvs_$1.cnt) then 
	rm -rf $WorkPath/drc_lvs/lvs_$1/cover_lvs_$1.cnt
endif	

printf "set WorkPath $WorkPath \n">cover_lvs_$1.cnt
printf "set cell(cir_file) $NetPath\n">>cover_lvs_$1.cnt
printf "set cell(gds_file) $WorkPath/drc_lvs/gds/gds_$1.gds\n">>cover_lvs_$1.cnt
if (-f $MAIN_COVER/cover_main.cnt) then
	cat $MAIN_COVER/cover_main.cnt >> $WorkPath/drc_lvs/lvs_$1/cover_lvs_$1.cnt
else
	"\033[1;29mDoesn't exist <cover_main.cnt> file\033[0m"
	exit
endif
#//////////////////////////////////////////////////////////////////////////////////////
if (-f $WorkPath/drc_lvs/cell_list) then
	foreach cellName (`cat $WorkPath/drc_lvs/cell_list`) 
		printf "\ncell		$cellName		$cellName		I">>cover_lvs_$1.cnt
	end
else
	echo "\033[1;29m\nDoes not exist <cell_list> file \nPlease write cell_list and become run script\n\033[0m"
	exit
endif	
if (-d $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs_old) then
	echo "\033[1;29mRemoving icv_lvs_old directory\033[0m"
	rm -rf $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs_old 
endif
if (-d $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs) then
	echo "\033[1;29mCopy icv_lvs in icv_lvs_old directory\033[0m"
	mv -f $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs_old
endif
if (-f $WorkPath/drc_lvs/lvs_$1/mycover_lvs.logx) then
	echo "\033[1;29mRemoving mycover_lvs.logx file\033[0m"
	rm -rf $WorkPath/drc_lvs/mycover_lvs.logx
endif
echo "\033[1;29mVDK_POOL is $VDK_POOL\033[0m"
if (-f $WorkPath/drc_lvs/lvs_$1/cover_lvs_$1.cnt) then 
	echo "\033[1;33mCOVER file creating completed\033[0m"
endif 
#######################################################################################
######################RUN CNT FILE#####################################################
rm -rf  $WorkPath/drc_lvs/lvs_$1/cells/cover.log $WorkPath/drc_lvs/lvs_$1/cells/cover.log.bak $WorkPath/drc_lvs/lvs_$1/cells/strmOut* $WorkPath/drc_lvs/lvs_$1/cells/vnc_logs 
echo "\033[1;36mRUNNING COVER FILE 		\c\033[0m"; 	date +"%T"
echo "\033[1;33mYou use ICV verification for $cellName cell\033[0m"
cover $WorkPath/drc_lvs/lvs_$1/cover_lvs_$1.cnt >mycover_lvs.logx
echo "\033[1;36mLVS VERIFICATION COMPLATED	\c\033[0m";	date +"%T"


 

/u/arpih/bin/from_suren/cnt_to_html/cnt_ext.tcl cover_lvs_$1.cnt
foreach cellName (`cat $WorkPath/drc_lvs/cell_list`) 
	if (-f $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName/$cellName.LVS_ERRORS) then
		echo "\033[1;34mFor $cellName\033[0m"
		setenv vuecell $cellName
		cat $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName/$cellName.LVS_ERRORS | grep result
		if (-f $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName/$cellName.LAYOUT_ERRORS) then
			cat $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName/$cellName.LAYOUT_ERRORS | grep ERROR 
		else
			echo "\033[1;34mDoesn't exist LAYOUT_ERRORS file for $cellName\033[0m"
			echo "\033[1;34mCheck LOG files in $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName directory\033[0m"
			
		endif
		 
	else
		echo "\033[1;34mDoesn't exist LVS_ERRORS file for $cellName\033[0m"
		echo "\033[1;34mCheck LOG files in $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName directory\033[0m"
		cat $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$cellName/*log | grep error
	endif
end


if ($htmli) then
	gnome-open result.html
else if ($vuei) then
	echo "openning vue"
	settdk tdk16.24.tmp_icv
	setenv NEW_DRC
	icv_vue -load $WorkPath/drc_lvs/lvs_$1/cells/icv_lvs/$vuecell/$vuecell.vue  -lay CDesignerLE &
endif

cd $WorkPath
echo "print <Enter> if you wont close"
while ([set answer = $<]=="yes")
	echo "Close the window"
end
