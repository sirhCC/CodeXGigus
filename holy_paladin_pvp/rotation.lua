local M = {}
local constants = require("modules/constants")
local util = require("modules/utility")
local dr = require("modules/dr_tracker")
local ui = require("ui")

function M.run()
    local player = core.local_player
    if not player or not player:is_alive() then return end
    if not ui.menu_elements.enable_script_check or not ui.menu_elements.enable_script_check:get_state() then return end

    local holy_power = player:get_power(constants.POWER_HOLY_POWER)

    -- ==============================
    -- Beacon of Light & Faith Logic
    -- ==============================
    local light, faith = util.get_current_beacon_targets()
    for _, tag in ipairs({ "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() then
            if not light and util.can_cast(constants.SPELLS.BEACON_OF_LIGHT, unit) then
                util.cast_on_unit(constants.SPELLS.BEACON_OF_LIGHT, unit)
                return
            end
            if not faith and light and unit:get_guid() ~= light:get_guid()
                and util.can_cast(constants.SPELLS.BEACON_OF_FAITH, unit) then
                util.cast_on_unit(constants.SPELLS.BEACON_OF_FAITH, unit)
                return
            end
        end
    end

    -- ==============================
    -- Pre-Aura Mastery for Incoming CC
    -- ==============================
    if util.is_incoming_cc_on_player()
        and not util.has_buff(player, constants.BUFFS.AURA_MASTERY)
        and not util.has_buff(player, constants.BUFFS.DIVINE_SHIELD)
        and util.can_cast(constants.SPELLS.AURA_MASTERY) then
        util.cast_self(constants.SPELLS.AURA_MASTERY)
        return
    end

    -- ==============================
    -- Pre-Sacrifice Logic
    -- ==============================
    for _, tag in ipairs({ "party1", "party2" }) do
        local ally = core.unit_manager:get_unit(tag)
        if util.is_valid_target(ally) then
            local hp = ally:get_health_percent()
            if hp < 85 and not util.has_buff(ally, constants.BUFFS.BLESSING_OF_SACRIFICE)
                and not util.has_buff(ally, constants.BUFFS.FORBEARANCE)
                and util.can_cast(constants.SPELLS.BLESSING_OF_SACRIFICE, ally) then
                for i = 1, 3 do
                    local enemy = core.unit_manager:get_unit("arena" .. i)
                    if enemy and enemy:is_alive()
                        and enemy:get_distance(ally) < 10
                        and util.is_enemy_bursting and util.is_enemy_bursting() then
                        util.cast_on_unit(constants.SPELLS.BLESSING_OF_SACRIFICE, ally)
                        return
                    end
                end
            end
        end
    end

    -- ==============================
    -- Interrupt Stopper with HoJ
    -- ==============================
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy and enemy:is_alive()
            and util.should_interrupt_with_hoj(enemy)
            and enemy:get_distance(player) <= 10
            and not dr.is_on_dr(enemy, "stun")
            and util.can_cast(constants.SPELLS.HAMMER_OF_JUSTICE, enemy) then
            for j = 1, 3 do
                local teammate = core.unit_manager:get_unit("arena" .. j)
                if teammate and teammate:is_alive()
                    and teammate:get_guid() ~= enemy:get_guid()
                    and teammate:get_health_percent() < 40 then
                    util.cast_on_unit(constants.SPELLS.HAMMER_OF_JUSTICE, enemy)
                    return
                end
            end
        end
    end

    -- ==============================
    -- DR-aware HoJ → Repent Chain
    -- ==============================
    for i = 1, 3 do
        local enemy = core.unit_manager:get_unit("arena" .. i)
        if enemy and enemy:is_alive()
            and enemy:get_distance(player) <= 30
            and enemy:is_in_los()
            and util.can_cast(constants.SPELLS.REPENTANCE, enemy) then
            local stun_dr = dr.get_dr_remaining(enemy, "stun")
            local incap_dr = dr.get_dr_remaining(enemy, "incap")
            if stun_dr <= 1 and incap_dr == 0 then
                local spec = enemy:get_spec_id()
                if spec == constants.SPEC_IDS.RESTO_DRUID or spec == constants.SPEC_IDS.HOLY_PRIEST then
                    util.cast_on_unit(constants.SPELLS.REPENTANCE, enemy)
                    return
                end
            end
        end
    end

    -- ==============================
    -- Healing (Wings, Focus Target, Surge)
    -- ==============================
    if player:has_buff(constants.BUFFS.AVENGING_WRATH) then
        local wings_buff = player:get_buff(constants.BUFFS.AVENGING_WRATH)
        if wings_buff and wings_buff.remaining_time <= 2.5 and holy_power >= 3 then
            for _, tag in ipairs({ "player", "party1", "party2", "focus" }) do
                local unit = core.unit_manager:get_unit(tag)
                if util.is_valid_target(unit) and unit:get_health_percent() < 95 then
                    util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                    return
                end
            end
        end
        for _, tag in ipairs({ "player", "party1", "party2" }) do
            local unit = core.unit_manager:get_unit(tag)
            if util.is_valid_target(unit) then
                local hp = unit:get_health_percent()
                if hp < 95 and util.can_cast(constants.SPELLS.HOLY_SHOCK, unit) then
                    util.cast_on_unit(constants.SPELLS.HOLY_SHOCK, unit)
                    return
                end
                if holy_power >= 3 and hp < 90 and util.can_cast(constants.SPELLS.WORD_OF_GLORY, unit) then
                    util.cast_on_unit(constants.SPELLS.WORD_OF_GLORY, unit)
                    return
                end
                if holy_power >= 3 and hp < 85 and util.can_cast(constants.SPELLS.LIGHT_OF_DAWN) then
                    util.cast_self(constants.SPELLS.LIGHT_OF_DAWN)
                    return
                end
            end
        end
    end

    -- ==============================
    -- Fake Cast Logic
    -- ==============================
    local cast = player:get_cast_info()
    if not cast or cast.spell_id ~= constants.SPELLS.FLASH_OF_LIGHT then
        for _, tag in ipairs({ "player", "party1", "party2" }) do
            local unit = core.unit_manager:get_unit(tag)
            if util.is_valid_target(unit) and unit:get_health_percent() < 50 then
                if util.can_cast(constants.SPELLS.FLASH_OF_LIGHT, unit) then
                    util.cast_on_unit(constants.SPELLS.FLASH_OF_LIGHT, unit)
                    return
                end
            end
        end
    else
        if cast.remaining_time > 0.3 and util.should_fake_cast and util.should_fake_cast() then
            core.rotation:stop_casting()
            return
        end
    end

    -- ==============================
    -- Idle Filler (Judgment, Crusader Strike)
    -- ==============================
    local everyone_safe = true
    for _, tag in ipairs({ "player", "party1", "party2" }) do
        local unit = core.unit_manager:get_unit(tag)
        if unit and unit:is_alive() and unit:get_health_percent() < 85 then
            everyone_safe = false
            break
        end
    end

    if everyone_safe and holy_power < 5 and not player:has_buff(constants.BUFFS.AVENGING_WRATH) then
        local kill_target = core.unit_manager:get_unit("arena1")
        if kill_target and kill_target:is_alive() and kill_target:is_in_los() then
            if util.can_cast(constants.SPELLS.JUDGMENT, kill_target) then
                util.cast_on_unit(constants.SPELLS.JUDGMENT, kill_target)
                return
            end
            if util.can_cast(constants.SPELLS.CRUSADER_STRIKE, kill_target) and kill_target:get_distance(player) < 5 then
                util.cast_on_unit(constants.SPELLS.CRUSADER_STRIKE, kill_target)
                return
            end
        end
    end
end

return M