local plugin = {}

plugin["name"] = "Holy Paladin PvP"
plugin["version"] = "1.0"
plugin["author"] = "Bik Pisser"
plugin["load"] = true

-- Only load if the player is in-game
local local_player = core.object_manager.get_local_player()
if not local_player then
    plugin["load"] = false
    return plugin
end

---@type enums
local enums = require("common/enums")
local player_class = local_player:get_class()

-- Class ID 2 = Paladin
if player_class ~= enums.class_id.PALADIN then
    plugin["load"] = false
    return plugin
end

-- Specialization ID 1 = Holy (for Paladin)
local player_spec_id = core.spell_book.get_specialization_id()
if player_spec_id ~= 1 then
    plugin["load"] = false
    return plugin
end

return plugin