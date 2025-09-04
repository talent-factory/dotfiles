---
description: Behebe alle Linting- und Formatierungsprobleme in der gesamten Codebase
category: code-analysis-testing
allowed-tools: Bash, Edit, Read, Glob
---

# Codebase bereinigen

Behebe alle Linting-, Formatierungs- und statische Analyse-Probleme in der gesamten Codebase.

## Prozess

1. **Projektsprache(n) erkennen**:
   - Dateiendungen und Konfigurationsdateien prüfen
   - Häufige Indikatoren:
     - Python: .py Dateien, requirements.txt, pyproject.toml
     - JavaScript/TypeScript: .js/.ts Dateien, package.json
     - Go: .go Dateien, go.mod
     - Rust: .rs Dateien, Cargo.toml
     - Java: .java Dateien, pom.xml
     - Ruby: .rb Dateien, Gemfile

2. **Sprachspezifische Linter ausführen**:

   **Python:**
   - Formatierung: `black .` oder `autopep8`
   - Import-Sortierung: `isort .`
   - Linting: `flake8` oder `pylint`
   - Type-Checking: `mypy`

   **JavaScript/TypeScript:**
   - Linting: `eslint . --fix`
   - Formatierung: `prettier --write .`
   - Type-Checking: `tsc --noEmit`

   **Go:**
   - Formatierung: `go fmt ./...`
   - Linting: `golangci-lint run --fix`

   **Rust:**
   - Formatierung: `cargo fmt`
   - Linting: `cargo clippy --fix`

   **Java:**
   - Formatierung: `google-java-format` oder `spotless`
   - Linting: `checkstyle` oder `spotbugs`

   **Ruby:**
   - Linting/Formatierung: `rubocop -a`

3. **Projekt-Scripts prüfen**:
   - Nach Lint/Format-Scripts in package.json, Makefile, etc. suchen
   - Häufige Script-Namen: `lint`, `format`, `fix`, `clean`

4. **Probleme beheben**:
   - Auto-Fixes anwenden wo verfügbar
   - Probleme manuell beheben die nicht automatisch behoben werden können
   - Linter erneut ausführen um zu verifizieren dass alle Probleme gelöst sind

5. **Sauberen Zustand verifizieren**:
   - Alle Linter erneut ohne Fix-Flags ausführen
   - Sicherstellen dass keine Fehler oder Warnungen verbleiben

Behebe alle gefundenen Probleme bis die Codebase alle Linting- und Formatierungs-Checks besteht.
