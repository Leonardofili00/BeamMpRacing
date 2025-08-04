--examplePlugin (SERVER)

local commandPrefix = "/" --prefix used to identify commands entered through chat

local debugOutput = true --set to false to hide console printed information

markersData = {
    {
        ["name"] = "test",
        ["pos"] = {
            ["x"] = 0,
            ["y"] = 0,
            ["z"] = 0
        }
    }
}

local old_inside = {}

function onInit() --runs when plugin is loaded
    MP.RegisterEvent("onPlayerJoining", "onPlayerJoining")
    MP.RegisterEvent("onChatMessage", "onChatMessage")

	print("BeamGP loaded")
end

function onChatMessage(player_id, player_name, message)
    if message:sub(1,1) == commandPrefix then
        local command = string.sub(message,2)

        return 1
    else
        -- Non fai nulla qui
    end
end

function onPlayerJoining(player_id)
    print("Setting up player")
	table.insert(old_inside, false)
end

local function IsEntityInsideArea(pos1, pos2, radius)
    -- Estrai le coordinate
    local x1, y1, z1 = pos1.x, pos1.y, pos1.z
    local x2, y2, z2 = pos2.x, pos2.y, pos2.z

    -- Calcola la distanza euclidea
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

    -- Verifica se è dentro il raggio
    return distance <= radius
end

local seconds = 0

function CountSeconds()
    for _, marker in ipairs(markersData) do
        for playerId = 0, MP.GetPlayerCount() - 1 do
            local raw_data, err = MP.GetPositionRaw(playerId, 0)
            if err == "" and raw_data and raw_data.pos then
                local playerPos = {
                    x = raw_data.pos[1],
                    y = raw_data.pos[2],
                    z = raw_data.pos[3]
                }

                if old_inside[playerId + 1] == false and IsEntityInsideArea(playerPos, marker.pos, 2) == true then
                    print("Player è dentro l'area")
                    old_inside[playerId + 1] = true
                end

                if old_inside[playerId + 1] == true and IsEntityInsideArea(playerPos, marker.pos, 2) == false then
                    print("Player è fuori l'area")
                    old_inside[playerId + 1] = false
                end
            end
        end
    end
end

-- create a custom event called 'EverySecond'
-- and register the handler function 'CountSeconds' to it
MP.RegisterEvent("EverySecond", "CountSeconds")

-- create a timer for this event, which will fire every 1000ms (1s)
MP.CreateEventTimer("EverySecond", 25)