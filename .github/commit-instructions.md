## Commit Messages

Follow the Conventional Commits standard, adapted to the corporate guidelines
and to this repository (a LaTeX bachelor thesis). Commit messages are
written in English, even though the thesis text is German.

### Structure

    type(scope): subject

    optional body

    optional trailers

- Every line must be at most 72 characters.
- Blank lines between subject, body and trailers are mandatory.
- Breaking change: add `!` after the type/scope and a
  `Breaking-Change: <reason>` trailer. Here this only applies to class
  changes that require edits in `main.tex` or the chapters (e.g. a
  renamed metadata macro).
- Automatically generated `Merge ...` and `Revert ...` subjects are exempt.

### Type (required)

Use exactly one of:

| Type       | Use for                                       | Examples in this repository                                                    |
|------------|-----------------------------------------------|--------------------------------------------------------------------------------|
| `feat`     | New or extended content or functionality      | New section, paragraph, figure, table, listing, acronym; new class feature     |
| `fix`      | Corrections that change meaning or output     | Wrong statement or value, wrong citation, broken reference, build or layout bug |
| `build`    | Build process and toolchain                   | `.latexmkrc`, `requirements.txt`, `scripts/latexdiff.ps1`                      |
| `ci`       | Repository infrastructure, no effect on PDF   | `.githooks/`, `.gitattributes`, `.vscode/`, `.editorconfig`, `latexindent.yaml` |
| `refactor` | Restructuring without changing content        | Move or split sections, rename labels or files, reorder chapters               |
| `docs`     | Repository documentation, **not** the thesis  | `AGENTS.md`, this file                                                         |
| `chore`    | Minor changes without impact on content       | Typos, wording polish, formatting, `.gitignore`, standalone Zotero export      |
| `revert`   | Reverting previous commits                    |                                                                                |

Thesis text is content: use `feat`, `fix`, `refactor` or `chore`, never
`docs`.

If several types apply, choose by this priority:
`feat` > `fix` > `build` > `ci` > `refactor` > `docs` > `chore`.
If a commit needs several types, it should probably be split.

### Scope (optional, recommended)

Use one of these scopes; omit the scope if a commit spans several areas.

- Chapters (file name without number): `abstract`, `einleitung`,
  `grundlagen`, `verwandte-arbeiten`, `anforderungsanalyse`,
  `konzeption`, `implementierung`, `evaluation`, `fazit-ausblick`,
  `anhang-a`, `ki-hilfsmittel`
- Thesis infrastructure: `main` (`main.tex`), `class` (`hsrt-thesis.cls`),
  `bib` (`references.bib`), `acronyms`, `figures`, `code`
- Tooling: `latexmk`, `latexdiff`, `hooks`, `git`, `vscode`, `agents`

New chapters use their new file name as scope.

### Subject (required)

- Format: `type(scope): description`; the scope is optional.
- Imperative mood, present tense ("add", not "added" or "adds"), starting
  with a lowercase verb.
- No trailing period.
- Describe the change concisely; don't repeat the type.
- Do not use "WIP" (case-insensitive). For unfinished text, describe the
  state instead: `feat(grundlagen): draft section on AIOps`.

### Body (optional)

- Explain the reason for the change (why), not just what.
- Use correct American English, imperative mood.
- Wrap at 72 characters.
- Bullet lists use `-` or `*` with a blank line before and after the list.

### Trailers (optional)

- Format: `Key: value`, placed last, after a blank line.
- Breaking changes: `Breaking-Change: <reason>`.
- AI tools contributed to the change: `AI-assisted: <tool> (<purpose>)`.
  Keeps a record for `chapters/ki-hilfsmittel.tex`.
- Other trailers (e.g. `Co-authored-by:`) are allowed.

### Examples

    feat(grundlagen): add section on root cause analysis

    fix(evaluation): correct latency values in results table

    refactor(konzeption): split architecture section into subsections

    chore(einleitung): fix typos in problem statement

    build(latexmk): run makeglossaries for the acronym list

    ci(hooks): block files larger than 10 MiB

    docs(agents): describe commit message rules

    feat(konzeption): add architecture overview figure

    The figure replaces the textual component list and shows the data
    flow between log ingestion and the language model explicitly.

    AI-assisted: GitHub Copilot (wording of the figure caption)

### History hygiene

- Single-author repository: commit directly on `main`; keep the history
  linear (rebase instead of merge if a branch is used).
- Every commit should build without errors (`latexmk`), so that any
  revision can be used for `scripts/latexdiff.ps1`.
- Commit a new `references.bib` export together with the text that
  cites the new sources.
- Squash fixup/"oops" commits before pushing; never rewrite pushed
  commits.
- Keep logically separate changes (e.g. content vs. class layout) as
  separate commits.
- Tag versions handed to the examiners (`v1`, `v2`, ...), so that
  `scripts/latexdiff.ps1 v1` shows all changes since then.
