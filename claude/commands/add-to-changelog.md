---
description: Füge einen neuen Eintrag zur CHANGELOG.md des Projekts hinzu nach Keep a Changelog Format
category: documentation-changelogs
argument-hint: <version> <änderungstyp> <nachricht>
allowed-tools: Read, Edit
---

# Changelog aktualisieren

Füge einen neuen Eintrag zur CHANGELOG.md des Projekts hinzu basierend auf den bereitgestellten Argumenten.

## Argumente analysieren

Analysiere $ARGUMENTS um zu extrahieren:

- Versionsnummer (z.B. "1.1.0")
- Änderungstyp: "added", "changed", "deprecated", "removed", "fixed", oder "security"
- `<nachricht>` ist die Beschreibung der Änderung

## Beispiele

```text
/add-to-changelog 1.1.0 added "Neue Markdown zu BlockDoc Konvertierungsfunktion"
```

```text
/add-to-changelog 1.0.2 fixed "Fehler im HTML-Renderer der falsche Ausgabe verursacht"
```

## Beschreibung

Dieser Befehl wird:

1. **CHANGELOG.md prüfen und erstellen falls nötig**
2. **Nach existierender Sektion für die angegebene Version suchen**:
   - Falls gefunden: Neuen Eintrag unter dem entsprechenden Änderungstyp hinzufügen
   - Falls nicht gefunden: Neue Versionssektion mit heutigem Datum erstellen
3. **Eintrag nach Keep a Changelog Konventionen formatieren**
4. **Änderungen committen falls gewünscht**

## Implementierung

Der Befehl sollte:

1. **Argumente parsen** um Version, Änderungstyp und Nachricht zu extrahieren
2. **Existierende CHANGELOG.md lesen** falls vorhanden
3. **Falls Datei nicht existiert**: Neue mit Standard-Header erstellen
4. **Prüfen ob Versionssektion bereits existiert**
5. **Neuen Eintrag in entsprechender Sektion hinzufügen**
6. **Aktualisierten Inhalt zurück in Datei schreiben**
7. **Committen der Änderungen vorschlagen**

Denke daran, die Package-Version in `__init__.py` und `setup.py` zu aktualisieren, falls dies eine neue Version ist.

Das CHANGELOG folgt dem [Keep a Changelog](https://keepachangelog.com/) Format und [Semantic Versioning](https://semver.org/).
