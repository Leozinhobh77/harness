# `upgrade` — trazer melhorias da skill para este projeto

> `evolve` melhora a **skill**. `upgrade` leva essas melhorias para **um projeto**.
> São separados de propósito: um projeto estável não deve mudar sozinho porque a skill mudou.

```
/harness upgrade              # traz o que a skill aprendeu desde a última vez
/harness upgrade --tier 3     # sobe o projeto de tier
/harness upgrade --tier 2     # desce de tier (raro, mas existe)
```

## Modo padrão — sincronizar com a skill

### 1. Compare
Leia a versão em `.harness/manifesto.json` × `VERSAO.json` da skill.
Igual → *"já está na v1.2.0, nada a trazer"* e pare. Uma linha.

### 2. Monte o diff
Leia `memoria/CHANGELOG.md` de cada versão intermediária. Para cada mudança, decida:

| Situação | O que fazer |
|---|---|
| Guarda nova que o projeto não tem | **propor** — dizendo qual erro ela previne |
| Guarda que foi abatida do template | **propor remover** — a menos que tenha disparado aqui |
| Check novo no `doctor` | entra sozinho (o doctor lê os critérios em tempo real) |
| Template mudou, mas o projeto customizou aquele arquivo | ⚠️ **nunca sobrescreva** — mostre lado a lado |

### 3. ⚠️ A regra mais importante deste comando

> **Customização do usuário sempre vence o template.**

Se o `AGENTS.md` do projeto foi editado à mão desde o `init`, você **não** sobrescreve. Nunca.
Mostre o que mudou no template e pergunte se quer incorporar.

Um harness que apaga o trabalho do dono na hora do update é um harness que ninguém atualiza
nunca mais.

### 4. Aplique com checkpoint
Git limpo antes. Só o aprovado. Atualize `manifesto.json`. Rode o `doctor` no fim.

---

## Modo `--tier` — subir ou descer a escada

### Subindo

1. **Mostre o gatilho.** Não suba porque "parece maduro". Cite o gatilho objetivo de
   `criterios/TIERS.md` que foi cruzado:
   > *"O projeto passou a lidar com dado financeiro — gatilho de T2+."*
2. **Mostre o custo:** o que entra e quantos tokens a mais por sessão.
3. **Gere só o delta.** Nunca regenere o que já existe.
4. Atualize o `manifesto.json`.

### Descendo (existe, e é saudável)

Projeto que virou protótipo de novo, ou que ficou parado — não precisa carregar governança de
projeto ativo.

- **Nada é apagado.** Move para `.harness/hibernado/` com a data.
- Voltar é um comando: `/harness upgrade --tier 2`.
- Guarda de segurança de dado **nunca desce**, em nenhum tier.

Essa última regra vale repetir: `.gitignore` e bloqueio de dado sensível não são funcionalidade
de tier. São chão.

---

## Saída

```
⬆️ UPGRADE — Finanças
harness v1.0.0 → v1.2.0 · tier T2 (mantido)

ENTRA (2)
  + hook pos-edicao: encoding UTF-8 no PowerShell
    previne: acento quebrado em script (visto em 3 projetos)
  + check: plano em andamento parado há +30 dias

SAI (1)
  - guarda "bloquear-node-modules" — o .gitignore já cobre

⚠️ PRESERVADO (1)
  ! Seu AGENTS.md foi editado à mão em 14/07. O template mudou a seção
    "Comandos essenciais". NÃO sobrescrevi. Quer ver o lado a lado?

Aprova?
```
