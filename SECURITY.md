# Security Policy

## Supported Versions

We actively support the latest version of AI Agent Dotfiles. Security updates are provided for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < 3.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these guidelines:

### Where to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please report security issues privately through one of these methods:

1. **GitHub Security Advisories** (Preferred):
   - Go to the [Security tab](https://github.com/talent-factory/dotfiles/security/advisories)
   - Click "Report a vulnerability"
   - Fill in the details

2. **Direct Contact**:
   - Email the maintainers directly (check repository for contact info)
   - Use PGP encryption if possible

### What to Include

Please include the following information in your report:

- **Description**: Clear description of the vulnerability
- **Impact**: What could an attacker do with this vulnerability?
- **Affected versions**: Which versions are affected?
- **Steps to reproduce**: Detailed steps to reproduce the issue
- **Proof of concept**: Code or commands demonstrating the issue
- **Suggested fix**: If you have ideas for a fix (optional)

### Example Report

```markdown
**Vulnerability**: Command injection in install.sh

**Impact**: An attacker could execute arbitrary commands if they control
the DOTFILES_DIR environment variable.

**Affected versions**: All versions prior to 3.0.0

**Steps to reproduce**:
1. Set DOTFILES_DIR to "; malicious_command"
2. Run ./install.sh
3. The malicious command executes

**Proof of concept**:
export DOTFILES_DIR="; rm -rf /tmp/test"
./install.sh

**Suggested fix**: Properly quote all variable expansions
```

## Security Considerations

### Installation Security

This project installs dotfiles and configurations to your system. Please be aware:

1. **Review before installation**: Always review code before running installation scripts
2. **Backup existing files**: The installer creates backups, but verify they're created
3. **Symlinks vs Copy**: Understand the security implications of each method
4. **Permissions**: Ensure installation directories have appropriate permissions

### Known Security Boundaries

**What this project does**:
- Installs AI agent configurations to user home directory or workspace
- Creates symlinks or copies files
- Modifies shell configurations (if enabled)

**What this project does NOT do**:
- Modify system files outside user directories
- Require root/administrator privileges (except for Windows symlinks)
- Connect to external services (all operations are local)
- Transmit data over the network

### Safe Usage Guidelines

**Do**:
- ✅ Clone from the official repository
- ✅ Review installation scripts before running
- ✅ Use dry-run mode to preview changes
- ✅ Keep your fork up-to-date with upstream
- ✅ Verify symlink targets point to expected locations

**Don't**:
- ❌ Run installation scripts from untrusted sources
- ❌ Install as root/administrator (unless necessary for Windows symlinks)
- ❌ Commit sensitive data (API keys, tokens) to your fork
- ❌ Share installation directories containing sensitive information

## Response Process

### Timeline

- **Acknowledgment**: Within 48 hours of report
- **Initial assessment**: Within 1 week
- **Fix development**: Depends on severity (critical: days, low: weeks)
- **Disclosure**: After fix is available

### Severity Levels

**Critical**: Remote code execution, privilege escalation
- Response: Immediate (24-48 hours)
- Fix: Emergency patch

**High**: Local code execution, data exposure
- Response: 1 week
- Fix: Next minor version

**Medium**: Information disclosure, denial of service
- Response: 2 weeks
- Fix: Next minor/patch version

**Low**: Minor issues with limited impact
- Response: 1 month
- Fix: Next version

### Disclosure Policy

We follow **coordinated disclosure**:

1. You report the vulnerability privately
2. We confirm and develop a fix
3. We release a security patch
4. We publish a security advisory (crediting you if desired)
5. You may publish your findings after the advisory

**Embargo period**: 90 days from initial report (or until fix is released, whichever is sooner)

## Security Updates

### How to Stay Informed

- **GitHub Security Advisories**: Enable notifications for this repository
- **Release Notes**: Check CHANGELOG.md for security fixes
- **Git Tags**: Security patches are tagged (e.g., v3.0.1-security)

### Applying Updates

```bash
# Update your fork
cd ~/.dotfiles
git fetch upstream
git merge upstream/develop

# Reinstall if needed
./install.sh
```

## Bug Bounty

We do not currently offer a bug bounty program. However, we greatly appreciate security research and will publicly acknowledge your contribution (if desired) in:

- Security advisories
- CHANGELOG.md
- Repository README (hall of fame)

## Contact

For security concerns, please contact the maintainers through:
- GitHub Security Advisories (preferred)
- GitHub Issues (for non-security bugs only)
- Direct email (check repository for contact information)

---

**Last Updated**: November 2024
**Version**: 1.0
