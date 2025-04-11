local menu = require("menu")
local rotation = require("rotation")

return {
    on_load = function()
        menu.init_menu()
        core.log("[Holy Paladin] Menu initialized.")
        _G.paladin_state = { enabled = true }  -- Force enabled
    end,

    on_unload = function()
        core.log("[Holy Paladin] Unloaded.")
    end,

    run = function()
        core.log("[Holy Paladin] RUN TRIGGERED")

        if not _G.paladin_state or not _G.paladin_state.enabled then
            core.log("[Holy Paladin] Script not enabled")
            return
        end

        rotation.run()
    end,

    on_render = function()
        -- Future visual hooks
    end,

    create_menu = function()
        -- Registered in menu.init_menu
    end
}

local menu_elements = require("menu")

function on_render_menu()
    menu_elements.main_tree:render("Holy Paladin PvP", function()
        menu_elements.enable_script_check:render("Enable Script", "Toggle script functionality")
        menu_elements.enable_toggle:render("Toggle Script", "Keybind toggle")

        if not menu_elements.enable_script_check:get_state() then return end

        -- PvP Context Settings
        menu_elements.pvp_settings.tree:render("PvP Settings", function()
            menu_elements.pvp_settings.enable_arena:render("Enable in Arena")
            menu_elements.pvp_settings.enable_bg:render("Enable in Battlegrounds")
            menu_elements.pvp_settings.enable_world_pvp:render("Enable in World PvP")
            menu_elements.pvp_settings.enable_duels:render("Enable in Duels")
        end)

        -- Healing Settings
        menu_elements.healing.tree:render("Healing Logic", function()
            menu_elements.healing.triage_mode:render("Enable Triage Mode")
            menu_elements.healing.wog_threshold:render("WOG Threshold")
        end)

        -- Utility Settings
        menu_elements.utility.tree:render("Utility & Toggles", function()
            menu_elements.utility.auto_wings:render("Auto Wings")
            menu_elements.utility.fake_casts:render("Fake Casts")
            menu_elements.utility.auto_hoj_chain:render("Auto HoJ Chains")
            menu_elements.utility.enable_freedom_prediction:render("Freedom Prediction")
            menu_elements.utility.debug_logs:render("Debug Logging")
        end)
    end)
end
