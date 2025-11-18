---
description: Erstelle einen Projektplan aus PRD und verwalte Tasks in Linear
category: project
argument-hint: "[--prd <PRD-Pfad>] [--interactive]"
allowed-tools:
  - Read
  - Write
  - TodoWrite
  - AskUserQuestion
  - mcp__linear__*
---

# Claude Command: Create Project Plan

Erstelle einen strukturierten Projektplan aus einem PRD-Dokument und verwalte Tasks als EPIC mit zugehörigen Issues in Linear.

## Rolle & Expertise

Du agierst als **Scrum Master, Product Owner und Entwicklungsleiter** mit folgender Expertise:

- **Akademischer Hintergrund**: MSc in Computer Science
- **Best Practices**: Aktuelle Standards von renommierten Universitäten und Fachhochschulen
- **Agile Methoden**: Scrum, Kanban, User Story Mapping
- **Linear Integration**: EPIC-basierte Projekt-Strukturierung

## Verwendung

```bash
# Standard: PRD.md im aktuellen Verzeichnis
/project:create-plan

# Spezifisches PRD-Dokument
/project:create-plan --prd docs/requirements/feature-x.md

# Interaktiver Modus
/project:create-plan --interactive
```

## Workflow

### 1. PRD-Dokument einlesen

- **Standard**: `PRD.md` im aktuellen Verzeichnis
- **Custom**: Über `--prd <Pfad>` angegeben
- **Fallback**: Interaktive Nachfrage falls nicht gefunden

**Validierung**:
- PRD-Struktur vollständig?
- Ziele & Erfolgsmetriken definiert?
- Anforderungen priorisiert (MoSCoW)?

### 2. EPIC in Linear erstellen

Das PRD wird als **EPIC** in Linear gespeichert:

```
EPIC: [Feature-Name]
├── Description: Executive Summary aus PRD
├── Status: planned
├── Priority: Basierend auf PRD-Priorisierung
└── Metadata: Link zum vollständigen PRD
```

**Duplikat-Check**:
- Prüfe existierende EPICs mit gleichem/ähnlichem Namen
- Interaktive Bestätigung bei Duplikaten
- Option: Existierendes EPIC aktualisieren

### 3. Task-Breakdown durchführen

Leite aus dem PRD **in sich abgeschlossene Tasks** ab:

**Kriterien für gute Tasks**:
- ✅ **Atomic**: Eine logische Einheit
- ✅ **Actionable**: Sofort umsetzbar
- ✅ **Testable**: Akzeptanzkriterien definiert
- ✅ **Assignable**: Für einen Entwickler/Agenten
- ✅ **Estimated**: Geschätzter Aufwand (Story Points)

**Task-Struktur**:
```
Task: [Konkrete Beschreibung]
├── Description: Detaillierte Anforderungen
├── Acceptance Criteria: Messbare Erfolgskriterien
├── Dependencies: Andere Tasks
├── Agent Recommendation: Vorgeschlagener KI-Agent
├── Estimate: Story Points (1, 2, 3, 5, 8)
└── Labels: Tags für Kategorisierung
```

### 4. Linear Issues erstellen

Jeder Task wird als **Issue** unter dem EPIC erstellt:

- **Title**: Prägnant und beschreibend
- **Description**: Vollständige Task-Details
- **Priority**: Must/Should/Could/Won't
- **Estimate**: Story Points
- **Labels**: Technology Stack, Type, etc.
- **Agent Hints**: Empfohlene KI-Agenten

### 5. Konsistenz-Check

**Vor dem Speichern**:
- [ ] Keine Duplikate oder Redundanzen
- [ ] Konsistentes Gesamtbild der Anwendung
- [ ] Tasks sind vollständig und umsetzbar
- [ ] Dependencies korrekt verknüpft
- [ ] Priorisierung logisch

## Agent-Empfehlungen

Basierend auf Task-Typ werden KI-Agenten empfohlen:

| Task-Typ | Empfohlene Agenten | Verwendung |
|----------|-------------------|------------|
| **Code Review** | `code-reviewer` | Qualitätssicherung |
| **Java Development** | `java-developer` | Spring Boot, Enterprise Java |
| **Python Development** | `python-expert` | Django, FastAPI, Data Science |
| **AI/ML Features** | `ai-engineer` | LLM-Integration, ML-Pipelines |
| **Agent Development** | `agent-expert` | KI-Agenten-Entwicklung |
| **Documentation** | `markdown-syntax-formatter` | Docs, READMEs |
| **Testing** | `test-automator` | Unit/Integration Tests |

**Details**: [create-plan/agent-mapping.md](create-plan/agent-mapping.md)

## Qualitätskriterien

### Tasks müssen erfüllen:

- [ ] **Präzise Formulierung**: Entwickler können ohne Nachfragen umsetzen
- [ ] **Klare Akzeptanzkriterien**: Testbar und messbar
- [ ] **Dependencies dokumentiert**: Reihenfolge klar
- [ ] **Realistische Schätzung**: Story Points basierend auf Komplexität
- [ ] **Agent-Empfehlung**: Passender KI-Agent vorgeschlagen (falls verfügbar)

### EPIC muss enthalten:

- [ ] **Executive Summary**: Kurze Übersicht
- [ ] **Business Value**: Warum wird das gebaut?
- [ ] **Success Metrics**: Messbare Ziele
- [ ] **Timeline**: Grobe Meilensteine
- [ ] **Dependencies**: Externe Abhängigkeiten

## Duplikat-Vermeidung

**Vor EPIC-Erstellung**:
1. Suche existierende EPICs mit ähnlichem Namen
2. Prüfe aktive Issues mit überlappenden Anforderungen
3. Interaktive Bestätigung bei Duplikaten:
   - Neues EPIC erstellen
   - Existierendes EPIC erweitern
   - Abbrechen und PRD anpassen

**Vor Issue-Erstellung**:
1. Prüfe existierende Issues im EPIC
2. Vermeide redundante Aufgaben
3. Merge ähnliche Tasks

## Linear-Integration

**Verwendete Linear-Features**:
- **Projects/EPICs**: Für PRD-basierte Features
- **Issues**: Für individuelle Tasks
- **Labels**: Technology, Type, Priority
- **Estimates**: Story Points
- **Dependencies**: Task-Verknüpfungen
- **Custom Fields**: Agent Recommendations

**Details**: [create-plan/linear-integration.md](create-plan/linear-integration.md)

## Task-Breakdown Strategien

**Aus funktionalen Anforderungen**:
- Eine Anforderung = Ein oder mehrere Tasks
- Must-Have → Höchste Priorität
- Should/Could-Have → Mittlere/Niedrige Priorität

**Aus nicht-funktionalen Anforderungen**:
- Performance-Tasks separat
- Security-Review als eigene Tasks
- Accessibility nach Feature-Tasks

**Cross-Cutting Concerns**:
- Testing als separate Tasks
- Documentation Tasks
- CI/CD Setup
- Monitoring & Observability

**Details**: [create-plan/task-breakdown.md](create-plan/task-breakdown.md)

## Best Practices

**DO ✅**:
- PRD vollständig analysieren vor Task-Erstellung
- Atomic Tasks: Eine logische Einheit pro Task
- Klare Akzeptanzkriterien definieren
- Dependencies explizit dokumentieren
- Realistische Schätzungen (T-Shirt Sizing)
- Agent-Empfehlungen basierend auf Expertise
- Duplikat-Check vor Erstellung

**DON'T ❌**:
- Zu große Tasks (> 8 Story Points)
- Vage Beschreibungen ohne Akzeptanzkriterien
- Tasks ohne Priorisierung
- Redundante oder überlappende Tasks
- Dependencies ignorieren
- Linear ohne Duplikat-Check befüllen

**Vollständiger Guide**: [create-plan/best-practices.md](create-plan/best-practices.md)

## Beispiel-Workflow

```bash
# 1. PRD erstellen
/project:create-prd "Dark Mode Toggle"

# 2. Plan aus PRD generieren
/project:create-plan --prd PRD.md

# Output:
# ✅ PRD eingelesen: PRD.md
# ✅ EPIC erstellt: "Dark Mode Toggle" (LIN-123)
# ✅ 8 Tasks generiert:
#    - LIN-124: UI Toggle Component (3 SP) [java-developer]
#    - LIN-125: Theme State Management (5 SP) [java-developer]
#    - LIN-126: CSS Variables Setup (2 SP) [java-developer]
#    - LIN-127: Local Storage Persistence (2 SP) [java-developer]
#    - LIN-128: Unit Tests (3 SP) [test-automator]
#    - LIN-129: Integration Tests (3 SP) [test-automator]
#    - LIN-130: Documentation (2 SP) [markdown-syntax-formatter]
#    - LIN-131: Code Review (1 SP) [code-reviewer]
# ✅ Dependencies verknüpft
# ✅ Labels hinzugefügt: feature, ui, accessibility
```

## Weitere Informationen

- **Linear Integration**: [create-plan/linear-integration.md](create-plan/linear-integration.md)
  - Linear-API-Verwendung
  - EPIC/Issue-Struktur
  - Custom Fields Setup
  - Label-Strategie

- **Task Breakdown**: [create-plan/task-breakdown.md](create-plan/task-breakdown.md)
  - Task-Sizing Strategien
  - Abhängigkeiten identifizieren
  - Story Point Estimation
  - Cross-Cutting Concerns

- **Agent Mapping**: [create-plan/agent-mapping.md](create-plan/agent-mapping.md)
  - Verfügbare KI-Agenten
  - Expertise-Mapping
  - Task-Typ → Agent
  - Custom Agent Integration

- **Best Practices**: [create-plan/best-practices.md](create-plan/best-practices.md)
  - Atomic Task Guidelines
  - Akzeptanzkriterien definieren
  - Duplikat-Vermeidung
  - Estimation Best Practices

---

**PRD-Pfad**: $ARGUMENTS
