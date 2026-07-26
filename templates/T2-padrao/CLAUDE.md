# CLAUDE.md — {{PROJETO}}

> **Camada fina.** O documento canônico é **`AGENTS.md`** (raiz) — vale para qualquer IA.
> Aqui só o checklist de entrada e notas de ferramenta. **Não duplica** regras nem arquitetura.
>
> ⚠️ **Nada de "estado atual" aqui.** Informação que muda toda hora vive em `ESTADO.md`, que é
> gerado. Meter isso num arquivo estático é anti-padrão conhecido — desatualiza e você paga o
> token dele em toda sessão.

## START HERE (antes de qualquer coisa)

1. [ ] Leia **`AGENTS.md`** inteiro — é curto e é a fonte da verdade.
2. [ ] Leia **`ESTADO.md`** — onde o projeto está agora (1 tela).
3. [ ] Leia **`docs/GOVERNANCA.md`** — o fluxo obrigatório (as 4 portas).
4. [ ] Passe os olhos em **`docs/PRD.md`** e **`docs/SPEC.md`**.
5. [ ] Confira **`Planos/INDICE.md`** antes de propor algo novo.

Depois disso você sabe o necessário. Evite perguntar ao usuário o que já está documentado.

## Notas do Claude Code (ferramenta, não projeto)

- **Hooks ativos** (`.claude/settings.json`): `guarda` bloqueia o proibido · `pos-edicao` valida
  toda escrita · `porta-saida` não deixa encerrar com plano sem baixa. Se um deles te barrar,
  **ele provavelmente está certo** — leia a mensagem antes de contornar.
- **Planejamento grande:** use `EnterPlanMode`/`ExitPlanMode` para qualquer coisa que vá virar
  um plano em `Planos/`. Não pule direto para o código.
- **Manutenção do harness:** `/harness doctor` audita · `/harness learn "<erro>"` vira guarda ·
  `/manual-harness` explica tudo.
{{NOTAS_EXTRAS}}
