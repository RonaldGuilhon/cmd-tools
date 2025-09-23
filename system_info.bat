@echo off
setlocal enabledelayedexpansion
title Informacoes do Sistema
color 0F
mode con: cols=120 lines=40

:main_menu
cls
echo.
echo +========================================================================================================================+
echo ^|                                              INFORMACOES DO SISTEMA                                                   ^|
echo +========================================================================================================================+
echo ^|                                                                                                                        ^|
echo ^|  [1] Informacoes Basicas do Hardware                                                                                  ^|
echo ^|  [2] Informacoes do Processador                                                                                       ^|
echo ^|  [3] Informacoes de Memoria                                                                                           ^|
echo ^|  [4] Informacoes da Placa Mae/BIOS                                                                                    ^|
echo ^|  [5] Informacoes de Disco                                                                                             ^|
echo ^|  [6] Informacoes de Rede                                                                                              ^|
echo ^|  [7] Monitor de Sistema em Tempo Real                                                                                 ^|
echo ^|  [8] Temperatura e Sensores                                                                                           ^|
echo ^|  [9] Lista de Processos                                                                                               ^|
echo ^|  [10] Relatorio Completo                                                                                              ^|
echo ^|                                                                                                                        ^|
echo ^|  [0] Sair                                                                                                             ^|
echo ^|                                                                                                                        ^|
echo +========================================================================================================================+
echo.
set /p choice=Digite sua opcao: 

if "%choice%"=="1" goto hardware_info
if "%choice%"=="2" goto cpu_info
if "%choice%"=="3" goto memory_info
if "%choice%"=="4" goto motherboard_info
if "%choice%"=="5" goto disk_info
if "%choice%"=="6" goto network_info
if "%choice%"=="7" goto realtime_monitor
if "%choice%"=="8" goto temperature_info
if "%choice%"=="9" goto process_list
if "%choice%"=="10" goto full_report
if "%choice%"=="0" goto exit_program

echo.
echo Opcao invalida! Pressione qualquer tecla para tentar novamente...
pause >nul
goto main_menu

:: =================== INFORMACOES BASICAS DO HARDWARE ===================
:hardware_info
cls
echo ========= INFORMACOES BASICAS DO HARDWARE =========
echo.
echo Modelo do Sistema:
wmic computersystem get Model,Manufacturer
echo.
echo Placa Mae:
wmic baseboard get Product,Manufacturer,Version
echo.
echo BIOS:
wmic bios get SMBIOSBIOSVersion,Manufacturer,ReleaseDate
echo.
echo Placa de Video:
wmic path win32_VideoController get Name,AdapterRAM
echo.
pause
goto main_menu

:: =================== INFORMACOES DO PROCESSADOR ===================
:cpu_info
cls
echo ========= INFORMACOES DO PROCESSADOR =========
echo.
echo Processador:
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed
echo.
echo Arquitetura:
wmic cpu get Architecture,AddressWidth
echo.
echo Cache:
wmic cpu get L2CacheSize,L3CacheSize
echo.
echo Uso atual do CPU:
wmic cpu get LoadPercentage
echo.
pause
goto main_menu

:: =================== INFORMACOES DE MEMORIA ===================
:memory_info
cls
echo ========= INFORMACOES DE MEMORIA =========
echo.
echo Memoria Total do Sistema:
wmic computersystem get TotalPhysicalMemory
echo.
echo Modulos de Memoria:
wmic memorychip get Capacity,Speed,Manufacturer,PartNumber
echo.
echo Uso de Memoria:
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory
echo.
echo Memoria Virtual:
wmic OS get TotalVirtualMemorySize,FreeVirtualMemory
echo.
pause
goto main_menu

:: =================== INFORMACOES DA PLACA MAE/BIOS ===================
:motherboard_info
cls
echo ========= INFORMACOES DA PLACA MAE/BIOS =========
echo.
echo Placa Mae:
wmic baseboard get Product,Manufacturer,Version,SerialNumber
echo.
echo BIOS/UEFI:
wmic bios get SMBIOSBIOSVersion,Manufacturer,ReleaseDate,SerialNumber
echo.
echo Slots de Memoria:
wmic memphysical get MaxCapacity,MemoryDevices
echo.
pause
goto main_menu

:: =================== INFORMACOES DE DISCO ===================
:disk_info
cls
echo ========= INFORMACOES DE DISCO =========
echo.
echo Discos Fisicos:
wmic diskdrive get Model,Size,InterfaceType
echo.
echo Particoes:
wmic logicaldisk get Size,FreeSpace,FileSystem,VolumeName
echo.
echo Uso de Espaco:
for %%d in (C: D: E: F:) do (
    if exist %%d\ (
        echo.
        echo Disco %%d
        dir %%d\ | find "bytes free"
    )
)
echo.
pause
goto main_menu

:: =================== INFORMACOES DE REDE ===================
:network_info
cls
echo ========= INFORMACOES DE REDE =========
echo.
echo Adaptadores de Rede:
wmic path win32_NetworkAdapter where NetEnabled=true get Name,Speed,MACAddress
echo.
echo Configuracao IP:
ipconfig /all
echo.
pause
goto main_menu

:: =================== MONITOR EM TEMPO REAL ===================
:realtime_monitor
cls
echo ========= MONITOR DE SISTEMA EM TEMPO REAL =========
echo.
echo Pressione Ctrl+C para sair do monitor
echo.
pause
cls

:monitor_loop
cls
echo ========= MONITOR EM TEMPO REAL - %date% %time% =========
echo.

echo CPU:
wmic cpu get LoadPercentage /value | find "LoadPercentage"

echo.
echo MEMORIA:
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value ^| find "FreePhysicalMemory"') do set freemem=%%a
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value ^| find "TotalVisibleMemorySize"') do set totalmem=%%a
set /a usedmem=totalmem-freemem
set /a mempercent=(usedmem*100)/totalmem
echo Memoria Usada: %mempercent%%%

echo.
echo PROCESSOS (Top 10):
tasklist /fo csv | sort /r /+5 | head -n 11

echo.
echo DISCOS:
wmic logicaldisk get Size,FreeSpace,Caption /format:table

timeout /t 3 >nul
goto monitor_loop

:: =================== TEMPERATURA E SENSORES ===================
:temperature_info
cls
echo ========= TEMPERATURA E SENSORES =========
echo.
echo NOTA: Para informacoes detalhadas de temperatura, recomenda-se usar:
echo - HWiNFO64
echo - Core Temp
echo - MSI Afterburner
echo.
echo Informacoes basicas disponiveis via WMI:
echo.
echo Sensores de Temperatura (se disponiveis):
wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature 2>nul
if %errorlevel% neq 0 (
    echo Sensores de temperatura nao disponiveis via WMI neste sistema.
    echo.
    echo Alternativas via PowerShell:
    echo powershell "Get-WmiObject -Namespace root/OpenHardwareMonitor -Class Sensor | Where-Object {$_.SensorType -eq 'Temperature'}"
)
echo.
echo Ventiladores (se disponiveis):
wmic path Win32_Fan get Name,Status 2>nul
echo.
pause
goto main_menu

:: =================== LISTA DE PROCESSOS ===================
:process_list
cls
echo ========= LISTA DE PROCESSOS =========
echo.
echo [1] Todos os processos
echo [2] Processos por uso de CPU
echo [3] Processos por uso de memoria
echo [4] Processos de um usuario especifico
echo [5] Voltar
echo.
set /p proc_choice=Escolha uma opcao: 

if "%proc_choice%"=="1" (
    tasklist
    pause
    goto process_list
)
if "%proc_choice%"=="2" (
    echo Processos ordenados por CPU:
    wmic process get Name,ProcessId,PageFileUsage,WorkingSetSize /format:table
    pause
    goto process_list
)
if "%proc_choice%"=="3" (
    echo Processos ordenados por memoria:
    tasklist /fo table | sort /r /+5
    pause
    goto process_list
)
if "%proc_choice%"=="4" (
    set /p username=Digite o nome do usuario: 
    tasklist /fi "username eq %username%"
    pause
    goto process_list
)
if "%proc_choice%"=="5" goto main_menu

goto process_list

:: =================== RELATORIO COMPLETO ===================
:full_report
cls
echo ========= GERANDO RELATORIO COMPLETO =========
echo.
set "report_file=system_report_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt"
set "report_file=%report_file: =0%"

echo Gerando relatorio em: %report_file%
echo.

echo ========= RELATORIO DO SISTEMA - %date% %time% ========= > "%report_file%"
echo. >> "%report_file%"

echo === SISTEMA === >> "%report_file%"
systeminfo >> "%report_file%"
echo. >> "%report_file%"

echo === HARDWARE === >> "%report_file%"
wmic computersystem get Model,Manufacturer >> "%report_file%"
wmic baseboard get Product,Manufacturer,Version >> "%report_file%"
echo. >> "%report_file%"

echo === PROCESSADOR === >> "%report_file%"
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed >> "%report_file%"
echo. >> "%report_file%"

echo === MEMORIA === >> "%report_file%"
wmic memorychip get Capacity,Speed,Manufacturer >> "%report_file%"
echo. >> "%report_file%"

echo === DISCOS === >> "%report_file%"
wmic diskdrive get Model,Size,InterfaceType >> "%report_file%"
wmic logicaldisk get Size,FreeSpace,FileSystem,VolumeName >> "%report_file%"
echo. >> "%report_file%"

echo === REDE === >> "%report_file%"
ipconfig /all >> "%report_file%"
echo. >> "%report_file%"

echo === PROCESSOS === >> "%report_file%"
tasklist >> "%report_file%"

echo.
echo Relatorio gerado com sucesso: %report_file%
echo.
set /p open_report=Deseja abrir o relatorio? (s/n): 
if /i "%open_report%"=="s" notepad "%report_file%"

pause
goto main_menu

:exit_program
echo.
echo Saindo do programa...
timeout /t 2 >nul
exit