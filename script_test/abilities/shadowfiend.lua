
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")

local shadowfiend = {}

function shadowfiend.try_shadowfiend(player, target)
    if spell_helper:is_spell_castable(config.SPELLS.SHADOWFIEND.id, player, target, false, false) and
       not spell_helper:is_spell_on_cooldown(config.SPELLS.SHADOWFIEND.id) then
        spell_queue:queue_spell_target(
            config.SPELLS.SHADOWFIEND.id,
            target,
            config.SPELLS.SHADOWFIEND.priority,
            "Casting Shadowfiend"
        )
        return true
    end
    return false
end

return shadowfiend
