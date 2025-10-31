---
description: Test-getriebener Entwicklungsworkflow mit Red-Green-Refactor Prozess und Branch-Management
category: code-analysis-testing
allowed-tools: Read, Write, Edit, Bash(git *)
---

# Test-Driven Development (TDD)

Dies beschreibt die Entwicklungspraktiken und Prinzipien, die befolgt werden müssen. Beginne nicht mit Features bevor du dazu aufgefordert wirst, dieses Dokument soll dich in die richtige Denkweise versetzen.

1. Stelle sicher, dass du auf dem main-Branch bist bevor du beginnst (außer du wirst angewiesen auf einem spezifischen Branch zu starten)
2. Verstehe den vorhandenen Code bevor du ihn änderst
3. Erstelle einen Branch für das Feature, den Bugfix oder das angeforderte Refactoring
4. Verwende test-getriebene Entwicklung. Red-Green-Refactor Prozess (unten beschrieben)
5. Beim Committen in Git, lasse den Claude-Footer in Kommentaren weg
6. Schließe jedes Feature, jeden Bug oder Refactor ab indem du den Branch zu GitHub pushst und einen Pull Request erstellst
7. Falls du mehrere Features, Bugs und/oder Refactors bearbeiten sollst, kannst du dann zum nächsten übergehen

## High-Level Ablauf

### Einzeln vs. mehrere

Manchmal bekommst du eine Aufgabe. Manchmal bekommst du eine Aufgabenliste.
Die Liste könnte als Git-Repository Issue-Liste bereitgestellt werden, zum Beispiel.

Falls du mehrere auf einmal bekommst, beginne mit der ersten und vervollständige sie eine nach der anderen, erstelle einen Branch für jede und einen Pull Request wenn fertig.

### Notizen führen

Erstelle eine Markdown-Datei unter dem notes/features/ Ordner für das Feature. Falls du einen Feature-Branch erstellst, verwende denselben Namen.

Nutze diese Notizen-Datei um Antworten auf klärende Fragen und andere wichtige Dinge während der Arbeit am Feature festzuhalten. Dies kann dein Langzeitgedächtnis sein falls die Session unterbrochen wird und du später darauf zurückkommen musst.

Dies sind deine Notizen, also füge gerne hinzu, modifiziere, ordne neu an und lösche Inhalte in der Notizen-Datei.

Du kannst, wenn du möchtest, andere Notizen hinzufügen die dir oder zukünftigen Entwicklern hilfreich sein könnten, aber mehr ist nicht immer besser. Sei kurz und hilfreich.

### Feature verstehen

1. Lies zuerst die README.md und alle relevanten Dokumente auf die sie verweist
2. Stelle zusätzliche klärende Fragen (falls es wichtige Unklarheiten gibt) 
