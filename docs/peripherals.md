# 🖱️ Periféricos — Referência Completa

Detalhes das opções de otimização de mouse, teclado, HDD e SSD do WinBooster V3.

---

## Mouse

**O que faz:** remove a aceleração de ponteiro do Windows, resultando em movimento linear — a mesma distância física no mouse sempre resulta na mesma distância na tela, independente da velocidade.

| Registro | Valor aplicado | Padrão Windows | Efeito |
|----------|---------------|----------------|--------|
| `MouseSpeed` | `0` | `1` | Desativa aceleração |
| `MouseThreshold1` | `0` | `6` | Remove limiar de aceleração (baixa velocidade) |
| `MouseThreshold2` | `0` | `10` | Remove limiar de aceleração (alta velocidade) |

Após aplicar, o sistema chama `RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters` para recarregar as configurações imediatamente.

**Para reverter:** use a opção 6 (Reverter Otimizações) do menu de periféricos, ou importe o backup `.reg` gerado automaticamente.

> A aceleração desativada é preferência pessoal — especialmente útil para gaming de precisão. Para uso geral, o padrão do Windows pode ser mais confortável.

---

## Teclado

**O que faz:** reduz o delay antes da repetição de tecla e aumenta a velocidade de repetição.

| Registro | Valor aplicado | Padrão Windows | Efeito |
|----------|---------------|----------------|--------|
| `KeyboardDelay` | `0` | `1` | Delay mínimo antes de iniciar repetição (~250ms) |
| `KeyboardSpeed` | `31` | `31` | Velocidade de repetição máxima |

> Se `FilterKeysSetter.exe` estiver presente na pasta `tools/`, ele será aberto para configurações adicionais.

---

## SSD — Ajustes de Filesystem

> ⚠️ **Opção avançada.** Pode variar por tipo de drive e configuração. Use somente se souber o motivo.

**O que faz:**

| Comando | Efeito |
|---------|--------|
| `schtasks /Disable ScheduledDefrag` | Desativa a desfragmentação agendada. O Windows já gerencia TRIM automaticamente em SSDs — desfragmentar um SSD é desnecessário e gera desgaste adicional. |
| `fsutil behavior set disableLastAccess 0` | Desativa atualização de "Last Access Time" nos arquivos — reduz escritas desnecessárias. |
| `fsutil behavior set disable8dot3 1` | Desativa criação de nomes curtos 8.3 no filesystem — reduz overhead de manutenção. |

> O Windows 10/11 já desativa a desfragmentação em SSDs por padrão na maioria dos casos. Essa opção garante a configuração explicitamente.

---

## HDD — Ajustes de Filesystem

> ⚠️ **Opção avançada — compatibilidade.** Ajustes diferentes dos do SSD.

**O que faz:**

| Comando | Efeito |
|---------|--------|
| `fsutil behavior set disableLastAccess 2` | Desativa atualização de "Last Access Time" para todos os volumes. Reduz escritas desnecessárias em HDDs. |
| `fsutil behavior set disable8dot3 0` | Mantém nomes curtos 8.3 habilitados — necessário para compatibilidade com alguns programas mais antigos. |

> Diferente do SSD, em HDDs os nomes 8.3 são mantidos por compatibilidade. O valor `disableLastAccess = 2` (vs `0` no SSD) aplica o ajuste de forma mais abrangente.

---

## Reverter Periféricos

A opção **6 — Reverter Otimizações** do menu de periféricos restaura:

- `MouseSpeed` → `1`
- `KeyboardDelay` → `1`
- `fsutil disableLastAccess` → `1` (comportamento padrão)

Mouse e teclado também podem ser restaurados pelo backup `.reg` gerado automaticamente antes de cada modificação.
