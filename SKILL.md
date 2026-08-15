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
| "menu", "menu harness", "quais comandos existem" | `comandos/menu.md` | Lançador: escolha um número e ele executa |

**Não carregue mais de um comando por vez.** Se o pedido couber em dois, pergunte qual.

## 🔌 A trava de estrutura desatualizada

**Antes de construir, corrigir ou implantar qualquer coisa num projeto**, olhe o `ESTADO.md`
dele. Se trouxer o bloco **ESTRUTURA DESATUALIZADA com item `[SEGURANCA]`**, diga isso **antes**
de começar o que foi pedido:

> *"Antes: a estrutura deste projeto está na v1.7.0 e tem 1 correção de segurança pendente —
> `<título>`. Aplico o `upgrade` primeiro? (leva segundos e não mexe no seu código)"*

Depois faça o que ele decidir. **Ele pode dizer "depois", e "depois" é resposta legítima** — o
aviso informa, não obriga.

**Por que esta regra existe (15/08/2026):** a skill evolui aqui; os projetos ficam onde estão.
Sair aplicando correção em 20 ou 30 projetos a cada versão inverteria o propósito — mexer na
skill viraria manutenção alheia. O modelo é **pull**: a skill nunca empurra, o projeto descobre
sozinho ao ser aberto (`memoria/MIGRACOES.json` → `scripts/_migracoes.ps1` → aviso no `ESTADO.md`
e achado no `doctor`). Esta linha é só o que o **agente faz** com o aviso que o mecanismo já deu.

⚠️ **Só vale para item de segurança.** Pendência de rotina não interrompe trabalho nenhum —
guarda que interrompe à toa é guarda que o usuário desliga.

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
│                        comum/ ESTADO.tpl · ESTADO-pendencias.tpl · sombra.ps1
│                               critico-cego.md · REGRAS-DE-NEGOCIO.md (T2+) · referencias/
├── scripts/              doctor.ps1 · estado.ps1 · versao.ps1 · sombra.ps1
│                        _migracoes.ps1 — "o que este projeto ainda não aplicou"
├── manual/               MANUAL.md — 📌 fonte única do manual
├── docs/                 index.html — página publicada (GitHub Pages), saída do --exportar
└── memoria/              REGISTRO · PADROES · CHANGELOG
                          MIGRACOES.json — 📌 o que um PROJETO precisa aplicar (modelo pull)
```

> **Esta árvore é a fonte única da estrutura.** O `README.md` aponta para cá em vez de manter
> uma cópia — enquanto existiram duas, uma desatualizou sem ninguém notar (v1.3.3).

## Uma regra sobre o manual

`manual/MANUAL.md` é a **fonte única**. A página web e o Notion são cópias publicadas. Pedido para
"arrumar a página" = corrigir o `MANUAL.md` e rodar `/harness manual --exportar`. Nunca edite a
saída — é assim que deriva nasce.

## Idioma

Português do Brasil, sempre — com o usuário e nos arquivos gerados.
