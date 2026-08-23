# ==========================================
# INSTALACAO VIA CHOCOLATEY
# ==========================================
# GIMP, Shotcut, Blender -> D:\softwares
# Execute como Administrador!

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INSTALACAO VIA CHOCOLATEY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ==========================================
# FASE 1: Verificar/Instalar Chocolatey
# ==========================================
Write-Host "`n[1/3] Verificando Chocolatey..." -ForegroundColor Yellow

# Caminho direto do choco
$chocoExe = "C:\ProgramData\chocolatey\bin\choco.exe"

# Verificar se o choco existe e funciona
$chocoFunciona = $false
if (Test-Path $chocoExe) {
    try {
        $chocoVersion = & $chocoExe --version 2>$null
        if ($chocoVersion) {
            $chocoFunciona = $true
            Write-Host "  Chocolatey ja instalado: v$chocoVersion" -ForegroundColor Green
        }
    } catch {
        $chocoFunciona = $false
    }
}

if (-not $chocoFunciona) {
    Write-Host "  Chocolatey nao encontrado ou incompleto. Instalando..." -ForegroundColor Yellow
    
    # Remover pasta incompleta se existir
    if (Test-Path "C:\ProgramData\chocolatey") {
        Write-Host "  Removendo instalacao incompleta..." -ForegroundColor Yellow
        Remove-Item "C:\ProgramData\chocolatey" -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Verificar execution policy
    Set-ExecutionPolicy Bypass -Scope Process -Force
    
    # Instalar Chocolatey
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Atualizar PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    if (Test-Path $chocoExe) {
        $chocoVersion = & $chocoExe --version 2>$null
        Write-Host "  Chocolatey instalado com sucesso: v$chocoVersion" -ForegroundColor Green
    } else {
        Write-Host "ERRO: Falha ao instalar Chocolatey" -ForegroundColor Red
        exit 1
    }
}

# ==========================================
# FASE 2: Preparar pasta destino
# ==========================================
Write-Host "`n[2/3] Preparando pasta destino..." -ForegroundColor Yellow

$destino = "D:\softwares"
if (-not (Test-Path $destino)) {
    New-Item -ItemType Directory -Path $destino -Force | Out-Null
    Write-Host "  Pasta criada: $destino" -ForegroundColor Green
} else {
    Write-Host "  Pasta existe: $destino" -ForegroundColor Green
}

# ==========================================
# FASE 3: Instalar programas
# ==========================================
Write-Host "`n[3/3] Instalando programas..." -ForegroundColor Yellow

# Configurar Chocolatey para instalar em D:\softwares
& $chocoExe config set --name installLocation --value "D:\softwares" 2>$null

$programs = @(
    @{ Name = "GIMP"; Package = "gimp"; Version = "3.2.4" },
    @{ Name = "Shotcut"; Package = "shotcut.install"; Version = "" },
    @{ Name = "Blender"; Package = "blender"; Version = "" }
)

foreach ($prog in $programs) {
    Write-Host "`n  Instalando $($prog.Name)..." -ForegroundColor Cyan
    
    $installCmd = "$chocoExe install $($prog.Package) -y --force"
    if ($prog.Version) {
        $installCmd += " --version=$($prog.Version)"
    }
    
    try {
        Invoke-Expression $installCmd
        Write-Host "  [$($prog.Name)] Instalado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "  [$($prog.Name)] ERRO: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ==========================================
# VERIFICACAO FINAL
# ==========================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "VERIFICACAO FINAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nProgramas instalados:" -ForegroundColor Yellow

$installed = @(
    @{ Name = "GIMP"; Paths = @("D:\softwares\GIMP*", "C:\Program Files\GIMP*") },
    @{ Name = "Shotcut"; Paths = @("D:\softwares\Shotcut*", "C:\Program Files\Shotcut*") },
    @{ Name = "Blender"; Paths = @("D:\softwares\Blender*", "C:\Program Files\Blender*") }
)

foreach ($prog in $installed) {
    $found = $false
    foreach ($path in $prog.Paths) {
        $items = Get-ChildItem $path -ErrorAction SilentlyContinue
        if ($items) {
            Write-Host "  $($prog.Name): $($items[0].FullName)" -ForegroundColor Green
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Host "  $($prog.Name): Nao encontrado" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "INSTALACAO CONCLUIDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan