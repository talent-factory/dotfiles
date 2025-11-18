---
description: Erstelle einen neuen Branch, committe Änderungen und erstelle einen Pull Request mit automatischer Commit-Aufteilung
category: develop
allowed-tools:
  - "Bash(git *)"
  - "Bash(gh *)"
  - "Bash(biome *)"
  - Read
  - Glob
---

# Claude Command: Pull Request erstellen

Erstelle automatisch einen neuen Branch, analysiere Änderungen und erstelle einen professionellen Pull Request.

**Alle Commit-Nachrichten und PR-Beschreibungen werden in Deutsch verfasst.**

## Verwendung

Standard-Pull-Request:

```bash
/create-pr
```

Mit Optionen:

```bash
/create-pr --draft          # Erstellt Draft-PR
/create-pr --no-format      # Überspringt Code-Formatierung
/create-pr --single-commit  # Alle Änderungen in einem Commit
/create-pr --target main    # Ziel-Branch angeben (Standard: main)
```

## Workflow

1. **Änderungen prüfen**
   - Erkenne uncommitted oder bereits committete Änderungen
   - Falls uncommitted Changes → Rufe `/commit` auf
   - Falls Commits vorhanden → Verwende diese
   - Details: [create-pr/commit-workflow.md](create-pr/commit-workflow.md)

2. **Branch erstellen**
   - Generiere aussagekräftigen Branch-Namen: `<type>/<description>-<date>`
   - Prüfe auf bestehende Branches
   - Erstelle Branch vom aktuellen HEAD
   - Beispiel: `feature/user-dashboard-2024-10-30`

3. **Code-Formatierung** (optional mit `--no-format` überspringen)
   - **JavaScript/TypeScript**: Biome
   - **Python**: Black, isort, Ruff
   - **Java**: Google Java Format
   - **Markdown**: markdownlint
   - Details: [create-pr/code-formatting.md](create-pr/code-formatting.md)

4. **Pull Request erstellen**
   - Push Branch zum Remote
   - Generiere aussagekräftigen PR-Titel
   - Erstelle detaillierte PR-Beschreibung mit Test-Plan
   - Verlinke relevante Issues
   - Setze passende Labels
   - Template: [create-pr/pr-template.md](create-pr/pr-template.md)

## Integration mit /commit

**Wichtig**: Dieser Command erstellt KEINE eigenen Commits!

- **Uncommitted Changes**: Ruft `/commit` auf
- **Bestehende Commits**: Verwendet diese für PR
- **Keine Commit-Duplikation**: Commit-Logik nur in `/commit`

**Workflow-Details**: [create-pr/commit-workflow.md](create-pr/commit-workflow.md)

## PR-Template

```markdown
## Beschreibung

[Kurze Beschreibung der Änderungen]

## Änderungen

- Änderung 1
- Änderung 2

## Test-Plan

- [ ] Manuelle Tests durchgeführt
- [ ] Automatische Tests laufen durch
- [ ] Code-Review bereit

## Breaking Changes

[Falls vorhanden]
```

**Vollständiges Template**: [create-pr/pr-template.md](create-pr/pr-template.md)

## Best Practices

- **Aussagekräftige Titel**: Beschreibe das "Was" in 50 Zeichen
- **Detaillierte Beschreibung**: Erkläre das "Warum" und "Wie"
- **Self-Review**: Prüfe eigene Änderungen vor Submission
- **Kleine PRs**: Halte PRs fokussiert und reviewbar (150-400 Zeilen)
- **Klare Commits**: Jeder Commit sollte eigenständig verständlich sein

**Weitere Best Practices**: [create-pr/pr-template.md](create-pr/pr-template.md)

## Weitere Informationen

- **Code-Formatierung**: [create-pr/code-formatting.md](create-pr/code-formatting.md)
- **Commit-Workflow**: [create-pr/commit-workflow.md](create-pr/commit-workflow.md)
- **PR-Template & Best Practices**: [create-pr/pr-template.md](create-pr/pr-template.md)
- **Troubleshooting**: [create-pr/troubleshooting.md](create-pr/troubleshooting.md)
