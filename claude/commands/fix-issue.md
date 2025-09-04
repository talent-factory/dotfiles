---
description: Systematische Behebung eines spezifischen Issues mit vollständigem Workflow
category: version-control-git
argument-hint: <issue_nummer_oder_beschreibung>
allowed-tools: Bash(git *), Bash(gh *), Read, Edit
---

# Issue beheben

Behebe das Issue: $ARGUMENTS

## Workflow

1. **Issue analysieren**:
   - Issue-Details aus GitHub abrufen (falls Nummer angegeben)
   - Problem verstehen und Reproduktionsschritte identifizieren
   - Betroffene Dateien und Komponenten ermitteln

2. **Branch erstellen**:

   ```bash
   git checkout -b fix/issue-<nummer>-kurze-beschreibung
   ```

3. **Problem lösen**:
   - Minimale, zielgerichtete Änderungen implementieren
   - Tests hinzufügen oder anpassen
   - Lokale Tests ausführen

4. **Commit und Push**:

   ```bash
   git add .
   git commit -m "fix: Löse Issue #<nummer>

   - Detaillierte Beschreibung der Änderungen
   - Referenz auf Issue #<nummer>"
   git push origin fix/issue-<nummer>-kurze-beschreibung
   ```

5. **Pull Request erstellen**:
   - PR mit Referenz auf das ursprüngliche Issue
   - Test-Plan und Verifikationsschritte hinzufügen
