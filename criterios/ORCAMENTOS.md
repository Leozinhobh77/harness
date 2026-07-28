# ORÇAMENTOS — limites de linha por documento

> Aplicação da **Lei 3**. Estes números não são sugestão: o `doctor` reprova quem estoura.

## A tabela

| Documento | Alvo | Teto (reprova) | Se estourar, para onde migra |
|---|---|---|---|
| `AGENTS.md` | 80 | **120** | conteúdo profundo → `docs/SPEC.md` ou `docs/REGRAS-DE-NEGOCIO.md` |
| `AGENTS.md` (T1) | 30 | **40** | é hora de subir pra T2 |
| `CLAUDE.md` | 25 | **40** | regra de projeto → `AGENTS.md`; estado → `ESTADO.md` |
| `ESTADO.md` | 25 | **40** | é gerado — se estourou, o gerador está errado |
| `docs/GOVERNANCA.md` | 90 | **140** | detalhe de plano → `Planos/MANUAL.md` |
| `docs/PRD.md` | 60 | **100** | detalhe técnico → `SPEC.md` |
| `docs/SPEC.md` | 90 | **150** | regra de domínio → `REGRAS-DE-NEGOCIO.md` |
| `docs/REGRAS-DE-NEGOCIO.md` | 150 | **250** | vira teste executável, não parágrafo |
| `docs/DECISOES.md` | — | **15 decisões** | quebra em `docs/decisoes/D0NN-slug.md` + índice |
| `Planos/MANUAL.md` | 90 | **140** | — |
| plano individual | 120 | **200** | plano grande demais = deveria ser dois planos |

## A tolerância — o teto é mira, não linha da morte

**Passar até ~20% do teto não é achado.** O `doctor` só acusa acima disso, e diz de quanto foi
o excesso em porcentagem.

Sem essa folga, o número passa a mandar no conteúdo: um documento bom com 5 linhas a mais vira
"problema", e a correção proposta é **mutilar texto que presta** para agradar um limite. É o
inverso do que a Lei 3 quer — ela existe para impedir inchaço, não para impedir que um
documento seja completo.

**E cada arquivo tem o seu.** Nunca some dois documentos diferentes para comparar com um teto:
a medição que embasa os limites é **por arquivo**. `SKILL.md` e `CONSTITUICAO.md` são coisas
distintas, com trabalhos distintos — somar os dois e comparar com o limiar de um é erro de
categoria.

**Procedência:** correção do usuário em 27/07/2026, depois de eu ter somado `SKILL.md` (81) com
`CONSTITUICAO.md` (113) e proposto ação por causa do total. Palavras dele: *"já fez a coisa toda
certinha e vai ficar cortando o conteúdo? só iria estourar se fossem muitas linhas"*.

## A regra do ponteiro

Estourou o orçamento, **não corte informação — mude de lugar.**

```
❌ errado:  apagar o parágrafo para caber
✅ certo:   mover para o documento de profundidade + deixar 1 linha de ponteiro
```

E nunca duplicar parágrafo entre dois documentos. **Fonte única, sempre.** Duplicata é
garantia de que um dos dois vai desatualizar sem ninguém notar.

## Orçamento de sessão

O `doctor` também soma o custo total: quantos tokens este harness cobra só por existir, em
toda sessão.

**Só entram na conta os documentos que carregam sempre** — `AGENTS.md`, `CLAUDE.md` e
`ESTADO.md`. `SPEC.md`, `REGRAS-DE-NEGOCIO.md`, `MANUAL.md` e companhia são leitura sob demanda:
têm teto de linha (a tabela acima), mas **não** cobram pedágio por sessão. Somar os dois era o
mesmo erro de duas contas diferentes com o mesmo nome — inflava o número e escondia o real.

| Tier | Alvo | Alerta |
|---|---|---|
| T1 | ~500 | > 900 |
| T2 | ~2.500 | > 4.000 |
| T3 | ~5.000 | > 8.000 |

Estourou o alerta: ou o projeto subiu de tier sem passar pelo gatilho, ou tem documento
inchado. O `doctor` diz qual dos dois.

## A exceção honesta

`docs/DECISOES.md` **não tem teto de linha** — tem teto de **quantidade de decisões**. O
motivo: uma decisão bem escrita, com o "por que" completo, vale mais que três resumidas. O
problema dela não é comprimento, é **acúmulo sem índice**. Por isso a solução é quebrar em
arquivos com índice barato (progressive disclosure), não encurtar o texto.
