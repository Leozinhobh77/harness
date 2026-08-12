---
name: harness
description: Cria, audita, mantém e evolui o harness de governança de qualquer projeto (AGENTS.md, hooks, planos, decisões). Use quando o usuário pedir para criar a estrutura de um projeto novo, auditar/limpar a estrutura de um projeto existente, transformar um erro recorrente em guarda permanente, ou evoluir a própria skill. Gatilhos - /harness, criar estrutura do projeto, montar harness, auditar estrutura, doctor, estrutura de governança.
---

# /harness — construtor e curador de harness

> **Um harness é o esqueleto de governança que faz uma IA trabalhar bem num projeto:**
> `AGENTS.md`, hooks que impedem erro, planos com baixa obrigatória, decisões registradas.
>
> Esta skill **cria** esse esqueleto dimensionado ao projeto, **audita** se ele está saudável,
> **aprende** com cada erro real, e **evolui a si mesma** com o que aprende entre projetos.

## ⚠️ Antes de qualquer coisa (toda invocação)

1. Rode `scripts/versao.ps1` e mostre a **linha de status** que ele retornar.
   - Se ele devolver `OK`, **não diga nada sobre versão** — silêncio é sucesso.
   - Se devolver um aviso, mostre em **uma linha só**, no fim da resposta. Nunca sermão.
2. Leia `CONSTITUICAO.md`. As 5 leis valem para tudo que você fizer aqui — inclusive
   para mudanças na própria skill.

## Roteamento — carregue só o comando pedido

| Pedido do usuário | Carregue | O que faz |
|---|---|---|
| `/harness` sozinho, "como está a estrutura" | `comandos/status.md` | Situação do projeto atual em 10 linhas |
| "criar estrutura", "montar harness", `init` | `comandos/init.md` | Cria (ou adota) o harness do projeto |
| "auditar", "conferir", "está ok?", `doctor` | `comandos/doctor.md` | Diagnostica. **Nunca escreve.** |
| "corrigir", "arrumar", "limpar", `fix` | `comandos/fix.md` | Aplica o que o doctor achou |
| "a IA errou X", "isso não pode repetir", `learn` | `comandos/learn.md` | Erro → guarda permanente |
| "voltar", "desfazer", "apagou meu arquivo", "socorro" | `comandos/voltar.md` | Máquina do tempo — restaura pelas fotos da sombra |
| "está bom?", "compara com a referência", `criticar` | `comandos/criticar.md` | Comparação cega contra a barra de `referencias/` |
| "roda o loop", "itera até vencer", `gauntlet` | `comandos/gauntlet.md` | Loop builder→portão→crítico com freios — até vencer a barra |
| "evoluir a skill", "melhorar você", `evolve` | `comandos/evolve.md` | A skill audita e melhora a si mesma |
| "atualizar este projeto", `upgrade` | `comandos/upgrade.md` | Traz melhorias da skill pro projeto |
| "manual", "ajuda", "como usa" | `comandos/manual.md` | Manual navegável por número |
| "exportar o manual", "publicar", `--exportar` | `comandos/exportar.md` | Publica o manual (web / Notion) |
| "menu", "menu harness", "quais comandos existem" | `comandos/menu.md` | Lançador com último uso de cada comando |

**Não carregue mais de um comando por vez.** Se o pedido couber em dois, pergunte qual.

## Registrar uso (toda vez que um comando roda — não só pelo menu)

Depois de carregar qualquer `comandos/<nome>.md` desta tabela **e terminar de executá-lo**,
atualize `memoria/uso.json`: `{"<nome>": {"data": "<hoje, AAAA-MM-DD>", "projeto": "<nome do
projeto atual, ou null>"}}`. Isso alimenta o `/menu-harness` — sem esse passo, o menu mostra
"nunca usado" pra tudo, mesmo em comando que acabou de rodar. **Exceção: não registre o próprio
`menu`** — ele é o painel que exibe os outros, registrar ele mesmo seria autorreferente e sem
sinal nenhum (a data seria sempre "agora"). `status` é registrado normalmente como qualquer
outro comando.

## As 3 regras que você nunca quebra

1. **`doctor` nunca escreve. `fix` nunca decide.** Diagnóstico e tratamento são separados —
   é isso que deixa o usuário confiar em rodar `doctor` a qualquer hora.
2. **Mecânico vence escrito.** Se dá pra virar hook, vira hook. Texto em `AGENTS.md` é o
   último recurso, não o primeiro.
3. **Nada é automático.** Você **propõe** com o motivo na mão; o usuário aprova. Isso vale
   para subir de tier, abater regra, e mudar a própria skill.

## Onde fica cada coisa

```
harness/
├── SKILL.md              este arquivo — só roteia
├── CONSTITUICAO.md       as 5 leis anti-inchaço
├── README.md             vitrine do repositório — não é lido em execução
├── VERSAO.json           versão + datas (máquina)
├── .gitignore
├── comandos/             a instrução de cada comando
├── criterios/            TIERS · ORCAMENTOS · CHECKS
├── templates/            T1-leve · T2-padrao (não existe T3 — ver TIERS.md)
│                        comum/ ESTADO.tpl · sombra.ps1 · critico-cego.md
│                               REGRAS-DE-NEGOCIO.md (T2+) · referencias/
├── scripts/              doctor.ps1 · estado.ps1 · versao.ps1 · sombra.ps1
├── manual/               MANUAL.md — 📌 fonte única do manual
├── docs/                 index.html — página publicada (GitHub Pages), saída do --exportar
└── memoria/              REGISTRO · PADROES · CHANGELOG · uso.json (p/ /menu-harness)
```

> **Esta árvore é a fonte única da estrutura.** O `README.md` aponta para cá em vez de manter
> uma cópia — enquanto existiram duas, uma desatualizou sem ninguém notar (v1.3.3).

## Uma regra sobre o manual

`manual/MANUAL.md` é a **fonte única**. A página web e o Notion são cópias publicadas. Pedido para
"arrumar a página" = corrigir o `MANUAL.md` e rodar `/harness manual --exportar`. Nunca edite a
saída — é assim que deriva nasce.

## Idioma

Português do Brasil, sempre — com o usuário e nos arquivos gerados.
