--examplePlugin (SERVER)

local commandPrefix = "/"

local debugOutput = true

local ready = false

markersData = {
    {
        ["name"] = "zero-zero",
        ["pos"] = {
            ["x"] = 0,
            ["y"] = 0,
            ["z"] = 0
        }
    }
}


local old_inside = {}

function onInit()
	MP.RegisterEvent("onChatMessage", "onChatMessage")
	MP.RegisterEvent("onPlayerJoining", "onPlayerJoining")
	MP.RegisterEvent("callBack", "callBack")

	print("examplePlugin loaded")
end

function onPlayerJoining(player_id)
    print("Setting up player")
	table.insert(old_inside, false)
end

function onChatMessage(player_id, player_name, message)
	if message:sub(1,1) == commandPrefix then
		command = string.sub(message,2)
		onCommand(player_id, command)
		return 1
	end
end

function callBack(player_id, data)
	print("CallBack: " .. player_id .. " | " .. data)
end

function onCommand(player_id, data)
	local data = split(data)
	local command = data[1]
	local args = {}
	if data[2] then
		local argIndex = 1
		for dataIndex = 2, #data do
			args[argIndex] = data[dataIndex]
			argIndex = argIndex + 1
		end
	end

	if command == "start" then
		MP.SendChatMessage(-1, "Ok, sys started")
		ready = true
	end
end

function split(str, sep)
	local sep = sep or " "
	local t = {}
	for str in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local seconds = 0

local function IsEntityInsideArea(pos1, pos2, radius)
 
    local x1, y1, z1 = pos1.x, pos1.y, pos1.z
    local x2, y2, z2 = pos2.x, pos2.y, pos2.z

    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

    return distance <= radius
end

function CountSeconds()
	if ready == true then
		for _, marker in ipairs(markersData) do
			for player_id = 0, MP.GetPlayerCount() - 1 do
				local raw_data, err = MP.GetPositionRaw(player_id, 0)

				if err == "" then
					local x, y, z = table.unpack(raw_data["pos"])
					local playerPos = { ["x"] = x, ["y"] = y, ["z"] = z }

					if old_inside[player_id + 1] == false and IsEntityInsideArea(playerPos, marker.pos, 2) == true then
						MP.TriggerClientEvent(player_id, "toggleTimer", "")
						old_inside[player_id + 1] = true
					end

					if old_inside[player_id + 1] == true and IsEntityInsideArea(playerPos, marker.pos, 2) == false then
						old_inside[player_id + 1] = false
					end
				end
			end
		end
	end
    seconds = seconds + 1
end

MP.RegisterEvent("EverySecond", "CountSeconds")
MP.CreateEventTimer("EverySecond", 25)