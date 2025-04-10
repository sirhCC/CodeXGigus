
-- Holy Paladin PvP Control Panel with On/Off Toggle

local control_panel = {}

-- Create the On/Off toggle for the control panel
function control_panel.create_toggle()
    -- Create a simple On/Off toggle button for the user
    local toggle = { state = false }

    function toggle:on_toggle()
        self.state = not self.state
        print("Holy Paladin PvP is now " .. (self.state and "On" or "Off"))
    end

    -- Display the toggle button
    return toggle
end

return control_panel
