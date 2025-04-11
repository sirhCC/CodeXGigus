-- === Emergency Priority Override System ===
-- If any ally is below critical threshold, fire best heal immediately — bypass all logic

local function emergency_heal()
    local holy_power = player:get_power(constants.POWER_HOLY_POWER)

    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and unit:get_health_percent() < 12 then
            -- Log emergency override
            core.log("[Paladin PvP] ⚠️ EMERGENCY OVERRIDE — Healing " .. tag)

            -- Priority order: LoH > WOG > Flash > Shock
            if util.can_cast(constants.SPELLS.LAY_ON_HANDS, unit) then
                util.cast_on_unit(constants.SPELLS.LAY_ON_HANDS, unit)
                return true
            end

            if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return true
            end

            if util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, unit) then
                util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, unit)
                return true
            end

            if util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then
                util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit)
                return true
            end
        end
    end

    return false
end

-- Call this early in run() inside rotation.lua:
-- if emergency_heal() then return end