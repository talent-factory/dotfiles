# AI Agent Development Guidelines

## Testing Commands

### Installation Testing
```bash
# Full installation test
./test-install.sh

# Skill validation
./agents/_shared/references/scripts/validate-skill.sh <skill-path>

# Skill trigger testing  
./agents/_shared/references/scripts/test-skill-trigger.sh <skill-path>
```

### Single Test Execution
For Python-based skills: `python -m pytest tests/test_specific.py::test_function`
For Bash scripts: `bash -n script.sh` for syntax checking

## Code Style Guidelines

### Shell Scripts
- Use `#!/usr/bin/env bash` shebang
- Use `set -e` for error handling
- Follow existing function naming: `install_*`, `validate_*`, `log_*`
- Use color variables from common.sh: `$RED`, `$GREEN`, `$YELLOW`, `$BLUE`, `$MAGENTA`, `$CYAN`, `$NC`

### Python Scripts  
- Use ruff for linting, black for formatting
- Type hints required for function signatures
- Error handling with try/except blocks, not bare excepts
- Use f-strings for string formatting

### File Structure
- Scripts in `scripts/` directories
- Documentation in same directory as implementation
- Use relative imports within modules
- Follow existing directory naming patterns

### Naming Conventions
- Functions: `snake_case` with descriptive names
- Files: `kebab-case.sh` or `snake_case.py`
- Variables: `UPPER_SNAKE_CASE` for constants, `snake_case` for variables
- Error messages: Use log functions from common.sh

### Documentation
- YAML frontmatter in all .md files with required fields
- Usage examples in all executable scripts
- Comment complex logic and non-obvious workarounds