# Workflow: Filesystem Task Implementation

Detaillierter Workflow für die Implementierung von Filesystem-basierten Tasks.

## Übersicht

Der Workflow ist in 8 Phasen unterteilt:

```
1. Task-Identifikation
   ↓
2. Task-Daten einlesen
   ↓
3. Dependency-Check
   ↓
4. Branch-Erstellung
   ↓
5. Task-Status Update (pending → in_progress)
   ↓
6. Implementierung
   ↓
7. PR-Erstellung
   ↓
8. Finalisierung (in_progress → completed)
```

## Phase 1: Task-Identifikation

### Szenario A: Task-ID als Argument

**Command**: `/develop:implement-fs-task task-001`

**Workflow**:
1. Task-ID parsen (`task-001`)
2. In allen `.plans/*/tasks/` Verzeichnissen suchen
3. Matches finden:
   - Genau 1 Match → Direkt verwenden
   - Mehrere Matches → Interaktive Auswahl anbieten
   - Keine Matches → Fehler anzeigen, alternative Tasks vorschlagen

**Beispiel**:
```bash
# Suche nach task-001
find .plans -type f -name "task-001-*.md"

# Ergebnis:
.plans/dark-mode-toggle/tasks/task-001-ui-toggle-component.md
.plans/user-authentication/tasks/task-001-login-form.md

# → Interaktive Auswahl:
# 1. dark-mode-toggle: UI Toggle Component
# 2. user-authentication: Login Form
# Welchen Task möchten Sie implementieren? [1-2]:
```

### Szenario B: Kein Argument (Interaktiv)

**Command**: `/develop:implement-fs-task`

**Workflow**:
1. Alle Pläne finden:
   ```bash
   find .plans -maxdepth 1 -type d -not -name ".plans"
   ```

2. Für jeden Plan: Pending Tasks zählen
   ```bash
   grep -l "Status: pending" .plans/*/tasks/*.md | wc -l
   ```

3. Plan-Übersicht anzeigen:
   ```
   Verfügbare Pläne:
   1. dark-mode-toggle (5 pending, 2 in progress, 1 completed)
   2. user-authentication (8 pending, 0 in progress, 0 completed)
   3. api-rate-limiting (3 pending, 1 in progress, 2 completed)
   ```

4. User wählt Plan (z.B. `1`)

5. Tasks in ausgewähltem Plan anzeigen (nur Status `pending`):
   ```
   Pending Tasks in "dark-mode-toggle":
   1. task-001 - UI Toggle Component (3 SP) [Must-Have]
   2. task-002 - Theme State Management (5 SP) [Must-Have]
   3. task-003 - CSS Variables Setup (2 SP) [Should-Have]
   ```

6. User wählt Task (z.B. `1`)

### Szenario C: Mit Plan-Kontext

**Command**: `/develop:implement-fs-task --plan dark-mode-toggle`

**Workflow**:
1. Plan-Name validieren
   ```bash
   test -d .plans/dark-mode-toggle
   ```

2. Falls vorhanden: Tasks in Plan anzeigen (nur `pending`)
3. User wählt Task aus

**Optional**: Task-ID direkt angeben
```bash
/develop:implement-fs-task --plan dark-mode-toggle task-003
```

## Phase 2: Task-Daten einlesen

**Task-Datei**: `.plans/[plan]/tasks/task-NNN-description.md`

### Parsing-Strategie

**Metadata extrahieren** (YAML-Style):
```bash
# Status
grep "^\*\*Status\*\*:" task-001-ui-toggle.md
# → - **Status**: pending

# Priority
grep "^\*\*Priority\*\*:" task-001-ui-toggle.md
# → - **Priority**: must

# Estimate
grep "^\*\*Estimate\*\*:" task-001-ui-toggle.md
# → - **Estimate**: 3 Story Points

# Labels
grep "^\*\*Labels\*\*:" task-001-ui-toggle.md
# → - **Labels**: [feature, ui, react]
```

### Datenstruktur aufbauen

```python
task = {
    "id": "task-001",
    "title": "UI Toggle Component",
    "file_path": ".plans/dark-mode-toggle/tasks/task-001-ui-toggle-component.md",
    "plan": "dark-mode-toggle",
    "status": "pending",
    "priority": "must",
    "estimate": 3,
    "labels": ["feature", "ui", "react"],
    "assignee": "Claude",
    "description": "...",
    "acceptance_criteria": [
        "Toggle button renders correctly",
        "State persists in localStorage",
        "Theme switches on click"
    ],
    "dependencies": {
        "requires": [],
        "blocks": ["task-005"]
    },
    "agent_recommendation": "frontend-developer"
}
```

### Akzeptanzkriterien extrahieren

**Pattern**: Checkbox-Liste unter `## Acceptance Criteria`

```bash
# Extrahiere alle Checkboxen
sed -n '/## Acceptance Criteria/,/##/p' task-001-*.md | grep "^- \[ \]"

# Output:
- [ ] Toggle button renders correctly
- [ ] State persists in localStorage
- [ ] Theme switches on click
```

### Dependencies extrahieren

**Format**:
```markdown
## Dependencies

- **Requires**: task-001, task-003
- **Blocks**: task-005, task-008
```

**Parsing**:
```bash
# Requires
grep "Requires:" task-001-*.md | sed 's/.*Requires: //' | tr ',' '\n'

# Blocks
grep "Blocks:" task-001-*.md | sed 's/.*Blocks: //' | tr ',' '\n'
```

## Phase 3: Dependency-Check

### Required-Tasks validieren

**Für jeden Required-Task**:
1. Task-Datei finden
2. Status auslesen
3. Prüfen ob `completed`

**Beispiel**:
```bash
# Task-001 requires task-003
task_file=".plans/dark-mode-toggle/tasks/task-003-css-variables.md"

# Status prüfen
status=$(grep "**Status**:" "$task_file" | awk '{print $3}')

if [ "$status" != "completed" ]; then
  echo "❌ Dependency not met: task-003 is $status"
fi
```

### User-Interaktion bei unerfüllten Dependencies

**Warnung anzeigen**:
```
⚠️ Dependencies not fully met:

Required Tasks:
- task-003 (CSS Variables Setup): in_progress
- task-004 (Theme Context): pending

Blocked Tasks:
- task-005 (Integration): waiting for this task

Options:
1. Continue anyway (not recommended)
2. Choose another task
3. Abort

Your choice [1-3]:
```

**Empfehlung**: Option 2 oder 3 wählen

## Phase 4: Branch-Erstellung

### Branch-Name generieren

**Schema**: `task-NNN-short-description`

**Strategie 1**: Aus Dateinamen extrahieren
```bash
file="task-001-ui-toggle-component.md"
branch_name="${file%.md}"  # Entferne .md
# → task-001-ui-toggle-component
```

**Strategie 2**: Aus Task-Titel generieren
```bash
title="UI Toggle Component"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
branch_name="task-001-$slug"
# → task-001-ui-toggle-component
```

### Pre-Branch-Checks

**1. Working Directory sauber**:
```bash
git_status=$(git status --porcelain)
if [ -n "$git_status" ]; then
  echo "❌ Working directory not clean!"
  echo "$git_status"
  exit 1
fi
```

**2. Aktueller Branch ist main/develop**:
```bash
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ] && [ "$current_branch" != "develop" ]; then
  echo "⚠️ Not on main/develop. Current: $current_branch"
  echo "Switch to main/develop first? [y/n]:"
fi
```

**3. Remote up-to-date**:
```bash
git fetch origin
local_hash=$(git rev-parse @)
remote_hash=$(git rev-parse @{u})

if [ "$local_hash" != "$remote_hash" ]; then
  echo "⚠️ Local branch is out of sync with remote"
  echo "Pull changes first? [y/n]:"
fi
```

### Branch erstellen

```bash
branch_name="task-001-ui-toggle-component"

# Branch erstellen und wechseln
git checkout -b "$branch_name"

# Bestätigung
echo "✅ Branch erstellt: $branch_name"
git branch --show-current
```

## Phase 5: Task-Status Update (pending → in_progress)

### Task-Datei modifizieren

**Vorher**:
```markdown
## Metadata
- **ID**: task-001
- **Status**: pending
- **Priority**: must
- **Estimate**: 3 Story Points
- **Labels**: [feature, ui, react]
- **Assignee**: Claude
- **Created**: 2024-11-15
- **Updated**: 2024-11-15
```

**Nachher**:
```markdown
## Metadata
- **ID**: task-001
- **Status**: in_progress
- **Priority**: must
- **Estimate**: 3 Story Points
- **Labels**: [feature, ui, react]
- **Assignee**: Claude
- **Created**: 2024-11-15
- **Updated**: 2024-11-18
```

**Änderungen**:
1. `Status: pending` → `Status: in_progress`
2. `Updated: 2024-11-15` → `Updated: 2024-11-18` (aktuelles Datum)

### Edit-Command verwenden

```bash
# Mit Edit-Tool
old_string="- **Status**: pending"
new_string="- **Status**: in_progress"

edit_file task_file old_string new_string

# Updated-Datum aktualisieren
old_date="- **Updated**: 2024-11-15"
new_date="- **Updated**: $(date +%Y-%m-%d)"

edit_file task_file old_date new_date
```

### Commit der Status-Änderung

```bash
git add .plans/dark-mode-toggle/tasks/task-001-ui-toggle-component.md
git commit -m "🔄 chore: Start task-001 implementation"
```

**Rationale**: Separater Commit für Status-Update, unabhängig von Code-Änderungen

## Phase 6: Implementierung

### Implementierungs-Strategie

**1. Task-Beschreibung analysieren**

Aus Task-Datei extrahieren:
```markdown
## Description

Create a reusable toggle button component for dark mode switching.
The component should:
- Render a sun/moon icon based on current theme
- Toggle theme on click
- Persist theme preference in localStorage
- Support keyboard navigation (Enter/Space)
```

**Ableitungen**:
- Welche Dateien: `components/ThemeToggle.tsx`
- Welche Dependencies: React, localStorage API
- Welche Tests: Unit tests für Render, Click, Persistence

**2. Akzeptanzkriterien als Checklist**

```bash
# TodoWrite nutzen
todos = [
  "Toggle button renders correctly",
  "State persists in localStorage",
  "Theme switches on click"
]
```

**3. Code-Änderungen durchführen**

**Beispiel**:
```typescript
// components/ThemeToggle.tsx
import { useState, useEffect } from 'react';

export function ThemeToggle() {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    // Akzeptanzkriterium 2: Persistence
    const saved = localStorage.getItem('theme');
    if (saved) setTheme(saved as 'light' | 'dark');
  }, []);

  const toggle = () => {
    // Akzeptanzkriterium 3: Theme switches
    const newTheme = theme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
    localStorage.setItem('theme', newTheme);
  };

  // Akzeptanzkriterium 1: Renders correctly
  return (
    <button onClick={toggle}>
      {theme === 'light' ? '🌙' : '☀️'}
    </button>
  );
}
```

**4. Tests schreiben**

```typescript
// components/ThemeToggle.test.tsx
import { render, fireEvent } from '@testing-library/react';
import { ThemeToggle } from './ThemeToggle';

describe('ThemeToggle', () => {
  it('renders correctly', () => {
    const { getByRole } = render(<ThemeToggle />);
    expect(getByRole('button')).toBeInTheDocument();
  });

  it('switches theme on click', () => {
    const { getByRole } = render(<ThemeToggle />);
    const button = getByRole('button');

    fireEvent.click(button);
    expect(button.textContent).toBe('☀️');
  });

  it('persists theme in localStorage', () => {
    const { getByRole } = render(<ThemeToggle />);
    fireEvent.click(getByRole('button'));

    expect(localStorage.getItem('theme')).toBe('dark');
  });
});
```

### Labels → Commit-Typ Mapping

**Aus Task-Labels ableiten**:

```python
labels = ["feature", "ui", "react"]

# Mapping
label_to_commit_type = {
    "bug": "🐛 fix",
    "fix": "🐛 fix",
    "feature": "✨ feat",
    "enhancement": "✨ feat",
    "docs": "📚 docs",
    "documentation": "📚 docs",
    "refactor": "♻️ refactor",
    "performance": "⚡ perf",
    "test": "🧪 test",
    "style": "💎 style",
}

# Bestimme Commit-Typ
commit_type = "✨ feat"  # Default
for label in labels:
    if label in label_to_commit_type:
        commit_type = label_to_commit_type[label]
        break
```

### Commits während Implementierung

**Best Practice**: Atomare Commits pro logischer Einheit

```bash
# Commit 1: Component erstellt
git add components/ThemeToggle.tsx
git commit -m "✨ feat: Add ThemeToggle component"

# Commit 2: Tests hinzugefügt
git add components/ThemeToggle.test.tsx
git commit -m "🧪 test: Add ThemeToggle tests"

# Commit 3: Integration
git add components/Layout.tsx
git commit -m "✨ feat: Integrate ThemeToggle in Layout"
```

**Alternative**: Squash später beim PR (empfohlen)

## Phase 7: PR-Erstellung

### PR-Body generieren

**Template**:
```markdown
## Task: task-001 - UI Toggle Component

**Plan**: dark-mode-toggle
**Task-Datei**: `.plans/dark-mode-toggle/tasks/task-001-ui-toggle-component.md`

**Beschreibung**:
Create a reusable toggle button component for dark mode switching.
The component should render a sun/moon icon, toggle theme on click,
and persist theme preference in localStorage.

**Änderungen**:
- Neue Komponente `ThemeToggle.tsx` erstellt
- Unit Tests in `ThemeToggle.test.tsx` hinzugefügt
- Integration in `Layout.tsx`

**Test-Plan**:
- [x] Toggle button renders correctly
- [x] State persists in localStorage
- [x] Theme switches on click

**Story Points**: 3
**Priority**: must

**Status**: in_progress → completed
```

### PR erstellen mit GitHub CLI

```bash
# Branch pushen
git push -u origin task-001-ui-toggle-component

# PR erstellen
gh pr create \
  --title "task-001: UI Toggle Component" \
  --body "$(cat pr-body.md)" \
  --label "feature,ui" \
  --base develop
```

### PR-Labels aus Task-Labels ableiten

```python
task_labels = ["feature", "ui", "react"]

# Mapping Task-Labels → PR-Labels
label_mapping = {
    "bug": "bug",
    "fix": "bug",
    "feature": "enhancement",
    "enhancement": "enhancement",
    "docs": "documentation",
    "documentation": "documentation",
    "ui": "ui",
    "react": "react",
}

pr_labels = []
for label in task_labels:
    if label in label_mapping:
        pr_labels.append(label_mapping[label])

# → pr_labels = ["enhancement", "ui", "react"]
```

## Phase 8: Finalisierung

### Task-Status Update (in_progress → completed)

**Task-Datei aktualisieren**:
```bash
# Status ändern
old_string="- **Status**: in_progress"
new_string="- **Status**: completed"
edit_file task_file old_string new_string

# Updated-Datum aktualisieren
old_date="- **Updated**: 2024-11-18"
new_date="- **Updated**: $(date +%Y-%m-%d)"
edit_file task_file old_date new_date
```

### STATUS.md regenerieren

Siehe [task-management.md](./task-management.md) für Details.

**Kurz**:
1. Alle Tasks im Plan einlesen
2. Progress-Zahlen neu berechnen:
   - Total Tasks
   - Completed (%)
   - In Progress
   - Pending
   - Blocked
3. STATUS.md neu schreiben mit aktualisierten Zahlen

### Finaler Commit

```bash
git add .plans/dark-mode-toggle/tasks/task-001-ui-toggle-component.md
git add .plans/dark-mode-toggle/STATUS.md
git commit -m "✅ chore: Mark task-001 as completed"

# Push
git push
```

### Optional: EPIC.md aktualisieren

Falls EPIC.md einen Progress-Tracker hat:

```markdown
## Progress

- **Total Tasks**: 8
- **Completed**: 1 (12.5%)
- **In Progress**: 0
- **Pending**: 7
```

## Vollständiges Beispiel

```bash
# Command: /develop:implement-fs-task task-001

# Phase 1: Task-Identifikation
✅ Task task-001 gefunden in .plans/dark-mode-toggle/tasks/
✅ Task-Titel: UI Toggle Component

# Phase 2: Task-Daten einlesen
✅ Status: pending
✅ Priority: must
✅ Estimate: 3 Story Points
✅ Labels: [feature, ui, react]
✅ Akzeptanzkriterien: 3 items

# Phase 3: Dependency-Check
✅ No required dependencies
✅ Blocks: task-005 (will be unblocked)

# Phase 4: Branch-Erstellung
✅ Working directory clean
✅ Current branch: develop
✅ Remote up-to-date
✅ Branch erstellt: task-001-ui-toggle-component

# Phase 5: Task-Status Update
✅ Status: pending → in_progress
✅ Updated: 2024-11-18
✅ Committed: "🔄 chore: Start task-001 implementation"

# Phase 6: Implementierung
🔄 Creating ThemeToggle component...
✅ Component created: components/ThemeToggle.tsx
🔄 Writing tests...
✅ Tests created: components/ThemeToggle.test.tsx
✅ All acceptance criteria met (3/3)

# Phase 7: PR-Erstellung
✅ Branch pushed: task-001-ui-toggle-component
✅ PR created: #456
✅ Labels: enhancement, ui, react

# Phase 8: Finalisierung
✅ Status: in_progress → completed
✅ STATUS.md updated
✅ Committed: "✅ chore: Mark task-001 as completed"
✅ Pushed to remote

🎉 Task task-001 erfolgreich implementiert!

PR: https://github.com/org/repo/pull/456
```

## Siehe auch

- [task-management.md](./task-management.md) - STATUS.md Regenerierung
- [best-practices.md](./best-practices.md) - Best Practices
- [troubleshooting.md](./troubleshooting.md) - Problemlösungen
