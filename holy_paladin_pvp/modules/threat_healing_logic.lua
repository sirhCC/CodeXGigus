-- === Threat-Based Healing Priority ===
-- Prioritize healing the unit with highest enemy focus
local focus_target, threat_count = util.get_focused_teammate()
if focus_target and threat_count >= 2 then
    local hp = focus_target:get_health_percent()
    local holy_power = player:get_power(constants.POWER_HOLY_POWER)

    if hp < 95 and util.can_cast(constants.SPELLS.HOLY_SHOCK, focus_target) then
        util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, focus_target)
        return
    end

    if holy_power >= 3 and hp < 75 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, focus_target) then
        util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, focus_target)
        return
    end

    if hp < 50 and util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, focus_target) then
        util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, focus_target)
        return
    end
end