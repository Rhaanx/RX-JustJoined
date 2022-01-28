local color = Config.Colors
local font = Config.Font
local displaying = 1
firstspawn = 0

AddEventHandler("playerSpawned", function(spawn)
    if firstspawn == 0 then
        if Config.Use3dme == false then
            JustJoined()
        else
            ExecuteCommand('me ' .. Config.JoinedMessage)
            Wait(5000)
            ExecuteCommand('me ' .. Config.JoinedMessage)
            Wait(5000)
            ExecuteCommand('me ' .. Config.JoinedMessage)
        end
        firstspawn = 1
    end
end)

function JustJoined()
    local isDisplaying = true

    Citizen.CreateThread(function()
        Wait(15000)
        isDisplaying = false
    end)

    Citizen.CreateThread(function()
        displaying = displaying + 1
        while isDisplaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(source)), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 500 then
                local offset = 1 + (displaying * 0.15)
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset - 0.200, Config.JoinedMessage2)
            end
        end
        displaying = displaying - 1
    end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 255, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(Config.JoinedMessage2)
        EndTextCommandDisplayText(_x, _y)
    end
end
