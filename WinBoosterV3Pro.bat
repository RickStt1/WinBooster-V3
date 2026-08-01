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

set "w=!ESC![0m"
set "y=!ESC![40;33m"
set "o=!ESC![38;5;202m"
set "b=!ESC![94m"
set "q=!ESC![90m"
set "r=!ESC![91m"
set "g=!ESC![92m"

title Project Prometheus - WinBooster V3 Pro
color 07

:: ==========================================
:: CRIAR PASTAS DE LOG E BACKUP
:: ==========================================
set "LOG_DIR=%~dp0Logs"
set "BACKUP_DIR=%~dp0Backups"
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!"
if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"

:: Gerar nome de log com data/hora
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss" 2^>nul') do set "STAMP=%%i"
if "!STAMP!"=="" (
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set "STAMP=%%c-%%a-%%b")
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set "STAMP=!STAMP!_%%a-%%b")
)
set "STAMP=!STAMP: =0!"
set "LOGFILE=!LOG_DIR!\WinBooster_!STAMP!.log"
echo [INICIO] WinBooster iniciado em %DATE% %TIME% > "!LOGFILE!"
echo [INFO] Logs salvos em: !LOG_DIR! >> "!LOGFILE!"
echo [INFO] Backups salvos em: !BACKUP_DIR! >> "!LOGFILE!"

:: ==========================================
:: MODO DE SIMULAÇÃO (Variável Global)
:: ==========================================
set "SIMULATE=0"

cls

:: ==========================================
:: MENU PRINCIPAL
:: ==========================================
:menu
call :PrintHeader "WinBooster V3 Pro"
echo.
echo               !o![ !y! 1 !o!]!w! Criar Ponto de Restauração         !o![ !y! 6 !o!]!w! Verificar Temperatura
echo.
echo               !o![ !y! 2 !o!]!w! Otimização de Windows              !o![ !y! 7 !o!]!w! Kit Pós-Formatação (Winget)
echo.
echo               !o![ !y! 3 !o!]!w! Otimização de Jogos                !o![ !y! 8 !o!]!w! Liberar Memória RAM
echo.
echo               !o![ !y! 4 !o!]!w! Otimização de Periféricos          !o![ !y! 9 !o!]!w! Melhorar Conexão/Ping
echo.
echo               !o![ !y! 5 !o!]!w! Config. Inicialização do Windows   !o![ !y!10 !o!]!w! Modo Simulação (ON/OFF)
echo.
echo               !o![ !y!11 !o!]!w! Otimizações Avançadas de FPS       !o![ !y!12 !o!]!w! Tweaks Profundos (Risco)
echo.
echo               !o![ !y!13 !o!]!w! Sair
echo.
if "!SIMULATE!"=="1" echo               !r![MODO SIMULAÇÃO ATIVO - Nenhuma alteração será feita]!w!
echo.
set /p opcao="Escolha uma opcao: "

if "!opcao!"=="1"  goto opcao_restauracao
if "!opcao!"=="2"  goto menuwindows
if "!opcao!"=="3"  goto prioridadegames
if "!opcao!"=="4"  goto perifericos
if "!opcao!"=="5"  goto autorun
if "!opcao!"=="6"  goto tempera
if "!opcao!"=="7"  goto posformatacao
if "!opcao!"=="8"  goto limparram
if "!opcao!"=="9"  goto ping
if "!opcao!"=="10" goto toggle_simulate
if "!opcao!"=="11" goto fpsavancado
if "!opcao!"=="12" goto tweaksprofundos
if "!opcao!"=="13" goto sair

echo !r!Opcao invalida. Digite um numero entre 1 e 13.!w!
pause
goto menu

:: ==========================================
:: TOGGLE MODO SIMULAÇÃO (CORRIGIDO)
:: ==========================================
:toggle_simulate
if "!SIMULATE!"=="0" (
    set "SIMULATE=1"
    echo !y!Modo Simulação ATIVADO. Nenhuma alteração será executada.!w!
) else (
    set "SIMULATE=0"
    echo !g!Modo Simulação DESATIVADO. Alterações serão aplicadas normalmente.!w!
)
pause
goto menu

:: ==========================================
:: VERIFICAR TEMPERATURA
:: ==========================================
:tempera
call :PrintHeader "VERIFICAR TEMPERATURA"
call :CheckTool "OpenHardwareMonitor.exe"
if !errorlevel! equ 1 goto menu
call :LogAction "Abrir Monitor de Temperatura"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] start OpenHardwareMonitor.exe & pause & goto menu)
start "" "!~dp0!OpenHardwareMonitor.exe"
echo !g![OK] Monitor de hardware aberto!!w!
pause
goto menu

:: ==========================================
:: MELHORAR CONEXÃO / PING
:: ==========================================
:ping
call :PrintHeader "MELHORAR CONEXÃO / PING"
echo Aplicando otimizações de DNS e rede...
call :LogAction "Otimizar Conexão/Ping"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] ipconfig /flushdns; DNSJumper & pause & goto menu)
ipconfig /flushdns >nul 2>&1
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1
call :CheckTool "DnsJumper.exe"
if !errorlevel! equ 1 goto menu
echo !g![OK] Abrindo DNSJumper!!w!
start "" "!~dp0!DnsJumper.exe"
echo !g![OK] Otimizações de rede aplicadas!!w!
pause
goto menu

:: ==========================================
:: KIT PÓS-FORMATAÇÃO (WINGET)
:: ==========================================
:posformatacao
call :PrintHeader "KIT PÓS-FORMATAÇÃO (WINGET)"
echo.
echo        !o![ !b! 1 !o!]!w! Kit DEV/Engenharia (VS Code, Git, Python, Node.js)
echo        !o![ !b! 2 !o!]!w! Kit Essencial (Chrome, Discord, Spotify)
echo        !o![ !o! 3 !o!]!o! Voltar!w!
echo.
set /p wg_op="Opcao: "

if "!wg_op!"=="3" goto menu
if "!wg_op!"=="1" (
    call :LogAction "Instalar Kit DEV"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] winget install Dev Kit & pause & goto menu)
    echo Instalando Kit DEV...
    winget install -e --id Microsoft.VisualStudioCode
    winget install -e --id Git.Git
    winget install -e --id Python.Python.3.11
    winget install -e --id OpenJS.NodeJS
    echo !g![OK] Kit DEV instalado!!w!
    pause
    goto menu
)
if "!wg_op!"=="2" (
    call :LogAction "Instalar Kit Essencial"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] winget install Essencial Kit & pause & goto menu)
    echo Instalando Kit Essencial...
    winget install -e --id Google.Chrome
    winget install -e --id Discord.Discord
    winget install -e --id Spotify.Spotify
    echo !g![OK] Kit Essencial instalado!!w!
    pause
    goto menu
)
echo !r!Opção inválida. Digite 1, 2 ou 3.!w!
pause
goto posformatacao

:: ==========================================
:: LIBERAR MEMÓRIA RAM
:: ==========================================
:limparram
call :PrintHeader "LIBERAR MEMÓRIA RAM"
call :CheckTool "RAMMap.exe"
if !errorlevel! equ 1 goto menu
call :LogAction "Limpar RAM"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] RAMMap.exe -Ew -Es & pause & goto menu)
echo Limpando o cache de memória RAM...
"!~dp0!RAMMap.exe" -Ew
"!~dp0!RAMMap.exe" -Es
echo !g![OK] Memória RAM otimizada com sucesso!!w!
pause
goto menu

:: ==========================================
:: CRIAR PONTO DE RESTAURAÇÃO
:: ==========================================
:opcao_restauracao
call :PrintHeader "CRIAR PONTO DE RESTAURAÇÃO"
echo Ligando o motor de Proteção do Sistema no Kernel...
call :LogAction "Criar Ponto de Restauração"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Checkpoint-Computer & pause & goto menu)
sc config VSS start= demand >nul 2>&1
sc start VSS >nul 2>&1
echo Habilitando a Restauração no Disco C:...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
echo Criando o Ponto de Restauração (isso pode demorar um pouco)...
powershell -Command "Checkpoint-Computer -Description 'RestorePoint by Project Prometheus' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
if !errorlevel! equ 0 (
    echo.
    echo !g![OK] Ponto de restauração criado com sucesso!!w!
) else (
    echo.
    echo !r![ERRO] O Windows bloqueou a criação. Verifique em Propriedades do Sistema.!w!
)
pause
goto menu

:: ==========================================
:: CONFIG. INICIALIZAÇÃO DO WINDOWS
:: ==========================================
:autorun
call :PrintHeader "CONFIG. INICIALIZAÇÃO DO WINDOWS"
call :CheckTool "Autoruns.exe"
if !errorlevel! equ 1 goto menu
call :LogAction "Abrir Autoruns"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] start Autoruns.exe & pause & goto menu)
start "" "!~dp0!Autoruns.exe"
echo !g![OK] Autoruns aberto!!w!
pause
goto menu

:: ==========================================
:: SAIR
:: ==========================================
:sair
call :PrintHeader "ATÉ LOGO!"
echo.
echo        Encerrando o WinBooster V3 Pro...
echo        Logs salvos em: !LOG_DIR!
echo.
echo [FIM] WinBooster encerrado em %DATE% %TIME% >> "!LOGFILE!"
timeout /t 3 >nul
endlocal
exit /b 0

:: ==========================================
:: MENU DE OTIMIZAÇÃO DO WINDOWS
:: ==========================================
:menuwindows
call :PrintHeader "OTIMIZAÇÃO DE WINDOWS"
echo.
echo                          Escolha a opção que você quer otimizar:
echo.
echo        !o![ !b! 1 !o!]!w! Otimizar Energia               !o![ !b!18 !o!]!w! Desat. Overlay do Xbox Game Bar
echo        !o![ !b! 2 !o!]!w! Desat. Efeitos Visuais         !o![ !b!19 !o!]!w! Otimizar Rede para Jogos
echo        !o![ !b! 3 !o!]!w! Tweaks de Privacidade          !o![ !b!20 !o!]!w! Resetar Cache de Miniaturas
echo        !o![ !b! 4 !o!]!w! Desat. Telemetria              !o![ !b!21 !o!]!w! Remover App Cortana
echo        !o![ !b! 5 !o!]!w! Desativar XBOX Totalmente      !o![ !b!22 !o!]!w! Desat. Prefetch e Superfetch
echo        !o![ !b! 6 !o!]!w! Desat. Relatórios de Erro      !o![ !b!23 !o!]!w! Fechar Explorer
echo        !o![ !b! 7 !o!]!w! Otimizar ALT+TAB               !o![ !b!24 !o!]!w! Iniciar Explorer
echo        !o![ !b! 8 !o!]!w! Desat. Relógio do Windows      !o![ !b!25 !o!]!w! Desat. UAC
echo        !o![ !b! 9 !o!]!w! Desat. Serviços Inúteis        !o![ !b!26 !o!]!w! Desat. Hyper-V
echo        !o![ !b!10 !o!]!w! Desat. Hibernação              !o![ !b!27 !o!]!w! Verificar/Arrumar Arquivos
echo        !o![ !b!11 !o!]!w! Otimizar Explorer              !o![ !b!28 !o!]!w! Limpar Cache de Rede
echo        !o![ !b!12 !o!]!w! Desat. Indexação               !o![ !b!29 !o!]!w! Limpar Arquivos Temporários
echo        !o![ !b!13 !o!]!w! Debloater                      !o![ !b!30 !o!]!w! Exclusão Defender (CyberSec)
echo        !o![ !b!14 !o!]!w! Desat. Notificações            !o![ !b!31 !o!]!w! Desat. Maps Manager
echo        !o![ !b!15 !o!]!w! Desat. Cortana                 !o![ !b!32 !o!]!w! Desat. TimeStamp
echo        !o![ !b!16 !o!]!w! Bloquear Feedback Automático   !o![ !b!33 !o!]!w! Desat. Aero Peek
echo        !o![ !b!17 !o!]!w! Desat. SmartScreen             !o![ !b!34 !o!]!w! REINICIAR PC
echo.
echo        !o![ !o!35 !o!]!o! Menu Principal!w!
echo.
if "!SIMULATE!"=="1" echo        !r![MODO SIMULAÇÃO ATIVO]!w!
echo.
set /p opcao="Digite o número (1-35): "

REM Validar entrada
for /f "tokens=1" %%A in ("!opcao!") do set "opcao=%%A"
if not "!opcao!" geq "1" goto invalid_menuwindows
if not "!opcao!" leq "35" goto invalid_menuwindows

if "!opcao!"=="35" goto menu
if "!opcao!"=="1"  goto win_1
if "!opcao!"=="2"  goto win_2
if "!opcao!"=="3"  goto win_3
if "!opcao!"=="4"  goto win_4
if "!opcao!"=="5"  goto win_5
if "!opcao!"=="6"  goto win_6
if "!opcao!"=="7"  goto win_7
if "!opcao!"=="8"  goto win_8
if "!opcao!"=="9"  goto win_9
if "!opcao!"=="10" goto win_10
if "!opcao!"=="11" goto win_11
if "!opcao!"=="12" goto win_12
if "!opcao!"=="13" goto win_13
if "!opcao!"=="14" goto win_14
if "!opcao!"=="15" goto win_15
if "!opcao!"=="16" goto win_16
if "!opcao!"=="17" goto win_17
if "!opcao!"=="18" goto win_18
if "!opcao!"=="19" goto win_19
if "!opcao!"=="20" goto win_20
if "!opcao!"=="21" goto win_21
if "!opcao!"=="22" goto win_22
if "!opcao!"=="23" goto win_23
if "!opcao!"=="24" goto win_24
if "!opcao!"=="25" goto win_25
if "!opcao!"=="26" goto win_26
if "!opcao!"=="27" goto win_27
if "!opcao!"=="28" goto win_28
if "!opcao!"=="29" goto win_29
if "!opcao!"=="30" goto win_30
if "!opcao!"=="31" goto win_31
if "!opcao!"=="32" goto win_32
if "!opcao!"=="33" goto win_33
if "!opcao!"=="34" goto win_34

:invalid_menuwindows
echo !r!Opção inválida. Digite um número entre 1 e 35.!w!
pause
goto menuwindows

:: Opção 1 - Otimizar Energia
:win_1
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "win_energia"
call :LogAction "Win: Otimizar Energia"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] powercfg & pause & goto menuwindows)
echo Otimizando Energia...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg.exe /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IdleDisable 0 >nul 2>&1
powercfg.exe /setactive SCHEME_CURRENT >nul 2>&1
powercfg.cpl
echo !g![OK] Energia otimizada!!w!
pause
goto menuwindows

:: Opção 2 - Desativar Efeitos Visuais
:win_2
call :PrintHeader "DESATIVAR EFEITOS VISUAIS"
echo.
echo !r![AVISO] Isso removerá animações, transparências e sombras do Windows.!w!
echo !r!         O sistema ficará mais rápido mas menos "bonito". Continuar? (S/N)!w!
set /p conf_win2="Confirmar: "
if /i not "!conf_win2!"=="S" goto menuwindows
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "win_visual"
call :LogAction "Win: Desativar Efeitos Visuais"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Desativar efeitos visuais & pause & goto menuwindows)
echo Desativando Efeitos Visuais...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo !g![OK] Efeitos visuais desativados!!w!
pause
goto menuwindows

:: Opção 3 - Tweaks de Privacidade
:win_3
call :PrintHeader "TWEAKS DE PRIVACIDADE"
echo.
echo !r![AVISO] Isso reduz coleta de dados da Microsoft mas pode afetar!w!
echo !r!         funcionalidades como sugestões personalizadas. Continuar? (S/N)!w!
set /p conf_win3="Confirmar: "
if /i not "!conf_win3!"=="S" goto menuwindows
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "win_privacidade"
call :LogAction "Win: Tweaks de Privacidade"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Tweaks de privacidade & pause & goto menuwindows)
echo Aplicando Tweaks de Privacidade...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_Recommendations /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Tweaks de Privacidade aplicados!!w!
pause
goto menuwindows

:: Opção 4 - Desativar Telemetria
:win_4
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "win_telemetria"
call :LogAction "Win: Desativar Telemetria"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Desativar telemetria & pause & goto menuwindows)
echo Desativando Telemetria...
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisableWindowsAdvertising" /t REG_DWORD /d 1 /f >nul 2>&1
echo !g![OK] Telemetria desativada!!w!
pause
goto menuwindows

:: Opção 5 - Desativar Xbox
:win_5
call :LogAction "Win: Gerenciar Xbox"
echo.
echo [1] Remover Xbox  [2] Restaurar Xbox  [3] Voltar
set /p escX="Opcao: "
if "!escX!"=="3" goto menuwindows
if "!escX!"=="1" (
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Remover Xbox & pause & goto menuwindows)
    call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" "win_xbox_xblauthmanager"
    call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" "win_xbox_xblgamesave"
    call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" "win_xbox_xboxgipsvc"
    call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" "win_xbox_xboxnetapisvc"
    sc stop "XblAuthManager" >nul 2>&1
    sc config "XblAuthManager" start= disabled >nul 2>&1
    sc stop "XblGameSave" >nul 2>&1
    sc config "XblGameSave" start= disabled >nul 2>&1
    sc stop "XboxGipSvc" >nul 2>&1
    sc config "XboxGipSvc" start= disabled >nul 2>&1
    sc stop "XboxNetApiSvc" >nul 2>&1
    sc config "XboxNetApiSvc" start= disabled >nul 2>&1
    powershell -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1
    echo !g![OK] Xbox removido!!w!
    pause
    goto menuwindows
)
if "!escX!"=="2" (
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Restaurar Xbox & pause & goto menuwindows)
    sc config "XblAuthManager" start= demand >nul 2>&1
    sc config "XblGameSave" start= demand >nul 2>&1
    sc config "XboxGipSvc" start= demand >nul 2>&1
    sc config "XboxNetApiSvc" start= demand >nul 2>&1
    echo !g![OK] Xbox restaurado!!w!
    pause
    goto menuwindows
)
echo !r!Opção inválida.!w!
pause
goto menuwindows

:: Opção 6 - Desativar Relatórios de Erro
:win_6
call :BackupReg "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "win_erros"
call :LogAction "Win: Desativar Relatórios de Erro"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Desativar relatórios de erro & pause & goto menuwindows)
echo Desativando Relatórios de Erro...
sc stop "WerSvc" >nul 2>&1
sc config "WerSvc" start= disabled >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DisableWindowsErrorReporting" /t REG_DWORD /d 1 /f >nul 2>&1
echo !g![OK] Relatórios de erro desativados!!w!
pause
goto menuwindows

:: Opção 7 - Otimizar ALT+TAB
:win_7
call :PrintHeader "OTIMIZAR ALT+TAB"
echo.
echo !r![AVISO] Isso reiniciará o Explorer (gerenciador de janelas).!w!
echo !r!         Aplicativos podem travar temporariamente. Continuar? (S/N)!w!
set /p conf_win7="Confirmar: "
if /i not "!conf_win7!"=="S" goto menuwindows
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" "win_alttab"
call :LogAction "Win: Otimizar ALT+TAB"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] AltTabSettings & pause & goto menuwindows)
echo Otimizando ALT+TAB...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v AltTabSettings /t REG_DWORD /D 1 /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul
start explorer.exe >nul 2>&1
echo !g![OK] ALT+TAB otimizado!!w!
pause
goto menuwindows

:: Opção 8 - Desativar Relógio Windows
:win_8
call :PrintHeader "DESATIVAR SINCRONIZAÇÃO DE RELÓGIO"
echo.
echo !r![AVISO CRÍTICO] Esta ação desativa o serviço w32time.!w!
echo !r!                 Isso pode causar dessincronização da hora do sistema.!w!
echo !r!                 Recomenda-se manter ativado. Tem CERTEZA? (S/N)!w!
set /p conf_w8="Confirmar: "
if /i not "!conf_w8!"=="S" goto menuwindows
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\w32time" "win_relogio"
call :LogAction "Win: Desativar Relógio Windows"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Desativar w32time & pause & goto menuwindows)
echo Desativando Relógio...
net stop w32time >nul 2>&1
sc config w32time start= disabled >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
echo !g![OK] Relógio do Windows ajustado!!w!
pause
goto menuwindows

:: Opção 9 - Desativar Serviços Inúteis
:win_9
call :PrintHeader "DESATIVAR SERVIÇOS"
echo.
echo !r![AVISO] Esta ação desativa Spooler (impressoras), wisvc e WbioSrvc (biometria).!w!
echo !r!         Impressoras e reconhecimento de voz podem parar de funcionar.!w!
echo !r!         Tem CERTEZA? (S/N)!w!
set /p conf_w9="Confirmar: "
if /i not "!conf_w9!"=="S" goto menuwindows
call :LogAction "Win: Desativar Serviços Inúteis"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Desativar serviços & pause & goto menuwindows)
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" "win_servico_spooler"
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\wisvc" "win_servico_wisvc"
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\WbioSrvc" "win_servico_wbiosrvc"
echo Desativando Serviços Inúteis...
sc stop Spooler >nul 2>&1
sc config Spooler start= disabled >nul 2>&1
sc stop wisvc >nul 2>&1
sc config wisvc start= disabled >nul 2>&1
sc stop WbioSrvc >nul 2>&1
sc config WbioSrvc start= disabled >nul 2>&1
echo !g![OK] Serviços desativados!!w!
pause
goto menuwindows

:: Opção 10 - Desativar Hibernação
:win_10
call :LogAction "Win: Desativar Hibernação"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] powercfg -h off & pause & goto menuwindows)
echo Desativando Hibernação...
powercfg -h off >nul 2>&1
if !errorlevel! equ 0 (
    echo !g![OK] Hibernação desativada!!w!
) else (
    echo !r![AVISO] Falha ao desativar hibernação (pode exigir privilégios adicionais).!w!
)
pause
goto menuwindows

:: Opção 11 - Otimizar Explorer
:win_11
call :PrintHeader "OTIMIZAR EXPLORER"
echo.
echo !r![AVISO] Isso altera configurações de visualização do Explorer.!w!
echo !r!         Arquivo recentes serão ocultados. Continuar? (S/N)!w!
set /p conf_win11="Confirmar: "
if /i not "!conf_win11!"=="S" goto menuwindows
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "win_explorer"
call :LogAction "Win: Otimizar Explorer"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Otimizar Explorer & pause & goto menuwindows)
echo Otimizando Explorer...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul
start explorer.exe >nul 2>&1
echo !g![OK] Explorer otimizado!!w!
pause
goto menuwindows

:: Opção 12 - Desativar Indexação
:win_12
call :LogAction "Win: Desativar Indexação"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] sc config WSearch disabled & pause & goto menuwindows)
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" "win_indexacao"
net stop "Windows Search" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
echo !g![OK] Indexação desativada!!w!
pause
goto menuwindows

:: Opção 13 - Debloater
:win_13
call :PrintHeader "REMOVER APPS DO WINDOWS"
echo.
echo !r![AVISO] Isso remove Office Hub, Maps e News (apps padrão do Windows).!w!
echo !r!         Continuar? (S/N)!w!
set /p conf_win13="Confirmar: "
if /i not "!conf_win13!"=="S" goto menuwindows
call :LogAction "Win: Debloater"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Remove-AppxPackage & pause & goto menuwindows)
echo Removendo apps padrão...
powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-AppxPackage *news* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Debloater aplicado!!w!
pause
goto menuwindows

:: Opção 14 - Desativar Notificações
:win_14
call :BackupReg "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" "win_notif"
call :LogAction "Win: Desativar Notificações"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] ToastEnabled=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Notificações desativadas!!w!
pause
goto menuwindows

:: Opção 15 - Desativar Cortana
:win_15
call :BackupReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "win_cortana"
call :LogAction "Win: Desativar Cortana"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] AllowCortana=0 & pause & goto menuwindows)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Cortana desativada!!w!
pause
goto menuwindows

:: Opção 16 - Bloquear Feedback
:win_16
call :BackupReg "HKCU\Software\Microsoft\Siuf\Rules" "win_feedback"
call :LogAction "Win: Bloquear Feedback"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] NumberOfSIUFInPeriod=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Feedback bloqueado!!w!
pause
goto menuwindows

:: Opção 17 - Desativar SmartScreen
:win_17
call :PrintHeader "DESATIVAR SMARTSCREEN"
echo.
echo !r![AVISO - RISCO] SmartScreen protege contra downloads maliciosos.!w!
echo !r!                 Desativar reduz proteção. Tem CERTEZA? (S/N)!w!
set /p conf_w17="Confirmar: "
if /i not "!conf_w17!"=="S" goto menuwindows
call :BackupReg "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" "win_smartscreen"
call :LogAction "Win: Desativar SmartScreen"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] SmartScreenEnabled=Off & pause & goto menuwindows)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off /f >nul 2>&1
echo !g![OK] SmartScreen desativado!!w!
pause
goto menuwindows

:: Opção 18 - Desativar Overlay Xbox Game Bar
:win_18
call :BackupReg "HKCU\Software\Microsoft\GameBar" "win_overlays"
call :LogAction "Win: Desativar Overlay do Xbox Game Bar"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] AllowAutoGameMode=0 & pause & goto menuwindows)
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Overlay do Xbox Game Bar desativado!!w!
pause
goto menuwindows

:: Opção 19 - Otimizar Rede para Jogos
:win_19
call :PrintHeader "OTIMIZAR REDE PARA JOGOS"
echo.
echo !r![AVISO] Ajustes de rede podem afetar conexões. Tem certeza? (S/N)!w!
set /p conf_w19="Confirmar: "
if /i not "!conf_w19!"=="S" goto menuwindows
call :LogAction "Win: Otimizar Rede para Jogos"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] netsh tcp set global & pause & goto menuwindows)
echo Otimizando Rede...
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global chimney=disabled >nul 2>&1
echo !g![OK] Rede otimizada!!w!
pause
goto menuwindows

:: Opção 20 - Resetar Cache de Miniaturas
:win_20
call :PrintHeader "RESETAR CACHE DE MINIATURAS"
echo.
echo !r![AVISO] Isso remove o cache de imagens do Explorer (pode levar tempo!w!
echo !r!         para recriar). Continuar? (S/N)!w!
set /p conf_win20="Confirmar: "
if /i not "!conf_win20!"=="S" goto menuwindows
call :LogAction "Win: Resetar Cache de Miniaturas"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] del thumbcache & pause & goto menuwindows)
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "!LocalAppData!\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
del /f /s /q "!LocalAppData!\Microsoft\Windows\Explorer\thumbcache*" >nul 2>&1
start explorer.exe >nul 2>&1
echo !g![OK] Cache limpo!!w!
pause
goto menuwindows

:: Opção 21 - Remover App Cortana
:win_21
call :LogAction "Win: Remover App Cortana"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Remove-AppxPackage Cortana & pause & goto menuwindows)
powershell -Command "Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage" >nul 2>&1
echo !g![OK] App Cortana removido!!w!
pause
goto menuwindows

:: Opção 22 - Desativar Prefetch
:win_22
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "win_prefetch"
call :LogAction "Win: Desativar Prefetch"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] SysMain disabled & pause & goto menuwindows)
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start= disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Prefetch desativado!!w!
pause
goto menuwindows

:: Opção 23 - Fechar Explorer
:win_23
call :LogAction "Win: Fechar Explorer"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] taskkill explorer.exe & pause & goto menuwindows)
taskkill /f /im explorer.exe >nul 2>&1
echo !g![OK] Explorer fechado!!w!
pause
goto menuwindows

:: Opção 24 - Iniciar Explorer
:win_24
call :LogAction "Win: Iniciar Explorer"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] start explorer.exe & pause & goto menuwindows)
start explorer.exe >nul 2>&1
echo !g![OK] Explorer iniciado!!w!
pause
goto menuwindows

:: Opção 25 - Desativar UAC
:win_25
call :PrintHeader "DESATIVAR UAC - RISCO CRÍTICO"
echo.
echo !r![AVISO - PERIGO MÁXIMO] Desativar UAC deixa o sistema vulnerável a!w!
echo !r!                        modificações não autorizadas por malware.!w!
echo !r!                        Isso é uma ação de RISCO EXTREMO.!w!
echo !r!                        Tem CERTEZA ABSOLUTA? (S/N)!w!
set /p conf_w25="Confirmar: "
if /i not "!conf_w25!"=="S" goto menuwindows
call :BackupReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "win_uac"
call :LogAction "Win: Desativar UAC"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] EnableLUA=0 & pause & goto menuwindows)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] UAC Desativado! Reinicie o PC para aplicar.!w!
pause
goto menuwindows

:: Opção 26 - Desativar Hyper-V
:win_26
call :PrintHeader "DESATIVAR HYPER-V"
echo.
echo !r![AVISO] Isso afeta máquinas virtuais e WSL2. Tem certeza? (S/N)!w!
set /p conf_w26="Confirmar: "
if /i not "!conf_w26!"=="S" goto menuwindows
call :LogAction "Win: Desativar Hyper-V"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] dism Disable Hyper-V & pause & goto menuwindows)
dism /Online /Disable-Feature:Microsoft-Hyper-V-All /NoRestart >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
echo !g![OK] Hyper-V desativado! Reinicie o PC para concluir.!w!
pause
goto menuwindows

:: Opção 27 - Verificar Arquivos do Sistema
:win_27
call :PrintHeader "VERIFICAR ARQUIVOS DO SISTEMA"
echo.
echo !y![INFO] Este processo pode levar VÁRIOS MINUTOS. Não interrompa!w!
echo.
call :LogAction "Win: Verificar Arquivos do Sistema"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] sfc /scannow & pause & goto menuwindows)
sfc /scannow
dism /online /cleanup-image /restorehealth
echo.
echo !g![OK] Arquivos verificados e corrigidos!!w!
pause
goto menuwindows

:: Opção 28 - Limpar Cache de Rede
:win_28
call :LogAction "Win: Limpar Cache de Rede"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] flushdns winsock reset & pause & goto menuwindows)
echo Limpando DNS cache...
ipconfig /flushdns >nul 2>&1
echo Resetando Winsock...
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo !g![OK] Cache de rede limpo!!w!
pause
goto menuwindows

:: Opção 29 - Limpar Arquivos Temporários
:win_29
call :PrintHeader "LIMPAR ARQUIVOS TEMPORÁRIOS"
echo.
echo !r![AVISO] Isso remove arquivos temp (pode falhar se estiverem em uso).!w!
echo !r!         Use limpeza via Disco Cleanup para alternativa segura. (S/N)!w!
set /p conf_win29="Continuar com limpeza agressiva? "
if /i not "!conf_win29!"=="S" goto menuwindows
call :LogAction "Win: Limpar Temporários"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] del /temp & pause & goto menuwindows)
echo Limpando temporários...
del /s /f /q "!temp!\*.*" >nul 2>&1
del /s /f /q "!windir!\temp\*.*" >nul 2>&1
cleanmgr.exe
echo !g![OK] Temporários limpos!!w!
pause
goto menuwindows

:: Opção 30 - Exclusão Defender (CyberSec)
:win_30
call :PrintHeader "EXCLUSÃO DEFENDER (CYBERSEC)"
echo.
echo !r![AVISO] Adiciona uma pasta às exclusões do Windows Defender.!w!
echo !r!         Use APENAS em pastas confiáveis!!w!
echo.
set /p folder_path="Digite o caminho completo (ex: C:\Games\): "

REM Validar entrada
if "!folder_path!"=="" (
    echo !r![ERRO] Caminho vazio! Operação cancelada.!w!
    pause
    goto menuwindows
)

REM Verificar se path é válido (contém colon no Windows path)
echo !folder_path! | findstr /R "^[a-zA-Z]:" >nul 2>&1
if !errorlevel! neq 0 (
    echo !r![ERRO] Caminho deve começar com unidade (ex: C:\).!w!
    pause
    goto menuwindows
)

if not exist "!folder_path!\" (
    echo.
    echo !r![AVISO] Esta pasta não existe no disco. Confira antes de continuar. (S/N)!w!
    set /p conf_folder="Adicionar mesmo assim? "
    if /i not "!conf_folder!"=="S" goto menuwindows
)

echo.
echo !r![CONFIRMAÇÃO] Adicionar exclusão para: !folder_path! ? (S/N)!w!
set /p conf_w30="Confirmar: "
if /i not "!conf_w30!"=="S" goto menuwindows
call :LogAction "Win: Exclusão Defender para !folder_path!"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Add-MpPreference -ExclusionPath & pause & goto menuwindows)
powershell -Command "Add-MpPreference -ExclusionPath '!folder_path!'" >nul 2>&1
if !errorlevel! equ 0 (
    echo !g![OK] Pasta blindada contra scans do Defender!!w!
) else (
    echo !r![ERRO] Falha ao adicionar exclusão. Verifique permissões.!w!
)
pause
goto menuwindows

:: Opção 31 - Desativar Maps Manager
:win_31
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" "win_maps"
call :LogAction "Win: Desativar Maps Manager"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] MapsBroker Start=4 & pause & goto menuwindows)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo !g![OK] Maps Broker Desativado!!w!
pause
goto menuwindows

:: Opção 32 - Desativar TimeStamp
:win_32
call :BackupReg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" "win_timestamp"
call :LogAction "Win: Desativar TimeStamp"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] NtfsDisableLastAccessUpdate=1 & pause & goto menuwindows)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1
echo !g![OK] TimeStamp desativado!!w!
pause
goto menuwindows

:: Opção 33 - Desativar Aero Peek
:win_33
call :BackupReg "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "win_aeropeek"
call :LogAction "Win: Desativar Aero Peek"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] EnableAeroPeek=0 & pause & goto menuwindows)
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Aero Peek desativado!!w!
pause
goto menuwindows

:: Opção 34 - Reiniciar PC
:win_34
echo.
echo !r![AVISO] O PC será REINICIADO em 5 segundos. Salve seus arquivos!w!
echo !r!          (Pressione Ctrl+C para cancelar)!w!
echo.
pause
call :LogAction "Win: Reiniciar PC"
shutdown /r /t 5 /c "WinBooster - Reinicialização agendada"
goto menu

:: ==========================================
:: PRIORIDADE DE JOGOS
:: ==========================================
:prioridadegames
call :PrintHeader "AUMENTAR PRIORIDADE NOS GAMES"
echo.
echo        !o![ !b! 1 !o!]!w! Fortnite                             !o![ !b!16 !o!]!w! ULTRAKILL
echo        !o![ !b! 2 !o!]!w! Gta V                                !o![ !b!17 !o!]!w! Blood Strike
echo        !o![ !b! 3 !o!]!w! FiveM                                !o![ !b!18 !o!]!w! Arena Breakout
echo        !o![ !b! 4 !o!]!w! CS2                                  !o![ !b!19 !o!]!w! Resident Evil 4 Remake
echo        !o![ !b! 5 !o!]!w! Minecraft                            !o![ !b!20 !o!]!w! Resident Evil 2 Remake
echo        !o![ !b! 6 !o!]!w! Valorant                             !o![ !b!21 !o!]!w! Resident Evil Village
echo        !o![ !b! 7 !o!]!w! League of Legends                    !o![ !b!22 !o!]!w! Free Fire
echo        !o![ !b! 8 !o!]!w! Warzone                              !o![ !b!23 !o!]!w! Battlefield 2042
echo        !o![ !b! 9 !o!]!w! Apex Legends                         !o![ !b!24 !o!]!w! Battlefield 4
echo        !o![ !b!10 !o!]!w! Roblox                               !o![ !b!25 !o!]!w! The Last Of US 1 e 2
echo        !o![ !b!11 !o!]!w! God Of War (Ambos)                   !o![ !b!26 !o!]!w! PUBG
echo        !o![ !b!12 !o!]!w! MTA                                  !o![ !b!27 !o!]!w! Rocket League
echo        !o![ !b!13 !o!]!w! Euro Truck (1 e 2)                   !o![ !b!28 !o!]!w! Cyberpunk 2077
echo        !o![ !b!14 !o!]!w! Rainbow Six                          !o![ !b!29 !o!]!w! Terraria
echo        !o![ !b!15 !o!]!w! Cult of the Lamb                     !o![ !b!30 !o!]!w! Red Dead 2
echo.
echo        !o![ !o!31 !o!]!o! Voltar ao Menu Principal          !o![ !o!32 !o!]!o! REVERTER TODOS !w!
echo.
if "!SIMULATE!"=="1" echo        !r![MODO SIMULAÇÃO ATIVO]!w!
echo.
set /p jogo="Digite o numero (1-32): "

if "!jogo!"=="31" goto menu
if "!jogo!"=="32" goto revert_all_games

if "!jogo!"=="1"  call :SetGamePriority "FortniteClient-Win64-Shipping.exe"
if "!jogo!"=="2"  call :SetGamePriority "GTA5.exe"
if "!jogo!"=="3"  call :SetGamePriority "FiveM_b2372_GTAProcess.exe"
if "!jogo!"=="4"  call :SetGamePriority "cs2.exe"
if "!jogo!"=="5"  call :SetGamePriority "javaw.exe"
if "!jogo!"=="6"  call :SetGamePriority "VALORANT-Win64-Shipping.exe"
if "!jogo!"=="7"  call :SetGamePriority "LeagueClient.exe"
if "!jogo!"=="8"  call :SetGamePriority "cod.exe"
if "!jogo!"=="9"  call :SetGamePriority "r5apex.exe"
if "!jogo!"=="10" call :SetGamePriority "RobloxPlayerBeta.exe"
if "!jogo!"=="11" (call :SetGamePriority "GoW.exe" & call :SetGamePriority "GoWRagnarok.exe")
if "!jogo!"=="12" (call :SetGamePriority "Multi Theft Auto.exe" & call :SetGamePriority "gta_sa.exe")
if "!jogo!"=="13" (call :SetGamePriority "eurotrucks.exe" & call :SetGamePriority "ets2.exe")
if "!jogo!"=="14" call :SetGamePriority "RainbowSix.exe"
if "!jogo!"=="15" call :SetGamePriority "CultOfTheLamb.exe"
if "!jogo!"=="16" call :SetGamePriority "ULTRAKILL.exe"
if "!jogo!"=="17" call :SetGamePriority "BloodStrike.exe"
if "!jogo!"=="18" call :SetGamePriority "ArenaBreakout.exe"
if "!jogo!"=="19" call :SetGamePriority "re4.exe"
if "!jogo!"=="20" call :SetGamePriority "re2.exe"
if "!jogo!"=="21" call :SetGamePriority "re8.exe"
if "!jogo!"=="22" call :SetGamePriority "HD-Player.exe"
if "!jogo!"=="23" call :SetGamePriority "BF2042.exe"
if "!jogo!"=="24" call :SetGamePriority "bf4.exe"
if "!jogo!"=="25" (call :SetGamePriority "tlou-i.exe" & call :SetGamePriority "tlou-ii.exe")
if "!jogo!"=="26" call :SetGamePriority "tslgame.exe"
if "!jogo!"=="27" call :SetGamePriority "RocketLeague.exe"
if "!jogo!"=="28" call :SetGamePriority "Cyberpunk2077.exe"
if "!jogo!"=="29" call :SetGamePriority "Terraria.exe"
if "!jogo!"=="30" call :SetGamePriority "RDR2.exe"

echo !g![OK] Prioridade do jogo aumentada!!w!
pause
goto prioridadegames

:revert_all_games
call :LogAction "Games: Reverter Todas as Prioridades"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Reverter prioridades de todos os jogos & pause & goto prioridadegames)
echo Revertendo prioridades de todos os jogos...
for %%G in (FortniteClient-Win64-Shipping.exe GTA5.exe FiveM_b2372_GTAProcess.exe cs2.exe javaw.exe VALORANT-Win64-Shipping.exe LeagueClient.exe cod.exe r5apex.exe RobloxPlayerBeta.exe GoW.exe GoWRagnarok.exe "Multi Theft Auto.exe" gta_sa.exe eurotrucks.exe ets2.exe RainbowSix.exe CultOfTheLamb.exe ULTRAKILL.exe BloodStrike.exe ArenaBreakout.exe re4.exe re2.exe re8.exe HD-Player.exe BF2042.exe bf4.exe tlou-i.exe tlou-ii.exe tslgame.exe RocketLeague.exe Cyberpunk2077.exe Terraria.exe RDR2.exe) do (
    call :RevertGamePriority "%%~G"
)
echo !g![OK] Todos os jogos revertidos!!w!
pause
goto prioridadegames

:: ==========================================
:: OTIMIZAÇÃO DE PERIFÉRICOS
:: ==========================================
:perifericos
call :PrintHeader "OTIMIZAÇÃO DE PERIFÉRICOS"
echo.
echo            !o![ !b! 1 !o!]!w! Otimizar HDD                    !o![ !b! 2 !o!]!w! Otimizar SSD
echo            !o![ !b! 3 !o!]!w! Verificar Temperatura           !o![ !b! 4 !o!]!w! Otimizar Teclado
echo            !o![ !b! 5 !o!]!w! Otimizar Mouse                  !o![ !b! 6 !o!]!w! Reverter Otimização
echo            !o![ !o! 7 !o!]!o! Voltar ao Menu Principal!w!
echo.
if "!SIMULATE!"=="1" echo            !r![MODO SIMULAÇÃO ATIVO]!w!
echo.
set /p opcao="Digite o número (1-7): "

if "!opcao!"=="7" goto menu
if "!opcao!"=="1" (
    call :LogAction "Periférico: Otimizar HDD"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] fsutil HDD & pause & goto perifericos)
    fsutil behavior set disableLastAccess 2 >nul 2>&1
    fsutil behavior set disable8dot3 0 >nul 2>&1
    echo !g![OK] HDD Otimizado!!w!
    pause
    goto perifericos
)
if "!opcao!"=="2" (
    call :LogAction "Periférico: Otimizar SSD"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] fsutil SSD & pause & goto perifericos)
    schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
    fsutil behavior set disableLastAccess 0 >nul 2>&1
    fsutil behavior set disable8dot3 1 >nul 2>&1
    echo !g![OK] SSD Otimizado!!w!
    pause
    goto perifericos
)
if "!opcao!"=="3" (
    call :CheckTool "OpenHardwareMonitor.exe"
    if !errorlevel! equ 1 goto perifericos
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] start OpenHardwareMonitor.exe & pause & goto perifericos)
    start "" "!~dp0!OpenHardwareMonitor.exe"
    echo !g![OK] Monitor de hardware aberto!!w!
    pause
    goto perifericos
)
if "!opcao!"=="4" (
    call :BackupReg "HKCU\Control Panel\Keyboard" "teclado"
    call :LogAction "Periférico: Otimizar Teclado"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Keyboard settings & pause & goto perifericos)
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f >nul 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f >nul 2>&1
    call :CheckTool "FilterKeysSetter.exe"
    if !errorlevel! equ 0 start "" "!~dp0!FilterKeysSetter.exe"
    echo !g![OK] Teclado Otimizado!!w!
    pause
    goto perifericos
)
if "!opcao!"=="5" (
    call :BackupReg "HKCU\Control Panel\Mouse" "mouse"
    call :LogAction "Periférico: Otimizar Mouse"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Mouse settings & pause & goto perifericos)
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
    RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True >nul 2>&1
    echo !g![OK] Mouse otimizado!!w!
    pause
    goto perifericos
)
if "!opcao!"=="6" (
    call :LogAction "Periférico: Reverter Otimizações"
    if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Reverter periféricos & pause & goto perifericos)
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f >nul 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 1 /f >nul 2>&1
    fsutil behavior set disableLastAccess 1 >nul 2>&1
    echo !g![OK] Periféricos Revertidos!!w!
    pause
    goto perifericos
)
echo !r!Opção inválida. Digite um número entre 1 e 7.!w!
pause
goto perifericos

:: ==========================================
:: OTIMIZAÇÕES AVANÇADAS DE FPS (Resumido por espaço)
:: ==========================================
:fpsavancado
call :PrintHeader "OTIMIZAÇÕES AVANÇADAS DE FPS"
echo.
echo        !o![ !b! 1 !o!]!w! Modo de Jogo + Sem DVR              !o![ !b! 5 !o!]!w! Desat. Power Throttling
echo        !o![ !b! 2 !o!]!w! GPU Scheduling (HAGS)               !o![ !b! 6 !o!]!w! Desat. Nagle (Latência de Rede)
echo        !o![ !b! 3 !o!]!w! Prioridade de CPU p/ Jogos          !o![ !b! 7 !o!]!w! Reduzir Fila do Mouse (Input Lag)
echo        !o![ !b! 4 !o!]!w! MMCSS (Agendador Multimídia)        !o![ !b! 8 !o!]!w! Desat. VBS/Core Isolation (RISCO)
echo.
echo        !o![ !o! 9 !o!]!o! Reverter Todos os Tweaks de FPS   !o![ !o!10 !o!]!o! Voltar ao Menu Principal!w!
echo.
if "!SIMULATE!"=="1" echo        !r![MODO SIMULAÇÃO ATIVO]!w!
echo.
set /p opcao="Digite o número (1-10): "

if "!opcao!"=="10" goto menu
if "!opcao!"=="1" goto fps_1
if "!opcao!"=="2" goto fps_2
if "!opcao!"=="3" goto fps_3
if "!opcao!"=="4" goto fps_4
if "!opcao!"=="5" goto fps_5
if "!opcao!"=="6" goto fps_6
if "!opcao!"=="7" goto fps_7
if "!opcao!"=="8" goto fps_8
if "!opcao!"=="9" goto fps_revert

echo !r!Opção inválida. Digite um número entre 1 e 10.!w!
pause
goto fpsavancado

:fps_1
call :BackupReg "HKCU\System\GameConfigStore" "fps_gamemode"
call :LogAction "FPS: Modo de Jogo + Sem DVR"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Ativar Game Mode / Desativar Game DVR & pause & goto fpsavancado)
echo Ativando Modo de Jogo e desativando Game DVR...
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] Modo de Jogo ativado e Game DVR desativado!!w!
pause
goto fpsavancado

:fps_2
call :PrintHeader "GPU SCHEDULING (HAGS)"
echo.
echo !y![INFO] Ativa Agendamento de GPU por Hardware. Requer GPU/driver compatível!w!
echo !y!       e REINICIALIZAÇÃO.!w!
echo.
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "fps_hags"
call :LogAction "FPS: GPU Scheduling (HAGS) ON"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] HwSchMode=2 & pause & goto fpsavancado)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo !g![OK] GPU Scheduling ativado! Reinicie o PC.!w!
pause
goto fpsavancado

:fps_3
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "fps_cpupriority"
call :LogAction "FPS: Prioridade de CPU para Jogos"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Win32PrioritySeparation=38 & pause & goto fpsavancado)
echo Ajustando prioridade de CPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo !g![OK] Prioridade de CPU ajustada!!w!
pause
goto fpsavancado

:fps_4
call :BackupReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "fps_mmcss"
call :LogAction "FPS: MMCSS para Jogos"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] MMCSS Games High Priority & pause & goto fpsavancado)
echo Configurando Agendador Multimídia (MMCSS)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d High /f >nul 2>&1
echo !g![OK] MMCSS configurado!!w!
pause
goto fpsavancado

:fps_5
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "fps_powerthrottling"
call :LogAction "FPS: Desativar Power Throttling"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] PowerThrottlingOff=1 & pause & goto fpsavancado)
echo Desativando Power Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
echo !g![OK] Power Throttling desativado!!w!
pause
goto fpsavancado

:fps_6
call :LogAction "FPS: Desativar Nagle"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] TcpAckFrequency=1 / TCPNoDelay=1 & pause & goto fpsavancado)
powershell -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name TcpAckFrequency -Type DWord -Value 1 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name TCPNoDelay -Type DWord -Value 1 -ErrorAction SilentlyContinue }" >nul 2>&1
echo !g![OK] Nagle desativado!!w!
pause
goto fpsavancado

:fps_7
call :PrintHeader "REDUZIR FILA DO MOUSE"
echo.
echo !y![INFO] Reduz input lag de mouses de alta taxa de reporte. Requer REINICIALIZAÇÃO.!w!
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" "fps_mousequeue"
call :LogAction "FPS: Reduzir Fila do Mouse"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] MouseDataQueueSize=20 & pause & goto fpsavancado)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 20 /f >nul 2>&1
echo !g![OK] Fila do mouse reduzida! Reinicie o PC.!w!
pause
goto fpsavancado

:fps_8
call :PrintHeader "DESATIVAR VBS/CORE ISOLATION - RISCO"
echo.
echo !r![RISCO ALTO] Isso remove proteção de kernel contra malware avançado.!w!
echo !r!              Use apenas em PC gamer dedicado. Tem CERTEZA? (S/N)!w!
set /p conf_fps8="Confirmar: "
if /i not "!conf_fps8!"=="S" goto fpsavancado
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" "fps_vbs"
call :LogAction "FPS: Desativar VBS/Core Isolation"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] EnableVirtualizationBasedSecurity=0 & pause & goto fpsavancado)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 0 /f >nul 2>&1
echo !g![OK] VBS desativado! Reinicie o PC.!w!
pause
goto fpsavancado

:fps_revert
call :LogAction "FPS: Reverter Todos os Tweaks"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Reverter todos os tweaks de FPS & pause & goto fpsavancado)
echo Revertendo tweaks de FPS...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /f >nul 2>&1
powershell -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Remove-ItemProperty -Path $_.PSPath -Name TcpAckFrequency -ErrorAction SilentlyContinue; Remove-ItemProperty -Path $_.PSPath -Name TCPNoDelay -ErrorAction SilentlyContinue }" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /f >nul 2>&1
echo !g![OK] Tweaks de FPS revertidos! Reinicie o PC.!w!
pause
goto fpsavancado

:: ==========================================
:: TWEAKS PROFUNDOS (Apenas labels, versão reduzida)
:: ==========================================
:tweaksprofundos
call :PrintHeader "TWEAKS PROFUNDOS (AVANÇADO)"
echo.
echo !r![ATENÇÃO] Seção com ajustes profundos do sistema operacional.!w!
echo !r!           Cada opção mostra avisos detalhados e pede confirmação.!w!
echo.
echo        !o![ !b! 1 !o!]!w! Desativar Core Parking (100% dos Núcleos Ativos)
echo        !o![ !b! 2 !o!]!w! Desativar Dynamic Tick / Timer Coalescing
echo        !o![ !b! 3 !o!]!w! Desativar HPET (High Precision Event Timer)
echo        !o![ !b! 4 !o!]!w! Pagefile Fixo Otimizado (Baseado na RAM)
echo        !o![ !b! 5 !o!]!w! Desativar Mitigações Spectre/Meltdown (RISCO ALTO)
echo.
echo        !o![ !o! 6 !o!]!o! Reverter Todos os Tweaks Profundos   !o![ !o! 7 !o!]!o! Voltar ao Menu Principal!w!
echo.
if "!SIMULATE!"=="1" echo        !r![MODO SIMULAÇÃO ATIVO]!w!
echo.
set /p opcao="Digite o número (1-7): "

if "!opcao!"=="7" goto menu
if "!opcao!"=="1" goto tp_1
if "!opcao!"=="2" goto tp_2
if "!opcao!"=="3" goto tp_3
if "!opcao!"=="4" goto tp_4
if "!opcao!"=="5" goto tp_5
if "!opcao!"=="6" goto tp_revert

echo !r!Opção inválida. Digite um número entre 1 e 7.!w!
pause
goto tweaksprofundos

:tp_1
call :PrintHeader "CORE PARKING"
echo.
echo !y![O QUE FAZ]!w!
echo  O Windows desliga (estaciona) núcleos ociosos para economizar energia.
echo  Desativar mantém todos os núcleos ativos, reduzindo latência.
echo.
echo !r![RISCO]!w!
echo  Maior consumo de energia, temperatura e ruído de cooler.
echo  Em notebooks reduz autonomia de bateria.
echo.
set /p conf_tp1="Deseja aplicar? (S/N): "
if /i not "!conf_tp1!"=="S" goto tweaksprofundos
call :LogAction "TweakProfundo: Core Parking"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] CPMINCORES=100 & pause & goto tweaksprofundos)
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
echo !g![OK] Core Parking desativado!!w!
pause
goto tweaksprofundos

:tp_2
call :PrintHeader "DYNAMIC TICK"
echo.
echo !y![O QUE FAZ]!w!
echo  Permite que CPU entre em estados profundos de economia de energia.
echo  Desativar pode reduzir microstutters no jogo.
echo.
echo !r![RISCO]!w!
echo  Aumenta consumo de energia em idle. Requer REINICIALIZAÇÃO.
echo.
set /p conf_tp2="Deseja aplicar? (S/N): "
if /i not "!conf_tp2!"=="S" goto tweaksprofundos
call :LogAction "TweakProfundo: Dynamic Tick"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] bcdedit disabledynamictick yes & pause & goto tweaksprofundos)
bcdedit /set disabledynamictick yes >nul 2>&1
echo !g![OK] Dynamic Tick desativado! Reinicie o PC.!w!
pause
goto tweaksprofundos

:tp_3
call :PrintHeader "HPET (HIGH PRECISION EVENT TIMER)"
echo.
echo !y![O QUE FAZ]!w!
echo  Força Windows a usar TSC da CPU em vez de HPET para sincronização.
echo  Pode reduzir input lag em alguns sistemas.
echo.
echo !r![RISCO CRÍTICO]!w!
echo  Em hardware antigo pode causar instabilidade de clock e BSOD.
echo  Crie Ponto de Restauração antes! Requer REINICIALIZAÇÃO.
echo.
set /p conf_tp3="Tem CERTEZA? (S/N): "
if /i not "!conf_tp3!"=="S" goto tweaksprofundos
call :LogAction "TweakProfundo: HPET"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] bcdedit useplatformclock false & pause & goto tweaksprofundos)
bcdedit /set useplatformclock false >nul 2>&1
echo !g![OK] HPET desativado! Reinicie o PC. Se notar instabilidade, volte aqui.!w!
pause
goto tweaksprofundos

:tp_4
call :PrintHeader "PAGEFILE FIXO OTIMIZADO"
echo.
echo !y![O QUE FAZ]!w!
echo  Define tamanho fixo do arquivo de paginação (1.5x a RAM).
echo  Evita redimensionamento dinâmico que causa engasgos.
echo.
echo !r![RISCO]!w!
echo  Se insuficiente, aplicativos podem travar. Recomendado para 16GB+ RAM.
echo.
set /p conf_tp4="Deseja aplicar? (S/N): "
if /i not "!conf_tp4!"=="S" goto tweaksprofundos
call :LogAction "TweakProfundo: Pagefile Fixo"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Pagefile fixo 1.5x RAM & pause & goto tweaksprofundos)
powershell -Command "$ram=(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1MB; $size=[math]::Round($ram*1.5); $cs=Get-WmiObject Win32_ComputerSystem; $cs.AutomaticManagedPagefile=$false; $cs.Put(); $pf=Get-WmiObject Win32_PageFileSetting; $pf.InitialSize=$size; $pf.MaximumSize=$size; $pf.Put()" >nul 2>&1
echo !g![OK] Pagefile fixo configurado! Reinicie o PC.!w!
pause
goto tweaksprofundos

:tp_5
call :PrintHeader "DESATIVAR SPECTRE/MELTDOWN"
echo.
echo !y![O QUE FAZ]!w!
echo  Remove proteções contra execução especulativa de CPU.
echo  Recupera desempenho em jogos com muitas chamadas de sistema.
echo.
echo !r![RISCO EXTREMO]!w!
echo  Seu sistema fica exposto a ataques de canal lateral (side-channel).
echo  NÃO recomendado para PCs com dados sensíveis.
echo  Use APENAS em PC gamer dedicado, offline se possível.
echo.
set /p conf_tp5="Tem CERTEZA ABSOLUTA? (S/N): "
if /i not "!conf_tp5!"=="S" goto tweaksprofundos
call :BackupReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "tp_spectre"
call :LogAction "TweakProfundo: Espectre/Meltdown"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] FeatureSettingsOverride=3 & pause & goto tweaksprofundos)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul 2>&1
echo !g![OK] Mitigações desativadas! Reinicie o PC.!w!
pause
goto tweaksprofundos

:tp_revert
call :LogAction "TweakProfundo: Reverter Todos"
if "!SIMULATE!"=="1" (echo [SIMULAÇÃO] Reverter todos os tweaks profundos & pause & goto tweaksprofundos)
echo Revertendo tweaks profundos...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 5 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
powershell -Command "$cs=Get-WmiObject Win32_ComputerSystem; $cs.AutomaticManagedPagefile=$true; $cs.Put()" >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /f >nul 2>&1
echo !g![OK] Tweaks profundos revertidos! Reinicie o PC.!w!
pause
goto tweaksprofundos

:: ==========================================
:: FUNÇÕES CENTRAIS (CORRIGIDAS)
:: ==========================================

:SetGamePriority
if "!SIMULATE!"=="1" (
    echo [SIMULAÇÃO] SetGamePriority: %~1
    goto :eof
)
REM Validar se processo existe
tasklist | find /i "%~1" >nul 2>&1
if !errorlevel! neq 0 (
    echo !q![INFO] %~1 não está em execução no momento.!w!
)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
call :LogAction "SetGamePriority: %~1"
goto :eof

:RevertGamePriority
if "!SIMULATE!"=="1" (
    echo [SIMULAÇÃO] RevertGamePriority: %~1
    goto :eof
)
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1\PerfOptions" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~1" /f >nul 2>&1
goto :eof

:CheckTool
if not exist "!~dp0!%~1" (
    echo.
    echo !r![ERRO] %~1 não encontrado na pasta do script!!w!
    echo !r!        Coloque o arquivo na mesma pasta que WinBooster.bat!w!
    echo.
    pause
    exit /b 1
)
exit /b 0

:BackupReg
REM Parâmetros: %~1 = chave, %~2 = nome backup
if "!SIMULATE!"=="1" (
    echo [SIMULAÇÃO] BackupReg: %~1
    goto :eof
)
REM Verificar se chave existe
reg query "%~1" >nul 2>&1
if !errorlevel! neq 0 (
    echo !q![BACKUP] Chave não existe ainda - ignorado.!w!
    goto :eof
)
set "BACKUP_FILE=!BACKUP_DIR!\%~2_!STAMP!.reg"
reg export "%~1" "!BACKUP_FILE!" /y >nul 2>&1
if exist "!BACKUP_FILE!" (
    echo !q![BACKUP] Salvain: !BACKUP_FILE!!w!
) else (
    echo !r![AVISO] Falha ao fazer backup do registro.!w!
)
goto :eof

:LogAction
echo [%DATE% %TIME%] %~1 >> "!LOGFILE!"
goto :eof

:PrintHeader
cls
echo !o!      ==============================================================================
echo !w!                                %~1
echo !o!      =============================================================================!w!
echo.
goto :eof
