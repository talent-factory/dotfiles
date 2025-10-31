---
description: Analysiere GitHub Issue und erstelle technische Spezifikation mit Implementierungsplan
category: documentation-changelogs
argument-hint: <issue_nummer>
allowed-tools: Read
---

# Technische Dokumentation erstellen

Analysiere GitHub Issue #$ARGUMENTS und erstelle eine technische Spezifikation.

## Prozess

1. **Issue-Details von GitHub API abrufen**
2. **Anforderungen gründlich verstehen**
3. **Verwandten Code und Projektstruktur überprüfen**
4. **Detaillierte Analyseergebnisse klar in der Antwort ausgeben**
5. **Technische Spezifikation mit folgendem Format erstellen**

## Template für technische Spezifikation

```markdown
# Technische Spezifikation für Issue #$ARGUMENTS

## Issue-Zusammenfassung
- Titel: [Issue-Titel von GitHub]
- Beschreibung: [Kurze Beschreibung aus Issue]
- Labels: [Labels aus Issue]
- Priorität: [Hoch/Mittel/Niedrig basierend auf Issue-Inhalt]

## Problemstellung
[1-2 Absätze die das Problem erklären]

## Technischer Ansatz
[Detaillierter technischer Ansatz]

## Implementierungsplan
1. [Schritt 1]
2. [Schritt 2]
3. [Schritt 3]

## Testplan
1. Unit Tests:
   - [Test-Szenario]
2. Komponenten-Tests:
   - [Test-Szenario]
3. Integrations-Tests:
   - [Test-Szenario]

## Zu modifizierende Dateien
- 

## Zu erstellende Dateien
- 

## Zu nutzende existierende Utilities
- 

## Erfolgskriterien
- [ ] [Kriterium 1]
- [ ] [Kriterium 2]

## Außerhalb des Umfangs
- [Element 1]
- [Element 2]
```

## Wichtige Hinweise

- Folge unseren strikten TDD-Prinzipien
- Verwende KISS-Ansatz (Keep It Simple, Stupid)
- Beachte das 300-Zeilen-Datei-Limit

**WICHTIG**: Nach Abschluss der Analyse die vollständige technische Spezifikation explizit in der Antwort ausgeben damit sie überprüft werden kann.
