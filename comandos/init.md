# `init` — criar (ou adotar) o harness de um projeto

> **Você é um compilador, não um copiador.** A entrada é o projeto real; a saída é um harness
> dimensionado a ele. Nunca despeje o mesmo pacote em todo mundo.

## O fluxo — 5 passos, nesta ordem

### Passo 1 — INVESTIGUE antes de perguntar

Nunca pergunte o que dá para descobrir sozinho. Olhe o disco:

```
• É repositório git?  Working tree limpo?
• Quantos arquivos de código? Que linguagem/stack?
• Já existe AGENTS.md / CLAUDE.md / docs/ / .claude/ ?
• Tem README? Ele já diz o que o projeto é?
• Tem .harness/manifesto.json? → é ADOÇÃO, não criação (pule para /harness upgrade)
```

Diga em 2–3 linhas o que encontrou. Isso prova que você olhou, e o usuário confia mais no que
vem depois.

### Passo 2 — CLASSIFIQUE e proponha um tier

Leia `criterios/TIERS.md`. Aplique a **Lei 5**: o menor tier defensável.

Faça no máximo **3 perguntas**, em linguagem simples (o usuário não sabe o que é "tier"):

1. *"Isso é um teste rápido ou algo que você vai usar de verdade por meses?"*
2. *"Vai guardar dado sensível — dinheiro, dado pessoal, senha?"*
3. *"Só você mexe, ou mais gente?"*

Se o usuário já explicou o projeto na conversa, **não repergunte** — infira e confirme numa frase.

Apresente assim:

```
Proponho T2 · Padrão.
Por quê: app que você vai usar por meses, com dado financeiro seu, uso solo.
Custo: ~2.500 tokens por sessão.
Dá pra subir depois com um comando — o gatilho aparece sozinho.
```

**Espere o OK.** Não gere nada antes.

### Passo 3 — COLETE o mínimo para escrever

Só o que você não consegue inferir:

| Precisa saber | Como obter |
|---|---|
| O que o projeto faz (1 parágrafo) | perguntar, ou pegar da conversa |
| Stack/linguagem | detectar no disco; perguntar só se vazio |
| O que **nunca** pode ser tocado/commitado | **sempre perguntar** — é a guarda mais importante |
| **Vai entrar chave, senha ou token?** | **sempre perguntar** — ver abaixo |
| Como roda / como testa | detectar (`package.json`, etc.) ou perguntar |

⚠️ As duas linhas em negrito são as únicas perguntas obrigatórias em qualquer tier. São a
exceção da Lei 1: guarda de dado entra preventivamente porque perder — ou vazar — dado não tem
desfazer.

**Se a resposta sobre credencial for sim**, gere os dois arquivos no Passo 4:

- `.env` — com as variáveis **vazias** e um comentário dizendo onde pegar cada valor
- `.env.example` — o modelo versionado (copie de `templates/comum/env-example.tpl`)

E confira que o `.gitignore` tem a exceção `!.env.example`. Sem ela, a regra `.env.*` engole o
próprio modelo e ninguém descobre quais variáveis o projeto usa.

> **Procedência (13/08/2026, Vórtex):** o usuário informou que usaria uma chave de API paga. Eu
> protegi a chave em quatro lugares e **esqueci de criar o arquivo onde ela mora** — foi ele
> quem lembrou. Proteção sem o lugar certo para guardar empurra a pessoa a colar o segredo em
> qualquer canto.

### Passo 4 — GERE

Copie de `templates/<tier>/` e **preencha de verdade** — nunca deixe `<placeholder>` no arquivo
final. Se você não sabe o que escrever num campo, **corte a seção** em vez de deixar genérico
(Lei 1).

Ordem de geração:
1. `.gitignore` e as guardas de dado — **primeiro**, antes de existir risco
2. **A sombra** — `.claude/hooks/sombra.ps1` (de `templates/comum/`) + a entrada dela no
   `settings.json`. **Todo tier, inclusive T1.** É a rede de segurança; ela nasce antes de
   existir o que salvar, senão o primeiro acidente acontece sem foto nenhuma.

   ⚠️ **E tire a foto de nascimento na hora, à mão:**
   ```
   powershell -File <skill>/scripts/sombra.ps1 -Projeto "<raiz>" -Snapshot -Motivo "nascimento do harness"
   ```
   **Isto não é zelo, é buraco tapado.** O hook só dispara na **próxima** sessão. Sem esta
   chamada, o projeto passa todo o dia do parto — que é justamente quando mais se mexe nele —
   **sem uma única foto**, e o `/harness voltar` não tem para onde voltar.
   *Procedência: o `doctor` acusou "Sem sombra" num projeto recém-criado em 13/08/2026.*
3. `AGENTS.md`
4. Resto do tier
5. **A prateleira de referências** (T2+) — `referencias/` com `INDICE.md` e as 8 pastas, cada
   uma com `.gitkeep`. Copie o índice de `templates/comum/referencias/`.
   ⚠️ **Crie a prateleira inteira, mesmo vazia.** Pasta vazia custa **zero token** — só o
   `INDICE.md` tem conteúdo, e ele é leitura sob demanda. O motivo é de adoção, não técnico:
   *estrutura que não se vê não é lembrada*, e referência que ninguém lembra de pôr não existe.
   Junto: `.claude/agents/critico-cego.md` (de `templates/comum/`).
6. `.claude/settings.json` completo + demais hooks (T2+)
7. `.harness/manifesto.json`
8. `.env` + `.env.example` — **só se a resposta sobre credencial foi sim** (ver Passo 3)
9. `ESTADO.md` — **por último**, rodando `scripts/estado.ps1` (ele é gerado, nunca escrito)
10. `git init` se ainda não for repo (**pergunte antes**)

### Passo 5 — REGISTRE e prove

1. Acrescente uma linha em `memoria/REGISTRO.md` (projeto, caminho, tier, data, versão da skill)
2. Incremente `projetos_criados` em `VERSAO.json`
3. **Rode `/harness doctor`** no que você acabou de criar. Se o seu próprio parto não passa no
   seu próprio exame, conserte antes de entregar.
4. Mostre ao usuário: árvore de arquivos + as 3 coisas que ele precisa saber para usar

---

## As regras de ouro do `init`

**Nunca escreva regra genérica.** Lei 1. Se você se pegar escrevendo *"sempre escreva código
limpo"* ou *"prefira nomes descritivos"*, apague. O modelo já sabe. Isso não é neutro — mede-se
piora com esse tipo de linha.

**Preencha ou corte.** `<TODO>` num harness recém-nascido é dívida que ninguém paga.

**As guardas primeiro.** `.gitignore` e o hook de bloqueio nascem antes de qualquer código.

**Nada de "estado atual" dentro de arquivo estático.** Informação que muda toda hora vai para
`ESTADO.md`, que é gerado. Meter isso no `CLAUDE.md` é anti-padrão nomeado.

---

## Se o projeto JÁ TEM estrutura (adoção)

Não sobrescreva nada. Trate como migração:

1. Rode o `doctor` no que existe
2. Mostre um **diff**: o que já está bom · o que falta · o que está inchado
3. Proponha as mudanças **uma a uma**, com o motivo de cada
4. Aplique só o aprovado
5. Crie o `.harness/manifesto.json` marcando `"adotado": true`

Estrutura que o usuário construiu à mão tem valor sentimental e prático. Você **acrescenta a
espinha mecânica**, não substitui o trabalho dele.
