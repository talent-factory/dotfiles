---
description: Führe umfassende PR-Review aus mehreren Perspektiven durch (PM, Developer, QA, Security)
category: version-control-git
argument-hint: <pr_link_oder_nummer>
allowed-tools: Bash(gh *), Read
---

# PR Review durchführen

**PR Link/Nummer**: $ARGUMENTS

> **Anweisungen**: Führe jede Aufgabe in der angegebenen Reihenfolge aus um eine gründliche Code-Review durchzuführen. Aktualisiere GitHub mit dieser Review.
> **Wichtig**: Die Zukunft ist jetzt—alle Verbesserungen oder "zukünftige" Empfehlungen müssen **sofort** umgesetzt werden.

---

## Aufgabe 1: Product Manager Review

**Ziel**: Bewertung aus Produktmanagement-Perspektive, Fokus auf:

- **Business Value**: Bringt diese PR unsere Kernprodukt-Ziele klar voran und liefert sofortigen ROI?
- **User Experience**: Ist die Änderung intuitiv und erfreulich für Benutzer jetzt sofort? Falls nicht, sofort beheben.
- **Strategische Ausrichtung**: Passt die PR zu aktuellen (und langfristigen, d.h. jetzigen) strategischen Zielen?

**Aktion**: Klare Anweisungen geben wie maximaler Benutzer- und Business-Impact sichergestellt wird. Alle "zukünftigen" Vorschläge müssen jetzt implementiert werden.

---

## Aufgabe 2: Developer Review

**Ziel**: Code gründlich aus Senior Lead Engineer Perspektive bewerten:

1. **Code-Qualität & Wartbarkeit**: Ist der Code für Lesbarkeit und einfache Wartung strukturiert? Falls nicht, jetzt refactoren.
2. **Performance & Skalierbarkeit**: Werden diese Änderungen effizient bei Skalierung funktionieren? Falls nicht, sofort optimieren.
3. **Best Practices & Standards**: Abweichungen von Coding-Standards notieren und jetzt korrigieren.

**Aktion**: Präzisen aber vollständigen Review-Kommentar hinterlassen, sicherstellen dass alle Verbesserungen sofort passieren—keine Verschiebungen.

---

## Aufgabe 3: Quality Engineer Review

**Ziel**: Gesamtqualität, Test-Strategie und Zuverlässigkeit der Lösung verifizieren:

1. **Test-Abdeckung**: Sind ausreichend Tests vorhanden (Unit, Integration, E2E)? Falls nicht, jetzt hinzufügen.
2. **Potenzielle Bugs & Edge Cases**: Wurden alle Edge Cases berücksichtigt? Falls nicht, sofort addressieren.
3. **Regressions-Risiko**: Bestätigen dass Änderungen existierende Funktionalität nicht untergraben. Falls Risiko identifiziert, jetzt mit zusätzlichen Checks oder Tests mindern.

**Aktion**: Detaillierte QA-Bewertung bereitstellen, darauf bestehen dass alle "zukünftigen" Verbesserungen sofort abgeschlossen werden.

---

## Aufgabe 4: Security Engineer Review

**Ziel**: Robuste Sicherheitspraktiken und Compliance sicherstellen:

1. **Schwachstellen**: Identifiziere potenzielle Sicherheitslücken oder unsichere Praktiken. Falls gefunden, sofort beheben.
2. **Authentifizierung & Autorisierung**: Überprüfe dass Zugriffskontrolle korrekt implementiert ist.
3. **Datenschutz & Compliance**: Stelle sicher dass sensible Daten angemessen behandelt werden.
4. **Input-Validierung**: Bestätige dass alle Eingaben ordnungsgemäß validiert und sanitisiert werden.

**Aktion**: Umfassende Sicherheitsbewertung durchführen und alle identifizierten Risiken sofort mindern.

---

## Abschluss

Nach Abschluss aller vier Reviews:

1. **Zusammenfassung erstellen**: Kurze Zusammenfassung aller kritischen Punkte und erforderlichen Änderungen
2. **GitHub Review posten**: Vollständige Review mit allen Kommentaren und Empfehlungen auf GitHub veröffentlichen
3. **Nachverfolgung**: Sicherstellen dass alle "sofortigen" Verbesserungen tatsächlich implementiert werden

**Wichtig**: Diese Review ist nur abgeschlossen wenn alle identifizierten Verbesserungen implementiert sind—keine Verschiebungen auf "später".
