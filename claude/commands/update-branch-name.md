---
description: Aktualisiere Branch-Namen nach Namenskonventionen
category: version-control-git
argument-hint: <neuer_branch_name>
allowed-tools: Bash(git *)
---

# Branch-Namen aktualisieren

Aktualisiere Branch-Namen auf: $ARGUMENTS

## Branch-Umbenennung

1. **Aktuellen Branch-Namen prüfen**:

   ```bash
   git branch --show-current
   ```

2. **Branch lokal umbenennen**:

   ```bash
   git branch -m $ARGUMENTS
   ```

3. **Alten Remote-Branch löschen**:

   ```bash
   git push origin --delete <alter_branch_name>
   ```

4. **Neuen Branch-Namen pushen**:

   ```bash
   git push origin $ARGUMENTS
   ```

5. **Upstream-Tracking setzen**:

   ```bash
   git push --set-upstream origin $ARGUMENTS
   ```

## Namenskonventionen

- `feature/beschreibung` - Neue Features
- `fix/beschreibung` - Fehlerbehebungen  
- `hotfix/beschreibung` - Kritische Fixes
- `refactor/beschreibung` - Code-Refactoring
- `docs/beschreibung` - Dokumentationsänderungen
