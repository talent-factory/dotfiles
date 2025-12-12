# Workflow: Task Implementation

Detaillierter Workflow für die Implementierung von Tasks (Filesystem oder Linear).

## Übersicht

Der Workflow ist in 7 Phasen unterteilt:

```
1. Task-Identifikation
   ↓
2. Task-Daten einlesen
   ↓
3. Branch-Erstellung
   ↓
4. Task-Status Update
   ↓
5. Implementierung
   ↓
6. PR-Erstellung
   ↓
7. Finalisierung
```

## Phase 1: Task-Identifikation

### Mit Task-ID Argument

**Filesystem**: `/develop:implement-task task-001`
**Linear**: `/develop:implement-task --linear PROJ-123`

**Workflow**:
1. Task-ID parsen und validieren
2. Task abrufen (Filesystem: `.plans/*/tasks/`, Linear: MCP)
3. Bei mehreren Matches: Interaktive Auswahl

### Ohne Argument (Interaktiv)

**Filesystem**: `/develop:implement-task`
**Linear**: `/develop:implement-task --linear`

**Workflow**:
1. Verfügbare Tasks auflisten
2. User wählt Task aus
3. Task-Daten laden

### Validierungs-Checks

- ✅ Task existiert
- ✅ Task ist nicht bereits abgeschlossen
- ✅ Task hat validen Status (pending/Backlog)
- ✅ Dependencies erfüllt (nur Filesystem)

## Phase 2: Task-Daten einlesen

### Gemeinsame Daten

| Feld | Filesystem | Linear |
|------|------------|--------|
| Titel | Aus Markdown | `issue.title` |
| Beschreibung | `## Description` | `issue.description` |
| Labels | `**Labels**:` | `issue.labels.nodes` |
| Status | `**Status**:` | `issue.state.name` |
| Akzeptanzkriterien | `## Acceptance Criteria` | Aus Description parsen |

### Datenstruktur

```python
task = {
    "id": "task-001" | "PROJ-123",
    "title": "UI Toggle Component",
    "description": "...",
    "status": "pending" | "Backlog",
    "labels": ["feature", "ui"],
    "acceptance_criteria": [
        "Toggle button renders correctly",
        "State persists in localStorage"
    ],
    "provider": "filesystem" | "linear"
}
```

## Phase 3: Branch-Erstellung

### Branch-Naming

**Einheitliches Format für alle Provider**:

```
feature/<ISSUE-ID>-<description>
```

| Provider | Beispiel |
|----------|----------|
| Filesystem | `feature/task-001-ui-toggle-component` |
| Linear | `feature/proj-123-user-authentication` |

### Pre-Branch-Checks

```bash
# 1. Working Directory sauber?
git status --porcelain

# 2. Auf main/develop?
git branch --show-current

# 3. Remote up-to-date?
git fetch origin
```

### Branch erstellen

```bash
# Filesystem
git checkout -b feature/task-001-ui-toggle-component

# Linear
git checkout -b feature/proj-123-user-authentication
```

## Phase 4: Task-Status Update

### Filesystem

```markdown
# Vorher
- **Status**: pending

# Nachher
- **Status**: in_progress
- **Updated**: 2024-11-18
```

**Commit**: `🔄 chore: Start task-001 implementation`

### Linear

Via MCP: `linear_update_issue_state()` → "In Progress"

**Optional Comment**: 
```markdown
🚀 Implementation gestartet in Branch: `feature/proj-123-...`
```

## Phase 5: Implementierung

### Strategie

1. **Task-Beschreibung analysieren** - Betroffene Dateien identifizieren
2. **Akzeptanzkriterien als Checklist** - TodoWrite nutzen
3. **Code-Änderungen durchführen** - Basierend auf Beschreibung
4. **Tests schreiben** - Unit/Integration Tests

### Labels → Commit-Typ Mapping

```python
label_to_commit = {
    "bug": "🐛 fix",
    "feature": "✨ feat",
    "docs": "📚 docs",
    "refactor": "♻️ refactor",
    "performance": "⚡ perf",
    "test": "🧪 test"
}
```

### Atomare Commits

```bash
# Commit 1: Feature
git commit -m "✨ feat: Add ThemeToggle component"

# Commit 2: Tests
git commit -m "🧪 test: Add ThemeToggle tests"
```

## Phase 6: PR-Erstellung

### PR-Body Template

```markdown
## Task: [ID] - [Titel]

**Beschreibung**:
<Task-Beschreibung>

**Änderungen**:
- <Änderung 1>
- <Änderung 2>

**Test-Plan**:
- [x] <Akzeptanzkriterium 1>
- [x] <Akzeptanzkriterium 2>

**Status**: In Progress → Completed/In Review
```

### PR erstellen

```bash
git push -u origin <branch-name>
gh pr create --title "[ID]: [Titel]" --body "..."
```

## Phase 7: Finalisierung

### Filesystem

1. Task-Status → `completed`
2. STATUS.md aktualisieren
3. Commit: `✅ chore: Mark task-001 as completed`

### Linear

1. Issue-Status → `In Review` oder `Done`
2. Optional: PR-Link als Comment

## Siehe auch

- [filesystem.md](./filesystem.md) - Filesystem-spezifische Details
- [linear.md](./linear.md) - Linear-spezifische Details
- [best-practices.md](./best-practices.md) - Best Practices
- [troubleshooting.md](./troubleshooting.md) - Problemlösungen

