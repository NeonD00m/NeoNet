<img src="NeoNetLogo.png" align="right"/>

<h1>NeoNet</h1>
<h3>A networking module made to have simple API with advanced utility.</h3>

---

NeoNet is a _networking module_ for Roblox. It simplifies the process of networking in Roblox experiences. Based off of Net (by sleitnick) with added features inspired by Net (by Vorlias). Massive credit goes to both of those libraries.

## Features
- Support for RemoteValues which function very similarly to RemoteProperties from Comm (by sleitnick). Use `GetValue` and `SetValue` to get and set the values, set is only available on the server. The client can also use `Observe` to connect a function to when the value changes.
- NeoNet provides the option to use the API _but also_ provides raw access to remotes for custom usage. Access the actual instances by calling `RemoteEvent` or `RemoteFunction`, and finally `RemoteValue` to get a table with all of the data for the RemoteValue.
- NeoNet comes with middleware for rate-limiting aswell as type-checking, and custom middleware is very easy to create and use.
