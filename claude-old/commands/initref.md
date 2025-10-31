---
description: Initialisiere Referenzdokumentation für ein neues Projekt oder Feature
category: documentation-changelogs
argument-hint: <projekt_name>
allowed-tools: Write, Read, Glob
---

# Referenzdokumentation initialisieren

Initialisiere Referenzdokumentation für: $ARGUMENTS

## Dokumentationsstruktur

Erstelle folgende Dokumentationsstruktur:

1. **README.md** - Projektübersicht und Schnellstart
2. **CONTRIBUTING.md** - Beitragsrichtlinien
3. **CHANGELOG.md** - Versionshistorie und Änderungen
4. **docs/** Verzeichnis mit:
   - **getting-started.adoc** - Detaillierte Setup-Anweisungen
   - **api-reference.adoc** - API-Dokumentation
   - **examples/** - Code-Beispiele und Tutorials
   - **troubleshooting.adoc** - Häufige Probleme und Lösungen

## Inhalts-Templates

Jede Datei sollte enthalten:

- Klare Überschriften und Struktur
- Code-Beispiele wo relevant
- Links zu verwandter Dokumentation
- Konsistente Formatierung und Stil

## Implementierungsschritte

1. **Verzeichnisstruktur erstellen**
2. **Template-Dateien mit Platzhalter-Inhalt generieren**
3. **Inhalt für das spezifische Projekt anpassen**
4. **Dokumentations-Build-Prozess einrichten (falls nötig)**
5. **Dokumentations-Links zur Haupt-README hinzufügen**

## AsciiDoc-Format

Folge den globalen Dokumentationsrichtlinien:

- Dokumentation in AsciiDoc (.adoc) erstellen
- Deutsche Sprache verwenden
- Technische Begriffe in Englisch belassen
- Konsistente Terminologie

## Beispiel

```bash
/initref
```

Dies erstellt oder aktualisiert Referenzdateien im `/ref`-Verzeichnis und aktualisiert die zentrale Dokumentation in `CLAUDE.md`.

## Hinweise

- Achte auf eine konsistente Struktur der Referenzdateien
- Verwende deutsche Beschreibungen mit englischen Fachbegriffen
- Stelle sicher, dass alle wichtigen Projektkomponenten dokumentiert sind
