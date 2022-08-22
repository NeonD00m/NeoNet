--[=[
    @class NeoNet

    Based off of 'Net' by sleitnick with added features
    similar to other networking modules.
]=]

export type RemoteSetupInfo = {
    RemoteEvents: {string},
    RemoteFunctions: {string},
    RemoteValues: {string: any},
}

export type RemoteClientMiddleware = (
    Parameters: {number: any}
) -> (boolean)

export type RemoteServerMiddleware = (
    Player: Player,
    Parameters: {number: any}
) -> (boolean)

local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()
local IsRunning = RunService:IsRunning()

local NeoNet = {
    Middleware = script,--so you can do NeoNet.Middleware.TestMiddleware
}
local RemoteValues = {}

--[[
    CLIENT & SERVER METHODS
]]

--[=[
	Gets a RemoteEvent with the given name.
	On the server, if the RemoteEvent does not exist, then
	it will be created with the given name.
	On the client, if the RemoteEvent does not exist, then
	it will wait until it exists for at least 10 seconds.
	If the RemoteEvent does not exist after 10 seconds, an
	error will be thrown.
	```lua
	local remoteEvent = NeoNet:RemoteEvent("PointsChanged")
	```
]=]
function NeoNet:RemoteEvent(name: string): RemoteEvent
    name = "RE/" .. name
    if IsServer then
		local r = script:FindFirstChild(name)
		if not r then
			r = Instance.new("RemoteEvent")
			r.Name = name
			r.Parent = script
		end
		return r
	else
		local r = script:WaitForChild(name, 10)
		if not r then
			error("Failed to find RemoteEvent: " .. name, 2)
		end
		return r
	end
end

--[=[
	Gets a RemoteFunction with the given name.
	On the server, if the RemoteFunction does not exist, then
	it will be created with the given name.
	On the client, if the RemoteFunction does not exist, then
	it will wait until it exists for at least 10 seconds.
	If the RemoteFunction does not exist after 10 seconds, an
	error will be thrown.
	```lua
	local remoteFunction = NeoNet:RemoteFunction("GetPoints")
	```
]=]
function NeoNet:RemoteFunction(name: string): RemoteFunction
    name = "RF/" .. name
    if IsServer then
		local r = script:FindFirstChild(name)
		if not r then
			r = Instance.new("RemoteFunction")
			r.Name = name
			r.Parent = script
		end
		return r
	else
		local r = script:WaitForChild(name, 10)
		if not r then
			error("Failed to find RemoteFunction: " .. name, 2)
		end
		return r
	end
end

--[=[
	Gets a RemoteValue with the given name.
	On the server, if the RemoteValue does not exist, then
	it will be created with the given name.
	On the client, if the RemoteValue does not exist, then
	it will wait until it exists for at least 10 seconds.
	If the RemoteValue does not exist after 10 seconds, an
	error will be thrown.
	```lua
	local remoteValue = NeoNet:RemoteValue("ButtonClicks")
	```
]=]
function NeoNet:RemoteValue(name: string, value: any)
    name = "RV/" .. name
    if IsServer then
        local r = script:FindFirstChild(name)
        if not r then
            r = Instance.new("RemoteEvent")
            r.Name = name
            r.Parent = script
            RemoteValues[name] = {
                Event = r,
                Value = value,
                _connection = r.OnServerEvent:Connect(function(player)
                    r:FireClient(player, RemoteValues[name].Value)
                end)
            }
        end
        return RemoteValues[name]
    else
        local r = script:WaitForChild(name, 10)
		if not r then
			error("Failed to find RemoteValue: " .. name, 2)
		end
        if not RemoteValues[name] then
            RemoteValues[name] = {
                Event = r,
                Value = value,
                _connection = r.OnClientEvent:Connect(function(newValue)
                    RemoteValues[name].Value = newValue
                end)
            }
            r:FireServer()--ask server for current value
        end
		return RemoteValues[name]
    end
end

--NeoNet:Connect had to be separated for Middleware typing

--[=[
	Gets the current value of a RemoteValue.
	```lua
	print(NeoNet:GetValue("ButtonClicks"), "Clicks")
	```
]=]
function NeoNet:GetValue(name: string): any
    if not IsRunning then return end
    local r = self:RemoteValue(name)
    if r then
        return r.Value
    end
end

--[=[
	Fires the given RemoteEvent.
	```lua
	NeoNet:Fire("SomeEvent", someParameters)
	```
]=]
function NeoNet:Fire(name: string, ...: any)
    if not IsRunning then return end
    if IsServer then
        self:RemoteEvent(name):FireAllClients(...)
    else
        self:RemoteEvent(name):FireServer(...)
    end
end--add fire for, except, and other things

if IsServer then
    --[[
        SERVER ONLY METHODS
    ]]

    --[=[
        @server
        Sets up all the defined RemoteEvents, RemoteFunctions, and RemoteValues.
        ```lua
        NeoNet:Setup {
            RemoteEvents = {
                "ClickRequest"
            },
            RemoteValues = {
                ButtonClicks = 0
            }
        }
        ```
    ]=]
    function NeoNet:Setup(info: RemoteSetupInfo)
        if info and info.RemoteEvents then
            for _, name in info.RemoteEvents do
                NeoNet:RemoteEvent(name)
            end
        elseif info and info.RemoteFunctions then
            for _, name in info.RemoteFunctions do
                NeoNet:RemoteFunction(name)
            end
        elseif info and info.RemoteValues then
            for name, value in info.RemoteValues do
                NeoNet:RemoteValue(name, value)
            end
        end
    end

    --[=[
        Connects a handler function to the given RemoteEvent.
        ```lua
        -- Client
        NeoNet:Connect("PointsChanged", function(points)
            print("Points", points)
        end)
        -- Server
        NeoNet:Connect("SomeEvent", function(player, ...) end)
        ```
    ]=]
    function NeoNet:Connect(name: string, handler: (...any) -> (), middleware: RemoteServerMiddleware): RBXScriptConnection --add middleware
        if not IsRunning then return end
        return self:RemoteEvent(name).OnServerEvent:Connect(function(player, ...)
            if not middleware or middleware({...}) then
                handler(player, ...)
            end
        end)
    end

    --[=[
        @server
        Sets the invocation function for the given RemoteFunction.
        ```lua
        NeoNet:Handle("GetPoints", function(player)
            return 10
        end)
        ```
    ]=]
    function NeoNet:Handle(name: string, handler: (player: Player, ...any) -> ...any)--add middleware
        if not IsRunning then return end
        self:RemoteFunction(name).OnServerInvoke = handler
    end

    --[=[
        @server
        Sets the value for the given RemoteValue.
        ```lua
        NeoNet:SetValue("ButtonClicks", 0)
        ```
    ]=]
    function NeoNet:SetValue(name: string, value: any)
        if not IsRunning then return end
        local r = self:RemoteValue(name)
        if r and r.Value ~= value then
            r.Value = value
            return r.Event:FireAllClients(value)
        end
    end--add set for, except, and other things

    --[=[
        @server
        Destroys all RemoteEvents and RemoteFunctions. This
        should really only be used in testing environments
        and not during runtime.
    ]=]
    function NeoNet:Clean()
        script:ClearAllChildren()
        table.clear(RemoteValues)
    end
else
    --[[
        CLIENT ONLY METHODS
    ]]

    --moonwave documentation is on the server version of this method
    function NeoNet:Connect(name: string, handler: (...any) -> (), middleware: RemoteClientMiddleware): RBXScriptConnection --add middleware
        if not IsRunning then return end
        return self:RemoteEvent(name).OnClientEvent:Connect(function(...)
            if not middleware or middleware({...}) then
                handler(...)
            end
        end)
    end

    --[=[
        @client
        Connects a function to the given RemoteValue.
        ```lua
        NeoNet:Observe("ButtonClicks", function(newValue)
            print(tostring(newValue) .. " Clicks")
        end)
        ```
    ]=]
    function NeoNet:Observe(name: string, handler: (any))--add middleware
        if not IsRunning then return end
        local r = self:RemoteValue(name)
        handler(r.Value)
        return r.Event.OnClientEvent:Connect(handler)
    end

    --[=[
        @client
        Invokes the RemoteFunction with the given arguments.
        ```lua
        local points = NeoNet:Invoke("GetPoints")
        ```
    ]=]
    function NeoNet:Invoke(name: string, ...: any): ...any--add middleware
        if not IsRunning then return end
        return self:RemoteFunction(name):InvokeServer(...)
    end
end

return NeoNet