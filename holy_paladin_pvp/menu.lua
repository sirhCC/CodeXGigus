local menu_elements = {
    main_tree = core.menu.tree_node(),
    enable_script_check = core.menu.checkbox(true, "enable_script_check"),
    enable_toggle = core.menu.keybind(7, true, "enable_toggle"),

    pvp_settings = {
        tree = core.menu.tree_node(),
        enable_arena = core.menu.checkbox(true, "enable_arena"),
        enable_bg = core.menu.checkbox(true, "enable_bg"),
        enable_world_pvp = core.menu.checkbox(true, "enable_world_pvp"),
        enable_duels = core.menu.checkbox(true, "enable_duels")
    },

    healing = {
        tree = core.menu.tree_node(),
        triage_mode = core.menu.checkbox(false, "triage_mode"),
        wog_threshold = core.menu.slider_int(10, 100, 75, "wog_threshold")
    },

    utility = {
        tree = core.menu.tree_node(),
        auto_wings = core.menu.checkbox(true, "auto_wings"),
        fake_casts = core.menu.checkbox(true, "fake_casts"),
        auto_hoj_chain = core.menu.checkbox(true, "auto_hoj_chain"),
        enable_freedom_prediction = core.menu.checkbox(true, "freedom_prediction"),
        debug_logs = core.menu.checkbox(false, "debug_logs")
    }
}

return menu_elements
