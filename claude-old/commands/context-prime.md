---
description: Lade Projektkontext durch Lesen der README.md und Erkundung relevanter Projektdateien
category: context-loading-priming
allowed-tools: Read, Bash(git *)
---

# Projektkontext laden

Dieser Befehl lädt den Projektkontext durch systematische Analyse der wichtigsten Projektdateien.

## Workflow

1. **README.md lesen**:
   - Verstehe Projektbeschreibung und Ziele
   - Identifiziere Hauptfunktionalitäten
   - Notiere wichtige Setup-Anweisungen

2. **Projektstruktur analysieren**:

   ```bash
   git ls-files | head -20
   ```

3. **Relevante Konfigurationsdateien prüfen**:
   - package.json / requirements.txt / Cargo.toml
   - .gitignore und andere Konfigurationsdateien
   - Dokumentationsverzeichnisse

4. **Projekttyp identifizieren**:
   - Programmiersprache(n)
   - Framework(s) und Dependencies
   - Build-System und Tools

## Ziel

Nach Ausführung dieses Befehls solltest du ein klares Verständnis haben von:

- Was das Projekt macht
- Wie es strukturiert ist
- Welche Technologien verwendet werden
- Wie man damit arbeitet
