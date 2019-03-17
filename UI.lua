local interface = {}

function interface.printTable(aMultiTable)
    os.execute("cls")
    print("                -- MATCH 3 GAME --")
    print("")
    print("Tick: ", timer)
    print("")
    print("   0 1 2 3 4 5 6 7 8 9")
    print("   -------------------")
    for y = 1,10 do
        row = y-1 .. "| " .. table.concat(aMultiTable[y], " ")
        print(row)
    end
end

return interface