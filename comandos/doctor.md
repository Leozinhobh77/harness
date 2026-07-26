# `doctor` — diagnosticar. **Nunca escrever.**

> Esta é a regra número um deste comando e não tem exceção: **o `doctor` não altera nenhum
> arquivo.** Nem para "corrigir uma coisinha". Nem um espaço em branco.
>
> É isso que faz o usuário poder rodar `doctor` a qualquer hora, sem medo, inclusive no meio de
> outro trabalho. No segundo em que ele começar a escrever, vira um comando perigoso e o usuário
> para de rodar.

## Fluxo

```
1. Ache o .harness/manifesto.json  →  sem ele, o projeto não tem harness (ofereça /harness init)
2. Rode scripts/doctor.ps1          →  todos os checks 🤖 mecânicos
3. Faça os checks 🧠 de julgamento  →  leia os documentos e o código
4. Some o custo de tokens do harness
5. Monte o relatório
```

Use `criterios/CHECKS.md` como lista completa. Use `criterios/ORCAMENTOS.md` para os limites.

## Os 2 checks que valem mais que todos os outros

### Deriva (Família 2)
O harness diz uma coisa, o disco diz outra. É o modo de falha mais comum e o mais silencioso —
ninguém percebe, e a IA passa meses trabalhando com um mapa errado.

Onde olhar com atenção:
- `SPEC.md` descreve arquitetura que não existe mais no código
- `AGENTS.md` cita comando que foi renomeado
- `INDICE.md` diz "Em andamento" num plano que foi entregue há um mês

### Procedência (Família 4)
Para **cada regra** do `AGENTS.md`, pergunte:

> *"Se eu apagar esta linha, que erro concreto volta a acontecer?"*

Não sabe responder com um caso real? É candidata a abate. Isso não é purismo — é a Lei 1, e
existe porque regra genérica **mede piora**, não neutralidade.

## Relatório

Formato exato em `criterios/CHECKS.md`. Três coisas inegociáveis:

1. **Ordem por severidade** 🔴 → 🟡 → 🔵
2. **Cada item traz o comando exato** que corrige (`/harness fix`, `/harness upgrade --tier 3`…)
3. **Sucesso é silencioso.** Tudo verde = uma linha e ponto final. Não liste os 34 checks que
   passaram para parecer que trabalhou.

## Modos

| Comando | O que faz |
|---|---|
| `/harness doctor` | tudo |
| `/harness doctor --rapido` | só os 🤖 mecânicos (segundos, sem leitura de documento) |
| `/harness doctor --skill` | roda o doctor **na própria skill** (usado pelo `evolve`) |

## No fim, sempre

Se achou 🔴 ou 🟡, feche com **uma linha**:

```
→ /harness fix  resolve 3 dos 4 itens. O último precisa de decisão sua.
```

Nunca conserte. Nunca ofereça "quer que eu já arrume?" e saia arrumando. O usuário chama o
`fix` quando quiser.
