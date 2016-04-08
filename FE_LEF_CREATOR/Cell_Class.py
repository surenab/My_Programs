import os
import csv
import sys
import shutil

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class Cell(object):
    #Initialization
    def __init__(self,cellName,heigth,width,powerList = ["vddpi","vdda","vddp"],metalWidth = 0.06,metalSpace = 0.04,metalBlk = "layer_20_2",metalPin = "layer_53_0",metalM3LayerE1 = "layer_20_275",metalM3LayerE2 = "layer_20_276",outlLayer = "layer_16_0",m3TextLayer = "layer_60_0"):
        self.cellName = cellName
        self.powerList = powerList
        self.height = heigth
        self.width = width
        self.metalWidth = metalWidth
        self.metalSpace = metalSpace
        self.metalBlk = metalBlk
        self.metalPin = metalPin
        self.metalM3LayerE1 = metalM3LayerE1
        self.metalM3LayerE2 = metalM3LayerE2
        self.outlLayer = outlLayer
        self.m3TextLayer = m3TextLayer
    #Metods
    def printCellInfo (self):
        print "-------------------------------------------------"
        print "cellName = ",self.cellName
        print "powerList = ",self.powerList
        print "height = ",self.height
        print "width = ",self.width
        print "metalWidth = ",self.metalWidth
        print "metalSpace = ",self.metalSpace
        print "metalBlk = ",self.metalBlk
        print "metalPin = ",self.metalPin
        print "metalM3LayerE1 = ",self.metalM3LayerE1
        print "metalM3LayerE2 = ",self.metalM3LayerE2
        print "outlLayer = ",self.outlLayer
        print "m3TextLayer = ",self.m3TextLayer
        print "-------------------------------------------------"
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class PinCell(object):
    #Initialization
    def __init__(self,cellName,heigth,width,pinCellType,pinList = ["a","b","c","b","c","b","c","b","c","b","c","b","c","b","c"],metalWidth = 0.037,metalSpace = 0.02,metalBlk = "layer_6_2",metalPinE1 = "layer_62_0",metalPinE2 = "layer_63_0",metalM1LayerE1 = "layer_6_255",metalM1LayerE2 = "layer_18_256",outlLayer = "layer_16_0",m1TextLayer = "layer_58_0",m1TextLayerE2 = "layer_59_0",m1CutE1 = "layer_31_109",m1CutE2 = "layer_18_110"):
        self.cellName = cellName
        self.pinList = pinList
        self.height = heigth
        self.width = width
        self.metalWidth = metalWidth
        self.metalSpace = metalSpace
        self.metalPinE1 = metalPinE1
        self.metalPinE2 = metalPinE2
        self.metalM1LayerE1 = metalM1LayerE1
        self.metalM1LayerE2 = metalM1LayerE2
        self.outlLayer = outlLayer
        self.m1TextLayer = m1TextLayer
        self.m1TextLayerE2 = m1TextLayerE2
        self.m1CutE1 = m1CutE1
        self.m1CutE2 = m1CutE2
        self.pinCellType = pinCellType
        self.metalBlk = metalBlk
    #Metods
    def printCellInfo (self):
        print "-------------------------------------------------"
        print "cellName = ",self.cellName
        print "powerList = ",self.pinList
        print "height = ",self.height
        print "width = ",self.width
        print "metalWidth = ",self.metalWidth
        print "metalSpace = ",self.metalSpace
        print "metalPinE1 = ",self.metalPinE1
        print "metalPinE2 = ",self.metalPinE2
        print "metalM3LayerE1 = ",self.metalM1LayerE1
        print "metalM3LayerE2 = ",self.metalM1LayerE2
        print "outlLayer = ",self.outlLayer
        print "m3TextLayer = ",self.m1TextLayer
        print "m1CutE1 = ",m1CutE1
        print "m1CutE2 = ",m1CutE2
        print "pinCellType = ",pinCellType
        print "-------------------------------------------------"
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def createTclToGdsFile(allCells,powerList,lefMode,minM3Space,writepath):
    #Creating gds.tcl File
    #Creating library in gds.tcl File
    if os.path.exists(writepath):
        os.remove(writepath)
    with open(writepath,"w") as f:
        f.write("library {lefCells}\n\n")
        f.write('dbu_per_uu 2000\n')
        f.write('user_unit micron\n\n')
        #Repeat while allCells is exist
        for cell in allCells:
            #Creating Cells
            f.write('cell {'+cell.cellName+'}\n')
            f.write('view {layout} layout\n')
            f.write('	boundary {0 0 ' + str(cell.width) + ' 0 ' + str(cell.width) + ' '+str(cell.height) + ' 0 ' + str(cell.height)+'} {' + str(cell.outlLayer) + '}\n')
            metalCount = int((cell.width-cell.metalSpace)/(cell.metalWidth+cell.metalSpace))
            startXPoint = cell.metalSpace/2+cell.metalWidth/2
            blkStartPoint = 0
            firstBlk = 0
            for i in range(0,metalCount,1):
                powerNameIndex = i-(i//len(cell.powerList))*len(cell.powerList)
                powerName = cell.powerList[powerNameIndex]
                if i%2 == 0:
                    metalLayer = cell.metalM3LayerE1
                else:
                    metalLayer = cell.metalM3LayerE2
                if i != 0:
                    startXPoint = startXPoint + (cell.metalSpace+cell.metalWidth)
                #Creating Metals
                f.write('	path { ' + str(startXPoint) +' ' + str(0) + ' ' + str(startXPoint) + ' ' + str(cell.height) + ' } ' + str(cell.metalWidth) + ' {' + metalLayer + '} flush\n')
                #Creating IPIN layers
                if powerName in powerList:
                    #f.write('	path { ' + str(startXPoint) +' ' + str(0) + ' ' + str(startXPoint) + ' ' + str(cell.height) + ' } ' + str(cell.metalWidth) + ' {' + cell.metalPin + '} flush\n')

                    f.write('	boundary {' + str(startXPoint-cell.metalWidth/2) + ' 0 ' + str(startXPoint+cell.metalWidth/2) + ' 0 ' + str(startXPoint+cell.metalWidth/2) + ' '+str(cell.height) + ' ' + str(startXPoint-cell.metalWidth/2) + ' ' + str(cell.height)+'} {' + str(cell.metalPin) + '}\n')


                    if lefMode != "Space":
                        f.write('	boundary {' + str(blkStartPoint) + ' 0 ' + str(startXPoint-cell.metalWidth/2) + ' 0 ' + str(startXPoint-cell.metalWidth/2) + ' '+str(cell.height) + ' ' + str(blkStartPoint) + ' ' + str(cell.height)+'} {' + str(cell.metalBlk) + '}\n')
                        blkStartPoint = startXPoint+cell.metalWidth/2
                    else:
                        if ((startXPoint-cell.metalWidth/2-minM3Space)-(blkStartPoint+minM3Space))>minM3Space:
                            if firstBlk == 0:
                                f.write('	boundary {' + str(blkStartPoint) + ' 0 ' + str(startXPoint-cell.metalWidth/2-minM3Space) + ' 0 ' + str(startXPoint-cell.metalWidth/2-minM3Space) + ' '+str(cell.height) + ' ' + str(blkStartPoint) + ' ' + str(cell.height)+'} {' + str(cell.metalBlk) + '}\n')
                                firstBlk = 1
                            else:
                                f.write('	boundary {' + str(blkStartPoint+minM3Space) + ' 0 ' + str(startXPoint-cell.metalWidth/2-minM3Space) + ' 0 ' + str(startXPoint-cell.metalWidth/2-minM3Space) + ' '+str(cell.height) + ' ' + str(blkStartPoint+minM3Space) + ' ' + str(cell.height)+'} {' + str(cell.metalBlk) + '}\n')
                        blkStartPoint = startXPoint+cell.metalWidth/2
                #Creating Text
                f.write("	text {" + str(startXPoint) + " " + str(0.005) + "} {" + powerName + "} {" + cell.m3TextLayer + "} leftcenter r90 {font_0} 0.02\n")
                #Creating BLK Layer
            if lefMode != "Space":
                f.write('	boundary {' + str(blkStartPoint) + ' 0 ' + str(cell.width) + ' 0 ' + str(cell.width) + ' '+str(cell.height) + ' ' + str(blkStartPoint) + ' ' + str(cell.height)+'} {' + str(cell.metalBlk) + '}\n')
            else:
                f.write('	boundary {' + str(blkStartPoint+minM3Space) + ' 0 ' + str(cell.width) + ' 0 ' + str(cell.width) + ' '+str(cell.height) + ' ' + str(blkStartPoint+minM3Space) + ' ' + str(cell.height)+'} {' + str(cell.metalBlk) + '}\n')
            #Close Temp cell
            f.write('end_view\n')
            f.write('end_cell\n\n')
    #End of Library in gds.tcl File
        #f.write('end_library\n')
        f.close()
    print "Lef Creator::Finish"
    return 0
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def pinCellAddingToTclFile(allCells,lefMode,minM3Space,writepath,m1CutWidth,m1CutOverlapM1,via01Width,m1OverlapV12,m1MinLength,pCount,spaceM1CutToOUTL):
    #Creating gds.tcl File
    #Creating library in gds.tcl File
    if not os.path.exists(writepath):
        print "GDS file is not Exist"
        return -1
    with open(writepath,"a+") as f:
        #Repeat while allCells is exist
        centerAddYPoint = m1MinLength
        for cell in allCells:
            #Creating Cells
            #print "----------------------------------------------------------\n"
            f.write('cell {'+cell.cellName+'}\n')
            f.write('view {layout} layout\n')
            f.write('	boundary {0 0 ' + str(cell.width) + ' 0 ' + str(cell.width) + ' '+str(cell.height) + ' 0 ' + str(cell.height)+'} {' + str(cell.outlLayer) + '}\n')
            bufferWidth = 0
            bufferPinCount = 0
            if cell.pinCellType == "center":
                centerAddYPoint = m1MinLength
                for cellTemp in allCells:
                    if cellTemp.pinCellType == "buffer":
                        bufferHeight = cell.height
                        bufferPinCount = len(cellTemp.pinList)
                        break
            if cell.pinCellType == "io":
                centerAddYPoint = m1MinLength
            pinCount = len(cell.pinList)
            if ((pinCount+bufferPinCount+8)*m1MinLength/pCount>(cell.height+bufferHeight)):
                print "ERROR::Impossible Create Center+Buffer Pins in Center+Buffer Width!\nPlease change Center or Buffer width!"
                return -1
            if (pinCount*m1MinLength/pCount>cell.height):
                height = pinCount*m1MinLength/pCount
            else:
                height = cell.height
            startXPoint = cell.width - m1CutOverlapM1 -cell.metalWidth/2 - spaceM1CutToOUTL
            for i in range(0,pCount):
                if i%2 == 0:
                    metalLayer = cell.metalM1LayerE1
                else:
                    metalLayer = cell.metalM1LayerE2
                f.write('	path { ' + str(startXPoint-i*(cell.metalWidth+cell.metalSpace)) +' ' + str(0) + ' ' + str(startXPoint-i*(cell.metalWidth+cell.metalSpace)) + ' ' + str(height) + ' } ' + str(cell.metalWidth) + ' {' + metalLayer + '} flush\n')
            x1CutE1 = cell.width-2*m1CutOverlapM1-pCount*(cell.metalWidth+cell.metalSpace)+cell.metalSpace - spaceM1CutToOUTL
            x1CutE2 = cell.width-2*m1CutOverlapM1-(pCount-1)*(cell.metalWidth+cell.metalSpace)+cell.metalSpace - spaceM1CutToOUTL
            x2CutE1 = cell.width - spaceM1CutToOUTL
            x2CutE2 = cell.width-cell.metalWidth-cell.metalSpace - spaceM1CutToOUTL
            x1Text = x1CutE1 + m1CutOverlapM1+cell.metalWidth/2
            x2Text = x1Text + (cell.metalWidth+cell.metalSpace)
            x3Text = x2Text + (cell.metalWidth+cell.metalSpace)
            textIndex = 0



            f.write('	path { ' + str(x1CutE1) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength) + ' ' + str(x2CutE1) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
            f.write('	path { ' + str(x1CutE2) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength) + ' ' + str(x2CutE2) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE2 + '} flush\n')
            if (pinCount+bufferPinCount < pCount):
                if textIndex<len(cell.pinList):
                    f.write("	text {" + str(x1Text) + " " + str((m1MinLength-centerAddYPoint)+0.005+m1CutWidth/2) + "} {" + cell.pinList[textIndex] + "} {" + cell.m1TextLayer + "} leftcenter r90 {font_0} 0.02\n")
                    textIndex += 1
                    f.write('	path { ' + str(x1Text) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength+m1CutWidth/2) + ' ' + str(x1Text) + ' ' + str((m1MinLength-centerAddYPoint)+(0+1)*m1MinLength - m1CutWidth/2) + ' } ' + str(cell.metalWidth) + ' {' + cell.metalPinE1 + '} flush\n')

                if textIndex<len(cell.pinList):
                    f.write("	text {" + str(x2Text) + " " + str((m1MinLength-centerAddYPoint)+0.005+m1CutWidth/2) + "} {" + cell.pinList[textIndex] + "} {" + cell.m1TextLayerE2 + "} leftcenter r90 {font_0} 0.02\n")
                    textIndex += 1
                    f.write('	path { ' + str(x2Text) + ' ' + str((m1MinLength-centerAddYPoint)+0*m1MinLength+m1CutWidth/2) + ' ' + str(x2Text) + ' ' + str((m1MinLength-centerAddYPoint)+(0+1)*m1MinLength - m1CutWidth/2) + ' } ' + str(cell.metalWidth) + ' {' + cell.metalPinE2 + '} flush\n')

                tempPoint = (m1MinLength-centerAddYPoint)+0*m1MinLength+m1CutWidth/2
                while tempPoint>m1MinLength:
                    f.write('	boundary {' + str(x1Text-cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE1) + '}\n')
                    f.write('	boundary {' + str(x2Text-cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE2) + '}\n')
                    f.write('	boundary {' + str(x3Text-cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE1) + '}\n')
                    tempPoint = tempPoint - m1MinLength
                else:
                    f.write('	boundary {' + str(x1Text-cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE1) + '}\n')
                    f.write('	boundary {' + str(x2Text-cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE2) + '}\n')
                    f.write('	boundary {' + str(x3Text-cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' '+str(tempPoint-m1CutWidth) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(tempPoint-m1CutWidth)+'} {' + str(cell.metalPinE1) + '}\n')




            if centerAddYPoint != m1MinLength:
                firstXPoint = -centerAddYPoint
            else:
                firstXPoint = 0
            for i in range(0,len(cell.pinList)//pCount + 1):
                if textIndex<len(cell.pinList):
                    f.write("	text {" + str(x1Text) + " " + str(firstXPoint+0.005+i*m1MinLength+m1CutWidth/2) + "} {" + cell.pinList[textIndex] + "} {" + cell.m1TextLayer + "} leftcenter r90 {font_0} 0.02\n")
                    textIndex += 1
                    f.write('	boundary {' + str(x1Text-cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) + ' '+str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2)+'} {' + str(cell.metalPinE1) + '}\n')

                if textIndex<len(cell.pinList):
                    f.write("	text {" + str(x2Text) + " " + str(firstXPoint+0.005+i*m1MinLength+m1CutWidth/2) + "} {" + cell.pinList[textIndex] + "} {" + cell.m1TextLayerE2 + "} leftcenter r90 {font_0} 0.02\n")
                    textIndex += 1
                    f.write('	boundary {' + str(x2Text-cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) + ' '+str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2)+'} {' + str(cell.metalPinE2) + '}\n')

                if textIndex<len(cell.pinList):
                    f.write("	text {" + str(x3Text) + " " + str(firstXPoint+0.005+i*m1MinLength+m1CutWidth/2) + "} {" + cell.pinList[textIndex] + "} {" + cell.m1TextLayer + "} leftcenter r90 {font_0} 0.02\n")
                    textIndex += 1
                    f.write('	path { ' + str(x1CutE1) + ' ' + str(firstXPoint+(i+1)*m1MinLength) + ' ' + str(x2CutE1) + ' ' + str(firstXPoint+(i+1)*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
                    f.write('	path { ' + str(x1CutE2) + ' ' + str(firstXPoint+(i+1)*m1MinLength) + ' ' + str(x2CutE2) + ' ' + str(firstXPoint+(i+1)*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE2 + '} flush\n')
                    f.write('	boundary {' + str(x3Text-cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) +' '+ str(firstXPoint+i*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) + ' '+str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(firstXPoint+(i+1)*m1MinLength - m1CutWidth/2)+'} {' + str(cell.metalPinE1) + '}\n')
                else:
                    if i == len(cell.pinList)//3:
                        centerAddYPoint = cell.height - (firstXPoint+i*m1MinLength)
                    if centerAddYPoint>0:
                        if centerAddYPoint-m1MinLength>=m1MinLength:
                            centerAddYPoint = m1MinLength
                        elif centerAddYPoint-m1MinLength>0:
                            centerAddYPoint = centerAddYPoint-m1MinLength
                    break
            firstXPointCut = firstXPoint
            while firstXPointCut >= 0:
                f.write('	path { ' + str(x1CutE1) + ' ' + str(firstXPointCut) + ' ' + str(x2CutE1) + ' ' + str(firstXPointCut) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
                f.write('	path { ' + str(x1CutE2) + ' ' + str(firstXPointCut) + ' ' + str(x2CutE2) + ' ' + str(firstXPointCut) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE2 + '} flush\n')
                firstXPointCut = firstXPointCut - m1MinLength
            else:
                f.write('	boundary {' + str(x1Text-cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' 0 ' + str(x1Text+cell.metalWidth/2) + ' '+str(firstXPointCut+m1MinLength-m1CutWidth/2) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(firstXPointCut+m1MinLength-m1CutWidth/2)+'} {' + str(cell.metalPinE1) + '}\n')
                f.write('	boundary {' + str(x2Text-cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' 0 ' + str(x2Text+cell.metalWidth/2) + ' '+str(firstXPointCut+m1MinLength-m1CutWidth/2) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(firstXPointCut+m1MinLength-m1CutWidth/2)+'} {' + str(cell.metalPinE2) + '}\n')
                f.write('	boundary {' + str(x3Text-cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' 0 ' + str(x3Text+cell.metalWidth/2) + ' '+str(firstXPointCut+m1MinLength-m1CutWidth/2) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(firstXPointCut+m1MinLength-m1CutWidth/2)+'} {' + str(cell.metalPinE1) + '}\n')

            if (pinCount*m1MinLength/pCount<=cell.height):
                if (cell.height-((pinCount+1)//pCount*m1MinLength))>=0:
                    if (cell.pinCellType != "cap"):
                        f.write('	path { ' + str(x1CutE1) + ' ' + str(cell.height) + ' ' + str(x2CutE1) + ' ' + str(cell.height) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
                        f.write('	path { ' + str(x1CutE2) + ' ' + str(cell.height) + ' ' + str(x2CutE2) + ' ' + str(cell.height) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE2 + '} flush\n')
                if m1MinLength - centerAddYPoint<=m1MinLength and m1MinLength - centerAddYPoint>0 and cell.pinCellType == "center":
                    f.write('	boundary {' + str(x1Text-cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) + ' '+str(cell.height) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(cell.height)+'} {' + str(cell.metalPinE1) + '}\n')
                    f.write('	boundary {' + str(x2Text-cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) + ' '+str(cell.height) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(cell.height)+'} {' + str(cell.metalPinE2) + '}\n')
                    f.write('	boundary {' + str(x3Text-cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) +' '+ str(pinCount//pCount*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) + ' '+str(cell.height) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(cell.height)+'} {' + str(cell.metalPinE1) + '}\n')
                else:
                    capBLK = 0
                    if (cell.pinCellType == "cap"):
                        capBLK = m1CutWidth/2
                    if pinCount%pCount == 0:
                        f.write('	boundary {' + str(x1Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x2Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x3Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                    elif pinCount%pCount == 1:
                        f.write('	path { ' + str(x1CutE1) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' ' + str(x2CutE1) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
                        f.write('	boundary {' + str(x1Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x2Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x3Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                    elif pinCount%pCount == 2:
                        f.write('	path { ' + str(x1CutE1) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' ' + str(x2CutE1) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE1 + '} flush\n')
                        f.write('	path { ' + str(x1CutE2) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' ' + str(x2CutE2) + ' ' + str(firstXPoint+((pinCount)//pCount+1)*m1MinLength) + ' } ' + str(m1CutWidth) + ' {' + cell.m1CutE2 + '} flush\n')
                        f.write('	boundary {' + str(x1Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x1Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x1Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x2Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount+1)*m1MinLength+m1CutWidth/2) +' '+ str(x2Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x2Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')
                        f.write('	boundary {' + str(x3Text-cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) +' '+ str(firstXPoint+((pinCount)//pCount)*m1MinLength+m1CutWidth/2) +' '+ str(x3Text+cell.metalWidth/2) + ' '+str(cell.height - m1CutWidth/2 + capBLK) + ' ' + str(x3Text-cell.metalWidth/2) + ' ' + str(cell.height - m1CutWidth/2 + capBLK)+'} {' + str(cell.metalBlk) + '}\n')

            if cell.pinCellType == "buffer":
                centerAddYPoint = m1MinLength


            #Close Temp cell
            f.write('end_view\n')
            f.write('end_cell\n\n')
    #End of Library in gds.tcl File
        f.write('end_library')
        f.close()
    print "Lef Creator::Finish"
    return 0
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def detectDelimiter(csvFile):
    with open(csvFile, 'r') as myCsvfile:
        header=myCsvfile.readline()
        if ";" in header:
            return ";"

        if "," in header:
            return ","

        if "\t" in header:
            return "\t"
    return ","
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def main():
    fileName = sys.argv[1]
    print "Lef Creator::Start MAIN Function"
    #Infor for cell generation
    #-----------------------------------------------
    powerList = ["vddp","vdda","vdd","vss"]
    lefMode = "Space" #Possible "NoSpace"
    minM3Space = 0.02
    writepath = 'newGds.tcl'
    #fileName = "real.csv"
    #-----------------------------------------------
    #Info for pin cell generation
    m1CutWidth = 0.03
    m1CutOverlapM1 = 0.045
    via01Width = 0.02
    via12Width = 0.02
    m1OverlapV12 = 0.02
    m2MinPitch = 0.04
    m2Width = 0.02
    pinCountX = 3
    minM1Space = 0.02
    spaceM1CutToOUTL = 0.0505
    m1MinLength = (pinCountX-1) * m2MinPitch + 2 * m1OverlapV12 + via12Width + m2Width + 2 * m2MinPitch + m1CutWidth
    #-----------------------------------------------
    #Reading CSV File
    #Parsing CSV Info
    #Creating Cell Objects
    delimeterX = detectDelimiter(fileName)
    #print "delimeterX = ",delimeterX
    allCells,allPinCells = getAllCells(fileName,delimeterX)
    createTclToGdsFile(allCells,powerList,lefMode,minM3Space,writepath)
    pinCellAddingToTclFile(allPinCells,lefMode,minM1Space,writepath,m1CutWidth,m1CutOverlapM1,via01Width,m1OverlapV12,m1MinLength,pinCountX,spaceM1CutToOUTL)
    os.system("tcl2gds newGds.tcl newGds.gds /u/surenab/Desktop/scripts/CSV/tech.out")
    if not os.path.exists("FE_LEF_GDS"):
        os.makedirs("FE_LEF_GDS")
    else:
        shutil.rmtree("FE_LEF_GDS")
        os.makedirs("FE_LEF_GDS")
    os.rename("newGds.gds","./FE_LEF_GDS/newGds.gds")
    os.rename("newGds.tcl","./FE_LEF_GDS/newGds.tcl")
    return 0
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def converDelimiter(fileName,delimeterX):
    txt_file = fileName
    csv_file = fileName + "_temp"
    f1 = open(txt_file, "rt")
    f2 = open(csv_file, 'wt')
    in_txt = csv.reader(f1, delimiter = delimeterX)
    out_csv = csv.writer(f2,delimiter = "\t")
    out_csv.writerows(in_txt)
    f1.close()
    f2.close()
    return csv_file
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def getAllCells(fileName,delimeterX):
    if delimeterX == "\t":
        f = open(fileName,'rt')
    else:
        f = open(converDelimiter(fileName,delimeterX),'rt')
    cellType = []
    allFileInfo = []
    cellHeights = []
    powerList = []
    cellTypeName = {}
    cellWidths = []
    try:
        reader = csv.reader(f)
        for row in reader:
            #print ', '.join(row)
            allFileInfo.append(row)
    finally:
        f.close()
    #Finding cell Types################
    for i in allFileInfo[0]:
        cellType=i.split()
    cellType.pop(0)
    ###################################
    #Finding cell Height###############
    for i in allFileInfo[1]:
        cellHeights=i.split("\t")
    ###################################
    #Finding Cell list################
    for i in allFileInfo:
        if "Pin Cells" in i[0]:
            indexCapStart = allFileInfo.index(i)
            break
    for i in allFileInfo:
        if "Powers" in i[0]:
            indexPowerStart = allFileInfo.index(i)
            break

    cells = []
    for j in range(2,indexPowerStart):
        for i in allFileInfo[j]:
            if len(i.split())>0:
                cells.append(i.split("\t"))


    for cell in cells:
        for index,i in enumerate(cell):
            if index == 0:
                cellWidths.append(i)
                continue
            if cellType[index-1] not in cellTypeName.keys():
                cellTypeName[cellType[index-1]] = [i]
            else:
                cellTypeName[cellType[index-1]].append(i)
            #print cellTypeName
    print "cell Type and Name is",cellTypeName
    print "keys = ",cellTypeName.keys()
    print "cellWidths =", cellWidths
    print "cellHeights = ", cellHeights
    cellHeights = cellHeights[1:]
    ###################################
    powerList =  allFileInfo[indexPowerStart][0].split("\t")[1:]
    print "powerList =", powerList
    #print "powerList = ", powerList
    #for ix,i in enumerate(cellTypeName):
    newPowerList = []
    for p in powerList:
        newPowerList.append(p.split(";"))
    print "newPowerList =", newPowerList
    pinCells = []
    pinCellPins = []
    pinCellWidths = []
    pinCellTypeName = {}
    pinCellTypePins = {}
    for i in range(indexCapStart+1,len(allFileInfo),2):
        pinCells.append(allFileInfo[i][0].split("\t"))
        pinCellPins.append(allFileInfo[i+1][0].split("\t"))
    for pIndex,pinCell in enumerate(pinCells):
        for index,i in enumerate(pinCell):
            if index == 0:
                pinCellWidths.append(i)
                continue
            #print "index = ",index
            #print "pin with that index-1 = ",pinCells[pIndex][index]
            if cellType[index-1] not in pinCellTypeName.keys():
                pinCellTypeName[cellType[index-1]] = [pinCells[pIndex][index]]
            else:
                pinCellTypeName[cellType[index-1]].append(pinCells[pIndex][index])
    for pIndex,pinCellPin in enumerate(pinCellPins):
        for index,i in enumerate(cellType):
            if cellType[index] not in pinCellTypePins.keys():
                pinCellTypePins[cellType[index]] = [pinCellPins[pIndex][index+1].split()]
            else:
                pinCellTypePins[cellType[index]].append(pinCellPins[pIndex][index+1].split())
    allCellObjects = []
    allPinCellObject = []
    keys = cellTypeName.keys()
    for index,i in enumerate(cellWidths):
        tempW = float(i)
        #print tempW
        #print tempPinW
        for inx,j in enumerate(cellHeights):
            if j == "":
                continue
            tempH = float(j)
            if inx == 2:
                nameI = 4
            elif inx == 3:
                nameI = 3
            elif inx == 4:
                nameI = 5
            elif inx == 5:
                nameI = 2
            else:
                nameI = inx
            tempCellName = cellTypeName[keys[nameI]][index]
            #print "tempCellName = ",tempCellName
            if len(tempCellName.split())<=0:
                #print "	continue"
                continue
            tempPowerList = newPowerList[inx]
            #print "		tempPinCellName = ",tempPinCellName
            #print "		tempPinCellPins = ",tempPinCellPins
            #print "		",tempH,tempCellName,tempPowerList
            tempCellClass = Cell(tempCellName,tempH,tempW,tempPowerList)
            allCellObjects.append(tempCellClass)

    for index,i in enumerate(pinCellWidths):
        if pinCellWidths[index] == "":
            continue
        tempPinW = float(pinCellWidths[index])
        #print tempW
        #print tempPinW
        for inx,j in enumerate(cellHeights):
            if j == "":
                continue
            tempH = float(j)
            if inx == 2:
                nameI = 4
            elif inx == 3:
                nameI = 3
            elif inx == 4:
                nameI = 5
            elif inx == 5:
                nameI = 2
            else:
                nameI = inx
            tempPinCellName = pinCellTypeName[keys[nameI]][index]
            if len(tempPinCellName.split())<=0:
                #print "	continue"
                continue
                continue
            tempPinCellPins = pinCellTypePins[keys[nameI]][index]
            #print "		",tempH,tempCellName,tempPowerList
            tempPinCellClass = PinCell(tempPinCellName,tempH,tempPinW,keys[nameI],tempPinCellPins)
            allPinCellObject.append(tempPinCellClass)
    return allCellObjects,allPinCellObject
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
main()
