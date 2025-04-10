
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")

local smite = {}

function smite.try_smite(player, target)
    if spell_helper:is_spell_castable(config.SPELLS.SMITE.id, player, target, false, false) and
       not spell_helper:is_spell_on_cooldown(config.SPELLS.SMITE.id) then
        spell_queue:queue_spell_target(
            config.SPELLS.SMITE.id,
            target,
            config.SPELLS.SMITE.priority,
            "Casting Smite"
        )
        return true
    end
    return false
end

return smite
