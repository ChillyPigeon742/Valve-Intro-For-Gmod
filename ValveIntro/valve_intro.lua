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
                <video autoplay onended="document.location='about:blank'" width="100%" height="100%">
                    <source src="asset://garrysmod/html/valve.webm" type="video/webm">
                </video>
            </body>
        </html>
    ]])

    timer.Simple(13.2, function()
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
            print("[ValveIntro] Detected UI unfrozen, count: " .. unfreezeCount)

            if unfreezeCount == 2 then
                PlayValveIntro()
            end
        end
        isFrozen = false
    end

    lastFrameTime = now
end)