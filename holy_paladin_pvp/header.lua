-- header.lua

local plugin = {
    name = "Holy Paladin PvP",
    version = "1.0.0",
    author = "You",
    load = true
}

local enums = require("common/enums")
local local_player = core.object_manager.get_local_player()

if not local_player then
    plugin.load = false
    return plugin
end

local class_id = local_player:get_class()
local spec_id = core.spell_book.get_specialization_id()

-- Only load for Holy Paladin
if class_id ~= enums.class_id.PALADIN or spec_id ~= 65 then
    plugin.load = true
end

return plugin
