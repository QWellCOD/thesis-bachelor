# Builds build/main-diff.pdf with all changes since the given Git revision marked up.
param([string]$Revision = 'HEAD')

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$old = Join-Path ([IO.Path]::GetTempPath()) "thesis-latexdiff-$PID"
New-Item -ItemType Directory -Path $old | Out-Null
try {
    git archive --format=zip -o "$old\rev.zip" $Revision
    if ($LASTEXITCODE) { throw "Unknown Git revision '$Revision'." }
    Expand-Archive -Path "$old\rev.zip" -DestinationPath $old

    # cmd redirection keeps latexdiff's UTF-8 output (PowerShell 5.1 '>' would write UTF-16).
    # minted is treated as verbatim: markup inside code blocks would be printed literally.
    cmd /c "latexdiff --flatten --config=""VERBATIMENV=(?:comment|minted)"" ""$old\main.tex"" main.tex > main-diff.tex"
    if ($LASTEXITCODE) { throw 'latexdiff failed.' }

    latexmk main-diff.tex
    if ($LASTEXITCODE) { throw 'Build failed, see build/main-diff.log.' }
    Write-Host "Done: build/main-diff.pdf (changes since $Revision)"
}
finally {
    Remove-Item -Recurse -Force $old
}
