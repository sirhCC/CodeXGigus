-- === Enemy Cast Stopper with HoJ ===
-- Interrupt critical casts like Polymorph, Cyclone, Fear using Hammer of Justice

local high_danger_casts = {
    [118] = true,     -- Polymorph
    [33786] = true,   -- Cyclone
    [5782] = true,    -- Fear
    [605] = true,     -- Mind Control
    [20066] = true,   -- Repentance
    [51514] = true,   -- Hex
    [82691] = true    -- Ring of Frost
}

for i = 1, 3 do
    local enemy = core.unit_manager:get_unit("arena" .. i)
    if enemy and enemy:is_alive()
        and enemy:get_distance(player) <= 10
        and util.can_cast(constants.SPELLS.HAMMER_OF_JUSTICE, enemy)
        and not dr.is_on_dr(enemy, "stun") then

        local cast = enemy:get_cast_info()
        if cast and cast.remaining_time > 0.2 and high_danger_casts[cast.spell_id] then
            util.cast_on_unit(constants.SPELLS.HAMMER_OF_JUSTICE, enemy)
            return
        end
    end
end