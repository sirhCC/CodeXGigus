-- Holy Paladin PvP Config

local config = {}

config.VERSION = "1.0.0"

config.SPELLS = {
    WORD_OF_GLORY = { id = 85673, name = "Word of Glory" },
    FLASH_OF_LIGHT = { id = 19750, name = "Flash of Light" },
    HOLY_SHOCK = { id = 20473, name = "Holy Shock" },
    CLEANSE = { id = 4987, name = "Cleanse" },
    LAY_ON_HANDS = { id = 633, name = "Lay on Hands" },
    AVENGING_WRATH = { id = 31884, name = "Avenging Wrath" },
}

config.CONSTANTS = {
    HEAL_CHECK_INTERVAL = 0.2,
    EMERGENCY_THRESHOLD = 40,
    NORMAL_THRESHOLD = 80
}

config.DEFAULT_SETTINGS = {
    enable = false,
    show_debug = true,
    use_cleanse = true,
    use_wings = true,
    emergency_threshold = 40,
    normal_heal_threshold = 80
}

return config
