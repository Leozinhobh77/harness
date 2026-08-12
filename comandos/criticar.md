# `criticar` — a comparação cega contra a barra

> Uma rodada. **Sem loop.** Você olha o gap, decide se conserta, e chama de novo se quiser.
>
> A evidência que sustenta este comando é do crítico **existir** (um critic loop matou ~78% dos
> defeitos restantes num estudo pré-registrado de 2026), não de ele rodar sozinho a noite toda.
> O loop autônomo é onde mora o reward hacking medido — ver `manual/MANUAL.md` §4.9.

```
/harness criticar                  # o que acabou de ser feito
/harness criticar app/index.html
```

## Fluxo — a ordem é o produto

### 1. Portão determinístico — **primeiro, sempre**

Antes de gastar um único token de crítico, o que a máquina consegue responder sozinha:

```
build passa? · teste passa? · lint limpo? · /harness doctor sem 🔴?
```

**Falhou? Pare aqui e reporte.** Não se pede opinião estética sobre coisa que nem roda. Esta
ordem não é preciosismo: é o mecanismo que derrubou amplificação de erro de 1,7% para 0,1% no
estudo de *evidence-gated control*.

### 2. Ache a barra

Leia `referencias/INDICE.md` e escolha a referência aplicável ao alvo.

- **Nenhuma serve?** Diga isso e pare. *Sem barra não existe crítica — existe opinião.*
- Ofereça: *"quer colocar uma referência em `referencias/` e eu rodo de novo?"*

### 3. Capture o artefato **real**

| Alvo | Como capturar |
|---|---|
| página / tela | **screenshot de verdade** (Playwright), não o HTML |
| componente | screenshot do componente renderizado |
| código | o arquivo |
| texto | o texto |

Sem Playwright disponível, use o fonte — mas **diga ao usuário** que a crítica visual fica fraca
sem pixel de verdade.

### 4. Sorteie A e B

Copie os dois para uma pasta de rascunho **fora do projeto**, renomeados `A.<ext>` e `B.<ext>`.

⚠️ **O mapa de quem é quem fica só com você.** Nunca escreva num arquivo: o crítico tem `Read`, e
acharia. Fora do projeto para ele não descobrir por vizinhança de pasta.

### 5. Chame o `critico-cego`

Subagente, contexto limpo, só leitura, Sonnet. Passe **apenas**: os dois caminhos e o propósito
declarado do artefato. Nada de história, nada de "fizemos assim porque".

### 6. Decodifique e reporte

```
🔍 CRÍTICA — app/index.html
   barra: referencias/visual/painel-stripe.png

   ✅ portão: build ok · 12 testes ok · doctor limpo

   RESULTADO: perdemos

   MAIOR GAP
   O espaçamento entre os cartões varia de 8 a 24px sem motivo aparente;
   na barra é constante em 16px.

   ONDE VER
   app/index.html — a grade de cartões, primeira dobra

→ quer que eu conserte esse gap? (eu não mexi em nada)
```

## As regras que não se quebram

**Não conserte.** Descobrir e consertar na mesma respiração é como o builder volta a corrigir a
própria prova. Reporte, e espere.

**Uma rodada.** Se o usuário pedir outra, rode outra — mas a decisão é dele, a cada vez. É ele o
freio.

**Binário, nunca nota.** Sem "7 de 10". Nota vira alvo, e alvo é otimizado no lugar do produto:
mediu-se um juiz indo de 0,72 a 0,94 de aprovação com a acurácia real parada em 0,20.

**Perder é resultado bom.** Um crítico que sempre aprova não está funcionando — está sendo
educado. Se três críticas seguidas vencerem, desconfie da barra: ela provavelmente está baixa
demais para ensinar alguma coisa.

## Quando NÃO usar

- Não há referência e não faz sentido criar uma (script interno, tarefa de uma linha)
- O portão determinístico ainda está vermelho — conserte aquilo primeiro
- O trabalho não acabou; criticar rascunho gasta token e gera gap que você já ia arrumar
