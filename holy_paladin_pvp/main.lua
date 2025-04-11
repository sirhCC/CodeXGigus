-- Holy Paladin - Main Logic

local core = _G.core
local config = require("config")
local paladin_core = require("core")

---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")

local function on_update()
    if not paladin_core.state.enabled then return end

    local player = core.object_manager.get_local_player()
    if not player then return end

    local now = core.time()
    if now - paladin_core.state.last_heal_check < config.CONSTANTS.HEAL_CHECK_INTERVAL then return end
    paladin_core.state.last_heal_check = now

    for _, ally in ipairs(core.group.get_friendly_units()) do
        if ally and ally:is_valid() and not ally:is_dead() then
            local hp = ally:get_health_percent()
            if hp < config.DEFAULT_SETTINGS.emergency_threshold then
                spell_queue:cast(config.SPELLS.LAY_ON_HANDS.id, ally)
                return
            elseif hp < config.DEFAULT_SETTINGS.normal_heal_threshold then
                spell_queue:cast(config.SPELLS.WORD_OF_GLORY.id, ally)
                return
            end
        end
    end
end

-- Register logic
core.register_on_update_callback(on_update)

-- Basic toggle in control panel
local function on_control_panel_render()
    return {{
        name = "Holy Paladin PvP",
        enabled = paladin_core.state.enabled,
        callback = function()
            paladin_core.state.enabled = not paladin_core.state.enabled
            return paladin_core.state.enabled
        end
    }}
end

core.register_on_render_control_panel_callback(on_control_panel_render)

core.log("[Holy Paladin PvP] v" .. config.VERSION .. " loaded!")
