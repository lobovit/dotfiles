# Fix-EasyAntiCheat-EA.ps1 - Solucao para EA App
# Remove EasyAntiCheat completamente e permite reinstalacao limpa via EA App

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIX EASYANTICHEAT - SOLUCAO EA APP" -ForegroundColor Cyan
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

Write-Host "`nStep 4: Procurando por arquivos EasyAntiCheat na pasta do Apex..." -ForegroundColor Yellow

$apexPaths = @(
    "D:\games\fps\Apex",
    "D:\games\Apex",
    "C:\Program Files (x86)\Apex Legends",
    "C:\Program Files\Apex Legends",
    "$env:LOCALAPPDATA\Apex Legends"
)

foreach ($apexPath in $apexPaths) {
    if (Test-Path $apexPath) {
        Write-Host "  Encontrado: $apexPath" -ForegroundColor Green
        
        # Procurar por arquivos EasyAntiCheat na pasta do jogo
        $eacFiles = Get-ChildItem -Path $apexPath -Filter "*EasyAntiCheat*" -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $eacFiles) {
            Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
            Write-Host "    Removido: $($file.Name)" -ForegroundColor Gray
        }
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

Write-Host "`nStep 6: Limpando cache do EA App..." -ForegroundColor Yellow

$eaPaths = @(
    "$env:LOCALAPPDATA\Electronic Arts\EA Desktop\cache",
    "$env:APPDATA\Electronic Arts\EA Desktop\cache",
    "$env:LOCALAPPDATA\Electronic Arts\EA Desktop\CrashDumps"
)

foreach ($eaPath in $eaPaths) {
    if (Test-Path $eaPath) {
        Remove-Item -Path "$eaPath\*" -Force -ErrorAction SilentlyContinue
        Write-Host "  Cache limpo: $eaPath" -ForegroundColor Green
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PROXIMOS PASSOS MANUAIS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. REINICIE O COMPUTADOR agora" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Apos reiniciar, abra o EA App" -ForegroundColor White
Write-Host ""
Write-Host "3. Va em Minha Biblioteca > Apex Legends" -ForegroundColor White
Write-Host "   Clique nos 3 pontos (...) > Reparar" -ForegroundColor White
Write-Host "   Ou clique em Iniciar e aguarde detectar o problema" -ForegroundColor White
Write-Host ""
Write-Host "4. Se pedir para instalar EasyAntiCheat, confirme" -ForegroundColor White
Write-Host ""
Write-Host "5. Se nao funcionar, tente:" -ForegroundColor White
Write-Host "   - Desinstalar o Apex pelo EA App" -ForegroundColor White
Write-Host "   - Reiniciar o computador" -ForegroundColor White
Write-Host "   - Reinstalar o Apex pelo EA App" -ForegroundColor White
Write-Host ""
Write-Host "6. Alternativa manual:" -ForegroundColor White
Write-Host "   Va ate a pasta: D:\games\fps\Apex" -ForegroundColor Cyan
Write-Host "   Procure por EasyAntiCheat_EOS_Setup.exe" -ForegroundColor Cyan
Write-Host "   Execute como Administrador" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

$restart = Read-Host "Deseja reiniciar o computador agora? (S/N)"
if ($restart -eq "S" -or $restart -eq "s") {
    Write-Host "Reiniciando..." -ForegroundColor Yellow
    Restart-Computer -Force
} else {
    Write-Host "Lembre-se de reiniciar antes de prosseguir!" -ForegroundColor Yellow
}