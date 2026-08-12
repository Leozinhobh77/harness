<#
.SYNOPSIS
  Motor da SOMBRA - a maquina do tempo do projeto.
.DESCRIPTION
  Mantem um repositorio git "sombra" em .harness/sombra.git que fotografa o
  projeto inteiro antes de cada acao de risco. E separado do git do usuario:
  historico proprio, nao polui o "git log" dele, nao entra no commit dele.

  POR QUE ELE EXISTE (procedencia - Lei 1, excecao de seguranca de dado):
  o checkpoint nativo do Claude Code (/rewind) NAO rastreia mudanca feita por
  comando de shell (rm, mv, cp, redirecionamento), nem edicao de subagente em
  segundo plano, nem nada depois de 30 dias. E exatamente ai que se perde
  trabalho sem desfazer. A sombra cobre esse buraco, e so ele.

  QUEM TIRA FOTO: o hook .claude/hooks/sombra.ps1 do projeto (autocontido, para
  o projeto continuar protegido mesmo sem a skill instalada).
  QUEM LE E RESTAURA: este script, chamado por /harness voltar.

  NUNCA apaga arquivo do usuario. Restaurar sempre tira uma foto antes, e
  arquivo criado depois da foto e REPORTADO, nunca removido.

  ASCII puro de proposito (armadura ps1-check). Ver PADROES.md P001.
.EXAMPLE
  powershell -File sombra.ps1 -Projeto "C:\...\Meu Site" -Listar
  powershell -File sombra.ps1 -Projeto "C:\...\Meu Site" -Diff 2
  powershell -File sombra.ps1 -Projeto "C:\...\Meu Site" -Restaurar 2
  powershell -File sombra.ps1 -Projeto "C:\...\Meu Site" -Status -Json
#>
param(
    [Parameter(Mandatory=$true)][string]$Projeto,
    [switch]$Listar,
    [int]$Diff = 0,
    [int]$Restaurar = 0,
    [switch]$Status,
    [switch]$Limpar,
    [switch]$Snapshot,
    [string]$Motivo = 'foto manual',
    [int]$Quantos = 20,
    [switch]$Json
)

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Test-Path -LiteralPath $Projeto)) {
    Write-Output "ERRO: projeto nao encontrado -> $Projeto"
    exit 1
}

$Raiz   = (Resolve-Path -LiteralPath $Projeto).Path.TrimEnd('\')
$Sombra = Join-Path $Raiz '.harness\sombra.git'

# ------------------------------------------------------------------
# git da sombra: --git-dir aponta pro repo bare, --work-tree pro projeto.
# E assim que o git enxerga os arquivos do projeto sem existir um .git
# dentro dele. Identidade fixa para nao depender do git config do usuario
# (repo novo sem user.name configurado recusa commitar).
# ------------------------------------------------------------------
function Invoke-GitSombra {
    param([string[]]$Argumentos)
    $base = @(
        '--git-dir',   $Sombra,
        '--work-tree', $Raiz,
        '-c', 'user.name=harness-sombra',
        '-c', 'user.email=sombra@harness.local',
        '-c', 'core.autocrlf=false',
        '-c', 'core.safecrlf=false',
        '-c', 'core.fileMode=false'
    )
    $saida = & git @($base + $Argumentos) 2>$null
    return $saida
}

function Test-SombraExiste {
    return (Test-Path -LiteralPath (Join-Path $Sombra 'HEAD'))
}

# O que a sombra NUNCA fotografa. Curto de proposito: quanto menos exclusao,
# mais poder de restauracao. So sai o que e gigante e se reconstroi sozinho
# (dependencia baixada, cache) e o que criaria recursao (a propria sombra).
$Exclusoes = @(
    '/.git/',
    '/.harness/sombra.git/',
    'node_modules/',
    '.venv/',
    'venv/',
    '__pycache__/',
    '*.pyc',
    '.pytest_cache/',
    '.gradle/',
    'Thumbs.db',
    '.DS_Store'
)

function New-Sombra {
    if (Test-SombraExiste) { return $true }
    $pai = Split-Path $Sombra -Parent
    if (-not (Test-Path -LiteralPath $pai)) {
        New-Item -ItemType Directory -Force -Path $pai | Out-Null
    }
    $null = & git init --bare --quiet "$Sombra" 2>$null
    if (-not (Test-SombraExiste)) { return $false }

    $infoDir = Join-Path $Sombra 'info'
    if (-not (Test-Path -LiteralPath $infoDir)) {
        New-Item -ItemType Directory -Force -Path $infoDir | Out-Null
    }
    Set-Content -Path (Join-Path $infoDir 'exclude') -Value $Exclusoes -Encoding ASCII
    return $true
}

function Get-TamanhoSombra {
    if (-not (Test-SombraExiste)) { return 0 }
    $bytes = (Get-ChildItem -LiteralPath $Sombra -Recurse -File -ErrorAction SilentlyContinue |
              Measure-Object -Property Length -Sum).Sum
    if (-not $bytes) { return 0 }
    return [math]::Round($bytes / 1MB, 1)
}

# "ha 4 min", "ha 2 horas", "ontem 15:40". O %ar do git sai em INGLES e nao ha
# como traduzir por parametro - a skill inteira e em portugues, entao o tempo
# relativo e calculado aqui. Achado no teste de aceitacao da v1.4.0.
function Get-Quando {
    param([datetime]$Data)
    $s = [int]((Get-Date) - $Data).TotalSeconds
    if ($s -lt 60)    { return 'agora mesmo' }
    if ($s -lt 3600)  { return "ha $([int]($s/60)) min" }
    if ($s -lt 86400) {
        $h = [int]($s/3600)
        if ($h -eq 1) { return 'ha 1 hora' }
        return "ha $h horas"
    }
    if ($s -lt 172800) { return ('ontem ' + $Data.ToString('HH:mm')) }
    return $Data.ToString('dd/MM HH:mm')
}

# Devolve a lista de fotos, mais nova primeiro. Numero 1 = a mais recente.
function Get-Fotos {
    param([int]$Limite = 20)
    if (-not (Test-SombraExiste)) { return @() }
    $sep = [char]1
    $campo = [char]2
    $bruto = Invoke-GitSombra @('log', "--format=$sep%H$campo%aI$campo%ad$campo%s",
                                '--date=format:%d/%m %H:%M', '--name-only',
                                '-n', [string]$Limite)
    if (-not $bruto) { return @() }

    $texto = ($bruto -join "`n")
    $fotos = New-Object System.Collections.Generic.List[object]
    $n = 0
    foreach ($bloco in ($texto -split [string]$sep)) {
        if (-not $bloco.Trim()) { continue }
        $linhas = @($bloco -split "`n")
        $cab = @($linhas[0] -split [string]$campo)
        if ($cab.Count -lt 4) { continue }
        $arquivos = @($linhas | Select-Object -Skip 1 | Where-Object { $_.Trim() })
        $n++
        $quando = $cab[1]
        try { $quando = Get-Quando ([datetime]::Parse($cab[1], [Globalization.CultureInfo]::InvariantCulture)) } catch { }
        $fotos.Add([pscustomobject]@{
            numero   = $n
            hash     = $cab[0]
            quando   = $quando
            data     = $cab[2]
            motivo   = $cab[3]
            arquivos = $arquivos.Count
        })
    }
    return $fotos.ToArray()
}

function Resolve-Foto {
    param([int]$Numero)
    $fotos = Get-Fotos -Limite ([math]::Max($Numero, 20))
    if ($fotos.Count -eq 0) { return $null }
    if ($Numero -lt 1 -or $Numero -gt $fotos.Count) { return $null }
    return $fotos[$Numero - 1]
}

# ------------------------------------------------------------------
# SNAPSHOT - tirar uma foto. O hook do projeto faz isso sozinho; aqui existe
# para uso manual e para a foto de seguranca antes de restaurar.
# Sem mudanca no disco = sem foto. Nao se enche o historico de foto igual.
# ------------------------------------------------------------------
function Invoke-Snapshot {
    param([string]$Razao)
    if (-not (New-Sombra)) { return 'ERRO: nao consegui criar a sombra' }

    $null = Invoke-GitSombra @('add', '-A')
    $pendente = Invoke-GitSombra @('status', '--porcelain')
    $temHistorico = (Invoke-GitSombra @('rev-parse', '--verify', 'HEAD'))
    if (-not $pendente -and $temHistorico) { return 'SEM_MUDANCA' }

    $null = Invoke-GitSombra @('commit', '--quiet', '--allow-empty', '-m', $Razao)
    $hash = (Invoke-GitSombra @('rev-parse', '--short', 'HEAD'))
    if ($hash) { return "OK $hash" }
    return 'ERRO: commit da sombra falhou'
}

# ==================================================================
# ACOES
# ==================================================================

# ---------- STATUS (usado pelo doctor) ----------
if ($Status) {
    $existe = Test-SombraExiste
    $fotos  = @()
    if ($existe) { $fotos = Get-Fotos -Limite 500 }
    $ultima = ''
    if ($fotos.Count -gt 0) { $ultima = $fotos[0].data }

    if ($Json) {
        [pscustomobject]@{
            existe    = $existe
            fotos     = $fotos.Count
            tamanhoMB = (Get-TamanhoSombra)
            ultima    = $ultima
        } | ConvertTo-Json -Depth 3
        exit 0
    }
    if (-not $existe) { Write-Output 'SOMBRA: nao existe neste projeto'; exit 2 }
    Write-Output "SOMBRA: $($fotos.Count) foto(s) | $(Get-TamanhoSombra) MB | ultima: $ultima"
    exit 0
}

# ---------- SNAPSHOT manual ----------
if ($Snapshot) {
    $r = Invoke-Snapshot -Razao $Motivo
    Write-Output $r
    if ($r -like 'ERRO*') { exit 1 }
    exit 0
}

# ---------- LISTAR ----------
if ($Listar) {
    if (-not (Test-SombraExiste)) {
        Write-Output 'SEM_SOMBRA: este projeto ainda nao tem sombra.'
        exit 2
    }
    $fotos = Get-Fotos -Limite $Quantos
    if ($Json) { $fotos | ConvertTo-Json -Depth 3; exit 0 }

    if ($fotos.Count -eq 0) { Write-Output 'Nenhuma foto ainda.'; exit 0 }
    Write-Output "SOMBRA | $(Get-TamanhoSombra) MB"
    Write-Output ''
    foreach ($f in $fotos) {
        $arq = "$($f.arquivos) arquivo(s)"
        if ($f.arquivos -eq 0) { $arq = '-' }
        Write-Output ("  {0,2} | {1,-14} | {2,-16} | {3}" -f $f.numero, $f.quando, $arq, $f.motivo)
    }
    exit 0
}

# ---------- DIFF ----------
if ($Diff -gt 0) {
    $f = Resolve-Foto $Diff
    if (-not $f) { Write-Output "ERRO: nao existe foto numero $Diff"; exit 1 }
    Write-Output "O que mudou da foto $Diff ($($f.quando) - $($f.motivo)) ate agora:"
    Write-Output ''
    $null = Invoke-GitSombra @('add', '-A')
    $saida = Invoke-GitSombra @('diff', '--stat', $f.hash)
    if (-not $saida) { Write-Output '  (nada mudou desde essa foto)' }
    else { $saida | ForEach-Object { Write-Output "  $_" } }
    exit 0
}

# ---------- RESTAURAR ----------
if ($Restaurar -gt 0) {
    $f = Resolve-Foto $Restaurar
    if (-not $f) { Write-Output "ERRO: nao existe foto numero $Restaurar"; exit 1 }

    # 1. Rede de seguranca: o estado atual vira foto ANTES de qualquer escrita.
    #    E isto que faz "desfazer o desfazer" ser possivel.
    $antes = Invoke-Snapshot -Razao "antes de voltar para a foto $Restaurar ($($f.motivo))"
    if ($antes -like 'ERRO*') { Write-Output $antes; exit 1 }
    $hashAtual = (Invoke-GitSombra @('rev-parse', 'HEAD'))

    # 2. Arquivos que existem agora e NAO existiam na foto. O checkout nao os
    #    remove, e nos tambem nao - so avisamos. Nada e apagado, nunca.
    $extras = @()
    if ($hashAtual) {
        $extras = @(Invoke-GitSombra @('diff', '--name-only', '--diff-filter=A',
                                       $f.hash, $hashAtual) | Where-Object { $_.Trim() })
    }

    # 3. Restaura o conteudo da foto por cima do disco.
    $null = Invoke-GitSombra @('checkout', $f.hash, '--', '.')
    $null = Invoke-GitSombra @('reset', '--mixed', '--quiet', 'HEAD')

    Write-Output "VOLTOU para a foto $Restaurar - $($f.quando) - $($f.motivo)"
    Write-Output ''
    Write-Output "  O estado anterior virou foto tambem (foto 1). Da para desfazer isto."
    if ($extras.Count -gt 0) {
        Write-Output ''
        Write-Output "  ATENCAO: $($extras.Count) arquivo(s) criado(s) DEPOIS dessa foto"
        Write-Output "  continuam no disco (nao apago nada). Confira se ainda quer:"
        foreach ($e in ($extras | Select-Object -First 10)) { Write-Output "    - $e" }
        if ($extras.Count -gt 10) { Write-Output "    ... e mais $($extras.Count - 10)" }
    }
    exit 0
}

# ---------- LIMPAR ----------
if ($Limpar) {
    if (-not (Test-SombraExiste)) { Write-Output 'SEM_SOMBRA'; exit 2 }
    $antesMB = Get-TamanhoSombra
    $null = Invoke-GitSombra @('reflog', 'expire', '--expire=now', '--all')
    $null = Invoke-GitSombra @('gc', '--prune=now', '--quiet')
    $depoisMB = Get-TamanhoSombra
    Write-Output "SOMBRA compactada: $antesMB MB -> $depoisMB MB"
    Write-Output '(compactacao nao apaga foto nenhuma - so reorganiza o arquivo)'
    exit 0
}

# ---------- sem acao ----------
Write-Output 'Use: -Listar | -Diff N | -Restaurar N | -Status | -Snapshot | -Limpar'
exit 0
