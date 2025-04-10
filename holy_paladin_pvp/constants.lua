-- constants.lua

local enums = require("common/enums")
local pvp_helper = require("common/utility/pvp_helper")

local M = {}

-- Class & Spec
M.CLASS_ID = enums.class_id.PALADIN
M.SPEC_ID_HOLY = 65
M.HOLY_POWER_TYPE = 9

-- Spell IDs
M.SPELLS = {
    HOLY_SHOCK = 20473,
    WORD_OF_GLORY = 85673,
    FLASH_OF_LIGHT = 19750,
    BEACON_OF_LIGHT = 53563,
    LIGHT_OF_DAWN = 85222,
    DIVINE_PROTECTION = 498,
    DIVINE_SHIELD = 642,
    AURA_MASTERY = 31821,
    BLESSING_OF_PROTECTION = 1022,
    BLESSING_OF_FREEDOM = 1044,
    CLEANSE_TOXINS = 213644,
    JUDGMENT = 275773,
    HAMMER_OF_JUSTICE = 853,
    LAY_ON_HANDS = 633,
    BLESSING_OF_SACRIFICE = 6940,
}

-- Buff IDs
M.BUFFS = {
    BEACON_OF_LIGHT = 53563,
    DIVINE_PROTECTION = 498,
    DIVINE_SHIELD = 642,
    AURA_MASTERY = 31821,
    BLESSING_OF_FREEDOM = 1044,
    BLESSING_OF_PROTECTION = 1022,
    FORBEARANCE = 25771,
    LIGHTS_HAMMER_GROUND = 126434,
}

-- PvP CC Flags
M.CC_FLAGS = {
    STUN = pvp_helper.cc_flags.STUN,
    SILENCE = pvp_helper.cc_flags.SILENCE,
    ROOT = pvp_helper.cc_flags.ROOT,
    INCAPACITATE = pvp_helper.cc_flags.INCAPACITATE,
    DISORIENT = pvp_helper.cc_flags.DISORIENT,
    FEAR = pvp_helper.cc_flags.FEAR,
    POLYMORPH = pvp_helper.cc_flags.POLYMORPH,
    ANY = pvp_helper.cc_flags.ANY
}

return M
