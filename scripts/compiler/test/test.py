#################################################################################################
#this program was wrotten for make compiler minumum combination for getting issues  #############
#################################################################################################
#################################################################################################

import sys
import os
if len(sys.argv) == 6:
	#print "All is Rigth"
	pass
else:
	print "You must write rigth parameters"
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
	
#for t1 in insts:
	#print " ".join(t1)
#print "header is ",new_header
new_header.pop(0)
#print "header is ",new_header
all_p = []
header_l = len(new_header)
testname = insts[0][1]


for x in range(header_l):
	all_px = []
	for t1 in insts:
		all_px.append(t1[x+2])
	all_p.append(all_px)
	
#print "lx = ",len(new_header)
#print "ll = ",len(all_p)
#print all_p[15][0]

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
#print "new_header = ",new_header
#print "nw_n = ",nw_n
#print "nb_n = ",nb_n
#print "cm_n = ",cm_n
#print "bk_n = ",bk_n
def getcomp_withn (n,all):
	tmp = ""
	for i in all:
		tmp = tmp + " " + i[n]
	tmp = "add_inst" + " " + testname + " " + tmp
	#print "tmp = ",tmp
	return tmp;
getcomp_withn(5,all_p);		
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
def wk_bk2 (vdda,buf,cmn):
	print "wk_bk2 function"
	#print new_header
	get_comp_numbers = []
	cm1c1 = 0;cm1c2 = 0;cm1c3 = 0;cm1c4 = 0;cm1c5 = 0;cm1c6 = 0;
	cm2c1 = 0;cm2c2 = 0;cm2c3 = 0;cm2c4 = 0;cm2c5 = 0;cm2c6 = 0;
	cm4c1 = 0;cm4c2 = 0;cm4c3 = 0;cm4c4 = 0;cm4c5 = 0;cm4c6 = 0;
	cm8c1 = 0;cm8c2 = 0;cm8c3 = 0;cm8c4 = 0;cm8c5 = 0;cm8c6 = 0;
	cm16c1 = 0;cm16c2 = 0;cm16c3 = 0;cm16c4 = 0;cm16c5 = 0;cm16c6 = 0;
	cm1n1 = "na";cm1n2 = "na";cm1n3 = "na";cm1n4 = "na";cm1n5 = "na";cm1n6 = "na";
	cm2n1 = "na";cm2n2 = "na";cm2n3 = "na";cm2n4 = "na";cm2n5 = "na";cm2n6 = "na";
	cm4n1 = "na";cm4n2 = "na";cm4n3 = "na";cm4n4 = "na";cm4n5 = "na";cm4n6 = "na";
	cm8n1 = "na";cm8n2 = "na";cm8n3 = "na";cm8n4 = "na";cm8n5 = "na";cm8n6 = "na";
	cm16n1 = "na";cm16n2 = "na";cm16n3 = "na";cm16n4 = "na";cm16n5 = "na";cm16n6 = "na";
#######################################################################################################################################################
#######################################################################################################################################################		
	cm1c10 = 0;cm1c20 = 0;cm1c30 = 0;cm1c40 = 0;cm1c50 = 0;cm1c60 = 0;
	cm2c10 = 0;cm2c20 = 0;cm2c30 = 0;cm2c40 = 0;cm2c50 = 0;cm2c60 = 0;
	cm4c10 = 0;cm4c20 = 0;cm4c30 = 0;cm4c40 = 0;cm4c50 = 0;cm4c60 = 0;
	cm8c10 = 0;cm8c20 = 0;cm8c30 = 0;cm8c40 = 0;cm8c50 = 0;cm8c60 = 0;
	cm16c10 = 0;cm16c20 = 0;cm16c30 = 0;cm16c40 = 0;cm16c50 = 0;cm16c60 = 0;
	cm1n10 = "na";cm1n20 = "na";cm1n30 = "na";cm1n40 = "na";cm1n50 = "na";cm1n60 = "na";
	cm2n10 = "na";cm2n20 = "na";cm2n30 = "na";cm2n40 = "na";cm2n50 = "na";cm2n60 = "na";
	cm4n10 = "na";cm4n20 = "na";cm4n30 = "na";cm4n40 = "na";cm4n50 = "na";cm4n60 = "na";
	cm8n10 = "na";cm8n20 = "na";cm8n30 = "na";cm8n40 = "na";cm8n50 = "na";cm8n60 = "na";
	cm16n10 = "na";cm16n20 = "na";cm16n30 = "na";cm16n40 = "na";cm16n50 = "na";cm16n60 = "na";
	for i1 in range(len(all_p[bk_n])):
		ii2 = all_p[bk_n][i1]
		ii1 = all_p[vdda_n][i1]
		ii0 = all_p[red_n][i1]
		cm =  all_p[cm_n][i1]
		cd = all_p[cd_n][i1]
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm1c1 == 0 and cm == "1" and cd == '1':  cm1n1 = i1;cm1c1 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm1c2 == 0 and cm == "1" and cd == '1':  cm1n2 = i1;cm1c2 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm1c3 == 0 and cm == "1" and cd == '1':  cm1n3 = i1;cm1c3 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm1c4 == 0 and cm == "1" and cd == '1':  cm1n4 = i1;cm1c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm1c5 == 0   and cm == "1" and cd == '1':	       cm1n5 = i1;cm1c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm1c6 == 0   and cm == "1" and cd == '1':     	       cm1n6 = i1;cm1c6 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm2c1 == 0 and cm == "2" and cd == '1':  cm2n1 = i1;cm2c1 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm2c2 == 0 and cm == "2" and cd == '1':  cm2n2 = i1;cm2c2 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm2c3 == 0 and cm == "2" and cd == '1':  cm2n3 = i1;cm2c3 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm2c4 == 0 and cm == "2" and cd == '1':  cm2n4 = i1;cm2c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm2c5 == 0   and cm == "2" and cd == '1':	       cm2n5 = i1;cm2c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm2c6 == 0   and cm == "2" and cd == '1':     	       cm2n6 = i1;cm2c6 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm4c1 == 0 and cm == "4" and cd == '1':  cm4n1 = i1;cm4c1 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm4c2 == 0 and cm == "4" and cd == '1':  cm4n2 = i1;cm4c2 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm4c3 == 0 and cm == "4" and cd == '1':  cm4n3 = i1;cm4c3 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm4c4 == 0 and cm == "4" and cd == '1':  cm4n4 = i1;cm4c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm4c5 == 0   and cm == "4" and cd == '1':	       cm4n5 = i1;cm4c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm4c6 == 0   and cm == "4" and cd == '1':     	       cm4n6 = i1;cm4c6 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm8c1 == 0 and cm == "8" and cd == '1':  cm8n1 = i1;cm8c1 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm8c2 == 0 and cm == "8" and cd == '1':  cm8n2 = i1;cm8c2 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm8c3 == 0 and cm == "8" and cd == '1':  cm8n3 = i1;cm8c3 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm8c4 == 0 and cm == "8" and cd == '1':  cm8n4 = i1;cm8c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm8c5 == 0   and cm == "8" and cd == '1':	             	       cm8n5 = i1;cm8c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm8c6 == 0   and cm == "8" and cd == '1':     	               cm8n6 = i1;cm8c6 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm16c1 == 0 and cm == "16" and cd == '1':  cm16n1 = i1;cm16c1 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm16c2 == 0 and cm == "16" and cd == '1':  cm16n2 = i1;cm16c2 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm16c3 == 0 and cm == "16" and cd == '1':  cm16n3 = i1;cm16c3 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm16c4 == 0 and cm == "16" and cd == '1':  cm16n4 = i1;cm16c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm16c5 == 0   and cm == "16" and cd == '1':	         cm16n5 = i1;cm16c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm16c6 == 0   and cm == "16" and cd == '1':     	 cm16n6 = i1;cm16c6 = 1
######################################################################################################################################################
######################################################################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm1c10 == 0 and cm == "1" and cd == '0':  cm1n10 = i1;cm1c10 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm1c20 == 0 and cm == "1" and cd == '0':  cm1n20 = i1;cm1c20 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm1c30 == 0 and cm == "1" and cd == '0':  cm1n30 = i1;cm1c30 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm1c40 == 0 and cm == "1" and cd == '0':  cm1n40 = i1;cm1c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm1c50 == 0   and cm == "1" and cd == '0':	       cm1n50 = i1;cm1c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm1c60 == 0   and cm == "1" and cd == '0':     	       cm1n60 = i1;cm1c60 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm2c10 == 0 and cm == "2" and cd == '0':  cm2n10 = i1;cm2c10 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm2c20 == 0 and cm == "2" and cd == '0':  cm2n20 = i1;cm2c20 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm2c30 == 0 and cm == "2" and cd == '0':  cm2n30 = i1;cm2c30 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm2c40 == 0 and cm == "2" and cd == '0':  cm2n40 = i1;cm2c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm2c50 == 0   and cm == "2" and cd == '0':	       cm2n50 = i1;cm2c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm2c60 == 0   and cm == "2" and cd == '0':     	       cm2n60 = i1;cm2c60 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm4c10 == 0 and cm == "4" and cd == '0':  cm4n10 = i1;cm4c10 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm4c20 == 0 and cm == "4" and cd == '0':  cm4n20 = i1;cm4c20 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm4c30 == 0 and cm == "4" and cd == '0':  cm4n30 = i1;cm4c30 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm4c40 == 0 and cm == "4" and cd == '0':  cm4n40 = i1;cm4c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm4c50 == 0   and cm == "4" and cd == '0':	       cm4n50 = i1;cm4c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm4c60 == 0   and cm == "4" and cd == '0':     	       cm4n60 = i1;cm4c60 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm8c10 == 0 and cm == "8" and cd == '0':  cm8n10 = i1;cm8c10 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm8c20 == 0 and cm == "8" and cd == '0':  cm8n20 = i1;cm8c20 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm8c30 == 0 and cm == "8" and cd == '0':  cm8n30 = i1;cm8c30 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm8c40 == 0 and cm == "8" and cd == '0':  cm8n40 = i1;cm8c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm8c50 == 0   and cm == "8" and cd == '0':	             	       cm8n50 = i1;cm8c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm8c60 == 0   and cm == "8" and cd == '0':     	               cm8n60 = i1;cm8c60 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and ii0 =='0' and cm16c10 == 0 and cm == "16" and cd == '0':  cm16n10 = i1;cm16c10 = 1
		elif ii2 == '2' and ii1 == '0'  and ii0 =='1' and cm16c20 == 0 and cm == "16" and cd == '0':  cm16n20 = i1;cm16c20 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='1' and cm16c30 == 0 and cm == "16" and cd == '0':  cm16n30 = i1;cm16c30 = 1
		elif ii2 == '2' and ii1 == '1'  and ii0 =='0' and cm16c40 == 0 and cm == "16" and cd == '0':  cm16n40 = i1;cm16c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm16c50 == 0   and cm == "16" and cd == '0':	         cm16n50 = i1;cm16c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm16c60 == 0   and cm == "16" and cd == '0':     	 cm16n60 = i1;cm16c60 = 1
		#################################################################################################
	if buf == '1':
		if vdda != '1':
			get_comp_numbers = [cm1n1,cm1n2,cm1n5,cm2n1,cm2n2,cm2n5,cm4n1,cm4n2,cm4n5,cm8n1,cm8n2,cm8n5,cm16n1,cm16n2,cm16n5,cm1n10,cm1n20,cm1n50,cm2n10,cm2n20,cm2n50,cm4n10,cm4n20,cm4n50,cm8n10,cm8n20,cm8n50,cm16n10,cm16n20,cm16n50]
		if cm1n3 != "na":   get_comp_numbers.append(cm1n3)
		elif cm2n3 != "na": get_comp_numbers.append(cm2n3)
		elif cm4n3 != "na": get_comp_numbers.append(cm4n3)
		elif cm8n3 != "na": get_comp_numbers.append(cm8n3)
		elif cm16n3 != "na":get_comp_numbers.append(cm16n3)
		if cm1n6 != "na":   get_comp_numbers.append(cm1n6)
		elif cm2n6 != "na": get_comp_numbers.append(cm2n6)
		elif cm4n6 != "na": get_comp_numbers.append(cm4n6)
		elif cm8n6 != "na": get_comp_numbers.append(cm8n6)
		elif cm16n6 != "na":get_comp_numbers.append(cm16n6)
		if cm1n4 != "na":   get_comp_numbers.append(cm1n4)
		elif cm2n4 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n4 != "na": get_comp_numbers.append(cm4n4)
		elif cm8n4 != "na": get_comp_numbers.append(cm8n4)
		elif cm16n4 != "na":get_comp_numbers.append(cm16n4)
		if cm1n30 != "na":   get_comp_numbers.append(cm1n30)
		elif cm2n30 != "na": get_comp_numbers.append(cm2n30)
		elif cm4n30 != "na": get_comp_numbers.append(cm4n30)
		elif cm8n30 != "na": get_comp_numbers.append(cm8n30)
		elif cm16n30 != "na":get_comp_numbers.append(cm16n30)
		if cm1n60 != "na":   get_comp_numbers.append(cm1n60)
		elif cm2n60 != "na": get_comp_numbers.append(cm2n60)
		elif cm4n60 != "na": get_comp_numbers.append(cm4n60)
		elif cm8n60 != "na": get_comp_numbers.append(cm8n60)
		elif cm16n60 != "na":get_comp_numbers.append(cm16n60)
		if cm1n40 != "na":   get_comp_numbers.append(cm1n40)
		elif cm2n40 != "na": get_comp_numbers.append(cm2n40)
		elif cm4n40 != "na": get_comp_numbers.append(cm4n40)
		elif cm8n40 != "na": get_comp_numbers.append(cm8n40)
		elif cm16n40 != "na":get_comp_numbers.append(cm16n40)
	else:
		if vdda != '1':
			if cmn == '1':get_comp_numbers = [cm1n3,cm1n4,cm1n6,cm1n30,cm1n40,cm1n60]
			if cmn == '2':get_comp_numbers = [cm2n3,cm2n4,cm2n6,cm2n30,cm2n40,cm2n60]
			if cmn == '4':get_comp_numbers = [cm4n3,cm4n4,cm4n6,cm4n30,cm4n40,cm4n60]
			if cmn == '8':get_comp_numbers = [cm8n3,cm8n4,cm8n6,cm8n30,cm8n40,cm8n60]
			if cmn == '16':get_comp_numbers = [cm16n3,cm16n4,cm16n6,cm16n30,cm16n40,cm16n60]
		else:	
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n2,cm1n3,cm1n4,cm1n5,cm1n6,cm1n10,cm1n20,cm1n30,cm1n40,cm1n50,cm1n60]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n2,cm2n3,cm2n4,cm2n5,cm2n6,cm2n10,cm2n20,cm2n30,cm2n40,cm2n50,cm2n60]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n2,cm4n3,cm4n4,cm4n5,cm4n6,cm4n10,cm4n20,cm4n30,cm4n40,cm4n50,cm4n60]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n2,cm8n3,cm8n4,cm8n5,cm8n6,cm8n10,cm8n20,cm8n30,cm8n40,cm8n50,cm8n60]
			if cmn == '16':get_comp_numbers =[cm16n1,cm16n2,cm16n3,cm16n4,cm16n5,cm16n6,cm16n10,cm16n20,cm16n30,cm16n40,cm16n50,cm16n60]	
	get_comp = []
	print "get_comp_numbers = ",get_comp_numbers
	for i in get_comp_numbers:
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
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
def rw (vdda,buf,cmn):
	print "rw function" 
	get_comp_numbers = []
	cm1c1 = 0;cm1c2 = 0;cm1c3 = 0;cm1c4 = 0;
	cm2c1 = 0;cm2c2 = 0;cm2c3 = 0;cm2c4 = 0;
	cm4c1 = 0;cm4c2 = 0;cm4c3 = 0;cm4c4 = 0;
	cm8c1 = 0;cm8c2 = 0;cm8c3 = 0;cm8c4 = 0;
	cm16c1 = 0;cm16c2 = 0;cm16c3 = 0;cm16c4 = 0;
	cm1n1 = "na";cm1n2 = "na";cm1n3 = "na";cm1n4 = "na";
	cm2n1 = "na";cm2n2 = "na";cm2n3 = "na";cm2n4 = "na";
	cm4n1 = "na";cm4n2 = "na";cm4n3 = "na";cm4n4 = "na";
	cm8n1 = "na";cm8n2 = "na";cm8n3 = "na";cm8n4 = "na";
	cm16n1 = "na";cm16n2 = "na";cm16n3 = "na";cm16n4 = "na";
#######################################################################################################################################################
#######################################################################################################################################################		
	cm1c10 = 0;cm1c20 = 0;cm1c30 = 0;cm1c40 = 0;
	cm2c10 = 0;cm2c20 = 0;cm2c30 = 0;cm2c40 = 0;
	cm4c10 = 0;cm4c20 = 0;cm4c30 = 0;cm4c40 = 0;
	cm8c10 = 0;cm8c20 = 0;cm8c30 = 0;cm8c40 = 0;
	cm16c10 = 0;cm16c20 = 0;cm16c30 = 0;cm16c40 = 0;
	cm1n10 = "na";cm1n20 = "na";cm1n30 = "na";cm1n40 = "na";
	cm2n10 = "na";cm2n20 = "na";cm2n30 = "na";cm2n40 = "na";
	cm4n10 = "na";cm4n20 = "na";cm4n30 = "na";cm4n40 = "na";
	cm8n10 = "na";cm8n20 = "na";cm8n30 = "na";cm8n40 = "na";
	cm16n10 = "na";cm16n20 = "na";cm16n30 = "na";cm16n40 = "na";
	for i1 in range(len(all_p[bk_n])):
		bank = all_p[bk_n][i1]
		shift = all_p[vdda_n][i1]
		redx = all_p[red_n][i1]
		cm =  all_p[cm_n][i1]
		cd = all_p[cd_n][i1]
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '1':  cm1n1 = i1;cm1c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '1':  cm1n2 = i1;cm1c2 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "1" and cd == '1':	cm1n3 = i1;cm1c3 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "1" and cd == '1':  cm1n4 = i1;cm1c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "2" and cd == '1':  cm2n1 = i1;cm2c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "2" and cd == '1':  cm2n2 = i1;cm2c2 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "2" and cd == '1':	cm2n3 = i1;cm2c3 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "2" and cd == '1':  cm2n4 = i1;cm2c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "4" and cd == '1':  cm4n1 = i1;cm4c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "4" and cd == '1':  cm4n2 = i1;cm4c2 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "4" and cd == '1':	cm4n3 = i1;cm4c3 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "4" and cd == '1':  cm4n4 = i1;cm4c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "8" and cd == '1':  cm8n1 = i1;cm8c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "8" and cd == '1':  cm8n2 = i1;cm8c2 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "8" and cd == '1':	cm8n3 = i1;cm8c3 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "8" and cd == '1':  cm8n4 = i1;cm8c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "16" and cd == '1':  cm16n1 = i1;cm16c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "16" and cd == '1':  cm16n2 = i1;cm16c2 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "16" and cd == '1':	cm16n3 = i1;cm16c3 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "16" and cd == '1':  cm16n4 = i1;cm16c4 = 1
######################################################################################################################################################
		######################################################################################################################################
######################################################################################################################################################
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '0':  cm1n10 = i1;cm1c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '0':  cm1n20 = i1;cm1c20 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "1" and cd == '0':	cm1n30 = i1;cm1c30 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "1" and cd == '0':  cm1n40 = i1;cm1c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "2" and cd == '0':  cm2n10 = i1;cm2c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "2" and cd == '0':  cm2n20 = i1;cm2c20 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "2" and cd == '0':	cm2n30 = i1;cm2c30 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "2" and cd == '0':  cm2n40 = i1;cm2c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "4" and cd == '0':  cm4n10 = i1;cm4c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "4" and cd == '0':  cm4n20 = i1;cm4c20 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "4" and cd == '0':	cm4n30 = i1;cm4c30 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "4" and cd == '0':  cm4n40 = i1;cm4c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "8" and cd == '0':  cm8n10 = i1;cm8c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "8" and cd == '0':  cm8n20 = i1;cm8c20 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "8" and cd == '0':	cm8n30 = i1;cm8c30 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "8" and cd == '0':  cm8n40 = i1;cm8c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "16" and cd == '0':  cm16n10 = i1;cm16c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "16" and cd == '0':  cm16n20 = i1;cm16c20 = 1
		elif bank == '4' and shift == '0'  and cm1c3 == 0 and cm == "16" and cd == '0':	cm16n30 = i1;cm16c30 = 1
		elif bank == '4' and shift == '1'  and cm1c4 == 0 and cm == "16" and cd == '0':  cm16n40 = i1;cm16c40 = 1
		#################################################################################################
	if buf == '1':
		if vdda != '1':
			get_comp_numbers = [cm1n1,cm1n3,cm2n1,cm2n3,cm4n1,cm4n3,cm8n1,cm8n3,cm16n1,cm16n3,cm1n10,cm1n30,cm2n10,cm2n30,cm4n10,cm4n30,cm8n10,cm8n30,cm16n10,cm16n30]
		if cm1n4 != "na":   get_comp_numbers.append(cm1n4)
		elif cm2n4 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n4 != "na": get_comp_numbers.append(cm4n4)
		elif cm8n4 != "na": get_comp_numbers.append(cm8n4)
		elif cm16n4 != "na":get_comp_numbers.append(cm16n4)
		if cm1n2 != "na":   get_comp_numbers.append(cm1n2)
		elif cm2n2 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n2 != "na": get_comp_numbers.append(cm4n2)
		elif cm8n2 != "na": get_comp_numbers.append(cm8n2)
		elif cm16n2 != "na":get_comp_numbers.append(cm16n2)
		if cm1n40 != "na":   get_comp_numbers.append(cm1n40)
		elif cm2n40 != "na": get_comp_numbers.append(cm2n40)
		elif cm4n40 != "na": get_comp_numbers.append(cm4n40)
		elif cm8n40 != "na": get_comp_numbers.append(cm8n40)
		elif cm16n40 != "na":get_comp_numbers.append(cm16n40)
		if cm1n20 != "na":   get_comp_numbers.append(cm1n20)
		elif cm2n20 != "na": get_comp_numbers.append(cm2n20)
		elif cm4n20 != "na": get_comp_numbers.append(cm4n20)
		elif cm8n20 != "na": get_comp_numbers.append(cm8n20)
		elif cm16n20 != "na":get_comp_numbers.append(cm16n20)
	else:
		if vdda != '1':
			if cmn == '1':get_comp_numbers = [cm1n3,cm1n1,cm1n30,cm1n10]
			if cmn == '2':get_comp_numbers = [cm2n3,cm2n1,cm2n30,cm2n10]
			if cmn == '4':get_comp_numbers = [cm4n3,cm4n1,cm4n30,cm4n10]
			if cmn == '8':get_comp_numbers = [cm8n3,cm8n1,cm8n30,cm8n10]
			if cmn == '16':get_comp_numbers = [cm16n3,cm16n1,cm16n30,cm16n10]
		else:	
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n2,cm1n3,cm1n4,cm1n10,cm1n20,cm1n30,cm1n40]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n2,cm2n3,cm2n4,cm2n10,cm2n20,cm2n30,cm2n40]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n2,cm4n3,cm4n4,cm4n10,cm4n20,cm4n30,cm4n40]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n2,cm8n3,cm8n4,cm8n10,cm8n20,cm8n30,cm8n40]
			if cmn == '16':get_comp_numbers =[cm16n1,cm16n2,cm16n3,cm16n4,cm16n10,cm16n20,cm16n30,cm16n40]	
	get_comp = []
	print "get_comp_numbers = ",get_comp_numbers
	for i in get_comp_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#################################################################################################
#################################################################################################
def xdec (vdda,buf,cmn):
	print "xdec function" 
	get_comp_numbers = []
	cm1c1 = 0;cm1c2 = 0;cm1c3 = 0;cm1c4 = 0;
	cm2c1 = 0;cm2c2 = 0;cm2c3 = 0;cm2c4 = 0;
	cm4c1 = 0;cm4c2 = 0;cm4c3 = 0;cm4c4 = 0;
	cm8c1 = 0;cm8c2 = 0;cm8c3 = 0;cm8c4 = 0;
	cm16c1 = 0;cm16c2 = 0;cm16c3 = 0;cm16c4 = 0;
	cm1n1 = "na";cm1n2 = "na";cm1n3 = "na";cm1n4 = "na";
	cm2n1 = "na";cm2n2 = "na";cm2n3 = "na";cm2n4 = "na";
	cm4n1 = "na";cm4n2 = "na";cm4n3 = "na";cm4n4 = "na";
	cm8n1 = "na";cm8n2 = "na";cm8n3 = "na";cm8n4 = "na";
	cm16n1 = "na";cm16n2 = "na";cm16n3 = "na";cm16n4 = "na";
#######################################################################################################################################################
#######################################################################################################################################################		
	cm1c10 = 0;cm1c20 = 0;cm1c30 = 0;cm1c40 = 0;
	cm2c10 = 0;cm2c20 = 0;cm2c30 = 0;cm2c40 = 0;
	cm4c10 = 0;cm4c20 = 0;cm4c30 = 0;cm4c40 = 0;
	cm8c10 = 0;cm8c20 = 0;cm8c30 = 0;cm8c40 = 0;
	cm16c10 = 0;cm16c20 = 0;cm16c30 = 0;cm16c40 = 0;
	cm1n10 = "na";cm1n20 = "na";cm1n30 = "na";cm1n40 = "na";
	cm2n10 = "na";cm2n20 = "na";cm2n30 = "na";cm2n40 = "na";
	cm4n10 = "na";cm4n20 = "na";cm4n30 = "na";cm4n40 = "na";
	cm8n10 = "na";cm8n20 = "na";cm8n30 = "na";cm8n40 = "na";
	cm16n10 = "na";cm16n20 = "na";cm16n30 = "na";cm16n40 = "na";
	for i1 in range(len(all_p[bk_n])):
		bank = all_p[bk_n][i1]
		shift = all_p[vdda_n][i1]
		redx = all_p[red_n][i1]
		cm =  all_p[cm_n][i1]
		cd = all_p[cd_n][i1]
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '1':  cm1n1 = i1;cm1c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '1':  cm1n2 = i1;cm1c2 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "1" and cd == '1':	cm1n3 = i1;cm1c3 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "1" and cd == '1':  cm1n4 = i1;cm1c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "2" and cd == '1':  cm2n1 = i1;cm2c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "2" and cd == '1':  cm2n2 = i1;cm2c2 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "2" and cd == '1':	cm2n3 = i1;cm2c3 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "2" and cd == '1':  cm2n4 = i1;cm2c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "4" and cd == '1':  cm4n1 = i1;cm4c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "4" and cd == '1':  cm4n2 = i1;cm4c2 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "4" and cd == '1':	cm4n3 = i1;cm4c3 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "4" and cd == '1':  cm4n4 = i1;cm4c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "8" and cd == '1':  cm8n1 = i1;cm8c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "8" and cd == '1':  cm8n2 = i1;cm8c2 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "8" and cd == '1':	cm8n3 = i1;cm8c3 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "8" and cd == '1':  cm8n4 = i1;cm8c4 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "16" and cd == '1':  cm16n1 = i1;cm16c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "16" and cd == '1':  cm16n2 = i1;cm16c2 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "16" and cd == '1':	cm16n3 = i1;cm16c3 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "16" and cd == '1':  cm16n4 = i1;cm16c4 = 1
######################################################################################################################################################
		######################################################################################################################################
######################################################################################################################################################
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '0':  cm1n10 = i1;cm1c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '0':  cm1n20 = i1;cm1c20 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "1" and cd == '0':	cm1n30 = i1;cm1c30 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "1" and cd == '0':  cm1n40 = i1;cm1c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "2" and cd == '0':  cm2n10 = i1;cm2c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "2" and cd == '0':  cm2n20 = i1;cm2c20 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "2" and cd == '0':	cm2n30 = i1;cm2c30 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "2" and cd == '0':  cm2n40 = i1;cm2c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "4" and cd == '0':  cm4n10 = i1;cm4c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "4" and cd == '0':  cm4n20 = i1;cm4c20 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "4" and cd == '0':	cm4n30 = i1;cm4c30 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "4" and cd == '0':  cm4n40 = i1;cm4c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "8" and cd == '0':  cm8n10 = i1;cm8c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "8" and cd == '0':  cm8n20 = i1;cm8c20 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "8" and cd == '0':	cm8n30 = i1;cm8c30 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "8" and cd == '0':  cm8n40 = i1;cm8c40 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "16" and cd == '0':  cm16n10 = i1;cm16c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "16" and cd == '0':  cm16n20 = i1;cm16c20 = 1
		elif bank == '2' and shift == '0'  and cm1c3 == 0 and cm == "16" and cd == '0':	cm16n30 = i1;cm16c30 = 1
		elif bank == '2' and shift == '1'  and cm1c4 == 0 and cm == "16" and cd == '0':  cm16n40 = i1;cm16c40 = 1
		#################################################################################################
	if buf == '1':
		if vdda != '1':
			get_comp_numbers = [cm1n1,cm1n3,cm2n1,cm2n3,cm4n1,cm4n3,cm8n1,cm8n3,cm16n1,cm16n3,cm1n10,cm1n30,cm2n10,cm2n30,cm4n10,cm4n30,cm8n10,cm8n30,cm16n10,cm16n30]
		if cm1n4 != "na":   get_comp_numbers.append(cm1n4)
		elif cm2n4 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n4 != "na": get_comp_numbers.append(cm4n4)
		elif cm8n4 != "na": get_comp_numbers.append(cm8n4)
		elif cm16n4 != "na":get_comp_numbers.append(cm16n4)
		if cm1n2 != "na":   get_comp_numbers.append(cm1n2)
		elif cm2n2 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n2 != "na": get_comp_numbers.append(cm4n2)
		elif cm8n2 != "na": get_comp_numbers.append(cm8n2)
		elif cm16n2 != "na":get_comp_numbers.append(cm16n2)
		if cm1n40 != "na":   get_comp_numbers.append(cm1n40)
		elif cm2n40 != "na": get_comp_numbers.append(cm2n40)
		elif cm4n40 != "na": get_comp_numbers.append(cm4n40)
		elif cm8n40 != "na": get_comp_numbers.append(cm8n40)
		elif cm16n40 != "na":get_comp_numbers.append(cm16n40)
		if cm1n20 != "na":   get_comp_numbers.append(cm1n20)
		elif cm2n20 != "na": get_comp_numbers.append(cm2n20)
		elif cm4n20 != "na": get_comp_numbers.append(cm4n20)
		elif cm8n20 != "na": get_comp_numbers.append(cm8n20)
		elif cm16n20 != "na":get_comp_numbers.append(cm16n20)
	else:
		if vdda != '1':
			if cmn == '1':get_comp_numbers = [cm1n3,cm1n1,cm1n30,cm1n10]
			if cmn == '2':get_comp_numbers = [cm2n3,cm2n1,cm2n30,cm2n10]
			if cmn == '4':get_comp_numbers = [cm4n3,cm4n1,cm4n30,cm4n10]
			if cmn == '8':get_comp_numbers = [cm8n3,cm8n1,cm8n30,cm8n10]
			if cmn == '16':get_comp_numbers = [cm16n3,cm16n1,cm16n30,cm16n10]
		else:	
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n2,cm1n3,cm1n4,cm1n10,cm1n20,cm1n30,cm1n40]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n2,cm2n3,cm2n4,cm2n10,cm2n20,cm2n30,cm2n40]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n2,cm4n3,cm4n4,cm4n10,cm4n20,cm4n30,cm4n40]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n2,cm8n3,cm8n4,cm8n10,cm8n20,cm8n30,cm8n40]
			if cmn == '16':get_comp_numbers =[cm16n1,cm16n2,cm16n3,cm16n4,cm16n10,cm16n20,cm16n30,cm16n40]	
	get_comp = []
	print "get_comp_numbers = ",get_comp_numbers
	for i in get_comp_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#################################################################################################
#################################################################################################
def lcen (vdda,buf,cmn):
	print "lcen function" 
	get_comp_numbers = []
	cm1c1 = 0;cm1c2 = 0;cm1c3 = 0;cm1c4 = 0;cm1c5 = 0;cm1c6 = 0;
	cm2c1 = 0;cm2c2 = 0;cm2c3 = 0;cm2c4 = 0;cm2c5 = 0;cm2c6 = 0;
	cm4c1 = 0;cm4c2 = 0;cm4c3 = 0;cm4c4 = 0;cm4c5 = 0;cm4c6 = 0;
	cm8c1 = 0;cm8c2 = 0;cm8c3 = 0;cm8c4 = 0;cm8c5 = 0;cm8c6 = 0;
	cm16c1 = 0;cm16c2 = 0;cm16c3 = 0;cm16c4 = 0;cm16c5 = 0;cm16c6 = 0;
	cm1n1 = "na";cm1n2 = "na";cm1n3 = "na";cm1n4 = "na";cm1n5 = "na";cm1n6 = "na";
	cm2n1 = "na";cm2n2 = "na";cm2n3 = "na";cm2n4 = "na";cm2n5 = "na";cm2n6 = "na";
	cm4n1 = "na";cm4n2 = "na";cm4n3 = "na";cm4n4 = "na";cm4n5 = "na";cm4n6 = "na";
	cm8n1 = "na";cm8n2 = "na";cm8n3 = "na";cm8n4 = "na";cm8n5 = "na";cm8n6 = "na";
	cm16n1 = "na";cm16n2 = "na";cm16n3 = "na";cm16n4 = "na";cm16n5 = "na";cm16n6 = "na";
#######################################################################################################################################################
#######################################################################################################################################################		
	cm1c10 = 0;cm1c20 = 0;cm1c30 = 0;cm1c40 = 0;cm1c50 = 0;cm1c60 = 0;
	cm2c10 = 0;cm2c20 = 0;cm2c30 = 0;cm2c40 = 0;cm2c50 = 0;cm2c60 = 0;
	cm4c10 = 0;cm4c20 = 0;cm4c30 = 0;cm4c40 = 0;cm4c50 = 0;cm4c60 = 0;
	cm8c10 = 0;cm8c20 = 0;cm8c30 = 0;cm8c40 = 0;cm8c50 = 0;cm8c60 = 0;
	cm16c10 = 0;cm16c20 = 0;cm16c30 = 0;cm16c40 = 0;cm16c50 = 0;cm16c60 = 0;
	cm1n10 = "na";cm1n20 = "na";cm1n30 = "na";cm1n40 = "na";cm1n50 = "na";cm1n60 = "na";
	cm2n10 = "na";cm2n20 = "na";cm2n30 = "na";cm2n40 = "na";cm2n50 = "na";cm2n60 = "na";
	cm4n10 = "na";cm4n20 = "na";cm4n30 = "na";cm4n40 = "na";cm4n50 = "na";cm4n60 = "na";
	cm8n10 = "na";cm8n20 = "na";cm8n30 = "na";cm8n40 = "na";cm8n50 = "na";cm8n60 = "na";
	cm16n10 = "na";cm16n20 = "na";cm16n30 = "na";cm16n40 = "na";cm16n50 = "na";cm16n60 = "na";
	for i1 in range(len(all_p[bk_n])):
		ii2 = all_p[bk_n][i1]
		ii1 = all_p[vdda_n][i1]
		pg = all_p[pg_n][i1]
		cm =  all_p[cm_n][i1]
		cd = all_p[cd_n][i1]
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm1c1 == 0 and cm == "1" and cd == '1':  cm1n1 = i1;cm1c1 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm1c2 == 0 and cm == "1" and cd == '1':  cm1n2 = i1;cm1c2 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm1c3 == 0 and cm == "1" and cd == '1':  cm1n3 = i1;cm1c3 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm1c4 == 0 and cm == "1" and cd == '1':  cm1n4 = i1;cm1c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm1c5 == 0   and cm == "1" and cd == '1':	       cm1n5 = i1;cm1c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm1c6 == 0   and cm == "1" and cd == '1':     	       cm1n6 = i1;cm1c6 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm2c1 == 0 and cm == "2" and cd == '1':  cm2n1 = i1;cm2c1 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm2c2 == 0 and cm == "2" and cd == '1':  cm2n2 = i1;cm2c2 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm2c3 == 0 and cm == "2" and cd == '1':  cm2n3 = i1;cm2c3 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm2c4 == 0 and cm == "2" and cd == '1':  cm2n4 = i1;cm2c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm2c5 == 0   and cm == "2" and cd == '1':	       cm2n5 = i1;cm2c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm2c6 == 0   and cm == "2" and cd == '1':     	       cm2n6 = i1;cm2c6 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm4c1 == 0 and cm == "4" and cd == '1':  cm4n1 = i1;cm4c1 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm4c2 == 0 and cm == "4" and cd == '1':  cm4n2 = i1;cm4c2 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm4c3 == 0 and cm == "4" and cd == '1':  cm4n3 = i1;cm4c3 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm4c4 == 0 and cm == "4" and cd == '1':  cm4n4 = i1;cm4c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm4c5 == 0   and cm == "4" and cd == '1':	       cm4n5 = i1;cm4c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm4c6 == 0   and cm == "4" and cd == '1':     	       cm4n6 = i1;cm4c6 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm8c1 == 0 and cm == "8" and cd == '1':  cm8n1 = i1;cm8c1 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm8c2 == 0 and cm == "8" and cd == '1':  cm8n2 = i1;cm8c2 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm8c3 == 0 and cm == "8" and cd == '1':  cm8n3 = i1;cm8c3 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm8c4 == 0 and cm == "8" and cd == '1':  cm8n4 = i1;cm8c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm8c5 == 0   and cm == "8" and cd == '1':	             	       cm8n5 = i1;cm8c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm8c6 == 0   and cm == "8" and cd == '1':     	               cm8n6 = i1;cm8c6 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm16c1 == 0 and cm == "16" and cd == '1':  cm16n1 = i1;cm16c1 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm16c2 == 0 and cm == "16" and cd == '1':  cm16n2 = i1;cm16c2 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm16c3 == 0 and cm == "16" and cd == '1':  cm16n3 = i1;cm16c3 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm16c4 == 0 and cm == "16" and cd == '1':  cm16n4 = i1;cm16c4 = 1
		elif ii2 == '4' and ii1 == '0'  and cm16c5 == 0   and cm == "16" and cd == '1':	         cm16n5 = i1;cm16c5 = 1
		elif ii2 == '4' and ii1 == '1'  and cm16c6 == 0   and cm == "16" and cd == '1':     	 cm16n6 = i1;cm16c6 = 1
######################################################################################################################################################
######################################################################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm1c10 == 0 and cm == "1" and cd == '0':  cm1n10 = i1;cm1c10 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm1c20 == 0 and cm == "1" and cd == '0':  cm1n20 = i1;cm1c20 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm1c30 == 0 and cm == "1" and cd == '0':  cm1n30 = i1;cm1c30 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm1c40 == 0 and cm == "1" and cd == '0':  cm1n40 = i1;cm1c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm1c50 == 0   and cm == "1" and cd == '0':	       cm1n50 = i1;cm1c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm1c60 == 0   and cm == "1" and cd == '0':     	       cm1n60 = i1;cm1c60 = 1
		#################################################################################################
		if   ii2 == '2' and ii1 == '0'  and pg =='0' and cm2c10 == 0 and cm == "2" and cd == '0':  cm2n10 = i1;cm2c10 = 1
		elif ii2 == '2' and ii1 == '0'  and pg =='1' and cm2c20 == 0 and cm == "2" and cd == '0':  cm2n20 = i1;cm2c20 = 1
		elif ii2 == '2' and ii1 == '1'  and pg =='1' and cm2c30 == 0 and cm == "2" and cd == '0':  cm2n30 = i1;cm2c30 = 1
		elif ii2 == '2' and ii1 == '1'  and pg =='0' and cm2c40 == 0 and cm == "2" and cd == '0':  cm2n40 = i1;cm2c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm2c50 == 0   and cm == "2" and cd == '0':	       cm2n50 = i1;cm2c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm2c60 == 0   and cm == "2" and cd == '0':     	       cm2n60 = i1;cm2c60 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm4c10 == 0 and cm == "4" and cd == '0':  cm4n10 = i1;cm4c10 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm4c20 == 0 and cm == "4" and cd == '0':  cm4n20 = i1;cm4c20 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm4c30 == 0 and cm == "4" and cd == '0':  cm4n30 = i1;cm4c30 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm4c40 == 0 and cm == "4" and cd == '0':  cm4n40 = i1;cm4c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm4c50 == 0   and cm == "4" and cd == '0':	       cm4n50 = i1;cm4c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm4c60 == 0   and cm == "4" and cd == '0':     	       cm4n60 = i1;cm4c60 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm8c10 == 0 and cm == "8" and cd == '0':  cm8n10 = i1;cm8c10 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm8c20 == 0 and cm == "8" and cd == '0':  cm8n20 = i1;cm8c20 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm8c30 == 0 and cm == "8" and cd == '0':  cm8n30 = i1;cm8c30 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm8c40 == 0 and cm == "8" and cd == '0':  cm8n40 = i1;cm8c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm8c50 == 0   and cm == "8" and cd == '0':	             	       cm8n50 = i1;cm8c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm8c60 == 0   and cm == "8" and cd == '0':     	               cm8n60 = i1;cm8c60 = 1
		#################################################################################################
		if   ii2 == '1' and ii1 == '0'  and pg =='0' and cm16c10 == 0 and cm == "16" and cd == '0':  cm16n10 = i1;cm16c10 = 1
		elif ii2 == '1' and ii1 == '0'  and pg =='1' and cm16c20 == 0 and cm == "16" and cd == '0':  cm16n20 = i1;cm16c20 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='1' and cm16c30 == 0 and cm == "16" and cd == '0':  cm16n30 = i1;cm16c30 = 1
		elif ii2 == '1' and ii1 == '1'  and pg =='0' and cm16c40 == 0 and cm == "16" and cd == '0':  cm16n40 = i1;cm16c40 = 1
		elif ii2 == '4' and ii1 == '0'  and cm16c50 == 0   and cm == "16" and cd == '0':	         cm16n50 = i1;cm16c50 = 1
		elif ii2 == '4' and ii1 == '1'  and cm16c60 == 0   and cm == "16" and cd == '0':     	 cm16n60 = i1;cm16c60 = 1
		#################################################################################################
	if buf == '1':
		if vdda != '1':
			get_comp_numbers = [cm1n1,cm1n2,cm1n5,cm2n1,cm2n2,cm2n5,cm4n1,cm4n2,cm4n5,cm8n1,cm8n2,cm8n5,cm16n1,cm16n2,cm16n5,cm1n10,cm1n20,cm1n50,cm2n10,cm2n20,cm2n50,cm4n10,cm4n20,cm4n50,cm8n10,cm8n20,cm8n50,cm16n10,cm16n20,cm16n50]
		if cm1n3 != "na":   get_comp_numbers.append(cm1n3)
		elif cm2n3 != "na": get_comp_numbers.append(cm2n3)
		elif cm4n3 != "na": get_comp_numbers.append(cm4n3)
		elif cm8n3 != "na": get_comp_numbers.append(cm8n3)
		elif cm16n3 != "na":get_comp_numbers.append(cm16n3)
		if cm1n6 != "na":   get_comp_numbers.append(cm1n6)
		elif cm2n6 != "na": get_comp_numbers.append(cm2n6)
		elif cm4n6 != "na": get_comp_numbers.append(cm4n6)
		elif cm8n6 != "na": get_comp_numbers.append(cm8n6)
		elif cm16n6 != "na":get_comp_numbers.append(cm16n6)
		if cm1n4 != "na":   get_comp_numbers.append(cm1n4)
		elif cm2n4 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n4 != "na": get_comp_numbers.append(cm4n4)
		elif cm8n4 != "na": get_comp_numbers.append(cm8n4)
		elif cm16n4 != "na":get_comp_numbers.append(cm16n4)
		if cm1n30 != "na":   get_comp_numbers.append(cm1n30)
		elif cm2n30 != "na": get_comp_numbers.append(cm2n30)
		elif cm4n30 != "na": get_comp_numbers.append(cm4n30)
		elif cm8n30 != "na": get_comp_numbers.append(cm8n30)
		elif cm16n30 != "na":get_comp_numbers.append(cm16n30)
		if cm1n60 != "na":   get_comp_numbers.append(cm1n60)
		elif cm2n60 != "na": get_comp_numbers.append(cm2n60)
		elif cm4n60 != "na": get_comp_numbers.append(cm4n60)
		elif cm8n60 != "na": get_comp_numbers.append(cm8n60)
		elif cm16n60 != "na":get_comp_numbers.append(cm16n60)
		if cm1n40 != "na":   get_comp_numbers.append(cm1n40)
		elif cm2n40 != "na": get_comp_numbers.append(cm2n40)
		elif cm4n40 != "na": get_comp_numbers.append(cm4n40)
		elif cm8n40 != "na": get_comp_numbers.append(cm8n40)
		elif cm16n40 != "na":get_comp_numbers.append(cm16n40)
	else:
		if vdda != '1':
			if cmn == '1':get_comp_numbers = [cm1n3,cm1n4,cm1n6,cm1n30,cm1n40,cm1n60]
			if cmn == '2':get_comp_numbers = [cm2n3,cm2n4,cm2n6,cm2n30,cm2n40,cm2n60]
			if cmn == '4':get_comp_numbers = [cm4n3,cm4n4,cm4n6,cm4n30,cm4n40,cm4n60]
			if cmn == '8':get_comp_numbers = [cm8n3,cm8n4,cm8n6,cm8n30,cm8n40,cm8n60]
			if cmn == '16':get_comp_numbers = [cm16n3,cm16n4,cm16n6,cm16n30,cm16n40,cm16n60]
		else:	
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n2,cm1n3,cm1n4,cm1n5,cm1n6,cm1n10,cm1n20,cm1n30,cm1n40,cm1n50,cm1n60]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n2,cm2n3,cm2n4,cm2n5,cm2n6,cm2n10,cm2n20,cm2n30,cm2n40,cm2n50,cm2n60]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n2,cm4n3,cm4n4,cm4n5,cm4n6,cm4n10,cm4n20,cm4n30,cm4n40,cm4n50,cm4n60]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n2,cm8n3,cm8n4,cm8n5,cm8n6,cm8n10,cm8n20,cm8n30,cm8n40,cm8n50,cm8n60]
			if cmn == '16':get_comp_numbers =[cm16n1,cm16n2,cm16n3,cm16n4,cm16n5,cm16n6,cm16n10,cm16n20,cm16n30,cm16n40,cm16n50,cm16n60]	
	get_comp = []
	print "get_comp_numbers = ",get_comp_numbers
	for i in get_comp_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
##################################################################################################
#################################################################################################
def lpg (vdda,buf,cmn):
	print "lpg function" 
	get_comp_numbers = []
	cm1c1 = 0;cm1c2 = 0;
	cm2c1 = 0;cm2c2 = 0;
	cm4c1 = 0;cm4c2 = 0;
	cm8c1 = 0;cm8c2 = 0;
	cm16c1 = 0;cm16c2 = 0;
	cm1n1 = "na";cm1n2 = "na";
	cm2n1 = "na";cm2n2 = "na";
	cm4n1 = "na";cm4n2 = "na";
	cm8n1 = "na";cm8n2 = "na";
	cm16n1 = "na";cm16n2 = "na";
#######################################################################################################################################################
#######################################################################################################################################################		
	cm1c10 = 0;cm1c20 = 0;
	cm2c10 = 0;cm2c20 = 0;
	cm4c10 = 0;cm4c20 = 0;
	cm8c10 = 0;cm8c20 = 0;
	cm16c10 = 0;cm16c20 = 0;
	cm1n10 = "na";cm1n20 = "na";
	cm2n10 = "na";cm2n20 = "na";
	cm4n10 = "na";cm4n20 = "na";
	cm8n10 = "na";cm8n20 = "na";
	cm16n10 = "na";cm16n20 = "na";
	for i1 in range(len(all_p[bk_n])):
		bank = all_p[bk_n][i1]
		shift = all_p[vdda_n][i1]
		redx = all_p[red_n][i1]
		cm =  all_p[cm_n][i1]
		cd = all_p[cd_n][i1]
		pg = all_p[pg_n][i1]
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '1' and pg == '1':  cm1n1 = i1;cm1c1 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '1' and pg == '1':  cm1n2 = i1;cm1c2 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm2c1 == 0 and cm == "2" and cd == '1' and pg == '1':  cm2n1 = i1;cm2c1 = 1
		elif bank == '1' and shift == '1'  and cm2c2 == 0 and cm == "2" and cd == '1' and pg == '1':  cm2n2 = i1;cm2c2 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm4c1 == 0 and cm == "4" and cd == '1' and pg == '1':  cm4n1 = i1;cm4c1 = 1
		elif bank == '1' and shift == '1'  and cm4c2 == 0 and cm == "4" and cd == '1' and pg == '1':  cm4n2 = i1;cm4c2 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm8c1 == 0 and cm == "8" and cd == '1' and pg == '1':  cm8n1 = i1;cm8c1 = 1
		elif bank == '1' and shift == '1'  and cm8c2 == 0 and cm == "8" and cd == '1' and pg == '1':  cm8n2 = i1;cm8c2 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm16c1 == 0 and cm == "16" and cd == '1' and pg == '1':  cm16n1 = i1;cm16c1 = 1
		elif bank == '1' and shift == '1'  and cm16c2 == 0 and cm == "16" and cd == '1' and pg == '1':  cm16n2 = i1;cm16c2 = 1
######################################################################################################################################################
		######################################################################################################################################
######################################################################################################################################################
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm1c1 == 0 and cm == "1" and cd == '0' and pg == '1':  cm1n10 = i1;cm1c10 = 1
		elif bank == '1' and shift == '1'  and cm1c2 == 0 and cm == "1" and cd == '0' and pg == '1':  cm1n20 = i1;cm1c20 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm2c1 == 0 and cm == "2" and cd == '0' and pg == '1':  cm2n10 = i1;cm2c10 = 1
		elif bank == '1' and shift == '1'  and cm2c2 == 0 and cm == "2" and cd == '0' and pg == '1':  cm2n20 = i1;cm2c20 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm4c1 == 0 and cm == "4" and cd == '0' and pg == '1':  cm4n10 = i1;cm4c10 = 1
		elif bank == '1' and shift == '1'  and cm4c2 == 0 and cm == "4" and cd == '0' and pg == '1':  cm4n20 = i1;cm4c20 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm8c1 == 0 and cm == "8" and cd == '0' and pg == '1':  cm8n10 = i1;cm8c10 = 1
		elif bank == '1' and shift == '1'  and cm8c2 == 0 and cm == "8" and cd == '0' and pg == '1':  cm8n20 = i1;cm8c20 = 1
		#################################################################################################
		if   bank == '1' and shift == '0'  and cm16c1 == 0 and cm == "16" and cd == '0' and pg == '1':  cm16n10 = i1;cm16c10 = 1
		elif bank == '1' and shift == '1'  and cm16c2 == 0 and cm == "16" and cd == '0' and pg == '1':  cm16n20 = i1;cm16c20 = 1
		#################################################################################################
	if buf == '1':
		if vdda != '1':
			get_comp_numbers = [cm1n1,cm2n1,cm4n1,cm8n1,cm16n1,cm1n10,cm2n10,cm4n10,cm8n10,cm16n10,]
		if cm1n2 != "na":   get_comp_numbers.append(cm1n2)
		elif cm2n2 != "na": get_comp_numbers.append(cm2n4)
		elif cm4n2 != "na": get_comp_numbers.append(cm4n2)
		elif cm8n2 != "na": get_comp_numbers.append(cm8n2)
		elif cm16n2 != "na":get_comp_numbers.append(cm16n2)
		if cm1n20 != "na":   get_comp_numbers.append(cm1n20)
		elif cm2n20 != "na": get_comp_numbers.append(cm2n20)
		elif cm4n20 != "na": get_comp_numbers.append(cm4n20)
		elif cm8n20 != "na": get_comp_numbers.append(cm8n20)
		elif cm16n20 != "na":get_comp_numbers.append(cm16n20)
	else:
		if vdda == '1':
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n10]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n10]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n10]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n10]
			if cmn == '16':get_comp_numbers = [cm16n1,cm16n10]
		else:	
			if cmn == '1':get_comp_numbers = [cm1n1,cm1n2,cm1n10,cm1n20]
			if cmn == '2':get_comp_numbers = [cm2n1,cm2n2,cm2n10,cm2n20]
			if cmn == '4':get_comp_numbers = [cm4n1,cm4n2,cm4n10,cm4n20]
			if cmn == '8':get_comp_numbers = [cm8n1,cm8n2,cm8n10,cm8n20]
			if cmn == '16':get_comp_numbers =[cm16n1,cm16n2,cm16n10,cm16n20]	
	get_comp = []
	print "get_comp_numbers = ",get_comp_numbers
	for i in get_comp_numbers:
		if i != "na":
			tm = getcomp_withn(i,all_p)
			get_comp.append(tm) 
	print "***********************************************************************************************************"	
	for i in get_comp:
		print i	 
	print "***********************************************************************************************************"
	return get_comp;
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################		
#######################################################################################################################################################
#######################################################################################################################################################	
#################################################################################################
#################################################################################################
def sac (vdda,buf,cmn):
	print "sac function" 
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
def sac_wa (vdda,buf,cmn):
	print "sac_wa function" 
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
	print "red function"
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
def gcen (vdda,buf,cmn):
	print "gcen function" 
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
def gpg (vdda,buf,cmn):
	print "gpg function" 
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
		tname = "/vdda_"+str(shift)+"/cm_"+str(cm)+"/cd_"+str(cd)+"/bk_"+str(bank)
		for tbk in [1]:
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
def bcen (vdda,buf,cmn):
	print "bcen function" 
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
def pin (vdda,buf,cmn):
	print "pin function" 
	return;
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

if row == "wk_bk2":
	print "wk_bk2"
	wk_bk2 (lsh,buf,cm);
elif row == "rw":
	print "rw"
	rw (lsh,buf,cm);
elif row == "xdec":
	print "xdec"
	xdec (lsh,buf,cm);
elif row == "lcen":
	print "lcen"
	lcen (lsh,buf,cm);
elif row == "lpg":
	print "lpg"
	lpg (lsh,buf,cm);
elif row == "sac":
	print "sac"
	sac (lsh,buf,cm);
elif row == "sac_wa":
	print "sac_wa"
	sac_wa (lsh,buf,cm);
elif row == "red":
	print "red"
	red (lsh,buf,cm);
elif row == "gcen":
	print "gcen"
	gcen (lsh,buf,cm);
elif row == "gpg":
	print "gpg"
	gpg (lsh,buf,cm);
elif row == "bcen":
	print "bcen"
	bcen (lsh,buf,cm);
elif row == "bcen_mux":
	print "bcen_mux"
	bcen (lsh,buf,cm);
elif row == "pin":
	print "pin"
	pin (lsh,buf,cm);
else:
	print "Give me please row name from this range 'wk_bk2 rw xdec lcen lpg sac sac_wa red gcen gpg bcen bcen_mux pin'"
	sys.exit(0)

