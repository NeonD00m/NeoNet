--!strict
--[=[
    @class TypeChecker

    :::tip
    This should be constructed for each connection,
    or each connection with the same types.
    :::

    Constructs a middleware function with the settings you select.
    ```lua
    local newChecker = TypeChecker({"string", "number"})
    --Or use it like this:
    NeoNet:Connect("SomeEvent", function()
        --do something
    end, TypeChecker{"string", "number"})
    ```

    if you want to create your own middleware check out the docs page on it.
]=]
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