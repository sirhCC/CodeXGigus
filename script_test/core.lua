
local core = {}

core.menu = {
    elements = {} -- Add menu elements here as needed
}

core.object_manager = {
    get_local_player = function()
        -- Example: Replace with actual code to get the local player object
        return { get_name = function() return "PlayerName" end }
    end
}

core.spell_book = {
    get_specialization_id = function()
        -- Example: Replace with actual logic for getting specialization ID
        return 1
    end
}

core.spell_helper = require("common/utility/spell_helper")

return core
