# TIERS — quanto harness este projeto merece

> Aplicação da **Lei 5** (o menor tier que serve). Na dúvida entre dois, é o menor.

## A tabela

| Tier | Perfil do projeto | Custo por sessão |
|---|---|---|
| **T1 · Leve** | script solto, protótipo, POC, experimento, 1–2 arquivos | ~500 tokens |
| **T2 · Padrão** | aplicação pessoal real, que você vai usar e manter por meses | ~2.500 tokens |
| **T3 · Completo** ⚠️ | multi-módulo, dado sensível de terceiro, mais de uma pessoa, vida longa | ~5.000 tokens |

⚠️ **O T3 é projeto, não entrega.** Ver a seção dele abaixo antes de propor a alguém.

## O que cada tier gera

### T1 · Leve
```
AGENTS.md          ≤ 40 linhas — stack, comandos, o que nunca tocar
.gitignore
.claude/settings.json + hooks/sombra.ps1   ← a única guarda de T1
```
Sem `docs/`, sem `Planos/`, sem guarda de processo. Um protótipo não precisa de governança —
precisa que você descubra rápido se a ideia presta.

⚠️ **A sombra é a exceção, e ela não é funcionalidade de tier — é chão.** Vale a mesma regra do
`.gitignore` e do bloqueio de dado sensível (ver `comandos/upgrade.md`): perder trabalho num
protótipo dói igual, e um protótipo é justamente onde ninguém commita. Custo: 0 token por sessão.

### T2 · Padrão
```
AGENTS.md          ≤ 120 linhas — canônico, estilo ponteiro
CLAUDE.md          ≤ 40 linhas — camada fina, sem estado volátil dentro
ESTADO.md          ≤ 40 linhas — GERADO por scripts/estado.ps1, nunca escrito à mão
.gitignore
.claude/settings.json + hooks/{sombra,guarda,pos-edicao,porta-saida}.ps1
docs/GOVERNANCA.md · PRD.md · SPEC.md · DECISOES.md
Planos/MANUAL.md · MODELO-DE-PLANO.md · INDICE.md · Concluídos/
referencias/INDICE.md + a prateleira (visual · personagens · texto · documentos
                                      dados · mapas · audio · video)
.claude/agents/critico-cego.md
.harness/manifesto.json · log-guardas.jsonl · sombra.git/
```

> **`referencias/` não conta no orçamento de sessão.** Só o `INDICE.md` tem conteúdo, e ele é
> leitura sob demanda — igual ao `SPEC.md`. A prateleira nasce inteira mesmo vazia porque o
> custo é zero e o ganho é de adoção: prateleira invisível não é usada.

### T3 · Completo  ⚠️ projetado, ainda não implementado

> **Não existe template T3 executável.** `templates/T3-completo/` tem um arquivo só
> (`docs/REGRAS-DE-NEGOCIO.md`) e nenhum comando sabe montar o resto. O que vem abaixo é o
> **alvo de desenho**, não o que a skill entrega hoje.
>
> Por que está assim: nenhum projeto do `memoria/REGISTRO.md` chegou perto do gatilho.
> Construir sem caso concreto é palpite — exatamente o que a Lei 1 proíbe. Quando o primeiro
> projeto cruzar, ele vira o caso de uso e o template nasce medido, não imaginado.

Tudo do T2, **mais**:
```
docs/REGRAS-DE-NEGOCIO.md   + os testes executáveis que provam cada regra
.claude/hooks/              guardas extras específicas do domínio
AGENTS.md aninhado          por módulo/pasta (o mais próximo do cwd vence)
auditor cego                subagente de contexto limpo na Porta de Saída
```

---

## Os gatilhos de subida (a escada)

**A estrutura não sobe por tempo nem por vontade. Sobe por evento real.**
O `doctor` detecta o gatilho e **propõe** — nunca aplica sozinho.

| Subida | Gatilho objetivo (qualquer um basta) |
|---|---|
| **T1 → T2** | • primeiro plano de trabalho criado<br>• 3+ arquivos de código no projeto<br>• primeira vez que o usuário disse "continua de onde parou" |
| **T2 → T2+** | • primeiro bug real que chegou ao uso<br>• dado sensível entrou no projeto (dinheiro, pessoal, credencial)<br>• regra de negócio que, se quebrar, o usuário só descobre tarde |
| **T2+ → T3** ⚠️ | • projeto virou multi-módulo (2+ pastas de código independentes)<br>• outra pessoa passou a usar ou mexer<br>• passou de 15 decisões registradas |

⚠️ Cruzar o gatilho de T3 hoje **não tem upgrade para aplicar**. O `doctor` registra que cruzou
e o caso vira a matéria-prima para construir o T3 de verdade — não prometa a subida como se ela
existisse.

**"T2+"** não é um tier separado — é o T2 com os testes de regra de negócio adicionados. Ele
existe porque a diferença entre "app pessoal" e "app pessoal que mexe com dinheiro" é grande
demais para ignorar, e pequena demais para virar T3.

---

## A descida (o que quase nenhum sistema tem)

**Sobe por gatilho, desce por desuso.** Sem a descida, é questão de tempo até virar monstro.

| Descida | Critério objetivo |
|---|---|
| Guarda abatida | não disparou nenhuma vez em 90 dias (`.harness/log-guardas.jsonl`) |
| Regra abatida | sem procedência registrada (Lei 1) |
| Decisão arquivada | superada por outra mais nova |
| Documento abatido | nenhum outro documento aponta para ele |

Quem propõe: `doctor`. Quem aplica: `fix --limpar`. Quem decide: **o usuário, sempre**.

---

## Como classificar na hora do `init`

Não pergunte "que tier você quer?" — o usuário não tem como saber. **Investigue e proponha:**

1. Olhe o disco: tem git? quantos arquivos de código? que linguagem? já tem `AGENTS.md`?
2. Pergunte no máximo 3 coisas em linguagem simples:
   - "Isso é um teste rápido ou algo que você vai usar de verdade por meses?"
   - "Vai guardar dado sensível (dinheiro, dado pessoal, senha)?"
   - "Só você mexe, ou mais gente?"
3. Proponha **um** tier, diga **por que** esse e **quanto custa** por sessão.
4. Diga a frase que tira o medo: *"dá pra subir depois com um comando; o gatilho vai aparecer sozinho."*
