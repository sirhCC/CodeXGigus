local rotation = require("rotation")
local paladin_menu = require("paladin_menu")

return {
    on_load = function()
        paladin_menu.init_menu()
        core.log("[Holy Paladin] Menu initialized.")
        _G.paladin_state = { enabled = true }
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
        -- Registered in paladin_menu.init_menu
    end
}
