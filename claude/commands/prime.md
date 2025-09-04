---
description: Lade Projektkontext mit aktuellen Informationen und Änderungen
category: context-loading-priming
allowed-tools: Read, Bash(git *), Glob
---

# Kontext laden und vorbereiten

Lade den vollständigen Projektkontext mit aktuellen Informationen und Änderungen.

## Kontext-Workflow

1. **Projektverständnis aufbauen**:
   - README.md lesen um Projekt und Ziele zu verstehen
   - Hauptfunktionalitäten und Architektur erfassen
   - Setup-Anweisungen und Dependencies notieren

2. **Aktuelle Entwicklung analysieren**:

   ```bash
   git log --oneline -10
   git status
   ```

3. **Projektstruktur erkunden**:
   - Verzeichnisstruktur analysieren
   - Wichtige Konfigurationsdateien identifizieren
   - Code-Organisation verstehen

4. **Dokumentation sammeln**:
   - Vorhandene Dokumentation durchgehen
   - Kommentare und Notizen erfassen
   - Relevante Kontext-Informationen zusammenstellen

5. **Arbeitsstand bewerten**:
   - Offene Änderungen prüfen
   - Nächste Schritte identifizieren
   - Prioritäten ableiten
