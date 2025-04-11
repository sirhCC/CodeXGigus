-- "Oh Shit Moment" Auto-Response (unit drops under 60% with 20%+ spike loss)
M.snapshots = M.snapshots or {
    party1 = { last = 100, timer = 0 },
    party2 = { last = 100, timer = 0 },
    player = { last = 100, timer = 0 }
}

local time = os.clock()
local panic_triggered = 0
local panic_threshold = 60 -- HP % threshold
local drop_trigger = 20    -- HP drop %

for _, tag in ipairs({ "player", "party1", "party2" }) do
    local unit = core.unit_manager:get_unit(tag)
    if unit and unit:is_alive() then
        local hp_now = unit:get_health_percent()
        local snap = M.snapshots[tag]
        if snap and (time - snap.timer) > 1.5 then
            snap.last = hp_now
            snap.timer = time
        end

        local delta = snap.last - hp_now
        if hp_now < panic_threshold and delta >= drop_trigger then
            panic_triggered = panic_triggered + 1
        end
    end
end

if panic_triggered >= 1 then
    if util.can_cast(constants.SPELLS.AURA_MASTERY) and not util.has_buff(player, constants.BUFFS.AURA_MASTERY) then
        util.cast_self(constants.SPELLS.AURA_MASTERY)
        return
    end

    if util.can_cast(constants.SPELLS.AVENGING_WRATH) and not player:has_buff(constants.BUFFS.AVENGING_WRATH) then
        util.cast_self(constants.SPELLS.AVENGING_WRATH)
        return
    end

    if util.can_cast(constants.SPELLS.LAY_ON_HANDS, player) and player:get_health_percent() < 20 then
        util.cast_self(constants.SPELLS.LAY_ON_HANDS)
        return
    end
end