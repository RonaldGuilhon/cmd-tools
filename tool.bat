@echo off
title Ferramenta de Utilitários Windows
color 0A

:menu
cls
echo ===============================
echo     MENU DE MANUTENCAO
echo ===============================
echo [1] Limpar pasta TEMP
echo [2] Desfragmentar disco C:
echo [3] Verificar disco C:
echo [4] Informacoes do sistema
echo [5] Limpar DNS
echo [6] Verificar arquivos do sistema (SFC)
echo [7] Sair
echo ===============================
set /p op=Escolha uma opcao: 

if "%op%"=="1" goto limparTemp
if "%op%"=="2" goto defrag
if "%op%"=="3" goto chkdsk
if "%op%"=="4" goto sysinfo
if "%op%"=="5" goto dns
if "%op%"=="6" goto sfc
if "%op%"=="7" exit

goto menu

:limparTemp
echo Limpando pasta TEMP...
del /s /q %temp%\*
del /s /q C:\Windows\Temp\*
pause
goto menu

:defrag
echo Desfragmentando disco C:
defrag C: /U /V
pause
goto menu

:chkdsk
echo Verificando disco C:
chkdsk C: /f
pause
goto menu

:sysinfo
systeminfo
pause
goto menu

:dns
ipconfig /flushdns
pause
goto menu

:sfc
sfc /scannow
pause
goto menu
