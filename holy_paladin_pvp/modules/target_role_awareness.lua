-- === Target Role Awareness Logic ===

-- Known healer specs for targeting logic
local healer_specs = {
    [105] = true,  -- Druid - Restoration
    [270] = true,  -- Monk - Mistweaver
    [65]  = true,  -- Paladin - Holy
    [256] = true,  -- Priest - Discipline
    [257] = true,  -- Priest - Holy
    [264] = true   -- Shaman - Restoration
}

-- Identify enemy healer and potential kill target
local enemy_healer = nil
local enemy_kill_target = nil
local max_threat_count = 0

for i = 1, 3 do
    local enemy = core.unit_manager:get_unit("arena" .. i)
    if enemy and enemy:is_alive() then
        local spec = enemy:get_spec_id()
        if healer_specs[spec] then
            enemy_healer = enemy
        end

        local threat_count = 0
        for _, tag in ipairs({ "party1", "party2" }) do
            local ally = core.unit_manager:get_unit(tag)
            if ally and ally:is_alive() and enemy:get_target_guid() == ally:get_guid() then
                threat_count = threat_count + 1
            end
        end

        if threat_count > max_threat_count then
            enemy_kill_target = enemy
            max_threat_count = threat_count
        end
    end
end

-- Logic usage example (can be used in rotation or CC targeting):
-- Use Repent on enemy healer if not already CC’d or DR’d
if enemy_healer and util.can_cast(constants.SPELLS.REPENTANCE, enemy_healer)
    and not dr.is_on_dr(enemy_healer, "incap")
    and enemy_healer:is_in_los() then
    util.cast_on_unit(constants.SPELLS.REPENTANCE, enemy_healer)
    return
end

-- Use stronger defensive if kill target pressure is rising (stackable usage later)
-- This part is usually paired with focused healing logic