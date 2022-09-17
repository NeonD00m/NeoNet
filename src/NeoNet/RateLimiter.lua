--!strict
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

    --OR if you want to dynamically change the rate use it like this:
    local limiterInfo = {60, true}
    NeoNet:Connect("SomeEvent", function()
        --do something
    end, RateLimiter(limiterInfo))
    --later/somewhere else
    limiterInfo[1] = 30
    ```

    if you want to create your own middleware check out the docs page on it.
]=]
local function dynamicLimiter(info: {number})
    local lastRequest = 0

    return function()--actual middleware
        local unit = if not info[2] then 60 else 1
        local intervalTime = 1 / (info[1] / unit)

        local result = lastRequest + intervalTime <= os.clock()
        if result then
            lastRequest = os.clock()
        end
        return result
    end
end

return function(maxRequests: number | {number}, isPerSecond: boolean?)--constructor
    if type(maxRequests) == "table" then
        return dynamicLimiter(maxRequests)
    end

    --static limiter
    if not isPerSecond then
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