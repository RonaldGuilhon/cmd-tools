@echo off
title Ferramenta de Utilitarios Avancada
color 0A

:inicio
cls
echo =====================================
echo        PAINEL DE MANUTENCAO
echo =====================================
echo [1] Rede
echo [2] Disco
echo [3] Sistema
echo [4] Limpeza
echo [5] Seguranca
echo [6] Atualizacoes
echo [7] Sair
echo =====================================
set /p op=Escolha uma opcao: 

if "%op%"=="1" goto rede
if "%op%"=="2" goto disco
if "%op%"=="3" goto sistema
if "%op%"=="4" goto limpeza
if "%op%"=="5" goto seguranca
if "%op%"=="6" goto atualizacoes
if "%op%"=="7" exit

goto inicio

:: ================== SUBMENU REDE ==================
:rede
cls
echo ========= MENU REDE =========
echo [1] Mostrar configuracoes IP
echo [2] Limpar DNS
echo [3] Testar conexao Google (ping)
echo [4] Voltar
set /p op=Opcao: 

if "%op%"=="1" ipconfig /all & pause & goto rede
if "%op%"=="2" ipconfig /flushdns & pause & goto rede
if "%op%"=="3" ping 8.8.8.8 & pause & goto rede
if "%op%"=="4" goto inicio
goto rede

:: ================== SUBMENU DISCO ==================
:disco
cls
echo ========= MENU DISCO =========
echo [1] Verificar disco C:
echo [2] Desfragmentar disco C:
echo [3] Mostrar uso de espaco em disco
echo [4] Voltar
set /p op=Opcao: 

if "%op%"=="1" chkdsk C: /f & pause & goto disco
if "%op%"=="2" defrag C: /U /V & pause & goto disco
if "%op%"=="3" dir C:\ /s & pause & goto disco
if "%op%"=="4" goto inicio
goto disco

:: ================== SUBMENU SISTEMA ==================
:sistema
cls
echo ========= MENU SISTEMA =========
echo [1] Informacoes do sistema
echo [2] Lista de processos
echo [3] Finalizar processo
echo [4] Voltar
set /p op=Opcao: 

if "%op%"=="1" systeminfo & pause & goto sistema
if "%op%"=="2" tasklist & pause & goto sistema
if "%op%"=="3" (
    set /p proc=Digite o nome do processo (ex: chrome.exe): 
    taskkill /IM %proc% /F
    pause
    goto sistema
)
if "%op%"=="4" goto inicio
goto sistema

:: ================== SUBMENU LIMPEZA ==================
:limpeza
cls
echo ========= MENU LIMPEZA =========
echo [1] Limpar pasta TEMP do usuario
echo [2] Limpar pasta TEMP do Windows
echo [3] Executar Limpeza de Disco
echo [4] Voltar
set /p op=Opcao: 

if "%op%"=="1" del /s /q %temp%\* & pause & goto limpeza
if "%op%"=="2" del /s /q C:\Windows\Temp\* & pause & goto limpeza
if "%op%"=="3" cleanmgr /sagerun:1 & pause & goto limpeza
if "%op%"=="4" goto inicio
goto limpeza

::SegurancaMenu
:seguranca
cls
echo ========= MENU SEGURANCA =========
echo [1] Verificar arquivos do sistema (SFC)
echo [2] Reparar imagem do Windows (DISM)
echo [3] Visualizar logs de eventos
echo [4] Verificacao de virus (Windows Defender)
echo [5] Voltar
set /p op=Opcao: 

if "%op%"=="1" sfc /scannow & pause & goto seguranca
if "%op%"=="2" dism /online /cleanup-image /restorehealth & pause & goto seguranca
if "%op%"=="3" eventvwr & pause & goto seguranca
if "%op%"=="4" goto antivirus
if "%op%"=="5" goto inicio
goto seguranca

:: ================== SUBMENU ATUALIZACOES ==================
:atualizacoes
cls
echo ========= MENU ATUALIZACOES =========
echo [1] Atualizar drivers
echo [2] Atualizar software (winget)
echo [3] Verificar atualizacoes do Windows
echo [4] Voltar
set /p op=Opcao: 

if "%op%"=="1" goto drivers
if "%op%"=="2" goto software
if "%op%"=="3" goto windowsupdate
if "%op%"=="4" goto inicio
goto atualizacoes

:: ================== VERIFICACAO DE VIRUS ==================
:antivirus
cls
echo Executando verificacao de virus com Windows Defender...
echo Isso pode levar alguns minutos...
powershell -Command "Start-MpScan -ScanType QuickScan"
if %errorlevel% equ 0 (
    echo Verificacao concluida com sucesso!
) else (
    echo Erro na verificacao. Verifique se o Windows Defender esta ativo.
)
pause
goto seguranca

:: ================== ATUALIZACAO DE DRIVERS ==================
:drivers
cls
echo Verificando drivers desatualizados...
echo Isso pode levar alguns minutos...
powershell -Command "Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DeviceName -ne $null} | Select-Object DeviceName, DriverVersion, DriverDate | Sort-Object DeviceName | Format-Table -AutoSize"
echo.
echo Para atualizar drivers automaticamente, execute:
echo powershell -Command "Install-Module PSWindowsUpdate -Force; Get-WUDriver"
echo.
set /p update=Deseja tentar atualizar drivers automaticamente? (s/n): 
if /i "%update%"=="s" (
    powershell -Command "try { Install-Module PSWindowsUpdate -Force -Scope CurrentUser; Import-Module PSWindowsUpdate; Get-WUDriver -Install -AcceptAll } catch { Write-Host 'Erro: Instale o modulo PSWindowsUpdate manualmente' }"
)
pause
goto atualizacoes

:: ================== ATUALIZACAO DE SOFTWARE ==================
:software
cls
echo Verificando software instalado e atualizacoes disponiveis...
winget list --upgrade-available
echo.
set /p update=Deseja atualizar todos os programas? (s/n): 
if /i "%update%"=="s" (
    echo Atualizando todos os programas...
    winget upgrade --all --accept-package-agreements --accept-source-agreements
) else (
    echo Para atualizar um programa especifico, use:
    echo winget upgrade [nome-do-programa]
)
pause
goto atualizacoes

:: ================== ATUALIZACOES DO WINDOWS ==================
:windowsupdate
cls
echo Verificando atualizacoes do Windows...
echo Abrindo Windows Update...
start ms-settings:windowsupdate
echo.
echo Alternativamente, execute no PowerShell como administrador:
echo Install-Module PSWindowsUpdate -Force
echo Get-WUInstall -AcceptAll -AutoReboot
pause
goto atualizacoes
