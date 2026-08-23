# ==========================================
# LIMPEZA DE LIXO DIGITAL - REGISTRO
# ==========================================
# Execute como Administrador!

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "LIMPEZA DE REGISTRO - ENTRADAS QUEBRADAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Funcao para testar se um caminho existe
function Test-ValidPath {
    param($Path)
    if ([string]::IsNullOrEmpty($Path)) { return $false }
    $cleanPath = $Path -replace '"', ''
    $cleanPath = $cleanPath -replace '\s+/.*$', ''  # Remove argumentos
    return (Test-Path $cleanPath)
}

# ==========================================
# FASE 1: HKLM Uninstall
# ==========================================
Write-Host "`n[1/4] Verificando HKLM Uninstall..." -ForegroundColor Yellow

$brokenHKLM = @()
$entries = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
foreach ($entry in $entries) {
    $name = $entry.DisplayName
    $uninstall = $entry.UninstallString
    $install = $entry.InstallLocation
    
    if ($uninstall -and -not (Test-ValidPath $uninstall)) {
        $brokenHKLM += [PSCustomObject]@{
            Name = $name
            Path = $uninstall
            Type = "UninstallString"
        }
    }
    if ($install -and -not (Test-Path $install)) {
        $brokenHKLM += [PSCustomObject]@{
            Name = $name
            Path = $install
            Type = "InstallLocation"
        }
    }
}

Write-Host "  Entradas quebradas encontradas: $($brokenHKLM.Count)" -ForegroundColor White

# ==========================================
# FASE 2: HKLM WOW6432Node
# ==========================================
Write-Host "`n[2/4] Verificando HKLM WOW6432Node..." -ForegroundColor Yellow

$brokenWOW = @()
$entriesWOW = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
foreach ($entry in $entriesWOW) {
    $name = $entry.DisplayName
    $uninstall = $entry.UninstallString
    $install = $entry.InstallLocation
    
    if ($uninstall -and -not (Test-ValidPath $uninstall)) {
        $brokenWOW += [PSCustomObject]@{
            Name = $name
            Path = $uninstall
            Type = "UninstallString"
        }
    }
    if ($install -and -not (Test-Path $install)) {
        $brokenWOW += [PSCustomObject]@{
            Name = $name
            Path = $install
            Type = "InstallLocation"
        }
    }
}

Write-Host "  Entradas quebradas encontradas: $($brokenWOW.Count)" -ForegroundColor White

# ==========================================
# FASE 3: HKCU Uninstall
# ==========================================
Write-Host "`n[3/4] Verificando HKCU Uninstall..." -ForegroundColor Yellow

$brokenHKCU = @()
$entriesHKCU = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
foreach ($entry in $entriesHKCU) {
    $name = $entry.DisplayName
    $uninstall = $entry.UninstallString
    $install = $entry.InstallLocation
    
    if ($uninstall -and -not (Test-ValidPath $uninstall)) {
        $brokenHKCU += [PSCustomObject]@{
            Name = $name
            Path = $uninstall
            Type = "UninstallString"
        }
    }
    if ($install -and -not (Test-Path $install)) {
        $brokenHKCU += [PSCustomObject]@{
            Name = $name
            Path = $install
            Type = "InstallLocation"
        }
    }
}

Write-Host "  Entradas quebradas encontradas: $($brokenHKCU.Count)" -ForegroundColor White

# ==========================================
# FASE 4: Limpeza
# ==========================================
Write-Host "`n[4/4] Executando limpeza..." -ForegroundColor Yellow

# Lista de programas para remover do registro
$removeList = @(
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Blender",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\GIMP",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TikTok LIVE Studio"
)

foreach ($path in $removeList) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
        Write-Host "  Removido: $path" -ForegroundColor Green
    }
}

# ==========================================
# RELATORIO FINAL
# ==========================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RELATORIO FINAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nEntradas quebradas encontradas:" -ForegroundColor Yellow
Write-Host "  HKLM: $($brokenHKLM.Count)" -ForegroundColor White
Write-Host "  WOW6432Node: $($brokenWOW.Count)" -ForegroundColor White
Write-Host "  HKCU: $($brokenHKCU.Count)" -ForegroundColor White
Write-Host "  Total: $($brokenHKLM.Count + $brokenWOW.Count + $brokenHKCU.Count)" -ForegroundColor White

Write-Host "`nProgramas removidos do registro:" -ForegroundColor Yellow
foreach ($item in $brokenHKLM + $brokenWOW + $brokenHKCU) {
    Write-Host "  - $($item.Name) ($($item.Type))" -ForegroundColor Gray
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "LIMPEZA CONCLUIDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan