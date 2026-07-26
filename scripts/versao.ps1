<#
.SYNOPSIS
  Status de versao da skill /harness + lembrete de evolucao.
.DESCRIPTION
  Rodado em TODA invocacao da skill. Devolve "OK" quando esta em dia
  (sucesso e silencioso) ou uma linha curta de aviso quando venceu o prazo.
.EXAMPLE
  powershell -File versao.ps1
  powershell -File versao.ps1 -Json
#>
param([switch]$Json)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz    = Split-Path -Parent $PSScriptRoot
$arquivo = Join-Path $raiz 'VERSAO.json'

if (-not (Test-Path $arquivo)) {
    Write-Output "ERRO: VERSAO.json nao encontrado em $raiz"
    exit 1
}

$v     = Get-Content $arquivo -Raw -Encoding UTF8 | ConvertFrom-Json
$hoje  = (Get-Date).Date
$cult  = [Globalization.CultureInfo]::InvariantCulture

function Dias([string]$data) {
    if ([string]::IsNullOrWhiteSpace($data)) { return 9999 }
    try   { return [int]($hoje - [datetime]::Parse($data, $cult).Date).TotalDays }
    catch { return 9999 }
}

$diasEvolucao = Dias $v.ultima_evolucao
$diasPesquisa = Dias $v.ultima_pesquisa_web

$pSugerir  = 14; $pInsistir = 30; $pPesquisa = 45
if ($v.prazos_dias) {
    if ($v.prazos_dias.evolucao_sugerir)     { $pSugerir  = [int]$v.prazos_dias.evolucao_sugerir }
    if ($v.prazos_dias.evolucao_insistir)    { $pInsistir = [int]$v.prazos_dias.evolucao_insistir }
    if ($v.prazos_dias.pesquisa_web_sugerir) { $pPesquisa = [int]$v.prazos_dias.pesquisa_web_sugerir }
}

$avisos = @()
if     ($diasEvolucao -ge $pInsistir) { $avisos += "[!] $diasEvolucao dias sem evoluir a skill (prazo: $pInsistir) -> /harness evolve" }
elseif ($diasEvolucao -ge $pSugerir)  { $avisos += "[.] ja sao $diasEvolucao dias desde a ultima evolucao -> /harness evolve" }
if     ($diasPesquisa -ge $pPesquisa) { $avisos += "[.] $diasPesquisa dias sem checar o estado da arte -> /harness evolve (etapa de pesquisa)" }

if ($Json) {
    [pscustomobject]@{
        versao          = $v.versao
        atualizada_em   = $v.atualizada_em
        dias_evolucao   = $diasEvolucao
        dias_pesquisa   = $diasPesquisa
        projetos        = $v.projetos_criados
        em_dia          = ($avisos.Count -eq 0)
        avisos          = $avisos
    } | ConvertTo-Json -Depth 4
    exit 0
}

Write-Output "harness v$($v.versao) | atualizada em $($v.atualizada_em) | $($v.projetos_criados) projeto(s)"

if ($avisos.Count -eq 0) {
    Write-Output "OK"
} else {
    $avisos | ForEach-Object { Write-Output $_ }
}
