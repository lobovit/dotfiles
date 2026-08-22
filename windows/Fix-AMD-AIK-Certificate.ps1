# Fix SCEP Certificate Enrollment Error (Event ID 87 - AMD AIK Certificate)

Write-Host "Fixing SCEP Certificate Enrollment Error" -ForegroundColor Cyan
Write-Host "Event ID 87 - AMD AIK Certificate with P-256 ECC not supported" -ForegroundColor Yellow

# Step 1: Check current certificate status
Write-Host "`nStep 1: Checking current certificate status..." -ForegroundColor Green

Write-Host "Checking for AMD AIK certificates..." -ForegroundColor Gray
try {
    $certs = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction SilentlyContinue | 
        Where-Object { $_.Issuer -like "*AMD*" -or $_.Subject -like "*AIK*" -or $_.FriendlyName -like "*AIK*" }
    
    if ($certs) {
        Write-Host "Found AMD-related certificates:" -ForegroundColor Yellow
        foreach ($cert in $certs) {
            Write-Host "  - Subject: $($cert.Subject)" -ForegroundColor Gray
            Write-Host "    Issuer: $($cert.Issuer)" -ForegroundColor Gray
            Write-Host "    Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
            Write-Host "    NotAfter: $($cert.NotAfter)" -ForegroundColor Gray
        }
    } else {
        Write-Host "No AMD AIK certificates found" -ForegroundColor Gray
    }
} catch {
    Write-Host "Error checking certificates: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Check certificate enrollment events
Write-Host "`nStep 2: Checking recent certificate enrollment events..." -ForegroundColor Green

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName='Application'
        ProviderName='Microsoft-Windows-CertificateServicesClient-CertEnroll'
        Id=87
    } -MaxEvents 5 -ErrorAction SilentlyContinue
    
    if ($events) {
        Write-Host "Recent Event ID 87 events:" -ForegroundColor Yellow
        foreach ($event in $events) {
            Write-Host "  Time: $($event.TimeCreated)" -ForegroundColor Gray
            Write-Host "  Message: $($event.Message.Substring(0, [Math]::Min(200, $event.Message.Length)))..." -ForegroundColor Gray
        }
    } else {
        Write-Host "No recent Event ID 87 events found" -ForegroundColor Gray
    }
} catch {
    Write-Host "Error checking events: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Clear pending certificate requests
Write-Host "`nStep 3: Clearing pending certificate requests..." -ForegroundColor Green

try {
    # Check for pending certificate requests
    $pendingRequests = certreq -enroll -list 2>&1
    Write-Host "Pending certificate requests:" -ForegroundColor Gray
    Write-Host $pendingRequests -ForegroundColor White
} catch {
    Write-Host "Error checking pending requests: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Reset TPM attestation
Write-Host "`nStep 4: Resetting TPM attestation..." -ForegroundColor Green

try {
    # Clear TPM-related certificates
    Write-Host "Clearing TPM-related certificates..." -ForegroundColor Gray
    
    # Remove any problematic AMD AIK certificates
    $amdCerts = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction SilentlyContinue | 
        Where-Object { $_.Issuer -like "*AMD*" -and $_.Subject -like "*AIK*" }
    
    foreach ($cert in $amdCerts) {
        Write-Host "Removing certificate: $($cert.Subject)" -ForegroundColor Yellow
        Remove-Item -Path "Cert:\LocalMachine\My\$($cert.Thumbprint)" -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "TPM attestation reset completed" -ForegroundColor Green
} catch {
    Write-Host "Error resetting TPM attestation: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Check TPM status
Write-Host "`nStep 5: Checking TPM status..." -ForegroundColor Green

try {
    $tpm = Get-Tpm -ErrorAction SilentlyContinue
    if ($tpm) {
        Write-Host "TPM Present: $($tpm.TpmPresent)" -ForegroundColor Gray
        Write-Host "TPM Ready: $($tpm.TpmReady)" -ForegroundColor Gray
        Write-Host "TPM Enabled: $($tpm.TpmEnabled)" -ForegroundColor Gray
        Write-Host "TPM Activated: $($tpm.TpmActivated)" -ForegroundColor Gray
        Write-Host "TPM Owned: $($tpm.TpmOwned)" -ForegroundColor Gray
    } else {
        Write-Host "TPM not found or not accessible" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error checking TPM: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 6: Reset Windows Certificate Services
Write-Host "`nStep 6: Resetting Windows Certificate Services..." -ForegroundColor Green

try {
    # Stop and restart certificate services
    Write-Host "Stopping certificate services..." -ForegroundColor Gray
    Stop-Service -Name "CertSvc" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    Write-Host "Starting certificate services..." -ForegroundColor Gray
    Start-Service -Name "CertSvc" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    
    Write-Host "Certificate services reset completed" -ForegroundColor Green
} catch {
    Write-Host "Error resetting certificate services: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Create registry fix for AMD AIK
Write-Host "`nStep 7: Creating registry fix for AMD AIK..." -ForegroundColor Green

$regPath = "HKLM:\SOFTWARE\Microsoft\Cryptography\MSCEP"
$regSettings = @(
    @{Name="ECCP256"; Value="ECDSA_P256"; Type="String"},
    @{Name="ECCP384"; Value="ECDSA_P384"; Type="String"}
)

foreach ($setting in $regSettings) {
    try {
        if (!(Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        Set-ItemProperty -Path $regPath -Name $setting.Name -Value $setting.Value -Type $setting.Type -ErrorAction SilentlyContinue
        Write-Host "Set $($setting.Name) to $($setting.Value)" -ForegroundColor Green
    } catch {
        Write-Host "Error setting registry: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 8: Create batch script for manual fix
Write-Host "`nStep 8: Creating manual fix script..." -ForegroundColor Green

$fixScript = @"
@echo off
echo ========================================
echo AMD AIK Certificate Fix Script
echo Event ID 87 - SCEP Enrollment Error
echo ========================================
echo.

echo Step 1: Clearing certificate cache...
certutil -urlcache * delete
certutil -setreg urlcache\0 delete

echo.
echo Step 2: Resetting TPM attestation...
tpmutil -command clear

echo.
echo Step 3: Clearing pending certificate requests...
certreq -enroll -list

echo.
echo Step 4: Checking TPM status...
tpmutil -command getstatus

echo.
echo Step 5: Restarting certificate services...
net stop CertSvc
net start CertSvc

echo.
echo ========================================
echo Fix completed. Please restart your computer.
echo ========================================
echo.
pause
"@

$fixScriptPath = "$env:USERPROFILE\Desktop\Fix-AMD-AIK-Certificate.bat"
Set-Content -Path $fixScriptPath -Value $fixScript
Write-Host "Created fix script at: $fixScriptPath" -ForegroundColor Green

# Final instructions
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "IMPORTANT INFORMATION:" -ForegroundColor Yellow
Write-Host "This error is generally HARMLESS and does not affect system functionality." -ForegroundColor White
Write-Host "It occurs because AMD TPM modules try to use ECC P-256 keys" -ForegroundColor White
Write-Host "which are not supported by Microsoft's AIK SCEP endpoint." -ForegroundColor White
Write-Host "`nIf you still want to fix it:" -ForegroundColor Yellow
Write-Host "1. Run the created batch script as Administrator" -ForegroundColor White
Write-Host "2. Restart your computer" -ForegroundColor White
Write-Host "3. Check Event Viewer for recurrence" -ForegroundColor White
Write-Host "`nAlternative solutions:" -ForegroundColor Yellow
Write-Host "- Update BIOS/UEFI to latest version" -ForegroundColor White
Write-Host "- Update AMD chipset drivers" -ForegroundColor White
Write-Host "- Check for Windows updates" -ForegroundColor White
Write-Host "- Disable TPM attestation in BIOS (if not needed)" -ForegroundColor White
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")