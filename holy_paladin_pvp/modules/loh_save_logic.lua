-- === Lay on Hands Save Logic (Last Resort Check) ===
-- Only use LoH if other defensives (Sacrifice/Freedom) are unavailable

local can_sac = util.can_cast(constants.SPELLS.BLESSING_OF_SACRIFICE)
local can_freedom = util.can_cast(constants.SPELLS.BLESSING_OF_FREEDOM)
local has_sac_buff = util.has_buff(player, constants.BUFFS.BLESSING_OF_SACRIFICE)
local has_freedom_buff = util.has_buff(player, constants.BUFFS.BLESSING_OF_FREEDOM)

if player:get_health_percent() < 20 then
    if not can_sac and not can_freedom and not has_sac_buff and not has_freedom_buff then
        if util.can_cast(constants.SPELLS.LAY_ON_HANDS) then
            util.cast_self(constants.SPELLS.LAY_ON_HANDS)
            return
        end
    end
end