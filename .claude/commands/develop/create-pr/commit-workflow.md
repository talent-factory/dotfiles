# Commit-Workflow Integration

Der `/create-pr` Command integriert sich mit dem `/commit` Command für professionelle Commits.

## Workflow-Übersicht

```text
Uncommitted Changes?
        │
        ├─ JA  → Rufe /commit auf
        │           │
        │           ├─ Pre-Commit Checks
        │           ├─ Staging
        │           ├─ Commit-Nachricht
        │           └─ Commit erstellt
        │
        └─ NEIN → Verwende bestehende Commits
                      │
                      └─ Branch erstellen
                         Push to remote
                         PR erstellen
```

## Integration mit /commit

### Voraussetzungen

Der `/create-pr` Command:

- **Prüft auf uncommitted Changes**
- **Ruft `/commit` auf** falls nötig
- **Verwendet bestehende Commits** für PR
- **Erstellt KEINE eigenen Commits**

### Warum diese Integration?

**Konsistenz**: Ein Command für Commits = konsistente Qualität

**Keine Duplikation**: Commit-Logik nur in `/commit`

**Flexibilität**: Du kannst Commits manuell erstellen oder automatisch

## Workflow-Szenarien

### Szenario 1: Keine Commits vorhanden

**Situation**: Du hast Änderungen, aber noch keinen Commit

```bash
$ git status
modified: src/app.py
modified: tests/test_app.py
```

**Workflow**:

```bash
/create-pr
```

1. **Erkennt uncommitted Changes**
2. **Ruft `/commit` auf**
   - Pre-Commit-Checks
   - Staging
   - Commit-Erstellung
3. **Erstellt Branch**: `feature/neue-funktion-2024-10-30`
4. **Pushed Branch**
5. **Erstellt PR**

### Szenario 2: Commits bereits vorhanden

**Situation**: Du hast bereits Commits erstellt

```bash
$ git log --oneline -3
abc1234 (HEAD -> main) ✨ feat: Neue Funktion hinzugefügt
def5678 🧪 test: Tests für neue Funktion
ghi9012 📚 docs: Dokumentation aktualisiert
```

**Workflow**:

```bash
/create-pr
```

1. **Erkennt bestehende Commits**
2. **Überspringt Commit-Erstellung**
3. **Erstellt Branch**: `feature/neue-funktion-2024-10-30`
4. **Pushed Branch mit allen Commits**
5. **Erstellt PR** basierend auf Commit-Historie

### Szenario 3: Gemischte Situation

**Situation**: Commits vorhanden + neue Änderungen

```bash
$ git log --oneline -1
abc1234 (HEAD -> main) ✨ feat: Neue Funktion hinzugefügt

$ git status
modified: src/app.py  # Weitere Änderungen
```

**Workflow**:

```bash
/create-pr
```

1. **Erkennt uncommitted Changes**
2. **Ruft `/commit` auf** für neue Änderungen
3. **Erstellt Branch** mit allen Commits
4. **Pushed und erstellt PR**

## Commit-Aufteilung

Der `/commit` Command kann Änderungen automatisch in logische Commits aufteilen.

### Automatische Erkennung

**Beispiel**: Mehrere unabhängige Änderungen

```bash
$ git status
modified: src/auth/login.py       # Auth-Feature
modified: src/dashboard/ui.py     # UI-Update
modified: tests/test_auth.py      # Auth-Tests
modified: tests/test_dashboard.py # UI-Tests
modified: README.md               # Docs
```

**Workflow**:

```bash
/commit
```

Kann in separate Commits aufteilen:

```
✨ feat: Login-Funktionalität verbessert
├─ src/auth/login.py
└─ tests/test_auth.py

💎 style: Dashboard UI aktualisiert
├─ src/dashboard/ui.py
└─ tests/test_dashboard.py

📚 docs: README mit neuen Features aktualisiert
└─ README.md
```

### Warum Commit-Aufteilung?

**Vorteile**:

- **Atomare Commits**: Jeder Commit ist unabhängig
- **Besseres Review**: Reviewer sehen klare Struktur
- **Einfaches Debugging**: git bisect funktioniert besser
- **Cherry-Picking**: Einzelne Features können isoliert werden

### Single-Commit Option

**Wenn du alles in einem Commit möchtest**:

```bash
/create-pr --single-commit
```

## Branch-Erstellung

### Automatische Branch-Namen

**Format**: `<type>/<description>-<date>`

**Beispiele**:

```
feature/user-authentication-2024-10-30
bugfix/memory-leak-fix-2024-10-30
refactor/api-restructure-2024-10-30
```

### Branch-Naming basierend auf Commits

Der Branch-Name wird aus den Commit-Nachrichten abgeleitet:

**Commits**:

```
✨ feat: Benutzer-Dashboard hinzugefügt
🧪 test: Dashboard Tests implementiert
```

**Branch**: `feature/benutzer-dashboard-2024-10-30`

### Kollisionen vermeiden

**Problem**: Branch existiert bereits

**Lösung**: Automatisches Suffix

```
feature/neue-funktion-2024-10-30
feature/neue-funktion-2024-10-30-v2
feature/neue-funktion-2024-10-30-v3
```

## Push-Strategie

### First-Time Push

**Erster Push eines neuen Branches**:

```bash
git push -u origin feature/neue-funktion
```

**Das `-u` Flag**:

- Setzt upstream Branch
- Erlaubt einfaches `git push` später
- Tracked Remote Branch

### Commit-Historie präsentieren

**Alle Commits werden gepushed**:

```bash
git log --oneline origin/main..HEAD
```

### Force Push vermeiden

**Prinzip**: Niemals `--force` ohne Notwendigkeit

**Ausnahme**: Nur bei expliziter Anfrage

```bash
/create-pr --force-push  # ⚠️ Vorsicht!
```

## PR-Erstellung basierend auf Commits

### Commit-Analyse

Der Command analysiert alle Commits:

```bash
git log --oneline origin/main..HEAD
```

### PR-Titel Generierung

**Single Commit**: Commit-Nachricht als Titel

```
✨ feat: Benutzer-Dashboard hinzugefügt
```

→ PR-Titel: **"Benutzer-Dashboard hinzugefügt"**

**Multiple Commits**: Zusammenfassung erstellen

```
✨ feat: Login-System implementiert
🧪 test: Login-Tests hinzugefügt
📚 docs: Login-Dokumentation erstellt
```

→ PR-Titel: **"Login-System mit Tests und Dokumentation"**

### PR-Beschreibung Generierung

**Basierend auf Commits**:

```markdown
## Beschreibung

Diese PR implementiert ein neues Login-System mit OAuth2-Support.

## Änderungen

- ✨ Login-System implementiert
- 🧪 Login-Tests hinzugefügt
- 📚 Login-Dokumentation erstellt

## Test-Plan

- [ ] Manuelle Tests durchgeführt
- [ ] Unit Tests laufen durch (18 neue Tests)
- [ ] Integration Tests erfolgreich

## Breaking Changes

Keine
```

## Best Practices

### Commit-Hygiene vor PR

**Checkliste**:

- [ ] Alle Commits haben aussagekräftige Nachrichten
- [ ] Commits sind logisch aufgeteilt
- [ ] Keine "WIP" oder "fix" Commits
- [ ] Commit-Historie ist sauber

**Falls nötig**: Commits aufräumen vor `/create-pr`

```bash
git rebase -i HEAD~5
# Commits squashen, reword, etc.
```

### Commit-Nachrichten als Dokumentation

**Commits dokumentieren das "Warum"**:

```
✨ feat: Rate Limiting für API-Endpoints

Implementiert Token-Bucket-Algorithmus für API-Rate-Limiting.
Limit: 100 Requests pro Minute pro User.

Grund: Schutz vor API-Missbrauch und DoS-Angriffen.
```

### Atomare Feature-Branches

**Ein Branch = Ein Feature**

```
✅ feature/user-authentication
✅ bugfix/login-memory-leak
❌ feature/multiple-unrelated-things
```

## Troubleshooting

### /commit wird nicht aufgerufen

**Problem**: Änderungen werden erkannt, aber `/commit` nicht aufgerufen

**Diagnose**:

```bash
git status
git diff
```

**Mögliche Ursachen**:

- Alle Änderungen bereits committed
- Working Directory ist clean
- Nur untracked Files

### Commits sind in falscher Reihenfolge

**Problem**: Commit-Historie ist durcheinander

**Lösung**: Rebase vor PR

```bash
git rebase -i origin/main
# Commits neu anordnen
```

### Branch-Name passt nicht

**Problem**: Automatischer Branch-Name ist unpassend

**Lösung**: Branch manuell erstellen

```bash
git checkout -b feature/besserer-name
/create-pr
# Verwendet bestehenden Branch-Namen
```

### Zu viele Commits

**Problem**: PR hat 20+ Commits, schwer zu reviewen

**Lösung**: Commits squashen

```bash
git rebase -i origin/main
# Markiere Commits als 'squash'
```

Oder verwenden:

```bash
/create-pr --single-commit
```

## Integration mit Git Hooks

### Pre-Push Hook

**Automatische Validierung vor Push**:

```bash
#!/bin/bash
# .git/hooks/pre-push

# Alle Commits prüfen
for commit in $(git rev-list origin/main..HEAD); do
  msg=$(git log -1 --format=%s $commit)
  if ! echo "$msg" | grep -E "^(feat|fix|docs|style|refactor|test|chore):"; then
    echo "❌ Commit $commit hat keine Convention-Nachricht"
    exit 1
  fi
done
```

### Commit-Message Hook

**Validierung beim Committen**:

```bash
#!/bin/bash
# .git/hooks/commit-msg

msg=$(cat "$1")
if ! echo "$msg" | grep -E "^(✨|🐛|📚|💎|♻️|⚡|🧪|🔧)"; then
  echo "❌ Commit-Nachricht benötigt Emoji"
  exit 1
fi
```

## Workflow-Beispiele

### Einfacher Feature-Workflow

```bash
# 1. Änderungen machen
vim src/feature.py

# 2. PR erstellen (inkl. Commit)
/create-pr

# Fertig! Branch, Commits, und PR erstellt
```

### Komplexer Multi-Commit-Workflow

```bash
# 1. Feature implementieren
vim src/auth.py
/commit

# 2. Tests hinzufügen
vim tests/test_auth.py
/commit

# 3. Docs aktualisieren
vim README.md
/commit

# 4. PR erstellen
/create-pr

# Branch mit 3 sauberen Commits + PR
```
