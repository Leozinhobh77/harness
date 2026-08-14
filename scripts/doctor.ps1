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
    [string]$Projeto,
    # Auto-exame: examina a PROPRIA skill em vez de um projeto.
    # A etapa 6 do evolve manda rodar isto desde a v1.6.0, e ate a v1.8.0 o
    # parametro nao existia - a instrucao mandava rodar um comando inexistente.
    # Achado executando o proprio ritual do evolve em 13/08/2026.
    [switch]$Skill,
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

# =====================================================================
#  AUTO-EXAME  (-Skill)
#  A skill e um harness. Ela tem que passar no proprio exame - senao
#  prega orcamento sendo obesa.
# =====================================================================
if ($Skill) {
    $raizSkill = Split-Path $PSScriptRoot -Parent

    # 1. Os scripts compilam?
    foreach ($s in (Get-ChildItem (Join-Path $raizSkill 'scripts') -Filter *.ps1)) {
        $errs = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($s.FullName, [ref]$null, [ref]$errs)
        if ($errs -and $errs.Count -gt 0) {
            Add-Achado 'VERMELHO' 'Mecanica' "scripts/$($s.Name) tem $($errs.Count) erro(s) de sintaxe" 'corrigir antes de qualquer outra coisa'
        }
        # ASCII puro: acento em .ps1 quebra no console do Windows (P001).
        $naoAscii = @([IO.File]::ReadAllBytes($s.FullName) | Where-Object { $_ -gt 127 }).Count
        if ($naoAscii -gt 0) {
            Add-Achado 'AMARELO' 'Mecanica' "scripts/$($s.Name) tem $naoAscii byte(s) nao-ASCII" 'mover texto acentuado para .md'
        }
    }

    # 2. Toda rota do SKILL.md tem arquivo? Todo arquivo esta roteado?
    $skillMd = Join-Path $raizSkill 'SKILL.md'
    $rotas = @()
    if (Test-Path $skillMd) {
        $rotas = ([regex]::Matches((Get-Content $skillMd -Raw -Encoding UTF8), 'comandos/([a-z]+)\.md') |
                  ForEach-Object { $_.Groups[1].Value }) | Sort-Object -Unique
        foreach ($r in $rotas) {
            if (-not (Test-Path (Join-Path $raizSkill "comandos\$r.md"))) {
                Add-Achado 'VERMELHO' 'Deriva' "SKILL.md roteia para comandos/$r.md, que nao existe" 'criar o arquivo ou tirar a rota'
            }
        }
    } else {
        Add-Achado 'VERMELHO' 'Estrutura' 'SKILL.md nao existe' ''
    }
    foreach ($c in (Get-ChildItem (Join-Path $raizSkill 'comandos') -Filter *.md -ErrorAction SilentlyContinue)) {
        if ($rotas -notcontains $c.BaseName) {
            Add-Achado 'AMARELO' 'Deriva' "comandos/$($c.Name) existe mas nenhuma rota do SKILL.md aponta para ele" 'rotear ou abater (Lei 4)'
        }
    }

    # 3. Orcamento dos documentos que a skill carrega sempre.
    #    O SKILL.md nao tem teto de linha: o que se cobra dele e o PAPEL
    #    (so rotear). Instrucao de comando mora em comandos/.
    foreach ($par in @(@('CONSTITUICAO.md', 140), @('criterios\TIERS.md', 160), @('criterios\ORCAMENTOS.md', 110))) {
        $arq = Join-Path $raizSkill $par[0]
        if (-not (Test-Path $arq)) { continue }
        $n = @(Get-Content $arq -Encoding UTF8).Count
        if ($n -gt ([int]$par[1] * 1.2)) {
            Add-Achado 'AMARELO' 'Orcamento' "$($par[0]) com $n linhas (teto $($par[1]) + 20%)" 'mover profundidade e deixar ponteiro'
        }
    }

    # 4. Os templates que todo projeto herda estao sadios?
    $gitignoreT2 = Join-Path $raizSkill 'templates\T2-padrao\.gitignore'
    if (Test-Path $gitignoreT2) {
        $g = Get-Content $gitignoreT2 -Raw -Encoding UTF8
        # Regra que engole o proprio modelo: `.env.*` casa com `.env.example`.
        if ($g -match '(?m)^\.env\.\*' -and $g -notmatch '(?m)^!\.env\.example') {
            Add-Achado 'VERMELHO' 'Template' 'o .gitignore do T2 tem `.env.*` sem a excecao `!.env.example` - o modelo de variaveis nunca seria versionado' 'acrescentar !.env.example'
        }
    }

    # 5. Guardas do template sem procedencia (Lei 1 aplicada a si mesma).
    $guardas = Join-Path $raizSkill 'templates\T2-padrao\.harness\guardas.json'
    if (Test-Path $guardas) {
        try {
            $cfg = Get-Content $guardas -Raw -Encoding UTF8 | ConvertFrom-Json
            foreach ($g in @($cfg.arquivos_protegidos) + @($cfg.comandos_proibidos)) {
                if ($g -and -not $g.procedencia) {
                    Add-Achado 'VERMELHO' 'Procedencia' "guarda '$($g.nome)' do template nao tem procedencia (Lei 1)" 'registrar o caso real ou abater'
                }
            }
        } catch {
            Add-Achado 'VERMELHO' 'Mecanica' 'guardas.json do template nao e JSON valido' ''
        }
    }

    # 6. Os SATELITES apontam para coisa que ainda existe?
    #
    #    Satelite = skill-atalho que mora FORA deste repo (menu-harness,
    #    manual-harness) e manda ler arquivo daqui de dentro.
    #
    #    PROCEDENCIA: 14/08/2026. O menu-harness mandava ler
    #    memoria/uso.json e executar o passo "Registrar uso" - os dois
    #    abatidos na v1.8.0 (P013). O abate podou o comandos/menu.md e o
    #    SKILL.md, que sao daqui, e ninguem olhou o satelite. O Read falhou
    #    na frente do usuario ao abrir o menu.
    #
    #    POR QUE AQUI, e nao numa guarda nova: o check 2 acima ja e "rota
    #    aponta para arquivo que existe". Ele nao faltava - enxergava so o
    #    SKILL.md daqui. Escopo estreito, nao guarda ausente (learn.md,
    #    secao 2: se a guarda existia e nao pegou, conserte ELA).
    #
    #    DESCOBERTA DINAMICA de proposito: varre as pastas irmas em vez de
    #    ler uma lista fixa. Lista fixa apodrece e para de guardar sem
    #    ninguem perceber (P012), que e o mesmo erro um nivel acima.
    #
    #    So casa referencia QUALIFICADA (~/.claude/skills/harness/...), que
    #    e a forma de "manda ler X". Mencao em prosa a um caminho relativo
    #    nao dispara - e assim que se evita alarme falso em nota explicativa.
    $dirSkills = Split-Path $raizSkill -Parent
    foreach ($sat in (Get-ChildItem $dirSkills -Directory -ErrorAction SilentlyContinue)) {
        if ($sat.FullName -eq $raizSkill) { continue }
        $satMd = Join-Path $sat.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $satMd)) { continue }
        $txtSat = Get-Content $satMd -Raw -Encoding UTF8
        foreach ($m in [regex]::Matches($txtSat, '~/\.claude/skills/harness/([A-Za-z0-9_\-./]+)')) {
            $rel = $m.Groups[1].Value.TrimEnd('.', ',', ')')
            if (-not $rel) { continue }
            $alvoSat = Join-Path $raizSkill ($rel -replace '/', '\')
            if (-not (Test-Path -LiteralPath $alvoSat)) {
                Add-Achado 'VERMELHO' 'Integridade' "$($sat.Name)/SKILL.md manda ler $rel, que nao existe" 'corrigir o satelite ou recriar o alvo'
            }
        }
    }

    $vS = @($achados | Where-Object { $_.severidade -eq 'VERMELHO' })
    $aS = @($achados | Where-Object { $_.severidade -eq 'AMARELO'  })
    $zS = @($achados | Where-Object { $_.severidade -eq 'AZUL'     })
    $versaoS = 'desconhecida'
    try { $versaoS = (Get-Content (Join-Path $raizSkill 'VERSAO.json') -Raw | ConvertFrom-Json).versao } catch { }

    if ($Json) {
        [pscustomobject]@{
            alvo = 'skill'; versao = $versaoS
            totais = @{ vermelho=$vS.Count; amarelo=$aS.Count; azul=$zS.Count }
            achados = $achados
        } | ConvertTo-Json -Depth 6
        exit 0
    }

    Write-Output "DOCTOR (auto-exame) | a propria skill | v$versaoS"
    Write-Output "$($rotas.Count) rota(s) | $(@(Get-ChildItem (Join-Path $raizSkill 'scripts') -Filter *.ps1).Count) script(s)"
    Write-Output ''
    if ($achados.Count -eq 0) {
        Write-Output 'OK - a skill passa no proprio exame.'
    } else {
        foreach ($grupo in @(@('VERMELHO',$vS), @('AMARELO',$aS), @('AZUL',$zS))) {
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
    exit 0
}

if (-not $Projeto) { Write-Output 'ERRO: informe -Projeto <caminho> ou use -Skill'; exit 1 }
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
# ATENCAO: cada arquivo tem o SEU orcamento. Nunca some dois documentos
# diferentes para comparar com um teto - a medicao que embasa os limites e
# POR ARQUIVO. Somar e erro de categoria.
$sempreCarregados = @('AGENTS.md', 'CLAUDE.md', 'ESTADO.md')

# TOLERANCIA (ver criterios/ORCAMENTOS.md). O teto e a mira, nao a linha da
# morte: passar um pouco nao justifica cortar conteudo que presta. Alarme so
# quando o excesso e grande. Sem isto, o doctor reprovava por 5 linhas e o
# proximo assistente propunha mutilar documento bom para agradar um numero.
$tolerancia = 1.20

$totalLinhas = 0
foreach ($k in $orcamentos.Keys) {
    $fp = Join-Path $Projeto $k
    if (Test-Path $fp) {
        $n = @(Get-Content $fp -Encoding UTF8).Count
        if ($sempreCarregados -contains $k) { $totalLinhas += $n }
        $teto = $orcamentos[$k]
        if ($n -gt [math]::Ceiling($teto * $tolerancia)) {
            $pct = [math]::Round((($n / $teto) - 1) * 100)
            Add-Achado 'AMARELO' 'Inchaco' "$k tem $n linhas (teto $teto, ${pct}% acima)" '/harness fix'
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

# ============ F5 Mecanica: a sombra ============
# A sombra e rede de seguranca de DADO, entao vale para todo tier (inclusive
# T1) - mesma regra do .gitignore. Projeto sem ela nao tem como voltar de um
# comando destrutivo: o /rewind nativo do Claude Code nao desfaz o que o shell
# fez. Ver comandos/voltar.md.
$dirSombra = Join-Path $dirHarn 'sombra.git'
if (-not (Test-Path (Join-Path $dirSombra 'HEAD'))) {
    Add-Achado 'AMARELO' 'Mecanica' 'Sem sombra: nao ha como desfazer um comando destrutivo neste projeto' '/harness upgrade'
} else {
    $motorSombra = Join-Path $PSScriptRoot 'sombra.ps1'
    if (Test-Path $motorSombra) {
        try {
            $st = (& $motorSombra -Projeto $Projeto -Status -Json) -join "`n" | ConvertFrom-Json
            if ($st.fotos -eq 0) {
                Add-Achado 'AMARELO' 'Mecanica' 'Sombra existe mas nao tem nenhuma foto - o hook pode nao estar rodando' 'verificar .claude/settings.json'
            }
            # Sem teto, a rede de seguranca vira o inchaco que a Lei 4 combate.
            if ($st.tamanhoMB -gt 300) {
                Add-Achado 'AZUL' 'Mecanica' "Sombra ocupa $($st.tamanhoMB) MB" '/harness voltar --limpar'
            }
        } catch { }
    }
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
