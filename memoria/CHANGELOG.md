# CHANGELOG — /harness

> Toda mudança da skill, datada e **com procedência**. Sem procedência, a mudança não deveria
> ter entrado (Lei 1 aplicada à própria skill).
>
> Versionamento: `patch` = correção/texto · `minor` = promoção, abate, check novo ·
> `major` = quebra harness existente (evite; se for, escreva o guia de migração).

---

## v1.3.1 — 2026-07-27

**O check do `ESTADO.md` estava errado pela terceira vez. Agora não pergunta mais pelo relógio.**

### Procedência
Achado ao vivo no `/harness upgrade` de **Finanças**, minutos depois de publicar a v1.3.0: o
`doctor` acusou `[Deriva] ESTADO.md e mais antigo que o ultimo commit` logo após um commit que
regenerou o próprio `ESTADO.md`. Reproduzido com carimbo de tempo na mão:

```
ESTADO.md regenerado às   15:35:10
commit 703168b            15:35:12   ← 2 segundos depois
```

### O erro, em três tentativas
1. **v1.2.x** — comparava o `mtime` com o último commit. Mas o commit que **carrega** o
   `ESTADO.md` é sempre alguns segundos mais novo que o arquivo. Insatisfazível após commitar.
2. **v1.3.0** — passou a usar `git log -1 -- . ':(exclude)ESTADO.md'`. O filtro exclui o
   **caminho**, não o **commit**: commitar o `ESTADO.md` junto com qualquer outro arquivo — o
   caso normal — devolvia o mesmo commit, e o check voltava a ser insatisfazível.
3. **v1.3.1** — a pergunta certa não tem relógio nenhum: *regenerar hoje daria um arquivo
   diferente do que está no disco?* `estado.ps1 -Preview` devolve o conteúdo sem escrever, então
   o `doctor` continua só lendo (regra 1 da skill).

### A parte que a comparação de conteúdo revelou
Trocar relógio por conteúdo **não bastou** — e isso foi a descoberta que valeu a rodada. O
`ESTADO.md` embute a lista dos últimos commits e o status do git. Ambos são **insatisfazíveis
por construção**: no instante em que o arquivo é commitado já falta um commit na lista — o
próprio —, e o "working tree limpo" fica falso assim que se edita qualquer coisa.

Então a comparação ficou só na parte **estável**: título, planos ativos e quantidade de
concluídos. É exatamente a deriva que importa — plano que mudou de status ou foi arquivado sem o
`ESTADO.md` ser regenerado. O resto é uma vista de cortesia que não dá para cobrar exatidão.

### Verificação
Dois cenários, os dois conferidos:
- `ESTADO.md` em dia → `OK - nenhum problema mecanico encontrado`
- plano ativo inventado no arquivo → `[Deriva] ESTADO.md nao bate com o que seria gerado agora`

### Abate (Lei 4)
**Nada abatido, e a razão é a mesma da v1.3.0:** 1 projeto, 2 dias de vida. Os critérios pedem
90 dias sem disparo ou ≥2 projetos independentes. Não há dado, e chutar remoção é pior que
esperar. Marcado de novo para a próxima rodada — se cair uma terceira vez sem abate, o problema
passa a ser o julgamento, não a falta de dado.

### Observação para a próxima rodada
`SKILL.md` está com **81 linhas**. O exemplo de saída do `evolve` fala em "SKILL.md 58/60
linhas", sugerindo um teto de 60 — mas `criterios/ORCAMENTOS.md` **não tem linha para
`SKILL.md`**, então nada fiscaliza. É o mesmo tipo de buraco que a v1.3.0 fechou para
`REGRAS-DE-NEGOCIO.md`. Não mexi agora porque é decisão de orçamento, não correção de bug.

---

## v1.3.0 — 2026-07-27

**O `doctor` estava cego em quatro pontos. Achado rodando o próprio `doctor` num projeto real.**

### Procedência
Rodada completa `doctor → fix → upgrade → evolve` no projeto **Finanças** (1º projeto do
registro). Cada item abaixo é uma falha **silenciosa** — nenhuma delas dava erro; todas
simplesmente deixavam de acusar algo. É o pior tipo de defeito num comando de diagnóstico:
o usuário lê "OK" e acredita.

### Entra
- **Orçamento de todos os documentos.** O mapa `$orcamentos` em `scripts/doctor.ps1` tinha 6
  arquivos fixos; `criterios/ORCAMENTOS.md` define 8. `docs/REGRAS-DE-NEGOCIO.md` (teto 250) e
  `Planos/MANUAL.md` (teto 140) nunca eram conferidos por ninguém. **Impacto real:** o
  `REGRAS-DE-NEGOCIO.md` de Finanças estava com **281 linhas** desde sempre, sem nunca ter sido
  acusado. Comentário no código agora manda manter os dois em sincronia.
- **Custo de sessão vs. orçamento viraram duas contas separadas.** O custo somava "todos os
  documentos com teto" e chamava isso de custo por sessão — mas `SPEC.md`,
  `REGRAS-DE-NEGOCIO.md` e `MANUAL.md` são leitura sob demanda, não carregam em toda sessão.
  Agora o custo soma só `AGENTS.md` + `CLAUDE.md` + `ESTADO.md`. Em Finanças o número caiu de
  **~5.213 para ~1.924** tokens/sessão — o alarme de inchaço era, ele próprio, inflado.
  Documentado em `criterios/ORCAMENTOS.md`.
- **Alerta de custo passou a normalizar o tier.** O mapa tinha `T1`/`T2`/`T3`; o manifesto de
  Finanças diz `T2+`, a chave não existia e o `if` nunca disparava — **o alerta estava
  desligado no único projeto que existe**. Agora `T2+` normaliza para `T2`, e tier
  desconhecido vira achado 🔵 explícito em vez de silêncio.
- **Check do `ESTADO.md` deixou de ser insatisfazível.** Comparava o `mtime` do arquivo com o
  último commit — mas o commit que **contém** o `ESTADO.md` é sempre alguns segundos mais novo
  que ele, então o check reclamava para sempre depois de commitar. Agora compara com o último
  commit que mexeu em qualquer coisa **exceto** o `ESTADO.md`
  (`git log -1 -- . ':(exclude)ESTADO.md'`). Pego ao vivo: acusou logo após o commit do próprio
  `fix` desta mesma rodada.
- **Registro do projeto virou mecânico (Lei 2).** `comandos/init.md:75-78` manda registrar o
  projeto em `memoria/REGISTRO.md` — e o passo foi **pulado** na criação de Finanças. Como a
  etapa 2 do `evolve` varre justamente esse registro, a skill estava condenada a nunca aprender
  com nenhum projeto: `REGISTRO.md` vazio = varredura vazia, para sempre. Um passo escrito que
  foi ignorado é exatamente o anti-padrão da Lei 2, então virou check no `doctor`.
- `memoria/REGISTRO.md`: Finanças registrado (dado consertado). `projetos_criados: 1`.

### Abate (Lei 4)
**Nada abatido nesta rodada** — e isso é uma admissão, não um atestado. A skill tem 1 dia; os
critérios objetivos de abate pedem 90 dias sem disparo ou ≥2 projetos independentes. Não há
dado ainda, e chutar remoção seria pior que esperar. Fica marcado para a próxima rodada.

### Nota de método
Todos os 5 achados vieram de **rodar a skill de verdade num projeto**, não de reler o código
dela. O auto-doctor (`SKILL.md` no orçamento, parsers OK, 0 bytes não-ASCII, 10/10 comandos da
rota existindo) passou limpo e não teria encontrado nenhum deles — porque nenhum é erro de
sintaxe ou de estrutura. São erros de **cobertura**: código correto conferindo a coisa errada.

---

## v1.2.1 — 2026-07-26

**Correção no `guarda.ps1` (T2+): comando proibido só bloqueia dentro do próprio projeto.**

### Procedência
Achado ao vivo, minutos depois de publicar a v1.2.0: a guarda `sem-push` de Financas bloqueou
`cd ...\harness && git push`, um push **já autorizado** num repositório totalmente diferente,
só porque o texto do comando continha "git push". A guarda nunca teve esse defeito na intenção
— só na implementação, que checava o texto sem saber que o `cd` levava pra fora do projeto.

### Entra
- `templates/T2-padrao/.claude/hooks/guarda.ps1` — resolve o diretório efetivo do comando antes
  de aplicar `comandos_proibidos`; se o `cd` aponta fora da raiz do projeto, pula a checagem
- **Segunda volta no mesmo bug, minutos depois:** o primeiro fix só entendia caminho estilo
  Windows (`C:\Users\...`); o `Bash` deste ambiente é Git Bash e produz `/c/Users/...`, que o
  `Resolve-Path` do PowerShell não reconhece — falhava em silêncio e a guarda voltava a
  bloquear tudo. Só apareceu porque a mensagem de commit descrevendo o próprio bug continha o
  texto "git push", e a guarda se autoaplicou. Corrigido convertendo `/<letra>/...` para
  `<LETRA>:\...` antes de resolver.
- Testado nos 4 cenários (com caminho no formato real do Bash): push dentro do projeto (continua
  bloqueando), push em outro repo via `cd` posix (agora libera, mesmo com "git push" no texto
  da mensagem de commit), `reset --hard` dentro do projeto (continua bloqueando)
- P006 em `memoria/PADROES.md`
- Propagado manualmente para o `.claude/hooks/guarda.ps1` já instalado em Financas (projeto
  existente — `/harness upgrade` levaria isso automaticamente da próxima vez)

---

## v1.2.0 — 2026-07-26

**Comando novo: `/menu-harness` — lançador com último uso.**

### Procedência
Usuário pediu um menu que lista todos os comandos com descrição curta e a data do último
acesso de cada um, pra não precisar lembrar nomes. Proposta apresentada com duas opções pra
registrar "último uso": (A) passo central no roteador, mantido pelo agente; (B) hook mecânico
dedicado por projeto. Optou pela recomendação — opção A — com o argumento de que a Lei 2
("mecânico vence escrito") existe pra **guardas que evitam erro**, e isto é telemetria de
conveniência, não uma guarda; um hook a mais em todo projeto novo seria custo sem benefício de
segurança correspondente.

### Entra
- `comandos/menu.md` — menu em 2 grupos (comandos do projeto atual vs. comandos da skill),
  com descrição de uma linha e último uso por comando; escolher um número **executa**, não só
  explica (diferença deliberada em relação ao `/manual-harness`, que ensina)
- `memoria/uso.json` — registro central, `{comando: {data, projeto}}`
- `SKILL.md` ganha a seção "Registrar uso": todo comando carregado da tabela de roteamento
  grava sua própria execução — cobre tanto `/harness <comando>` direto quanto via o menu.
  Exceção: o próprio `menu` não se autorregistra (seria sempre "agora", sem sinal nenhum)
- `~/.claude/skills/menu-harness/` — atalho, mesmo padrão do `manual-harness`
- Manual (fonte + página publicada): colinha, FAQ e histórico atualizados

### O que ficou de fora, de propósito
Contagem de vezes usado (não só a última data) e hook mecânico de instrumentação (opção B) —
nenhum dos dois foi pedido; ambos ficam registrados aqui como candidatos, não implementados.

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
