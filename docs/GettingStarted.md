---
sidebar_position: 3
---

# Getting Started

Here's how you can use NeoNet for a project.

First, on the server just require NeoNet through wally's packages or another location.
```lua
local NeoNet = require(game:GetService("ReplicatedStorage").Packages.NeoNet)
```

Then, here is an example of what it might look like to set up each type of remote in your game, with [`:Setup`](/api/NeoNet#Setup) and without.
[`:Setup`](/api/NeoNet#Setup) is probably worse in most cases, but if you have enough remotes or have the [`RemoteSetupInfo`](/api/NeoNet#RemoteSetupInfo) as a module it could be useful.
```lua
NeoNet:Setup {
	RemoteEvents = {
		"SomeEvent"
	},
	RemoteFunctions = {
		"SomeFunction"
	},
	RemoteValues = {
		SomeValue = 0
	}
}
--Or like this:
NeoNet:RemoteEvent("SomeEvent")
Neonet:RemoteFunction("SomeFunction")
NeoNet:RemoteValue("SomeValue", 0)
```

Then, make your connections and fires.
```lua title="init.server.lua"
--RemoteEvent
NeoNet:Fire("SomeEvent") --client/server
NeoNet:Connect("SomeEvent", function() --client/server
    --do something
end)

--RemoteFunction
local data = NeoNet:Invoke("SomeFunction") --only client
NeoNet:Handle("SomeFunction", function() --only server
    --return data
end)

--RemoteValue
NeoNet:SetValue("SomeValue", aValue) --only server
NeoNet:Observe("SomeValue", function(newValue) --only client
    --do something
end)
```

## Next steps
You should dive in to the [API reference](/api/NeoNet)!

More progress for the documentation will be written eventually as currently, there are some undocumented behaviors and pages that just need more work.