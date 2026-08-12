<#
  SOMBRA (SessionStart + PreToolUse) - fotografa o projeto antes do risco.

  A quarta guarda. As outras tres impedem erro; esta aceita que um dia um erro
  passa, e garante que da para voltar.

  POR QUE (procedencia - excecao de seguranca de dado da Lei 1):
  o /rewind nativo do Claude Code so desfaz o que as ferramentas de EDICAO
  fizeram. Arquivo apagado ou sobrescrito por comando de shell nao volta por
  ele. Este hook cobre exatamente esse buraco.

  QUANDO TIRA FOTO
    SessionStart .................... linha de base do dia
    PreToolUse Write|Edit|Notebook .. com pausa de 90s entre fotos
    PreToolUse Bash DESTRUTIVO ...... sempre, sem pausa   <-- o que importa

  CONTRATO: este hook NUNCA bloqueia. Sai 0 em qualquer situacao, inclusive
  erro. Uma rede de seguranca que trava o trabalho e desligada pelo usuario na
  primeira semana - e ai nao protege mais nada.

  AUTOCONTIDO de proposito: nao chama a skill. Se o /harness for desinstalado,
  o projeto continua sendo fotografado. Ler e restaurar e que precisam da skill
  (/harness voltar).

  ASCII puro (armadura ps1-check).
#>
$ErrorActionPreference = 'SilentlyContinue'

try {
    try { [Console]::InputEncoding = [System.Text.Encoding]::UTF8 } catch { }
    $bruto = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($bruto)) { exit 0 }
    $ev = $bruto | ConvertFrom-Json

    $raiz = $env:CLAUDE_PROJECT_DIR
    if (-not $raiz) { $raiz = (Get-Location).Path }
    try { $raiz = (Resolve-Path -LiteralPath $raiz).Path } catch { }
    $raiz = $raiz.TrimEnd('\', '/')

    $dirHarness = Join-Path $raiz '.harness'
    if (-not (Test-Path -LiteralPath $dirHarness)) { exit 0 }
    $sombra = Join-Path $dirHarness 'sombra.git'
    $marca  = Join-Path $dirHarness '.sombra-ultima'

    $evento = [string]$ev.hook_event_name
    $tool   = [string]$ev.tool_name
    $cmd    = ''
    if ($ev.tool_input -and $ev.tool_input.command) { $cmd = [string]$ev.tool_input.command }
    $alvo = ''
    if ($ev.tool_input) {
        if ($ev.tool_input.file_path)          { $alvo = [string]$ev.tool_input.file_path }
        elseif ($ev.tool_input.notebook_path)  { $alvo = [string]$ev.tool_input.notebook_path }
    }

    # ---------- decide se tira foto, e com que motivo ----------
    $motivo   = ''
    $comPausa = $true

    if ($evento -eq 'SessionStart') {
        $motivo   = 'inicio da sessao'
        $comPausa = $false

        # ESTADO.md e derivado, e vivia desatualizado: o doctor acusava, ninguem
        # rodava o fix, e o alarme virava paisagem (2 de 3 projetos - evolve
        # v1.7.0). Lei 2: se da para ser mecanico, nao fica sendo pedido.
        # Roda ANTES da foto, para a foto ja pegar o arquivo em dia.
        #
        # BEST-EFFORT de proposito: o gerador mora na skill, e este hook e
        # autocontido. Sem a skill instalada, pula em silencio - a FOTO, que e
        # o que realmente importa aqui, nao depende disto.
        try {
            $gerador = Join-Path $env:USERPROFILE '.claude\skills\harness\scripts\estado.ps1'
            if ((Test-Path -LiteralPath $gerador) -and
                (Test-Path -LiteralPath (Join-Path $raiz 'ESTADO.md'))) {
                $null = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $gerador -Projeto $raiz 2>$null
            }
        } catch { }
    }
    elseif ($tool -match '^(Write|Edit|NotebookEdit)$') {
        $nome = $alvo
        if ($alvo) { $nome = Split-Path $alvo -Leaf }
        if (-not $nome) { $nome = 'arquivo' }
        $motivo = "antes de editar $nome"
    }
    elseif ($tool -eq 'Bash' -or $tool -eq 'PowerShell') {
        # Padroes que MEXEM NO DISCO de um jeito que o /rewind nao desfaz.
        # Generoso de proposito: foto sem mudanca nao vira commit (custa ~nada),
        # mas foto que faltou custa o trabalho do dia.
        $destrutivo = @(
            '\brm\b', '\brmdir\b', '\bdel\b', '\bmv\b', '\bcp\b', '\btruncate\b',
            '\bsed\b[^\n]*-i', '\bmkfs\b', '\bformat\b',
            'Remove-Item', 'Move-Item', 'Rename-Item', 'Set-Content', 'Out-File', 'Clear-Content',
            'git\s+(checkout|restore|reset|clean|stash|revert|rebase|merge)',
            '(npm|pnpm|yarn|bun)\s+(install|ci|add|remove|update|prune)',
            'pip\s+(install|uninstall)',
            '>\s*[^\s>|&]'
        )
        $bate = $false
        foreach ($p in $destrutivo) { if ($cmd -match $p) { $bate = $true; break } }
        if ($bate) {
            $curto = $cmd -replace '\s+', ' '
            if ($curto.Length -gt 60) { $curto = $curto.Substring(0, 60) + '...' }
            $motivo   = "antes de: $curto"
            $comPausa = $false
        }
    }

    if (-not $motivo) { exit 0 }

    # ---------- pausa (debounce) ----------
    # So vale para edicao de arquivo. Comando destrutivo e inicio de sessao
    # SEMPRE fotografam - e justamente ali que a foto precisa existir.
    if ($comPausa -and (Test-Path -LiteralPath $marca)) {
        $idade = (Get-Date) - (Get-Item -LiteralPath $marca).LastWriteTime
        if ($idade.TotalSeconds -lt 90) { exit 0 }
    }

    # ---------- git da sombra ----------
    $gitBase = @(
        '--git-dir',   $sombra,
        '--work-tree', $raiz,
        '-c', 'user.name=harness-sombra',
        '-c', 'user.email=sombra@harness.local',
        '-c', 'core.autocrlf=false',
        '-c', 'core.safecrlf=false',
        '-c', 'core.fileMode=false'
    )

    # Primeira vez: cria o repo bare e a lista de exclusoes.
    if (-not (Test-Path -LiteralPath (Join-Path $sombra 'HEAD'))) {
        $null = & git init --bare --quiet "$sombra" 2>$null
        if (-not (Test-Path -LiteralPath (Join-Path $sombra 'HEAD'))) { exit 0 }
        $info = Join-Path $sombra 'info'
        if (-not (Test-Path -LiteralPath $info)) {
            New-Item -ItemType Directory -Force -Path $info | Out-Null
        }
        $exclusoes = @(
            '/.git/', '/.harness/sombra.git/', 'node_modules/', '.venv/', 'venv/',
            '__pycache__/', '*.pyc', '.pytest_cache/', '.gradle/', 'Thumbs.db', '.DS_Store'
        )
        Set-Content -Path (Join-Path $info 'exclude') -Value $exclusoes -Encoding ASCII
    }

    $null = & git @($gitBase + @('add', '-A')) 2>$null
    $pendente = & git @($gitBase + @('status', '--porcelain')) 2>$null
    $temHead  = & git @($gitBase + @('rev-parse', '--verify', 'HEAD')) 2>$null

    # Nada mudou no disco = nada a fotografar. Nao se enche o historico de
    # foto identica: isso enterra a foto util no meio do ruido.
    if (-not $pendente -and $temHead) {
        Set-Content -Path $marca -Value (Get-Date -Format 'o') -Encoding ASCII
        exit 0
    }

    $null = & git @($gitBase + @('commit', '--quiet', '-m', $motivo)) 2>$null
    Set-Content -Path $marca -Value (Get-Date -Format 'o') -Encoding ASCII

    # Registra no mesmo log das outras guardas - e esse log que o /harness
    # doctor usa para saber se as guardas estao vivas.
    try {
        $reg = [pscustomobject]@{
            data    = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
            guarda  = 'sombra'
            acao    = 'fotografou'
            detalhe = $motivo
        } | ConvertTo-Json -Compress
        Add-Content -Path (Join-Path $dirHarness 'log-guardas.jsonl') -Value $reg -Encoding UTF8
    } catch { }

    exit 0
} catch {
    exit 0   # FAIL-OPEN, sempre. Rede de seguranca nunca atrapalha o trabalho.
}
