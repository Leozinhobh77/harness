# REGISTRO — projetos criados por esta skill

> Lido pelo `/harness evolve` na etapa de varredura. Cada projeto aqui é uma fonte de
> aprendizado — é a partir desta lista que a skill acha convergência entre projetos.
>
> ⚠️ **Nunca apague uma linha.** Projeto que sumiu do disco vira `arquivado` — o que ele ensinou
> continua valendo.

| Projeto | Caminho | Tier | Criado em | Versão da skill | Estado |
|---|---|---|---|---|---|
| Finanças | `~/Desktop/Projetos/Finanças` | T2+ | 2026-07-26 | v1.0.0 (nascido) · v1.11.1 (atual) | `ativo` |
| Zenith Invest | `~/Desktop/Projetos/Zenith Invest` | T2+ | 2026-07-30 | v1.3.2 (nascido) · v1.11.1 (atual) | `ativo` |
| Central de Projetos e MCPs | `~/Desktop/Projetos/Central de Projetos e MCPs (Computador)` | T2 | 2026-08-11 | v1.3.3 (nascido) · v1.11.1 (atual) | `ativo` |
| Vórtex | `~/Desktop/Projetos/Vórtex` | T2+ | 2026-08-12 | v1.7.0 (nascido) · v1.11.1 (atual) | `ativo` |

> **Varredura do `evolve` de 2026-08-12:** os 3 vivos, 0 🔴, custo entre 2.028 e 2.236
> tokens/sessão. A convergência achada (P011) saiu de Zenith + Central. Finanças trocou a guarda
> `sem-push` pela `sem-push-force` no mesmo dia (a antiga foi para `.harness/abatidos/`).

> **Rodada de `upgrade` de 2026-08-15 (v1.11.1):** os 4 sincronizados. O upgrade era de rotina e
> virou achado — o `matcher` do `settings.json` dos quatro ainda estava sem `PowerShell`, então a
> correção de segurança da v1.8.0 (P012) **nunca tinha rodado**: o código do `guarda.ps1` estava
> certo e o hook não era chamado. Foto da sombra antes, `doctor` depois: Central e Vórtex limpos,
> Finanças e Zenith com `ESTADO.md` fora de dia (se regenera sozinho na próxima sessão). 🔎 Zenith
> com `log-guardas.jsonl` vazio — o próximo `evolve` confere se é desuso ou hook parado.

> **Vórtex** é o primeiro projeto **nascido inteiro na v1.7.0** — e o primeiro criado como teste
> deliberado da skill, não por necessidade. Serve de linha de base: tudo que doer nele é dor de
> nascimento, sem herança de versão antiga para culpar.

## Estados

- `ativo` — existe no disco e está em uso
- `arquivado` — sumiu do disco ou foi abandonado; o aprendizado dele continua contando
- `adotado` — já tinha estrutura própria; o harness foi acrescentado por cima
