---
description: Implementiere Task mit Branch-Erstellung und PR (Filesystem oder Linear)
category: develop
argument-hint: "[task-ID] [--linear]"
allowed-tools:
  - Read
  - Write
  - Edit
  - TodoWrite
  - AskUserQuestion
  - Glob
  - Bash
---

# Implement Task

Automatisierte Umsetzung von Tasks: Task auswählen, Branch erstellen, implementieren und Pull Request erstellen.

## Übersicht

Dieser Command orchestriert den kompletten Workflow von Task bis Pull Request:

1. **Task auswählen** - Aus Filesystem oder Linear (via `--linear` Flag)
2. **Branch erstellen** - Automatisch basierend auf Task-ID
3. **Status aktualisieren** - Task auf "In Progress" setzen
4. **Implementierung** - Code-Änderungen basierend auf Task-Beschreibung
5. **PR erstellen** - Pull Request mit Task-Verlinkung
6. **Finalisierung** - Task-Status auf "Completed", Tracking aktualisieren

## Verwendung

```bash
# Filesystem-basiert (Standard)
/develop:implement-task              # Interaktive Auswahl
/develop:implement-task task-001     # Mit Task-ID
/develop:implement-task --plan dark-mode task-003  # Mit Plan-Kontext

# Linear-basiert
/develop:implement-task --linear           # Interaktive Auswahl
/develop:implement-task --linear PROJ-123  # Mit Issue-ID
```

## Provider-Auswahl

### Filesystem (Standard)

**Wann verwenden**: Tasks wurden via `/create-plan` erstellt und liegen in `.plans/*/tasks/`.

**Erwartete Struktur**:
```
.plans/[feature-name]/
├── EPIC.md
├── STATUS.md
└── tasks/
    ├── task-001-*.md
    ├── task-002-*.md
    └── ...
```

### Linear (`--linear`)

**Wann verwenden**: Tasks werden in Linear verwaltet.

**Voraussetzung**: Linear MCP Server muss konfiguriert sein.

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": { "LINEAR_API_KEY": "<your-api-key>" }
    }
  }
}
```

## Gemeinsamer Workflow

### 1. Task-Identifikation

**Mit Argument**: Task-ID validieren und abrufen
**Ohne Argument**: Verfügbare Tasks auflisten, User wählt interaktiv

### 2. Task-Daten einlesen

Folgende Informationen extrahieren:
- **Titel & Beschreibung** - Für Branch-Name und Kontext
- **Labels/Tags** - Für Commit-Typ-Bestimmung
- **Status** - Muss "pending" / "Backlog" sein
- **Akzeptanzkriterien** - Als Test-Plan-Checkliste
- **Dependencies** - Vor Start prüfen (nur Filesystem)

### 3. Branch-Erstellung

**Einheitliches Format für alle Provider**:

```
feature/<ISSUE-ID>-<description>
```

| Provider | Beispiel |
|----------|----------|
| Filesystem | `feature/task-001-ui-toggle-component` |
| Linear | `feature/proj-123-user-auth` |

**Vor Branch-Erstellung prüfen**:
- ✅ Working Directory sauber (git status)
- ✅ Aktueller Branch ist main/develop
- ✅ Remote ist up-to-date (git fetch)

### 4. Status-Update

| Provider | Transition |
|----------|------------|
| Filesystem | `pending` → `in_progress` in Task-Datei |
| Linear | `Backlog` → `In Progress` via MCP |

### 5. Implementierung

1. **Task-Beschreibung analysieren** - Betroffene Dateien identifizieren
2. **Akzeptanzkriterien als Checklist** - Schritt für Schritt abarbeiten
3. **Code-Änderungen durchführen** - Basierend auf Task-Beschreibung
4. **Tests schreiben** - Unit/Integration Tests für Akzeptanzkriterien

**Labels → Commit-Typ Mapping**:
- `bug`, `fix` → 🐛 fix
- `feature`, `enhancement` → ✨ feat
- `docs`, `documentation` → 📚 docs
- `refactor` → ♻️ refactor
- `performance` → ⚡ perf
- `test` → 🧪 test
- Default: ✨ feat

### 6. PR-Erstellung

PR mit Task-Verlinkung erstellen:
- Titel: Task-Titel
- Body: Beschreibung, Änderungen, Test-Plan
- Labels: Basierend auf Task-Labels

### 7. Finalisierung (OBLIGATORISCH)

> ⚠️ **WICHTIG**: Dieser Schritt ist NICHT optional!

| Provider | Aktionen |
|----------|----------|
| Filesystem | Task-Status → `completed`, STATUS.md aktualisieren |
| Linear | Issue-Status → `In Review` oder `Done` via MCP |

## Error Handling

- **Task nicht gefunden**: Validierung, Alternativen vorschlagen
- **Branch existiert bereits**: Warnung, Option zum Wechseln
- **Dependencies nicht erfüllt** (FS): Liste anzeigen, User-Entscheidung
- **Linear MCP nicht verfügbar**: Fehlermeldung mit Setup-Anleitung

## Detail-Dokumentation

### Allgemein
- **[workflow.md](../references/implement-task/workflow.md)** - Detaillierter Workflow mit Beispielen
- **[best-practices.md](../references/implement-task/best-practices.md)** - Branch-Naming, Commits, PR-Gestaltung
- **[troubleshooting.md](../references/implement-task/troubleshooting.md)** - Häufige Probleme und Lösungen

### Provider-spezifisch
- **[filesystem.md](../references/implement-task/filesystem.md)** - Filesystem-Tasks, STATUS.md
- **[linear.md](../references/implement-task/linear.md)** - Linear MCP Setup, API-Details

## Siehe auch

- **[/create-plan](./create-plan.md)** - Projektplanung (Filesystem/Linear)
- **[/commit](./commit.md)** - Professionelle Git-Commits
- **[/create-pr](./create-pr.md)** - Pull Request-Erstellung

---

**Arguments**: $ARGUMENTS

