# Core Packages Library

**Package**: `@core/lib`
**Version**: 0.1.0
**Repository**: `pkg-core-lib`

## Overview

Core Packages Library

## Installation

### Prerequisites

This package requires the following external commands:

- `yq`

### Using pkg-cli

```bash
# Install from GitHub
pkg-cli install @core/lib

# Or install from local source
cd ~/.pkgs
stow lib
```

## Usage

### Library Extensions

This package provides core library extensions for the pkgs ecosystem.

```bash
# Load a library in your script
source "$(which lib-common)" 2>/dev/null || {
    echo "Error: lib-common not found"
    exit 1
}

# Use library functions
lib_common_log "INFO" "Your message here"
```

See individual library documentation in `.local/docs/lib/` for details.

## Configuration

Configuration files are typically stored in:
- `~/.config/lib/` - User configuration
- `~/.local/share/lib/` - Application data

## Uninstallation

```bash
# Using pkg-cli
pkg-cli uninstall @core/lib

# Or manual unstow
cd ~/.pkgs
stow -D lib
```

## Development

See [CLAUDE.md](CLAUDE.md) for development guidelines and AI assistance instructions.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/andronics/pkg-core-lib/issues)
- **Discussions**: [GitHub Discussions](https://github.com/andronics/pkg-core-lib/discussions)
- **Documentation**: [pkgs ecosystem docs](https://github.com/andronics/.pkgs)

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history.
