# Get-EventViewerErrors.ps1 - Consulta abrangente de erros no Event Viewer
# Autor: Assistente PowerShell
# Data: $(Get-Date)

param(
    [int]$DaysBack = 7,
    [int]$MaxEvents = 100,
    [string]$OutputPath = "$env:USERPROFILE\Documents",
    [switch]$HTMLReport,
    [switch]$DetailedLog
)

# Configurações
$ErrorActionPreference = "Continue"
$ReportDate = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ComputerName = $env:COMPUTERNAME

# Cores para o console
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "CONSULTA DE ERROS - EVENT VIEWER" "Cyan"
Write-ColorOutput "Computador: $ComputerName" "Yellow"
Write-ColorOutput "Periodo: Ultimos $DaysBack dias" "Yellow"
Write-ColorOutput "Data/Hora: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" "Yellow"
Write-ColorOutput "========================================" "Cyan"

# Função para obter erros do Sistema
function Get-SystemErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[1/7] Consultando erros do Sistema..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Erros críticos e erros
        $SystemErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            Level=1,2
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($SystemErrors) {
            foreach ($Event in $SystemErrors) {
                $Errors += [PSCustomObject]@{
                    Log = "System"
                    Time = $Event.TimeCreated
                    Level = $Event.LevelDisplayName
                    ID = $Event.Id
                    Source = $Event.ProviderName
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($SystemErrors.Count) erros no Sistema" "Yellow"
        } else {
            Write-ColorOutput "  Nenhum erro critico/erro encontrado no Sistema" "Gray"
        }
        
        # Alertas
        $SystemWarnings = Get-WinEvent -FilterHashtable @{
            LogName='System'
            Level=3
            StartTime=$StartDate
        } -MaxEvents 50 -ErrorAction SilentlyContinue
        
        if ($SystemWarnings) {
            foreach ($Event in $SystemWarnings) {
                $Errors += [PSCustomObject]@{
                    Log = "System"
                    Time = $Event.TimeCreated
                    Level = $Event.LevelDisplayName
                    ID = $Event.Id
                    Source = $Event.ProviderName
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($SystemWarnings.Count) alertas no Sistema" "Yellow"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Sistema: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Aplicação
function Get-ApplicationErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[2/7] Consultando erros de Aplicacao..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Erros de aplicação
        $AppErrors = Get-WinEvent -FilterHashtable @{
            LogName='Application'
            Level=1,2
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($AppErrors) {
            foreach ($Event in $AppErrors) {
                $Errors += [PSCustomObject]@{
                    Log = "Application"
                    Time = $Event.TimeCreated
                    Level = $Event.LevelDisplayName
                    ID = $Event.Id
                    Source = $Event.ProviderName
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($AppErrors.Count) erros de Aplicacao" "Yellow"
        } else {
            Write-ColorOutput "  Nenhum erro encontrado em Aplicacao" "Gray"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Aplicacao: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Segurança
function Get-SecurityErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[3/7] Consultando erros de Seguranca..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Falhas de login (Event ID 4625)
        $LoginFailures = Get-WinEvent -FilterHashtable @{
            LogName='Security'
            Id=4625
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($LoginFailures) {
            foreach ($Event in $LoginFailures) {
                $Errors += [PSCustomObject]@{
                    Log = "Security"
                    Time = $Event.TimeCreated
                    Level = "Error"
                    ID = $Event.Id
                    Source = "Logon Failure"
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontradas $($LoginFailures.Count) falhas de login" "Yellow"
        } else {
            Write-ColorOutput "  Nenhuma falha de login encontrada" "Gray"
        }
        
        # Login com credenciais explícitas (Event ID 4648)
        $ExplicitLogins = Get-WinEvent -FilterHashtable @{
            LogName='Security'
            Id=4648
            StartTime=$StartDate
        } -MaxEvents 50 -ErrorAction SilentlyContinue
        
        if ($ExplicitLogins) {
            Write-ColorOutput "  Encontrados $($ExplicitLogins.Count) logins com credenciais explicitas" "Yellow"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Seguranca: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Rede
function Get-NetworkErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[4/7] Consultando erros de Rede..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Erros TCP/IP (Event IDs 4227, 4231, 4266)
        $TcpErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            ProviderName='Tcpip'
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($TcpErrors) {
            foreach ($Event in $TcpErrors) {
                if ($Event.Level -le 3) { # Critical, Error, Warning
                    $Errors += [PSCustomObject]@{
                        Log = "System"
                        Time = $Event.TimeCreated
                        Level = $Event.LevelDisplayName
                        ID = $Event.Id
                        Source = "Tcpip"
                        Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                    }
                }
            }
            Write-ColorOutput "  Encontrados $($TcpErrors.Count) erros de Rede TCP/IP" "Yellow"
        } else {
            Write-ColorOutput "  Nenhum erro de Rede TCP/IP encontrado" "Gray"
        }
        
        # Erros DNS (Event ID 1014)
        $DnsErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            Id=1014
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($DnsErrors) {
            Write-ColorOutput "  Encontrados $($DnsErrors.Count) erros de DNS" "Yellow"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Rede: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Serviços
function Get-ServiceErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[5/7] Consultando erros de Servicos..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Serviço terminou com erro (Event ID 7023)
        $ServiceErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            ProviderName='Service Control Manager'
            Id=7023
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($ServiceErrors) {
            foreach ($Event in $ServiceErrors) {
                $Errors += [PSCustomObject]@{
                    Log = "System"
                    Time = $Event.TimeCreated
                    Level = "Error"
                    ID = $Event.Id
                    Source = "Service Control Manager"
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($ServiceErrors.Count) erros de Servicos (7023)" "Yellow"
        }
        
        # Falha ao iniciar serviço (Event ID 7026)
        $ServiceStartErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            ProviderName='Service Control Manager'
            Id=7026
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($ServiceStartErrors) {
            Write-ColorOutput "  Encontrados $($ServiceStartErrors.Count) erros ao iniciar servicos (7026)" "Yellow"
        }
        
        # Serviço terminou inesperadamente (Event ID 7031)
        $ServiceUnexpected = Get-WinEvent -FilterHashtable @{
            LogName='System'
            ProviderName='Service Control Manager'
            Id=7031
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($ServiceUnexpected) {
            Write-ColorOutput "  Encontrados $($ServiceUnexpected.Count) servicos que terminaram inesperadamente (7031)" "Yellow"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Servicos: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Windows Update
function Get-WindowsUpdateErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[6/7] Consultando erros de Windows Update..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Erros de Windows Update
        $UpdateErrors = Get-WinEvent -FilterHashtable @{
            LogName='Microsoft-Windows-WindowsUpdateClient/Operational'
            Level=1,2
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($UpdateErrors) {
            foreach ($Event in $UpdateErrors) {
                $Errors += [PSCustomObject]@{
                    Log = "WindowsUpdate"
                    Time = $Event.TimeCreated
                    Level = $Event.LevelDisplayName
                    ID = $Event.Id
                    Source = "WindowsUpdateClient"
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($UpdateErrors.Count) erros de Windows Update" "Yellow"
        } else {
            Write-ColorOutput "  Nenhum erro de Windows Update encontrado" "Gray"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Windows Update: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para obter erros de Certificados
function Get-CertificateErrors {
    param([int]$DaysBack, [int]$MaxEvents)
    
    Write-ColorOutput "`n[7/7] Consultando erros de Certificados..." "Green"
    
    $StartDate = (Get-Date).AddDays(-$DaysBack)
    $Errors = @()
    
    try {
        # Erros de certificados (Event ID 87)
        $CertErrors = Get-WinEvent -FilterHashtable @{
            LogName='Application'
            ProviderName='Microsoft-Windows-CertificateServicesClient-CertEnroll'
            Id=87
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($CertErrors) {
            foreach ($Event in $CertErrors) {
                $Errors += [PSCustomObject]@{
                    Log = "Application"
                    Time = $Event.TimeCreated
                    Level = "Error"
                    ID = $Event.Id
                    Source = "CertEnroll"
                    Message = $Event.Message.Substring(0, [Math]::Min(200, $Event.Message.Length))
                }
            }
            Write-ColorOutput "  Encontrados $($CertErrors.Count) erros de Certificados (87)" "Yellow"
        } else {
            Write-ColorOutput "  Nenhum erro de Certificado encontrado" "Gray"
        }
        
        # Erros de COM/DCOM (Event ID 10016)
        $ComErrors = Get-WinEvent -FilterHashtable @{
            LogName='System'
            ProviderName='Microsoft-Windows-DistributedCOM'
            Id=10016
            StartTime=$StartDate
        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
        
        if ($ComErrors) {
            Write-ColorOutput "  Encontrados $($ComErrors.Count) erros COM/DCOM (10016)" "Yellow"
        }
    } catch {
        Write-ColorOutput "  Erro ao consultar Certificados: $($_.Exception.Message)" "Red"
    }
    
    return $Errors
}

# Função para gerar relatório HTML
function Generate-HTMLReport {
    param([array]$AllErrors, [string]$OutputPath, [string]$ReportDate)
    
    Write-ColorOutput "`nGerando relatorio HTML..." "Green"
    
    $HTMLContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Relatorio de Erros - Event Viewer</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; text-align: center; }
        h2 { color: #34495e; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .summary { background-color: #ecf0f1; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .summary-item { display: inline-block; margin: 10px 20px; }
        .summary-number { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .summary-label { color: #7f8c8d; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #3498db; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .error { background-color: #fee; }
        .warning { background-color: #ffd; }
        .critical { background-color: #fdd; }
        .info { background-color: #dff; }
        .footer { text-align: center; margin-top: 30px; color: #7f8c8d; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Relatorio de Erros - Event Viewer</h1>
        <p style="text-align: center;">Computador: $ComputerName | Data: $ReportDate</p>
        
        <div class="summary">
            <h2>Resumo Executivo</h2>
            <div class="summary-item">
                <div class="summary-number">$($AllErrors.Count)</div>
                <div class="summary-label">Total de Erros</div>
            </div>
            <div class="summary-item">
                <div class="summary-number">$(($AllErrors | Where-Object { $_.Level -eq 'Critical' }).Count)</div>
                <div class="summary-label">Criticos</div>
            </div>
            <div class="summary-item">
                <div class="summary-number">$(($AllErrors | Where-Object { $_.Level -eq 'Error' }).Count)</div>
                <div class="summary-label">Erros</div>
            </div>
            <div class="summary-item">
                <div class="summary-number">$(($AllErrors | Where-Object { $_.Level -eq 'Warning' }).Count)</div>
                <div class="summary-label">Alertas</div>
            </div>
        </div>
        
        <h2>Detalhes dos Erros</h2>
        <table>
            <tr>
                <th>Log</th>
                <th>Data/Hora</th>
                <th>Nivel</th>
                <th>ID</th>
                <th>Fonte</th>
                <th>Mensagem</th>
            </tr>
"@
    
    foreach ($Error in $AllErrors | Sort-Object Time -Descending) {
        $RowClass = switch ($Error.Level) {
            "Critical" { "critical" }
            "Error" { "error" }
            "Warning" { "warning" }
            default { "info" }
        }
        
        $HTMLContent += @"
            <tr class="$RowClass">
                <td>$($Error.Log)</td>
                <td>$($Error.Time.ToString('dd/MM/yyyy HH:mm:ss'))</td>
                <td>$($Error.Level)</td>
                <td>$($Error.ID)</td>
                <td>$($Error.Source)</td>
                <td>$($Error.Message)</td>
            </tr>
"@
    }
    
    $HTMLContent += @"
        </table>
        
        <h2>Recomendacoes</h2>
        <ul>
            <li><strong>Event ID 10016 (COM/DCOM):</strong> Execute .\Fix-COMPermission.ps1</li>
            <li><strong>Event ID 4266 (UDP):</strong> Execute .\Fix-UDP-PortExhaustion.ps1</li>
            <li><strong>Event ID 7023 (Servico):</strong> Verifique e reinicie o servico</li>
            <li><strong>Event ID 87 (Certificado):</strong> Execute .\Fix-AMD-AIK-Certificate.ps1</li>
            <li><strong>Event ID 1000 (Falha):</strong> Verifique o aplicativo, reinstale se necessario</li>
            <li><strong>Event ID 4625 (Login):</strong> Verifique credenciais, bloqueie se suspeito</li>
        </ul>
        
        <div class="footer">
            <p>Relatorio gerado automaticamente por Get-EventViewerErrors.ps1</p>
            <p>Data de geracao: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')</p>
        </div>
    </div>
</body>
</html>
"@
    
    $ReportPath = Join-Path $OutputPath "EventViewer-Report-$ReportDate.html"
    $HTMLContent | Out-File -FilePath $ReportPath -Encoding UTF8
    
    Write-ColorOutput "Relatorio HTML salvo em: $ReportPath" "Green"
    return $ReportPath
}

# Função para gerar log detalhado
function Generate-DetailedLog {
    param([array]$AllErrors, [string]$OutputPath, [string]$ReportDate)
    
    Write-ColorOutput "`nGerando log detalhado..." "Green"
    
    $LogPath = Join-Path $OutputPath "EventViewer-Log-$ReportDate.txt"
    
    $LogContent = @"
========================================
LOG DETALHADO - EVENT VIEWER
Computador: $ComputerName
Data/Hora: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Periodo: Ultimos $DaysBack dias
========================================

RESUMO:
- Total de erros: $($AllErrors.Count)
- Criticos: $(($AllErrors | Where-Object { $_.Level -eq 'Critical' }).Count)
- Erros: $(($AllErrors | Where-Object { $_.Level -eq 'Error' }).Count)
- Alertas: $(($AllErrors | Where-Object { $_.Level -eq 'Warning' }).Count)

========================================
DETALHES DOS ERROS:
========================================

"@
    
    foreach ($Error in $AllErrors | Sort-Object Time -Descending) {
        $LogContent += @"
[$($Error.Time.ToString('dd/MM/yyyy HH:mm:ss'))] [$($Error.Level)] [$($Error.Log)]
ID: $($Error.ID) | Fonte: $($Error.Source)
Mensagem: $($Error.Message)
----------------------------------------

"@
    }
    
    $LogContent += @"

========================================
FIM DO LOG
========================================
"@
    
    $LogContent | Out-File -FilePath $LogPath -Encoding UTF8
    
    Write-ColorOutput "Log detalhado salvo em: $LogPath" "Green"
    return $LogPath
}

# Função para gerar resumo
function Generate-Summary {
    param([array]$AllErrors)
    
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "RESUMO DA CONSULTA" "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    
    Write-ColorOutput "`nTotal de erros encontrados: $($AllErrors.Count)" "Yellow"
    
    if ($AllErrors.Count -gt 0) {
        # Contagem por nível
        $CriticalCount = ($AllErrors | Where-Object { $_.Level -eq 'Critical' }).Count
        $ErrorCount = ($AllErrors | Where-Object { $_.Level -eq 'Error' }).Count
        $WarningCount = ($AllErrors | Where-Object { $_.Level -eq 'Warning' }).Count
        
        Write-ColorOutput "`nPor nivel:" "White"
        Write-ColorOutput "  Criticos: $CriticalCount" "Red"
        Write-ColorOutput "  Erros: $ErrorCount" "Yellow"
        Write-ColorOutput "  Alertas: $WarningCount" "Gray"
        
        # Contagem por log
        Write-ColorOutput "`nPor log:" "White"
        $AllErrors | Group-Object Log | ForEach-Object {
            Write-ColorOutput "  $($_.Name): $($_.Count)" "Gray"
        }
        
        # Top 5 fontes mais comuns
        Write-ColorOutput "`nTop 5 fontes de erros:" "White"
        $AllErrors | Group-Object Source | Sort-Object Count -Descending | Select-Object -First 5 | ForEach-Object {
            Write-ColorOutput "  $($_.Name): $($_.Count) erros" "Gray"
        }
        
        # Últimos 5 erros
        Write-ColorOutput "`nUltimos 5 erros:" "White"
        $AllErrors | Sort-Object Time -Descending | Select-Object -First 5 | ForEach-Object {
            Write-ColorOutput "  [$($_.Time.ToString('dd/MM HH:mm'))] [$($_.Level)] $($_.Source): $($_.Message.Substring(0, [Math]::Min(100, $_.Message.Length)))..." "Gray"
        }
        
        # Recomendações
        Write-ColorOutput "`n========================================" "Cyan"
        Write-ColorOutput "RECOMENDACOES" "Cyan"
        Write-ColorOutput "========================================" "Cyan"
        
        $HasCOM = $AllErrors | Where-Object { $_.ID -eq 10016 }
        $HasUDP = $AllErrors | Where-Object { $_.ID -eq 4266 }
        $HasService = $AllErrors | Where-Object { $_.ID -eq 7023 }
        $HasCert = $AllErrors | Where-Object { $_.ID -eq 87 }
        $HasLogin = $AllErrors | Where-Object { $_.ID -eq 4625 }
        
        if ($HasCOM) {
            Write-ColorOutput "  - Execute .\Fix-COMPermission.ps1 para erros COM/DCOM" "Yellow"
        }
        if ($HasUDP) {
            Write-ColorOutput "  - Execute .\Fix-UDP-PortExhaustion.ps1 para erros UDP" "Yellow"
        }
        if ($HasService) {
            Write-ColorOutput "  - Verifique e reinicie servicos com erro" "Yellow"
        }
        if ($HasCert) {
            Write-ColorOutput "  - Execute .\Fix-AMD-AIK-Certificate.ps1 para erros de certificado" "Yellow"
        }
        if ($HasLogin) {
            Write-ColorOutput "  - Verifique tentativas de login suspeitas" "Yellow"
        }
    } else {
        Write-ColorOutput "`nNenhum erro critico encontrado nos ultimos $DaysBack dias!" "Green"
        Write-ColorOutput "Seu sistema esta saudavel." "Green"
    }
    
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "CONSULTA FINALIZADA" "Cyan"
    Write-ColorOutput "========================================" "Cyan"
}

# Função principal
function Main {
    Write-ColorOutput "Iniciando consulta de erros no Event Viewer..." "Cyan"
    
    # Criar diretório de saída se não existir
    if (!(Test-Path -Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        Write-ColorOutput "Diretorio de saida criado: $OutputPath" "Gray"
    }
    
    # Coletar erros de todas as categorias
    $AllErrors = @()
    
    $AllErrors += Get-SystemErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-ApplicationErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-SecurityErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-NetworkErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-ServiceErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-WindowsUpdateErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    $AllErrors += Get-CertificateErrors -DaysBack $DaysBack -MaxEvents $MaxEvents
    
    # Gerar resumo
    Generate-Summary -AllErrors $AllErrors
    
    # Gerar relatório HTML se solicitado
    if ($HTMLReport) {
        $ReportPath = Generate-HTMLReport -AllErrors $AllErrors -OutputPath $OutputPath -ReportDate $ReportDate
        Start-Process $ReportPath
    }
    
    # Gerar log detalhado se solicitado
    if ($DetailedLog) {
        $LogPath = Generate-DetailedLog -AllErrors $AllErrors -OutputPath $OutputPath -ReportDate $ReportDate
    }
    
    # Sempre gerar resumo em texto
    $SummaryPath = Join-Path $OutputPath "EventViewer-Summary-$ReportDate.txt"
    $AllErrors | Sort-Object Time -Descending | Format-Table Log, Time, Level, ID, Source, Message -AutoSize | Out-File -FilePath $SummaryPath -Encoding UTF8
    Write-ColorOutput "`nResumo salvo em: $SummaryPath" "Green"
}

# Executar script
Main