# Dotfiles

Persönliches Dotfiles Management Repository für macOS.

## Struktur

```text
dotfiles/
├── install.sh              # Installations-Script
├── config/                 # ~/.config Verzeichnis-Inhalte
├── shell/                  # Shell-Konfigurationen (zsh, bash)
├── git/                    # Git-Konfigurationen
├── vim/                    # Vim-Konfigurationen
├── claude/                 # Claude-Konfigurationen
├── ssh/                    # SSH-Konfigurations-Templates
└── local/                  # ~/.local Verzeichnis-Inhalte
```

## Installation

1. Repository klonen:

   ```bash
   git clone <repository-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Installations-Script ausführen:

   ```bash
   ./install.sh
   ```

Das Script wird:

- Backups von existierenden Konfigurationsdateien erstellen
- Symbolische Links von deinem Home-Verzeichnis zu den Dotfiles in diesem Repository erstellen
- Korrekte Berechtigungen für SSH-Konfigurationen setzen

## Neue Dotfiles hinzufügen

1. Kopiere deine Konfigurationsdatei in das entsprechende Verzeichnis in diesem Repository
2. Aktualisiere das `install.sh` Script falls nötig
3. Committe und pushe deine Änderungen

## Backup

Das Installations-Script erstellt automatisch Backups von existierenden Dateien in `~/.dotfiles_backup_<timestamp>/` bevor Symlinks erstellt werden.

## SSH-Konfiguration

SSH-Konfigurationen werden aus Sicherheitsgründen speziell behandelt. Die `ssh/config.template` Datei bietet einen Ausgangspunkt den du lokal anpassen kannst.

## Verwendung auf neuen Systemen

Klone einfach das Repository und führe das Installations-Script auf jedem neuen System aus um deine gesamte Entwicklungsumgebung einzurichten.
