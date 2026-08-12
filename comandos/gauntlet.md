# `gauntlet` — o loop com freios

> O `criticar` roda **uma** rodada e devolve o gap. O `gauntlet` fecha o ciclo: corrige o gap,
> passa pelo portão, critica de novo — até vencer ou até um freio parar.
>
> **A diferença entre isto e o Gauntlet Loop original não é o loop — são os freios.** A versão
> "pure prompt" não tem portão, não tem rollback, não tem teto; o único freio é o usuário
> lembrar de existir. Aqui cada freio é um passo obrigatório do fluxo, porque a evidência é
> dura: o benchmark da área mediu 25% de resolução com **regressões em todos os perfis de
> loop**, e juiz LLM sem portão infla aprovação (0,72→0,94) com a qualidade real parada (0,20).

```
/harness gauntlet "refazer a home"               # teto padrão: 3 rodadas
/harness gauntlet "refazer a home" --rodadas 5
```

## Antes de rodar — nada é automático (regra 3 da skill)

1. **Ache a barra** em `referencias/INDICE.md`, igual ao `criticar` (passo 2 de lá). Sem barra
   aplicável → **pare** e ofereça criar uma. Loop sem barra é andar em círculo com estilo.
2. **Mostre o contrato e espere o OK explícito:**

```
🏟️ GAUNTLET — refazer a home
   barra:  referencias/visual/painel-stripe.png
   teto:   3 rodadas
   custo:  cada rodada ≈ um build + um criticar (subagente incluso)
   freios: portão determinístico · foto da sombra por rodada · platô · teto

   Cada rodada fica na sombra — /harness voltar desfaz qualquer uma.

Rodo? (é você quem paga as rodadas)
```

**Sem OK, nada roda.** E o usuário pode interromper a qualquer momento — o freio manual continua
sendo o freio final.

## Cada rodada — a ordem é o produto

```
1. FOTO           scripts/sombra.ps1 -Projeto "<raiz>" -Snapshot -Motivo "gauntlet rodada N: <mutação>"
2. BUILDER        rodada 1: construir/melhorar o alvo
                  rodadas 2+: corrigir SÓ o gap apontado
3. PORTÃO         build · testes · lint · doctor sem 🔴
4. CRÍTICO CEGO   criticar, passos 3–6 (captura → sorteio → subagente → decodifica)
5. DECISÃO        VENCEMOS → fim (vitória)
                  PERDEMOS → o gap é a tarefa da rodada N+1
```

### As regras de cada passo

**1 · Foto sempre, antes de tocar em qualquer coisa.** O motivo carrega o número da rodada e a
mutação — é o que faz o relatório final e o `/harness voltar` fazerem sentido.

**2 · Uma mutação por rodada.** Nas rodadas 2+, o builder corrige **só o gap apontado**. Nada de
"já que estou aqui, arrumo isso também" — mudança dupla torna impossível saber o que causou a
melhora ou a piora (disciplina de hill climbing). Se o builder notar outro problema, anota para
depois do loop.

**3 · Portão antes de crítico, sempre.** Quebrou o build/teste na mutação? O builder tenta
consertar **dentro da rodada**. Não conseguiu → **rollback pela foto desta rodada**
(`-Restaurar`) **e o loop para** com o motivo. Nunca se apresenta ao crítico um artefato que não
passa no portão — opinião estética sobre coisa quebrada é ruído pago.

**4 · O crítico é o mesmo do `criticar`** — subagente `critico-cego`, contexto limpo, sorteio
A/B fora do projeto, binário + 1 gap. Não duplique a instrução: siga `comandos/criticar.md`,
passos 3–6.

**5 · O builder não vê o transcript do crítico.** Ele recebe **só o texto do gap**. Histórico de
julgamentos anteriores no contexto do builder é o começo do reward hacking — ele aprende a
agradar o juiz em vez de melhorar o produto.

## As paradas — qualquer uma encerra

| Parada | Critério | O que fazer |
|---|---|---|
| 🏆 **Vitória** | crítico escolheu o nosso às cegas | relatório e fim |
| 🔢 **Teto** | rodadas esgotadas (padrão 3) | relatório com o último gap em aberto |
| 📉 **Platô** | o MESMO gap voltou duas vezes seguidas | parar — repetir a mesma correção não vai funcionar na terceira |
| 💥 **Regressão** | portão quebrou e não consertou na rodada | rollback + parar com o motivo |
| 🛑 **Você** | o usuário mandou parar | parar onde está, estado fica na sombra |

**Platô é parada, não desafio.** O mesmo gap duas vezes significa que o builder não sabe fechar
aquele gap sozinho — a terceira tentativa custa o mesmo e falha igual. O relatório entrega o gap
ao usuário, que decide com informação que o loop não tem.

## Relatório final — sempre, em qualquer parada

```
🏟️ GAUNTLET — refazer a home · encerrado: 🏆 vitória na rodada 2

  rodada │ mutação                      │ portão │ veredito
  ───────┼──────────────────────────────┼────────┼─────────────────────────
     1   │ construção inicial           │   ✅   │ ❌ gap: espaçamento irregular
     2   │ grade fixa de 16px           │   ✅   │ 🏆 VENCEMOS

  Cada rodada está na sombra → /harness voltar lista e desfaz qualquer uma.
```

Se a **vitória veio fácil** (rodada 1, e não é a primeira vez que a barra perde de primeira),
acrescente uma linha: *"essa barra pode estar baixa demais para ensinar — vale procurar uma mais
dura?"*. Barra que sempre perde não é barra, é plateia.

## O que o `gauntlet` NUNCA faz

- ❌ **Rodar sem OK explícito** — o custo é do usuário, a decisão também
- ❌ **Nota, score, telemetria de rodadas em arquivo** — métrica acumulada é o alvo que o
  reward hacking precisa; o veredito é binário e morre com a rodada
- ❌ **Mais de uma mutação por rodada** — mesmo que "óbvio", mesmo que "rapidinho"
- ❌ **Apresentar ao crítico artefato reprovado no portão**
- ❌ **Continuar depois de um platô** — duas repetições encerram
- ❌ **Mexer no teto sozinho** — acabaram as rodadas, acabou; o usuário decide se estende

## Quando usar `criticar` e quando usar `gauntlet`

| Situação | Use |
|---|---|
| quer saber onde está o maior gap | `criticar` (uma rodada, barato) |
| gap conhecido, quer fechar e conferir | `criticar` de novo depois de corrigir |
| quer entregar algo NO NÍVEL da barra e tem orçamento pra iterar | `gauntlet` |
| não tem referência em `referencias/` | nenhum dos dois — monte a barra primeiro |
