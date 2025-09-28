@echo off
setlocal enabledelayedexpansion
title Menu de Atalhos de Pastas
color 0A

:menu
cls
echo.
echo ===============================================
echo           MENU DE ATALHOS DE PASTAS
echo ===============================================
echo.
echo Selecione uma pasta para abrir:
echo.
echo [1] D:\PROGRAMAS INSTALADOS
echo [2] D:\Games
echo [3] D:\Games\trainers
echo [4] D:\Emulador
echo.
echo [0] Sair
echo.
set /p opcao=Digite sua opcao (0-4): 

if "%opcao%"=="1" goto pasta1
if "%opcao%"=="2" goto pasta2
if "%opcao%"=="3" goto pasta3
if "%opcao%"=="4" goto pasta4
if "%opcao%"=="0" goto sair

echo.
echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
pause >nul
goto menu

:pasta1
set "pasta_atual=D:\PROGRAMAS INSTALADOS"
set "nome_pasta=PROGRAMAS INSTALADOS"
goto submenu

:pasta2
set "pasta_atual=D:\Games"
set "nome_pasta=Games"
goto submenu

:pasta3
set "pasta_atual=D:\Games\trainers"
set "nome_pasta=Games\trainers"
goto submenu

:pasta4
set "pasta_atual=D:\Emulador"
set "nome_pasta=Emulador"
goto submenu

:submenu
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
    goto menu
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
    set "tipo!contador!=atalho"
    echo [!contador!] %%~nf (Atalho)
)

rem Listar arquivos executáveis (.exe, .bat, .cmd)
for %%f in ("%pasta_atual%\*.exe") do (
    set /a contador+=1
    set /a opcoes_max+=1
    set "arquivo!contador!=%%~nxf"
    set "caminho!contador!=%%f"
    set "tipo!contador!=executavel"
    echo [!contador!] %%~nxf (Executável)
)

for %%f in ("%pasta_atual%\*.bat") do (
    set /a contador+=1
    set /a opcoes_max+=1
    set "arquivo!contador!=%%~nxf"
    set "caminho!contador!=%%f"
    set "tipo!contador!=executavel"
    echo [!contador!] %%~nxf (Batch)
)

for %%f in ("%pasta_atual%\*.cmd") do (
    set /a contador+=1
    set /a opcoes_max+=1
    set "arquivo!contador!=%%~nxf"
    set "caminho!contador!=%%f"
    set "tipo!contador!=executavel"
    echo [!contador!] %%~nxf (Command)
)

if %opcoes_max%==0 (
    echo Nenhum atalho ou executavel encontrado nesta pasta.
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
    goto menu
)

echo.
echo [A] Abrir pasta no Explorer
echo [0] Voltar ao menu principal
echo.
set /p sub_opcao=Digite sua opcao (1-%opcoes_max%, A, 0): 

if /i "%sub_opcao%"=="A" (
    explorer "%pasta_atual%"
    echo Pasta aberta no Explorer!
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    goto submenu
)

if "%sub_opcao%"=="0" goto menu

rem Verificar se a opcao e valida
set opcao_valida=0
for /l %%i in (1,1,%opcoes_max%) do (
    if "%sub_opcao%"=="%%i" set opcao_valida=1
)

if %opcao_valida%==0 (
    echo.
    echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
    pause >nul
    goto submenu
)

rem Executar o arquivo selecionado
setlocal enabledelayedexpansion
set "arquivo_selecionado=!caminho%sub_opcao%!"
set "tipo_arquivo=!tipo%sub_opcao%!"
echo.
echo Executando: !arquivo%sub_opcao%!

rem Verificar o tipo de arquivo e executar adequadamente
if "!tipo_arquivo!"=="atalho" (
    rem Executar o atalho .lnk
    start "" "!arquivo_selecionado!"
) else if "!tipo_arquivo!"=="executavel" (
    rem Executar arquivo executável diretamente
    cd /d "%pasta_atual%"
    start "" "!arquivo_selecionado!"
    cd /d "c:\Users\Ronald\Documents\GitHub\cmd-tools"
)

echo.
echo Pressione qualquer tecla para voltar ao submenu...
pause >nul
goto submenu

:sair
echo.
echo Saindo do programa...
echo Obrigado por usar o Menu de Atalhos de Pastas!
timeout /t 2 >nul
exit