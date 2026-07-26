# `manual --exportar` — publicar o manual

> **Fonte única:** `manual/MANUAL.md`. Tudo aqui é **saída**, nunca original.
> Se alguém pedir para "corrigir a página web" ou "arrumar o Notion", a resposta é: corrige o
> `MANUAL.md` e reexporta. Editar a saída cria deriva — o problema que este harness inteiro existe
> para evitar.

```
/harness manual --exportar          # faz o destino padrão: github
/harness manual --exportar github   # regenera docs/index.html, commita e dá push
/harness manual --exportar artifact # republica a cópia privada no claude.ai
/harness manual --exportar notion   # envia ou entrega os blocos para colar
```

**Destino padrão: `github`.** É o que o usuário lê no celular.
🌐 https://leozinhobh77.github.io/harness/

## Antes de qualquer destino

1. Leia `manual/MANUAL.md` — é a fonte.
2. Leia `VERSAO.json` e confira: o carimbo do manual bate com a versão atual da skill?
   - **Não bate** → atualize o cabeçalho e a tabela "Histórico deste manual" no `MANUAL.md` **antes**
     de exportar. Manual publicado com carimbo errado é pior que manual desatualizado, porque mente
     com confiança.
3. Todo destino recebe o carimbo: `v<versão> · gerado em <data>` + a linha de fonte única.

---

## Destino `github` (padrão)

**Arquivo:** `docs/index.html` · repo `Leozinhobh77/harness` · Pages serve de `/docs` na `main`.

1. Regenere o HTML a partir do `MANUAL.md` atual, **preservando o desenho existente** — tokens de
   cor, navegação com scroll-spy, tema claro/escuro, favicon. Não redesenhe a cada exportação:
   atualize só o conteúdo e o carimbo.
2. Confira que o rodapé e o cabeçalho trazem a versão certa.
3. Commite e dê push:
   ```
   git add -A && git commit -m "docs: manual v<versão>" && git push
   ```
4. O build do Pages leva ~30s. Confirme com `curl -s -o /dev/null -w "%{http_code}"` na URL antes
   de dizer ao usuário que está no ar. **Nunca afirme que publicou sem ter conferido.**

⚠️ **Repositório é público.** Antes de qualquer push, varra o conteúdo novo por nome de cliente,
nome de negócio, número exato de registro, caminho com dado pessoal, token ou credencial. O
exemplo do flywheel no manual está **generalizado de propósito** — mantenha assim.

## Destino `artifact`

Cópia privada no claude.ai, útil para rascunho antes de publicar.

1. Publique `docs/index.html` com a ferramenta `Artifact`.
2. **Passe a URL existente no parâmetro `url`** para manter o mesmo link — sem isso, uma conversa
   nova cria outro artifact.
3. Mantenha o favicon ⚙️ — o usuário acha a aba pelo ícone. Use `label` com a versão.

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
