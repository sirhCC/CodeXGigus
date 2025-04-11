-- Holy Paladin Core

local core = _G.core
local config = require("config")

---@type enums
local enums = require("common/enums")
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")

local paladin_core = {}

paladin_core.state = {
    enabled = false,
    last_heal_check = 0,
}

paladin_core.menu = {
    elements = {},
    trees = {}
}

function paladin_core.debug_log(message)
    if config.DEFAULT_SETTINGS.show_debug then
        core.log("[Holy Paladin] " .. message)
    end
end

return paladin_core
