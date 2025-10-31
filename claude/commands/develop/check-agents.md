---
description: Validiert Agenten-Dateien, YAML-Frontmatter (inkl. color-Attribut) und Best Practices
category: develop
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# Agent Validation Tool

Dieser Command validiert Claude Code Agenten auf:

- YAML-Frontmatter Struktur (inkl. **color-Attribut**)
- Markdown-Syntax
- Agent-spezifische Best Practices
- Vollständigkeit der Dokumentation

## Usage

```bash
# Spezifischen Agenten prüfen
/develop:check-agents claude/agents/code-reviewer.md

# Oder ohne Pfad für interaktive Auswahl
/develop:check-agents
```

## Validierungs-Checks

### 1. YAML-Frontmatter

**Required**:

- `name` (String, lowercase mit Bindestrichen, z.B. "code-reviewer")
- `description` (String, 1-200 Zeichen)
- `color` (String, eine der erlaubten Farben)

**Optional**:

- `category` (String, z.B. "quality-security", "specialized-domains")
- `model` (String: "sonnet", "opus", "haiku")
- `tools` (Array von Tool-Namen oder Komma-separierter String)
- `allowed-tools` (Array von Tool-Namen)

**Format**:

```yaml
---
name: code-reviewer
description: Experte für Code-Reviews mit Fokus auf Qualität und Sicherheit
category: quality-security
model: sonnet
color: blue
tools: Read, Write, Grep
---
```

### 2. Color-Attribut Validierung

**Erlaubte Farben**:

- `blue` - Standard für Code-/Entwicklungs-Agenten
- `green` - Für Testing-/Validierungs-Agenten
- `red` - Für Security-/Critical-Agenten
- `yellow` - Für Dokumentations-Agenten
- `purple` - Für Research-/Analyse-Agenten
- `orange` - Für Build-/Deployment-Agenten
- `cyan` - Für Data-/Database-Agenten
- `magenta` - Für UI/UX-Agenten

**Validation**:

- ✅ Color-Attribut muss vorhanden sein
- ✅ Color muss eine der erlaubten Farben sein
- ✅ Color sollte zur Kategorie/Funktion passen

**Empfehlungen**:

```yaml
# Gut ✅
name: code-reviewer
category: quality-security
color: blue

# Gut ✅
name: test-automator
category: testing
color: green

# Fehlt ❌
name: markdown-formatter
category: specialized-domains
# KEIN color-Attribut!

# Falsche Farbe ❌
name: security-auditor
color: pink  # Nicht erlaubt
```

### 3. Markdown-Struktur

- Muss mit Frontmatter beginnen
- Mindestens eine H1-Überschrift (`# Agent Name`)
- Valides CommonMark-Format
- Klare Abschnitte (Rolle, Aktivierung, Prozess, etc.)

**Empfohlene Struktur**:

```markdown
# Agent Name

[Kurze Beschreibung]

## Rolle / Core Expertise

[Was der Agent kann]

## Aktivierung / Vorgehen

[Wann und wie der Agent verwendet wird]

## Prozess / Workflow

[Schritt-für-Schritt Ablauf]

## Bereitstellung / Output

[Was der Agent liefert]
```

### 4. Agent-spezifische Best Practices

**Name**:

- ✅ Lowercase mit Bindestrichen: `code-reviewer`
- ❌ CamelCase oder Unterstriche: `CodeReviewer`, `code_reviewer`
- ✅ Beschreibend und prägnant
- ✅ Stimmt mit Dateinamen überein (ohne `.md`)

**Description**:

- Kurz und prägnant (1-200 Zeichen)
- Beschreibt WAS der Agent tut
- Optional: WANN der Agent verwendet werden soll
- Optional: Proaktiv-Hinweis ("MUST BE USED when...", "Use PROACTIVELY...")
- **Sprache: Deutsch** (technische Begriffe auf Englisch erlaubt)

**Dokumentation (Markdown-Body)**:

- **Primär auf Deutsch** verfasst
- Technische Begriffe (z.B. "Code-Review", "Testing") können auf Englisch bleiben
- Fachbegriffe (z.B. "Progressive Disclosure") auf Englisch erlaubt
- Konsistente Sprache innerhalb eines Agenten

**Category** (optional, aber empfohlen):


- Gruppiert verwandte Agenten
- Beispiele: `quality-security`, `specialized-domains`, `skill-builder`, `development`, `testing`

**Model** (optional):

- `sonnet` - Standard (balanced)
- `opus` - Komplexe Aufgaben
- `haiku` - Schnelle, einfache Aufgaben

## Validierungs-Workflow

Wenn du diesen Command ausführst, solltest du:

1. **Agenten-Pfad ermitteln**:
   - Falls kein Pfad angegeben: Alle `.md`-Dateien in `claude/agents/` listen (rekursiv)
   - User wählt Agenten aus oder du verarbeitest alle

2. **Datei einlesen**:
   - Read-Tool verwenden
   - Prüfen ob Datei existiert

3. **YAML-Frontmatter parsen**:
   - Ersten Block zwischen `---` extrahieren
   - Required-Felder prüfen: `name`, `description`, **`color`**
   - Optional-Felder validieren: `category`, `model`, `tools`
   - Format-Validierung (keine Syntax-Fehler)

4. **Color-Attribut Check**:
   - ❌ Fehlt color-Attribut komplett?
   - ❌ Ist color nicht in erlaubten Farben?
   - ⚠️ Passt color zur Kategorie/Funktion?

5. **Markdown validieren**:
   - Mindestens eine H1-Überschrift vorhanden
   - Name in H1 stimmt mit `name` in YAML überein (empfohlen)
   - Grundlegende CommonMark-Struktur

6. **Name validieren**:
   - Lowercase mit Bindestrichen
   - Stimmt mit Dateinamen überein
   - Format: `[a-z][a-z0-9-]*`

7. **Report ausgeben**

   **Erfolgreicher Agent**:

   ```markdown
   ## Validation Report: code-reviewer

   ✅ YAML-Frontmatter: Valid
   ✅ Color-Attribut: blue (valid ✓)
   ✅ Markdown-Struktur: Valid
   ✅ Name Convention: Valid
   ✅ Best Practices: Compliant

   ### Details:
   - Name: code-reviewer (matches filename ✓)
   - Description: "Experte für Code-Reviews..." (91 chars ✓)
   - Category: quality-security ✓
   - Model: sonnet ✓
   - Color: blue (appropriate for code-review ✓)

   ✨ Agent is fully compliant!
   ```

   **Agent mit fehlendem Color**:

   ```markdown
   ## Validation Report: markdown-syntax-formatter

   ✅ YAML-Frontmatter: Valid (except color)
   ❌ Color-Attribut: MISSING
   ✅ Markdown-Struktur: Valid
   ✅ Name Convention: Valid
   ⚠️  Best Practices: Partially compliant

   ### Issues to fix:
   1. ❌ REQUIRED: Add 'color' field to YAML frontmatter
      Recommended: color: yellow (documentation/formatting agent)

   ### Recommended fix:
   ```yaml
   ---
   name: markdown-syntax-formatter
   category: specialized-domains
   description: Konvertiert Text mit visueller Formatierung...
   color: yellow  # ADD THIS LINE
   ---
   ```

   ### Available colors

   - blue: Code/Development agents
   - green: Testing/Validation agents
   - red: Security/Critical agents
   - yellow: Documentation agents ← RECOMMENDED
   - purple: Research/Analysis agents
   - orange: Build/Deployment agents
   - cyan: Data/Database agents
   - magenta: UI/UX agents

   **Agent mit ungültiger Color**:

   ```markdown
   ## Validation Report: example-agent

   ✅ YAML-Frontmatter: Valid (except color)
   ❌ Color-Attribut: INVALID ("pink" not allowed)
   ✅ Markdown-Struktur: Valid
   ✅ Name Convention: Valid

   ### Issues to fix:
   1. ❌ Color "pink" is not in allowed colors list
      Change to one of: blue, green, red, yellow, purple, orange, cyan, magenta

   ### Recommended fix:
   Choose appropriate color based on agent function:
   - If code-related → blue
   - If testing-related → green
   - If security-related → red
   - If documentation-related → yellow
   - If research-related → purple
   ```

8. **Bulk-Validierung** (alle Agenten):

   ```markdown
   ## Bulk Validation Report: claude/agents/

   Found 5 agent files:

   ✅ code-reviewer.md - Fully compliant
   ❌ markdown-syntax-formatter.md - Missing color
   ❌ skill-documenter-agent.md - Missing color
   ❌ skill-elicitation-agent.md - Missing color
   ❌ skill-generator-agent.md - Missing color

   ### Summary:
   - Total agents: 5
   - Compliant: 1 (20%)
   - Missing color: 4 (80%)
   - Invalid color: 0 (0%)
   - Other issues: 0 (0%)

   ### Agents needing color attribute:
   1. markdown-syntax-formatter.md → Recommended: yellow
   2. skill-documenter-agent.md → Recommended: yellow
   3. skill-elicitation-agent.md → Recommended: purple
   4. skill-generator-agent.md → Recommended: blue

   ### Quick fix script:
   Would you like me to add the recommended colors to all agents?
   ```

## Error Handling

- **Datei nicht gefunden**: Klare Fehlermeldung mit Pfad
- **YAML-Parse-Fehler**: Zeige Zeile und Fehler
- **Fehlende Required-Felder**: Liste alle fehlenden Felder (inkl. color!)
- **Ungültige Color**: Zeige erlaubte Farben + Empfehlung

## Auto-Fix Option

Nach der Validierung kannst du optional anbieten:

```text
🔧 Auto-Fix verfügbar!

Soll ich die fehlenden color-Attribute automatisch hinzufügen?
[Ja] Füge empfohlene Farben hinzu
[Nein] Nur Report anzeigen
[Manuell] Zeige mir was zu tun ist
```

Falls "Ja":

- Analysiere Agent-Funktion aus `name` und `description`
- Wähle passende Farbe
- Füge `color: [farbe]` zum YAML-Frontmatter hinzu
- Zeige Diff vor dem Schreiben

## Integration mit anderen Commands

Dieser Command ist nützlich:

- **Vor dem Commit**: Agenten validieren bevor sie commited werden
- **Nach Änderungen**: Sicherstellen dass alle Agenten compliant sind
- **Neue Agenten**: Initiales Setup überprüfen
- **Bulk-Check**: Alle Agenten auf einmal prüfen

## Beispiele

**Einzelner Agent mit Color**:

```text
/develop:check-agents claude/agents/code-reviewer.md
→ ✅ Fully compliant (color: blue)
```

**Einzelner Agent ohne Color**:

```text
/develop:check-agents claude/agents/markdown-syntax-formatter.md
→ ❌ Missing color attribute
→ 💡 Recommended: yellow (documentation agent)
```

**Alle Agenten prüfen**:

```text
/develop:check-agents
→ Found 5 agents, 4 missing color
→ [Bulk Report anzeigen]
```

**Mit Auto-Fix**:

```text
/develop:check-agents --fix
→ Fixed 4 agents, added color attributes
→ [Show changes]
```

## Color-Kategorie Mapping

Zur Orientierung für Auto-Fix oder manuelle Zuweisung:

| Agent-Typ | Empfohlene Farbe | Beispiele |
|-----------|------------------|-----------|
| Code-Review, Development | `blue` | code-reviewer, developer |
| Testing, Validation | `green` | test-automator, validator |
| Security, Critical | `red` | security-auditor, penetration-tester |
| Documentation, Writing | `yellow` | documenter, markdown-formatter |
| Research, Analysis | `purple` | researcher, analyst |
| Build, Deployment, CI/CD | `orange` | deployer, builder |
| Data, Database | `cyan` | data-engineer, db-optimizer |
| UI/UX, Design | `magenta` | ui-designer, ux-specialist |

**Keywords für Auto-Detection**:

- Blue: "code", "review", "developer", "engineer", "refactor"
- Green: "test", "validate", "check", "verify", "qa"
- Red: "security", "audit", "vulnerability", "pentest"
- Yellow: "document", "write", "markdown", "format", "guide"
- Purple: "research", "analyze", "investigate", "synthesize"
- Orange: "build", "deploy", "ci", "cd", "release"
- Cyan: "data", "database", "query", "etl", "pipeline"
- Magenta: "ui", "ux", "design", "interface", "accessibility"

## Notes

- Dieser Command sollte selbst Best Practices folgen ✨
- Color-Attribut ist ab sofort REQUIRED für alle Agenten
- Auto-Fix sollte intelligent Farben vorschlagen basierend auf Agent-Funktion
- Bei Unsicherheit: Nutzer fragen welche Farbe gewünscht ist
