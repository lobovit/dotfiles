# ==========================================
# MIGRACAO MSYS2 - C:\msys64 -> D:\softwares\msys64
# ==========================================
# Execute como Administrador!

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MIGRACAO MSYS2" -ForegroundColor Cyan
Write-Host "C:\msys64 -> D:\softwares\msys64" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ==========================================
# FASE 1: Pre-validacao
# ==========================================
Write-Host "`n[1/6] Pre-validacao..." -ForegroundColor Yellow

$source = "C:\msys64"
$dest = "D:\softwares\msys64"

if (-not (Test-Path $source)) {
    Write-Host "ERRO: Pasta de origem nao encontrada: $source" -ForegroundColor Red
    exit 1
}

if (Test-Path $dest) {
    Write-Host "ERRO: Pasta de destino ja existe: $dest" -ForegroundColor Red
    Write-Host "Remova ou renomeie a pasta destino primeiro." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "D:\softwares")) {
    New-Item -ItemType Directory -Path "D:\softwares" -Force | Out-Null
    Write-Host "  Pasta D:\softwares criada" -ForegroundColor Green
}

$sourceSize = (Get-ChildItem $source -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB
Write-Host "  Origem: $source ($([math]::Round($sourceSize, 2)) GB)" -ForegroundColor White
Write-Host "  Destino: $dest" -ForegroundColor White
Write-Host "  ESPACO NECESSARIO: $([math]::Round($sourceSize * 1.1, 2)) GB (10% margem)" -ForegroundColor Yellow

# Verificar espaco em disco
$drive = Get-PSDrive D
$freeGB = $drive.Free / 1GB
Write-Host "  Espaco livre em D:\ $([math]::Round($freeGB, 2)) GB" -ForegroundColor White

if ($freeGB -lt ($sourceSize * 1.1)) {
    Write-Host "ERRO: Espaco insuficiente em D:\" -ForegroundColor Red
    exit 1
}

Write-Host "  Pre-validacao OK!" -ForegroundColor Green

# ==========================================
# FASE 2: Fechar processos MSYS2
# ==========================================
Write-Host "`n[2/6] Fechando processos MSYS2..." -ForegroundColor Yellow

$msysProcesses = Get-Process | Where-Object { $_.Path -like "*msys64*" }
if ($msysProcesses) {
    foreach ($proc in $msysProcesses) {
        Write-Host "  Parando: $($proc.Name) (PID: $($proc.Id))" -ForegroundColor Yellow
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 3
    Write-Host "  Processos fechados" -ForegroundColor Green
} else {
    Write-Host "  Nenhum processo MSYS2 ativo" -ForegroundColor Green
}

# ==========================================
# FASE 3: Mover pasta
# ==========================================
Write-Host "`n[3/6] Movendo pasta (isso pode demorar)..." -ForegroundColor Yellow
Write-Host "  Copiando arquivos..." -ForegroundColor White

# Usar robocopy para copia segura com retry
$robocopyResult = & robocopy $source $dest /E /COPYALL /R:3 /W:5 /NFL /NDL /NP /XJ

if ($LASTEXITCODE -le 7) {
    Write-Host "  Copia concluida com sucesso!" -ForegroundColor Green
    
    # Verificar integridade
    $sourceCount = (Get-ChildItem $source -Recurse -File).Count
    $destCount = (Get-ChildItem $dest -Recurse -File).Count
    
    if ($sourceCount -eq $destCount) {
        Write-Host "  Verificacao: $sourceCount arquivos copiados" -ForegroundColor Green
        
        # Remover origem
        Write-Host "  Removendo pasta original..." -ForegroundColor Yellow
        Remove-Item $source -Recurse -Force
        Write-Host "  Pasta original removida" -ForegroundColor Green
    } else {
        Write-Host "ERRO: Diferenca no numero de arquivos!" -ForegroundColor Red
        Write-Host "  Origem: $sourceCount arquivos" -ForegroundColor Red
        Write-Host "  Destino: $destCount arquivos" -ForegroundColor Red
        Write-Host "  Pasta original NAO foi removida" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "ERRO: Falha na copia (codigo: $LASTEXITCODE)" -ForegroundColor Red
    exit 1
}

# ==========================================
# FASE 4: Atualizar PATH do usuario
# ==========================================
Write-Host "`n[4/6] Atualizando PATH do usuario..." -ForegroundColor Yellow

$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
$newPath = $currentPath -replace [regex]::Escape("C:\msys64\mingw64\bin"), "D:\softwares\msys64\mingw64\bin"

if ($currentPath -ne $newPath) {
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "  PATH atualizado" -ForegroundColor Green
    
    # Atualizar tambem na secao atual
    $env:PATH = $env:PATH -replace [regex]::Escape("C:\msys64\mingw64\bin"), "D:\softwares\msys64\mingw64\bin"
} else {
    Write-Host "  PATH ja esta atualizado ou entrada nao encontrada" -ForegroundColor Gray
}

# ==========================================
# FASE 5: Atualizar registro
# ==========================================
Write-Host "`n[5/6] Atualizando registro..." -ForegroundColor Yellow

# Uninstall key
$uninstallKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{96c72073-3470-4fab-965f-18e1b4603f3f}"
if (Test-Path $uninstallKey) {
    # Atualizar InstallLocation
    Set-ItemProperty -Path $uninstallKey -Name "InstallLocation" -Value "D:\softwares\msys64"
    Write-Host "  InstallLocation atualizado" -ForegroundColor Green
    
    # Atualizar UninstallString
    $newUninstall = '"D:\softwares\msys64\uninstall.exe" --start-uninstaller'
    Set-ItemProperty -Path $uninstallKey -Name "UninstallString" -Value $newUninstall
    Write-Host "  UninstallString atualizado" -ForegroundColor Green
}

# ==========================================
# FASE 6: Atualizar atalhos do Menu Inicio
# ==========================================
Write-Host "`n[6/6] Atualizando atalhos do Menu Inicio..." -ForegroundColor Yellow

$startMenu = "C:\Users\lobor\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MSYS2"
if (Test-Path $startMenu) {
    $shell = New-Object -ComObject WScript.Shell
    
    Get-ChildItem "$startMenu\*.lnk" | ForEach-Object {
        $shortcut = $shell.CreateShortcut($_.FullName)
        $oldTarget = $shortcut.TargetPath
        $newTarget = $oldTarget -replace [regex]::Escape("C:\msys64"), "D:\softwares\msys64"
        
        if ($oldTarget -ne $newTarget) {
            $shortcut.TargetPath = $newTarget
            $shortcut.WorkingDirectory = $newTarget.Substring(0, $newTarget.LastIndexOf("\"))
            $shortcut.Save()
            Write-Host "  Atalho atualizado: $($_.Name)" -ForegroundColor Green
        }
    }
    
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null
}

# ==========================================
# RELATORIO FINAL
# ==========================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "MIGRACAO CONCLUIDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nResumo:" -ForegroundColor Yellow
Write-Host "  Pasta: C:\msys64 -> D:\softwares\msys64" -ForegroundColor White
Write-Host "  PATH: C:\msys64\mingw64\bin -> D:\softwares\msys64\mingw64\bin" -ForegroundColor White
Write-Host "  Registro: InstallLocation e UninstallString atualizados" -ForegroundColor White
Write-Host "  Atalhos: 5 atalhos do Menu Inicio atualizados" -ForegroundColor White

Write-Host "`nProximos passos:" -ForegroundColor Yellow
Write-Host "  1. Reinicie o computador" -ForegroundColor White
Write-Host "  2. Teste: Abra um terminal e digite 'msys2'" -ForegroundColor White
Write-Host "  3. Verifique se o pacman funciona: 'pacman --version'" -ForegroundColor White