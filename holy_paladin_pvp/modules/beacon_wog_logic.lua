-- === Beacon-Aware WOG Logic ===
-- Prefer casting WOG on beaconed targets or on targets that will benefit via Beacon transfer
local holy_power = player:get_power(constants.POWER_HOLY_POWER)
if holy_power >= 3 then
    local beacon_light, beacon_faith = util.get_current_beacon_targets()

    -- Direct WOG on Beacon target if they're low
    for _, beacon in ipairs({ beacon_light, beacon_faith }) do
        if beacon and beacon:is_alive() and beacon:get_health_percent() < 80 then
            if util.can_cast(constants.SPELLS.WORD_OF_GLORY, beacon) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, beacon)
                return
            end
        end
    end

    -- If Beacon targets are healthy, WOG someone else to transfer healing through Beacon
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and unit:get_health_percent() < 60 then
            if util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                return
            end
        end
    end
end