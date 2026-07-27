<#
.SYNOPSIS
  Checks mecanicos do harness de um projeto (familias 1, 2, 3, 5 de CHECKS.md).
.DESCRIPTION
  So faz o que da para verificar sem julgamento. Os checks de julgamento
  (familias 2-parcial, 4 procedencia e 6 escada) sao feitos pelo modelo.

  NUNCA escreve nada. Somente leitura, sempre.
  ASCII puro de proposito (armadura ps1-check). Ver PADROES.md P001.
.EXAMPLE
  powershell -File doctor.ps1 -Projeto "C:\Users\...\Financas"
  powershell -File doctor.ps1 -Projeto "..." -Json
#>
param(
    [Parameter(Mandatory=$true)][string]$Projeto,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$achados = New-Object System.Collections.Generic.List[object]
function Add-Achado {
    param([string]$Sev, [string]$Familia, [string]$Msg, [string]$Fix = '')
    $achados.Add([pscustomobject]@{ severidade=$Sev; familia=$Familia; mensagem=$Msg; correcao=$Fix })
}

# Normaliza um ESTADO.md para comparacao de CONTEUDO (ver F2).
#
# Fica so a parte ESTAVEL: titulo, planos ativos e quantidade de concluidos.
# O que sai, e por que:
#   - a linha "> Gerado em ...": traz a data, muda todo dia sem nada de
#     substancia mudar;
#   - a secao de commits e o status do git ate o fim do arquivo: sao
#     INSATISFAZIVEIS por construcao. O ESTADO.md lista os ultimos commits,
#     entao no instante em que ele e commitado ja falta um - o proprio. E o
#     status "working tree limpo" fica falso assim que se edita qualquer coisa.
#     Conferir isso e cobrar do arquivo uma exatidao que ele nao pode ter.
#
# O que sobra e exatamente a deriva que importa: plano que mudou de status ou
# foi arquivado sem o ESTADO.md ser regenerado.
function Get-EstadoComparavel {
    param([string]$Texto)
    if (-not $Texto) { return '' }
    $t = ($Texto -replace "`r`n", "`n").TrimStart([char]0xFEFF)

    $saida = New-Object System.Collections.Generic.List[string]
    foreach ($l in ($t -split "`n")) {
        # corta fora da secao de commits em diante (o cabecalho tem "commits")
        if ($l -match '^##\s.*commits') { break }
        if ($l -match '^\s*>\s*Gerado em') { continue }
        $saida.Add($l.TrimEnd())
    }
    return (($saida -join "`n").Trim())
}

if (-not (Test-Path $Projeto)) { Write-Output "ERRO: projeto nao encontrado -> $Projeto"; exit 1 }

$nome      = Split-Path $Projeto -Leaf
$dirPlanos = Join-Path $Projeto 'Planos'
$dirHarn   = Join-Path $Projeto '.harness'

# ============ manifesto ============
$tier = 'T?'
$versaoSkill = '?'
$declarados = @()
$manifesto = Join-Path $dirHarn 'manifesto.json'
if (-not (Test-Path $manifesto)) {
    Write-Output "SEM_HARNESS: $Projeto nao tem .harness/manifesto.json"
    exit 2
}
try {
    $m = Get-Content $manifesto -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($m.tier)         { $tier        = [string]$m.tier }
    if ($m.versao_skill) { $versaoSkill = [string]$m.versao_skill }
    if ($m.arquivos)     { $declarados  = @($m.arquivos) }
} catch {
    Add-Achado 'VERMELHO' 'Integridade' 'manifesto.json invalido (JSON quebrado)' '/harness fix'
}

# ============ F1 Integridade ============
foreach ($rel in $declarados) {
    if (-not (Test-Path (Join-Path $Projeto $rel))) {
        Add-Achado 'VERMELHO' 'Integridade' "Arquivo declarado no manifesto nao existe: $rel" '/harness fix'
    }
}

$docs = @(Get-ChildItem $Projeto -Filter '*.md' -File -Recurse -ErrorAction SilentlyContinue |
          Where-Object { $_.FullName -notmatch '\\(\.git|node_modules|\.harness)\\' })

# links markdown relativos quebrados
foreach ($d in $docs) {
    $txt = Get-Content $d.FullName -Raw -Encoding UTF8
    $mm = [regex]::Matches($txt, '\[[^\]]*\]\(([^)#:]+\.md)[^)]*\)')
    foreach ($x in $mm) {
        $alvo = $x.Groups[1].Value.Trim()
        if ($alvo -match '^(https?|mailto)') { continue }
        $abs = Join-Path $d.DirectoryName $alvo
        if (-not (Test-Path $abs)) {
            $relDoc = $d.FullName.Substring($Projeto.Length).TrimStart('\')
            Add-Achado 'VERMELHO' 'Integridade' "Link quebrado em ${relDoc}: $alvo" '/harness fix'
        }
    }
}

# settings.json valido + hooks existem
$settings = Join-Path $Projeto '.claude\settings.json'
if (Test-Path $settings) {
    try {
        $bruto = Get-Content $settings -Raw -Encoding UTF8
        $null = $bruto | ConvertFrom-Json
        foreach ($h in [regex]::Matches($bruto, '\.claude[\\/]hooks[\\/]([A-Za-z0-9_\-]+\.ps1)')) {
            $hp = Join-Path $Projeto (".claude\hooks\" + $h.Groups[1].Value)
            if (-not (Test-Path $hp)) {
                Add-Achado 'VERMELHO' 'Mecanica' "Hook citado no settings.json nao existe: $($h.Groups[1].Value)" '/harness fix'
            }
        }
    } catch {
        Add-Achado 'VERMELHO' 'Integridade' '.claude/settings.json nao e JSON valido' '/harness fix'
    }
} elseif ($tier -ne 'T1') {
    Add-Achado 'AMARELO' 'Mecanica' 'Projeto T2+ sem .claude/settings.json (nenhuma guarda mecanica ativa)' '/harness upgrade'
}

# ============ F1/F2 Planos ============
$idsVistos = @{}
$planosAtivos = @()
if (Test-Path $dirPlanos) {
    $dirConcl = (Get-ChildItem $dirPlanos -Directory -Filter 'Conclu*' -ErrorAction SilentlyContinue | Select-Object -First 1)
    $planosAtivos = @(Get-ChildItem $dirPlanos -Filter '*.md' -File | Where-Object { $_.Name -match '^\d{4}-' })
    $todos = @($planosAtivos)
    if ($dirConcl) { $todos += @(Get-ChildItem $dirConcl.FullName -Filter '*.md' -File | Where-Object { $_.Name -match '^\d{4}-' }) }

    foreach ($p in $todos) {
        $id = $p.Name.Substring(0,4)
        if ($idsVistos.ContainsKey($id)) {
            Add-Achado 'VERMELHO' 'Integridade' "Numero de plano duplicado: $id" 'renumerar manualmente'
        } else { $idsVistos[$id] = $p.Name }
    }

    foreach ($p in $planosAtivos) {
        $txt = Get-Content $p.FullName -Raw -Encoding UTF8
        $status = ''
        if ($txt -match '(?m)^status:\s*(.+)$') { $status = ($Matches[1] -split '#')[0].Trim() }
        $idade = [int]((Get-Date) - $p.LastWriteTime).TotalDays

        if ($status -match 'Conclu|Cancel') {
            Add-Achado 'AMARELO' 'Deriva' "Plano $($p.Name) esta '$status' mas segue fora de Concluidos/" '/harness fix'
        }
        if ($status -match 'andamento' -and $idade -gt 30) {
            Add-Achado 'AMARELO' 'Deriva' "Plano $($p.Name) em andamento sem alteracao ha $idade dias" 'retomar ou pausar'
        }
    }

    # indice x disco
    $indice = Join-Path $dirPlanos 'INDICE.md'
    if (Test-Path $indice) {
        $itxt = Get-Content $indice -Raw -Encoding UTF8
        foreach ($p in $planosAtivos) {
            $id = $p.Name.Substring(0,4)
            if ($itxt -notmatch [regex]::Escape($id)) {
                Add-Achado 'AMARELO' 'Deriva' "Plano $id existe em Planos/ mas nao esta no INDICE.md" '/harness fix'
            }
        }
    } elseif ($tier -ne 'T1') {
        Add-Achado 'AMARELO' 'Integridade' 'Planos/INDICE.md nao existe' '/harness fix'
    }
}

# ============ F2 ESTADO derivado ============
$estado = Join-Path $Projeto 'ESTADO.md'
if (Test-Path $estado) {
    # RELOGIO nao serve para esta pergunta, e duas tentativas ja falharam:
    #   v1.2.x  comparava com o ultimo commit - mas o commit que CARREGA o
    #           ESTADO.md e sempre alguns segundos mais novo que o arquivo.
    #   v1.3.0  passou a excluir ':(exclude)ESTADO.md' - so que isso exclui o
    #           CAMINHO, nao o COMMIT. Commitar o ESTADO.md junto com qualquer
    #           outro arquivo (o caso normal) devolvia o mesmo commit, e o check
    #           voltava a ser impossivel de satisfazer.
    # A pergunta certa nao tem relogio nenhum: regenerar hoje daria um arquivo
    # diferente do que esta no disco? -Preview devolve o conteudo sem escrever,
    # entao o doctor continua so lendo (regra 1 da skill).
    $gerador = Join-Path $PSScriptRoot 'estado.ps1'
    if (Test-Path $gerador) {
        try {
            $previa = (& $gerador -Projeto $Projeto -Preview) -join "`n"
            # se o gerador falhou, ele devolve uma mensagem de erro - nao acuse por isso
            if ($previa -match '(?m)^\s*#\s*ESTADO') {
                $atual = Get-Content $estado -Raw -ErrorAction Stop
                if ((Get-EstadoComparavel $atual) -ne (Get-EstadoComparavel $previa)) {
                    Add-Achado 'AMARELO' 'Deriva' 'ESTADO.md nao bate com o que seria gerado agora' '/harness fix'
                }
            }
        } catch { }
    }
}

# ============ F3 Inchaco ============
# Tetos de criterios/ORCAMENTOS.md. Manter os dois em sincronia:
# documento com teto la e sem linha aqui nunca e conferido por ninguem.
$orcamentos = @{
    'AGENTS.md'                    = 120
    'CLAUDE.md'                    = 40
    'ESTADO.md'                    = 40
    'docs\GOVERNANCA.md'           = 140
    'docs\PRD.md'                  = 100
    'docs\SPEC.md'                 = 150
    'docs\REGRAS-DE-NEGOCIO.md'    = 250
    'Planos\MANUAL.md'             = 140
}

# Custo de sessao != soma dos orcamentos. So estes carregam em TODA sessao;
# o resto e leitura sob demanda e nao cobra pedagio por sessao.
$sempreCarregados = @('AGENTS.md', 'CLAUDE.md', 'ESTADO.md')

$totalLinhas = 0
foreach ($k in $orcamentos.Keys) {
    $fp = Join-Path $Projeto $k
    if (Test-Path $fp) {
        $n = @(Get-Content $fp -Encoding UTF8).Count
        if ($sempreCarregados -contains $k) { $totalLinhas += $n }
        if ($n -gt $orcamentos[$k]) {
            Add-Achado 'AMARELO' 'Inchaco' "$k tem $n linhas (teto $($orcamentos[$k]))" '/harness fix'
        }
    }
}

$decisoes = Join-Path $Projeto 'docs\DECISOES.md'
if (Test-Path $decisoes) {
    $dtxt = Get-Content $decisoes -Raw -Encoding UTF8
    $qtd = ([regex]::Matches($dtxt, '(?m)^###\s+D\d+')).Count
    if ($qtd -gt 15) {
        Add-Achado 'AMARELO' 'Inchaco' "DECISOES.md tem $qtd decisoes (teto 15) - hora de quebrar em docs/decisoes/" '/harness fix'
    }
}

# custo estimado (~13 tokens por linha de markdown)
$custo = [int]($totalLinhas * 13)
$alertaCusto = @{ 'T1'=900; 'T2'=4000; 'T3'=8000 }
# Tier vem do manifesto e pode ter sufixo ('T2+'). Sem normalizar, a chave nao
# existe no mapa e o alerta nunca dispara - falha silenciosa, nao erro.
$tierBase = ($tier -replace '[^T0-9]', '')
if ($alertaCusto.ContainsKey($tierBase) -and $custo -gt $alertaCusto[$tierBase]) {
    Add-Achado 'AMARELO' 'Inchaco' "Harness custa ~$custo tokens/sessao (alerta ${tierBase}: $($alertaCusto[$tierBase]))" '/harness fix --limpar'
} elseif (-not $alertaCusto.ContainsKey($tierBase)) {
    Add-Achado 'AZUL' 'Inchaco' "Tier '$tier' nao tem alerta de custo definido - o custo nao esta sendo vigiado" 'revisar criterios/ORCAMENTOS.md'
}

# ============ F5 Mecanica: guardas sem disparo ============
$log = Join-Path $dirHarn 'log-guardas.jsonl'
if (Test-Path $log) {
    $linhas = @(Get-Content $log -Encoding UTF8 | Where-Object { $_.Trim() })
    $porGuarda = @{}
    foreach ($l in $linhas) {
        try {
            $e = $l | ConvertFrom-Json
            if ($e.guarda) {
                if (-not $porGuarda.ContainsKey($e.guarda)) { $porGuarda[$e.guarda] = 0 }
                $porGuarda[$e.guarda]++
            }
        } catch { }
    }
    $hooks = Join-Path $Projeto '.claude\hooks'
    if (Test-Path $hooks) {
        foreach ($h in Get-ChildItem $hooks -Filter '*.ps1' -File) {
            $g = $h.BaseName
            $idade = [int]((Get-Date) - $h.CreationTime).TotalDays
            if ($idade -ge 90 -and -not $porGuarda.ContainsKey($g)) {
                Add-Achado 'AZUL' 'Mecanica' "Guarda '$g' nunca disparou em $idade dias - avaliar abate" '/harness fix --limpar'
            }
        }
    }
} elseif ($tier -ne 'T1' -and (Test-Path (Join-Path $Projeto '.claude\hooks'))) {
    Add-Achado 'AMARELO' 'Mecanica' 'log-guardas.jsonl vazio ou ausente - os hooks podem nao estar rodando' 'verificar settings.json'
}

# ============ F5 Mecanica: projeto registrado na skill ============
# Passo escrito em comandos/init.md que ja foi pulado uma vez. REGISTRO.md vazio
# = a etapa 2 do /harness evolve nao tem o que varrer, e a skill nunca aprende.
# Lei 2: virou check mecanico em vez de continuar sendo so um pedido em texto.
$registro = Join-Path (Split-Path $PSScriptRoot -Parent) 'memoria\REGISTRO.md'
if (Test-Path $registro) {
    $rtxt = Get-Content $registro -Raw -Encoding UTF8
    if ($rtxt -notmatch [regex]::Escape($nome)) {
        Add-Achado 'AMARELO' 'Mecanica' "Projeto ausente de memoria/REGISTRO.md - a skill nao aprende com ele" '/harness evolve'
    }
}

# ============ F5 git ============
$voltar2 = $false
try {
    Push-Location $Projeto -ErrorAction Stop
    $voltar2 = $true
    $null = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0) {
        Add-Achado 'AZUL' 'Mecanica' 'Projeto nao e repositorio git (sem ponto de restauracao)' 'git init'
    }
} catch { } finally { if ($voltar2) { Pop-Location } }

# ============ saida ============
$v = @($achados | Where-Object { $_.severidade -eq 'VERMELHO' })
$a = @($achados | Where-Object { $_.severidade -eq 'AMARELO'  })
$z = @($achados | Where-Object { $_.severidade -eq 'AZUL'     })

if ($Json) {
    [pscustomobject]@{
        projeto = $nome; tier = $tier; versao_skill = $versaoSkill
        custo_tokens = $custo
        totais = @{ vermelho=$v.Count; amarelo=$a.Count; azul=$z.Count }
        achados = $achados
    } | ConvertTo-Json -Depth 6
    exit 0
}

Write-Output "DOCTOR (mecanico) | $nome | tier $tier | harness v$versaoSkill"
Write-Output "custo estimado: ~$custo tokens/sessao"
Write-Output ''
if ($achados.Count -eq 0) {
    Write-Output 'OK - nenhum problema mecanico encontrado.'
} else {
    foreach ($grupo in @(@('VERMELHO',$v), @('AMARELO',$a), @('AZUL',$z))) {
        if ($grupo[1].Count -gt 0) {
            Write-Output "$($grupo[0]) ($($grupo[1].Count))"
            foreach ($it in $grupo[1]) {
                Write-Output "  - [$($it.familia)] $($it.mensagem)"
                if ($it.correcao) { Write-Output "      -> $($it.correcao)" }
            }
            Write-Output ''
        }
    }
}
