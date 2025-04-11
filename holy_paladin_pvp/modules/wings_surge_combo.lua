-- === Wings Ending Healing Surge Combo ===
if util.wings_ending_soon(2.0) then
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and unit:get_health_percent() < 80 then
            local holy_power = player:get_power(constants.POWER_HOLY_POWER)

            if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return
            end

            if util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then
                util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit)
                return
            end

            if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return
            end
        end
    end
end