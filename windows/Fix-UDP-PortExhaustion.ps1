# Fix TCP/IP Event ID 4266 - UDP Port Exhaustion

Write-Host "Fixing TCP/IP Event ID 4266 - UDP Port Exhaustion" -ForegroundColor Cyan
Write-Host "This error indicates all UDP ephemeral ports are in use" -ForegroundColor Yellow

# Step 1: Check current UDP port usage
Write-Host "`nStep 1: Checking current UDP port usage..." -ForegroundColor Green

# Check UDP connections
Write-Host "UDP connections in use:" -ForegroundColor Gray
$udpConnections = Get-NetUDPEndpoint | Measure-Object
Write-Host "Total UDP endpoints: $($udpConnections.Count)" -ForegroundColor Yellow

# Check dynamic port range
Write-Host "`nCurrent UDP dynamic port range:" -ForegroundColor Gray
try {
    $udpRange = netsh int ipv4 show dynamicport udp
    Write-Host $udpRange -ForegroundColor White
} catch {
    Write-Host "Could not retrieve UDP port range" -ForegroundColor Red
}

# Step 2: Expand UDP dynamic port range
Write-Host "`nStep 2: Expanding UDP dynamic port range..." -ForegroundColor Green

# Get current range first
$currentRange = netsh int ipv4 show dynamicport udp
Write-Host "Current UDP range:" -ForegroundColor Gray
Write-Host $currentRange -ForegroundColor White

# Expand UDP port range (start from 5001, use 60535 ports)
Write-Host "`nExpanding UDP port range..." -ForegroundColor Gray
try {
    netsh int ipv4 set dynamicport udp start=5001 num=60535
    Write-Host "Successfully expanded UDP port range" -ForegroundColor Green
} catch {
    Write-Host "Failed to expand UDP port range" -ForegroundColor Red
}

# Step 3: Optimize TCP/IP parameters
Write-Host "`nStep 3: Optimizing TCP/IP parameters..." -ForegroundColor Green

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

# Create registry entries if they don't exist
$regSettings = @(
    @{Name="TcpTimedWaitDelay"; Value=30; Type="DWord"},
    @{Name="MaxUserPort"; Value=65534; Type="DWord"},
    @{Name="TcpNumConnections"; Value=16777214; Type="DWord"},
    @{Name="TcpMaxDataRetransmissions"; Value=5; Type="DWord"}
)

foreach ($setting in $regSettings) {
    try {
        $currentValue = Get-ItemProperty -Path $regPath -Name $setting.Name -ErrorAction SilentlyContinue
        
        if ($currentValue) {
            Write-Host "$($setting.Name): $($currentValue.$($setting.Name)) (current)" -ForegroundColor Gray
        } else {
            Set-ItemProperty -Path $regPath -Name $setting.Name -Value $setting.Value -Type $setting.Type
            Write-Host "$($setting.Name): Set to $($setting.Value)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Error setting $($setting.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 4: Flush DNS and reset network stack
Write-Host "`nStep 4: Flushing DNS and resetting network stack..." -ForegroundColor Green

try {
    ipconfig /flushdns
    Write-Host "DNS cache flushed" -ForegroundColor Green
} catch {
    Write-Host "Failed to flush DNS cache" -ForegroundColor Red
}

try {
    netsh int ip reset
    Write-Host "TCP/IP stack reset" -ForegroundColor Green
} catch {
    Write-Host "Failed to reset TCP/IP stack" -ForegroundColor Red
}

try {
    netsh winsock reset
    Write-Host "Winsock reset" -ForegroundColor Green
} catch {
    Write-Host "Failed to reset Winsock" -ForegroundColor Red
}

# Step 5: Check for processes using too many UDP ports
Write-Host "`nStep 5: Checking for processes using UDP ports..." -ForegroundColor Green

Write-Host "Top processes using UDP ports:" -ForegroundColor Gray
try {
    Get-NetUDPEndpoint | Group-Object OwningProcess | 
        Sort-Object Count -Descending | 
        Select-Object -First 10 |
        ForEach-Object {
            $process = Get-Process -Id $_.Name -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "PID: $($_.Name) - Process: $($process.ProcessName) - UDP Endpoints: $($_.Count)" -ForegroundColor White
            }
        }
} catch {
    Write-Host "Could not retrieve UDP port usage by process" -ForegroundColor Red
}

# Step 6: Restart network services
Write-Host "`nStep 6: Restarting network services..." -ForegroundColor Green

$services = @("Dnscache", "Dhcp", "Wcmsvc")
foreach ($service in $services) {
    try {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            Write-Host "Restarting $service..." -ForegroundColor Gray
            Restart-Service -Name $service -Force -ErrorAction SilentlyContinue
            Write-Host "Restarted $service" -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to restart $service" -ForegroundColor Red
    }
}

# Step 7: Verify changes
Write-Host "`nStep 7: Verifying changes..." -ForegroundColor Green

Write-Host "`nNew UDP dynamic port range:" -ForegroundColor Gray
try {
    $newRange = netsh int ipv4 show dynamicport udp
    Write-Host $newRange -ForegroundColor White
} catch {
    Write-Host "Could not retrieve new UDP port range" -ForegroundColor Red
}

# Final instructions
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "RECOMMENDATIONS:" -ForegroundColor Yellow
Write-Host "1. RESTART YOUR COMPUTER for all changes to take effect" -ForegroundColor White
Write-Host "2. Monitor Event Viewer for recurrence of Event ID 4266" -ForegroundColor White
Write-Host "3. If issue persists, check for applications consuming excessive UDP ports" -ForegroundColor White
Write-Host "4. Consider updating network drivers if problem continues" -ForegroundColor White
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")