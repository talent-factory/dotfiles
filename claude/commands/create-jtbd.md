---
description: Erstelle ein Jobs to be Done (JTBD) Dokument für ein Produkt-Feature mit Fokus auf Benutzerbedürfnisse
category: project-task-management
argument-hint: "<feature-beschreibung> [ausgabe-pfad]"
allowed-tools: Write, TodoWrite
---

# Jobs to be Done Dokument erstellen

Erstelle ein umfassendes Jobs to be Done (JTBD) Dokument basierend auf der bereitgestellten Feature-Beschreibung.

## Anweisungen

1. **Argumente parsen**:
   - Erstes Argument: Feature/Produkt-Beschreibung (erforderlich)
   - Zweites Argument: Ausgabe-Pfad (optional, Standard: `JTBD.md` im aktuellen Verzeichnis)

2. **Gut strukturiertes JTBD-Dokument erstellen** das folgendes beinhaltet:

   **Kern-Job-Statement**:
   - Wenn [Situation]
   - Möchte ich [Motivation]
   - Damit ich [erwartetes Ergebnis]

   **Job Map**:
   - Definieren: Was Benutzer zuerst verstehen müssen
   - Lokalisieren: Welche Eingaben/Ressourcen Benutzer benötigen
   - Vorbereiten: Wie sich Benutzer bereit machen
   - Bestätigen: Wie Benutzer Bereitschaft verifizieren
   - Ausführen: Die Kern-Aktion
   - Überwachen: Wie Benutzer Fortschritt verfolgen
   - Modifizieren: Wie Benutzer Anpassungen vornehmen
   - Abschließen: Wie Benutzer den Job beenden

   **Kontext & Umstände**:
   - Funktionale Job-Aspekte
   - Emotionale Job-Aspekte
   - Soziale Job-Aspekte

   **Erfolgskriterien**:
   - Wie Benutzer Erfolg messen
   - Welche Ergebnisse sie erwarten
   - Zeit-/Aufwands-Einschränkungen

   **Schmerzpunkte**:
   - Aktuelle Frustrationen
   - Workarounds die Benutzer verwenden
   - Unerfüllte Bedürfnisse

   **Konkurrierende Lösungen**:
   - Wie Benutzer dies aktuell lösen
   - Alternative Ansätze
   - Warum aktuelle Lösungen unzureichend sind

3. **Fokus auf**:
   - Benutzer-Motivationen (nicht Features)
   - Jobs die über Zeit stabil bleiben
   - Ergebnisse die Benutzer erreichen wollen
   - Kontext der den Job auslöst

4. **TodoWrite-Tool verwenden** um JTBD-Sektionen zu verfolgen während du sie vervollständigst

## Beispiel-Verwendung

- `/create-jtbd "Hilf Entwicklern Bugs schneller zu finden und zu beheben"`
- `/create-jtbd "Ermögliche Teams in Echtzeit an Dokumenten zusammenzuarbeiten" collab-JTBD.md`

Feature-Beschreibung: $ARGUMENTS
