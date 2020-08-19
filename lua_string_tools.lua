local RusEng = {['а']="a",['А']="A",['В']="B",['Е']="E",['е']="e",['К']="K",['к']="k",['М']="M",['Н']="H",['о']="o",['О']="O",['р']="p",['Р']="P",['с']="c",['С']="C",['Т']="T",['У']="y",['х']="x",['Х']="X"}

local function HideTextForRus(str,curpos,res1)
  curpos = curpos or 0
  if curpos == 0 then
    str = str:gsub("ё","е")
    str = str:gsub("Ё","Е")
  end
  local res = res1 or {}
  if #str >= curpos then
    for i = curpos,#str do
      local symbol = str:sub(i,i+1)
      local newstr
      if RusEng[symbol] then
        newstr = str:sub(0, (i - 2) < 0 and 0 or (i - 1))..RusEng[symbol]..str:sub(i+2)
        res[#res+1] = newstr
        HideTextForRus(newstr or str,curpos+1,res)
      end
    end
  end
  
  if curpos == 0 then
    local iter =0
    for k,v in pairs(res)do
        for k1,v1 in pairs(res)do
            if k ~= k1 and v == v1 then res[k1] = nil end
        end
    end
  end
  
  table.insert(res,1,str)
  return res
end

local function GetCountOfChangableSymbols(str)
  str = str:gsub("ё","е")
  str = str:gsub("Ё","Е")
  local count = 0
  for rus,eng in pairs(RusEng)do
    local found = str:find(rus,1,true)
    while found do
      str = str:sub(0,found-1)..str:sub(found+1)
      count = count + 1
      found = str:find(rus,1,true)
    end
  end
  return count
end


local function UpSymbols(str,curpos,res1)
  curpos = curpos or 0
  local res = res1 or {}
  if #str >= curpos then
    for i = curpos,#str do
      local newstr = str:sub(0, (i - 1) < 0 and 0 or (i - 1))..str:sub(i,i):upper()..str:sub(i+1)
      res[#res+1] = newstr
      UpSymbols(newstr,curpos+1,res)
    end
  end
  
  if curpos == 0 then
    local iter =0
    for k,v in pairs(res)do
        for k1,v1 in pairs(res)do
            if k ~= k1 and v == v1 then res[k1] = nil end
        end
    end
  end
  
  return res
end

local strToUp = "abcde"
local upSymbols = UpSymbols(strToUp)
local AllUpped = upSymbols[#strToUp+1]
print(AllUpped)

print("------------------")


local strToRus = "абвгде"
local rusSymbols = HideTextForRus(strToRus)
local AllEng = rusSymbols[GetCountOfChangableSymbols(strToRus)+1]
print(AllEng == "aбвгдe")
