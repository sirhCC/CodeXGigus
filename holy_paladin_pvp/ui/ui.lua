
-- UI file for Holy Paladin PvP with control panel toggle buttons

local ui = {}

-- Function to initialize the UI with the toggle
function ui.init(control_panel)
    -- Create a toggle button in the UI
    local toggle = control_panel.create_toggle()

    -- Set the toggle button to handle user interaction
    print("Press the button to toggle Holy Paladin PvP:")
    toggle:on_toggle()  -- Toggle the state once on load for initial display
end

return ui
