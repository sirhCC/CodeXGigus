-- === Support Kill Go Mode (Flexible DR Cast) ===
local enemy = core.unit_manager:get_unit("arena1")
local target_is_low = enemy and enemy:is_alive() and enemy:get_health_percent() < 40

if target_is_low then
    -- Try to CC healer if not on full DR or kill chance is high
    for i = 1, 3 do
        local potential = core.unit_manager:get_unit("arena" .. i)
        if potential and potential:is_alive()
            and potential:get_guid() ~= enemy:get_guid()
            and potential:is_in_los() then
            local incap_dr = dr.get_dr_remaining(potential, "incap")
            -- Allow Repent on 3rd DR if kill chance is high (target < 25%)
            if (incap_dr <= 10 or enemy:get_health_percent() < 25)
                and util.can_cast(constants.SPELLS.REPENTANCE, potential) then
                util.cast_on_unit(constants.SPELLS.REPENTANCE, potential)
                return
            end
        end
    end

    -- Holy Shock the kill target for pressure + Beacon value
    if util.can_cast(constants.SPELLS.HOLY_SHOCK, enemy) then
        util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, enemy)
        return
    end

    -- WOG the teammate if they're beaconed (support through Beacon)
    local light, _ = util.get_current_beacon_targets()
    if light and util.can_cast(constants.SPELLS.WORD_OF_GLORY, light) then
        util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, light)
        return
    end
end