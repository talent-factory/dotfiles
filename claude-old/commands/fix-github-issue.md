---
description: Analysiere und behebe ein GitHub Issue mit umfassenden Tests und Verifikation
category: version-control-git
argument-hint: <issue_nummer>
allowed-tools: Bash(gh *), Read, Edit, Write, Bash(git *)
---

# GitHub Issue beheben

Analysiere und behebe das GitHub Issue: $ARGUMENTS.

## Prozess

1. **Issue-Details abrufen**: `gh issue view` verwenden um Issue-Details zu erhalten
2. **Problem verstehen**: Das im Issue beschriebene Problem verstehen
3. **Codebase durchsuchen**: Nach relevanten Dateien suchen
4. **Änderungen implementieren**: Notwendige Änderungen zur Behebung des Issues implementieren
5. **Tests schreiben und ausführen**: Fix durch Tests verifizieren
6. **Code-Qualität sicherstellen**: Code besteht Linting und Type-Checking
7. **Beschreibende Commit-Message erstellen**: Aussagekräftige Commit-Nachricht verfassen

## Wichtige Hinweise

- GitHub CLI (`gh`) für alle GitHub-bezogenen Aufgaben verwenden
- Umfassende Tests zur Verifikation der Lösung
- Code-Qualitätsstandards einhalten