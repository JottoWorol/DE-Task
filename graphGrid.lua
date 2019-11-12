--GRAPH BACK #################################
backLinesColor = 0.9
axisLinesColor = 0.3
graphHeight = H*0.95
xLines = {}
yLines = {}
isKilled = true

function xFindOptimalUnit(yLeft, xLeft, xRight)
  if(xLeft<0)then
    if(xRight - xLeft > 7)then
      for i=1, xRight - xLeft, 0.5 do
        if(intDiv(xRight - xLeft,i)<16 and (mod(-xLeft,i)==0 or mod(i,-xLeft)==0))then
          return i
        end
      end
      return -xLeft
    else
      if(xRight-xLeft>1)then
        return 1/((64/(xRight - xLeft))^(1/2))
      else
        return (xRight-xLeft)/8
      end
    end
  else
    if(xRight - xLeft > 7)then
      for i=1, xRight - xLeft, 0.5 do
        if(intDiv(xRight - xLeft,i)<16)then
          return i
        end
      end
    else
      if(xRight-xLeft>1)then
        return 1/((64/(xRight - xLeft))^(1/2))
      else
        return (xRight-xLeft)/8
      end
    end
  end
end

function yFindOptimalUnit(xLeft, yLeft, yRight)
  if(yLeft<0)then
    if(yRight - yLeft > 7)then
      for i=1, yRight - yLeft, 0.5 do
        if(intDiv(yRight - yLeft,i)<16 and (mod(-yLeft,i)==0 or mod(i,-yLeft)==0))then
          return i
        end
      end
      return -yLeft
    else
      if(yRight-yLeft>1)then
        return 1/((64/(yRight - yLeft))^(1/2))
      else
        return (yRight-yLeft)/8
      end
    end
  else
    if(yRight - yLeft > 7)then
      for i=1, yRight - yLeft, 0.5 do
        if(intDiv(yRight - yLeft,i)<16)then
          return i
        end
      end
    else
      if(yRight-yLeft>1)then
        return 1/((64/(yRight - yLeft))^(1/2))
      else
        return (yRight-yLeft)/8
      end
    end
  end
end

function drawGrid(mode)
  if(mode=="ordinary")then
    xLeft = xLeftBound
    xRight = xRightBound
    yLeft = yLeftBound
    yRight = yRightBound
  elseif(mode=="total")then
    xLeft = totalLeft
    xRight = totalRight
    yLeft = 0
    yRight = totalUpper
  elseif(mode=="local")then
    xLeft = xLeftBound
    xRight = xRightBound
    yLeft = 0
    yRight = localUpper
  end
  xUnit = W/(xRight - xLeft)
  yUnit = graphHeight/(yRight - yLeft)
  isKilled=false
  xLineUnit = xUnit*xFindOptimalUnit(yLeft, xLeft, xRight)
  yLineUnit = yUnit*yFindOptimalUnit(xLeft, yLeft, yRight)
  graphBack = display.newRect(gridGroup,centerX,centerY+(H-graphHeight)/2, W, graphHeight)
  graphBack.strokeWidth = 1
  graphBack:setFillColor(0,0,0,0)
  graphBack:setStrokeColor( 0,0,0 )

  if(xLeft<0)then
    xText = 0 - xLeft*xUnit
  else
    xText = 0
  end

  if(yLeft<0)then
    yText = H+yLeft*yUnit-10
  else
    yText = H-10
  end

  for i=0, W, xLineUnit do  --back X lines  --yText  --vertical lines
    local xLine = display.newLine(gridGroup,i,H,i,H - graphHeight)
    xLine:setStrokeColor(backLinesColor,backLinesColor,backLinesColor)
    xLine.strokeWidth = 3
    xLine.scaleText = display.newText({parent=graphGroup,text = round2(i/xUnit + xLeft), x=i+10,y=yText, font =native.systemFont,fontSize = 20})
    xLine.scaleText:setFillColor( 0,0,0 )
    xLine.scaleText.anchorX = 1
    table.insert( xLines, xLine)
  end

  for i=H, H-graphHeight, -yLineUnit do  --back Y lines  --xText   --horizontal
    local yLine = display.newLine(gridGroup,0,i,W,i)
    yLine:setStrokeColor(backLinesColor,backLinesColor,backLinesColor)
    yLine.strokeWidth = 3
    lineText = round4(-((i-H)/yUnit) + yLeft)
    if(lineText~=0 and lineText~=yRight)then
      yLine.scaleText = display.newText({parent=graphGroup,text =lineText, x=xText,y=i-10, font =native.systemFont,fontSize = 20,align = "left"})
      yLine.scaleText:setFillColor( 0,0,0 )
      yLine.scaleText.anchorX = 0
    end
    table.insert( yLines, yLine)
  end
  if(mode~="total")then
    axisNamex = display.newText({parent=graphGroup,text ="X", x=W,y=yText-30, font =native.systemFont,fontSize = 30})
  else
    axisNamex = display.newText({parent=graphGroup,text ="N", x=W,y=yText-30, font =native.systemFont,fontSize = 30})
  end
  axisNamex:setFillColor( 0,0,0 )
  axisNamex.anchorX = 1

  if(mode=="ordinary")then
    axisNamey = display.newText({parent=graphGroup,text ="Y", x=xText+30,y=H-graphHeight, font =native.systemFont,fontSize = 30})
    axisNamey:setFillColor( 0,0,0 )
  else
    axisNamey = display.newText({parent=graphGroup,text ="Error", x=xText+30,y=H-graphHeight, font =native.systemFont,fontSize = 30})
    axisNamey:setFillColor( 0.3,0.3,0.3 )
  end
  
  axisNamey.anchorY = 0
  axisNamey.anchorX = 0

  yAxis = display.newLine(gridGroup,-xLeft*xUnit,H,-xLeft*xUnit,H - graphHeight)
  yAxis:setStrokeColor(axisLinesColor,axisLinesColor,axisLinesColor)
  yAxis.strokeWidth = 3

  xAxis = display.newLine(gridGroup,0,H +yLeft*yUnit,W,H+yLeft*yUnit)
  xAxis:setStrokeColor(axisLinesColor,axisLinesColor,axisLinesColor)
  xAxis.strokeWidth = 3
end

function killGrid()
  isKilled = true
  for i=#xLines, 1, -1 do
    if(xLines[i].scaleText ~= nil)then
      display.remove(xLines[i].scaleText)
    end
    display.remove(xLines[i])
    table.remove(xLines, i)
  end

  for i=#yLines, 1, -1 do
    if(yLines[i].scaleText ~= nil)then
      display.remove(yLines[i].scaleText)
    end
    display.remove(yLines[i])
    table.remove(yLines, i)
  end
  display.remove(graphBack)
  display.remove(xAxis)
  display.remove(yAxis)
  display.remove(axisNamex)
  display.remove(axisNamey)
end