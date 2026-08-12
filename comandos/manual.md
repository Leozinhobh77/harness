# `manual` — manual navegável por número

> Chamado por `/manual-harness` ou por "manual", "ajuda", "como usa".
>
> **Como funciona:** mostre o índice, o usuário digita um número, você ensina **aquele tópico**
> a fundo. Nunca despeje o manual inteiro — é exatamente o inchaço que esta skill combate.

## 📌 Onde está o conteúdo

Este arquivo é o **roteiro** (como conduzir a navegação). O **conteúdo** mora em:

**`manual/MANUAL.md`** — fonte única, completa, em 4 camadas.

Carregue de lá o tópico que o usuário escolher — **só aquele**. Se ele pedir algo que o
`MANUAL.md` não cobre, responda direto e considere se aquilo merece entrar no manual (aí é
edição do `MANUAL.md` + `/harness manual --exportar`).

Para publicar: `comandos/exportar.md`.

## Passo 1 — mostre o índice (exatamente assim)

```
📖 MANUAL — /harness v<versão> · atualizado <data>

  COMEÇANDO
   0 · Visão geral — o que é um harness e por que você quer um
   1 · Meu primeiro projeto — o passo a passo do zero

  OS COMANDOS
   2 · /harness init      criar ou adotar a estrutura
   3 · /harness doctor    auditar (nunca escreve)
   4 · /harness fix       corrigir o que o doctor achou
   5 · /harness voltar    máquina do tempo — desfazer o acidente     🕰️
   6 · /harness criticar  comparar com a referência, às cegas         🔍
   7 · /harness gauntlet  loop até vencer a barra (com freios)        🏟️
   8 · /harness learn     transformar um erro em guarda permanente   ⭐
   9 · /harness evolve    a skill melhora a si mesma                ⭐⭐
  10 · /harness upgrade   trazer melhorias da skill pro projeto

  ENTENDENDO POR DENTRO
  11 · Tiers e a escada — como a estrutura cresce junto com o projeto
  12 · As 5 leis anti-inchaço — por que ela se recusa a crescer à toa
  13 · Hooks — a espinha mecânica que impede erro de verdade
  14 · Referências — a barra que o projeto quer bater
  15 · Versão, changelog e o lembrete automático

  ATALHOS
  16 · Colinha — todos os comandos numa tela
  17 · Perguntas frequentes

Digite o número (ou "tudo" para o resumo de todos).
```

## Passo 2 — ensine o tópico escolhido

**Estrutura obrigatória de cada tópico:**

1. **O que é** — 2 frases, linguagem simples, sem jargão
2. **Quando usar** — a situação concreta do dia a dia
3. **Exemplo real** — comando + o que aparece na tela
4. **A pegadinha** — o erro que as pessoas cometem com isso
5. **Relacionados** — *"veja também 4 e 8"*

Sempre termine com: `Outro número, ou "sair"?`

## Conteúdo de cada tópico

Tudo vem de `manual/MANUAL.md`. Carregue **só a seção pedida** e traduza para linguagem de
usuário — não recite o arquivo.

| Nº | Seção do `MANUAL.md` | Ênfase ao ensinar |
|---|---|---|
| 0 | §1 Visão geral | harness = esqueleto que faz a IA trabalhar bem. Sem jargão. |
| 1 | §2 Meu primeiro projeto | o passeio: `init` → trabalhar → `learn` → `doctor` |
| 2 | §4.2 `init` | investiga antes de perguntar; propõe o **menor** tier |
| 3 | §4.3 `doctor` | ⚠️ **nunca escreve** — pode rodar sem medo, a qualquer hora |
| 4 | §4.4 `fix` | automático × decisão; `--limpar` é o abate |
| 5 | §4.8 `voltar` | o buraco que o `/rewind` nativo deixa: **comando de shell** |
| 6 | §4.9 `criticar` | quem julga não pode ter visto construir; **perder é resultado bom** |
| 7 | §4.10 `gauntlet` | o loop **com freios**: portão · foto por rodada · platô · teto · você |
| 8 | §4.5 `learn` | a pergunta-chave: *"dá pra impedir mecanicamente?"* |
| 9 | §4.6 `evolve` | os 3 ciclos; promoção exige **2 projetos** |
| 10 | §4.7 `upgrade` | **sua customização sempre vence o template** |
| 11 | §7.3 Tiers | sobe por gatilho, **desce por desuso** |
| 12 | §7.2 As 5 leis | Lei 1 (procedência) e Lei 2 (mecânico > escrito) pesam mais |
| 13 | §7.4 Hooks | os **4** hooks, o que cada um pega, o `log-guardas.jsonl` |
| 14 | §6 `referencias/` | os 3 critérios · a regra da companheira · a ficha de personagem |
| 15 | §9 + `VERSAO.json` | por que o lembrete existe e como calar (rodando `evolve`) |

Há ainda duas camadas que o índice numerado não expõe direto, mas que você deve oferecer quando
a pergunta pedir: **§5 Receitas** (situação → o que fazer) e **§6 Anatomia** (cada arquivo
explicado).

### Tópico 16 — Colinha (mostre exatamente isto)

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
/manual-harness       este manual

Rotina saudável:
  ao criar projeto ......... init
  quando a IA errar ........ learn        ← o hábito que mais paga
  quando algo der errado ... voltar       ← você não precisa lembrar dele antes
  toda semana .............. doctor
  a cada ~2 semanas ........ evolve
```

### Tópico 17 — FAQ

Responda estas, curto:

- **"O doctor pode estragar meu projeto?"** Não. Ele nunca escreve. Nem um espaço.
- **"Preciso rodar isso toda hora?"** Não. `learn` quando a IA errar, `doctor` de vez em quando.
- **"E se eu editei os arquivos à mão?"** Sua edição vence. O `upgrade` nunca sobrescreve
  customização — ele mostra e pergunta.
- **"Serve pra projeto que já existe?"** Serve. `init` detecta e vira modo adoção: audita o que
  tem e propõe melhorias uma a uma.
- **"Se a IA apagar um arquivo meu, dá pra recuperar?"** Dá — `/harness voltar`. Funciona
  inclusive quando o estrago veio de comando de shell, que é justamente o caso em que o
  `/rewind` nativo do Claude Code não consegue ajudar.
- **"Por que ela insiste em ser pequena?"** Porque arquivo de instrução acima de ~150 linhas
  aumenta custo em 20–23% **sem ganho medido** — e regra genérica chega a piorar o resultado.
- **"Como eu apago tudo?"** Apague a pasta `.harness/` e os documentos. Nada fica escondido no
  sistema; o harness inteiro mora dentro do seu projeto.

## Regras do manual

- **Nunca despeje tudo.** Índice → escolha → um tópico. Progressive disclosure vale aqui também.
- **Linguagem de gente.** "guarda que impede erro", não "hook PreToolUse com exit code 2".
- **Todo tópico tem exemplo real**, com saída de tela.
- Se o usuário perguntar algo fora do índice, responda direto — o índice é atalho, não cerca.
