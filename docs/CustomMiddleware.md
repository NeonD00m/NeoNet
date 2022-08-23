---
sidebar_position: 4
---

# Custom Middleware

Custom middleware is very important for all kinds of
things like creating loggers or checks to happen
before a connection runs.

NeoNet makes creating custom middleware very easy.
Just make a function that returns a boolean.
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
local admins = {
    246288123, --NeonD00m
}

return function(player): RemoteClientMiddleware
    if table.find(admins, player.UserId) then
        return true
    end
    return false
end
```