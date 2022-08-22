local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NeoNet = require(ReplicatedStorage:WaitForChild("NeoNet"))

NeoNet:Observe("ButtonClicks", function(newValue)
	workspace.Button.BillboardGui.TextLabel.Text = tostring(newValue) .. " Clicks"
end)

workspace.Button.Button.ProximityPrompt.Triggered:Connect(function()
	NeoNet:Fire("ClickRequest")
end)