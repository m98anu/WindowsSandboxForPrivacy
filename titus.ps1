Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "3. Applying System Optimization Preset via Native Engine" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# Define the absolute local path inside the sandbox directory mirror layout
$OfflineScript = "C:\Users\WDAGUtilityAccount\Desktop\sanbos\winutil.ps1"

if (Test-Path $OfflineScript) {
    Write-Host "Executing automated offline tweaks configuration via Advanced Preset..." -ForegroundColor Green
    
    # Force official engine variables directly into memory to bypass JSON formatting bugs completely
    $env:preset = "Advanced"
    $env:run = "true"
    
    # Execute the offline script copy using dot-sourcing to pull environment states instantly
    . $OfflineScript
} else {
    Write-Host "ERROR: winutil.ps1 missing from sanbos directory. Could not apply tweaks." -ForegroundColor Red
}