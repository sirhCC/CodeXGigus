local core = _G.core
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")
local unit_helper = require("common/utility/unit_helper")

local fortitude = {}

function fortitude.buff_party(player)
    local allies = unit_helper:get_friendly_players()
    for _, ally in ipairs(allies or {}) do
        if not spell_helper:unit_has_buff_by_id(ally, config.SPELLS.FORTITUDE.id) then
            if spell_helper:is_spell_castable(config.SPELLS.FORTITUDE.id, player, ally, false, false) and
               not spell_helper:is_spell_on_cooldown(config.SPELLS.FORTITUDE.id) then
                spell_queue:queue_spell_target(
                    config.SPELLS.FORTITUDE.id,
                    ally,
                    config.SPELLS.FORTITUDE.priority,
                    "Rebuffing Power Word: Fortitude"
                )
                return true
            end
        end
    end
    return false
end

return fortitude