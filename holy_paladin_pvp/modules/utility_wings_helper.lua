-- === Utility Helper: Wings Ending Soon ===
local wings_ids = {
    [31884] = true,   -- Avenging Wrath
    [231895] = true   -- Crusade
}

function M.wings_ending_soon(threshold)
    threshold = threshold or 2.0
    local buffs = core.local_player:get_buffs()
    for _, buff in ipairs(buffs) do
        if wings_ids[buff.spell_id] and buff.remaining_time <= threshold then
            return true
        end
    end
    return false
end