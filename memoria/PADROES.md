# PADRÕES — o que a skill aprendeu entre projetos

> ⭐ **É este arquivo que faz a skill ficar mais inteligente a cada projeto.**
>
> Todo `/harness learn` grava aqui. O `/harness evolve` lê, procura o mesmo padrão em projetos
> **diferentes**, e promove ao template quando aparece em **≥2 projetos independentes**.
>
> **Um caso é acaso. Dois é padrão.** É essa regra que impede um projeto barulhento de
> redesenhar a skill inteira.

## Formato

```markdown
### P0NN — <o erro, em uma linha>
- **Visto em:** <projeto> (AAAA-MM-DD), <projeto> (AAAA-MM-DD)
- **Nível da solução:** 1–5 (ver tabela em comandos/learn.md)
- **Solução:** <o que resolveu>
- **Promovido ao template:** não | sim (vX.Y.Z, tier T?)
```

---

### P001 — Script `.ps1` com acento/emoji quebra no console do Windows
- **Visto em:** skill /harness (2026-07-26)
- **Nível da solução:** 3 (PostToolUse — hook valida após cada escrita)
- **Solução:** `.ps1` fica **ASCII puro**; todo texto acentuado mora em template `.md` UTF-8 que
  o script lê e preenche. O hook `pos-edicao.ps1` checa parser + bytes não-ASCII a cada escrita.
- **Detalhe:** o console do Windows usa cp1252; acento em `.ps1` vira lixo ou erro de parser.
  Pego ao vivo pela armadura `ps1-check` da Forge do usuário durante a construção desta skill —
  14 erros de parser e 60 bytes não-ASCII num único arquivo.
- **Promovido ao template:** sim (v1.0.0, T2 — `pos-edicao.ps1`)

### P002 — `$var:` em string PowerShell é lido como variável com escopo
- **Visto em:** skill /harness (2026-07-26)
- **Nível da solução:** 3 (PostToolUse — o parser pega)
- **Solução:** usar `${var}` sempre que um `:` vier logo depois do nome. O check de parser em
  `pos-edicao.ps1` já cobre — não precisa de regra escrita.
- **Detalhe:** `"alerta $tier: $(...)"` não é erro de digitação; o PowerShell interpreta `$tier:`
  como qualificador de escopo e falha no parse. Erro silencioso até rodar.
- **Promovido ao template:** sim (v1.0.0 — coberto pelo check de parser, sem regra escrita)

---

### P007 — Arquivo derivado não se confere por relógio, e nem todo conteúdo dele é conferível
- **Visto em:** skill /harness, projeto Finanças (2026-07-27) — três tentativas de acertar
- **Nível da solução:** 2 (o próprio doctor acusou, ao vivo, logo depois de commitar)
- **Solução:** para saber se um arquivo derivado está em dia, **não compare timestamps** —
  regenere numa prévia que não escreve e compare o conteúdo. O gerador é a definição de "em
  dia"; qualquer heurística de tempo é aproximação.
- **A segunda metade, que é a menos óbvia:** compare só a parte **estável** do derivado. Se ele
  embute algo que muda por tê-lo gerado (lista de commits que passa a incluir o commit dele
  mesmo, status de working tree), essa parte é **insatisfazível por construção** e cobrá-la
  produz alarme permanente. Alarme que nunca apaga é pior que alarme nenhum: ensina a ignorar.
- **Como reconhecer em outro lugar:** todo check de "X está atualizado?" onde o ato de atualizar
  X muda a coisa contra a qual X é comparado. Se existe essa circularidade, o check precisa
  excluir explicitamente a parte circular.
- **Promovido ao template:** não — é conhecimento do `doctor` da própria skill. Vale como regra
  de projeto se algum dia um harness gerar outro arquivo derivado.

### P011 — Guarda que bloqueia a CLASSE inteira é abatida; sobrevive a que bloqueia só o destrutivo
- **Visto em:** Zenith Invest (2026-07-30), Central de Projetos (2026-08-11) — ⭐ **2 projetos
  independentes, datas e motivos diferentes, mesma conclusão**
- **Nível da solução:** 2 (a guarda continua sendo hook — mudou o escopo, não o nível)
- **O padrão:** o template T2 nascia com `sem-push`, que bloqueia **todo** `git push`. Nos dois
  projetos em que o push virou fluxo normal, o usuário **não refinou a guarda — ele a removeu**:
  Zenith abateu depois de autorizar publicação; Central omitiu no `init`. Nos dois casos, criou
  em seguida uma guarda nova cobrindo **só `--force`**.
- **A lição generalizável:** guarda larga demais não é "conservadora", é **frágil** — ela não
  vira mais estreita com o uso, ela vira **desligada**. E guarda desligada protege zero. Ao
  desenhar uma guarda, a pergunta não é *"o que pode dar errado nesta família de comandos?"* e
  sim *"qual variante específica não tem desfazer?"*. `git push` republica; `git push --force`
  apaga o que já estava publicado. Só a segunda merece hook.
- **Como reconhecer em outro lugar:** toda guarda cujo padrão casa um comando inteiro sem
  qualificador (`git push`, `rm`, `npm install`). Se o comando base é parte do trabalho normal
  de algum projeto plausível, a guarda vai ser abatida lá — e o abate leva junto a proteção
  contra a variante destrutiva.
- **Promovido ao template:** **sim** (v1.7.0) — `sem-push` sai, `sem-push-force` entra em
  `templates/T2-padrao/.harness/guardas.json`. Projetos existentes não mudam sozinhos; o
  Finanças fica com a guarda velha até o usuário decidir.

### P010 — O CSS do projeto derrota o `hidden` do HTML, e o conserto do JS vira enfeite
- **Visto em:** skill /harness, página do manual (2026-08-12) — **é o P003 uma camada acima**
- **Nível da solução:** 3 (teste Playwright pegou; a olho nu passou meses despercebido)
- **Solução:** `.icon-btn svg[hidden] { display: none; }` — uma regra explícita que devolve o
  poder ao atributo.
- **Detalhe:** o P003 já tinha ensinado a usar `setAttribute('hidden','')` em vez de
  `.hidden = true` (que é no-op em SVG). O JS estava **correto**. Só que o CSS da página tinha
  `.icon-btn svg { display: block; }` — especificidade `(0,1,1)`, que **vence** a regra
  `[hidden] { display: none }` da folha de estilo do navegador, que é `(0,1,0)`. Resultado: o
  atributo era escrito e removido certinho, e **nunca surtia efeito**. Sol e lua ficavam
  sobrepostos num botão de 38px, no ar, desde a v1.1.1.
- **Por que escapou:** o teste anterior (P003) verificava se o **atributo** mudava — e mudava. A
  pergunta certa é sobre o **estilo computado**, não sobre o atributo: `getComputedStyle(el).display`.
- **Como reconhecer em outro lugar:** qualquer lugar onde se controla visibilidade por `hidden`
  e o CSS declara `display` no mesmo elemento por classe. **Toda vez que você declara `display`
  numa regra de classe, você desarmou o `hidden` daquele elemento** — e o desarme é silencioso.
- **Promovido ao template:** não é template de projeto — é conhecimento de front-end da própria
  skill, como P003/P004/P005.

### P009 — `.Count` num `PSCustomObject` devolve `$null`, não `1` — e o teste com muitos itens esconde
- **Visto em:** skill /harness (2026-08-12, construção da sombra)
- **Nível da solução:** 3 (o parser não pega; só rodar no caso de 1 item pega)
- **Solução:** **toda** chamada de função que devolve lista vai dentro de `@()`. Sempre, mesmo
  quando "obviamente" vem mais de um.
- **Detalhe:** o PowerShell desenrola array de 1 item para escalar. A extensão `.Count` do PSv3
  cobre escalares comuns, mas num `PSCustomObject` o acesso vira busca de propriedade
  inexistente e devolve `$null`. As duas comparações seguintes ficam **silenciosamente
  invertidas**: `$null -eq 0` é falso (parece ter itens) e `1 -gt $null` é verdadeiro (parece
  fora do intervalo). Resultado: `-Restaurar 1` respondia *"não existe foto numero 1"* em
  projeto com **exatamente uma foto** — ou seja, quebrava justamente na primeira vez que alguém
  precisasse dele.
- **⭐ A lição que vale mais que o bug:** o teste de aceitação passou com 3 fotos e **mascarou o
  defeito**. Ele só apareceu ao rodar em projeto real recém-instalado. Todo caminho que lida com
  coleção precisa de um teste com **exatamente um** elemento — é o caso de borda mais comum e o
  menos testado, porque o cenário de demonstração naturalmente tem vários.
- **Promovido ao template:** não é template de projeto — é conhecimento de PowerShell da própria
  skill, como P001 e P002. O check de parser não pega isto: é erro de tipo em tempo de execução.

### P008 — Guarda de comando casa o TEXTO INTEIRO, e pega quem só *fala* do comando
- **Visto em:** skill /harness (2026-07-26, como P006), **armadura C0 da Forge** (2026-08-12) —
  ⭐ dois sistemas independentes, o mesmo desenho, o mesmo defeito
- **Nível da solução:** 2 (o hook já era nível 2 — o defeito é o casamento, não o nível)
- **O padrão:** uma guarda que aplica regex sobre o comando inteiro bloqueia qualquer comando
  que **mencione** o texto proibido, mesmo quando o trecho destrutivo mira outro lugar — ou
  quando não existe trecho destrutivo nenhum, só a string dentro de um payload.
- **Detalhe:** construindo a sombra, dois comandos legítimos foram bloqueados pela armadura da
  Forge: (1) um `Remove-Item -Recurse` numa pasta de teste em `Temp\`, porque a *outra linha* do
  mesmo comando citava o caminho `.claude\skills\harness\scripts\sombra.ps1`; (2) um JSON de
  teste contendo `"command":"rm -rf imagens/"` — o comando não apagava nada, só passava a string
  para o hook por stdin. O escopo da armadura é `.claude`/`Forge`, e ela concluiu "in-scope"
  pela menção, não pelo alvo.
- **A solução, nas duas vezes, é a mesma:** resolver o **alvo efetivo** da parte destrutiva antes
  de decidir. O `guarda.ps1` já faz isso para `cd ... && ...` (P006); a armadura da Forge ainda
  não.
- **Como reconhecer em outro lugar:** toda guarda que decide escopo por `$comando -match
  '<caminho>'`. Se a mesma string pode aparecer como *argumento de outra coisa*, o falso positivo
  é questão de tempo — e falso positivo em guarda ensina a contornar guarda.
- **Terceira ocorrência (2026-08-12, evolve v1.7.0):** agora foi a guarda `sem-push-force` do
  **próprio projeto Central** — bloqueou um comando que só **escrevia um arquivo de casos de
  teste** contendo a string `git push --force` dentro de um heredoc. Nenhum push ia acontecer.
  **Três sistemas diferentes, o mesmo defeito, no mesmo dia.**
- **O limite honesto:** este terceiro caso **não tem conserto por regex**. Distinguir "vai
  executar um push --force" de "a string aparece como dado" exige interpretar o shell, e o hook
  só recebe texto. O P006 resolveu o caso do `cd` porque ali havia sinal estrutural; aqui não há.
  **A mitigação é o contorno normal**, não um regex melhor: passar dado por arquivo (ferramenta
  de escrita) em vez de pela linha de comando.
- **Quarta ocorrência (2026-08-13, evolve v1.8.0):** a armadura da Forge de novo, duas vezes
  seguidas, bloqueando comandos que **testavam a própria guarda** — os casos de teste continham
  a string proibida como dado. A segunda tentativa montava a string em pedaços
  (`'git push ' + '--f' + 'orce'`) e **foi bloqueada mesmo assim**: a armadura remonta a
  concatenação antes de casar. Confirma o limite abaixo — não é falta de regex melhor.
- **Quinta ocorrência (2026-08-13), e é a melhor ilustração que o padrão já teve:** a armadura
  bloqueou o **commit que documentava a correção da guarda**, porque a mensagem do commit
  explicava que `git reset --hard` deixara de passar batido. Nenhum reset ia acontecer — o texto
  era a documentação do conserto. **Uma guarda impedindo o registro do próprio aprendizado.**
- **O limite honesto:** este caso **não tem conserto por regex**. Distinguir "vai executar um
  push --force" de "a string aparece como dado" exige interpretar o shell, e o hook só recebe
  texto. O P006 resolveu o caso do `cd` porque ali havia sinal estrutural; aqui não há.
  **A mitigação é o contorno normal**, não um regex melhor: passar dado por arquivo (ferramenta
  de escrita) em vez de pela linha de comando.
- **Promovido ao template:** não — o `guarda.ps1` do T2 já está correto desde o P006. Registrado
  porque as ocorrências seguintes **confirmam o padrão** (regra dos 2 casos, aqui com 4) e porque
  a armadura da Forge é do usuário: vale a correção lá, quando ele quiser.

### P012 — Guarda que só cobre UMA ferramenta não guarda nada, e ninguém percebe
- **Visto em:** template T2 da skill /harness (2026-08-13) — **os 4 projetos ao mesmo tempo**
- **Nível da solução:** 2 (hook que bloqueia)
- **O padrão:** o `guarda.ps1` verificava `$ferramenta -eq 'Bash'` antes de aplicar os
  `comandos_proibidos`. No Windows, **a maioria dos comandos passa pela ferramenta PowerShell** —
  então `git reset --hard` por lá **nunca foi bloqueado**, em nenhum dos quatro projetos, desde
  que a guarda existe.
- **Por que passou tanto tempo despercebido:** a guarda *existia*, *aparecia* no `guardas.json`,
  *aparecia* na tabela 🔴 do `AGENTS.md` e **disparava de vez em quando** — pelo caminho do Bash.
  Um mecanismo meio ligado é mais perigoso que um desligado: ele produz a sensação de proteção
  e o log até mostra disparos, o que confirma a sensação.
- **Como reconhecer em outro lugar:** toda condição que filtra por **nome de ferramenta, canal
  ou ambiente** antes de aplicar uma regra de segurança. Pergunte: *por quantos caminhos
  diferentes essa ação pode chegar aqui?* Se a resposta for mais de um, o filtro está errado
  por construção.
- **Corrigido na v1.8.0:** `$ferramenta -match '^(Bash|PowerShell)$'`, com 9 casos de teste.
- **Promovido ao template:** sim.

### P013 — Pedido escrito ao agente não é mecanismo: vira dado falso com cara de verdade
- **Visto em:** skill /harness — `uso.json` (2026-08-12 e 2026-08-13, dois ciclos de evolve)
- **Nível da solução:** abate (era nível 4, o pior)
- **O padrão:** o `SKILL.md` pedia, por escrito, que o agente registrasse cada execução de
  comando num `uso.json`. O `/menu-harness` lia esse arquivo e mostrava "último uso".
  **O registro não acontecia.** Em 13/08 o `criticar` rodou **duas vezes** e continuou marcado
  como "nunca usado"; o `learn` idem, por dois ciclos seguidos.
- **O que torna isto pior que não ter o recurso:** o menu não dizia "não sei" — dizia
  **"nunca usado"**, com confiança, sobre um comando usado horas antes. **Dado errado é pior
  que dado nenhum**, porque dado nenhum ninguém usa para decidir e dado errado sim. Foi
  inclusive por confiar nesse número que o evolve anterior abriu uma investigação sobre o
  `learn` "nunca usado" — investigando o instrumento, não o mundo.
- **A raiz é a Lei 2:** era um pedido educado ocupando o lugar de um mecanismo. E a Lei 2 já
  avisa que isso é o anti-padrão nº 1. A skill violou a própria lei, por escrito, no próprio
  roteador.
- **Como reconhecer em outro lugar:** toda instrução da forma *"depois de X, lembre-se de
  atualizar Y"* onde Y é lido por outra coisa como se fosse verdade. Ou vira mecânico, ou o
  consumidor de Y precisa admitir que o dado é aproximado.
- **Abatido na v1.8.0:** `uso.json` apagado, o passo saiu do `SKILL.md`, a coluna saiu do menu.
- **Promovido ao template:** não se aplica — é lição sobre a própria skill.

### P003 — `.hidden` não existe em SVGElement, só em HTMLElement
- **Visto em:** skill /harness (2026-07-26)
- **Nível da solução:** 3 (teste Playwright pegou antes de publicar)
- **Solução:** trocar `svg.hidden = bool` por `svg.setAttribute('hidden','')` /
  `svg.removeAttribute('hidden')`. A propriedade IDL `hidden` é definida só na interface
  `HTMLElement`; em `<svg>` inline (SVGElement) o assign vira um expando silencioso — não
  lança erro, não reflete no atributo, e o elemento continua escondido/visível do jeito errado.
- **Detalhe:** achado testando o botão de tema (ícone sol/lua) do manual — o clique mudava
  `data-theme` corretamente mas o ícone não trocava. Sem teste automatizado, passaria batido
  (visualmente sutil, fácil de não notar num clique rápido).
- **Promovido ao template:** não é template de projeto — é conhecimento de front-end da própria
  skill (páginas que ela gera). Registrado aqui para a próxima página HTML nascer sem o bug.

### P006 — Guarda de comando bloqueia por TEXTO, sem saber se o `cd` leva pra fora do projeto
- **Visto em:** skill /harness, projeto Financas (2026-07-26)
- **Nível da solução:** 2 (o hook já era nível 2 — o bug era o escopo, não o nível)
- **Solução:** `guarda.ps1` agora resolve o diretório efetivo do comando (detecta um `cd <caminho>
  && ...`/`; ...` no início do texto) antes de aplicar `comandos_proibidos`. Se o `cd` aponta pra
  fora da raiz do projeto (`$env:CLAUDE_PROJECT_DIR`), a checagem de comando proibido é pulada —
  o comando não mexe neste projeto, não é trabalho desta guarda impedir.
- **Detalhe:** achado ao vivo — a guarda `sem-push` de Financas bloqueou
  `cd ...\harness && git push`, um push **legítimo e já autorizado** num repositório sem
  nenhuma relação com Financas, só porque o texto continha "git push". A guarda funcionava
  perfeitamente bem *dentro* do próprio projeto (continua bloqueando `git push`/`reset --hard`
  ali) — o problema era só a ausência de consciência de diretório.
- **Promovido ao template:** sim, direto — corrigido em
  `templates/T2-padrao/.claude/hooks/guarda.ps1` (T2+ herda). Propagado manualmente pra
  Financas (projeto já existente, fora do fluxo automático de `/harness upgrade`).
- **Segunda camada do mesmo bug, achada minutos depois:** o primeiro fix resolvia caminho
  estilo Windows (`C:\Users\...`) mas o `Bash` deste ambiente é Git Bash — o `cd` real vem
  como `/c/Users/...`. `Resolve-Path` do PowerShell não entende esse formato, falha em
  silêncio, e a guarda voltava a tratar tudo como "dentro do projeto". Só apareceu porque a
  própria mensagem de commit descrevendo o bug continha o texto "git push" — a guarda pegou a
  si mesma. Corrigido convertendo `/<letra>/...` para `<LETRA>:\...` antes de resolver.
  **Moral:** testar só com o formato de caminho que eu digitei à mão não basta — tinha que
  testar com o formato que a ferramenta real produz.

### P005 — Página sem `<meta viewport>` renderiza a ~980px no celular: TODO o CSS mobile morre
- **Visto em:** skill /harness (2026-07-26)
- **Nível da solução:** 5 → devia ter sido 3 (o usuário pegou, não um teste)
- **Solução:** toda página destinada ao GitHub Pages (ou qualquer servidor que sirva o arquivo
  cru) tem que ser um **documento HTML completo**: `<!doctype html>`, `<html lang>`, `<head>`
  com `<meta charset>` e `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- **Detalhe:** a página nasceu como *fragmento* (o publicador de Artifacts embrulha em
  doctype/head/viewport na hora de servir). Ao mover o mesmo arquivo para o GitHub Pages, ele
  foi servido cru: sem viewport, o navegador do celular renderiza a ~980px e encolhe tudo —
  letra minúscula, zoom manual, e **nenhuma media query de mobile dispara**. O usuário viu o
  site desktop espremido. Os testes Playwright não pegaram porque emulam o viewport
  diretamente (`viewport={...}`), pulando exatamente o mecanismo que estava quebrado.
- **Moral dupla:** (1) fragmento e documento são artefatos diferentes — mudar o canal de
  publicação exige reconferir o invólucro; (2) teste que emula o ambiente não cobre o que o
  ambiente real infere sozinho.
- **Promovido ao template:** conhecimento da própria skill (páginas que ela publica), como P003/P004.

### P004 — Scroll-spy por "primeira seção interceptando" escolhe a seção errada
- **Visto em:** skill /harness (2026-07-26)
- **Nível da solução:** 3 (teste Playwright pegou antes de publicar)
- **Solução:** trocar `IntersectionObserver` + "primeira em ordem de documento que está
  intersectando" por uma varredura em `scroll`+`requestAnimationFrame` que caminha as seções em
  ordem e marca ativa a **última** cujo topo já cruzou a linha de leitura (topo da tela + um
  offset). Sections são sequenciais, então o loop pode parar no primeiro que ainda não chegou.
- **Detalhe:** em página longa, ao pular direto para uma seção (clique de link, não scroll
  incremental), a seção anterior pode sobrar com poucos pixels ainda visíveis no topo da tela —
  e como ela aparece primeiro no array (ordem do documento), o algoritmo antigo a escolhia em
  vez da seção que realmente ocupa a tela. Confirmado com debug script: navegação para "§7.1 O
  flywheel" marcava "§6 Os arquivos" como ativa.
- **Promovido ao template:** não é template de projeto — mesmo motivo do P003.
