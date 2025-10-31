---
description: Erstelle und führe automatisch einen Git-Commit mit der ersten vorgeschlagenen Commit-Message aus
category: version-control-git
allowed-tools: Bash(git *)
---

# Schnellen Commit erstellen

Diese Aufgabe verwendet die gleiche Logik wie der commit-Task (.claude/commands/commit.md), wählt aber automatisch die erste vorgeschlagene Commit-Message ohne Bestätigung aus.

## Prozess

- **3 Commit-Message-Vorschläge generieren** im gleichen Format wie der commit-Task
- **Automatisch ersten Vorschlag verwenden** ohne Benutzer zu fragen
- **Sofort `git commit -m` ausführen** mit der ersten Message
- **Alle anderen Verhaltensweisen bleiben gleich** wie beim commit-Task (Format, Package-Namen, nur staged Files)
- **KEINE Claude Co-Authorship-Footer** zu Commits hinzufügen
