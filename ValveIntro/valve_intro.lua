local function PlayValveIntro()
    RunConsoleCommand("cl_software_cursor", 1)

    local panel = vgui.Create("DHTML")
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0, 0)
    panel:SetZPos(32767)
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(false)
    panel:MakePopup()

    panel:SetHTML([[
        <html>
            <body style="margin:0; overflow:hidden; background:black;">
                <video id="valveVid" autoplay width="100%" height="100%" style="display:block;">
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
                    RunConsoleCommand("cl_software_cursor", 0)
                end
            end)
        end
    end)
end

local playedIntro = false

hook.Add("Think", "ValveIntro_MainMenuCheck", function()
    if gui.IsGameUIVisible() and not playedIntro then
        PlayValveIntro()
        playedIntro = true
        hook.Remove("Think", "ValveIntro_MainMenuCheck")
    end
end)