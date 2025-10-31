---
description: Verifiziere dass Repository im funktionsfähigen Zustand ist durch Ausführung von CI-Checks und Behebung von Problemen
category: version-control-git
allowed-tools: Bash, Read, Edit
---

# Repository-Zustand verifizieren

Verifiziere dass das Repository in einem funktionsfähigen Zustand ist durch Ausführung entsprechender CI-Checks und Behebung aller gefundenen Probleme.

## Prozess

1. **Package Manager erkennen**:
   - Nach Package Manager Dateien suchen: package-lock.json (npm), pnpm-lock.yaml (pnpm), yarn.lock (yarn), bun.lockb (bun)
   - Nach anderen Build-Systemen suchen: Makefile, Cargo.toml, go.mod, requirements.txt, etc.

2. **Dependencies aktualisieren**:
   - npm: `npm install`
   - pnpm: `pnpm install`
   - yarn: `yarn install`
   - bun: `bun install`
   - Andere: Entsprechende Dependency-Installation ausführen

3. **Linting ausführen**:
   - package.json Scripts nach lint-Befehl durchsuchen
   - Häufige Muster: `lint`, `eslint`, `check`, `format`
   - Alle gefundenen Linting-Probleme beheben

4. **Type Checking ausführen** (falls anwendbar):
   - TypeScript: `tsc` oder nach `typecheck` Script suchen
   - Andere typisierte Sprachen: entsprechenden Type Checker ausführen

5. **Build ausführen**:
   - Nach Build-Scripts in package.json oder Build-Konfiguration suchen
   - Häufige Muster: `build`, `compile`, `dist`
   - Alle Build-Fehler beheben

6. **Tests ausführen**:
   - Nach Test-Scripts suchen: `test`, `test:unit`, `test:coverage`
   - .env Datei sourcen falls sie existiert vor Testausführung
   - Alle fehlschlagenden Tests beheben

7. **Zusätzliche Checks**:
   - Prüfen ob package.json sortiert werden muss (falls sort-package-json verfügbar)
   - Andere projektspezifische Checks aus CI-Konfiguration ausführen

8. **Änderungen stagen**:
   - Änderungen mit `git status` überprüfen
   - Behobene Dateien mit `git add` hinzufügen
   - Git Submodules oder Vendor-Verzeichnisse ausschließen

## Wichtige Hinweise

- **NICHT** zum nächsten Schritt fortfahren bis der aktuelle Befehl erfolgreich ist
- Alle gefundenen Probleme beheben bevor fortgefahren wird
- Falls ein Befehl nicht existiert, nach Alternativen suchen oder überspringen falls nicht anwendbar
- Zusammenfassung mit Häkchen (✅) für bestandene Schritte am Ende ausgeben

## Protokoll wenn etwas kaputt geht

Folgende Schritte wenn CI kaputt geht:

### 1. Erklären warum es kaputt ist

- Wenn ein Test kaputt ist, zuerst gründlich nachdenken und vollständige Erklärung geben was kaputt ging. Quellcode und Logs zitieren die die These unterstützen.
- Falls kein Quellcode oder Logs zur Unterstützung der These vorhanden, gründlich nachdenken und in Codebase nach Beweis suchen.
- Console Logs hinzufügen falls es hilft die These zu bestätigen oder herauszufinden warum es kaputt ist
