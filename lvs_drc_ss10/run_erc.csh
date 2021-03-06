#!/bin/tcsh -f
echo "\033[1;27mHi dear $USER.I'm script for running erc and now starting run ERC verification.Thanks for using me.\n\033[0m"

#######################changed variables##############################################
setenv WorkPath `pwd`
echo "\033[1;29mWorking Path is $WorkPath\033[0m"
if (-f /remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/sourceme_lvsdrc ) then
	
        source /remote/am04home1/arpih/bin/from_suren/lvs_drc_ss10/sourceme_lvsdrc
else
	echo "\033[1;29m\nDoes not exist <sourceme_lvsdrc>  file \033[0m"
	echo "print anything if you wont close"
	while ([set answer = $<]=="yes")
		echo "Close the window"
	end
endif


echo "ICV Version is"
which icv

#//////////////////////////////////////////////////////////////////
setenv vdkpool $1
echo "vdkpool is $vdkpool"
setenv VDK_POOL $vdkpool


setenv vt_map $d_vt
##########create drc_lvs directory############################
if !(-d $WorkPath/drc_lvs/) then
	echo "\033[1;29mDoes not exist drc_lvs directory \nCreating drc_lvs directory in your work area\033[0m"
	mkdir $WorkPath/drc_lvs/
	echo "\033[1;29mCreated drc_lvs directory in your work area\033[0m"
endif
######################################################################################
if (-f $WorkPath/drc_lvs/cell_drc) then
	echo "\033[1;29mGet lib name for your cell\033[0m"
	setenv libName `cat $WorkPath/drc_lvs/cell_drc | awk '{print $1}'`
	echo "\033[1;29mYour lib name is <$libName>\033[0m"
else
	echo "\033[1;29mDoes not exist <lib Name> file \nPlease write lib Name and then run script\033[0m"
	exit
endif	

if (-f $WorkPath/drc_lvs/cell_drc) then
	echo "\033[1;29mGet cell name for your cell\033[0m"
	setenv cellName `cat $WorkPath/drc_lvs/cell_drc | awk '{print $2}'`
	echo "\033[1;29mYour cell name is <$cellName>\033[0m"
else
	echo "\033[1;29mDoes not exist <cell_list> file \nPlease write cell_list and become run script\033[0m"
	exit
endif	
echo "\033[1;29mGo to drc_lvs directory\033[0m"
cd $WorkPath/drc_lvs/
#export gds ################
echo "\033[1;29mVDK_POOL is $VDK_POOL\033[0m"

if !(-d $WorkPath/drc_lvs/gds/) then
	echo "\033[1;29mDoesn't exist gds Directory,I create gds Directory now\033[0m"
	mkdir $WorkPath/drc_lvs/gds/
endif
if (-f $WorkPath/drc_lvs/gds/gds_erc.gds) then
	echo "\033[1;29mRemove old gds files\033[0m"
	rm -rf $WorkPath/drc_lvs/gds/gds_erc.gds
	echo "\033[1;29mRemoved old gds files\033[0m"
endif
if (-f $WorkPath/drc_lvs/ex_erc.log) then
	echo "\033[1;29mRemoving generated old ex_erc.log file\033[0m"
	rm -rf $WorkPath/drc_lvs/ex_erc.log
endif
echo "\033[1;29mStarting export gds file\033[0m"
exportStream -logFile exportStream_1.log -lib $libName -libDefFile $WorkPath/lib.defs -gds $WorkPath/drc_lvs/gds/gds_erc.gds -blockageType 0 -cell $cellName -donutNumSides 64 -ellipseNumSides 64 -hierDepth 13 -layerMap $vt_map -noOutputBlockages -rectAsBoundary -view layout -text cdba -ver 3 -toLowerLabel -dbuPerUU 4000> ex_erc.log
tail $WorkPath/drc_lvs/exportStream_1.log -n 6
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
#unsetenv LD_LIBRARY_PATH

setenv TCL_LIBRARY "/global/apps3/customdesigner_2013.03/amd64/tcl/lib/tcl8.4"
setenv TCLDP_PATH "/global/apps3/customdesigner_2013.03/amd64/ext/lib/tcl-dp"
setenv TCLLIBPATH "$HOME/.synopsys_custom  /remote/cad-rep/emll/tools/CD_utilities /global/apps3/customdesigner_2013.03/auxx /global/apps3/customdesigner_2013.03/amd64/tcl/lib/tcl8.4 global/apps3/customdesigner_2013.03/amd64/tclpython/4.1-PY2.6.2"
#setenv LD_LIBRARY_PATH  "/global/apps3/customdesigner_2013.03/amd64/platform/lib:/global/apps3/customdesigner_2013.03/amd64/lib:/global/apps3/customdesigner_2013.03/amd64/OA/lib/linux_rhel40_32/opt:/global/apps3/customdesigner_2013.03/amd64/ext/lib/vcd:/global/apps3/customdesigner_2013.03/amd64/ext/lib/webworks:/global/apps3/customdesigner_2013.03/amd64/boost/lib:/global/apps3/customdesigner_2013.03/amd64/tcl/lib:/global/apps3/customdesigner_2013.03/amd64/tdk/lib:/global/apps3/customdesigner_2013.03/amd64/qt/lib:/global/apps3/customdesigner_2013.03/amd64/qt/plugins/imageformats:/global/apps3/customdesigner_2013.03/amd64/Python/2.6.2/lib:/global/apps3/customdesigner_2013.03/amd64/qwt/lib:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/lib:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/3rd/oa/lib/linux_rhel30_gcc411_64/opt:/remote/cadtools/ciraNova/445_py262/linux64/plat_linux_gcc411_64/3rd/lib:/remote/sge/default/lib/lx24-amd64:/depot/gcc-4.2.2/lib:/usr/openwin/lib:/usr/dt/lib:/usr/local/lib:/usr/local/ssl/lib:/remote/cliosoft/old_am_virl_cad/fsb/rtda/2011.03/linux/lib"


source /u/surenab/.cshrc
module unload emll_cadutilities_queryccs
#module load emll_cadutilities_queryccs
setenv QUERYCCS_ENABLE 0
setenv VDK_POOL $vdkpool

######################creat new cnt file for run#######################################
if (-f $WorkPath/drc_lvs/cover_drc_erc.cnt) then
	echo "\033[1;29mRemoving generated old cnt file\033[0m"
	rm -rf $WorkPath/drc_lvs/cover_drc_erc.cnt
endif
echo "\033[1;29mStarting make cover_erc.cnt file\033[0m"

printf "set WorkPath $WorkPath \n">$WorkPath/drc_lvs/cover_erc.cnt
#printf "set cell(cir_file) $NetPath\n">>cover_erc.cnt
printf "set cell(gds_file) $WorkPath/drc_lvs/gds/gds_erc.gds\n">>cover_erc.cnt

cat $MAIN_COVER/cover_main.cnt >> $WorkPath/drc_lvs/cover_erc.cnt
printf "\ncell		$cellName		$cellName		E">>$WorkPath/drc_lvs/cover_erc.cnt
echo "\033[1;29mFinished make cover_erc.cnt file\033[0m"
#######################################################################################
######################RUN CNT FILE#####################################################
if (-d $WorkPath/drc_lvs/cells/icv_erc_old) then
	echo "\033[1;29mRemoving icv_drc_old directory\033[0m"
	rm -rf $WorkPath/drc_lvs/cells/icv_erc_old 
endif
if (-d $WorkPath/drc_lvs/cells/icv_erc) then
	echo "\033[1;29mCopy icv_drc in icv_erc_old directory\033[0m"
	mv -f $WorkPath/drc_lvs/cells/icv_erc $WorkPath/drc_lvs/cells/icv_erc_old
endif

if (-f $WorkPath/drc_lvs/mycover.log) then
	echo "\033[1;29mRemoving mycover.log file\033[0m"
	rm -rf $WorkPath/drc_lvs/mycover.log
endif
if (-f $WorkPath/drc_lvs/cover_drc_$1.cnt) then 
	echo "\033[1;33mCOVER file creating completed\033[0m"
else	
	echo "\033[1;29mDoes not exist cover_erc.cnt file \n\033[0m"
endif 
echo "\033[1;29mVDK_POOL is $VDK_POOL\033[0m"

echo "\033[1;33mRUNNING COVER FILE 		\c\033[0m"; 	date +"%T"
cover $WorkPath/drc_lvs/cover_erc.cnt >mycover.log
cd $WorkPath
tail $WorkPath/drc_lvs/cells/icv_erc/$cellName/icv_erc.log -n 1
echo "\033[1;33mDRC VERIFICATION COMPLATED	\c\033[0m";	date +"%T"

echo "print <Enter> if you wont close"
while ([set answer = $<]=="yes")
	echo "Close the window"
end
