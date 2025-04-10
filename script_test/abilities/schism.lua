
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")

local schism = {}

function schism.try_schism(player, target)
    if spell_helper:is_spell_castable(config.SPELLS.SCHISM.id, player, target, false, false) and
       not spell_helper:is_spell_on_cooldown(config.SPELLS.SCHISM.id) then
        spell_queue:queue_spell_target(
            config.SPELLS.SCHISM.id,
            target,
            config.SPELLS.SCHISM.priority,
            "Casting Schism"
        )
        return true
    end
    return false
end

return schism
