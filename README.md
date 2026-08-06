# ⚙️ `/harness`

**Skill do [Claude Code](https://claude.com/claude-code) que cria, audita e evolui o esqueleto de
governança de um projeto — e aprende com cada erro real, para que ele não se repita.**

📖 **[Manual completo →](https://leozinhobh77.github.io/harness/)**

---

## O problema

Um harness (`AGENTS.md`, planos, decisões, guardas) é o que faz uma IA trabalhar bem num projeto.
A maioria é escrita à mão, cresce sem freio, e em alguns meses vira um documento que ninguém lê e
que custa token em toda sessão.

Pior: quase todo harness é **só pedido educado**. Nada impede a IA de fazer errado — só se pede
que ela não faça.

## A abordagem

```
Mecânico vence escrito.  Se dá pra virar hook, não vira parágrafo.
Procedência obrigatória. Regra sem erro real que a justifique não entra.
A estrutura pode encolher. Sobe por gatilho, desce por desuso.
```

## Os comandos

| Comando | O que faz |
|---|---|
| `/harness init` | cria ou adota a estrutura, dimensionada ao projeto |
| `/harness doctor` | audita — **nunca escreve** |
| `/harness fix` | aplica o que o doctor achou · `--limpar` abate o que não se provou |
| `/harness learn "<erro>"` | transforma um erro real em guarda permanente |
| `/harness evolve` | a skill audita e melhora a si mesma |
| `/harness upgrade` | leva as melhorias da skill para um projeto |
| `/manual-harness` | manual navegável por número |

## Os três tiers

Nem todo projeto merece a mesma governança. O `init` propõe sempre **o menor tier defensável**:

| Tier | Perfil | Custo por sessão |
|---|---|---|
| **T1 · Leve** | protótipo, script solto | ~500 tokens |
| **T2 · Padrão** | aplicação real, mantida por meses | ~2.500 tokens |
| **T3 · Completo** ⚠️ | multi-módulo, dado sensível, mais de uma pessoa | ~5.000 tokens |

⚠️ O T3 está **projetado, ainda não implementado** — nenhum projeto chegou perto do gatilho, e
construir sem caso concreto seria palpite. Hoje a skill entrega T1, T2 e T2+.

A subida acontece por **gatilho objetivo** (primeiro bug real, dado sensível entrou, virou
multi-módulo) — nunca por achismo. E existe **descida**: guarda que não disparou em 90 dias vira
candidata a abate, com base no log de disparos.

## A espinha mecânica

Três hooks, gerados a partir do tier T2:

| Hook | Evento | O que faz |
|---|---|---|
| `guarda` | `PreToolUse` | bloqueia o proibido, antes de acontecer |
| `pos-edicao` | `PostToolUse` | valida e devolve o erro para o modelo se corrigir |
| `porta-saida` | `Stop` | não deixa encerrar o turno com plano sem baixa |

As guardas moram em `.harness/guardas.json` — **como dado, não como código**. Guarda nova entra
sem ninguém editar script, e cada disparo vira uma linha em `.harness/log-guardas.jsonl`. É isso
que transforma "acho que dá pra limpar" em decisão baseada em dado.

## Estrutura

A árvore canônica mora em [`SKILL.md`](SKILL.md) — fonte única, para não desatualizar em dois
lugares. Em resumo: `SKILL.md` roteia · `comandos/` guarda a instrução de cada comando ·
`criterios/` os limites · `templates/` o que é gerado · `scripts/` os checks mecânicos ·
`manual/MANUAL.md` é a fonte única do manual e `docs/index.html` a página publicada.

## Instalação

```bash
git clone https://github.com/Leozinhobh77/harness.git ~/.claude/skills/harness
```

Requer Claude Code. Os hooks são PowerShell (Windows); os documentos funcionam em qualquer
ferramenta que leia `AGENTS.md`.

## Base

Construída sobre levantamento do estado da arte de julho/2026 em harness engineering, o padrão
`AGENTS.md`, context engineering, spec-driven development e hooks do Claude Code. As medições
que mais pesaram no desenho estão em [`manual/MANUAL.md` §9](manual/MANUAL.md), com as fontes.

Duas delas explicam quase todo o resto:

- arquivo de instrução acima de ~150 linhas: **+20–23% de custo, sem ganho de performance**
- `AGENTS.md` gerado por LLM: **piora a taxa de sucesso em 5 de 8 cenários** testados

> Os melhores harnesses não são frameworks baixados de um fornecedor — são moldados pelo seu
> histórico específico de falhas.

É por isso que esta skill nasce enxuta e cresce a partir dos seus erros, não de palpites.

---

Português do Brasil. Feito para uso pessoal, aberto para quem quiser.
