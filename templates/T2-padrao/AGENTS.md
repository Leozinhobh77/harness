# AGENTS.md — {{PROJETO}}

> **Documento canônico.** Qualquer IA (Claude Code, Cursor, Copilot, Gemini, Codex) que abrir
> esta pasta deve ler este arquivo **primeiro e por inteiro**. É curto de propósito — a
> profundidade vive nos links da seção 6. **Não copie conteúdo de lá para cá: fonte única, sempre.**

## 1. O que é este projeto

{{DESCRICAO}}

## 2. Comandos essenciais

```
{{COMANDOS}}
```

## 3. Regras de ouro (não negociáveis)

> Cada regra aqui existe por causa de um erro real. Regra sem procedência é abatida pelo
> `/harness doctor` — não adicione nenhuma sem saber que erro ela previne.

1. **Investigue antes de agir.** Leia o código real relevante e diga o que encontrou antes de
   propor ou implementar. Nunca trabalhe às cegas.
2. **Nada sem plano aprovado + autorização.** Trabalho não trivial só começa com um plano em
   `Planos/` (ver `Planos/MANUAL.md`) e o usuário dizendo sim. Dúvida se é trivial? Trate como
   não trivial.
3. **Fale português** com o usuário.
4. **Checkpoint antes, commit depois.** Working tree limpo antes de mudança arriscada; commit ao
   terminar (convenção em `docs/GOVERNANCA.md` §4).
5. **Ao fim de toda tarefa: dê baixa no plano** — checkboxes, status, progresso, changelog,
   `Planos/INDICE.md`. Arquive em `Planos/Concluídos/` se encerrou.
6. **Efeito flywheel.** Errou por instrução ausente ou ambígua neste harness? **Corrija o
   documento na mesma tarefa** e registre em `docs/DECISOES.md`. Melhor ainda: rode
   `/harness learn "<o erro>"` para virar guarda mecânica.
{{REGRAS_EXTRAS}}

## 4. Como este projeto pensa (as 4 portas)

Detalhadas em `docs/GOVERNANCA.md`:

```
0. AO ENTRAR        → AGENTS.md → GOVERNANCA → PRD/SPEC → ESTADO.md → Planos/INDICE.md
1. PORTA DE ENTRADA → investigar o sistema real + plano aprovado + autorização
2. DURANTE          → seguir o plano, mudanças pequenas e reversíveis, dar baixa ao avançar
3. PORTA DE SAÍDA   → testar + sincronizar docs + dar baixa + commit
```

## 5. Tabela de permissões

| Nível | Significa | Exemplos |
|---|---|---|
| 🟢 **Sempre pode** | Sem pedir | Ler código, investigar, rodar testes, ler docs e planos |
| 🟡 **Perguntar antes** | Precisa de OK explícito | Implementar algo novo, mudar escopo, nova dependência, mexer em dados |
| 🔴 **Nunca** | Proibido, sem exceção | {{PROIBIDOS}} |

Versão completa em `docs/GOVERNANCA.md` §2. As linhas 🔴 são impostas por hook — ver
`.claude/hooks/guarda.ps1`.

## 6. Mapa de documentos (a profundidade vive aqui)

| Documento | Quando ler |
|---|---|
| `ESTADO.md` | **Sempre, ao entrar** — onde o projeto está agora. É gerado; não edite. |
| `docs/GOVERNANCA.md` | Sempre — fluxo completo, permissões, rollback, convenção de commit. |
| `docs/PRD.md` | Antes de decidir o **o quê**/**por quê** de uma funcionalidade. |
| `docs/SPEC.md` | Antes de mexer em código — arquitetura, stack, convenções técnicas. |
| `docs/DECISOES.md` | Para entender **por que** algo é assim (memória sob demanda). |
| `Planos/MANUAL.md` + `MODELO-DE-PLANO.md` | Antes de criar/atualizar um plano. |
| `Planos/INDICE.md` | Para ver o que já está em andamento antes de começar algo novo. |
| `CLAUDE.md` | Camada específica do Claude Code (não repete o que já está aqui). |

## 7. Fora de escopo hoje

{{FORA_ESCOPO}}

---

<!--
  Harness gerado por /harness · tier T2 · v{{VERSAO_SKILL}}
  Orçamento deste arquivo: 120 linhas. Estourou? Migre para docs/SPEC.md e deixe um ponteiro.
  /harness doctor confere. /harness learn "<erro>" adiciona guarda com procedência.
-->
