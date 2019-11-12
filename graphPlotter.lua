xLeftBound = -1
xRightBound = 6
yLeftBound = -10
yRightBound = 1000
totalLeft = 2
totalRight = 1000
totalUpper = 2000
localUpper = 0.01
n = 1000
step = 0.05
x0 = 1
y0 = 2
X = 6
local c
local graphExact = {}
local graphEuler = {}
local graphEulerExact = {}
local graphImproved = {}
local graphImprovedExact = {}
local graphKutta = {}
local graphKuttaExact = {}
local graphEulerBetterExact = {}
local graphImprovedBetterExact = {}
local graphKuttaBetterExact = {}
local approxEuler = {}
local approxImproved = {}
local approxKutta = {}
grid = require("graphGrid")
local function line(x1,y1,x2,y2)
  p = display.newLine(graphGroup,x1,y1,x2,y2)
  p:setStrokeColor( 0,0,0,0 )
  p.strokeWidth = 3
  p.y1 = y1
  p.y2 = y2
  p.x1 = x1
  p.x2 = x2
  return p
end

function replaceXWith(expression,x)
  for i=1, #expression do
    if(expression[i]=='x')then
      return replaceXWith(substring(expression,1,i-1)..'('..x..')'..substring(expression,i+1,#expression),x)
    end
  end
  return expression
end

function compStep(N)
  return (X-x0)/N
end

function  compParam()
  return math.log(y0/x0+1)/x0
end

local eulerPrevX
local eulerPrevY

function origFunc(x,y)
  return (y/x+1)*math.log(y/x+1)+y/x
end

function exact(x)
  return x*(math.exp(x*c)-1)
end

function euler(x)
  if(x==x0)then
    eulerPrevY = y0
    eulerPrevX = x0
    return y0
  else
    h = (x-eulerPrevX)
    eulerPrevY = eulerPrevY+h*origFunc(eulerPrevX,eulerPrevY)
    eulerPrevX = x
    return eulerPrevY
  end
end

function eulerBetter(x)
  if(x==x0)then
    eulerPrevY = y0
    eulerPrevX = x0
    return y0
  else
    h = (x-eulerPrevX)
    result = eulerPrevY+h*origFunc(eulerPrevX,eulerPrevY)
    eulerPrevX = x
    eulerPrevY = exact(x)
    return result
  end
end

function eulerIm(x)
  if(x==x0)then
    eulerPrevY = y0
    eulerPrevX = x0
    return y0
  else
    h = (x-eulerPrevX)
    eulerPrevY = eulerPrevY+h/2*(origFunc(eulerPrevX,eulerPrevY) + origFunc(x,eulerPrevY+h*origFunc(eulerPrevX,eulerPrevY)))
    eulerPrevX = x
    return eulerPrevY
  end
end

function eulerImBetter(x)
  if(x==x0)then
    eulerPrevY = y0
    eulerPrevX = x0
    return y0
  else
    h = (x-eulerPrevX)
    result = eulerPrevY+h/2*(origFunc(eulerPrevX,eulerPrevY) + origFunc(x,eulerPrevY+h*origFunc(eulerPrevX,eulerPrevY)))
    eulerPrevX = x
    eulerPrevY = exact(x)
    return result
  end
end

local px
local py
function kutta(x)
  if(x==x0)then
    py = y0
    px = x0
    return y0
  else
    h = (x-px)
    k1 = origFunc(px,py)
    k2 = origFunc(px+h/2,py+k1*h/2)
    k3 = origFunc(px+h/2,py+k2*h/2)
    k4 = origFunc(px+h,py+h*k3)
    py = py + (h/6)*(k1+2*k2+2*k3+k4)
    px = x
    return py
  end
end

function kuttaBetter(x)
  if(x==x0)then
    py = y0
    px = x0
    return y0
  else
    h = (x-px)
    k1 = origFunc(px,py)
    k2 = origFunc(px+h/2,py+k1*h/2)
    k3 = origFunc(px+h/2,py+k2*h/2)
    k4 = origFunc(px+h,py+h*k3)
    result = py + (h/6)*(k1+2*k2+2*k3+k4)
    px = x
    py = exact(x)
    return result
  end
end

function funcValue(str,x)
  if(str=="exact")then
    return  exact(x)
  elseif(str=="euler")then
    return euler(x)
  elseif(str=="eulerIm")then
    return eulerIm(x)
  elseif(str=="kutta")then
    return kutta(x)
  elseif(str=="eulerLocal")then
    return eulerBetter(x)
  elseif(str=="eulerImLocal")then
    return eulerImBetter(x)
  elseif(str=="kuttaLocal")then
    return kuttaBetter(x)
  end
end

function realPoint(func,x)
  local result = H-funcValue(func,x)*yUnit + yLeftBound*yUnit
  return result
end

function plot(func)
  xUnit = W/(xRightBound - xLeftBound)
  yUnit = graphHeight/(yRightBound - yLeftBound)
  c = compParam()
  step = compStep(n)*xUnit
  local tableToSave
  if(func=="exact")then
    tableToSave = graphExact
  elseif(func=="euler")then
    tableToSave = graphEuler
  elseif(func=="eulerIm")then
    tableToSave = graphImproved
  elseif(func=="kutta")then
    tableToSave = graphKutta
  elseif(func=="eulerLocal")then
  end
  local prevPoint = realPoint(func, x0)
  for i=(-xLeftBound+x0)*xUnit+step, (-xLeftBound+X)*xUnit, step do
    xx = (i + xLeftBound*xUnit)/xUnit
    if(prevPoint>=H-graphHeight and funcValue(func, xx)>-xx)then --and funcValue(func, xx)<=-xx
      local graphLine = line(i - step, prevPoint,i, realPoint(func,xx))
      table.insert( tableToSave, graphLine)
    end
    prevPoint = realPoint(func,xx)
  end
end

function plotDifference(toCompare)
  toSaveTable=nil
  local yLeft = yLeftBound
  local yRight = yRightBound
  if(toCompare=="euler")then
    toSaveTable = graphEulerExact
  elseif(toCompare=="eulerIm")then
    toSaveTable = graphImprovedExact
  elseif(toCompare=="kutta")then
    toSaveTable = graphKuttaExact
  else
    yUnit = graphHeight/(localUpper)
    yLeft = 0
    yRight = localUpper
    if(toCompare=="eulerLocal")then
      toSaveTable = graphEulerBetterExact
    elseif(toCompare=="eulerImLocal")then
      toSaveTable = graphImprovedBetterExact
    elseif(toCompare=="kuttaLocal")then
      toSaveTable = graphKuttaBetterExact
    end
  end
  local prevPoint = H-math.abs(realPoint(toCompare,x0)-realPoint("exact",x0))+yLeft*yUnit
  local currentPoint
  for i=(-xLeftBound+x0)*xUnit+step, (-xLeftBound+X)*xUnit, step do
    xx = (i + xLeftBound*xUnit)/xUnit
    if(prevPoint>=H-graphHeight)then
      currentPoint = H-math.abs(realPoint(toCompare,xx)-realPoint("exact",xx))+yLeft*yUnit
      local graphLine = line(i - step, prevPoint,i, currentPoint)
      table.insert(toSaveTable, graphLine)
      prevPoint = currentPoint
    end
  end
end

function plotApprox(func)
  local errorTable
  if(func=="euler")then
    errorTable=approxEuler
  elseif(func=="eulerIm")then
    errorTable=approxImproved
  elseif(func=="kutta")then
    errorTable=approxKutta
  end
  local approxUnit = W/(totalRight-totalLeft)
  local prevApprox
  for i=totalLeft, totalRight do
    local approxStep = compStep(i)
    local prevY = math.abs(funcValue(func, x0)-funcValue("exact",x0))
    for j=x0 + approxStep, X, approxStep do
      prevY = math.abs(funcValue(func, j)-funcValue("exact",j))
    end
    if(i>totalLeft)then
      local graphLine = line((i - totalLeft-1)*approxUnit,H - prevApprox*(graphHeight/totalUpper), (i- totalLeft)*approxUnit, H - prevY*(graphHeight/totalUpper))
      prevApprox = prevY
      table.insert( errorTable, graphLine)
    else
      prevApprox = prevY
    end
  end
end

local legendUI = {}

function showLegend(graphNames,colors)
  local rowHeight = H/15
  local width = W/8
  local boxWidth = width/6
  local height = rowHeight*#graphNames
  local back = display.newRect( graphGroup, W-width/2, H-graphHeight+height/2, width, height )
  back:setFillColor( 1,1,1 )
  for i=1, #graphNames do
    local lText = display.newText({parent = graphGroup, text = graphNames[i], x = W-width, y = H-graphHeight+rowHeight*(i-0.5), font = native.systemFont, fontSize = rowHeight/2})
    lText:setFillColor( 0,0,0 )
    lText.anchorX=0
    table.insert( legendUI, lText)
    local box = display.newRect( graphGroup, W-boxWidth, lText.y, boxWidth, boxWidth)
    box:setFillColor( colors[i][1],colors[i][2],colors[i][3] )
    table.insert(legendUI, box)
  end

  table.insert(legendUI,back)
end

function killLegend()
  for i=#legendUI,1, -1 do
    display.remove(legendUI[i])
    table.remove(legendUI,i)
  end
end

function showExact()
  for i, line in pairs(graphExact) do
    line:setStrokeColor( 0,0,0,1 )
  end
  showLegend({"Exact"},{{0,0,0}})
end

function killExact()
  for i, line in pairs(graphExact) do
    line:setStrokeColor( 0,0,0,0 )
  end
  killLegend()
end

function showEuler()
  for i, line in pairs(graphEuler) do
    line:setStrokeColor( 0,0,0,1 )
  end
  for i, line in pairs(graphEulerExact) do
    line:setStrokeColor( 1,0,0,1 )
  end
  showLegend({"Euler","Error"},{{0,0,0},{1,0,0}})
end

function killEuler()
  for i, line in pairs(graphEuler) do
    line:setStrokeColor( 0,0,0,0 )
  end
  for i, line in pairs(graphEulerExact) do
    line:setStrokeColor( 0,0,0,0 )
  end
  killLegend()
end

function showEulerIm()
  for i, line in pairs(graphImproved) do
    line:setStrokeColor( 0,0,0,1 )
  end
  for i, line in pairs(graphImprovedExact) do
    line:setStrokeColor( 0,0.5,0,1 )
  end
  showLegend({"Improved","Error"},{{0,0,0},{0,0.5,0}})
end

function killEulerIm()
  for i, line in pairs(graphImproved) do
    line:setStrokeColor( 0,0,0,0 )
  end
  for i, line in pairs(graphImprovedExact) do
    line:setStrokeColor( 0,0,0,0 )
  end
  killLegend()
end

function showKutta()
  for i, line in pairs(graphKutta)do
    line:setStrokeColor( 0,0,0,1 )
  end
  for i, line in pairs(graphKuttaExact) do
    line:setStrokeColor( 0,0,1,1 )
  end
  showLegend({"Euler","Error"},{{0,0,0},{0,0,1}})
end

function killKutta()
  for i, line in pairs(graphKutta) do
    line:setStrokeColor( 0,0,0,0 )
  end
  for i, line in pairs(graphKuttaExact) do
    line:setStrokeColor( 0,0,0,0 )
  end
  killLegend()
end

function showLocal()
  for i, line in pairs(graphKuttaBetterExact) do
    line:setStrokeColor( 0,0,1,1 )
  end

  for i, line in pairs(graphEulerBetterExact) do
    line:setStrokeColor( 1,0,0,1 )
  end

  for i, line in pairs(graphImprovedBetterExact) do
    line:setStrokeColor( 0,0.5,0,1 )
  end
  showLegend({"Euler","Improved","Kutta"},{{1,0,0},{0,0.3,0},{0,0,1}})
end

function killLocal()
  for i, line in pairs(graphKuttaBetterExact) do
    line:setStrokeColor( 1,0,0,0 )
  end

  for i, line in pairs(graphEulerBetterExact) do
    line:setStrokeColor( 1,0,0,0 )
  end

  for i, line in pairs(graphImprovedBetterExact) do
    line:setStrokeColor( 1,0,0,0 )
  end
  killLegend()
end

function showTotal()
  for i, line in pairs(approxEuler) do
    line:setStrokeColor( 1,0,0,1 )
  end

  for i, line in pairs(approxImproved) do
    line:setStrokeColor( 0,0.3,0,1 )
  end

  for i, line in pairs(approxKutta) do
    line:setStrokeColor( 0,0,1,1 )
  end

  showLegend({"Euler","Improved","Kutta"},{{1,0,0},{0,0.3,0},{0,0,1}})
end

function killTotal()
  for i, line in pairs(approxEuler) do
    line:setStrokeColor( 0,0,1,0 )
  end

  for i, line in pairs(approxImproved) do
    line:setStrokeColor( 0,0,1,0 )
  end

  for i, line in pairs(approxKutta) do
    line:setStrokeColor( 0,0,1,0 )
  end
  killLegend()
end

function clearGraphs()
  for i=#graphExact,1, -1 do
    display.remove(graphExact[i])
    table.remove(graphExact,i)
  end

  for i=#graphEuler,1, -1 do
    display.remove(graphEuler[i])
    table.remove(graphEuler,i)
  end

  for i=#graphKutta,1, -1 do
    display.remove(graphKutta[i])
    table.remove(graphKutta,i)
  end

  for i=#graphEulerExact,1, -1 do
    display.remove(graphEulerExact[i])
    table.remove(graphEulerExact,i)
  end

  for i=#graphImproved,1, -1 do
    display.remove(graphImproved[i])
    table.remove(graphImproved,i)
  end

  for i=#graphImprovedExact,1, -1 do
    display.remove(graphImprovedExact[i])
    table.remove(graphImprovedExact,i)
  end

  for i=#graphKuttaExact,1, -1 do
    display.remove(graphKuttaExact[i])
    table.remove(graphKuttaExact,i)
  end

  for i=#graphEulerBetterExact,1, -1 do
    display.remove(graphEulerBetterExact[i])
    table.remove(graphEulerBetterExact,i)
  end

  for i=#graphImprovedBetterExact,1, -1 do
    display.remove(graphImprovedBetterExact[i])
    table.remove(graphImprovedBetterExact,i)
  end

  for i=#graphKuttaBetterExact,1, -1 do
    display.remove(graphKuttaBetterExact[i])
    table.remove(graphKuttaBetterExact,i)
  end

  for i=#approxEuler,1, -1 do
    display.remove(approxEuler[i])
    table.remove(approxEuler,i)
  end

  for i=#approxImproved,1, -1 do
    display.remove(approxImproved[i])
    table.remove(approxImproved,i)
  end

  for i=#approxKutta,1, -1 do
    display.remove(approxKutta[i])
    table.remove(approxKutta,i)
  end
end