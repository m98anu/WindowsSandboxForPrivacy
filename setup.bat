@echo off
set "SANDBOX_DEPOT=C:\Users\WDAGUtilityAccount\Desktop\sanbos"

echo ===================================================
echo 1. Verification of Local Depot Installers
echo ===================================================
if not exist "%SANDBOX_DEPOT%\DiscordSetup.exe" echo WARNING: DiscordSetup.exe is missing from sanbos folder!
if not exist "%SANDBOX_DEPOT%\ClaudeSetup.exe" echo WARNING: ClaudeSetup.exe is missing from sanbos folder!
if not exist "%SANDBOX_DEPOT%\HeliumSetup.exe" echo WARNING: HeliumSetup.exe is missing from sanbos folder!

echo ===================================================
echo 2. Installing Applications Locally
echo ===================================================
echo Deploying Discord Desktop...
if exist "%SANDBOX_DEPOT%\DiscordSetup.exe" start /wait "" "%SANDBOX_DEPOT%\DiscordSetup.exe" /S

echo Deploying Claude Desktop...
if exist "%SANDBOX_DEPOT%\ClaudeSetup.exe" start /wait "" "%SANDBOX_DEPOT%\ClaudeSetup.exe" /S

echo Deploying Helium Browser...
if exist "%SANDBOX_DEPOT%\HeliumSetup.exe" start /wait "" "%SANDBOX_DEPOT%\HeliumSetup.exe" /S

echo Waiting a moment for files to settle...
timeout /t 5 /nobreak >nul

echo ===================================================
echo 3. Applying System Optimization Preset
echo ===================================================
echo Running Chris Titus Tech WinUtil configurations...
powershell -NoProfile -ExecutionPolicy Bypass -File "%SANDBOX_DEPOT%\titus.ps1"

echo ===================================================
echo 4. Configuring Default Protocols
echo ===================================================
ftype httpfile="C:\Program Files\Helium\Helium.exe" "%%1" >nul 2>&1
ftype httpsfile="C:\Program Files\Helium\Helium.exe" "%%1" >nul 2>&1
assoc .http=httpfile >nul 2>&1
assoc .https=httpsfile >nul 2>&1

echo ===================================================
echo 5. Generating Valid Desktop Shortcuts
echo ===================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $d=$w.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Discord.lnk'); $d.TargetPath='C:\Users\WDAGUtilityAccount\AppData\Local\Discord\Update.exe'; $d.Arguments='--processStart Discord.exe'; $d.Save()"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $h=$w.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Helium.lnk'); $h.TargetPath='C:\Program Files\Helium\Helium.exe'; $h.Save()"

echo ===================================================
echo Sandbox workstation deployment is complete!
echo ===================================================
pause