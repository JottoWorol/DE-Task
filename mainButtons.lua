
function buttonAnim(butto)
  function restore()
    butto.width = buttonsWidth
    butto.height = buttonsHeight
  end
  butto.width = butto.width*0.9
  butto.height = butto.height*0.9
  timer.performWithDelay( 400, restore)
end
mUI = {}
options = require("options")
parser = require("expressionParser")
plotter = require("graphPlotter")

buttonsWidth = W/8
buttonsHeight = (H-graphHeight)-10

function paintButtonsWhite()
  buttonExact:setFillColor( 1,1,1 )
  buttonEuler:setFillColor( 1,1,1 )
  buttonImpro:setFillColor( 1,1,1 )
  buttonKutta:setFillColor( 1,1,1 )
  buttonLocal:setFillColor( 1,1,1 )
  buttonTotal:setFillColor( 1,1,1 )
end

function activeColor(button)
  paintButtonsWhite()
  button:setFillColor(0.5,0.5,0.5)
  print("yeah")
end

function onClickOptions(event)
  if(event.isPrimaryButtonDown)then
      paintButtonsWhite()
    buttonAnim(event.target)
    killEuler()
    killExact()
    killEulerIm()
    killKutta()
    killLocal()
    killTotal()
    killGrid()
    showOptions()
  end
end

function onClickExact(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killEuler()
    killEulerIm()
    killKutta()
    killLocal()
    killTotal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("ordinary")
    showExact()
  end
end

function onClickEuler(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killExact()
    killEulerIm()
    killKutta()
    killLocal()
    killTotal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("ordinary")
    showEuler()
  end
end

function onClickImproved(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killExact()
    killEuler()
    killKutta()
    killLocal()
    killTotal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("ordinary")
    showEulerIm()
  end
end

function onClickKutta(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killEuler()
    killExact()
    killEulerIm()
    killLocal()
    killTotal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("ordinary")
    showKutta()
  end
end

function onClickLocal(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killEuler()
    killExact()
    killEulerIm()
    killKutta()
    killTotal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("local")
    showLocal()
  end
end

function onClickTotal(event)
  if(event.isPrimaryButtonDown)then
    buttonAnim(event.target)
    activeColor(event.target)
    killOptions()
    killEuler()
    killExact()
    killEulerIm()
    killKutta()
    killLocal()
    if(not isKilled)then
      killGrid()
    end
    drawGrid("total")
    showTotal()
  end
end

function createButton(text,x,y)
  local button = display.newRect(x,y, buttonsWidth, buttonsHeight)
  button.strokeWidth = 2
  button:setStrokeColor(0,0,0)
  local optionsText = display.newText({text=text,x=x, y=y, font = native.systemFont, fontSize = 20})
  optionsText:setFillColor( 0,0,0 )
  if(text=="COMPUTE" or text=="set default")then
    table.insert( optionsUI, button)
    table.insert( optionsUI, optionsText)
  elseif(text~="Options")then
    table.insert( mUI, button)
    table.insert( mUI, optionsText)
  end
  return button
end

buttonOptions = createButton("Options",buttonsWidth/2+10,(H-graphHeight)*0.5)
buttonOptions:addEventListener( "mouse", onClickOptions)

function showMainButtons()
  buttonExact = createButton("Exact",buttonsWidth*1.5+20,(H-graphHeight)*0.5)
  buttonExact:addEventListener( "mouse", onClickExact)

  buttonEuler = createButton("Euler",buttonsWidth*2.5+30,(H-graphHeight)*0.5)
  buttonEuler:addEventListener( "mouse", onClickEuler)

  buttonImpro = createButton("Improved Euler",buttonsWidth*3.5+40,(H-graphHeight)*0.5)
  buttonImpro:addEventListener( "mouse", onClickImproved)

  buttonKutta = createButton("Runge–Kutta",buttonsWidth*4.5+50,(H-graphHeight)*0.5)
  buttonKutta:addEventListener( "mouse", onClickKutta)

  buttonLocal = createButton("Local Error",buttonsWidth*5.5+70,(H-graphHeight)*0.5)
  buttonLocal:addEventListener( "mouse", onClickLocal)

  buttonTotal = createButton("Total Error",buttonsWidth*6.5+80,(H-graphHeight)*0.5)
  buttonTotal:addEventListener( "mouse", onClickTotal)
end

function killMainButtons()
  for i, UI in pairs(mUI) do
    display.remove( UI )
    table.remove( mUI,i )
  end
end