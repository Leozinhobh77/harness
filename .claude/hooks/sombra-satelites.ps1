<#
  SOMBRA DOS SATELITES (SessionStart + PreToolUse) - fotografa as skills-atalho.

  Satelite = skill-atalho que mora FORA deste repo e manda ler arquivo daqui
  de dentro (menu-harness, manual-harness). Um SKILL.md cada, mais nada.

  PROCEDENCIA (14/08/2026): os satelites eram o unico pedaco do sistema sem
  volta - sem git, sem sombra, sem historico. E nao sao intocados: na v1.9.0 o
  menu-harness foi EDITADO (referencias mortas do abate da v1.8.0, P015). Uma
  edicao errada ali nao tinha como desfazer - o /rewind nao alcanca arquivo
  reescrito por comando, e git nao existe la.

  POR QUE ESTE ARQUIVO, e nao mais um trecho no sombra.ps1 ao lado:
  aquele e copia BYTE-IDENTICA de templates/comum/ - o mesmo hook que vai para
  TODO projeto do usuario. "Fotografar as pastas irmas" num projeto qualquer
  seria fotografar o Desktop inteiro. O comportamento e desta skill, entao
  mora so nesta skill.

  POR QUE O HOOK MORA AQUI, e nao dentro do satelite: hook so dispara na
  sessao aberta NAQUELA pasta, e ninguem abre sessao no menu-harness. Satelite
  e sempre editado a partir de uma sessao desta skill - entao e esta sessao
  que precisa fotografa-lo.

  QUANDO FOTOGRAFA
    SessionStart ................. todos os satelites (linha de base)
    Write/Edit dentro de um ...... aquele satelite
    Bash destrutivo que cita ..... o(s) satelite(s) citado(s)

  CONTRATO: este hook NUNCA bloqueia. Sai 0 em qualquer situacao, inclusive
  erro. Rede de seguranca que trava o trabalho e desligada na primeira semana.

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

    $evento = [string]$ev.hook_event_name
    $tool   = [string]$ev.tool_name
    $cmd    = ''
    if ($ev.tool_input -and $ev.tool_input.command) { $cmd = [string]$ev.tool_input.command }
    $alvo = ''
    if ($ev.tool_input) {
        if ($ev.tool_input.file_path)          { $alvo = [string]$ev.tool_input.file_path }
        elseif ($ev.tool_input.notebook_path)  { $alvo = [string]$ev.tool_input.notebook_path }
    }

    # Padroes que MEXEM NO DISCO de um jeito que o /rewind nao desfaz. Mesma
    # lista do sombra.ps1 ao lado. Calculado aqui em cima porque tambem serve
    # de porta de entrada para o caso do shell.
    $destrutivo = @(
        '\brm\b', '\brmdir\b', '\bdel\b', '\bmv\b', '\bcp\b', '\btruncate\b',
        '\bsed\b[^\n]*-i', '\bmkfs\b', '\bformat\b',
        'Remove-Item', 'Move-Item', 'Rename-Item', 'Set-Content', 'Out-File', 'Clear-Content',
        'git\s+(checkout|restore|reset|clean|stash|revert|rebase|merge)',
        '(npm|pnpm|yarn|bun)\s+(install|ci|add|remove|update|prune)',
        'pip\s+(install|uninstall)',
        '>\s*[^\s>|&]'
    )
    $bateDestrutivo = $false
    if ($cmd) { foreach ($p in $destrutivo) { if ($cmd -match $p) { $bateDestrutivo = $true; break } } }

    # ---------- porta barata ----------
    # A chamada comum - que e a esmagadora maioria - precisa custar uma
    # comparacao de string, e nao varredura de disco. Hook caro tambem e hook
    # desligado.
    #
    # NAO se filtra o comando de shell por caminho aqui: comando destrutivo e
    # raro e a varredura sai barata, enquanto exigir que ele CITE a pasta das
    # skills perde o caso relativo ("cd menu-harness; ..."). Achado no teste
    # do proprio hook: a porta pedia barra ANTES de "skills", e um simples
    # "cp -r skills/sat-falso" passava batido. 14/08/2026.
    $vale = $false
    if     ($evento -eq 'SessionStart')                  { $vale = $true }
    elseif ($tool -match '^(Write|Edit|NotebookEdit)$')  { $vale = ($alvo -match '(?i)skills[\\/]') }
    elseif ($tool -eq 'Bash' -or $tool -eq 'PowerShell') { $vale = $bateDestrutivo }
    if (-not $vale) { exit 0 }

    # ---------- quem e satelite ----------
    # MESMA REGRA do check 6 do doctor (scripts/doctor.ps1): pasta irma, com
    # SKILL.md, que cita ~/.claude/skills/harness/<algo>. Regra unica de
    # proposito - "satelite" querendo dizer duas coisas em dois lugares e a
    # duplicata que apodrece sem ninguem ver (P015). Descoberta dinamica pelo
    # mesmo motivo: lista fixa para de guardar em silencio (P012).
    # CUIDADO com a forma do caminho: o Windows tem duas para a mesma pasta -
    # a longa (C:\Users\Usuario\...) e a curta 8.3 (C:\Users\USURIO~2\...). O
    # Get-ChildItem devolve sempre a longa, mas CLAUDE_PROJECT_DIR e o
    # file_path da ferramenta podem chegar na curta. Comparar as duas como
    # texto da FALSO em pasta identica. Canoniza pelo Get-Item, que resolve as
    # duas para a mesma forma. (Achado no teste do proprio hook, 14/08/2026.)
    $dirSkills = Split-Path $raiz -Parent
    $raizCanon = $raiz
    try { $raizCanon = (Get-Item -LiteralPath $raiz -ErrorAction Stop).FullName.TrimEnd('\') } catch { }

    $satelites = New-Object System.Collections.Generic.List[string]
    foreach ($d in (Get-ChildItem -LiteralPath $dirSkills -Directory -ErrorAction SilentlyContinue)) {
        $caminho = $d.FullName.TrimEnd('\')
        if ($caminho -eq $raizCanon) { continue }
        $md = Join-Path $caminho 'SKILL.md'
        if (-not (Test-Path -LiteralPath $md)) { continue }
        $txt = Get-Content -LiteralPath $md -Raw -Encoding UTF8
        if ($txt -match '~/\.claude/skills/harness/[A-Za-z0-9_\-./]+') { $satelites.Add($caminho) }
    }
    if ($satelites.Count -eq 0) { exit 0 }

    # ---------- decide quem fotografar, e com que motivo ----------
    $alvos  = @()
    $motivo = ''

    if ($evento -eq 'SessionStart') {
        $alvos  = $satelites.ToArray()
        $motivo = 'inicio da sessao'
    }
    elseif ($tool -match '^(Write|Edit|NotebookEdit)$') {
        $nome = ''
        if ($alvo) { $nome = Split-Path $alvo -Leaf }
        if (-not $nome) { $nome = 'arquivo' }
        $motivo = "antes de editar $nome"
        # Casa pelo NOME da pasta do satelite, nao por prefixo de caminho: o
        # nome e o unico pedaco identico nas duas formas do Windows (curta e
        # longa) e tambem no caminho com ~. Generoso de proposito - um arquivo
        # noutra pasta de mesmo nome so provoca uma foto a mais, e foto sem
        # mudanca nao vira commit. Foto que faltou custa o trabalho do dia.
        foreach ($s in $satelites) {
            $nomeSat = Split-Path $s -Leaf
            if ($alvo -match ('(?i)[\\/]' + [regex]::Escape($nomeSat) + '([\\/]|$)')) { $alvos += $s }
        }
    }
    elseif ($bateDestrutivo) {
        $curto = $cmd -replace '\s+', ' '
        if ($curto.Length -gt 60) { $curto = $curto.Substring(0, 60) + '...' }
        $motivo = "antes de: $curto"
        # Aqui basta CITAR o nome do satelite, sem exigir barra em volta: no
        # texto de um comando ele aparece de toda forma imaginavel.
        foreach ($s in $satelites) {
            $nomeSat = Split-Path $s -Leaf
            if ($cmd -match [regex]::Escape($nomeSat)) { $alvos += $s }
        }
    }

    if (-not $motivo) { exit 0 }
    if ($alvos.Count -eq 0) { exit 0 }

    # ---------- fotografa cada alvo ----------
    # Um satelite quebrado nao pode impedir a foto do outro: cada um no seu
    # try. Sem debounce de proposito - so chegamos aqui quando o satelite e o
    # alvo, e "nada mudou = nada a fotografar" ja segura o historico limpo.
    foreach ($sat in $alvos) {
        try {
            $dirH = Join-Path $sat '.harness'
            if (-not (Test-Path -LiteralPath $dirH)) {
                New-Item -ItemType Directory -Force -Path $dirH | Out-Null
            }
            $sombra = Join-Path $dirH 'sombra.git'

            $gitBase = @(
                '--git-dir',   $sombra,
                '--work-tree', $sat,
                '-c', 'user.name=harness-sombra',
                '-c', 'user.email=sombra@harness.local',
                '-c', 'core.autocrlf=false',
                '-c', 'core.safecrlf=false',
                '-c', 'core.fileMode=false'
            )

            if (-not (Test-Path -LiteralPath (Join-Path $sombra 'HEAD'))) {
                $null = & git init --bare --quiet "$sombra" 2>$null
                if (-not (Test-Path -LiteralPath (Join-Path $sombra 'HEAD'))) { continue }
                $info = Join-Path $sombra 'info'
                if (-not (Test-Path -LiteralPath $info)) {
                    New-Item -ItemType Directory -Force -Path $info | Out-Null
                }
                $exclusoes = @('/.git/', '/.harness/sombra.git/', 'node_modules/', 'Thumbs.db', '.DS_Store')
                Set-Content -Path (Join-Path $info 'exclude') -Value $exclusoes -Encoding ASCII
            }

            $null = & git @($gitBase + @('add', '-A')) 2>$null
            $pendente = & git @($gitBase + @('status', '--porcelain')) 2>$null
            $temHead  = & git @($gitBase + @('rev-parse', '--verify', 'HEAD')) 2>$null
            if (-not $pendente -and $temHead) { continue }

            $null = & git @($gitBase + @('commit', '--quiet', '-m', $motivo)) 2>$null
        } catch { }
    }

    exit 0
} catch {
    exit 0   # FAIL-OPEN, sempre.
}
