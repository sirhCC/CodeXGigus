local M = {}
local DR_RESET_TIME = 18
local dr_table = {}

local spell_to_dr = {
    [853] = "stun", [408] = "stun", [5211] = "stun",
    [118] = "incap", [20066] = "incap", [605] = "incap",
    [8122] = "fear", [5484] = "fear", [2094] = "disorient",
    [88625] = "silence"
}

function M.apply_dr(unit_guid, spell_id)
    local dr_type = spell_to_dr[spell_id]
    if not dr_type then return end
    if not dr_table[unit_guid] then dr_table[unit_guid] = {} end
    dr_table[unit_guid][dr_type] = os.time() + DR_RESET_TIME
end

function M.is_on_dr(unit, dr_type)
    local guid = unit:get_guid()
    return dr_table[guid] and dr_table[guid][dr_type] and (dr_table[guid][dr_type] - os.time()) > 0
end

function M.get_dr_remaining(unit, dr_type)
    local guid = unit:get_guid()
    if dr_table[guid] and dr_table[guid][dr_type] then
        return math.max(0, dr_table[guid][dr_type] - os.time())
    end
    return 0
end

return M