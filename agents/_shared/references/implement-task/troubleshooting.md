# Troubleshooting: Task Implementation

Häufige Probleme bei der Implementierung von Tasks und deren Lösungen.

## Task-Identifikation

### Task nicht gefunden

**Symptom**:
```
❌ Error: Task [ID] not found
```

**Lösungen**:

**Filesystem**:
```bash
# Alle Tasks auflisten
find .plans -name "task-*.md"

# Mit Plan-Kontext suchen
/develop:implement-task --plan dark-mode-toggle task-001
```

**Linear**:
```bash
# Issue-ID validieren (Format: [A-Z]+-[0-9]+)
# Beispiel: PROJ-123, nicht proj-123

# API-Test
curl -H "Authorization: Bearer $LINEAR_API_KEY" \
  https://api.linear.app/graphql \
  -d '{"query":"query{issue(id:\"PROJ-123\"){id title}}"}'
```

## Branch-Probleme

### Branch existiert bereits

**Symptom**:
```
⚠️ Branch feature/proj-123-... already exists
```

**Lösungen**:

1. **Zu existierendem Branch wechseln**:
   ```bash
   git checkout feature/proj-123-user-auth
   ```

2. **Branch löschen und neu erstellen**:
   ```bash
   git branch -D feature/proj-123-user-auth
   git checkout -b feature/proj-123-user-auth
   ```

3. **Anderen Task wählen**

### Working Directory nicht sauber

**Symptom**:
```
❌ Error: Working directory not clean
```

**Lösungen**:

```bash
# Option 1: Committen
/commit

# Option 2: Stashen
git stash save "WIP before implementing task"

# Option 3: Verwerfen (Vorsicht!)
git reset --hard HEAD
```

### Remote nicht up-to-date

**Symptom**:
```
⚠️ Local branch is behind remote
```

**Lösung**:
```bash
git fetch origin
git pull --rebase origin main
```

## Status-Update Probleme

### Filesystem: Status-Update schlägt fehl

**Symptom**:
```
❌ Could not update task status
Old string not found: "- **Status**: pending"
```

**Ursache**: Format in Task-Datei weicht ab

**Lösung**: Task-Datei manuell korrigieren:
```markdown
- **Status**: pending
```

### Linear: MCP Server nicht verfügbar

**Symptom**:
```
❌ Linear MCP server not available
```

**Diagnose**:
```bash
# MCP-Konfiguration prüfen
cat ~/.config/claude/mcp_config.json

# API Key testen
echo $LINEAR_API_KEY
curl -H "Authorization: Bearer $LINEAR_API_KEY" \
  https://api.linear.app/graphql \
  -d '{"query":"{ viewer { id } }"}'
```

**Lösung**: MCP-Konfiguration erstellen:
```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": { "LINEAR_API_KEY": "${LINEAR_API_KEY}" }
    }
  }
}
```

### Linear: API Key ungültig

**Symptom**:
```
❌ Error 401: Unauthorized
```

**Lösung**:
1. Neuen Key generieren: https://linear.app → Settings → API
2. In `~/.env` aktualisieren:
   ```bash
   export LINEAR_API_KEY="lin_api_NEW_KEY"
   source ~/.env
   ```

## PR-Erstellung Probleme

### GitHub CLI nicht authentifiziert

**Symptom**:
```
❌ gh: Not authenticated
```

**Lösung**:
```bash
gh auth login
# Folge dem Browser-Login
gh auth status  # Verifizieren
```

### Keine Commits für PR

**Symptom**:
```
❌ No commits between main and feature-branch
```

**Lösung**:
```bash
# Änderungen committen
git add .
git commit -m "✨ feat: Implement feature"

# Dann PR erstellen
/create-pr
```

## Finalisierung Probleme

### Task bleibt in_progress nach PR

**Symptom**: Task-Status ist noch `in_progress` obwohl PR erstellt

**Lösung**:

**Filesystem**:
```bash
# Task-Status manuell setzen
# Edit: - **Status**: completed
# Edit: - **Updated**: <heute>

# STATUS.md regenerieren
git add .plans/*/tasks/*.md .plans/*/STATUS.md
git commit -m "✅ chore: Mark task as completed"
```

**Linear**:
```bash
# Issue-Status in Linear auf "In Review" oder "Done" setzen
```

## Performance-Probleme

### Command hängt

**Symptom**: Keine Ausgabe für >5 Minuten

**Lösungen**:
1. `Ctrl+C` zum Abbrechen
2. Rate Limit prüfen (Linear: 1200 req/hour)
3. Neu starten mit Debug: `export DEBUG=*`

### Suche zu langsam (Filesystem)

**Symptom**: Task-Suche dauert >5 Sekunden

**Lösung**: Plan-Kontext angeben
```bash
# Statt
/develop:implement-task task-001

# Besser
/develop:implement-task --plan dark-mode task-001
```

## Siehe auch

- [workflow.md](./workflow.md) - Detaillierter Workflow
- [best-practices.md](./best-practices.md) - Best Practices
- [filesystem.md](./filesystem.md) - Filesystem-spezifisch
- [linear.md](./linear.md) - Linear-spezifisch

