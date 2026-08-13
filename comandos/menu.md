# `menu` — o lançador

> Chamado por `/menu-harness` ou por "menu", "menu harness", "quais comandos existem".
>
> Diferença do `/manual-harness`: o manual **ensina**; o menu **lança**. Aqui o usuário escolhe
> um número e o comando já roda — não se explica antes, a menos que ele peça.

> **O menu não mostra mais "último uso" (abatido na v1.8.0).**
> Ele vinha de `memoria/uso.json`, alimentado por um passo escrito no `SKILL.md` pedindo ao
> agente que registrasse cada execução. **Não funcionava:** em 13/08/2026 o `criticar` rodou
> duas vezes e continuou marcado como "nunca usado"; o `learn` idem, por dois ciclos.
> Era a Lei 2 sendo violada — pedido escrito no lugar de mecanismo — e **dado errado é pior que
> dado nenhum**: o menu afirmava com confiança algo falso. Se um dia houver como registrar
> mecanicamente, a coluna volta.

## Fluxo

### 1. Descubra o projeto atual

Olhe se o diretório de trabalho tem `.harness/manifesto.json`. Se tiver, use o campo `projeto`
de lá para o cabeçalho do grupo "DESTE PROJETO". Se não tiver, mostre "(nenhum projeto com
harness aqui)" no lugar do nome — os comandos de projeto continuam listados normalmente, só
o `init` fica mais relevante nesse caso.

### 2. Monte o menu — dois grupos, nesta ordem

**Grupo "DESTE PROJETO"** (na ordem): `init`, `doctor`, `fix`, `voltar`, `criticar`, `gauntlet`, `learn`, `upgrade`, `status`
**Grupo "DA SKILL"** (na ordem): `evolve`, `manual`, `exportar`

`voltar` fica **logo depois do `fix`**, no bloco de conserto. Quem abre o menu por causa de um
acidente precisa achar em um segundo — não depois de ler dez linhas.

Para cada um, pegue a descrição de uma linha da tabela abaixo.

| Comando | Descrição de uma linha |
|---|---|
| `init` | criar ou adotar a estrutura |
| `doctor` | auditar (nunca escreve) |
| `fix` | corrigir o que o doctor achou |
| `voltar` | máquina do tempo — desfazer o que deu errado |
| `criticar` | comparar com a referência, às cegas |
| `gauntlet` | loop até vencer a barra (com freios) |
| `learn` | erro real → guarda permanente |
| `upgrade` | trazer melhorias da skill pro projeto |
| `status` | resumo rápido (10 linhas) |
| `evolve` | a skill melhora a si mesma |
| `manual` | abrir o manual completo |
| `exportar` | publicar o manual (web/github/notion) |

### 3. Formato exato

```
🚀 MENU /harness · v<versão>

  DESTE PROJETO (<nome do projeto, ou "nenhum harness aqui">)
   1 · init      criar ou adotar a estrutura
   2 · doctor    auditar (nunca escreve)
   3 · fix       corrigir o que o doctor achou
   4 · voltar    máquina do tempo — desfazer o que deu errado
   5 · criticar  comparar com a referência, às cegas
   6 · gauntlet  loop até vencer a barra (com freios)
   7 · learn     erro real → guarda permanente
   8 · upgrade   trazer melhorias da skill pro projeto
   9 · status    resumo rápido (10 linhas)

  DA SKILL (global)
  10 · evolve    a skill melhora a si mesma
  11 · manual    abrir o manual completo
  12 · exportar  publicar o manual (web/github/notion)

Digite o número do comando que quer rodar.
```

### 4. Ao escolher um número

Trate exatamente como se o usuário tivesse digitado o comando correspondente — carregue o
`comandos/<nome>.md` daquele item (a rota já está no `SKILL.md`) e siga as instruções de lá
normalmente.

Se o comando escolhido precisa de argumento (`learn` precisa da descrição do erro; `upgrade`
pode precisar de `--tier`), **pergunte o que falta** na mesma resposta em que confirma a
escolha — não peça pro usuário digitar o comando de novo com o argumento.

## Regras

- **Nunca despeje explicação de cada comando aqui.** Se o usuário quiser entender antes de
  rodar, isso é o `/manual-harness` — ofereça, não substitua.
- **Sucesso é o menu curto.** As 12 linhas cabem numa tela. Não adicione coluna nenhuma —
  a de "último uso" já foi tentada e abatida na v1.8.0 por publicar dado falso.
