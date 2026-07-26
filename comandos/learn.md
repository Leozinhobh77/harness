# `learn` — transformar um erro real em guarda permanente

> **O comando mais importante desta skill.** É o *ratchet*: toda falha vira catraca, e catraca
> não destrava. Um harness que não aprende com os próprios erros é só documentação bonita.

```
/harness learn "a IA marcou o plano como concluído sem rodar o teste"
```

## A pergunta que define tudo

Antes de escrever qualquer coisa, responda — **em voz alta, para o usuário**:

> ### "Dá para impedir isso mecanicamente?"

É a **Lei 2**. A resposta define o que você vai fazer, e a ordem de preferência é rígida:

| Nível | Solução | Exemplo |
|---|---|---|
| **1. Impossível de fazer errado** | mudar a estrutura | arquivo derivado em vez de escrito à mão |
| **2. Bloqueio na hora** | hook `PreToolUse` | impedir edição de arquivo de dado bruto |
| **3. Detecção na hora** | hook `PostToolUse` | rodar validação após cada Write e devolver o erro |
| **4. Detecção no fim** | hook `Stop` (exit 2) | recusar terminar o turno sem baixa no plano |
| **5. Pedido escrito** | linha no `AGENTS.md` | **último recurso** |

**Suba o máximo que conseguir nessa tabela.** Nível 5 é derrota aceita, não escolha.

## Fluxo

### 1. Entenda o erro de verdade
Não aceite a descrição de primeira. Pergunte o suficiente para saber:
- O que a IA fez exatamente?
- O que deveria ter feito?
- Já tinha alguma regra cobrindo isso? **(crítico — veja abaixo)**

### 2. ⚠️ Se já existia guarda e ela falhou

**Não empilhe outra.** Conserte a que existe.

Esse é o jeito nº 1 de um harness virar monstro: cada falha vira uma regra nova, e em 6 meses
existem quatro regras dizendo a mesma coisa de jeitos diferentes — e o modelo obedece pior, não
melhor, porque instrução redundante compete por atenção.

Se a guarda existia e não pegou, o problema é **ela**: estava no nível errado da tabela, tinha
escopo estreito demais, ou era texto quando devia ser hook.

### 3. Escolha o nível e implemente

Sempre com **procedência** anexada. Todo artefato gerado pelo `learn` carrega:

```
Procedência: <o erro concreto> · <data> · learn
```

Sem isso, o `doctor` vai marcar como candidata a abate depois — e vai estar certo.

### 4. Registre em três lugares

| Onde | O quê |
|---|---|
| a guarda/regra em si | com a procedência embutida |
| `docs/DECISOES.md` do projeto | entrada datada: erro, solução, nível escolhido |
| `memoria/PADROES.md` da skill | ⭐ **é isso que faz a skill aprender entre projetos** |

O terceiro é o que transforma um conserto local em conhecimento global. Não pule.

### 5. Prove que funciona

Guarda que você não testou não é guarda, é esperança. Reproduza a situação e confirme que ela
dispara. Se não der para reproduzir, **diga isso** ao usuário em vez de fingir.

## O formato em `memoria/PADROES.md`

```markdown
### P0NN — <o erro, em uma linha>
- **Visto em:** projeto-a (2026-07-26), projeto-b (2026-06-14)   ← 2 projetos!
- **Nível da solução:** 4 (Stop hook)
- **Solução:** porta-saida.ps1 recusa fechar com plano sem baixa
- **Promovido ao template:** não   ← vira "sim" quando o evolve promover
```

Quando o mesmo padrão aparece em **≥2 projetos independentes**, ele fica elegível para
promoção ao template pelo `evolve` — e todo projeto futuro nasce imune. Um caso é acaso;
dois é padrão.

## O que o `learn` NUNCA faz

- ❌ Escrever regra genérica ("seja mais cuidadoso", "preste atenção") — não é guarda, é desabafo
- ❌ Empilhar regra sobre guarda existente que falhou
- ❌ Criar guarda sem procedência
- ❌ Promover ao template sozinho — isso é trabalho do `evolve`, com ≥2 projetos e seu OK
