
@echo off
:: ==========================================
:: FORÇAR MODO ADMINISTRADOR AUTOMATICAMENTE
:: ==========================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~dpnx0", "", "%~dp0", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" >nul 2>&1
    exit /b 0
)
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==========================================
:: GERADOR DE ESC SEGURO (EVITA ERRO DE COPY/PASTE) E CORES
:: ==========================================
for /F "delims=#" %%E in ('"prompt #$E# & echo on & for %%A in (1) do rem"') do set "ESC=%%E"

set "w=%ESC%[0m"
set "y=%ESC%[40;33m"
set "o=%ESC%[38;5;202m"
set "b=%ESC%[94m"
set "q=%ESC%[90m"
set "r=%ESC%[91m"
set "g=%ESC%[92m"

set /a corBaseR=255
set /a corBaseG=255
set /a corBaseB=0
set /a variacaoR=0
set /a variacaoG=-255
set /a variacaoB=0

title Project Prometheus - Win Booster V2
color 07

:: ==========================================
:: CRIAR PASTAS DE LOG E BACKUP
:: ==========================================
set "LOG_DIR=%~dp0Logs"
set "BACKUP_DIR=%~dp0Backups"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: Gerar nome de log com data/hora
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "STAMP=%%i"
set "LOGFILE=%LOG_DIR%\WinBooster_%STAMP%.log"
for /f "tokens=1-2 delims=:, " %%a in ('time /t') do set "HORA_LOG=%%a%%b"
set "LOGFILE=%LOG_DIR%\WinBooster_%DATA_LOG%_%HORA_LOG%.log"
echo [INICIO] WinBooster iniciado em %DATE% %TIME% > "%LOGFILE%"
echo [INFO] Logs salvos em: %LOG_DIR% >> "%LOGFILE%"
echo [INFO] Backups salvos em: %BACKUP_DIR% >> "%LOGFILE%"

:: ==========================================
:: MODO DE SIMULAÇÃO
:: ==========================================
set "SIMULATE=0"

cls

:: ==========================================
:: MENU PRINCIPAL
:: ==========================================
:menu
call :PrintHeader "WinBooster V3 Pro"
echo.
echo               %o%[ %y% 1 %o%]%w% Criar Ponto de Restauração         %o%[ %y% 6 %o%]%w% Verificar Temperatura
echo.
echo               %o%[ %y% 2 %o%]%w% Otimização de Windows              %o%[ %y% 7 %o%]%w% Kit Pós-Formatação (Winget)
echo.
echo               %o%[ %y% 3 %o%]%w% Otimização de Jogos                %o%[ %y% 8 %o%]%w% Liberar Memória RAM
echo.
echo               %o%[ %y% 4 %o%]%w% Otimização de Periféricos          %o%[ %y% 9 %o%]%w% Melhorar Conexão/Ping
echo.
echo               %o%[ %y% 5 %o%]%w% Config. Inicialização do Windows   %o%[ %y%10 %o%]%w% Modo Simulação (ON/OFF)
echo.
echo               %o%[ %y%11 %o%]%w% Sair
echo.
if "%SIMULATE%"=="1" echo               %r%[MODO SIMULAÇÃO ATIVO - Nenhuma alteração será feita]%w%
echo.
set /p opcao="Escolha uma opcao: "

if "%opcao%"=="1"  goto opcao_restauracao
if "%opcao%"=="2"  goto menuwindows
if "%opcao%"=="3"  goto prioridadegames
if "%opcao%"=="4"  goto perifericos
if "%opcao%"=="5"  goto autorun
if "%opcao%"=="6"  goto tempera
if "%opcao%"=="7"  goto posformatacao
if "%opcao%"=="8"  goto limparram
if "%opcao%"=="9"  goto ping
if "%opcao%"=="10" goto toggle_simulate
if "%opcao%"=="11" goto sair

echo %r%Opcao invalida. Tente novamente.%w%
pause
goto menu

:: ==========================================
:: TOGGLE MODO SIMULAÇÃO
:: ==========================================
:toggle_simulate
if "%SIMULATE%"=="0" (
    set "SIMULATE=1"
    echo %y%Modo Simulação ATIVADO. Nenhuma alteração será executada.%w%
) else (
    set "SIMULATE=0"
    echo %g%Modo Simulação DESATIVADO. Alterações serão aplicadas normalmente.%w%
)
pause
goto menu

:: ==========================================
:: FUNÇÕES DIRETAS DO MENU PRINCIPAL
:: ==========================================
:ping
call :PrintHeader "MELHORAR CONEXÃO / PING"
echo Aplicando otimizações de DNS e rede...
call :LogAction "Otimizar Conexão/Ping"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] ipconfig /flushdns; DNSJumper & pause & goto menu)
ipconfig /flushdns
ipconfig /release
ipconfig /renew
call :CheckTool "DnsJumper.exe"
if errorlevel 1 goto menu
echo %g%[OK] Abrindo DNSJumper!%w%
start "" "%~dp0DnsJumper.exe"
echo %g%[OK] Otimizações de rede aplicadas!%w%
pause
goto menu

:posformatacao
call :PrintHeader "KIT PÓS-FORMATAÇÃO (WINGET)"
echo.
echo        %o%[ %b% 1 %o%]%w% Kit DEV/Engenharia (VS Code, Git, Python, Node.js)
echo        %o%[ %b% 2 %o%]%w% Kit Essencial (Chrome, Discord, Spotify)
echo        %o%[ %o% 3 %o%]%o% Voltar%w%
echo.
set /p wg_op="Opcao: "
if "%wg_op%"=="3" goto menu
if "%wg_op%"=="1" (
    call :LogAction "Instalar Kit DEV"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] winget install Dev Kit & pause & goto menu)
    winget install -e --id Microsoft.VisualStudioCode
    winget install -e --id Git.Git
    winget install -e --id Python.Python.3.11
    winget install -e --id OpenJS.NodeJS
    echo %g%[OK] Kit DEV instalado!%w%
)
if "%wg_op%"=="2" (
    call :LogAction "Instalar Kit Essencial"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] winget install Essencial Kit & pause & goto menu)
    winget install -e --id Google.Chrome
    winget install -e --id Discord.Discord
    winget install -e --id Spotify.Spotify
    echo %g%[OK] Kit Essencial instalado!%w%
)
echo %r%Opção inválida.%w%
pause
goto menu

:limparram
call :PrintHeader "LIBERAR MEMÓRIA RAM"
call :CheckTool "RAMMap.exe"
if errorlevel 1 goto menu
call :LogAction "Limpar RAM"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] RAMMap.exe -Ew -Es & pause & goto menu)
echo Limpando o cache de memória RAM...
"%~dp0RAMMap.exe" -Ew
"%~dp0RAMMap.exe" -Es
echo %g%[OK] Memória RAM otimizada com sucesso!%w%
pause
goto menu

:opcao_restauracao
call :PrintHeader "CRIAR PONTO DE RESTAURAÇÃO"
echo Ligando o motor de Proteção do Sistema no Kernel...
call :LogAction "Criar Ponto de Restauração"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Checkpoint-Computer & pause & goto menu)
sc config VSS start= demand >nul 2>&1
sc start VSS >nul 2>&1
echo Habilitando a Restauração no Disco C:...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'" >nul 2>&1
echo Criando o Ponto de Restauração (isso pode demorar um pouco)...
powershell -Command "Checkpoint-Computer -Description 'RestorePoint by Project Prometheus' -RestorePointType 'MODIFY_SETTINGS'"
if %errorlevel% equ 0 (
    echo.
    echo %g%[OK] Ponto de restauração criado com sucesso!%w%
) else (
    echo.
    echo %r%[ERRO] O Windows bloqueou a criação. Verifique se a Proteção do Sistema não foi permanentemente removida da sua ISO.%w%
)
pause
goto menu

:autorun
call :PrintHeader "CONFIG. INICIALIZAÇÃO DO WINDOWS"
call :CheckTool "Autoruns.exe"
if errorlevel 1 goto menu
call :LogAction "Abrir Autoruns"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] start Autoruns.exe & pause & goto menu)
start "" "%~dp0Autoruns.exe"
echo %g%[OK] Autoruns aberto!%w%
pause
goto menu

:tempera
call :PrintHeader "VERIFICAR TEMPERATURA"
call :CheckTool "OpenHardwareMonitor.exe"
if errorlevel 1 goto menu
call :LogAction "Abrir Monitor de Temperatura"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] start OpenHardwareMonitor.exe & pause & goto menu)
start "" "%~dp0OpenHardwareMonitor.exe"
echo %g%[OK] Monitor de hardware aberto!%w%
pause
goto menu

:sair
call :PrintHeader "ATE LOGO!"
echo.
echo        Encerrando o WinBooster V2...
echo        Logs salvos em: %LOG_DIR%
echo.
echo [FIM] WinBooster encerrado em %DATE% %TIME% >> "%LOGFILE%"
timeout /t 3 >nul
exit /b 0

:: ==========================================
:: MENU DE OTIMIZAÇÃO DO WINDOWS
:: ==========================================
:menuwindows
call :PrintHeader "OTIMIZAÇÃO DE WINDOWS"
echo.
echo                          Escolha a opção que você quer otimizar:
echo.
echo        %o%[ %b% 1 %o%]%w% Otimizar Energia               %o%[ %b%18 %o%]%w% Desat. Overlays (Steam/Xbox)
echo        %o%[ %b% 2 %o%]%w% Desat. Efeitos Visuais         %o%[ %b%19 %o%]%w% Otimizar Rede para Jogos
echo        %o%[ %b% 3 %o%]%w% Tweaks de Privacidade          %o%[ %b%20 %o%]%w% Resetar Cache de Miniaturas
echo        %o%[ %b% 4 %o%]%w% Desat. Telemetria              %o%[ %b%21 %o%]%w% Remover App Cortana
echo        %o%[ %b% 5 %o%]%w% Desativar XBOX Totalmente      %o%[ %b%22 %o%]%w% Desat. Prefetch e Superfetch
echo        %o%[ %b% 6 %o%]%w% Desat. Relatórios de Erro      %o%[ %b%23 %o%]%w% Fechar Explorer
echo        %o%[ %b% 7 %o%]%w% Otimizar ALT+TAB               %o%[ %b%24 %o%]%w% Iniciar Explorer
echo        %o%[ %b% 8 %o%]%w% Desat. Relógio do Windows      %o%[ %b%25 %o%]%w% Desat. UAC
echo        %o%[ %b% 9 %o%]%w% Desat. Serviços Inúteis        %o%[ %b%26 %o%]%w% Desat. Hyper-V
echo        %o%[ %b%10 %o%]%w% Desat. Hibernação              %o%[ %b%27 %o%]%w% Verificar/Arrumar Arquivos
echo        %o%[ %b%11 %o%]%w% Otimizar Explorer              %o%[ %b%28 %o%]%w% Limpar Cache de Rede
echo        %o%[ %b%12 %o%]%w% Desat. Indexação               %o%[ %b%29 %o%]%w% Limpar Arquivos Temporários
echo        %o%[ %b%13 %o%]%w% Debloater                      %o%[ %b%30 %o%]%w% Exclusão Defender (CyberSec)
echo        %o%[ %b%14 %o%]%w% Desat. Notificações            %o%[ %b%31 %o%]%w% Desat. Maps Manager
echo        %o%[ %b%15 %o%]%w% Desat. Cortana                 %o%[ %b%32 %o%]%w% Desat. TimeStamp
echo        %o%[ %b%16 %o%]%w% Bloquear Feedback Automático   %o%[ %b%33 %o%]%w% Desat. Aero Peek
echo        %o%[ %b%17 %o%]%w% Desat. SmartScreen             %o%[ %b%34 %o%]%w% REINICIAR PC
echo.
echo        %o%[ %o%35 %o%]%o% Menu Principal%w%
echo.
if "%SIMULATE%"=="1" echo        %r%[MODO SIMULAÇÃO ATIVO]%w%
echo.
set /p opcao="Digite o número: "

if "%opcao%"=="35" goto menu
if "%opcao%"=="1"  goto win_1
if "%opcao%"=="2"  goto win_2
if "%opcao%"=="3"  goto win_3
if "%opcao%"=="4"  goto win_4
if "%opcao%"=="5"  goto win_5
if "%opcao%"=="6"  goto win_6
if "%opcao%"=="7"  goto win_7
if "%opcao%"=="8"  goto win_8
if "%opcao%"=="9"  goto win_9
if "%opcao%"=="10" goto win_10
if "%opcao%"=="11" goto win_11
if "%opcao%"=="12" goto win_12
if "%opcao%"=="13" goto win_13
if "%opcao%"=="14" goto win_14
if "%opcao%"=="15" goto win_15
if "%opcao%"=="16" goto win_16
if "%opcao%"=="17" goto win_17
if "%opcao%"=="18" goto win_18
if "%opcao%"=="19" goto win_19
if "%opcao%"=="20" goto win_20
if "%opcao%"=="21" goto win_21
if "%opcao%"=="22" goto win_22
if "%opcao%"=="23" goto win_23
if "%opcao%"=="24" goto win_24
if "%opcao%"=="25" goto win_25
if "%opcao%"=="26" goto win_26
if "%opcao%"=="27" goto win_27
if "%opcao%"=="28" goto win_28
if "%opcao%"=="29" goto win_29
if "%opcao%"=="30" goto win_30
if "%opcao%"=="31" goto win_31
if "%opcao%"=="32" goto win_32
if "%opcao%"=="33" goto win_33
if "%opcao%"=="34" goto win_34

echo %r%Opção inválida. Tente novamente.%w%
pause
goto menuwindows

:win_1
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "win_energia"
call :LogAction "Win: Otimizar Energia"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] powercfg & pause & goto menuwindows)
echo Otimizando Energia...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg.exe /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IdleDisable 0
powercfg.exe /setactive SCHEME_CURRENT
powercfg.cpl
echo %g%[OK] Energia otimizada!%w%
pause
goto menuwindows

:win_2
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "win_visual"
call :LogAction "Win: Desativar Efeitos Visuais"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Desativar efeitos visuais & pause & goto menuwindows)
echo Desativando Efeitos Visuais...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Control Panel\Desktop" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo %g%[OK] Efeitos visuais desativados!%w%
pause
goto menuwindows

:win_3
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "win_privacidade"
call :LogAction "Win: Tweaks de Privacidade"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Tweaks de privacidade & pause & goto menuwindows)
echo Aplicando Tweaks de Privacidade...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
sc stop DiagTrack & sc config DiagTrack start= disabled
sc stop dmwappushservice & sc config dmwappushservice start= disabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_Recommendations /t REG_DWORD /d 0 /f
echo %g%[OK] Tweaks de Privacidade aplicados!%w%
pause
goto menuwindows

:win_4
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "win_telemetria"
call :LogAction "Win: Desativar Telemetria"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Desativar telemetria & pause & goto menuwindows)
echo Desativando Telemetria...
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisableWindowsAdvertising" /t REG_DWORD /d 1 /f
echo %g%[OK] Telemetria desativada!%w%
pause
goto menuwindows

:win_5
call :LogAction "Win: Desativar Xbox"
echo [1] Remover Xbox  [2] Restaurar Xbox  [3] Voltar
set /p escX="Opcao: "
if "%escX%"=="3" goto menuwindows
if "%escX%"=="1" (
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Remover Xbox & pause & goto menuwindows)
    sc stop "Xbox Game Monitoring" & sc config "Xbox Game Monitoring" start= disabled
    powershell -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
    powershell -command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage"
    echo %g%[OK] Xbox removido!%w%
)
if "%escX%"=="2" (
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Restaurar Xbox & pause & goto menuwindows)
    sc config "Xbox Game Monitoring" start= demand
    sc config "XblAuthManager" start= demand
    echo %g%[OK] Xbox restaurado!%w%
)
pause
goto menuwindows

:win_6
call :BackupReg "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "win_erros"
call :LogAction "Win: Desativar Relatórios de Erro"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Desativar relatórios de erro & pause & goto menuwindows)
echo Desativando Relatórios de Erro...
sc stop "WerSvc" & sc config "WerSvc" start= disabled
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DisableWindowsErrorReporting" /t REG_DWORD /d 1 /f
echo %g%[OK] Relatórios de erro desativados!%w%
pause
goto menuwindows

:win_7
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" "win_alttab"
call :LogAction "Win: Otimizar ALT+TAB"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] AltTabSettings & pause & goto menuwindows)
echo Otimizando ALT+TAB...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v AltTabSettings /t REG_DWORD /D 1 /f
taskkill /f /im explorer.exe >nul & start explorer.exe
echo %g%[OK] ALT+TAB otimizado!%w%
pause
goto menuwindows

:win_8
echo.
echo %r%[AVISO] Esta ação irá desativar a sincronização de relógio do Windows (w32time)%w%
echo %r%         e remover o valor useplatformclock do BCD (boot). Pode afetar a%w%
echo %r%         sincronização de hora do sistema. Tem certeza? (S/N)%w%
echo.
set /p conf_w8="Confirmar: "
if /i not "%conf_w8%"=="S" goto menuwindows
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\w32time" "win_relogio"
call :LogAction "Win: Desativar Relógio Windows"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Desativar w32time & pause & goto menuwindows)
echo Desativando Relógio...
net stop w32time >nul 2>&1 & sc config w32time start= disabled
bcdedit /deletevalue useplatformclock >nul 2>&1
echo %g%[OK] Relógio do Windows ajustado!%w%
pause
goto menuwindows

:win_9
echo.
echo %r%[AVISO] Esta ação irá desativar serviços do Windows (Spooler, wisvc, WbioSrvc).%w%
echo %r%         Isso pode desativar impressoras e biometria. Tem certeza? (S/N)%w%
echo.
set /p conf_w9="Confirmar: "
if /i not "%conf_w9%"=="S" goto menuwindows
call :LogAction "Win: Desativar Serviços Inúteis"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Desativar serviços & pause & goto menuwindows)
echo Desativando Serviços Inúteis...
sc stop Spooler & sc config Spooler start= disabled
sc stop wisvc & sc config wisvc start= disabled
sc stop WbioSrvc & sc config WbioSrvc start= disabled
echo %g%[OK] Serviços desativados!%w%
pause
goto menuwindows

:win_10
call :LogAction "Win: Desativar Hibernação"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] powercfg -h off & pause & goto menuwindows)
powercfg -h off
echo %g%[OK] Hibernação desativada!%w%
pause
goto menuwindows

:win_11
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "win_explorer"
call :LogAction "Win: Otimizar Explorer"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Otimizar Explorer & pause & goto menuwindows)
echo Otimizando Explorer...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul & start explorer.exe
echo %g%[OK] Explorer otimizado!%w%
pause
goto menuwindows

:win_12
call :LogAction "Win: Desativar Indexação"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] sc config WSearch disabled & pause & goto menuwindows)
net stop "Windows Search" >nul 2>&1 & sc config "WSearch" start= disabled >nul 2>&1
echo %g%[OK] Indexação desativada!%w%
pause
goto menuwindows

:win_13
call :LogAction "Win: Debloater"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Remove-AppxPackage & pause & goto menuwindows)
echo Removendo apps padrão...
powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *news* | Remove-AppxPackage -ErrorAction SilentlyContinue"
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f
echo %g%[OK] Debloater aplicado!%w%
pause
goto menuwindows

:win_14
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" "win_notif"
call :LogAction "Win: Desativar Notificações"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] ToastEnabled=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f
echo %g%[OK] Notificações desativadas!%w%
pause
goto menuwindows

:win_15
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "win_cortana"
call :LogAction "Win: Desativar Cortana"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] AllowCortana=0 & pause & goto menuwindows)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
echo %g%[OK] Cortana desativada!%w%
pause
goto menuwindows

:win_16
call :BackupReg "HKCU\Software\Microsoft\Siuf\Rules" "win_feedback"
call :LogAction "Win: Bloquear Feedback"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] NumberOfSIUFInPeriod=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
echo %g%[OK] Feedback bloqueado!%w%
pause
goto menuwindows

:win_17
echo.
echo %r%[AVISO] Desativar o SmartScreen reduz a proteção contra downloads maliciosos.%w%
echo %r%         Certifique-se de que sabe o que está fazendo. Tem certeza? (S/N)%w%
echo.
set /p conf_w17="Confirmar: "
if /i not "%conf_w17%"=="S" goto menuwindows
call :BackupReg "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" "win_smartscreen"
call :LogAction "Win: Desativar SmartScreen"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] SmartScreenEnabled=Off & pause & goto menuwindows)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off /f
echo %g%[OK] SmartScreen desativado!%w%
pause
goto menuwindows

:win_18
call :BackupReg "HKCU\Software\Microsoft\GameBar" "win_overlays"
call :LogAction "Win: Desativar Overlays"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] AllowAutoGameMode=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
echo %g%[OK] Overlays desativados!%w%
pause
goto menuwindows

:win_19
echo.
echo %r%[AVISO] Ajustes de rede podem afetar conexões existentes. Tem certeza? (S/N)%w%
echo.
set /p conf_w19="Confirmar: "
if /i not "%conf_w19%"=="S" goto menuwindows
call :LogAction "Win: Otimizar Rede para Jogos"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] netsh tcp set global & pause & goto menuwindows)
echo Otimizando Rede...
netsh interface tcp set global autotuninglevel=normal
netsh interface tcp set global rss=enabled
netsh interface tcp set global chimney=disabled
echo %g%[OK] Rede otimizada!%w%
pause
goto menuwindows

:win_20
call :LogAction "Win: Resetar Cache de Miniaturas"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] del thumbcache & pause & goto menuwindows)
taskkill /f /im explorer.exe
del /f /s /q %LocalAppData%\Microsoft\Windows\Explorer\iconcache* >nul 2>&1
del /f /s /q %LocalAppData%\Microsoft\Windows\Explorer\thumbcache* >nul 2>&1
start explorer.exe
echo %g%[OK] Cache limpo!%w%
pause
goto menuwindows

:win_21
call :LogAction "Win: Remover App Cortana"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Remove-AppxPackage Cortana & pause & goto menuwindows)
powershell -Command "Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage"
echo %g%[OK] App Cortana removido!%w%
pause
goto menuwindows

:win_22
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "win_prefetch"
call :LogAction "Win: Desativar Prefetch"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] SysMain disabled & pause & goto menuwindows)
sc stop "SysMain" >nul 2>&1 & sc config "SysMain" start= disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f
echo %g%[OK] Prefetch desativado!%w%
pause
goto menuwindows

:win_23
call :LogAction "Win: Fechar Explorer"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] taskkill explorer.exe & pause & goto menuwindows)
taskkill /f /im explorer.exe
echo %g%[OK] Explorer fechado!%w%
pause
goto menuwindows

:win_24
call :LogAction "Win: Iniciar Explorer"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] start explorer.exe & pause & goto menuwindows)
start explorer.exe
echo %g%[OK] Explorer iniciado!%w%
pause
goto menuwindows

:win_25
echo.
echo %r%[AVISO - PERIGO] Desativar o UAC (Controle de Conta de Usuário) deixa o sistema%w%
echo %r%                  vulnerável a modificações não autorizadas. Isso é uma ação de risco.%w%
echo %r%                  Tem CERTEZA que deseja desativar? (S/N)%w%
echo.
set /p conf_w25="Confirmar: "
if /i not "%conf_w25%"=="S" goto menuwindows
call :BackupReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "win_uac"
call :LogAction "Win: Desativar UAC"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] EnableLUA=0 & pause & goto menuwindows)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
echo %g%[OK] UAC Desativado!%w%
pause
goto menuwindows

:win_26
echo.
echo %r%[AVISO] Desativar Hyper-V pode afetar máquinas virtuais e WSL2. Tem certeza? (S/N)%w%
echo.
set /p conf_w26="Confirmar: "
if /i not "%conf_w26%"=="S" goto menuwindows
call :LogAction "Win: Desativar Hyper-V"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] dism Disable Hyper-V & pause & goto menuwindows)
dism /Online /Disable-Feature:Microsoft-Hyper-V-All /NoRestart
bcdedit /set hypervisorlaunchtype off
echo %g%[OK] Hyper-V desativado!%w%
pause
goto menuwindows

:win_27
call :LogAction "Win: Verificar Arquivos do Sistema"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] sfc /scannow & pause & goto menuwindows)
sfc /scannow
dism /online /cleanup-image /restorehealth
echo %g%[OK] Arquivos verificados!%w%
pause
goto menuwindows

:win_28
call :LogAction "Win: Limpar Cache de Rede"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] flushdns winsock reset & pause & goto menuwindows)
ipconfig /flushdns & netsh winsock reset & netsh int ip reset
echo %g%[OK] Cache de rede limpo!%w%
pause
goto menuwindows

:win_29
call :LogAction "Win: Limpar Temporários"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] del /temp & pause & goto menuwindows)
del /s /f /q "%temp%\*.*" 2>nul
del /s /f /q "%windir%\temp\*.*" 2>nul
cleanmgr.exe
echo %g%[OK] Temporários limpos!%w%
pause
goto menuwindows

:win_30
call :PrintHeader "EXCLUSÃO DO DEFENDER (CYBERSEC SAFE)"
echo.
echo %r%[AVISO] Adicionar exclusão no Defender remove a proteção de antivírus para%w%
echo %r%         essa pasta. Use apenas para pastas de desenvolvimento confiáveis.%w%
echo.
echo Digite o caminho completo da sua pasta de projetos (Ex: C:\Users\Rick\Projetos)
set /p folder_path="Caminho: "
if not exist "%folder_path%\" (
    echo %r%[ERRO] A pasta não existe.%w%
    pause
    goto menuwindows
)
echo.
echo %r%[CONFIRMAÇÃO] Adicionar exclusão para: %folder_path% ? (S/N)%w%
set /p conf_w30="Confirmar: "
if /i not "%conf_w30%"=="S" goto menuwindows
call :LogAction "Win: Exclusão Defender para %folder_path%"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Add-MpPreference -ExclusionPath & pause & goto menuwindows)
powershell -Command "Add-MpPreference -ExclusionPath '%folder_path%'"
echo %g%[OK] Pasta blindada contra scans do Defender. O Kernel continua protegido!%w%
pause
goto menuwindows

:win_31
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" "win_maps"
call :LogAction "Win: Desativar Maps Manager"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] MapsBroker Start=4 & pause & goto menuwindows)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /v Start /t REG_DWORD /d 4 /f
echo %g%[OK] Maps Broker Desativado!%w%
pause
goto menuwindows

:win_32
call :BackupReg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" "win_timestamp"
call :LogAction "Win: Desativar TimeStamp"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] NtfsDisableLastAccessUpdate=1 & pause & goto menuwindows)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f
echo %g%[OK] TimeStamp desativado!%w%
pause
goto menuwindows

:win_33
call :BackupReg "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "win_aeropeek"
call :LogAction "Win: Desativar Aero Peek"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] EnableAeroPeek=0 & pause & goto menuwindows)
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo %g%[OK] Aero Peek desativado!%w%
pause
goto menuwindows

:win_34
echo.
echo %r%[AVISO] O PC será REINICIADO em 5 segundos. Salve seus arquivos! (Ctrl+C para cancelar)%w%
echo.
pause
call :LogAction "Win: Reiniciar PC"
shutdown /r /t 5
goto menu

:: ==========================================
:: PRIORIDADE DE JOGOS
:: ==========================================
:prioridadegames
call :PrintHeader "AUMENTAR PRIORIDADE NOS GAMES"
echo.
echo        %o%[ %b% 1 %o%]%w% Fortnite                             %o%[ %b%16 %o%]%w% ULTRAKILL
echo        %o%[ %b% 2 %o%]%w% Gta V                                %o%[ %b%17 %o%]%w% Blood Strike
echo        %o%[ %b% 3 %o%]%w% FiveM                                %o%[ %b%18 %o%]%w% Arena Breakout
echo        %o%[ %b% 4 %o%]%w% CS2                                  %o%[ %b%19 %o%]%w% Resident Evil 4 Remake
echo        %o%[ %b% 5 %o%]%w% Minecraft                            %o%[ %b%20 %o%]%w% Resident Evil 2 Remake
echo        %o%[ %b% 6 %o%]%w% Valorant                             %o%[ %b%21 %o%]%w% Resident Evil Village
echo        %o%[ %b% 7 %o%]%w% League of Legends                    %o%[ %b%22 %o%]%w% Free Fire
echo        %o%[ %b% 8 %o%]%w% Warzone                              %o%[ %b%23 %o%]%w% Battlefield 2042
echo        %o%[ %b% 9 %o%]%w% Apex Legends                         %o%[ %b%24 %o%]%w% Battlefield 4
echo        %o%[ %b%10 %o%]%w% Roblox                               %o%[ %b%25 %o%]%w% The Last Of US 1 e 2
echo        %o%[ %b%11 %o%]%w% God Of War (Ambos)                   %o%[ %b%26 %o%]%w% PUBG
echo        %o%[ %b%12 %o%]%w% MTA                                  %o%[ %b%27 %o%]%w% Rocket League
echo        %o%[ %b%13 %o%]%w% Euro Truck (1 e 2)                   %o%[ %b%28 %o%]%w% Cyberpunk 2077
echo        %o%[ %b%14 %o%]%w% Rainbow Six                          %o%[ %b%29 %o%]%w% Terraria
echo        %o%[ %b%15 %o%]%w% Cult of the Lamb                     %o%[ %b%30 %o%]%w% Red Dead 2
echo.
echo        %o%[ %o%31 %o%]%o% Voltar ao Menu Principal          %o%[ %o%32 %o%]%o% REVERTER TODOS %w%
echo.
if "%SIMULATE%"=="1" echo        %r%[MODO SIMULAÇÃO ATIVO]%w%
echo.
set /p jogo="Digite o numero: "

if "%jogo%"=="31" goto menu
if "%jogo%"=="32" goto revert_all_games

if "%jogo%"=="1"  call :SetGamePriority "FortniteClient-Win64-Shipping.exe"
if "%jogo%"=="2"  call :SetGamePriority "GTA5.exe"
if "%jogo%"=="3"  call :SetGamePriority "FiveM_b2372_GTAProcess.exe"
if "%jogo%"=="4"  call :SetGamePriority "cs2.exe"
if "%jogo%"=="5"  call :SetGamePriority "javaw.exe"
if "%jogo%"=="6"  call :SetGamePriority "VALORANT-Win64-Shipping.exe"
if "%jogo%"=="7"  call :SetGamePriority "LeagueClient.exe"
if "%jogo%"=="8"  call :SetGamePriority "cod.exe"
if "%jogo%"=="9"  call :SetGamePriority "r5apex.exe"
if "%jogo%"=="10" call :SetGamePriority "RobloxPlayerBeta.exe"
if "%jogo%"=="11" (call :SetGamePriority "GoW.exe" & call :SetGamePriority "GoWRagnarok.exe")
if "%jogo%"=="12" (call :SetGamePriority "Multi Theft Auto.exe" & call :SetGamePriority "gta_sa.exe")
if "%jogo%"=="13" (call :SetGamePriority "eurotrucks.exe" & call :SetGamePriority "ets2.exe")
if "%jogo%"=="14" call :SetGamePriority "RainbowSix.exe"
if "%jogo%"=="15" call :SetGamePriority "CultOfTheLamb.exe"
if "%jogo%"=="16" call :SetGamePriority "ULTRAKILL.exe"
if "%jogo%"=="17" call :SetGamePriority "BloodStrike.exe"
if "%jogo%"=="18" call :SetGamePriority "ArenaBreakout.exe"
if "%jogo%"=="19" call :SetGamePriority "re4.exe"
if "%jogo%"=="20" call :SetGamePriority "re2.exe"
if "%jogo%"=="21" call :SetGamePriority "re8.exe"
if "%jogo%"=="22" call :SetGamePriority "HD-Player.exe"
if "%jogo%"=="23" call :SetGamePriority "BF2042.exe"
if "%jogo%"=="24" call :SetGamePriority "bf4.exe"
if "%jogo%"=="25" (call :SetGamePriority "tlou-i.exe" & call :SetGamePriority "tlou-ii.exe")
if "%jogo%"=="26" call :SetGamePriority "tslgame.exe"
if "%jogo%"=="27" call :SetGamePriority "RocketLeague.exe"
if "%jogo%"=="28" call :SetGamePriority "Cyberpunk2077.exe"
if "%jogo%"=="29" call :SetGamePriority "Terraria.exe"
if "%jogo%"=="30" call :SetGamePriority "RDR2.exe"

echo %g%[OK] Aplicado com sucesso!%w%
pause
goto prioridadegames

:revert_all_games
call :LogAction "Games: Reverter Todas as Prioridades"
if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Reverter prioridades de todos os jogos & pause & goto prioridadegames)
echo Revertendo prioridades...
for %%G in (FortniteClient-Win64-Shipping.exe GTA5.exe FiveM_b2372_GTAProcess.exe cs2.exe javaw.exe VALORANT-Win64-Shipping.exe LeagueClient.exe cod.exe r5apex.exe RobloxPlayerBeta.exe GoW.exe GoWRagnarok.exe "Multi Theft Auto.exe" gta_sa.exe eurotrucks.exe ets2.exe RainbowSix.exe CultOfTheLamb.exe ULTRAKILL.exe BloodStrike.exe ArenaBreakout.exe re4.exe re2.exe re8.exe HD-Player.exe BF2042.exe bf4.exe tlou-i.exe tlou-ii.exe tslgame.exe RocketLeague.exe Cyberpunk2077.exe Terraria.exe RDR2.exe) do (
    call :RevertGamePriority "%%~G"
)
echo %g%[OK] Todos os jogos revertidos ao padrão do Windows!%w%
pause
goto prioridadegames


:: ==========================================
:: OTIMIZAÇÃO DE PERIFÉRICOS
:: ==========================================
:perifericos
call :PrintHeader "OTIMIZAÇÃO DE PERIFÉRICOS"
echo.
echo            %o%[ %b% 1 %o%]%w% Otimizar HDD                    %o%[ %b% 2 %o%]%w% Otimizar SSD
echo            %o%[ %b% 3 %o%]%w% Verificar Temperatura           %o%[ %b% 4 %o%]%w% Otimizar Teclado
echo            %o%[ %b% 5 %o%]%w% Otimizar Mouse                  %o%[ %b% 6 %o%]%w% Reverter Otimização
echo            %o%[ %o% 7 %o%]%o% Voltar ao Menu Principal%w%
echo.
if "%SIMULATE%"=="1" echo            %r%[MODO SIMULAÇÃO ATIVO]%w%
echo.
set /p opcao="Digite o número: "

if "%opcao%"=="7" goto menu
if "%opcao%"=="1" (
    call :LogAction "Periférico: Otimizar HDD"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] fsutil HDD & pause & goto perifericos)
    fsutil behavior set disableLastAccess 2
    fsutil behavior set disable8dot3 0
    echo %g%[OK] HDD Otimizado!%w%
    pause
    goto perifericos
)
if "%opcao%"=="2" (
    call :LogAction "Periférico: Otimizar SSD"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] fsutil SSD & pause & goto perifericos)
    schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
    fsutil behavior set disableLastAccess 0
    fsutil behavior set disable8dot3 1
    echo %g%[OK] SSD Otimizado!%w%
    pause
    goto perifericos
)
if "%opcao%"=="3" (
    call :CheckTool "OpenHardwareMonitor.exe"
    if errorlevel 1 goto perifericos
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] start OpenHardwareMonitor.exe & pause & goto perifericos)
    start "" "%~dp0OpenHardwareMonitor.exe"
    echo %g%[OK] Monitor de hardware aberto!%w%
    pause
    goto perifericos
)
if "%opcao%"=="4" (
    call :BackupReg "HKCU\Control Panel\Keyboard" "teclado"
    call :LogAction "Periférico: Otimizar Teclado"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Keyboard settings & pause & goto perifericos)
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f
    call :CheckTool "FilterKeysSetter.exe"
    if not errorlevel 1 start "" "%~dp0FilterKeysSetter.exe"
    echo %g%[OK] Teclado Otimizado!%w%
    pause
    goto perifericos
)
if "%opcao%"=="5" (
    call :BackupReg "HKCU\Control Panel\Mouse" "mouse"
    call :LogAction "Periférico: Otimizar Mouse"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Mouse settings & pause & goto perifericos)
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
    RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
    echo %g%[OK] Mouse otimizado!%w%
    pause
    goto perifericos
)
if "%opcao%"=="6" (
    call :LogAction "Periférico: Reverter Otimizações"
    if "%SIMULATE%"=="1" (echo [SIMULAÇÃO] Reverter periféricos & pause & goto perifericos)
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 1 /f
    fsutil behavior set disableLastAccess 1
    echo %g%[OK] Periféricos Revertidos!%w%
    pause
    goto perifericos
)
echo %r%Opção inválida. Tente novamente.%w%
pause
goto perifericos

:: ==========================================
:: FUNÇÕES CENTRAIS (ENGENHARIA / REUSO)
:: ==========================================

:SetGamePriority
if "%SIMULATE%"=="1" (
    echo [SIMULAÇÃO] SetGamePriority: %~1
    goto :eof
)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
call :LogAction "SetGamePriority: %~1"
goto :eof

:RevertGamePriority
if "%SIMULATE%"=="1" (
    echo [SIMULAÇÃO] RevertGamePriority: %~1
    goto :eof
)
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1\PerfOptions" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1" /f >nul 2>&1
goto :eof

:CheckTool
if not exist "%~dp0%~1" (
    echo.
    echo %r%[ERRO CRÍTICO] %~1 não encontrado na pasta do script!%w%
    echo %r%               Coloque o arquivo na mesma pasta que o WinBooster.bat%w%
    echo.
    pause
    exit /b 1
)
exit /b 0

:BackupReg
:: Parâmetros: %~1 = chave do registro, %~2 = nome do backup
if "%SIMULATE%"=="1" (
    echo [SIMULAÇÃO] BackupReg: %~1
    goto :eof
)
set "BACKUP_FILE=%BACKUP_DIR%\%~2_%STAMP%.reg"
reg export "%~1" "%BACKUP_FILE%" /y >nul 2>&1
if exist "%BACKUP_FILE%" (
    echo %q%[BACKUP] Chave salva em: %BACKUP_FILE%%w%
) else (
    echo %q%[BACKUP] Chave não existia ainda (não foi necessário backup).%w%
)
goto :eof

:LogAction
echo [%DATE% %TIME%] %~1 >> "%LOGFILE%"
goto :eof

:PrintHeader
cls
echo %o%      ==============================================================================
echo %w%                                %~1
echo %o%      ==============================================================================%w%
echo.
goto :eof
