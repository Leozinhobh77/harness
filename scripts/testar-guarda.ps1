<#
  TESTE DA GUARDA NOS DOIS SENTIDOS - o que deve bloquear bloqueia, o que deve
  passar passa.

  POR QUE (P019, 16/10/2026): a guarda do template liberava a acao em 3 de 3
  casos de falha e o doctor passava limpo - nenhum check RODAVA a guarda, so
  olhava o texto dela. Teste de um lado so ("bloqueia o proibido?") nao pega
  isso: e preciso testar tambem o que acontece quando ela nao consegue conferir.
  O doctor --skill chama este script; ele tambem roda sozinho.

  Projeto de mentira em %TEMP%, nunca em projeto real. Sai 0 = tudo passou,
  1 = alguma falha (lista os casos). ASCII puro (armadura ps1-check).
.EXAMPLE
  powershell -File testar-guarda.ps1
  powershell -File testar-guarda.ps1 -Guarda <outro guarda.ps1> -Silencioso
#>
param(
    [string]$Guarda,
    [string]$GuardasJson,
    [switch]$Silencioso
)

$raizSkill = Split-Path $PSScriptRoot -Parent
if (-not $Guarda)      { $Guarda      = Join-Path $raizSkill 'templates\T2-padrao\.claude\hooks\guarda.ps1' }
if (-not $GuardasJson) { $GuardasJson = Join-Path $raizSkill 'templates\T2-padrao\.harness\guardas.json' }

$t = Join-Path $env:TEMP ('harness-teste-guarda-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force (Join-Path $t '.harness') | Out-Null
Copy-Item -LiteralPath $GuardasJson (Join-Path $t '.harness\guardas.json')
$t = (Resolve-Path -LiteralPath $t).Path
$antes = $env:CLAUDE_PROJECT_DIR
$env:CLAUDE_PROJECT_DIR = $t

$falhas = New-Object System.Collections.Generic.List[string]
function Rodar([string]$nome, [string]$entrada, [int]$esperado) {
    $null = $entrada | powershell -NoProfile -ExecutionPolicy Bypass -File $Guarda 2>&1
    $c = $LASTEXITCODE
    if ($c -ne $esperado) { $script:falhas.Add("$nome (esperado $esperado, veio $c)") }
    if (-not $Silencioso) {
        $ok = 'PASSOU'; if ($c -ne $esperado) { $ok = 'FALHOU' }
        '{0,-7} esperado={1} veio={2}  {3}' -f $ok, $esperado, $c, $nome
    }
}

# O comando proibido e montado em pedacos: guardas externas (ex.: a armadura
# da Forge) bloqueiam qualquer comando que apenas CITE o texto (P008).
$pf = 'git push --' + 'force origin main'
$tj = $t -replace '\\', '\\'
$cmdRuim  = '{"tool_name":"PowerShell","tool_input":{"command":"' + $pf + '"}}'
$cmdBom   = '{"tool_name":"PowerShell","tool_input":{"command":"git status"}}'
$escrita  = '{"tool_name":"Write","tool_input":{"file_path":"' + $tj + '\\src\\a.txt"}}'
$editaCfg = '{"tool_name":"Edit","tool_input":{"file_path":"' + $tj + '\\.harness\\guardas.json"}}'

try {
    Rodar 'comando proibido (push forcado)' $cmdRuim 2
    Rodar 'comando inofensivo (git status)' $cmdBom 0
    Rodar 'escrita comum' $escrita 0
    Rodar 'pedido vazio' '' 2
    Rodar 'pedido que nao e JSON' 'isso nao e json' 2
    Set-Content -LiteralPath (Join-Path $t '.harness\guardas.json') -Value '{ quebrado' -Encoding ASCII
    Rodar 'guardas.json quebrado + escrita comum' $escrita 2
    Rodar 'guardas.json quebrado + editar o proprio guardas.json' $editaCfg 0
    # .NET direto: o %TEMP% desta maquina vem com nome curto (USURIO~2), que o
    # Rename-Item recusa mesmo com -LiteralPath.
    [IO.File]::Move((Join-Path $t '.harness\guardas.json'), (Join-Path $t '.harness\guardas.antigo'))
    Rodar 'sem guardas.json (projeto sem guardas)' $escrita 0
} finally {
    $env:CLAUDE_PROJECT_DIR = $antes
}

if ($falhas.Count -gt 0) {
    if ($Silencioso) { $falhas | ForEach-Object { $_ } }
    else { "FALHAS: $($falhas.Count)" }
    exit 1
}
if (-not $Silencioso) { 'FALHAS: 0' }
exit 0
