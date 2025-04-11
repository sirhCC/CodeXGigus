-- === Repent Chain DR-Aware Combo ===
-- Chain Repent after HoJ if DR allows (not overlapping and not immune)

local function should_chain_repent(target)
    if not target or not target:is_alive() then return false end

    local stun_dr = dr.get_dr_remaining(target, "stun")
    local incap_dr = dr.get_dr_remaining(target, "incap")

    -- Only Repent if stun DR is low and Incap DR is not active
    return stun_dr < 3 and incap_dr == 0
end

for i = 1, 3 do
    local enemy = core.unit_manager:get_unit("arena" .. i)
    if enemy and enemy:is_alive()
        and util.can_cast(constants.SPELLS.REPENTANCE, enemy)
        and should_chain_repent(enemy)
        and enemy:is_in_los()
        and not enemy:is_casting() then
        util.cast_on_unit(constants.SPELLS.REPENTANCE, enemy)
        return
    end
end