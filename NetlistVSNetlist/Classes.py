import copy
################################################################################################################################
################################################################################################################################
def portDiff(p1,p2):
    diffports = None
    portnotinp1 = None
    portnotinp2 = None
    if p1 is None or p2 is None:
        if [diffports,p1,p2] == [None,None,None]:
            return None
        return [{"diff":diffports},{"extra1":p1},{"extra2":p2}]
    if len(p1)>len(p2):
        while(len(p2)>0):
            if p1[0] != p2[0]:
                if diffports is None:
                    diffports = [p1[0],p2[0]]
                else:
                    diffports.append([p1[0],p2[0]])
            del p1[0]
            del p2[0]
    else:
        while(len(p1)>0):
            if p1[0] != p2[0]:
                if diffports is None:
                    diffports = [[p1[0],p2[0]]]
                else:
                    diffports.append([p1[0],p2[0]])
            del p1[0]
            del p2[0]
    if len(p1) != 0:
        portnotinp1 = p1
    if len(p2) != 0:
        portnotinp2 = p2
    if [diffports,portnotinp1,portnotinp2] == [None,None,None]:
        return None
    return [{"diff":diffports},{"extra1":portnotinp1},{"extra2":portnotinp2}]
def getTranzistorbyName(t,name):
    for i in t:
        if name == i.getTName():
            return i
    return None
def getApproxSameTranz(ts,t):
    for index,i in enumerate(ts):
        if t.compareOnly(i):
            return i,index
    return None
def TDiff(t1,t2):
    diffTs = None
    if t1 is None or t2 is None:
        if [diffTs,t1,t2] == [None,None,None]:
            return None
        return [{"TranzDiff":diffTs},{"Extra1":t1},{"Extra2":t2}]
    if len(t1)>len(t2):
        while(len(t2)>0):
            tempT2 = t2[0]
            del t2[0]
            tempT2Name = tempT2.getTName()
            tempT1 = getTranzistorbyName(t1,tempT2Name)
            if tempT1 is None:
                tInfo =  getApproxSameTranz(t1,tempT2)
                if tInfo is not None:
                    tempT1 = tInfo[0]
                    index = tInfo[1]
                    del t1[index]
                else:
                    continue
            else:
                del t1[t1.index(tempT1)]
            tempDiffTs = tempT1.compare(tempT2)
            if tempDiffTs is not None:
                if diffTs is None:
                    diffTs = [tempDiffTs]
                else:
                    diffTs.append(tempDiffTs)
    else:
        while(len(t1)>0):
            tempT1 = t1[0]
            del t1[0]
            tempT1Name = tempT1.getTName()
            tempT2 = getTranzistorbyName(t2,tempT1Name)
            if tempT2 is None:
                tInfo =  getApproxSameTranz(t2,tempT1)
                if tInfo is not None:
                    tempT2 = tInfo[0]
                    index = tInfo[1]
                    del t2[index]
                else:
                    continue
            else:
                del t2[t2.index(tempT2)]
            tempDiffTs = tempT1.compare(tempT2)
            if tempDiffTs is not None:
                if diffTs is None:
                    diffTs = [tempDiffTs]
                else:
                    diffTs.append(tempDiffTs)


    if len(t1) == 0:
        t1 = None
    if len(t2) == 0:
        t2 = None
    if [diffTs,t1,t2] == [None,None,None]:
        return None
    return [{"TranzDiff":diffTs},{"Extra1":t1},{"Extra2":t2}]
def getInstanceByName(iss,name):
    for i in iss:
        if name == i.getName():
            return i
    return None
def getInstanceByParams(iss,i2):
    for index,i1 in enumerate(iss):
        if i2.compareOnly(i1):
            return i1,index
    return None
def IDiff(i1,i2):
    diffInst = None
    insNoInList1 = None
    insNoInList2 = None
    if i1 is None or i2 is None:
        if [diffInst,i1,i2] == [None,None,None]:
            return None
        return [{"diffInstaces":diffInst},{"ExtraInstances1":i1},{"ExtraInstances2":i2}]
    if len(i1)<=len(i2):
        while(len(i1)>0):
            it1 = i1[0]
            del i1[0]
            iname = it1.getName()
            it2 = getInstanceByName(i2,iname)
            if it2 is None:
                it2temp = getInstanceByParams(i2,it1)
                if it2temp is not None:
                    it2 = it2temp[0]
                    index = it2temp[1]
                    del i2[index]
                else:
                    continue
            else:
                del i2[i2.index(it2)]
            tempDiffIns = it1.compare(it2)
            if tempDiffIns is not None:
                if diffInst is None:
                    diffInst = [tempDiffIns]
                else:
                    diffInst.append(tempDiffIns)
    else:
        while(len(i2)>0):
            it2 = i2[0]
            del i2[0]
            iname = it2.getName()
            it1 = getInstanceByName(i1,iname)
            if it1 is None:
                it1temp = getInstanceByParams(i1,it2)
                if it1temp is not None:
                    it1 = it1temp[0]
                    index = it1temp[1]
                    del i1[index]
                else:
                    continue
            else:
                del i1[i1.index(it1)]
            tempDiffIns = it1.compare(it2)
            if tempDiffIns is not None:
                if diffInst is None:
                    diffInst = [tempDiffIns]
                else:
                    diffInst.append(tempDiffIns)
    if len(i1) == 0:
        i1 = None
    if len(i2) == 0:
        i2 = None
    if [diffInst,i1,i2] == [None,None,None]:
        return None
    return [{"diffInstaces":diffInst},{"ExtraInstances1":i1},{"ExtraInstances2":i2}]
###################################### Tranzistor Class ############################################################################
class Tranzistor:
    def __init__(self,line = None,tName = None,drain = None,gate = None,source = None,bulk = None,type = None,nfin = None,l = None,m = None):
        if line is not None:
            self.__line = line
            self.__tName,self.__drain,self.__gate,self.__source,self.__bulk,self.__type,self.__nfin,self.__l,self.__m = self.getTranzData()
        else:
            self.__line = None
            self.__tName = tName
            self.__drain = drain
            self.__gate = gate
            self.__source = source
            self.__bulk = bulk
            self.__type = type
            self.__nfin = nfin
            self.__l = l
            self.__m = m
    def getTranzData(self):
        data = self.__line.split()
        if len(data) < 9:
            data.append("m=1")
        return data
    def getTName(self):
        return self.__tName
    def getDrain(self):
        return self.__drain
    def getGate(self):
        return self.__gate
    def getSource(self):
        return self.__source
    def getBulk(self):
        return self.__bulk
    def getType(self):
        return self.__type
    def getNfin(self):
        return self.__nfin
    def getL(self):
        return self.__l
    def getM(self):
        return self.__m
    def compare(self,t2):
        if (self.__drain == t2.getDrain() or self.__drain == t2.getSource()):
            sd = None
        else:
            sd = [self.__drain,t2.getDrain()]
        if (self.__source == t2.getDrain() or self.__source == self.__source):
            ss = None
        else:
            ss = [self.__source,self.__source]
        if self.__gate == t2.getGate():
            sg = None
        else:
            sg = [self.__gate,t2.getGate()]
        if self.__bulk == t2.getBulk():
            sb = None
        else:
            sb = [self.__bulk,t2.getBulk()]
        if self.__type == t2.getType():
            st = None
        else:
            st = [self.__type,t2.getType()]
        if self.__nfin == t2.getNfin():
            sn = None
        else:
            sn = [self.__nfin,t2.getNfin()]
        if self.__l == t2.getL():
            sl = None
        else:
            sl = [self.__l,t2.getL()]
        if self.__m == t2.getM():
            sm = None
        else:
            sm = [self.__m,t2.getM()]
        if self.__tName == t2.getTName():
            sname = self.__tName
        else:
            sname = [self.__tName,t2.getTName()]
        if [sd,sg,ss,sb,st,sn,sl,sm] == [None, None, None, None, None, None, None, None] and type(sname) == str:
            return None
        return [sname,sd,sg,ss,sb,st,sn,sl,sm]
    def compareOnly(self,t):
        if self.__drain == t.getDrain() and self.__source == t.getSource() and self.__gate == t.getGate() and self.__bulk == t.getBulk() and self.__type == t.getType() and self.__nfin == t.getNfin() and self.__l == t.getL() and self.__m == t.getM():
            return True
        return False
    def printTarnzistorInfo(self):
        print "\tname = ",self.__tName,"\t\tdrain = ",self.__drain,"\t\tsource = ",self.__source,"\t\tgate = ",self.__gate,"\t\tbulk = ",self.__bulk,"\t\ttype = ",self.__type,"\t\tnfin = ",self.__nfin,"\t\tl = ",self.__l,"\t\tm = ",self.__m
################################################################################################################################
################################################################################################################################
class Instance:
    def __init__(self,line = None,name = None,portList = None,type = None,params = None):
        if line is not None:
            self.__line = line
            self.__params = None
            self.__portList = None
            self.getInstanceInfoFromLine()
        else:
            self.__line = None
            self.__name = name
            self.__portList = portList
            self.__type = type
            self.__params = params
    def getName(self):
        return self.__name
    def getPortList(self):
        return self.__portList
    def getType(self):
        return self.__type
    def getParams(self):
        return self.__params
    def compare(self,ins):
        portList = ins.getPortList()
        portListDiff = portDiff(self.__portList,portList)
        params = ins.getParams()
        paramsDiff = portDiff(self.__params,params)
        typeDiff = None
        nameDiff = self.__name
        if ins.getType() != self.__type:
            typeDiff = [self.__type,ins.getType()]
        if ins.getName() != self.__name:
            nameDiff = [self.__name,ins.getName()]
        if type(nameDiff) == str and [typeDiff,portListDiff,paramsDiff] == [None,None,None]:
            return None
        return [nameDiff,typeDiff,portListDiff,paramsDiff]
    def compareOnly(self,i):
        return self.__params == i.getParams() and self.__type == i.getType() and self.__portList == i.getPortList()
    def getInstanceInfoFromLine(self):
        tempLine = self.__line.split()
        self.__name = tempLine[0]
        typeIndex = -1
        for index,item in enumerate(tempLine):
            if "=" in item:
                typeIndex = index - 1
                break
        if typeIndex == -1:
            typeIndex = len(tempLine)-1
        self.__type = tempLine[typeIndex]
        for i in range(1,typeIndex):
            if self.__portList is None:
                self.__portList = [tempLine[i]]
            else:
                self.__portList.append(tempLine[i])
        if typeIndex<len(tempLine):
            for i in range(typeIndex+1,len(tempLine)):
                 if self.__params is None:
                    self.__params = [tempLine[i]]
                 else:
                    self.__params.append(tempLine[i])
    def printInstanceInfo(self):
        print "\tname = ",self.__name,"\t\tportList = ",self.__portList,"\t\ttype = ",self.__type,"\t\tparamList = ",self.__params
################################################################################################################################
################################################################################################################################
class Subckt:
    def __init__(self,listOfLines = None,portList = None,params = None,name = None,allTranzistors = None,allInstances = None):
        if listOfLines is not None:
            self.__listOflines = listOfLines
            self.__portList = portList
            self.__params = params
            self.__name = name
            self.__allTranzistors = allTranzistors
            self.__allInstances = allInstances
            self.parseAllLines()
        else:
            self.__listOflines = None
            self.__portList = portList
            self.__params = params
            self.__name = name
            self.__allTranzistors = allTranzistors
            self.__allInstances = allInstances
    def getParams(self):
        return self.__params
    def getPortList(self):
        return self.__portList
    def getName(self):
        return self.__name
    def getAllTranzistors(self):
        return self.__allTranzistors
    def getAllInstances(self):
        return self.__allInstances
    def compare(self,sub):
        difference = None
        #print "Comparing subckts "
        #portList = sub.getPortList()
        portListDiff = portDiff(self.__portList,sub.getPortList())
        #print "portListDiff =", portListDiff
        #params = sub.getParams()
        paramListDiff = portDiff(self.__params,sub.getParams())
        #print "paramListDiff = ",paramListDiff
        #allTranzistors = sub.getAllTranzistors()
        tranzistorsDiff = TDiff(self.__allTranzistors,sub.getAllTranzistors())
        #print "tranzDiff = ",tranzistorsDiff
        #allInstances = sub.getAllInstances()
        instancesDiff = IDiff(self.__allInstances,sub.getAllInstances())
        #print "insDiff = ",instancesDiff
        if [portListDiff,paramListDiff,tranzistorsDiff] == [None,None,None] and instancesDiff == [{'diffInstaces': None}, {'ExtraInstances1': []}, {'ExtraInstances2': []}]:
            return None
        return [portListDiff,paramListDiff,tranzistorsDiff,instancesDiff]
    def parseAllLines(self):
        startParams = 0
        for index,i in enumerate(self.__listOflines):
            temp = i
            startParams = 0
            if index == 0:
                temp = temp.split()
                self.__name = temp[1]
                for j in range(2,len(temp)):
                    if startParams == 0:
                        if "=" not in temp[j]:
                            if self.__portList is None:
                                self.__portList = [temp[j]]
                            else:
                                self.__portList.append(temp[j])
                        else:
                            self.__params = [temp[j]]
                            startParams = 1
                    else:
                        if self.__params is None:
                            self.__params = [temp[j]]
                        else:
                            self.__params.append(temp[j])
            else:
                if temp.startswith("m"):
                    tempTranzistor = Tranzistor(temp)
                    if self.__allTranzistors is None:
                        self.__allTranzistors = [tempTranzistor]
                    else:
                        self.__allTranzistors.append(tempTranzistor)
                    #tempTranzistor.printTarnzistorInfo()
                elif temp.startswith("x"):
                    tempInstance = Instance(temp)
                    if self.__allInstances is None:
                        self.__allInstances = [tempInstance]
                    else:
                        self.__allInstances.append(tempInstance)
                    #tempInstance.printInstanceInfo()
################################################################################################################################
################################################################################################################################
class Netlsit:
    def __init__(self,sub = None):
        self.__subckt = sub
    def addSubckt(self,subckt):
        if self.__subckt == None:
            self.__subckt = [subckt]
        else:
            self.__subckt.append(subckt)
    def getSubckts(self):
        return self.__subckt
    def getSubcktByName(self,name = None):
        for i in self.__subckt:
            #print "name = ",name,"    name2 = ",i.getName()
            if i.getName() == name:
                return i
        else:
            return None
    def getSubcktCount(self):
        if self.__subckt is None:
            return 0
        return len(self.__subckt)
    def removeSubcktByName(self,name):
        for index,i in enumerate(self.__subckt):
            if i.getName() == name:
                del self.__subckt[index]
                return 0
        else:
            return -1
    def empatySubckts(self):
        self.__subckt = None
    def getCellHier(self,subName):
        tempSub = None
        hier = 0
        for sub in self.__subckt:
            insts = sub.getAllInstances()
            if insts is not None:
                for ins in insts:
                    if subName == ins.getType():
                        hier = 1
                        if tempSub is None:
                            tempSub = [sub.getName()]
                        else:
                            if sub.getName() not in tempSub:
                                tempSub.append(sub.getName())
        if hier == 0:
            return [subName]
        else:
            while (hier == 1):
                hier = 0
                tempSubX = tempSub
                tempSub = None
                for subx in tempSubX:
                    for sub in self.__subckt:
                        insts = sub.getAllInstances()
                        if insts is not None:
                            for ins in insts:
                                if subx == ins.getType():
                                    hier = 1
                                    if tempSub is None:
                                        tempSub = [sub.getName()]
                                    else:
                                        if sub.getName() not in tempSub:
                                            tempSub.append(sub.getName())
            else:
                return tempSubX
        return None
    def getCellSubCells(self,cellName):
        allNames = None
        mysub = self.getSubcktByName(cellName)
        if mysub is None:
            print "return nothing"
            return []
        insts = mysub.getAllInstances()
        if insts is None:
            boolvar = False
        else:
            boolvar = True
        while(boolvar):
            boolvar = False
            insts2 = None
            for ins in insts:
                type = ins.getType()
                if allNames is None:
                    allNames = [type]
                else:
                    if type not in allNames:
                        allNames.append(type)
                tempsub = self.getSubcktByName(type)
                #print tempsub.getName()
                if tempsub is not None:
                    tempIn = tempsub.getAllInstances()
                    if tempIn is not None:
                        #print tempIn
                        if insts2 is None:
                            insts2 = tempsub.getAllInstances()
                        else:
                            insts2 = insts2 + tempsub.getAllInstances()
            if insts2 is not None:
                insts = insts2
                boolvar = True
        return allNames
    def compare(self,netlist):
        tempNetlist2 = copy.deepcopy(netlist)
        tempSubs = self.__subckt
        diffSubs = None
        extraSub1 = None
        extraSub2 = None
        if len(self.__subckt) < tempNetlist2.getSubcktCount():
            while (len(self.__subckt)>0):
                sub1 = self.__subckt[0]
                del self.__subckt[0]
                name = sub1.getName()
                sub2 = tempNetlist2.getSubcktByName(name)
                if sub2 is None:
                    if extraSub1 is None:
                        extraSub1 = [sub1]
                    else:
                        extraSub1.append(sub1)
                    continue
                tempNetlist2.removeSubcktByName(name)
                tempNetlist2.removeSubcktByName(name)
                result = sub1.compare(sub2)
                if result != [None,None,None,None] and result != None :
                    if diffSubs is None:
                        diffSubs = [{name:result}]
                    else:
                        diffSubs.append({name:result})

            extraSub2 = tempNetlist2.getSubckts()
            if len(extraSub2) == 0:
                extraSub2 = None
        else:
            while (tempNetlist2.getSubcktCount()>0):
                sub2 = tempNetlist2.getSubckts()[0]
                name = sub2.getName()
                tempNetlist2.removeSubcktByName(name)
                sub1 = self.getSubcktByName(name)
                if sub1 is None:
                    if extraSub2 is None:
                        extraSub2 = [sub2]
                    else:
                        extraSub2.append(sub2)
                    continue
                self.removeSubcktByName(name)
                result = sub2.compare(sub1)
                if result != [None,None,None,None] and result != None :
                    if diffSubs is None:
                        diffSubs = [{name:result}]
                    else:
                        diffSubs.append({name:result})

            extraSub1 = self.__subckt
            if len(extraSub1) == 0:
                extraSub1 = None
        self.__subckt = tempSubs
        return [diffSubs,extraSub1,extraSub2]
################################################################################################################################
################################################################################################################################



