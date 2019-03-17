local aMultiTable = {}

function aMultiTable.firstInit()
    ch = math.random(65,70)
    for y = 1,10 do
        aMultiTable[y] = {}
        for x = 1,10 do
                    if (y == 1) then
                        aMultiTable[y][x] = string.char(ch)
                        while (aMultiTable[y][x] == aMultiTable[y][x-1]) do
                            ch = math.random(65,70)
                            aMultiTable[y][x] = string.char(ch)
                        end
                    end
                    if (y>1) then 
                        aMultiTable[y][x] = string.char(ch)
                            while ((aMultiTable[y][x] == aMultiTable[y-1][x]) 
                                or (aMultiTable[y][x] == aMultiTable[y][x-1])) do
                                ch = math.random(65,70)
                                aMultiTable[y][x] = string.char(ch)
                            end
                    end
        end
    end
end

function aMultiTable.readCommand()
    print("What and where to move?")
    answer = io.read()

    words = {}
    for w in answer:gmatch("%w+") do
        table.insert(words, w)
    end
    
    if (answer=='q' or answer=='Q') then
        return nil, nil, true 
   end

    aMultiTable.checkCommand()

    fromX = tonumber(words [2])
    fromY = tonumber(words [3])
    direction = words [4]
    to = moveDirection(fromX, fromY, direction)
   return from, to, false
end

local function isInvalid(words)
    return(#words ~=4 or words[1]~='m'
    or tonumber(words[2]) < 0 or tonumber(words[2]) > 9
    or tonumber(words[3]) < 0 or tonumber(words[3]) > 9
    or string.match("urld", words[4])==nil)
end

function aMultiTable.checkCommand()
    if isInvalid(words) then
        return nil, nil, false
    end
end

function aMultiTable.mix()
    for y = 1,10 do
        for x = 1,10 do
            minValue = 65
            maxValue = 70
            ch = math.random(minValue,maxValue)
            if (y > 2) then
                while (aMultiTable[y-1][x] == string.char(ch) and aMultiTable[y-2][x] == string.char(ch)) do
                    ch = math.random(minValue,maxValue)
                end
            end
            if (x>2) then
                while(aMultiTable[y][x-1] == string.char(ch) and aMultiTable[y][x-2] == string.char(ch)) do 
                    ch = math.random(minValue, maxValue)
                end
            end
            aMultiTable[y][x] = string.char(ch)
        end
    end
end

function moveDirection(fromX, fromY, direction)
    from = {x = fromX + 1, y = fromY + 1}
    to = {x = X, y = Y}
    
    if (direction == "r") then
    to.x, to.y = from.x+1, from.y
    else 
        if (direction == "l") then 
        to.x, to.y = from.x-1, from.y
        else 
            if (direction == "u") then
            to.x, to.y = from.x, from.y-1
            else 
                if (direction == "d") then
                to.x, to.y = from.x, from.y+1
                end
            end
        end
    end 
    return to
end

function aMultiTable.move(from, to)
    tick()
    temp = aMultiTable[from.y][from.x]
        aMultiTable[from.y][from.x] = aMultiTable[to.y][to.x]
        aMultiTable[to.y][to.x] = temp
end

local function checkVert(loc)
    X, Y = loc.x, loc.y
    matchedCrist = {}
    if Y - 1 > 1 and aMultiTable[Y][X] == aMultiTable[Y-1][X] then 
        matchedCrist[#matchedCrist+1] = {x = X, y = Y-1}
        if Y-2 >= 1 and aMultiTable[Y][X] == aMultiTable[Y-2][X] then
            matchedCrist[#matchedCrist+1] = {x = X, y = Y-2}
        end
    end
    if Y+1 < 10 and aMultiTable[Y][X] == aMultiTable[Y+1][X] then
        matchedCrist[#matchedCrist+1] = {x = X, y = Y+1}
        if Y+2 <= 10 and aMultiTable[Y][X] == aMultiTable[Y+2][X] then
            matchedCrist[#matchedCrist+1] = {x=X, y = Y+2}
        end
    end
    
    if #matchedCrist>1 then
        for key, val in pairs(matchedCrist) do
            table.insert(_G['matched'],val)
        end
        return true
    end
    return false
end

local function checkHor(loc)
    X, Y = loc.x, loc.y
    matchedCrist = {}
    if X - 1 > 1 and aMultiTable[Y][X] == aMultiTable[Y][X-1] then 
        matchedCrist[#matchedCrist+1] = {x = X-1, y = Y}
        if X-2>=1 and aMultiTable[Y][X] == aMultiTable[Y][X-2] then
            matchedCrist[#matchedCrist+1] = {x = X-2, y = Y}
        end
    end
    if X+1 < 10 and aMultiTable[Y][X] == aMultiTable[Y][X+1] then
        matchedCrist[#matchedCrist+1] = {x = X+1, y = Y}
        if X+2 <= 10 and aMultiTable[Y][X] == aMultiTable[Y][X+2] then
            matchedCrist[#matchedCrist+1] = {x = X+2, y = Y}
        end
    end
    
    if #matchedCrist>1 then
        for key, val in pairs(matchedCrist) do
            table.insert(_G['matched'],val)
        end
        return true
    end
    return false
end

function checkCristal(loc)
    count = #_G['matched']
    isMatchedVert = checkVert(loc)
    isMatchedHor = checkHor(loc)
    
    if (count < #_G['matched']) then
        table.insert(_G['matched'], loc)
    end
    return isMatchedHor or isMatchedVert
end

local function noMoves()
    for y = 1,10 do
        for x = 1,10 do
            element = aMultiTable[y][x]
            if element == aMultiTable[y+1][x] and aMultiTable[y+1][x] ~= nil then
                if y < 7 and element == aMultiTable[y+3][x] and aMultiTable[y+3][x]~= nil then return false end
                if y < 8 and x > 1 and element == aMultiTable[y+2][x-1] and aMultiTable[y+2][x-1] ~= nil then return false end
                if y < 8 and x < 10 and element == aMultiTable[y+2][x+1] and aMultiTable[y+2][x+1] ~= nil then return false end

                if y > 1 and element == aMultiTable[y-2][x] and aMultiTable[y-2][x] ~= nil then return false end
                if y > 0 and x > 1 and element == aMultiTable[y-1][x-1] and aMultiTable[y-1][x-1] ~= nil then return false end
                if y > 0 and x < 10 and element == aMultiTable[y-1][x+1] and aMultiTable[y-1][x+1] ~= nil then return false end
            end
            if element == aMultiTable[y][x+1] and aMultiTable[y][x+1] ~= nil then
                if x < 8 and element == aMultiTable[y][x+3] and aMultiTable[y][x+3] ~= nil then return false end
                if x < 9 and y > 0 and element == aMultiTable[y][x-1] and aMultiTable[y][x-1] ~= nil then return false end
                if x < 9 and y < 9 and element == aMultiTable[y][x+1] and aMultiTable[y][x+1] ~= nil then return false end

                if x > 2 and element == aMultiTable[y][x-2] and aMultiTable[y][x-2] ~= nil then return false end
                if x > 1 and y > 0 and element == aMultiTable[y-1][x-1] and aMultiTable[y-1][x-1] ~= nil then return false end
                if x > 1 and y < 9 and element == aMultiTable[y-1][x+1] and aMultiTable[y-1][x+1] ~= nil then return false end
            end
        end        
    end
    return true
end

function aMultiTable.noPossibleMoves()
    if noMoves() then
        aMultiTable.mix()
    end
end

local function clearLines()
    if #_G['matched'] < 1 then return false end

    for key, val in pairs(_G['matched']) do
        aMultiTable[val.y][val.x] = " "
    end
end

function aMultiTable.checkMatched(from, to)
    isMatchedFrom = checkCristal(from)
    isMatchedTo = checkCristal(to)

    clearLines()
    return isMatchedFrom or isMatchedTo
end

local function isPossibleMatches()
    iterFlag = false
    for i = 1,10 do
        for j = 1,10 do
            iterFlag = iterFlag or checkCristal({x = j, y = i})
        end
    end
    return iterFlag
end

function aMultiTable.checkPossibleMatches()
    flag = true
    while flag do
        iterFlag = isPossibleMatches()
        clearLines()
        dump()
        flag = flag and iterFlag
    end
end

return aMultiTable