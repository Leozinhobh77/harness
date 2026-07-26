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
