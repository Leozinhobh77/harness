# `manual --exportar` — publicar o manual

> **Fonte única:** `manual/MANUAL.md`. Tudo aqui é **saída**, nunca original.
> Se alguém pedir para "corrigir a página web" ou "arrumar o Notion", a resposta é: corrige o
> `MANUAL.md` e reexporta. Editar a saída cria deriva — o problema que este harness inteiro existe
> para evitar.

```
/harness manual --exportar          # pergunta o destino
/harness manual --exportar web      # regenera e republica a página
/harness manual --exportar notion   # envia ou entrega os blocos para colar
```

## Antes de qualquer destino

1. Leia `manual/MANUAL.md` — é a fonte.
2. Leia `VERSAO.json` e confira: o carimbo do manual bate com a versão atual da skill?
   - **Não bate** → atualize o cabeçalho e a tabela "Histórico deste manual" no `MANUAL.md` **antes**
     de exportar. Manual publicado com carimbo errado é pior que manual desatualizado, porque mente
     com confiança.
3. Todo destino recebe o carimbo: `v<versão> · gerado em <data>` + a linha de fonte única.

---

## Destino `web`

**Arquivo:** `manual/web/manual.html`

1. Regenere o HTML a partir do `MANUAL.md` atual, preservando o desenho existente (tokens de cor,
   navegação, scroll-spy, tema claro/escuro). **Não redesenhe a cada exportação** — só atualize o
   conteúdo e o carimbo.
2. Republique com a ferramenta `Artifact` **no mesmo caminho de arquivo**, para manter a URL.
   - Se a conversa atual não foi quem publicou, passe a URL no parâmetro `url`.
   - Mantenha o mesmo favicon (⚙️) — o usuário acha a aba pelo ícone.
3. Use `label` com a versão: `v1.2.0-manual`.

## Destino `notion`

**Se houver MCP do Notion conectado:** escreva direto. Uma página-mãe com filhas:

```
📖 Manual /harness        ← índice + carimbo de versão + colinha
├── Começando            visão geral · primeiro projeto · glossário
├── Referência           os sete comandos
├── Receitas             as seis situações
├── Anatomia             cada arquivo explicado
├── Conceitos            flywheel · 5 leis · tiers · hooks
├── Socorro              FAQ e problemas
└── Evidências           números e fontes
```

A **colinha fica na página-mãe, no topo** — é o que ele abre 90% das vezes.

**Se não houver MCP:** entregue os blocos markdown na conversa, **um por página**, cada um em seu
próprio bloco de código para copiar. Avise os dois detalhes de formatação:
- tabelas e blocos de código colam perfeito
- citações (`>`) viram texto simples; no Notion viram *callout* em 2 cliques

## Depois de exportar

Registre em `memoria/CHANGELOG.md` **só se o conteúdo mudou** — reexportação sem mudança de
conteúdo não vira entrada de changelog. Isso é a Lei 4 aplicada ao próprio changelog: registro que
não informa nada é ruído.

---

## Quando o `evolve` deve lembrar disso

Se uma rodada de `evolve` mudar comando, tier, lei ou orçamento, o manual **ficou errado**.
Nesses casos o `evolve` deve fechar com:

```
⚠️ O manual mudou com esta evolução → /harness manual --exportar
```
