local config = {}

config.SPELLS = {
    FORTITUDE = { id = 21562, name = "Power Word: Fortitude", priority = 1 },
    FLASH_HEAL = { id = 2061, name = "Flash Heal", priority = 2 },
    RENEW = { id = 139, name = "Renew", priority = 3 },
    DESPERATE_PRAYER = { id = 19236, name = "Desperate Prayer", priority = 4 },
    BARRIER = { id = 62618, name = "Power Word: Barrier", priority = 5 },
    RAPTURE = { id = 47536, name = "Rapture", priority = 6 },
    SHADOW_WORD_SHIELD = { id = 17, name = "Power Word: Shield", priority = 7 },
    PSYCHIC_SCREAM = { id = 8122, name = "Psychic Scream", priority = 8 },
    MIND_CONTROL = { id = 605, name = "Mind Control", priority = 9 },
    SMITE = { id = 585, name = "Smite", priority = 10 },
    SHADOWFIEND = { id = 34433, name = "Shadowfiend", priority = 11 },
    SCHISM = { id = 214621, name = "Schism", priority = 12 },
    PURIFY = { id = 527, name = "Purify", priority = 13 },
    DISPEL_MAGIC = { id = 527, name = "Dispel Magic", priority = 14 },
    FADE = { id = 213602, name = "Fade", priority = 15 },
    SHADOW_WORD_DEATH = { id = 32379, name = "Shadow Word: Death", priority = 16 }
}

config.DEFAULT_SETTINGS = {
    use_fortitude = true,
    use_flash_heal = true,
    use_renew = true,
    use_desperate_prayer = true,
    use_barrier = true,
    use_rapture = true,
    use_power_word_shield = true,
    use_psychic_scream = true,
    use_mind_control = false,
    use_smite = true,
    use_shadowfiend = true,
    use_schism = true,
    use_purify = true,
    use_dispel_magic = true,
    use_fade = true,
    use_shadow_word_death = true,
    atonement_min = 2
}

config.PVP_SETTINGS = {
    interrupt_threshold = 12,  -- Distance for checking interrupts
    low_health_threshold = 30  -- Health % below which emergency healing triggers
}

return config