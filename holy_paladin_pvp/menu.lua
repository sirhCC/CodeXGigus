local core = require("core")
local menu = core.menu

local M = {}

M.elements = {}

function M.init_menu()
    local root = menu.tree_node("Holy Paladin PvP")

    M.elements.enable_script = menu.checkbox(true, "Enable Script")
    M.elements.auto_wings = menu.checkbox(true, "Auto Wings")
    M.elements.fake_casts = menu.checkbox(true, "Fake Casts")
    M.elements.auto_hoj_chain = menu.checkbox(true, "Auto HoJ Kill Chains")
    M.elements.triage_mode = menu.checkbox(false, "Enable Triage Mode")
    M.elements.enable_freedom_prediction = menu.checkbox(true, "Freedom Prediction")
    M.elements.wog_threshold = menu.slider_int(10, 100, 75, "WOG Threshold")
    M.elements.show_debug = menu.checkbox(false, "Show Debug Logs")

    root:add_child(M.elements.enable_script)
    root:add_child(M.elements.auto_wings)
    root:add_child(M.elements.fake_casts)
    root:add_child(M.elements.auto_hoj_chain)
    root:add_child(M.elements.triage_mode)
    root:add_child(M.elements.enable_freedom_prediction)
    root:add_child(M.elements.wog_threshold)
    root:add_child(M.elements.show_debug)
end

return M
