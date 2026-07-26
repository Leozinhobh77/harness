# CHANGELOG — /harness

> Toda mudança da skill, datada e **com procedência**. Sem procedência, a mudança não deveria
> ter entrado (Lei 1 aplicada à própria skill).
>
> Versionamento: `patch` = correção/texto · `minor` = promoção, abate, check novo ·
> `major` = quebra harness existente (evite; se for, escreva o guia de migração).

---

## v1.1.2 — 2026-07-26

**A correção que importava: viewport. + remodelagem mobile de verdade.**

### Procedência
Mesmo depois da gaveta (v1.1.1), o usuário reportou: letra minúscula no celular, nada
responsivo, precisando esticar com os dedos. **Causa raiz encontrada:** a página não tinha
`<meta name="viewport">` — nasceu como fragmento para o publicador de Artifacts (que embrulha
com viewport na hora de servir) e foi movida crua para o GitHub Pages. Sem a tag, o celular
renderiza a ~980px e encolhe tudo, e nenhuma media query mobile dispara. O usuário estava
vendo o site desktop espremido; a v1.1.1 inteira nunca chegou a rodar no aparelho dele.
Registrado como **P005** em `memoria/PADROES.md`.

### Entra
- Documento HTML completo: `<!doctype html>`, `<html lang="pt-BR">`, `<meta charset>`,
  `<meta viewport>`, `<meta color-scheme>`
- Base tipográfica do mobile sobe para **19px** com line-height 1.75
- Menu remodelado como **botões**: linhas com ~48px de altura de toque, número em chip,
  item ativo com fundo em destaque — no desktop e na gaveta
- Gaveta mais larga (87vw, teto 390px) com `overscroll-behavior: contain`
- Títulos, tabelas, código e callouts maiores no mobile

### Lição de teste
Os testes Playwright emulam o viewport diretamente — por isso passaram enquanto o aparelho
real quebrava. Teste que emula o ambiente não cobre o que o ambiente real infere sozinho.

---

## v1.1.1 — 2026-07-26

**Manual mobile: gaveta deslizante + leitura maior.**

### Procedência
Usuário testou o manual publicado no celular: o menu virou uma tira horizontal espremida junto
com o conteúdo, e o texto ficou pequeno. Pediu um padrão mais moderno — gaveta que abre/fecha,
campo de leitura maior, fontes mais legíveis.

### Entra
- Topbar fixa no mobile: hambúrguer · marca · **rótulo da seção atual** (sempre visível, mesmo
  com a gaveta fechada) · tema
- Gaveta deslizante com backdrop, fecha por Escape / toque fora / clique num link, trava de foco
  (Tab não escapa) e trava o scroll do fundo enquanto aberta
- Tipografia do mobile sobe (raiz 17.5px, `line-height` 1.72) — todo o resto do sistema de
  medidas em `rem` escala junto, sem precisar tocar cada regra
- Desktop ganha botão de recolher o menu (mesma ideia, sem overlay) para quem quiser o campo de
  leitura inteiro

### Dois bugs achados pelos próprios testes (Playwright), não por revisão manual
Registrados em `memoria/PADROES.md` como **P003** e **P004**:
1. `svg.hidden = bool` é um no-op silencioso — a propriedade `hidden` só existe em
   `HTMLElement`, não em `SVGElement`. Corrigido com `setAttribute`/`removeAttribute`.
2. O scroll-spy antigo (`IntersectionObserver`, pega a primeira seção "visível" em ordem de
   documento) escolhia a seção errada quando duas ficavam simultaneamente intersectando a tela
   após um salto de âncora. Trocado por varredura `scroll`+`rAF` que pega a última seção cujo
   topo já cruzou a linha de leitura — mais simples e correto.

Nenhum dos dois foi visual o bastante para saltar aos olhos num clique rápido — só apareceram
porque havia teste automatizado checando o estado real (atributo, texto, classe), não só a
captura de tela. Ver Lei 2 (`CONSTITUICAO.md`): o teste é a guarda mecânica; a correção manual
teria sido o "texto pedindo por favor" de nível 5.

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

### Publicação (mesma versão, adendo)
A skill virou repositório público **[Leozinhobh77/harness](https://github.com/Leozinhobh77/harness)**,
com o manual servido por GitHub Pages em **https://leozinhobh77.github.io/harness/**.
Motivo: até aqui a skill existia **em um único disco** — sem backup, sem histórico. O repositório
resolve backup, versionamento (cada `evolve` vira commit) e publicação de uma vez, e substitui o
plano do Notion.

Como o repositório é público, o exemplo do flywheel foi **generalizado**: saíram o nome do negócio
real e o número exato de contatos, ficaram "um projeto real" e "mais de mil clientes". A didática
é idêntica. Mesma limpeza aplicada aos exemplos de `learn.md`, `evolve.md` e ao changelog.
`comandos/exportar.md` passou a exigir varredura de conteúdo sensível antes de qualquer push.

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
