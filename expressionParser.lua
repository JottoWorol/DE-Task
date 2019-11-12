local function findLeftBound(str, start)
  local braceCount = 0
  for i=start, 1, -1 do
    if(str[i]=='(')then
      braceCount=braceCount+1
    elseif(str[i]==')')then
      braceCount=braceCount-1
    end
    if(braceCount==0)then
      --if(str[i]=='(' or str[i]==')')then
        --return i
      if(str[i]=='+' or str[i]=='-' or str[i]=='*' or str[i]=='/')then
        return(i+1)
      end
    end
  end
  return(1) 
end

local function findRightBound(str, start)
  local braceCount = 0
  for i=start, #str do
    if(str[i]=='(')then
      braceCount=braceCount+1
    elseif(str[i]==')')then
      braceCount=braceCount-1
    end
    if(braceCount==0 and i~=start)then
      --if(str[i]=='(' or str[i]==')')then
        --return i
      if(str[i]=='+' or str[i]=='-' or str[i]=='*' or str[i]=='/')then
        return(i-1)
      end
    end
  end 
  --print("gonna return ",str)
  return(#str)
end

local function unbrace(str)
  if(str[1]=='(')then
    return substring(str,2,#str-1)
  else
    return str
  end
end

function eval(str)
  --print(str)
  if(#str==0)then
    return 0
  end
  local leftBound
  local rightBound
  local braceCount = 0

  if(str[1]=='-')then
    return -round(eval(substring(str,2,#str)))
  end

  local function leftString(i)
    return substring(str,1,leftBound-1)
  end

  local function rightString(i)
    return substring(str,rightBound+1,#str)
  end

  --######### Power ############
  for i=1, #str do
    if(str[i]=='(')then
      braceCount=braceCount+1
    elseif(str[i]==')')then
      braceCount=braceCount-1
    end
    if(braceCount==0 and str[i]=='^')then
      leftBound = findLeftBound(str, i-1)
      rightBound = findRightBound(str, i+1)
      return round(eval(leftString(i)..round((round(eval(substring(str, leftBound, i-1)))^round(eval(substring(str, i+1, rightBound)))))..rightString(i)))
    end
  end
  braceCount = 0
  --######### MULT and DIV ############
  for i=1, #str do
    if(str[i]=='(')then
      braceCount=braceCount+1
    elseif(str[i]==')')then
      braceCount=braceCount-1
    end
    if(braceCount==0 and str[i]=='*')then
      leftBound = findLeftBound(str, i-1)
      rightBound = findRightBound(str, i+1)
    
      return round(eval(leftString(i)..round(round(eval(substring(str, leftBound, i-1)))*round(eval(substring(str, i+1, rightBound))))..rightString(i)))
    elseif(braceCount==0 and str[i]=='/')then
      leftBound = findLeftBound(str, i-1)
      rightBound = findRightBound(str, i+1)
      return round(eval(leftString(i)..round(round(eval(substring(str, leftBound, i-1)))/round(eval(substring(str, i+1, rightBound))))..rightString(i)))
    end
  end
  braceCount = 0
  --######### SUM and SUB ############
  for i=1, #str do
    if(str[i]=='(')then
      braceCount=braceCount+1
    elseif(str[i]==')')then
      braceCount=braceCount-1
    end
    if(braceCount==0 and str[i]=='+')then
      leftBound = findLeftBound(str, i-1)
      rightBound = findRightBound(str, i+1)
      return round(eval(leftString(i)..round(((round(eval(substring(str, leftBound, i-1)))+round(eval(substring(str, i+1, rightBound))))))..rightString(i)))
    elseif(braceCount==0 and str[i]=='-')then
      leftBound = findLeftBound(str, i-1)
      rightBound = findRightBound(str, i+1)
      if(str[1]=="-" and leftBound==1 and #leftString(i)==0)then
        return -round(eval(substring(str, i+1, rightBound)))
      end
      return round(eval(leftString(i)..round(((round(eval(substring(str, leftBound, i-1)))-round(eval(substring(str, i+1, rightBound))))))..rightString(i)))
    end
  end

  if(str[1]=='(')then
    return round(eval(substring(str,2,#str-1)))
  end

  --######### Math functions ############
  if(str=="e")then
    return round(math.exp(1))
  elseif(substring(str,1,4)=="sin(")then
    return round(math.sin(round(eval(substring(str,5,#str-1)))))
  elseif(substring(str,1,4)=="cos(")then
    return round(math.cos(round(eval(substring(str,5,#str-1)))))
  elseif(substring(str,1,4)=="tan(")then
    return round(math.tan(round(eval(substring(str,5,#str-1)))))
  elseif(substring(str,1,4)=="exp(")then
    return round(math.exp(round(eval(substring(str,5,#str-1)))))
  elseif(substring(str,1,4)=="ctg(")then
    return round(1/math.tan(round(eval(substring(str,5,#str-1)))))
  elseif(substring(str,1,3)=="ln(")then
    return round(math.log(round(eval(substring(str,4,#str-1)))))
  elseif(substring(str,1,2)=="pi")then
    return round(math.pi)  
  end

  return round(tonumber(str))
end