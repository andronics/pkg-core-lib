# lib - AI Assistant Instructions

**Package**: `@core/lib`
**Version**: 0.1.0
**Type**: core package

## Package Overview

**Description**: Core Packages Library

**Purpose**: Provide core packages library functionality for the pkgs ecosystem.

## Architecture

### Package Structure

```
lib/
├── .local/
│   ├── bin/          # Executables (added to PATH via stow)
│   ├── share/        # Shared data files
│   └── config/       # Default configuration templates
├── package.conf      # Package metadata
└── README.md         # User documentation
```

### Key Files

**Executables**:
- `.local/bin/lib-load` - Main executable
- `.local/bin/schema-exec` - Main executable
- `.local/bin/schema-yaml2skill` - Main executable

**Configuration**:
- `package.conf` - Package metadata and dependencies

## Development Guidelines

### Code Style

- **Language**: Shell (ZSH)
- **Style**: Follow existing pkgs ecosystem conventions
- **Comments**: Document complex logic and non-obvious decisions
- **Error Handling**: Always check command exit codes and handle errors gracefully

### Dependencies

**External Commands Required**:
- `yq`

Always check for command availability before use:

```bash
if ! command -v pactl &>/dev/null; then
    echo "Error: pactl not found" >&2
    exit 1
fi
```

### Testing

Before committing changes:

1. **Test installation**: `stow lib`
2. **Test functionality**: Run main commands and verify output
3. **Test uninstallation**: `stow -D lib`
4. **Check for regressions**: Verify existing functionality still works

### Common Tasks

#### Adding a New Feature

1. Plan the feature and update documentation
2. Implement in appropriate script file
3. Test thoroughly
4. Update README.md with usage examples
5. Update CHANGELOG.md
6. Commit with conventional commit message: `feat: description`

#### Fixing a Bug

1. Reproduce the bug
2. Identify root cause
3. Implement fix
4. Test fix doesn't break other functionality
5. Update CHANGELOG.md
6. Commit with: `fix: description`

#### Refactoring Code

1. Ensure tests/verification pass before refactoring
2. Make changes incrementally
3. Test after each change
4. Update documentation if behavior changes
5. Commit with: `refactor: description`

## Integration Points

### With Other Packages

- **All packages**: Can source library extensions
- **Integration**: Via `source "$(which lib-name)"`

### With System

Integrates with system via:
- `yq` command

## Common Issues

### Installation Issues

**Problem**: Package files not in PATH after installation
**Solution**: Verify stow created symlinks: `ls -la ~/.local/bin/`

**Problem**: Permission denied errors
**Solution**: Check file permissions in `.local/bin/` (should be executable)

### Runtime Issues

**Problem**: Command not found errors
**Solution**: Check that required external commands are installed

## Version History

- **0.1.0** (2025-11-13): Initial version
  - Migrated from monolithic pkgs repository
  - Added proper dependency declarations
  - Created comprehensive documentation

## References

- [pkgs Ecosystem Documentation](https://github.com/andronics/.pkgs)
- [GNU Stow Manual](https://www.gnu.org/software/stow/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Note**: This package is part of the pkgs ecosystem. See the main repository for overall architecture and design decisions.
