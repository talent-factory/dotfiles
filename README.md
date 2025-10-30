# Dotfiles

Persönliches Dotfiles Management Repository für macOS mit professioneller Entwicklungsumgebung.

## Übersicht

Dieses Repository verwaltet Konfigurationsdateien und Entwicklungstools für eine konsistente Entwicklungsumgebung über verschiedene Systeme hinweg.

## Struktur

```text
dotfiles/
├── install.sh              # Installations-Script mit automatischen Backups
├── README.md               # Diese Datei
├── CLAUDE.md               # Claude Code Dokumentation
│
├── .claude/                # Claude Code Konfigurationen
│   ├── agents/             # Spezialisierte Agenten
│   │   ├── code-reviewer.md
│   │   ├── markdown-syntax-formatter.md
│   │   └── skill-builder/  # Skill-Builder-System
│   │       ├── README.md
│   │       ├── skill-documenter-agent.md
│   │       ├── skill-elicitation-agent.md
│   │       ├── skill-generator-agent.md
│   │       └── skill-validator-agent.md
│   │
│   └── commands/           # Claude Commands mit Progressive Disclosure
│       ├── develop/
│       │   ├── commit.md
│       │   ├── commit/     # Pre-Commit-Checks, Best Practices, etc.
│       │   ├── create-pr.md
│       │   └── create-pr/  # PR-Templates, Troubleshooting, etc.
│       ├── project/
│       │   ├── create-prd.md
│       │   └── create-prd/ # PRD Best Practices, Templates, Guides
│       └── skills/
│           ├── build-skill.md
│           ├── package-skill.md
│           ├── scripts/    # Validierung & Packaging
│           └── templates/  # Skill-Templates
│
├── config/                 # ~/.config Verzeichnis-Inhalte
├── shell/                  # Shell-Konfigurationen (zsh, bash)
│   ├── zshrc
│   ├── bashrc
│   ├── bash_profile
│   └── zshenv
│
├── git/                    # Git-Konfigurationen
│   ├── gitconfig
│   └── gitignore_global
│
├── vim/                    # Vim-Konfigurationen
│   └── vimrc
│
├── ssh/                    # SSH-Konfigurations-Templates
│   └── config.template
│
└── local/                  # ~/.local Verzeichnis-Inhalte
```

## Features

### 🚀 Claude Code Integration

- **Progressive Disclosure**: Optimierte Commands für schnelle Verarbeitung
- **Best Practices**: Industry-Standard-Methoden für Commits, PRs und PRDs
- **Skill-Builder**: Vollständiges System zur Skill-Entwicklung
- **Agenten**: Spezialisierte Code-Review und Dokumentations-Agenten

### 🛠️ Entwicklungstools

- **Shell**: ZSH und Bash Konfigurationen
- **Git**: Globale Git-Einstellungen und Ignore-Patterns
- **Vim**: Vorkonfigurierter Vim-Editor
- **SSH**: Sichere SSH-Konfigurations-Templates

### 💾 Automatische Backups

Das Installations-Script erstellt automatisch Backups existierender Dateien bevor Symlinks erstellt werden.

## Installation

### Voraussetzungen

- macOS (primär getestet)
- Git
- Bash/ZSH

### Schnellstart

1. **Repository klonen**:

   ```bash
   git clone <repository-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Installation ausführen**:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

### Was das Script macht

Das `install.sh` Script wird:

- ✅ Backups von existierenden Konfigurationsdateien erstellen
- ✅ Symbolische Links vom Home-Verzeichnis zu den Dotfiles erstellen
- ✅ Korrekte Berechtigungen für SSH-Konfigurationen setzen
- ✅ Claude Code Konfigurationen einrichten
- ✅ `.config` und `.local` Verzeichnisse verlinken

### Nach der Installation

1. **Terminal neu starten** oder Shell-Konfiguration laden:

   ```bash
   source ~/.zshrc  # Für ZSH
   # oder
   source ~/.bashrc # Für Bash
   ```

2. **Claude Code verifizieren**:

   Öffnen Sie Claude Code und überprüfen Sie, dass die Commands verfügbar sind:
   - `/commit`
   - `/create-pr`
   - `/project:create-prd`

3. **SSH-Konfiguration anpassen** (falls benötigt):

   ```bash
   vim ~/.ssh/config
   ```

## Verwendung

### Neue Dotfiles hinzufügen

1. **Datei ins Repository kopieren**:

   ```bash
   cp ~/.myconfig ~/.dotfiles/config/myconfig
   ```

2. **Install-Script aktualisieren** (falls nötig):

   Bearbeiten Sie `install.sh` für spezielle Behandlung.

3. **Änderungen committen**:

   ```bash
   cd ~/.dotfiles
   git add .
   git commit -m "feat: Füge myconfig hinzu"
   git push
   ```

### Auf neuem System einrichten

```bash
# 1. Dotfiles klonen
git clone <repository-url> ~/.dotfiles

# 2. Installation ausführen
cd ~/.dotfiles
./install.sh

# 3. Terminal neu starten
```

### Backup-Verwaltung

Backups werden automatisch in `~/.dotfiles_backup_<timestamp>/` erstellt:

```bash
# Backups anzeigen
ls -la ~/.dotfiles_backup_*

# Backup wiederherstellen (falls nötig)
cp -r ~/.dotfiles_backup_20241030_123456/.zshrc ~/
```

## Claude Code Commands

Vollständige Dokumentation der Claude Code Integration finden Sie in [CLAUDE.md](CLAUDE.md).

### Verfügbare Commands

- **`/commit`**: Professionelle Git-Commits mit Pre-Commit-Checks
- **`/create-pr`**: Pull Requests mit automatischer Branch-Erstellung
- **`/project:create-prd`**: Product Requirements Documents nach Best Practices

### Features

- ✨ Progressive Disclosure für optimale Performance
- 📚 Umfassende Best Practices (~2.800 Zeilen Dokumentation)
- 🎯 4 PRD-Templates (MVP, Standard, Major Initiative, Technical)
- 🛠️ Skill-Builder-System mit 4 spezialisierten Agenten
- ✅ Industry-Standard-Methoden (SMART, MoSCoW, Risiko-Matrix)

## SSH-Konfiguration

SSH-Konfigurationen werden aus Sicherheitsgründen speziell behandelt:

1. **Template verwenden**:

   ```bash
   cat ssh/config.template
   ```

2. **Lokale Konfiguration erstellen**:

   ```bash
   cp ssh/config.template ~/.ssh/config
   chmod 600 ~/.ssh/config
   ```

3. **Anpassen** an eigene Bedürfnisse.

**Wichtig**: SSH-Konfigurationen mit Credentials gehören NICHT ins Repository!

## Sicherheit

### Nicht getrackte Dateien

Folgende Dateien werden bewusst NICHT versioniert:

- `.claude/settings.local.json` - Lokale Claude-Einstellungen
- `*.local` - Alle lokalen Konfigurationen
- SSH Private Keys
- API Keys und Credentials

### .gitignore

Das Repository enthält ein umfassendes `.gitignore` für:

- Claude lokale Einstellungen
- OS-generierte Dateien (.DS_Store)
- Editor-Backup-Dateien
- Lokale Konfigurationen

## Troubleshooting

### Symlinks funktionieren nicht

```bash
# Überprüfen ob Symlink existiert
ls -la ~/.zshrc

# Symlink manuell erstellen
ln -sf ~/.dotfiles/shell/zshrc ~/.zshrc
```

### Claude Commands nicht verfügbar

1. **Verzeichnis überprüfen**:

   ```bash
   ls -la ~/.claude/commands/
   ```

2. **Symlinks neu erstellen**:

   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. **Claude Code neu starten**

### Backup wiederherstellen

```bash
# Neuestes Backup finden
ls -lt ~/.dotfiles_backup_* | head -1

# Datei wiederherstellen
cp ~/.dotfiles_backup_<timestamp>/.zshrc ~/
```

## Wartung

### Repository aktualisieren

```bash
cd ~/.dotfiles
git pull origin main
./install.sh  # Nur bei Struktur-Änderungen nötig
```

### Änderungen committen

```bash
cd ~/.dotfiles
git add .
git commit -m "feat: Beschreibung der Änderung"
git push
```

## Weiterführende Dokumentation

- **[CLAUDE.md](CLAUDE.md)** - Vollständige Claude Code Dokumentation
- **[.claude/commands/develop/commit/best-practices.md](.claude/commands/develop/commit/best-practices.md)** - Git Commit Best Practices
- **[.claude/commands/project/create-prd/best-practices.md](.claude/commands/project/create-prd/best-practices.md)** - PRD Best Practices
- **[.claude/commands/skills/README.md](.claude/commands/skills/README.md)** - Skill-Builder System

## Lizenz

Persönliches Repository - Nicht für öffentliche Nutzung lizenziert.

## Support

Bei Problemen:

1. Überprüfen Sie die [Troubleshooting](#troubleshooting) Sektion
2. Konsultieren Sie [CLAUDE.md](CLAUDE.md) für Claude-spezifische Fragen
3. Prüfen Sie die Git-Historie für kürzliche Änderungen

---

**Version**: 2.0.0 (mit Progressive Disclosure)
**Zuletzt aktualisiert**: Oktober 2024
