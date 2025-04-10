
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")

local renew = {}

function renew.try_renew(target)
    if not spell_helper:unit_has_buff_by_id(target, config.SPELLS.RENEW.id) and
       spell_helper:is_spell_castable(config.SPELLS.RENEW.id, target, target, false, false) and
       not spell_helper:is_spell_on_cooldown(config.SPELLS.RENEW.id) then
        spell_queue:queue_spell_target(
            config.SPELLS.RENEW.id,
            target,
            config.SPELLS.RENEW.priority,
            "Casting Renew"
        )
        return true
    end
    return false
end

return renew
