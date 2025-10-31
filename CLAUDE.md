# Claude Code Konfiguration

Umfassende Dokumentation der Claude Code Integration mit Commands, Agenten und Best Practices.

## Inhaltsverzeichnis

- [Übersicht](#übersicht)
- [Installation](#installation)
- [Commands](#commands)
  - [/commit](#commit---professionelle-git-commits)
  - [/create-pr](#create-pr---pull-requests-erstellen)
  - [/develop:check-agents](#developcheck-agents---agent-validation)
  - [/develop:check-commands](#developcheck-commands---command-validation)
  - [/project:create-prd](#projectcreate-prd---product-requirements-documents)
- [Agenten](#agenten)
- [Skill-Builder System](#skill-builder-system)
- [Progressive Disclosure](#progressive-disclosure)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Übersicht

Dieses Repository enthält eine professionelle Claude Code Konfiguration mit:

- **5 Haupt-Commands** für Development und Product Management
- **Progressive Disclosure Pattern** für optimale Performance
- **~2.800 Zeilen Best Practices Dokumentation**
- **4 PRD-Templates** (MVP, Standard, Major Initiative, Technical)
- **Skill-Builder System** mit 4 spezialisierten Agenten
- **Industry-Standard Methoden** (SMART, MoSCoW, Risiko-Matrix)

### Architektur

```text
.claude/
├── agents/                      # Spezialisierte Agenten
│   ├── code-reviewer.md         # Code-Review Agent
│   ├── markdown-syntax-formatter.md
│   └── skill-builder/           # Skill-Builder System
│       ├── README.md
│       ├── skill-documenter-agent.md
│       ├── skill-elicitation-agent.md
│       ├── skill-generator-agent.md
│       └── skill-validator-agent.md
│
└── commands/                    # Commands mit Progressive Disclosure
    ├── develop/
    │   ├── commit.md            # 85 Zeilen (Haupt-Command)
    │   ├── commit/              # 1.246 Zeilen (Details)
    │   ├── create-pr.md         # 115 Zeilen (Haupt-Command)
    │   └── create-pr/           # 2.067 Zeilen (Details)
    ├── project/
    │   ├── create-prd.md        # 232 Zeilen (Haupt-Command)
    │   └── create-prd/          # 2.213 Zeilen (Details)
    └── skills/
        ├── build-skill.md
        ├── package-skill.md
        ├── scripts/             # Validierung & Packaging
        └── templates/           # 5 Skill-Templates
```

## Installation

### Voraussetzungen

- Claude Code installiert
- Git konfiguriert
- macOS oder Linux

### Automatische Installation

Das `install.sh` Script richtet automatisch die Claude-Konfiguration ein:

```bash
cd ~/.dotfiles
./install.sh
```

Das Script wird:

1. ✅ Backup von existierender `~/.claude/` erstellen
2. ✅ Symlink von `~/.claude/` zu `.claude/` im Repository erstellen
3. ✅ Verfügbarkeit der Commands verifizieren
4. ✅ Agenten-Verfügbarkeit prüfen

### Manuelle Installation

Falls Sie die Installation manuell durchführen möchten:

```bash
# Backup erstellen (falls .claude existiert)
[[ -d ~/.claude ]] && mv ~/.claude ~/.claude.backup_$(date +%Y%m%d)

# Symlink erstellen
ln -sf ~/.dotfiles/.claude ~/.claude

# Verifizieren
ls -la ~/.claude/commands/
ls -la ~/.claude/agents/
```

### Verifikation

Nach der Installation in Claude Code prüfen:

```bash
# Commands sollten verfügbar sein:
/commit
/create-pr
/develop:check-agents
/develop:check-commands
/project:create-prd

# Oder in der Command-Palette nach "commit", "create-pr", "check-agents", "check-commands" oder "create-prd" suchen
```

### Environment Variables Setup

⚠️ **Wichtig**: API Keys werden über `~/.env` verwaltet und sind NICHT im Repository!

```bash
# .env aus Template erstellen
cp ~/.dotfiles/.env.example ~/.env

# API Keys hinzufügen
vim ~/.env
```

Die Shell-Konfiguration lädt automatisch alle Variablen aus `~/.env`.

## Commands

### `/commit` - Professionelle Git-Commits

Erstellt professionelle Git-Commits mit automatischen Pre-Commit-Checks und konventionellen Commit-Nachrichten.

**Location**: `.claude/commands/develop/commit.md`

#### Features

- ✅ **Pre-Commit-Checks** für Java, Python, React/Node.js, Dokumentation
- ✅ **Staging-Analyse** mit automatischem Add bei Bedarf
- ✅ **Diff-Analyse** erkennt logische Änderungen
- ✅ **Emoji Conventional Commits** (✨ feat, 🐛 fix, 📚 docs, etc.)
- ✅ **Atomare Commits** für bessere Git-Historie
- ✅ **Commit-Aufteilung** bei mehreren logischen Änderungen

#### Verwendung

```bash
# Standard-Commit
/commit

# Mit Optionen
/commit --no-verify     # Überspringt Pre-Commit-Checks
/commit --skip-tests    # Überspringt Tests
/commit --force-push    # Force Push (Vorsicht!)
```

#### Unterstützte Projekttypen

**Java**: Maven, Gradle, Spring Boot
- Builds, Tests, Checkstyle, SpotBugs

**Python**: Ruff, Black, pytest, mypy
- Linting, Formatierung, Type-Checking, Tests

**React/Node.js**: ESLint, Prettier, TypeScript, Jest/Vitest
- Linting, Formatierung, Type-Checking, Tests, Builds

**Dokumentation**: LaTeX, Markdown, AsciiDoc
- Kompilierung, Validierung, Rendering

#### Commit-Typen

| Emoji | Type | Beschreibung |
|-------|------|--------------|
| ✨ | `feat` | Neue Funktionalität |
| 🐛 | `fix` | Fehlerbehebung |
| 📚 | `docs` | Dokumentation |
| 💎 | `style` | Code-Formatierung |
| ♻️ | `refactor` | Code-Umstrukturierung |
| ⚡ | `perf` | Performance |
| 🧪 | `test` | Tests |
| 🔧 | `chore` | Build, Tools, Konfiguration |
| 🚀 | `ci` | CI/CD |
| 🔒 | `security` | Sicherheit |

**Vollständige Liste**: [commit/commit-types.md](.claude/commands/develop/commit/commit-types.md)

#### Detail-Dokumentation

- **[Pre-Commit-Checks](.claude/commands/develop/commit/pre-commit-checks.md)** (150 Zeilen)
  - Detaillierte Check-Beschreibungen pro Projekttyp
  - Fehlerbehebungs-Anleitungen

- **[Commit-Types](.claude/commands/develop/commit/commit-types.md)** (205 Zeilen)
  - Alle Emoji-Typen mit Beispielen
  - Best-Practice Format

- **[Best Practices](.claude/commands/develop/commit/best-practices.md)** (321 Zeilen)
  - Atomare Commits
  - Imperative Form
  - Code-Qualität vor Commit
  - Git-Historie sauber halten

- **[Troubleshooting](.claude/commands/develop/commit/troubleshooting.md)** (486 Zeilen)
  - Build-Fehler
  - Test-Probleme
  - Linting-Issues
  - Merge-Konflikte

---

### `/create-pr` - Pull Requests erstellen

Erstellt automatisch einen neuen Branch, analysiert Änderungen und erstellt einen professionellen Pull Request.

**Location**: `.claude/commands/develop/create-pr.md`

#### Features

- ✅ **Automatische Branch-Erstellung** mit aussagekräftigen Namen
- ✅ **Code-Formatierung** (Biome, Black, Prettier, etc.)
- ✅ **Integration mit /commit** - keine doppelte Commit-Logik
- ✅ **PR-Template** mit Test-Plan und Beschreibung
- ✅ **Label-Management** basierend auf Änderungstyp
- ✅ **Issue-Verlinkung** automatisch erkannt

#### Verwendung

```bash
# Standard-Pull-Request
/create-pr

# Mit Optionen
/create-pr --draft          # Erstellt Draft-PR
/create-pr --no-format      # Überspringt Code-Formatierung
/create-pr --single-commit  # Alle Änderungen in einem Commit
/create-pr --target main    # Ziel-Branch angeben
```

#### Workflow

1. **Änderungen prüfen**: Uncommitted oder committed?
2. **Commit erstellen**: Ruft `/commit` auf falls nötig
3. **Branch erstellen**: `feature/beschreibung-2024-10-30`
4. **Code formatieren**: Optional, projektspezifisch
5. **PR erstellen**: Mit aussagekräftigem Titel und Test-Plan

#### Code-Formatierung

**JavaScript/TypeScript**: Biome
- Format und Linting in einem Tool

**Python**: Black, isort, Ruff
- Formatierung, Import-Sortierung, Linting

**Java**: Google Java Format
- Maven/Gradle Integration

**Markdown**: markdownlint, mdformat
- Validierung und Formatierung

#### Detail-Dokumentation

- **[Code-Formatting](.claude/commands/develop/create-pr/code-formatting.md)** (383 Zeilen)
  - Formatierung pro Sprache
  - Tool-Konfiguration
  - Troubleshooting

- **[Commit-Workflow](.claude/commands/develop/create-pr/commit-workflow.md)** (468 Zeilen)
  - Integration mit /commit
  - Branch-Erstellung
  - Push-Strategien

- **[PR-Template](.claude/commands/develop/create-pr/pr-template.md)** (529 Zeilen)
  - Standard-Template
  - Best Practices
  - Review-Prozess

- **[Troubleshooting](.claude/commands/develop/create-pr/troubleshooting.md)** (687 Zeilen)
  - Branch-Probleme
  - GitHub CLI Issues
  - Merge-Konflikte

---

### `/develop:check-agents` - Agent Validation

Validiert Claude Code Agenten auf YAML-Struktur (inkl. **color-Attribut**), Markdown-Syntax und Best Practices.

**Location**: `claude/commands/develop/check-agents.md`

#### Features

- ✅ **YAML-Frontmatter Validierung** (name, description, **color**)
- ✅ **Color-Attribut Pflicht** - 8 erlaubte Farben mit semantischer Bedeutung
- ✅ **Markdown-Struktur Check** (H1-Überschriften, CommonMark)
- ✅ **Best Practices Validation** (Naming, Category, Model)
- ✅ **Bulk-Validierung** - Alle Agenten auf einmal prüfen
- ✅ **Auto-Fix Option** - Intelligente Farb-Vorschläge

#### Verwendung

```bash
# Spezifischen Agenten prüfen
/develop:check-agents claude/agents/code-reviewer.md

# Interaktive Auswahl / Bulk-Check
/develop:check-agents
```

#### Color-Attribut (Required)

Alle Agenten **müssen** ein `color`-Attribut haben:

| Farbe | Verwendung | Beispiele |
|-------|------------|-----------|
| `blue` | Code/Development | code-reviewer, developer |
| `green` | Testing/Validation | test-automator, validator |
| `red` | Security/Critical | security-auditor |
| `yellow` | Documentation | documenter, formatter |
| `purple` | Research/Analysis | researcher, analyst |
| `orange` | Build/Deployment | deployer, ci-specialist |
| `cyan` | Data/Database | data-engineer, db-optimizer |
| `magenta` | UI/UX | ui-designer, ux-specialist |

#### Validierungs-Checks

**YAML-Frontmatter**:
- `name` (required, lowercase mit Bindestrichen)
- `description` (required, 1-200 Zeichen)
- `color` (required, eine der 8 erlaubten Farben)
- `category` (optional, empfohlen)
- `model` (optional: sonnet/opus/haiku)
- `tools` (optional)

**Markdown-Struktur**:
- Mindestens eine H1-Überschrift
- Valides CommonMark-Format
- Empfohlene Abschnitte: Rolle, Aktivierung, Prozess

**Best Practices**:
- Name in lowercase mit Bindestrichen
- Name stimmt mit Dateinamen überein
- Color passt zur Agent-Funktion

#### Example Reports

**Compliant Agent**:
```markdown
## Validation Report: code-reviewer

✅ YAML-Frontmatter: Valid
✅ Color-Attribut: blue (valid ✓)
✅ Markdown-Struktur: Valid
✅ Best Practices: Compliant

✨ Agent is fully compliant!
```

**Missing Color**:
```markdown
## Validation Report: markdown-syntax-formatter

❌ Color-Attribut: MISSING
💡 Recommended: color: yellow (documentation agent)

### Quick fix:
Add to YAML frontmatter:
color: yellow
```

**Bulk Report**:
```markdown
## Bulk Validation: 6 agents

✅ Compliant: 2 (33%)
❌ Missing color: 4 (67%)

Agents needing color:
- markdown-syntax-formatter.md → yellow
- skill-documenter-agent.md → yellow
- skill-generator-agent.md → blue
- skill-validator-agent.md → green
```

#### Use Cases

- **Vor dem Commit**: Agenten validieren
- **Neue Agenten**: Color-Attribut nicht vergessen
- **Bulk-Check**: Alle Agenten auf Compliance prüfen
- **Migration**: Bestehende Agenten mit color ausstatten

---

### `/develop:check-commands` - Command Validation

Validiert Claude Code Commands auf Struktur, Dokumentation und Best Practices.

**Location**: `claude/commands/develop/check-commands.md`

#### Features

- ✅ **YAML-Frontmatter Validierung** (required & optional fields)
- ✅ **Markdown-Struktur Check** (H1-Überschriften, Links)
- ✅ **Dokumentations-Prüfung** (Progressive Disclosure, Detail-Dateien)
- ✅ **Best Practices Validation** (Naming, Category, Description)
- ✅ **Detaillierte Reports** mit Fehlerbeschreibungen und Fixes

#### Verwendung

```bash
# Spezifischen Command prüfen
/develop:check-commands claude/commands/develop/commit.md

# Interaktive Auswahl
/develop:check-commands
```

#### Validierungs-Checks

**YAML-Frontmatter**:
- `description` (required, 1-100 Zeichen)
- `category` (required, muss existierendem Ordner entsprechen)
- `allowed-tools` (optional, Array)

**Markdown-Struktur**:
- Mindestens eine H1-Überschrift
- Valides CommonMark-Format
- Keine kaputten Links

**Dokumentation**:
- Progressive Disclosure für >250 Zeilen Commands
- Detail-Dateien im Unterordner
- Referenzen auf Detail-Dateien gültig

**Best Practices**:
- Lowercase Dateinamen mit Bindestrichen
- Prägnante Descriptions (1-100 chars)
- Korrekte Kategorie-Zuordnung

#### Example Report

```markdown
## Validation Report: /develop:commit

✅ YAML-Frontmatter: Valid
✅ Markdown-Struktur: Valid
✅ Dokumentation: Complete
✅ Best Practices: Compliant
✅ Progressive Disclosure: Implemented (84 lines main, 4 detail files)

✨ Command is fully compliant!
```

#### Use Cases

- **Vor dem Commit**: Commands validieren
- **Nach Änderungen**: Integrität sicherstellen
- **Neue Commands**: Initiales Setup überprüfen

---

### `/project:create-prd` - Product Requirements Documents

Erstellt professionelle Product Requirements Documents nach Industry-Best-Practices.

**Location**: `.claude/commands/project/create-prd.md`

#### Features

- ✅ **4 PRD-Templates** (MVP, Standard, Major Initiative, Technical)
- ✅ **SMART-Ziele** (Spezifisch, Messbar, Erreichbar, Relevant, Terminiert)
- ✅ **MoSCoW-Priorisierung** (Must/Should/Could/Won't)
- ✅ **Nutzer-zentriert** (nicht lösungszentriert)
- ✅ **Risikobewertung** mit Mitigation-Strategien
- ✅ **Erfolgsmetriken** mit Tracking-Plan

#### Verwendung

```bash
# Einfache PRD
/project:create-prd "Dark Mode Toggle"

# Mit Ausgabepfad
/project:create-prd "KI-gestützte Budgetierung" docs/prds/budget-ai.md
```

#### PRD-Struktur

1. **Executive Summary** (3-5 Sätze)
   - Was, Für wen, Warum, Impact, Timeline

2. **Problemstellung**
   - Aktueller Zustand, Problem, Auswirkungen, Evidenz

3. **Ziele & Erfolgsmetriken**
   - SMART-Ziele, Primäre/Sekundäre Metriken, Guardrails

4. **User Stories & Personas**
   - Datenbasierte Personas, User Stories, Akzeptanzkriterien

5. **Funktionale Anforderungen**
   - MoSCoW-priorisiert, detailliert, mit Edge Cases

6. **Nicht-funktionale Anforderungen**
   - Performance, Security, Scalability, Usability, Accessibility

7. **Abgrenzung (Out of Scope)**
   - Was NICHT gebaut wird, Rationale, Future Timeline

8. **Risikobewertung**
   - Risiko-Matrix, Mitigation, Contingency-Pläne

9. **Timeline & Meilensteine**
   - Phasen, Dependencies, Approvals

#### Templates

**Template-Auswahl nach Projekt-Komplexität**:

| Typ | Dauer | Komplexität | Template |
|-----|-------|-------------|----------|
| Small Feature | < 2 Wochen | Niedrig | Minimal MVP |
| Standard Feature | 4-8 Wochen | Mittel | Standard Feature |
| Major Initiative | > 2 Monate | Hoch | Major Initiative |
| Platform/Infra | Variabel | Mittel-Hoch | Technical PRD |

#### Best Practices

**Nutzer-zentriert**:
- ✅ Fokus auf Problem, nicht Lösung
- ✅ "Warum" und "Was", nicht "Wie"
- ❌ Keine technischen Implementation-Details

**Messbare Ziele**:
- ✅ Konkrete Baseline & Target-Werte
- ✅ Tracking-Plan mit Analytics-Events
- ❌ Keine vagen Ziele wie "mehr Nutzer"

**Klare Priorisierung**:
- ✅ MoSCoW-Methode konsequent anwenden
- ✅ Rationale für jede Priorisierung
- ❌ Nicht alles als "Must-Have" markieren

#### Detail-Dokumentation

- **[Best Practices](.claude/commands/project/create-prd/best-practices.md)** (538 Zeilen)
  - Grundprinzipien
  - Erfolgsmetriken (SMART)
  - Risikobewertung
  - Stakeholder-Management
  - Häufige Fehler

- **[Templates](.claude/commands/project/create-prd/templates.md)** (799 Zeilen)
  - 4 vollständige Templates
  - Template-Auswahl-Guide
  - Anpassungs-Tipps

- **[Sections-Guide](.claude/commands/project/create-prd/sections-guide.md)** (899 Zeilen)
  - Detaillierter Guide pro Abschnitt
  - Beispiele (✅ vs. ❌)
  - Schreibtipps
  - Häufige Fehler

---

## Agenten

### Code-Reviewer Agent

**Location**: `.claude/agents/code-reviewer.md`

Proaktiver Code-Review-Agent für Qualität, Sicherheit und Wartbarkeit.

**Verwendung**: Wird automatisch nach Commits aufgerufen oder manuell:

```
Review den Code in src/components/
```

**Features**:
- Code-Qualität Checks
- Security-Analyse
- Performance-Review
- Best Practices Validation

### Markdown Syntax Formatter

**Location**: `.claude/agents/markdown-syntax-formatter.md`

Formatiert Markdown-Dateien nach CommonMark-Standard.

**Verwendung**:

```
Formatiere README.md nach CommonMark
```

### Skill-Builder Agents

**Location**: `.claude/agents/skill-builder/`

4 spezialisierte Agenten für Skill-Entwicklung:

1. **skill-elicitation-agent.md**
   - Requirements-Analyse
   - Fragestellung
   - Specification-Erstellung

2. **skill-generator-agent.md**
   - Skill-Code-Generierung
   - Dateistruktur-Erstellung
   - Dependency-Dokumentation

3. **skill-validator-agent.md**
   - YAML-Validierung
   - Struktur-Checks
   - Code-Testing
   - Integration-Testing

4. **skill-documenter-agent.md**
   - SKILL.md Enhancement
   - Reference Documentation
   - Example Collection
   - README Creation

**Vollständige Dokumentation**: [.claude/agents/skill-builder/README.md](.claude/agents/skill-builder/README.md)

---

## Skill-Builder System

Vollständiges System zur Entwicklung professioneller Claude Code Skills.

**Location**: `.claude/commands/skills/`

### Commands

#### `/skills:build-skill`

Orchestriert alle 4 Skill-Builder-Agenten für komplette Skill-Entwicklung.

**Workflow**:
1. Requirements Elicitation
2. Skill Generation
3. Validation & Testing
4. Documentation Enhancement

**Verwendung**:

```bash
/skills:build-skill
```

Claude führt Sie durch den interaktiven Prozess.

#### `/skills:package-skill`

Validiert und verpackt Skills in distributable ZIP-Files.

**Verwendung**:

```bash
/skills:package-skill
```

**Features**:
- Quick & Comprehensive Validation
- ZIP-Packaging mit Struktur
- Distribution Guidelines

### Scripts

**Location**: `.claude/commands/skills/scripts/`

- **init_skill.py**: Skill-Initialisierung aus Template
- **package_skill.py**: ZIP-Packaging
- **quick_validate.py**: Schnelle YAML-Validierung
- **validate-skill.sh**: Umfassende 10-Phasen-Validierung
- **test-skill-trigger.sh**: Trigger-Testing

### Templates

**Location**: `.claude/commands/skills/templates/`

5 verschiedene Skill-Templates:

1. **simple-skill-template.md** - Basis-Template
2. **multi-file-skill-template.md** - Mit Referenz-Dateien
3. **tool-restricted-skill-template.md** - Read-Only Skills
4. **enhanced-simple-skill-template.md** - Mit Metadata
5. **enhanced-multi-file-skill-template.md** - Vollständig

### Dokumentation

- **[QUICKSTART.md](.claude/commands/skills/QUICKSTART.md)** - Schnelleinstieg
- **[README.md](.claude/commands/skills/README.md)** - Vollständige Dokumentation

---

## Progressive Disclosure

Ein Kernelement dieser Konfiguration ist das **Progressive Disclosure Pattern**.

### Konzept

**Problem**: Große Command-Dateien (100+ Zeilen) führen zu:
- Langsamerer Verarbeitung
- Höherem Token-Verbrauch
- Schlechterer Übersichtlichkeit

**Lösung**: Progressive Disclosure
- Kompakte Haupt-Commands (50-120 Zeilen)
- Details in separate Dateien ausgelagert
- Claude lädt Details nur bei Bedarf

### Implementation

#### Vorher (Monolithisch)

```
commit.md (136 Zeilen)
└── Alles in einer Datei
```

#### Nachher (Progressive Disclosure)

```
commit.md (85 Zeilen)
├── Übersicht & Workflow
├── Referenzen zu Details
└── commit/
    ├── pre-commit-checks.md (150 Zeilen)
    ├── commit-types.md (205 Zeilen)
    ├── best-practices.md (321 Zeilen)
    └── troubleshooting.md (486 Zeilen)
```

### Vorteile

**Performance**:
- ⚡ 38-41% weniger Zeilen in Haupt-Commands
- ⚡ Schnellere initiale Verarbeitung
- ⚡ Reduzierter Token-Verbrauch

**Usability**:
- 📖 Bessere Übersicht
- 🔍 Einfachere Navigation
- 📚 Strukturierte Detail-Informationen

**Wartbarkeit**:
- 🛠️ Modulare Updates
- 📝 Isolierte Änderungen
- 🔄 Einfachere Versionierung

### Metriken

| Command | Vorher | Nachher | Reduktion |
|---------|--------|---------|-----------|
| commit.md | 136 Zeilen | 85 Zeilen | -38% |
| create-pr.md | 195 Zeilen | 115 Zeilen | -41% |
| create-prd.md | 48 Zeilen | 232 Zeilen | +384% (erweitert) |

**Gesamt-Dokumentation**: ~11.700 Zeilen (inkl. Details)

---

## Best Practices

### Git Workflow

**Atomare Commits**:
```bash
# Gut ✅
git commit -m "✨ feat: User-Dashboard hinzugefügt"
git commit -m "🧪 test: Dashboard-Tests implementiert"

# Schlecht ❌
git commit -m "Alles aktualisiert"
```

**Commit-Messages**:
- Imperativ-Form: "Füge hinzu" nicht "Hinzugefügt"
- Erste Zeile ≤ 72 Zeichen
- Emoji Conventional Commits
- Beschreibendes "Was" und "Warum"

**Vollständige Guidelines**: [commit/best-practices.md](.claude/commands/develop/commit/best-practices.md)

### PRD-Erstellung

**Nutzer-zentriert**:
```markdown
# Gut ✅
## Problem
Nutzer können Ausgaben nicht effektiv tracken, was zu
Budgetüberschreitungen führt (45% in User-Survey).

# Schlecht ❌
## Lösung
Wir bauen ein Dashboard mit React und PostgreSQL.
```

**SMART-Ziele**:
```markdown
# Gut ✅
Feature Adoption: 60% der User nutzen Dashboard innerhalb
4 Wochen nach Launch (Baseline: N/A, Messung: Analytics)

# Schlecht ❌
Nutzer sollen Feature verwenden und glücklich sein.
```

**Vollständige Guidelines**: [create-prd/best-practices.md](.claude/commands/project/create-prd/best-practices.md)

### Pull Requests

**PR-Größe**:
- ✅ 150-400 Zeilen: Ideal
- ⚠️ 400-800 Zeilen: Noch OK
- ❌ 800+ Zeilen: Zu groß, aufteilen

**PR-Template**:
```markdown
## Beschreibung
[Kurze Beschreibung]

## Änderungen
- Änderung 1
- Änderung 2

## Test-Plan
- [ ] Unit Tests
- [ ] Integration Tests
- [ ] Manual Testing

## Breaking Changes
[Falls vorhanden]
```

**Vollständige Guidelines**: [create-pr/pr-template.md](.claude/commands/develop/create-pr/pr-template.md)

---

## Troubleshooting

### Commands nicht verfügbar

**Problem**: Commands erscheinen nicht in Claude Code

**Diagnose**:
```bash
# 1. Prüfe Symlink
ls -la ~/.claude
# Sollte zeigen: .claude -> /Users/daniel/.dotfiles/.claude

# 2. Prüfe Commands
ls -la ~/.claude/commands/develop/

# 3. Prüfe Berechtigungen
ls -la ~/.claude/commands/develop/*.md
```

**Lösung**:
```bash
# Symlink neu erstellen
cd ~/.dotfiles
./install.sh

# Claude Code neu starten
```

### Symlink-Probleme

**Problem**: Symlink zeigt auf falsches Ziel

**Lösung**:
```bash
# Alten Symlink entfernen
rm ~/.claude

# Neuen erstellen
ln -sf ~/.dotfiles/.claude ~/.claude

# Verifizieren
ls -la ~/.claude
```

### Pre-Commit-Checks schlagen fehl

**Problem**: `/commit` meldet Check-Fehler

**Lösung**:
1. **Build-Fehler**: Siehe [commit/troubleshooting.md](.claude/commands/develop/commit/troubleshooting.md)
2. **Test-Fehler**: `--skip-tests` Option verwenden
3. **Linting**: Auto-Fix wo möglich, sonst manuell

```bash
# Checks überspringen (nur für Debugging!)
/commit --no-verify
```

### GitHub CLI Probleme

**Problem**: `gh` Commands funktionieren nicht

**Diagnose**:
```bash
gh auth status
gh repo view
```

**Lösung**:
```bash
# Re-Authentifizierung
gh auth login

# Token-Permissions aktualisieren
gh auth refresh -s repo
```

**Vollständige Troubleshooting**: [create-pr/troubleshooting.md](.claude/commands/develop/create-pr/troubleshooting.md)

---

## Wartung & Updates

### Repository aktualisieren

```bash
cd ~/.dotfiles
git pull origin develop
./install.sh  # Nur bei Struktur-Änderungen
```

### Neue Commands hinzufügen

1. **Command erstellen**: `.claude/commands/category/new-command.md`
2. **Frontmatter definieren**:
   ```yaml
   ---
   description: Kurze Beschreibung
   category: category
   allowed-tools:
     - Tool1
     - Tool2
   ---
   ```
3. **Testen**: Command in Claude Code aufrufen
4. **Committen**: Mit `/commit`

### Dokumentation erweitern

1. **Detail-Dateien** in Command-Unterordner
2. **Referenzen** im Haupt-Command aktualisieren
3. **Best Practices** befolgen (Progressive Disclosure)

---

## Weiterführende Ressourcen

### Dokumentation

- **Commands**:
  - [commit/](.claude/commands/develop/commit/) - Git Commit Dokumentation
  - [create-pr/](.claude/commands/develop/create-pr/) - PR Dokumentation
  - [create-prd/](.claude/commands/project/create-prd/) - PRD Dokumentation

- **Skills**:
  - [skills/](.claude/commands/skills/) - Skill-Builder System
  - [agents/skill-builder/](.claude/agents/skill-builder/) - Skill-Agenten

### Claude Code

- **Offizielle Docs**: https://docs.claude.com/en/docs/claude-code
- **GitHub**: https://github.com/anthropics/claude-code

### Support

Bei Problemen:
1. Konsultieren Sie die jeweiligen Troubleshooting-Guides
2. Prüfen Sie Git-Historie für kürzliche Änderungen
3. Verifizieren Sie Symlinks und Berechtigungen

---

## Änderungshistorie

### Version 2.0.0 (Oktober 2024)

**Hauptänderungen**:
- ✨ Progressive Disclosure Implementation
- ✨ Umstrukturierung von `claude/` zu `.claude/`
- ✨ PRD Best Practices hinzugefügt (~2.800 Zeilen)
- ✨ 4 PRD-Templates (MVP, Standard, Major, Technical)
- ✨ Skill-Builder System mit 4 Agenten
- ♻️ Commands um 38-41% reduziert
- 📚 11.700+ Zeilen Gesamt-Dokumentation

**Migration**: Automatisch via `install.sh`

### Version 1.0.0 (Initial)

- Basis Commands (commit, create-pr, create-prd)
- Monolithische Struktur
- Grundlegende Dokumentation

---

**Version**: 2.0.0
**Zuletzt aktualisiert**: Oktober 2024
**Maintainer**: Daniel
