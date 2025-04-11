-- === Smart Sacrifice / WOG / Freedom based on Role Awareness ===

-- Use enemy_kill_target (identified from Target Role Awareness) for prioritized support
if enemy_kill_target and enemy_kill_target:is_alive() then
    for _, tag in ipairs({ "party1", "party2" }) do
        local teammate = core.unit_manager:get_unit(tag)
        if teammate and teammate:is_alive() and enemy_kill_target:get_target_guid() == teammate:get_guid() then
            local hp = teammate:get_health_percent()
            local holy_power = player:get_power(constants.POWER_HOLY_POWER)

            -- Prioritized Sacrifice
            if hp < 85 and util.can_cast(constants.SPELLS.BLESSING_OF_SACRIFICE, teammate)
                and not util.has_buff(teammate, constants.BUFFS.BLESSING_OF_SACRIFICE)
                and not util.has_buff(teammate, constants.BUFFS.FORBEARANCE) then
                util.cast_on_unit(constants.SPELLS.BLESSING_OF_SACRIFICE, teammate)
                return
            end

            -- Prioritized WOG
            if holy_power >= 3 and hp < 75 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, teammate) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, teammate)
                return
            end

            -- Prioritized Freedom
            if util.has_movement_debuff(teammate)
                and util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM, teammate)
                and not util.has_buff(teammate, constants.BUFFS.BLESSING_OF_FREEDOM) then
                util.cast_on_unit(constants.SPELLS.BLESSING_OF_FREEDOM, teammate)
                return
            end
        end
    end
end