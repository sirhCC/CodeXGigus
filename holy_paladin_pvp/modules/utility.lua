-- modules/utility.lua

local constants = require("modules/constants")
local utility = {}

function utility.is_low_hp(unit, threshold)
    return unit:health_percent() < threshold
end

function utility.is_beaconed(unit)
    return unit:has_buff(constants.buffs.BEACON_OF_LIGHT)
end

function utility.has_wings()
    return localplayer:has_buff(constants.buffs.AVENGING_WRATH)
end

function utility.wings_ending_soon()
    local buff = localplayer:get_buff(constants.buffs.AVENGING_WRATH)
    return buff and buff.remaining < 4
end

return utility
