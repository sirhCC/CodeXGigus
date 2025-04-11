-- === Enhanced Holy Power Economy Logic ===

-- Triage Mode Toggle
local triage_mode = menu.elements.enable_triage_mode and menu.elements.enable_triage_mode:get_state()
local holy_power = player:get_power(constants.POWER_HOLY_POWER)

-- Priority: Avoid WOG overuse, Shock if low HP, LoD only at 5HP + AoE
for _, tag in ipairs({ "player", "party1", "party2" }) do
    local unit = core.unit_manager:get_unit(tag)
    if unit and unit:is_alive() then
        local hp = unit:get_health_percent()

        -- Avoid WOG on high HP units
        if holy_power >= 3 and hp > 90 then break end

        -- Triage Mode: Use Flash immediately under 50%
        if triage_mode and hp < 50 then
            if util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, unit) then
                util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, unit)
                return
            end
        end

        -- Rebuild Holy Power if low
        if holy_power < 3 and util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then
            util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit)
            return
        end

        -- WOG Chaining if Wings is active
        if player:has_buff(constants.BUFFS.AVENGING_WRATH) then
            if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return
            elseif util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then
                util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit)
                return
            elseif holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return
            end
        end
    end
end

-- LoD: Only cast at 5 Holy Power and 2+ allies in range and injured
local injured_allies = 0
for _, tag in ipairs({ "player", "party1", "party2" }) do
    local unit = core.unit_manager:get_unit(tag)
    if unit and unit:is_alive() and unit:get_health_percent() < 80 and unit:get_distance(player) <= 15 then
        injured_allies = injured_allies + 1
    end
end

if holy_power >= 5 and injured_allies >= 2 and util.can_cast(constants.SPELLS.LIGHT_OF_DAWN) then
    util.cast_self(constants.SPELLS.LIGHT_OF_DAWN)
    return
end