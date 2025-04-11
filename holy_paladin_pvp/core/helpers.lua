-- core/helpers.lua

local buff_manager = require("common/modules/buff_manager")
local enums = require("common/enums")
local constants = require("constants")

local M = {}

-- Check if a unit has a specific buff
---@param unit game_object
---@param buff_id number
---@return boolean
function M.has_buff(unit, buff_id)
    local buff_data = buff_manager:get_buff_data(unit, buff_id)
    return buff_data and buff_data.is_active
end

-- Check if a unit has a specific debuff
---@param unit game_object
---@param debuff_id number
---@return boolean
function M.has_debuff(unit, debuff_id)
    local debuff_data = buff_manager:get_debuff_data(unit, debuff_id)
    return debuff_data and debuff_data.is_active
end

-- Get the player's current Holy Power
---@return number
function M.get_holy_power()
    local player = core.object_manager.get_local_player()
    return player and player:get_power(constants.HOLY_POWER_TYPE) or 0
end

-- Get the party/raid member with the lowest health %
---@return game_object | nil
function M.get_lowest_party_member()
    local unit_helper = require("common/utility/unit_helper")
    local local_player = core.object_manager.get_local_player()
    if not local_player then return nil end

    local allies = unit_helper:get_ally_list_around(local_player:get_position(), 40.0, true, true)
    local lowest = nil
    local lowest_hp = 100

    for _, ally in ipairs(allies) do
        if ally:is_alive() and not ally:is_dead() then
            local hp = ally:get_health_percent()
            if hp < lowest_hp then
                lowest = ally
                lowest_hp = hp
            end
        end
    end

    return lowest
end

-- Check if a unit is in line of sight
---@param unit game_object
---@return boolean
function M.is_in_los(unit)
    local local_player = core.object_manager.get_local_player()
    return core.graphics.is_line_of_sight(local_player, unit)
end

-- Check if a unit is a valid heal target
---@param unit game_object
---@return boolean
function M.is_valid_heal_target(unit)
    return unit and unit:is_alive() and not unit:is_dead()
end

return M
