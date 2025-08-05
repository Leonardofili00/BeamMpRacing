--examplePlugin (SERVER)

local commandPrefix = "/" --prefix used to identify commands entered through chat

local debugOutput = true --set to false to hide console printed information

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

function onInit() --runs when plugin is loaded

	--Provided by BeamMP
	MP.RegisterEvent("onChatMessage", "onChatMessage")
	MP.RegisterEvent("onPlayerJoining", "onPlayerJoining")

	--Custom
	MP.RegisterEvent("test", "test")

	print("examplePlugin loaded")

end

function onPlayerJoining(player_id)
    print("Setting up player")
	table.insert(old_inside, false)
end

--A chat message was sent
--The sender's ID, the sender's name, and the chat message
function onChatMessage(player_id, player_name, message)
	if debugOutput then
		print("onChatMessage: player_id: " .. player_id .. " | player_name: " .. player_name .. " | Message: " .. message)
	end
	if message:sub(1,1) == commandPrefix then --if the character at index 1 of the string is the command prefix then
		command = string.sub(message,2) --the command is everything in the chat message from string index 2 to the end of the string
		onCommand(player_id, command) --call the onCommand() function passing in the player's ID and the command string
		return 1 --prevent the command from showing up in the chat
	else --otherwise do nothing
	end
end

------------------------------BEGIN CUSTOM FUNCTIONS------------------------------

function test(player_id, data)
	MP.SendChatMessage(-1, MP.GetPlayerName(player_id) .. " " .. data)
end

--This is called when a command is entered in chat
--The player's ID, and the data containing the command and the arguments
function onCommand(player_id, data)
	local data = split(data)
	local command = data[1] --get the command from the data
	local args = {} --initialize an arguments table
	if data[2] then --if there is at least one argument
		local argIndex = 1
		for dataIndex = 2, #data do
			args[argIndex] = data[dataIndex]
			argIndex = argIndex + 1
		end
	end
	if debugOutput then
		print("onCommand: player_id: " .. player_id .. " | command: " .. command)
		print("args:")
		print(args)
	end
	ready = true
end

--function for splitting strings by a separator into a table
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

function CountSeconds()
	if ready == true then
		for _, marker in ipairs(markersData) do
			for player_id = 0, MP.GetPlayerCount() - 1 do
				local raw_data, err = MP.GetPositionRaw(player_id, 0)

				if err == "" then
					local x, y, z = table.unpack(raw_data["pos"])
					local playerPos = { ["x"] = x, ["y"] = y, ["z"] = z }

					if old_inside[player_id + 1] == false and IsEntityInsideArea(playerPos, marker.pos, 2) == true then
						MP.TriggerClientEvent(player_id, "test", "Sei dentro l'area")
						print("Player è dentro l'area")
						old_inside[player_id + 1] = true
					end

					if old_inside[player_id + 1] == true and IsEntityInsideArea(playerPos, marker.pos, 2) == false then
						MP.TriggerClientEvent(player_id, "test", "Sei fuori l'area")
						print("Player è fuori l'area")
						old_inside[player_id + 1] = false
					end
				end
			end
		end
	end
    seconds = seconds + 1
end

-- create a custom event called 'EverySecond'
-- and register the handler function 'CountSeconds' to it
MP.RegisterEvent("EverySecond", "CountSeconds")

-- create a timer for this event, which will fire every 1000ms (1s)
MP.CreateEventTimer("EverySecond", 25)