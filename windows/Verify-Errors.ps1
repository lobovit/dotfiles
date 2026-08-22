# Verificacao pos-correcao
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICACAO POS-CORRECAO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$StartDate = (Get-Date).AddHours(-1)
$TotalErrors = 0

# Verificar erros do Sistema
Write-Host "`n[1/3] Verificando erros do Sistema..." -ForegroundColor Green
$SystemErrors = Get-WinEvent -FilterHashtable @{
    LogName='System'
    Level=1,2
    StartTime=$StartDate
} -MaxEvents 50 -ErrorAction SilentlyContinue

if ($SystemErrors) {
    $TotalErrors += $SystemErrors.Count
    Write-Host "  Encontrados $($SystemErrors.Count) erros no Sistema" -ForegroundColor Yellow
    $SystemErrors | Select-Object -First 3 | ForEach-Object {
        Write-Host "    - [$($_.LevelDisplayName)] $($_.ProviderName): $($_.Message.Substring(0, [Math]::Min(100, $_.Message.Length)))..." -ForegroundColor Gray
    }
} else {
    Write-Host "  Nenhum erro critico/erro encontrado no Sistema" -ForegroundColor Green
}

# Verificar erros de Aplicacao
Write-Host "`n[2/3] Verificando erros de Aplicacao..." -ForegroundColor Green
$AppErrors = Get-WinEvent -FilterHashtable @{
    LogName='Application'
    Level=1,2
    StartTime=$StartDate
} -MaxEvents 50 -ErrorAction SilentlyContinue

if ($AppErrors) {
    $TotalErrors += $AppErrors.Count
    Write-Host "  Encontrados $($AppErrors.Count) erros de Aplicacao" -ForegroundColor Yellow
    $AppErrors | Select-Object -First 3 | ForEach-Object {
        Write-Host "    - [$($_.LevelDisplayName)] $($_.ProviderName): $($_.Message.Substring(0, [Math]::Min(100, $_.Message.Length)))..." -ForegroundColor Gray
    }
} else {
    Write-Host "  Nenhum erro encontrado em Aplicacao" -ForegroundColor Green
}

# Verificar erros TCP/IP
Write-Host "`n[3/3] Verificando erros TCP/IP..." -ForegroundColor Green
$TcpErrors = Get-WinEvent -FilterHashtable @{
    LogName='System'
    ProviderName='Tcpip'
    StartTime=$StartDate
} -MaxEvents 50 -ErrorAction SilentlyContinue

if ($TcpErrors) {
    $TotalErrors += $TcpErrors.Count
    Write-Host "  Encontrados $($TcpErrors.Count) erros TCP/IP" -ForegroundColor Yellow
} else {
    Write-Host "  Nenhum erro TCP/IP encontrado" -ForegroundColor Green
}

# Resumo
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMO DA VERIFICACAO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total de erros na ultima hora: $TotalErrors" -ForegroundColor White

if ($TotalErrors -eq 0) {
    Write-Host "`nSistema funcionando normalmente!" -ForegroundColor Green
    Write-Host "Todas as correcoes foram aplicadas com sucesso." -ForegroundColor Green
} else {
    Write-Host "`nAinda existem erros que precisam de atencao." -ForegroundColor Yellow
    Write-Host "Alguns erros podem necessitar de reinicializacao do sistema." -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PROXIMOS PASSOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. REINICIE O COMPUTADOR para aplicar todas as mudancas" -ForegroundColor White
Write-Host "2. Apos reiniciar, execute novamente a verificacao" -ForegroundColor White
Write-Host "3. Para o EasyAntiCheat, faca o download e instale manualmente" -ForegroundColor White
Write-Host "   de https://www.easyanticheat.net/download/" -ForegroundColor White