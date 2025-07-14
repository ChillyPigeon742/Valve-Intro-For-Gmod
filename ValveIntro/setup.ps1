Write-Host "==============================="
Write-Host "    Valve Intro Setup Tool"
Write-Host "==============================="
Write-Host ""

function Get-GModPath {
    $steamPath = ""

    $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Valve\Steam" -Name InstallPath -ErrorAction SilentlyContinue).InstallPath
    if (-not $steamPath) {
        $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -Name InstallPath -ErrorAction SilentlyContinue).InstallPath
    }

    if (-not $steamPath) {
        Write-Host "[ERROR] Steam installation path not found." -ForegroundColor Red
        Pause
        exit
    }

    $gmodPath = Join-Path $steamPath "steamapps\common\GarrysMod"
    if (Test-Path $gmodPath) {
        return $gmodPath
    }

    $libraryFoldersFile = Join-Path $steamPath "steamapps\libraryfolders.vdf"
    if (Test-Path $libraryFoldersFile) {
        $libraryFolders = Get-Content $libraryFoldersFile | Select-String -Pattern '^\s*"(\d+)"\s+"(.*)"' | ForEach-Object {
            $_.Matches.Groups[2].Value
        }

        foreach ($libraryFolder in $libraryFolders) {
            $gmodPath = Join-Path $libraryFolder "steamapps\common\GarrysMod"
            if (Test-Path $gmodPath) {
                return $gmodPath
            }
        }
    }

    Write-Host "[ERROR] GMod installation path not found." -ForegroundColor Red
    Pause
    exit
}

$gmodPath = Get-GModPath

Write-Host "[SUCCESS] GMod path found: $gmodPath"

$menuLuaPath = Join-Path $gmodPath "garrysmod\lua\menu\menu.lua"
$backupMenuLuaPath = Join-Path $gmodPath "garrysmod\lua\menu\menu.lua.bak"
$destLuaPath = Join-Path $gmodPath "garrysmod\lua\menu\valve_intro.lua"
$destWebmPath = Join-Path $gmodPath "garrysmod\media\valve.webm"

Write-Host "[INFO] menu.lua path: $menuLuaPath"
Write-Host "[INFO] Destination valve_intro.lua: $destLuaPath"
Write-Host "[INFO] Destination valve.webm: $destWebmPath"

if (-not (Test-Path $menuLuaPath)) {
    Write-Host "[ERROR] menu.lua not found!" -ForegroundColor Red
    Pause
    exit
}

$localLua = Join-Path (Get-Location) "valve_intro.lua"
$localWebm = Join-Path (Get-Location) "valve.webm"

if (-not (Test-Path $localLua)) {
    Write-Host "[ERROR] Local valve_intro.lua not found!" -ForegroundColor Red
    Pause
    exit
}

if (-not (Test-Path $localWebm)) {
    Write-Host "[ERROR] Local valve.webm not found!" -ForegroundColor Red
    Pause
    exit
}

$includeLine = 'include("valve_intro.lua")'
$trimmedIncludeLine = $includeLine.Trim()

Write-Host ""
Write-Host "[1] Install"
Write-Host "[2] Uninstall"
Write-Host ""

do {
    $choice = Read-Host "Choose an option (1 or 2)"
} while ($choice -notin '1','2')

Write-Host "You chose: $choice"
Write-Host ""

$menuContent = Get-Content $menuLuaPath
$includeExists = $menuContent | Where-Object { $_.Trim() -eq $trimmedIncludeLine }
$luaExists = Test-Path $destLuaPath
$webmExists = Test-Path $destWebmPath

switch ($choice) {
    '1' {
        if ($includeExists -and $luaExists -and $webmExists) {
            Write-Host "[INFO] Already installed. No changes made."
        } else {
            if (-not (Test-Path $backupMenuLuaPath)) {
                Copy-Item -Path $menuLuaPath -Destination $backupMenuLuaPath -Force
                Write-Host "[INFO] Backed up menu.lua to menu.lua.bak"
            } else {
                Write-Host "[INFO] Backup menu.lua.bak already exists"
            }

            Copy-Item -Path $localLua -Destination $destLuaPath -Force
            Write-Host "[INFO] Copied valve_intro.lua to lua/menu/"

            # Check if 'media' folder exists, if not, create it
            $mediaFolder = Join-Path $gmodPath "garrysmod\media"
            if (-not (Test-Path $mediaFolder)) {
                Write-Host "[INFO] 'media' folder not found, creating it..."
                New-Item -Path $mediaFolder -ItemType Directory -Force
            }

            Copy-Item -Path $localWebm -Destination $destWebmPath -Force
            Write-Host "[INFO] Copied valve.webm to media/"

            if (-not $includeExists) {
                Add-Content -Path $menuLuaPath -Value ""
                Add-Content -Path $menuLuaPath -Value $trimmedIncludeLine
                Write-Host "[SUCCESS] Added include line to menu.lua!"
            } else {
                Write-Host "[INFO] Include line already present in menu.lua."
            }
        }
    }
    '2' {
        if (-not $includeExists -and -not $luaExists -and -not $webmExists) {
            Write-Host "[INFO] Already uninstalled. No changes made."
        } else {
            if (Test-Path $destLuaPath) {
                Remove-Item -Path $destLuaPath -Force
                Write-Host "[INFO] Removed valve_intro.lua from lua/menu/"
            } else {
                Write-Host "[INFO] valve_intro.lua not found in lua/menu/"
            }

            if (Test-Path $destWebmPath) {
                Remove-Item -Path $destWebmPath -Force
                Write-Host "[INFO] Removed valve.webm from media/"
            } else {
                Write-Host "[INFO] valve.webm not found in media/"
            }

            if (Test-Path $backupMenuLuaPath) {
                Move-Item -Path $backupMenuLuaPath -Destination $menuLuaPath -Force
                Write-Host "[SUCCESS] Restored original menu.lua from backup!"
            } else {
                Write-Host "[INFO] Backup not found, attempting manual removal of include line..."

                $newContent = $menuContent | Where-Object { $_.Trim() -ne $trimmedIncludeLine }
                if ($newContent.Count -ne $menuContent.Count) {
                    Set-Content -Path $menuLuaPath -Value $newContent
                    Write-Host "[SUCCESS] Removed include line from menu.lua!"
                } else {
                    Write-Host "[INFO] Include line not found in menu.lua. No changes made."
                }
            }
        }
    }
}

Write-Host ""
Write-Host "==============================="
Write-Host "  PRESS ANY KEY TO EXIT..."
Write-Host "==============================="
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")