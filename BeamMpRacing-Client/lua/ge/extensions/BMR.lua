--BeamMpRacing (CLIENT)

local M = {}

local function onExtensionLoaded()
	log('W', "BeamMpRacing", "BeamMpRacing LOADED")
end

local function onExtensionUnloaded()
	log('W', "BeamMpRacing", "BeamMpRacing UNLOADED")
end

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

M.onInit = function() setExtensionUnloadMode(M, "manual") end

return M
