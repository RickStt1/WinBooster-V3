# 🎮 Games — Prioridade de CPU

Lista de jogos suportados pelo WinBooster V3 para configuração de alta prioridade de CPU via registro do Windows.

---

## Como funciona

O WinBooster usa o mecanismo **IFEO** (Image File Execution Options) do Windows para definir `CpuPriorityClass = 3` (Alta Prioridade) para o executável do jogo **antes mesmo de ele ser iniciado**.

```
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\
  Image File Execution Options\<jogo.exe>\PerfOptions
    CpuPriorityClass = 3
```

Isso é feito via `reg add` — sem injeção de processo, sem DLL, sem código em execução em segundo plano.

**Valores de CpuPriorityClass:**
| Valor | Prioridade |
|-------|-----------|
| 1 | Idle (mínima) |
| 2 | Normal (padrão do Windows) |
| **3** | **Alta (aplicado pelo WinBooster)** |
| 4 | Realtime (não recomendado — pode travar o sistema) |

---

## Reverter

Use a opção **32 — Reverter Todos** no menu de jogos para remover as chaves IFEO de todos os jogos de uma vez.

Para reverter individualmente, basta excluir a chave:
```
HKLM\...\Image File Execution Options\<jogo.exe>\PerfOptions
```

---

## Jogos Suportados

| # | Jogo | Executável(is) |
|---|------|----------------|
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
| 11 | God of War (ambos) | `GoW.exe` + `GoWRagnarok.exe` |
| 12 | MTA | `Multi Theft Auto.exe` + `gta_sa.exe` |
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
| 25 | The Last of Us Part I | `tlou-i.exe` |
| 26 | PUBG | `tslgame.exe` |
| 27 | Rocket League | `RocketLeague.exe` |
| 28 | Cyberpunk 2077 | `Cyberpunk2077.exe` |
| 29 | Terraria | `Terraria.exe` |
| 30 | Red Dead Redemption 2 | `RDR2.exe` |

> **Nota sobre Minecraft:** o executável `javaw.exe` é compartilhado com outros processos Java. Aplicar prioridade alta pode afetar qualquer outro programa Java em execução.

---

## Adicionar um jogo não listado

Atualmente não há uma opção de entrada personalizada no menu. Para adicionar manualmente:

```cmd
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\seujogo.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f
```

Para reverter:

```cmd
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\seujogo.exe\PerfOptions" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\seujogo.exe" /f
```
