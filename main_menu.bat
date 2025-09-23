@echo off
setlocal enabledelayedexpansion
title Main Menu
color 0F
mode con: cols=110 lines=30

:: Configurar janela centralizada e não redimensionável
powershell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Win32 { [DllImport(\"user32.dll\")] public static extern IntPtr GetConsoleWindow(); [DllImport(\"user32.dll\")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags); [DllImport(\"user32.dll\")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect); [DllImport(\"user32.dll\")] public static extern IntPtr GetSystemMetrics(int nIndex); public struct RECT { public int Left; public int Top; public int Right; public int Bottom; } }'; $hwnd = [Win32]::GetConsoleWindow(); $screenWidth = [Win32]::GetSystemMetrics(0); $screenHeight = [Win32]::GetSystemMetrics(1); $windowWidth = 880; $windowHeight = 600; $x = ($screenWidth - $windowWidth) / 2; $y = ($screenHeight - $windowHeight) / 2; [Win32]::SetWindowPos($hwnd, 0, $x, $y, $windowWidth, $windowHeight, 0x0040)"

:main_menu
cls
echo.
echo +======================================================================================================+
echo ^|                                              Main Menu                                               ^|
echo +======================================================================================================+
echo ^|                                                                                                      ^|
echo ^|  Ferramentas de Sistema                          Atalhos de Pastas                                   ^|
echo ^|  ===========================                     =======================                             ^|
echo ^|                                                                                                      ^|
echo ^|  1. Rede                                         a. D:\PROGRAMAS INSTALADOS                          ^|
echo ^|  2. Disco                                        b. D:\Games                                         ^|
echo ^|  3. Sistema                                      c. D:\Games\trainers                                ^|
echo ^|  4. Limpeza                                      d. D:\Emulador                                      ^|
echo ^|  5. Seguranca                                                                                        ^|
echo ^|  6. Atualizacoes                                                                                     ^|
echo ^|                                                                                                      ^|
echo ^|                                                                                                      ^|
echo ^|                                                  Outros                                              ^|
echo ^|                                                  =======                                             ^|
echo ^|                                                                                                      ^|
echo ^|                                                  0. Sair                                             ^|
echo ^|                                                                                                      ^|
echo ^|                                                                                                      ^|
echo ^|                                                                                                      ^|
echo +======================================================================================================+
echo.
set /p choice=Digite sua opcao: 

:: Processar escolhas das ferramentas de sistema
if "%choice%"=="1" goto rede
if "%choice%"=="2" goto disco
if "%choice%"=="3" goto sistema
if "%choice%"=="4" goto limpeza
if "%choice%"=="5" goto seguranca
if "%choice%"=="6" goto atualizacoes

:: Processar escolhas dos atalhos de pastas
if /i "%choice%"=="a" goto pasta1
if /i "%choice%"=="b" goto pasta2
if /i "%choice%"=="c" goto pasta3
if /i "%choice%"=="d" goto pasta4

:: Processar outras opções
if "%choice%"=="0" goto exit_program

echo.
echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
pause >nul
goto main_menu

:: =================== FERRAMENTAS DE SISTEMA (do tool.bat) ===================

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
if "%op%"=="4" goto main_menu
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
if "%op%"=="4" goto main_menu
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
if "%op%"=="4" goto main_menu
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
if "%op%"=="4" goto main_menu
goto limpeza

:: ================== SUBMENU SEGURANCA ==================
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
if "%op%"=="5" goto main_menu
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
if "%op%"=="4" goto main_menu
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

:: =================== ATALHOS DE PASTAS (do menu_pastas.bat) ===================

:pasta1
set "pasta_atual=D:\PROGRAMAS INSTALADOS"
set "nome_pasta=PROGRAMAS INSTALADOS"
goto submenu_pasta

:pasta2
set "pasta_atual=D:\Games"
set "nome_pasta=Games"
goto submenu_pasta

:pasta3
set "pasta_atual=D:\Games\trainers"
set "nome_pasta=Games\trainers"
goto submenu_pasta

:pasta4
set "pasta_atual=D:\Emulador"
set "nome_pasta=Emulador"
goto submenu_pasta

:submenu_pasta
cls
echo.
echo ===============================================
echo           ATALHOS EM: %nome_pasta%
echo ===============================================
echo.

if not exist "%pasta_atual%" (
    echo ERRO: Pasta nao encontrada!
    echo.
    echo Pressione qualquer tecla para voltar ao menu principal...
    pause >nul
    goto main_menu
)

echo Carregando atalhos...
echo.

set contador=0
set /a opcoes_max=0

rem Listar apenas arquivos .lnk (atalhos)
for %%f in ("%pasta_atual%\*.lnk") do (
    set /a contador+=1
    set /a opcoes_max+=1
    set "arquivo!contador!=%%~nf"
    set "caminho!contador!=%%f"
    echo [!contador!] %%~nf
)

if %opcoes_max%==0 (
    echo Nenhum atalho encontrado nesta pasta.
    echo.
    echo [1] Abrir pasta no Explorer
    echo [0] Voltar ao menu principal
    echo.
    set /p sub_opcao=Digite sua opcao: 
    if "!sub_opcao!"=="1" (
        explorer "%pasta_atual%"
        echo Pasta aberta no Explorer!
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
    )
    goto main_menu
) else (
    echo.
    echo [A] Abrir pasta no Explorer
    echo [0] Voltar ao menu principal
    echo.
    set /p sub_opcao=Digite sua opcao (1-%opcoes_max%, A, 0): 
    
    if /i "!sub_opcao!"=="A" (
        explorer "%pasta_atual%"
        echo Pasta aberta no Explorer!
        echo.
        echo Pressione qualquer tecla para continuar...
        pause >nul
        goto submenu_pasta
    )
    
    if "!sub_opcao!"=="0" goto main_menu
    
    rem Verificar se é um número válido
    set /a num_opcao=!sub_opcao! 2>nul
    if !num_opcao! gtr 0 if !num_opcao! leq %opcoes_max% (
        echo Executando: !arquivo%num_opcao%!
        start "" "!caminho%num_opcao%!"
        echo.
        echo Atalho executado! Pressione qualquer tecla para continuar...
        pause >nul
        goto submenu_pasta
    ) else (
        echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
        pause >nul
        goto submenu_pasta
    )
)

:exit_program
echo.
echo Saindo do programa...
echo Obrigado por usar o Main Menu!
timeout /t 2 >nul
exit

:sair
goto exit_program