# Troubleshooting: Filesystem Task Implementation

Häufige Probleme bei der Implementierung von Filesystem-basierten Tasks und deren Lösungen.

## Task-Identifikation

### Problem: Task nicht gefunden

**Symptom**:
```
❌ Error: Task task-001 not found in any plan
```

**Ursachen**:
1. Task-ID falsch geschrieben
2. Task-Datei existiert nicht
3. Falsche Verzeichnisstruktur

**Diagnose**:
```bash
# 1. Alle Tasks auflisten
find .plans -name "task-*.md"

# 2. Spezifischen Task suchen
find .plans -name "task-001-*.md"

# 3. Verzeichnisstruktur prüfen
tree .plans
```

**Lösung**:
```bash
# Falls Task existiert: Korrekten Namen verwenden
/develop:implement-fs-task task-001

# Falls Task nicht existiert: Interaktive Auswahl
/develop:implement-fs-task
# → Zeigt alle verfügbaren Tasks

# Oder: Plan manuell angeben
/develop:implement-fs-task --plan dark-mode-toggle
```

### Problem: Mehrere Tasks mit gleicher ID

**Symptom**:
```
⚠️ Multiple tasks found with ID task-001:
1. .plans/dark-mode-toggle/tasks/task-001-ui-toggle.md
2. .plans/user-auth/tasks/task-001-login-form.md
Which one? [1-2]:
```

**Ursache**: Mehrere Pläne mit gleicher Task-Nummerierung

**Lösung**:
```bash
# Option 1: Interaktiv auswählen
# → User wählt gewünschten Task

# Option 2: Plan-Kontext angeben
/develop:implement-fs-task --plan dark-mode-toggle task-001
```

**Best Practice**: Eindeutige Task-Nummerierung pro Plan verwenden

## Dependencies

### Problem: Required-Tasks nicht erfüllt

**Symptom**:
```
⚠️ Dependencies not met:

Required Tasks:
- task-003 (CSS Variables Setup): in_progress
- task-004 (Theme Context): pending

Continue anyway? [y/n]:
```

**Ursache**: Task-005 requires task-003 und task-004, aber diese sind nicht `completed`

**Diagnose**:
```bash
# Status der Required-Tasks prüfen
grep "**Status**:" .plans/dark-mode-toggle/tasks/task-003-*.md
# → - **Status**: in_progress

grep "**Status**:" .plans/dark-mode-toggle/tasks/task-004-*.md
# → - **Status**: pending
```

**Lösung**:

**Option 1**: Anderen Task wählen
```bash
# Task mit erfüllten Dependencies wählen
/develop:implement-fs-task task-001  # Keine Dependencies
```

**Option 2**: Required-Tasks zuerst fertigstellen
```bash
# task-003 fertigstellen
/develop:implement-fs-task task-003
# → Nach Completion: task-003 status: completed

# task-004 fertigstellen
/develop:implement-fs-task task-004
# → Nach Completion: task-004 status: completed

# Dann task-005 starten
/develop:implement-fs-task task-005
# → ✅ Dependencies met
```

**Option 3**: Fortfahren trotz Dependencies (nicht empfohlen)
```
Continue anyway? y
⚠️ Warning: This may lead to integration issues!
```

### Problem: Circular Dependencies

**Symptom**:
```
❌ Error: Circular dependency detected:
task-001 requires task-002
task-002 requires task-003
task-003 requires task-001
```

**Ursache**: Task-Dependencies bilden einen Kreis

**Diagnose**:
```bash
# Dependencies extrahieren
grep "**Requires**:" .plans/*/tasks/task-001-*.md
# → task-002

grep "**Requires**:" .plans/*/tasks/task-002-*.md
# → task-003

grep "**Requires**:" .plans/*/tasks/task-003-*.md
# → task-001  # ❌ Circular!
```

**Lösung**: Dependencies neu strukturieren

```markdown
# Vorher (Circular):
task-001: requires task-002
task-002: requires task-003
task-003: requires task-001

# Nachher (Linear):
task-001: requires [none]
task-002: requires task-001
task-003: requires task-002
```

**Prevention**: Dependency-Graph visualisieren (STATUS.md) vor Implementierung

## Branch-Erstellung

### Problem: Branch existiert bereits

**Symptom**:
```
❌ Error: Branch task-001-ui-toggle-component already exists
```

**Ursache**: Branch wurde bereits früher erstellt

**Diagnose**:
```bash
# Branches auflisten
git branch -a | grep task-001

# Output:
  task-001-ui-toggle-component
  remotes/origin/task-001-ui-toggle-component
```

**Lösung**:

**Option 1**: Zu existierendem Branch wechseln
```bash
git checkout task-001-ui-toggle-component

# Status prüfen
git status

# Falls clean: Weiter implementieren
# Falls uncommitted changes: Committen oder stashen
```

**Option 2**: Alten Branch löschen (Vorsicht!)
```bash
# Lokalen Branch löschen
git branch -D task-001-ui-toggle-component

# Remote-Branch löschen (falls vorhanden)
git push origin --delete task-001-ui-toggle-component

# Neuen Branch erstellen
git checkout -b task-001-ui-toggle-component
```

**Option 3**: Anderen Task wählen
```bash
/develop:implement-fs-task task-002
```

### Problem: Working Directory nicht sauber

**Symptom**:
```
❌ Error: Working directory not clean. Uncommitted changes:
 M src/components/ThemeToggle.tsx
 M src/styles/theme.css
```

**Ursache**: Uncommitted Änderungen im Working Directory

**Diagnose**:
```bash
git status
# Output zeigt modified files
```

**Lösung**:

**Option 1**: Änderungen committen
```bash
/commit
# → Erstellt Commit für aktuelle Änderungen

# Dann Task starten
/develop:implement-fs-task task-002
```

**Option 2**: Änderungen stashen
```bash
git stash save "WIP: Theme changes"

# Task implementieren
/develop:implement-fs-task task-002

# Später: Stash wiederherstellen
git stash pop
```

**Option 3**: Änderungen verwerfen (Vorsicht!)
```bash
# Alle Änderungen verwerfen
git reset --hard HEAD

# Dann Task starten
/develop:implement-fs-task task-002
```

### Problem: Remote nicht up-to-date

**Symptom**:
```
⚠️ Warning: Local branch is out of sync with remote
Local:  abc123def
Remote: xyz789abc

Pull changes first? [y/n]:
```

**Ursache**: Remote-Branch hat neuere Commits

**Diagnose**:
```bash
git fetch origin
git status
# Output: Your branch is behind 'origin/develop' by 3 commits
```

**Lösung**:
```bash
# Pull changes
git pull origin develop

# Oder: Rebase (empfohlen)
git pull --rebase origin develop

# Dann Task starten
/develop:implement-fs-task task-001
```

## Task-Status-Updates

### Problem: Status-Update schlägt fehl

**Symptom**:
```
❌ Error: Could not update task status
Old string not found: "- **Status**: pending"
```

**Ursache**: Status-Format in Task-Datei weicht ab

**Diagnose**:
```bash
# Aktuelles Format prüfen
grep "Status" .plans/*/tasks/task-001-*.md

# Mögliche Outputs:
- **Status**: pending       # ✅ Correct
- **Status** : pending      # ❌ Extra space
- **status**: pending       # ❌ Lowercase
- Status: pending           # ❌ No bold markers
```

**Lösung**:

**Option 1**: Task-Datei manuell korrigieren
```bash
# Edit task-001-ui-toggle-component.md
# Ändere auf korrektes Format:
- **Status**: pending
```

**Option 2**: Bulk-Fix mit sed
```bash
# Fix all task files in plan
find .plans/dark-mode-toggle/tasks -name "task-*.md" -exec \
  sed -i 's/- \*\*Status\*\* : /- **Status**: /' {} \;
```

**Prevention**: Template nutzen (task-template.md) für neue Tasks

### Problem: STATUS.md nicht aktualisiert

**Symptom**: Task status in Task-Datei `completed`, aber STATUS.md zeigt noch `pending`

**Ursache**: STATUS.md wurde nicht regeneriert

**Diagnose**:
```bash
# Task-Status prüfen
grep "**Status**:" .plans/dark-mode-toggle/tasks/task-001-*.md
# → - **Status**: completed

# STATUS.md prüfen
grep "task-001" .plans/dark-mode-toggle/STATUS.md
# → - [ ] task-001: UI Toggle Component (3 SP) - pending
#       ^^^^ ❌ Noch pending
```

**Lösung**:
```bash
# STATUS.md regenerieren
# (Manuell via Python-Script oder Command)

python3 regenerate-status.py .plans/dark-mode-toggle

# Oder: Manuell editieren (nicht empfohlen)
# Edit .plans/dark-mode-toggle/STATUS.md
```

**Prevention**: Automatische Regenerierung im Workflow einbauen

## Implementierung

### Problem: Akzeptanzkriterien unklar

**Symptom**: Task-Beschreibung zu vage, Implementierung unklar

**Beispiel**:
```markdown
## Acceptance Criteria
- [ ] Component works correctly
- [ ] Tests pass
```

**Problem**: "Works correctly" ist zu vage!

**Lösung**:

**Option 1**: Akzeptanzkriterien präzisieren
```markdown
## Acceptance Criteria
- [ ] Toggle button renders sun icon in light mode
- [ ] Toggle button renders moon icon in dark mode
- [ ] Clicking toggle switches theme (light ↔ dark)
- [ ] Theme preference persists in localStorage
- [ ] Component supports keyboard navigation (Enter/Space)
- [ ] Unit tests achieve >90% coverage
```

**Option 2**: User fragen (AskUserQuestion)
```bash
# Claude nutzt AskUserQuestion
What should "works correctly" include?
1. Visual rendering
2. State management
3. Persistence
4. All of the above
```

### Problem: Fehlende Dependencies (Code)

**Symptom**:
```
❌ Error: Module 'react' not found
```

**Ursache**: Dependencies nicht installiert

**Diagnose**:
```bash
# Node.js
cat package.json | grep react
# → Nicht vorhanden

# Python
grep "react" requirements.txt
# → Nicht vorhanden
```

**Lösung**:
```bash
# Node.js
npm install react react-dom

# Python
pip install react  # (falls Python-Binding)

# Java
# Add to pom.xml oder build.gradle
```

### Problem: Tests schlagen fehl

**Symptom**:
```
❌ FAIL: ThemeToggle.test.tsx
Expected: true
Received: false
```

**Ursache**: Implementierung erfüllt Akzeptanzkriterien nicht

**Diagnose**:
```bash
# Test-Output analysieren
npm test -- ThemeToggle.test.tsx

# Code reviewen
cat src/components/ThemeToggle.tsx
```

**Lösung**:
```bash
# 1. Test verstehen
# Was wird erwartet?

# 2. Code anpassen
# Implementierung korrigieren

# 3. Test erneut ausführen
npm test -- ThemeToggle.test.tsx

# 4. Wiederholen bis grün
```

## PR-Erstellung

### Problem: GitHub CLI nicht authentifiziert

**Symptom**:
```
❌ Error: gh: Not authenticated
```

**Ursache**: `gh` CLI nicht eingeloggt

**Diagnose**:
```bash
gh auth status
# Output: You are not logged into any GitHub hosts
```

**Lösung**:
```bash
# Login
gh auth login

# Folge dem Prozess:
# 1. GitHub.com auswählen
# 2. HTTPS auswählen
# 3. Browser-Login

# Verifizieren
gh auth status
# Output: ✓ Logged in to github.com
```

### Problem: PR-Erstellung schlägt fehl

**Symptom**:
```
❌ Error: No commits between develop and task-001-ui-toggle-component
```

**Ursache**: Branch hat keine Änderungen gegenüber Base-Branch

**Diagnose**:
```bash
git log develop..HEAD
# Output: (empty)

# Diff prüfen
git diff develop...HEAD
# Output: (empty)
```

**Lösung**:
```bash
# Commits vorhanden?
git log --oneline

# Falls keine Commits: Änderungen committen
git add .
git commit -m "✨ feat(task-001): Implement UI toggle"

# Dann PR erstellen
/create-pr
```

### Problem: PR-Labels falsch

**Symptom**: PR hat Labels `bug`, sollte aber `enhancement` haben

**Ursache**: Task-Labels nicht korrekt in PR-Labels gemapped

**Diagnose**:
```bash
# Task-Labels prüfen
grep "**Labels**:" .plans/*/tasks/task-001-*.md
# → - **Labels**: [bug, ui]  # ❌ Sollte "feature" sein

# PR-Labels prüfen
gh pr view 456 --json labels
```

**Lösung**:

**Option 1**: Task-Labels korrigieren
```bash
# Edit task-001-ui-toggle-component.md
- **Labels**: [feature, ui]  # ✅ Korrigiert

# PR neu erstellen oder Labels manuell ändern
gh pr edit 456 --add-label "enhancement" --remove-label "bug"
```

**Option 2**: PR-Labels manuell setzen
```bash
gh pr edit 456 --add-label "enhancement,ui,react"
```

## Finalisierung

### Problem: Task bleibt in_progress nach PR-Merge

**Symptom**: Task-Status ist `in_progress`, aber PR wurde bereits gemerged

**Ursache**: Finalisierungs-Schritt wurde übersprungen

**Diagnose**:
```bash
# Task-Status prüfen
grep "**Status**:" .plans/*/tasks/task-001-*.md
# → - **Status**: in_progress  # ❌ Sollte completed sein

# PR-Status prüfen
gh pr view 456 --json state
# → "state": "MERGED"
```

**Lösung**:
```bash
# Task-Status manuell auf completed setzen
# Edit task-001-ui-toggle-component.md
- **Status**: completed
- **Updated**: 2024-11-18

# STATUS.md regenerieren
python3 regenerate-status.py .plans/dark-mode-toggle

# Committen
git add .plans/dark-mode-toggle/tasks/task-001-*.md
git add .plans/dark-mode-toggle/STATUS.md
git commit -m "✅ chore: Mark task-001 as completed"
git push
```

### Problem: STATUS.md zeigt falsche Progress-Zahlen

**Symptom**:
```markdown
- **Total Tasks**: 8
- **Completed**: 3 (37.5%)
```

Aber manuell gezählt: 1 completed, nicht 3!

**Ursache**: STATUS.md veraltet oder falsch regeneriert

**Diagnose**:
```bash
# Manuell zählen
grep "**Status**: completed" .plans/dark-mode-toggle/tasks/*.md | wc -l
# → 1

# STATUS.md prüfen
grep "Completed:" .plans/dark-mode-toggle/STATUS.md
# → - **Completed**: 3 (37.5%)  # ❌ Falsch
```

**Lösung**:
```bash
# STATUS.md neu generieren
python3 regenerate-status.py .plans/dark-mode-toggle

# Verifizieren
grep "Completed:" .plans/dark-mode-toggle/STATUS.md
# → - **Completed**: 1 (12.5%)  # ✅ Korrekt

# Committen
git add .plans/dark-mode-toggle/STATUS.md
git commit -m "📝 docs: Regenerate STATUS.md"
git push
```

## Performance

### Problem: find-Befehle zu langsam

**Symptom**: Task-Suche dauert >5 Sekunden

**Ursache**: Zu viele Dateien, ineffiziente Suche

**Diagnose**:
```bash
# Anzahl Task-Dateien
find .plans -name "task-*.md" | wc -l
# → 10000  # Sehr viele!

# Zeit messen
time find .plans -name "task-001-*.md"
# → real 0m6.234s  # Zu langsam
```

**Lösung**:

**Option 1**: Maxdepth begrenzen
```bash
# Statt:
find .plans -name "task-001-*.md"

# Besser:
find .plans -maxdepth 3 -name "task-001-*.md"
```

**Option 2**: Plan-Kontext nutzen
```bash
# Statt alle Pläne durchsuchen:
/develop:implement-fs-task task-001

# Besser: Plan angeben
/develop:implement-fs-task --plan dark-mode-toggle task-001
```

**Option 3**: Indexing einführen (Advanced)
```bash
# Metadata-Index erstellen (einmalig)
python3 create-index.py .plans

# Task-Suche via Index (schnell)
python3 find-task.py task-001
```

## Git-Integration

### Problem: Merge-Konflikte

**Symptom**:
```
❌ CONFLICT (content): Merge conflict in src/theme.tsx
```

**Ursache**: Änderungen in develop überschneiden sich mit Task-Branch

**Diagnose**:
```bash
git status
# Output zeigt Konflikte

git diff
# Zeigt <<<<<<< HEAD Marker
```

**Lösung**:
```bash
# 1. Konflikte manuell auflösen
vim src/theme.tsx
# Entferne Konflikt-Marker, behalte gewünschte Änderungen

# 2. Resolved markieren
git add src/theme.tsx

# 3. Merge/Rebase fortsetzen
git rebase --continue
# oder
git merge --continue

# 4. Tests ausführen
npm test

# 5. Pushen
git push --force-with-lease
```

## Siehe auch

- [workflow.md](./workflow.md) - Vollständiger Workflow
- [task-management.md](./task-management.md) - Task-Status-Management
- [best-practices.md](./best-practices.md) - Best Practices
- [../commit/troubleshooting.md](../commit/troubleshooting.md) - Commit Troubleshooting
- [../create-pr/troubleshooting.md](../create-pr/troubleshooting.md) - PR Troubleshooting
