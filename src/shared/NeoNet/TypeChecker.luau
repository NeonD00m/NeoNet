return function(types: {number: string})--constructor
    return function(player, parameters)--actual middleware
        if not parameters then
            parameters = player
        end
        --types: {string, number}
        --params:{"hello", 78}
        for key, value in parameters do
            if typeof(value) ~= types[key] then
                return false
            end
        end

        return true --success if no incorrect types found
    end
end