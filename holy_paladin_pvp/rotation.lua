local M = {}

local constants = require("modules/constants")
local util = require("modules/utility")
local dr = require("modules/dr_tracker")

function M.run()
    local player = core.local_player
    if not player or not player:is_alive() then return end

    -- === Emergency Priority Override ===
    local holy_power = player:get_power(constants.POWER_HOLY_POWER)
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and unit:get_health_percent() < 12 then
            if util.can_cast(constants.SPELLS.LAY_ON_HANDS, unit) then util.cast_on_unit(constants.SPELLS.LAY_ON_HANDS, unit) return end
            if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit) return end
            if util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, unit) then util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, unit) return end
            if util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit) return end
        end
    end

    -- === Oh Shit Panic Response ===
    M.snapshots = M.snapshots or { player = { last = 100, timer = 0 }, party1 = { last = 100, timer = 0 }, party2 = { last = 100, timer = 0 } }
    local time = os.clock()
    local panic_triggered = 0
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() then
            local hp_now = unit:get_health_percent()
            local snap = M.snapshots[tag]
            if snap and (time - snap.timer) > 1.5 then snap.last = hp_now snap.timer = time end
            if hp_now < 60 and (snap.last - hp_now) >= 20 then panic_triggered = panic_triggered + 1 end
        end
    end
    if panic_triggered >= 1 then
        if util.can_cast(constants.SPELLS.AURA_MASTERY) and not util.has_buff(player, constants.BUFFS.AURA_MASTERY) then util.cast_self(constants.SPELLS.AURA_MASTERY) return end
        if util.can_cast(constants.SPELLS.AVENGING_WRATH) and not player:has_buff(constants.BUFFS.AVENGING_WRATH) then util.cast_self(constants.SPELLS.AVENGING_WRATH) return end
        if util.can_cast(constants.SPELLS.LAY_ON_HANDS, player) and player:get_health_percent() < 20 then util.cast_self(constants.SPELLS.LAY_ON_HANDS) return end
    end

    -- === Target Role Awareness ===
    local healer_specs = { [105]=true, [270]=true, [65]=true, [256]=true, [257]=true, [264]=true }
    local enemy_healer, enemy_kill_target, max_threat_count = nil, nil, 0
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena"..i)
        if enemy and enemy:is_alive() then
            if healer_specs[enemy:get_spec_id()] then enemy_healer = enemy end
            local threat = 0
            for _, tag in ipairs({ "party1", "party2" }) do
                local ally = core.unit_manager:get_unit(tag)
                if ally and ally:is_alive() and enemy:get_target_guid() == ally:get_guid() then threat = threat + 1 end
            end
            if threat > max_threat_count then enemy_kill_target = enemy max_threat_count = threat end
        end
    end

    -- === Smart Repent on Healer ===
    if enemy_healer and util.can_cast(constants.SPELLS.REPENTANCE, enemy_healer) and not dr.is_on_dr(enemy_healer, "incap") and enemy_healer:is_in_los() then
        util.cast_on_unit(constants.SPELLS.REPENTANCE, enemy_healer)
        return
    end

    -- === HoJ Cast Stopper ===
    local stop_casts = { [118]=true, [33786]=true, [5782]=true, [605]=true, [20066]=true, [51514]=true, [82691]=true }
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena"..i)
        if enemy and enemy:is_alive() and enemy:get_distance(player) <= 10 and util.can_cast(constants.SPELLS.HAMMER_OF_JUSTICE, enemy) and not dr.is_on_dr(enemy, "stun") then
            local cast = enemy:get_cast_info()
            if cast and cast.remaining_time > 0.2 and stop_casts[cast.spell_id] then
                util.cast_on_unit(constants.SPELLS.HAMMER_OF_JUSTICE, enemy)
                return
            end
        end
    end

    -- === Repent Chain Combo ===
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena"..i)
        if enemy and enemy:is_alive() and util.can_cast(constants.SPELLS.REPENTANCE, enemy)
           and dr.get_dr_remaining(enemy, "stun") < 3 and dr.get_dr_remaining(enemy, "incap") == 0 and enemy:is_in_los() then
            util.cast_on_unit(constants.SPELLS.REPENTANCE, enemy)
            return
        end
    end

    -- === Smart Defensive on Kill Target ===
    if enemy_kill_target then
        for _, tag in ipairs({ "party1", "party2" }) do
            local teammate = core.unit_manager:get_unit(tag)
            if teammate and teammate:is_alive() and enemy_kill_target:get_target_guid() == teammate:get_guid() then
                local hp = teammate:get_health_percent()
                if hp < 85 and util.can_cast(constants.SPELLS.BLESSING_OF_SACRIFICE, teammate) and not util.has_buff(teammate, constants.BUFFS.BLESSING_OF_SACRIFICE)
                   and not util.has_buff(teammate, constants.BUFFS.FORBEARANCE) then util.cast_on_unit(constants.SPELLS.BLESSING_OF_SACRIFICE, teammate) return end
                if holy_power >= 3 and hp < 75 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, teammate) then util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, teammate) return end
                if util.has_movement_debuff(teammate) and util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM, teammate)
                   and not util.has_buff(teammate, constants.BUFFS.BLESSING_OF_FREEDOM) then util.cast_on_unit(constants.SPELLS.BLESSING_OF_FREEDOM, teammate) return end
            end
        end
    end

    -- === Light of Dawn Smart AoE ===
    local injured = 0
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local u = core.unit_manager:get_unit(tag)
        if u and u:is_alive() and u:get_health_percent() < 80 and u:get_distance(player) <= 15 then injured = injured + 1 end
    end
    if holy_power >= 5 and injured >= 2 and util.can_cast(constants.SPELLS.LIGHT_OF_DAWN) then util.cast_self(constants.SPELLS.LIGHT_OF_DAWN) return end

    -- === Wings Ending Surge ===
    if util.wings_ending_soon(2.0) then
        for _, tag in ipairs({ "player", "party1", "party2" }) do
            local unit = core.unit_manager:get_unit(tag)
            if unit and unit:is_alive() and unit:get_health_percent() < 80 then
                if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit) return end
                if util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit) return end
                if holy_power >= 3 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit) return end
            end
        end
    end
end

return M
