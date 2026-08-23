@echo off
title Limpeza de Lixo Digital - Windows
color 0C
echo ========================================
echo   LIMPEZA DE LIXO DIGITAL
echo ========================================
echo.
echo Este script remove:
echo   - Atalhos quebrados do Menu Inicio
echo   - Atalhos quebrados da Area de Trabalho
echo   - Entradas quebradas no Registro
echo   - Servico quebrado do TikTok
echo.
echo IMPORTANTE: Execute como Administrador!
echo.
echo [1] Iniciar Limpeza
echo [2] Sair
echo.
set /p choice="Escolha (1-2): "
if "%choice%"=="1" goto CLEAN
if "%choice%"=="2" goto EXIT
echo Opcao invalida!
pause
goto MENU

:CLEAN
echo.
echo ========================================
echo   FASE 1: ATALHOS QUEBRADOS
echo ========================================
echo.

echo Removendo atalhos quebrados do Menu Inicio...
echo.

REM GIMP
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GIMP 3.2.4.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GIMP 3.2.4.lnk" 2>nul && echo   [OK] GIMP 3.2.4
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GIMP 3.0.6-1.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GIMP 3.0.6-1.lnk" 2>nul && echo   [OK] GIMP 3.0.6-1

REM Blender
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Blender\Blender 5.1.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Blender\Blender 5.1.lnk" 2>nul && echo   [OK] Blender 5.1
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Blender\Blender 4.4.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Blender\Blender 4.4.lnk" 2>nul && echo   [OK] Blender 4.4

REM Emacs
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Emacs-30.2\Emacs.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Emacs-30.2\Emacs.lnk" 2>nul && echo   [OK] Emacs
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Emacs-30.2\Uninstall.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Emacs-30.2\Uninstall.lnk" 2>nul && echo   [OK] Emacs Uninstall

REM Python 3.8
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Python 3.8" rmdir /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Python 3.8" 2>nul && echo   [OK] Python 3.8

REM Arduino
if exist "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Arduino IDE.lnk" del "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\Arduino IDE.lnk" 2>nul && echo   [OK] Arduino IDE

REM TikTok
if exist "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\TikTok LIVE Studio.lnk" del "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\TikTok LIVE Studio.lnk" 2>nul && echo   [OK] TikTok LIVE Studio

echo.
echo Removendo atalhos quebrados da Area de Trabalho...

REM Area de Trabalho (OneDrive)
set "DESKTOP=%USERPROFILE%\OneDrive\Area de Trabalho"
if exist "%DESKTOP%\Blender 4.4.lnk" del "%DESKTOP%\Blender 4.4.lnk" 2>nul && echo   [OK] Blender 4.4
if exist "%DESKTOP%\Blender 5.1.lnk" del "%DESKTOP%\Blender 5.1.lnk" 2>nul && echo   [OK] Blender 5.1
if exist "%DESKTOP%\facebook.lnk" del "%DESKTOP%\facebook.lnk" 2>nul && echo   [OK] facebook
if exist "%DESKTOP%\Firefox.lnk" del "%DESKTOP%\Firefox.lnk" 2>nul && echo   [OK] Firefox
if exist "%DESKTOP%\GIMP 3.0.4.lnk" del "%DESKTOP%\GIMP 3.0.4.lnk" 2>nul && echo   [OK] GIMP 3.0.4
if exist "%DESKTOP%\GIMP 3.0.6-1.lnk" del "%DESKTOP%\GIMP 3.0.6-1.lnk" 2>nul && echo   [OK] GIMP 3.0.6-1
if exist "%DESKTOP%\GIMP 3.2.4.lnk" del "%DESKTOP%\GIMP 3.2.4.lnk" 2>nul && echo   [OK] GIMP 3.2.4
if exist "%DESKTOP%\Modernize Launcher.lnk" del "%DESKTOP%\Modernize Launcher.lnk" 2>nul && echo   [OK] Modernize Launcher
if exist "%DESKTOP%\Process Hacker 2.lnk" del "%DESKTOP%\Process Hacker 2.lnk" 2>nul && echo   [OK] Process Hacker 2

echo.
echo ========================================
echo   FASE 2: SERVICO QUEBRADO
echo ========================================
echo.

echo Removendo servico TikTok LiveStudioElevationService...
sc stop LiveStudioElevationService 2>nul
sc delete LiveStudioElevationService 2>nul && echo   [OK] Servico removido || echo   [INFO] Servico ja nao existe

echo.
echo ========================================
echo   FASE 3: REGISTRO (ATALHOS QUEBRADOS)
echo ========================================
echo.

echo Limpando entradas quebradas no Registro...
echo.

REM Software que nao existe mais em D:\softwares
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Blender" /f 2>nul && echo   [OK] Blender (registro)
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\GIMP" /f 2>nul && echo   [OK] GIMP (registro)

REM TikTok
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TikTok LIVE Studio" /f 2>nul && echo   [OK] TikTok LIVE Studio (registro)

echo.
echo ========================================
echo   FASE 4: LIMPEZA DE CACHE
echo ========================================
echo.

echo Limpando cache de atalhos...
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\RecentlyDeleted\*.lnk" 2>nul
echo   [OK] Cache de atalhos limpo

echo.
echo ========================================
echo   LIMPEZA CONCLUIDA!
echo ========================================
echo.
echo Proximos passos:
echo   1. Reinicie o computador
echo   2. Verifique se os erros sumiram
echo.
pause
goto MENU

:EXIT
exit