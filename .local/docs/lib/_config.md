# _config - Configuration Management with Multi-Format Support

**Version:** 1.0.0
**Layer:** Infrastructure (Layer 2)
**Dependencies:** _common v2.0 (required), jq (optional for JSON), yq (optional for YAML)
**Total Lines:** 3,248 | **Functions:** 17 | **Examples:** 35 | **Last Updated:** 2025-11-07

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (140 lines) -->

## Quick Reference Index

### Compact References (Lines 14-160)
- [Function Quick Reference](#function-quick-reference) - 17 functions (public API)
- [Config Formats Reference](#config-formats-quick-reference) - 4 formats
- [Environment Variables Quick Reference](#environment-variables-quick-reference) - 8 variables
- [Return Codes Quick Reference](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (L161-220, ~60 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (L221-300, ~80 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (L301-600, ~300 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (L601-750, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (L751-2150, ~1400 lines) 📚 LARGE SECTION
- [Advanced Usage](#advanced-usage) (L2151-2600, ~450 lines) 💡 ADVANCED
- [Best Practices](#best-practices) (L2601-2850, ~250 lines) ✨ IMPORTANT
- [Troubleshooting](#troubleshooting) (L2851-3100, ~250 lines) 🔧 REFERENCE
- [Architecture & Design](#architecture--design) (L3101-3248, ~148 lines) 🏗️ INTERNAL

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: Core API -->

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|-----------|------|
| `config-load` | Load config from file (JSON/INI/ENV) | L559-613 | Medium | [→](#config-load) |
| `config-save` | Save config to file | L615-661 | Medium | [→](#config-save) |
| `config-get` | Get value with fallback chain | L663-702 | Low | [→](#config-get) |
| `config-set` | Set value with optional type validation | L704-736 | Low | [→](#config-set) |
| `config-has` | Check key existence | L738-752 | Low | [→](#config-has) |
| `config-delete` | Delete key | L754-777 | Low | [→](#config-delete) |
| `config-keys` | List keys matching pattern | L779-788 | Low | [→](#config-keys) |
| `config-merge` | Merge config from file | L807-814 | Medium | [→](#config-merge) |
| `config-set-default` | Set default value | L816-828 | Low | [→](#config-set-default) |
| `config-get-type` | Get type of value | L830-844 | Low | [→](#config-get-type) |
| `config-clear-all` | Clear all configuration | L790-801 | Low | [→](#config-clear-all) |
| `config-size` | Get key count | L803-805 | Low | [→](#config-size) |
| `config-detect-format` | Auto-detect file format | L264-308 | Low | [→](#config-detect-format) |
| `config-dump` | Export config in format | L871-892 | Low | [→](#config-dump) |
| `config-stats` | Display statistics | L850-869 | Low | [→](#config-stats) |
| `config-help` | Show help message | L898-992 | Low | [→](#config-help) |
| `config-self-test` | Run tests | L998-1035 | High | [→](#config-self-test) |

---

## Config Formats Quick Reference

<!-- CONTEXT_GROUP: Format Handlers -->

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Format | Extension | Nesting | Native Support | Tool Required | Link |
|--------|-----------|---------|---|---|---|
| **JSON** | `.json` | Nested objects | Yes (via jq) | jq (optional) | [→](#json-format) |
| **INI** | `.ini`, `.conf` | Section+key | Yes (native ZSH) | None | [→](#ini-format) |
| **ENV** | `.env` | Flat (underscore) | Yes (native ZSH) | None | [→](#env-format) |
| **YAML** | `.yaml`, `.yml` | Nested objects | No (planned) | yq (not yet) | [→](#yaml-format) |

**Format Detection:** Auto-detected from extension or file content (Line 264-308)

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Purpose | Scope |
|----------|------|---------|---------|-------|
| `CONFIG_CONFIG_DIR` | path | `$XDG_CONFIG_HOME/config` | User config directory | Local |
| `CONFIG_DATA_DIR` | path | `$XDG_DATA_HOME/lib/config` | Data directory | Local |
| `CONFIG_CACHE_DIR` | path | `$XDG_CACHE_HOME/lib/config` | Cache directory | Local |
| `CONFIG_STATE_DIR` | path | `$XDG_STATE_HOME/lib/config` | State directory | Local |
| `CONFIG_VERBOSE` | boolean | `false` | Verbose output | Behavior |
| `CONFIG_DEBUG` | boolean | `false` | Debug output | Behavior |
| `CONFIG_AUTO_SAVE` | boolean | `false` | Auto-save after changes | Behavior |
| `CONFIG_ENV_PREFIX` | string | `CONFIG` | Env override prefix | Behavior |
| `CONFIG_ALLOW_ENV_OVERRIDE` | boolean | `true` | Enable env overrides | Behavior |
| `CONFIG_STRICT_MODE` | boolean | `false` | Strict validation | Validation |
| `CONFIG_VALIDATE_TYPES` | boolean | `true` | Type validation | Validation |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Context | Recovery |
|------|---------|---------|----------|
| `0` | Success | Operation completed | N/A |
| `1` | Not found | Key missing, no default | Provide default or load config |
| `2` | Invalid parameters | Missing/invalid args | Check argument count/format |
| `3` | Parse error | Malformed file format | Verify file syntax, check format |
| `4` | File not found | Config file missing | Verify path, create file |
| `6` | Unsupported format | Tool unavailable | Install jq/yq or convert format |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (60 lines) -->

## Overview

The `_config` extension provides **production-grade configuration management** for ZSH scripts with support for multiple file formats (JSON, INI, ENV), dot notation for nested keys, environment variable overrides, type validation, and schema support.

**Key Features:**
- **Multi-Format Support:** JSON (via jq), INI, ENV formats with auto-detection
- **Dot Notation Access:** `"database.primary.host"` for nested structures (Line 164-168)
- **Environment Overrides:** Transparent precedence: env vars > config > defaults (Line 171-188)
- **Type Validation:** string, int, bool, float with smart validation (Line 191-233)
- **Default Values:** Fallback chain with multiple default sources (Line 816-828)
- **Configuration Merging:** Combine multiple files with override priority (Line 807-814)
- **XDG Compliance:** Standard directories for config/data/cache/state
- **Auto-Save Capability:** Optional automatic persistence after changes (Line 253-258)
- **Format Auto-Detection:** Detects format from extension or content
- **Zero Dependencies (optional):** Works with only _common; jq/yq optional

**Architecture Highlights:**
- Three associative arrays: `_CONFIG_DATA`, `_CONFIG_TYPES`, `_CONFIG_DEFAULTS` (L105-110)
- Flat key-value storage with semantic dot notation (not hierarchical)
- Lazy environment override resolution on access
- Format-specific handlers for parsing/serialization
- Statistics tracking for debugging

**Use Case Categories:**
- **Application Configuration** - Settings files for utilities
- **Multi-Environment Config** - Dev/staging/prod with env var overrides
- **Configuration Merging** - Combine base + environment-specific configs
- **Type-Safe Config** - Validate values at runtime
- **Dynamic Configuration** - Modify and save settings
- **12-Factor Apps** - Environment-driven configuration

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (80 lines) -->

## Installation

### Standard Loading

```zsh
# Basic - with error handling
source "$(which _config)" || {
    echo "Error: _config extension not found" >&2
    exit 1
}

# With optional initialization
source "$(which _config)"
# Extension automatically initializes with sensible defaults
```

### Verification

```zsh
# Check version
echo "$CONFIG_VERSION"  # Outputs: 1.0.0

# Run self-tests
_config self-test
# Output:
#   === Testing config v1.0.0 ===
#   ...
#   Tests passed: 12/12

# Show statistics
config-stats
# Shows available formats (JSON/YAML/INI/ENV)
```

### Dependencies

**Required:**
- `_common` v2.0 - Validation, XDG paths, command checking (Line 45-64)

**Optional (graceful degradation):**
- `jq` - JSON format support (optional, ~auto-detected)
- `yq` - YAML format support (planned, not yet implemented)

### Feature Availability

```zsh
# Check which formats are available
config-stats

# Output example:
# Feature Support:
#   JSON: ✓ Available
#   YAML: ✗ Not available (install yq)
#   INI: ✓ Available
#   ENV: ✓ Available
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (300 lines) -->

## Quick Start

<!-- CONTEXT_GROUP: basic_operations -->

### 1. Load JSON Configuration

Parse and access JSON config files:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Create sample config
cat > config.json <<'EOF'
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "myapp"
  },
  "server": {
    "debug": true,
    "workers": 4
  }
}
EOF

# Load configuration
config-load "config.json"

# Access with dot notation
db_host=$(config-get "database.host")
db_port=$(config-get "database.port")
debug=$(config-get "server.debug")

echo "Connected to $db_host:$db_port (debug: $debug)"
```

**Key Points:**
- Auto-detects JSON from extension
- Flattens nested structure to dot notation
- Uses jq for safe parsing

---

### 2. Load INI Configuration

Work with INI/CONF files:

```zsh
source "$(which _config)"

# Create INI config
cat > config.ini <<'EOF'
[database]
host = localhost
port = 5432
name = myapp

[server]
debug = true
workers = 4
EOF

# Load INI file
config-load "config.ini"

# Access sections with dot notation
host=$(config-get "database.host")
port=$(config-get "database.port")
workers=$(config-get "server.workers")

# List all database settings
config-keys "database.*"
```

**Key Points:**
- Sections become key prefixes
- Native ZSH parsing (no dependencies)
- Handles quoted values

---

### 3. Environment Variable Overrides

Implement 12-factor app pattern:

```zsh
source "$(which _config)"

# Load base configuration
config-load "config.json"

# Environment variables override config keys:
# database.host -> CONFIG_DATABASE_HOST
# server.port -> CONFIG_SERVER_PORT
# app.debug.enabled -> CONFIG_APP_DEBUG_ENABLED

export CONFIG_DATABASE_HOST="production.db.example.com"
export CONFIG_SERVER_WORKERS="8"

# These retrieve the env var values:
host=$(config-get "database.host")        # production.db.example.com
workers=$(config-get "server.workers")    # 8

echo "Using database: $host with $workers workers"
```

**Override Rules:**
1. Add `CONFIG_ENV_PREFIX` (default: `CONFIG`)
2. Convert dots to underscores
3. Convert to uppercase
4. Check if variable exists, return if found
5. Otherwise use config value

---

### 4. Configuration with Defaults

Set sensible defaults before loading:

```zsh
source "$(which _config)"

# Set defaults (used if key not in config)
config-set-default "server.host" "localhost"
config-set-default "server.port" "8080"
config-set-default "server.timeout" "30"

# Load config (overwrites defaults)
config-load "config.json"

# Gets return default if not in config
host=$(config-get "server.host")           # From default or config
port=$(config-get "server.port")           # From default or config
timeout=$(config-get "server.timeout")     # From default or config

# Fallback if key not found at all
scheme=$(config-get "server.scheme" "http")  # Uses provided default

echo "Server: $host:$port (timeout: $timeout, scheme: $scheme)"
```

**Priority Order (→ L369-376):**
1. Environment variable override
2. Loaded configuration value
3. Default value (set with `config-set-default`)
4. Provided default parameter
5. Not found (return 1)

---

### 5. Type-Safe Configuration

Validate types on assignment:

```zsh
source "$(which _config)"

# Set typed values with validation
config-set "database.port" "5432" "int"
config-set "database.enable_ssl" "true" "bool"
config-set "timeout.seconds" "30.5" "float"

# Valid boolean values: true, false, 1, 0, yes, no, on, off
config-set "debug.enabled" "yes" "bool"    # Normalized to "true"
config-set "cache.disabled" "no" "bool"    # Normalized to "false"

# Type validation (when CONFIG_VALIDATE_TYPES=true)
config-set "port" "8080" "int"             # Valid
config-set "port" "abc" "int"              # Error: not an integer

# Supported types: string, int, bool, float, array
```

**Type Validation (→ L191-233):**
- `string` - Any value (always valid)
- `int` - Must match: `^-?[0-9]+$`
- `bool` - Must be: true, false, 1, 0, yes, no, on, off
- `float` - Must match: `^-?[0-9]+\.?[0-9]*$`
- `array` - Any value (future support)

---

### 6. Configuration Merging and Export

Combine configs and export in different formats:

```zsh
source "$(which _config)"

# Load base configuration
config-load "config/base.json"

# Merge environment-specific config
if [[ -f "config/production.json" ]]; then
    config-merge "config/production.json"
fi

# Merge INI overrides
config-merge "local.ini"

# Get final merged values
db_host=$(config-get "database.host")

# Export to different formats
config-save "config-backup.json" "json"
config-save "config-backup.ini" "ini"
config-save "config-backup.env" "env"

# Dump current state
config-dump "table"
```

**Merging (→ L807-814):**
- Merges INTO existing config
- Later values override earlier ones
- Equivalent to `config-load <file> <format> true`

---

<!-- CONTEXT_GROUP: configuration -->

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL (150 lines) -->

### Environment Variables

**Path Configuration:**

```zsh
# Set custom directories (all XDG-compliant)
export CONFIG_CONFIG_DIR="$HOME/.config/myapp"
export CONFIG_DATA_DIR="$HOME/.local/share/lib/myapp"
export CONFIG_CACHE_DIR="$HOME/.cache/lib/myapp"
export CONFIG_STATE_DIR="$HOME/.local/state/lib/myapp"
```

**Behavior Flags:**

```zsh
# Verbose and debug output
export CONFIG_VERBOSE=true      # Show info messages
export CONFIG_DEBUG=false       # Show debug messages

# Auto-save after modifications
export CONFIG_AUTO_SAVE=false   # Save after each config-set/config-delete

# Type validation
export CONFIG_VALIDATE_TYPES=true  # Validate on config-set
export CONFIG_STRICT_MODE=false    # Strict validation mode (reserved)
```

**Environment Override Mechanism:**

```zsh
# Override prefix
export CONFIG_ENV_PREFIX="CONFIG"    # Default prefix for env vars

# Enable/disable env overrides
export CONFIG_ALLOW_ENV_OVERRIDE=true  # Default: enabled

# Example: With CONFIG_ENV_PREFIX="CONFIG"
# database.host -> CONFIG_DATABASE_HOST
# server.port -> CONFIG_SERVER_PORT

# To use custom prefix:
export CONFIG_ENV_PREFIX="MYAPP"
# database.host -> MYAPP_DATABASE_HOST
# server.port -> MYAPP_SERVER_PORT
```

### Environment Variable Override Format

Mapping from config keys to environment variables:

```zsh
# Format rules:
# 1. Start with CONFIG_ENV_PREFIX (default: CONFIG)
# 2. Replace dots with underscores
# 3. Convert to uppercase

# Examples:
database.host          → CONFIG_DATABASE_HOST
server.port            → CONFIG_SERVER_PORT
app.debug.enabled      → CONFIG_APP_DEBUG_ENABLED
cache.ttl.seconds      → CONFIG_CACHE_TTL_SECONDS

# Custom prefix example:
# With CONFIG_ENV_PREFIX="MYAPP":
database.host          → MYAPP_DATABASE_HOST
server.port            → MYAPP_SERVER_PORT
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE (1400 lines) -->

## API Reference

### Loading and Saving

#### `config-load` (L559-613)

Load configuration from a file with format detection.

**Usage:**
```zsh
config-load <file> [format] [merge]
```

**Parameters:**
- `file` (required) - Path to configuration file
- `format` (optional) - Format: `json`, `yaml`, `ini`, `env` (auto-detected if omitted)
- `merge` (optional) - `true` to merge with existing, `false` to replace (default: `false`)

**Returns:**
- `0` - Success
- `2` - Invalid parameters
- `3` - Parse error (malformed file)
- `4` - File not found
- `6` - Unsupported format or missing tool (e.g., jq not installed)

**Performance (L281-287):**
- ENV: ~50ms (1000 keys)
- INI: ~100ms (1000 keys)
- JSON: ~200ms (1000 keys, includes jq subprocess)

**Examples:**

```zsh
# Auto-detect format from extension
config-load "config.json"
config-load "settings.ini"
config-load ".env"

# Explicit format specification
config-load "config" "json"

# Merge with existing configuration
config-load "base.json"
config-load "overrides.json" "json" "true"

# Error handling
if ! config-load "config.json"; then
    echo "Failed to load config" >&2
    exit 1
fi

# Check what was loaded
size=$(config-size)
echo "Loaded $size configuration keys"
```

**Notes:**
- Clears existing config unless `merge=true`
- Auto-detects format from file extension or content
- Creates internal storage in `_CONFIG_DATA`, `_CONFIG_TYPES` hashes
- Updates `_CONFIG_SOURCE_FILE` and `_CONFIG_SOURCE_FORMAT` state
- Counts total loads in `_CONFIG_TOTAL_LOADS`

---

#### `config-save` (L615-661)

Save configuration to a file, optionally converting format.

**Usage:**
```zsh
config-save [file] [format]
```

**Parameters:**
- `file` (optional) - Output file path (defaults to source file from `config-load`)
- `format` (optional) - Output format (defaults to source format or auto-detect)

**Returns:**
- `0` - Success
- `2` - Invalid parameters (no file specified, invalid format)
- `6` - Unsupported format or missing tool

**Examples:**

```zsh
# Save to same file (requires prior config-load)
config-load "config.json"
config-set "debug" "true"
config-save
# Saves to config.json in JSON format

# Save to different file
config-load "config.json"
config-set "debug" "true"
config-save "config.new.json"
# Saves to config.new.json in JSON format

# Save in different format
config-load "config.json"
config-save "config.ini" "ini"
# Loads from JSON, saves as INI

# Save with auto-save
export CONFIG_AUTO_SAVE=true
config-load "settings.json"
config-set "theme" "dark"     # Auto-saves to settings.json
config-set "font-size" "12"   # Auto-saves again

# Error handling
if ! config-save "output.json"; then
    echo "Failed to save config" >&2
    exit 1
fi
```

**Notes:**
- Creates parent directories if needed (via `common-ensure-dir`)
- Auto-saves only if `CONFIG_AUTO_SAVE=true`
- Updates modification flag `_CONFIG_MODIFIED=false` on success
- Counts total saves in `_CONFIG_TOTAL_SAVES`
- Only works if source file specified or passed as parameter

---

#### `config-detect-format` (L264-308)

Detect configuration file format from extension or content.

**Usage:**
```zsh
format=$(config-detect-format <file>)
```

**Parameters:**
- `file` (required) - File path to analyze

**Returns:**
- `0` - Success, outputs detected format
- `2` - Invalid parameters

**Detection Rules:**
1. Check file extension (`.json`, `.yaml`, `.yml`, `.ini`, `.conf`, `.env`)
2. Check file content for format indicators:
   - JSON: Starts with `{` or `[`
   - YAML: Starts with `---`
   - INI: Starts with `[section]`
3. Default to `env` format if no match

**Examples:**

```zsh
# Detect from extension
format=$(config-detect-format "config.json")
echo "Detected: $format"  # Output: json

# Use in conditional logic
format=$(config-detect-format "$config_file")
case "$format" in
    json) echo "JSON format detected" ;;
    ini)  echo "INI format detected" ;;
    env)  echo "ENV format detected" ;;
esac

# Content-based detection
# Even without extension, detects from content
cp config.json config.backup
format=$(config-detect-format "config.backup")
# Still outputs: json
```

---

### Getting and Setting Values

#### `config-get` (L663-702)

Get configuration value with transparent override resolution.

**Usage:**
```zsh
value=$(config-get <key> [default])
```

**Parameters:**
- `key` (required) - Configuration key (supports dot notation)
- `default` (optional) - Default value if key not found

**Returns:**
- `0` - Success, value printed to stdout
- `1` - Key not found and no default provided
- `2` - Invalid parameters

**Priority Resolution (→ L369-376):**
1. Environment variable override (if `CONFIG_ALLOW_ENV_OVERRIDE=true`)
2. Loaded configuration value in `_CONFIG_DATA`
3. Default value from `_CONFIG_DEFAULTS`
4. Provided default parameter
5. Not found (return code 1)

**Examples:**

```zsh
# Simple get
config-load "config.json"
host=$(config-get "database.host")
port=$(config-get "database.port")

# With fallback default
timeout=$(config-get "server.timeout" "30")

# Nested keys (dot notation)
db_timeout=$(config-get "database.connection.timeout")
cache_enabled=$(config-get "cache.enabled")

# Check if found
if value=$(config-get "optional.setting"); then
    echo "Found: $value"
else
    echo "Not found, using default"
    value="default"
fi

# Environment override
export CONFIG_DATABASE_HOST="prod.db.example.com"
host=$(config-get "database.host")
# Returns: prod.db.example.com (from env var, not config)

# With defaults and overrides
config-set-default "server.host" "localhost"
host=$(config-get "server.host" "127.0.0.1")
# Returns: localhost (from default, or provided default if not set)
```

**Notes:**
- Normalizes key via `_config-normalize-key` (removes leading/trailing dots)
- Checks environment override first (if enabled)
- Uses `_CONFIG_DATA` hash for O(1) lookup
- Increments `_CONFIG_TOTAL_GETS` counter
- Returns empty string if key not found (check return code)

---

#### `config-set` (L704-736)

Set configuration value with optional type validation.

**Usage:**
```zsh
config-set <key> <value> [type]
```

**Parameters:**
- `key` (required) - Configuration key (supports dot notation)
- `value` (required) - Value to set (any string)
- `type` (optional) - Type for validation: `string`, `int`, `bool`, `float` (default: `string`)

**Returns:**
- `0` - Success
- `2` - Invalid parameters or type validation failed (when `CONFIG_VALIDATE_TYPES=true`)

**Type Validation (→ L191-233):**
- `string` - Any value accepted (always valid)
- `int` - Must match: `^-?[0-9]+$` (optional sign, digits)
- `bool` - Must be: `true`, `false`, `1`, `0`, `yes`, `no`, `on`, `off`
- `float` - Must match: `^-?[0-9]+\.?[0-9]*$` (optional decimal)
- `array` - Any value (for future support)

**Examples:**

```zsh
# Simple string set
config-set "database.host" "localhost"
config-set "app.name" "MyApplication"

# Type-validated integers
config-set "database.port" "5432" "int"
config-set "server.workers" "4" "int"

# Type-validated booleans
config-set "debug" "true" "bool"
config-set "cache.enabled" "false" "bool"
config-set "ssl" "1" "bool"          # Normalized to "true"
config-set "verbose" "yes" "bool"    # Normalized to "true"

# Type-validated floats
config-set "timeout.seconds" "30.5" "float"
config-set "threshold" "0.95" "float"

# Nested keys (creates structure)
config-set "database.primary.host" "localhost"
config-set "database.primary.port" "5432"
config-set "database.replica.host" "replica.local"

# Type validation errors
config-set "port" "invalid" "int"    # Error: "not an integer"
config-set "debug" "maybe" "bool"    # Error: "not a boolean"

# Disable type validation
export CONFIG_VALIDATE_TYPES=false
config-set "port" "invalid" "int"    # No error, stores as-is
```

**Notes:**
- Marks configuration as modified (`_CONFIG_MODIFIED=true`)
- Auto-saves if `CONFIG_AUTO_SAVE=true`
- Normalizes boolean values to `true`/`false` for bool type
- Stores type metadata in `_CONFIG_TYPES` hash
- Increments `_CONFIG_TOTAL_SETS` counter
- Validation is optional (controlled by `CONFIG_VALIDATE_TYPES`)

---

#### `config-has` (L738-752)

Check if configuration key exists without retrieving value.

**Usage:**
```zsh
if config-has <key>; then
    echo "Key exists"
fi
```

**Parameters:**
- `key` (required) - Configuration key to check

**Returns:**
- `0` - Key exists (in config or defaults)
- `1` - Key not found
- `2` - Invalid parameters

**Examples:**

```zsh
# Simple check
if config-has "database.host"; then
    echo "Database configured"
fi

# Conditional loading
if ! config-has "api.key"; then
    echo "API key required" >&2
    exit 1
fi

# Check before get
if config-has "optional.feature"; then
    feature=$(config-get "optional.feature")
else
    feature="disabled"
fi

# Combine with defaults
if ! config-has "server.port"; then
    config-set-default "server.port" "8080"
fi

# Iterate through keys
for key in $(config-keys "database.*"); do
    if config-has "$key"; then
        echo "$key = $(config-get "$key")"
    fi
done
```

**Notes:**
- Checks both `_CONFIG_DATA` and `_CONFIG_DEFAULTS` hashes
- Does NOT check environment variable overrides
- O(1) hash lookup performance
- Useful for conditional initialization

---

#### `config-delete` (L754-777)

Delete a configuration key and its metadata.

**Usage:**
```zsh
config-delete <key>
```

**Parameters:**
- `key` (required) - Configuration key to delete

**Returns:**
- `0` - Success
- `1` - Key not found
- `2` - Invalid parameters

**Examples:**

```zsh
# Delete a key
config-delete "database.password"

# Delete nested key
config-delete "server.ssl.certificate"

# Delete with verification
if config-has "temp.setting"; then
    config-delete "temp.setting"
fi

# Clean up sensitive data
config-set "api.key" "secret123"
# ...use it...
config-delete "api.key"  # Remove from memory

# Batch delete
for key in $(config-keys "deprecated.*"); do
    config-delete "$key"
done
```

**Notes:**
- Marks config as modified (`_CONFIG_MODIFIED=true`)
- Auto-saves if `CONFIG_AUTO_SAVE=true`
- Removes from `_CONFIG_DATA`, `_CONFIG_TYPES`, `_CONFIG_DEFAULTS`
- Does NOT delete environment variable overrides
- Check return code to verify deletion

---

### Querying Configuration

#### `config-keys` (L779-788)

List all configuration keys, optionally filtered by pattern.

**Usage:**
```zsh
config-keys [pattern]
```

**Parameters:**
- `pattern` (optional) - Glob pattern (default: `*` for all keys)

**Returns:**
- `0` - Success, outputs keys (one per line)

**Pattern Syntax:**
- `*` - Matches any characters (default)
- `?` - Matches single character
- `[abc]` - Matches any in set
- `database.*` - All keys starting with `database.`

**Examples:**

```zsh
# All keys
config-keys
# Output:
# database.host
# database.port
# server.workers

# Filter by pattern
config-keys "database.*"
# Output:
# database.host
# database.port
# database.name

# Count keys
total=$(config-keys | wc -l)
echo "Configuration has $total keys"

# Count database keys
db_count=$(config-keys "database.*" | wc -l)
echo "Database settings: $db_count"

# Iterate and print
for key in $(config-keys "server.*"); do
    value=$(config-get "$key")
    echo "$key = $value"
done

# Get all top-level sections
config-keys | cut -d. -f1 | sort -u
```

**Notes:**
- Iterates all keys matching pattern
- O(n) complexity where n = number of keys
- No sorting guaranteed (use | sort for ordered output)
- Pattern matching is shell glob syntax

---

#### `config-size` (L803-805)

Get total number of configuration keys currently loaded.

**Usage:**
```zsh
count=$(config-size)
```

**Returns:**
- `0` - Success, outputs count

**Examples:**

```zsh
# Get configuration size
size=$(config-size)
echo "Configuration contains $size keys"

# Check if empty
if [[ $(config-size) -eq 0 ]]; then
    echo "No configuration loaded"
    exit 1
fi

# Progress indicator
before=$(config-size)
config-merge "additional.json"
after=$(config-size)
echo "Loaded $((after - before)) additional keys"
```

**Notes:**
- Returns `${#_CONFIG_DATA[@]}` (array size)
- O(1) complexity
- Does not count environment overrides separately

---

#### `config-dump` (L871-892)

Export entire configuration in specified format.

**Usage:**
```zsh
config-dump [format]
```

**Parameters:**
- `format` (optional) - Output format: `env` or `table` (default: `env`)

**Returns:**
- `0` - Success
- `2` - Invalid format

**Output Formats:**

ENV format (default):
```
key1=value1
key2=value2
database.host=localhost
```

Table format (Markdown):
```
KEY|VALUE|TYPE
---|-----|----
database.host|localhost|string
database.port|5432|string
```

**Examples:**

```zsh
# ENV format (KEY=VALUE, sorted)
config-dump
# Output:
# database.host=localhost
# database.port=5432
# debug=true

# Table format (for human viewing)
config-dump table
# Output:
# KEY|VALUE|TYPE
# ---|-----|----
# database.host|localhost|string
# database.port|5432|string

# Export to file
config-dump > config-backup.env

# Pipe to other tools
config-dump | grep "^database"

# Create shell script from config
{
    echo "#!/usr/bin/env zsh"
    echo "# Generated from config"
    config-dump | sed 's/^/export CONFIG_/'
} > config.sh
```

**Notes:**
- ENV format sorts keys alphabetically
- Table format uses pipe delimiters (Markdown compatible)
- Useful for debugging, backup, or generating shell scripts

---

### Default Values and Type Information

#### `config-set-default` (L816-828)

Set default value returned when key not found in config.

**Usage:**
```zsh
config-set-default <key> <value>
```

**Parameters:**
- `key` (required) - Configuration key
- `value` (required) - Default value

**Returns:**
- `0` - Success
- `2` - Invalid parameters

**Examples:**

```zsh
# Set defaults before loading config
config-set-default "server.host" "localhost"
config-set-default "server.port" "8080"
config-set-default "server.timeout" "30"
config-set-default "logging.level" "info"

# Load config (overwrites defaults if key present)
config-load "config.json"

# Access returns default if not in config
host=$(config-get "server.host")  # Value from config or default
timeout=$(config-get "server.timeout")  # Value from default if not in config

# Defaults don't override config
config-set-default "database.host" "localhost"
config-set "database.host" "prod.example.com"
value=$(config-get "database.host")  # Returns: prod.example.com

# Check what's default vs. loaded
if config-has "optional.feature"; then
    # Key is in loaded config
    echo "Feature configured"
else
    # Key is only in defaults (or not set)
    echo "Using default"
fi
```

**Priority (→ L369-376):**
1. Environment variable override
2. Loaded config value
3. **Default value** (this function)
4. Provided default parameter

**Notes:**
- Defaults do NOT modify loaded configuration
- Used when key not found in `_CONFIG_DATA`
- Stored in `_CONFIG_DEFAULTS` hash
- Does not trigger auto-save

---

#### `config-get-type` (L830-844)

Get the type of a configuration value.

**Usage:**
```zsh
type=$(config-get-type <key>)
```

**Parameters:**
- `key` (required) - Configuration key

**Returns:**
- `0` - Success, outputs type (string, int, bool, float, unknown)
- `1` - Key not found
- `2` - Invalid parameters

**Examples:**

```zsh
# Get type of value
config-set "port" "8080" "int"
type=$(config-get-type "port")
echo "Port type: $type"  # Output: int

# Conditional logic based on type
port=$(config-get "server.port")
if [[ "$(config-get-type "server.port")" == "int" ]]; then
    echo "Port is integer: $port"
fi

# Verify types before using
for key in $(config-keys "database.*"); do
    value=$(config-get "$key")
    type=$(config-get-type "$key")
    echo "$key ($type) = $value"
done

# Type checking in validation
validate_config() {
    if config-has "database.port"; then
        if [[ "$(config-get-type "database.port")" != "int" ]]; then
            echo "database.port must be integer" >&2
            return 1
        fi
    fi
    return 0
}
```

**Notes:**
- Returns `unknown` if type not explicitly set
- Returns from `_CONFIG_TYPES` hash
- Does not infer type from value, only from metadata

---

### Management Functions

#### `config-merge` (L807-814)

Merge configuration from another file into current config.

**Usage:**
```zsh
config-merge <file> [format]
```

**Parameters:**
- `file` (required) - File to merge (same formats as `config-load`)
- `format` (optional) - File format (auto-detected if omitted)

**Returns:**
- `0` - Success
- `2` - Invalid parameters
- `4` - File not found
- `6` - Unsupported format or missing tool

**Examples:**

```zsh
# Load base config
config-load "base.json"
echo "Loaded $(config-size) keys"

# Merge overrides (keys in merge file override base)
config-merge "overrides.json"
echo "After merge: $(config-size) keys"

# Merge from different format
config-load "config.json"
config-merge "env.ini" "ini"

# Multi-environment pattern
config-load "config/default.json"
if [[ -f "config/production.json" ]]; then
    config-merge "config/production.json"
fi

# Environment-specific overrides
ENV="${APP_ENV:-development}"
config-load "config/base.json"
for override in "config/${ENV}.json" "config/local.json"; do
    if [[ -f "$override" ]]; then
        config-merge "$override"
    fi
done
```

**Notes:**
- Equivalent to `config-load <file> <format> true`
- Merges INTO existing config (doesn't clear)
- Duplicate keys from merge file override existing values
- Updates `_CONFIG_TOTAL_LOADS` counter
- Useful for layered configuration approach

---

#### `config-clear-all` (L790-801)

Clear all configuration and reset to empty state.

**Usage:**
```zsh
config-clear-all
```

**Returns:**
- `0` - Success

**Examples:**

```zsh
# Clear and reload
config-clear-all
config-load "new-config.json"

# Reset configuration
config-clear-all
config-set-default "host" "localhost"
config-set-default "port" "8080"

# In error handlers
if ! process_config; then
    echo "Configuration invalid, resetting" >&2
    config-clear-all
    exit 1
fi
```

**Notes:**
- Clears `_CONFIG_DATA`, `_CONFIG_TYPES`, `_CONFIG_DEFAULTS`, `_CONFIG_SCHEMA`
- Resets `_CONFIG_TOTAL_KEYS` to 0
- Resets `_CONFIG_MODIFIED=false`
- Does NOT clear source file reference
- Does NOT reset counters (`_CONFIG_TOTAL_LOADS`, etc.)

---

#### `config-stats` (L850-869)

Display detailed configuration statistics and feature availability.

**Usage:**
```zsh
config-stats
```

**Returns:**
- `0` - Success

**Output Example:**

```
Configuration Statistics:
  Total Keys: 12
  Source File: /path/to/config.json
  Source Format: json
  Modified: false
  Auto-save: false

Operations:
  Loads: 2
  Saves: 1
  Gets: 45
  Sets: 8

Feature Support:
  JSON: ✓ Available
  YAML: ✗ Not available (install yq)
  INI: ✓ Available
  ENV: ✓ Available
```

**Examples:**

```zsh
# Show current state
config-load "config.json"
config-stats

# Check feature support
if config-stats | grep -q "JSON: ✗"; then
    echo "Warning: jq not installed, JSON support unavailable" >&2
fi

# Monitor during script
echo "Initial state:"
config-stats

config-merge "overrides.json"
echo "After merge:"
config-stats
```

**Notes:**
- Shows total keys, source file, source format
- Shows operation counters (loads, saves, gets, sets)
- Shows which formats are available
- Useful for debugging and monitoring

---

<!-- CONTEXT_GROUP: advanced_usage -->

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (450 lines) -->

### 1. Multi-Environment Configuration

Implement environment-specific overrides with cascading configuration:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Load configuration hierarchy
load_environment_config() {
    local env="${1:-development}"

    # Load base configuration
    if ! config-load "config/base.json"; then
        echo "Error: Failed to load base config" >&2
        return 1
    fi

    # Load environment-specific config
    if [[ -f "config/${env}.json" ]]; then
        if ! config-merge "config/${env}.json"; then
            echo "Error: Failed to load ${env} config" >&2
            return 1
        fi
    fi

    # Load local overrides (not in version control)
    if [[ -f "config/local.json" ]]; then
        config-merge "config/local.json"
    fi

    # Environment variables override everything
    # (automatically handled by config-get)

    return 0
}

# Usage
load_environment_config "$APP_ENV"

# Access database host (respects priority):
# 1. CONFIG_DATABASE_HOST env var (highest)
# 2. local.json (if present)
# 3. environment.json (production.json, development.json)
# 4. base.json (lowest)
db_host=$(config-get "database.host")
```

**Configuration Files:**

```
config/
├── base.json          # Default settings for all envs
├── development.json   # Development overrides
├── staging.json       # Staging overrides
├── production.json    # Production overrides
└── local.json         # Local machine overrides (gitignored)
```

**Priority Order:**
1. Environment variables (CONFIG_*)
2. Local overrides (local.json)
3. Environment-specific (production.json, etc.)
4. Base defaults (base.json)

---

### 2. Configuration Validation

Validate required keys and type constraints:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

validate_config() {
    local required_keys=(
        "database.host"
        "database.port"
        "database.name"
        "api.key"
        "server.port"
    )

    local errors=0

    # Check required keys
    for key in "${required_keys[@]}"; do
        if ! config-has "$key"; then
            echo "Error: Missing required config: $key" >&2
            ((errors++))
        fi
    done

    # Validate integer ranges
    if config-has "database.port"; then
        port=$(config-get "database.port")
        if [[ ! "$port" =~ ^[0-9]+$ ]] || [[ $port -lt 1024 ]] || [[ $port -gt 65535 ]]; then
            echo "Error: database.port must be 1024-65535, got: $port" >&2
            ((errors++))
        fi
    fi

    # Validate hostnames/IPs
    if config-has "database.host"; then
        host=$(config-get "database.host")
        if [[ ! "$host" =~ ^[a-zA-Z0-9.-]+$ ]]; then
            echo "Error: Invalid database.host format: $host" >&2
            ((errors++))
        fi
    fi

    # Validate boolean flags
    if config-has "debug.enabled"; then
        debug=$(config-get "debug.enabled")
        if [[ ! "$debug" =~ ^(true|false)$ ]]; then
            echo "Error: debug.enabled must be true/false, got: $debug" >&2
            ((errors++))
        fi
    fi

    return $errors
}

# Load and validate
config-load "config.json" || exit 1

if ! validate_config; then
    echo "Configuration validation failed" >&2
    exit 1
fi

echo "Configuration valid"
```

---

### 3. Configuration Hot-Reload

Monitor file for changes and reload automatically:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Track file state
declare -g _CONFIG_LAST_MTIME=""

config-reload-if-changed() {
    local config_file="$1"

    if [[ ! -f "$config_file" ]]; then
        echo "Config file not found: $config_file" >&2
        return 1
    fi

    # Get current file modification time
    local current_mtime=$(stat -f%m "$config_file" 2>/dev/null || stat -c%Y "$config_file" 2>/dev/null)

    # First check: initialize
    if [[ -z "$_CONFIG_LAST_MTIME" ]]; then
        _CONFIG_LAST_MTIME="$current_mtime"
        return 0
    fi

    # Check if file changed
    if [[ "$current_mtime" != "$_CONFIG_LAST_MTIME" ]]; then
        echo "Configuration file changed, reloading..." >&2
        _CONFIG_LAST_MTIME="$current_mtime"
        config-load "$config_file" || return 1
        echo "Configuration reloaded successfully" >&2
        return 0
    fi

    return 0
}

# Usage in long-running process
config-load "config.json"

while true; do
    # Check and reload if changed
    config-reload-if-changed "config.json"

    # Use current configuration
    host=$(config-get "database.host")
    port=$(config-get "database.port")

    # Do work...
    sleep 5
done
```

---

### 4. Configuration Templates with Variable Substitution

Support variable references in configuration values:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Expand variables in config values
config-expand-variables() {
    local key value

    for key in $(config-keys); do
        value=$(config-get "$key")

        # Replace $(var) and ${var} patterns
        # $(database.host) -> value of database.host
        while [[ "$value" =~ \$\(([^)]+)\) ]]; do
            local ref_key="${match[1]}"
            local ref_value=$(config-get "$ref_key" "")
            value="${value//$\(${ref_key}\)/$ref_value}"
        done

        # Update if changed
        if [[ "$value" != "$(config-get "$key")" ]]; then
            config-set "$key" "$value"
        fi
    done
}

# Example config with references:
# database.host=localhost
# database.port=5432
# database.url=postgresql://$(database.host):$(database.port)/mydb

config-load "config.json"
config-expand-variables

# Now database.url = postgresql://localhost:5432/mydb
url=$(config-get "database.url")
echo "Connection: $url"
```

---

### 5. Multi-Format Configuration Integration

Seamlessly work with multiple file formats:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Support multiple formats in single config system
config-load-auto() {
    local config_dir="$1"
    local env="${2:-development}"

    # Try formats in preference order
    local formats=("json" "ini" "env")

    for fmt in "${formats[@]}"; do
        local file="${config_dir}/config.${fmt}"

        if [[ -f "$file" ]]; then
            echo "Loading $file (format: $fmt)" >&2
            if config-load "$file" "$fmt"; then
                return 0
            fi
        fi
    done

    echo "Error: No configuration file found in $config_dir" >&2
    return 1
}

# Merge different formats
config-load-all() {
    local config_dir="$1"

    # JSON base
    config-load "${config_dir}/base.json" "json"

    # INI overrides
    [[ -f "${config_dir}/overrides.ini" ]] && \
        config-merge "${config_dir}/overrides.ini" "ini"

    # ENV local
    [[ -f "${config_dir}/.env" ]] && \
        config-merge "${config_dir}/.env" "env"
}

# Usage
config-load-all "/etc/myapp/config"
```

---

### 6. Configuration Snapshots and Rollback

Save and restore configuration states:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

declare -gA _CONFIG_SNAPSHOTS=()

# Save configuration snapshot
config-snapshot-save() {
    local name="$1"

    # Export current config to env format
    _CONFIG_SNAPSHOTS[$name]=$(config-dump "env")

    echo "Snapshot saved: $name" >&2
    return 0
}

# Restore from snapshot
config-snapshot-restore() {
    local name="$1"

    if [[ -z "${_CONFIG_SNAPSHOTS[$name]:-}" ]]; then
        echo "Error: Snapshot not found: $name" >&2
        return 1
    fi

    # Clear and restore
    config-clear-all

    # Parse env format and restore
    while IFS='=' read -r key value; do
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        config-set "$key" "$value"
    done <<< "${_CONFIG_SNAPSHOTS[$name]}"

    echo "Snapshot restored: $name" >&2
    return 0
}

# Usage
config-load "config.json"
config-snapshot-save "original"

# Make changes
config-set "debug" "true"
config-set "workers" "1"

# Check changes
echo "Modified: $(config-dump)"

# Rollback
config-snapshot-restore "original"
echo "Restored: $(config-dump)"
```

---

## Best Practices

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (250 lines) -->

### 1. Use Hierarchical Keys

Organize configuration with dot notation for clarity:

```zsh
# Good: Hierarchical structure
database.primary.host
database.primary.port
database.replica.host
database.replica.port
server.http.host
server.http.port
server.https.port

# Avoid: Flat naming
database_primary_host
database_primary_port
server_http_port
```

**Benefits:**
- Clear logical grouping
- Easy pattern matching (`config-keys "database.*"`)
- Maps naturally to nested config file formats
- Reduces key name collisions

---

### 2. Set Defaults Early

Define sensible defaults before loading configuration:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Set defaults immediately after sourcing
config-set-default "server.host" "localhost"
config-set-default "server.port" "8080"
config-set-default "server.timeout" "30"
config-set-default "logging.level" "info"
config-set-default "debug" "false"

# Load config (overwrites defaults where specified)
config-load "config.json"

# All settings have values even if not in config
host=$(config-get "server.host")  # From config or default
level=$(config-get "logging.level")  # From config or default
```

**Benefits:**
- Explicit defaults documented in code
- Graceful degradation if config missing
- Easier to understand required settings
- Better for optional features

---

### 3. Validate After Loading

Check configuration immediately after loading:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Load configuration
if ! config-load "config.json"; then
    echo "Failed to load configuration" >&2
    exit 1
fi

# Validate required settings
required_keys=("database.host" "database.port" "api.key")
for key in "${required_keys[@]}"; do
    if ! config-has "$key"; then
        echo "Missing required configuration: $key" >&2
        exit 1
    fi
done

# Validate types and ranges
port=$(config-get "database.port")
if [[ ! "$port" =~ ^[0-9]+$ ]]; then
    echo "database.port must be numeric" >&2
    exit 1
fi

# Now safe to proceed
echo "Configuration validated successfully"
```

---

### 4. Respect Environment Variable Priority

Design for 12-factor app compliance:

```zsh
#!/usr/bin/env zsh
source "$(which _config)"

# Enable env override (default, but be explicit)
export CONFIG_ALLOW_ENV_OVERRIDE=true

# Load base configuration
config-load "config/default.json"

# Environment variables automatically take precedence
# Users can override any setting:
# export CONFIG_DATABASE_HOST="prod.db"
# export CONFIG_SERVER_WORKERS="16"

# Code accesses transparently
db_host=$(config-get "database.host")  # Uses env var if set
workers=$(config-get "server.workers")  # Uses env var if set
```

**12-Factor Compliance:**
1. Store defaults in config files
2. Allow environment variable overrides
3. Never hardcode configuration
4. Support multiple environments

---

### 5. Use Type Validation for Critical Values

Validate types on important configuration:

```zsh
# Type-validate critical settings
config-set "database.port" "5432" "int"
config-set "server.workers" "4" "int"
config-set "cache.ttl" "3600" "int"
config-set "debug.enabled" "true" "bool"
config-set "timeout.seconds" "30.5" "float"

# Don't over-validate
config-set "app.name" "MyApp"  # String, no validation needed
config-set "description" "Application description"
```

---

### 6. Secure Sensitive Data

Never store secrets in configuration files:

```zsh
# BAD: Plain text passwords
config-set "database.password" "secret123"
config-save "config.json"  # Password visible in file!

# BETTER: Use environment variables
export DATABASE_PASSWORD="secret123"
# Don't save to file

# BEST: Use secrets management
# password=$(get-secret "database.password")
# or read from secure vault
```

**Security Measures:**
- Restrict config file permissions (`chmod 600`)
- Never commit secrets to version control
- Use environment variables for sensitive data
- Use secrets management systems when available

---

### 7. Handle Missing Config Gracefully

Provide fallbacks for optional settings:

```zsh
# Check and provide default
if config-has "optional.feature"; then
    feature=$(config-get "optional.feature")
else
    feature="disabled"
fi

# Use fallback directly
feature=$(config-get "optional.feature" "disabled")

# Conditional execution based on availability
if config-has "integrations.slack.webhook"; then
    notify_slack "$(config-get 'integrations.slack.webhook')"
fi
```

---

### 8. Document Configuration Schema

Clearly document expected configuration:

```zsh
# Document in code what keys are expected
#
# CONFIGURATION SCHEMA:
# ─────────────────────
# database.host (string) - Database hostname [required]
# database.port (int)    - Database port [default: 5432]
# database.name (string) - Database name [required]
# database.user (string) - Database user [required]
# database.password (string) - Database password [env: DB_PASSWORD]
#
# server.host (string)   - Server bind address [default: localhost]
# server.port (int)      - Server port [default: 8080]
# server.workers (int)   - Worker processes [default: 4]
# server.timeout (float) - Request timeout seconds [default: 30.0]

config-set-default "database.port" "5432"
config-set-default "server.host" "localhost"
config-set-default "server.port" "8080"
config-set-default "server.workers" "4"
config-set-default "server.timeout" "30.0"

config-load "$CONFIG_FILE"
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (250 lines) -->

### Problem: JSON Support Not Available

**Symptoms:**
```
Error: JSON support requires 'jq'
```

**Root Causes:**
- `jq` not installed
- `jq` not in PATH
- JSON file parsing failed

**Solutions:**

**1. Install jq:**
```zsh
# Arch Linux
sudo pacman -S jq

# Debian/Ubuntu
sudo apt install jq

# macOS
brew install jq

# Alpine
apk add jq
```

**2. Verify installation:**
```zsh
jq --version
which jq
```

**3. Use different format:**
```zsh
# Convert JSON to INI
config-load "config.json"
config-save "config.ini" "ini"

# Or use ENV format
config-save "config.env" "env"
```

**4. Check JSON syntax:**
```zsh
jq empty config.json  # Shows parse errors
```

---

### Problem: Environment Override Not Working

**Symptoms:**
```
export CONFIG_DATABASE_HOST="newhost"
config-get "database.host"  # Returns old value
```

**Root Causes:**
- Env override disabled
- Wrong variable name format
- Wrong prefix

**Solutions:**

**1. Enable env overrides:**
```zsh
export CONFIG_ALLOW_ENV_OVERRIDE=true
```

**2. Check variable format:**
```zsh
# Correct format: CONFIG_KEY_NAME
export CONFIG_DATABASE_HOST="value"      # ✓ database.host
export CONFIG_SERVER_WORKERS="8"         # ✓ server.workers
export CONFIG_APP_DEBUG_ENABLED="true"   # ✓ app.debug.enabled

# Wrong formats:
export CONFIG_database_host="value"      # ✗ Must be uppercase
export DATABASE_HOST="value"             # ✗ Missing CONFIG_ prefix
export database.host="value"             # ✗ Use underscores, not dots
```

**3. Verify format conversion:**
```zsh
# Key format: lowercase with dots
# Env format: CONFIG_ + uppercase with underscores

# Examples:
key="database.host"
env_key="CONFIG_${key//\./_}"
env_key="${env_key:u}"  # Uppercase
echo "$env_key"  # CONFIG_DATABASE_HOST
```

**4. Use custom prefix:**
```zsh
# Set custom prefix
export CONFIG_ENV_PREFIX="MYAPP"
export MYAPP_DATABASE_HOST="value"
```

---

### Problem: Configuration Not Saving

**Symptoms:**
```
config-set "key" "value"
config-save
# No error, but changes not persisted
```

**Root Causes:**
- No source file specified
- File permissions issue
- Disk space issue

**Solutions:**

**1. Specify source file:**
```zsh
# Must load first or specify file in save
config-load "config.json"
config-set "key" "value"
config-save  # Uses config.json

# Or specify explicitly
config-save "output.json"
```

**2. Check file permissions:**
```zsh
ls -l config.json
# Must be writable by current user

chmod 600 config.json  # Make writable (owner only)
```

**3. Check directory permissions:**
```zsh
# Parent directory must be writable
ls -ld "$(dirname "$config_file")"
chmod 755 "$(dirname "$config_file")"
```

**4. Enable auto-save:**
```zsh
export CONFIG_AUTO_SAVE=true
config-load "config.json"
config-set "key" "value"  # Auto-saves
```

---

### Problem: Type Validation Failing

**Symptoms:**
```
config-set "port" "8080" "int"
# Error: Value is not an integer
```

**Root Causes:**
- Value format incorrect
- Type validation enabled but value invalid
- Wrong type specified

**Solutions:**

**1. Check value format:**
```zsh
# Integer: digits only
config-set "port" "8080" "int"         # ✓ Valid
config-set "port" "8080.0" "int"       # ✗ Use float

# Boolean: specific values
config-set "debug" "true" "bool"       # ✓ Valid
config-set "debug" "True" "bool"       # ✗ Case-sensitive
config-set "debug" "1" "bool"          # ✓ Valid
config-set "debug" "yes" "bool"        # ✓ Valid

# Float: decimals allowed
config-set "ratio" "0.95" "float"      # ✓ Valid
config-set "ratio" "95" "float"        # ✓ Valid (integer OK for float)
```

**2. Disable type validation:**
```zsh
export CONFIG_VALIDATE_TYPES=false
config-set "port" "8080" "int"  # No error
```

**3. Use string type:**
```zsh
# When validation not needed
config-set "value" "anything"        # String, no validation
config-set "value" "anything" "string"  # Explicit string type
```

---

### Problem: Format Detection Incorrect

**Symptoms:**
```
config-load "config.backup"
# Detects as ENV but should be JSON
```

**Root Causes:**
- No file extension
- Wrong extension
- Content doesn't match format

**Solutions:**

**1. Specify format explicitly:**
```zsh
config-load "config.backup" "json"  # Override detection
```

**2. Check file extension:**
```zsh
# Use standard extensions:
config.json   # JSON format
config.ini    # INI format
config.env    # ENV format
```

**3. Fix file content:**
```zsh
# Verify JSON syntax
jq empty config.json

# Check INI sections
head config.ini  # Should start with [section]

# Check ENV format
head config.env  # Should be KEY=VALUE
```

---

### Problem: Memory/Performance Issues

**Symptoms:**
```
# Loading very large config (10,000+ keys)
# Takes long time, consumes memory
```

**Root Causes:**
- Large configuration file
- Many small access operations
- Memory limitations

**Solutions:**

**1. Reduce configuration size:**
```zsh
# Separate configuration by module
config-load "core.json"      # Load minimal set
config-merge "features.json" # Load only if needed

# Or use symbolic links to relevant sections
```

**2. Batch operations:**
```zsh
# Instead of:
for i in {1..1000}; do
    value=$(config-get "key.${i}")  # 1000 lookups
done

# Use:
values=$(config-dump)  # Single dump
while IFS='=' read -r key value; do
    # Process value
done <<< "$values"
```

**3. Use config-keys pattern filtering:**
```zsh
# Instead of loading all keys
for key in $(config-keys "database.*"); do
    # Only iterate matching keys
done
```

---

## Architecture & Design

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL (148 lines) -->

### Storage Structure

**In-Memory Data Structures (L104-122):**

```zsh
# Main configuration storage
declare -gA _CONFIG_DATA=()        # key -> value
declare -gA _CONFIG_TYPES=()       # key -> type
declare -gA _CONFIG_DEFAULTS=()    # key -> default_value
declare -gA _CONFIG_SCHEMA=()      # key -> schema (reserved)

# State tracking
declare -g _CONFIG_SOURCE_FILE=""    # Source file path
declare -g _CONFIG_SOURCE_FORMAT=""  # Source format (json/ini/env)
declare -g _CONFIG_MODIFIED=false    # Dirty flag for changes

# Statistics
declare -g _CONFIG_TOTAL_KEYS=0      # Key count
declare -g _CONFIG_TOTAL_LOADS=0     # Load operations
declare -g _CONFIG_TOTAL_SAVES=0     # Save operations
declare -g _CONFIG_TOTAL_GETS=0      # Get operations
declare -g _CONFIG_TOTAL_SETS=0      # Set operations
```

**Memory Characteristics:**
- Per key: ~100-250 bytes (key + value + metadata)
- 1,000 keys: ~100-250KB
- 10,000 keys: ~1-2.5MB
- Scales linearly with key count

---

### Format Handlers

**JSON Handler (L314-386):**
- Uses `jq` for safe parsing and generation
- Flattens nested structures to dot notation
- Supports arbitrary nesting depth
- Performance: ~200ms for 1000 keys

**INI Handler (L392-484):**
- Native ZSH parsing (no external tools)
- Section headers become key prefixes
- Handles quoted values
- Performance: ~100ms for 1000 keys

**ENV Handler (L490-553):**
- Simple KEY=VALUE parsing
- Converts underscores to dots
- Handles quoted values
- Performance: ~50ms for 1000 keys (fastest)

**YAML Handler:**
- Not yet implemented
- Planned for future versions
- Will use `yq` similar to jq approach

---

### Environment Override Resolution

**Priority Chain (→ L171-188, 369-376):**

```zsh
# When config-get "database.host" is called:

1. Check environment variable
   # Construct: CONFIG_DATABASE_HOST
   # If exists, return immediately

2. Check loaded config
   # Look in _CONFIG_DATA["database.host"]
   # If exists, return

3. Check defaults
   # Look in _CONFIG_DEFAULTS["database.host"]
   # If exists, return

4. Use provided default
   # Return parameter if passed
   # Otherwise return empty/error
```

**Performance:** O(1) for each step (hash lookups)

---

### Type Validation

**Validation Rules (→ L191-233):**

```zsh
# string: Always valid (catchall)
# int: Matches ^-?[0-9]+$ (signed integer)
# bool: Matches (true|false|1|0|yes|no|on|off)
# float: Matches ^-?[0-9]+\.?[0-9]*$ (decimal)
# array: Accepted (future support)

# Boolean normalization:
# true, 1, yes, on -> "true"
# false, 0, no, off -> "false"
```

---

### Auto-Save Mechanism

**Triggered on:**
- `config-set` when `CONFIG_AUTO_SAVE=true`
- `config-delete` when `CONFIG_AUTO_SAVE=true`

**Process:**
1. Modify internal state
2. Check `CONFIG_AUTO_SAVE` flag
3. Call `_config-auto-save` helper
4. Calls `config-save` if enabled
5. Uses same file/format as source

---

### Statistics Tracking

**Counters Maintained:**

```zsh
_CONFIG_TOTAL_KEYS    # Total keys loaded
_CONFIG_TOTAL_LOADS   # Number of config-load calls
_CONFIG_TOTAL_SAVES   # Number of config-save calls
_CONFIG_TOTAL_GETS    # Number of config-get calls
_CONFIG_TOTAL_SETS    # Number of config-set calls
```

**Uses:**
- Performance monitoring
- Debugging and diagnostics
- Audit trails

---

## External References

**Related Extensions:**
- `_common` v2.0 - Required: validation, XDG paths, command checking
- `_cache` v2.0 - Optional: cache parsed config results
- `_log` v2.0 - Optional: enhanced logging for config operations
- `_events` v2.0 - Optional: emit events on config changes

**File Locations:**
- Source: `/home/andronics/.local/bin/lib/_config`
- Documentation: `/home/andronics/.local/docs/lib/_config.md`
- Tests: Run `_config self-test`

**Further Reading:**
- JSON format: https://www.json.org
- INI format: https://en.wikipedia.org/wiki/INI_file
- ZSH parameter expansion: https://zsh.sourceforge.io/Doc/Release/Expansion.html
- 12-Factor App methodology: https://12factor.net

---

**Document Version:** 1.0 | Enhanced Documentation Requirements v1.1
**Last Updated:** 2025-11-07 | **Compliance:** Gold Standard (_bspwm v1.0.0 level)
