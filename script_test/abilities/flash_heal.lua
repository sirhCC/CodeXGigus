
local spell_helper = require("common/utility/spell_helper")
local spell_queue = require("common/modules/spell_queue")
local config = require("config")

local flash_heal = {}

function flash_heal.try_flash_heal(target)
    if spell_helper:is_spell_castable(config.SPELLS.FLASH_HEAL.id, target, target, false, false) and
       not spell_helper:is_spell_on_cooldown(config.SPELLS.FLASH_HEAL.id) then
        spell_queue:queue_spell_target(
            config.SPELLS.FLASH_HEAL.id,
            target,
            config.SPELLS.FLASH_HEAL.priority,
            "Casting Flash Heal"
        )
        return true
    end
    return false
end

return flash_heal
