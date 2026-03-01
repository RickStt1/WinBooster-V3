# 🪟 Windows Tweaks — Referência Completa

Lista completa das ~34 opções do submenu de otimização de Windows do WinBooster V3.

> ⚠️ Opções marcadas com **[AVANÇADO]** exigem confirmação manual e criam backup de registro antes de executar. Leia a descrição antes de aplicar.

---

## Tabela de Opções

| # | Nome | Descrição | Nível | Backup |
|---|------|-----------|-------|--------|
| 1 | **Otimizar Energia** | Ativa o plano Ultimate Performance e ajusta comportamento de ociosidade da CPU | Normal | ✅ |
| 2 | **Desativar Efeitos Visuais** | Remove animações, transparências e sombras de janelas para reduzir uso de GPU | Normal | ✅ |
| 3 | **Tweaks de Privacidade** | Desativa telemetria (DiagTrack), feedback automático (SIUF) e sugestões no menu Iniciar | Normal | ✅ |
| 4 | **Desativar Telemetria** | Bloqueia coleta de dados de uso e publicidade via política de grupo (HKLM) | Normal | ✅ |
| 5 | **Desativar Xbox** | Remove pacotes UWP e serviços do Xbox (inclui opção de restaurar) | Normal | — |
| 6 | **Desativar Relatórios de Erro** | Para o serviço WerSvc, que coleta e envia relatórios de falha de aplicativos | Normal | ✅ |
| 7 | **Otimizar ALT+TAB** | Usa o switcher clássico do Windows em vez da versão com thumbnails animadas | Normal | ✅ |
| 8 | **Tweaks de Timer/Clock** ⚠️ | Para o serviço W32Time e remove `useplatformclock` do BCD. **Pode afetar sincronização de hora e autenticação em alguns cenários.** Uso específico para gaming/benchmark. | **Avançado** | ✅ |
| 9 | **Desativar Serviços Seletivos** ⚠️ | Para Spooler (impressão), WbioSrvc (biometria) e wisvc (Insider). Use somente se não utilizar esses recursos. | **Avançado** | — |
| 10 | **Desativar Hibernação** | Remove o arquivo `hiberfil.sys` e desativa hibernação. Libera espaço em disco equivalente à RAM instalada. Desativa o Início Rápido. | Normal | — |
| 11 | **Otimizar Explorer** | Define abertura no "Este Computador", limpa histórico de caminhos digitados e desativa arquivos recentes | Normal | ✅ |
| 12 | **Desativar Indexação** | Para o serviço Windows Search (WSearch). Reduz uso de CPU/disco; busca no Explorer fica mais lenta | Normal | — |
| 13 | **Debloater** | Remove OfficHub, Maps, News e oculta o botão Copilot da barra de tarefas | Normal | — |
| 14 | **Desativar Notificações** | Bloqueia notificações toast para o usuário atual | Normal | ✅ |
| 15 | **Desativar Cortana** | Bloqueia Cortana via política de grupo (AllowCortana=0 em HKLM) | Normal | ✅ |
| 16 | **Bloquear Feedback Automático** | Zera o contador SIUF para impedir pop-ups de avaliação do Windows | Normal | ✅ |
| 17 | **SmartScreen (avançado)** ⚠️ | Desativa o filtro SmartScreen para arquivos baixados. **Reduz proteção contra executáveis desconhecidos. Recomendado manter habilitado na maioria dos casos.** Inclui confirmação e backup. | **Avançado** | ✅ |
| 18 | **Desativar Overlays** | Remove o painel automático do Xbox Game Bar ao iniciar jogos (AllowAutoGameMode=0) | Normal | ✅ |
| 19 | **Otimizar Rede** ⚠️ | Ajusta TCP AutoTuning, RSS e Chimney Offload. Pode melhorar latência em jogos, mas pode afetar conexões existentes. Exige confirmação. | **Avançado** | — |
| 20 | **Resetar Cache de Miniaturas** | Limpa `iconcache` e `thumbcache`. Reconstruídos automaticamente pelo Explorer | Normal | — |
| 21 | **Remover App Cortana** | Remove o pacote UWP da Cortana (Microsoft.549981C3F5F10). Diferente de só desativar via política | Normal | — |
| 22 | **Desativar Prefetch/Superfetch** | Para SysMain e zera EnablePrefetcher. Recomendado para SSDs; em HDDs pode piorar tempo de carga | Normal | ✅ |
| 23 | **Fechar Explorer** | `taskkill /f /im explorer.exe` — útil para aplicar configurações sem reiniciar | Utilitário | — |
| 24 | **Iniciar Explorer** | `start explorer.exe` — reinicia o Explorer após fechar | Utilitário | — |
| 25 | **UAC (avançado)** ⚠️ | Desativa o Controle de Conta de Usuário (EnableLUA=0). **Qualquer processo em execução terá privilégio total automaticamente. Não recomendado para uso geral.** Exige confirmação dupla e inclui backup. | **Avançado** | ✅ |
| 26 | **Hyper-V (avançado)** ⚠️ | Desativa o Hyper-V via DISM e configura o BCD (`hypervisorlaunchtype off`). Necessário para alguns anti-cheats, mas **remove suporte a WSL2, Docker Desktop e VMs**. | **Avançado** | — |
| 27 | **Verificar Integridade do Sistema** | Executa `sfc /scannow` + `DISM /restorehealth`. Verifica e repara arquivos protegidos do Windows | Normal | — |
| 28 | **Limpar Cache de Rede** | Flush DNS + reset Winsock + reset pilha IP. Corrige problemas de conectividade comuns | Normal | — |
| 29 | **Limpar Temporários** | Esvazia `%temp%` e `%windir%\temp`, abre limpeza de disco | Normal | — |
| 30 | **Exceção no Defender (uso específico)** ⚠️ | Adiciona uma pasta específica à lista de exclusão do Windows Defender. Útil para pastas de build, compilação ou jogos com falsos positivos. **Não recomendado em ambiente corporativo.** Exige confirmação e valida se a pasta existe. | **Avançado** | — |
| 31 | **Desativar Maps Manager** | Para o serviço MapsBroker (Gerenciador de Mapas Offline) — desnecessário se não usar o app Mapas | Normal | ✅ |
| 32 | **Desativar TimeStamp NTFS** | Desativa atualização de `Last Access Time` no NTFS (`NtfsDisableLastAccessUpdate=1`). Reduz escritas em disco, especialmente em SSDs | Normal | ✅ |
| 33 | **Desativar Aero Peek** | Remove o efeito de prévia ao passar o mouse no canto da barra de tarefas (EnableAeroPeek=0) | Normal | ✅ |
| 34 | **Reiniciar PC** | `shutdown /r /t 5` — reinicia em 5 segundos com aviso | Utilitário | — |

---

## Níveis de Risco

| Nível | Descrição |
|-------|-----------|
| **Normal** | Otimização comum, reversível via backup de registro |
| **Avançado** | Exige confirmação manual (`S/N`). Pode afetar funcionalidades do sistema. Leia a descrição antes de aplicar. |
| **Utilitário** | Ação pontual sem modificação permanente |

---

## Como reverter uma opção

Qualquer opção que cria backup (`✅` na coluna Backup):

1. Abra a pasta `Backups/` na raiz do script
2. Localize o arquivo `.reg` com o nome da opção + data/hora
3. Dê duplo clique → confirme a importação
4. Reinicie o Explorer ou o sistema se necessário

Para opções sem backup automático, use o **Ponto de Restauração do Sistema** (opção 1 do menu principal).
