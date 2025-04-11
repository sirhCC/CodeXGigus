local menu = require("menu")
local rotation = require("rotation")

return {
    on_load = function()
        menu.init_menu()
        print("[Holy Paladin] Menu initialized.")
        _G.paladin_state = { enabled = true }  -- Force enabled
    end,

    on_unload = function()
        print("[Holy Paladin] Unloaded.")
    end,

    run = function()
        print("[Holy Paladin] RUN TRIGGERED")

        if not _G.paladin_state or not _G.paladin_state.enabled then
            print("[Holy Paladin] Script not enabled")
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