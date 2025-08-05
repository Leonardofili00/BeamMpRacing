--examplePlugin (CLIENT)

local M = {}

local markers = {}
local markersData = {
    {
        ["name"] = "test",
        ["shape"] = "position_marker",
        ["pos"] = {
            ["x"] = 0,
            ["y"] = 0,
            ["z"] = 0
        },
        ["rot"] = {
            ["x"] = 0,
            ["y"] = 0,
            ["z"] = 0,
            ["w"] = 1
        },
        ["color"] = {
            ["r"] = 1,
            ["g"] = 0,
            ["b"] = 0,
            ["a"] = 0.5
        }
    }
}

--custom function called by command !jump (see server-side examplePlugin)
local function test(data)
	TriggerServerEvent("test", data)
end

local function onExtensionLoaded()
	AddEventHandler("test", test) --name of event to call (string), and the function that calling this event will process
	log('W', "examplePlugin", "examplePlugin LOADED")
end

local function onExtensionUnloaded()
	log('W', "examplePlugin", "examplePlugin UNLOADED")
end

local function createMarker(markerName, markerShape, markerPos, markerRot, markerColor)
    local marker =  createObject('TSStatic')
    marker:setField('shapeName', 0, "art/shapes/interface/" .. markerShape .. ".dae")
    marker:setPosition(vec3(markerPos.x,markerPos.y,markerPos.z))
    marker.scale = vec3(1,1,1)
    marker:setField('rotation', 0, markerRot.w .. " " .. markerRot.x .. " " .. markerRot.y .. " " .. markerRot.z)
    marker.useInstanceRenderData = true
    marker:setField('instanceColor', 0, markerColor.r .. " " .. markerColor.g .. " " .. markerColor.b .. " " .. markerColor.a)
    marker:setField('collisionType', 0, "Collision Mesh")
    marker:setField('decalType', 0, "Collision Mesh")
    marker:setField('playAmbient', 0, "1")
    marker:setField('allowPlayerStep', 0, "1")
    marker:setField('canSave', 0, "0")
    marker:setField('canSaveDynamicFields', 0, "1")
    marker:setField('renderNormals', 0, "0")
    marker:setField('meshCulling', 0, "0")
    marker:setField('originSort', 0, "0")
    marker:setField('forceDetail', 0, "-1")
    marker.canSave = false
    marker:registerObject(markerName)
    scenetree.MissionGroup:addObject(marker)
    return marker
end

local function onUpdate()
    if worldReadyState == 2 then
        if #markers == 0 then
            for _, data in pairs(markersData) do
                local mk = scenetree.findObject(data.name)
                if mk == nil then
                    log('I', "markerCreation", 'Creating marker ' .. tostring(data.name) )
                    mk = createMarker(data.name, data.shape, data.pos, data.rot, data.color)
                end
                table.insert(markers, mk)
            end
        end
    end
end

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded
M.onUpdate = onUpdate

M.onInit = function() setExtensionUnloadMode(M, "manual") end

return M
