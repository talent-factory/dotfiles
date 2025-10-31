---
description: Aktualisiere Implementierungsdokumentation inklusive Spezifikationen, Status und Best Practices
category: documentation-changelogs
allowed-tools: Read, Edit, Write
---

# Dokumentation aktualisieren

## Dokumentationsanalyse

1. **Aktuellen Dokumentationsstatus überprüfen**:
   - `specs/implementation_status.md` für Gesamtprojektstatus prüfen
   - Implementiertes Phasendokument (`specs/phase{N}_implementation_plan.md`) reviewen
   - `specs/flutter_structurizr_implementation_spec.md` und `specs/flutter_structurizr_implementation_spec_updated.md` reviewen
   - `specs/testing_plan.md` überprüfen um sicherzustellen dass es aktuell ist basierend auf kürzlichen Test-Erfolgen, -Fehlern und Änderungen
   - `CLAUDE.md` und `README.md` für projektweite Dokumentation untersuchen
   - Nach neuen Lessons Learned oder Best Practices in CLAUDE.md suchen und dokumentieren

2. **Implementierungs- und Testergebnisse analysieren**:
   - Überprüfen was in der letzten Phase implementiert wurde
   - Testergebnisse und Abdeckung reviewen
   - Neue Best Practices identifizieren die während der Implementierung entdeckt wurden
   - Implementierungsherausforderungen und Lösungen notieren
   - Aktualisierte Dokumentation mit kürzlichen Implementierungs- und Testergebnissen abgleichen um Genauigkeit sicherzustellen

## Dokumentationsupdates

1. **Phasen-Implementierungsdokument aktualisieren**:
   - Abgeschlossene Aufgaben mit ✅ Status markieren
   - Implementierungsprozentwerte aktualisieren
   - Detaillierte Notizen zum Implementierungsansatz hinzufügen
   - Abweichungen vom ursprünglichen Plan mit Begründung dokumentieren
   - Neue Abschnitte hinzufügen falls nötig (Lessons Learned, Best Practices)
   - Spezifische Implementierungsdetails für komplexe Komponenten dokumentieren
   - Zusammenfassung neuer Troubleshooting-Tipps oder Workflow-Verbesserungen die während der Phase entdeckt wurden einschliessen

2. **Implementierungsstatusdokument aktualisieren**:
   - Phasen-Abschlussprozentwerte aktualisieren
   - Implementierungsstatus für Komponenten hinzufügen oder aktualisieren
   - Notizen zu Implementierungsansatz und Entscheidungen hinzufügen
   - Best Practices dokumentieren die während der Implementierung entdeckt wurden
   - Überwundene Herausforderungen und implementierte Lösungen notieren

3. **Implementierungsspezifikationsdokumente aktualisieren**:
   - Abgeschlossene Elemente mit ✅ oder Durchstreichung markieren aber ursprüngliche Anforderungen bewahren
   - Notizen zu Implementierungsdetails wo angebracht hinzufügen
   - Referenzen zu implementierten Dateien und Klassen hinzufügen
   - Implementierungsleitfaden basierend auf Erfahrung aktualisieren

4. **CLAUDE.md und README.md falls nötig aktualisieren**:
   - Neue Best Practices hinzufügen
   - Projektstatus aktualisieren
   - Neue Implementierungsleitfäden hinzufügen
   - Bekannte Probleme oder Einschränkungen dokumentieren
   - Verwendungsbeispiele aktualisieren um neue Features einzuschliessen
