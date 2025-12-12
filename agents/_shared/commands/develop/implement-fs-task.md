---
description: Implementiere einen Filesystem-basierten Task mit Branch-Erstellung und PR
category: develop
argument-hint: "[task-NNN oder interaktive Auswahl]"
allowed-tools:
  - Read
  - Write
  - Edit
  - TodoWrite
  - AskUserQuestion
  - Glob
  - Bash
---

# Implement Filesystem Task

Automatisierte Umsetzung von Filesystem-basierten Tasks: Task auswählen, Branch erstellen, implementieren und Pull Request erstellen.

## Übersicht

Dieser Command orchestriert den kompletten Workflow von Task-Datei bis Pull Request:

1. **Task auswählen** - Aus `.plans/[feature]/tasks/` via Argument oder interaktiv
2. **Branch erstellen** - `task-NNN-description` vor Start
3. **Status aktualisieren** - Task auf "in_progress" setzen in Task-Datei
4. **Implementierung** - Code-Änderungen basierend auf Task-Beschreibung
5. **PR erstellen** - Pull Request mit Task-Verlinkung
6. **Finalisierung** - Task-Status auf "completed", STATUS.md aktualisieren

## Verwendung

```bash
# Mit Task-ID
/develop:implement-fs-task task-001

# Ohne Argument (interaktive Auswahl)
/develop:implement-fs-task

# Mit Plan-Kontext
/develop:implement-fs-task --plan dark-mode-toggle task-003
```

## Workflow

### 1. Task-Identifikation

**Argument vorhanden**:
- Task-ID validieren (z.B. `task-001`)
- Task-Datei finden in `.plans/*/tasks/`
- Bei mehreren Matches: Interaktive Auswahl

**Kein Argument**:
- Alle verfügbaren Pläne auflisten
- User wählt Plan aus
- Tasks mit Status "pending" anzeigen
- User wählt Task interaktiv aus

**Plan-Kontext vorhanden** (`--plan [feature-name]`):
- Direkt in `.plans/[feature-name]/tasks/` suchen
- Verfügbare Tasks mit Status "pending" anzeigen
- User wählt Task aus

### 2. Task-Daten einlesen

Folgende Informationen aus der Task-Datei extrahieren:

- **Titel & Beschreibung** - Für Branch-Name und Kontext
- **Metadata**:
  - ID (`task-NNN`)
  - Status (muss `pending` sein)
  - Priority (für Commit-Message)
  - Estimate (Story Points)
  - Labels (für Commit-Typ-Bestimmung)
  - Assignee
- **Akzeptanzkriterien** - Als Test-Plan-Checkliste
- **Dependencies** - Vor Start prüfen
- **Agent Recommendation** - Kann als Kontext verwendet werden

### 3. Dependency-Check

**Vor Implementierung prüfen**:
```markdown
## Dependencies
- **Requires**: task-001, task-002
- **Blocks**: task-005
```

**Validation**:
- Alle Required-Tasks müssen Status `completed` haben
- Falls nicht: Warnung anzeigen und User fragen:
  - Trotzdem fortfahren?
  - Anderen Task wählen?

### 4. Branch-Erstellung

**Branch-Naming-Schema**:
```text
task-NNN-short-description
```

**Beispiele**:
- `task-001` → `task-001-ui-toggle-component`
- `task-042` → `task-042-integration-test-suite`

**Slug-Generierung**:
- Aus Task-Dateiname extrahieren (bereits kebab-case)
- Falls nicht vorhanden: Aus Task-Titel generieren

**Vor Branch-Erstellung prüfen**:
- ✅ Working Directory sauber (git status)
- ✅ Aktueller Branch ist main/develop
- ✅ Remote ist up-to-date (git fetch)

### 5. Task-Status Update

Task-Datei aktualisieren:

**Vorher**:
```markdown
## Metadata
- **Status**: pending
- **Updated**: 2024-10-15
```

**Nachher**:
```markdown
## Metadata
- **Status**: in_progress
- **Updated**: 2024-11-18
```

**Zusätzlich**:
- Git-Änderung committen:
  ```bash
  git add .plans/[feature]/tasks/task-NNN-*.md
  git commit -m "🔄 chore: Start task-NNN implementation"
  ```

### 6. Implementierung

**Implementierungs-Strategie**:

1. **Task-Beschreibung analysieren**
   - Welche Dateien betroffen?
   - Welche Funktionalität hinzufügen/ändern?

2. **Akzeptanzkriterien als Checklist**
   - Schritt für Schritt abarbeiten
   - TodoWrite nutzen für Tracking

3. **Code-Änderungen durchführen**
   - Basierend auf Task-Beschreibung
   - Agent-Empfehlung berücksichtigen (falls vorhanden)

4. **Tests schreiben**
   - Unit Tests für Akzeptanzkriterien
   - Integration Tests falls nötig

**Labels → Commit-Typ Mapping**:
- `bug`, `fix` → 🐛 fix
- `feature`, `enhancement` → ✨ feat
- `docs`, `documentation` → 📚 docs
- `refactor` → ♻️ refactor
- `performance` → ⚡ perf
- `test` → 🧪 test
- Default: ✨ feat

### 7. PR-Erstellung

**PR-Template mit Task-Integration**:

```markdown
## Task: task-NNN - [Task-Titel]

**Plan**: [feature-name]
**Task-Datei**: `.plans/[feature-name]/tasks/task-NNN-*.md`

**Beschreibung**:
<Task-Beschreibung aus Task-Datei>

**Änderungen**:
- <Änderung 1>
- <Änderung 2>

**Test-Plan**:
<Akzeptanzkriterien aus Task-Datei als Checkboxen>

**Story Points**: <Estimate>
**Priority**: <Priority>

**Status**: in_progress → completed
```

**PR-Labels** (basierend auf Task-Labels):
- Task hat `bug` → PR bekommt `bug`
- Task hat `feature` → PR bekommt `enhancement`
- Task hat `docs` → PR bekommt `documentation`

### 8. Finalisierung (OBLIGATORISCH)

> ⚠️ **WICHTIG**: Dieser Schritt ist NICHT optional! Nach jeder PR-Erstellung MÜSSEN die folgenden Aktionen durchgeführt werden.

**Nach PR-Erstellung IMMER ausführen**:

#### 8.1 Task-Status auf `completed` setzen

Die Task-Datei aktualisieren:

```markdown
## Metadata
- **Status**: completed
- **Updated**: <aktuelles Datum>
```

**Konkrete Schritte**:
1. Task-Datei öffnen: `.plans/[feature]/tasks/task-NNN-*.md`
2. Status von `in_progress` auf `completed` ändern
3. Updated-Datum auf heute setzen

#### 8.2 STATUS.md aktualisieren

Die STATUS.md MUSS folgende Änderungen enthalten:

1. **Progress Overview aktualisieren**:
   - `Completed` Zähler erhöhen
   - `In Progress` Zähler verringern
   - Prozentsätze neu berechnen

2. **Task in korrekter Sektion verschieben**:
   - Von "In Progress 🚧" nach "Completed ✅" verschieben
   - Checkbox von `[ ]` auf `[x]` ändern

3. **Last Updated Datum aktualisieren**

**Beispiel-Änderungen in STATUS.md**:
```markdown
# Vorher:
- **Completed**: 0 (0%)
- **In Progress**: 1 (9%)

# Nachher:
- **Completed**: 1 (9%)
- **In Progress**: 0 (0%)
```

#### 8.3 Finaler Commit

```bash
git add .plans/[feature]/tasks/task-NNN-*.md
git add .plans/[feature]/STATUS.md
git commit -m "✅ chore: Mark task-NNN as completed"
git push
```

#### 8.4 Checkliste Finalisierung

Vor Abschluss des Commands verifizieren:

- [ ] Task-Datei: Status = `completed`
- [ ] Task-Datei: Updated = aktuelles Datum
- [ ] STATUS.md: Progress-Zahlen korrekt
- [ ] STATUS.md: Task in "Completed ✅" Sektion
- [ ] STATUS.md: Last Updated = aktuelles Datum
- [ ] Git: Änderungen committed und gepusht

## Konfiguration

### Filesystem-basierte Tasks

**Erforderlich**: Tasks müssen via `/project:create-plan-fs` erstellt sein.

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

**Validierung**:
- Task-Datei muss alle Metadata-Felder haben
- Status muss `pending` sein (sonst Warnung)
- Akzeptanzkriterien müssen definiert sein

### Git-Konfiguration

**Branch-Strategie**:
- Base-Branch: `main` oder `develop` (auto-detect)
- Task-Branches: `task-NNN-description`
- Merge-Strategie: Pull Request (GitHub/GitLab)

## Error Handling

**Task nicht gefunden**:
- Validierung der Task-ID
- Suche in allen `.plans/*/tasks/`
- Alternative Tasks vorschlagen
- Abbruch mit klarer Fehlermeldung

**Branch existiert bereits**:
- Warnung anzeigen
- Option zum Wechseln oder neuen Branch erstellen
- Bestehenden Branch aktualisieren?

**Dependencies nicht erfüllt**:
- Liste der Required-Tasks mit Status anzeigen
- User-Entscheidung: Fortfahren oder abbrechen?
- Rationale für Abhängigkeiten erklären

**Task bereits in Bearbeitung** (Status `in_progress`):
- Warnung anzeigen
- User fragen: Trotzdem fortfahren oder anderen Task wählen?

## Detail-Dokumentation

Für weiterführende Informationen siehe:

- **[workflow.md](../../references/implement-fs-task/workflow.md)** - Detaillierter Workflow mit Beispielen
- **[task-management.md](../../references/implement-fs-task/task-management.md)** - Task-Status-Updates, STATUS.md Regenerierung
- **[best-practices.md](../../references/implement-fs-task/best-practices.md)** - Branch-Naming, Commit-Messages, PR-Gestaltung
- **[troubleshooting.md](../../references/implement-fs-task/troubleshooting.md)** - Häufige Probleme, Lösungen, Debugging

## Beispiele

### Vollständiger Workflow

```bash
# Command aufrufen
/develop:implement-fs-task task-001

# Claude:
# ✅ Task task-001 gefunden: "UI Toggle Component"
# ✅ Plan: dark-mode-toggle
# ✅ Dependencies erfüllt
# ✅ Branch erstellt: task-001-ui-toggle-component
# ✅ Task-Status: pending → in_progress
# 🔄 Implementierung startet...
# ✅ Code-Änderungen durchgeführt
# ✅ Tests geschrieben (3/3 Akzeptanzkriterien erfüllt)
# ✅ PR erstellt: #456
# ✅ Task-Status: in_progress → completed
# ✅ STATUS.md aktualisiert
```

### Interaktive Task-Auswahl

```bash
# Command ohne Argument
/develop:implement-fs-task

# Claude:
# Verfügbare Pläne:
# 1. dark-mode-toggle (5 pending tasks)
# 2. user-authentication (8 pending tasks)
# 3. api-rate-limiting (3 pending tasks)
# Welchen Plan möchten Sie bearbeiten? [1-3]:

# User wählt: 1

# Claude:
# Pending Tasks in "dark-mode-toggle":
# 1. task-001 - UI Toggle Component (3 SP) [Must-Have]
# 2. task-002 - Theme State Management (5 SP) [Must-Have]
# 3. task-003 - CSS Variables Setup (2 SP) [Should-Have]
# Welchen Task möchten Sie implementieren? [1-3]:
```

## Integration mit anderen Commands

**Verwandte Commands**:
- **[/project:create-plan-fs](../project/create-plan-fs.md)** - Plan-Erstellung
- **[/commit](./commit.md)** - Professionelle Git-Commits (wird automatisch genutzt)
- **[/create-pr](./create-pr.md)** - PR-Erstellung (wird automatisch genutzt)

**Workflow-Integration**:
1. PRD erstellen: `/project:create-prd`
2. Plan erstellen: `/project:create-plan-fs`
3. Tasks implementieren: `/develop:implement-fs-task` (dieser Command)
4. Review: Code-Reviewer Agent
5. Merge & Deploy

## Siehe auch

- **[Linear-basierte Implementation](./implement-linear-task.md)** - Alternative mit Linear-Integration
- **[Filesystem-basierte Planung](../project/create-plan-fs.md)** - Task-Struktur-Details

---

**Arguments**: $ARGUMENTS
