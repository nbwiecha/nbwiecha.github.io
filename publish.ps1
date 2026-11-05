<#
.SYNOPSIS
  Render the Quarto site into docs/ and (optionally) commit + push it.

.DESCRIPTION
  GitHub Pages serves this site from the docs/ folder on main. Quarto renders
  every .qmd into docs/ and copies any file a page links to (PDFs, images)
  along with it, so there is no manual copying: edit the sources in the repo
  root, run this script, check the preview, then push.

.EXAMPLE
  .\publish.ps1                      # render + open preview in browser
  .\publish.ps1 -Push -Message "Update CV"   # render, commit everything, push
#>
param(
  [switch]$Push,
  [string]$Message = "Update site",
  [switch]$NoPreview
)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Find quarto: PATH first, then the copies bundled with Positron / RStudio.
$quarto = (Get-Command quarto -ErrorAction SilentlyContinue).Source
if (-not $quarto) {
  $candidates = @(
    "$env:LOCALAPPDATA\Programs\Positron\resources\app\quarto\bin\quarto.exe",
    "$env:ProgramFiles\Quarto\bin\quarto.exe",
    "$env:ProgramFiles\RStudio\resources\app\bin\quarto\bin\quarto.exe"
  )
  $quarto = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $quarto) { throw "Quarto not found. Install it from https://quarto.org or via Positron/RStudio." }

Write-Host "Rendering with $quarto" -ForegroundColor Cyan
& $quarto render
if ($LASTEXITCODE -ne 0) { throw "quarto render failed" }

Write-Host "`nChanges:" -ForegroundColor Cyan
git status --short

if (-not $NoPreview -and -not $Push) { Start-Process (Join-Path $PSScriptRoot "docs\index.html") }

if ($Push) {
  git add -A
  git diff --cached --quiet
  if ($LASTEXITCODE -eq 0) { Write-Host "Nothing to commit." ; exit 0 }
  git commit -m $Message
  git push
  Write-Host "`nPushed. GitHub Pages usually updates within a minute or two." -ForegroundColor Green
}
