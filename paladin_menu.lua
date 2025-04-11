---@type color
local color = require("common/color")

local M = {}

-- Define all menu elements OUTSIDE the render callback
local menu_elements = {
    header = core.menu.header(),
    enable_script = core.menu.checkbox(true, "paladin_enable_script"),
    emergency_flash = core.menu.checkbox(true, "paladin_emergency_flash"),
    wog_threshold = core.menu.combobox(3, "paladin_wog_threshold")  -- default index = 3
}

-- This function is called from main.lua on load
function M.init_menu()
    _G.paladin_state = _G.paladin_state or {}

    core.menu.register_on_render_menu_callback(function()
        menu_elements.header:render("Holy Paladin", color.yellow(255))

        menu_elements.enable_script:render("Enable Script", "Toggles the core logic")
        _G.paladin_state.enabled = menu_elements.enable_script:get_state()

        menu_elements.emergency_flash:render("Emergency Flash Mode", "Use Flash of Light at critical HP")
        _G.paladin_state.emergency_flash = menu_elements.emergency_flash:get_state()

        menu_elements.wog_threshold:render("Word of Glory % Threshold", {
            "90%", "75%", "60%", "45%", "30%"
        }, "Choose how low HP needs to be to cast WoG")

        local idx = menu_elements.wog_threshold:get()
        local values = {0.9, 0.75, 0.6, 0.45, 0.3}
        _G.paladin_state.wog_threshold = values[idx]
    end)
end

return M
