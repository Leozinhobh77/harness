# `voltar` — a máquina do tempo do projeto

> As outras guardas impedem o erro. Esta aceita que um dia um erro passa, e garante que
> **dá para voltar**. É o único comando da skill que existe para o momento em que tudo já deu errado.
>
> **Fale como se o usuário estivesse com medo** — porque provavelmente está. Nada de "commit",
> "hash", "HEAD". Diga *foto*, *voltar*, *o que mudou*.

## O que a sombra cobre (e por que ela existe)

O `/rewind` nativo do Claude Code desfaz **só o que as ferramentas de edição fizeram**. Arquivo
apagado ou sobrescrito por comando de shell não volta por ele, e nada volta depois de 30 dias.

A sombra cobre exatamente esse buraco: um repositório git separado em `.harness/sombra.git`, que
fotografa o projeto **antes de cada ação de risco**. Não é o git do usuário, não polui o `git log`
dele, não entra nos commits dele.

## Fluxo

```
1. Tem .harness/sombra.git?  →  não: ofereça /harness upgrade e pare
2. scripts/sombra.ps1 -Projeto "<raiz>" -Listar
3. Mostre a lista (formato abaixo) e espere a escolha
4. Antes de restaurar: SEMPRE mostre o -Diff daquela foto primeiro
5. Confirmado: scripts/sombra.ps1 -Projeto "<raiz>" -Restaurar N
6. Diga o que voltou, e que o estado anterior virou foto 1
```

## Formato da lista

```
🕰️  SOMBRA — Meu Site          14 fotos · 2,3 MB

   1 · há 4 min      antes de: rm -rf dist/           3 arquivos
   2 · há 22 min     antes de editar index.html       1 arquivo
   3 · há 1 hora     antes de: git checkout main      8 arquivos
   4 · hoje 09:14    início da sessão                 —

Qual número? (ou "d 2" para ver o que mudou desde a foto 2)
```

**Número 1 é sempre a mais recente.** Isso é de propósito: em pânico, ninguém quer contar de trás
pra frente.

## A regra que não se quebra

> **Nunca restaure sem mostrar o que vai mudar.**

Rode `-Diff N` e mostre o resultado **antes** de perguntar se pode. Restaurar é escrita em cima do
trabalho do usuário; ele tem que ver o tamanho do estrago antes de dizer sim.

E diga sempre a frase que tira o medo:

```
O estado de agora vira foto também, antes de eu mexer. Dá para desfazer isto.
```

## O que o `-Restaurar` faz (e o que ele NÃO faz)

| Faz | Não faz |
|---|---|
| Tira uma foto do estado atual **primeiro** | ❌ Apagar arquivo criado depois da foto |
| Devolve ao disco o conteúdo daquela foto | ❌ Mexer no git do usuário (branch, commit, stash) |
| Recria arquivo que tinha sido apagado | ❌ Restaurar `node_modules/` (é excluído — rode o install) |
| Lista o que sobrou de novo, para você decidir | ❌ Perguntar duas vezes: uma confirmação basta |

Arquivo criado **depois** da foto continua no disco. Isso não é bug — é a regra "nada é apagado"
da skill inteira. O script lista esses arquivos; quem decide apagar é o usuário.

## Quando o projeto não tem sombra

```
Este projeto ainda não tem sombra — nasceu antes dela existir (v1.4.0).
→ /harness upgrade  liga ela em 1 minuto, sem mexer em nada seu.
```

## Manutenção

`/harness voltar --limpar` roda `-Limpar`: compacta o repositório da sombra. **Não apaga foto
nenhuma** — só reorganiza. O `doctor` avisa quando o tamanho merece atenção.

> Guarda de segurança de dado **nunca é candidata a abate** (Lei 4, e está escrito em
> `comandos/fix.md`). A sombra ter 0 restaurações é o sucesso dela, não o fracasso.
