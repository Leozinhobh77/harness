# 📖 MANUAL `/harness`

> **Versão 1.13.0** · gerado em **15/08/2026**
>
> 📌 **Este arquivo é a fonte única do manual.** A página publicada é cópia — nunca edite lá.
> Mudou algo? Edite este arquivo e rode `/harness manual --exportar`.
>
> 🌐 Publicado em **https://leozinhobh77.github.io/harness/**
> 📦 Repositório: **https://github.com/Leozinhobh77/harness**

---

## Colinha

```
/harness              onde estamos (10 linhas, barato)
/harness init         criar/adotar a estrutura
/harness doctor       auditar · NUNCA escreve · rode sem medo
/harness fix          corrigir o que o doctor achou
/harness fix --limpar abater o que não se provou útil
/harness voltar       máquina do tempo · desfaz o acidente  🕰️ o dia em que salva
/harness criticar     compara com a referência, às cegas    🔍 sobe a barra
/harness gauntlet     loop até vencer a barra, com freios   🏟️ quando tem orçamento
/harness learn "..."  erro real → guarda permanente        ⭐ o mais valioso
/harness evolve       a skill melhora a si mesma            ⭐ a cada ~2 semanas
/harness upgrade      trazer melhorias da skill pro projeto
/manual-harness       este manual — ENSINA, não executa
/menu-harness         os 12 comandos em lista — ESCOLHE por número e já EXECUTA

Rotina saudável:
  ao criar projeto ......... init
  quando a IA errar ........ learn        ← o hábito que mais paga
  toda semana .............. doctor
  a cada ~2 semanas ........ evolve
```

---

## Índice

| Camada | Seções |
|---|---|
| 🚀 **Começando** | [Visão geral](#1-visão-geral) · [Primeiro projeto](#2-meu-primeiro-projeto) · [Glossário](#3-glossário) |
| 📕 **Referência** | [status](#41-harness--status) · [init](#42-harness-init) · [doctor](#43-harness-doctor) · [fix](#44-harness-fix) · [learn](#45-harness-learn-) · [evolve](#46-harness-evolve-) · [upgrade](#47-harness-upgrade) · [voltar](#48-harness-voltar-) · [criticar](#49-harness-criticar-) · [gauntlet](#410-harness-gauntlet-) |
| 🍳 **Receitas** | [6 situações do dia a dia](#5-receitas) |
| 🔧 **Anatomia** | [Cada arquivo que ele cria](#6-anatomia) |
| 🧠 **Conceitos** | [Flywheel](#71-o-efeito-flywheel) · [5 leis](#72-as-5-leis-anti-inchaço) · [Tiers](#73-tiers-e-a-escada) · [Hooks](#74-hooks) |
| 🚑 **Socorro** | [FAQ e problemas](#8-socorro) |
| 📚 **Evidências** | [Os números e as fontes](#9-evidências) |

---
---

# 🚀 COMEÇANDO

## 1. Visão geral

### O que é um harness

**Harness** é o esqueleto que faz uma IA trabalhar bem no seu projeto. Na prática:

- um **documento** que ela lê ao entrar e que diz como as coisas funcionam ali
- **planos** de trabalho com baixa obrigatória, para nada ficar pela metade sem registro
- **decisões** registradas, para ninguém refazer discussão já resolvida
- **guardas mecânicas** que impedem erro de acontecer — não pedem, impedem

### Por que isso importa mais que o modelo

A frase que resume o consenso de 2026:

> *"Um modelo mediano com um bom harness ganha de um modelo ótimo com harness ruim."*

O mesmo modelo produz resultados dramaticamente diferentes dependendo do sistema em volta. Você
não controla o modelo — controla o harness. É lá que o retorno está.

### O que esta skill faz

| Faz | Não faz |
|---|---|
| Cria a estrutura **dimensionada ao projeto** | Despeja o mesmo pacote em todo mundo |
| Audita se está saudável | Muda nada sem você aprovar |
| Aprende com cada erro real | Escreve regra genérica bonita |
| Melhora a si mesma entre projetos | Cresce sozinha sem limite |

### A tese central

Harness não morre de falta de regra. **Morre de excesso.**

Um documento de 400 linhas que ninguém lê é pior que um de 80 que todo mundo lê — e mede-se
pior, não é opinião (ver [Evidências](#9-evidências)). Por isso metade desta skill existe para
impedir ela mesma de crescer à toa.

---

## 2. Meu primeiro projeto

O passeio completo, do zero ao app rodando:

```
1. /harness init          → investiga a pasta, propõe um tier, pergunta 3 coisas, monta
2. você trabalha normal   → os hooks já estão vigiando em silêncio
3. a IA erra alguma coisa → /harness learn "o que ela fez de errado"     ⭐ o hábito que paga
4. de vez em quando       → /harness doctor  (audita, nunca estraga)
5. a cada ~2 semanas      → /harness evolve  (a skill fica mais esperta)
```

### O que esperar do passo 1

Ele **não** vai te encher de pergunta. Ele olha a pasta primeiro e te diz o que achou:

```
Vejo: pasta vazia · sem git · sem AGENTS.md

Proponho T2 · Padrão.
Por quê: app que você vai usar por meses, com dado financeiro seu, uso solo.
Custo: ~2.500 tokens por sessão.
Dá pra subir depois com um comando — o gatilho aparece sozinho.

Posso rodar git init? (o harness todo se apoia nele para checkpoint e rollback)
```

### A pegadinha

**O passo 3 é o que todo mundo pula** — e é o único que faz o harness ficar bom de verdade. Sem
ele você tem um template bonito que envelhece. Com ele você tem um sistema que aprende.

---

## 3. Glossário

| Termo | O que significa aqui |
|---|---|
| **Harness** | o esqueleto de governança do projeto: documentos + planos + guardas |
| **Tier** | o tamanho do harness (T1 leve · T2 padrão · T3 completo) |
| **Guarda** | um bloqueio mecânico (hook) que impede uma ação errada |
| **Hook** | script que o Claude Code roda automaticamente em certos momentos |
| **Procedência** | o erro real que justifica a existência de uma regra |
| **Deriva** | quando o documento diz uma coisa e o disco diz outra |
| **Abate** | remover uma regra/guarda que não se provou útil |
| **Dar baixa** | atualizar o plano após entregar parte dele (checkbox, status, changelog) |
| **Flywheel** | a regra de que corrigir o documento faz parte da tarefa que errou |
| **Catraca** | o mesmo princípio, com ênfase em "não destrava" |
| **Escada** | a subida/descida de tier conforme o projeto muda |
| **Porta** | um dos 4 momentos de checagem do fluxo de trabalho |
| **DoR / DoD** | Definition of Ready / Done — checklists de entrada e saída de um plano |
| **Orçamento** | o teto de linhas de cada documento |

---
---

# 📕 REFERÊNCIA

## 4.1 `/harness` (status)

O "bom dia" da skill. **Máximo 10 linhas**, barato, não roda auditoria completa.

```
📁 Finanças · tier T2 · harness v1.5.0 · criado 26/07/2026

Estado: 1 plano ativo (0003 — dashboard de filtros, 6/14 tarefas)
Último commit: há 2 dias — "feat: filtro por período customizado"
Saúde: 0 🔴 · 2 🟡     → /harness doctor  para ver
```

Sem harness na pasta, ele te oferece o `init`. Nunca escreve nada.

---

## 4.2 `/harness init`

Cria a estrutura — ou **adota** um projeto que já tem a sua.

### Como funciona

```
1. INVESTIGA   → git? quantos arquivos? linguagem? já tem AGENTS.md?
2. CLASSIFICA  → propõe UM tier e justifica, com o custo em tokens
3. PERGUNTA    → no máximo 3 coisas, em português normal
4. GERA        → só o que aquele tier pede, tudo preenchido de verdade
5. REGISTRA    → anota na memória da skill e roda o doctor no que criou
```

### As 3 perguntas

> *"Isso é um teste rápido ou algo que você vai usar de verdade por meses?"*
> *"Vai guardar dado sensível — dinheiro, dado pessoal, senha?"*
> *"Só você mexe, ou mais gente?"*

Se você já explicou o projeto na conversa, ele **não repergunta** — infere e confirma numa frase.

### As duas perguntas obrigatórias

Essas ele faz **sempre**, em qualquer tier, mesmo no T1:

> *"O que neste projeto nunca pode ser tocado ou commitado?"*
> *"Vai entrar chave, senha ou token?"*

São a única exceção da Lei 1 (procedência): guarda de dado entra preventivamente, porque perder
— ou vazar — dado não tem desfazer.

**A segunda entrou na v1.8.0, e a história dela ensina mais que a regra.** Num projeto real o
usuário avisou que usaria uma chave de API paga. A skill protegeu a chave em quatro lugares
diferentes… e **esqueceu de criar o arquivo onde ela mora**. Foi o usuário quem notou. Proteção
sem o lugar certo para guardar empurra a pessoa a colar o segredo em qualquer canto — que é
exatamente o acidente que a proteção existia para impedir.

Se a resposta for sim, ele gera os dois arquivos:

| Arquivo | O que é | Vai pro git? |
|---|---|---|
| `.env` | onde a chave mora de verdade — nasce **vazio**, com um comentário dizendo onde pegar cada valor | **nunca** |
| `.env.example` | o modelo: os nomes das variáveis, sem os valores | **sim** — é ele que conta ao próximo (ou a você em 3 meses) quais variáveis o projeto precisa |

> ⚠️ **A armadilha do `.gitignore`, que mordeu de verdade.** A regra `.env.*` — que parece a
> coisa certa a escrever — **casa também com `.env.example`**. O modelo ia para o `.gitignore`
> junto com o segredo, e todo projeto nascia sem ele. Por isso o template hoje traz a exceção
> `!.env.example`, e o `doctor --skill` **reprova** qualquer template que volte a esquecê-la.
> Uma regra de proteção larga demais não protege mais: ela come o que não devia.

### A foto de nascimento

No passo 4, logo depois de criar a sombra, o `init` **tira uma foto à mão** — e isso não é zelo.

O hook da sombra só entra em vigor na **sessão seguinte**: o Claude Code lê as configurações
quando a sessão abre. Sem essa foto manual, o projeto atravessaria todo o dia do parto — que é
justamente quando mais se mexe nele — **sem uma única foto**, e o `/harness voltar` não teria
para onde voltar. *Procedência: o `doctor` acusou "Sem sombra" num projeto recém-criado.*

### Modo adoção

Projeto que já tem estrutura **não é sobrescrito**. Ele:
1. roda o doctor no que existe
2. mostra um diff — o que está bom · o que falta · o que está inchado
3. propõe **uma mudança por vez**, com o motivo
4. aplica só o aprovado

Estrutura que você construiu à mão tem valor. Ele **acrescenta a espinha mecânica**, não
substitui seu trabalho.

### A pegadinha

Ele sempre propõe o **menor tier defensável**. Se parecer pouco, é de propósito — subir depois
é um comando, descer depois de inchar é sofrimento.

---

## 4.3 `/harness doctor`

> ⚠️ **NUNCA escreve. Nem um espaço em branco.**

Essa é a regra número um dele e não tem exceção. É o que te permite rodar a qualquer hora,
inclusive no meio de outro trabalho, sem medo. No segundo em que ele começasse a escrever, você
pararia de rodar.

### As 6 famílias de check

| Família | O que caça |
|---|---|
| **Integridade** | link quebrado · plano fantasma no índice · número duplicado · JSON inválido |
| **Deriva** ⭐ | índice ≠ disco · plano parado há 30 dias · `SPEC` que não bate com o código |
| **Inchaço** | documento acima do teto (com 20% de tolerância) · 15+ decisões sem quebrar · custo alto demais |
| **Procedência** ⭐⭐ | regra que não previne erro nenhum · regra genérica · regras que se contradizem |
| **Mecânica** | hooks configurados? rodam? guarda que nunca disparou? |
| **Escada** | o projeto cruzou um gatilho de tier e ainda não subiu? |

### As duas que valem mais

**Deriva** é o modo de falha mais comum e o mais silencioso. Ninguém percebe, e a IA passa meses
trabalhando com um mapa errado.

**Procedência** quase nenhum sistema confere. O teste é uma pergunta:

> *"Se eu apagar esta linha, que erro concreto volta a acontecer?"*

Não sabe responder com um caso real? É candidata a abate.

### A saída

```
🩺 DOCTOR — Finanças · tier T2 · harness v1.5.0 · 06/08/2026

🔴 QUEBRADO (1)
  • Planos/INDICE.md:19 aponta para o plano 0003, que não existe
    → /harness fix

🟡 DERIVA (1)
  • AGENTS.md tem 191 linhas (teto 120, 59% acima)
    → /harness fix  (migra o excedente para docs/SPEC.md)

🔵 OPORTUNIDADE (1)
  • Guarda "bloquear-env" nunca disparou em 90 dias
    → /harness fix --limpar

📊 Custo do harness: ~2.700 tokens/sessão (alvo T2: 2.500) ⚠️
✅ 34 checks passaram
```

### O teto é mira, não linha da morte

Desde a **v1.3.2**, o `doctor` só acusa acima de **teto × 1,20** — e diz o excesso em
porcentagem. Um `AGENTS.md` de 134 linhas num teto de 120 **não vira achado**.

O motivo é prático: sem essa folga, um documento bom com 5 linhas a mais vira "problema", e a
correção proposta é **mutilar texto que presta** para agradar um número. É o inverso do que a
Lei 3 quer. A regra veio de uma correção do usuário, não de teoria — está registrada em
`criterios/ORCAMENTOS.md`.

E **cada arquivo tem o seu teto**. Somar dois documentos diferentes e comparar o total com o
limite de um só é erro de categoria — foi exatamente o erro que originou a regra.

### Modos

| Comando | O que faz |
|---|---|
| `/harness doctor` | tudo |
| `/harness doctor --rapido` | só os checks mecânicos (segundos) |
| `/harness doctor --skill` | roda o doctor **na própria skill** (é o auto-exame) |

### O auto-exame — quando a ferramenta se aponta para si

O `--skill` é o `doctor` virado para dentro: em vez de auditar o seu projeto, audita a skill.
Ele confere parser e ASCII dos scripts · toda rota tem arquivo · todo arquivo está roteado ·
orçamento dos documentos de sessão · a armadilha do `.env.example` · guarda de template sem
procedência (a Lei 1 aplicada contra a própria skill) · e os **satélites**.

**Duas coisas aqui valem mais que a lista.**

A primeira: até a v1.8.0 esse modo estava **documentado e não existia**. O ritual do `evolve`
mandava rodá-lo desde a v1.6.0, e o parâmetro nunca tinha sido implementado — a instrução
mandava executar um comando inexistente, e ninguém notou por duas versões. Foi achado rodando o
próprio ritual. Assim que passou a existir, **ele achou sozinho** um bug de segurança do
template. Instrução escrita não é mecanismo: enquanto ninguém executa, ela é só uma frase bonita.

A segunda: o check dos **satélites** (v1.9.0). Satélite é uma skill-atalho que mora **fora** do
repositório da skill e manda ler arquivo de dentro dele — `/menu-harness` e `/manual-harness` são
os dois. Quando a v1.8.0 abateu um arquivo, a poda passou em tudo que era do repositório e
deixou vivo o satélite, que continuou mandando ler o arquivo apagado. O usuário abriu o menu e a
leitura falhou na frente dele.

> **A lição, que vale para qualquer projeto seu:** *a fronteira da auditoria estava menor que a
> fronteira da dependência.* Tudo que depende de você entra no seu exame — mesmo que não seja
> seu arquivo, mesmo que more em outra pasta.

### A pegadinha

Tudo verde = **uma linha**. Ele não lista os 34 checks que passaram para parecer que trabalhou.

---

## 4.4 `/harness fix`

O braço. O cérebro é o `doctor`. Se ele descobrir um problema novo durante o conserto, ele
**para e reporta** — descoberta é trabalho do doctor.

### Automático × decisão

| Faz sozinho (reversível, sem perda) | Sempre pergunta (perda ou escolha) |
|---|---|
| regenerar `ESTADO.md` | **abater qualquer regra ou guarda** |
| sincronizar `INDICE.md` com o disco | onde migrar conteúdo de doc inchado |
| arquivar plano concluído | apagar documento órfão |
| consertar link com alvo inequívoco | `SPEC` × código divergem: qual está certo? |
| reordenar tabela de índice | subir/descer de tier (isso é `upgrade`) |

### Checkpoint obrigatório

Antes de qualquer escrita ele confere o git. Working tree sujo? Avisa e oferece commitar antes.
Não é repo git? Avisa que não tem desfazer e pede confirmação.

### `--limpar` — o abate

```
/harness fix --limpar
```

Modo dedicado à **descida da escada**. Nunca roda junto com o fix normal — remoção merece
atenção separada. Um candidato por vez:

```
Guarda: bloquear-edicao-env
Criada em: 2026-03-12 · Procedência: "IA editou o .env e vazou chave"
Disparou: 0 vezes em 136 dias
Sugestão: ABATER — o risco original não se materializou nenhuma vez

[m]anter · [a]bater · [p]ular
```

**Nada some de verdade.** Vai para `.harness/abatidos/` com a data. Ressuscitar é barato;
reconstruir do zero não é.

### A pegadinha mais importante

**Guarda de segurança de dado nunca é candidata a abate**, mesmo com zero disparos. Um
`.gitignore` que nunca "disparou" está funcionando perfeitamente — zero disparos é o sucesso
dela, não o fracasso.

---

## 4.5 `/harness learn` ⭐

**O comando mais valioso da skill.** É o *ratchet*: toda falha vira catraca, e catraca não
destrava.

```
/harness learn "a IA marcou o plano como concluído sem rodar o teste"
```

### A pergunta que define tudo

Antes de escrever qualquer coisa, ele pergunta — em voz alta, pra você:

> ### *"Dá para impedir isso mecanicamente?"*

E sobe o máximo que conseguir nesta escada:

| Nível | Solução | Exemplo |
|---|---|---|
| **1** | Impossível de fazer errado | arquivo derivado em vez de escrito à mão |
| **2** | Bloqueia na hora | hook que impede editar dado bruto |
| **3** | Detecta na hora | valida após cada escrita e devolve o erro |
| **4** | Detecta no fim | recusa terminar o turno sem baixa |
| **5** | Texto pedindo por favor | **último recurso** |

Nível 5 é **derrota aceita**, não escolha.

### Se já existia guarda e ela falhou

**Ele conserta aquela. Não empilha outra.**

Essa é a pegadinha mais importante do manual inteiro. Empilhar é como um harness vira monstro:
cada falha vira regra nova, e em 6 meses existem quatro regras dizendo a mesma coisa de jeitos
diferentes — e o modelo obedece **pior**, não melhor, porque instrução redundante compete por
atenção.

Se a guarda existia e não pegou, o problema é **ela**: estava no nível errado, tinha escopo
estreito, ou era texto quando devia ser hook.

### Onde ele registra

| Onde | O quê |
|---|---|
| a guarda em si | com a procedência embutida |
| `docs/DECISOES.md` do projeto | entrada datada: erro, solução, nível |
| `memoria/PADROES.md` da skill | ⭐ é isso que faz a skill aprender entre projetos |

O terceiro transforma um conserto local em conhecimento global.

### E ele testa

Guarda que não foi testada não é guarda, é esperança. Ele reproduz a situação e confirma que
dispara. Se não der pra reproduzir, ele **diz isso** em vez de fingir.

---

## 4.6 `/harness evolve` ⭐⭐

Os outros comandos cuidam dos projetos. Este cuida **da skill**.

É o ciclo mais lento e o mais valioso — o que ela aprender aqui, todo projeto futuro nasce
sabendo. E o mais perigoso: um erro aqui contamina **todos** os projetos futuros. Por isso nada
é automático.

### Os 3 ciclos

```
CICLO 1 — dentro da sessão    ⚡ ms       hook falha → o modelo se corrige na hora
CICLO 2 — o projeto aprende   📅 tarefa   /harness learn → guarda naquele projeto
CICLO 3 — a SKILL aprende     🧬 semanas  /harness evolve → todo projeto futuro nasce sabendo
```

### As 8 etapas

1. **Situação** — versão, última evolução, quantos projetos
2. **Varredura** — roda doctor rápido em cada projeto, coleta os `learn`
3. **Convergência** ⭐ — procura o mesmo problema em projetos **diferentes**
4. **Abate** — obrigatório, não opcional
5. **Pesquisa externa** — o estado da arte mudou?
6. **Auto-doctor** 🪞 — ela roda o próprio exame em si mesma
7. **Propõe** — você aprova por número
8. **Aplica, versiona, registra** — com procedência no changelog

### A regra de promoção

> **≥ 2 projetos independentes.** Um caso é acaso. Dois é padrão.

Isso impede que um projeto barulhento redesenhe a skill inteira.

### A regra que impede o monstro

**Toda rodada é obrigada a olhar para remoção**, não só adição. Se depois de 5 evoluções ela só
cresceu, algo está errado no julgamento — não no mundo.

> A skill tem que **poder encolher**.

---

## 4.7 `/harness upgrade`

`evolve` melhora a **skill**. `upgrade` leva isso para **um projeto**. São separados de
propósito: projeto estável não deve mudar sozinho porque a skill mudou.

```
/harness upgrade              # traz o que a skill aprendeu
/harness upgrade --tier 2+    # sobe de tier
/harness upgrade --tier 2     # desce de tier (raro, mas existe)
```

### Você não precisa sair atualizando seus projetos

Esta é a parte que muda como você trabalha, então vale ler inteira.

**O problema:** você vai ter 20, 30 projetos com harness. Se toda melhoria da skill exigisse
sair aplicando em todos, mexer na skill viraria um dia de manutenção nos outros — o contrário do
que a ferramenta existe para fazer.

**A solução tem nome: `pull` em vez de `push`.**

```
push (errado em escala)              pull (como funciona desde a v1.13.0)

  skill nova                            skill nova
      │                                     │   ← não empurra nada, para ninguém
      ├──► projeto 1                        │
      ├──► projeto 2   ← você, na mão       ▼
      ├──► projeto 3                    cada projeto descobre sozinho,
      └──► projeto 30  ← inviável        no dia em que VOCÊ abrir ele
```

Na prática: quando você abre um projeto atrasado, o `ESTADO.md` dele nasce com este bloco no
topo — e a IA lê isso antes de qualquer coisa:

```
⚠️ ESTRUTURA DESATUALIZADA — 1 pendência(s), 1 de SEGURANCA

Este projeto está na v1.8.0 · a skill instalada está na v1.13.0.

- [SEGURANCA] O matcher do settings.json não encaminhava PowerShell (v1.11.1)

Aplicar: /harness upgrade.
```

**Projeto que você não abrir não paga nada** e fica parado na versão dele. Isso é o certo, não
uma falha — e ficar atrasado de propósito é uma decisão legítima.

**Três detalhes que fazem isso ser útil em vez de chato:**

| Regra | Por quê |
|---|---|
| **Versão diferente não gera aviso** — só pendência real gera | senão todo ajuste da skill incomodaria 30 projetos à toa, e alarme que grita à toa é alarme que você desliga |
| **Confere no disco, não no número** | se você já aplicou a correção à mão, ele cala. O número da versão é indício, não prova |
| **Só interrompe por segurança** | pendência de rotina aparece e não atrapalha o trabalho |

E quando você pedir *"implementa tal coisa"* num projeto com pendência de **segurança**, a skill
avisa **antes** de começar: *"a estrutura está atrasada e tem 1 correção de segurança — aplico
primeiro?"*. Você pode dizer "depois". Ela informa, não obriga.

### A regra mais importante deste comando

> **Customização do usuário sempre vence o template.**

Editou o `AGENTS.md` à mão? Ele **não** sobrescreve. Nunca. Mostra o que mudou no template e
pergunta se quer incorporar.

Um harness que apaga o trabalho do dono no update é um harness que ninguém atualiza nunca mais.

### Subindo de tier

Ele **mostra o gatilho**. Não sobe porque "parece maduro":

> *"O projeto passou a lidar com dado financeiro — gatilho de T2+."*

Depois mostra o custo, gera **só o delta**, e atualiza o manifesto.

### Descendo de tier

Existe, e é saudável. Projeto que virou protótipo de novo não precisa carregar governança de
projeto ativo. Nada é apagado — vai para `.harness/hibernado/`. Voltar é um comando.

**Guarda de segurança de dado nunca desce**, em nenhum tier. É chão, não funcionalidade.

---

## 4.8 `/harness voltar` 🕰️

**A máquina do tempo do projeto.** As outras guardas impedem o erro; esta aceita que um dia um
erro passa, e garante que dá para voltar.

### Por que ela existe (o buraco que ela tapa)

O Claude Code já tem um "Ctrl+Z" nativo — o `/rewind`. Ele é bom: fotografa antes de cada
mensagem sua, guarda as 100 últimas, dura 30 dias. **Mas ele só desfaz o que as ferramentas de
edição fizeram.** O que ele **não** alcança:

| Não volta pelo `/rewind` | Traduzindo |
|---|---|
| Mudança feita por comando de shell | um `rm`, um `mv`, um `>` que sobrescreveu |
| Edição de subagente em segundo plano | agente que trabalha em paralelo |
| Mudança externa | você editando no VS Code ao mesmo tempo |
| Qualquer coisa depois de 30 dias | a sessão expirou |

A própria documentação dele diz: *"não substitui controle de versão"*.

**A sombra cobre exatamente esse buraco — e só ele.** Reimplementar o `/rewind` seria o inchaço
que a Lei 1 proíbe.

### Como funciona

Um repositório git **separado** em `.harness/sombra.git`. Histórico próprio: não polui o seu
`git log`, não entra nos seus commits, não mexe em branch nenhum seu. Ele fotografa em três
momentos:

```
ao abrir a sessão .............. a linha de base do dia
antes de editar um arquivo ..... com pausa de 90s entre fotos
antes de comando destrutivo .... SEMPRE, sem pausa   ← o que o /rewind não pega
```

### Na hora do aperto

```
/harness voltar

🕰️  SOMBRA — Meu Site          14 fotos · 2,3 MB

   1 · há 4 min      antes de: rm -rf dist/           3 arquivos
   2 · há 22 min     antes de editar index.html       1 arquivo
   3 · hoje 09:14    início da sessão                 —

Qual número? (ou "d 2" para ver o que mudou desde a foto 2)
```

**Número 1 é sempre a mais recente** — em pânico, ninguém quer contar de trás pra frente.

Ele **nunca restaura sem mostrar antes** o que vai mudar. E diz a frase que tira o medo:

> *O estado de agora vira foto também, antes de eu mexer. Dá para desfazer isto.*

### O que ele faz e o que não faz

| Faz | Não faz |
|---|---|
| Tira foto do estado atual **primeiro** | ❌ apagar arquivo criado depois da foto |
| Devolve ao disco o conteúdo da foto | ❌ mexer no seu git (branch, commit, stash) |
| Recria arquivo e pasta apagados | ❌ restaurar `node_modules/` — rode o install |
| Lista o que sobrou de novo, pra você decidir | ❌ perguntar duas vezes |

### A pegadinha

**Ela é a única guarda que nasce em todos os tiers, inclusive T1.** Não é funcionalidade de
tier — é chão, como o `.gitignore`. Protótipo é justamente onde ninguém commita, então é onde
perder trabalho dói mais.

E como o `.gitignore`, **nunca é candidata a abate**: zero restaurações é o sucesso dela, não o
fracasso.

---

## 4.9 `/harness criticar` 🔍

**A comparação cega contra uma barra.** Uma rodada, sem loop.

### O problema que ele resolve

Perguntar *"ficou bom?"* para quem acabou de construir não funciona. Quem construiu conhece o
esforço, sabe o que foi difícil, e defende a obra. Não é má-fé — é como atenção funciona.

A saída é estrutural: **quem julga não pode ter visto construir.**

### Como funciona

```
1. PORTÃO DETERMINÍSTICO    build? teste? lint? doctor?
   falhou → PARA. Não se pede opinião estética sobre coisa que nem roda.

2. A BARRA                  lê referencias/INDICE.md
   nenhuma serve → para. Sem barra não há crítica, há opinião.

3. CAPTURA                  página → screenshot de VERDADE
                            código/texto → o arquivo

4. SORTEIA A e B            o mapa de quem é quem nunca vai pro disco

5. CRÍTICO CEGO             subagente · contexto limpo · SÓ LEITURA
   "um é referência profissional, outro é candidato. qual vence?"

6. REPORTA                  venceu/perdeu + UM gap concreto
                            e não conserta nada
```

O passo 1 é o que separa isto de "pedir palpite pra IA". É o mesmo mecanismo que, num estudo de
2026, derrubou amplificação de erro de **1,7% para 0,1%**.

### Não precisa de outra janela

O crítico é um **subagente**: roda na mesma sessão, com janela de contexto própria. Na extensão
do VS Code ele aparece no painel de agentes, e você pode abrir o transcript dele. Um comando, uma
janela.

### Por que binário e não nota

Porque **nota vira alvo**. Mediu-se em 2026 um juiz LLM indo de 0,72 a 0,94 de aprovação
enquanto a acurácia verdadeira ficava parada em 0,20 — o sistema aprendeu a agradar o juiz, não a
melhorar. Decisão binária mais um gap concreto não oferece essa superfície.

### A pegadinha

**Perder é resultado bom.** Um crítico que sempre aprova está sendo educado, não útil. Se três
críticas seguidas vencerem, desconfie da barra — ela provavelmente está baixa demais para
ensinar alguma coisa.

### O que ele deliberadamente NÃO faz

Não roda em loop sozinho. Para o ciclo completo — corrigir o gap, passar pelo portão, criticar
de novo — existe o `gauntlet` (§4.10), que fecha o loop **com freios**. O `criticar` é a rodada
avulsa e barata; o `gauntlet` é a sequência com orçamento.

---

## 4.10 `/harness gauntlet` 🏟️

**O loop até vencer a barra — com os freios que a versão original não tem.**

### De onde veio

Do **Gauntlet Loop** de Matt Shumer (julho/2026): dar ao agente uma barra concreta, separar quem
constrói de quem julga, e iterar até o crítico escolher o nosso às cegas. A ideia é boa. As
implementações públicas, porém, são "pure prompt" — sem portão, sem rollback, sem teto; o único
freio é o usuário lembrar de existir.

E a evidência pede freio: o benchmark da área (**LoopsBench**, 07/2026) mediu **25%** de
resolução na melhor configuração com **regressões em todos os perfis de loop**, e mediu-se juiz
LLM inflando aprovação (0,72→0,94) com a qualidade real parada (0,20). Por isso aqui **cada
freio é um passo obrigatório**, não um conselho.

### Como funciona

```
/harness gauntlet "refazer a home"            # teto padrão: 3 rodadas

cada rodada:
  1. FOTO da sombra          (dá pra voltar a qualquer rodada)
  2. BUILDER corrige SÓ o gap apontado — uma mutação por rodada
  3. PORTÃO determinístico   build · testes · doctor
  4. CRÍTICO CEGO            o mesmo do criticar
  5. VENCEMOS? → fim  ·  PERDEMOS? → o gap vira a próxima rodada
```

### Os cinco freios

| Freio | O que faz |
|---|---|
| 🏆 Vitória | crítico escolheu o nosso às cegas → fim |
| 🔢 Teto | 3 rodadas por padrão — acabou, acabou; você decide se estende |
| 📉 Platô | o MESMO gap voltou duas vezes → para (a 3ª tentativa falha igual) |
| 💥 Regressão | portão quebrou e não consertou → **rollback pela foto** + para |
| 🛑 Você | interrupção manual, a qualquer momento |

### As regras anti-trapaça (fixas, não configuráveis)

- **Uma mutação por rodada.** Nada de "já que estou aqui" — mudança dupla esconde o que causou
  a melhora ou a piora.
- **O builder não vê o transcript do crítico** — só recebe o gap em texto. Histórico de
  julgamento no contexto do builder é o começo do reward hacking.
- **Nunca nota, nunca score em arquivo.** O veredito é binário e morre com a rodada.
- **Nada roda sem o seu OK** — o comando mostra barra, teto e custo, e espera.

### A pegadinha

**Vitória fácil é suspeita.** Se a barra perde de primeira, e não é a primeira vez, a barra
provavelmente está baixa demais para ensinar. Barra que sempre perde não é barra, é plateia.

### Quando usar qual

| Situação | Use |
|---|---|
| quer saber o maior gap | `criticar` — uma rodada, barato |
| quer entregar NO NÍVEL da barra e tem orçamento | `gauntlet` |
| não tem referência | nenhum — monte a barra primeiro |

---
---

# 🍳 RECEITAS

> A camada que quase nenhum manual tem: situação real → o que fazer.

## 5. Receitas

### 🆕 Receita 1 — Começando um app do zero

```
1. crie a pasta vazia
2. /harness init
3. responda as 3 perguntas · autorize o git init
4. peça o PRD:  "vamos escrever o docs/PRD.md"
5. peça a SPEC: "agora a arquitetura, docs/SPEC.md"
6. primeiro plano: "cria o plano 0001 pra <primeira funcionalidade>"
7. aprove o plano → só então o código começa
```

**Por que nessa ordem:** o `init` monta a casa vazia; PRD e SPEC decidem o quê e como; o plano
decide o passo a passo. Código antes disso é chute caro.

**Não pule o passo 7.** Plano aprovado é o que ativa a Porta 1 e os hooks de baixa.

---

### 🏚️ Receita 2 — Herdei um projeto bagunçado

```
1. /harness init          → ele detecta que já existe algo e vira modo ADOÇÃO
2. leia o diff que ele mostra — não aceite tudo de uma vez
3. aceite primeiro só as GUARDAS DE DADO (.gitignore, bloqueios)
4. depois AGENTS.md + ESTADO.md
5. planos e docs por último, conforme a necessidade aparecer
```

**A ordem importa:** guarda de dado primeiro, porque é a única irreversível se der errado.
Documento você escreve depois com calma; dado vazado não volta.

**Não deixe ele reescrever seus documentos existentes.** Se você já tem um README bom, ele
aponta pra ele — não substitui.

---

### 🔁 Receita 3 — A IA vive errando a mesma coisa

Essa é a receita que mais paga. No momento em que o erro acontecer:

```
/harness learn "descreva o erro exatamente como aconteceu"
```

**Descreva o comportamento, não a regra que você quer.**

| ❌ Não diga | ✅ Diga |
|---|---|
| "põe uma regra pra sempre rodar teste" | "ela marcou o plano concluído sem rodar o teste" |
| "ela precisa ser mais cuidadosa com dados" | "ela editou o contacts.csv que é fonte bruta" |

Por quê: se você já entrega a regra pronta, ele vai direto pro nível 5 (texto). Se você entrega
o **comportamento**, ele consegue subir a escada e virar hook — que funciona mesmo quando o
modelo está distraído.

**Se já existe guarda e ela falhou, diga isso.** Ele conserta a guarda em vez de empilhar outra.

---

### 📈 Receita 4 — Meu projeto cresceu, e agora?

```
1. /harness doctor
2. procure na saída a seção 🔵 OPORTUNIDADE
3. se ele citar um gatilho de tier cruzado → /harness upgrade --tier N
4. aprove só o delta que fizer sentido
```

**Não suba de tier por sensação.** Ele só propõe quando um gatilho objetivo foi cruzado:
primeiro bug real · dado sensível entrou · virou multi-módulo · 15+ decisões. Se ele não
propôs, provavelmente não é hora.

**Sinal clássico de que passou da hora:** você começou a explicar a mesma coisa duas vezes pra
IA em sessões diferentes.

---

### 🕰️ Receita 5 — Voltei depois de 2 meses parado

```
1. /harness                 → 10 linhas: onde parou, último commit, plano ativo
2. leia o ESTADO.md         → é gerado, então não mente
3. /harness doctor          → o que apodreceu enquanto você não estava
4. /harness fix             → sincroniza o que dá pra sincronizar sozinho
5. /harness upgrade         → traz o que a skill aprendeu nesse tempo
```

O passo 2 é o que mata a pergunta "onde eu estava mesmo?". Como o `ESTADO.md` é **derivado**
dos planos e do git, ele é impossível de estar desatualizado — ele não é fonte de nada, é uma
vista.

---

### 💰 Receita 6 — Quanto esse harness está me custando?

```
/harness doctor
```

Olhe a linha final:

```
📊 Custo do harness: ~2.700 tokens/sessão (alvo T2: 2.500) ⚠️
```

| Tier | Alvo | Alerta |
|---|---|---|
| T1 | ~500 | > 900 |
| T2 | ~2.500 | > 4.000 |
| T3 ⚠️ | ~5.000 | > 8.000 |

Estourou? São só duas causas possíveis, e o doctor diz qual:
1. o projeto **subiu de tier sem passar pelo gatilho** → desça
2. algum documento **inchou** → `/harness fix` migra o excedente

### O que entra nessa conta (mudou na v1.3.0)

Só os documentos que **carregam em toda sessão**: `AGENTS.md`, `CLAUDE.md` e `ESTADO.md`. O
`SPEC.md`, o `REGRAS-DE-NEGOCIO.md` e o `Planos/MANUAL.md` são leitura **sob demanda** — têm teto
de linha, mas não cobram pedágio por sessão.

Antes o custo somava todo documento com teto e chamava aquilo de custo por sessão. Em Finanças o
número caiu de **~5.213 para ~1.924** tokens/sessão quando a conta foi corrigida: o alarme de
inchaço era, ele próprio, inflado. São duas contas diferentes que tinham o mesmo nome.

---
---

# 🔧 ANATOMIA

## 6. Anatomia

O que o `init` cria, arquivo por arquivo (exemplo: tier T2).

```
MeuProjeto/
├── AGENTS.md              canônico · lido por QUALQUER IA · teto 120 linhas
├── CLAUDE.md              camada fina do Claude Code · teto 40 linhas
├── ESTADO.md              🔄 GERADO · onde o projeto está agora
├── .gitignore             guardas de dado
├── .claude/
│   ├── settings.json      configuração dos hooks
│   ├── agents/
│   │   └── critico-cego.md 🔍 o juiz que não viu construir
│   └── hooks/
│       ├── sombra.ps1        🕰️ FOTOGRAFA antes do risco (todo tier)
│       ├── guarda.ps1        bloqueia ANTES
│       ├── pos-edicao.ps1    valida DEPOIS de cada escrita
│       └── porta-saida.ps1   não deixa ENCERRAR sem baixa
├── docs/
│   ├── GOVERNANCA.md      as 4 portas · permissões · rollback · flywheel
│   ├── PRD.md             o quê e por quê
│   ├── SPEC.md            o como (técnico)
│   └── DECISOES.md        memória: por que as coisas são assim
├── Planos/
│   ├── MANUAL.md          como planejar e dar baixa
│   ├── MODELO-DE-PLANO.md template pra copiar
│   ├── INDICE.md          registro de todos os planos
│   └── Concluídos/        histórico (nunca apagar)
├── referencias/           🔍 A BARRA — o que o projeto quer parecer
│   ├── INDICE.md          o único com conteúdo · leitura sob demanda
│   ├── visual/ personagens/ texto/ documentos/
│   └── dados/ mapas/ audio/ video/
└── .harness/
    ├── manifesto.json     identidade do harness (tier, versão, arquivos)
    ├── guardas.json       ⭐ as guardas como DADO, não como código
    ├── log-guardas.jsonl  📊 registro de cada disparo
    └── sombra.git/        🕰️ as fotos do projeto (fora do seu git)
```

### Os três documentos de topo — a diferença

| Arquivo | Pra quem | Muda com que frequência |
|---|---|---|
| `AGENTS.md` | **qualquer IA** (Cursor, Copilot, Gemini, Codex, Claude) | raramente |
| `CLAUDE.md` | só o Claude Code — notas de ferramenta | raramente |
| `ESTADO.md` | qualquer IA, ao entrar | **toda semana** |

**Por que separados:** informação que muda toda hora dentro de arquivo estático é anti-padrão
nomeado — ele desatualiza e você paga o token dele em toda sessão. Por isso o estado saiu para
um arquivo próprio, **e esse arquivo é gerado**.

### Por que o `ESTADO.md` é gerado

Ele é montado a partir dos `Planos/` + `git log`. Isso mata a deriva na raiz:

> Ele **não é fonte de nada** — é uma vista. Logo, é **impossível** ele divergir da realidade.

Por isso existe uma guarda que bloqueia editá-lo à mão. E desde a v1.7.0 **ele se regenera
sozinho ao abrir a sessão** — o hook `sombra.ps1` roda o gerador antes de tirar a foto do dia.
Antes disso o `doctor` acusava a deriva, ninguém rodava o `fix`, e o alarme virava paisagem (era
assim em 2 dos 3 projetos do registro). Alarme que nunca apaga ensina a ignorar.

Se o arquivo estiver aberto no editor, a escrita falha por lock e o hook segue em silêncio —
nesse caso, `/harness fix` resolve.

**Como o `doctor` sabe que ele está velho — e as duas tentativas erradas antes (v1.3.1).** Ele
**não olha relógio**. Comparar o `mtime` do `ESTADO.md` com o último commit é insatisfazível por
construção: o commit que *contém* o `ESTADO.md` é sempre mais novo que o arquivo, então o check
reclamava para sempre depois de commitar. Excluir o caminho do `git log` também não resolveu —
isso exclui o **arquivo**, não o **commit**, e commitar o `ESTADO.md` junto com qualquer outra
coisa devolvia o mesmo commit.

A pergunta certa não tem relógio nenhum: **regenerar agora daria um arquivo diferente?** O gerador
roda em modo prévia (sem escrever, então o `doctor` continua só lendo) e o conteúdo é comparado.

E compara-se só a parte **estável**: a lista de commits e o status do working tree são
insatisfazíveis por construção — o ato de gerar muda a coisa contra a qual se compara. Alarme que
nunca apaga é pior que alarme nenhum, porque ensina a ignorar.

### `.harness/guardas.json` — a peça mais elegante

As guardas moram aqui **como dado**:

```json
{
  "comandos_proibidos": [
    {
      "nome": "sem-push-force",
      "padrao": "git\\s+push\\s+.*(--force|-f)\\b",
      "motivo": "Reescreve histórico publicado. Não tem desfazer pra quem já baixou.",
      "procedencia": "convergência de 2 projetos independentes (evolve v1.7.0)"
    }
  ]
}
```

> **Repare no que esta guarda NÃO faz: ela não bloqueia `git push`.** Até a v1.6.0 bloqueava — e
> foi abatida em 2 dos 3 projetos, porque neles publicar é o trabalho normal. A lição virou o
> P011: **guarda larga demais não é conservadora, é frágil** — ela não vira mais estreita com o
> uso, ela vira *desligada*. E o abate leva junto a proteção contra a variante que importava.
> A pergunta certa não é *"o que pode dar errado nesta família de comandos?"*, é **"qual variante
> não tem desfazer?"**.

**Guarda nova entra sem ninguém editar script.** O `learn` acrescenta uma entrada aqui, e ela
já está valendo. O campo `procedencia` é obrigatório — é ele que o doctor confere.

### `.harness/log-guardas.jsonl` — a instrumentação

Uma linha por disparo:

```json
{"data":"2026-08-12T02:15:27","guarda":"sem-push-force","acao":"bloqueou","detalhe":"git push --force"}
```

**É isso que transforma "acho que dá pra limpar" em dado.** Guarda com zero disparos em 90 dias
vira candidata objetiva a abate. Sem esse arquivo, limpeza seria chute.

### `.harness/sombra.git` — a rede embaixo do trapézio

Um repositório git **inteiro**, escondido dentro do `.harness/`, com o histórico das fotos do seu
projeto. Ele usa um truque simples: o git aceita separar *onde mora o histórico* de *onde moram
os arquivos*. Assim ele enxerga o projeto todo sem existir um `.git` a mais atrapalhando.

O que isso te dá, comparado a "fazer cópia dos arquivos":

| | Cópia de arquivo | Sombra (git) |
|---|---|---|
| Pega o que o **shell** fez | ❌ | ✅ |
| Suja a árvore do projeto | pasta `.backups/` por toda parte | nada visível |
| Restaurar tudo de uma vez | ❌ | ✅ |
| Ver o que mudou entre dois pontos | ❌ | ✅ |

Ele fica **fora do seu git** (está no `.gitignore`), porque é rede de segurança **da máquina** —
não histórico do projeto. Versionar as fotos duplicaria tudo a cada commit.

Detalhe de desenho que vale saber: o hook que tira as fotos é **autocontido**. Ele não chama a
skill. Se você desinstalar o `/harness` amanhã, o projeto **continua sendo fotografado** — só o
`voltar` (ler e restaurar) é que precisa da skill.

> **A skill demorou a fazer o que exigia dos outros.** Até a v1.9.0 ela cobrava sombra de todo
> projeto que criava e **não tinha a sua** — e era o pior lugar para faltar, porque o `evolve`
> reescreve os arquivos dela em lote, que é exatamente o caso que o `/rewind` não desfaz. Hoje
> ela tem, e na v1.10.0 os satélites também ganharam a deles.
>
> Guardo isso aqui porque a lição é sua também: **a peça que você mais confia é a que ninguém
> lembra de proteger.** Quando for procurar o buraco no seu projeto, comece pelo que parece
> óbvio demais para checar.

### `referencias/` — a categoria que faltava

Todo o resto do harness é sobre o que o projeto **decidiu**. Esta pasta é sobre o que ele **quer
parecer**. É material de entrada, não documento de governança — por isso não mora em `docs/`.

```
referencias/
├── INDICE.md      ← o único com conteúdo · o resto é prateleira
├── visual/        prints, telas, paletas
├── personagens/   consistência de personagem, marca, produto
├── texto/         tom de voz · exemplo bom E exemplo ruim
├── documentos/    PDF, briefing, spec de terceiro
├── dados/         JSON, CSV, esquema de exemplo
├── mapas/         .canvas, diagrama, mapa mental
├── audio/         + companheira .md
└── video/         + companheira .md
```

**Os 3 critérios de entrada** — todos obrigatórios, e é isso que separa referência de arquivo
solto:

| Nomeada | Buscável | Inspecionável |
|---|---|---|
| uma coisa específica | dá pra abrir, ler, rodar | dá pra pôr lado a lado |
| ❌ "design moderno" | ❌ link que não abre | ❌ "elegante" |

**Custo por sessão: zero.** Pasta vazia não custa token; o `INDICE.md` é leitura sob demanda,
igual ao `SPEC.md`. O que carrega sempre é **uma linha** de ponteiro no `AGENTS.md` — medido em
13 tokens.

**Por que a prateleira nasce inteira, mesmo vazia:** *o que não é visto não é lembrado*. Uma pasta
`referencias/` sozinha e vazia não ensina onde as coisas vão; oito pastas nomeadas ensinam. Como
o custo é zero, o único critério que sobra é adoção.

### A regra da companheira — áudio e vídeo

Hoje a IA lê imagem, PDF, markdown, JSON, CSV e `.canvas` direto. **Áudio e vídeo, não.** A regra
resolve os dois sem esperar nada:

```
video/transicao-suave.mp4
video/transicao-suave.md      ← o que tem nele, e o que nele é a barra
```

Hoje ela lê a companheira. Quando passar a ler o arquivo direto, **o arquivo já está lá**. Zero
retrabalho — e essa é a parte que faz valer a pena criar a pasta antes de a capacidade existir.

### A ficha de personagem — a peça mais subestimada

Foto sozinha não garante consistência: ela mostra **um** estado. A ficha diz **o que não pode
mudar entre um estado e outro**.

```markdown
## Invariantes — nunca mudam
- cabelo castanho-escuro, ondulado, altura do ombro
- cicatriz pequena na sobrancelha esquerda

## Variáveis — podem mudar
expressão · ângulo · iluminação · fundo

## Erros já cometidos      ← a seção que faz a ficha ficar boa
- 2026-08-12 — saiu de cabelo liso → virou o invariante "ondulado"
```

A última seção é a **Lei 1 aplicada à referência**: invariante que nasceu de um erro real vale
muito mais que invariante que alguém imaginou. É o mesmo flywheel do `learn`, aplicado a
consistência em vez de guarda.

---
---

# 🧠 CONCEITOS

## 7.1 O efeito flywheel

### A metáfora

**Flywheel** = volante de inércia. Custa muito pra começar a girar, mas depois que gira, cada
volta guarda energia e facilita a próxima.

> **Cada erro corrigido torna aquela classe de erro menos provável — para sempre, em todas as
> sessões futuras.**

O segredo está numa pergunta só: **onde a correção mora?**

### O mecanismo, em 4 passos

```
1. A IA erra
2. Pergunta: o erro foi da IA, ou o harness não dizia?
3. Se o harness era ausente/ambíguo/desatualizado
   → CORRIGIR O DOCUMENTO FAZ PARTE DA MESMA TAREFA
4. Registrar o ocorrido em DECISOES.md
```

O passo 3 é a regra inteira. Não é "anota que depois a gente arruma". É **na mesma tarefa**,
junto com a entrega, ou não conta.

### Por que é a peça mais inteligente

| Sem flywheel | Com flywheel |
|---|---|
| Correção fica no **chat** | Correção vira **documento no repositório** |
| A sessão acaba, o contexto morre | Próxima sessão lê e já sabe |
| Você repete a mesma correção semana que vem | Você **nunca mais** repete |
| Erro nº 40 tão provável quanto o nº 1 | Classes inteiras já eliminadas |

Sem flywheel, **você** é a memória do projeto — e memória humana não escala. Daqui a 3 meses
você mesmo não vai lembrar por que decidiu aquilo.

Com flywheel, **o projeto carrega a própria memória**. É a diferença entre treinar um estagiário
novo toda segunda e ter um manual escrito pelos estagiários anteriores.

### Um exemplo real

De um projeto real, decisão D011:

> Ao testar um plano, um arquivo com dados de cliente foi parar num caminho **dentro do
> repositório** que o `.gitignore` não cobria. Apareceria como untracked e podia entrar num
> commit — vazando o telefone de mais de mil clientes.

O que aconteceu, seguindo a regra:

1. ❌ Não esperou o usuário pedir
2. 🔧 Corrigiu o `.gitignore` **na mesma tarefa**, antes de qualquer `git add`
3. 📝 Registrou a D011 explicando o gap e a correção
4. ✅ Nenhum dado chegou a ser commitado

O harness pegou uma falha **do próprio harness** e se consertou. É o volante girando.

### O nome no mercado: Ratchet Principle

Addy Osmani (Google) chama de **princípio da catraca**:

> *"Trate toda falha do agente como sinal permanente. Cada restrição deve rastrear até algo
> específico que deu errado."*

Catraca acrescenta uma propriedade que "flywheel" não tem: **não destrava.** Uma vez que subiu
um dente, não desce. Flywheel acumula energia; catraca não perde o que ganhou.

### ⚠️ Onde o flywheel clássico para

O flywheel tradicional **só produz texto**:

```
erro → parágrafo novo no AGENTS.md → torcer pra IA ler e obedecer
```

Melhor que nada, mas depende do modelo **ler, lembrar e obedecer** — nas três, sempre. Às vezes
não obedece, e o volante gira em falso. Pior: cada erro vira parágrafo, e em 6 meses o documento
tem 300 linhas competindo por atenção. **O flywheel começa a atrapalhar a si mesmo.**

### Como o `learn` conserta isso

```
erro → "dá pra impedir mecanicamente?"
         │
         ├─ SIM → vira HOOK. Funciona mesmo se o modelo não ler.    ⚡
         │        E o AGENTS.md não engorda uma linha.
         │
         └─ NÃO → vira texto, com procedência anexada.              📝
                  (derrota aceita, não escolha)
```

**Aconteceu ao vivo na construção desta skill:** um `.ps1` foi escrito com erro de sintaxe e
acento. Um hook barrou em milissegundos, sem revisão humana. Virou o padrão **P001** — e note o
que **não** aconteceu: nenhuma regra escrita dizendo "lembre-se de usar ASCII". Virou um check
automático. O flywheel girou **sem custar uma linha de documento**.

### O freio: Lei 4

Flywheel sem freio é bola de neve. Cada erro vira regra, nenhuma sai nunca, e em um ano ninguém
lê o documento inteiro. Foi o que começou a acontecer no projeto que serviu de diagnóstico:
**18 decisões, nenhuma jamais podada.**

```
📈 Flywheel  = sobe por erro real       (a energia entra)
📉 Abate     = desce por desuso         (o freio, via log-guardas.jsonl)
```

Sem os dois, você tem ou um sistema que não aprende, ou um que se sufoca.

### Em uma frase

> Flywheel é a regra de que **a correção mora no repositório**, não na sua cabeça nem no chat.
> A `/harness` acrescenta duas coisas: tenta virar **guarda mecânica** antes de virar texto, e
> **poda** o que não se provou útil.

---

## 7.2 As 5 leis anti-inchaço

Estão em `CONSTITUICAO.md` e valem inclusive para mudanças na própria skill.

| # | Lei | Em uma frase |
|---|---|---|
| **1** | **Procedência obrigatória** | regra sem erro real que a justifique não entra |
| **2** | **Mecânico vence escrito** | dá pra ser hook? então não é texto |
| **3** | **Orçamento é lei** | cada doc tem teto de linhas, e estourar reprova |
| **4** | **Pressão de abate** | pra entrar regra, avalie se tirar outra não é melhor |
| **5** | **O menor tier que serve** | na dúvida entre dois, é o menor |

### Lei 1 — por que é tão dura

Regra genérica **não é neutra**. Mediu-se em 2026: `AGENTS.md` gerado por LLM (cheio de regra
plausível tipo "escreva código limpo") **piorou a taxa de sucesso em 5 de 8 cenários**, somando
2,45–3,92 passos extras por tarefa.

O modelo já sabe escrever código limpo. Dizer isso só ocupa atenção que ele usaria pra entender
o que é específico do **seu** projeto.

**Exceção única:** guardas de segurança de dado entram preventivamente. Perder dado não tem
desfazer.

### Lei 2 — a ordem de preferência

```
1. Impossível de fazer errado (estrutura)
2. Erro bloqueado na hora (hook)
3. Erro detectado na hora (validação)
4. Erro detectado no fim (Stop hook)
5. Texto pedindo educadamente        ← último recurso
```

E a razão é velocidade de retorno:

```
PostToolUse (ms) > pre-commit (s) > CI (min) > você percebendo (∞)
```

### Lei 3 — o número

Arquivo de instrução acima de ~150 linhas aumenta o custo de inferência em **20–23% sem ganho
nenhum de performance**. Documento que passa do orçamento não está informando — está cobrando
pedágio.

**Estourou não significa cortar informação.** Significa **mudar de lugar**: migra pro documento
de profundidade e deixa um ponteiro. Nunca duplique parágrafo entre documentos.

**Duas ressalvas que a lei aprendeu na prática (v1.3.2):**

1. **O teto tem 20% de folga.** Ele é mira, não linha da morte. Passar um pouco não é achado —
   senão o número passa a mandar no conteúdo e a "correção" vira mutilar texto bom.
2. **O teto é por arquivo.** Nunca some dois documentos com funções diferentes para comparar com
   um limite de arquivo único. A medição que embasa os números é por arquivo.

### Lei 4 — o critério objetivo

Nunca é chute:
- guarda que **nunca disparou** em 90 dias
- regra **sem procedência**
- decisão **superada** por outra
- documento que **nenhum outro referencia**

### Lei 5 — por que conservador

O jeito mais fácil de estragar um projeto pequeno é dar a ele governança de projeto grande.
Governança que não serve é atrito puro — e atrito faz você abandonar o processo inteiro.

---

## 7.3 Tiers e a escada

| Tier | Quando | O que ganha | Custo/sessão |
|---|---|---|---|
| **T1 · Leve** | script, protótipo, POC | `AGENTS.md` (~40 linhas) + `.gitignore` + 🕰️ sombra | ~500 tokens |
| **T2 · Padrão** | app pessoal real | + estado, governança, PRD/SPEC, decisões, planos, +3 hooks | ~2.500 |
| **T2+** | ...que mexe com dinheiro ou dado sensível | + testes de regra de negócio | +variável |
| **T3 · Completo** ⚠️ | multi-módulo, mais de uma pessoa | + auditor cego, `AGENTS.md` aninhado, guardas extras | ~5.000 |

⚠️ **O T3 está projetado, ainda não implementado.** Não existe template T3 nem comando que o
monte — nenhum projeto chegou perto do gatilho, e construir sem caso concreto seria palpite
(Lei 1). Hoje a skill entrega **T1, T2 e T2+**.

### Os gatilhos de subida

**A estrutura não sobe por tempo nem por vontade. Sobe por evento real.**

| Subida | Gatilho (qualquer um basta) |
|---|---|
| **T1 → T2** | primeiro plano criado · 3+ arquivos de código · você disse "continua de onde parou" |
| **T2 → T2+** | primeiro bug real que chegou ao uso · dado sensível entrou · regra que, se quebrar, você só descobre tarde |
| **T2+ → T3** ⚠️ | virou multi-módulo · outra pessoa passou a mexer · 15+ decisões registradas — o gatilho é **registrado**, mas não há subida para aplicar (ver ⚠️ acima) |

### A descida — o que quase nenhum sistema tem

| Descida | Critério objetivo |
|---|---|
| Guarda abatida | zero disparos em 90 dias |
| Regra abatida | sem procedência |
| Decisão arquivada | superada por outra |
| Documento abatido | nenhum outro aponta pra ele |

```
📈 Sobe por gatilho (evento aconteceu)
📉 Desce por desuso (não se provou)
```

**Sem a descida, é questão de tempo até virar monstro.** Quem propõe: `doctor`. Quem aplica:
`fix --limpar`. Quem decide: **você, sempre**.

---

## 7.4 Hooks

A espinha mecânica. Quatro, todos testados funcionando. **Três impedem o erro; o quarto aceita
que um dia um erro passa.**

| Hook | Evento | Quando dispara | O que faz | Tier |
|---|---|---|---|---|
| **`sombra`** 🕰️ | `PreToolUse` · `SessionStart` | antes do risco | **fotografa** o projeto | todos |
| **`guarda`** | `PreToolUse` | antes de escrever/rodar | **bloqueia** o proibido | T2+ |
| **`pos-edicao`** | `PostToolUse` | depois de cada escrita | valida e **devolve o erro pro modelo** | T2+ |
| **`porta-saida`** | `Stop` | ao tentar encerrar | **não deixa fechar** com plano sem baixa | T2+ |

### `sombra` — a rede de segurança

Fotografa antes de cada ação de risco, com atenção especial ao **comando de shell** — que é
justamente o que o `/rewind` nativo não desfaz. Ver [§4.8](#48-harness-voltar-).

> **Nunca bloqueia. Nunca.** Sai com sucesso em qualquer situação, inclusive erro. Uma rede de
> segurança que trava o trabalho é desligada na primeira semana — e aí não protege mais nada.

### `guarda` — bloqueia antes

Lê `.harness/guardas.json` e barra arquivo protegido ou comando proibido. Testado: barrou
`git push`, barrou edição do `ESTADO.md`, liberou `AGENTS.md`.

> 🚨 **Correção de segurança — se o seu projeto é anterior a 15/08/2026, rode `/harness upgrade`
> nele.** A guarda escutava só a ferramenta `Bash`. No Windows a maioria dos comandos passa pelo
> **PowerShell** — ou seja, `git reset --hard` por lá **nunca foi bloqueado**, em nenhum projeto,
> desde que a guarda existe.
>
> **Por que isso é pior que não ter guarda nenhuma:** um mecanismo meio ligado *produz sensação
> de proteção* — e o log ainda mostrava disparos, pelo caminho do Bash, o que confirmava a
> sensação. Você confia e baixa a atenção justamente onde não está coberto. É o padrão `P012`.

### O detalhe que fez essa correção demorar dois dias a mais

Vale ler devagar, porque é o erro mais fácil de cometer em qualquer sistema com hooks.

Um hook passa por **duas portas** até agir:

```
ferramenta usada  →  [ matcher ]  →  hook é chamado  →  [ código do hook ]  →  bloqueia
                          ↑                                     ↑
                  quem decide SE ele roda              quem decide O QUE fazer
                  (settings.json)                      (guarda.ps1)
```

A v1.8.0 corrigiu **o código** (`^(Bash|PowerShell)$`) e parou por aí. O **matcher** continuou
`"Write|Edit|NotebookEdit|Bash"` — então a ferramenta PowerShell **nunca era encaminhada** ao
hook, e a linha corrigida jamais rodou. Guarda certa, do lado de dentro de uma porta fechada.

> **A lição, e ela serve para o seu projeto:** *o alcance de uma guarda é o do seu ponto mais
> estreito — e o ponto mais estreito quase nunca é o código, é o registro que decide se ele é
> chamado.* Quando consertar uma proteção, confira **as duas portas** antes de dar por resolvido.

Corrigido de verdade na **v1.11.1** (15/08/2026), no template e nos quatro projetos existentes.

**E na v1.12.0 você não precisa mais lembrar disso.** O `doctor` passou a conferir a porta: se
algum hook do seu projeto escutar `Bash` sem `PowerShell`, ele acusa 🔴 **dizendo qual hook**. O
auto-exame faz o mesmo nos templates, para projeto novo não nascer com o buraco.

> Repare no padrão, porque é o coração desta ferramenta: o erro aconteceu, doeu, virou lição
> escrita — e só ficou **resolvido** quando virou uma linha de código que confere sozinha. Lição
> escrita você esquece de aplicar. É a Lei 2 no osso. Mesmo erro, outra peça.

### `pos-edicao` — o retorno mais rápido que existe

Roda depois de cada Write/Edit e devolve o problema pro modelo, que se corrige antes de seguir.
Hoje confere: JSON válido · sintaxe e ASCII em `.ps1` · orçamento de linhas em markdown.

### `porta-saida` — a Porta 3 virando lei

Só segura com **evidência clara**: existe plano em andamento **e** arquivo de código foi
alterado depois da última baixa. Tem trava anti-loop.

> **Conservador de propósito.** Um Stop hook que dispara à toa é insuportável, e aí você desliga
> o harness inteiro. Melhor deixar passar um caso duvidoso do que irritar.

### A pegadinha

Se um hook te barrar, **ele provavelmente está certo**. Na construção desta skill, a armadura da
Forge barrou duas vezes — e nas duas o problema era o código, não a guarda.

---
---

# 🚑 SOCORRO

## 8. Socorro

### Perguntas frequentes

**O doctor pode estragar meu projeto?**
Não. Ele nunca escreve. Nem um espaço em branco. Pode rodar a qualquer hora.

**Preciso rodar isso toda hora?**
Não. `learn` quando a IA errar, `doctor` de vez em quando. Só.

**E se eu editei os arquivos à mão?**
Sua edição vence. O `upgrade` nunca sobrescreve customização — mostra o lado a lado e pergunta.

**Serve pra projeto que já existe?**
Serve. O `init` detecta e vira modo adoção: audita o que tem e propõe melhoria por melhoria.

**Qual a diferença entre `/manual-harness` e `/menu-harness`?**
O manual **ensina** — você escolhe um tópico e ele explica a fundo, com exemplo. O menu
**lança** — mostra os 12 comandos com uma descrição de uma linha cada, e escolher um número já
executa aquele comando. Use o manual pra entender; o menu pra agir.

**O menu não mostrava a data do último uso de cada comando?**
Mostrava, e foi **abatido na v1.8.0** — de propósito. A skill pedia por escrito que o agente
registrasse cada execução, e isso simplesmente não acontecia: o `criticar` rodou duas vezes num
dia e continuou aparecendo como *"nunca usado"*. O problema não era a falta do recurso — era o
menu **não dizer "não sei"** e dizer *"nunca usado"* com confiança sobre um comando usado horas
antes. **Dado errado é pior que dado nenhum**: o `evolve` chegou a abrir uma investigação sobre
um comando "nunca usado", investigando o instrumento achando que era o mundo. Se um dia houver
como registrar mecanicamente, volta.

**Se a IA apagar um arquivo meu, dá pra recuperar?**
Dá — é pra isso que a sombra existe. `/harness voltar` lista as fotos e devolve o arquivo, a
pasta, ou o conteúdo sobrescrito. Funciona inclusive quando o estrago veio de um comando de
shell, que é o caso em que o `/rewind` nativo do Claude Code **não** consegue ajudar.

**Então a sombra substitui o `/rewind`?**
Não, e nem tenta. O `/rewind` é mais rápido para desfazer edição dentro da conversa. A sombra
cobre o que ele não alcança: comando de shell, subagente em segundo plano, e o que passou de 30
dias. Use o `/rewind` no dia a dia; o `voltar` quando ele não der conta.

**Ela ocupa muito espaço?**
Pouco — o git guarda só a diferença entre as fotos. Nos projetos de teste ficou entre 0,1 e 1,5
MB. O `doctor` avisa se passar de 300 MB, e `/harness voltar --limpar` compacta sem apagar foto
nenhuma.

**O crítico precisa de outra janela aberta?**
Não. Ele é um **subagente**: roda na mesma sessão, com janela de contexto própria, e aparece no
painel de agentes da extensão do VS Code. Um comando, uma janela.

**Por que o crítico usa um modelo diferente do que construiu?**
Porque viés de auto-preferência é medido: modelo tende a favorecer saída da própria família. E
comparar é mais barato que criar. Mas a variável **menos** importante aqui é o modelo — o que faz
funcionar é o contexto limpo, a cegueira e o portão determinístico antes.

**A pasta `referencias/` vazia não é inchaço?**
Não, e a conta é literal: pasta vazia custa **zero token**, e o `INDICE.md` é leitura sob
demanda. O que carrega em toda sessão é uma linha de ponteiro — 13 tokens medidos. A Lei 3 cobra
documento que carrega sempre; nada aqui carrega.

**Por que o `criticar` não roda em loop sozinho?**
Porque loop é decisão de orçamento, e ela é sua. Quando você quer o ciclo completo, existe o
`gauntlet` (§4.10) — que roda o loop **com freios**: portão determinístico entre rodadas, foto
da sombra antes de cada mutação, parada por platô, teto de rodadas, e seu OK antes de começar.

**Qual a diferença entre o `gauntlet` daqui e o Gauntlet Loop original?**
Os freios. A versão "pure prompt" não tem portão, rollback nem teto — o único freio é o usuário.
A evidência que pede freio: LoopsBench (07/2026) mediu **25%** de resolução com regressões em
todos os perfis de loop, e juiz LLM sem portão infla aprovação (0,72→0,94) com a qualidade real
parada (0,20). Aqui cada freio é um passo obrigatório do fluxo.

**Por que ela insiste tanto em ser pequena?**
Acima de ~150 linhas o custo sobe 20–23% sem ganho medido, e regra genérica chega a **piorar** o
resultado. Enxuto não é estética, é performance.

**Como eu apago tudo?**
Apague a pasta `.harness/` e os documentos. Nada fica escondido no sistema — o harness inteiro
mora dentro do seu projeto.

**Funciona com outras IAs além do Claude?**
Os documentos sim (`AGENTS.md` é padrão aberto). Os hooks são específicos do Claude Code — em
outra ferramenta você fica só com a camada de texto.

---

### Problemas

#### 🚫 "Um hook me barrou e eu acho que ele está errado"

```
1. LEIA a mensagem — ela diz qual guarda e qual o motivo
2. Se a guarda estiver errada mesmo:
   /harness learn "a guarda X barrou <situação legítima>"
   → ele conserta a guarda, não empilha outra
3. Emergência: edite .harness/guardas.json e remova a entrada
```

**Antes de contornar, considere que ele pode estar certo.** É o caso mais comum.

#### ❓ "O doctor acusa deriva e eu não entendo"

Deriva = o documento diz uma coisa, o disco diz outra. Pergunte:

```
"me explica essa deriva e me mostra os dois lados"
```

Ele mostra o que o documento afirma e o que o código realmente faz. **Você** decide qual está
certo — essa decisão nunca é automática.

#### 🔇 "Quero desligar um hook temporariamente"

Edite `.claude/settings.json` e comente/remova a entrada dele. Mas:

> Se você está desligando o mesmo hook toda semana, **o hook está errado** — não o seu
> comportamento. Rode `/harness learn` e conserte de vez.

#### ♻️ "Meu ESTADO.md está errado"

Não edite à mão (a guarda vai barrar, e com razão). Rode:

```
/harness fix
```

Ele regenera a partir dos planos e do git. Se **ainda** estiver errado, o problema está nos
planos — provavelmente algum sem baixa.

#### 📉 "O harness ficou caro demais"

```
/harness doctor            → mostra o custo e a causa
/harness fix               → migra excedente de documento inchado
/harness fix --limpar      → abate o que não se provou útil
/harness upgrade --tier 2  → desce de tier se subiu cedo demais
```

#### 🗑️ "Quero desinstalar"

Apague `.harness/`, `.claude/hooks/`, e os documentos que não quiser manter. `AGENTS.md` vale a
pena manter mesmo sem a skill — é padrão aberto e qualquer IA lê.

---
---

# 📚 EVIDÊNCIAS

## 9. Evidências

> Por que confiar nas regras em vez de decorar. Levantamento de julho/2026.

### Os números que moldaram o desenho

| Achado | Consequência no desenho |
|---|---|
| Arquivo de instrução **> ~150 linhas**: custo de inferência **+20–23%**, sem ganho de performance | **Lei 3** — orçamento por documento |
| `AGENTS.md` **gerado por LLM**: piora a taxa de sucesso em **5 de 8 cenários**, +2,45–3,92 passos por tarefa | **Lei 1** — procedência obrigatória |
| *"Prompting instead of enforcing"* é o **anti-padrão nº 1** de harness | **Lei 2** — mecânico vence escrito |
| Velocidade de retorno: **PostToolUse (ms) > pre-commit (s) > CI (min) > humano (∞)** | os 3 hooks, com ênfase no `pos-edicao` |
| **Agentes dão nota boa ao próprio trabalho** (self-evaluation bias) | auditor separado no T3 |
| Memória de agente escala com **progressive disclosure** (índice barato → fatia → documento) | `DECISOES.md` com índice; quebra aos 15 |
| **Prosa apodrece; teste não** — inclua artefatos executáveis e ADRs, exclua prosa descritiva | tier T2+ com regra de negócio virando teste |

### O princípio que resume tudo

> *"Um modelo mediano com um bom harness ganha de um modelo ótimo com harness ruim."*
> — Addy Osmani

> *"Os melhores harnesses não são frameworks baixados de um fornecedor — são moldados pelo seu
> histórico específico de falhas."*

Essa segunda frase é o motivo de o `learn` existir, e de esta skill nascer **enxuta** em vez de
completa: ela deve crescer a partir dos **seus** erros, não dos meus palpites.

### Fontes

- [Agent Harness Engineering — Addy Osmani](https://addyosmani.com/blog/agent-harness-engineering/)
- [Harness Engineering Best Practices 2026 — Sakasegawa](https://nyosegawa.com/en/posts/harness-engineering-best-practices-2026/)
- [Harness Engineering — Software Mansion](https://agentic-engineering.swmansion.com/becoming-productive/harness-engineering/)
- [AGENTS.md Best Practices (2026) — Betterclaw](https://www.betterclaw.io/blog/agents-md-best-practices)
- [Context Engineering — Sourcegraph](https://sourcegraph.com/blog/context-engineering)
- [The Agent-Native Repo — Harness.io](https://www.harness.io/blog/the-agent-native-repo-why-agents-md-is-the-new-standard)
- [GitHub Spec-Kit](https://github.com/github/spec-kit)
- [State of AI Agent Memory 2026 — Mem0](https://mem0.ai/blog/state-of-ai-agent-memory-2026)
- [Claude Code Hooks: Production Playbook — Totalum](https://www.totalum.app/blog/claude-code-hooks-totalum)
- [AGENTS.md Advanced Patterns: Nested Hierarchies](https://codex.danielvaughan.com/2026/03/26/agents-md-advanced-patterns/)

---

## Histórico deste manual

| Versão | Data | O que mudou |
|---|---|---|
| **1.13.0** | **2026-08-15** | **Pull em vez de push: o projeto descobre sozinho** 📡 — correção de rumo pedida pelo usuário, e das que mudam a arquitetura. Eu tinha acabado de patchear 4 projetos na mão; ele apontou o que isso vira com 30: *"eu tô aqui só para atualizar a skill"*. Agora a skill **nunca empurra nada** — publica o que mudou em `memoria/MIGRACOES.json`, e cada projeto descobre **no dia em que você abrir ele**, pelo bloco de pendências no `ESTADO.md` e pela família `Migracao` do `doctor`. **O canal já existia** (o hook da sombra já chamava o gerador do `ESTADO.md`), então o aviso custou **zero arquivo novo dentro dos projetos** — e isso resolveu um ovo-e-galinha: hook novo só chegaria por migração, que é o que ele deveria anunciar. Três regras contra virar ruído: silêncio é o padrão · confere no disco, não no número · só interrompe por segurança. |
| **1.12.0** | **2026-08-15** | **A porta do hook entrou no exame** 🔌 — a v1.11.1 consertou os 4 projetos à mão; esta rodada impede que volte. O `doctor` passou a conferir o **`matcher`** — a peça que decide se o hook é chamado — em duas camadas: no seu projeto (🔴 **nomeando o hook** afetado) e nos templates T1/T2 (para projeto novo não nascer torto). Sem a segunda, consertar os existentes seria enxugar gelo. A regra é genérica — *"quem escuta `Bash` tem de escutar `PowerShell`"* — e não comparação com a string exata do template, que quebraria em qualquer customização legítima e viraria alarme falso. **Alargou o check que já existia**, não empilhou família nova. O `P012` sobe de nível 5 para 3. |
| **1.11.1** | **2026-08-15** | **A correção de segurança da v1.8.0 nunca tinha rodado** 🩸 — o que era para ser um `upgrade` de rotina nos 4 projetos virou achado. A v1.8.0 corrigiu o **código** do `guarda.ps1` e não corrigiu o **`matcher`** do `settings.json`, que é quem decide se o hook é chamado: por dois dias, em todos os projetos, `git reset --hard` por PowerShell continuou passando, e comando destrutivo por lá não gerava foto da sombra. **Guarda certa, do lado de dentro de uma porta fechada.** Corrigido no template (T1 e T2) e nos quatro projetos, com foto da sombra antes e `doctor` depois. Registrado como **segunda camada do `P012`**: *o alcance de uma guarda é o do seu ponto mais estreito, e o ponto mais estreito quase nunca é o código.* Achado por leitura arquivo a arquivo — nenhum mecanismo pegou. |
| **1.11.0** | **2026-08-14** | **Este manual saiu da 1.7.0 e o atraso virou guarda** 📖 — auditoria completa das quatro rodadas que ele tinha perdido (1.8.0 → 1.10.0). Corrigido o que **mentia**: a colinha e o FAQ anunciavam a coluna "último uso" do menu, abatida na 1.8.0, e diziam "10 comandos" quando são 12. Acrescentado o que **faltava**: a segunda pergunta obrigatória do `init` (credencial) com a armadilha do `.env.example`, a foto de nascimento da sombra, o auto-exame `--skill` e o check dos satélites, e o aviso de segurança do `P012`. **E o ciclo fechou:** o `exportar` *pedia por escrito* que se conferisse o carimbo antes de publicar — pedido é exatamente o que a Lei 2 proíbe no lugar de mecanismo, e foi assim que o manual passou 4 versões atrasado. Agora o auto-exame confere sozinho: carimbo do manual **e** da página contra o `VERSAO.json`, e todo comando que existe está documentado. |
| **1.10.0** | **2026-08-14** | **A sombra alcança os satélites** 🌒 — `/menu-harness` e `/manual-harness` moram fora do repositório da skill e eram o único pedaço do sistema **sem volta**: um arquivo cada, sem git, sem foto. Agora cada um tem a sua sombra, alimentada pela sessão da skill (hook só dispara na pasta onde a sessão abriu — então a rede fica onde a mão passa, não onde o objeto está). **Buraco achado de raspão:** o gatilho listava `Bash` e esquecia `PowerShell`, o shell principal do Windows — comando destrutivo por lá não gerava foto nenhuma desde que a sombra nasceu. O código já tratava o caso; a ferramenta é que nunca chegava nele. **P016:** comparar caminho como texto — o Windows tem duas grafias para a mesma pasta (`Usuário` e `USURIO~2`), e a guarda se desligava sozinha, em silêncio, com `exit 0`. |
| **1.9.0** | **2026-08-14** | **A skill adota o próprio harness** 🛰️ — ela exigia sombra de *todo* projeto que cria e não tinha a sua, justamente onde o risco é maior: o `evolve` reescreve arquivos em lote, que é o caso que o `/rewind` nativo não desfaz. Adoção, não despejo de template: os papéis já existiam sob nomes próprios (`SKILL.md`+`CONSTITUICAO.md` fazem o `AGENTS.md`), então só entrou a espinha mecânica que faltava. **Check novo:** o auto-exame passou a enxergar os **satélites** — as skills-atalho que moram fora do repositório e apontam para dentro dele. Procedência: o menu mandava ler um arquivo abatido na 1.8.0 e o `Read` falhou na frente do usuário. *A fronteira da auditoria estava menor que a fronteira da dependência.* |
| **1.8.0** | **2026-08-13** | **O `evolve` que nasceu de um projeto construído do zero** 🧬 — um jogo 3D criado só para testar a skill expôs em um dia quatro defeitos que três semanas nos outros projetos não revelaram. **Segurança:** a guarda cobria só `Bash`, e no Windows quase tudo passa pelo PowerShell — `git reset --hard` por lá nunca foi bloqueado, em nenhum projeto (`P012`). **Segurança:** a regra `.env.*` do template engolia o próprio `.env.example`, e todo projeto com credencial nascia sem o modelo. **Buraco:** o `init` não tirava a foto de nascimento da sombra, e o projeto passava o dia do parto sem nada para onde voltar. **Existia só no papel:** `doctor --skill` estava documentado desde a 1.6.0 e nunca tinha sido implementado. **Abatido (`P013`):** o `uso.json` e a coluna "último uso" — a skill *pedia* que o agente registrasse cada execução, não acontecia, e o menu dizia "nunca usado" com confiança sobre comando usado horas antes. **Dado errado é pior que dado nenhum.** |
| **1.7.0** | **2026-08-12** | **Primeira rodada completa de `evolve`** 🧬 — a skill varreu os 3 projetos, achou convergência real, promoveu, abateu e passou no próprio doctor. **Promovido:** `sem-push` sai do template, `sem-push-force` entra — dois projetos independentes rejeitaram a guarda larga em datas e por motivos diferentes (P011: *guarda larga demais não é conservadora, é frágil — vira desligada, e o abate leva junto a proteção que importava*). **Promovido:** o `ESTADO.md` passa a se regenerar sozinho no início da sessão (Lei 2 — o `doctor` acusava a deriva em 2 de 3 projetos e ninguém rodava o `fix`). **Abatido:** `templates/T3-completo/` deixou de existir — tinha um arquivo só, e nem era do T3; `REGRAS-DE-NEGOCIO.md` foi para `comum/`, onde o T2+ o alcança. **Observado sem mexer:** `learn` marca "nunca usado" e mesmo assim guarda customizada nasceu em 2 projetos — investigar no próximo uso real. |
| **1.6.0** | **2026-08-12** | **O loop com freios: `/harness gauntlet`** 🏟️ — fecha o ciclo que o `criticar` deixou aberto: builder corrige o gap → portão determinístico → crítico cego → repete, até vencer a barra ou um freio parar. Os cinco freios são passos obrigatórios, não conselhos: vitória · teto de rodadas (padrão 3) · **platô** (mesmo gap 2× → para) · **regressão** (portão quebrou → rollback pela foto da sombra + para) · você. Anti-reward-hacking fixo: uma mutação por rodada, builder nunca vê o transcript do crítico, nunca nota nem score em arquivo, nada roda sem OK explícito. Zero mudança nos projetos — todas as peças (crítico, sombra, portão, barra) já existiam das v1.4–1.5. |
| **1.5.0** | **2026-08-12** | **A barra: `referencias/` e o crítico cego** 🔍 — o harness ganha uma categoria que não tinha: **material de entrada** (o que o projeto quer parecer), separado de documento de governança (o que ele decidiu). Prateleira de 8 pastas + `INDICE.md` com os 3 critérios de entrada (**Nomeada · Buscável · Inspecionável**) + ficha de consistência de personagem. Comando novo `/harness criticar`: portão determinístico primeiro, depois um **subagente crítico com contexto limpo** compara o resultado real contra a barra **às cegas**, decisão binária sem nota, e **não conserta**. Nasceu de pesquisa sobre o **Gauntlet Loop** — que entrou pela metade de propósito: entrou o crítico (ganho medido de ~78% dos defeitos), **não entrou o loop autônomo** (LoopsBench: 25% de resolução e regressões em todos os perfis; reward hacking de juiz medido em 0,72→0,94 com acurácia real em 0,20). Prateleira nasce inteira mesmo vazia — custo zero, e *o que não é visto não é lembrado*. |
| **1.4.0** | **2026-08-12** | **A quarta guarda: a sombra** 🕰️ — máquina do tempo do projeto, em `.harness/sombra.git`. Nasceu de uma pergunta do usuário (*"ela faz backup do meu projeto?"*), cuja resposta era **não**: a única rede era git, e procedimental. Pesquisa do dia delimitou o buraco exato — o `/rewind` nativo do Claude Code **não** rastreia mudança feita por comando de shell, subagente em segundo plano, nem nada depois de 30 dias. A sombra cobre esse buraco e só ele. **T1 ganhou hook pela primeira vez** (a sombra é chão, não tier). Comando novo `/harness voltar`, 3 checks novos no `doctor`. Provado em teste real: arquivo apagado, pasta apagada e arquivo sobrescrito por shell — os três voltaram. Dois defeitos achados na verificação, um deles sério (`-Restaurar` quebrava em projeto com **exatamente uma foto**, justo na primeira vez que alguém precisaria dele — P009). |
| 1.3.3 | 2026-08-06 | A skill rodou o próprio `doctor --skill` e reprovou em 4 pontos. Corrigida a deriva do `SKILL.md` (apontava a saída do manual pra um arquivo inexistente), eliminada a segunda árvore de estrutura do `README.md` (fonte única), e o **T3 passou a se declarar "projetado, ainda não implementado"** — havia gatilho, check e descrição, mas nenhum template. Abatido do `evolve` o item que cobrava um orçamento inexistente. **Este manual foi atualizado da 1.2.1 até aqui.** |
| 1.3.2 | 2026-07-27 | O teto de orçamento ganhou **20% de tolerância** e parou de somar arquivos diferentes. Correção do usuário: teto binário faz o número mandar no conteúdo, e somar `SKILL.md` com `CONSTITUICAO.md` é erro de categoria. |
| 1.3.1 | 2026-07-27 | O check do `ESTADO.md` parou de perguntar pelo relógio — errado nas duas tentativas anteriores. Agora regenera uma prévia (sem escrever) e compara só a parte estável do conteúdo. |
| 1.3.0 | 2026-07-27 | O `doctor` estava **cego em 4 pontos**, achado rodando-o num projeto real: orçamento de 2 documentos nunca conferido, custo de sessão somando leitura sob demanda (inflava de ~1.924 pra ~5.213), alerta de custo desligado em tier com sufixo (`T2+`), e o registro do projeto na skill virou check mecânico (Lei 2). |
| 1.2.1 | 2026-07-26 | Só o hook `guarda.ps1` (template T2+): não bloqueia mais comando proibido quando o `cd` do comando aponta pra fora do projeto — achado ao vivo (P006). Conteúdo deste arquivo não mudou. |
| 1.2.0 | 2026-07-26 | Comando novo `/menu-harness` — lançador com descrição + último uso de cada comando. Roteador (`SKILL.md`) ganha o passo "Registrar uso", central pra qualquer jeito de invocar um comando. |
| 1.1.1 | 2026-07-26 | Só apresentação (`docs/index.html`): gaveta deslizante no mobile, leitura maior, colapso de menu no desktop. Conteúdo deste arquivo não mudou. |
| 1.1.0 | 2026-07-26 | Manual completo em 4 camadas + glossário + evidências; comando `--exportar` |
| 1.0.0 | 2026-07-26 | Primeira versão (só referência) |
