############################Creator:surenab@synopsys.com######################################### 
#################################################################################################
#This program was wrotten for make compiler minumum combination for getting issues  #############
#################################################################################################
#################################################################################################
#################################################################################################
import sys
import os
def my_help ():
	print """-------------------This program for getting all insts and making new tcl file for pipe running.-------------------------------------------------------------------------------------------------------------
		 
		 For running you must give 5 or 6 parameters : Example: '''''python get_inst.py samsung_stv2_wrapper_one.tcl lcen 1 1 4 diff''''
		 
		 				File Path:   Full file Path and Name
						Row	 :   Which Row changed --  'wk_bk2 rw xdec lcen lpg sac sac_wa red gcen gpg bcen bcen_mux pin'
						VDDA	 :   Set '1' if changed cell is level shifter,otherwise anything but not '1'
						BUF	 :   Set '1' if changed cell buffer or rebuffer or cap cell,otherwise anything but not '1' (if you set '1',script will get all cm configurations)
						CM	 :   If BUF is not 1,you can set what cm you want
						IO_SIZE	 :   Set 'diff' if different cm io sizes is different,otherwise script needn't this parameter
		
	      """
	print "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
#################################################################################################
if len(sys.argv) == 6 or len(sys.argv) == 7:
	#print "All is Rigth"
	pass
else:
	my_help()
	sys.exit(0)
pwd = os.getcwd()
print "Current directory is",pwd
#*******geting inputs*****************
tclfile = sys.argv[1]
row = 	  sys.argv[2]
lsh = 	  sys.argv[3]
buf = 	  sys.argv[4]
cm = 	  sys.argv[5]
#*************************************
if len(sys.argv) == 7 and sys.argv[6] == "diff":
	cm_diff = sys.argv[6]
else:
	cm_diff = "same"
#*************************************
tclfile = pwd + "/" + tclfile
print "Tcl File is",tclfile
allfile = []
ftcl1 = open(tclfile, "r")
tcl1 = ftcl1.readlines()
for t1 in tcl1:
	#print t1
	allfile.append(t1.split())	
ftcl1.close()
#print allfile
insts = []
header = []
for t1 in allfile:
	if "header" in t1:
		new_header = t1
	if "add_inst" in t1:
		insts.append(t1)
	else:
		header.append(t1)
new_header.pop(0)
all_p = []
header_l = len(new_header)
testname = insts[0][1]
for x in range(header_l):
	all_px = []
	for t1 in insts:
		all_px.append(t1[x+2])
	all_p.append(all_px)
#################################################################################################
#################################################################################################
for x in range(header_l):
	if new_header[x] == "NW":
		nw_n = x
	if new_header[x] == "NB":
		nb_n = x
	if new_header[x] == "CM":
		cm_n = x
	if new_header[x] == "BK":
		bk_n = x
	if new_header[x] == "center_decode":
		cd_n = x
	if new_header[x] == "pg_enable":
		pg_n = x
	if new_header[x] == "redundancy_enable":
		red_n = x
	if new_header[x] == "bist_enable":
		bist_n = x
	if new_header[x] == "write_assist":
		wa_n = x
	if new_header[x] == "periphery_Vt":
		vt_n = x
	if new_header[x] == "vdda_enable":
		vdda_n = x
#################################################################################################
#################################################################################################
def getcomp_withn (n,all):
	tmp = ""
	for i in all:
		tmp = tmp + " " + i[n]
	tmp = "add_inst" + " " + testname + " " + tmp
	#print "tmp = ",tmp
	return tmp;
#################################################################################################
#################################################################################################
def wk_bk2 (vdda,buf,cmn):
	#print "wk_bk2 function"
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)+"/red_"+str(redx)
		for tbk in [2,4,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for tred in [0,1]:
							if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank and redx == tred:  
								if tname in check.keys():
									pass
								else:  
									all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#################################################################################################
#################################################################################################
def rw (vdda,buf,cmn):
	#print "rw function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)
		for tbk in [1,4,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank :  
							if tname in check.keys():
								pass
							else:  
								all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#################################################################################################
#################################################################################################
def xdec (vdda,buf,cmn):
	#print "xdec function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)
		for tbk in [1,4,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank :  
							if tname in check.keys():
								pass
							else:  
								all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#################################################################################################
#################################################################################################
def lcen (vdda,buf,cmn):
	#print "lcen function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)+"/red_"+str(redx)+"/pg_"+str(pg)
		for tbk in [1,4,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for tpg in [0,1]:
							if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank and pg == tpg:  
								if tname in check.keys():
									pass
								else:  
									all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
##################################################################################################
#################################################################################################
def lpg (vdda,buf,cmn):
	#print "lpg function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)+"/pg_1"
		for tbk in [1,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank and pg == 1:  
							if tname in check.keys():
								pass
							else:  
								all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#################################################################################################
#################################################################################################
def sac (vdda,buf,cmn,cm_diff_m):
	#print "sac function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		nw = int(all_p[nw_n][i1])
		xdec_bk = nw/(cm*bank*4)
		nw_32 = (cm*bank*4)*8
		nw_64 = (cm*bank*4)*16
		nw_128 = (cm*bank*4)*32
		nw_192 = (cm*bank*4)*48
		nw_256 = (cm*bank*4)*64
		if nw<nw_32:tmp_nw=32;
		elif nw<nw_64:tmp_nw=64;
		elif nw<nw_128:tmp_nw=128;
		elif nw<nw_192:tmp_nw=192;
		elif nw<nw_256:tmp_nw=256;
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/wa_"+str(wa)+"/bk_"+str(bank)+"/pg_"+str(pg)+"/red_"+str(redx)
		for tbk in [1,4]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for twa in [0,1]:
							for tpg in [0,1]:
								for tred in [0,1]:
									if twa == 0:
										if cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank and pg == tpg and redx == tred:  
											if tname in check.keys():
												pass
											else:  
												all[tname] = i1;check[tname] = 1
									else:	
								
										if cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank and pg == tpg and redx == tred:
											tname = tname+str(tmp_nw)  
											if tname in check.keys():
												pass
											else:  
												all[tname] = i1;check[tname] = 1
										
	ret_numbers = []
	get_comp = []
	#print "all = ",all
	if buf == '1': 
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				#print "x=",x
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def sac_wa (vdda,buf,cmn):
	#print "sac_wa function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		nw = int(all_p[nw_n][i1])
		xdec_bk = nw/(cm*bank*4)
		nw_32 = (cm*bank*4)*8
		nw_64 = (cm*bank*4)*16
		nw_128 = (cm*bank*4)*32
		nw_192 = (cm*bank*4)*48
		nw_256 = (cm*bank*4)*64
		if nw<nw_32:tmp_nw=32;
		elif nw<nw_64:tmp_nw=64;
		elif nw<nw_128:tmp_nw=128;
		elif nw<nw_192:tmp_nw=192;
		elif nw<nw_256:tmp_nw=256;
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/wa_"+str(wa)+"/bk_"+str(bank)+"/red_"+str(redx)+"/wa_"+str(tmp_nw)
		for tbk in [1,4]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for tred in [0,1]:
							if cd == tcd and cm == tcm and shift == tvdda  and tbk == bank and redx == tred and wa == 1:  
								if tname in check.keys():
									pass
								else:  
									all[tname] = i1;check[tname] = 1
									
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				#print "x=",x
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def red (vdda,buf,cmn):
	#print "red function"
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		nw = int(all_p[nw_n][i1])
		xdec_bk = nw/(cm*bank*4)
		nw_32 = (cm*bank*4)*8
		nw_64 = (cm*bank*4)*16
		nw_128 = (cm*bank*4)*32
		nw_192 = (cm*bank*4)*48
		nw_256 = (cm*bank*4)*64
		if nw<nw_32:tmp_nw=32;
		elif nw<nw_64:tmp_nw=64;
		elif nw<nw_128:tmp_nw=128;
		elif nw<nw_192:tmp_nw=192;
		elif nw<nw_256:tmp_nw=256;
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/wa_"+str(wa)+"/bk_"+str(bank)
		for tbk in [1,2]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for twa in [0,1]:
							if twa == 0:
								if redx == 1 and cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank:  
									if tname in check.keys():
										pass
									else:  
										all[tname] = i1;check[tname] = 1
							else:	
								if redx == 1 and cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank:
									tname = tname+str(tmp_nw)  
									if tname in check.keys():
										pass
									else:  
										all[tname] = i1;check[tname] = 1
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				#print "x=",x
				if "vdda_1" in x:
					#print "x=",x
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				#print "x=",x
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def gcen (vdda,buf,cmn,cm_diff_m):
	#print "gcen function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		nw = int(all_p[nw_n][i1])
		xdec_bk = nw/(cm*bank*4)
		nw_32 = (cm*bank*4)*8
		nw_64 = (cm*bank*4)*16
		nw_128 = (cm*bank*4)*32
		nw_192 = (cm*bank*4)*48
		nw_256 = (cm*bank*4)*64
		if nw<nw_32:tmp_nw=32;
		elif nw<nw_64:tmp_nw=64;
		elif nw<nw_128:tmp_nw=128;
		elif nw<nw_192:tmp_nw=192;
		elif nw<nw_256:tmp_nw=256;
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/wa_"+str(wa)+"/bk_"+str(bank)+"/pg_"+str(pg)+"/red_"+str(redx)
		for tbk in [1]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for twa in [0,1]:
							for tpg in [0,1]:
								for tred in [0,1]:
									for tbist in [0,1]:
										if twa == 0:
											if cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank and pg == tpg and redx == tred and bist == tbist:  
												if tname in check.keys():
													pass
												else:  
													all[tname] = i1;check[tname] = 1
										else:	
								
											if cd ==tcd and cm == tcm and shift == tvdda and wa == twa and tbk == bank and pg == tpg and redx == tred and bist == tbist:
												tname = tname+str(tmp_nw)  
												if tname in check.keys():
													pass
												else:  
													all[tname] = i1;check[tname] = 1
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def gpg (vdda,buf,cmn):
	#print "gpg function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)+"pg_1"
		for tbk in [1,8]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for tbist in [0,1]:
							if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank and pg == 1 and bist == tbist:  
								if tname in check.keys():
									pass
								else:  
									all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1':
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1':
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def bcen (vdda,buf,cmn,cm_diff_m):
	#print "bcen function" 
	all_cm = {}
	all = {}
	check = {}
	for i1 in range(len(all_p[bk_n])):
		bank = int(all_p[bk_n][i1])
		bist = int(all_p[bist_n][i1])
		shift = int(all_p[vdda_n][i1])
		redx = int(all_p[red_n][i1])
		cm =  int(all_p[cm_n][i1])
		cd = int(all_p[cd_n][i1])
		pg = int(all_p[pg_n][i1])
		wa = int(all_p[wa_n][i1])
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)+"/pg_"+str(pg)
		for tbk in [1]:
			for tcd in [0,1]:
				for tcm in [1,2,4,8,16]:
					for tvdda in [0,1]:
						for tpg in [0,1]:
							if cd ==tcd and cm == tcm and shift == tvdda and tbk == bank and bist == 1 and pg == tpg:  
								if tname in check.keys():
									pass
								else:  
									all[tname] = i1;check[tname] = 1
								
										
	ret_numbers = []
	get_comp = []
	if buf == '1': 
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				if "vdda_1" in x:
					all_cm[x] = all[x]
		else:
			all_cm = all
	else:
		if vdda == '1' and cm_diff_m != "diff":
			for x in all.keys():
				tt = "cm_" + cmn
				if (tt in x) and ("vdda_1" in x):
					all_cm[x] = all[x]
		else:
			for x in all.keys():
				tt = "cm_" + cmn
				if tt in x:
					all_cm[x] = all[x]
			
	for k in all_cm.keys():
		ret_numbers.append(all_cm[k])
	for i in ret_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;	
#################################################################################################
#################################################################################################
def pin (vdda,buf,cmn):
	print "pin function" 
	return;
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
def create_tcl (x,y):
	file_tcl = open("new_tcl.tcl","w")
	for i in y:
		tmp = ""
		for t in i:
			tmp = tmp + t + " "
		tmp = tmp + "\n"
		file_tcl.write(tmp)
	file_tcl.write("\n \n \n")
	for i in x:
		file_tcl.write(i+"\n")
	file_tcl.close()
	return 0;
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
if row == "wk_bk2":
	#print "wk_bk2"
	ins = wk_bk2 (lsh,buf,cm);
elif row == "rw":
	#print "rw"
	ins = rw (lsh,buf,cm);
elif row == "xdec":
	#print "xdec"
	ins = xdec (lsh,buf,cm);
elif row == "lcen":
	#print "lcen"
	ins = lcen (lsh,buf,cm);
elif row == "lpg":
	#print "lpg"
	ins = lpg (lsh,buf,cm);
elif row == "sac":
	#print "sac"
	ins = sac (lsh,buf,cm,cm_diff);
elif row == "sac_wa":
	#print "sac_wa"
	ins = sac_wa (lsh,buf,cm);
elif row == "red":
	#print "red"
	ins = red (lsh,buf,cm);
elif row == "gcen":
	#print "gcen"
	ins = gcen (lsh,buf,cm,cm_diff);
elif row == "gpg":
	#print "gpg"
	ins = gpg (lsh,buf,cm,cm_diff);
elif row == "bcen":
	#print "bcen"
	ins = bcen (lsh,buf,cm,cm_diff);
elif row == "bcen_mux":
	#print "bcen_mux"
	ins = bcen (lsh,buf,cm);
elif row == "pin":
	#print "pin"
	ins = pin (lsh,buf,cm);
else:
	print "Give me please row name from this range 'wk_bk2 rw xdec lcen lpg sac sac_wa red gcen gpg bcen bcen_mux pin'"
	sys.exit(0)

create_tcl (ins,header);
print "Tcl file creating is done.Please check new_tcl.tcl file"
print "FINISH"
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
