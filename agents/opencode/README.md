# OpenCode Agent Konfiguration

Dieses Verzeichnis enthält benutzerdefinierte OpenCode-Agenten, die spezialisierte 
KI-Assistenten für bestimmte Aufgaben und Workflows darstellen. Anders als bei Claude 
Code sind OpenCode-Agenten stark auf die tool-gesteuerte Entwicklung ausgerichtet und 
unterstützen zwei Haupttypen:

## Agent-Typen in OpenCode

### Primary Agents (Primäre Agenten)
Primäre Agenten sind die Hauptassistenten, mit denen du direkt interagierst. Du kannst während einer Sitzung mit der **Tab**-Taste zwischen ihnen wechseln. OpenCode bringt zwei eingebaute primäre Agenten mit:

- **Build**: Standard-Agent mit allen Tools aktiviert
- **Plan**: Eingeschränkter Agent für Analyse und Planung ohne Änderungen

### Subagents (Sub-Agenten)  
Sub-Agenten sind spezialisierte Assistenten, die von primären Agenten für bestimmte Aufgaben aufgerufen werden können. Sie können auch manuell mit **@-Erwähnungen** aktiviert werden:

```
@general help me search for this function
```

## Verzeichnisstruktur

```
agents/opencode/
├── agent/              # Agenten-Konfigurationen
│   ├── deutscher-dokumentations-agent.md
│   ├── security-auditor.md
│   └── (weitere agenten)
├── command/            # Slash-Befehle (Custom Commands)
│   ├── README.md       # Übersicht aller Commands
│   ├── QUICKSTART.md   # Schnellstart für Commands
│   ├── commit.md       # Commit-Nachrichten generieren
│   ├── create-pr.md    # Pull Requests erstellen
│   ├── implement-task.md # Entwicklungsaufgaben umsetzen
│   ├── check.md        # Code-Qualitätsprüfungen
│   ├── init-project.md # Neue Projekte initialisieren
│   ├── create-plan.md  # Entwicklungspläne erstellen
│   ├── create-prd.md   # Product Requirements erstellen
│   ├── build-skill.md  # Agent Skills bauen
│   ├── package-skill.md # Skills paketieren
│   ├── create-command.md # Custom Commands erstellen
│   ├── check-commands.md # Commands validieren
│   ├── check-agents.md # Agenten validieren
│   ├── ruff-check.md   # Ruff Linting und Formatting
│   └── (weitere commands)
└── README.md           # Diese Datei
```

## Agent-Konfiguration

Agenten können auf zwei Weisen konfiguriert werden:

### 1. Markdown-Dateien (Empfohlen)
Erstelle Markdown-Dateien im `agents/opencode/agent/`-Verzeichnis. Der Dateiname wird zum Agentennamen:

```yaml
---
description: Erstellt und pflegt deutsche technische Dokumentation
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
tools:
  write: true
  edit: true
  bash: false
permission:
  edit: allow
  bash: deny
---

Du bist ein spezialisierter technischer Redakteur für deutsche Dokumentation. Deine Hauptaufgaben sind:

- Erstellung klarer und verständlicher technischer Dokumentation auf Deutsch
- Pflege und Aktualisierung bestehender Dokumentationen
- Übersetzung technischer Inhalte von Englisch ins Deutsche
- Sicherstellung konsistenter Terminologie und Stil

## Custom Commands (Slash-Befehle)

Neben Agenten bietet OpenCode auch **Custom Commands** - wiederverwendbare Slash-Befehle, die direkt in der OpenCode TUI verwendet werden können. Diese sind im `command/` Verzeichnis definiert.

### Was sind Custom Commands?

Custom Commands sind vordefinierte Prompts, die mit `/command-name` in der TUI ausgeführt werden können. Sie unterstützen:

- **Argumente**: `$ARGUMENTS` oder `$1`, `$2` für Positional-Parameter
- **Shell-Output**: `!befehl` für Command-Einbindung
- **Datei-Referenzen**: `@dateiname` für automatische Dateieinbindung
- **Agent-Targeting**: Spezifische Agenten für Aufgaben

### Beispiel-Struktur eines Commands:

```markdown
---
description: Generiert commit-Nachrichten nach Conventional Commits
agent: build
model: anthropic/claude-sonnet-4-20250514
---

Analysiere die git-Änderungen und erstelle eine Commit-Nachricht im Conventional Commits Format:

!`git status --porcelain`
!`git diff --cached`

Fokus auf:
- Typ (feat, fix, docs, style, refactor, test, chore)
- Klare Beschreibung der Änderungen
- breaking changes kennzeichnen
```

### Verfüg Commands

Das `command/` Verzeichnis enthält eine umfassende Sammlung von Commands:

**Entwicklungs-Workflow:**
- `/commit` - Commit-Nachrichten generieren
- `/create-pr` - Pull Requests erstellen  
- `/implement-task` - Entwicklungsaufgaben umsetzen
- `/check` - Code-Qualitätsprüfungen
- `/ruff-check` - Ruff Linting und Formatting

**Projekt-Management:**
- `/init-project` - Neue Projekte initialisieren
- `/create-plan` - Entwicklungspläne erstellen
- `/create-prd` - Product Requirements erstellen
- `/package-skill` - Skills paketieren

**Skill-Entwicklung:**
- `/build-skill` - Agent Skills bauen
- `/create-command` - Custom Commands erstellen

**Validierung:**
- `/check-commands` - Commands validieren
- `/check-agents` - Agenten validieren

## Weiterführende Dokumentation

### OpenCode Commands
- [OpenCode Commands Official Docs](https://opencode.ai/docs/commands/)
- [Command README](command/README.md) - Übersicht aller verfügbaren Commands
- [Command Quickstart](command/QUICKSTART.md) - Schnellstart für Custom Commands

### OpenCode Agents
- [OpenCode Agents Official Docs](https://opencode.ai/docs/agents/)
- [Tool Configuration](https://opencode.ai/docs/tools/)
- [Permission System](https://opencode.ai/docs/permissions/)
- [AI Agents Reference](../../../install/AI_AGENTS_REFERENCE.md)

### Beispiel-Commands
```bash
# In der OpenCode TUI verwenden
/commit                                    # Commit-Nachricht generieren
/create-pr                                 # Pull Request erstellen
/implement-task "Füge Benutzerauthentifizierung hinzu"  # Aufgabe umsetzen
/check                                    # Code-Qualitätsprüfung
/create-plan "Neues Feature"              # Entwicklungsplan erstellen
```
```

### 2. JSON-Konfiguration
Alternativ in `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "deutscher-dokumentations-agent": {
      "description": "Erstellt deutsche technische Dokumentation",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "Du bist ein technischer Redakteur für deutsche Dokumentation...",
      "tools": {
        "write": true,
        "edit": true,
        "bash": false
      }
    }
  }
}
```

## Konfigurationsoptionen

### Erforderliche Felder
- **description**: Kurze Beschreibung des Agentenzwecks

### Optionale Felder
- **mode**: `primary`, `subagent`, oder `all` (Standard: `all`)
- **model**: Modellspezifikation (z.B. `anthropic/claude-sonnet-4-20250514`)
- **temperature**: Zufälligkeit der Antworten (0.0-1.0)
- **maxSteps**: Maximale Anzahl an agenschen Iterationen
- **tools**: Welche Tools verfügbar sind
- **permission**: Berechtigungen für spezifische Aktionen

### Tool-Steuerung
```yaml
tools:
  write: true      # Dateien erstellen
  edit: true       # Dateien bearbeiten  
  bash: false      # Shell-Befehle deaktivieren
  read: true       # Dateien lesen
  webfetch: true   # Web-Inhalte abrufen
```

### Berechtigungs-Steuerung
```yaml
permission:
  edit: allow      # Bearbeitungen immer erlauben
  bash: 
    "git status": allow  # Spezifische Befehle erlauben
    "*": ask            # Alle anderen fragen
  webfetch: deny    # Web-Zugriff verweigern
```

## Konkretes Beispiel: Deutscher Dokumentations-Agent

Hier ist ein praktisches Beispiel für einen Agenten, der deutsche technische Dokumentation erstellt:

**Datei:** `agents/opencode/agent/deutscher-dokumentations-agent.md`

```yaml
---
description: Spezialisiert auf deutsche technische Dokumentation und Übersetzungen
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
tools:
  write: true
  edit: true
  read: true
  bash: false
permission:
  edit: allow
  bash: deny
  webfetch: allow
---

Du bist ein Experte für deutsche technische Dokumentation. Deine Hauptaufgaben:

## Kernaufgaben
1. **Erstellung** technischer Dokumentation auf Deutsch
2. **Übersetzung** englischer Tech-Dokumentation
3. **Pflege** bestehender deutscher Dokumentationen
4. **Qualitätssicherung** von deutschen Texten

## Stilrichtlinien
- Verwende präzise deutsche Fachterminologie
- Vermeide unnötige Anglizismen (nutze "Datenverarbeitung" statt "Data Processing")
- Schreibe in aktivem, direktem Stil
- Strukturiere Inhalte mit klaren Überschriften
- Füge praxisnahe Beispiele hinzu

## Terminologie-Beispiele
- "Dateisystem" statt "Filesystem"
- "Speicher" statt "Memory"  
- "Prozessor" statt "CPU"
- "Netzwerk" statt "Network"
- "Programmierschnittstelle" statt "API"

Beantworte Anfragen immer auf Deutsch und erstelle hochwertige technische Dokumentation.
```

## Verwendung der Agenten

### 1. Manuelles Aufrufen
```bash
# In OpenCode TUI
@deutscher-dokumentations-agent Erstelle eine README.md für dieses Projekt

# Analysieren ohne Änderungen
@plan Überprüfe die Codebasis und schlage Verbesserungen vor
```

### 2. Automatischer Aufruf
Primäre Agenten rufen automatisch Sub-Agenten auf, basierend auf deren Beschreibung und dem Kontext der Anfrage.

### 3. Agenten-Wechsel
- **Tab-Taste**: Zwischen primären Agenten wechseln
- **@-Erwähnung**: Spezifischen Sub-Agenten aufrufen

## Unterschied zu Claude Code Sub-Agents

| Feature | OpenCode Agenten | Claude Code Sub-Agents |
|---------|------------------|-----------------------|
| **Fokus** | Tool-gesteuerte Entwicklung | Chat-basierte Interaktion |
| **Konfiguration** | Markdown + JSON | Hauptsächlich YAML |
| **Tool-Steuerung** | Detaillierte Permissions | Begrenzte Steuerung |
| **Integration** | Tiefe IDE-Integration | Begrenzte IDE-Integration |
| **Modelle**| Flexible Modellwahl | Claude-spezifisch |

## Installation

Agenten werden automatisch aus dem `agent/`-Verzeichnis geladen. Stelle sicher, dass:

1. Die Dateien im richtigen Verzeichnis liegen: `~/.config/opencode/agent/` oder für dieses Projekt: `agents/opencode/agent/`
2. YAML-Frontmatter korrekt formatiert ist
3. Die Dateiendung `.md` hat

## Best Practices

1. **Spezifische Beschreibungen**: Klare, kurze Beschreibung des Zwecks
2. **Temperatur-Wahl**: 
   - `0.0-0.2` für Code-Analyse und Review
   - `0.3-0.5` für allgemeine Entwicklung
   - `0.6-1.0` für kreative Aufgaben
3. **Minimal Permissions**: Gib nur die notwendigen Rechte
4. **Modell-Auswahl**: Wandle leistungsfähige Modelle für komplexe Aufgaben
5. **Klare Prompts**: Detaillierte Anweisungen im Agenten-Prompt

## Custom Commands (Slash-Befehle)

Neben Agenten bietet OpenCode auch **Custom Commands** - wiederverwendbare Slash-Befehle, die direkt in der OpenCode TUI verwendet werden können. Diese sind im `command/` Verzeichnis definiert.

### Was sind Custom Commands?

Custom Commands sind vordefinierte Prompts, die mit `/command-name` in der TUI ausgeführt werden können. Sie unterstützen:

- **Argumente**: `$ARGUMENTS` oder `$1`, `$2` für Positional-Parameter
- **Shell-Output**: `!befehl` für Command-Einbindung
- **Datei-Referenzen**: `@dateiname` für automatische Dateieinbindung
- **Agent-Targeting**: Spezifische Agenten für Aufgaben

### Beispiel-Struktur eines Commands:

```markdown
---
description: Generiert commit-Nachrichten nach Conventional Commits
agent: build
model: anthropic/claude-sonnet-4-20250514
---

Analysiere die git-Änderungen und erstelle eine Commit-Nachricht im Conventional Commits Format:

!`git status --porcelain`
!`git diff --cached`

Fokus auf:
- Typ (feat, fix, docs, style, refactor, test, chore)
- Klare Beschreibung der Änderungen
- breaking changes kennzeichnen
```
