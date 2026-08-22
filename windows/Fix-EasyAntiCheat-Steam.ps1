# Fix-EasyAntiCheat-Steam.ps1 - Solucao baseada na comunidade
# Remove EasyAntiCheat completamente e permite reinstalacao limpa via Steam

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIX EASYANTICHEAT - SOLUCAO STEAM" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se esta rodando como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERRO: Execute este script como Administrador!" -ForegroundColor Red
    Write-Host "Clique com o botao direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Step 1: Parando servicos EasyAntiCheat..." -ForegroundColor Yellow
Stop-Service -Name "EasyAntiCheat" -Force -ErrorAction SilentlyContinue
Stop-Service -Name "EasyAntiCheat_EOS" -Force -ErrorAction SilentlyContinue
Write-Host "  Servicos parados" -ForegroundColor Green

Write-Host "`nStep 2: Removendo servicos..." -ForegroundColor Yellow
sc.exe delete EasyAntiCheat 2>$null
sc.exe delete EasyAntiCheat_EOS 2>$null
Write-Host "  Servicos removidos" -ForegroundColor Green

Write-Host "`nStep 3: Removendo pastas de instalacao..." -ForegroundColor Yellow

$paths = @(
    "C:\Program Files (x86)\EasyAntiCheat",
    "C:\Program Files (x86)\EasyAntiCheat_EOS",
    "C:\Program Files\EasyAntiCheat",
    "C:\Program Files\EasyAntiCheat_EOS",
    "$env:LOCALAPPDATA\EasyAntiCheat",
    "$env:PROGRAMDATA\EasyAntiCheat",
    "D:\games\fps\Apex\EasyAntiCheat"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $path) {
            Write-Host "  Nao foi possivel remover: $path (reinicie e tente novamente)" -ForegroundColor Yellow
        } else {
            Write-Host "  Removido: $path" -ForegroundColor Green
        }
    } else {
        Write-Host "  Nao encontrado: $path" -ForegroundColor Gray
    }
}

Write-Host "`nStep 4: Procurando por arquivos EasyAntiCheat em jogos Steam..." -ForegroundColor Yellow

# Procurar por pastas EasyAntiCheat em locais comuns de jogos Steam
$steamPaths = @(
    "D:\games\fps",
    "D:\games",
    "D:\SteamLibrary\steamapps\common",
    "C:\Program Files (x86)\Steam\steamapps\common",
    "$env:PROGRAMFILES (x86)\Steam\steamapps\common",
    "D:\Steam\steamapps\common"
)

$foundGames = @()

foreach ($steamPath in $steamPaths) {
    if (Test-Path $steamPath) {
        $easyFolders = Get-ChildItem -Path $steamPath -Filter "EasyAntiCheat" -Directory -Recurse -ErrorAction SilentlyContinue
        foreach ($folder in $easyFolders) {
            $gamePath = Split-Path -Path $folder.FullName -Parent
            $gameName = Split-Path -Path $gamePath -Leaf
            Write-Host "  Encontrado: $gameName em $($folder.FullName)" -ForegroundColor Gray
            $foundGames += [PSCustomObject]@{
                GameName = $gameName
                GamePath = $gamePath
                EACPath = $folder.FullName
            }
        }
    }
}

if ($foundGames.Count -gt 0) {
    Write-Host "`n  Jogos encontrados com EasyAntiCheat:" -ForegroundColor Cyan
    foreach ($game in $foundGames) {
        Write-Host "    - $($game.GameName)" -ForegroundColor White
    }
}

Write-Host "`nStep 5: Verificando registro do Windows..." -ForegroundColor Yellow

# Verificar e remover chaves de registro do EasyAntiCheat
$regPaths = @(
    "HKLM:\SOFTWARE\WOW6432Node\EasyAntiCheat",
    "HKLM:\SOFTWARE\EasyAntiCheat",
    "HKCU:\SOFTWARE\EasyAntiCheat"
)

foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Removido registro: $regPath" -ForegroundColor Green
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PROXIMOS PASSOS MANUAIS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. REINICIE O COMPUTADOR agora" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Apos reiniciar, abra o Steam" -ForegroundColor White
Write-Host ""
Write-Host "3. Va em Biblioteca > Apex Legends" -ForegroundColor White
Write-Host "   Clique com botao direito > Propriedades" -ForegroundColor White
Write-Host "   Arquivos Locais > Verificar integridade dos arquivos" -ForegroundColor White
Write-Host ""
Write-Host "4. Tente iniciar o Apex Legends" -ForegroundColor White
Write-Host "   Deve aparecer 'EasyAntiCheat nao instalado'" -ForegroundColor White
Write-Host ""
Write-Host "5. Va ate a pasta do jogo:" -ForegroundColor White
Write-Host "   D:\games\fps\Apex\EasyAntiCheat" -ForegroundColor Cyan
Write-Host ""
Write-Host "6. Clique no instalador EasyAntiCheat (NAO no EOS Setup)" -ForegroundColor Yellow
Write-Host "   Deve aparecer 'Instalacao bem-sucedida'" -ForegroundColor Green
Write-Host ""
Write-Host "7. Inicie o jogo normalmente" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

$restart = Read-Host "Deseja reiniciar o computador agora? (S/N)"
if ($restart -eq "S" -or $restart -eq "s") {
    Write-Host "Reiniciando..." -ForegroundColor Yellow
    Restart-Computer -Force
} else {
    Write-Host "Lembre-se de reiniciar antes de prosseguir!" -ForegroundColor Yellow
}