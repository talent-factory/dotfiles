# Best Practices für Git Commits

## Commit-Qualität

### Atomare Commits

**Prinzip**: Jeder Commit sollte eine logische, unabhängige Einheit darstellen

✅ **Gute atomare Commits**:

```
✨ feat: Benutzer-Authentifizierung hinzugefügt
🧪 test: Tests für Authentifizierung hinzugefügt
📚 docs: Auth-API Dokumentation erstellt
```

❌ **Schlechter monolithischer Commit**:

```
✨ feat: Auth, Tests, Docs, Bugfixes und Refactoring
```

**Vorteile**:

- Einfacheres Code-Review
- Besseres Debugging (git bisect)
- Selektives Cherry-Picking möglich
- Klare Git-Historie

### Aussagekräftige Nachrichten

**Was macht eine gute Commit-Nachricht aus?**

1. **Beschreibe das "Was" und "Warum"**, nicht das "Wie"
2. **Kontext bieten** für zukünftige Entwickler
3. **Technische Details** wenn relevant

✅ **Gut**:

```
🐛 fix: Speicherleck in WebSocket-Verbindungen behoben

WebSocket-Connections wurden nicht korrekt geschlossen,
wenn Clients die Verbindung abrupt beendeten. Dies führte
zu Memory-Leaks bei hoher Last.

Lösung: Explicit cleanup in finally-Block implementiert.
```

❌ **Schlecht**:

```
fix: bug
```

### Imperative Form

**Regel**: Schreibe als würdest du dem Code befehlen, was er tun soll

✅ **Richtig (Imperativ)**:

- Füge Feature hinzu
- Behebe Bug
- Aktualisiere Dokumentation
- Entferne deprecated Code

❌ **Falsch (Vergangenheit)**:

- Feature hinzugefügt
- Bug behoben
- Dokumentation aktualisiert
- Deprecated Code entfernt

**Warum?** Git selbst verwendet Imperativ (z.B. "Merge branch", "Revert commit")

### Erste Zeile ≤ 72 Zeichen

**Grund**: Bessere Lesbarkeit in Git-Tools

```
✨ feat: User Dashboard mit Metriken                    # ✅ 48 Zeichen
✨ feat: Implementierung eines umfassenden...           # ❌ zu lang
```

**Tools zur Überprüfung**:

```bash
git log --oneline          # Zeigt nur erste Zeile
git log --format="%s"      # Subject lines
```

## Code-Qualität vor Commit

### Checkliste

Bevor du commitest:

- [ ] **Linting bestanden**: Code folgt Projektstandards
- [ ] **Tests erfolgreich**: Alle Tests laufen durch
- [ ] **Build erfolgreich**: Projekt kompiliert ohne Fehler
- [ ] **Dokumentation aktuell**: README, Kommentare, Docs sind aktuell
- [ ] **Keine Debug-Ausgaben**: console.log, print() entfernt
- [ ] **Keine auskommentierten Code-Blöcke**
- [ ] **Secrets entfernt**: API-Keys, Passwörter nicht committed

### Automatische Checks

**Pre-Commit Hooks einrichten**:

```bash
# Für alle Projekte
git config --global core.hooksPath ~/.git-hooks

# Projekt-spezifisch
# .git/hooks/pre-commit
```

### Code-Review vor Commit

**Self-Review durchführen**:

```bash
git diff --staged          # Überprüfe staged changes
git diff HEAD             # Alle Änderungen
git add -p               # Interactive staging
```

## Projektspezifische Standards

### Java

**Standards**:

- ✅ Keine Compiler-Warnungen
- ✅ Checkstyle-Konformität
- ✅ JavaDoc für public APIs
- ✅ Unit Tests für neue Methoden

**Prüfung**:

```bash
mvn clean compile -Werror
mvn checkstyle:check
```

### Python

**Standards**:

- ✅ PEP 8 Compliance
- ✅ Type Hints wo möglich
- ✅ Docstrings für Funktionen
- ✅ Max. Zeilen-Länge: 88 (Black) oder 79 (PEP 8)

**Prüfung**:

```bash
black --check .
ruff check .
mypy .
```

### React/TypeScript

**Standards**:

- ✅ Keine ESLint-Fehler
- ✅ TypeScript strict mode
- ✅ Komponenten-Tests vorhanden
- ✅ Props mit TypeScript-Interfaces

**Prüfung**:

```bash
npm run lint
tsc --noEmit
npm test
```

## Häufige Fehler vermeiden

### ❌ "WIP" Commits

**Problem**: "Work in Progress" Commits in History

**Lösung**: Squash vor dem Push

```bash
git rebase -i HEAD~3
# Markiere Commits als 'squash'
```

### ❌ Zu große Commits

**Problem**: 50+ Dateien in einem Commit

**Lösung**: Logisch aufteilen

```bash
git add -p                    # Interactive staging
git add path/to/feature/      # Nur Feature-Dateien
```

### ❌ Merge-Commit-Durcheinander

**Problem**: Unnötige Merge-Commits in Feature-Branch

**Lösung**: Rebase verwenden

```bash
git pull --rebase origin main
# statt
git pull origin main
```

### ❌ Fehlende Kontext-Informationen

**Problem**: "fix typo", "update file"

**Lösung**: Kontext hinzufügen

```
📚 docs: Typo in API-Dokumentation korrigiert

Der Endpoint-Name war falsch dokumentiert (/api/user statt /api/users),
was zu Verwirrung bei externen API-Nutzern führte.
```

## Git-Historie sauber halten

### Vor dem Push

**Review der Commits**:

```bash
git log --oneline -10         # Letzte 10 Commits
git log --graph --oneline     # Mit Branch-Visualisierung
```

**Commits aufräumen**:

```bash
git rebase -i HEAD~5          # Interaktives Rebase
# Optionen: pick, squash, reword, edit, drop
```

### Branch-Hygiene

**Feature-Branches**:

```
feature/user-authentication   # ✅ Beschreibend
feat/auth                    # ✅ Kürzer, aber klar
user-auth-123               # ✅ Mit Ticket-Nummer
fix-login                   # ❌ Zu generisch
new-stuff                   # ❌ Nicht aussagekräftig
```

**Regelmäßig aufräumen**:

```bash
git branch --merged | grep -v main | xargs git branch -d
```

## Team-Kollaboration

### Konsistente Conventions

**Team-Agreement etablieren**:

- Commit-Message-Format
- Branch-Naming-Schema
- PR-Anforderungen
- Review-Prozess

### Commit-Message-Templates

**Erstellen**:

```bash
git config commit.template ~/.gitmessage
```

**Template** (`~/.gitmessage`):

```
# <emoji> <type>: <subject>

# [optional body]

# [optional footer]

# Typen: feat, fix, docs, style, refactor, perf, test, chore
# Emojis: ✨ 🐛 📚 💎 ♻️ ⚡ 🧪 🔧
```

## Tools und Automation

### Commit-Message-Linting

```bash
npm install -g @commitlint/cli @commitlint/config-conventional
```

### Pre-Commit Framework

```bash
pip install pre-commit
pre-commit install
```

### Git Aliases

```bash
# Nützliche Shortcuts
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --graph --oneline --decorate"
```
