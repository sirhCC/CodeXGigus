-- core/state.lua

-- This module can be used to store persistent state info
-- between frames or for cooldown/trigger tracking

local M = {
    last_cast_time = {},
    cooldown_tracking = {},
}

function M.set_last_cast(spell_id)
    M.last_cast_time[spell_id] = os.clock()
end

function M.get_last_cast(spell_id)
    return M.last_cast_time[spell_id] or 0
end

return M
