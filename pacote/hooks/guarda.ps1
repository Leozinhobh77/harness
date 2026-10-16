<#
  GUARDA (PreToolUse) - bloqueia acao proibida ANTES de acontecer.

  Nivel 2 da tabela do /harness learn. Le os padroes de .harness/guardas.json
  para que novas guardas entrem por DADO, nunca editando este script.

  Contrato Claude Code: stdin = JSON do evento. exit 2 = bloqueia e manda
  o texto de stderr para o modelo. exit 0 = libera.

  ASCII puro (armadura ps1-check).
#>
$ErrorActionPreference = 'Stop'

# Sem isto, qualquer acento no JSON de entrada (nome de pasta, comando) chega corrompido -
# "Usuario" virava lixo tipo "Usu[bytes]rio" e quebrava qualquer comparacao de caminho.
try { [Console]::InputEncoding = [System.Text.Encoding]::UTF8 } catch { }

# FALHA FECHADA (v1.14.0). Ate a v1.13.0 todo erro aqui terminava em exit 0 -
# a guarda que nao conseguia ler o pedido LIBERAVA o pedido. Guarda nao sabe
# o que esta liberando = guarda desligada com cara de ligada (P016). O par
# mecanico disto e o "onFailure": "block" no settings.json, que cobre o caso
# em que este script nem chega a rodar (powershell nao abre, estoura o tempo).
function Bloquear-PorFalha {
    param([string]$Motivo)
    [Console]::Error.WriteLine("BLOQUEADO (falha-fechada): $Motivo")
    [Console]::Error.WriteLine('A guarda nao conseguiu conferir esta acao, entao nao a liberou.')
    exit 2
}

try { $bruto = [Console]::In.ReadToEnd() } catch { Bloquear-PorFalha 'nao consegui ler o pedido da ferramenta.' }
if ([string]::IsNullOrWhiteSpace($bruto)) { Bloquear-PorFalha 'o pedido da ferramenta chegou vazio.' }

try { $ev = $bruto | ConvertFrom-Json } catch { Bloquear-PorFalha 'o pedido da ferramenta nao e JSON valido.' }

$raiz = $env:CLAUDE_PROJECT_DIR
if (-not $raiz) { $raiz = (Get-Location).Path }

# $env:CLAUDE_PROJECT_DIR chega em formato inconsistente (visto na pratica: barra normal e
# letra de unidade minuscula, "c:/Users/..."). Normaliza uma vez aqui para todo o resto do
# script comparar sempre a mesma forma canonica (Resolve-Path sempre devolve "C:\Users\...").
function Normalizar-Caminho {
    param([string]$Caminho)
    if (-not $Caminho) { return $Caminho }
    try { return (Resolve-Path -LiteralPath $Caminho -ErrorAction Stop).Path.TrimEnd('\', '/') }
    catch { return $Caminho.Replace('/', '\').TrimEnd('\', '/') }
}
$raiz = Normalizar-Caminho $raiz

$ferramenta = [string]$ev.tool_name
$alvo = ''
if ($ev.tool_input) {
    if ($ev.tool_input.file_path)   { $alvo = [string]$ev.tool_input.file_path }
    elseif ($ev.tool_input.notebook_path) { $alvo = [string]$ev.tool_input.notebook_path }
}
$comando = ''
if ($ev.tool_input -and $ev.tool_input.command) { $comando = [string]$ev.tool_input.command }

# ---------- carrega as guardas ----------
$cfg = Join-Path $raiz '.harness\guardas.json'
if (-not (Test-Path $cfg)) { exit 0 }    # sem arquivo = projeto sem guardas, nao e falha
try { $g = Get-Content $cfg -Raw -Encoding UTF8 | ConvertFrom-Json } catch {
    # Arquivo de guardas quebrado desligava TODAS as guardas sem aviso. Agora
    # bloqueia - menos a edicao do proprio guardas.json, senao a IA nunca
    # conseguiria consertar o arquivo que esta travando tudo.
    $alvoCfg = ($alvo.Replace('/', '\')).TrimEnd('\')
    if ($alvoCfg -and $alvoCfg.EndsWith('.harness\guardas.json', [StringComparison]::OrdinalIgnoreCase)) { exit 0 }
    Bloquear-PorFalha '.harness/guardas.json esta ilegivel (JSON quebrado). Conserte o arquivo - a edicao dele continua liberada.'
}

function Escrever-Log {
    param([string]$Guarda, [string]$Acao, [string]$Detalhe)
    try {
        $dir = Join-Path $raiz '.harness'
        if (-not (Test-Path $dir)) { return }
        $reg = [pscustomobject]@{
            data    = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
            guarda  = $Guarda
            acao    = $Acao
            detalhe = $Detalhe
        } | ConvertTo-Json -Compress
        Add-Content -Path (Join-Path $dir 'log-guardas.jsonl') -Value $reg -Encoding UTF8
    } catch { }
}

$bloqueios = New-Object System.Collections.Generic.List[string]

# ---------- 1. arquivos protegidos ----------
if ($alvo -and $ferramenta -match '^(Write|Edit|NotebookEdit)$' -and $g.arquivos_protegidos) {
    $rel = $alvo
    if ($alvo.StartsWith($raiz, [StringComparison]::OrdinalIgnoreCase)) {
        $rel = $alvo.Substring($raiz.Length).TrimStart('\', '/')
    }
    $relBarra = $rel.Replace('\', '/')
    foreach ($regra in $g.arquivos_protegidos) {
        if ($relBarra -like $regra.padrao) {
            $bloqueios.Add("BLOQUEADO: '$relBarra' e arquivo protegido. Motivo: $($regra.motivo)")
            Escrever-Log $regra.nome 'bloqueou' $relBarra
        }
    }
}

# ---------- 2. comandos proibidos ----------
# So bloqueia se o comando agir DENTRO deste projeto. Se o comando comeca com "cd <outro
# caminho> && ..." apontando pra FORA da raiz, ele nao mexe neste repositorio - nao e
# trabalho desta guarda impedir. Sem isso, "cd ..\outro-repo && git push" era bloqueado so
# por conter o texto "git push", mesmo mirando um repositorio sem nenhuma relacao com este
# projeto. Achado ao vivo: a guarda de Financas bloqueou um push legitimo pro repositorio
# harness. Ver P006 em memoria/PADROES.md da skill.
$dirEfetivo = $raiz
if ($comando -match '^\s*cd\s+"?([^"&;]+?)"?\s*(&&|;)') {
    $caminhoCd = $Matches[1].Trim()
    # o Bash deste ambiente usa caminho estilo Git Bash (/c/Users/...), nao Windows
    # (C:\Users\...) - Resolve-Path so entende o segundo formato. Converte antes de resolver.
    if ($caminhoCd -match '^/([A-Za-z])/(.*)$') {
        $caminhoCd = "$($Matches[1].ToUpper()):\$($Matches[2] -replace '/', '\')"
    }
    try {
        $alvoCd = Resolve-Path -LiteralPath $caminhoCd -ErrorAction Stop
        $dirEfetivo = $alvoCd.Path
    } catch { }
}
$mexeNesteProjeto = $dirEfetivo.TrimEnd('\', '/').StartsWith($raiz.TrimEnd('\', '/'), [StringComparison]::OrdinalIgnoreCase)

# Bash E PowerShell. Ate a v1.8.0 esta linha olhava so 'Bash' - e no Windows a
# maioria dos comandos passa pela ferramenta PowerShell, entao `git reset
# --hard` por la NAO era bloqueado em nenhum projeto. A guarda existia e nao
# guardava. Achado por leitura de codigo no evolve de 13/08/2026.
if ($comando -and $ferramenta -match '^(Bash|PowerShell)$' -and $g.comandos_proibidos -and $mexeNesteProjeto) {
    foreach ($regra in $g.comandos_proibidos) {
        if ($comando -match $regra.padrao) {
            $bloqueios.Add("BLOQUEADO: comando proibido neste projeto. Motivo: $($regra.motivo)")
            Escrever-Log $regra.nome 'bloqueou' $comando
        }
    }
}

if ($bloqueios.Count -gt 0) {
    [Console]::Error.WriteLine(($bloqueios -join "`n"))
    [Console]::Error.WriteLine('')
    [Console]::Error.WriteLine('Se esta guarda estiver errada, use /harness learn para corrigi-la.')
    exit 2
}

exit 0
