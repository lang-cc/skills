param(
    [switch]$Commit,
    [switch]$Push
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $repoRoot 'manifest.json'
$agentsRoot = Split-Path -Parent $repoRoot
$sourceReferences = Join-Path $agentsRoot 'references'
$sourceLock = Join-Path $agentsRoot '.skill-lock.json'
$repoReferences = Join-Path $repoRoot 'references'
$repoLock = Join-Path $repoRoot 'skill-lock.json'

$actualNames = @(Get-ChildItem -LiteralPath $repoRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf } |
    Select-Object -ExpandProperty Name |
    Sort-Object)

if ($actualNames.Count -eq 0) {
    throw "No installed skills found in $repoRoot"
}

$manifest = [ordered]@{
    version = 1
    skills  = $actualNames
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding utf8

if (Test-Path -LiteralPath $sourceReferences -PathType Container) {
    New-Item -ItemType Directory -Path $repoReferences -Force | Out-Null
    & robocopy $sourceReferences $repoReferences /MIR /COPY:DAT /DCOPY:T /R:1 /W:1 /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy failed with exit code $LASTEXITCODE"
    }
}

if (Test-Path -LiteralPath $sourceLock -PathType Leaf) {
    Copy-Item -LiteralPath $sourceLock -Destination $repoLock -Force
}

Write-Host "Backed up $($actualNames.Count) skills from $repoRoot"

if ($Push) {
    $Commit = $true
}

if ($Commit) {
    & git -C $repoRoot rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "$repoRoot is not a Git repository"
    }

    if (-not (git -C $repoRoot status --porcelain)) {
        Write-Host 'No changes to commit.'
    }
    else {
        & git -C $repoRoot add --all
        if ($LASTEXITCODE -ne 0) {
            throw 'git add failed'
        }

        $message = "Backup skills $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        & git -C $repoRoot commit -m $message
        if ($LASTEXITCODE -ne 0) {
            throw 'git commit failed'
        }
    }
}

if ($Push) {
    & git -C $repoRoot remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) {
        throw 'No origin remote is configured'
    }

    & git -C $repoRoot push -u origin HEAD
    if ($LASTEXITCODE -ne 0) {
        throw 'git push failed'
    }
}
