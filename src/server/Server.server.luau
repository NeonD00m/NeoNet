local NeoNet = require(game:GetService("ReplicatedStorage"):WaitForChild("NeoNet"))
local RateLimiter = require(NeoNet.Middleware.RateLimiter)
--[[None of this setup is necessary because we connect immediately:
NeoNet:Setup {
	RemoteEvents = {
		"ClickRequest"
	},
	RemoteValues = {
		ButtonClicks = 0
	}
}
--Or do them one-by-one
NeoNet:RemoteEvent("ClickRequest")]]
NeoNet:RemoteValue("ButtonClicks", 0)

NeoNet:Connect("ClickRequest", function()
	NeoNet:SetValue("ButtonClicks", NeoNet:GetValue("ButtonClicks") + 1)
end, RateLimiter(0.5, true))