# CHANGELOG — /harness

> Toda mudança da skill, datada e **com procedência**. Sem procedência, a mudança não deveria
> ter entrado (Lei 1 aplicada à própria skill).
>
> Versionamento: `patch` = correção/texto · `minor` = promoção, abate, check novo ·
> `major` = quebra harness existente (evite; se for, escreva o guia de migração).

---

## v1.1.0 — 2026-07-26

**Manual completo em 4 camadas + publicação.**

### Entra
- **`manual/MANUAL.md`** — fonte única do manual, em 4 camadas: 📕 referência · 🍳 receitas ·
  🔧 anatomia · 🚑 socorro, mais glossário (14 termos) e evidências com fontes
- **`manual/web/manual.html`** — página publicada, tema claro/escuro, navegação com scroll-spy
- **`comandos/exportar.md`** — `/harness manual --exportar [web|notion]`
- Regra no `SKILL.md`: manual tem fonte única; a saída nunca se edita

### Procedência
O usuário quis guardar o manual no Notion. O risco real: cópia publicada vira **segunda fonte de
verdade** e passa a mentir assim que o `evolve` mudar algo — exatamente a deriva que a Família 2
do `doctor` caça. Resolvido com três mecanismos: fonte única declarada, **carimbo de versão em
toda saída** (a cópia diz de qual versão ela é), e o `evolve` obrigado a lembrar da reexportação
quando mudar comando, tier, lei ou orçamento.

### O que NÃO entrou, de propósito
Cópias dos blocos do Notion salvas em disco. Seriam a terceira cópia do mesmo conteúdo — Lei 3,
fonte única. Os blocos são gerados sob demanda a partir do `MANUAL.md`.

### Nota de escopo
Os orçamentos de `criterios/ORCAMENTOS.md` **não se aplicam ao `MANUAL.md`**. Orçamento existe
para o que carrega em **toda sessão** (`SKILL.md`, `AGENTS.md`); documento que um humano lê sob
demanda não custa token de sessão. Confundir os dois levaria a mutilar documentação útil em nome
de uma regra que existe para outra coisa.

---

## v1.0.0 — 2026-07-26

**Nascimento.** Primeira versão da skill.

### Base de pesquisa
Construída sobre levantamento do estado da arte em julho/2026 — harness engineering
(Addy Osmani, Software Mansion, Sakasegawa), padrão AGENTS.md, context engineering
(Sourcegraph), spec-driven development (GitHub Spec-Kit), hooks do Claude Code, e memória de
agente (Mem0). As medições que mais pesaram no desenho:

- Arquivo de instrução acima de ~150 linhas: **+20–23% de custo sem ganho de performance**
- `AGENTS.md` gerado por LLM: **piora a taxa de sucesso em 5 de 8 cenários**, +2,45–3,92 passos
- *"Prompting instead of enforcing"* é o anti-padrão nº 1 — daí a Lei 2
- Hierarquia de retorno: PostToolUse (ms) > pre-commit (s) > CI (min) > humano (∞)

### Entra
- **Constituição de 5 leis** — procedência obrigatória · mecânico vence escrito · orçamento é
  lei · pressão de abate · menor tier que serve
- **Tiers T1/T2/T3** com gatilhos objetivos de subida **e critérios de descida por desuso**
- **7 comandos** — `status` `init` `doctor` `fix` `learn` `evolve` `upgrade`
- **3 hooks** (T2) — `guarda` (PreToolUse) · `pos-edicao` (PostToolUse) · `porta-saida` (Stop)
- **Guardas como dado** (`.harness/guardas.json`) — nova guarda entra sem editar script
- **`ESTADO.md` derivado** — gerado de `Planos/` + git, impossível divergir
- **`log-guardas.jsonl`** — instrumentação que transforma limpeza em decisão baseada em dado
- **Manual navegável** (`/manual-harness`) com índice numerado
- **Lembrete de evolução** por prazo, silencioso quando em dia

### Procedência do desenho
Diagnóstico de um harness real construído à mão (~junho/2026), que acertou o
`AGENTS.md` canônico, o flywheel e o anti-inchaço, mas era **100% prompt e 0% mecânico**: nada
impedia a IA de pular a baixa do plano ou editar dado bruto. Os 6 gaps encontrados viraram, um
a um, as decisões de desenho acima.

### Achados durante a própria construção
- **P001** — `.ps1` com acento quebra no console do Windows. Pego ao vivo pela armadura
  `ps1-check` da Forge do usuário (14 erros de parser + 60 bytes não-ASCII). Virou o check de
  ASCII em `pos-edicao.ps1` e a arquitetura "script ASCII + template UTF-8".
- **P002** — `$var:` em string é lido como escopo pelo PowerShell. Coberto pelo check de parser,
  **sem regra escrita** — aplicação prática da Lei 2.

Que a primeira versão já tenha nascido com dois padrões achados por hook, e não por revisão
humana, é a evidência de que a Lei 2 está certa.
