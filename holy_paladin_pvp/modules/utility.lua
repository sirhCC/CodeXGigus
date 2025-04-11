local M = {}
local constants = require("modules/constants")

function M.has_buff(unit, spell_id)
    for _, buff in ipairs(unit:get_buffs()) do
        if buff.spell_id == spell_id then return true end
    end
    return false
end

function M.can_cast(spell_id, target)
    return core.cast:can_cast(spell_id, target)
end

function M.cast_on_unit(spell_id, unit)
    core.cast:cast(spell_id, unit)
end

function M.cast_self(spell_id)
    core.cast:cast(spell_id, core.local_player)
end

function M.is_valid_target(unit)
    return unit and unit:is_alive() and unit:is_in_los() and unit:get_distance(core.local_player) <= 40
end

function M.is_holy_power_capping()
    return core.local_player:get_power(constants.POWER_HOLY_POWER) >= 5
end

function M.has_movement_debuff(unit)
    for _, debuff in ipairs(unit:get_debuffs()) do
        if debuff.dispel_type == "Root" or debuff.dispel_type == "Snare" then
            return true
        end
    end
    return false
end

function M.get_beacon_target()
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and M.has_buff(unit, constants.BUFFS.BEACON_OF_LIGHT) then
            return unit
        end
    end
    return nil
end

function M.get_current_beacon_targets()
    local light, faith = nil, nil
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() then
            for _, buff in ipairs(unit:get_buffs()) do
                if buff.spell_id == constants.BUFFS.BEACON_OF_LIGHT then light = unit end
                if buff.spell_id == constants.BUFFS.BEACON_OF_FAITH then faith = unit end
            end
        end
    end
    return light, faith
end

function M.get_enemy_specs()
    local specs = {}
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy and enemy:is_alive() then table.insert(specs, enemy:get_spec_id()) end
    end
    return specs
end

function M.get_focused_teammate()
    local pressure_target, max_threat_count = nil, 0
    for _, tag in ipairs({ "party1", "party2" }) do
        local ally = core.unit_manager:get_unit(tag)
        if ally and ally:is_alive() then
            local threat_count = 0
            for i = 1, 3 do
                local enemy = core.unit_manager:get_unit("arena" .. i)
                if enemy and enemy:get_target_guid() == ally:get_guid() then threat_count = threat_count + 1 end
            end
            if threat_count > max_threat_count then
                max_threat_count = threat_count
                pressure_target = ally
            end
        end
    end
    return pressure_target, max_threat_count
end

local tracked_cc_casts = {
    [118] = true, [20066] = true, [51514] = true, [8122] = true, [605] = true, [33786] = true
}

function M.is_incoming_cc_on_player()
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy then
            local cast = enemy:get_cast_info()
            if cast and tracked_cc_casts[cast.spell_id] and cast.target_guid == core.local_player:get_guid() then
                return true
            end
        end
    end
    return false
end

local interruptable_casts = {
    [2061] = true, [8936] = true, [740] = true, [5185] = true,
    [116670] = true, [124682] = true, [118] = true,
    [33786] = true, [20066] = true, [51514] = true, [8122] = true,
}

function M.should_interrupt_with_hoj(unit)
    if not unit or not unit:is_alive() then return false end
    local cast = unit:get_cast_info()
    if cast and interruptable_casts[cast.spell_id] and cast.remaining_time > 0.2 then
        return true
    end
    return false
end


local burst_buffs = {
    -- Paladin
    [31884] = true,   -- Avenging Wrath
    [231895] = true,  -- Crusade

    -- Mage
    [190319] = true,  -- Combustion
    [12472] = true,   -- Icy Veins
    [12042] = true,   -- Arcane Power

    -- Priest
    [391109] = true,  -- Dark Ascension
    [232698] = true,  -- Voidform
    [10060] = true,   -- Power Infusion
    [47536] = true,   -- Rapture

    -- Warrior
    [107574] = true,  -- Avatar
    [1719] = true,    -- Recklessness
    [262228] = true,  -- Deadly Calm

    -- Death Knight
    [51271] = true,   -- Pillar of Frost
    [47568] = true,   -- Empower Rune Weapon
    [207289] = true,  -- Unholy Frenzy

    -- Monk
    [137639] = true,  -- Storm, Earth, and Fire
    [152173] = true,  -- Serenity
    [123904] = true,  -- Xuen, the White Tiger

    -- Demon Hunter
    [198589] = true,  -- Blur
    [162264] = true,  -- Metamorphosis

    -- Warlock
    [104773] = true,  -- Unending Resolve
    [113860] = true,  -- Dark Soul: Misery
    [113858] = true,  -- Dark Soul: Instability

    -- Rogue
    [13750] = true,   -- Adrenaline Rush
    [13877] = true,   -- Blade Flurry
    [121471] = true,  -- Shadow Blades
    [360194] = true,  -- Deathmark

    -- Hunter
    [288613] = true,  -- Trueshot
    [266779] = true,  -- Coordinated Assault
    [194407] = true,  -- Spitting Cobra

    -- Druid
    [102543] = true,  -- Incarnation: King of the Jungle
    [102560] = true,  -- Incarnation: Chosen of Elune
    [33891] = true,   -- Incarnation: Tree of Life
    [194223] = true,  -- Celestial Alignment
}

function M.is_enemy_bursting()
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy and enemy:is_alive() then
            for _, buff in ipairs(enemy:get_buffs()) do
                if burst_buffs[buff.spell_id] then
                    return true
                end
            end
        end
    end
    return false
end


return M
