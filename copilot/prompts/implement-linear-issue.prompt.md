---
description: Implementiere Linear Issue mit Branch-Erstellung und PR
category: develop
---

# Implement Linear Issue

Automatisierte Umsetzung von Linear Issues: Issue abrufen, Branch erstellen, implementieren und Pull Request erstellen.

## Übersicht

Dieser Command orchestriert den kompletten Workflow von Linear Issue bis Pull Request:

1. **Issue abrufen** - Linear Issue-Daten via MCP Server
2. **Branch erstellen** - `feature/<issue-id>-<issue-title>` vor Start
3. **Status aktualisieren** - Issue auf "In Progress" setzen
4. **Implementierung** - Code-Änderungen basierend auf Issue-Beschreibung
5. **PR erstellen** - Pull Request mit Linear-Verlinkung

## Verwendung

```bash
# Mit Issue-ID
/develop:implement-linear-issue PROJ-123

# Ohne Argument (interaktive Auswahl)
/develop:implement-linear-issue
```

## Workflow

### 1. Issue-Identifikation

**Argument vorhanden**:

- Issue-ID validieren und abrufen

**Kein Argument**:

- Zugewiesene Issues auflisten
- User wählt Issue interaktiv aus

### 2. Issue-Daten Abruf

Via Linear MCP Server folgende Daten abrufen:

- **Titel & Beschreibung** - Für Branch-Name und Kontext
- **Labels/Tags** - Für Commit-Typ-Bestimmung (feat/fix/etc.)
- **Status** - Aktueller Workflow-Status
- **Assignee** - Validierung der Zuständigkeit
- **Akzeptanzkriterien** - Als Test-Plan-Checkliste

### 3. Branch-Erstellung

**Branch-Naming-Schema**:

```text
feature/<issue-id>-<issue-title-slug>
```

**Beispiele**:

- `PROJ-123` → `feature/PROJ-123-user-authentication`
- `TEAM-456` → `feature/TEAM-456-dark-mode-toggle`

**Vor Branch-Erstellung prüfen**:

- ✅ Working Directory sauber (git status)
- ✅ Aktueller Branch ist main/develop
- ✅ Remote ist up-to-date (git fetch)

### 4. Issue-Status Update

Issue-Status auf **"In Progress"** setzen via Linear MCP:

- Workflow-Transition validieren
- Status-Update durchführen
- Bestätigung protokollieren

### 5. Implementierung

**Implementierungs-Strategie**:

1. Issue-Beschreibung analysieren
2. Betroffene Dateien identifizieren
3. Code-Änderungen durchführen
4. Tests schreiben (basierend auf Akzeptanzkriterien)

**Labels → Commit-Typ Mapping**:

- `bug`, `fix` → 🐛 fix
- `feature`, `enhancement` → ✨ feat
- `docs`, `documentation` → 📚 docs
- `refactor` → ♻️ refactor
- `performance` → ⚡ perf
- `test` → 🧪 test

### 6. PR-Erstellung

**PR-Template mit Linear-Integration**:

```markdown
## Linear Issue: [PROJ-123](https://linear.app/team/issue/PROJ-123)

**Beschreibung**:
<Issue-Beschreibung>

**Änderungen**:
- <Änderung 1>
- <Änderung 2>

**Test-Plan**:
- [ ] <Akzeptanzkriterium 1>
- [ ] <Akzeptanzkriterium 2>

**Linear Status**: In Progress → In Review
```

**PR-Labels** (basierend auf Issue-Labels):

- Issue hat `bug` → PR bekommt `bug`
- Issue hat `feature` → PR bekommt `enhancement`

## Konfiguration

### Linear MCP Server Setup

**Erforderlich**: Linear MCP Server muss konfiguriert sein.

**Installation** (siehe [linear-integration.md](./implement-linear-issue/linear-integration.md)):

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "<your-api-key>"
      }
    }
  }
}
```

### Linear Projekt-Konfiguration

**In CLAUDE.md festhalten**:

```markdown
## Linear Integration

- **Workspace**: `your-team`
- **Projekt**: `PROJ` (Projekt-Key)
- **Workflow**: Backlog → In Progress → In Review → Done
```

## Error Handling

**Issue nicht gefunden**:

- Validierung der Issue-ID
- Alternative Issues vorschlagen
- Abbruch mit klarer Fehlermeldung

**Branch existiert bereits**:

- Warnung anzeigen
- Option zum Wechseln oder neuen Branch erstellen

**Linear MCP nicht verfügbar**:

- Fehlermeldung mit Setup-Anleitung
- Verweis auf [linear-integration.md](./implement-linear-issue/linear-integration.md)

## Detail-Dokumentation

Für weiterführende Informationen siehe:

- **[linear-integration.md](./implement-linear-issue/linear-integration.md)** - Linear MCP Server Setup, API-Details, GraphQL-Queries
- **[workflow.md](./implement-linear-issue/workflow.md)** - Detaillierter Workflow, Best Practices, Beispiele
- **[troubleshooting.md](./implement-linear-issue/troubleshooting.md)** - Häufige Probleme, Lösungen, Debugging
- **[best-practices.md](./implement-linear-issue/best-practices.md)** - Branch-Naming, Commit-Messages, PR-Gestaltung

## Beispiele

### Vollständiger Workflow

```bash
# Command aufrufen
/develop:implement-linear-issue PROJ-123

# Claude:
# ✅ Issue PROJ-123 abgerufen: "User Authentication"
# ✅ Branch erstellt: feature/PROJ-123-user-authentication
# ✅ Issue-Status: Backlog → In Progress
# 🔄 Implementierung startet...
# ✅ Code-Änderungen durchgeführt
# ✅ Tests geschrieben
# ✅ PR erstellt: #456
```

### Interaktive Issue-Auswahl

```bash
# Command ohne Argument
/develop:implement-linear-issue

# Claude:
# Ihre zugewiesenen Issues:
# 1. PROJ-123 - User Authentication (In Progress)
# 2. PROJ-124 - Dark Mode Toggle (Backlog)
# 3. PROJ-125 - API Rate Limiting (Backlog)
# Welches Issue möchten Sie umsetzen? [1-3]:
```

## Siehe auch

- **[/commit](./commit.md)** - Professionelle Git-Commits
- **[/create-pr](./create-pr.md)** - Pull Request-Erstellung
- **[/develop:check-commands](./check-commands.md)** - Command-Validierung
