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
| Cidade Isométrica | `~/Desktop/Projetos/cidade-isometrica` | T2 | 2026-08-16 | v1.13.0 (nascido) | `ativo` |
| Mentor24h | `~/Desktop/Projetos/Mentor24h-V4` | T2+ | 2026-08-23 | v1.13.0 (nascido) | `ativo` |

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

> **Cidade Isométrica** (2026-08-16) é o primeiro nascido na v1.13.0 e o primeiro **T2 raso** do
> registro — todos os anteriores são T2+ ou T2 de projeto com dado sensível. Serve para medir se o
> T2 sem `REGRAS-DE-NEGOCIO.md` é confortável ou se falta algo. Também é o primeiro cuja guarda de
> nascimento (`sem-overpass-area-grande`) veio de **risco documentado antes da primeira linha de
> código**, não de erro cometido — a ficha da ideia de origem (`banco-de-ideias`, `2026-08-16#03`)
> já trazia a seção "onde dói". Vale observar no próximo `evolve` se guarda nascida de risco
> previsto dispara tanto quanto guarda nascida de erro real, ou se é otimismo que vira desuso.

> **Mentor24h** (2026-08-23) é o primeiro caso de **migração em vez de adoção**: o projeto tinha
> 453 arquivos, 12,6 MB e 87 commits, mas 73% do peso eram screenshots e 41 deles estavam
> commitados — adotar o harness no lugar não tiraria os 13,6 MB já cravados na história do git.
> Nasceu numa pasta nova, com git limpo, e a v3 ficou intacta como arquivo morto.
> Achado que vale para o `evolve`: a v3 tinha **cinco** sistemas paralelos de rastreio, e três se
> declaravam "a fonte única" no próprio cabeçalho. Eles colidiram de fato — "Etapa 28" era
> *Supabase (pendente)* num arquivo e *Organização Panes (concluída)* no outro. É a primeira
> evidência direta de que a proliferação de rastreio não é só inchaço: **produz informação
> contraditória que uma IA não tem como desempatar**. Virou a guarda `rastreio-so-em-planos`.
> Se um segundo projeto mostrar o mesmo, é convergência e cabe no `init` de todo mundo.

## Estados

- `ativo` — existe no disco e está em uso
- `arquivado` — sumiu do disco ou foi abandonado; o aprendizado dele continua contando
- `adotado` — já tinha estrutura própria; o harness foi acrescentado por cima
