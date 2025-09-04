---
description: Behebe Probleme in einem Pull Request mit systematischem Workflow
category: version-control-git
argument-hint: <pr_nummer_oder_beschreibung>
allowed-tools: Bash(git *), Bash(gh *), Read, Edit
---

# Pull Request Probleme beheben

Behebe Probleme im Pull Request: $ARGUMENTS

## Workflow

1. **PR analysieren**:
   - PR-Details und Feedback reviewen
   - Failing Tests und CI-Probleme identifizieren
   - Code-Review-Kommentare durchgehen

2. **Lokale Änderungen vornehmen**:
   - Branch auschecken und aktualisieren
   - Probleme systematisch beheben
   - Tests lokal ausführen

3. **Änderungen committen und pushen**:

   ```bash
   git add .
   git commit -m "fix: Behebe PR-Feedback

   - Spezifische Änderungen auflisten
   - Referenz auf PR #<nummer>"
   git push origin <branch-name>
   ```

4. **Verifikation**:
   - CI/CD Pipeline überprüfen
   - Tests bestätigen
   - Review-Status aktualisieren
