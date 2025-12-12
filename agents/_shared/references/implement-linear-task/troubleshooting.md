# Troubleshooting Guide

Lösungen für häufige Probleme bei der Verwendung von `/develop:implement-linear-task`.

## Linear MCP Server Probleme

### MCP Server nicht verfügbar

**Symptom**:

```text
❌ Error: Linear MCP server not available
Cannot connect to Linear API
```

**Diagnose**:

```bash
# 1. Prüfe MCP-Konfiguration
cat ~/.config/claude/mcp_config.json

# 2. Prüfe Linear API Key
echo $LINEAR_API_KEY

# 3. Test Linear API direkt
curl -H "Authorization: Bearer $LINEAR_API_KEY" \
  https://api.linear.app/graphql \
  -d '{"query":"{ viewer { id name } }"}'
```

**Lösungen**:

**1. MCP Server nicht konfiguriert**:

```json
// ~/.config/claude/mcp_config.json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    }
  }
}
```

**2. API Key fehlt**:

```bash
# In ~/.env hinzufügen
export LINEAR_API_KEY="lin_api_xxxxxxxxxxxxxxxxxxxxxxxx"

# Shell neu starten oder source
source ~/.env
```

**3. Claude Code neu starten**:

```bash
# Claude Code vollständig beenden
# Dann neu starten
```

**4. MCP Server manuell testen**:

```bash
# Server direkt aufrufen
LINEAR_API_KEY="lin_api_xxx" npx -y @modelcontextprotocol/server-linear

# Erwartete Ausgabe: Server läuft ohne Fehler
```

### API Key ungültig

**Symptom**:

```text
❌ Error 401: Unauthorized
Linear API key is invalid or expired
```

**Lösung**:

1. Neuen API Key generieren:
   - https://linear.app → Settings → API
   - "Create new API key"
   - Scopes: `read`, `write`
2. API Key aktualisieren:

   ```bash
   # In ~/.env
   export LINEAR_API_KEY="lin_api_NEW_KEY"
   source ~/.env
   ```

3. Claude Code neu starten

### Rate Limit erreicht

**Symptom**:

```text
❌ Error 429: Too Many Requests
Rate limit exceeded: 1200 requests/hour
```

**Ursachen**:
- Zu viele API-Calls in kurzer Zeit
- Andere Tools nutzen denselben API Key

**Lösungen**:

**1. Warten und Retry**:
```javascript
// Automatischer Retry nach 5 Minuten
await sleep(5 * 60 * 1000)
retry()
```

**2. Rate Limit Status prüfen**:
```bash
curl -I -H "Authorization: Bearer $LINEAR_API_KEY" \
  https://api.linear.app/graphql

# Headers prüfen:
# X-RateLimit-Remaining: 1150
# X-RateLimit-Reset: 1234567890
```

**3. Separate API Keys** für verschiedene Tools:
- Development: `lin_api_dev_xxx`
- Production: `lin_api_prod_xxx`
- CI/CD: `lin_api_ci_xxx`

## Issue-bezogene Probleme

### Issue nicht gefunden

**Symptom**:

```text
❌ Issue PROJ-999 not found
```

**Ursachen**:

- Issue-ID falsch geschrieben
- Issue existiert nicht
- Kein Zugriff auf Issue (Permissions)

**Diagnose**:

```bash
# Issue direkt in Linear suchen
# https://linear.app/team/issue/PROJ-999

# Issue via API prüfen
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: Bearer $LINEAR_API_KEY" \
  -d '{"query":"query{issue(id:\"PROJ-999\"){id title}}"}'
```

**Lösungen**:

**1. Issue-ID validieren**:

- Format: `[A-Z]+-[0-9]+`
- Beispiele: `PROJ-123`, `TEAM-456`
- NICHT: `proj-123`, `PROJ123`

**2. Team-Key prüfen**:

```bash
# Falscher Team-Key
WRONG-123  # Team "WRONG" existiert nicht

# Richtiger Team-Key
PROJ-123   # Team "PROJ" existiert
```

**3. Permissions prüfen**:

- User muss Zugriff auf Team haben
- Issue darf nicht privat sein

### Issue nicht zugewiesen

**Symptom**:

```text
⚠️  Warning: Issue PROJ-123 is not assigned to you
Assigned to: Alice

Continue anyway? [y/N]
```

**Optionen**:

**1. Sich selbst zuweisen** (in Linear):

```text
1. Issue in Linear öffnen
2. Assignee auf sich selbst setzen
3. Command erneut ausführen
```

**2. Trotzdem fortfahren**:

```bash
# Mit Warnung fortfahren
# Antwort: y
```

**Best Practice**: Nur eigene Issues bearbeiten!

### Issue bereits "Done"

**Symptom**:

```text
❌ Issue PROJ-123 is already completed
Status: Done

Cannot implement completed issue
```

**Ursachen**:

- Issue wurde bereits abgeschlossen
- Status manuell in Linear geändert

**Lösungen**:

**1. Status in Linear prüfen**:

- Falls fälschlicherweise auf "Done" gesetzt
- Status zurück auf "Backlog" setzen

**2. Neues Issue erstellen**:

- Falls zusätzliche Arbeit nötig
- Neues Issue mit Referenz auf PROJ-123

**3. Issue re-open**:

```graphql
mutation ReopenIssue($id: String!, $stateId: String!) {
  issueUpdate(id: $id, input: { stateId: $stateId }) {
    issue {
      id
      state { name }
    }
  }
}
```

## Branch-Probleme

### Branch existiert bereits

**Symptom**:

```text
⚠️  Branch feature/proj-123-user-authentication exists

Options:
1. Switch to existing branch
2. Overwrite (DANGER!)
3. Create with suffix (-v2)
4. Abort
```

**Lösungen**:

**1. Auf existierenden Branch wechseln**:

```bash
git checkout feature/proj-123-user-authentication

# Prüfen ob up-to-date
git status
git pull origin feature/proj-123-user-authentication
```

**2. Branch überschreiben** (VORSICHT!):

```bash
# NUR wenn sicher, dass keine wichtigen Änderungen verloren gehen
git branch -D feature/proj-123-user-authentication
git checkout -b feature/proj-123-user-authentication
```

**3. Branch mit Suffix**:

```bash
# Neuer Branch: feature/proj-123-user-authentication-v2
git checkout -b feature/proj-123-user-authentication-v2
```

**4. Abbrechen** und manuell aufräumen:

```bash
# Existierenden Branch prüfen
git log feature/proj-123-user-authentication

# Falls nicht mehr benötigt, löschen
git branch -d feature/proj-123-user-authentication
```

### Working Directory nicht sauber

**Symptom**:

```text
❌ Cannot create branch: working directory not clean

Uncommitted changes:
  M src/auth/oauth2.ts
  ?? src/test/new-test.ts
```

**Lösungen**:

**1. Änderungen committen**:

```bash
git add .
git commit -m "WIP: Temporary commit"
```

**2. Änderungen stashen**:

```bash
git stash save "WIP before implementing PROJ-123"

# Später wiederherstellen:
git stash pop
```

**3. Änderungen verwerfen** (VORSICHT!):

```bash
# Nur wenn sicher, dass Änderungen nicht benötigt werden
git reset --hard HEAD
git clean -fd
```

### Branch-Push fehlgeschlagen

**Symptom**:

```text
❌ Error: failed to push branch
! [rejected] feature/proj-123 -> feature/proj-123 (non-fast-forward)
```

**Ursachen**:

- Remote-Branch hat neue Commits
- Lokaler Branch ist behind

**Lösungen**:

**1. Pull und Merge**:

```bash
git pull origin feature/proj-123-user-authentication

# Falls Konflikte:
git mergetool
git commit
```

**2. Rebase**:

```bash
git fetch origin
git rebase origin/feature/proj-123-user-authentication

# Falls Konflikte:
git rebase --continue
```

**3. Force Push** (VORSICHT!):

```bash
# NUR wenn sicher, dass Remote-Changes überschrieben werden können
git push --force-with-lease origin feature/proj-123-user-authentication
```

## Status-Update Probleme

### Workflow-State nicht gefunden

**Symptom**:

```text
❌ Cannot find "In Progress" state
Available states: Backlog, Todo, Done
```

**Ursachen**:

- Custom Workflow ohne "In Progress" State
- Team verwendet andere State-Namen

**Diagnose**:

```bash
# Workflow-States abrufen
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: Bearer $LINEAR_API_KEY" \
  -d '{"query":"query{team(id:\"team_id\"){states{nodes{id name type}}}}"}'
```

**Lösungen**:

**1. State-Mapping anpassen**:

```javascript
// Custom State-Mapping in CLAUDE.md
const stateMapping = {
  "start_work": "state_id_123",  // Custom "Start Work" state
  "in_review": "state_id_456"
}
```

**2. Manuell State auswählen**:

```text
Available workflow states:
1. Backlog
2. Todo
3. Working
4. Review
5. Done

Select "In Progress" equivalent: [1-5]:
```

**3. Workflow in Linear anpassen**:

- Settings → Workflow
- States umbenennen oder hinzufügen

### Transition nicht erlaubt

**Symptom**:

```text
❌ Cannot transition from "Done" to "In Progress"
Workflow rule prevents this transition
```

**Ursachen**:

- Linear Workflow-Rules verbieten Transition
- Issue-Status ist "locked"

**Lösungen**:

**1. Workflow-Rules prüfen** (Linear Settings):

```text
Settings → Workflow → Transitions
- Welche Transitions sind erlaubt?
```

**2. Issue re-open**:

```bash
# Erst auf "Backlog" zurück, dann "In Progress"
# Via Linear UI oder API
```

**3. Admin kontaktieren**:

- Falls Workflow-Rules zu restriktiv

## PR-Erstellung Probleme

### GitHub CLI nicht authentifiziert

**Symptom**:

```text
❌ gh: To use GitHub CLI, please authenticate
Run: gh auth login
```

**Lösung**:

```bash
# GitHub CLI Authentication
gh auth login

# Follow prompts:
# - What account? GitHub.com
# - Protocol? HTTPS
# - Authenticate? Login with browser

# Verify
gh auth status
```

### PR-Template nicht gefunden

**Symptom**:

```text
⚠️  Warning: .github/pull_request_template.md not found
Using default PR template
```

**Lösungen**:

**1. PR-Template erstellen**:

```bash
mkdir -p .github
cat > .github/pull_request_template.md << 'EOF'
## Linear Issue
[ISSUE-ID](https://linear.app/team/issue/ISSUE-ID)

## Description

## Changes

## Test Plan

## Breaking Changes
EOF
```

**2. Default-Template verwenden**:

- Command generiert automatisch Template mit Linear-Link

### PR-Labels können nicht gesetzt werden

**Symptom**:

```text
⚠️  Warning: Failed to set PR labels
Labels: enhancement, backend

PR created without labels
```

**Ursachen**:

- Labels existieren nicht im Repository
- Keine Permissions zum Setzen von Labels

**Lösungen**:

**1. Labels in GitHub erstellen**:

```bash
# Via gh CLI
gh label create enhancement --color "a2eeef"
gh label create backend --color "0e8a16"
```

**2. Labels manuell setzen**:

- PR in GitHub öffnen
- Labels manuell hinzufügen

**3. Label-Mapping anpassen**:

```javascript
// Nur existierende Labels verwenden
const validLabels = ['bug', 'enhancement', 'documentation']
```

## Test-Probleme

### Tests schlagen fehl

**Symptom**:

```text
❌ Test suite failed
15 tests, 3 failed, 12 passed

Failed tests:
- OAuth2 login with Google
- Session persistence
- Logout functionality
```

**Diagnose**:

```bash
# Tests lokal ausführen
npm test

# Verbose Output
npm test -- --verbose

# Einzelnen Test
npm test -- oauth2.test.ts
```

**Lösungen**:

**1. Test-Dependencies prüfen**:

```bash
# Dependencies installieren
npm install

# Test-Datenbank aufsetzen
npm run test:db:setup
```

**2. Environment Variables**:

```bash
# Test-Environment
export NODE_ENV=test
export DATABASE_URL=postgresql://localhost/test

# Tests erneut
npm test
```

**3. Tests anpassen**:

- Implementierung prüfen
- Test-Cases korrigieren
- Mocks/Stubs hinzufügen

### Test-Coverage zu niedrig

**Symptom**:

```text
⚠️  Warning: Test coverage below threshold
Current: 65% | Required: 80%
```

**Lösungen**:

**1. Fehlende Tests identifizieren**:

```bash
npm run test:coverage

# Coverage-Report öffnen
open coverage/index.html
```

**2. Tests für ungetestete Bereiche**:

```javascript
// Beispiel: Edge-Cases
describe('OAuth2 Error Handling', () => {
  it('should handle invalid tokens', () => {
    // Test implementation
  })

  it('should handle network errors', () => {
    // Test implementation
  })
})
```

**3. Threshold temporär senken** (nicht empfohlen):

```json
// package.json
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "lines": 70
      }
    }
  }
}
```

## Allgemeine Probleme

### Command hängt

**Symptom**:

```text
🔄 Implementing changes...
[Keine weitere Ausgabe für >5 Minuten]
```

**Ursachen**:

- API-Call wartet auf Timeout
- Deadlock in Implementierung
- Rate Limit erreicht

**Lösungen**:

**1. Command abbrechen**:

```text
Ctrl+C
```

**2. Logs prüfen**:

```bash
# Claude Code Logs
# Developer Tools → Console
# Nach Fehlern suchen
```

**3. Neu starten mit Debug**:

```bash
# Environment Variable setzen
export DEBUG=linear:*

# Command erneut ausführen
/develop:implement-linear-task PROJ-123
```

### Inkonsistenter State

**Symptom**:

```text
⚠️  Warning: Inconsistent state detected
- Branch: feature/proj-123-... exists
- Linear: Issue is "Backlog" (expected "In Progress")
- PR: Not created
```

**Diagnose**:

```bash
# Git Status
git status
git branch -a

# Linear Status (via API oder UI)
# PR Status (via GitHub)
```

**Lösungen**:

**1. State manuell synchronisieren**:

```bash
# Linear-Status setzen
# → Via Linear UI auf "In Progress"

# Branch prüfen und ggf. löschen
git branch -D feature/proj-123-...

# Command erneut ausführen
/develop:implement-linear-task PROJ-123
```

**2. Cleanup-Script**:

```bash
# cleanup-issue.sh
#!/bin/bash
ISSUE_ID=$1

# Branch löschen
git branch -D feature/${ISSUE_ID}*

# Linear-Status auf Backlog
# (via API oder manuell)

echo "Cleanup complete for $ISSUE_ID"
```

### Performance-Probleme

**Symptom**:

```text
Command dauert >5 Minuten
Viele API-Calls
```

**Ursachen**:

- Zu viele Issues abgerufen
- Langsame Netzwerk-Verbindung
- Rate Limiting

**Lösungen**:

**1. Issue-Filter einschränken**:

```javascript
// Nur offene Issues abrufen
filter: {
  state: { type: { nin: ["completed", "canceled"] } }
}

// Limit setzen
first: 10  // Nur 10 Issues
```

**2. Caching nutzen**:

```javascript
// Issue-Daten cachen (5 Minuten)
const cachedIssues = cache.get('my-issues')
if (cachedIssues && cache.isValid()) {
  return cachedIssues
}
```

**3. Parallel-Requests vermeiden**:

```javascript
// Sequentiell statt parallel
await getIssue()
await updateStatus()
await createComment()
```

## Debug-Tipps

### Verbose Logging aktivieren

```bash
# In Claude Code Console
export DEBUG=*

# Oder spezifisch
export DEBUG=linear:*,mcp:*
```

### API-Calls tracen

```bash
# Network Tab in DevTools öffnen
# Alle GraphQL-Requests prüfen
# Response Status & Body checken
```

### State-Dumps

```javascript
// State vor/nach jedem Schritt loggen
console.log('State before branch creation:', {
  currentBranch: git.currentBranch(),
  issue: issue,
  workingDir: git.status()
})
```

## Hilfe bekommen

### Logs sammeln

```bash
# Claude Code Logs
# → Developer Tools → Console → Save as...

# Git Status
git status > git-status.txt
git log --oneline -10 > git-log.txt

# Linear API Test
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: Bearer $LINEAR_API_KEY" \
  -d '{"query":"{ viewer { id } }"}' \
  > linear-test.txt
```

### Support kontaktieren

**Information bereitstellen**:

1. Command-Aufruf (ohne sensitive Daten)
2. Fehler-Message
3. Logs (Console, Git)
4. Environment (OS, Claude Code Version)

**Checkliste vor Support**:

- [ ] Troubleshooting-Guide durchgearbeitet
- [ ] Linear MCP Server verifiziert
- [ ] API Key getestet
- [ ] Logs gesammelt

## Siehe auch

- **[linear-integration.md](./linear-integration.md)** - MCP Server Setup
- **[workflow.md](./workflow.md)** - Workflow-Details
- **[best-practices.md](./best-practices.md)** - Best Practices
