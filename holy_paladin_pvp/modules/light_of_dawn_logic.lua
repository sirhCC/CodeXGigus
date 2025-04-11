-- === Light of Dawn AoE Awareness ===
-- Cast Light of Dawn only when 2+ nearby allies are below 80% HP

local injured_allies = 0
for _, tag in ipairs({ "player", "party1", "party2" }) do
    local unit = core.unit_manager:get_unit(tag)
    if unit and unit:is_alive() and unit:get_health_percent() < 80 and unit:get_distance(player) <= 15 then
        injured_allies = injured_allies + 1
    end
end

if injured_allies >= 2 and util.can_cast(constants.SPELLS.LIGHT_OF_DAWN) then
    util.cast_self(constants.SPELLS.LIGHT_OF_DAWN)
    return
end