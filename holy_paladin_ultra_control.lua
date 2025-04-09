
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
                and CanCastSpell(spell_ids.HAMMER_OF_JUSTICE, unit)
                and not ShouldAvoidCastingOn(unit) then
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


function DamageRotation()
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
