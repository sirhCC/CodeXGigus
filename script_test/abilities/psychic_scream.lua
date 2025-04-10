local core = _G.core
local priest_core = require("core")
local config = require("config")
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")

local scream = {}

function scream.try_psychic_scream(player)
    local menu = priest_core.menu.elements
    if not menu.use_psychic_scream or not menu.use_psychic_scream:get_state() then return false end

    local target = player:get_target()
    if not target or not target:is_enemy() then return false end
    local dist = priest_core.safe_get(target, "get_distance", 100)
    if dist > 8 then return false end -- 8 yd range

    if spell_helper:is_spell_on_cooldown(config.SPELLS.PSYCHIC_SCREAM.id) then return false end
    if not spell_helper:is_spell_castable(config.SPELLS.PSYCHIC_SCREAM.id, player, target, false, false) then return false end

    spell_queue:queue_spell(config.SPELLS.PSYCHIC_SCREAM.id, config.SPELLS.PSYCHIC_SCREAM.priority, "Using Psychic Scream on nearby enemy")
    return true
end

return scream