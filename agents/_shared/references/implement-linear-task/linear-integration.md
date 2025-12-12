# Linear Integration Guide

Umfassende Anleitung zur Integration des Linear MCP Servers mit Claude Code.

## Übersicht

Der Linear MCP Server ermöglicht Claude Code direkten Zugriff auf Linear-Daten via Model Context Protocol. Dies erlaubt:

- Issue-Abruf und Suche
- Status-Updates
- Comment-Erstellung
- Team- und Projekt-Informationen
- Workflow-Management

## Installation

### 1. Linear MCP Server installieren

Der offizielle Linear MCP Server wird via npm bereitgestellt:

```bash
# Keine Installation nötig - wird via npx ausgeführt
# npx lädt automatisch @modelcontextprotocol/server-linear
```

### 2. Linear API Key generieren

**Schritte**:

1. Öffne Linear: https://linear.app
2. Gehe zu **Settings** → **API**
3. Klicke **Create new API key**
4. **Scopes auswählen**:
   - ✅ `read` - Issue-Daten lesen
   - ✅ `write` - Issue-Status aktualisieren, Comments erstellen
5. API Key kopieren und sicher speichern

### 3. Claude Code Konfiguration

**MCP Server in Claude Code registrieren**:

Öffne die Claude Code MCP-Konfiguration und füge hinzu:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "lin_api_xxxxxxxxxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

**⚠️ Sicherheit**: Niemals API Keys direkt im Code! Besser:

```json
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

**Environment Variable setzen** (`~/.env`):

```bash
export LINEAR_API_KEY="lin_api_xxxxxxxxxxxxxxxxxxxxxxxx"
```

### 4. Verifikation

**Claude Code neu starten** und testen:

```bash
# In Claude Code:
# "List my Linear issues"
# "Show Linear team information"
```

Wenn erfolgreich, sollte Claude auf Linear-Daten zugreifen können.

## Linear GraphQL API

Der MCP Server nutzt die Linear GraphQL API im Hintergrund.

### Wichtige Endpoints

**Issue abrufen**:

```graphql
query GetIssue($id: String!) {
  issue(id: $id) {
    id
    identifier
    title
    description
    state {
      id
      name
    }
    assignee {
      id
      name
      email
    }
    labels {
      nodes {
        id
        name
      }
    }
    project {
      id
      name
    }
    createdAt
    updatedAt
  }
}
```

**Zugewiesene Issues auflisten**:

```graphql
query MyIssues {
  viewer {
    assignedIssues {
      nodes {
        id
        identifier
        title
        state {
          name
        }
        priority
      }
    }
  }
}
```

**Issue-Status aktualisieren**:

```graphql
mutation UpdateIssueState($id: String!, $stateId: String!) {
  issueUpdate(id: $id, input: { stateId: $stateId }) {
    success
    issue {
      id
      state {
        name
      }
    }
  }
}
```

**Comment hinzufügen**:

```graphql
mutation CreateComment($issueId: String!, $body: String!) {
  commentCreate(input: { issueId: $issueId, body: $body }) {
    success
    comment {
      id
      body
    }
  }
}
```

## MCP Server Funktionen

Der Linear MCP Server stellt folgende Tools bereit:

### `linear_get_issue`

**Beschreibung**: Issue-Details abrufen

**Parameter**:

- `issueId` (String) - Issue-ID oder Identifier (z.B. "PROJ-123")

**Rückgabe**:

```json
{
  "id": "abc123",
  "identifier": "PROJ-123",
  "title": "User Authentication",
  "description": "Implement OAuth2 authentication...",
  "state": { "name": "In Progress" },
  "assignee": { "name": "Daniel" },
  "labels": [{ "name": "feature" }]
}
```

### `linear_list_my_issues`

**Beschreibung**: Dem User zugewiesene Issues

**Parameter**:

- `filter` (Optional) - Status-Filter (z.B. "backlog", "in_progress")

**Rückgabe**: Array von Issue-Objekten

### `linear_update_issue_state`

**Beschreibung**: Issue-Status ändern

**Parameter**:

- `issueId` (String) - Issue-ID
- `stateId` (String) - Ziel-Status-ID

**Hinweis**: Status-IDs müssen vorher via `linear_get_workflow_states` abgerufen werden.

### `linear_create_comment`

**Beschreibung**: Comment zu Issue hinzufügen

**Parameter**:

- `issueId` (String) - Issue-ID
- `body` (String) - Comment-Text (Markdown unterstützt)

### `linear_get_workflow_states`

**Beschreibung**: Workflow-States für Team abrufen

**Parameter**:

- `teamId` (String) - Team-ID

**Rückgabe**: Array von Workflow-States mit IDs und Namen

### `linear_search_issues`

**Beschreibung**: Issues durchsuchen

**Parameter**:

- `query` (String) - Suchbegriff
- `limit` (Number, optional) - Max. Anzahl Ergebnisse

## Workflow-States Mapping

Typische Linear Workflows:

**Standard-Workflow**:

1. **Backlog** - Neue Issues
2. **Todo** - Geplant
3. **In Progress** - Wird bearbeitet
4. **In Review** - PR erstellt
5. **Done** - Abgeschlossen
6. **Canceled** - Abgebrochen

**Custom Workflows**: Jedes Team kann eigene States definieren.

**States abrufen**:

```javascript
// Via MCP:
linear_get_workflow_states({ teamId: "abc123" })

// Rückgabe:
[
  { id: "state1", name: "Backlog" },
  { id: "state2", name: "In Progress" },
  { id: "state3", name: "In Review" },
  { id: "state4", name: "Done" }
]
```

## Team & Projekt Setup

### Team-ID ermitteln

```graphql
query GetTeams {
  teams {
    nodes {
      id
      name
      key
    }
  }
}
```

**Beispiel-Rückgabe**:

```json
[
  { "id": "team_abc", "name": "Engineering", "key": "PROJ" }
]
```

### Projekt-Konfiguration in CLAUDE.md

**Empfohlen**: Team- und Projekt-Informationen in CLAUDE.md dokumentieren:

```markdown
## Linear Integration

### Workspace
- **Name**: Your Company
- **URL**: https://linear.app/your-company

### Teams
- **Engineering**: `PROJ` (Team-Key)
  - Team-ID: `team_abc123`
  - Workflow: Backlog → In Progress → In Review → Done

### Projekte
- **Main Product**: `PROJ-*`
- **Infrastructure**: `INFRA-*`

### Status-IDs
- Backlog: `state_backlog123`
- In Progress: `state_inprogress456`
- In Review: `state_review789`
- Done: `state_done012`
```

## Testing & Debugging

### MCP Server Connection testen

```bash
# In Claude Code:
"Show me my Linear teams"
"List my assigned Linear issues"
```

Erwartetes Verhalten:

- ✅ Claude ruft MCP Tool auf
- ✅ Linear-Daten werden angezeigt
- ❌ Fehler → Siehe Troubleshooting

### GraphQL Playground

**Linear bietet ein GraphQL Playground**:
https://linear.app/your-workspace/settings/api

**Beispiel-Query testen**:

```graphql
{
  viewer {
    id
    name
    assignedIssues {
      nodes {
        identifier
        title
      }
    }
  }
}
```

### MCP Server Logs

**Logs aktivieren** (in MCP-Konfiguration):

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}",
        "DEBUG": "linear:*"
      }
    }
  }
}
```

**Logs prüfen**:

- Claude Code Console öffnen
- Nach `[linear]` Einträgen suchen

## Best Practices

### API Rate Limits

**Linear API Limits**:

- **Rate Limit**: 1.200 Requests/Stunde
- **Burst**: 100 Requests/Minute

**Empfehlungen**:

- ✅ Batching nutzen (mehrere Issues auf einmal)
- ✅ Caching für häufig abgerufene Daten
- ❌ Keine unnötigen API-Calls

### Security

**API Key Schutz**:

- ✅ Environment Variables nutzen
- ✅ Niemals in Git committen
- ✅ `.env` in `.gitignore`
- ✅ Separate Keys für Development/Production

**Key Rotation**:

- Alle 90 Tage API Key rotieren
- Bei Verdacht auf Kompromittierung sofort rotieren

### Error Handling

**Typische Fehler**:

**401 Unauthorized**:

- API Key ungültig oder abgelaufen
- Fix: Neuen API Key generieren

**403 Forbidden**:

- Fehlende Permissions
- Fix: API Key Scopes überprüfen

**404 Not Found**:

- Issue existiert nicht
- Fix: Issue-ID validieren

**429 Too Many Requests**:

- Rate Limit überschritten
- Fix: Warten und Retry mit Backoff

## Alternative: Direct GraphQL API

Falls MCP Server nicht verfügbar:

**Direct API Call** (mit `curl`):

```bash
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: Bearer lin_api_xxx" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ viewer { id name } }"
  }'
```

**In Command integrieren**:

```javascript
// Via Bash-Tool in Claude Code
const response = await bash(`
  curl -s -X POST https://api.linear.app/graphql \\
    -H "Authorization: Bearer ${LINEAR_API_KEY}" \\
    -H "Content-Type: application/json" \\
    -d '{"query":"query GetIssue($id:String!){issue(id:$id){id title}}"}'
`);
```

**Nachteile vs. MCP**:

- Manuelle Query-Konstruktion
- Kein Type-Safety
- Fehleranfälliger

**Empfehlung**: MCP Server bevorzugen.

## Weiterführende Ressourcen

### Offizielle Dokumentation

- **Linear API Docs**: https://developers.linear.app/docs
- **GraphQL Schema**: https://studio.apollographql.com/public/Linear-API/home
- **Linear MCP Server**: https://github.com/modelcontextprotocol/servers/tree/main/src/linear

### Beispiele

- **[workflow.md](./workflow.md)** - Workflow-Beispiele mit MCP
- **[best-practices.md](./best-practices.md)** - Integration Best Practices
- **[troubleshooting.md](./troubleshooting.md)** - Häufige Probleme

## Zusammenfassung

**Setup-Schritte**:

1. ✅ Linear API Key generieren
2. ✅ MCP Server in Claude Code konfigurieren
3. ✅ Environment Variable setzen
4. ✅ Team/Projekt-IDs in CLAUDE.md dokumentieren
5. ✅ Connection testen

**Nach Setup verfügbar**:

- Issue-Abruf und Suche
- Status-Updates
- Comment-Erstellung
- Workflow-Management
