-- Holy Paladin PvP - Header

local plugin = {}

plugin["name"] = "Holy Paladin PvP"
plugin["version"] = "1.0.0"
plugin["author"] = "Bik Pisser"
plugin["description"] = "Advanced Holy Paladin PvP healing and utility logic."
plugin["load"] = true

-- Check local player
local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

-- Require enums for class check
---@type enums
local enums = require("common/enums")
local player_class = local_player:get_class()

-- Only load for Paladins (we'll check spec later)
if player_class ~= enums.class_id.PALADIN then
    plugin["load"] = false
    return plugin
end

return plugin
