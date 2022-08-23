"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[723],{1550:e=>{e.exports=JSON.parse('{"functions":[],"properties":[],"types":[],"name":"RateLimiter","desc":":::tip\\nThis should be constructed for each connection.\\n:::\\n\\nConstructs a middleware function with the settings you select.\\n```lua\\nlocal newLimiter = Ratelimiter(60, true)\\n--Or use it like this:\\nNeoNet:Connect(\\"SomeEvent\\", function()\\n    --do something\\nend, RateLimiter(0.5, true))\\n```\\n\\nif you want to create your own middleware check out the docs page on it.","source":{"line":19,"path":"src/shared/NeoNet/RateLimiter.luau"}}')}}]);