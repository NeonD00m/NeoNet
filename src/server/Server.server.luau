local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NeoNet = require(ReplicatedStorage:WaitForChild("NeoNet"))
local RateLimiter = require(NeoNet.Middleware.RateLimiter)

NeoNet:Setup {
	RemoteEvents = {
		"ClickRequest"
	},
	RemoteValues = {
		ButtonClicks = 0
	}
}
NeoNet:RemoteEvent("ClickRequest")
NeoNet:RemoteValue("ButtonClicks", 0)

NeoNet:Connect("ClickRequest", function()
	NeoNet:SetValue("ButtonClicks", NeoNet:GetValue("ButtonClicks") + 1)
end, RateLimiter(0.5, true))

--[[
NeoNet:Connect("someEvent", function()
	--this connection can only run once a second because of the RateLimiter
end, RateLimiter(1, true))

NeoNet:Connect("someEvent", function(someValue1: string, someValue: number)
	--this connection uses a TypeChecker to verify types
end, TypeChecker{"string", "number})

--Server-only middleware
NeoNet:Connect("someEvent", function(admin: Player)
	--this connection uses custom middleware
end, function(player) --custom middleware to only let an admin fire
	return player.UserId = 246288123
end)
]]