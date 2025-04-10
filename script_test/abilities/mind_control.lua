local core = _G.core
local priest_core = require("core")
local config = require("config")
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")

local mc = {}

function mc.try_mind_control(player)
    local menu = priest_core.menu.elements
    if not menu.use_mind_control or not menu.use_mind_control:get_state() then return false end

    local target = player:get_target()
    if not target or not target:is_enemy() then return false end
    local dist = priest_core.safe_get(target, "get_distance", 100)
    if dist > 30 then return false end

    if spell_helper:is_spell_on_cooldown(config.SPELLS.MIND_CONTROL.id) then return false end
    if not spell_helper:is_spell_castable(config.SPELLS.MIND_CONTROL.id, player, target, false, false) then return false end

    spell_queue:queue_spell_target(config.SPELLS.MIND_CONTROL.id, target, config.SPELLS.MIND_CONTROL.priority, "Casting Mind Control")
    return true
end

return mc