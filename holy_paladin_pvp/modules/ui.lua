-- modules/ui.lua

local ui = {}
local menu = require("core/menu")

function ui.setup()
    menu:add_node("Holy Paladin PvP")
    menu:add_checkbox("Enable Healing", true)
    menu:add_slider("Emergency Threshold", 10, 100, 40)
    menu:add_slider("Flash of Light Threshold", 10, 100, 85)
    menu:add_slider("WOG Threshold", 10, 100, 65)
end

ui.setup()
return ui
