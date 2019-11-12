local textHeight = W/30
local startY = H/10
local startX = W/10
optionsUI = {}
local xLeftField
local xRightField
local yLeftField
local yRightField
local nField
local x0Field
local y0Field
local optionsKilled = true


function newText(text, x, y)
  local t = display.newText({text = text, x=x+textHeight*2.5,y=y,font = native.systemFont, fontSize = 25})
  t:setFillColor( 0,0,0 )
  return t
end

function newTextField(text, x,y)
  local tf = native.newTextField(x  + H/3, y, textHeight*5, textHeight)
  local paramText = newText(text, x, y)
  paramText.anchorX=1
  table.insert(optionsUI, tf)
  table.insert( optionsUI, paramText)
  return tf
end

function computeGraphs(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    xLeftBound = eval(xLeftField.text)
    xRightBound = eval(xRightField.text)
    yLeftBound = eval(yLeftField.text)
    yRightBound = eval(yRightField.text)
    x0 = eval(x0Field.text)
    y0 = eval(y0Field.text)
    n = eval(nField.text)
    X = eval(XField.text)
    localUpper = eval(localToField.text)
    totalLeft = eval(totalFromField.text)
    totalRight = eval(totalToField.text)
    clearGraphs()
    plot("exact")
    plot("euler")
    plotDifference("euler")
    plot("eulerIm")
    plotDifference("eulerIm")
    plot("kutta")
    plotDifference("kutta")
    plotDifference("eulerLocal")
    plotDifference("eulerImLocal")
    plotDifference("kuttaLocal")
    plotApprox("euler")
    plotApprox("eulerIm")
    plotApprox("kutta")
    killMainButtons()
    showMainButtons()
    completedText = display.newText({text = "completed!", x=startX, y=startY+textHeight*14,font=native.systemFont,fontSize=30})
    completedText:setFillColor(0,0,0)
    table.insert( optionsUI, completedText)
  end
end

function setDefault(event)
  if(event==1 or event.isPrimaryButtonDown)then
    if(event~=1)then
      buttonAnim(event.target)
    end
    xLeftField.text = "-1"
    xRightField.text = "6"
    yLeftField.text = "-10"
    yRightField.text = "1000"
    nField.text = "1000"
    x0Field.text = "1"
    y0Field.text = "2"
    XField.text = "6"
    localToField.text = "0.01"
    totalFromField.text = "2"
    totalToField.text = "1000"
    if(completedText~=nil)then
      completedText.text = ""
    end
  end
end

function restoreValues()
  xLeftField.text = tostring(xLeftBound)
  xRightField.text = tostring(xRightBound)
  yLeftField.text = tostring(yLeftBound)
  yRightField.text = tostring(yRightBound)
  nField.text = tostring(n)
  x0Field.text = tostring(x0)
  y0Field.text = tostring(y0)
  XField.text = tostring(X)
  localToField.text = tostring(localUpper)
  totalFromField.text = tostring(totalLeft)
  totalToField.text = tostring(totalRight)
end

function showOptions()
  if(optionsKilled)then
    optionsKilled=false
  else
    return
  end
  xLeftField = newTextField("x Grid From:",startX, startY)
  xRightField = newTextField("x Grid To:",startX, startY + textHeight)
  yLeftField = newTextField("y Grid From:",startX, startY + textHeight*2)
  yRightField = newTextField("y Grid To:",startX, startY + textHeight*3)
  nField = newTextField("N:",startX, startY + textHeight*4)
  x0Field = newTextField("x0:",startX, startY + textHeight*5)
  y0Field = newTextField("y0:",startX, startY + textHeight*6)
  XField = newTextField("X:",startX, startY + textHeight*7)
  localToField = newTextField("Local Error Y To:",startX, startY + textHeight*8)
  totalFromField = newTextField("Total Error N From:",startX, startY + textHeight*9)
  totalToField = newTextField("Total Error N To:",startX, startY + textHeight*10)
  restoreValues()
  setButton = createButton("COMPUTE", startX, startY + textHeight*13)
  setButton:addEventListener( "mouse", computeGraphs)
  defaultButton = createButton("set default", startX, startY + textHeight*12)
  defaultButton:addEventListener( "mouse", setDefault)
end

function killOptions()
  if(not optionsKilled)then
    optionsKilled=true
  else
    return
  end
  for i=#optionsUI, 1, -1 do
    display.remove(optionsUI[i])
    table.remove( optionsUI,i )
  end
end

