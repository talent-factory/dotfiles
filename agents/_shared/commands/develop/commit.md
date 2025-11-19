---
description: Erstelle professionelle Git-Commits mit automatischen Checks für Java, Python und React Projekte
category: develop
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Claude Command: Commit

Erstelle professionelle Git-Commits mit automatischen Qualitätschecks und konventionellen Commit-Nachrichten.

**Alle Commits und Nachrichten werden in Deutsch verfasst.**

## Verwendung

Standard-Commit:

```bash
/commit
```

Mit Optionen:

```bash
/commit --no-verify     # Überspringt Pre-Commit-Checks
/commit --force-push    # Führt force push aus (Vorsicht!)
/commit --skip-tests    # Überspringt Testausführung
```

## Workflow

1. **Pre-Commit-Checks** (optional mit `--no-verify` überspringen)
   - Automatische Projekterkennung (Java, Python, React, Docs)
   - Relevante Checks ausführen (Build, Tests, Linting)
   - Details siehe: [commit/pre-commit-checks.md](commit/pre-commit-checks.md)

2. **Staging-Analyse**
   - Prüfe gestakte Dateien mit `git status`
   - Füge automatisch Änderungen hinzu falls nötig
   - Zeige Übersicht der zu committenden Dateien

3. **Diff-Analyse**
   - Analysiere `git diff` für Änderungsumfang
   - Erkenne mehrere logische Änderungen
   - Schlage Commit-Aufteilung vor bei Bedarf

4. **Commit-Nachricht**
   - Verwende Emoji Conventional Commit Format
   - Automatische Typerkennung basierend auf Änderungen
   - Deutsche, imperative Beschreibung
   - Referenz: [commit/commit-types.md](commit/commit-types.md)

5. **Commit erstellen**
   - Erstelle Commit mit aussagekräftiger Nachricht
   - Optional: Push zum Remote-Repository anbieten

## Commit-Typen (Auswahl)

- ✨ `feat`: Neue Funktionalität
- 🐛 `fix`: Fehlerbehebung
- 📚 `docs`: Dokumentationsänderungen
- 💎 `style`: Code-Formatierung
- ♻️ `refactor`: Code-Umstrukturierung
- ⚡ `perf`: Performance-Verbesserungen
- 🧪 `test`: Tests hinzufügen/korrigieren
- 🔧 `chore`: Build, Tools, Konfiguration

**Vollständige Liste**: [commit/commit-types.md](commit/commit-types.md)

## Unterstützte Projekttypen

- **Java**: Maven, Gradle, Spring Boot
- **Python**: Ruff, Black, pytest, mypy
- **React/Node.js**: ESLint, Prettier, TypeScript, Jest/Vitest
- **Dokumentation**: LaTeX, Markdown, AsciiDoc

**Details zu Checks**: [commit/pre-commit-checks.md](commit/pre-commit-checks.md)

## Weitere Informationen

- **Best Practices**: [commit/best-practices.md](commit/best-practices.md)
- **Troubleshooting**: [commit/troubleshooting.md](commit/troubleshooting.md)
