# CHECKS — a lista de verificações do `doctor`

> 6 famílias. As marcadas 🤖 são feitas por `scripts/doctor.ps1` (mecânicas, sem julgamento).
> As marcadas 🧠 exigem leitura e julgamento — são feitas por você, o modelo.
>
> Severidade: 🔴 **quebrado** (corrija hoje) · 🟡 **deriva** (corrija esta semana) · 🔵 **oportunidade** (avalie).

---

## Família 1 — Integridade 🤖

| Check | Severidade |
|---|---|
| Todo arquivo declarado em `.harness/manifesto.json` existe no disco | 🔴 |
| Todo link `[...](...)` entre documentos aponta para arquivo existente | 🔴 |
| Todo plano citado em `INDICE.md` existe (em `Planos/` ou `Concluídos/`) | 🔴 |
| Todo plano em `Planos/` está listado no `INDICE.md` | 🟡 |
| Nenhum `NNNN` de plano está duplicado | 🔴 |
| `.claude/settings.json` é JSON válido | 🔴 |
| Os hooks referenciados no `settings.json` existem no disco | 🔴 |

---

## Família 2 — Deriva ⭐ 🤖 + 🧠

O harness diz uma coisa, a realidade diz outra. É o modo de falha mais comum e o mais silencioso.

| Check | Severidade |
|---|---|
| `INDICE.md` diverge dos arquivos reais em `Planos/` (status ou progresso) | 🟡 |
| Plano `🚧 Em andamento` sem alteração há mais de 30 dias | 🟡 |
| `ESTADO.md` mais velho que o último commit | 🟡 |
| Plano `✔️ Concluído` que ainda não foi movido para `Concluídos/` | 🟡 |
| 🧠 `SPEC.md` descreve arquitetura que não bate com o código no disco | 🔴 |
| 🧠 `AGENTS.md` cita comando que não existe mais | 🔴 |
| 🧠 Decisão registrada foi revertida no código sem virar decisão nova | 🟡 |

---

## Família 3 — Inchaço 🤖

| Check | Severidade |
|---|---|
| Documento estourou o teto de `criterios/ORCAMENTOS.md` | 🟡 |
| `DECISOES.md` passou de 15 decisões (hora de quebrar em arquivos) | 🟡 |
| Custo total por sessão passou do alerta do tier | 🟡 |
| 🧠 Dois documentos com parágrafos duplicados (viola fonte única) | 🟡 |

---

## Família 4 — Procedência ⭐⭐ 🧠

**A checagem que praticamente nenhum sistema faz.** Aplicação direta da Lei 1.

| Check | Severidade |
|---|---|
| Regra em `AGENTS.md` sem procedência registrada (que erro ela previne?) | 🔵 |
| Guarda/hook sem procedência | 🔵 |
| Regra genérica que qualquer modelo já sabe ("escreva código limpo", "use nomes claros") | 🟡 |
| Regra que contradiz outra regra do próprio harness | 🔴 |

> **Como julgar:** para cada regra, pergunte *"se eu apagar esta linha, que erro volta a acontecer?"*
> Se não souber responder com um caso concreto, é candidata a abate.

---

## Família 5 — Mecânica 🤖

| Check | Severidade |
|---|---|
| O projeto tem hooks configurados? (T2+) | 🟡 |
| Cada hook do `settings.json` roda sem erro de sintaxe | 🔴 |
| `.harness/log-guardas.jsonl` está sendo escrito (os hooks estão vivos) | 🟡 |
| Existe guarda que **nunca disparou em 90 dias** → propor abate (Lei 4) | 🔵 |
| Repositório é git? Working tree limpo? | 🔵 |

---

## Família 6 — Escada 🧠

Detecta se o projeto **cruzou um gatilho** de `criterios/TIERS.md` e ainda não subiu.

| Check | Severidade |
|---|---|
| T1 com 3+ arquivos de código ou 1º plano criado → propor T2 | 🔵 |
| T2 com dado sensível ou bug real registrado → propor T2+ (testes de regra) | 🔵 |
| T2+ multi-módulo, mais de uma pessoa, ou 15+ decisões → **registrar** que cruzou o gatilho de T3 ⚠️ (não prometer a subida: não existe template T3 — ver `criterios/TIERS.md`) | 🔵 |
| Versão da skill no `manifesto.json` é anterior à atual → sugerir `upgrade` | 🔵 |

---

## Formato do relatório

Sempre nesta ordem, e **sempre com o comando exato de correção**:

```
🩺 DOCTOR — <projeto>   ·   tier T2   ·   harness v1.0.0   ·   26/07/2026

🔴 QUEBRADO (2)
  • Planos/INDICE.md:19 aponta para plano 0003 que não existe
    → /harness fix

🟡 DERIVA (1)
  • AGENTS.md tem 134 linhas (teto 120)
    → /harness fix  (migra o excedente para docs/SPEC.md)

🔵 OPORTUNIDADE (2)
  • Guarda "bloquear-env" nunca disparou em 90 dias
    → /harness fix --limpar
  • Projeto cruzou o gatilho de T2+ (dado financeiro entrou)
    → /harness upgrade --tier 2+

📊 Custo do harness: ~2.700 tokens/sessão (alvo T2: 2.500)  ⚠️
✅ 34 checks passaram
```

**Se estiver tudo verde, diga em uma linha e pare.** Sucesso é silencioso — não liste os 34
checks que passaram só para parecer trabalhoso.
