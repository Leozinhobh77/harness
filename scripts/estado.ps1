<#
.SYNOPSIS
  Regenera o ESTADO.md de um projeto a partir dos Planos/ e do git.
.DESCRIPTION
  ESTADO.md e DERIVADO, nunca escrito a mao. Por isso nao pode divergir da
  realidade: ele nao e fonte de nada, e uma vista.
  Fontes: Planos/*.md (frontmatter), Planos/Conclu*/ , git log.

  NOTA: este arquivo e ASCII puro de proposito. Todo texto acentuado vive no
  template templates/comum/ESTADO.tpl.md (UTF-8). Ver PADROES.md P001.
.EXAMPLE
  powershell -File estado.ps1 -Projeto "C:\Users\...\Financas"
  powershell -File estado.ps1 -Projeto "..." -Preview
#>
param(
    [Parameter(Mandatory=$true)][string]$Projeto,
    [switch]$Preview
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Test-Path $Projeto)) {
    Write-Output "ERRO: projeto nao encontrado -> $Projeto"
    exit 1
}

$raizSkill = Split-Path -Parent $PSScriptRoot
$template  = Join-Path $raizSkill 'templates\comum\ESTADO.tpl.md'
if (-not (Test-Path $template)) {
    Write-Output "ERRO: template nao encontrado -> $template"
    exit 1
}

$hoje      = Get-Date -Format 'yyyy-MM-dd'
$nome      = Split-Path $Projeto -Leaf
$dirPlanos = Join-Path $Projeto 'Planos'

# Pasta de concluidos: casa por curinga para nao depender de acento no nome.
$dirConcl = $null
if (Test-Path $dirPlanos) {
    $achado = Get-ChildItem $dirPlanos -Directory -Filter 'Conclu*' -ErrorAction SilentlyContinue |
              Select-Object -First 1
    if ($achado) { $dirConcl = $achado.FullName }
}

# ---------- tier e versao (do manifesto) ----------
$tier = 'T?'
$versaoSkill = '?'
$manifesto = Join-Path $Projeto '.harness\manifesto.json'
if (Test-Path $manifesto) {
    try {
        $m = Get-Content $manifesto -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($m.tier)         { $tier        = [string]$m.tier }
        if ($m.versao_skill) { $versaoSkill = [string]$m.versao_skill }
    } catch { }
}

# ---------- planos ativos ----------
$linhasPlanos = New-Object System.Collections.Generic.List[string]
if (Test-Path $dirPlanos) {
    $arquivos = Get-ChildItem $dirPlanos -Filter '*.md' -File |
                Where-Object { $_.Name -match '^\d{4}-' } |
                Sort-Object Name -Descending
    foreach ($f in $arquivos) {
        $txt = Get-Content $f.FullName -Raw -Encoding UTF8
        $titulo = $f.BaseName
        $status = ''
        $prog   = ''
        if ($txt -match '(?m)^titulo:\s*(.+)$')    { $titulo = $Matches[1].Trim() }
        if ($txt -match '(?m)^status:\s*(.+)$')    { $status = ($Matches[1] -split '#')[0].Trim() }
        if ($txt -match 'Progresso:\s*([^\r\n]+)') { $prog   = $Matches[1].Trim() }

        $id    = $f.Name.Substring(0, 4)
        $idade = [int]((Get-Date) - $f.LastWriteTime).TotalDays

        $partes = New-Object System.Collections.Generic.List[string]
        $partes.Add("**$id** - $titulo")
        if ($status) { $partes.Add($status) }
        if ($prog)   { $partes.Add($prog) }
        $linha = '- ' + ($partes -join ' | ')

        # Alerta de deriva: plano em andamento parado ha mais de 30 dias.
        if ($status -match 'andamento' -and $idade -gt 30) {
            $linha += "  [!] sem alteracao ha $idade dias"
        }
        $linhasPlanos.Add($linha)
    }
}
if ($linhasPlanos.Count -eq 0) { $linhasPlanos.Add('_Nenhum plano ativo._') }

# ---------- concluidos ----------
$qtdConcluidos = 0
if ($dirConcl) {
    $qtdConcluidos = @(Get-ChildItem $dirConcl -Filter '*.md' -File -ErrorAction SilentlyContinue |
                       Where-Object { $_.Name -match '^\d{4}-' }).Count
}

# ---------- git ----------
$commits   = @()
$pendentes = @()
$ehRepo    = $false
$voltar    = $false
try {
    Push-Location $Projeto -ErrorAction Stop
    $voltar = $true
    $null = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0) {
        $ehRepo    = $true
        $commits   = @(git log -3 --format='%ad %s' --date=short 2>$null)
        $pendentes = @(git status --porcelain 2>$null)
    }
} catch { } finally { if ($voltar) { Pop-Location } }

if ($ehRepo) {
    if ($commits.Count -gt 0) { $blocoCommits = (($commits | ForEach-Object { "- $_" }) -join "`r`n") }
    else                      { $blocoCommits = '_Repositorio sem commits ainda._' }
    if ($pendentes.Count -gt 0) { $blocoStatus = "[!] $($pendentes.Count) arquivo(s) sem commit na hora da geracao." }
    else                        { $blocoStatus = '[ok] Working tree limpo na geracao.' }
} else {
    $blocoCommits = '_Projeto nao e um repositorio git._'
    $blocoStatus  = '[!] Sem git = sem ponto de restauracao. Considere rodar git init.'
}

# ---------- migracoes pendentes: o aviso do modelo PULL ----------
#
# PROCEDENCIA (15/08/2026): a v1.11.1 corrigiu um buraco de seguranca em 4
# projetos, na mao, um por um. Com 20 ou 30 projetos isso e impossivel - e
# inverte o proposito, porque mexer na skill viraria manutencao nos outros.
#
# O modelo e PULL: a skill NUNCA empurra nada. Cada projeto descobre sozinho,
# quando e aberto, que esta atrasado. Projeto que ninguem abre nao paga nada e
# fica parado na versao dele, que e o comportamento desejado.
#
# POR QUE AQUI, e nao num hook novo: o hook da sombra de TODO projeto ja chama
# este script no inicio da sessao, e o ESTADO.md ja e lido toda sessao. Ou
# seja - o canal ja existe, e o aviso custa ZERO arquivo novo dentro dos
# projetos. Hook novo teria o problema do ovo e da galinha: para receber o
# aviso, o projeto precisaria antes receber o hook que da o aviso.
#
# SILENCIO E O PADRAO: versao diferente nao gera aviso; so gera aviso migracao
# PENDENTE. Sem isso todo patch da skill incomodaria 30 projetos a toa, e
# alarme falso vira alarme desligado (P011).
#
# E CONFERE NO DISCO antes de acusar: o numero da versao no manifesto e
# indicio, nao prova - o usuario pode ter aplicado a correcao a mao. Dado
# errado e pior que dado nenhum (P013).
$blocoPend = ''
try {
    $arqVer = Join-Path $raizSkill 'VERSAO.json'
    $lib    = Join-Path $PSScriptRoot '_migracoes.ps1'
    if ((Test-Path $arqVer) -and (Test-Path $lib)) {
        . $lib
        $verInstalada = [string](Get-Content $arqVer -Raw -Encoding UTF8 | ConvertFrom-Json).versao
        $pend = @(Get-MigracoesPendentes -Projeto $Projeto -RaizSkill $raizSkill `
                                         -VersaoProjeto $versaoSkill -Tier $tier)

        if ($pend.Count -gt 0) {
            $fragmento = Join-Path $raizSkill 'templates\comum\ESTADO-pendencias.tpl.md'
            if (Test-Path $fragmento) {
                $qtdSeg = @($pend | Where-Object { [string]$_.gravidade -eq 'seguranca' }).Count
                $linhas = New-Object System.Collections.Generic.List[string]
                foreach ($mg in $pend) {
                    if ([string]$mg.gravidade -eq 'seguranca') {
                        $linhas.Add("> - **[SEGURANCA]** $($mg.titulo)  _(v$($mg.versao))_")
                    } else {
                        $linhas.Add("> - $($mg.titulo)  _(v$($mg.versao))_")
                    }
                }
                $sufixo = ''
                if ($qtdSeg -gt 0) { $sufixo = ", $qtdSeg de SEGURANCA" }

                $blocoPend = Get-Content $fragmento -Raw -Encoding UTF8
                $blocoPend = $blocoPend.Replace('{{QTD}}',          [string]$pend.Count)
                $blocoPend = $blocoPend.Replace('{{SUFIXO_SEG}}',   $sufixo)
                $blocoPend = $blocoPend.Replace('{{VER_PROJETO}}',  $versaoSkill)
                $blocoPend = $blocoPend.Replace('{{VER_SKILL}}',    $verInstalada)
                $blocoPend = $blocoPend.Replace('{{LISTA}}',        ($linhas -join "`r`n"))
                $blocoPend = $blocoPend.TrimEnd() + "`r`n"
            }
        }
    }
} catch { }   # sem a skill instalada, ou JSON quebrado: silencio. Nunca atrapalha.

# ---------- montagem a partir do template ----------
$conteudo = Get-Content $template -Raw -Encoding UTF8
$conteudo = $conteudo.Replace('{{PENDENCIAS}}', $blocoPend)
$conteudo = $conteudo.Replace('{{PROJETO}}',        $nome)
$conteudo = $conteudo.Replace('{{DATA}}',           $hoje)
$conteudo = $conteudo.Replace('{{TIER}}',           $tier)
$conteudo = $conteudo.Replace('{{VERSAO}}',         $versaoSkill)
$conteudo = $conteudo.Replace('{{PLANOS}}',         ($linhasPlanos -join "`r`n"))
$conteudo = $conteudo.Replace('{{QTD_CONCLUIDOS}}', [string]$qtdConcluidos)
$conteudo = $conteudo.Replace('{{COMMITS}}',        $blocoCommits)
$conteudo = $conteudo.Replace('{{GIT_STATUS}}',     $blocoStatus)

if ($Preview) {
    Write-Output $conteudo
    exit 0
}

$destino = Join-Path $Projeto 'ESTADO.md'
Set-Content -Path $destino -Value $conteudo -Encoding UTF8
$qtdLinhas = ($conteudo -split "`n").Count
Write-Output "ESTADO.md regenerado ($qtdLinhas linhas) -> $destino"
