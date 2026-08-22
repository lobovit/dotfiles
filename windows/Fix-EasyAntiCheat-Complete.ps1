# Fix-EasyAntiCheat-Complete.ps1 - Solucao completa para EasyAntiCheat_EOS
# Remove completamente e permite reinstalacao limpa

Write-Host "========================================" -ForegroundColor Cyan
Write-Command "FIX EASYANTICHEAT - SOLUCAO COMPLETA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "ATENCAO: Este script vai remover completamente o EasyAntiCheat" -ForegroundColor Yellow
Write-Host "Voce precisara reinstalar manualmente apos a reinicializacao" -ForegroundColor Yellow
Write-Host ""

# Verificar se esta rodando como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERRO: Execute este script como Administrador!" -ForegroundColor Red
    pause
    exit 1
}

Read-Host "Pressione ENTER para continuar ou CTRL+C para cancelar"

Write-Host "`nStep 1: Parando todos os servicos EasyAntiCheat..." -ForegroundColor Yellow
$services = @("EasyAntiCheat_EOS", "EasyAntiCheat_EOSSys", "EasyAntiCheat")
foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Write-Host "  Parado: $svc" -ForegroundColor Gray
}

Write-Host "`nStep 2: Removendo servicos..." -ForegroundColor Yellow
foreach ($svc in $services) {
    sc.exe delete $svc 2>$null
    Write-Host "  Removido: $svc" -ForegroundColor Gray
}

Write-Host "`nStep 3: Removendo arquivos..." -ForegroundColor Yellow
$paths = @(
    "C:\Program Files (x86)\EasyAntiCheat_EOS",
    "C:\Program Files (x86)\EasyAntiCheat",
    "C:\Program Files\EasyAntiCheat_EOS",
    "C:\Program Files\EasyAntiCheat",
    "$env:LOCALAPPDATA\EasyAntiCheat",
    "$env:PROGRAMDATA\EasyAntiCheat",
    "$env:LOCALAPPDATA\EasyAntiCheat_EOS"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $path) {
            Write-Host "  Nao foi possivel remover: $path" -ForegroundColor Yellow
        } else {
            Write-Host "  Removido: $path" -ForegroundColor Green
        }
    }
}

Write-Host "`nStep 4: Limpando registro..." -ForegroundColor Yellow
$regPaths = @(
    "HKLM:\SOFTWARE\WOW6432Node\EasyAntiCheat",
    "HKLM:\SOFTWARE\EasyAntiCheat",
    "HKCU:\SOFTWARE\EasyAntiCheat",
    "HKLM:\SYSTEM\CurrentControlSet\Services\EasyAntiCheat_EOS",
    "HKLM:\SYSTEM\CurrentControlSet\Services\EasyAntiCheat_EOSSys",
    "HKLM:\SYSTEM\CurrentControlSet\Services\EasyAntiCheat"
)

foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Removido: $regPath" -ForegroundColor Green
    }
}

Write-Host "`nStep 5: Limpando cache..." -ForegroundColor Yellow
$cachePaths = @(
    "$env:LOCALAPPDATA\Electronic Arts\EA Desktop\cache",
    "$env:APPDATA\Electronic Arts\EA Desktop\cache",
    "$env:LOCALAPPDATA\EasyAntiCheat",
    "$env:TEMP\EasyAntiCheat"
)

foreach ($path in $cachePaths) {
    if (Test-Path $path) {
        Remove-Item -Path "$path\*" -Force -ErrorAction SilentlyContinue
        Write-Host "  Cache limpo: $path" -ForegroundColor Green
    }
}

Write-Host "`nStep 6: Verificando remocao..." -ForegroundColor Yellow
$remaining = @()
foreach ($path in $paths) {
    if (Test-Path $path) {
        $remaining += $path
    }
}

if ($remaining.Count -gt 0) {
    Write-Host "  Alguns arquivos nao puderam ser removidos (reinicie e tente novamente):" -ForegroundColor Yellow
    foreach ($path in $remaining) {
        Write-Host "    - $path" -ForegroundColor Gray
    }
} else {
    Write-Host "  Todos os arquivos removidos com sucesso!" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "REMOCAO COMPLETA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PROXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. REINICIE O COMPUTADOR" -ForegroundColor White
Write-Host ""
Write-Host "2. Apos reiniciar:" -ForegroundColor White
Write-Host "   - Abra o EA App" -ForegroundColor Gray
Write-Host "   - Va em Minha Biblioteca > Apex Legends" -ForegroundColor Gray
Write-Host "   - Clique nos 3 pontos (...) > Reparar" -ForegroundColor Gray
Write-Host "   - Ou reinstale o jogo" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Se nao funcionar pelo EA App:" -ForegroundColor White
Write-Host "   - Acesse: https://www.easy.ac/download/" -ForegroundColor Gray
Write-Host "   - Baixe o EasyAntiCheat_EOS_Setup.exe" -ForegroundColor Gray
Write-Host "   - Execute como Administrador" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

$restart = Read-Host "Deseja reiniciar o computador agora? (S/N)"
if ($restart -eq "S" -or $restart -eq "s") {
    Write-Host "Reiniciando em 10 segundos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Lembre-se de reiniciar!" -ForegroundColor Yellow
}