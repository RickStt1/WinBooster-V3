# 🚀 WinBooster V3

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%2F%2011-0078D6?style=flat&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen?style=flat)
![Language](https://img.shields.io/badge/Language-Batch%20Script-orange?style=flat)

> Script `.bat` de manutenção e otimização para Windows com foco em performance, gaming e privacidade — com backups automáticos, logs por execução e modo simulação.

> ⚠️ **Recomendado:** crie um ponto de restauração (opção 1 do menu) antes de aplicar qualquer otimização.

---

## ✅ Diferenciais

- 💾 **Backups por feature** — chave de registro exportada automaticamente antes de cada modificação crítica
- 📋 **Logs por execução** — cada sessão gera um arquivo de log com timestamp em `Logs/`
- 🧪 **Modo simulação** — exibe o que seria executado sem fazer nenhuma alteração real
- ✋ **Confirmação manual** — ações de risco exigem digitação explícita de `S` para prosseguir
- 🔍 **Ferramentas externas verificadas** — o script valida se o `.exe` existe antes de tentar usá-lo
- ↩️ **Reversível** — backups em `Backups/` + opção de ponto de restauração do sistema

---

## 📋 Sobre o Projeto

O **WinBooster V3** centraliza otimizações e tarefas de manutenção do Windows em uma interface de menu CLI com cores ANSI. Projetado para ser **reversível e auditável**: toda ação relevante é logada, chaves críticas de registro são exportadas antes de serem modificadas, e operações sensíveis exigem confirmação explícita.

Algumas opções são avançadas e o script sinaliza isso claramente — exibindo avisos e pedindo confirmação antes de executar.

---

## ✨ Funcionalidades

### 🪟 Windows — ~34 opções por categoria

| Categoria | O que inclui |
|-----------|-------------|
| **Energia & Visual** | Plano Ultimate Performance, desativar efeitos visuais e transparências |
| **Privacidade & Telemetria** | Bloquear DiagTrack, feedback automático e publicidade da Microsoft |
| **Debloat** | Remover Xbox, Cortana UWP, Office Hub, News, Maps, botão Copilot |
| **Explorer & UI** | Otimizar Explorer, ALT+TAB clássico, desativar Aero Peek, cache de miniaturas |
| **Rede** | Flush DNS, reset Winsock/IP, ajustes TCP para baixa latência |
| **Manutenção** | SFC + DISM, temporários, indexação, hibernação, prefetch/superfetch |
| **Avançado ⚠️** | UAC, SmartScreen, Hyper-V, timer do sistema, serviços seletivos |

> Lista completa com descrição de cada opção: [`docs/windows-tweaks.md`](docs/windows-tweaks.md)

---

### 🎮 Gaming — Prioridade de CPU por jogo (~30 jogos)

Aplica alta prioridade via `IFEO\PerfOptions\CpuPriorityClass` no registro — sem injeção de processo, sem DLL. Inclui opção de **reverter todos** de uma vez.

> Lista de jogos suportados e executáveis: [`docs/games-priority.md`](docs/games-priority.md)

---

### 🖱️ Periféricos

- **Mouse** — remove aceleração (movimento linear, sem interpolação de velocidade)
- **Teclado** — delay e repeat rate otimizados para resposta mais rápida
- **HDD / SSD** — ajustes de filesystem (opção avançada; veja [`docs/peripherals.md`](docs/peripherals.md))
- **Reverter** — restaura configurações padrão de mouse e teclado

---

### 🛠️ Ferramentas Externas (todas opcionais)

| Ferramenta | Fonte oficial | Função |
|------------|--------------|--------|
| `DnsJumper.exe` | [Sordum.org](https://www.sordum.org/7952/) | Trocar e testar servidores DNS |
| `RAMMap.exe` | [Sysinternals](https://learn.microsoft.com/sysinternals/downloads/rammap) | Limpeza de cache de RAM |
| `Autoruns.exe` | [Sysinternals](https://learn.microsoft.com/sysinternals/downloads/autoruns) | Gerenciar inicialização |
| `OpenHardwareMonitor.exe` | [openhardwaremonitor.org](https://openhardwaremonitor.org/) | Temperatura CPU/GPU |
| `FilterKeysSetter.exe` | — | Configuração avançada de teclado |

> Nenhuma ferramenta é distribuída neste repositório. Baixe de cada fonte oficial e coloque na pasta `tools/`. O script verifica se o arquivo existe antes de executar — se não encontrar, exibe erro e volta ao menu.

---

## 🔐 Segurança

- 💾 **Backups de registro** em `Backups/` antes de cada mudança crítica
- 📋 **Logs** em `Logs/` com data e hora de cada ação realizada
- ✋ **Confirmações explícitas** para: UAC, SmartScreen, Hyper-V, serviços, rede avançada e exclusões do Defender
- 🧪 **Modo simulação** — zero alterações reais, só exibe o que executaria
- 🔍 **CheckTool** — valida presença de ferramentas externas antes de usá-las

### O que este script NÃO faz

- ❌ Não baixa arquivos da internet
- ❌ Não executa nada remoto ou de fontes externas
- ❌ Não usa PowerShell com `DownloadFile`, `Invoke-WebRequest` ou similares
- ❌ Não modifica `hosts`, firewall ou rotas de rede
- ✅ Somente executa comandos locais nativos do Windows (`reg`, `sc`, `netsh`, `powercfg`, `bcdedit`, etc.)

> Em ambiente corporativo, consulte seu administrador antes de usar — especialmente as opções avançadas.

---

## 🗂️ Estrutura do Repositório

```
WinBoosterV3.bat              ← Script principal
tools/                        ← Coloque aqui as ferramentas externas (não incluídas)
│   .gitkeep
│   DnsJumper.exe             ← baixe da fonte oficial
│   RAMMap.exe                ← baixe da Sysinternals
│   Autoruns.exe              ← baixe da Sysinternals
│   OpenHardwareMonitor.exe   ← baixe do site oficial
Logs/                         ← Criado automaticamente ao iniciar
│   WinBooster_2025-01-01_1430.log
Backups/                      ← Criado automaticamente ao iniciar
│   win_uac_2025-01-01_1430.reg
docs/
│   windows-tweaks.md         ← Tabela completa das ~34 opções
│   games-priority.md         ← Lista de jogos e executáveis
│   peripherals.md            ← Detalhes de mouse/teclado/HDD/SSD
│   external-tools.md         ← Ferramentas, fontes e notas
│   architecture.md           ← Arquitetura interna do script
screenshots/
│   menu-principal.png
│   menu-windows.png
│   menu-gaming.png
LICENSE
CHANGELOG.md
```

---

## 🚦 Como Usar

> **Antes de qualquer coisa:** use a opção 1 do menu para criar um ponto de restauração do sistema.

### Via Explorer
1. Clique com o botão direito em `WinBoosterV3.bat`
2. Selecione **"Executar como administrador"**
3. Navegue pelos menus digitando o número da opção

> O script detecta automaticamente se está sem privilégios e solicita elevação via UAC.

### Via terminal (CMD como administrador)
```cmd
cd C:\caminho\para\WinBooster
WinBoosterV3.bat
```

### Modo Simulação
Selecione a opção **10** no menu principal para ativar/desativar.

Quando ativo:
- O cabeçalho exibe `[MODO SIMULAÇÃO ATIVO - Nenhuma alteração será feita]`
- Cada comando aparece prefixado com `[SIMULAÇÃO]` em vez de ser executado

### Restaurar um backup de registro
1. Abra a pasta `Backups/`
2. Dê duplo clique no `.reg` correspondente à ação que deseja reverter
3. Confirme a importação no prompt do Windows

---

## ⚙️ Compatibilidade

| Sistema | Status |
|---------|--------|
| Windows 11 (23H2 / 24H2) | ✅ Testado |
| Windows 10 (22H2) | ✅ Testado |
| Windows 10 LTSC | ⚠️ Parcial — alguns apps UWP podem não existir |
| Windows 7 / 8 | ❌ Não suportado |

**Requisitos:**
- PowerShell (já incluso no Windows 10/11)
- Privilégios de Administrador
- Ferramentas externas são todas opcionais

> Algumas otimizações podem variar por hardware, driver ou edição do Windows. Cada máquina é diferente — use o modo simulação para inspecionar antes de aplicar.

---

## 🏗️ Arquitetura (resumo)

```
WinBoosterV3.bat
├── Inicialização
│   ├── Elevação de privilégio (VBScript → runas)
│   ├── UTF-8 (chcp 65001) + cores ANSI
│   └── Criação de Logs/ e Backups/ + log da sessão
├── Menu Principal (11 opções)
│   ├── :opcao_restauracao   → Ponto de restauração
│   ├── :menuwindows         → ~34 tweaks de Windows
│   ├── :prioridadegames     → ~30 jogos
│   ├── :perifericos         → Mouse, teclado, HDD, SSD
│   ├── :autorun / :tempera  → Ferramentas externas
│   ├── :posformatacao       → Winget (kits DEV e Essencial)
│   ├── :limparram / :ping   → RAM e DNS
│   └── :toggle_simulate     → Modo simulação
└── Funções Auxiliares
    ├── :PrintHeader         → Cabeçalho com gradiente ANSI RGB
    ├── :LogAction           → Escreve no log da sessão
    ├── :BackupReg           → Exporta chave de registro (.reg)
    ├── :CheckTool           → Valida presença de executável externo
    ├── :SetGamePriority     → IFEO CpuPriorityClass = 3
    └── :RevertGamePriority  → Remove chave IFEO
```

> Diagrama e explicação detalhada: [`docs/architecture.md`](docs/architecture.md)

---

## ⚠️ Aviso Legal

Este script modifica configurações do registro e do sistema operacional. Cada máquina é diferente — algumas otimizações podem variar por hardware, driver ou edição do Windows. O autor não se responsabiliza por problemas causados pelo uso indevido.

**Backups de registro são criados automaticamente antes de mudanças críticas.** Recomenda-se também criar um ponto de restauração do sistema antes de aplicar qualquer otimização.

---

## 📜 Licença

Licenciado sob [MIT](LICENSE).

---

## 📝 Changelog

Veja [`CHANGELOG.md`](CHANGELOG.md) para o histórico de versões.

---

*Project Prometheus — WinBooster V3*
