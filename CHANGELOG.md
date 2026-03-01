# Changelog

Todas as mudanças relevantes do WinBooster são documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).

---

## [V3.0] — 2025

### Adicionado
- Sistema de **backup de registro** automático antes de modificações críticas (`Backups/`)
- Sistema de **logs por execução** com timestamp (`Logs/`)
- **Modo simulação** (opção 10): exibe comandos sem executar nada
- **Confirmação manual** (`S/N`) para ações de risco: UAC, SmartScreen, Hyper-V, serviços, rede, Defender
- Função `:CheckTool` — valida existência de ferramentas externas antes de usar
- Função `:BackupReg` — exporta chave de registro com nome + data + hora
- Função `:LogAction` — escreve entrada no log da sessão
- Elevação de privilégio automática via VBScript (compatível com caminhos com espaço)
- Cabeçalho com gradiente ANSI RGB 24-bit via `:PrintHeader`

### Alterado
- Menu principal reorganizado: 11 opções em 2 colunas (formato original)
- Submenu Windows expandido para ~34 opções organizadas por categoria
- Menu de jogos expandido para ~30 jogos com opção de reverter todos
- Adicionada opção de reverter individualmente cada jogo (`:RevertGamePriority`)
- Avisos explícitos com texto descritivo antes de ações avançadas
- Todas as funções retornam ao menu de origem ao finalizar (sem saída silenciosa)

### Corrigido
- Line endings convertidos para CRLF (Windows) — resolve falha de abertura imediata em alguns sistemas
- `setlocal enabledelayedexpansion` movido para depois do `chcp 65001` — resolve expansão prematura no bloco de elevação
- Método de elevação substituído de PowerShell para VBScript — mais estável com caminhos especiais

---

## [V2.0] — versão anterior

- Menu interativo com cores ANSI
- ~30 opções de otimização de Windows
- Prioridade de CPU para jogos via IFEO
- Otimização de periféricos (mouse, teclado, HDD, SSD)
- Integração com ferramentas externas (DnsJumper, RAMMap, Autoruns, OpenHardwareMonitor)
- Kit pós-formatação via Winget
