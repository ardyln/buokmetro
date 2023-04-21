version = "0.0.8"
function wrap()
    station = peripheral.find("train_station")
    target = peripheral.find("create_target")
    monitors = {peripheral.find("monitor")}
end 

function terminal()
    multiTerm = {}
    for funcName,_ in pairs(monitors[1]) do
        multiTerm[funcName] = function(...)
            for i=1,#monitors-1 do monitors[i][funcName](unpack(arg)) end
            return monitors[#monitors][funcName](unpack(arg))
        end
    end
    size = target.getSize()
    multiTerm.setTextScale(0.5)
    term.redirect(multiTerm)
    term.clear()
end

function updater()
    --term.setBackgroundColor(colors.pink)
    --term.setCursorPos(1,1)
    --term.setBackgroundColor(colors.red)
    --print("Metro Yazilim Guncellemesi" .. version)
    --rednet.open("front")
    --local id, message = rednet.receive("metro")
        if os.clock() > 3600 then 
        --else
            term.setCursorPos(1,1)
            print("Metro Yazilimi Guncelleniyor")
            shell.run("rm", "startup")
            shell.run("wget", "https://gist.githubusercontent.com/ardyln/e4dcaac12751f050aa281a6d06e14744/raw/startup?" .. os.clock() .. "=" .. os.time(), "startup")
            --f = fs.open("startup","w")
            --f.writeline(msg)
            --f.close()
            os.sleep(10)
            os.reboot()
        end

end

function door()
    rs.setBundledOutput("bottom", tonumber(string.match(station.getTrainName(), "%[(%d+)%]" )))
end

function loop()
    while true do
    term.redirect(multiTerm)
    term.clear()
    term.setBackgroundColor(colors.black)
        if station.getPresentTrain() == true then
            --rs.setBundledOutput("bottom", tonumber(string.match(station.getTrainName(), "%[(%d+)%]" )))
            if pcall(door) then
                door()
                term.setBackgroundColor(colors.green)
            else
                rs.setBundledOutput("bottom", 28150)
                term.setBackgroundColor(colors.red)
                term.setCursorPos(1,7)
                print("HATA: Kapi pozisyonu tespit edilemiyor. Tüm sürgülü kapilar açlacak")
            end
            
        else rs.setBundledOutput("bottom", 0)
        end
    target.setWidth(144)
    term.setCursorPos(1,1)
    print(station.getStationName() .. " - " .. os.time())
    term.setCursorPos(1,3)
    --print("1234567890123456789012345678901234567890")
    print(target.getLine(1))
    term.setCursorPos(1,8)
    print(target.getLine(2))
    updater()
    os.sleep(1)
    end
end

wrap()
terminal()
loop()
