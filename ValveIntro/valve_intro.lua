local introPlayed = false
local panel

local function CleanupPanel(fadeTime)
    if not IsValid(panel) then return end
    fadeTime = fadeTime or 1

    if fadeTime > 0 then
        panel:AlphaTo(0, fadeTime, 0, function()
            if IsValid(panel) then
                panel:Remove()
                RunConsoleCommand("cl_software_cursor", "0")
            end
        end)
    else
        panel:Remove()
        RunConsoleCommand("cl_software_cursor", "0")
    end

    hook.Remove("Think", "ValveIntro_SkipKey")
end

local function PlayValveIntro()
    if introPlayed then return end
    introPlayed = true

    RunConsoleCommand("cl_software_cursor", "1")

    panel = vgui.Create("DHTML")
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0, 0)
    panel:SetZPos(32767)
    panel:SetMouseInputEnabled(false)
    panel:SetKeyboardInputEnabled(false)
    panel:MakePopup()

    panel:SetHTML([[
        <html>
            <body style="margin:0;overflow:hidden;background:black">
                <video id="valveVid" autoplay playsinline width="100%" height="100%" style="display:block;object-fit:cover">
                    <source src="asset://garrysmod/media/valve.webm" type="video/webm">
                </video>
                <script>
                    const vid = document.getElementById("valveVid");
                    vid.onended = function () {
                        if (typeof gmod !== "undefined" && gmod.VALVE_INTRO_DONE) {
                            gmod.VALVE_INTRO_DONE();
                        }
                    };
                </script>
            </body>
        </html>
    ]])

    panel:AddFunction("gmod", "VALVE_INTRO_DONE", function()
        CleanupPanel(1)
    end)

    hook.Add("Think", "ValveIntro_SkipKey", function()
        if not IsValid(panel) then
            hook.Remove("Think", "ValveIntro_SkipKey")
            return
        end
        if input.IsKeyDown(KEY_ESCAPE) then
            CleanupPanel(0)
        end
    end)
end

concommand.Add("play_valve_intro", function()
    timer.Simple(1, PlayValveIntro)
end)