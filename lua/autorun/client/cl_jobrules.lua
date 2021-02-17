XeninUI:CreateFont("JobRules.Test", 20, 500)
XeninUI:CreateFont("JobRules.RightTitle", 25, 500)
XeninUI:CreateFont("JobRules.RightSubTitle", 20, 500)

local function open_job_rules()
    local frame = vgui.Create("XeninUI.Frame")
    frame:SetSize(math.min(1000, ScrW()),math.min(500, ScrH()))
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(jobrules.title)

    local accept = frame:Add("XeninUI.ButtonV2")
    accept:Dock(BOTTOM)
    accept:SetSolidColor(XeninUI.Theme.Red)
    accept:DockMargin(10, 10, 10, 10)
    accept:SetTall(45)
    accept:SetText("Close")
    accept:SetRoundness(6)

    local left = frame:Add("Panel")
    left:Dock(LEFT)
    left:SetWide(frame:GetWide() / 2)

    local right = frame:Add("Panel")
    right:Dock(LEFT)
    right:SetWide(frame:GetWide() / 2)

    local title = left:Add("DLabel")
    title:SetText("New to this job?")
    title:Dock(TOP)
    title:SetFont("JobRules.RightTitle")
    title:SetColor(color_white)
    title:SetContentAlignment(5)
    title:SizeToContentsY()

    local sub = left:Add("DLabel")
    sub:SetText("Check out the rules below!")
    sub:Dock(TOP)
    sub:SetFont("JobRules.RightSubTitle")
    sub:SetColor(Color(200, 200, 200))
    sub:SetContentAlignment(5)
    sub:SizeToContentsY()

    local scroll = left:Add("XeninUI.ScrollPanel")
    scroll:Dock(FILL)
    for k, v in ipairs(jobrules.rules[LocalPlayer():getJobTable().name] or {}) do
        local p = scroll:Add("DPanel")
        p:Dock(TOP)
        p:DockMargin(10, 10, 10, 0)
        p:SetTall(40)
        p.Paint = function(s, w, h)
            draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)
        end

        local name = p:Add("DLabel")
        name:Dock(LEFT)
        name:SetColor(color_white)
        name:SetText(v[1])
        name:SetFont("JobRules.Test")
        name:SizeToContentsX(31)
        name:SetContentAlignment(5)
        name.Paint = function(s, w, h)
            draw.RoundedBoxEx(6, 0, 0, w, h, Color(35, 35, 35), true, false, true, false)
        end

        local rule = p:Add("DLabel")
        rule:Dock(FILL)
        rule:SetText(v[2])
        rule:SetTextInset(10, 0)
        rule:SetColor(Color(200, 200, 200))
        rule:SetFont("JobRules.Test")
        rule:SizeToContentsX(31)
        rule:SetContentAlignment(4)
    end

    -- RDM Panel stuff
    local title = right:Add("DLabel")
    title:SetText("Need to report someome?")
    title:Dock(TOP)
    title:SetFont("JobRules.RightTitle")
    title:SetColor(color_white)
    title:SetContentAlignment(5)
    title:SizeToContentsY()

    local sub = right:Add("DLabel")
    sub:SetText("Do so below!")
    sub:Dock(TOP)
    sub:SetFont("JobRules.RightSubTitle")
    sub:SetColor(Color(200, 200, 200))
    sub:SetContentAlignment(5)
    sub:SizeToContentsY()

    local scroll = right:Add("XeninUI.ScrollPanel")
    scroll:Dock(FILL)

    for k, v in pairs(player.GetAll()) do
        local name = "Unknown"
        if (IsValid(v)) then name = v:Nick() end

        local p = scroll:Add("DButton")
        p:Dock(TOP)
        p:DockMargin(10, 10, 10, 0)
        p:SetTall(40)
        p.textAlpha = 0
        p:SetText("")
        p.Paint = function(s, w, h)
            if (s:IsHovered()) then
                s.textAlpha = Lerp(10 * FrameTime(), s.textAlpha, 255)
            else
                s.textAlpha = Lerp(10 * FrameTime(), s.textAlpha, 0)
            end

            draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Navbar)
            draw.SimpleText(name, "JobRules.Test", h, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText("Click to report!", "JobRules.Test", w - h, h / 2, ColorAlpha(XeninUI.Theme.Orange, s.textAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        p.DoClick = function()
            local minfo = vgui.Create("XeninUI.Frame")
            minfo:SetSize(600, 165)
            minfo:Center()
            minfo:SetTitle("Customize the message!")
            minfo:MakePopup()

            local text = minfo:Add("XeninUI.TextEntry")
            text:SetText("I was RDMed by " .. name .. "!")
            text:Dock(TOP)
            text:SetTall(45)
            text:DockMargin(10, 10, 10, 10)

            local sub = minfo:Add("XeninUI.ButtonV2")
            sub:Dock(BOTTOM)
            sub:SetText("Submit Report")
            sub:SetSolidColor(XeninUI.Theme.Green)
            sub:DockMargin(10, 10, 10, 10)
            sub:SetTall(45)
            sub:SetRoundness(6)

            sub.DoClick = function()
                local curText = text:GetText()
                LocalPlayer():ConCommand("say @" .. curText)

                minfo:Remove()
            end
        end

        local avatar = p:Add("XeninUI.Avatar")
        avatar:Dock(LEFT)
        avatar:SetPlayer(v, p:GetTall() - 10)
        avatar:DockMargin(5, 5, 5, 5)
        avatar:SetVertices(365)
        avatar:SetWide(p:GetTall() - 10)
    end
end

concommand.Add("testjobrules", function()
    open_job_rules()
end)

net.Receive("JobRules.SendOpenRules", function()

end)