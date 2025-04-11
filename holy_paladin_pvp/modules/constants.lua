-- modules/constants.lua

local buff_db = require("common/spell_data/buff_db")

local constants = {}

constants.spells = {
    HOLY_SHOCK = 20473,
    WORD_OF_GLORY = 85673,
    FLASH_OF_LIGHT = 19750,
    LIGHT_OF_DAWN = 85222,
    LAY_ON_HANDS = 633,
    HAMMER_OF_JUSTICE = 853,
    REPENTANCE = 20066,
    AVENGING_WRATH = 31884,
    BEACON_OF_LIGHT = 53563,
    BLESSING_OF_SACRIFICE = 6940,
    BLESSING_OF_PROTECTION = 1022,
    DIVINE_SHIELD = 642,
    CLEANSE = 4987
}

constants.buffs = {
    BEACON_OF_LIGHT = buff_db.BEACON_OF_LIGHT,
    AVENGING_WRATH = buff_db.AVENGING_WRATH,
    DIVINE_PURPOSE = buff_db.DIVINE_PURPOSE
}

return constants
