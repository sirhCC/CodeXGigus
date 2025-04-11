local menu = require("core/menu")

return {
    on_load = function()
        _G.paladin_state = { enabled = true }
        core.log("[Holy Paladin] Menu loaded.")

        -- Define and cache menu elements globally
        _G.hp_menu = {
            enable_script = menu.checkbox(true, "hp_enable_script"),
            emergency_slider = menu.slider_int(10, 100, 40, "hp_emergency_threshold"),
            normal_slider = menu.slider_int(10, 100, 80, "hp_normal_threshold"),
            use_cleanse = menu.checkbox(true, "hp_use_cleanse"),
            use_wings = menu.checkbox(true, "hp_use_wings"),
        }

        -- Register a proper PS menu rendering callback
        core.register_on_render_menu_callback(function()
            _G.hp_menu.enable_script:render("Enable Script")
            _G.hp_menu.use_cleanse:render("Use Cleanse")
            _G.hp_menu.use_wings:render("Use Wings")
            _G.hp_menu.emergency_slider:render("Emergency Threshold")
            _G.hp_menu.normal_slider:render("Normal Heal Threshold")
        end)
    end,

    on_unload = function()
        core.log("[Holy Paladin] Unloaded.")
    end,

    run = function()
        if not _G.paladin_state or not _G.paladin_state.enabled then
            core.log("[Holy Paladin] Script disabled, skipping run.")
            return
        end
        core.log("[Holy Paladin] RUN triggered.")
        -- Future healing logic here
    end,

    create_menu = function()
        -- Not used, handled by on_load registration
    end
}
