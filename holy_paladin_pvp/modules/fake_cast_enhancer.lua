-- === Fake Cast Enhancer Logic ===
-- Improve interrupt baiting by checking for enemy interrupt availability and range

local interrupt_ids = {
    [47528] = true,  -- Mind Freeze (DK)
    [183752] = true, -- DH Interrupt
    [2139] = true,   -- Counterspell (Mage)
    [96231] = true,  -- Rebuke (Paladin)
    [93985] = true,  -- Skull Bash (Druid)
    [1766] = true,   -- Kick (Rogue)
    [6552] = true,   -- Pummel (Warrior)
    [19647] = true,  -- Spell Lock (Warlock pet)
    [106839] = true  -- Solar Beam (Druid)
}

-- Check if any nearby enemy has interrupt ready
local function enemy_interrupt_ready()
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy and enemy:is_alive() and enemy:get_distance(player) < 20 then
            for _, buff in ipairs(enemy:get_buffs()) do
                if interrupt_ids[buff.spell_id] then
                    return true
                end
            end
            local cast_info = enemy:get_cast_info()
            if cast_info and interrupt_ids[cast_info.spell_id] then
                return true
            end
        end
    end
    return false
end

-- Enhanced Fake Cast Execution
for _, tag in ipairs({ "player", "party1", "party2" }) do
    local unit = core.unit_manager:get_unit(tag)
    if unit and unit:is_alive() and unit:get_health_percent() < 50 then
        local cast = player:get_cast_info()
        if not cast and util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, unit) then
            util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, unit)
            return
        elseif cast and cast.spell_id == constants.SPELLS.FLASH_OF_LIGHT then
            if cast.remaining_time > 0.4 and enemy_interrupt_ready() then
                core.rotation:stop_casting()
                return
            end
        end
    end
end