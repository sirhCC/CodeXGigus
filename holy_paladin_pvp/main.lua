local plugin = ...

local ui = require("ui")
local rotation = require("rotation")

function plugin.on_load()
    print("[Holy Paladin] Loaded.")
end

function plugin.on_unload()
    print("[Holy Paladin] Unloaded.")
end

function plugin.run()
    if not ui.menu_elements.enable_script_check or not ui.menu_elements.enable_script_check:get_state() then return end
    rotation.run()
end

function plugin.on_render()
    -- future visual hooks
end
