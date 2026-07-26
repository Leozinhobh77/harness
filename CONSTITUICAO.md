# CONSTITUIÇÃO — as 5 leis do `/harness`

> Estas leis são **inegociáveis** e valem para todo harness criado por esta skill **e para a
> própria skill**. Elas existem por um motivo só: harness morre de inchaço, não de falta de
> regra. Toda estrutura de governança que ninguém poda vira, em meses, um documento que
> ninguém lê e que custa token em toda sessão.
>
> Se um comando desta skill mandar fazer algo que viola uma lei daqui, **a lei vence** — e o
> comando deve ser corrigido.

---

## Lei 1 — Procedência obrigatória

**Nenhuma regra entra sem um erro real que a justifique.**

Toda linha de instrução num `AGENTS.md`, toda guarda, todo hook precisa rastrear até algo
específico que deu errado. Se você não consegue responder *"que erro isso previne?"*, a regra
não entra.

**Por que:** medição de 2026 mostrou que arquivos de instrução gerados por LLM (cheios de
regra genérica plausível) **reduziram a taxa de sucesso em 5 de 8 cenários testados**,
adicionando 2,45–3,92 passos extras por tarefa. Regra genérica não é neutra — ela **piora** o
agente.

**Exceção única:** guardas de segurança de dado (não commitar segredo, não apagar fonte bruta)
entram preventivamente. Perder dado não tem desfazer.

**Como se aplica:** todo item gerado carrega um campo de procedência. O `doctor` reprova
qualquer regra sem ele.

---

## Lei 2 — Mecânico vence escrito

**Se dá para impedir com um hook, não escreva um pedido.**

Ordem de preferência, sempre:

```
1. Impossível de fazer errado (estrutura/hook que bloqueia)
2. Erro detectado na hora (hook que valida e devolve o erro)
3. Erro detectado no fim (Stop hook, pre-commit)
4. Texto pedindo educadamente        ← último recurso
```

**Por que:** *"prompting instead of enforcing"* é o anti-padrão nº 1 de harness em 2026. E a
velocidade do retorno é implacável: `PostToolUse` (milissegundos) > pre-commit (segundos) >
CI (minutos) > o usuário percebendo (nunca).

**Como se aplica:** o comando `learn` sempre pergunta primeiro *"dá para ser mecânico?"*.
Só cria texto quando a resposta é não.

---

## Lei 3 — Orçamento é lei

**Cada documento tem um limite de linhas, e estourar reprova no `doctor`.**

Os limites estão em `criterios/ORCAMENTOS.md`. Não são sugestão.

**Por que:** medição de 2026 — arquivos de instrução acima de ~150 linhas aumentam o custo de
inferência em **20–23% sem ganho nenhum de performance**. Documento que passa do orçamento não
está mais informando, está cobrando pedágio.

**Como se aplica:** estourou o orçamento, o conteúdo **migra para um documento de profundidade**
e o arquivo principal fica só com o ponteiro. Nunca duplicar parágrafo entre documentos —
sempre link para a fonte única.

---

## Lei 4 — Pressão de abate

**Para entrar regra nova, é preciso avaliar se remover uma velha não é melhor.**

Uma estrutura que só cresce está morrendo devagar. `evolve` e `fix --limpar` são obrigados a
**propor remoções**, não só adições.

**Critério objetivo de abate** (nunca chute):
- Guarda que **nunca disparou** em 90 dias (dado de `.harness/log-guardas.jsonl`)
- Regra sem procedência (Lei 1)
- Decisão superada por outra mais nova
- Documento que nenhum outro documento referencia

**Por que:** foi exatamente assim que o harness de referência chegou a 18 decisões e 25 KB de
protocolo sem nunca ter podado nada. Ninguém lê inteiro, então a memória vira enfeite.

---

## Lei 5 — O menor tier que serve

**Na dúvida entre dois tiers, escolha o menor.**

Subir de tier é fácil e reversível (`/harness upgrade`). Descer, depois que o projeto encheu de
documento, é doloroso e quase nunca acontece.

**Por que:** o jeito mais fácil de estragar um projeto pequeno é dar a ele governança de
projeto grande. Governança que não serve ao projeto é atrito puro — e atrito faz o usuário
abandonar o processo inteiro.

**Como se aplica:** `init` sempre **propõe o menor tier defensável** e mostra o custo em tokens
por sessão. A subida acontece por **gatilho objetivo** (ver `criterios/TIERS.md`), nunca por
"acho que agora merece".

---

## Como emendar esta constituição

Só pelo comando `evolve`, com:
1. **Procedência** — que erro real motivou a emenda (Lei 1 aplicada a si mesma)
2. **Evidência de ≥2 projetos independentes** — um caso é acaso, dois é padrão
3. **Aprovação explícita do usuário**
4. Registro datado em `memoria/CHANGELOG.md`
