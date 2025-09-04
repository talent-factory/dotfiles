---
description: Führe CI-Checks aus und behebe alle Fehler bis alle Tests bestehen
category: ci-deployment
allowed-tools: Bash, Edit, Read, Glob
---

# CI-Checks ausführen

Führe CI-Checks für das Projekt aus und behebe alle Fehler bis alle Tests bestehen.

## Prozess

1. **CI-System erkennen**:
   - Prüfe auf CI-Konfigurationsdateien:
     - `.github/workflows/*.yml` (GitHub Actions)
     - `.gitlab-ci.yml` (GitLab CI)
     - `.circleci/config.yml` (CircleCI)
     - `Jenkinsfile` (Jenkins)
     - `.travis.yml` (Travis CI)
     - `bitbucket-pipelines.yml` (Bitbucket)

2. **Build-System erkennen**:
   - JavaScript/TypeScript: package.json scripts
   - Python: Makefile, tox.ini, setup.py, pyproject.toml
   - Go: Makefile, go.mod
   - Rust: Cargo.toml
   - Java: pom.xml, build.gradle
   - Andere: Suche nach gängigen CI-Scripts

3. **CI-Befehle ausführen**:
   - Prüfe auf CI-Scripts: `ci`, `test`, `check`, `validate`, `verify`
   - Gängige Script-Standorte:
     - `./scripts/ci.sh`, `./ci.sh`, `./run-tests.sh`
     - Package Manager Scripts (npm/yarn/pnpm run test)
     - Make-Targets (make test, make ci)
   - Virtuelle Umgebungen aktivieren falls nötig (Python, Ruby, etc.)

4. **Fehler beheben**:
   - Fehlerausgabe analysieren
   - Code-Probleme, Test-Fehler oder Konfigurationsprobleme beheben
   - CI-Checks nach jeder Behebung erneut ausführen

5. **Gängige CI-Aufgaben**:
   - Linting/Formatierung
   - Type-Checking
   - Unit-Tests
   - Integrationstests
   - Build-Verifikation
   - Dokumentationsgenerierung

## Beispiele

- JavaScript: `npm test` oder `npm run ci`
- Python: `make test` oder `pytest` oder `tox`
- Go: `go test ./...` oder `make test`
- Rust: `cargo test`
- Generisch: `./ci.sh` oder `make ci`

Behebe weiterhin Probleme und führe erneut aus bis alle CI-Checks bestehen.
