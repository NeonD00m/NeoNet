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