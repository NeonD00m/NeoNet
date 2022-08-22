return function(maxRequests: number, isPerSeconds: boolean)--constructor
    if not isPerSeconds then
        maxRequests /= 60
    end

    local lastRequest = 0
    local intervalTime = 1/maxRequests

    return function()--actual middleware
        return lastRequest + intervalTime <= os.clock()
    end
end