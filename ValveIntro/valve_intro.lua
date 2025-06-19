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

local lastFrameTime = SysTime()
local frozenThreshold = 0.1
local isFrozen = true
local unfreezeCount = 0

hook.Add("Think", "DetectGModFrozenState", function()
    local now = SysTime()
    local delta = now - lastFrameTime

    if delta > frozenThreshold then
        isFrozen = true
    else
        if isFrozen then
            unfreezeCount = unfreezeCount + 1

            if unfreezeCount == 2 then
                PlayValveIntro()
            end
        end
        isFrozen = false
    end

    lastFrameTime = now
end)