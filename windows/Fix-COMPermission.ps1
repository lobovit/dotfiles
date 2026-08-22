# Fix COM Server Permission Error for CLSID {9EA82395-E31B-41CA-8DF7-EC1CEE7194DF} and APPID {2ED83BAA-B2FD-43B1-99BF-E6149C622692}

$CLSID = "{9EA82395-E31B-41CA-8DF7-EC1CEE7194DF}"
$APPID = "{2ED83BAA-B2FD-43B1-99BF-E6149C622692}"
$NETWORK_SERVICE_SID = "S-1-5-20"
$NETWORK_SERVICE_NAME = "NT AUTHORITY\NETWORK SERVICE"

Write-Host "Fixing COM Server Permission Error..." -ForegroundColor Cyan
Write-Host "CLSID: $CLSID" -ForegroundColor Yellow
Write-Host "APPID: $APPID" -ForegroundColor Yellow

# Function to take ownership of registry key
function Take-RegistryOwnership {
    param([string]$KeyPath)
    
    try {
        Write-Host "Taking ownership of: $KeyPath" -ForegroundColor Gray
        
        # Get current owner
        $key = Get-Acl -Path $KeyPath
        $currentOwner = $key.Owner
        Write-Host "Current owner: $currentOwner" -ForegroundColor Gray
        
        # Take ownership
        $identity = [System.Security.Principal.NTAccount]"Administrators"
        $key.SetOwner($identity)
        Set-Acl -Path $KeyPath -AclObject $key
        
        # Grant full control to Administrators
        $key = Get-Acl -Path $KeyPath
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $key.AddAccessRule($rule)
        Set-Acl -Path $KeyPath -AclObject $key
        
        Write-Host "Successfully took ownership of: $KeyPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error taking ownership of $KeyPath : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to add NETWORK SERVICE permission to registry key
function Add-NetworkServicePermission {
    param([string]$KeyPath)
    
    try {
        Write-Host "Adding NETWORK SERVICE permission to: $KeyPath" -ForegroundColor Gray
        
        $key = Get-Acl -Path $KeyPath
        
        # Add permission for NETWORK SERVICE
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($NETWORK_SERVICE_NAME, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $key.AddAccessRule($rule)
        Set-Acl -Path $KeyPath -AclObject $key
        
        Write-Host "Successfully added NETWORK SERVICE permission to: $KeyPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error adding permission to $KeyPath : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Step 1: Take ownership and modify CLSID registry key
$clsidPath = "HKLM:\SOFTWARE\Classes\CLSID\$CLSID"
if (Test-Path $clsidPath) {
    if (Take-RegistryOwnership $clsidPath) {
        Add-NetworkServicePermission $clsidPath
    }
} else {
    Write-Host "CLSID registry path not found: $clsidPath" -ForegroundColor Red
}

# Step 2: Take ownership and modify APPID registry key
$appidPath = "HKLM:\SOFTWARE\Classes\APPID\$APPID"
if (Test-Path $appidPath) {
    if (Take-RegistryOwnership $appidPath) {
        Add-NetworkServicePermission $appidPath
    }
} else {
    Write-Host "APPID registry path not found: $appidPath" -ForegroundColor Red
}

# Step 3: Try to modify DCOM settings using WMI (may have limitations)
try {
    Write-Host "`nAttempting to modify DCOM settings via WMI..." -ForegroundColor Cyan
    
    # Get the DCOM application setting
    $app = Get-WmiObject -Query "SELECT * FROM Win32_DCOMApplicationSetting WHERE AppId='$APPID'" -EnableAllPrivileges
    
    if ($app) {
        Write-Host "Found DCOM application: $($app.Description)" -ForegroundColor Green
        
        # Get the current security descriptor
        $sdRes = $app.GetLaunchSecurityDescriptor()
        $sd = $sdRes.Descriptor
        
        # Create trustee for NETWORK SERVICE
        $trustee = ([wmiclass]'Win32_Trustee').CreateInstance()
        $trustee.Domain = "NT AUTHORITY"
        $trustee.Name = "NETWORK SERVICE"
        
        # Create ACE for Local Launch and Activation (permissions value 11)
        $ace = ([wmiclass]'Win32_ACE').CreateInstance()
        $ace.AccessMask = 11  # Local Launch + Local Activation
        $ace.AceFlags = 0
        $ace.AceType = 0  # ACCESS_ALLOWED
        $ace.Trustee = $trustee
        
        # Add the ACE to the DACL
        $sd.DACL += $ace
        
        # Set the modified security descriptor
        $app.SetLaunchSecurityDescriptor($sd)
        
        Write-Host "Successfully modified DCOM permissions via WMI" -ForegroundColor Green
    } else {
        Write-Host "DCOM application not found via WMI" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "WMI modification failed: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "This is expected - some DCOM configurations cannot be modified via PowerShell" -ForegroundColor Yellow
}

# Step 4: Alternative approach using dcomcnfg via command line
Write-Host "`nAttempting alternative approach using dcomcnfg..." -ForegroundColor Cyan

# Create a VBScript to modify DCOM permissions (more reliable than PowerShell for some cases)
$vbsScript = @"
Set objShell = CreateObject("Shell.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' This script will help modify DCOM permissions
' Note: Manual intervention may be required for some components

WScript.Echo "Please use Component Services (dcomcnfg.exe) to manually modify DCOM permissions for:"
WScript.Echo "APPID: $APPID"
WScript.Echo "Add NETWORK SERVICE with Local Launch and Local Activation permissions"
"@

# Write the VBScript to a temporary file
$tempScript = "$env:TEMP\fix_dcom_perm.vbs"
Set-Content -Path $tempScript -Value $vbsScript

Write-Host "Created helper script at: $tempScript" -ForegroundColor Gray
Write-Host "Please run this script and follow the instructions to complete the fix" -ForegroundColor Gray

# Final instructions
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "MANUAL STEPS REQUIRED:" -ForegroundColor Yellow
Write-Host "1. Open Component Services (dcomcnfg.exe) as Administrator" -ForegroundColor White
Write-Host "2. Navigate to: Component Services > Computers > My Computer > DCOM Config" -ForegroundColor White
Write-Host "3. Find the component with APPID: $APPID" -ForegroundColor White
Write-Host "4. Right-click > Properties > Security tab" -ForegroundColor White
Write-Host "5. Under 'Launch and Activation Permissions', click 'Edit'" -ForegroundColor White
Write-Host "6. Add 'NT AUTHORITY\NETWORK SERVICE'" -ForegroundColor White
Write-Host "7. Grant 'Local Launch' and 'Local Activation' permissions" -ForegroundColor White
Write-Host "8. Click OK to save changes" -ForegroundColor White
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")