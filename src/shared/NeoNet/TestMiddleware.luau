return function(player, parameters)
    if parameters then
        print(player.Name, ", test middleware executed")
    else
        print("test middleware executed")
    end
    return true
end

--[[
local GROUP_ID = 2664663

return function(player)
    return player:GetRankInGroup(GROUP_ID) >= 250
end
]]