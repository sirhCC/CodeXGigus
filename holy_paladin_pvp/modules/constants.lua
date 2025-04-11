local enums = require("common/enums")
local pvp_helper = require("common/utility/pvp_helper")

local M = {}

-- Class & Spec
M.CLASS_ID = enums.class_id.PALADIN
M.SPEC_ID_HOLY = 65
M.HOLY_POWER_TYPE = 9
M.POWER_HOLY_POWER = 9

-- Spell IDs
M.SPELLS = {
    HOLY_SHOCK = 20473,
    WORD_OF_GLORY = 85673,
    FLASH_OF_LIGHT = 19750,
    BEACON_OF_LIGHT = 53563,
    BEACON_OF_FAITH = 156910,
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
    CRUSADER_STRIKE = 35395,
    REPENTANCE = 20066,
}

-- Buff IDs
M.BUFFS = {
    BEACON_OF_LIGHT = 53563,
    BEACON_OF_FAITH = 156910,
    DIVINE_PROTECTION = 498,
    DIVINE_SHIELD = 642,
    AURA_MASTERY = 31821,
    BLESSING_OF_FREEDOM = 1044,
    BLESSING_OF_PROTECTION = 1022,
    FORBEARANCE = 25771,
    LIGHTS_HAMMER_GROUND = 126434,
    LIGHTS_CELERITY = 425315,
    POWER_OF_THE_SILVER_HAND = 425299,
    AVENGING_WRATH = 31884,
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

-- Spec IDs
M.SPEC_IDS = {
    FIRE_MAGE = 63,
    SUB_ROGUE = 261,
    SHADOW_PRIEST = 258,
    RESTO_DRUID = 105,
    HOLY_PRIEST = 257,
    ARMS_WARRIOR = 71,
    RET_PALADIN = 70,
}

return M