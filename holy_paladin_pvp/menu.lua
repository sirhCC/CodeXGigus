local core = _G.core
local menu = core.menu

local menu_elements = {
    main_tree = menu.tree_node(),
    enable_script_check = menu.checkbox(true, "enable_script_check"),
    enable_toggle = menu.keybind(7, true, "enable_toggle"),

    pvp_settings = {
        tree = menu.tree_node(),
        enable_arena = menu.checkbox(true, "enable_arena"),
        enable_bg = menu.checkbox(true, "enable_bg"),
        enable_world_pvp = menu.checkbox(true, "enable_world_pvp"),
        enable_duels = menu.checkbox(true, "enable_duels")
    },

    healing = {
        tree = menu.tree_node(),
        triage_mode = menu.checkbox(false, "triage_mode"),
        wog_threshold = menu.slider_int(10, 100, 75, "wog_threshold")
    },

    utility = {
        tree = menu.tree_node(),
        auto_wings = menu.checkbox(true, "auto_wings"),
        fake_casts = menu.checkbox(true, "fake_casts"),
        auto_hoj_chain = menu.checkbox(true, "auto_hoj_chain"),
        enable_freedom_prediction = menu.checkbox(true, "freedom_prediction"),
        debug_logs = menu.checkbox(false, "debug_logs")
    }
}

-- Register the UI tree rendering
core.register_on_render_menu_callback(function()
    menu_elements.main_tree:render("Holy Paladin PvP", function()
        menu_elements.enable_script_check:render("Enable Script", "Toggle script functionality")
        menu_elements.enable_toggle:render("Toggle Script", "Keybind toggle")

        if not menu_elements.enable_script_check:get_state() then return end

        menu_elements.pvp_settings.tree:render("PvP Settings", function()
            menu_elements.pvp_settings.enable_arena:render("Enable in Arena")
            menu_elements.pvp_settings.enable_bg:render("Enable in Battlegrounds")
            menu_elements.pvp_settings.enable_world_pvp:render("Enable in World PvP")
            menu_elements.pvp_settings.enable_duels:render("Enable in Duels")
        end)

        menu_elements.healing.tree:render("Healing Logic", function()
            menu_elements.healing.triage_mode:render("Enable Triage Mode")
            menu_elements.healing.wog_threshold:render("WOG Threshold")
        end)

        menu_elements.utility.tree:render("Utility & Toggles", function()
            menu_elements.utility.auto_wings:render("Auto Wings")
            menu_elements.utility.fake_casts:render("Fake Casts")
            menu_elements.utility.auto_hoj_chain:render("Auto HoJ Chains")
            menu_elements.utility.enable_freedom_prediction:render("Freedom Prediction")
            menu_elements.utility.debug_logs:render("Debug Logging")
        end)
    end)
end)

return menu_elements
