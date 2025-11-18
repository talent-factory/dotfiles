# Claude Code Developer Documentation

**Technical documentation for Claude Code integration, commands, agents, and architecture.**

> **Note**: This document is for developers and contributors. For general usage and installation, see [README.md](README.md).

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Commands](#commands)
  - [/commit](#commit---professionelle-git-commits)
  - [/create-pr](#create-pr---pull-requests-erstellen)
  - [/develop:check-agents](#developcheck-agents---agent-validation)
  - [/develop:check-commands](#developcheck-commands---command-validation)
  - [/project:create-prd](#projectcreate-prd---product-requirements-documents)
  - [/project:create-plan](#projectcreate-plan---projektplanung-aus-prd)
- [Agenten](#agenten)
- [Skill-Builder System](#skill-builder-system)
- [Progressive Disclosure](#progressive-disclosure)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Professional Claude Code configuration with comprehensive commands, agents, and best practices for software development and product management.

**Features:**
- **6 Main Commands** for development and product management
- **Progressive Disclosure Pattern** for optimal performance
- **~5,500 lines** of best practices documentation
- **4 PRD Templates** (MVP, Standard, Major Initiative, Technical)
- **Linear Integration** for EPIC-based project planning
- **Skill-Builder System** with 4 specialized agents
- **Industry-Standard Methods** (SMART, MoSCoW, Risk Matrix, Story Points)

### Architecture

```text
agents/claude/
├── agents/                      # Specialized agents
│   ├── code-reviewer.md         # Code review agent
│   ├── markdown-syntax-formatter.md
│   └── skill-builder/           # Skill builder system
│       ├── README.md
│       ├── skill-documenter-agent.md
│       ├── skill-elicitation-agent.md
│       ├── skill-generator-agent.md
│       └── skill-validator-agent.md
│
└── commands/                    # Commands with progressive disclosure
    ├── develop/
    │   ├── commit.md            # 85 lines (main command)
    │   ├── commit/              # 1,246 lines (details)
    │   ├── create-pr.md         # 115 lines (main command)
    │   └── create-pr/           # 2,067 lines (details)
    ├── project/
    │   ├── create-prd.md        # 232 lines (main command)
    │   ├── create-prd/          # 2,213 lines (details)
    │   ├── create-plan.md       # 266 lines (main command)
    │   └── create-plan/         # 2,492 lines (details)
    └── skills/
        ├── build-skill.md
        ├── package-skill.md
        ├── scripts/             # Validation & packaging
        └── templates/           # 5 skill templates
```

---

## Quick Start

### Installation

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions.

**TL;DR:**

```bash
# macOS/Linux
git clone https://github.com/talent-factory/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --interactive

# Windows
git clone https://github.com/talent-factory/dotfiles.git $env:USERPROFILE\.dotfiles
cd $env:USERPROFILE\.dotfiles
.\install.ps1 -Interactive
```

### Verification

After installation, verify commands are available in Claude Code:

```bash
# Commands should be accessible via slash commands:
/commit
/create-pr
/develop:check-agents
/develop:check-commands
/project:create-prd
/project:create-plan

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
/project:create-plan

# Oder in der Command-Palette nach "commit", "create-pr", "check-agents", "check-commands", "create-prd" oder "create-plan" suchen
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

### `/project:create-plan` - Projektplanung aus PRD

Erstellt einen strukturierten Projektplan aus einem PRD-Dokument und verwaltet Tasks als EPIC mit zugehörigen Issues in Linear.

**Location**: `claude/commands/project/create-plan.md`

#### Features

- ✅ **PRD-basierte Planung** mit vollständiger Analyse
- ✅ **Linear EPIC-Erstellung** für PRD-Features
- ✅ **Task-Breakdown** in atomare, umsetzbare Tasks
- ✅ **Agent-Empfehlungen** für jeden Task-Typ
- ✅ **Duplikat-Vermeidung** durch intelligente Checks
- ✅ **Konsistenz-Validierung** vor Speicherung
- ✅ **Story Point Estimation** mit T-Shirt Sizing
- ✅ **Dependency-Management** zwischen Tasks

#### Verwendung

```bash
# Standard: PRD.md im aktuellen Verzeichnis
/project:create-plan

# Mit spezifischem PRD
/project:create-plan --prd docs/requirements/feature-x.md

# Interaktiver Modus
/project:create-plan --interactive
```

#### Rolle & Expertise

Der Command agiert als **Scrum Master, Product Owner und Entwicklungsleiter** mit:
- MSc Computer Science Expertise
- Best Practices von renommierten Universitäten
- Agile Methoden (Scrum, Kanban, User Story Mapping)
- Linear Integration für EPIC-basierte Projekt-Strukturierung

#### Workflow

1. **PRD einlesen**
   - Standard: `PRD.md` im aktuellen Verzeichnis
   - Custom: Über `--prd <Pfad>` angegeben
   - Validierung: Struktur, Ziele, Priorisierung (MoSCoW)

2. **EPIC in Linear erstellen**
   - PRD als EPIC speichern
   - Executive Summary, Business Value, Success Metrics
   - Duplikat-Check für bestehende EPICs
   - Interaktive Bestätigung bei Konflikten

3. **Task-Breakdown durchführen**
   - Atomare, actionable Tasks aus PRD ableiten
   - Akzeptanzkriterien definieren
   - Story Points schätzen (1, 2, 3, 5, 8)
   - Agent-Empfehlungen zuweisen

4. **Issues in Linear erstellen**
   - Jeder Task als Issue unter EPIC
   - Priority basierend auf MoSCoW
   - Labels für Technology Stack & Type
   - Dependencies verknüpfen

5. **Konsistenz-Check**
   - Keine Duplikate oder Redundanzen
   - Konsistentes Gesamtbild
   - Dependencies korrekt verknüpft
   - Priorisierung logisch

#### Agent-Empfehlungen

Automatische Zuordnung von KI-Agenten basierend auf Task-Typ:

| Task-Typ | Empfohlene Agenten |
|----------|-------------------|
| **Java Backend** | `java-developer` |
| **Python Backend** | `python-expert` |
| **React/Next.js Frontend** | `frontend-developer` |
| **AI/ML Features** | `ai-engineer` |
| **Code Review** | `code-reviewer` |
| **Documentation** | `markdown-syntax-formatter` |
| **Testing** | `test-automator` |
| **Agent Development** | `agent-expert` |

**Details**: [create-plan/agent-mapping.md](claude/commands/project/create-plan/agent-mapping.md)

#### Task-Kriterien

**Gute Tasks erfüllen ATOMIC**:
- **A**ctionable: Sofort umsetzbar
- **T**estable: Akzeptanzkriterien definiert
- **O**wnable: Einer Person zuweisbar
- **M**easurable: Story Points (2-8 SP)
- **I**ndependent: Minimal Dependencies
- **C**omplete: In sich abgeschlossen

#### Linear-Integration

**Verwendete Features**:
- **Projects/EPICs**: PRD-basierte Features
- **Issues**: Individuelle Tasks
- **Labels**: Technology, Type, Priority
- **Estimates**: Story Points
- **Dependencies**: Task-Verknüpfungen
- **Custom Fields**: Agent Recommendations

#### Beispiel-Workflow

```bash
# 1. PRD erstellen
/project:create-prd "Dark Mode Toggle"

# 2. Plan aus PRD generieren
/project:create-plan --prd PRD.md

# Output:
# ✅ PRD eingelesen: PRD.md
# ✅ EPIC erstellt: "Dark Mode Toggle" (LIN-123)
# ✅ 8 Tasks generiert:
#    - LIN-124: UI Toggle Component (3 SP) [frontend-developer]
#    - LIN-125: Theme State Management (5 SP) [frontend-developer]
#    - LIN-126: CSS Variables Setup (2 SP) [frontend-developer]
#    - LIN-127: Local Storage Persistence (2 SP) [frontend-developer]
#    - LIN-128: Unit Tests (3 SP) [test-automator]
#    - LIN-129: Integration Tests (3 SP) [test-automator]
#    - LIN-130: Documentation (2 SP) [markdown-syntax-formatter]
#    - LIN-131: Code Review (1 SP) [code-reviewer]
# ✅ Dependencies verknüpft
# ✅ Labels hinzugefügt: feature, ui, accessibility
```

#### Detail-Dokumentation

- **[Linear Integration](claude/commands/project/create-plan/linear-integration.md)** (557 Zeilen)
  - Linear-API-Verwendung
  - EPIC/Issue-Struktur
  - Custom Fields Setup
  - Label-Strategie
  - Duplikat-Erkennung

- **[Task Breakdown](claude/commands/project/create-plan/task-breakdown.md)** (626 Zeilen)
  - Task-Sizing Strategien
  - Abhängigkeiten identifizieren
  - Story Point Estimation
  - Cross-Cutting Concerns
  - Task-Templates

- **[Agent Mapping](claude/commands/project/create-plan/agent-mapping.md)** (647 Zeilen)
  - Verfügbare KI-Agenten
  - Expertise-Mapping
  - Task-Typ → Agent
  - Multi-Agent-Workflows
  - Custom Agent Integration

- **[Best Practices](claude/commands/project/create-plan/best-practices.md)** (662 Zeilen)
  - PRD-zentrierte Planung
  - Atomic Task Guidelines
  - Akzeptanzkriterien definieren
  - Duplikat-Vermeidung
  - Estimation Best Practices
  - Qualitätskriterien

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
| create-plan.md | N/A | 266 Zeilen | Neu |

**Gesamt-Dokumentation**: ~14.500 Zeilen (inkl. Details)

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

For issues and questions:
1. Check the relevant troubleshooting guides
2. Review git history for recent changes
3. Verify symlinks and permissions
4. Open an issue on GitHub

---

## Contributing

We welcome contributions to improve Claude Code configurations!

### How to Contribute

1. **Fork** the repository
2. **Create a feature branch** from `develop`
3. **Make your changes** following our standards
4. **Test** your changes with Claude Code
5. **Submit a Pull Request**

**See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.**

### Development Guidelines

- **Commit Messages**: Use emoji conventional commits (see `/commit` command)
- **Code Review**: All PRs require review before merging
- **Testing**: Test commands in Claude Code before submitting
- **Documentation**: Update relevant docs for any changes

### Adding New Commands

1. Create command file in `agents/claude/commands/<category>/<command-name>.md`
2. Add YAML frontmatter with `description` and `category`
3. Use progressive disclosure for commands >250 lines
4. Document in this file
5. Test in Claude Code
6. Submit PR

### Adding New Agents

1. Create agent file in `agents/claude/agents/<agent-name>.md`
2. Add YAML frontmatter with `name`, `description`, and `color`
3. Document role, activation, and process
4. Test agent functionality
5. Submit PR

**See [agents/claude/commands/develop/check-commands.md](agents/claude/commands/develop/check-commands.md) and [agents/claude/commands/develop/check-agents.md](agents/claude/commands/develop/check-agents.md) for validation.**

---

## License

This project is licensed under the **MIT License**.

You are free to use, modify, and distribute this project. See [LICENSE](LICENSE) for full details.

**TL;DR**: Commercial and private use allowed, attribution appreciated but not required.

---

## Changelog

### Version 3.0.0 (November 2024)

**Major Release: Open Source + Multi-Agent System**

**New Features:**
- ✨ Open Source mit MIT License
- ✨ Multi-Agent Support (Augment, Claude, Copilot, Windsurf)
- ✨ Cross-Platform (macOS, Linux, Windows)
- ✨ Interactive Installation mit Agent-Auswahl
- ✨ Contributing Guidelines und Community Standards
- ✨ Issue Templates und PR Templates
- 📚 CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md

**Architecture:**
- ♻️ Umstrukturierung: `claude/` → `agents/claude/`
- 🏗️ Modulares Installer-System (`install/lib/`, `install/agents/`)
- 🪟 PowerShell-Support für Windows
- 📦 Agent-spezifische Installer-Module

**Documentation:**
- 📚 Neue README.md für Open Source
- 📚 INSTALLATION.md aktualisiert
- 📚 WINDOWS_INSTALLATION.md hinzugefügt
- 📚 PROJECT_SUMMARY.md (4,500+ Zeilen)
- 📚 AI_AGENTS_REFERENCE.md

**Migration**: Automatisch via `./install.sh` oder `.\install.ps1`

### Version 2.1.0 (November 2024)

**Hauptänderungen**:
- ✨ `/project:create-plan` Command hinzugefügt
- ✨ Linear-Integration für EPIC-basierte Projektplanung
- ✨ Agent-Empfehlungs-System für Task-Zuordnung
- ✨ Task-Breakdown mit Story Points & Dependencies
- ✨ 4 neue Agenten mit color-Attribut
- 📚 +2,758 Zeilen Dokumentation

### Version 2.0.0 (Oktober 2024)

**Hauptänderungen**:
- ✨ Progressive Disclosure Implementation
- ✨ PRD Best Practices (~2,800 Zeilen)
- ✨ 4 PRD-Templates
- ✨ Skill-Builder System
- ♻️ Commands um 38-41% reduziert

### Version 1.0.0 (Initial)

- Basis Commands (commit, create-pr, create-prd)
- Monolithische Struktur
- Grundlegende Dokumentation

---

**Version**: 3.0.0 (Open Source + Multi-Agent)
**Last Updated**: November 2024
**Maintainer**: Daniel
**License**: MIT

**⭐ Star this project if it helps you!**
