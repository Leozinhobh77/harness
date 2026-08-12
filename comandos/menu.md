# `menu` — lançador com último uso

> Chamado por `/menu-harness` ou por "menu", "menu harness", "quais comandos existem".
>
> Diferença do `/manual-harness`: o manual **ensina**; o menu **lança**. Aqui o usuário escolhe
> um número e o comando já roda — não se explica antes, a menos que ele peça.

## Fluxo

### 1. Leia `memoria/uso.json`

Se o arquivo não existir ou estiver vazio, trate todo comando como `nunca usado`.

### 2. Descubra o projeto atual

Olhe se o diretório de trabalho tem `.harness/manifesto.json`. Se tiver, use o campo `projeto`
de lá para o cabeçalho do grupo "DESTE PROJETO". Se não tiver, mostre "(nenhum projeto com
harness aqui)" no lugar do nome — os comandos de projeto continuam listados normalmente, só
o `init` fica mais relevante nesse caso.

### 3. Monte o menu — dois grupos, nesta ordem

**Grupo "DESTE PROJETO"** (na ordem): `init`, `doctor`, `fix`, `voltar`, `criticar`, `gauntlet`, `learn`, `upgrade`, `status`
**Grupo "DA SKILL"** (na ordem): `evolve`, `manual`, `exportar`

`voltar` fica **logo depois do `fix`**, no bloco de conserto. Quem abre o menu por causa de um
acidente precisa achar em um segundo — não depois de ler dez linhas.

Para cada um, pegue a descrição de uma linha da tabela abaixo e o último uso de
`memoria/uso.json` (chave = nome do comando). Formate a data como `DD/MM/AAAA`; se nunca usado,
escreva literalmente `nunca usado`.

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

### 4. Formato exato

```
🚀 MENU /harness · v<versão>

  DESTE PROJETO (<nome do projeto, ou "nenhum harness aqui">)
   1 · init      criar ou adotar a estrutura               <último uso>
   2 · doctor    auditar (nunca escreve)                   <último uso>
   3 · fix       corrigir o que o doctor achou             <último uso>
   4 · voltar    máquina do tempo — desfazer o que deu errado  <último uso>
   5 · criticar  comparar com a referência, às cegas       <último uso>
   6 · gauntlet  loop até vencer a barra (com freios)      <último uso>
   7 · learn     erro real → guarda permanente             <último uso>
   8 · upgrade   trazer melhorias da skill pro projeto     <último uso>
   9 · status    resumo rápido (10 linhas)                 <último uso>

  DA SKILL (global)
  10 · evolve    a skill melhora a si mesma                <último uso>
  11 · manual    abrir o manual completo                   <último uso>
  12 · exportar  publicar o manual (web/github/notion)     <último uso>

Digite o número do comando que quer rodar.
```

### 5. Ao escolher um número

Trate exatamente como se o usuário tivesse digitado o comando correspondente — carregue o
`comandos/<nome>.md` daquele item (a rota já está no `SKILL.md`) e siga as instruções de lá
normalmente, inclusive o registro de uso (§ "Registrar uso" no `SKILL.md`, que roda pra
**qualquer** jeito de invocar um comando, não só pelo menu).

Se o comando escolhido precisa de argumento (`learn` precisa da descrição do erro; `upgrade`
pode precisar de `--tier`), **pergunte o que falta** na mesma resposta em que confirma a
escolha — não peça pro usuário digitar o comando de novo com o argumento.

## Regras

- **Nunca despeje explicação de cada comando aqui.** Se o usuário quiser entender antes de
  rodar, isso é o `/manual-harness` — ofereça, não substitua.
- **Sucesso é o menu curto.** As 9 linhas cabem numa tela; não adicione colunas (contagem de
  uso, por exemplo) a menos que o usuário peça — foi decisão explícita não incluir isso por
  padrão.
- Se `memoria/uso.json` estiver corrompido (JSON inválido), não trave o menu — trate como vazio
  e mencione em uma linha que o arquivo parece corrompido.
