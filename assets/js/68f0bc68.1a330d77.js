"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[329],{66749:e=>{e.exports=JSON.parse('{"functions":[{"name":"RemoteEvent","desc":"Gets a RemoteEvent with the given name.\\nOn the server, if the RemoteEvent does not exist, then\\nit will be created with the given name.\\nOn the client, if the RemoteEvent does not exist, then\\nit will wait until it exists for at least 10 seconds.\\nIf the RemoteEvent does not exist after 10 seconds, an\\nerror will be thrown.\\n```lua\\nlocal remoteEvent = NeoNet:RemoteEvent(\\"PointsChanged\\")\\n```","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"RemoteEvent\\r\\n"}],"function_type":"method","source":{"line":73,"path":"src/NeoNet/init.luau"}},{"name":"RemoteFunction","desc":"Gets a RemoteFunction with the given name.\\nOn the server, if the RemoteFunction does not exist, then\\nit will be created with the given name.\\nOn the client, if the RemoteFunction does not exist, then\\nit will wait until it exists for at least 10 seconds.\\nIf the RemoteFunction does not exist after 10 seconds, an\\nerror will be thrown.\\n```lua\\nlocal remoteFunction = NeoNet:RemoteFunction(\\"GetPoints\\")\\n```","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"RemoteFunction\\r\\n"}],"function_type":"method","source":{"line":104,"path":"src/NeoNet/init.luau"}},{"name":"RemoteValue","desc":"Gets a RemoteValue with the given name.\\nOn the server, if the RemoteValue does not exist, then\\nit will be created with the given name.\\nOn the client, if the RemoteValue does not exist, then\\nit will wait until it exists for at least 10 seconds.\\nIf the RemoteValue does not exist after 10 seconds, an\\nerror will be thrown.\\n```lua\\nlocal remoteValue = NeoNet:RemoteValue(\\"ButtonClicks\\")\\n```","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"value","desc":"","lua_type":"T"}],"returns":[],"function_type":"method","source":{"line":135,"path":"src/NeoNet/init.luau"}},{"name":"GetValue","desc":"Gets the current value of a RemoteValue.\\n```lua\\nprint(NeoNet:GetValue(\\"ButtonClicks\\"), \\"Clicks\\")\\n```","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"any\\r\\n"}],"function_type":"method","source":{"line":179,"path":"src/NeoNet/init.luau"}},{"name":"Fire","desc":"Fires the given RemoteEvent. Will Fire to all clients if used from the server\\n```lua\\nNeoNet:Fire(\\"SomeEvent\\", someParameters, middleware?)\\n```\\n:::tip\\nIf the last parameter is a function then it will use that as middleware\\n:::","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"...","desc":"","lua_type":"any"}],"returns":[],"function_type":"method","source":{"line":196,"path":"src/NeoNet/init.luau"}},{"name":"Setup","desc":"Sets up all the defined RemoteEvents, RemoteFunctions, and RemoteValues.\\n```lua\\nNeoNet:Setup {\\n    RemoteEvents = {\\n        \\"ClickRequest\\"\\n    },\\n    RemoteValues = {\\n        ButtonClicks = 0\\n    }\\n}\\n```\\n    ","params":[{"name":"info","desc":"","lua_type":"RemoteSetupInfo"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":237,"path":"src/NeoNet/init.luau"}},{"name":"FireFor","desc":"Fires the given RemoteEvent to the specified player.\\n```lua\\nNeoNet:FireFor(\\"SomeEvent\\", somePlayer, someParameters, middleware?)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"player","desc":"","lua_type":"Player"},{"name":"...","desc":"","lua_type":"any"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":260,"path":"src/NeoNet/init.luau"}},{"name":"FireExcept","desc":"Fires the given RemoteEvent to all players except the specified player.\\n```lua\\nNeoNet:FireExcept(\\"SomeEvent\\", somePlayer, someParameters, middleware?)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"player","desc":"","lua_type":"Player"},{"name":"...","desc":"","lua_type":"any"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":282,"path":"src/NeoNet/init.luau"}},{"name":"FireList","desc":"Fires the given RemoteEvent to all specified players.\\n\\n```lua\\nNeoNet:FireList(\\"SomeEvent\\", {somePlayer1, somePlayer2}, someParameters, middleware?)\\n```\\n\\n:::caution\\nUses RemoteClientMiddleware for now due to uncertainty\\naround how to handle a list of players for middleware.\\n:::\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"players","desc":"","lua_type":"{Player}"},{"name":"...","desc":"","lua_type":"any"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":310,"path":"src/NeoNet/init.luau"}},{"name":"Connect","desc":"Connects a handler function to the given RemoteEvent.\\n```lua\\n-- Client\\nNeoNet:Connect(\\"PointsChanged\\", function(points)\\n    print(\\"Points\\", points)\\nend)\\n-- Server\\nNeoNet:Connect(\\"SomeEvent\\", function(player, ...) end)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"handler","desc":"","lua_type":"(...any) -> nil"},{"name":"middleware","desc":"","lua_type":"RemoteServerMiddleware"}],"returns":[{"desc":"","lua_type":"RBXScriptConnection\\r\\n"}],"function_type":"method","realm":["Server"],"source":{"line":341,"path":"src/NeoNet/init.luau"}},{"name":"Handle","desc":"Sets the invocation function for the given RemoteFunction.\\n```lua\\nNeoNet:Handle(\\"GetPoints\\", function(player)\\n    return 10\\nend)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"handler","desc":"","lua_type":"(player: Player, ...any) -> ...any"},{"name":"middleware","desc":"","lua_type":"RemoteServerMiddleware"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":364,"path":"src/NeoNet/init.luau"}},{"name":"SetValue","desc":"Sets the value for the given RemoteValue.\\n```lua\\nNeoNet:SetValue(\\"ButtonClicks\\", 0)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"value","desc":"","lua_type":"any"}],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":386,"path":"src/NeoNet/init.luau"}},{"name":"Clean","desc":"Destroys all RemoteEvents and RemoteFunctions. This\\nshould really only be used in testing environments\\nand not during runtime.\\n    ","params":[],"returns":[],"function_type":"method","realm":["Server"],"source":{"line":401,"path":"src/NeoNet/init.luau"}},{"name":"Observe","desc":"Connects a function to the given RemoteValue.\\n```lua\\nNeoNet:Observe(\\"ButtonClicks\\", function(newValue)\\n    print(tostring(newValue) .. \\" Clicks\\")\\nend)\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"handler","desc":"","lua_type":"(any)"},{"name":"middleware","desc":"","lua_type":"RemoteClientMiddleware"}],"returns":[],"function_type":"method","realm":["Client"],"source":{"line":433,"path":"src/NeoNet/init.luau"}},{"name":"Invoke","desc":"Invokes the RemoteFunction with the given arguments.\\n```lua\\nlocal points = NeoNet:Invoke(\\"GetPoints\\")\\n```\\n    ","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"...","desc":"","lua_type":"any"}],"returns":[{"desc":"","lua_type":"...any\\r\\n"}],"function_type":"method","realm":["Client"],"source":{"line":466,"path":"src/NeoNet/init.luau"}}],"properties":[{"name":"Middleware","desc":"For access to the built-in middleware that comes with NeoNet such as RateLimiter and TypeChecker.","lua_type":"{number: ModuleScript}","source":{"line":57,"path":"src/NeoNet/init.luau"}}],"types":[{"name":"RemoteSetupInfo","desc":"The information that should be sent into NeoNet:Setup","lua_type":"{RemoteEvents: {string},RemoteFunctions: {string},RemoteValues: {string: any},}","source":{"line":15,"path":"src/NeoNet/init.luau"}},{"name":"RemoteClientMiddleware","desc":"Type for client middleware. [See how to create your own middleware here.](/docs/CustomMiddleware)","lua_type":"(Parameters: {number: any},) -> (boolean, {number: any})","source":{"line":27,"path":"src/NeoNet/init.luau"}},{"name":"RemoteServerMiddleware","desc":"Type for server middleware. [See how to create your own middleware here.](/docs/CustomMiddleware)","lua_type":"(Player: Player,Parameters: {number: any}) -> (boolean, {number: any})","source":{"line":37,"path":"src/NeoNet/init.luau"}}],"name":"NeoNet","desc":"Based off of \'Net\' by sleitnick with added features\\nsimilar to other networking modules.","source":{"line":8,"path":"src/NeoNet/init.luau"}}')}}]);