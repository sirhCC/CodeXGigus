local M = {}
local constants = require("modules/constants")

local menu_elements = {}

function M.create_menu()
    local tree = core.menu.tree_node("Holy Paladin PvP")

    menu_elements.enable_script_check = core.menu.checkbox(true, "Enable Script")
    menu_elements.allow_auto_wings = core.menu.checkbox(true, "Allow Auto Wings")
    menu_elements.wog_threshold = core.menu.slider_float(0.3, 1.0, 0.75, "WOG HP Threshold")
    menu_elements.enable_fake_cast = core.menu.checkbox(true, "Enable Fake Casts")
    menu_elements.enable_auto_hoj = core.menu.checkbox(true, "Auto HoJ Kill Chains")

    tree:add_element(menu_elements.enable_script_check)
    tree:add_element(menu_elements.allow_auto_wings)
    tree:add_element(menu_elements.wog_threshold)
    tree:add_element(menu_elements.enable_fake_cast)
    tree:add_element(menu_elements.enable_auto_hoj)

    -- ✅ REGISTER the tree so it appears in the UI
    core.menu.add_node(tree)
end

M.menu_elements = menu_elements

return M

