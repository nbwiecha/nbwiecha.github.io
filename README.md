# nbwiecha.github.io
Personal webpage for Dr. Nate Wiecha

## Updating the site

Sources live in the repo root (`*.qmd`, `styles.css`, `Wiecha_CV.pdf`, ...).
Quarto renders them into `docs/`, which GitHub Pages serves. Linked files such
as the CV PDF are copied into `docs/` automatically. Don't edit `docs/` by hand.

1. Edit the `.qmd` pages, or drop a replacement file (e.g. a new `Wiecha_CV.pdf`) into the root.
2. Render and preview: `.\publish.ps1`
3. Publish: `.\publish.ps1 -Push -Message "what changed"`

If PowerShell blocks the script, run
`powershell -ExecutionPolicy Bypass -File .\publish.ps1` instead.
