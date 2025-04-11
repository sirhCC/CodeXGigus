local ui = require("ui")
local rotation = require("rotation")

return {
    on_load = function()
        print("[Holy Paladin] Loaded.")
    end,

    on_unload = function()
        print("[Holy Paladin] Unloaded.")
    end,

    run = function()
        if not ui.menu_elements.enable_script_check or not ui.menu_elements.enable_script_check:get_state() then return end
        rotation.run()
    end,

    on_render = function()
        -- future HUD rendering goes here
    end
}
