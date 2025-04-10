local core = _G.core
local config = require("config")
local player = core.local_player
local menu = core.menu.elements
local unit_helper = require("common/utility/unit_helper")

config.SPELLS = config.SPELLS or {}
config.DEFAULT_SETTINGS = config.DEFAULT_SETTINGS or {}

config.SPELLS.FORTITUDE = { id = 21562, name = "Power Word: Fortitude", priority = 1 }
config.DEFAULT_SETTINGS.use_fortitude = true

-- Load ability modules
local fortitude = require("abilities/power_word_fortitude")
local interrupts = require("abilities/enemy_interrupts")
local auto_focus = require("abilities/auto_focus_healer")
local flash_heal = require("abilities/flash_heal")
local renew = require("abilities/renew")
local desperate_prayer = require("abilities/desperate_prayer")
local power_word_shield = require("abilities/power_word_shield")
local rapture = require("abilities/rapture")
local barrier = require("abilities/barrier")
local purify = require("abilities/purify")
local dispel_magic = require("abilities/dispel_magic")
local schism = require("abilities/schism")
local smite = require("abilities/smite")
local shadowfiend = require("abilities/shadowfiend")
local psychic_scream = require("abilities/psychic_scream")
local mind_control = require("abilities/mind_control")
local fade = require("abilities/fade")
local swd = require("abilities/shadow_word_death")

local function is_safe_to_cast()
    local enemies = unit_helper:get_enemy_list_around(player:get_position(), 12, true)
    for _, enemy in ipairs(enemies or {}) do
        if enemy:can_interrupt() and enemy:is_facing(player) and enemy:can_see(player) then
            return false
        end
    end
    return true
end

local function get_priority_ally()
    local allies = unit_helper:get_friendly_players()
    table.sort(allies, function(a, b)
        return a:get_health_percentage() < b:get_health_percentage()
    end)
    return allies[1]
end

local function get_rapture_targets(min_hp)
    local targets = {}
    local allies = unit_helper:get_friendly_players()
    for _, ally in ipairs(allies or {}) do
        if ally:get_health_percentage() <= min_hp then
            table.insert(targets, ally)
        end
    end
    return targets
end

local function is_about_to_be_cced()
    return player:is_being_casted_on_by("Polymorph") or player:is_being_casted_on_by("Fear") or player:is_being_casted_on_by("Cyclone") or player:is_being_casted_on_by("Sap")
end

local function should_fade()
    local enemies = unit_helper:get_enemy_list_around(player:get_position(), 12, true)
    for _, enemy in ipairs(enemies or {}) do
        if enemy:is_melee() and enemy:is_facing(player) then
            return true
        end
    end
    return false
end

local function on_update()
    local target = player:get_target()
    local focus = player:get_focus_target()

    if not player:is_in_combat() and menu.use_fortitude and menu.use_fortitude:get_state() then
        if fortitude.buff_party(player) then return end
    end

    local priority_ally = get_priority_ally() or player

    if menu.use_desperate_prayer and menu.use_desperate_prayer:get_state() and desperate_prayer.try_desperate_prayer(player) then return end
    if menu.use_barrier and menu.use_barrier:get_state() and barrier.try_barrier(player) then return end

    local rapture_targets = get_rapture_targets(85)
    if menu.use_rapture and menu.use_rapture:get_state() and #rapture_targets >= 2 and rapture.try_rapture(player) then return end

    if menu.use_power_word_shield and menu.use_power_word_shield:get_state() then
        if power_word_shield.try_power_word_shield(player, priority_ally) or (focus and power_word_shield.try_power_word_shield(player, focus)) then return end
    end

    if menu.use_flash_heal and menu.use_flash_heal:get_state() and is_safe_to_cast() and flash_heal.try_flash_heal(priority_ally) then return end
    if menu.use_renew and menu.use_renew:get_state() and renew.try_renew(priority_ally) then return end

    if menu.use_purify and menu.use_purify:get_state() and purify.try_purify(player) then return end
    if menu.use_dispel_magic and menu.use_dispel_magic:get_state() and dispel_magic.try_dispel_magic(player) then return end

    if target then
        if menu.use_schism and menu.use_schism:get_state() and schism.try_schism(player, target) then return end
        if menu.use_shadowfiend and menu.use_shadowfiend:get_state() and shadowfiend.try_shadowfiend(player, target) then return end
        if menu.use_smite and menu.use_smite:get_state() and is_safe_to_cast() and smite.try_smite(player, target) then return end
    end

    if menu.use_psychic_scream and menu.use_psychic_scream:get_state() and psychic_scream.try_psychic_scream(player) then return end
    if menu.use_mind_control and menu.use_mind_control:get_state() and mind_control.try_mind_control(player) then return end

    if menu.use_shadow_word_death and menu.use_shadow_word_death:get_state() and is_about_to_be_cced() and swd.try_shadow_word_death(player) then return end
    if menu.use_fade and menu.use_fade:get_state() and should_fade() and fade.try_fade(player) then return end

    interrupts.track_enemy_interrupts()
    auto_focus.set_enemy_healer_focus()
end

return on_update
