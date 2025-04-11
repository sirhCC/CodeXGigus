-- === Advanced Freedom Intelligence with Toggle & Expanded Spell List ===
local enable_prediction = menu.elements.enable_freedom_prediction and menu.elements.enable_freedom_prediction:get_state()
if not enable_prediction then return end

-- Expanded root/snare spell list
local incoming_root_spells = {
    -- Mage
    [122] = true,     -- Frost Nova
    [33395] = true,   -- Freeze (Water Elemental)
    [157997] = true,  -- Ice Nova

    -- Monk
    [116706] = true,  -- Disable
    [123586] = true,  -- Flying Serpent Kick root

    -- Death Knight
    [196770] = true,  -- Remorseless Winter
    [45524] = true,   -- Chains of Ice

    -- Hunter
    [170855] = true,  -- Frost Trap
    [5116] = true,    -- Concussive Shot
    [190927] = true,  -- Harpoon

    -- Warrior
    [105771] = true,  -- Charge root
    [236077] = true,  -- Warbringer

    -- Paladin
    [197277] = true,  -- Judgment of Light snare

    -- Evoker
    [360806] = true,  -- Landslide (root)

    -- Druid
    [339] = true,     -- Entangling Roots
    [45334] = true,   -- Immobilized (Wild Charge)
}

-- Predict incoming CC
for i = 1, 3 do
    local enemy = core.unit_manager:get_unit("arena" .. i)
    if enemy then
        local cast = enemy:get_cast_info()
        if cast and incoming_root_spells[cast.spell_id] then
            if util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM, player)
                and not util.has_buff(player, constants.BUFFS.BLESSING_OF_FREEDOM) then
                util.cast_self(constants.SPELLS.BLESSING_OF_FREEDOM)
                return
            end
        end
    end
end

-- Free teammate if snared while chasing
for _, tag in ipairs({ "party1", "party2" }) do
    local teammate = core.unit_manager:get_unit(tag)
    if util.is_valid_target(teammate)
        and util.has_movement_debuff(teammate)
        and util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM, teammate)
        and not util.has_buff(teammate, constants.BUFFS.BLESSING_OF_FREEDOM) then
        util.cast_on_unit(constants.SPELLS.BLESSING_OF_FREEDOM, teammate)
        return
    end
end

-- Last resort: free self
if util.has_movement_debuff(player)
    and util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM)
    and not util.has_buff(player, constants.BUFFS.BLESSING_OF_FREEDOM) then
    util.cast_self(constants.SPELLS.BLESSING_OF_FREEDOM)
    return
end