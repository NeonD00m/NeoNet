--[=[
    @class RateLimiter

    :::tip
    This should be constructed for each connection.
    :::

    Constructs a middleware function with the settings you select.
    ```lua
    local newLimiter = Ratelimiter(60, true)
    --Or use it like this:
    NeoNet:Connect("SomeEvent", function()
        --do something
    end, RateLimiter(0.5, true))
    ```
]=]
return function(maxRequests: number, isPerSeconds: boolean)--constructor
    if not isPerSeconds then
        maxRequests /= 60
    end

    local lastRequest = 0
    local intervalTime = 1 / maxRequests

    return function()--actual middleware
        local result = lastRequest + intervalTime <= os.clock()
        if result then
            lastRequest = os.clock()
        end
        return result
    end
end