# `fix` — aplicar o que o `doctor` achou. **Nunca decidir.**

> O `fix` é o braço. O cérebro é o `doctor`. Se você se pegar descobrindo um problema novo
> dentro do `fix`, **pare e reporte** — não conserte por conta própria. Descoberta é trabalho
> do `doctor`.

## Fluxo

```
1. Rode o doctor primeiro (sempre — nunca conserte no escuro)
2. Separe o que é AUTOMÁTICO do que precisa de DECISÃO
3. Mostre os dois grupos e espere o OK
4. Checkpoint de git antes de mexer (working tree limpo ou commit)
5. Aplique só o aprovado
6. Rode o doctor de novo e mostre o antes/depois
```

## Automático vs. decisão

**Aplique sem perguntar** (reversível, óbvio, sem perda):

| Correção | Por que é seguro |
|---|---|
| Regenerar `ESTADO.md` | é derivado — não existe informação a perder |
| Sincronizar `INDICE.md` com os arquivos reais de `Planos/` | o disco é a verdade |
| Mover plano `✔️ Concluído` para `Concluídos/` | é o procedimento documentado |
| Consertar link quebrado quando o alvo é inequívoco | não há escolha a fazer |
| Formatar/reordenar tabela de índice | cosmético |

**Sempre pergunte** (perda, escolha ou julgamento):

| Correção | Por que precisa de você |
|---|---|
| **Abater qualquer regra ou guarda** | pode ser exatamente ela que segura o projeto |
| Migrar conteúdo de documento estourado | *onde* vai é decisão de arquitetura |
| Apagar documento órfão | órfão hoje pode ser importante amanhã |
| Corrigir deriva `SPEC` × código | qual dos dois está certo? só o usuário sabe |
| Subir ou descer de tier | usa `/harness upgrade`, não o `fix` |

## `--limpar` — o abate (Lei 4)

```
/harness fix --limpar
```

Modo dedicado à **descida da escada**. Nunca roda junto com o `fix` normal, porque remoção
merece atenção separada.

Para cada candidato, apresente assim:

```
Guarda: bloquear-edicao-env
Criada em: 2026-03-12 · Procedência: "IA editou o .env e vazou chave"
Disparou: 0 vezes em 136 dias
Sugestão: ABATER — o risco original não se materializou nenhuma vez

[m]anter · [a]bater · [p]ular
```

Regras do abate:
- **Um por vez.** Nunca uma lista com "confirma tudo?"
- **Nunca apague de verdade** — mova para `.harness/abatidos/` com a data. Ressuscitar é barato,
  reconstruir do zero não é.
- **Guarda de segurança de dado nunca é candidata**, mesmo com 0 disparos. Ela ter 0 disparos é
  o sucesso dela, não o fracasso.

Essa última regra é a mais importante do arquivo. Um `.gitignore` que nunca "disparou" está
funcionando perfeitamente.

## Checkpoint obrigatório

Antes de qualquer escrita:

```
git status limpo?  →  pode ir
tem coisa pendente? →  avise e ofereça commitar antes
não é repo git?     →  avise que não tem desfazer, e confirme
```

## Saída

```
🔧 FIX — Finanças

Aplicado automaticamente (3)
  ✓ ESTADO.md regenerado
  ✓ INDICE.md sincronizado (plano 0002 estava como "Em andamento", já concluído)
  ✓ Plano 0002 movido para Concluídos/

Aguardando você (1)
  ? AGENTS.md com 134 linhas (teto 120)
    Sugiro migrar "Modelo de dados" (18 linhas) para docs/SPEC.md
    → responda: pode migrar?

→ /harness doctor  agora acusa 0 🔴 e 1 🟡
```
