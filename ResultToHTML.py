import os
def get2row(s,var):
    return "\n\t<tr>\n\t\t<td>" + "<font color='black' size = '5'>" + var[0] + "</font>" + "</td>" + "\n\t\t<td>" + "<font color='black' size = '5'>" + var[1] + "</font>" + "</td>" + "\n\t</tr>"
def getrow(s,var):
    return "\n\t<tr>\n\t\t<td bgcolor = 'BurlyWood '>"  + "<font color='black' size = '5'>" + s + "</font>" +  "</td>" + "\n\t\t<td bgcolor = 'BurlyWood '>" + "<font color='black' size = '5'>" + var[0] + "</font>" + "</td>" + "\n\t\t<td bgcolor = 'BurlyWood '>" + "<font color='black' size = '5'>" + var[1] + "</font>" + "</td>" + "\n\t</tr>"
def getrowlef(s,var):
    return "\n\t<tr>\n\t\t<td bgcolor='brown'>"  + "<font color='black' size = '5'>" + s + "</font>" +  "</td>" + "\n\t\t<td bgcolor='brown'>" + "<font color='black' size = '5'>" + var[0] + "</font>" + "</td>" + "\n\t\t<td bgcolor='brown'>" + "<font color='black' size = '5'>" + var[1] + "</font>" + "</td>" + "\n\t</tr>"
def diffToHtml(diff,f,netlistFile1,netlistFile2,netlsitSubckt1,netlsitSubckt2):
    #f.write(htmltext)
    for name in diff:
        portlist = diff[name][0]
        paramlist = diff[name][1]
        tranzList = diff[name][2]
        instList = diff[name][3]
        htmltext =  "\t<tr>\n\t\t<td bgcolor='OliveDrab ' style = 'width:20%'>" + "<font color='black' size = '5' face='verdana'><b>" + "Subckt: " + name + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='OliveDrab ' style = 'width:20%'>" + "<font color='black' size = '5' face='verdana'><b>" + ' '.join(netlsitSubckt1.getCellHier(name))  + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='OliveDrab ' style = 'width:20%'>" + "<font color='black' size = '5' face='verdana'><b>" + ' '.join(netlsitSubckt2.getCellHier(name))  + "</b></font>" + "</td>" + "\n\t</tr>"
        if portlist is not None:
                        diffports = portlist[0]["diff"]
                        diffp1 = ""
                        diffp2 = ""
                        if diffports is not None:
                            for p in diffports:
                                diffp1 = diffp1 + p[0] + ";    "
                                diffp2 = diffp2 + p[1] + ";    "
                            htmltext = htmltext + getrowlef("Different Lefcell Ports",[diffp1,diffp2])
                        extra1ports = portlist[1]["extra1"]
                        extra2ports = portlist[2]["extra2"]
                        diffp1 = ""
                        diffp2 = ""
                        if extra1ports is not None:
                             diffp1 = ', '.join(extra1ports)
                        if extra2ports is not None:
                             diffp2 = ', '.join(extra2ports)
                        if [diffp1,diffp2] != ["",""]:
                            htmltext = htmltext + getrowlef("Extra Lefcell Ports",[diffp1,diffp2])
        if paramlist is not None:
                        diffports = paramlist[0]["diff"]
                        diffp1 = ""
                        diffp2 = ""
                        if diffports is not None:
                            for p in diffports:
                                diffp1 = diffp1 + p[0] + ";    "
                                diffp2 = diffp2 + p[1] + ";    "
                            htmltext = htmltext + getrow("Different Lefcell Parameters",[diffp1,diffp2])
                        extra1ports = paramlist[1]["extra1"]
                        extra2ports = paramlist[2]["extra2"]
                        diffp1 = ""
                        diffp2 = ""
                        if extra1ports is not None:
                             diffp1 = ', '.join(extra1ports)
                        if extra2ports is not None:
                             diffp2 = ', '.join(extra2ports)
                        if [diffp1,diffp2] != ["",""]:
                            htmltext = htmltext + getrow("Extra Lefcell Parameters",[diffp1,diffp2])
        if tranzList is not None:
            diffTranz = tranzList[0]["TranzDiff"]
            extraT1 = tranzList[1]["Extra1"]
            extraT2 = tranzList[2]["Extra2"]
            if diffTranz is not None:
                for difft_i in diffTranz:
                    tname = difft_i[0]
                    td = difft_i[1]
                    ts = difft_i[2]
                    tg = difft_i[3]
                    tb = difft_i[4]
                    ttype = difft_i[5]
                    tfin = difft_i[6]
                    tl = difft_i[7]
                    tm = difft_i[8]
                    if type(tname) == str:
                        htmltext = htmltext + "\n\t<tr>\n\t\t<td bgcolor='LightGrey'>"  + "<font color='black' size = '6'><b>" + tname + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t</tr>"
                    else:
                        htmltext = htmltext + "\n\t<tr>\n\t\t<td bgcolor='LightGrey'>"  + "<font color='black' size = '6'><b>" + tname[0] + " : " + tname[1] + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t</tr>"
                    if ts is not None:
                        htmltext = htmltext + getrow("source",ts)
                    if td is not None:
                        htmltext = htmltext + getrow("drain",td)
                    if tg is not None:
                        htmltext = htmltext + getrow("gate",tg)
                    if tb is not None:
                        htmltext = htmltext + getrow("bulk",tb)
                    if ttype is not None:
                        htmltext = htmltext + getrow("type",ttype)
                    if tfin is not None:
                        htmltext = htmltext + getrow("nfin",tfin)
                    if tl is not None:
                        htmltext = htmltext + getrow("length",tl)
                    if tm is not None:
                        htmltext = htmltext + getrow("multiple",tm)
            text1 = ""
            text2 = ""
            if extraT1 is not None:
                for t in extraT1:
                    text1 = text1 + t.getTName() + ";    "
            if extraT2 is not None:
                for t in extraT2:
                    text2 = text2 + t.getTName() + ";    "
            if text1 != "" or text2 != "":
                htmltext = htmltext + "\n\t<tr>\n\t\t<td bgcolor='blue'>"  + "<font color='red' size = '5'>" + "Extra Tranzistors" + "</font>" +  "</td>" + "\n\t\t<td bgcolor='blue'>" + "<font color='red' size = '5'>" + text1 + "</font>" + "</td>" + "\n\t\t<td bgcolor='blue'>" + "<font color='red' size = '5'>" + text2 + "</font>" + "</td>" + "\n\t</tr>"
        if instList is not None:
            diffInst = instList[0]["diffInstaces"]
            if diffInst is not None:
                for diffI in diffInst:
                    iname = diffI[0]
                    itype = diffI[1]
                    iports = diffI[2]
                    iparams = diffI[3]
                    htmltext = htmltext + "\n\t<tr>\n\t\t<td bgcolor='LightGrey'>"  + "<font color='black' size = '6'><b>" + iname + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t\t<td bgcolor='LightGrey'>" + "</td>" + "\n\t</tr>"
                    if itype is not None:
                        htmltext = htmltext + getrow("Instance Type",itype)
                    if iports is not None:
                        diffports = iports[0]["diff"]
                        diffp1 = ""
                        diffp2 = ""
                        if diffports is not None:
                            for p in diffports:
                                diffp1 = diffp1 + p[0] + ";    "
                                diffp2 = diffp2 + p[1] + ";    "
                            htmltext = htmltext + getrow("Different ports",[diffp1,diffp2])
                        extra1ports = iports[1]["extra1"]
                        extra2ports = iports[2]["extra2"]
                        x1 = ""
                        x2 = ""
                        if extra1ports is not None:
                            x1 = ', '.join(extra1ports)
                        if extra2ports is not None:
                            x2 = ', '.join(extra2ports)
                        if [x1,x2] != ["",""]:
                            htmltext = htmltext + getrow("Extra Ports",[x1,x2])
                    if iparams is not None:
                        diffports = iparams[0]["diff"]
                        diffp1 = ""
                        diffp2 = ""
                        if diffports is not None:
                            for p in diffports:
                                diffp1 = diffp1 + p[0] + ";    "
                                diffp2 = diffp2 + p[1] + ";    "
                            htmltext = htmltext + getrow("Different parameters",[diffp1,diffp2])
                        extra1ports = iparams[1]["extra1"]
                        extra2ports = iparams[2]["extra2"]
                        diffp1 = ""
                        diffp2 = ""
                        if extra1ports is not None:
                             diffp1 = ', '.join(extra1ports)
                        if extra2ports is not None:
                             diffp2 = ', '.join(extra2ports)
                        if [diffp1,diffp2] != ["",""]:
                            htmltext = htmltext + getrow("Extra Parameters",[diffp1,diffp2])
            extraInstNemes1 = ""
            extraInstNemes2 = ""
            extraInst1 = instList[1]["ExtraInstances1"]
            extraInst2 = instList[2]["ExtraInstances2"]
            if extraInst1 is not None:
                for e in extraInst1:
                    extraInstNemes1 = extraInstNemes1 + e.getName() + ";    "
            if extraInst2 is not None:
                for e in extraInst2:
                    extraInstNemes2 = extraInstNemes2 + e.getName() + ";    "
            if extraInstNemes1 != "" or extraInstNemes2 != "":
                htmltext = htmltext + getrowlef("Extra Instances",[extraInstNemes1,extraInstNemes2])
        #htmltext = htmltext + getrowlef("",["",""])
        f.write(htmltext)



def convertorHTML (result,netlistFile1,netlistFile2,netlsitSubckt1,netlsitSubckt2):
    diffs = result[0]
    extra1info = result[1]
    extra2info = result[2]
    if os.path.isfile("result_diff.html"):
        os.remove("result_diff.html")
    if os.path.isfile("result_extra.html"):
        os.remove("result_extra.html")
    if os.path.isfile("result.html"):
        os.remove("result.html")
    if diffs is None and extra1info is None and extra2info is None:
        with open("result.html","w") as f:
            htmltext = "<html>\n"
            htmltext = htmltext + "<head>\n<title>Extra Subckts</title>\n</head>\n"
            htmltext = htmltext + "<body bgcolor='LightGray'>\n"
            htmltext = htmltext + "<h1><center><font color='black' size = '5' face='verdana'><b>This File was auto generated by Netlist Comparation Tool</font></b></center></h1>\n"
            htmltext = htmltext + "<h1><center><font color='black' size = '3' face='verdana'><b>Comparing " + netlistFile1 + " VS " + netlistFile2 + " </font></b></center></h1>\n"
            htmltext = htmltext + "<p><center><font color='green' size = '8' face='verdana'><b>TWO NETLISTS ARE EQUAL</b></font></center></p>\n"
            f.write(htmltext)
            htmltext = "<div style='position: fixed; bottom: 0; width:100%; text-align: center'><h3><center><font color='MediumSlateBlue  ' size = '2' face='verdana'>Web page and NetlistVSNetlist Tool created by AM Memory Layout Team</font</center></h3></div>\n"
            htmltext = htmltext + "</body>\n"
            htmltext = htmltext + "</html>\n"
            f.write(htmltext)
            return


    with open("result_diff.html","w") as f:
        htmltext = "<html>\n"
        htmltext = htmltext + "<head>\n<title>Only Real Difference Page</title>\n</head>\n"
        htmltext = htmltext + "<body bgcolor='white'>\n"
        htmltext = htmltext + "<h1><center><font color='black' size = '5' face='verdana'><b>This File was auto generated by Netlist Comparation Tool</font></b></center></h1>\n"
        htmltext = htmltext + "<h1><center><font color='black' size = '3' face='verdana'><b>Comparing " + netlistFile1 + " VS " + netlistFile2 + " </font></b></center></h1>\n"
        head, netlistFile1 = os.path.split(netlistFile1)
        head, netlistFile2 = os.path.split(netlistFile2)
        htmltext = htmltext + """<table style="width:100%" border = 2px solid black;>\n"""
        htmltext = htmltext + "\t<tr>\n\t\t<td bgcolor='white ' style = 'width:20%'>" + "<font color='black' size = '6' face='verdana'><b>" + "Subckt: " + "Subckt Name" + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='white ' style = 'width:20%'>" + "<font color='black' size = '6' face='verdana'><b>" + netlistFile1  + "</b></font>" + "</td>" + "\n\t\t<td bgcolor='white ' style = 'width:20%'>" + "<font color='black' size = '6' face='verdana'><b>" + netlistFile2  + "</b></font>" + "</td>" + "\n\t</tr>"
        htmltext = htmltext + "\n<p>\n</p>\n"
        f.write(htmltext)
        if diffs is not None:
            for index,diff in enumerate(diffs):
                diffToHtml(diff,f,netlistFile1,netlistFile2,netlsitSubckt1,netlsitSubckt2)
        htmltext = htmltext + "</table>\n"
        htmltext = "<div style='position: fixed; bottom: 0; width:100%; text-align: center'><h3><center><font color='MediumSlateBlue  ' size = '2' face='verdana'>Web page and NetlistVSNetlist Tool created by AM Memory Layout Team</font</center></h3></div>\n"
        htmltext = htmltext + "</body>\n"
        f.write(htmltext)
        f.close()
    with open("result_extra.html","w") as f:
        htmltext = "<html>\n"
        htmltext = htmltext + "<head>\n<title>Extra Subckts</title>\n</head>\n"
        htmltext = htmltext + "<body bgcolor='LightGray '>\n"
        htmltext = htmltext + "<h1><center><font color='white' size = '5' face='verdana'><b>This File was auto generated by Netlist Comparation Tool</font></b></center></h1>\n"
        htmltext = htmltext + "<h1><center><font color='white' size = '3' face='verdana'><b>Comparing " + netlistFile1 + " VS " + netlistFile2 + " </font></b></center></h1>\n"
        htmltext = htmltext + """<table style="width:100%" border = 1px solid white;>\n"""
        f.write(htmltext)
        htmltext = get2row("",[netlistFile1,netlistFile2])
        htmltext = "\n\t<tr>\n\t\t<td>" + "<font color='black' size = '6'><b>" + netlistFile1 + "</b></font>" + "</td>" + "\n\t\t<td>" + "<font color='black' size = '6'><b>" + netlistFile2 + "</b></font>" + "</td>" + "\n\t</tr>"
        if extra1info is not None and extra2info is not None:
            if len(extra1info)>len(extra2info):
                min = len(extra2info)
            else:
                min = len(extra1info)
            for i in range(0,min):
                htmltext = htmltext + get2row("",[str(i+1) + ". " + extra1info[i].getName(),str(i+1) + ". " + extra2info[i].getName()])
            if len(extra1info)>len(extra2info):
                for i in range(min,len(extra1info)):
                    htmltext = htmltext + get2row("",[str(i+1) + ". " + extra1info[i].getName(),""])
            else:
                for i in range(min,len(extra2info)):
                    htmltext = htmltext + get2row("",["",str(i+1) + ". " + extra2info[i].getName()])
        elif extra1info is not None:
            for i in range(0,len(extra1info)):
                htmltext = htmltext + get2row("",[str(i+1) + ". " + extra1info[i].getName(),""])
        elif extra2info is not None:
            for i in range(0,len(extra2info)):
                htmltext = htmltext + get2row("",["",str(i+1) + ". " + extra2info[i].getName()])
        htmltext = htmltext + "</table>\n"
        f.write(htmltext)
        htmltext = "<div style='position: fixed; bottom: 0; width:100%; text-align: center'><h3><center><font color='MediumSlateBlue  ' size = '2' face='verdana'>Web page and NetlistVSNetlist Tool created by AM Memory Layout Team</font</center></h3></div>\n"
        htmltext = htmltext + "</body>\n"
        f.write(htmltext)
        f.close()
    with open("result.html","w") as f:
        htmltext = "<html>\n"
        htmltext = htmltext + "<head>\n<title>Extra Subckts</title>\n</head>\n"
        htmltext = htmltext + "<body bgcolor='LightGray'>\n"
        htmltext = htmltext + "<h1><center><font color='white' size = '5' face='verdana'><b>This File was auto generated by Netlist Comparation Tool</font></b></center></h1>\n"
        htmltext = htmltext + "<h1><center><font color='white' size = '3' face='verdana'><b>Comparing " + netlistFile1 + " VS " + netlistFile2 + " </font></b></center></h1>\n"
        htmltext = htmltext + """<table style="width:100%" border = 1px solid white;>\n"""
        f.write(htmltext)
        a1 = "<a href='result_diff.html'><center>Only Netlist Difference</center></a>"
        a2 = "<a href='result_extra.html'><center>Extra Subckts in Netlists</center></a>"
        f.write("""<table style="width:100%" border = 1px solid blue;>\n""")
        f.write(get2row("",[a1,a2]))
        f.write("</table>\n")
        htmltext = "<div style='position: fixed; bottom: 0; width:100%; text-align: center'><h3><center><font color='MediumSlateBlue  ' size = '2' face='verdana'>Web page and NetlistVSNetlist Tool created by AM Memory Layout Team</font</center></h3></div>\n"
        htmltext = htmltext + "</body>\n"
        htmltext = htmltext + "</html>\n"
        f.write(htmltext)
    print "FINSISH"
