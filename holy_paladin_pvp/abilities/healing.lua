local healing = {}

function healing.is_alive(unit)
    return unit and unit:is_valid() and not unit:is_dead()
end

return healing
