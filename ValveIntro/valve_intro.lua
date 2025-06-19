local function PlayValveIntro()
    local panel = vgui.Create("DHTML")
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0, 0)
    panel:SetZPos(32767)
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(false)
    panel:MakePopup()

    panel:SetHTML([[
        <html>
            <body style="margin:0;overflow:hidden;background:black">
                <video id="valveVid" autoplay width="100%" height="100%" style="display:block">
                    <source src="asset://garrysmod/html/valve.webm" type="video/webm">
                </video>
                <script>
                    const vid = document.getElementById("valveVid");
                    vid.onended = function() {
                        if (typeof gmod !== "undefined" && gmod.VALVE_INTRO_DONE) {
                            gmod.VALVE_INTRO_DONE();
                        }
                    };
                </script>
            </body>
        </html>
    ]])

    panel:AddFunction("gmod", "VALVE_INTRO_DONE", function()
        if IsValid(panel) then
            panel:AlphaTo(0, 1, 0, function()
                if IsValid(panel) then
                    panel:Remove()
                end
            end)
        end
    end)
end

do
    local lastFrame = SysTime()
    local freezeThreshold = 0.1
    local wasFrozen = true
    local unfrozenCount = 0

    hook.Add("Think", "ValveIntro_FreezeCheck", function()
        local now = SysTime()
        local delta = now - lastFrame

        if delta > freezeThreshold then
            wasFrozen = true
        else
            if wasFrozen then
                unfrozenCount = unfrozenCount + 1
                if unfrozenCount == 2 then
                    PlayValveIntro()
                    hook.Remove("Think", "ValveIntro_FreezeCheck")
                end
            end
            wasFrozen = false
        end

        lastFrame = now
    end)
end