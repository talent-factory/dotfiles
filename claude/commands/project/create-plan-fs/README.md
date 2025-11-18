# Create Plan FS - Filesystem-basierte Projektplanung

Dokumentation und Templates für das `/project:create-plan-fs` Command.

## Übersicht

Das `/project:create-plan-fs` Command erstellt strukturierte Projektpläne aus PRD-Dokumenten und speichert Tasks als Markdown-Dateien im Filesystem - ohne Abhängigkeit von externen Tools wie Linear.

## Unterschied zu `/project:create-plan`

| Feature | `/project:create-plan` | `/project:create-plan-fs` |
|---------|----------------------|-------------------------|
| **Speicherort** | Linear (Cloud) | Filesystem (lokal) |
| **Dependencies** | Linear API, MCP | Keine |
| **Format** | Linear Issues/EPICs | Markdown-Dateien |
| **Versionskontrolle** | Über Linear | Git-integriert |
| **Offline-Fähig** | ❌ Nein | ✅ Ja |
| **Tool Lock-in** | ✅ Ja (Linear) | ❌ Nein |
| **Kollaboration** | Linear UI | Git + PR-Workflow |
| **Automatisierung** | Linear Webhooks | Custom Scripts |

## Dateien in diesem Verzeichnis

### Templates

- **`epic-template.md`** - Template für EPIC.md (Feature-Übersicht)
- **`task-template.md`** - Template für einzelne Task-Dateien
- **`status-template.md`** - Template für STATUS.md (Fortschritts-Übersicht)

### Dokumentation

- **`example-structure.md`** - Vollständiges Beispiel einer Plan-Struktur
- **`best-practices.md`** - Best Practices für Filesystem-basierte Planung
- **`README.md`** - Diese Datei

## Quick Start

### 1. PRD erstellen

```bash
/project:create-prd "Dark Mode Toggle für Einstellungen"
```

**Output**: `PRD.md` im aktuellen Verzeichnis

### 2. Plan generieren

```bash
/project:create-plan-fs --prd PRD.md
```

**Output**: Strukturiertes Verzeichnis in `.plans/dark-mode-toggle/`

### 3. Plan ansehen

```bash
cd .plans/dark-mode-toggle/
cat STATUS.md
```

### 4. Task bearbeiten

```bash
# Task auf "in_progress" setzen
vim tasks/task-001-ui-toggle-component.md

# Implementation durchführen
# ...

# Task auf "completed" setzen
vim tasks/task-001-ui-toggle-component.md

# STATUS.md aktualisieren
# (manuell oder via Script)
```

## Verzeichnis-Struktur

```
.plans/
└── [feature-name]/
    ├── EPIC.md                 # Feature-Übersicht
    ├── STATUS.md               # Fortschritts-Tracking
    ├── tasks/
    │   ├── task-001-*.md       # Einzelne Tasks
    │   ├── task-002-*.md
    │   └── ...
    └── metadata.json           # Optional: Strukturierte Daten
```

## Template-Verwendung

### EPIC.md

Enthält:
- Executive Summary
- Business Value
- Success Metrics
- Timeline & Milestones
- Dependencies
- Link zum vollständigen PRD

**Verwendung**:
```bash
cp epic-template.md .plans/my-feature/EPIC.md
# Ersetze alle {{PLACEHOLDERS}}
```

### Task-Datei

Enthält:
- Metadata (Status, Priority, Estimate, etc.)
- Description
- Acceptance Criteria
- Dependencies
- Agent Recommendation
- Implementation Notes

**Verwendung**:
```bash
cp task-template.md .plans/my-feature/tasks/task-001-my-task.md
# Ersetze alle {{PLACEHOLDERS}}
```

### STATUS.md

Enthält:
- Progress Overview (Statistiken)
- Tasks by Priority
- Tasks by Status
- Dependencies Graph (Mermaid)

**Verwendung**:
- Wird automatisch vom Command generiert
- Kann manuell oder per Script aktualisiert werden

## Workflows

### Workflow 1: Feature-Entwicklung

```bash
# 1. PRD schreiben
/project:create-prd "User Authentication System"

# 2. Plan erstellen
/project:create-plan-fs --prd PRD.md

# 3. Ersten Task starten
cd .plans/user-authentication-system/tasks/
vim task-001-database-schema.md
# Status: pending → in_progress

# 4. Implementierung
# ... code, code, code ...

# 5. Task abschließen
vim task-001-database-schema.md
# Status: in_progress → completed
# Alle Acceptance Criteria abhaken

# 6. STATUS aktualisieren
cd ..
vim STATUS.md  # oder Script ausführen

# 7. Nächsten Task
cd tasks/
vim task-002-jwt-integration.md
# ...
```

### Workflow 2: Bestehenden Plan erweitern

```bash
# 1. Neuen Task hinzufügen
cd .plans/my-feature/tasks/
cp ../../create-plan-fs/task-template.md task-042-new-feature.md

# 2. Task ausfüllen
vim task-042-new-feature.md

# 3. STATUS.md aktualisieren
cd ..
# Script ausführen oder manuell aktualisieren

# 4. EPIC.md anpassen (falls nötig)
vim EPIC.md
```

### Workflow 3: Status-Review

```bash
# Täglich
cd .plans/my-feature/
cat STATUS.md

# Wöchentlich
cat EPIC.md
ls -la tasks/
# Review Dependencies, Blockierte Tasks identifizieren

# Vor Meetings
./scripts/generate-status.sh .plans/my-feature/
cat STATUS.md
```

## Git-Integration

### Commit-Convention

```bash
# Format: <type>: <description> (task-NNN)
git commit -m "feat: implement login API endpoint (task-005)"
git commit -m "fix: resolve password validation bug (task-007)"
git commit -m "test: add unit tests for auth service (task-012)"
git commit -m "docs: update API documentation (task-015)"
```

### Branch-Strategien

**Option A: Ein Branch pro Task**
```bash
git checkout -b task-001-database-schema
# ... implement ...
git commit -m "feat: create database schema for users (task-001)"
git push origin task-001-database-schema
# PR erstellen
```

**Option B: Ein Branch pro Feature**
```bash
git checkout -b feature/user-authentication
git commit -m "feat: database schema (task-001)"
git commit -m "feat: JWT integration (task-002)"
git commit -m "feat: login endpoint (task-003)"
# ...
git push origin feature/user-authentication
# PR erstellen mit allen Tasks
```

### Pull Request Template

```markdown
## Related Tasks

Part of: `.plans/user-authentication-system/`

**Completed**:
- ✅ task-001: Database Schema (3 SP)
- ✅ task-002: JWT Integration (5 SP)
- ✅ task-003: Login Endpoint (5 SP)

**Pending**:
- ⏸️ task-004: Session Management (waiting for review)

## Acceptance Criteria

All acceptance criteria from task files verified:
- [x] Database tables created with correct schema
- [x] JWT tokens generated correctly
- [x] Login endpoint responds within 200ms
- [x] Unit test coverage > 90%

## Testing

See individual task files for detailed test results.

## Screenshots/Logs

[Attach relevant artifacts]
```

## Automatisierung

### Status-Generator (Python)

Ein Beispiel-Script ist in `best-practices.md` dokumentiert.

**Features**:
- Liest alle Task-Dateien
- Extrahiert Metadata (Status, Priority, Estimate)
- Generiert STATUS.md mit Statistiken
- Erstellt Dependency-Graphen

**Verwendung**:
```bash
./scripts/generate-status.py .plans/my-feature/
```

### Task-Creator (Shell)

```bash
#!/bin/bash
# create-task.sh - Erstellt eine neue Task-Datei

PLAN_DIR=$1
TASK_NUM=$2
TASK_TITLE=$3

if [ -z "$PLAN_DIR" ] || [ -z "$TASK_NUM" ] || [ -z "$TASK_TITLE" ]; then
    echo "Usage: create-task.sh <plan-dir> <task-num> <title>"
    exit 1
fi

TASK_FILE="${PLAN_DIR}/tasks/task-$(printf '%03d' $TASK_NUM)-${TASK_TITLE}.md"

cp templates/task-template.md "$TASK_FILE"

# Ersetze Placeholders
sed -i '' "s/{{TASK_NUMBER}}/$(printf '%03d' $TASK_NUM)/g" "$TASK_FILE"
sed -i '' "s/{{TASK_TITLE}}/${TASK_TITLE}/g" "$TASK_FILE"
sed -i '' "s/{{CREATED_DATE}}/$(date +%Y-%m-%d)/g" "$TASK_FILE"

echo "✅ Task created: $TASK_FILE"
```

**Verwendung**:
```bash
./scripts/create-task.sh .plans/my-feature 42 "implement-api-cache"
```

## Migration von Linear

Falls Sie existierende Linear-Pläne haben:

### 1. Linear-Daten exportieren

```bash
# Mit Linear CLI oder API
linear-cli export --epic "EPIC-123" --format json > linear-export.json
```

### 2. Konvertierungs-Script

```python
#!/usr/bin/env python3
"""Convert Linear export to filesystem structure."""

import json
from pathlib import Path

def convert_linear_to_fs(export_file, output_dir):
    with open(export_file) as f:
        data = json.load(f)

    # Create plan directory
    plan_dir = Path(output_dir) / data['epic']['identifier'].lower()
    plan_dir.mkdir(parents=True, exist_ok=True)

    # Create EPIC.md
    # ...

    # Create tasks/
    tasks_dir = plan_dir / 'tasks'
    tasks_dir.mkdir(exist_ok=True)

    for i, issue in enumerate(data['issues'], 1):
        task_file = tasks_dir / f"task-{i:03d}-{issue['identifier'].lower()}.md"
        # Convert issue to task format
        # ...

    # Create STATUS.md
    # ...

if __name__ == '__main__':
    import sys
    convert_linear_to_fs(sys.argv[1], sys.argv[2])
```

## Vorteile

### ✅ Versionskontrolle
- Alle Änderungen in Git nachvollziehbar
- Diffs zeigen genau, was sich geändert hat
- Branching für experimentelle Pläne

### ✅ Keine Tool-Abhängigkeit
- Kein Linear-Account nötig
- Kein API-Token erforderlich
- Funktioniert offline

### ✅ Flexibilität
- Bearbeitung mit jedem Editor
- Custom Scripts für Automatisierung
- Integration mit CI/CD

### ✅ Portabilität
- Einfaches Backup
- Sharing via Git
- Migration zu anderen Tools möglich

### ✅ Transparenz
- Alle Daten im Klartext
- Kein proprietäres Format
- Grep-fähig, durchsuchbar

## Nachteile & Lösungen

### ⚠️ Keine UI
**Problem**: Keine grafische Oberfläche für Drag & Drop.

**Lösungen**:
- VS Code mit Markdown-Plugins
- Custom Web-UI (optional)
- Terminal-Tools wie `fzf` für Navigation

### ⚠️ Manuelle Synchronisation
**Problem**: STATUS.md muss manuell oder via Script aktualisiert werden.

**Lösungen**:
- Automatisierungs-Scripts (siehe oben)
- Git Hooks für automatische Updates
- CI/CD Pipeline für Validierung

### ⚠️ Keine Notifications
**Problem**: Keine automatischen Benachrichtigungen bei Task-Updates.

**Lösungen**:
- Git Hooks + Slack/Email-Integration
- GitHub Actions für Notifications
- Custom Monitoring-Scripts

## Support & Erweiterung

### Weitere Templates hinzufügen

```bash
cd .claude/commands/project/create-plan-fs/
# Erstelle neues Template
vim my-custom-template.md
# Referenziere es in create-plan-fs.md
```

### Best Practices anpassen

Bearbeiten Sie `best-practices.md` für Team-spezifische Guidelines.

### Scripts erweitern

Fügen Sie eigene Automatisierungs-Scripts hinzu:
```bash
mkdir scripts/
touch scripts/generate-status.py
touch scripts/create-task.sh
touch scripts/validate-tasks.sh
chmod +x scripts/*.sh scripts/*.py
```

## Vergleich: Wann welches Tool?

### Verwende `/project:create-plan-fs` wenn:
- ✅ Kein Linear-Account verfügbar
- ✅ Offline-Arbeit erforderlich
- ✅ Vollständige Git-Integration gewünscht
- ✅ Keine externe Tool-Abhängigkeit
- ✅ Custom-Workflows nötig

### Verwende `/project:create-plan` wenn:
- ✅ Linear bereits im Team etabliert
- ✅ Linear-UI bevorzugt
- ✅ Team-Kollaboration über Linear
- ✅ Linear-Integrationen (Slack, etc.) genutzt
- ✅ Roadmap-Features von Linear benötigt

## Weitere Ressourcen

- **Command-Datei**: `../create-plan-fs.md`
- **Templates**: Dieses Verzeichnis
- **Beispiele**: `example-structure.md`
- **Best Practices**: `best-practices.md`
- **Original (Linear)**: `../create-plan.md`

## Changelog

- **2025-01-18**: Initial release
  - Templates erstellt
  - Dokumentation geschrieben
  - Best Practices definiert

---

**Viel Erfolg mit Ihrer Filesystem-basierten Projektplanung! 🚀**
