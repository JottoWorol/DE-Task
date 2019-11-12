system.activate("mouse")
centerX = display.actualContentWidth/2
centerY = display.actualContentHeight/2
W = display.actualContentWidth
H = display.actualContentHeight

debug.getmetatable("").__index = function (s, i) return string.sub(s,i,i) end

function substring(str,from,to)
  return string.sub(str,from,to)
end

function intDiv(a,b) --функция для целочисленного деления, потмоу что в Lua 5.1 её нет
  local c = a/b
  c = c%1
  return (a/b - c)
end

function mod(a,b)
  return a/b-intDiv(a,b)
end

local decimal = 10
function round(val)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function round4(val)
  if (decimal) then
    return math.floor( (val * 10^4) + 0.5) / (10^4)
  else
    return math.floor(val+0.5)
  end
end

function round2(val)
  if (decimal) then
    return math.floor( (val * 10^2) + 0.5) / (10^2)
  else
    return math.floor(val+0.5)
  end
end

gridGroup = display.newGroup()
graphGroup = display.newGroup()



mainUI = require("mainButtons")

back = display.newRect(gridGroup,centerX,centerY,display.actualContentWidth,display.actualContentHeight)
back:setFillColor(0.85,0.996,0.996)

showOptions()

