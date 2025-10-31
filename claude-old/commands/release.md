---
description: Erstelle ein neues Release mit Versionierung, Changelog und Deployment
category: ci-deployment
argument-hint: <version_nummer>
allowed-tools: Bash(git *), Bash(gh *), Edit, Read
---

# Release erstellen

Erstelle Release: $ARGUMENTS

## Release-Workflow

1. **Version vorbereiten**:
   - Changelog aktualisieren
   - Version in relevanten Dateien bumpen
   - Tests ausführen und sicherstellen, dass alles funktioniert

2. **Git-Tag erstellen**:

   ```bash
   git tag -a v$ARGUMENTS -m "Release v$ARGUMENTS"
   git push origin v$ARGUMENTS
   ```

3. **GitHub Release erstellen**:

   ```bash
   gh release create v$ARGUMENTS --title "Release v$ARGUMENTS" --notes-from-tag
   ```

4. **Post-Release**:
   - Deployment-Pipeline überwachen
   - Release-Notes kommunizieren
   - Nächste Entwicklungsversion vorbereiten
