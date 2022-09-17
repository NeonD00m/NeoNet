local NeoNet = require(game:GetService("ReplicatedStorage"):WaitForChild("NeoNet"))
local RateLimiter = require(NeoNet.Middleware.RateLimiter)

-- setup for ClickRequest isn't necessary because we connect immediately, however ButtonClicks needs an inital value in this case
NeoNet:RemoteEvent("ClickRequest")
NeoNet:RemoteValue("ButtonClicks", 0)

NeoNet:Connect("ClickRequest", function()
	NeoNet:SetValue("ButtonClicks", NeoNet:GetValue("ButtonClicks") + 1)
end, RateLimiter(0.5, true))