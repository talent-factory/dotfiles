---
description: Generiere Mermaid-Diagramme für Dokumentation und Visualisierung
category: documentation-changelogs
argument-hint: <diagramm_typ> <beschreibung>
allowed-tools: Write, Read
---

# Mermaid-Diagramme erstellen

Generiere Mermaid-Diagramm: $ARGUMENTS

## Diagramm-Typen

### Flussdiagramm

```mermaid
flowchart TD
    A[Start] --> B{Entscheidung}
    B -->|Ja| C[Aktion 1]
    B -->|Nein| D[Aktion 2]
    C --> E[Ende]
    D --> E
```

### Sequenzdiagramm

```mermaid
sequenceDiagram
    participant A as Benutzer
    participant B as System
    A->>B: Anfrage
    B-->>A: Antwort
```

### Klassendiagramm

```mermaid
classDiagram
    class Benutzer {
        +String name
        +String email
        +login()
        +logout()
    }
```

### Gantt-Diagramm

```mermaid
gantt
    title Projekt-Zeitplan
    dateFormat  YYYY-MM-DD
    section Phase 1
    Aufgabe 1    :2024-01-01, 30d
    Aufgabe 2    :2024-01-15, 20d
```

## Verwendung

1. **Diagramm-Typ identifizieren**
2. **Mermaid-Syntax erstellen**
3. **Diagramm in Mermaid-Viewer testen**
4. **In Dokumentation einbetten**

## Best Practices

- Klare, aussagekräftige Labels verwenden
- Konsistente Farbschemata anwenden
- Diagramme nicht zu komplex gestalten
- Legende hinzufügen bei Bedarf
