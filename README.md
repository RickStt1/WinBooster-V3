# WinBooster V3

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%2F%2011-0078D6?style=flat&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen?style=flat)
![Language](https://img.shields.io/badge/Language-Batch%20Script-orange?style=flat)

Script `.bat` de manutenção e otimização para Windows com foco em performance, gaming e privacidade. Centraliza em um único menu interativo CLI operações que normalmente exigem conhecimento avançado de registro, serviços e configurações do sistema — com backups automáticos, logs por sessão e modo de simulação.

> Antes de aplicar qualquer otimização, use a opção 1 do menu para criar um ponto de restauração do sistema.

---

## Índice

- [Diferenciais](#diferenciais)
- [Como Usar](#como-usar)
- [Menu Principal](#menu-principal)
- [Otimizações de Windows](#otimizações-de-windows)
- [Otimizações de Jogos](#otimizações-de-jogos)
- [Otimizações de Periféricos](#otimizações-de-periféricos)
- [Otimizações Avançadas de FPS](#otimizações-avançadas-de-fps)
- [Tweaks Profundos](#tweaks-profundos)
- [Kit Pós-Formatação](#kit-pós-formatação)
- [Ferramentas Utilitárias](#ferramentas-utilitárias)
- [Ferramentas Externas](#ferramentas-externas)
- [Sistema de Backup e Logs](#sistema-de-backup-e-logs)
- [Segurança](#segurança)
- [Arquitetura Interna](#arquitetura-interna)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Compatibilidade](#compatibilidade)
- [Aviso Legal](#aviso-legal)

---

## Diferenciais

- **Backups automáticos por feature** — a chave de registro relevante é exportada para `Backups/` antes de qualquer modificação crítica, permitindo reversão cirúrgica sem precisar restaurar o sistema inteiro
- **Logs por sessão** — cada execução gera um arquivo `.log` com timestamp em `Logs/`, registrando cada ação realizada com data e hora exatas
- **Modo simulação** — exibe exatamente o que seria executado, incluindo os comandos, sem aplicar nenhuma alteração real; útil para auditar o script antes de rodar em produção
- **Confirmação explícita em ações de risco** — operações sensíveis exigem que o usuário digite `S` para prosseguir; o script não assume resposta padrão
- **Validação de ferramentas externas** — antes de tentar abrir qualquer `.exe` externo, o script verifica se o arquivo existe na pasta e exibe um erro claro caso esteja ausente
- **Elevação automática de privilégio** — ao detectar que não está sendo executado como administrador, o script cria um VBScript temporário para se relançar com `runas`, sem intervenção do usuário além do clique no UAC

---

## Como Usar

**Pré-requisito:** Windows 10 ou 11, PowerShell disponível (incluso por padrão), e conta com privilégios de Administrador.

**Via Explorer**

1. Clique com o botão direito em `WinBoosterV3.bat`
2. Selecione "Executar como administrador"
3. Caso o UAC apareça, confirme a elevação
4. Navegue pelos menus digitando o número da opção desejada e pressionando Enter

**Via terminal (CMD já aberto como administrador)**

```cmd
cd C:\caminho\para\WinBooster
WinBoosterV3.bat
```

**Modo Simulação**

Selecione a opção **10** no menu principal para ativar ou desativar o modo de simulação. Quando ativo, uma faixa vermelha no rodapé do menu indica `[MODO SIMULAÇÃO ATIVO - Nenhuma alteração será feita]`. Cada comando que seria executado aparece prefixado com `[SIMULAÇÃO]` no terminal, mas nenhuma alteração é efetivada no sistema.

**Restaurar um backup de registro manualmente**

1. Abra a pasta `Backups/` na raiz do script
2. Identifique o arquivo `.reg` pelo nome da feature e pelo timestamp da sessão (ex: `win_uac_2025-06-01_14-30-00.reg`)
3. Dê duplo clique no arquivo e confirme a importação no prompt do Windows
4. Reinicie se a opção original exigia reinicialização

---

## Menu Principal

O menu principal agrupa as funcionalidades em 13 entradas:

| Opção | Função |
|-------|--------|
| 1 | Criar Ponto de Restauração do Sistema |
| 2 | Otimizações de Windows (~34 sub-opções) |
| 3 | Otimização de Jogos — prioridade de CPU por jogo |
| 4 | Otimização de Periféricos — mouse, teclado, HDD, SSD |
| 5 | Configuração de Inicialização do Windows (Autoruns) |
| 6 | Verificar Temperatura — abre OpenHardwareMonitor |
| 7 | Kit Pós-Formatação — instala apps via Winget |
| 8 | Liberar Memória RAM — abre RAMMap |
| 9 | Melhorar Conexão/Ping — flush DNS + DnsJumper |
| 10 | Modo Simulação (ON/OFF) |
| 11 | Otimizações Avançadas de FPS |
| 12 | Tweaks Profundos (risco elevado) |
| 13 | Sair |

---

## Otimizações de Windows

Submenu com 34 opções organizadas por área. Todas com backup automático de registro antes da execução e confirmação explícita nas ações de maior risco.

### Energia e visual

**1 — Otimizar Energia**
Duplica o plano de energia "Ultimate Performance" (`e9a42b02...`) e configura `IdleDisable = 0` no subgrupo de processador, mantendo a CPU sem entrar em estados de economia durante uso. Abre o painel de Energia do Windows ao final.

**2 — Desativar Efeitos Visuais**
Define `VisualFXSetting = 2` (desempenho máximo), desativa transparências (`EnableTransparency = 0`) e aplica uma máscara binária ao `UserPreferencesMask` do painel de controle. Requer confirmação — o sistema fica visivelmente mais "cru" após a aplicação.

**33 — Desativar Aero Peek**
Remove o efeito de visualização rápida de área de trabalho ao passar o mouse sobre o canto da barra de tarefas (`EnableAeroPeek = 0` em `HKCU\Software\Microsoft\Windows\DWM`).

---

### Privacidade e telemetria

**3 — Tweaks de Privacidade**
Conjunto de ajustes: define `AllowTelemetry = 0` em `HKLM\SOFTWARE\Policies`, zera o contador de feedbacks SIUF, desabilita a tarefa agendada do CEIP (Customer Experience Improvement Program), para e desativa os serviços `DiagTrack` e `dmwappushservice`, e desativa recomendações na tela inicial.

**4 — Desativar Telemetria**
Foco específico em `AllowTelemetry = 0` e `DisableWindowsAdvertising = 1` nas políticas de grupo via registro.

**16 — Bloquear Feedback Automático**
Zera `NumberOfSIUFInPeriod` em `HKCU\Software\Microsoft\Siuf\Rules`, impedindo que o Windows solicite avaliações periódicas.

---

### Debloat — remoção de apps

**5 — Desativar Xbox**
Oferece duas sub-opções:
- **Remover**: para e desativa os quatro serviços Xbox (`XblAuthManager`, `XblGameSave`, `XboxGipSvc`, `XboxNetApiSvc`) via `sc config start= disabled` e remove os pacotes UWP `*xboxapp*` e `*Microsoft.XboxGamingOverlay*` com `Remove-AppxPackage`.
- **Restaurar**: reconfigura os quatro serviços para `start= demand`.

**13 — Debloater**
Remove via PowerShell os pacotes UWP `*officehub*`, `*maps*` e `*news*`, e oculta o botão do Copilot na barra de tarefas (`ShowCopilotButton = 0`).

**15 — Desativar Cortana (Política)**
Adiciona `AllowCortana = 0` em `HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search`, bloqueando o serviço via política de grupo.

**21 — Remover App Cortana**
Remove o pacote UWP `Microsoft.549981C3F5F10` (a versão standalone da Cortana para Windows 11) com `Remove-AppxPackage`.

**31 — Desativar Maps Manager**
Define `Start = 4` (desabilitado) no serviço `MapsBroker` via registro, impedindo sincronização em segundo plano de mapas offline.

---

### Explorer e interface

**7 — Otimizar ALT+TAB**
Define `AltTabSettings = 1` em `HKCU\...\Explorer`, revertendo para o comportamento clássico de ALT+TAB (sem preview de janelas). Reinicia o `explorer.exe` automaticamente para aplicar.

**11 — Otimizar Explorer**
Define `LaunchTo = 1` (abre "Este Computador" em vez de Acesso Rápido), apaga as entradas de `TypedPaths` (histórico de caminhos digitados na barra) e desativa arquivos recentes (`ShowRecent = 0`). Reinicia o `explorer.exe`.

**20 — Resetar Cache de Miniaturas**
Encerra o Explorer, exclui todos os arquivos `iconcache*` e `thumbcache*` de `%LocalAppData%\Microsoft\Windows\Explorer\` e reinicia o processo. O cache é reconstruído automaticamente na próxima navegação.

**23 e 24 — Fechar/Iniciar Explorer**
Encerra ou inicia o `explorer.exe` manualmente, útil durante troubleshooting ou após tweaks que exigem reinício do shell.

**34 — Reiniciar PC**
Executa `shutdown /r /t 5` com mensagem de aviso. Inclui pausa para cancelamento com Ctrl+C antes de confirmar.

---

### Rede

**19 — Otimizar Rede para Jogos**
Configura o stack TCP via `netsh`:
- `autotuninglevel=normal` — permite ajuste automático do buffer de recebimento
- `rss=enabled` — ativa Receive Side Scaling para distribuir processamento entre núcleos
- `chimney=disabled` — desativa TCP Chimney Offload (pode causar instabilidade em alguns drivers)

**28 — Limpar Cache de Rede**
Executa `ipconfig /flushdns`, `netsh winsock reset` e `netsh int ip reset` — equivalente a uma limpeza completa do stack de rede sem precisar reinstalar drivers.

---

### Manutenção do sistema

**6 — Desativar Relatórios de Erro**
Para o serviço `WerSvc` e define `DisableWindowsErrorReporting = 1` via política, impedindo envio de dumps para a Microsoft e reduzindo interrupções de popup após crashes.

**8 — Desativar Sincronização de Relógio**
Para e desativa o serviço `w32time` e remove o valor `useplatformclock` do BCD. **Ação de risco**: sem sincronização NTP, a hora do sistema pode derivar. Requer confirmação dupla.

**9 — Desativar Serviços Inúteis**
Para e desativa `Spooler` (impressão), `wisvc` (Windows Insider) e `WbioSrvc` (biometria). Exige confirmação, pois impressoras e leitores de digital param de funcionar.

**10 — Desativar Hibernação**
Executa `powercfg -h off`, removendo o arquivo `hiberfil.sys` do disco e liberando espaço equivalente ao tamanho da RAM instalada.

**12 — Desativar Indexação**
Para o serviço `WSearch` e define `start= disabled`. Reduz uso de disco em segundo plano, mas a busca do Explorer passa a ser mais lenta para arquivos não indexados.

**14 — Desativar Notificações**
Define `ToastEnabled = 0` em `HKCU\...\PushNotifications`, desabilitando notificações toast globalmente.

**18 — Desativar Overlay do Xbox Game Bar**
Define `AllowAutoGameMode = 0` e `ShowStartupPanel = 0` em `HKCU\Software\Microsoft\GameBar`, desativando o painel de Game Bar e o modo de jogo automático.

**22 — Desativar Prefetch e Superfetch**
Para o serviço `SysMain` (Superfetch) e define `EnablePrefetcher = 0` no registro. Em SSDs, o prefetch é geralmente desnecessário e pode causar writes extras.

**26 — Desativar Hyper-V**
Executa `dism /Online /Disable-Feature:Microsoft-Hyper-V-All` e `bcdedit /set hypervisorlaunchtype off`. Afeta WSL2, Docker Desktop e qualquer VM baseada em Hyper-V. Requer reinicialização.

**27 — Verificar/Reparar Arquivos do Sistema**
Executa `sfc /scannow` seguido de `dism /online /cleanup-image /restorehealth`. O processo pode levar vários minutos. Não interrompa enquanto estiver em execução.

**29 — Limpar Arquivos Temporários**
Exclui agressivamente o conteúdo de `%TEMP%` e `%WINDIR%\Temp` com `/f /q`, e abre o `cleanmgr.exe` para limpeza adicional guiada. Arquivos em uso por outros processos são ignorados.

**30 — Exclusão do Windows Defender**
Adiciona um caminho de pasta às exclusões do Defender via `Add-MpPreference -ExclusionPath`. Solicita o caminho ao usuário, valida o formato (`[letra]:\`) e pede confirmação antes de aplicar. Útil para pastas de jogos que disparam falsos positivos.

**32 — Desativar TimeStamp NTFS**
Define `NtfsDisableLastAccessUpdate = 1` em `HKCU\SYSTEM\CurrentControlSet\Control\FileSystem`. Impede que o NTFS atualize o timestamp de último acesso em cada leitura de arquivo, reduzindo writes desnecessários — especialmente relevante em HDDs com muitos arquivos pequenos.

---

### Opções de risco elevado

**17 — Desativar SmartScreen**
Define `SmartScreenEnabled = Off` em `HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer`. Remove a verificação de reputação de arquivos baixados. Requer confirmação — reduz proteção contra malware.

**25 — Desativar UAC**
Define `EnableLUA = 0` em `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`. O sistema para de solicitar elevação de privilégio para qualquer processo. Requer reinicialização e confirmação explícita. Risco crítico em ambientes compartilhados ou conectados à internet.

---

## Otimizações de Jogos

Aplica alta prioridade de CPU a executáveis específicos de jogos via `Image File Execution Options` (IFEO) no registro, definindo `CpuPriorityClass = 3` (Alta) em `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\[executável]\PerfOptions`.

Diferente de ferramentas que alteram prioridade em tempo real via `SetPriorityClass`, essa abordagem persiste entre sessões — o Windows aplica a prioridade automaticamente toda vez que o processo é iniciado, sem nenhum software rodando em segundo plano.

O script também verifica se o processo está em execução no momento (`tasklist | find`) e exibe um aviso informativo caso não esteja — mas a entrada de registro é criada de qualquer forma.

### Jogos suportados

| Opção | Jogo | Executável(is) |
|-------|------|----------------|
| 1 | Fortnite | `FortniteClient-Win64-Shipping.exe` |
| 2 | GTA V | `GTA5.exe` |
| 3 | FiveM | `FiveM_b2372_GTAProcess.exe` |
| 4 | CS2 | `cs2.exe` |
| 5 | Minecraft (Java) | `javaw.exe` |
| 6 | Valorant | `VALORANT-Win64-Shipping.exe` |
| 7 | League of Legends | `LeagueClient.exe` |
| 8 | Warzone | `cod.exe` |
| 9 | Apex Legends | `r5apex.exe` |
| 10 | Roblox | `RobloxPlayerBeta.exe` |
| 11 | God of War (1 e Ragnarök) | `GoW.exe` + `GoWRagnarok.exe` |
| 12 | MTA San Andreas | `Multi Theft Auto.exe` + `gta_sa.exe` |
| 13 | Euro Truck Simulator (1 e 2) | `eurotrucks.exe` + `ets2.exe` |
| 14 | Rainbow Six Siege | `RainbowSix.exe` |
| 15 | Cult of the Lamb | `CultOfTheLamb.exe` |
| 16 | ULTRAKILL | `ULTRAKILL.exe` |
| 17 | Blood Strike | `BloodStrike.exe` |
| 18 | Arena Breakout | `ArenaBreakout.exe` |
| 19 | Resident Evil 4 Remake | `re4.exe` |
| 20 | Resident Evil 2 Remake | `re2.exe` |
| 21 | Resident Evil Village | `re8.exe` |
| 22 | Free Fire | `HD-Player.exe` |
| 23 | Battlefield 2042 | `BF2042.exe` |
| 24 | Battlefield 4 | `bf4.exe` |
| 25 | The Last of Us (1 e 2) | `tlou-i.exe` + `tlou-ii.exe` |
| 26 | PUBG | `tslgame.exe` |
| 27 | Rocket League | `RocketLeague.exe` |
| 28 | Cyberpunk 2077 | `Cyberpunk2077.exe` |
| 29 | Terraria | `Terraria.exe` |
| 30 | Red Dead Redemption 2 | `RDR2.exe` |

A opção **32 — Reverter Todos** percorre todos os executáveis acima e remove as entradas IFEO correspondentes via `reg delete`, restaurando o comportamento padrão de prioridade do Windows.

---

## Otimizações de Periféricos

**1 — Otimizar HDD**
Define `disableLastAccess = 2` (desativa atualização de timestamp de acesso via fsutil) e `disable8dot3 = 0` (mantém nomes curtos 8.3 para compatibilidade com software legado). Recomendado para HDDs mecânicos.

**2 — Otimizar SSD**
Desabilita a tarefa agendada de desfragmentação (`\Microsoft\Windows\Defrag\ScheduledDefrag`), define `disableLastAccess = 0` e `disable8dot3 = 1`. Desfragmentar SSDs é desnecessário e degrada o dispositivo ao longo do tempo.

**3 — Verificar Temperatura**
Abre o `OpenHardwareMonitor.exe` da pasta `tools/`. Exibe temperatura de CPU, GPU, drives e outros sensores em tempo real.

**4 — Otimizar Teclado**
Define `KeyboardDelay = 0` (sem atraso antes de começar a repetição de tecla) e `KeyboardSpeed = 31` (taxa máxima de repetição) em `HKCU\Control Panel\Keyboard`. Se o `FilterKeysSetter.exe` estiver presente, também é aberto para configurações adicionais.

**5 — Otimizar Mouse**
Define `MouseSpeed = 0` e `MouseThreshold1 = 0` em `HKCU\Control Panel\Mouse`, desativando a aceleração de ponteiro do Windows. O cursor passa a se mover de forma linear proporcional ao movimento físico do mouse, sem interpolação de velocidade — comportamento preferido em jogos competitivos. Aplica com `UpdatePerUserSystemParameters`.

**6 — Reverter Otimizações**
Restaura `MouseSpeed = 1` (aceleração padrão) e `KeyboardDelay = 1`, e reverte o `disableLastAccess = 1` no fsutil.

---

## Otimizações Avançadas de FPS

Submenu dedicado a tweaks de baixo nível que afetam latência de entrada, agendamento de CPU/GPU e comportamento de rede. Cada opção inclui aviso sobre impacto e requer confirmação nas de maior risco.

**1 — Modo de Jogo + Desativar Game DVR**
Ativa `AutoGameModeEnabled = 1` no GameBar e define `GameDVR_Enabled = 0` e `GameDVR_FSEBehavior = 2` no GameConfigStore, além de bloquear o DVR via política (`AllowGameDVR = 0`). O Game DVR mantém um buffer de vídeo constante em segundo plano — desativá-lo libera GPU e CPU.

**2 — GPU Scheduling por Hardware (HAGS)**
Define `HwSchMode = 2` em `HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers`. Transfere o agendamento de frames da CPU para a GPU, reduzindo latência em GPUs e drivers compatíveis (NVIDIA 451.48+ / AMD equivalente). Requer reinicialização.

**3 — Prioridade de CPU para Jogos**
Define `Win32PrioritySeparation = 38` em `HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl`. O valor 38 (0x26) configura quantum de CPU curto e variável com prioridade máxima para o processo em foreground — diferente do padrão 2, que equilibra entre foreground e background.

**4 — MMCSS (Agendador Multimídia)**
Configura a entrada `Games` no MMCSS (`Multimedia Class Scheduler Service`) com `GPU Priority = 8`, `Priority = 6`, `Scheduling Category = High` e `SFIO Priority = High`. O MMCSS garante que threads de jogos recebam tempo de CPU de forma mais determinística, reduzindo microstutters causados por preempção.

**5 — Desativar Power Throttling**
Define `PowerThrottlingOff = 1` em `HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling`. Impede que o Windows reduza a frequência de processos em segundo plano considerados "não urgentes" — útil quando serviços auxiliares do jogo (como launchers e anti-cheats) são afetados.

**6 — Desativar Algoritmo de Nagle**
Itera por todas as interfaces de rede em `HKLM\SYSTEM\...\Tcpip\Parameters\Interfaces` e define `TcpAckFrequency = 1` e `TCPNoDelay = 1`. O algoritmo de Nagle agrupa pacotes TCP pequenos antes de enviar, introduzindo latência de até 200ms em conexões com dados esparsos — comum em jogos online.

**7 — Reduzir Fila do Mouse**
Define `MouseDataQueueSize = 20` em `HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters`. O padrão é 100 entradas. Reduzir o buffer significa que o sistema processa eventos de mouse mais frequentemente, diminuindo o input lag em mouses de alta taxa de reporte (1000Hz+). Requer reinicialização.

**8 — Desativar VBS e Core Isolation**
Define `EnableVirtualizationBasedSecurity = 0` em `DeviceGuard`, desativa `HypervisorEnforcedCodeIntegrity` e zera `LsaCfgFlags`. A Virtualização Baseada em Segurança cria uma camada de isolamento de kernel que, em jogos, pode custar de 5% a 15% de performance dependendo do título. **Risco alto**: remove proteções contra exploits de kernel. Requer reinicialização.

**9 — Reverter Todos os Tweaks de FPS**
Reverte individualmente cada uma das 8 opções acima para os valores padrão do Windows, incluindo remoção das entradas MMCSS e restauração do Nagle via PowerShell.

---

## Tweaks Profundos

Seção com ajustes que tocam em comportamentos fundamentais do kernel e do bootloader. Cada opção exibe uma explicação do que faz, o risco envolvido e pede confirmação antes de executar.

**1 — Desativar Core Parking**
Define `CPMINCORES = 100` no plano de energia atual via `powercfg`. Por padrão, o Windows "estaciona" (desativa temporariamente) núcleos ociosos para economizar energia. Manter todos os núcleos ativos elimina a latência de "acordar" um núcleo quando uma thread é escalonada para ele — relevante em jogos que criam threads rapidamente. Custo: maior consumo de energia e temperatura.

**2 — Desativar Dynamic Tick**
Executa `bcdedit /set disabledynamictick yes`. O Dynamic Tick permite que o timer de interrupção do sistema entre em repouso durante períodos ociosos. Desativá-lo força o timer a disparar em frequência constante, o que pode reduzir microstutters em cargas de trabalho sensíveis a latência. Requer reinicialização. Custo: maior consumo em idle.

**3 — Desativar HPET**
Executa `bcdedit /set useplatformclock false`. Força o Windows a usar o TSC (Time Stamp Counter) da CPU em vez do HPET (High Precision Event Timer) para sincronização interna. Em hardware moderno, o TSC é mais preciso e de menor latência. Em hardware antigo ou instável, pode causar problemas de sincronização ou BSOD. Requer reinicialização. Recomenda-se criar ponto de restauração antes.

**4 — Pagefile Fixo Otimizado**
Calcula 1.5× a RAM física instalada via `Get-CimInstance Win32_ComputerSystem`, desativa o gerenciamento automático do pagefile (`AutomaticManagedPagefile = false`) e define tamanho inicial e máximo iguais. Um pagefile com tamanho fixo elimina o redimensionamento dinâmico, que causa stutter ao expandir durante uso. Recomendado para sistemas com 16 GB+ de RAM. Requer reinicialização.

**5 — Desativar Mitigações Spectre/Meltdown**
Define `FeatureSettingsOverride = 3` e `FeatureSettingsOverrideMask = 3` em `HKLM\SYSTEM\...\Memory Management`. Remove as mitigações de execução especulativa introduzidas após a divulgação das vulnerabilidades Spectre/Meltdown em 2018. Em alguns workloads, essas mitigações custam de 2% a 30% de performance. **Risco extremo**: o sistema fica vulnerável a ataques de canal lateral que podem vazar dados de memória entre processos. Recomendado apenas em máquinas isoladas, dedicadas exclusivamente a jogos, sem acesso a dados sensíveis.

**6 — Reverter Todos os Tweaks Profundos**
Reverte Core Parking para 5% (padrão), remove os valores de BCD `disabledynamictick` e `useplatformclock`, reativa o gerenciamento automático de pagefile e remove os overrides de Spectre/Meltdown.

---

## Kit Pós-Formatação

Instala conjuntos de aplicativos via `winget install` com a flag `-e` (correspondência exata de ID). Útil para configurar rapidamente uma máquina após uma instalação limpa do Windows.

**Kit DEV/Engenharia**

Instala: Visual Studio Code (`Microsoft.VisualStudioCode`), Git (`Git.Git`), Python 3.11 (`Python.Python.3.11`) e Node.js LTS (`OpenJS.NodeJS`).

**Kit Essencial**

Instala: Google Chrome (`Google.Chrome`), Discord (`Discord.Discord`) e Spotify (`Spotify.Spotify`).

O Winget vem instalado por padrão no Windows 11 e em versões recentes do Windows 10. Em instalações muito antigas ou LTSC, pode ser necessário instalá-lo manualmente via Microsoft Store ou GitHub.

---

## Ferramentas Utilitárias

Além dos submenus de tweaks, o menu principal oferece três funções de uso rápido:

**Criar Ponto de Restauração (opção 1)**
Inicia o serviço VSS (`Volume Shadow Copy`), habilita a proteção do sistema no drive C:, zera o `SystemRestorePointCreationFrequency` (que por padrão impede criação de múltiplos pontos em menos de 24h) e executa `Checkpoint-Computer` via PowerShell com descrição `RestorePoint by Project Prometheus`. Exibe mensagem de sucesso ou erro dependendo do retorno do comando.

**Liberar Memória RAM (opção 8)**
Abre o `RAMMap.exe` com os flags `-Ew` (esvaziar working sets) e `-Es` (esvaziar stand-by list). Força o Windows a liberar memória que está reservada mas não está sendo ativamente usada, devolvendo-a ao pool disponível.

**Melhorar Conexão/Ping (opção 9)**
Executa `ipconfig /flushdns`, `/release` e `/renew` para limpar e renovar a configuração de rede, e em seguida abre o `DnsJumper.exe` para trocar o servidor DNS para opções mais rápidas (Cloudflare, Google, etc.).

---

## Ferramentas Externas

Nenhuma ferramenta de terceiros é distribuída neste repositório. Todas são opcionais — o script verifica a presença de cada `.exe` antes de tentar usá-lo e exibe um erro claro caso esteja ausente, sem travar ou gerar comportamento inesperado.

Baixe cada ferramenta da fonte oficial e coloque na pasta `tools/` (ou na raiz do script, dependendo da referência no código):

| Ferramenta | Fonte oficial | Uso no script |
|------------|--------------|---------------|
| `DnsJumper.exe` | [sordum.org/7952](https://www.sordum.org/7952/) | Trocar e testar servidores DNS (opção 9) |
| `RAMMap.exe` | [Sysinternals](https://learn.microsoft.com/sysinternals/downloads/rammap) | Limpeza de cache de RAM (opção 8) |
| `Autoruns.exe` | [Sysinternals](https://learn.microsoft.com/sysinternals/downloads/autoruns) | Gerenciar programas de inicialização (opção 5) |
| `OpenHardwareMonitor.exe` | [openhardwaremonitor.org](https://openhardwaremonitor.org/) | Monitor de temperatura (opções 6 e Periféricos 3) |
| `FilterKeysSetter.exe` | — | Configuração avançada de teclado (Periféricos 4) |

---

## Sistema de Backup e Logs

### Logs

A cada execução do script, é criada a pasta `Logs/` na raiz (se não existir) e um arquivo de log com o formato:

```
Logs\WinBooster_YYYY-MM-DD_HH-mm-ss.log
```

O timestamp é gerado via PowerShell (`Get-Date -Format yyyy-MM-dd_HH-mm-ss`) com fallback para `date /t` e `time /t` caso o PowerShell não esteja disponível. Cada ação relevante é registrada no formato:

```
[DD/MM/YYYY HH:MM:SS] Descrição da ação
```

### Backups de Registro

Antes de modificar qualquer chave crítica de registro, o script chama a função `:BackupReg`, que:

1. Verifica se a chave existe com `reg query`
2. Exporta a chave completa para `Backups\[nome]_[timestamp].reg` com `reg export /y`
3. Confirma a criação do arquivo e exibe o caminho no terminal

O nome do arquivo de backup é composto pelo identificador da feature (ex: `win_uac`, `fps_hags`, `teclado`) e pelo timestamp da sessão, facilitando a identificação do que cada `.reg` reverte.

Se a chave ainda não existe no sistema (primeira vez que a otimização é aplicada), o backup é ignorado com uma mensagem informativa.

---

## Segurança

O script foi projetado para ser auditável e reversível por padrão.

**O que o script faz:**
- Executa apenas comandos nativos do Windows: `reg`, `sc`, `netsh`, `powercfg`, `bcdedit`, `sfc`, `dism`, `taskkill`, `powershell -Command` (inline), `winget`
- Toda modificação crítica de registro é precedida de backup
- Operações de risco exibem aviso detalhado e exigem confirmação `S/N`
- O modo simulação permite inspecionar todos os comandos sem executá-los

**O que o script não faz:**
- Não baixa arquivos da internet
- Não executa código remoto ou referencia URLs externas
- Não usa `Invoke-WebRequest`, `DownloadFile`, `Start-BitsTransfer` ou qualquer mecanismo de download via PowerShell
- Não modifica o arquivo `hosts`, regras de firewall ou rotas de rede
- Não instala serviços, drivers ou software próprio
- Não agenda tarefas recorrentes

Em ambiente corporativo, consulte o administrador de sistemas antes de usar — especialmente as opções que desativam UAC, SmartScreen, Hyper-V, serviços de impressão ou mitigações de segurança.

---

## Arquitetura Interna

```
WinBoosterV3.bat
├── Bloco de elevação (VBScript temporário → runas)
├── Configuração de ambiente
│   ├── chcp 65001 (UTF-8)
│   ├── Geração de ESC para cores ANSI
│   ├── Definição de variáveis de cor (w, y, o, b, q, r, g)
│   └── Criação de Logs/ e Backups/ + abertura do log da sessão
│
├── :menu — Menu principal (opções 1–13)
│   ├── :opcao_restauracao    — VSS + Checkpoint-Computer
│   ├── :menuwindows          — 34 sub-opções de tweaks de Windows
│   ├── :prioridadegames      — IFEO por executável (~30 jogos)
│   │   └── :revert_all_games — Remove todas as entradas IFEO
│   ├── :perifericos          — Mouse, teclado, HDD, SSD, temperatura
│   ├── :autorun              — Abre Autoruns.exe
│   ├── :tempera              — Abre OpenHardwareMonitor.exe
│   ├── :posformatacao        — Winget kits DEV e Essencial
│   ├── :limparram            — RAMMap -Ew -Es
│   ├── :ping                 — Flush DNS + DnsJumper.exe
│   ├── :toggle_simulate      — Alterna SIMULATE entre 0 e 1
│   ├── :fpsavancado          — 8 tweaks de FPS + reverter
│   ├── :tweaksprofundos      — 5 tweaks de kernel/BCD + reverter
│   └── :sair                 — Log de encerramento + exit
│
└── Funções auxiliares
    ├── :PrintHeader [título]          — cls + cabeçalho com borda ANSI
    ├── :LogAction [descrição]         — Append no .log da sessão
    ├── :BackupReg [chave] [nome]      — reg export para Backups/
    ├── :CheckTool [executável]        — Valida existência, retorna errorlevel 0/1
    ├── :SetGamePriority [exe]         — reg add IFEO CpuPriorityClass=3
    └── :RevertGamePriority [exe]      — reg delete IFEO
```

Cada label de ação segue o padrão:
1. `call :PrintHeader` — exibe o título da seção
2. `call :BackupReg` (quando aplicável)
3. `call :LogAction` — registra no log
4. Verificação do modo simulação (`if "!SIMULATE!"=="1"`)
5. Execução dos comandos
6. Exibição do status (`[OK]` em verde ou `[ERRO]` em vermelho)
7. `pause` + retorno ao menu

---

## Estrutura do Repositório

```
WinBoosterV3.bat              — Script principal
tools/
│   .gitkeep
│   DnsJumper.exe             — baixe da fonte oficial (não incluído)
│   RAMMap.exe                — baixe da Sysinternals (não incluído)
│   Autoruns.exe              — baixe da Sysinternals (não incluído)
│   OpenHardwareMonitor.exe   — baixe do site oficial (não incluído)
│   FilterKeysSetter.exe      — (não incluído)
Logs/                         — criado automaticamente na primeira execução
│   WinBooster_2025-01-01_14-30-00.log
Backups/                      — criado automaticamente na primeira execução
│   win_uac_2025-01-01_14-30-00.reg
│   fps_hags_2025-01-01_14-30-00.reg
docs/
│   windows-tweaks.md
│   games-priority.md
│   peripherals.md
│   external-tools.md
│   architecture.md
screenshots/
│   menu-principal.png
│   menu-windows.png
│   menu-gaming.png
LICENSE
CHANGELOG.md
```

---

## Compatibilidade

| Sistema | Status |
|---------|--------|
| Windows 11 23H2 / 24H2 | Testado |
| Windows 10 22H2 | Testado |
| Windows 10 LTSC | Parcial — alguns pacotes UWP podem não existir |
| Windows 7 / 8 / 8.1 | Não suportado |

**Requisitos mínimos:**
- PowerShell 5.1 ou superior (incluso no Windows 10/11)
- Conta com privilégios de Administrador
- CMD com suporte a cores ANSI (Windows 10 1511+ por padrão)

Algumas otimizações dependem de hardware específico (HAGS requer GPU/driver compatível, Dynamic Tick afeta diferentemente CPUs Intel e AMD). O comportamento pode variar entre configurações de hardware, versão de driver e edição do Windows.

---

## Aviso Legal

Este script modifica configurações do registro do Windows, serviços do sistema e parâmetros do bootloader. O autor não se responsabiliza por instabilidade, perda de dados ou qualquer outro problema causado pelo uso incorreto ou sem os devidos cuidados.

Backups de registro são gerados automaticamente antes de modificações críticas, e a opção de criar ponto de restauração está disponível no menu principal. Leia os avisos exibidos pelo script antes de confirmar qualquer operação de risco.

---

## Licença

Licenciado sob [MIT](LICENSE). Veja [`CHANGELOG.md`](CHANGELOG.md) para o histórico de versões.

---

*Project Prometheus — WinBooster V3*
