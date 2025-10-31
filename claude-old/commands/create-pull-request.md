---
description: Anleitung für das Erstellen von Pull Requests mit GitHub CLI mit korrekten Templates und Konventionen
category: version-control-git
allowed-tools: Bash(gh *)
---

# Pull Request mit GitHub CLI erstellen

Diese Anleitung erklärt wie Pull Requests mit GitHub CLI in unserem Projekt erstellt werden.

## Voraussetzungen

1. GitHub CLI installieren falls noch nicht vorhanden:

   ```bash
   # macOS
   brew install gh

   # Windows
   winget install --id GitHub.cli

   # Linux
   # Anweisungen unter https://github.com/cli/cli/blob/trunk/docs/install_linux.md befolgen
   ```

2. Mit GitHub authentifizieren:

   ```bash
   gh auth login
   ```

## Neuen Pull Request erstellen

1. Zuerst PR-Beschreibung nach dem Template in @.github/pull_request_template.md vorbereiten

2. Den `gh pr create --draft` Befehl verwenden um einen neuen Pull Request zu erstellen:

   ```bash
   # Grundlegende Befehlsstruktur
   gh pr create --draft --title "✨(scope): Dein beschreibender Titel" --body "Deine PR-Beschreibung" --base main 
   ```

   Für komplexere PR-Beschreibungen mit korrekter Formatierung die `--body-file` Option mit der exakten PR-Template-Struktur verwenden:

   ```bash
   # PR mit korrekter Template-Struktur erstellen
   gh pr create --draft --title "✨(scope): Dein beschreibender Titel" --body-file .github/pull_request_template.md --base main
   ```

## Best Practices

1. **PR-Titel-Format**: Conventional Commit Format mit Emojis verwenden

   - Immer ein passendes Emoji am Anfang des Titels einfügen
   - Das tatsächliche Emoji-Zeichen verwenden (nicht die Code-Darstellung wie `:sparkles:`)
   - Beispiele:
     - `✨(supabase): Staging Remote-Konfiguration hinzufügen`
     - `🐛(auth): Login-Redirect-Problem beheben`
     - `📝(readme): Installationsanweisungen aktualisieren`

2. **Beschreibungs-Template**: Immer unsere PR-Template-Struktur aus @.github/pull_request_template.md verwenden

3. **Template-Genauigkeit**: Sicherstellen dass die PR-Beschreibung exakt der Template-Struktur folgt:

   - PR-Agent-Sektionen nicht modifizieren oder umbenennen (`pr_agent:summary` und `pr_agent:walkthrough`)
   - Alle Sektions-Header exakt so belassen wie sie im Template erscheinen
