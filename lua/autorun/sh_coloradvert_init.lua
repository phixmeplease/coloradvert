coloradvert = {}
coloradvert.color = Color(255, 0, 191)
coloradvert.textcolor = Color(255, 255, 0)
coloradvert.prefix = "(Advert) "

if (SERVER) then
    util.AddNetworkString("RecieveColorAdvert")
else
    net.Receive("RecieveColorAdvert", function()
        local ply = net.ReadEntity()
        if (!ply) then return end

        local text = net.ReadString()
        if (!text) then return end

        chat.AddText(coloradvert.color, coloradvert.prefix, ply:Nick() .. ": ", coloradvert.textcolor, text)
    end)
end

local function load()
    if (not DarkRP) then
        MsgC(Color(255, 0, 0), "DarkRP is not loaded. Failed to load ColorAdvert by lion!")
        return
    end

    -- Remove the old DarkRP commands
    DarkRP.removeChatCommand("advert")

    DarkRP.declareChatCommand({
        command = "advert",
        description = "Announces a roleplay message in chat for everyone to see.",
        delay = 1,
    })

    if (SERVER) then
        DarkRP.defineChatCommand("advert", function(ply, args)
            if (args == "") then
                ply:ChatPrint("Please supply some arguments.")
                return
            end
            local say = function(t)
                if (t == "") then
                    ply:ChatPrint("Please supply some arguments.")
                    return
                end
                net.Start("RecieveColorAdvert")
                net.WriteEntity(ply)
                net.WriteString(t)
                net.Broadcast()
            end
            hook.Call("playerAdverted", nil, ply, args) -- bLogs support
            return args, say
        end, 1)
    end
end

if (DarkRP) then
    load()
else
    hook.Add("PlayerInitalSpawn", "ColorAdvert", load)
end