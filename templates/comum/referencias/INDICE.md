# REFERÊNCIAS — a barra a bater

> **Isto não é inspiração. É a barra.** Inspiração é o que te anima; barra é contra o que o
> trabalho é comparado. Só a segunda serve para alguém dizer "ainda não chegou".
>
> 📌 Este índice é o **único arquivo lido por padrão** desta pasta. Ele custa zero token por
> sessão — só é aberto quando alguém vai trabalhar em algo que tem referência aqui.

## A regra de entrada — 3 critérios, todos obrigatórios

| Critério | Significa | Reprova |
|---|---|---|
| **Nomeada** | uma coisa específica, não uma categoria | ❌ "design moderno" |
| **Buscável** | dá para abrir, ler, rodar ou ver | ❌ link que não abre |
| **Inspecionável** | dá para pôr lado a lado e comparar | ❌ "elegante" |

Se você não consegue escrever **o que naquele arquivo é a barra**, ele ainda não é referência —
é arquivo solto. Deixe fora até saber.

## O que tem aqui

| Arquivo | O que nele é a barra | Vale para |
|---|---|---|
| _(vazio — a primeira referência entra aqui)_ | — | — |

---

## A prateleira

| Pasta | O que vai dentro | A IA lê hoje? |
|---|---|---|
| `visual/` | prints, telas, paletas, layouts | ✅ direto |
| `personagens/` | consistência de personagem, marca, produto | ✅ direto |
| `texto/` | tom de voz · exemplo bom **e** exemplo ruim | ✅ direto |
| `documentos/` | PDF, briefing, spec de terceiro | ✅ direto |
| `dados/` | JSON, CSV, esquema de exemplo | ✅ direto |
| `mapas/` | `.canvas`, diagrama, mapa mental | ✅ como texto |
| `audio/` | gravação, referência sonora | ⚠️ **precisa de companheira** |
| `video/` | trecho, animação, referência de movimento | ⚠️ **precisa de companheira** |

### A regra da companheira

Áudio e vídeo **ainda não são lidos direto**. Todo arquivo dessas duas pastas entra com um `.md`
do lado, mesmo nome:

```
video/transicao-suave.mp4
video/transicao-suave.md      ← o que tem no vídeo, e o que nele é a barra
```

Hoje a IA lê a companheira. Quando ela passar a ler o arquivo direto, **o arquivo já está aqui** —
nada a refazer. Para vídeo, vale extrair 2 ou 3 quadros-chave como `.png` e guardar em `visual/`:
isso funciona hoje, sem esperar nada.

### Arquivo grande

Vídeo e áudio pesados incham o git e a sombra. Se passar de ~10 MB, prefira guardar o link e um
quadro-chave, em vez do arquivo inteiro. O `/harness doctor` avisa quando a sombra cresce demais.

---

## Como isto é usado

- **Ao construir:** leia a referência aplicável **antes**, não depois.
- **Ao conferir:** `/harness criticar` compara o resultado real contra a barra daqui, às cegas.
- **Ao errar:** o erro vira linha escrita na referência. É assim que ela fica boa — igual ao
  `/harness learn`, mas para consistência em vez de guarda.
