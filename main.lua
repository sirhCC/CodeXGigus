
-- Future DR-aware interrupt/CC tracking can be implemented here
-- Example: track interrupt DR, avoid casting big heals into likely kicks if DR is low


-- Holy Paladin PvP Script with Full Rotation and Lightsmith Hero Talent Integration using PS API

-- Required PS API Function Mapping
local cast = core.input.cast_target_spell

-- Example Spell ID Mapping (fill with actual IDs)

-- UI settings (customizable in-game)
local ui_settings = {
    heal_threshold_hs = 0.5,
    heal_threshold_wog = 0.4,
    heal_threshold_loh = 0.3,
    enable_combo_logic = true,
    enable_cleanse = true,
    enable_freedom = true,
    enable_fakecast = true,

    enable_hoj_arena1 = true,
    enable_hoj_arena2 = true,
    enable_hoj_arena3 = true,
    enable_burst_mode = false,
    enable_defensive_mode = true,
    hp_pooling_threshold = 6000,

}

local SPELL_IDS = {
    HOLY_SHOCK = 20473,
    WORD_OF_GLORY = 85673,
    LAY_ON_HANDS = 633,
    DIVINE_SHIELD = 642,
    DIVINE_PROTECTION = 498,
    CLEANSE_TOXINS = 213644,
    BLESSING_OF_FREEDOM = 1044,
    HAMMER_OF_JUSTICE = 853,
    JUDGMENT = 275773,
    CRUSADER_STRIKE = 35395
}

-- Helper Functions
function TryCast(spellID, target)
    return cast(spellID, target)
end

-- Replace placeholder functions with PS-based logic where applicable
function UnitHealth(unit)
    -- PS should provide a way to get health percent; this is a mock
    return 0.6 -- placeholder for now
end
function GetHolyPower()
    return 3 -- placeholder
end

-- Hero Talents
function ActivateHolyBulwark() end
function ApplyRiteOfSanctification(target) end
function ApplySolidarity() end
function EnhanceHolyShock() end
function LayingDownArms(target) end
function InspireTarget(target) end
function TemptedInBattle(target) end
function SharedResolve(target) end
function VigilanceAura() end
function HammerAndAnvil() end
function BlessingOfTheForge(target) end

-- Core Healing & Utility Logic

-- Interrupt baiting to cancel casts if likely to be interrupted
function CheckInterruptBaiting()
local enemies = target_selector:get_targets(3)
    if cooldown_tracker.is_any_kick_around and cooldown_tracker:is_any_kick_around(enemies, true) then
        core.input.cancel_spells()
        plugin_helper:draw_text_character_center("FAKECAST!", color.orange(255), 1.2)
        print("Fakecasting cancelled due to kick threat")
        return
    end
    if not ui_settings.enable_fakecast then return end
    local incoming = health_prediction:get_incoming_damage("player", 1.5, false)
    if incoming > 5000 then
        core.input.cancel_spells()
        print("Fakecasting: canceling to bait interrupt")
    end
end


-- Combo chaining after spell casts
core.register_on_spell_cast_callback(function(spell_id, target)
    if not ui_settings.enable_combo_logic then return end
    print("Successfully cast spell " .. tostring(spell_id) .. " on " .. tostring(target))

    if spell_id == SPELL_IDS.HOLY_SHOCK and GetHolyPower() >= 3 then
        TryCast(SPELL_IDS.WORD_OF_GLORY, target)
    end
    if spell_id == SPELL_IDS.HAMMER_OF_JUSTICE then
        TryCast(SPELL_IDS.JUDGMENT, target)
    end
    if spell_id == SPELL_IDS.LAY_ON_HANDS then
        TryCast(SPELL_IDS.DIVINE_PROTECTION, "player")
    end
    if spell_id == SPELL_IDS.JUDGMENT then
        TryCast(SPELL_IDS.CRUSADER_STRIKE, target)
    end
    if spell_id == SPELL_IDS.BLESSING_OF_FREEDOM then
        TryCast(SPELL_IDS.CLEANSE_TOXINS, target)
    end
end)

function AutoHeal()
    if UnitHealth("party1") < 0.5 then TryCast(SPELL_IDS.HOLY_SHOCK, "party1") end
    if UnitHealth("party1") < 0.4 and GetHolyPower() >= 3 then TryCast(SPELL_IDS.WORD_OF_GLORY, "party1") end
    if UnitHealth("party1") < 0.3 then TryCast(SPELL_IDS.LAY_ON_HANDS, "party1") end
end

function UseDefensiveCooldowns()
    if UnitHealth("player") < 0.4 then TryCast(SPELL_IDS.DIVINE_SHIELD, "player") end
    if UnitHealth("player") < 0.5 then TryCast(SPELL_IDS.DIVINE_PROTECTION, "player") end
end




function UseCCLogic()
    local arena_targets = { "arena1", "arena2", "arena3" }
    local settings = {
        arena1 = ui_settings.enable_hoj_arena1,
        arena2 = ui_settings.enable_hoj_arena2,
        arena3 = ui_settings.enable_hoj_arena3,
    }

    for _, unit in ipairs(arena_targets) do
        if settings[unit] then
            local target_obj = core.unit_manager.get_unit(unit)
            if target_obj
                and not cooldown_tracker:has_any_relevant_defensive_up(target_obj)
                and CanCastSpell(SPELL_IDS.HAMMER_OF_JUSTICE, unit)
                and not ShouldAvoidCastingOn(unit)
                and not pvp_helper:is_cc_immune(unit, pvp_helper.cc_flags.STUN) then
                plugin_helper:draw_text_character_center("HoJ ON KILL TARGET", color.orange(255), 1.0)
                TryCast(SPELL_IDS.HAMMER_OF_JUSTICE, unit, 85, "Arena HoJ: " .. unit)
                return
            end
        end
    end

    -- fallback to healer if focus is valid
    local focus = "focus"
    if CanCastSpell(SPELL_IDS.HAMMER_OF_JUSTICE, focus)
        and not ShouldAvoidCastingOn(focus)
        and not pvp_helper:is_cc_immune(focus, pvp_helper.cc_flags.STUN) then
        plugin_helper:draw_text_character_center("Fallback HoJ on Healer", color.yellow(255), 1.0)
        TryCast(SPELL_IDS.HAMMER_OF_JUSTICE, focus, 85, "Fallback HoJ on Healer")
    end
end
    local arena_targets = { "arena1", "arena2", "arena3" }
    local settings = {
        arena1 = ui_settings.enable_hoj_arena1,
        arena2 = ui_settings.enable_hoj_arena2,
        arena3 = ui_settings.enable_hoj_arena3,
    }

    for _, unit in ipairs(arena_targets) do
        if settings[unit] then
            local target_obj = core.unit_manager.get_unit(unit)
            if target_obj
                and not cooldown_tracker:has_any_relevant_defensive_up(target_obj)
                and CanCastSpell(spell_ids.HAMMER_OF_JUSTICE, unit)
                and not ShouldAvoidCastingOn(unit) then
            if pvp_helper:is_cc_immune(unit, pvp_helper.cc_flags.STUN) then
        print("Skipping CC on target with stun immunity")
        return
    end
                TryCast(spell_ids.HAMMER_OF_JUSTICE, unit, 85, "Arena HoJ: " .. unit)
                return
            end
        end
    end
end

    local arena_targets = { "arena1", "arena2", "arena3" }

    for _, unit in ipairs(arena_targets) do
        local target_obj = core.unit_manager.get_unit(unit)
        if target_obj
            and not cooldown_tracker:has_any_relevant_defensive_up(target_obj)
            and CanCastSpell(spell_ids.HAMMER_OF_JUSTICE, unit)
            and not ShouldAvoidCastingOn(unit) then
            if pvp_helper:is_cc_immune(unit, pvp_helper.cc_flags.STUN) then
        print("Skipping CC on target with stun immunity")
        return
    end
            TryCast(spell_ids.HAMMER_OF_JUSTICE, unit, 85, "Arena HoJ: " .. unit)
            return
        end
    end
end

    local target = "target"
    local target_obj = core.unit_manager.get_unit(target)
    local isStunDR = false -- Replace with real DR logic if available

    if target_obj
        and not cooldown_tracker:has_any_relevant_defensive_up(target_obj)
        and not isStunDR then
        TryCast(SPELL_IDS.HAMMER_OF_JUSTICE, target)
    end
end


function AutoCleanse()
    TryCast(SPELL_IDS.CLEANSE_TOXINS, "party1")
end

function AutoFreedom()
    TryCast(SPELL_IDS.BLESSING_OF_FREEDOM, "party1")
end

function ManageHolyPower()
    if GetHolyPower() >= 3 then TryCast(SPELL_IDS.WORD_OF_GLORY, "party1") end
end


function OffensiveHolyShock()
    local target = "target"
    if GetHolyPower() < 5 and CanCastSpell(spell_ids.HOLY_SHOCK, target) and UnitHealth("player") > 0.8 then
        TryCast(spell_ids.HOLY_SHOCK, target, 60, "Offensive Holy Shock")
    end
end


function ExecuteBurstRotation()
    local comp = GetEnemyCompType()
    if comp.rogue and comp.mage and comp.priest then
        plugin_helper:draw_text_character_center("RMP BURST WINDOW!", color.red(255), 1.2)
    elseif comp.melee >= 2 then
        plugin_helper:draw_text_character_center("DOUBLE MELEE - BURST SOON", color.orange(255), 1.2)
    end
    ExecuteDefensiveRotation()
    DamageRotation()
    TryCast(SPELL_IDS.JUDGMENT, "target")
    TryCast(SPELL_IDS.CRUSADER_STRIKE, "target")
end


-- Enhanced spell cast check: cooldown, GCD, charges, LoS
function CanCastSpell(spell_id, target)
    local caster = core.object_manager.get_local_player()
    if cooldown_tracker:is_spell_los(spell_id, caster, target) then return false end
    if get_global_cooldown() > 0 then return false end
    if get_spell_cooldown(spell_id) > 0 then return false end

    local charges = get_spell_charge(spell_id)
    if charges ~= nil and charges == 0 then return false end

    return spell_helper:is_spell_castable(spell_id, caster, target, true, false)
end



-- Check whether it's safe to cast on a unit (interrupt or DR aware)
function ShouldAvoidCastingOn(unit)
    -- Placeholder: Replace with actual interrupt or DR tracking API if available
    local dr_state = "low" -- e.g., dr_tracker:get_dr_state(unit, "stun")
    local can_interrupt = false -- e.g., interrupt_tracker:can_interrupt(unit)

    if can_interrupt then
        print("Avoiding cast: enemy has interrupt ready.")
        return true
    end

    if dr_state == "low" or dr_state == "medium" then
        print("Avoiding CC: enemy is on stun DR.")
        return true
    end

    return false
end



-- Automatically set focus to an enemy healer
function AutoSetFocusHealer()
    local healer_classes = {
        [enums.class_id.PRIEST] = true,
        [enums.class_id.DRUID] = true,
        [enums.class_id.PALADIN] = true,
        [enums.class_id.SHAMAN] = true,
        [enums.class_id.MONK] = true,
        [enums.class_id.EVOKER] = true,
    }

    local enemies = target_selector:get_targets(3)
    for _, unit in ipairs(enemies) do
        local class_id = unit_helper:get_class(unit)
        if healer_classes[class_id] then
            core.input.set_focus(unit)
            print("Set focus to likely healer: " .. unit)
            break
        end
    end
end


-- PvP Combat Loop

function UpdatePvPRotation()
    AutoBeaconAssignment()
    AutoAuraSwap()
    AutoFocusKillTarget()
    PreWOGBeforeStunChain()
    OutOfCombatHeal()
    AutoSetFocusHealer()
    CheckInterruptBaiting()
    ActivateHolyBulwark()
    ApplyRiteOfSanctification("party1")
    ApplySolidarity()
    EnhanceHolyShock()
    LayingDownArms("target")
    InspireTarget("party1")
    TemptedInBattle("party1")
    SharedResolve("party1")
    VigilanceAura()
    HammerAndAnvil()
    BlessingOfTheForge("party1")

    AutoHeal()
    UseDefensiveCooldowns()
    UseCCLogic()
    AutoCleanse()
    AutoFreedom()
    ManageHolyPower()
    ExecuteBurstRotation()
    ExecuteDefensiveRotation()
    DamageRotation()
end

    ApplyRiteOfSanctification("party1")
    ApplySolidarity()
    EnhanceHolyShock()
    LayingDownArms("target")
    InspireTarget("party1")
    TemptedInBattle("party1")
    SharedResolve("party1")
    VigilanceAura()
    HammerAndAnvil()
    BlessingOfTheForge("party1")

    AutoHeal()
    UseDefensiveCooldowns()
    UseCCLogic()
    AutoCleanse()
    AutoFreedom()
    ManageHolyPower()
    ExecuteBurstRotation()
    ExecuteDefensiveRotation()
    DamageRotation()
end

-- Call main PvP rotation
UpdatePvPRotation()


-- UI Config Window
local function DrawUI()
    local window = core.menu.window.new("holy_paladin_ui")
    window:set_initial_size(ImVec2(300, 250))

    if window:begin() then
        window:separator_text("Healing Thresholds")
        ui_settings.heal_threshold_hs = window:slider_float("Holy Shock", ui_settings.heal_threshold_hs, 0.1, 1.0)
        ui_settings.heal_threshold_wog = window:slider_float("Word of Glory", ui_settings.heal_threshold_wog, 0.1, 1.0)
        ui_settings.heal_threshold_loh = window:slider_float("Lay on Hands", ui_settings.heal_threshold_loh, 0.1, 1.0)

        window:separator_text("Toggles")
        ui_settings.enable_cleanse = window:checkbox("Auto Cleanse", ui_settings.enable_cleanse)
        ui_settings.enable_freedom = window:checkbox("Auto Freedom", ui_settings.enable_freedom)
        ui_settings.enable_combo_logic = window:checkbox("Combo Logic", ui_settings.enable_combo_logic)
        ui_settings.enable_fakecast = window:checkbox("Fakecast Interrupt Baiting", ui_settings.enable_fakecast)

    window:separator_text("Advanced Settings")
    ui_settings.hp_pooling_threshold = window:slider_float("Pooling Threshold (incoming damage)", ui_settings.hp_pooling_threshold, 1000, 10000)


    window:separator_text("Modes")
    ui_settings.enable_burst_mode = window:checkbox("Enable Burst Mode", ui_settings.enable_burst_mode)
    ui_settings.enable_defensive_mode = window:checkbox("Enable Defensive Mode", ui_settings.enable_defensive_mode)


    window:separator_text("Arena123 HoJ Toggles")
    ui_settings.enable_hoj_arena1 = window:checkbox("Enable HoJ Arena1", ui_settings.enable_hoj_arena1)
    ui_settings.enable_hoj_arena2 = window:checkbox("Enable HoJ Arena2", ui_settings.enable_hoj_arena2)
    ui_settings.enable_hoj_arena3 = window:checkbox("Enable HoJ Arena3", ui_settings.enable_hoj_arena3)

    end

    
    window:separator_text("Enemy DR Info")
    for _, unit in ipairs({ "arena1", "arena2", "arena3" }) do
        local dr_time = dr_tracker.get_remaining_dr_time and dr_tracker:get_remaining_dr_time(unit, "stun")
        if dr_time and dr_time > 0 then
            window:text(unit .. " DR (stun): " .. string.format("%.1f", dr_time) .. "s")
        end
    end


    window:end_()
end

core.menu.add_draw_handler(DrawUI)



function ExecuteBurstRotation()
    local comp = GetEnemyCompType()
    if comp.rogue and comp.mage and comp.priest then
        plugin_helper:draw_text_character_center("RMP BURST WINDOW!", color.red(255), 1.2)
    elseif comp.melee >= 2 then
        plugin_helper:draw_text_character_center("DOUBLE MELEE - BURST SOON", color.orange(255), 1.2)
    end
    local target = "target"
    if ui_settings.enable_burst_mode then
        if CanCastSpell(SPELL_IDS.HOLY_SHOCK, target) then
            
    if talents and talents.is_enabled and talents.is_enabled(21201) then
        plugin_helper:draw_text_character_center("Glimmer Active!", color.yellow(255), 1.0)
    end

        plugin_helper:draw_text_character_center("BURST ACTIVE!", color.red(255), 1.2)
        TryCast(SPELL_IDS.HOLY_SHOCK, target, 90, "Burst: Holy Shock")
        end
        if GetHolyPower() >= 3 and CanCastSpell(SPELL_IDS.WORD_OF_GLORY, "player") then
            TryCast(SPELL_IDS.WORD_OF_GLORY, "player", 95, "Burst: Self WoG")
        end
        if CanCastSpell(SPELL_IDS.JUDGMENT, target) then
            TryCast(SPELL_IDS.JUDGMENT, target, 85, "Burst: Judgment")
        end
    end
end



function ExecuteDefensiveRotation()
    local comp = GetEnemyCompType()
    if comp.rogue and comp.mage and comp.priest then
        plugin_helper:draw_text_character_center("RMP DETECTED", color.red(255), 1.2)
    elseif comp.melee >= 2 then
        plugin_helper:draw_text_character_center("DOUBLE MELEE DETECTED", color.orange(255), 1.2)
    end
    if ui_settings.enable_defensive_mode then
        if UnitHealth("player") < 0.4 and CanCastSpell(SPELL_IDS.DIVINE_SHIELD, "player") then
            plugin_helper:draw_text_character_center("DEFENSIVE MODE", color.blue(255), 1.2)
        TryCast(SPELL_IDS.DIVINE_SHIELD, "player", 100, "Defensive: Bubble")
        elseif UnitHealth("player") < 0.5 and CanCastSpell(SPELL_IDS.DIVINE_PROTECTION, "player") then
            plugin_helper:draw_text_character_center("DEFENSIVE MODE", color.blue(255), 1.2)
        TryCast(SPELL_IDS.DIVINE_PROTECTION, "player", 90, "Defensive: Divine Protection")
        end
    end
end

function ShouldPoolHolyPower(unit)
    local _, incoming = unit_helper:get_health_percentage_inc(unit, 2.0)
    if incoming and incoming > ui_settings.hp_pooling_threshold and GetHolyPower() < 5 then
        print("Pooling Holy Power: High incoming damage detected")
        return true
    end
    return false
end

function OutOfCombatHeal()
    if not core.combat.is_in_combat() then
        local units = { "party1", "party2", "player", "focus" }
        
    local comp = GetEnemyCompType()
    local loh_thres = ui_settings.heal_threshold_loh
    local wog_thres = ui_settings.heal_threshold_wog
    local hs_thres  = ui_settings.heal_threshold_hs

    if comp.melee >= 2 then
        loh_thres = loh_thres + 0.1
        wog_thres = wog_thres + 0.1
        hs_thres = hs_thres + 0.05
    end

    for _, unit in ipairs(units) do
            local hp = unit_helper:get_health_percentage(unit)
            if hp < 0.7 and CanCastSpell(SPELL_IDS.HOLY_LIGHT, unit) then
                plugin_helper:draw_text_character_center("Holy Light - Prep", color.green(255), 1.0)
                TryCast(SPELL_IDS.HOLY_LIGHT, unit, 60, "Holy Light Prep Heal")
            end
        end
    end
end

function GetEnemyCompType()
    local comp = { melee = 0, caster = 0, rogue = false, mage = false, priest = false }
    for i = 1, 3 do
        local unit = "arena" .. i
        local class_id = unit_helper:get_class(unit)
        if class_id then
            if class_id == enums.class_id.ROGUE then comp.rogue = true end
            if class_id == enums.class_id.MAGE then comp.mage = true end
            if class_id == enums.class_id.PRIEST then comp.priest = true end
            if unit_helper:is_melee_class and unit_helper:is_melee_class(class_id) then
                comp.melee = comp.melee + 1
            elseif unit_helper:is_caster_class and unit_helper:is_caster_class(class_id) then
                comp.caster = comp.caster + 1
            end
        end
    end
    return comp
end

function AutoBeaconAssignment()
    local units = { "party1", "party2", "player" }
    local max_incoming = 0
    local beacon_target = nil

    for _, unit in ipairs(units) do
        local _, incoming = unit_helper:get_health_percentage_inc(unit, 2.0)
        if incoming and incoming > max_incoming then
            max_incoming = incoming
            beacon_target = unit
        end
    end

    if beacon_target and CanCastSpell(SPELL_IDS.BEACON_OF_LIGHT, beacon_target)
        and not buff_manager:has_buff(beacon_target, buff_db.BEACON_OF_LIGHT) then
        plugin_helper:draw_text_character_center("Swapping Beacon to " .. beacon_target, color.cyan(255), 1.0)
        TryCast(SPELL_IDS.BEACON_OF_LIGHT, beacon_target, 70, "Beacon Swap")
    end
end

function AutoAuraSwap()
    local comp = GetEnemyCompType()
    if UnitHealth("player") < 0.6 and comp.melee >= 2 then
        -- Switch to Devotion Aura
        TryCast(SPELL_IDS.DEVOTION_AURA, "player", 40, "Switching to Devotion Aura")
    elseif comp.caster >= 2 then
        -- Switch to Aura of Mercy
        TryCast(SPELL_IDS.AURA_OF_MERCY, "player", 40, "Switching to Aura of Mercy")
    end
end

function GetBestHealingTarget()
    local units = { "party1", "party2", "player" }
    local best = nil
    local score = -1

    for _, unit in ipairs(units) do
        if buff_manager:has_buff(unit, buff_db.DIVINE_SHIELD) then goto continue end

        local hp, incoming = unit_helper:get_health_percentage_inc(unit, 2.0)
        local priority = 0
        if unit_helper:is_healer(unit) then priority = priority + 20 end
        if incoming and incoming > 4000 then priority = priority + 15 end
        if pvp_helper:is_crowd_controlled(unit, pvp_helper.cc_flags.STUN) then priority = priority + 10 end
        if hp and hp < 0.4 then priority = priority + 30 end

        if priority > score then
            score = priority
            best = unit
        end
        ::continue::
    end

    return best
end

function AutoFocusKillTarget()
    local lowest_hp = 1.1
    local focus_target = nil
    for i = 1, 3 do
        local unit = "arena" .. i
        local hp = unit_helper:get_health_percentage(unit)
        if hp and hp < lowest_hp and not pvp_helper:is_cc_immune(unit, pvp_helper.cc_flags.ALL) then
            lowest_hp = hp
            focus_target = unit
        end
    end

    if focus_target then
        core.input.set_focus(focus_target)
        plugin_helper:draw_text_character_center("Auto-Focused Kill Target: " .. focus_target, color.red(255), 1.2)
    end
end

function PreWOGBeforeStunChain()
    local comp = GetEnemyCompType()
    if comp.rogue and comp.mage and comp.priest then
        local hp = unit_helper:get_health_percentage("player")
        if hp < 0.6 and GetHolyPower() >= 3 and CanCastSpell(SPELL_IDS.WORD_OF_GLORY, "player") then
            plugin_helper:draw_text_character_center("Pre-WoG BEFORE STUN!", color.orange(255), 1.2)
            TryCast(SPELL_IDS.WORD_OF_GLORY, "player", 95, "Pre-WoG Before Stun Chain")
        end
    end
end
