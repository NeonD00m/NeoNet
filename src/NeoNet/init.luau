--!strict
--[=[
    @class NeoNet

    Based off of 'Net' by sleitnick with added features
    similar to other networking modules.
]=]

--[=[
    @within NeoNet
    @type RemoteSetupInfo {RemoteEvents: {string},RemoteFunctions: {string},RemoteValues: {string: any},}

    The information that should be sent into NeoNet:Setup
]=]
export type RemoteSetupInfo = {
    RemoteEvents: {string}?,
    RemoteFunctions: {string}?,
    RemoteValues: {string: any}?,
}

--[=[
    @within NeoNet
    @type RemoteClientMiddleware (Parameters: {number: any},) -> (boolean, {number: any})

    Type for client middleware. [See how to create your own middleware here.](/docs/CustomMiddleware)
]=]
export type RemoteClientMiddleware = (
    Parameters: {number: any}?
) -> (boolean, {number: any}?)

--[=[
    @within NeoNet
    @type RemoteServerMiddleware (Player: Player,Parameters: {number: any}) -> (boolean, {number: any})

    Type for server middleware. [See how to create your own middleware here.](/docs/CustomMiddleware)
]=]
export type RemoteServerMiddleware = (
    Player: Player,
    Parameters: {number: any}?
) -> (boolean, {number: any}?)

local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()
local IsRunning = RunService:IsRunning()

local RemoteValues = {}
local NeoNet = {
    Parent = script,
    Middleware = script,--so you can do NeoNet.Middleware.TestMiddleware
}

--[=[
    @prop Middleware {number: ModuleScript}
    @within NeoNet

    For access to the built-in middleware that comes with NeoNet such as RateLimiter and TypeChecker.
]=]

--[[
    CLIENT & SERVER METHODS
]]
--[=[
    This method is only intended to be used for combining with/adapting to other systems or to organize your remotes in a more accessible place.
	:::caution
    It will make NeoNet unable to access remotes created without calling UseParent with the same Parent in the other scripts.
    :::
    Example case:
    \/ReplicatedStorage
       \/Remotes
          PointsChanged
	```lua
	NeoNet:UseParent(ReplicatedStorage.Remotes)
	local remoteEvent = NeoNet:RemoteEvent("PointsChanged")
	```
]=]
function NeoNet:UseParent(parent: Instance): RemoteEvent
    NeoNet.Parent = if typeof(parent) == "userdata" then parent else script
end

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
		local r = NeoNet.Parent:FindFirstChild(name)
		if not r then
			r = Instance.new("RemoteEvent")
			r.Name = name
			r.Parent = script
		end
		return r
	else
		local r = NeoNet.Parent:WaitForChild(name, 10)
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
		local r = NeoNet.Parent:FindFirstChild(name)
		if not r then
			r = Instance.new("RemoteFunction")
			r.Name = name
			r.Parent = NeoNet.Parent
		end
		return r
	else
		local r = NeoNet.Parent:WaitForChild(name, 10)
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
function NeoNet:RemoteValue<T>(name: string, value: T)
    name = "RV/" .. name
    if IsServer then
        local r = NeoNet.Parent:FindFirstChild(name)
        if not r then
            r = Instance.new("RemoteEvent")
            r.Name = name
            r.Parent = NeoNet.Parent
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
        local r = NeoNet.Parent:WaitForChild(name, 10)
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
    Fires the given RemoteEvent. Will Fire to all clients if used from the server
    ```lua
    NeoNet:Fire("SomeEvent", someParameters, middleware?)
    ```
    :::tip
    If the last parameter is a function then it will use that as middleware
    :::
]=]
function NeoNet:Fire(name: string, ...: any)
    if not IsRunning then return end
    local params1 = {...}
    local lastArg = params1[#params1]
    if type(lastArg) == "function" then
        table.remove(params1, #params1)
        local result, params2 = lastArg(params1)
        if result then
            if IsServer then
                self:RemoteEvent(name):FireAllClients(if params2 then table.unpack(params2) else ...)
            else
                self:RemoteEvent(name):FireServer(if params2 then table.unpack(params2) else ...)
            end
        end
    else
        if IsServer then
            self:RemoteEvent(name):FireAllClients(...)
        else
            self:RemoteEvent(name):FireServer(...)
        end
    end
end--add fire for, except, and other things

--[=[
    Connects a handler function to the given RemoteEvent and disconnects after the first event.
    :::caution
    If the middleware drops the request it will still be disconnected, use NeoNet:ConnectUntil if you want to only disconnect after middleware passes an event.
    :::
    ```lua
    NeoNet:ConnectOnce("SomeEvent", function(...) end)
    ```
]=]
function NeoNet:ConnectOnce(name: string, handler: (...any) -> nil, middleware: RemoteServerMiddleware | RemoteClientMiddleware)
    local connection = nil
    connection = self:Connect(name, function(player, ...)
        connection:Disconnect()
        if IsServer then
            if middleware then
                local result, params = middleware(player, {...})
                if result then
                    handler(player, if params then table.unpack(params) else ...)
                end
            else
                handler(...)
            end
        else
            if middleware then
                local result, params = middleware({player, ...})
                if result then
                    handler(player, if params then table.unpack(params) else ...)
                end
            else
                handler(...)
            end
        end
    end)
end

--[=[
    Connects a handler function to the given RemoteEvent and disconnects after the first event that passes the middleware.
    (Similar to :ConnectOnce but it only disconnects after the middleware has continued a request.)
    ```lua
    NeoNet:ConnectUntil("SomeEvent", function(...) end, someMiddleware)
    ```
]=]
function NeoNet:ConnectUntil(name: string, handler: (...any) -> nil, middleware: RemoteServerMiddleware | RemoteClientMiddleware)
    local connection = nil
    connection = self:Connect(name, function(...)
        connection:Disconnect()
        handler(...)
    end, middleware)
end

if IsServer then
    --[[
        SERVER ONLY METHODS
    ]]
    --[=[
        @server
        :::caution
        deprecated (as of v1.2.0) or something please don't use;
        this type of setup was exactly what I wanted to avoid with NeoNet
        :::
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
    -- ]=]
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
        @server
        Fires the given RemoteEvent to the specified player.
        ```lua
        NeoNet:FireFor("SomeEvent", somePlayer, someParameters, middleware?)
        ```
    ]=]
    function NeoNet:FireFor(name: string, player: Player, ...: any)
        if not IsRunning then return end
        local params1 = {...}
        local lastArg = params1[#params1]
        if type(lastArg) == "function" then
            table.remove(params1, #params1)
            local result, params2 = lastArg(params1)
            if result then
                self:RemoteEvent(name):FireClient(player, if params2 then table.unpack(params2) else ...)
            end
        else
            self:RemoteEvent(name):FireClient(player, ...)
        end
    end

    --[=[
        @server
        Fires the given RemoteEvent to all players except the specified player.
        ```lua
        NeoNet:FireExcept("SomeEvent", somePlayer, someParameters, middleware?)
        ```
    ]=]
    function NeoNet:FireExcept(name: string, player: Player, ...: any)
        if not IsRunning then return end
        local params1 = {...}
        local lastArg = params1[#params1]
        if type(lastArg) == "function" then
            table.remove(params1, #params1)
            local result, params2 = lastArg(params1)
            if result then
                self:RemoteEvent(name):FireExcept(player, if params2 then table.unpack(params2) else ...)
            end
        else
            self:RemoteEvent(name):FireExcept(player, ...)
        end
    end

    --[=[
        @server
        Fires the given RemoteEvent to all specified players.

        ```lua
        NeoNet:FireList("SomeEvent", {somePlayer1, somePlayer2}, someParameters, middleware?)
        ```

        :::caution
        Uses RemoteClientMiddleware for now due to uncertainty
        around how to handle a list of players for middleware.
        :::
    ]=]
    function NeoNet:FireList(name: string, players: {Player}, ...: any)
        if not IsRunning then return end
        local params1 = {...}
        local lastArg = params1[#params1]
        if type(lastArg) == "function" then
            table.remove(params1, #params1)
            local result, params2 = lastArg(params1)
            if result then
                for _, player in players do
                    self:RemoteEvent(name):FireClient(player, if params2 then table.unpack(params2) else ...)
                end
            end
        else
            for _, player in players do
                self:RemoteEvent(name):FireClient(player, ...)
            end
        end
    end

    --[=[
        @server
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
    function NeoNet:Connect(name: string, handler: (...any) -> nil, middleware: RemoteServerMiddleware): RBXScriptConnection
        if not IsRunning then return end
        return self:RemoteEvent(name).OnServerEvent:Connect(function(player, ...)
            if middleware then
                local result, params = middleware(player, {...})
                if result then
                    handler(player, if params then table.unpack(params) else ...)
                end
            else
                handler(...)
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
    function NeoNet:Handle(name: string, handler: (player: Player, ...any) -> ...any, middleware: RemoteServerMiddleware)
        if not IsRunning then return end
        -- self:RemoteFunction(name).OnServerInvoke = handler
        self:RemoteFunction(name).OnServerInvoke = function(player, ...)
            if middleware then
                local result, params = middleware(player, {...})
                if result then
                    return handler(player, if params then table.unpack(params) else ...)
                end
            else
                return handler(player, ...)
            end
        end
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
        local r = self:RemoteValue(name, value)
        if r and r.Value ~= value then
            r.Value = value
            r.Event:FireAllClients(value)
        end
    end--add set for, except, and other things

    --[=[
        @server
        Destroys all RemoteEvents and RemoteFunctions. This
        should really only be used in testing environments
        and not during runtime.
    ]=]
    function NeoNet:Clean()
        NeoNet.Parent:ClearAllChildren()
        table.clear(RemoteValues)
    end
else
    --[[
        CLIENT ONLY METHODS
    ]]
    --moonwave documentation is on the server version of this method
    function NeoNet:Connect(name: string, handler: (...any) -> nil, middleware: RemoteClientMiddleware): RBXScriptConnection
        if not IsRunning then return end
        return self:RemoteEvent(name).OnClientEvent:Connect(function(...)
            if middleware then
                local result, params = middleware({...})
                if result then
                    handler(if params then table.unpack(params) else ...)
                end
            else
                handler(...)
            end
        end)
    end

    --[=[
        @client
        Connects a function to the given RemoteValue, which will be called each time the value changes + when initially observed.
        ```lua
        NeoNet:Observe("ButtonClicks", function(newValue)
            print(tostring(newValue) .. " Clicks")
        end)
        ```
    ]=]
    function NeoNet:Observe(name: string, handler: (any), middleware: RemoteClientMiddleware)
        if not IsRunning then return end
        local r = self:RemoteValue(name)

        --initial value
        if middleware then
            local result, params = middleware({r})
            if result then
                handler(if params then table.unpack(params) else r)
            end
        else
            handler(r)
        end

        return r.Event.OnClientEvent:Connect(function(...)
            if middleware then
                local result, params = middleware({...})
                if result then
                    handler(if params then table.unpack(params) else ...)
                end
            else
                handler(...)
            end
        end)
    end

    --[=[
        @client
        Invokes the RemoteFunction with the given arguments.
        ```lua
        local points = NeoNet:Invoke("GetPoints")
        ```
    ]=]
    function NeoNet:Invoke(name: string, ...: any): ...any
        if not IsRunning then return end
        -- return self:RemoteFunction(name):InvokeServer(...)
        local lastArg = {...}
        lastArg = lastArg[#lastArg]
        if type(lastArg) == "function" then
            local result, params = lastArg({...})
            if result then
                return self:RemoteFunction(name):InvokeServer(if params then table.unpack(params) else ...)
            end
            --else request dropped by middleware
        else
            return self:RemoteFunction(name):InvokeServer(...)
        end
    end
end

return NeoNet