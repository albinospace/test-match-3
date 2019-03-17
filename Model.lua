local ui = require('UI')
local aMultiTable = require('Table')

_G['matched'] = {}
timer = 100
local ch = math.random(65,70) 

function init()
    aMultiTable.firstInit()
    ui.printTable(aMultiTable)
end

function tick()
    timer = timer - 1
        if (timer <= 0) then
        print("Ticks are out!")
        end
        return timer
end

function dump()
   local matched = _G['matched']
   table.sort(matched, function (a, b) return a.y < b.y end)

   for i = 1, #matched do
    X, Y = matched[i].x, matched[i].y
    while true do
            ui.printTable(aMultiTable)
        if Y == 1 then
            tick()
            ch = math.random(65,70)
            aMultiTable[Y][X] = string.char(ch)
            break
        else
            tick()
            tmp = aMultiTable[Y][X]
            aMultiTable[Y][X] = aMultiTable[Y-1][X]
            aMultiTable[Y-1][X] = tmp
            Y = Y-1
        end
    end
    ui.printTable(aMultiTable)
end
_G['matched'] = {}
end

init()

while true do 
    if timer <= 0 then break end

    from, to, exit = aMultiTable.readCommand()
    if exit then break end

   if to == nil then         --Если отсутствует to, то возможно не верное движение за границы матрицы
      if (from == nil) then   --Если отсутствует from и to, то не валидная строка с командой
         print("Invalid move command");          
       end 
       goto continue
    end

    aMultiTable.move(from, to)
    ui.printTable(aMultiTable)

    isMatched = aMultiTable.checkMatched(from, to)
    if isMatched then
        dump()
        aMultiTable.checkPossibleMatches()
        aMultiTable.noPossibleMoves()
    else
        aMultiTable.move(to, from)
        print("No match.")
    end
    ::continue::
    ui.printTable(aMultiTable)
end