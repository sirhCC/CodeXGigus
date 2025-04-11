-- Holy Paladin PvP - Menu
local core = _G.core

local menu = {}
menu.elements = {}
menu.trees = {}

-- Render the menu UI
local function render_menu()
    local e = menu.elements
    local t = menu.trees
    local color = require("common/color")

    t.main:render("Holy Paladin PvP", function()
        e.enable_checkbox:render("Enable Script")

        core.menu.header():render("Burst & Healing Settings", color.white(200))
        e.auto_wings:render("Auto Wings")
        e.fake_cast:render("Enable Fake Casts")
        e.auto_hoj:render("Auto HoJ Kill Chains")

        core.menu.header():render("Word of Glory Threshold", color.white(200))
        e.wog_threshold:render("WOG HP Threshold")

        core.menu.header():render("Debug", color.white(200))
        e.show_debug:render("Show Debug Messages")
    end)
end

-- Watch checkbox changes
local function check_enable_checkbox()
    local cb = menu.elements.enable_checkbox
    if cb then
        local new_state = cb:get_state()
        if new_state ~= _G.paladin_state.enabled then
            _G.paladin_state.enabled = new_state
            print("[Paladin PvP] " .. (new_state and "Enabled" or "Disabled") .. " via checkbox")
        end
    end
end

-- Initialize the menu
function menu.init_menu()
    menu.trees.main = core.menu.tree_node()

    menu.elements.enable_checkbox = core.menu.checkbox(true, "enable_paladin_script")
    menu.elements.auto_wings = core.menu.checkbox(true, "auto_wings")
    menu.elements.fake_cast = core.menu.checkbox(true, "fake_casts")
    menu.elements.auto_hoj = core.menu.checkbox(true, "auto_hoj")
    menu.elements.wog_threshold = core.menu.slider_float(0.3, 1.0, 0.75, "wog_threshold")
    menu.elements.show_debug = core.menu.checkbox(false, "show_debug")

    -- Default state table
    _G.paladin_state = {
        enabled = menu.elements.enable_checkbox:get_state()
    }

    -- Hook up to PS UI + Update cycle
    core.register_on_render_menu_callback(render_menu)
    core.register_on_update_callback(check_enable_checkbox)
end

return menu
