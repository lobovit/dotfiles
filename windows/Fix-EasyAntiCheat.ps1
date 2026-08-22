# Fix EasyAntiCheat_EOS Service Error (Event ID 7023 - Error %%87)

Write-Host "Fixing EasyAntiCheat_EOS Service Error" -ForegroundColor Cyan
Write-Host "Event ID 7023 - Error %%87 (ERROR_INVALID_PARAMETER)" -ForegroundColor Yellow

# Step 1: Check EasyAntiCheat service status
Write-Host "`nStep 1: Checking EasyAntiCheat service status..." -ForegroundColor Green

try {
    $service = Get-Service -Name "EasyAntiCheat_EOS" -ErrorAction SilentlyContinue
    if ($service) {
        Write-Host "Service found: $($service.Name)" -ForegroundColor Gray
        Write-Host "Status: $($service.Status)" -ForegroundColor Gray
        Write-Host "StartType: $($service.StartType)" -ForegroundColor Gray
    } else {
        Write-Host "EasyAntiCheat_EOS service not found" -ForegroundColor Red
    }
} catch {
    Write-Host "Error checking service: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Check service dependencies
Write-Host "`nStep 2: Checking service dependencies..." -ForegroundColor Green

try {
    $serviceDep = Get-Service -Name "EasyAntiCheat_EOS" -RequiredServices -ErrorAction SilentlyContinue
    if ($serviceDep) {
        foreach ($dep in $serviceDep) {
            Write-Host "Dependency: $($dep.Name) - Status: $($dep.Status)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "Error checking dependencies: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Try to restart the service
Write-Host "`nStep 3: Attempting to restart EasyAntiCheat_EOS service..." -ForegroundColor Green

try {
    $service = Get-Service -Name "EasyAntiCheat_EOS" -ErrorAction SilentlyContinue
    if ($service) {
        if ($service.Status -eq "Running") {
            Write-Host "Stopping service..." -ForegroundColor Gray
            Stop-Service -Name "EasyAntiCheat_EOS" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }
        
        Write-Host "Starting service..." -ForegroundColor Gray
        Start-Service -Name "EasyAntiCheat_EOS" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
        
        $service = Get-Service -Name "EasyAntiCheat_EOS" -ErrorAction SilentlyContinue
        Write-Host "New status: $($service.Status)" -ForegroundColor Green
    }
} catch {
    Write-Host "Error restarting service: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Check EasyAntiCheat installation path
Write-Host "`nStep 4: Checking EasyAntiCheat installation..." -ForegroundColor Green

$eacPaths = @(
    "C:\Program Files (x86)\EasyAntiCheat",
    "C:\Program Files\EasyAntiCheat",
    "$env:LOCALAPPDATA\EasyAntiCheat"
)

foreach ($path in $eacPaths) {
    if (Test-Path $path) {
        Write-Host "Found EasyAntiCheat at: $path" -ForegroundColor Green
        $setupFiles = Get-ChildItem -Path $path -Filter "*.exe" -ErrorAction SilentlyContinue
        foreach ($file in $setupFiles) {
            Write-Host "  - $($file.Name)" -ForegroundColor Gray
        }
    }
}

# Step 5: Reset Windows Sockets and TCP/IP
Write-Host "`nStep 5: Resetting network stack..." -ForegroundColor Green

try {
    netsh winsock reset
    Write-Host "Winsock reset completed" -ForegroundColor Green
} catch {
    Write-Host "Failed to reset Winsock" -ForegroundColor Red
}

try {
    netsh int ip reset
    Write-Host "TCP/IP reset completed" -ForegroundColor Green
} catch {
    Write-Host "Failed to reset TCP/IP" -ForegroundColor Red
}

# Step 6: Check Windows Firewall
Write-Host "`nStep 6: Checking Windows Firewall..." -ForegroundColor Green

try {
    $firewall = Get-NetFirewallRule -DisplayName "*EasyAntiCheat*" -ErrorAction SilentlyContinue
    if ($firewall) {
        Write-Host "Found EasyAntiCheat firewall rules:" -ForegroundColor Gray
        foreach ($rule in $firewall) {
            Write-Host "  - $($rule.DisplayName): $($rule.Enabled)" -ForegroundColor Gray
        }
    } else {
        Write-Host "No EasyAntiCheat firewall rules found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error checking firewall: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Verify system files
Write-Host "`nStep 7: Verifying system files..." -ForegroundColor Green

Write-Host "Running System File Checker..." -ForegroundColor Gray
Write-Host "This may take a few minutes..." -ForegroundColor Yellow

try {
    $result = sfc /scannow 2>&1
    Write-Host $result -ForegroundColor White
} catch {
    Write-Host "Error running SFC: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 8: Check for Windows updates
Write-Host "`nStep 8: Checking for Windows updates..." -ForegroundColor Green

try {
    $updates = Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 5
    Write-Host "Recent Windows updates:" -ForegroundColor Gray
    foreach ($update in $updates) {
        Write-Host "  - $($update.HotFixID): $($update.InstalledOn)" -ForegroundColor Gray
    }
} catch {
    Write-Host "Error checking updates: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 9: Create repair script for EasyAntiCheat
Write-Host "`nStep 9: Creating EasyAntiCheat repair instructions..." -ForegroundColor Green

$repairScript = @"
# EasyAntiCheat Repair Script
# Run this script as Administrator

Write-Host "EasyAntiCheat Repair Process" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Step 1: Download EasyAntiCheat Setup
Write-Host "`nStep 1: Download EasyAntiCheat Setup" -ForegroundColor Yellow
Write-Host "Please download the latest EasyAntiCheat_Setup.exe from:" -ForegroundColor White
Write-Host "https://www.easyanticheat.net/download/" -ForegroundColor White

# Step 2: Run as Administrator
Write-Host "`nStep 2: Run the setup as Administrator" -ForegroundColor Yellow
Write-Host "1. Right-click on EasyAntiCheat_Setup.exe" -ForegroundColor White
Write-Host "2. Select 'Run as administrator'" -ForegroundColor White
Write-Host "3. Click 'Repair Service'" -ForegroundColor White

# Step 3: Verify Secure Boot and TPM
Write-Host "`nStep 3: Verify Secure Boot and TPM 2.0" -ForegroundColor Yellow
Write-Host "EasyAntiCheat now requires Secure Boot and TPM 2.0" -ForegroundColor White
Write-Host "Check in: Settings > Update & Security > Recovery > Advanced startup" -ForegroundColor White

# Step 4: Check Memory Integrity
Write-Host "`nStep 4: Check Memory Integrity" -ForegroundColor Yellow
Write-Host "Go to: Settings > Privacy & Security > Windows Security > Device Security" -ForegroundColor White
Write-Host "Core isolation details > Memory integrity should be ON" -ForegroundColor White

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
"@

$repairScriptPath = "$env:USERPROFILE\Desktop\Fix-EasyAntiCheat.bat"
Set-Content -Path $repairScriptPath -Value $repairScript
Write-Host "Created repair script at: $repairScriptPath" -ForegroundColor Green

# Final instructions
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "MANUAL STEPS REQUIRED:" -ForegroundColor Yellow
Write-Host "1. Download EasyAntiCheat_Setup.exe from https://www.easyanticheat.net/download/" -ForegroundColor White
Write-Host "2. Right-click > Run as administrator" -ForegroundColor White
Write-Host "3. Click 'Repair Service'" -ForegroundColor White
Write-Host "4. If repair fails, click 'Uninstall' then 'Install Service'" -ForegroundColor White
Write-Host "5. Verify Secure Boot and TPM 2.0 are enabled in BIOS" -ForegroundColor White
Write-Host "6. Enable Memory Integrity in Windows Security" -ForegroundColor White
Write-Host "7. Restart your computer" -ForegroundColor White
Write-Host "8. Try launching your game again" -ForegroundColor White
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")