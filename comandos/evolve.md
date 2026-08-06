# `evolve` — a skill audita e melhora a si mesma

> Os outros comandos cuidam dos projetos. Este cuida da **skill**.
>
> É o ciclo mais lento e o mais valioso: o que ela aprender aqui, todo projeto futuro nasce
> sabendo. E é também o mais perigoso — uma mudança errada aqui contamina **todos** os projetos
> que ela criar. Por isso: nada é automático, tudo tem procedência, você aprova.

## Os 3 ciclos (contexto)

```
CICLO 1 — dentro da sessão      ⚡ ms       hook falha → modelo corrige na hora
CICLO 2 — o projeto aprende     📅 tarefa   /harness learn → guarda naquele projeto
CICLO 3 — a SKILL aprende       🧬 semanas  /harness evolve            ← você está aqui
```

## Fluxo — 8 etapas

### 1. Situação
Leia `VERSAO.json` e `memoria/CHANGELOG.md`. Diga em duas linhas: versão atual, quando foi a
última evolução, quantos projetos existem, quando foi a última pesquisa web.

### 2. Varredura
Percorra `memoria/REGISTRO.md`. Para cada projeto que ainda existe no disco:
- rode o `doctor` em modo `--rapido`
- colete os `learn` registrados
- some quais guardas dispararam e quais nunca dispararam (`.harness/log-guardas.jsonl`)

Projeto que sumiu do disco: marque como `arquivado` no registro, **não apague a linha**. O
aprendizado dele continua valendo.

### 3. Convergência ⭐ — o coração
Cruze os `PADROES.md`. Procure o mesmo problema em **projetos diferentes**.

> **Regra de promoção: ≥ 2 projetos independentes.**
> Um caso é acaso. Dois é padrão. Um único projeto barulhento não redesenha a skill.

"Independentes" significa projetos distintos — não a mesma coisa contada duas vezes em dias
diferentes.

### 4. Abate (Lei 4) — obrigatório, não opcional
`evolve` que só adiciona está matando a skill devagar. **Toda rodada tem que olhar para
remoção:**

- guarda no template que **nunca disparou em nenhum projeto** → propor tirar do template
- regra em `criterios/` que nunca reprovou nada → propor abater
- comando que o usuário nunca usou → propor simplificar ou fundir

Se você não encontrou **nada** para remover, diga isso explicitamente — e desconfie de si mesmo.

### 5. Pesquisa externa
Se passaram mais de `prazos_dias.pesquisa_web_sugerir` dias desde `ultima_pesquisa_web`,
**pergunte se pode pesquisar** e busque o que mudou:

- `AGENTS.md` — o padrão mudou? novos campos, nova precedência?
- Claude Code — hooks novos, eventos novos, recursos novos?
- Harness / context engineering — anti-padrão novo? medição nova?
- Spec-driven development — ferramenta nova que valha absorver?

Traga **o que muda a skill**, com fonte. Notícia que não muda nada não entra no relatório.

### 6. Auto-doctor 🪞
```
/harness doctor --skill
```
A skill é um harness. Ela tem que passar no próprio exame:
- `SKILL.md` continua só **roteando**? (ele não tem teto em `ORCAMENTOS.md` — o que se cobra
  dele é o papel, não o tamanho: instrução de comando mora em `comandos/`, não aqui)
- links entre os arquivos dela funcionam?
- todo comando documentado existe? todo arquivo existente está documentado?
- alguma regra dela sem procedência? (Lei 1 aplicada a si mesma)
- os `scripts/*.ps1` rodam sem erro?

**Se a skill não passa no próprio doctor, conserte isso antes de qualquer outra proposta.**
Não dá para pregar orçamento com um `SKILL.md` de 300 linhas.

### 7. Proponha
Nunca aplique direto. Monte o relatório e espere:

```
🧬 EVOLVE — harness v1.0.0 → v1.1.0
Última evolução: 26/07/2026 (18 dias) · 3 projetos · última pesquisa: 26/07/2026

📈 PROMOVER (2)
  1. Guarda de encoding UTF-8 no PowerShell
     Visto em: projeto-a, projeto-b, api-clientes  (3 projetos)
     → entra no template T2 como hook pos-edicao
  2. Regra "plano em andamento parado >30d vira alerta"
     Visto em: Finanças, api-clientes  (2 projetos)
     → entra em criterios/CHECKS.md, Família 2

📉 ABATER (1)
  3. Guarda "bloquear-node-modules" no template T2
     0 disparos em 3 projetos / 94 dias — o .gitignore já cobre
     → sai do template

🌐 PESQUISA (1)
  4. Claude Code adicionou o evento <X> em <data>
     → vale usar em porta-saida.ps1?  fonte: <url>

🪞 AUTO-DOCTOR
  ✅ passou · 10/10 comandos existem · 3 scripts com parser limpo

Aprova quais? (números, "todos" ou "nenhum")
```

### 8. Aplique, versione, registre
Só o aprovado. Depois:

1. **Versão** (semântico):
   - `patch` — correção, texto, ajuste de limite
   - `minor` — promoção/abate, check novo, comando melhorado
   - `major` — mudança que quebra harness já existente (evite; se for, escreva o guia de migração)
2. `VERSAO.json`: `versao`, `atualizada_em`, `ultima_evolucao`, `ultima_pesquisa_web`
3. **`memoria/CHANGELOG.md`** — entrada datada, com **procedência de cada item**
4. Marque os padrões promovidos como `Promovido: sim` em `PADROES.md`
5. Avise: *"os projetos existentes só recebem isso quando você rodar `/harness upgrade` neles"*

## A regra que impede a skill de virar o monstro

> **A skill tem que poder encolher.**

Se depois de 5 evoluções ela só cresceu, algo está errado no julgamento — não no mundo. Harness
morre de acúmulo, e uma skill que cria harness morre do mesmo jeito, só que multiplicado por
todos os projetos dela.
