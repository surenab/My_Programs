from Classes import *
from ResultToCSV import *
from ResultToHTML import *
import webbrowser
import sys
list = None
if len(sys.argv)<2:
    print "Command is Inccorect"
    exit()
if len(sys.argv)>=4:
    if sys.argv[3] == "-file":
        fileName = sys.argv[4]
        f = open(fileName,'r')
        for line in f.readlines():
            if list is None:
                list = [[line.split()[0],line.split()[1]]]
            else:
                list.append([line.split()[0],line.split()[1]])
        if len(list) == 0:
            list = None
    elif sys.argv[3] == "-cellList":
        for i in range(4,len(sys.argv)):
            if list is None:
	        list = [[sys.argv[i],sys.argv[i]]]
	    else:
	        list.append([sys.argv[i],sys.argv[i]])
        if len(list) == 0:
            list = None
    elif sys.argv[3] == "-cell":
        if list is None:
	    list = [[sys.argv[4],sys.argv[4]]]
        else:
	    list.append([sys.argv[4],sys.argv[4]])
        if len(list) == 0:
            list = None
    
#############################################################################################################################
netlistFile1 = "1.cir"
netlistFile2 = "2.cir"
netlistFile1 = "/slowfs/am04dwt2p013/projects/layout/ts16/hs1p_ffc/netlist/hs1p_chcells.cir.nodummy_lvt/hs1p_chcells.cir.nodummy_lvt"
netlistFile2 = "/slowfs/am04dwt2p050/scratch/lilitara/netlist/chcells_lvt.cir"
netlistFile1 = sys.argv[1]
netlistFile2 = sys.argv[2]

with open(netlistFile1,"r") as f1:
    data1 = f1.readlines()
f1.close()
with open(netlistFile2,"r") as f2:
    data2 = f2.readlines()
f2.close()
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
########################################################## My Functions ####################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
###############     Geting all Subckt Names     ################################
def getAllSubcktNames(data):
    allSubcktNames = None
    allSubcktListLines = None
    for index,line in enumerate(data):
        if ".subckt" in line:
            endindex = len(data)
            for i in range(index,len(data)):
                if ".end" in data[i]:
                    endindex = i
                    break
            if allSubcktNames is None:
                allSubcktNames = [line.split()[1]]
                allSubcktListLines = [data[index:endindex]]
            else:
                allSubcktNames.append(line.split()[1])
                allSubcktListLines.append(data[index:endindex])
    return allSubcktNames,allSubcktListLines
###################################################################################
############        Get rid all * and \n lines     ################################
def getRidOfAperLines(data):
    newData = None
    for line in data:
        if "*" not in line and line != "\n":
            if newData is None:
                newData = [line]
            else:
                newData.append(line)
    return newData
###################################################################################
############        Get rid all  +  lines     ################################
def getRidOfPlusLines(data):
    newData = None
    tempLine = ""
    for line in data:
        if line.startswith("+"):
            tempLine = tempLine[:-1] + line[1:]
        else:
            if newData is not None:
                newData.append(tempLine)
            else:
                newData = [tempLine]
            tempLine = line
    return newData
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
data1 = getRidOfAperLines(data1)
data2 = getRidOfAperLines(data2)
data1 = getRidOfPlusLines(data1)
data2 = getRidOfPlusLines(data2)
################################################################################################################################
netlistInfo1 = getAllSubcktNames(data1)
netlistInfo2 = getAllSubcktNames(data2)
data1 = None
data2 = None
################################################################################################################################
################################################################################################################################
################################################################################################################################
netlsitSubckt1 = Netlsit()
netlsitSubckt2 = Netlsit()
for intemp in netlistInfo1[1]:
    netlsitSubckt1.addSubckt(Subckt(intemp))
for intemp in netlistInfo2[1]:
    netlsitSubckt2.addSubckt(Subckt(intemp))
#list = [["hs1p_chgpgctrl","hs1p_chgpgctrl"],["hs1p_chgcen_clps","hs1p_chgcen_clps"]]
#list = None
if list is None:
    netlistInfo1 = None
    netlistInfo2 = None
    allResult = netlsitSubckt1.compare(netlsitSubckt2)
    convertorHTML(allResult,netlistFile1,netlistFile2,netlsitSubckt1,netlsitSubckt2)
    webbrowser.open("result.html")
else:
    cellList = None
    for l in list:
            if cellList is None:
                cellList = netlsitSubckt1.getCellSubCells(l[0])
            else:
                cellList = cellList + netlsitSubckt1.getCellSubCells(l[0]) 
    for l in list:
        cellList = cellList + l
    ListOfCells = []
    for i in cellList:
        if i not in ListOfCells:
            ListOfCells.append(i)
    netlsitSubckt1 = Netlsit()
    netlsitSubckt2 = Netlsit()
    for intemp in netlistInfo1[1]:
        if intemp[0].split(" ")[1] in ListOfCells:
            netlsitSubckt1.addSubckt(Subckt(intemp))
    for intemp in netlistInfo2[1]:
        if intemp[0].split(" ")[1] in ListOfCells:
            netlsitSubckt2.addSubckt(Subckt(intemp))
    if netlsitSubckt1.getSubcktCount()>0 or netlsitSubckt2.getSubcktCount()>0:
        allResult = netlsitSubckt1.compare(netlsitSubckt2)
        convertorHTML(allResult,netlistFile1,netlistFile2,netlsitSubckt1,netlsitSubckt2)
        webbrowser.open("result.html")
    else:
        print "Can't find cell in the netlist"
