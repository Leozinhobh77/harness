# CHANGELOG — /harness

> Toda mudança da skill, datada e **com procedência**. Sem procedência, a mudança não deveria
> ter entrado (Lei 1 aplicada à própria skill).
>
> Versionamento: `patch` = correção/texto · `minor` = promoção, abate, check novo ·
> `major` = quebra harness existente (evite; se for, escreva o guia de migração).

---

## v1.7.0 — 2026-08-12  ·  🧬 primeira rodada completa de `evolve`

**A skill varreu os 3 projetos, achou uma convergência real, promoveu, abateu, e passou no
próprio doctor.** É o Ciclo 3 funcionando pela primeira vez de ponta a ponta.

### Como foi a varredura

3 projetos vivos · 0 🔴 em todos · custo entre 2.028 e 2.236 tokens/sessão · auto-doctor limpo
(13/13 comandos roteados e existentes, 0 links quebrados, 8 scripts com parser e ASCII OK,
`SKILL.md` em 91 linhas). Pesquisa externa **pulada** — a última foi no mesmo dia.

### 📈 Promovido — a convergência (P011)

**`sem-push` sai do template T2; `sem-push-force` entra.**

Dois projetos independentes rejeitaram a guarda larga, em datas e por motivos diferentes:

| Projeto | O que fez | Motivo registrado no próprio projeto |
|---|---|---|
| Zenith (30/07) | **abateu** `sem-push`, criou `sem-push-forcado` | *"a guarda foi abatida quando o usuário autorizou a publicação; sobrou a parte destrutiva"* |
| Central (11/08) | **omitiu** `sem-push` no `init`, criou `sem-push-force` | *"neste projeto o push é o mecanismo de deploy, bloquear seria quebrar o fluxo"* |

**A lição, e ela é maior que esta guarda:** guarda larga demais não é conservadora — é **frágil**.
Ela não vira mais estreita com o uso; ela vira **desligada**. E o abate leva junto a proteção
contra a variante destrutiva. A pergunta certa ao desenhar guarda não é *"o que pode dar errado
nesta família de comandos?"* e sim *"qual variante não tem desfazer?"*.

Testado: 9/9 casos — bloqueia `--force`, `-f`, `--force-with-lease`; libera `push`,
`push origin main`, `push -u origin feature`.

### 📈 Promovido — Lei 2 aplicada ao `ESTADO.md`

`ESTADO.md nao bate com o que seria gerado agora` aparecia em **2 de 3** projetos: o `doctor`
acusava, ninguém rodava o `fix`, e o alarme virava paisagem. Alarme que nunca apaga ensina a
ignorar (é o P007 de novo, por outro ângulo).

Agora o hook `sombra.ps1` regenera o `ESTADO.md` no `SessionStart`, **antes** de tirar a foto.
Best-effort de propósito: o gerador mora na skill e o hook é autocontido — sem a skill, pula em
silêncio, e a foto (o que realmente importa) não depende disso.

⚠️ **Caveat achado no teste:** se o `ESTADO.md` estiver **aberto em editor**, a escrita falha por
lock e o hook segue em silêncio. Correto (fail-open), mas explica por que às vezes não regenera.

### 📉 Abatido (Lei 4)

**`templates/T3-completo/` deixou de existir.** A pasta tinha **um** arquivo — e nem era do T3:
`REGRAS-DE-NEGOCIO.md` é o que o **T2+** adiciona, e os dois projetos T2+ já o usam (67 e 145
linhas). Pasta com um arquivo errado dentro é pior que pasta nenhuma: parece que há algo pronto.
O arquivo foi para `templates/comum/`; o `TIERS.md` agora diz que **não existe template T3**, em
vez de apontar para um enganoso.

### 🔧 Observado, não mexido

`learn` marca **nunca usado** em `uso.json` — o comando que a própria skill chama de "o mais
importante" — e mesmo assim guarda customizada com procedência nasceu em 2 projetos. Ou o
trabalho acontece por fora dele (via decisão no `init`), ou o passo "Registrar uso" é pulado.
**Não sei qual, e não vou chutar** — fica para investigar no próximo uso real.

### P008 ganhou uma terceira ocorrência — e um limite honesto

A guarda `sem-push-force` do Central bloqueou um comando que só **escrevia um arquivo de teste**
contendo a string, dentro de um heredoc. Três sistemas diferentes, o mesmo defeito, no mesmo dia.
E este caso **não tem conserto por regex**: distinguir execução de dado exige interpretar o
shell. A mitigação é passar dado por arquivo, não por linha de comando.

### Nos projetos

Nenhum muda sozinho — é a regra do `upgrade`. **Finanças fica com a `sem-push` velha**, a mesma
que os outros dois rejeitaram, e a decisão de trocar é do usuário.

---

## v1.6.0 — 2026-08-12

**O degrau 3: `/harness gauntlet` — o loop fechado, com os freios que a evidência exige.**

### Procedência

Decisão explícita do usuário, tomada **depois** da pesquisa da v1.5.0 e com as alternativas na
mesa (só relatório · instalar a skill pronta · construir o degrau 3). Ele escolheu o degrau 3.
As implementações públicas foram dissecadas antes ([robonuggets/gauntlet-loop](https://github.com/robonuggets/gauntlet-loop)
e [duolahypercho/gauntlet-loop](https://github.com/duolahypercho/gauntlet-loop)): as duas são
**"pure prompt"** — a segunda diz textualmente *"No harness. No state machine. No helper
scripts."* e *"You are the brake. The loop will not finish on its own."* Sem portão, sem
rollback, sem teto.

A evidência que definiu os freios é a mesma da v1.5.0 (LoopsBench 25% + regressões em todos os
perfis; juiz inflando 0,72→0,94 com qualidade real em 0,20; Proof-or-Stop 1,7%→0,1%). O que a
v1.5.0 concluiu — *"o loop não é o que funciona, o portão é"* — virou desenho: **o loop existe,
mas cada freio é um passo obrigatório do fluxo.**

### Entra

- `comandos/gauntlet.md` — o 11º comando. Por rodada: foto da sombra → builder corrige **só** o
  gap → portão determinístico → crítico cego (reusa `criticar` §3–6, fonte única) → decisão.
- **Cinco paradas**, qualquer uma encerra: vitória · teto (padrão 3, `--rodadas N`) · **platô**
  (mesmo gap 2× seguidas) · **regressão** (portão quebrou → rollback pela foto) · o usuário.
- **Anti-reward-hacking fixo:** uma mutação por rodada (hill climbing) · builder nunca vê o
  transcript do crítico, só o gap em texto · nunca nota nem score em arquivo · nada roda sem OK
  explícito com barra, teto e custo na mesa (regra 3 da skill).
- Rota no `SKILL.md`, item 6 no menu, §4.10 no manual, seção na página.

### Zero mudança nos projetos

Todas as peças já estavam neles desde a v1.4.0/1.5.0: `critico-cego.md`, `referencias/`, a
sombra, o doctor. Só o `versao_skill` dos manifestos sobe. É o desenho em camadas pagando:
**o loop é só a ordem em que as peças existentes rodam.**

### Fora de escopo, deliberado

❌ Fan-out de builders em paralelo (dobra custo sem evidência de ganho no nosso caso) ·
❌ score/telemetria de rodadas em arquivo (a métrica que convida ao hacking) ·
❌ rodar sem confirmação.

---

## v1.5.0 — 2026-08-12

**A barra: `referencias/` e o crítico cego. O harness passa a ter uma categoria que não tinha —
material de entrada.**

### Procedência — e ela é mais fraca que a da v1.4.0, de propósito registrado assim

O usuário trouxe o **Gauntlet Loop** (Matt Shumer, julho/2026) e pediu pesquisa antes de decidir.
A pesquisa mudou o desenho. O que ficou de pé, e o que caiu:

**Contra o loop autônomo:**
- **LoopsBench** ([2608.00267](https://arxiv.org/abs/2608.00267), 31/07/2026): 112 desafios, 8
  linguagens. Melhor configuração = **25% de resolução**, e *"eventos de regressão permanecem
  visíveis em todos os perfis de loop avaliados"*.
- **Reward hacking de juízes** ([2607.05904](https://arxiv.org/abs/2607.05904)): em self-play a
  aprovação do juiz foi de **0,72 → 0,94 com a acurácia real parada em 0,20**. Transfere entre
  famílias de modelo; ensemble de três juízes ainda aceita 55%.
- **"LLMs Cannot Self-Correct Reasoning Yet"** ([2310.01798](https://arxiv.org/abs/2310.01798)):
  o gargalo é **detectar** o erro, não corrigir.
- O "one-shot" do Claude of Duty é falso — foram horas, subagentes, ~55k linhas. E o autor tem o
  caso **Reflection 70B** (2024) no histórico: demo dele não é evidência.

**A favor do mecanismo, quando há portão:**
- **Proof-or-Stop** ([2607.14890](https://arxiv.org/abs/2607.14890)): exigir evidência
  verificável antes de mudar de estado levou amplificação de erro de **1,7% → 0,1%**, zero
  conclusões falsas em 10 cenários.
- **Adversarial Test-Hardening** ([2607.23002](https://arxiv.org/abs/2607.23002)): critic loop
  matou **~78%** dos defeitos restantes.

**Conclusão que guiou o desenho:** o loop não é o que funciona — **o portão determinístico é**.
Entrou o crítico (uma rodada, com portão antes). **Não entrou o loop autônomo.**

⚠️ **A procedência honesta desta versão é uma lacuna real, não um erro real:** *"o usuário quer
subir a barra de qualidade em trabalho visual e não tem mecanismo nenhum para isso"*. É mais
fraca que a da sombra, que era a exceção explícita da Lei 1. Passa porque a Lei 1 governa
**regra e guarda** — comando não é imposto, não roda sozinho, não custa token sem uso (mesmo
critério pelo qual o `menu` entrou na v1.2.0). Fica registrado sem maquiagem.

### Entra

- `referencias/` — **categoria nova**: não é documento de governança (o que o projeto *decidiu*),
  é material de entrada (o que ele *quer parecer*). Prateleira de 8 pastas: `visual` ·
  `personagens` · `texto` · `documentos` · `dados` · `mapas` · `audio` · `video`.
- `referencias/INDICE.md` — o único arquivo com conteúdo. Impõe os 3 critérios que a pesquisa
  mostrou serem o miolo do método: **Nomeada · Buscável · Inspecionável**.
- `FICHA.tpl.md` — ficha de consistência de personagem/marca, com a seção **"erros já
  cometidos"**: a Lei 1 aplicada à referência (erro vira invariante escrito).
- `comandos/criticar.md` + `templates/comum/critico-cego.md` — subagente **read-only**, Sonnet,
  contexto limpo, comparação **cega** (não sabe qual é o nosso), **decisão binária sem nota**.

### Decisões de desenho

- **Prateleira inteira mesmo vazia.** Decisão do usuário, com argumento que eu aceito como
  correto: *"o que não é visto não é lembrado"*. Custo medido: **0 token** pela pasta, **13
  tokens** pela linha de ponteiro no `AGENTS.md`. Adoção é problema real; teto de token aqui não
  era.
- **Subagente, não agent teams.** Subagente roda na mesma sessão, com janela de contexto própria
  — sem abrir janela nova, funciona na extensão do VS Code. Agent teams é experimental, exige
  variável de ambiente, e split-pane **não funciona no VS Code**.
- **Sonnet no crítico.** Viés de auto-preferência é medido; se o Opus constrói, crítico Opus
  puxa a sardinha. E comparar é mais barato que criar. Ressalva honesta: o modelo é a variável
  **menos** importante — o que faz funcionar é contexto limpo + cegueira + portão antes.
- **Áudio e vídeo não são lidos hoje.** Verificado, não suposto. A regra da **companheira `.md`**
  resolve os dois casos: hoje a IA lê a companheira, amanhã lê o arquivo — que já está lá.

### Fora de escopo, explicitamente

❌ Loop autônomo · ❌ nota numérica · ❌ crítico que conserta · ❌ check no `doctor` cobrando
`referencias/`. Os três primeiros pela evidência; o quarto porque transformaria capacidade
opcional em obrigação — e aí seria o inchaço que a skill existe para impedir.

---

## v1.4.0 — 2026-08-12

**A quarta guarda: a sombra. As três primeiras impedem o erro; esta aceita que um dia um erro
passa, e garante que dá para voltar.**

### Procedência

Pergunta do usuário, ao vivo: *"quando eu vou modificar alguma coisa no meu projeto, ela faz
algum backup, pra caso aconteça alguma coisa de errado?"*

A resposta era **não**. Auditado no disco antes de responder: a única rede de segurança era git
— e ela era **procedimental**, não mecânica (`fix` e `upgrade` exigem working tree limpo; o resto
é pedido escrito no `AGENTS.md`). Nenhum hook copiava nada. O `pos-edicao.ps1` roda *depois* da
escrita: quando ele valida, o conteúdo anterior já foi embora.

Pesquisa de 12/08/2026 confirmou o tamanho exato do buraco. O checkpoint nativo do Claude Code
(`/rewind`, desde a v2.0) cobre bastante — snapshot antes de cada prompt, 100 mais recentes, 30
dias — **mas não rastreia**: mudança feita por comando de shell (`rm`, `mv`, `cp`, `>`), edição de
subagente em segundo plano, mudança externa, symlink. A doc é explícita: *"Not a replacement for
version control"*.

**Esta versão cobre esse buraco, e só ele.** Reimplementar o `/rewind` seria o inchaço que a
Lei 1 proíbe.

### Por que entrou sem os 2 projetos da regra de promoção

É a **exceção única da Lei 1** — guarda de segurança de dado entra preventivamente, porque perder
dado não tem desfazer. Mesmo estatuto do `.gitignore`.

### Entra

- `scripts/sombra.ps1` — motor: `-Listar` `-Diff N` `-Restaurar N` `-Status` `-Snapshot` `-Limpar`
- `templates/comum/sombra.ps1` — o hook, **autocontido**: não chama a skill, então o projeto
  continua protegido mesmo se o `/harness` for desinstalado. Fica em `comum/` e não em
  `T2-padrao/` porque T1 também o recebe — duas cópias seriam a duplicação que a Lei 3 proíbe
- `comandos/voltar.md` — o 10º comando, e o único escrito para quem está com medo
- `templates/T1-leve/.claude/settings.json` + `.gitignore` — **T1 ganha hook pela primeira vez**
- `criterios/CHECKS.md` — 3 checks novos na Família 5 · `scripts/doctor.ps1` — os mesmos, mecânicos
- Rota no `SKILL.md`, item 4 no `menu.md`, passo 2 na ordem de geração do `init.md`

### Desenho — as decisões que valem registro

- **Onde mora:** `.harness/sombra.git`, **dentro** do projeto. Mantém a promessa do manual
  (*"o harness inteiro mora dentro do seu projeto"*). Decisão do usuário, com a alternativa
  (`~/.harness/sombras/`) apresentada e recusada.
- **Repositório git separado**, não cópia de arquivo. Ganha da abordagem `.backups/` (a da Forge
  do usuário) em três pontos: captura o que o **shell** fez, não espalha pasta pela árvore, e
  restaura tudo de uma vez. Padrão *shadow git* (`GIT_DIR` + `GIT_WORK_TREE`).
- **Nunca bloqueia.** `exit 0` em qualquer situação, inclusive erro. Rede de segurança que trava
  o trabalho é desligada na primeira semana — e aí não protege mais nada.
- **Restaurar não apaga.** Tira foto do estado atual antes, e arquivo criado depois da foto é
  **listado**, nunca removido. É a regra "nada é apagado" da skill inteira.
- **Sem mudança no disco = sem foto.** Senão a foto útil fica enterrada em ruído.

### Provado, não presumido

Projeto de teste real: `estilo.css` apagado, `imagens/` apagada, `index.html` sobrescrito — os
três por comando de shell, o cenário que o `/rewind` **não** desfaz. `-Restaurar 1` trouxe os três
de volta, e o estado ruim virou foto 1. O hook foi testado com o JSON real de três eventos
(`Bash` destrutivo → fotografa · `Bash` inofensivo → não fotografa · `SessionStart` → fotografa),
sempre com `exit 0`.

### Dois achados durante a verificação

1. O `%ar` do git devolve tempo relativo **em inglês** e não há parâmetro para traduzir. A skill é
   português-only, então `Get-Quando` calcula em PowerShell (*"há 4 min"*, *"ontem 15:40"*).

2. ⭐ **`-Restaurar 1` quebrava em projeto com exatamente uma foto** (P009). `.Count` num
   `PSCustomObject` devolve `$null`, e as comparações ficavam invertidas em silêncio. O teste de
   aceitação tinha 3 fotos e passou; o defeito só apareceu ao rodar `-Status` nos **projetos
   reais**, recém-instalados. Corrigido com `@()` em toda chamada de `Get-Fotos`, e reprovado no
   cenário exato: projeto com uma foto, arquivo apagado, restaurado.

   A lição ficou registrada em `PADROES.md` porque vale além deste bug: **o cenário de
   demonstração naturalmente tem vários itens, então o caso de 1 é o menos testado — e é o
   primeiro que o usuário encontra.**

### Manual e página, atualizados junto (§4.8, hooks, anatomia, tiers, FAQ)

`manual/MANUAL.md` e `docs/index.html` receberam a seção nova do `voltar`, a tabela de hooks com
quatro linhas, a sombra na árvore da anatomia, o T1 corrigido na tabela de tiers, três perguntas
novas no FAQ e o carimbo v1.4.0. `comandos/manual.md` renumerou o índice (o `voltar` entra como
tópico 5, logo depois do `fix`).

**E a conferência da página achou um bug antigo, no ar desde a v1.1.1 (P010).** O botão de tema
mostrava **sol e lua sobrepostos**: o JS aplicava `hidden` corretamente (o conserto do P003 estava
lá), mas `.icon-btn svg { display: block }` tem especificidade maior que o `[hidden]` do navegador
e anulava o atributo em silêncio. Corrigido com uma regra explícita. É o P003 uma camada acima — e
o teste do P003 não pegava porque conferia o **atributo**, quando a pergunta certa era sobre o
**estilo computado**.

---

## v1.3.3 — 2026-08-06

**A skill rodou o próprio `doctor --skill` e reprovou em quatro pontos. Três eram deriva; um era
uma promessa que ela não cumpria.**

### Procedência
Usuário pediu o procedimento de avaliação **da skill** (não de projeto) e mandou rodar o
`doctor --skill` — o passo que o `evolve` normalmente faz na etapa 6, aqui isolado. Achados
verificados no disco, não inferidos:

- `SKILL.md:69` apontava a saída do manual para `manual/web/manual.html`. Esse caminho **não
  existe**; a saída real é `docs/index.html` (`comandos/exportar.md:10,31`). O `SKILL.md` é lido
  em toda invocação, e a regra logo abaixo manda "corrigir o `MANUAL.md` e rodar `--exportar`" —
  quem fosse arrumar a página tinha caminho aberto para criar o arquivo errado.
- Duas árvores de estrutura, `SKILL.md:60` e `README.md:69`, descrevendo a mesma pasta. A do
  README já tinha sido corrigida para `docs/index.html`; a do `SKILL.md` não. É textualmente o
  que `criterios/ORCAMENTOS.md` proíbe — *"duplicata é garantia de que um dos dois vai
  desatualizar sem ninguém notar"*. Aconteceu dentro da própria skill.
- Nenhuma das duas árvores listava `README.md`, `.gitignore` ou (no caso do `SKILL.md`) `docs/`,
  contra o check "todo arquivo existente está documentado".
- **T3 era um degrau sem escada.** `TIERS.md` definia os gatilhos, `CHECKS.md:87` mandava o
  `doctor` **propor T3**, `MANUAL.md:868` descrevia o que ele traz — e `templates/T3-completo/`
  tem um arquivo só, com **zero** menções a T3 em `comandos/` (grep). Um projeto que cruzasse o
  gatilho e aceitasse a proposta encontraria nada para aplicar.

### Entra
- `SKILL.md` — árvore corrigida (`docs/index.html`), com `README.md`, `.gitignore` e `docs/`
  listados, e declarada explicitamente como **fonte única da estrutura**
- `README.md` — árvore substituída por ponteiro para o `SKILL.md` + resumo em uma frase
- **T3 marcado como "projetado, ainda não implementado"** nos cinco lugares que o prometiam:
  `criterios/TIERS.md` (tabela, seção e gatilho), `criterios/CHECKS.md` (o check passa a
  *registrar* que cruzou, não a prometer subida), `comandos/upgrade.md` (`--tier 3` sai do bloco
  de uso, com aviso de não improvisar um T3 na hora), `README.md` e `manual/MANUAL.md`

### Sai (Lei 4)
- `comandos/evolve.md` — o item de abate *"documento da skill que estourou o próprio orçamento"*.
  `criterios/ORCAMENTOS.md` só tem tetos para documentos de **projeto**; o critério que essa
  linha cobrava não existe em lugar nenhum, então ela nunca reprovou nada e nunca poderia.

### Decisão registrada
Optou-se por **dizer a verdade sobre o T3 agora** em vez de construí-lo. Motivo: os 2 projetos do
`REGISTRO.md` estão longe do gatilho, e template sem caso concreto é palpite — a Lei 1 aplicada à
própria skill. Quando o primeiro projeto cruzar, ele vira o caso de uso e o T3 nasce medido.

### Não mexido de propósito
`manual/MANUAL.md` continua na v1.2.1 quanto ao **conteúdo** — as três entradas de 27/07 (v1.3.0,
v1.3.1, v1.3.2) ainda não entraram nele, e `docs/index.html` segue de 26/07. Só as marcações de
T3 foram aplicadas. Fica como o próximo trabalho.

`ultima_evolucao` **não** foi mexida: isto foi `doctor --skill` + correção, não um ciclo de
`evolve` (não houve varredura de convergência nem pesquisa externa).

---

## v1.3.2 — 2026-07-27

**O teto de orçamento ganhou tolerância. E parou de somar arquivos diferentes.**

### Procedência
Correção do **usuário**, não minha. Eu somei `SKILL.md` (81 linhas) com `CONSTITUICAO.md` (113)
e argumentei que o total de 194 passava do limiar de ~150 da Lei 3. Ele derrubou os dois pontos:

> *"A skill.md é uma coisa, a constituição é outra, cada uma com suas coisas — não é juntar as
> duas que vai virar uma coisa só. E se passar um pouco, quarenta linhas, vinte linhas, a gente
> não vai ficar cortando o conteúdo. Já fez a coisa toda certinha e vai ficar cortando? Só iria
> estourar se fossem muitas linhas, cem, duzentas — mas dez, vinte por cento a gente deixa."*

Ele está certo nas duas. A medição que embasa os tetos é **por arquivo**; somar dois documentos
com funções diferentes e comparar com um limiar de arquivo único é erro de categoria. E teto
binário faz o número mandar no conteúdo — a "correção" vira mutilar texto bom.

### Entra
- **Tolerância de 20% em `scripts/doctor.ps1`.** Achado só acima de `teto × 1.20`, e a mensagem
  passa a dizer o excesso em porcentagem (`"tem 239 linhas (teto 150, 59% acima)"`). Antes
  reprovava por 1 linha.
- **`criterios/ORCAMENTOS.md`** ganhou a seção "A tolerância — o teto é mira, não linha da
  morte", com a procedência acima e o aviso explícito de **nunca somar arquivos distintos**.
- Comentário no `doctor.ps1` repetindo a regra do não-somar, ao lado de `$sempreCarregados` —
  que é justamente onde a tentação de somar aparece.

### Corrige
- `comandos/evolve.md` dizia `✅ passou · SKILL.md 58/60 linhas` numa saída de exemplo. Esse
  "60" **nunca existiu** em `ORCAMENTOS.md` — era número ilustrativo, e me levou a tratar como
  teto real e propor ação por causa dele. Trocado por um exemplo que não inventa limite.
- A mesma seção listava "`SKILL.md` dentro do orçamento?" no auto-doctor. Agora diz o que de
  fato se cobra dele: **continuar só roteando** — instrução de comando mora em `comandos/`.
  Papel, não tamanho.

### Verificação
Três cenários, com o `docs/SPEC.md` de Finanças (teto 150):
- 165 linhas (10% acima) → **nenhum achado**
- 239 linhas (59% acima) → `[Inchaco] docs\SPEC.md tem 239 linhas (teto 150, 59% acima)`
- restaurado para 111 → `OK - nenhum problema mecanico encontrado`

### Nota
A quebra de `REGRAS-DE-NEGOCIO.md` (D008 em Finanças) continua justificada: 587 linhas num teto
de 250 é **135% acima**, muito além de qualquer tolerância. A regra nova não a teria evitado.

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
