---
description: Führe umfassende Code-Analyse mit Qualitätsmetriken und Empfehlungen durch
category: code-analysis-testing
argument-hint: "[datei-oder-verzeichnis-pfad]"
allowed-tools: Read, Grep, Glob, TodoWrite
---

# Code-Analyse durchführen

Führe eine umfassende Code-Analyse der angegebenen Dateien oder des Verzeichnisses durch. Falls kein Pfad angegeben ist, analysiere das aktuelle Arbeitsverzeichnis.

## Analyse-Prozess

1. **Argumente parsen**:
   - Pfad aus $ARGUMENTS extrahieren (Standard: aktuelles Verzeichnis falls nicht angegeben)
   - Umfang bestimmen: einzelne Datei, mehrere Dateien oder ganzes Verzeichnis

2. **Sprach-Erkennung**:
   - Programmiersprache(n) basierend auf Dateiendungen identifizieren
   - Sprachspezifische Analyse-Regeln anwenden

3. **Code-Qualitäts-Analyse**:
   - **Komplexitäts-Metriken**: Zyklomatische Komplexität, Verschachtelungstiefe, Funktionslänge
   - **Code-Smells**: Lange Methoden, große Klassen, doppelte Code-Muster
   - **Best Practices**: Namenskonventionen, Code-Organisation, Dokumentation
   - **Sicherheitsprobleme**: Häufige Schwachstellen, unsichere Muster, Input-Validierung
   - **Performance**: Ineffiziente Algorithmen, Memory Leaks, blockierende Operationen
   - **Wartbarkeit**: Code-Kopplung, Kohäsion, Test-Coverage-Indikatoren

4. **Bericht generieren**:
   - Zusammenfassung mit Gesamt-Gesundheitsscore
   - Detaillierte Ergebnisse nach Kategorie
   - Prioritäts-gerankte Probleme (Hoch/Mittel/Niedrig)
   - Spezifische Datei- und Zeilenreferenzen
   - Umsetzbare Verbesserungsempfehlungen

5. **Mit TodoWrite verfolgen**:
   - Todos für hochpriorisierte gefundene Probleme erstellen
   - Nach Fix-Komplexität und Impact organisieren

## Beispiel-Verwendung

- `/code_analysis` - Gesamtes aktuelles Verzeichnis analysieren
- `/code_analysis src/` - Allen Code im src-Verzeichnis analysieren
- `/code_analysis app.js` - Spezifische Datei analysieren
- `/code_analysis "src/**/*.py"` - Alle Python-Dateien in src analysieren

Ziel-Pfad: $ARGUMENTS
