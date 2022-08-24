---
sidebar_position: 4
---

# Custom Middleware

Custom middleware is very important for all kinds of
things like creating loggers or checks to happen
before a connection runs.

NeoNet makes creating custom middleware very easy, just make a function that returns a boolean.
 This boolean will continue if true, and drop the request if false.
 Obviously that does make it seem simpler than it really is, but here are the types so you
can see how they work in detail.
```lua
type RemoteClientMiddleware = (
    Parameters: {number: any} -- parameters incoming
) -> (boolean, {number: any})
--[[  result,  parameters ourgoing]]

type RemoteServerMiddleware = (
    Player: Player, -- player who fired remote
    Parameters: {number: any} -- parameters incoming
) -> (boolean, {number: any})
--[[  result,  parameters outgoing]]
```
:::tip
If parameters outgoing are nil then NeoNet will automatically send the initial parameters, so
 make sure to return a value other than nil if you want to remove the arguments.
:::
:::caution
For the RemoteServerMiddleware, make sure not to send the player as a parameter because it
 will automatically be the first parameter for the connected function. That's also why the
 incoming parameters are separated from the player.
:::

Inside NeoNet you'll also find a 'TestMiddleware'
object that is very simple:
```lua
return function(player, parameters)
    if parameters then
        print(player.Name, ", test middleware executed")
    else
        print("test middleware executed")
    end
    return true
end
```

But I'll provide another example since you probably
don't plan on adding middleware to print a player's
name every time they fire an event.

## Admin Check

For things like an admin panel, you most likely only
want your admins to be able to fire the events. Here
is some very simple code you might use for this. Also
unlike the two built-in middleware options something
like this can be reused for multiple connections.
```lua
return function(player): RemoteServerMiddleware
    return player:GetRankInGroup(GROUP_ID) >= 250
end
```