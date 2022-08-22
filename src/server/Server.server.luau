local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NeoNet = require(ReplicatedStorage:WaitForChild("NeoNet"))
local RateLimiter = require(NeoNet.Middleware.RateLimiter)

-- NeoNet:Setup {
-- 	RemoteEvents = {
-- 		"ClickRequest"
-- 	},
-- 	RemoteValues = {
-- 		"ButtonClicks"
-- 	}
-- }
NeoNet:RemoteEvent("ClickRequest")
NeoNet:RemoteValue("ButtonClicks", 0)

NeoNet:Connect("ClickRequest", function()
	NeoNet:SetValue("ButtonClicks", NeoNet:GetValue("ButtonClicks") + 1)
end, RateLimiter(0.5, true))