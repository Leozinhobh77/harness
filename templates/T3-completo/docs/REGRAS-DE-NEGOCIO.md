# REGRAS DE NEGÓCIO — {{PROJETO}}

> As regras que, se quebrarem, o usuário **só descobre tarde demais**. É por isso que este
> documento existe separado — e por isso cada regra aqui **tem que ter um teste**.
>
> ⚠️ **Regra sem teste é só um parágrafo bonito.** Prosa nunca avisa quando é violada.

## Como escrever uma regra aqui

Toda regra segue este formato. Sem exceção:

```markdown
### RN0NN — <nome curto da regra>
**Regra:** <o comportamento, sem ambiguidade>
**Por quê:** <o que acontece de ruim se quebrar>
**Exemplos:**
  - entrada X → saída Y
  - caso de borda Z → comportamento W
**Teste:** `<caminho/do/teste>` · `<nome do caso>`
**Procedência:** <de onde veio esta regra — pedido do usuário, bug real, etc.>
```

O campo **Teste** não é opcional. Se ainda não existe teste, escreva `⛔ SEM TESTE` — e o
`/harness doctor` vai cobrar. Uma regra marcada assim é dívida, não documentação.

## Cobertura

| Regra | Teste existe? |
|---|---|
| — | — |

> Meta: 100%. `/harness doctor` reprova regra sem teste em projeto T3.

---

## As regras

_(a primeira regra entra abaixo)_

{{REGRAS}}
