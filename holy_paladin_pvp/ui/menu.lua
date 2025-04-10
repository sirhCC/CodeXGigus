-- menu.lua

---@type color
local color = require("common/color")

local M = {}

M.menu_elements = {
    main_tree = core.menu.tree_node(),
    enable_script = core.menu.checkbox(true, "enable_script"),
    heal_threshold = core.menu.slider_int(1, 100, 60, "heal_threshold_slider")
}

function M.render_menu()
    M.menu_elements.main_tree:render("Holy Paladin PvP", function()
        M.menu_elements.enable_script:render("Enable Script", "Toggle healing logic")
        M.menu_elements.heal_threshold:render("Heal Threshold (%)")
        core.menu.header():render("Developed by You", color.aqua(200))
    end)
end

function M.render_control_panel()
    return {
        {
            name = "[Holy Paladin] Toggle Script",
            checkbox = M.menu_elements.enable_script
        },
        {
            name = "[Holy Paladin] Heal % Threshold",
            slider = M.menu_elements.heal_threshold
        }
    }
end

return M
