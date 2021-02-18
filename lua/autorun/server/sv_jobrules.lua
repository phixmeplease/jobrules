util.AddNetworkString("JobRules.SendOpenRules")
util.AddNetworkString("JobRules.SendOpenReport")
util.AddNetworkString("JobRules.StopSendingMeYouStupid")
hook.Add("PlayerSay", "JobRules_Commands", function(ply, text)
    if (string.lower(text) == "/hidejobrules") then
        ply:SetPData("jobrules_hasdisabled", true)
        ply:ChatPrint("Disabled Job Rules! To make it appear again do /allowjobrules")
        return ""
    end

    if (string.lower(text) == "/allowjobrules") then
        ply:SetPData("jobrules_hasdisabled", false)
        ply:ChatPrint("Disabled Job Enabled! To make it hide again do /hidejobrules")
        return ""
    end
end)

hook.Add("PlayerDeath", "JobRules", function(ply)
    net.Start("JobRules.SendOpenReport")
    net.Send(ply)
end)

hook.Add("OnPlayerChangedTeam", "JobRules", function(ply, _, to)
    if (ply:GetPData("jobrules_hasdisabled", false) == true) then return end
    if (jobrules.rules[ply:getJobTable().name] == nil) then return end
    net.Start("JobRules.SendOpenRules")
    net.WriteString(to)
    net.Send(ply)
    ply:ChatPrint("To hide this menu when you spawn, use /hidejobrules. To make it appear again do /allowjobrules")
end)