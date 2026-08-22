@echo off
echo ========================================
echo INSTALACAO EASYANTICHEAT - APEX LEGENDS
echo ========================================
echo.
echo Produto: Apex Legends
echo ID: 5dcd88f4e2094a698ebffa43438edc33
echo.

echo Verificando se o setup existe...
if not exist "EasyAntiCheat_EOS_Setup.exe" (
    echo ERRO: EasyAntiCheat_EOS_Setup.exe nao encontrado!
    echo Execute este script na pasta: D:\games\fps\Apex\EasyAntiCheat
    pause
    exit /b 1
)

echo Instalando EasyAntiCheat...
echo.
EasyAntiCheat_EOS_Setup.exe install 5dcd88f4e2094a698ebffa43438edc33
echo.

if %errorlevel% equ 0 (
    echo ========================================
    echo INSTALACAO CONCLUIDA COM SUCESSO!
    echo ========================================
    echo.
    echo O servico EasyAntiCheat_EOS foi instalado.
    echo Voce pode iniciar o Apex Legends agora.
) else (
    echo ========================================
    echo ERRO NA INSTALACAO!
    echo ========================================
    echo.
    echo Codigo de erro: %errorlevel%
    echo.
    echo Possiveis solucoes:
    Execute este script como Administrador
    Verifique se o antivirus nao esta bloqueando
)

echo.
pause