-- Discipline Priest Rotation - Menu
-- Menu definition and rendering

local core = _G.core
local warrior_core = require("core")
local config = require("config")
local talents = require("utils/talents")
local important_spells = require("important_spells")

-- Create menu module
local menu = {}

-- Function to render the menu
local function render_menu()
    -- Get local references to menu elements for cleaner code
    local menu_elements = warrior_core.menu.elements
    local menu_trees = warrior_core.menu.trees
    local color = require("common/color")

    -- Main menu
    menu_trees.main:render("Discipline Priest Rotation", function()
        -- Enable/disable checkbox
        menu_elements.enable_checkbox:render("Enable/Disable Script")

        -- Keybind for toggling
        core.menu.header():render("Keybind for Toggle:", color.white(200))
        menu_elements.enable_toggle:render("Set Keybind")

        -- Charge settings
        menu_trees.charge:render("Charge Settings", function()
            menu_elements.use_power_word_shield:render("Use Charge")

            if menu_elements.use_power_word_shield:get_state() then
                core.menu.header():render("Charge Distance Range:", color.white(200))
                menu_elements.charge_min_distance:render("Min Distance")
                menu_elements.charge_max_distance:render("Max Distance")
                menu_elements.charge_cooldown:render("Cooldown Threshold")
                menu_elements.charge_priority:render("Prioritize Charge over Leap", "When enabled, Charge will be used before Heroic Leap/Dragon Charge if possible")
                menu_elements.charge_casters:render("Charge to Interrupt Casters")
            end
        end)

        -- Mobility settings (Heroic Leap or Dragon Charge)
        menu_trees.leap:render("Mobility Settings", function()
            menu_elements.use_shadowfiend:render("Use Heroic Leap/Dragon Charge")

            if menu_elements.use_shadowfiend:get_state() then
                -- Show different settings based on whether Dragon Charge is talented
                if warrior_core.state.has_schism then
                    -- Dragon Charge settings
                    core.menu.header():render("Dragon Charge Settings (PvP):", color.green(200))

                    core.menu.header():render("Distance Settings:", color.white(200))
                    menu_elements.schism_min_distance:render("Min Distance", "Minimum distance to use Dragon Charge (higher values prevent using in melee range)")
                    menu_elements.schism_max_distance:render("Max Distance", "Maximum distance to use Dragon Charge")

                    core.menu.header():render("Line Settings:", color.white(200))
                    menu_elements.schism_line_check:render("Use Line Detection", "Enables line detection for Dragon Charge")

                    if menu_elements.schism_line_check:get_state() then
                        menu_elements.schism_min_enemies:render("Min Enemies in Line", "Minimum number of enemies required in line to use Dragon Charge")
                        menu_elements.schism_preferred_mode:render("Preferred Mode", "If enabled, will still use Dragon Charge even if minimum enemies not met")
                    end
                else
                    -- Heroic Leap settings
                    core.menu.header():render("Heroic Leap Settings:", color.white(200))

                    core.menu.header():render("Distance Range:", color.white(200))
                    menu_elements.leap_min_distance:render("Min Distance", "Minimum distance to use Heroic Leap (higher values prevent using in melee range)")
                    menu_elements.leap_max_distance:render("Max Distance", "Maximum distance to use Heroic Leap")
                end

                -- Show talent information
                core.menu.header():render("Talent Detection:", color.white(200))

                -- Display talent status with color indicators
                local bounding_status = warrior_core.state.has_bounding_stride and "Detected" or "Not Detected"
                local bounding_color = warrior_core.state.has_bounding_stride and color.green(200) or color.red(200)
                core.menu.header():render("Bounding Stride: " .. bounding_status, bounding_color)

                local dragon_status = warrior_core.state.has_schism and "Detected" or "Not Detected"
                local dragon_color = warrior_core.state.has_schism and color.green(200) or color.red(200)
                core.menu.header():render("Dragon Charge: " .. dragon_status, dragon_color)

                -- Show effective cooldown
                local effective_cooldown = talents.get_shadowfiend_cooldown()
                core.menu.header():render("Effective Leap Cooldown: " .. tostring(effective_cooldown) .. "s", color.white(200))
            end
        end)

        -- Interrupt settings
        menu_trees.interrupt:render("Interrupt Settings", function()
            menu_elements.use_flash_heal:render("Use Pummel")

            if menu_elements.use_flash_heal:get_state() then
                menu_elements.pummel_dangerous_only:render("Only Interrupt Dangerous Spells")

                -- Important Spells Configuration
                if menu_elements.pummel_dangerous_only:get_state() then
                    -- Render spell categories
                    for category_name, category_tree in pairs(menu_trees.spell_categories) do
                        local spell_ids = menu_elements.spell_category_lists[category_name] or {}

                        if #spell_ids > 0 then
                            category_tree:render(category_name .. " Spells", function()
                                for _, id in ipairs(spell_ids) do
                                    local checkbox = menu_elements.spell_checkboxes[id]
                                    if checkbox then
                                        -- Get spell info
                                        local spell_name = important_spells.get_spell_name(id) or "Unknown"
                                        local cast_time = important_spells.get_spell_cast_time(id) or 0

                                        -- Format tooltip with cast time
                                        local tooltip = string.format("%s (%.1fs cast)", spell_name, cast_time)

                                        -- Render the checkbox with tooltip
                                        checkbox:render(spell_name, tooltip)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end)

        -- Debug settings
        menu_trees.debug:render("Debug Settings", function()
            menu_elements.show_debug:render("Show Debug Messages")
            menu_elements.auto_face_target:render("Auto-Face Target", "When enabled, automatically face target before casting mobility abilities")

            if menu_elements.auto_face_target:get_state() then
                menu_elements.facing_delay:render("Facing Delay", "Delay in seconds after facing target before casting (0 = no delay)")
            end
        end)
    end)
end

-- Check if the enable checkbox state has changed
local function check_enable_checkbox()
    local checkbox = warrior_core.menu.elements.enable_checkbox
    if checkbox then
        local new_state = checkbox:get_state()

        -- Only update if the state has changed
        if new_state ~= warrior_core.state.enabled then
            warrior_core.state.enabled = new_state
            warrior_core.debug_log("Script " .. (new_state and "enabled" or "disabled") .. " via checkbox")
        end
    end
end

-- Check if the keybind has been pressed
local function check_keybind()
    local keybind = warrior_core.menu.elements.enable_toggle
    if not keybind then return end

    local key_pressed = false
    pcall(function()
        key_pressed = core.input.is_key_pressed(keybind:get_key_code())
    end)

    -- Only toggle if key state changed from not pressed to pressed
    if key_pressed and not warrior_core.state.last_key_state then
        -- Toggle the enabled state
        warrior_core.state.enabled = not warrior_core.state.enabled

        -- Update the checkbox to match
        local checkbox = warrior_core.menu.elements.enable_checkbox
        if checkbox then
            checkbox:set(warrior_core.state.enabled)
        end

        warrior_core.debug_log("Script " .. (warrior_core.state.enabled and "enabled" or "disabled") .. " via keybind")
    end

    -- Update last key state
    warrior_core.state.last_key_state = key_pressed
end

-- Initialize the menu
function menu.init_menu()
    -- Create menu elements
    local menu_elements = warrior_core.menu.elements
    local menu_trees = warrior_core.menu.trees

    -- Create tree nodes
    menu_trees.main = core.menu.tree_node()
    menu_trees.charge = core.menu.tree_node()
    menu_trees.leap = core.menu.tree_node()
    menu_trees.interrupt = core.menu.tree_node()
    menu_trees.debug = core.menu.tree_node()

    -- Create main elements
    menu_elements.enable_toggle = core.menu.keybind(0, false, "toggle_warrior_mobility") -- Default to no keybind (0) instead of undefined (999)
    menu_elements.enable_checkbox = core.menu.checkbox(config.DEFAULT_SETTINGS.enable, "enable_warrior_mobility")
    menu_elements.show_debug = core.menu.checkbox(config.DEFAULT_SETTINGS.show_debug, "show_debug")

    -- Facing settings
    menu_elements.auto_face_target = core.menu.checkbox(true, "auto_face_target") -- Default to true for backward compatibility
    menu_elements.facing_delay = core.menu.slider_float(0.0, 0.5, config.CONSTANTS.FACING_DELAY, "facing_delay")

    -- Charge settings
    menu_elements.use_power_word_shield = core.menu.checkbox(config.DEFAULT_SETTINGS.use_power_word_shield, "use_power_word_shield")
    menu_elements.charge_min_distance = core.menu.slider_int(5, 15, config.DEFAULT_SETTINGS.charge_min_distance, "charge_min_distance")
    menu_elements.charge_max_distance = core.menu.slider_int(15, 25, config.DEFAULT_SETTINGS.charge_max_distance, "charge_max_distance")  -- Max 25 yards (game limitation)
    menu_elements.charge_cooldown = core.menu.slider_float(0, 10, config.DEFAULT_SETTINGS.charge_cooldown, "charge_cooldown")
    menu_elements.charge_priority = core.menu.checkbox(config.DEFAULT_SETTINGS.charge_priority, "charge_priority")
    menu_elements.charge_casters = core.menu.checkbox(config.DEFAULT_SETTINGS.charge_casters, "charge_casters")

    -- Heroic Leap settings
    menu_elements.use_shadowfiend = core.menu.checkbox(config.DEFAULT_SETTINGS.use_shadowfiend, "use_shadowfiend")
    menu_elements.leap_min_distance = core.menu.slider_int(5, 15, config.DEFAULT_SETTINGS.leap_min_distance, "leap_min_distance")
    menu_elements.leap_max_distance = core.menu.slider_int(15, 40, config.DEFAULT_SETTINGS.leap_max_distance, "leap_max_distance")  -- Max 40 yards (game limitation)
    menu_elements.leap_cooldown = core.menu.slider_float(0, 10, config.DEFAULT_SETTINGS.leap_cooldown, "leap_cooldown")

    -- Dragon Charge settings (PvP talent)
    menu_elements.schism_line_check = core.menu.checkbox(config.DEFAULT_SETTINGS.schism_line_check, "schism_line_check")  -- Use line detection for Dragon Charge
    menu_elements.schism_min_distance = core.menu.slider_int(8, 15, config.DEFAULT_SETTINGS.schism_min_distance, "schism_min_distance")  -- Minimum distance to use Dragon Charge
    menu_elements.schism_max_distance = core.menu.slider_int(15, 25, config.DEFAULT_SETTINGS.schism_max_distance, "schism_max_distance")  -- Maximum distance to use Dragon Charge
    menu_elements.schism_min_enemies = core.menu.slider_int(1, 5, config.DEFAULT_SETTINGS.schism_min_enemies, "schism_min_enemies")  -- Minimum enemies required in line
    menu_elements.schism_preferred_mode = core.menu.checkbox(config.DEFAULT_SETTINGS.schism_preferred_mode, "schism_preferred_mode")  -- Preferred mode

    -- Interrupt settings
    menu_elements.use_flash_heal = core.menu.checkbox(config.DEFAULT_SETTINGS.use_flash_heal, "use_flash_heal")
    menu_elements.skip_pets = core.menu.checkbox(config.DEFAULT_SETTINGS.skip_pets, "skip_pets")  -- Skip pets when interrupting
    menu_elements.skip_high_dr_targets = core.menu.checkbox(config.DEFAULT_SETTINGS.skip_high_dr_targets, "skip_high_dr_targets")  -- Skip targets with high damage reduction
    menu_elements.pummel_dangerous_only = core.menu.checkbox(config.DEFAULT_SETTINGS.pummel_dangerous_only, "pummel_dangerous_only")

    -- Initialize important spell checkboxes
    menu_elements.spell_checkboxes = {}
    menu_elements.spell_category_lists = {}
    menu_trees.spell_categories = {}

    -- Create tree nodes for spell categories
    local spell_categories = important_spells.SPELL_CATEGORIES
    for _, category_name in pairs(spell_categories) do
        menu_trees.spell_categories[category_name] = core.menu.tree_node()
        menu_elements.spell_category_lists[category_name] = {}
    end

    -- Initialize spell checkboxes for each category
    for spell_id, spell_data in pairs(important_spells.IMPORTANT_SPELLS) do
        local category = spell_data.category
        local enabled = spell_data.enabled

        -- Create checkbox for this spell
        menu_elements.spell_checkboxes[spell_id] = core.menu.checkbox(enabled, "spell_" .. tostring(spell_id))

        -- Add spell ID to the appropriate category list
        if category and menu_elements.spell_category_lists[category] then
            table.insert(menu_elements.spell_category_lists[category], spell_id)
        end
    end

    -- Set initial toggle and checkbox states based on the script state
    if menu_elements.enable_toggle then
        menu_elements.enable_toggle:set_toggle_state(warrior_core.state.enabled)
    end

    if menu_elements.enable_checkbox then
        menu_elements.enable_checkbox:set(warrior_core.state.enabled)
    end

    -- Register callbacks
    core.register_on_render_menu_callback(render_menu)
    core.register_on_update_callback(check_keybind)
    core.register_on_update_callback(check_enable_checkbox)

    -- Expose functions to the menu module
    menu.render_menu = render_menu
    menu.check_keybind = check_keybind
    menu.check_enable_checkbox = check_enable_checkbox
end

return menu

-- Add custom priest specific menu options or abilities here
menu_elements.enable_power_word_fortitude = core.menu.checkbox(true, "Enable Power Word: Fortitude")
menu_elements.enable_dispel_magic = core.menu.checkbox(true, "Enable Dispel Magic")
