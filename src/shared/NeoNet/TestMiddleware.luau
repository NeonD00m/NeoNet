return function(player, parameters)
    if parameters then
        print(player.Name, ", test middleware executed")
    else
        print("test middleware executed")
    end
    return true
end