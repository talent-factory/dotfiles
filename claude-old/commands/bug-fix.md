---
description: Systematischer Workflow zur Fehlerbehebung mit Issue-Erstellung, Branch-Management und PR-Submission
category: version-control-git
argument-hint: <fehlerbeschreibung>
allowed-tools: Bash(git *), Bash(gh *)
---

# Fehlerbehebungs-Workflow

Verstehe den Fehler: $ARGUMENTS

## Vor dem Start

1. **GitHub Issue erstellen**:

   - Kurzen, beschreibenden Titel verwenden
   - Fehlerbeschreibung, Reproduktionsschritte und erwartetes Verhalten hinzufügen
   - Relevante Labels setzen (bug, priority, etc.)

2. **Git Branch erstellen**:

   ```bash
   git checkout -b fix/kurze-beschreibung-des-fehlers
   ```

## Fehlerbehebung durchführen

1. Problem lokalisieren und verstehen
2. Tests schreiben (falls nicht vorhanden)
3. Minimale Änderungen zur Fehlerbehebung implementieren
4. Tests ausführen und sicherstellen, dass sie bestehen

## Nach Abschluss

1. **Commit mit beschreibender Nachricht**:

   ```bash
   git commit -m "fix: Kurze Beschreibung der Behebung

   - Detaillierte Erklärung der Änderungen
   - Referenz auf Issue #123"
   ```

2. **Branch zum Remote-Repository pushen**:

   ```bash
   git push origin fix/kurze-beschreibung-des-fehlers
   ```

3. **Pull Request erstellen und Issue verlinken**:

   - Verwende GitHub CLI oder Web-Interface
   - Verlinke das ursprüngliche Issue
   - Füge Test-Plan hinzu
