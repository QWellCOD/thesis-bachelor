# AGENTS.md

Guidance for AI agents working on this repository: the bachelor thesis
"KI-gestützte Ursachenanalyse für Cloud-Dienste bei Bosch eBike Systems"
(Hochschule Reutlingen, Fakultät Informatik, B.Sc. Wirtschaftsinformatik).

## Ground Rules

- Thesis text is **German**. Code comments, config comments and commit messages are **English**.
- **Never edit `references.bib`.** It is a Zotero Better BibTeX auto-export (read-only in VS Code); manual changes are overwritten. If a source is missing, ask the user to add it in Zotero.
- **Never invent sources**, citation keys, page numbers or quotes. Only cite keys that exist in `references.bib`.
- Never edit files in `build/` (generated).
- Do not change the package load order, fonts or type area in `hsrt-thesis.cls` unless asked (see [Class Changes](#class-and-package-changes)).
- If AI contributes to thesis content, remind the user to document it in `chapters/ki-hilfsmittel.tex` (required by the university's declaration form).
- Commit or push only when asked.

## Repository Layout

```
main.tex               Entry point: metadata (\title, \author, \examiners, ...) and \include list
hsrt-thesis.cls        Document class: KOMA scrbook, fonts, layout, all packages, title page
acronyms.tex           \newacronym definitions (Abkürzungsverzeichnis)
references.bib         Bibliography, Zotero auto-export (read-only)
chapters/              One file per chapter: 01-einleitung ... 08-fazit-ausblick,
                       abstract, anhang-a (appendix), ki-hilfsmittel (AI usage table)
figures/               Images used in the thesis
code/                  Source files for listings (\inputminted)
assets/                Logos, official declaration form (Eigenstaendigkeitserklaerung.pdf,
                       replaced later by the signed version)
scripts/latexdiff.ps1  Builds build/main-diff.pdf with changes since a Git revision
.latexmkrc             All build options (engine, out_dir, biber, makeglossaries)
latexindent.yaml       Formatter settings (LaTeX Workshop formats on save)
.githooks/             Git LFS hooks + pre-commit guard against plain files > 10 MB
.vscode/               LaTeX Workshop recipe, LTeX+ (de-DE) config, latexdiff task
requirements.txt       Python package latexminted (needed by minted 3 on MiKTeX)
build/                 Generated output: main.pdf, aux files, minted cache (git-ignored)
```

## Toolchain

- Windows, PowerShell 5.1, MiKTeX (pdfLaTeX), latexmk via Strawberry Perl
- biblatex with biber, `style=apa`
- glossaries-extra (acronyms only), `makeglossaries` is run by latexmk
- minted 3: requires `-shell-escape` (set in `.latexmkrc`) and Python package `latexminted`
- Git LFS for all binary files (`.gitattributes`)

Not used: Tectonic, XeLaTeX/LuaLaTeX, Make, Docker, CI.

## Build and Verify

```powershell
latexmk        # main.tex -> build/main.pdf, all options from .latexmkrc
latexmk -c     # remove auxiliary files
```

- Full build takes about 1 minute, a rebuild after a small edit about 12 s.
- **LaTeX Workshop auto-builds on every file change.** A parallel `latexmk` run in the workspace corrupts `build/`. To verify changes, build in a temporary copy:

  ```powershell
  $t = Join-Path $env:TEMP 'thesis-build'; robocopy . $t /MIR /XD build .git | Out-Null; Push-Location $t; latexmk; Pop-Location
  ```

- Errors are in `build/main.log` (format `file:line: message`). Undefined reference/citation warnings after adding new ones disappear after the next run.
- Mark changes for review: `scripts/latexdiff.ps1 <revision>` (default `HEAD`) or the VS Code task "latexdiff: mark changes since a Git revision" -> `build/main-diff.pdf`.

## Writing Conventions

### Structure

- New chapter: create `chapters/NN-name.tex` and add `\include{chapters/NN-name}` to `main.tex`. Template:

  ```latex
  % !TeX root = ../main.tex
  \chapter{Titel}
  \label{chap:name}
  ```

- Unnumbered chapters use `\addchap`. Numbering and TOC go down to `\subsection`; avoid `\subsubsection`.
- `\includeonly{...}` in `main.tex` speeds up builds while writing; do not leave it active in commits.

### References, Citations, Acronyms

- Label prefixes: `chap:`, `sec:`, `fig:`, `tab:`, `lst:`. Reference with `\cref{}` / `\Cref{}` (cleveref, German names).
- APA citations: `\textcite{key}` in running text, `\parencite[S.~12]{key}` in parentheses.
- Quotes: `\enquote{...}` (csquotes), no literal quote characters.
- Acronyms: define in `acronyms.tex` with `\newacronym{key}{SHORT}{Long form}`, use `\gls{key}` / `\glspl{key}`. The first use prints the long form; only used entries appear in the list.
- German typography: `z.\,B.`, `d.\,h.`, `S.~12`, `Abschnitt~\ref{...}`.

### Figures, Tables, Listings

- Images go in `figures/`. Use PDF for vector graphics; **SVG is not supported** (convert to PDF). `\includegraphics{figures/name}`.
- Captions: below figures, above tables and listings (set by the class).
- Tables: `tabularx` is available; lining tabular figures are applied automatically.
- Listings: put source files in `code/` and wrap them in the `listing` float. Style (line numbers, frame, Exposé colors) is global via `\setminted`; do not override it per listing.

  ```latex
  \begin{listing}[htbp]
    \caption{Beschreibung}
    \label{lst:name}
    \inputminted{python}{code/example.py}
  \end{listing}
  ```

### Formatting

- UTF-8, LF line endings, 2-space indentation (`.editorconfig`, `.gitattributes eol=lf`). Files created by tools on Windows may get CRLF; convert them to LF.
- LaTeX files are formatted by latexindent on save; keep edits compatible with that.
- Every chapter file starts with `% !TeX root = ../main.tex`.

## Class and Package Changes

- All packages go into `hsrt-thesis.cls` via `\RequirePackage`. `main.tex` holds only metadata and structure. The class takes no options.
- Load order: minted before csquotes; hyperref -> glossaries-extra -> cleveref (last).
- minted must use the `float` package (current setup), not `newfloat`: otherwise KOMA tocbasic and latexdiff's listings both register `.lol` and the diff build fails.
- Exposé listing colors are applied via `\appto\minted@patch@PygmentsStyledef`; keep this hook when changing minted settings.
- Fonts (Libertine, Noto Sans, Inconsolata scaled to matching x-heights; newtxmath operators set to lining figures) and `\KOMAoptions{DIV=calc}` after font loading define the type area. Changing fonts changes the layout.

## Pitfalls

- `latexdiff-vc --flatten` does not work on Windows; use `scripts/latexdiff.ps1`. minted must stay a `VERBATIMENV` (`VERBATIMLINEENV` breaks the build). Deleting a minted block inside a float breaks the diff build.
- PowerShell 5.1 `>` writes UTF-16 and `Set-Content -Encoding UTF8` writes a BOM. For UTF-8 output, use `cmd /c "... > file"` or .NET methods.
- The project depends on pdfLaTeX + shell escape. Do not switch engines or remove `-shell-escape`.

## Git

- Commit messages follow [.github/commit-instructions.md](.github/commit-instructions.md): Conventional Commits `type(scope): subject`, English, max. 72 characters per line. Scope = chapter file name without number (e.g. `grundlagen`) or `class`, `bib`, `latexmk`, ... Thesis text is content (`feat`/`fix`/`refactor`/`chore`), never `docs`.
- Commits with AI contributions get the trailer `AI-assisted: <tool> (<purpose>)`.
- Every commit should build; tag versions handed to the examiners (`v1`, `v2`, ...) for latexdiff.
- Once per clone: `git config core.hooksPath .githooks` (activates the Git LFS hooks and the 10 MB guard).
- New binary file types: `git lfs track "*.ext"` and commit `.gitattributes` together with the file.
