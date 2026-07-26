# `status` — onde estamos, em 10 linhas

> Resposta ao `/harness` sozinho. **Barato e curto.** Não roda o doctor completo, não lê
> documento inteiro. É o "bom dia" da skill, não um relatório.

## Fluxo

```
1. scripts/versao.ps1        → versão da skill + prazos
2. .harness/manifesto.json   → este projeto tem harness? qual tier?
3. ESTADO.md                 → só as 5 primeiras linhas
4. git log -1                → último commit
5. doctor --rapido           → SÓ a contagem de 🔴/🟡, sem detalhar
```

## Formato — com harness

```
📁 Finanças · tier T2 · harness v1.0.0 · criado 26/07/2026

Estado: 1 plano ativo (0003 — dashboard de filtros, 6/14 tarefas)
Último commit: há 2 dias — "feat: filtro por período customizado"
Saúde: 0 🔴 · 2 🟡     → /harness doctor  para ver

💡 já são 18 dias desde a última evolução da skill → /harness evolve
```

## Formato — sem harness

```
📁 Finanças · sem harness

Vejo: git ✓ · 14 arquivos · JavaScript · sem AGENTS.md
→ /harness init  cria a estrutura (proponho T2, ~2.500 tokens/sessão)
```

## Regras

- **Máximo 10 linhas.** Estourou, você está fazendo o trabalho do `doctor`.
- **Tudo verde = não escreva "tudo ok" em 5 linhas.** Escreva em uma.
- O lembrete de versão entra **só se estiver vencido**, e sempre na **última linha**.
- Nunca escreva nada no disco.
