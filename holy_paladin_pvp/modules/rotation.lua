local config = require("config")

local rotation = {}

---@type spell_queue
local spell_queue = require("common/modules/spell_queue")

---@type spell_helper
local spell_helper = require("common/utility/spell_helper")

rotation.run = function()
    -- Force script to stay enabled
    _G.paladin_state = _G.paladin_state or {}
    _G.paladin_state.enabled = true

    if not _G.paladin_state.enabled then return end

    local player = core.object_manager.get_local_player()
    if not player then return end

    for _, ally in ipairs(core.group.get_friendly_units()) do
        if ally and ally:is_valid() and not ally:is_dead() then
            local hp = ally:get_health_percent()

            if hp < 40 then
                if spell_queue:cast(config.SPELLS.LAY_ON_HANDS.id, ally) then return end
            elseif hp < 65 then
                if spell_queue:cast(config.SPELLS.WORD_OF_GLORY.id, ally) then return end
            elseif hp < 85 then
                if spell_queue:cast(config.SPELLS.FLASH_OF_LIGHT.id, ally) then return end
            else
                spell_queue:cast(config.SPELLS.HOLY_SHOCK.id, ally)
            end
        end
    end
end

return rotation
