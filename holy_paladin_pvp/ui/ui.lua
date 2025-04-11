local M = {}
local constants = require("modules/constants")

local menu_elements = {}

function M.create_menu(ui_elements)
    menu_elements.enable_script_check = ui_elements:checkbox("Enable Script", true)
    menu_elements.allow_auto_wings = ui_elements:checkbox("Allow Auto Wings", true)
    menu_elements.wog_threshold = ui_elements:slider_float("WOG HP Threshold", 0.3, 1.0, 0.75, "%.0f%%")
end

M.menu_elements = menu_elements

return M