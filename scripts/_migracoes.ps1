<#
  MIGRACOES PENDENTES - a peca do modelo PULL, compartilhada.

  Responde UMA pergunta: "o que este projeto ainda precisa aplicar?"

  POR QUE ESTE ARQUIVO EXISTE: dois consumidores fazem a mesma pergunta em
  momentos diferentes - o estado.ps1 no inicio da sessao (aviso passivo) e o
  doctor.ps1 quando o usuario audita (resposta ativa). Duas copias da mesma
  logica seria a duplicata que esta skill inteira existe para evitar, e a que
  ela ja levou tres vezes (P015, P017). Uma fonte, dois leitores.

  ASCII puro (armadura ps1-check). Todo texto acentuado vive no
  memoria/MIGRACOES.json e no templates/comum/ESTADO-pendencias.tpl.md.
#>

function Get-MigracoesPendentes {
    <#
      Devolve as migracoes que este projeto ainda NAO aplicou.
      Array vazio = nada pendente. Nunca lanca: sem skill, sem arquivo ou com
      JSON quebrado, devolve vazio - o silencio e o padrao.
    #>
    param(
        [string]$Projeto,
        [string]$RaizSkill,
        [string]$VersaoProjeto,
        [string]$Tier
    )

    $vazio = @()
    try {
        $arq = Join-Path $RaizSkill 'memoria\MIGRACOES.json'
        if (-not (Test-Path -LiteralPath $arq)) { return $vazio }
        $todas = @((Get-Content -LiteralPath $arq -Raw -Encoding UTF8 | ConvertFrom-Json).migracoes)
        if ($todas.Count -eq 0) { return $vazio }

        $vProj = $null
        try { $vProj = [version]$VersaoProjeto } catch { }

        $pend = New-Object System.Collections.Generic.List[object]
        foreach ($mg in $todas) {
            $vMig = $null
            try { $vMig = [version]([string]$mg.versao) } catch { continue }

            # Ja veio de fabrica nesta versao do projeto.
            if ($vProj -and $vMig -le $vProj) { continue }

            # Migracao de tier que este projeto nao tem.
            if (([string]$mg.tiers) -eq 'T2+' -and $Tier -eq 'T1') { continue }

            # CONFERE NO DISCO. O numero de versao no manifesto e indicio, nao
            # prova: o usuario pode ter aplicado a correcao a mao, e acusar
            # pendencia que nao existe e o mesmo erro do P013 - dado errado e
            # pior que dado nenhum, e alarme falso vira alarme desligado (P011).
            # Formato do campo: "arquivo:<caminho relativo>:contem:<texto>"
            $jaAplicada = $false
            $partes = ([string]$mg.verificar) -split ':', 4
            if ($partes.Count -eq 4 -and $partes[0] -eq 'arquivo' -and $partes[2] -eq 'contem') {
                $alvo = Join-Path $Projeto ($partes[1].Replace('/', '\'))
                if (Test-Path -LiteralPath $alvo) {
                    $txt = Get-Content -LiteralPath $alvo -Raw -Encoding UTF8
                    if ($txt -and $txt.Contains($partes[3])) { $jaAplicada = $true }
                }
            }
            if (-not $jaAplicada) { $pend.Add($mg) }
        }
        return $pend.ToArray()
    } catch {
        return $vazio
    }
}
