# SPEC — especificação técnica (o como)

> Mapa técnico de alto nível. Convenções de engenharia que o `PRD.md` não cobre.
> ⚠️ **Este documento apodrece se ninguém o verificar.** Regra de negócio que, se quebrar, causa
> prejuízo **não pode morar só aqui em prosa — tem que virar teste** (ver seção Verificação).

## Stack e restrições não negociáveis

{{STACK}}

## Arquitetura

{{ARQUITETURA}}

## Convenções de engenharia

{{CONVENCOES}}

- **Comentários no código:** só quando o "porquê" não é óbvio. Não documentar o óbvio.
- **Sem comentário motivado por tarefa** ("adicionado para o pedido do fulano") — isso vai no
  commit ou no plano, não no código.

## Verificação (como testar)

{{VERIFICACAO}}

> **Prosa apodrece; teste não.** Um parágrafo descrevendo uma regra nunca avisa quando é
> violado. Um teste vermelho avisa em segundos. Toda regra que o usuário só descobriria quebrada
> tarde demais **precisa** de um teste.

## Decisões técnicas relevantes

Ver `DECISOES.md` para o histórico completo (com data e motivo) das escolhas de arquitetura.
