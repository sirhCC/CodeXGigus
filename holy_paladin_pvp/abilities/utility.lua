
-- abilities/utility.lua

local utility = {}

-- Function to check if a unit is alive
function utility.is_alive(unit)
    return unit and unit:is_valid() and not unit:is_dead()
end

return utility
