# 🚀 WinBooster V3 — Project Prometheus

> Script `.bat` completo de otimização para Windows com foco em **performance**, **gaming** e **privacidade**.
<img width="732" height="243" alt="menu" src="https://github.com/user-attachments/assets/885ff2c7-fbc5-4112-8791-eff3c60da79f" />


---


## 📋 Sobre o Projeto

O **WinBooster V3** centraliza dezenas de otimizações do Windows em uma interface de menu interativa com cores ANSI e gradiente. Desenvolvido com foco em segurança: cria **backups de registro** antes de modificações críticas, registra todas as ações em **logs com data/hora**, e exige **confirmação manual** antes de ações de risco.

---

## ✨ Funcionalidades

### 🪟 Otimização de Windows — 34 opções
| # | Função | Descrição |
|---|--------|-----------|
| 1 | Otimizar Energia | Ativa o plano Ultimate Performance |
| 2 | Desativar Efeitos Visuais | Remove animações e transparências |
| 3 | Tweaks de Privacidade | Desativa telemetria, DiagTrack e sugestões |
| 4 | Desativar Telemetria | Bloqueia coleta de dados e publicidade |
| 5 | Desativar XBOX | Remove pacotes e serviços Xbox |
| 6 | Desativar Relatórios de Erro | Para o serviço WerSvc |
| 7 | Otimizar ALT+TAB | Usa o switcher clássico mais leve |
| 8 | Desativar Relógio Windows | Para w32time e ajusta BCD |
| 9 | Desativar Serviços Inúteis | Para Spooler, wisvc e WbioSrvc |
| 10 | Desativar Hibernação | `powercfg -h off` |
| 11 | Otimizar Explorer | Abre no "Este Computador", limpa histórico |
| 12 | Desativar Indexação | Para Windows Search (WSearch) |
| 13 | Debloater | Remove OfficHub, Maps, News e Copilot |
| 14 | Desativar Notificações | Bloqueia notificações toast |
| 15 | Desativar Cortana | Via política de grupo |
| 16 | Bloquear Feedback | Zera período de feedback automático |
| 17 | Desativar SmartScreen | ⚠️ Exige confirmação |
| 18 | Desativar Overlays | Remove overlay do Steam/Xbox GameBar |
| 19 | Otimizar Rede para Jogos | Ajusta TCP AutoTuning e RSS |
| 20 | Resetar Cache de Miniaturas | Limpa iconcache e thumbcache |
| 21 | Remover App Cortana | Remove pacote UWP da Cortana |
| 22 | Desativar Prefetch/Superfetch | Para SysMain e zera EnablePrefetcher |
| 23 | Fechar Explorer | `taskkill /f /im explorer.exe` |
| 24 | Iniciar Explorer | `start explorer.exe` |
| 25 | Desativar UAC | ⚠️ Exige confirmação dupla |
| 26 | Desativar Hyper-V | ⚠️ Afeta WSL2 e VMs |
| 27 | Verificar/Arrumar Arquivos | `sfc /scannow` + `DISM restorehealth` |
| 28 | Limpar Cache de Rede | flushdns + winsock reset + ip reset |
| 29 | Limpar Temporários | Esvazia %temp% e %windir%\temp |
| 30 | Exclusão Defender | Adiciona pasta à whitelist do Defender |
| 31 | Desativar Maps Manager | Para o serviço MapsBroker |
| 32 | Desativar TimeStamp | Desativa atualização de último acesso NTFS |
| 33 | Desativar Aero Peek | Remove efeito de prévia da barra de tarefas |
| 34 | Reiniciar PC | `shutdown /r /t 5` |

### 🎮 Prioridade de Jogos — 30 jogos suportados
Aplica alta prioridade de CPU via registro do Windows (`IFEO\PerfOptions\CpuPriorityClass = 3`) para os principais jogos do mercado. Inclui opção de reverter todos de uma vez.

**Jogos suportados:** Fortnite, GTA V, FiveM, CS2, Minecraft, Valorant, LoL, Warzone, Apex, Roblox, God of War, MTA, Euro Truck, Rainbow Six, Cult of the Lamb, ULTRAKILL, Blood Strike, Arena Breakout, RE4/RE2/Village, Free Fire, Battlefield 2042/4, The Last of Us 1/2, PUBG, Rocket League, Cyberpunk 2077, Terraria, Red Dead 2.

### 🖱️ Otimização de Periféricos
- **HDD** — desativa last access, habilita nomes 8.3
- **SSD** — desativa desfragmentação agendada e last access
- **Teclado** — delay mínimo (0) e velocidade máxima (31)
- **Mouse** — remove aceleração (MouseSpeed=0, Threshold=0)
- **Reverter** — restaura configurações padrão de mouse e teclado

### 🛠️ Ferramentas Externas Integradas
| Ferramenta | Função |
|------------|--------|
| `DnsJumper.exe` | Troca e otimiza servidor DNS |
| `RAMMap.exe` | Limpeza profunda de cache de RAM |
| `Autoruns.exe` | Gerencia programas de inicialização |
| `OpenHardwareMonitor.exe` | Monitora temperatura de CPU/GPU |
| `FilterKeysSetter.exe` | Configuração avançada de teclado |

---

## 🔐 Segurança

| Recurso | Detalhe |
|---------|---------|
| **Backup de Registro** | Exporta chave original antes de modificar (`./Backups/`) |
| **Logs automáticos** | Registra ação + data/hora em `./Logs/` a cada execução |
| **Confirmação manual** | UAC, SmartScreen, Hyper-V, Serviços, Rede e Defender pedem `S/N` |
| **Modo Simulação** | Mostra o que faria sem executar nada (opção 10 do menu) |
| **CheckTool** | Verifica existência de executáveis externos antes de usar |

---

## 🗂️ Estrutura de Pastas

```
WinBooster.bat              ← Script principal
DnsJumper.exe               ← (opcional) Otimizador de DNS
RAMMap.exe                  ← (opcional) Limpeza de RAM
Autoruns.exe                ← (opcional) Gerenciar inicialização
OpenHardwareMonitor.exe     ← (opcional) Monitor de temperatura
FilterKeysSetter.exe        ← (opcional) Configuração de teclado
Logs/                       ← Criado automaticamente ao iniciar
│   WinBooster_2025-01-01_1430.log
Backups/                    ← Criado automaticamente ao iniciar
│   win_uac_2025-01-01_1430.reg
│   win_smartscreen_2025-01-01_1431.reg
```

---

## 🚦 Como Usar

### Método simples
1. **Clique com o botão direito** no `WinBooster.bat`
2. Selecione **"Executar como administrador"**
3. Navegue pelos menus digitando o número da opção

> O script solicita elevação automaticamente via VBScript se necessário.

### Modo Simulação (debug)
No menu principal, selecione a opção **10 — Modo Simulação** para ativar. Com ele ativo, o script exibe exatamente o que seria executado **sem fazer nenhuma alteração real**. Útil para estudar o script ou testar sem riscos.

### Restaurar um backup de registro
1. Abra a pasta `Backups/`
2. Dê duplo clique no arquivo `.reg` correspondente à ação que deseja reverter
3. Confirme a importação

---

## ⚙️ Requisitos

- **Windows 10 / 11**
- **PowerShell** (já incluso no Windows)
- **Privilégios de Administrador**
- Ferramentas externas são **opcionais** — o script verifica a existência antes de usar

---

## 🏗️ Arquitetura do Script

```
Inicialização
├── Elevação de privilégio (VBScript)
├── Encoding UTF-8 (chcp 65001)
├── Variáveis de cor ANSI
├── Criação de pastas Logs/ e Backups/
└── Menu Principal
    ├── :opcao_restauracao   → Ponto de restauração do sistema
    ├── :menuwindows         → 34 tweaks de Windows
    ├── :prioridadegames     → 30 jogos com prioridade de CPU
    ├── :perifericos         → HDD, SSD, mouse, teclado
    ├── :autorun             → Abre Autoruns.exe
    ├── :tempera             → Abre OpenHardwareMonitor.exe
    ├── :posformatacao       → Instala apps via Winget
    ├── :limparram           → Executa RAMMap.exe
    ├── :ping                → Flush DNS + DNSJumper
    └── :toggle_simulate     → Liga/desliga modo simulação

Funções reutilizáveis (labels auxiliares)
├── :PrintHeader    → Cabeçalho com gradiente RGB
├── :LogAction      → Grava ação no arquivo de log
├── :BackupReg      → Exporta chave de registro antes de modificar
├── :CheckTool      → Verifica existência de ferramenta externa
├── :SetGamePriority   → Aplica prioridade de CPU no registro IFEO
└── :RevertGamePriority → Remove prioridade do registro IFEO
```

---

## ⚠️ Aviso Legal

Este script realiza modificações no registro do Windows e em configurações do sistema. Use com responsabilidade. O autor não se responsabiliza por problemas causados pelo uso indevido. **Recomenda-se criar um Ponto de Restauração (opção 1) antes de aplicar otimizações.**

---

## 📜 Licença

Uso livre para fins pessoais e educacionais.

---

*Project Prometheus — WinBooster V3*
