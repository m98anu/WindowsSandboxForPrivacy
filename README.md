# WindowsSandboxForPrivacy

An automated, lightweight, and hardware-accelerated Windows Sandbox environment optimized for privacy, high-performance multimedia streaming, and zero-persistence workspaces. 

This repository provides an automated configuration engine to securely deploy **Discord**, **Claude**, and **Helium Browser** within an isolated, debloated, and privacy-hardened environment that vanishes completely when closed.

## 📌 Project Purpose & Features

Standard sandboxes and virtual machines are often sluggish, filled with background OS telemetry, or fully disconnected from necessary host peripherals (like microphones and webcams). This project fixes those limitations by using native Windows Hyper-V container virtualization wrapped in custom automation scripts.

### What This Environment Offers:
*   **Total Persistent Privacy:** No host directory access is granted except for one isolated boundary node (`sanbos`). Apps inside the sandbox cannot scan your host files or network traffic.
*   **Media & Stream Optimized:** Explicit hardware GPU pass-through combined with direct audio/video device routing allows for smooth **1440p at 60fps streaming** and stutter-free meetings.
*   **Host-Protected VPN Shielding:** Operates via Network Address Translation (NAT) over your host network. If your host machine runs **ProtonVPN** (or any other VPN), all sandbox traffic is automatically encrypted and hidden behind your host's secure IP tunnel natively.
*   **100% Offline-First App Deployment:** Software installers are executed instantly from a local shared folder directory. This completely eliminates dependency drops or DNS caching bugs mid-session.
*   **Chris Titus WinUtil Toolbox Integration:** Automatically fires up the trusted system-debloating utility on launch, allowing you to manually apply advanced presets and kill background telemetry tracking scripts instantly.

---

## 📂 Repository Architecture

The project consists of three core structural configuration files:

### 1. `SecureLeanedWorkstation.wsb` (The Launcher)
The master configuration file that defines the container parameters, allocates RAM overhead, passes hardware components, mounts the data pipe, and triggers the startup sequence.

```xml
<Configuration>
  <Networking>Enable</Networking>
  <VGpu>Enable</VGpu>
  <AudioInput>Enable</AudioInput>
  <VideoInput>Enable</VideoInput>
  <ClipboardRedirection>Disable</ClipboardRedirection>
  <MemoryInMB>8192</MemoryInMB> 
  
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\Users\User\Downloads\sanbos</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop\sanbos</SandboxFolder>
      <ReadOnly>false</ReadOnly>
    </MappedFolder>
  </MappedFolders>

  <LogonCommand>
    <Command>cmd.exe /c "start cmd.exe /k C:\Users\WDAGUtilityAccount\Desktop\sanbos\setup.bat"</Command>
  </LogonCommand>
</Configuration>
```

### 2. `setup.bat` (The App Deployer)
A Command Prompt Batch script designed to process app extractions sequentially and generate persistent desktop links without breaking token string wrappers.

```cmd
@echo off
set "SANDBOX_DEPOT=C:\Users\WDAGUtilityAccount\Desktop\sanbos"

echo ===================================================
echo 1. Installing Applications Locally
echo ===================================================
if exist "%SANDBOX_DEPOT%\DiscordSetup.exe" start /wait "" "%SANDBOX_DEPOT%\DiscordSetup.exe" /S
if exist "%SANDBOX_DEPOT%\ClaudeSetup.exe" start /wait "" "%SANDBOX_DEPOT%\ClaudeSetup.exe" /S
if exist "%SANDBOX_DEPOT%\HeliumSetup.exe" start /wait "" "%SANDBOX_DEPOT%\HeliumSetup.exe" /S

echo Waiting a moment for files to settle...
timeout /t 5 /nobreak >nul

echo ===================================================
echo 2. Running Toolbox Scripts
echo ===================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%SANDBOX_DEPOT%\titus.ps1"

echo ===================================================
echo 3. Configuring Default Protocols and Shortcuts
echo ===================================================
ftype httpfile="C:\Program Files\Helium\Helium.exe" "%%1" >nul 2>&1
ftype httpsfile="C:\Program Files\Helium\Helium.exe" "%%1" >nul 2>&1
assoc .http=httpfile >nul 2>&1
assoc .https=httpsfile >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $d=$w.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Discord.lnk'); $d.TargetPath='C:\Users\WDAGUtilityAccount\AppData\Local\Discord\Update.exe'; $d.Arguments='--processStart Discord.exe'; $d.Save()"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $h=$w.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Helium.lnk'); $h.TargetPath='C:\Program Files\Helium\Helium.exe'; $h.Save()"
pause
```

### 3. `titus.ps1` (The Optimizer Launcher)
A dedicated PowerShell script that bridges into your local directory memory to invoke the offline copy of the **Chris Titus Tech winutil** graphical deployment shell interface.

```powershell
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "3. Launching Chris Titus WinUtil GUI" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

$OfflineScript = "C:\Users\WDAGUtilityAccount\Desktop\sanbos\winutil.ps1"

if (Test-Path $OfflineScript) {
    Write-Host "Opening the Windows Toolbox window..." -ForegroundColor Green
    . $OfflineScript
} else {
    Write-Host "ERROR: winutil.ps1 missing from sanbos directory." -ForegroundColor Red
}
```

---

## 🛠️ Requirements & Setup Guide

### Prerequisites:
1. Ensure you are on **Windows 10/11 Pro, Enterprise, or Education** editions (Windows Home does not support native Sandbox execution).
2. Hardware Virtualization (Hyper-V) must be enabled in your machine's BIOS/UEFI.
3. Turn on the "Windows Sandbox" feature inside the *Turn Windows features on or off* control panel menu.

### Local Folder Staging Instructions:
To achieve lightning-fast deployment without web network dependencies, create your physical file station on your host machine before execution:

1. Create a folder named exactly **`sanbos`** inside your host **`Downloads`** folder (`C:\Users\User\Downloads\sanbos`).
2. Download the official installation setup files for your tools from their official vendor web panels, and rename them to match these exact signatures inside your `sanbos` folder:
    *   `DiscordSetup.exe` (Standard Windows Installer)
    *   `ClaudeSetup.exe` (Desktop Application Setup)
    *   `HeliumSetup.exe` (64-Bit Application Binary)
3. Download the compiled Chris Titus tool script by opening `https://winutil.net` on your host browser, saving the raw text content as **`winutil.ps1`**, and dropping it directly into the `sanbos` folder directory.
4. Save the code blocks for `setup.bat` and `titus.ps1` inside the `sanbos` folder as well.

---

## ⚙️ Core Architecture & Customization Considerations

### 🧠 RAM Allocation Settings (`<MemoryInMB>`)
The project utilizes an explicitly declared variable overhead parameter flag set to **`8192` (8 GB)** inside the `.wsb` file.
*   **Why it's configured this way:** Modern chromium-based browser architectures and media framework apps (like Claude and Discord) suffer severe background pagefile cache latency stuttering under standard sandbox defaults (~4 GB allocation limits). 8 GB ensures absolute fluidity.
*   **When to modify it:** If your physical computer has **16 GB of RAM or lower**, adjust the string value inside the `.wsb` file back down to **`4096` (4 GB)** to ensure you don't exhaust your host's memory map during heavy testing pipelines.

### 🚀 Host Processor Thread Acceleration
To make the virtual machine experience feel as responsive as your real host workstation desktop, you can inject a registry key directly on your host to prioritize the container's scheduler thread queue over standard background system applications:
1. Open `regedit` on your host system.
2. Go to `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options`.
3. Create a key named `WindowsSandbox.exe`, nest a sub-key named `PerfOptions`, and add a **DWORD (32-bit)** entry named `CpuPriorityClass` set to **`3`** (High Priority mode).

### 🔠 Font Visual Effects Considerations
To maintain extreme snappiness, running debloat tools or system configurations may turn off unmanaged text compositing layers, causing fonts to occasionally render with jagged or pixelated vector tracks. 
*   **The Fix:** If text strings inside Discord or browsers appear hard to read, press **`Win + R`** inside the running sandbox, run **`cttune`** to execute the native Microsoft ClearType tuner wizard, check "Turn on ClearType", and hit next to instantly restore crisp, anti-aliased sub-pixel rendering.
*   This is what you have to search for in the Windows Search Menu when you need to change the appearance and feel like for responsiveness and general performance:

<img width="450" height="550" alt="image" src="https://github.com/user-attachments/assets/3acb1a37-ea42-47f3-bc77-4941decf384b" />


## 🤝 Contributing, Auditing & To-Dos
Feel free to fork this project layout structure to adapt it for specialized testing toolsets (e.g., malware analysis sandboxes, sterile development nodes, or alternate communications wrappers).
*  Ability to automatically fetch a configuration preset from the Chris Titus tooling (i. e. Standard or Advanced)
*  Further automation for directly giving you fake-persistence -> turn on with sessions already logged in
