--[=[
    NeoNet
    Based off of 'Net' by sleitnick with added features similar to 'Comm'
    Simple yet, provides excellent utility.
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

function NeoNet:GetValue(name: string): any
    if not IsRunning then return end
    local r = self:RemoteValue(name)
    if r then
        return r.Value
    end
end

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
            for _, name in info.RemoteValues do
                NeoNet:RemoteValue(name)
            end
        end
    end

    function NeoNet:Connect(name: string, handler: (...any) -> (), middleware: RemoteServerMiddleware): RBXScriptConnection --add middleware
        if not IsRunning then return end
        return self:RemoteEvent(name).OnServerEvent:Connect(function(player, ...)
            if middleware(player, {...}) then
                handler(player, ...)
            end
        end)
    end

    function NeoNet:Handle(name: string, handler: (player: Player, ...any) -> ...any)--add middleware
        if not IsRunning then return end
        self:RemoteFunction(name).OnServerInvoke = handler
    end

    function NeoNet:SetValue(name: string, value: any)
        if not IsRunning then return end
        local r = self:RemoteValue(name)
        if r and r.Value ~= value then
            r.Value = value
            return r.Event:FireAllClients(value)
        end
    end--add set for, except, and other things

    function NeoNet:Clean()
        script:ClearAllChildren()
    end
else
    --[[
        CLIENT ONLY METHODS
    ]]
    function NeoNet:Connect(name: string, handler: (...any) -> (), middleware: RemoteClientMiddleware): RBXScriptConnection --add middleware
        if not IsRunning then return end
        return self:RemoteEvent(name).OnClientEvent:Connect(function(...)
            if middleware({...}) then
                handler(...)
            end
        end)
    end

    function NeoNet:Observe(name: string, handler: (any))--add middleware
        if not IsRunning then return end
        local r = self:RemoteValue(name)
        handler(r.Value)
        return r.Event.OnClientEvent:Connect(handler)
    end

    function NeoNet:Invoke(name: string, ...: any): ...any--add middleware
        if not IsRunning then return end
        return self:RemoteFunction(name):InvokeServer(...)
    end
end

return NeoNet