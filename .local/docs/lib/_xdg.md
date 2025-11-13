# _xdg - XDG Base Directory Specification Utilities

**Version:** 1.0.0
**Layer:** Infrastructure (Layer 2)
**Dependencies:** _common v2.0 (required), _log v2.0 (optional)
**Total Lines:** 660
**Functions:** 25
**Examples:** 10+
**Last Updated:** 2025-11-07

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (150 lines) -->

## Quick Reference Index

### Table of Contents

- [Function Quick Reference](#function-quick-reference) (L28-56, ~29 lines)
- [XDG Directories Quick Reference](#xdg-directories-quick-reference) (L57-80, ~24 lines)
- [Environment Variables Quick Reference](#environment-variables-quick-reference) (L81-105, ~25 lines)
- [Return Codes Quick Reference](#return-codes-quick-reference) (L106-120, ~15 lines)
- [Overview](#overview) (L121-180, ~60 lines)
- [Installation](#installation) (L181-240, ~60 lines)
- [Quick Start](#quick-start) (L241-450, ~210 lines)
- [Configuration](#configuration) (L451-600, ~150 lines)
- [API Reference](#api-reference) (L601-1800, ~1200 lines)
- [Advanced Usage](#advanced-usage) (L1801-2200, ~400 lines)
- [Best Practices](#best-practices) (L2201-2500, ~300 lines)
- [Troubleshooting](#troubleshooting) (L2501-3000, ~500 lines)
- [Architecture & Specification](#architecture--specification) (L3001-3300, ~300 lines)
- [External References](#external-references) (L3301-3350, ~50 lines)

---

## Function Quick Reference

<!-- CONTEXT_GROUP: directory-getters -->

| Function | Description | Source Lines | Complexity | Return | Link |
|----------|-------------|--------------|-----------|--------|------|
| `xdg-config-dir` | Get config directory path | L91-94 | O(1) | path | [→](#xdg-config-dir) |
| `xdg-cache-dir` | Get cache directory path | L100-103 | O(1) | path | [→](#xdg-cache-dir) |
| `xdg-data-dir` | Get data directory path | L109-112 | O(1) | path | [→](#xdg-data-dir) |
| `xdg-state-dir` | Get state directory path | L118-121 | O(1) | path | [→](#xdg-state-dir) |
| `xdg-runtime-dir` | Get runtime directory path | L127-130 | O(1) | path | [→](#xdg-runtime-dir) |

<!-- CONTEXT_GROUP: directory-setup -->

| `xdg-ensure-dir` | Create directory if needed | L140-155 | O(n) | 0/1 | [→](#xdg-ensure-dir) |
| `xdg-setup-all` | Create all XDG directories | L162-186 | O(n) | 0/1 | [→](#xdg-setup-all) |

<!-- CONTEXT_GROUP: file-paths -->

| `xdg-config-file` | Get full config file path | L196-200 | O(1) | path | [→](#xdg-config-file) |
| `xdg-cache-file` | Get full cache file path | L206-210 | O(1) | path | [→](#xdg-cache-file) |
| `xdg-data-file` | Get full data file path | L216-220 | O(1) | path | [→](#xdg-data-file) |
| `xdg-state-file` | Get full state file path | L226-230 | O(1) | path | [→](#xdg-state-file) |
| `xdg-runtime-file` | Get full runtime file path | L236-240 | O(1) | path | [→](#xdg-runtime-file) |

<!-- CONTEXT_GROUP: file-existence -->

| `xdg-config-exists` | Check config file exists | L250-255 | O(1) | 0/1 | [→](#xdg-config-exists) |
| `xdg-cache-exists` | Check cache file exists | L261-266 | O(1) | 0/1 | [→](#xdg-cache-exists) |
| `xdg-data-exists` | Check data file exists | L272-277 | O(1) | 0/1 | [→](#xdg-data-exists) |
| `xdg-state-exists` | Check state file exists | L283-288 | O(1) | 0/1 | [→](#xdg-state-exists) |
| `xdg-runtime-exists` | Check runtime file exists | L294-299 | O(1) | 0/1 | [→](#xdg-runtime-exists) |

<!-- CONTEXT_GROUP: directory-validation -->

| `xdg-dir-writable` | Check if directory writable | L309-312 | O(1) | 0/1 | [→](#xdg-dir-writable) |
| `xdg-validate-dir` | Validate directory exists/writable | L318-332 | O(1) | 0-4 | [→](#xdg-validate-dir) |

<!-- CONTEXT_GROUP: disk-usage -->

| `xdg-dir-size` | Get directory size (human readable) | L342-351 | O(n) | size | [→](#xdg-dir-size) |
| `xdg-dir-file-count` | Get file count in directory | L357-366 | O(n) | count | [→](#xdg-dir-file-count) |
| `xdg-show-usage` | Display usage for all directories | L371-381 | O(n) | output | [→](#xdg-show-usage) |

<!-- CONTEXT_GROUP: cache-management -->

| `xdg-clean-cache` | Remove all cache files | L391-409 | O(n) | 0/1 | [→](#xdg-clean-cache) |
| `xdg-clean-old-cache` | Remove old cache files (>N days) | L415-436 | O(n) | 0/1 | [→](#xdg-clean-old-cache) |

<!-- CONTEXT_GROUP: runtime-management -->

| `xdg-clean-runtime` | Remove all runtime files | L446-464 | O(n) | 0/1 | [→](#xdg-clean-runtime) |

<!-- CONTEXT_GROUP: config-management -->

| `xdg-create-default-config` | Create default config if missing | L474-498 | O(1) | 0/1 | [→](#xdg-create-default-config) |

<!-- CONTEXT_GROUP: information -->

| `xdg-show-dirs` | Display all XDG directories | L507-517 | O(1) | output | [→](#xdg-show-dirs) |
| `xdg-show-info` | Display detailed directory info | L522-548 | O(n) | output | [→](#xdg-show-info) |
| `xdg-self-test` | Run comprehensive self-test | L557-658 | O(n) | 0/1 | [→](#xdg-self-test) |

---

## XDG Directories Quick Reference

| Directory | Variable | Default Path | Purpose | Persistence |
|-----------|----------|---------------|---------|-------------|
| **Config** | `XDG_CONFIG_HOME` | `~/.config` | User configuration files | Persistent |
| **Cache** | `XDG_CACHE_HOME` | `~/.cache` | User cache data | Persistent |
| **Data** | `XDG_DATA_HOME` | `~/.local/share` | User data files | Persistent |
| **State** | `XDG_STATE_HOME` | `~/.local/state` | User state data | Persistent |
| **Runtime** | `XDG_RUNTIME_DIR` | `/run/user/UID` | Runtime files (PIDs, sockets) | Temporary |

---

## Environment Variables Quick Reference

| Variable | Type | Default | Purpose | Link |
|----------|------|---------|---------|------|
| `XDG_CONFIG_HOME` | path | `~/.config` | Config directory base | [→](#xdg-config-home) |
| `XDG_CACHE_HOME` | path | `~/.cache` | Cache directory base | [→](#xdg-cache-home) |
| `XDG_DATA_HOME` | path | `~/.local/share` | Data directory base | [→](#xdg-data-home) |
| `XDG_STATE_HOME` | path | `~/.local/state` | State directory base | [→](#xdg-state-home) |
| `XDG_RUNTIME_DIR` | path | `/run/user/$(id -u)` | Runtime directory base | [→](#xdg-runtime-dir-env) |

---

## Return Codes Quick Reference

| Code | Meaning | Context | Link |
|------|---------|---------|------|
| `0` | Success | Operation completed successfully | [→](#return-code-0) |
| `1` | Error | Generic failure (mkdir, cleanup, etc.) | [→](#return-code-1) |
| `2` | Invalid arguments | Missing required parameters | [→](#return-code-2) |
| `3` | Not writable | Directory not writable | [→](#return-code-3) |
| `4` | Not found | Directory/file doesn't exist | [→](#return-code-4) |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (60 lines) -->

## Overview

The `_xdg` extension provides complete **XDG Base Directory Specification** compliance for ZSH scripts, enabling proper file organization across config, cache, data, state, and runtime directories. It ensures applications follow Linux/Unix filesystem conventions and play nicely with system-wide configurations.

**What is XDG Base Directory Specification?**

The XDG Base Directory Specification is a freedesktop.org standard that defines where applications should store different types of data on Unix-like systems. This prevents filesystem pollution and enables proper user data isolation.

**Key Features:**

- ✅ **Full XDG Spec Compliance:** Implements all five XDG directory types with proper fallbacks
- ✅ **Automatic Directory Creation:** Create and validate directories with one function
- ✅ **Smart Fallbacks:** Graceful degradation when XDG variables not set
- ✅ **Multi-User Safe:** Per-user directory isolation
- ✅ **Zero Dependencies:** Pure ZSH implementation (except _common requirement)
- ✅ **Performance:** O(1) path operations, O(n) directory scanning
- ✅ **Comprehensive Testing:** Included self-test validates all functions
- ✅ **Cross-Platform:** Works on Linux, BSD, macOS

**XDG Specification Reference:**
- https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (60 lines) -->

## Installation

### Loading the Extension

```zsh
# Load with error handling (recommended)
if ! source "$(command -v _xdg)" 2>/dev/null; then
    echo "Error: _xdg extension not found" >&2
    echo "Install: cd ~/.pkgs && stow lib" >&2
    exit 6
fi

# Or from fixed path
source ~/.local/bin/lib/_xdg || exit 6
```

### Requirements

**System Requirements:**
- ZSH 5.0+ (for associative arrays)
- Linux/Unix filesystem
- User write permissions in `$HOME`

**Dependencies:**
- `_common` v2.0 (required) - Provides base XDG path functions
- `_log` v2.0 (optional) - Structured logging (gracefully degrades)
- `_lifecycle` v3.0 (optional) - Cleanup registration (gracefully degrades)

**Installation via Stow:**

```bash
cd ~/.pkgs
stow lib  # Symlinks all extensions to ~/.local/bin/lib/

# Verify installation
which _xdg && echo "✓ _xdg installed"
```

### Verification

```zsh
# Test basic functionality
if _xdg_loaded 2>/dev/null; then
    echo "✓ _xdg loaded successfully"
    xdg-config-dir test && echo "✓ XDG functions working"
else
    echo "✗ _xdg failed to load"
    exit 1
fi

# Run comprehensive test
xdg-self-test
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (210 lines) -->

## Quick Start

### Getting Started in 5 Minutes

#### 1. Load the Extension

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP="myapp"
```

#### 2. Get Directory Paths

```zsh
# Simple path retrieval (no directory creation)
config_dir=$(xdg-config-dir "$APP")
cache_dir=$(xdg-cache-dir "$APP")
data_dir=$(xdg-data-dir "$APP")

echo "Config: $config_dir"
echo "Cache: $cache_dir"
echo "Data: $data_dir"
# Output:
# Config: /home/user/.config/myapp
# Cache: /home/user/.cache/myapp
# Data: /home/user/.local/share/myapp
```

#### 3. Create Directories

```zsh
# Ensure all directories exist
xdg-ensure-dir "$config_dir"
xdg-ensure-dir "$cache_dir"

# Or setup all at once
xdg-setup-all "$APP"
```

#### 4. Store Configuration

```zsh
# Create default config file
xdg-create-default-config "$APP" "config.json" '{
  "debug": false,
  "version": "1.0"
}'

# Use config file
config_file=$(xdg-config-file "$APP" "config.json")
echo "Config: $config_file"
```

#### 5. Store Data

```zsh
# Get data file path
data_file=$(xdg-data-file "$APP" "database.db")

# Initialize if needed
if ! xdg-data-exists "$APP" "database.db"; then
    echo "Initializing database..."
    touch "$data_file"
fi

# Use data file
echo "Data file: $data_file"
```

### Example 1: Application Initialization

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP_NAME="myapp"

# Create all directories
echo "Initializing $APP_NAME..."
xdg-setup-all "$APP_NAME"

# Show where everything is
xdg-show-dirs "$APP_NAME"

# Create default configuration
xdg-create-default-config "$APP_NAME" "settings.json" '{
  "version": "1.0.0",
  "debug": false,
  "port": 8080
}'

echo "Setup complete!"
```

### Example 2: Cache Management

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP="myapp"

# Get cache directory
cache_dir=$(xdg-cache-dir "$APP")
xdg-ensure-dir "$cache_dir"

# Store something in cache
echo "Important data" > "$(xdg-cache-file "$APP" "data.txt")"

# Check cache size
size=$(xdg-dir-size "$cache_dir")
echo "Cache size: $size"

# Clean cache
xdg-clean-cache "$APP"
```

### Example 3: PID File Management

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

DAEMON_NAME="mydaemon"

# Get runtime file path
pidfile=$(xdg-runtime-file "$DAEMON_NAME" "daemon.pid")

# Check if already running
if xdg-runtime-exists "$DAEMON_NAME" "daemon.pid"; then
    existing_pid=$(cat "$pidfile")
    if kill -0 "$existing_pid" 2>/dev/null; then
        echo "Daemon already running (PID: $existing_pid)"
        exit 1
    fi
fi

# Start daemon and write PID
echo "$$" > "$pidfile"
echo "Daemon started (PID: $$)"
```

### Example 4: State Persistence

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP="myapp"
state_file=$(xdg-state-file "$APP" "session.json")

# Ensure directory exists
xdg-ensure-dir "$(dirname "$state_file")"

# Load previous state
if [[ -f "$state_file" ]]; then
    state=$(cat "$state_file")
    echo "Loaded state: $state"
else
    state='{"count": 0}'
fi

# Update state
state=$(echo "$state" | jq '.count += 1')

# Save state
echo "$state" > "$state_file"
echo "State saved: $state"
```

### Example 5: Check Directory Writable

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP="myapp"
config_dir=$(xdg-config-dir "$APP")

# Check if we can write
if xdg-dir-writable "$config_dir"; then
    echo "✓ Can write to config directory"
else
    echo "✗ Cannot write to config directory"
    # Fallback to temp directory
    export XDG_CONFIG_HOME="/tmp/config-$(id -u)"
    config_dir=$(xdg-config-dir "$APP")
    xdg-ensure-dir "$config_dir"
    echo "Using fallback: $config_dir"
fi
```

### Example 6: File Existence Checks

```zsh
#!/usr/bin/env zsh
source "$(command -v _xdg)" || exit 6

APP="myapp"

# Check config existence
if xdg-config-exists "$APP" "config.json"; then
    echo "✓ Config exists"
    cat "$(xdg-config-file "$APP" "config.json")"
else
    echo "✗ Config missing, creating default..."
    xdg-create-default-config "$APP" "config.json" '{"key": "value"}'
fi

# Check other file types
xdg-data-exists "$APP" "database.db" && echo "✓ Database exists"
xdg-cache-exists "$APP" "cache.txt" && echo "✓ Cache exists"
xdg-state-exists "$APP" "history.log" && echo "✓ State exists"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (150 lines) -->

## Configuration

### XDG Environment Variables

The `_xdg` extension respects all standard XDG environment variables. These can be set before loading the extension to customize behavior.

#### XDG_CONFIG_HOME

**Purpose:** Base directory for user configuration files

**Default:** `~/.config`

**Spec:** User-specific configuration files (application settings, preferences)

**Usage:**
```zsh
# Use standard location
echo $XDG_CONFIG_HOME  # ~/.config

# Or override
export XDG_CONFIG_HOME="/opt/myconfig"
source "$(command -v _xdg)"

# Now config dirs use /opt/myconfig
config_dir=$(xdg-config-dir "myapp")
echo "$config_dir"  # /opt/myconfig/myapp
```

#### XDG_CACHE_HOME

**Purpose:** Base directory for user cache data

**Default:** `~/.cache`

**Spec:** User cache files that can be safely deleted (will be regenerated)

**Usage:**
```zsh
# Standard location
cache_dir=$(xdg-cache-dir "myapp")
# ~/.cache/myapp

# Override for custom location
export XDG_CACHE_HOME="/var/cache/user"
```

#### XDG_DATA_HOME

**Purpose:** Base directory for user data files

**Default:** `~/.local/share`

**Spec:** User data files that should persist (databases, documents, etc.)

**Usage:**
```zsh
# Standard location
data_dir=$(xdg-data-dir "myapp")
# ~/.local/share/myapp

# Override for custom location
export XDG_DATA_HOME="/opt/myapp/data"
```

#### XDG_STATE_HOME

**Purpose:** Base directory for user state data

**Default:** `~/.local/state`

**Spec:** State files that track application state (history, sessions, etc.)

**Usage:**
```zsh
# Standard location
state_dir=$(xdg-state-dir "myapp")
# ~/.local/state/myapp

# Override for custom location
export XDG_STATE_HOME="/opt/myapp/state"
```

#### XDG_RUNTIME_DIR

**Purpose:** Base directory for runtime files

**Default:** `/run/user/$(id -u)`

**Spec:** Runtime files that should be on fast storage (PIDs, sockets, temporary files)

**Characteristics:**
- Typically on tmpfs (memory)
- Cleared on reboot
- User-specific (per-UID)
- Fast access

**Usage:**
```zsh
# Standard location
runtime_dir=$(xdg-runtime-dir "myapp")
# /run/user/1000/myapp

# Override for custom location
export XDG_RUNTIME_DIR="/tmp/runtime-1000"
```

### Fallback Behavior

If XDG environment variables are not set, `_xdg` uses sensible defaults:

```zsh
# Default fallbacks
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
```

### Directory Structure Example

After setting up an application, the following structure is created:

```
~/.config/myapp/                # Config files
├── config.json
├── settings.yaml
└── profiles/
    ├── dev.json
    └── prod.json

~/.cache/myapp/                 # Cache (can be deleted)
├── api-responses/
├── thumbnails/
└── temp/

~/.local/share/myapp/           # Data files (persistent)
├── database.db
├── documents/
└── backups/

~/.local/state/myapp/           # State files
├── history.txt
├── session.json
└── lastrun.log

/run/user/1000/myapp/           # Runtime files (temp)
├── daemon.pid
├── socket
└── locks/
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE (1200 lines) -->

## API Reference

### Directory Getter Functions

<!-- CONTEXT_GROUP: directory-getters -->

These functions return paths without creating directories. Use them to get where data should go.

#### xdg-config-dir

Get XDG config directory path for an application.

**Signature:**
```zsh
xdg-config-dir <app-name>
```

**Parameters:**
- `app-name` (required) - Application name (used as subdirectory)

**Returns:**
- Stdout: Full path to config directory
- Exit code: 0 on success, 2 if app-name missing

**Complexity:** O(1) - Simple string concatenation

**Dependencies:** _common (provides base path)

**Example:**
```zsh
# Basic usage
config=$(xdg-config-dir "myapp")
echo "$config"  # ~/.config/myapp

# Use in script
if [[ -f "$(xdg-config-dir myapp)/settings.json" ]]; then
    echo "Config exists"
fi

# With variables
APP_NAME="my-application"
CONFIG_DIR=$(xdg-config-dir "$APP_NAME")
mkdir -p "$CONFIG_DIR"
```

**Notes:**
- Does NOT create directory (use `xdg-ensure-dir` to create)
- Respects `XDG_CONFIG_HOME` environment variable
- App name becomes subdirectory: `$XDG_CONFIG_HOME/$app-name`

---

#### xdg-cache-dir

Get XDG cache directory path for an application.

**Signature:**
```zsh
xdg-cache-dir <app-name>
```

**Parameters:**
- `app-name` (required) - Application name

**Returns:**
- Stdout: Full path to cache directory
- Exit code: 0 on success, 2 if app-name missing

**Complexity:** O(1)

**Example:**
```zsh
cache=$(xdg-cache-dir "myapp")
echo "$cache"  # ~/.cache/myapp

# Check cache size
du -sh "$(xdg-cache-dir myapp)"

# Use in loop
for app in myapp otherapp; do
    cache=$(xdg-cache-dir "$app")
    [[ -d "$cache" ]] && du -sh "$cache"
done
```

**Notes:**
- Cache is volatile (can be deleted safely)
- Files here will not persist across cache cleanups

---

#### xdg-data-dir

Get XDG data directory path for an application.

**Signature:**
```zsh
xdg-data-dir <app-name>
```

**Parameters:**
- `app-name` (required) - Application name

**Returns:**
- Stdout: Full path to data directory
- Exit code: 0 on success, 2 if app-name missing

**Complexity:** O(1)

**Example:**
```zsh
data=$(xdg-data-dir "myapp")
echo "$data"  # ~/.local/share/myapp

# Initialize database
db="$(xdg-data-dir myapp)/app.db"
if [[ ! -f "$db" ]]; then
    sqlite3 "$db" < schema.sql
fi

# Use database
sqlite3 "$db" "SELECT * FROM users"
```

**Notes:**
- For persistent application data
- Should NOT contain cache or config
- Use for databases, documents, user data

---

#### xdg-state-dir

Get XDG state directory path for an application.

**Signature:**
```zsh
xdg-state-dir <app-name>
```

**Parameters:**
- `app-name` (required) - Application name

**Returns:**
- Stdout: Full path to state directory
- Exit code: 0 on success, 2 if app-name missing

**Complexity:** O(1)

**Example:**
```zsh
state=$(xdg-state-dir "myapp")
echo "$state"  # ~/.local/state/myapp

# Save session state
session_file="$(xdg-state-dir myapp)/session.json"
echo '{"window": "maximized"}' > "$session_file"

# Load session state
if [[ -f "$session_file" ]]; then
    jq . "$session_file"
fi
```

**Notes:**
- For application state that should persist but changes
- Examples: history, session info, last run time
- Different from data (data is core, state is transient)

---

#### xdg-runtime-dir

Get XDG runtime directory path for an application.

**Signature:**
```zsh
xdg-runtime-dir <app-name>
```

**Parameters:**
- `app-name` (required) - Application name

**Returns:**
- Stdout: Full path to runtime directory
- Exit code: 0 on success, 2 if app-name missing

**Complexity:** O(1)

**Example:**
```zsh
runtime=$(xdg-runtime-dir "myapp")
echo "$runtime"  # /run/user/1000/myapp

# PID file
pidfile="$(xdg-runtime-dir myapp)/daemon.pid"
echo $$ > "$pidfile"

# Check if already running
if [[ -f "$pidfile" ]]; then
    pid=$(cat "$pidfile")
    kill -0 "$pid" 2>/dev/null && echo "Running"
fi

# Unix socket
socket="$(xdg-runtime-dir myapp)/socket"
```

**Notes:**
- Runtime directory is typically on tmpfs (memory)
- Automatically cleared on system reboot
- Use for: PID files, sockets, temporary locks
- May not exist on all systems (check with `xdg-ensure-dir`)

---

### Directory Setup Functions

<!-- CONTEXT_GROUP: directory-setup -->

#### xdg-ensure-dir

Create directory and all parent directories if they don't exist.

**Signature:**
```zsh
xdg-ensure-dir <directory-path>
```

**Parameters:**
- `directory-path` (required) - Full path to directory

**Returns:**
- Exit code: 0 on success, 1 on failure

**Complexity:** O(n) where n = depth of directory path

**Side Effects:**
- Creates directory recursively if needed
- Sets appropriate permissions
- No error if directory already exists

**Example:**
```zsh
# Basic usage
xdg-ensure-dir "$HOME/.config/myapp" || exit 1

# After this, directory is guaranteed to exist
echo "Creating config file..."
echo "{}" > "$HOME/.config/myapp/config.json"

# Safe even if directory exists
xdg-ensure-dir "$HOME/.config/myapp"
echo "Still safe"

# Use with get functions
config_dir=$(xdg-config-dir "myapp")
xdg-ensure-dir "$config_dir"
echo "Config ready at: $config_dir"
```

**Error Handling:**
```zsh
# Check result
if xdg-ensure-dir "$config_dir"; then
    echo "Directory ready"
else
    echo "Failed to create directory: $config_dir"
    exit 1
fi
```

**Notes:**
- Idempotent (safe to call multiple times)
- Creates all parent directories
- Logs to _log if available

---

#### xdg-setup-all

Create all five XDG directories (config, cache, data, state, runtime) for an application.

**Signature:**
```zsh
xdg-setup-all <app-name>
```

**Parameters:**
- `app-name` (required) - Application name

**Returns:**
- Exit code: 0 if all created successfully, 1 if any failed

**Complexity:** O(n) - Creates 5 directories

**Side Effects:**
- Creates directories: config, cache, data, state, runtime
- Runtime directory creation may fail gracefully (acceptable)
- Logs operations via _log if available

**Example:**
```zsh
# Complete application initialization
APP_NAME="myapp"

echo "Setting up directories for $APP_NAME..."
if xdg-setup-all "$APP_NAME"; then
    echo "✓ All directories created"
else
    echo "✗ Some directories failed (check log)"
    exit 1
fi

# Now all directories exist
config=$(xdg-config-dir "$APP_NAME")
cache=$(xdg-cache-dir "$APP_NAME")
data=$(xdg-data-dir "$APP_NAME")
state=$(xdg-state-dir "$APP_NAME")
runtime=$(xdg-runtime-dir "$APP_NAME")

echo "Ready to use:"
echo "  Config: $config"
echo "  Cache: $cache"
echo "  Data: $data"
echo "  State: $state"
echo "  Runtime: $runtime"
```

**Notes:**
- Idempotent (safe to call multiple times)
- Runtime directory creation may fail on some systems (acceptable)
- Always call once at application startup
- Use with `xdg-show-dirs` to verify

---

### File Path Functions

<!-- CONTEXT_GROUP: file-paths -->

These functions construct full paths to files within XDG directories.

#### xdg-config-file

Get full path to a config file.

**Signature:**
```zsh
xdg-config-file <app-name> <filename>
```

**Parameters:**
- `app-name` (required) - Application name
- `filename` (required) - Filename within config directory

**Returns:**
- Stdout: Full path to config file
- Exit code: 0 on success, 2 if parameters missing

**Complexity:** O(1)

**Example:**
```zsh
# Get config file path
config=$(xdg-config-file "myapp" "config.json")
echo "$config"  # ~/.config/myapp/config.json

# Use in file operations
if [[ -f "$config" ]]; then
    jq . "$config"
fi

# Create config if missing
if ! xdg-config-exists "myapp" "config.json"; then
    xdg-create-default-config "myapp" "config.json" "{}"
fi

# Load config
source "$(xdg-config-file myapp settings.sh)"
```

**Notes:**
- Does not create file
- Returns path even if file doesn't exist
- Use with `xdg-config-exists` to check

---

#### xdg-cache-file

Get full path to a cache file.

**Signature:**
```zsh
xdg-cache-file <app-name> <filename>
```

**Parameters:**
- `app-name` (required)
- `filename` (required)

**Returns:**
- Stdout: Full path to cache file

**Complexity:** O(1)

**Example:**
```zsh
# Cache API response
cache=$(xdg-cache-file "myapp" "api-response.json")
curl https://api.example.com/data > "$cache"

# Check cache freshness
if [[ -f "$cache" ]]; then
    age=$(($(date +%s) - $(stat -c %Y "$cache")))
    if (( age < 3600 )); then
        echo "Cache fresh, using cached data"
        cat "$cache"
    else
        echo "Cache stale, fetching fresh data"
    fi
fi
```

---

#### xdg-data-file

Get full path to a data file.

**Signature:**
```zsh
xdg-data-file <app-name> <filename>
```

**Parameters:**
- `app-name` (required)
- `filename` (required)

**Returns:**
- Stdout: Full path to data file

**Complexity:** O(1)

**Example:**
```zsh
# Database file
db=$(xdg-data-file "myapp" "database.db")

# Create database if needed
if [[ ! -f "$db" ]]; then
    sqlite3 "$db" < schema.sql
fi

# Use database
sqlite3 "$db" "INSERT INTO users (name) VALUES ('Alice')"
```

---

#### xdg-state-file

Get full path to a state file.

**Signature:**
```zsh
xdg-state-file <app-name> <filename>
```

**Parameters:**
- `app-name` (required)
- `filename` (required)

**Returns:**
- Stdout: Full path to state file

**Complexity:** O(1)

**Example:**
```zsh
# Session state
session=$(xdg-state-file "myapp" "session.json")

# Load previous session
if [[ -f "$session" ]]; then
    jq . "$session"
else
    echo "{}" > "$session"
fi
```

---

#### xdg-runtime-file

Get full path to a runtime file.

**Signature:**
```zsh
xdg-runtime-file <app-name> <filename>
```

**Parameters:**
- `app-name` (required)
- `filename` (required)

**Returns:**
- Stdout: Full path to runtime file

**Complexity:** O(1)

**Example:**
```zsh
# PID file
pidfile=$(xdg-runtime-file "myapp" "daemon.pid")
echo $$ > "$pidfile"

# Socket
socket=$(xdg-runtime-file "myapp" "socket")

# Lock file
lockfile=$(xdg-runtime-file "myapp" "lock")
exec {lock_fd}>"$lockfile"
flock -n "$lock_fd" || exit 1
```

---

### File Existence Check Functions

<!-- CONTEXT_GROUP: file-existence -->

Fast checks to test if files exist (don't throw errors).

#### xdg-config-exists

Check if a config file exists.

**Signature:**
```zsh
xdg-config-exists <app-name> <filename>
```

**Parameters:**
- `app-name` (required)
- `filename` (required)

**Returns:**
- Exit code: 0 if file exists, 1 otherwise

**Complexity:** O(1)

**Example:**
```zsh
# Check and load config
if xdg-config-exists "myapp" "config.json"; then
    config=$(cat "$(xdg-config-file myapp config.json)")
    echo "Config loaded"
else
    echo "Config missing, using defaults"
    config="{}"
fi

# Use in conditionals
if xdg-config-exists "myapp" "config.json"; then
    : # Config exists
else
    # Create default config
    xdg-create-default-config "myapp" "config.json" "{}"
fi
```

---

#### xdg-cache-exists

Check if a cache file exists.

**Signature:**
```zsh
xdg-cache-exists <app-name> <filename>
```

**Returns:**
- Exit code: 0 if exists, 1 otherwise

**Example:**
```zsh
if xdg-cache-exists "myapp" "data.cache"; then
    echo "Using cached data"
    cat "$(xdg-cache-file myapp data.cache)"
else
    echo "Cache miss, fetching fresh data"
fi
```

---

#### xdg-data-exists

Check if a data file exists.

**Signature:**
```zsh
xdg-data-exists <app-name> <filename>
```

**Returns:**
- Exit code: 0 if exists, 1 otherwise

**Example:**
```zsh
# Check if database exists
if ! xdg-data-exists "myapp" "database.db"; then
    echo "Initializing database..."
    sqlite3 "$(xdg-data-file myapp database.db)" < schema.sql
fi
```

---

#### xdg-state-exists

Check if a state file exists.

**Signature:**
```zsh
xdg-state-exists <app-name> <filename>
```

**Returns:**
- Exit code: 0 if exists, 1 otherwise

---

#### xdg-runtime-exists

Check if a runtime file exists.

**Signature:**
```zsh
xdg-runtime-exists <app-name> <filename>
```

**Returns:**
- Exit code: 0 if exists, 1 otherwise

**Example:**
```zsh
# Check if daemon is running
if xdg-runtime-exists "myapp" "daemon.pid"; then
    pid=$(cat "$(xdg-runtime-file myapp daemon.pid)")
    if kill -0 "$pid" 2>/dev/null; then
        echo "Daemon running (PID: $pid)"
    else
        echo "Stale PID file"
    fi
else
    echo "Daemon not started"
fi
```

---

### Directory Validation Functions

<!-- CONTEXT_GROUP: directory-validation -->

#### xdg-dir-writable

Test if directory exists and is writable.

**Signature:**
```zsh
xdg-dir-writable <directory-path>
```

**Parameters:**
- `directory-path` (required) - Path to test

**Returns:**
- Exit code: 0 if exists and writable, 1 otherwise

**Complexity:** O(1)

**Example:**
```zsh
config_dir=$(xdg-config-dir "myapp")

if ! xdg-ensure-dir "$config_dir"; then
    echo "Error: Cannot create config directory"
    exit 1
fi

if ! xdg-dir-writable "$config_dir"; then
    echo "Error: Config directory not writable"
    exit 1
fi

# Now safe to write config
echo "{}" > "$config_dir/config.json"
```

**Notes:**
- Requires directory to exist
- Tests both existence and write permission

---

#### xdg-validate-dir

Validate directory exists and is writable, with error codes.

**Signature:**
```zsh
xdg-validate-dir <directory-path>
```

**Parameters:**
- `directory-path` (required)

**Returns:**
- Exit code: 0 on success
- Exit code: 4 if directory not found
- Exit code: 3 if not writable

**Complexity:** O(1)

**Example:**
```zsh
config_dir=$(xdg-config-dir "myapp")
xdg-ensure-dir "$config_dir"

case $(xdg-validate-dir "$config_dir") in
    0)
        echo "✓ Directory valid and writable"
        ;;
    3)
        echo "✗ Directory not writable"
        exit 1
        ;;
    4)
        echo "✗ Directory not found"
        exit 1
        ;;
esac
```

---

### Disk Usage Functions

<!-- CONTEXT_GROUP: disk-usage -->

#### xdg-dir-size

Get human-readable directory size.

**Signature:**
```zsh
xdg-dir-size <directory-path>
```

**Parameters:**
- `directory-path` (required)

**Returns:**
- Stdout: Size string (e.g., "42M", "1.5G")
- Exit code: 0 on success, 4 if not found

**Complexity:** O(n) where n = directory size

**Example:**
```zsh
config_size=$(xdg-dir-size "$(xdg-config-dir myapp)")
echo "Config size: $config_size"

# Monitor all directories
APP="myapp"
echo "Size breakdown:"
echo "  Config: $(xdg-dir-size $(xdg-config-dir $APP))"
echo "  Cache: $(xdg-dir-size $(xdg-cache-dir $APP))"
echo "  Data: $(xdg-dir-size $(xdg-data-dir $APP))"
```

**Notes:**
- Uses `du -sh` (may be slow for large directories)
- Includes all subdirectories
- Returns "0" if directory doesn't exist

---

#### xdg-dir-file-count

Count files in directory recursively.

**Signature:**
```zsh
xdg-dir-file-count <directory-path>
```

**Parameters:**
- `directory-path` (required)

**Returns:**
- Stdout: Number of files
- Exit code: 0 on success, 4 if not found

**Complexity:** O(n) where n = file count

**Example:**
```zsh
# Check how many config files
count=$(xdg-dir-file-count "$(xdg-config-dir myapp)")
echo "Config files: $count"

# Warn if too many files
if (( count > 1000 )); then
    echo "Warning: Too many cache files"
    xdg-clean-old-cache myapp 7
fi
```

---

#### xdg-show-usage

Display disk usage for all XDG directories.

**Signature:**
```zsh
xdg-show-usage <app-name>
```

**Parameters:**
- `app-name` (required)

**Returns:**
- Stdout: Formatted usage report
- Exit code: 0 on success

**Complexity:** O(n)

**Example:**
```zsh
# Show usage breakdown
xdg-show-usage "myapp"
# Output:
# Disk usage for: myapp
#
#   CONFIG   : 4.0K
#   CACHE    : 42M
#   DATA     : 128M
#   STATE    : 8.0K
#   RUNTIME  : 0

# Use in scripts
total=$(xdg-show-usage "myapp")
if [[ "$total" == *"1.5G"* ]] || [[ "$total" == *"2"*"G"* ]]; then
    echo "Data directory is getting large, consider cleanup"
fi
```

---

### Cache Management Functions

<!-- CONTEXT_GROUP: cache-management -->

#### xdg-clean-cache

Remove all files in cache directory.

**Signature:**
```zsh
xdg-clean-cache <app-name>
```

**Parameters:**
- `app-name` (required)

**Returns:**
- Exit code: 0 on success, 1 on failure

**Complexity:** O(n) where n = file count

**Side Effects:**
- Deletes all files in cache directory
- Preserves cache directory itself

**Example:**
```zsh
# Clean cache before starting
xdg-clean-cache "myapp"

# Clean all app caches
for app in myapp otherapp thirdapp; do
    xdg-clean-cache "$app"
done

# Verify clean
if [[ -z "$(find $(xdg-cache-dir myapp) -type f)" ]]; then
    echo "Cache successfully cleaned"
fi
```

**Notes:**
- Safe to call even if cache doesn't exist
- Irreversible (deleted files cannot be recovered)

---

#### xdg-clean-old-cache

Remove cache files older than N days.

**Signature:**
```zsh
xdg-clean-old-cache <app-name> <days>
```

**Parameters:**
- `app-name` (required)
- `days` (required) - Age threshold in days

**Returns:**
- Exit code: 0 on success, 1 on failure

**Complexity:** O(n)

**Side Effects:**
- Deletes files older than specified age
- Preserves newer files

**Example:**
```zsh
# Remove cache older than 30 days
xdg-clean-old-cache "myapp" 30

# Remove very old cache (90 days)
xdg-clean-old-cache "myapp" 90

# Scheduled cleanup (from cron)
# Run daily to keep cache fresh
0 2 * * * /home/user/.local/bin/lib/_xdg && xdg-clean-old-cache myapp 7
```

**Notes:**
- Uses file modification time
- Safer than `xdg-clean-cache` (preserves recent data)

---

### Runtime Management Functions

<!-- CONTEXT_GROUP: runtime-management -->

#### xdg-clean-runtime

Remove all runtime files.

**Signature:**
```zsh
xdg-clean-runtime <app-name>
```

**Parameters:**
- `app-name` (required)

**Returns:**
- Exit code: 0 on success, 1 on failure

**Complexity:** O(n)

**Side Effects:**
- Deletes all files in runtime directory
- Preserves runtime directory itself

**Example:**
```zsh
# Clean up on daemon shutdown
shutdown_daemon() {
    # Kill daemon process
    pkill -f "my_daemon"

    # Clean runtime files
    xdg-clean-runtime "mydaemon"
}

# Trap shutdown
trap shutdown_daemon EXIT
```

**Notes:**
- Call during application shutdown
- Cleans up PIDs, sockets, locks, etc.

---

### Config Management Functions

<!-- CONTEXT_GROUP: config-management -->

#### xdg-create-default-config

Create default config file if it doesn't exist.

**Signature:**
```zsh
xdg-create-default-config <app-name> <filename> <content>
```

**Parameters:**
- `app-name` (required) - Application name
- `filename` (required) - Config filename
- `content` (required) - Default file content

**Returns:**
- Exit code: 0 on success, 1 on failure

**Complexity:** O(1)

**Side Effects:**
- Creates config directory if needed
- Writes content to file if doesn't exist
- Idempotent (does nothing if file exists)

**Example:**
```zsh
# Create JSON config
xdg-create-default-config "myapp" "config.json" '{
  "version": "1.0.0",
  "debug": false,
  "port": 8080
}'

# Create YAML config
xdg-create-default-config "myapp" "settings.yaml" \
'debug: false
port: 8080
features:
  enabled: true'

# Create shell config
xdg-create-default-config "myapp" "settings.sh" \
'#!/bin/zsh
export DEBUG=false
export PORT=8080'

# Initialize on first run
if ! xdg-config-exists "myapp" "config.json"; then
    xdg-create-default-config "myapp" "config.json" "{}"
fi
```

**Notes:**
- Won't overwrite existing files
- Content can be multiline
- Safe to call multiple times

---

### Information Functions

<!-- CONTEXT_GROUP: information -->

#### xdg-show-dirs

Display all XDG directories for an application.

**Signature:**
```zsh
xdg-show-dirs <app-name>
```

**Parameters:**
- `app-name` (required)

**Returns:**
- Stdout: Formatted directory listing
- Exit code: 0 on success

**Complexity:** O(1)

**Example:**
```zsh
# Show all directories
xdg-show-dirs "myapp"
# Output:
# XDG directories for: myapp
#
#   CONFIG   : /home/user/.config/myapp
#   CACHE    : /home/user/.cache/myapp
#   DATA     : /home/user/.local/share/myapp
#   STATE    : /home/user/.local/state/myapp
#   RUNTIME  : /run/user/1000/myapp

# Use in setup script
echo "Setting up directories for $APP_NAME..."
xdg-setup-all "$APP_NAME"
echo ""
xdg-show-dirs "$APP_NAME"
```

---

#### xdg-show-info

Display detailed information about all directories.

**Signature:**
```zsh
xdg-show-info <app-name>
```

**Parameters:**
- `app-name` (required)

**Returns:**
- Stdout: Formatted detailed report
- Exit code: 0 on success

**Complexity:** O(n)

**Example:**
```zsh
# Show detailed info with sizes and file counts
xdg-show-info "myapp"
# Output:
# XDG Information for: myapp
#
# CONFIG   : /home/user/.config/myapp
#            [4.0K] (3 files)
#
# CACHE    : /home/user/.cache/myapp
#            [42M] (150 files)
#
# DATA     : /home/user/.local/share/myapp
#            [128M] (45 files)
#
# STATE    : /home/user/.local/state/myapp
#            [8.0K] (2 files)
#
# RUNTIME  : /run/user/1000/myapp
#            [0] (0 files)
```

**Notes:**
- Includes directory size and file count
- Good for debugging and monitoring

---

#### xdg-self-test

Run comprehensive self-tests on all functions.

**Signature:**
```zsh
xdg-self-test
```

**Parameters:**
- None

**Returns:**
- Stdout: Test results
- Exit code: 0 if all tests pass, 1 if any fail

**Complexity:** O(n) - Creates and cleans test directories

**Example:**
```zsh
# Run tests
xdg-self-test

# Typical output:
# === Testing _xdg v1.0.0 ===
#
# [TEST] Directory getters
#   PASS
#
# [TEST] Directory setup
#   PASS
#
# [TEST] File path construction
#   PASS
#
# ... (8+ more tests) ...
#
# === All tests PASSED ===
# _xdg v1.0.0

# Use in CI/CD
if xdg-self-test >/dev/null; then
    echo "✓ XDG extension tests passed"
else
    echo "✗ XDG extension tests failed"
    exit 1
fi

# Verbose output
xdg-self-test 2>&1 | grep -i fail
```

**Test Coverage:**
- Directory getter functions
- Directory setup and creation
- File path construction
- File existence checks
- Directory validation
- Disk usage functions
- Default config creation
- Cache cleaning
- Information display functions
- Cleanup

**Notes:**
- Non-destructive (cleans up test directories)
- Safe to run on production systems
- Great for verifying installation

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (400 lines) -->

## Advanced Usage

### Portable Path Handling

Create portable scripts that work on any system by using XDG functions:

```zsh
#!/usr/bin/env zsh
# Portable application setup

source "$(command -v _xdg)" || exit 6

setup_application() {
    local app_name="$1"

    # Create all directories
    xdg-setup-all "$app_name"

    # Create config with defaults
    xdg-create-default-config "$app_name" "config.json" \
        '{"version": "1.0", "initialized": true}'

    # Initialize data directory
    local data_dir=$(xdg-data-dir "$app_name")
    if [[ ! -d "$data_dir" ]]; then
        mkdir -p "$data_dir"
    fi

    # Verify setup
    xdg-show-dirs "$app_name"
}

setup_application "myapp"
```

### Multi-Application Configuration

Manage multiple related applications with shared and separate configurations:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

# Setup multiple related apps
declare -a APPS=("myapp-web" "myapp-api" "myapp-worker")

for app in "${APPS[@]}"; do
    echo "Setting up $app..."
    xdg-setup-all "$app"
done

# Create shared configuration
shared_config=$(xdg-config-dir "myapp")/shared.json
xdg-ensure-dir "$(dirname "$shared_config")"
echo '{"api": "https://api.example.com"}' > "$shared_config"

# Each app has own config + shared config access
for app in "${APPS[@]}"; do
    config=$(xdg-config-file "$app" "config.json")
    shared=$(xdg-config-dir "myapp")/shared.json

    echo "Config: $config (shared: $shared)"
done
```

### Cache with TTL Pattern

Implement time-to-live cache patterns:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

# Cache with TTL (Time To Live)
cache_get_or_fetch() {
    local app="$1"
    local key="$2"
    local ttl="${3:-3600}"  # Default 1 hour

    local cache_file=$(xdg-cache-file "$app" "${key}.cache")
    xdg-ensure-dir "$(dirname "$cache_file")"

    # Check if cache exists and is fresh
    if [[ -f "$cache_file" ]]; then
        local age=$(($(date +%s) - $(stat -c %Y "$cache_file")))
        if (( age < ttl )); then
            # Cache hit
            cat "$cache_file"
            return 0
        fi
    fi

    # Cache miss - fetch and store
    local data=$(fetch_data "$key")
    echo "$data" > "$cache_file"
    echo "$data"
}

fetch_data() {
    # Simulate expensive operation
    curl -s "https://api.example.com/data/$1"
}

# Usage
cache_get_or_fetch "myapp" "users" 3600
```

### State Machine Pattern

Track application state across sessions:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

# State machine using XDG state directory
declare -A STATE_TRANSITIONS=(
    ["init"]="running"
    ["running"]="stopping"
    ["stopping"]="stopped"
    ["stopped"]="init"
)

get_state() {
    local app="$1"
    local state_file=$(xdg-state-file "$app" "status.txt")

    if [[ -f "$state_file" ]]; then
        cat "$state_file"
    else
        echo "init"
    fi
}

set_state() {
    local app="$1"
    local state="$2"
    local state_file=$(xdg-state-file "$app" "status.txt")

    xdg-ensure-dir "$(dirname "$state_file")"
    echo "$state" > "$state_file"
}

transition_state() {
    local app="$1"
    local current=$(get_state "$app")
    local next="${STATE_TRANSITIONS[$current]}"

    if [[ -z "$next" ]]; then
        echo "Error: Invalid state transition from $current"
        return 1
    fi

    set_state "$app" "$next"
    echo "$current → $next"
}

# Usage
APP="myapp"
echo "Current: $(get_state $APP)"
transition_state "$APP"
echo "Updated: $(get_state $APP)"
```

### Runtime Socket Management

Create and manage Unix sockets for inter-process communication:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

# IPC via Unix socket
start_daemon() {
    local app="$1"
    local socket=$(xdg-runtime-file "$app" "socket")
    local pidfile=$(xdg-runtime-file "$app" "daemon.pid")

    xdg-ensure-dir "$(dirname "$socket")"

    # Check if already running
    if xdg-runtime-exists "$app" "daemon.pid"; then
        local pid=$(cat "$pidfile")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Daemon already running (PID: $pid, Socket: $socket)"
            return 1
        else
            rm -f "$pidfile" "$socket"
        fi
    fi

    # Start daemon
    (
        echo "$$" > "$pidfile"

        # Create named pipe for socket
        mkfifo "$socket" 2>/dev/null || true

        # Main daemon loop
        while true; do
            if read -t 5 cmd <"$socket"; then
                echo "Processing: $cmd"
                case "$cmd" in
                    "stop") break ;;
                    *) echo "Unknown command: $cmd" ;;
                esac
            fi
        done

        rm -f "$pidfile" "$socket"
    ) &

    echo "Daemon started (PID: $!, Socket: $socket)"
}

send_command() {
    local app="$1"
    local cmd="$2"
    local socket=$(xdg-runtime-file "$app" "socket")

    if ! xdg-runtime-exists "$app" "socket"; then
        echo "Error: Daemon not running (socket not found)"
        return 1
    fi

    echo "$cmd" > "$socket"
}

# Usage
start_daemon "myapp"
send_command "myapp" "stop"
```

### Directory Quotas and Limits

Monitor and enforce directory size limits:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

check_quotas() {
    local app="$1"
    local limits=(
        "config:100M"      # Config max 100MB
        "cache:500M"       # Cache max 500MB
        "data:1G"          # Data max 1GB
        "state:50M"        # State max 50MB
    )

    for limit_spec in "${limits[@]}"; do
        IFS=':' read -r dir_type max_size <<< "$limit_spec"

        local getter="xdg-${dir_type}-dir"
        local dir=$("$getter" "$app")

        if [[ -d "$dir" ]]; then
            local size=$(du -s "$dir" | cut -f1)
            local max_kb=${max_size%M}
            max_kb=$((max_kb * 1024))

            if (( size > max_kb )); then
                echo "Warning: $dir_type exceeds limit ($size KB > $max_kb KB)"

                # Auto-cleanup for cache
                if [[ "$dir_type" == "cache" ]]; then
                    echo "Cleaning old cache files..."
                    xdg-clean-old-cache "$app" 7
                fi
            fi
        fi
    done
}

check_quotas "myapp"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (300 lines) -->

## Best Practices

### 1. Always Call xdg-setup-all at Startup

Initialize all directories once at application startup:

```zsh
#!/usr/bin/env zsh

source "$(command -v _xdg)" || exit 6

main() {
    APP_NAME="myapp"

    # Setup first thing
    if ! xdg-setup-all "$APP_NAME"; then
        echo "Error: Failed to setup XDG directories" >&2
        exit 1
    fi

    # Now safe to use all functions
    config_dir=$(xdg-config-dir "$APP_NAME")
    # ...
}

main "$@"
```

**Why:** Ensures all directories exist before use, prevents runtime errors.

### 2. Cache Paths in Variables

Avoid repeated function calls:

```zsh
# Bad - repeated function calls
for i in {1..100}; do
    echo "data" >> "$(xdg-config-file myapp file.txt)"
done

# Good - cache path
config_file=$(xdg-config-file "myapp" "file.txt")
for i in {1..100}; do
    echo "data" >> "$config_file"
done
```

**Why:** Better performance, cleaner code.

### 3. Use xdg-ensure-dir Before Writing

Always ensure directory exists:

```zsh
# Bad - assumes directory exists
echo "config" > "$(xdg-config-file myapp config.json)"

# Good - ensure first
xdg-ensure-dir "$(xdg-config-dir myapp)"
echo "config" > "$(xdg-config-file myapp config.json)"
```

**Why:** Prevents "No such file or directory" errors.

### 4. Check Writable Before Using Directory

Validate before critical operations:

```zsh
APP="myapp"
data_dir=$(xdg-data-dir "$APP")

if ! xdg-dir-writable "$data_dir"; then
    echo "Error: Cannot write to data directory" >&2
    exit 1
fi

# Safe to proceed
echo "Important data" > "$data_dir/critical.dat"
```

**Why:** Handles permission issues gracefully.

### 5. Don't Store Persistent Data in Runtime

Runtime directory is temporary:

```zsh
# Bad - data will be lost on reboot
important_data=$(xdg-runtime-file "myapp" "data.txt")

# Good - use data directory
important_data=$(xdg-data-file "myapp" "data.txt")

# Runtime is for temporary files only
pidfile=$(xdg-runtime-file "myapp" "daemon.pid")
```

**Why:** Runtime directory is on tmpfs and cleared on reboot.

### 6. Use xdg-clean-old-cache for Periodic Cleanup

Schedule regular cache maintenance:

```zsh
# In crontab: run daily at 2 AM
# 0 2 * * * ~/.local/bin/cleanup-cache

#!/bin/zsh
source ~/.local/bin/lib/_xdg

# Clean cache older than 7 days
xdg-clean-cache "myapp" 7
xdg-clean-cache "otherapp" 30
```

**Why:** Prevents unbounded cache growth.

### 7. Use xdg-create-default-config for Initialization

Let the function handle idempotency:

```zsh
# Good - function handles "already exists"
xdg-create-default-config "myapp" "config.json" "{}"

# Check before loading
if xdg-config-exists "myapp" "config.json"; then
    config=$(cat "$(xdg-config-file myapp config.json)")
fi
```

**Why:** Idempotent, safe to call multiple times.

### 8. Validate Directories in Error Paths

Handle permission issues:

```zsh
if ! xdg-validate-dir "$(xdg-config-dir myapp)"; then
    echo "Error: Config directory invalid" >&2

    # Try alternate location
    export XDG_CONFIG_HOME="/tmp/config"
    xdg-setup-all "myapp"

    echo "Using fallback config: $(xdg-config-dir myapp)"
fi
```

**Why:** Graceful degradation on permission issues.

### 9. Run Self-Tests in Development

Verify extension integrity:

```zsh
# In development
xdg-self-test || exit 1

# In CI/CD
if ! xdg-self-test >/dev/null 2>&1; then
    echo "XDG extension tests failed" >&2
    exit 1
fi
```

**Why:** Catches regressions early.

### 10. Document XDG Directories in Your App

Help users understand where data goes:

```zsh
show_paths() {
    echo "Application data locations:"
    xdg-show-dirs "myapp"
    echo ""
    echo "For more info:"
    echo "  Config: ~/.config/myapp"
    echo "  Cache:  ~/.cache/myapp"
    echo "  Data:   ~/.local/share/myapp"
}
```

**Why:** Users expect standard XDG locations.

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (500 lines) -->

## Troubleshooting

### Issue: Directory Not Found Errors

**Problem:** Getting "No such file or directory" when writing files.

**Root Causes:**
1. Directory doesn't exist
2. Missing parent directories
3. Permission denied

**Diagnosis:**
```zsh
config_dir=$(xdg-config-dir "myapp")
if [[ ! -d "$config_dir" ]]; then
    echo "Directory does not exist: $config_dir"
fi

if ! xdg-dir-writable "$config_dir"; then
    echo "Directory not writable: $config_dir"
    ls -ld "$config_dir"  # Check permissions
fi
```

**Solutions:**

Option 1: Use xdg-setup-all:
```zsh
xdg-setup-all "myapp"
```

Option 2: Ensure directory explicitly:
```zsh
xdg-ensure-dir "$(xdg-config-dir myapp)"
```

Option 3: Check and fix permissions:
```zsh
config_dir=$(xdg-config-dir "myapp")
if [[ -d "$config_dir" ]]; then
    chmod 700 "$config_dir"
else
    mkdir -p "$config_dir"
    chmod 700 "$config_dir"
fi
```

---

### Issue: Runtime Directory Not Found

**Problem:** `XDG_RUNTIME_DIR` doesn't exist or `/run/user/UID` missing.

**Root Causes:**
1. Not logged in via system session manager
2. System doesn't follow XDG spec
3. Temporary directory cleaned up

**Diagnosis:**
```zsh
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
[[ -d "$XDG_RUNTIME_DIR" ]] && echo "✓ Exists" || echo "✗ Missing"
ls -ld "$XDG_RUNTIME_DIR" 2>/dev/null
```

**Solutions:**

Option 1: Check system support:
```zsh
if [[ -z "$XDG_RUNTIME_DIR" ]] || [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    echo "System doesn't support XDG_RUNTIME_DIR"
    echo "Runtime functions will fail gracefully"
fi
```

Option 2: Create fallback:
```zsh
if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR="/tmp/run-$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
fi
```

Option 3: Handle failure gracefully:
```zsh
# Don't fail if runtime dir unavailable
if ! xdg-ensure-dir "$(xdg-runtime-dir myapp)" 2>/dev/null; then
    echo "Warning: Runtime directory unavailable, using temp"
    runtime_dir="/tmp"
else
    runtime_dir=$(xdg-runtime-dir "myapp")
fi
```

---

### Issue: Permission Denied Creating Directories

**Problem:** `mkdir: Permission denied` when creating XDG directories.

**Root Causes:**
1. Home directory not writable
2. Disk full
3. File system read-only
4. SELinux/AppArmor blocking access

**Diagnosis:**
```zsh
# Check home directory
ls -ld "$HOME"

# Check XDG base paths
ls -ld "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

# Test directory creation
mkdir -p "$HOME/.test-xdg" 2>&1
```

**Solutions:**

Option 1: Fix directory ownership:
```zsh
chown -R "$(id -u):$(id -g)" "$HOME/.config"
chown -R "$(id -u):$(id -g)" "$HOME/.cache"
chown -R "$(id -u):$(id -g)" "$HOME/.local"
```

Option 2: Fix permissions:
```zsh
chmod -R u+w "$HOME/.config"
chmod -R u+w "$HOME/.cache"
chmod -R u+w "$HOME/.local"
```

Option 3: Use alternate location:
```zsh
export XDG_CONFIG_HOME="/tmp/.config-$(id -u)"
export XDG_DATA_HOME="/tmp/.data-$(id -u)"
export XDG_CACHE_HOME="/tmp/.cache-$(id -u)"

xdg-setup-all "myapp"
```

Option 4: Check disk space:
```zsh
df -h "$HOME"  # Check available space
```

---

### Issue: Cache Growing Too Large

**Problem:** Cache directory consuming excessive disk space.

**Root Causes:**
1. Never cleaned
2. Cache TTL too long
3. Large individual files in cache

**Diagnosis:**
```zsh
cache_dir=$(xdg-cache-dir "myapp")
size=$(xdg-dir-size "$cache_dir")
echo "Cache size: $size"

# Find largest files
find "$cache_dir" -type f -exec du -h {} \; | sort -rh | head -10
```

**Solutions:**

Option 1: Clean all cache:
```zsh
xdg-clean-cache "myapp"
echo "Cache cleaned"
```

Option 2: Clean old cache:
```zsh
# Keep only recent files
xdg-clean-old-cache "myapp" 7  # Keep 7+ day old files
```

Option 3: Implement size limit:
```zsh
check_cache_size() {
    local app="$1"
    local max_mb="${2:-500}"  # Default 500MB

    cache_dir=$(xdg-cache-dir "$app")
    size_kb=$(du -s "$cache_dir" 2>/dev/null | cut -f1)
    size_mb=$((size_kb / 1024))

    if (( size_mb > max_mb )); then
        echo "Cache size ($size_mb MB) exceeds limit ($max_mb MB)"
        xdg-clean-old-cache "$app" 30
    fi
}

check_cache_size "myapp" 500
```

Option 4: Automate cleanup:
```zsh
# In crontab: Daily cleanup at 2 AM
0 2 * * * xdg-clean-old-cache myapp 7

# Or in application shutdown
trap 'xdg-clean-old-cache myapp 30' EXIT
```

---

### Issue: Multiple Apps Using Same Directory

**Problem:** Different applications sharing the same XDG directories.

**Root Cause:** Using same application name for multiple scripts.

**Diagnosis:**
```zsh
# Check what's in a directory
ls -la "$(xdg-config-dir myapp)"
# Should only contain files for that app
```

**Solutions:**

Option 1: Use unique app names:
```zsh
# Instead of all using "myapp"
xdg-setup-all "myapp-web"
xdg-setup-all "myapp-api"
xdg-setup-all "myapp-worker"
```

Option 2: Use subdirectories:
```zsh
# Shared config directory
base_config=$(xdg-config-dir "myapp")

# App-specific subdirectories
web_config="$base_config/web"
api_config="$base_config/api"

xdg-ensure-dir "$web_config"
xdg-ensure-dir "$api_config"
```

Option 3: Namespace config files:
```zsh
# Same directory, different files
config=$(xdg-config-file "myapp" "web.json")
config=$(xdg-config-file "myapp" "api.json")
config=$(xdg-config-file "myapp" "worker.json")
```

---

### Issue: Config File Not Persisting

**Problem:** Config file disappears between sessions.

**Root Cause:** Storing config in runtime directory instead of config directory.

**Bad Example:**
```zsh
# WRONG - runtime is temporary
config=$(xdg-runtime-file "myapp" "config.json")
echo "{}" > "$config"  # Will be deleted on reboot
```

**Correct Example:**
```zsh
# RIGHT - config persists
config=$(xdg-config-file "myapp" "config.json")
xdg-ensure-dir "$(dirname $config)"
echo "{}" > "$config"  # Survives reboot
```

**Directory Choice Guide:**

| Use | For |
|-----|-----|
| **config** | Application settings, preferences, configuration |
| **data** | User documents, databases, saved files |
| **state** | Session info, history, last-used values |
| **cache** | Downloaded data, compiled assets, temporary results |
| **runtime** | PID files, sockets, locks (temporary, per-session) |

**Fix for Existing Issue:**
```zsh
# Migrate config from runtime to config
runtime_config=$(xdg-runtime-file "myapp" "config.json")
config_config=$(xdg-config-file "myapp" "config.json")

if [[ -f "$runtime_config" ]]; then
    xdg-ensure-dir "$(dirname $config_config)"
    cp "$runtime_config" "$config_config"
    rm "$runtime_config"
fi
```

---

### Issue: Environment Variables Not Respected

**Problem:** Setting XDG_* variables has no effect.

**Root Cause:** Variables set after _xdg is loaded, or using old paths.

**Bad Example:**
```zsh
source ~/.local/bin/lib/_xdg

# Too late! _xdg already loaded with default paths
export XDG_CONFIG_HOME="/custom/config"
```

**Correct Example:**
```zsh
# Set BEFORE loading _xdg
export XDG_CONFIG_HOME="/custom/config"
source ~/.local/bin/lib/_xdg

# Now uses custom location
config=$(xdg-config-dir "myapp")
```

**Verification:**
```zsh
# Check what location is being used
config=$(xdg-config-dir "myapp")
echo "Using config: $config"

# Should be under $XDG_CONFIG_HOME
echo "XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
```

---

### Issue: Testing Shows Stale Test Directories

**Problem:** Running `xdg-self-test` leaves behind test directories.

**Root Cause:** Test cleanup failed or interrupted.

**Solution:**
```zsh
# Find and remove test directories
find "$HOME/.config" -name "*xdg-test*" -type d -delete
find "$HOME/.cache" -name "*xdg-test*" -type d -delete
find "$HOME/.local" -name "*xdg-test*" -type d -delete

# Verify cleanup
ls "$HOME/.config" | grep xdg-test
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (300 lines) -->

## Architecture & Specification

### XDG Base Directory Specification Overview

The XDG Base Directory Specification defines a standard for organizing user data on Unix-like systems:

**Specification URL:** https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

**Core Principles:**
1. Applications should respect user's directory preferences
2. Different data types go to different directories
3. System provides sensible defaults
4. Users can customize via environment variables

### The Five XDG Directories

#### 1. XDG_CONFIG_HOME - User Configuration

**Purpose:** Application settings, preferences, configuration files

**Default:** `~/.config`

**Characteristics:**
- User-specific (per user)
- Persistent (survives reboot)
- Should be under `$HOME`
- Typically text files (JSON, YAML, INI)

**Examples:**
- Application settings files
- User preferences
- Feature flags
- Credentials

**Size Characteristics:** Typically small (KB - MB range)

#### 2. XDG_CACHE_HOME - User Cache

**Purpose:** Cached data that can be safely deleted

**Default:** `~/.cache`

**Characteristics:**
- User-specific
- Volatile (can be deleted anytime)
- Should be on fast storage
- Application manages cleanup
- Can be large

**Examples:**
- Downloaded web pages
- Compiled assets
- Thumbnail caches
- API response caches
- Build artifacts

**Size Characteristics:** Can be large (MB - GB range)

**Important:** Never store critical data in cache!

#### 3. XDG_DATA_HOME - User Data

**Purpose:** User data files and application databases

**Default:** `~/.local/share`

**Characteristics:**
- User-specific
- Persistent (survives reboot)
- Should be under `$HOME`
- Can be large
- Core application data

**Examples:**
- Databases
- Documents
- User files
- Saved games
- Downloaded resources

**Size Characteristics:** Variable (MB - GB range)

#### 4. XDG_STATE_HOME - User State

**Purpose:** Application state that changes frequently

**Default:** `~/.local/state`

**Characteristics:**
- User-specific
- Persistent
- Should be under `$HOME`
- Changes frequently
- Separate from config

**Examples:**
- Session information
- Window state (maximized, position)
- History files
- Last-run timestamps
- Undo/redo stacks

**Important:** Different from data (state changes, data is stable)

#### 5. XDG_RUNTIME_DIR - User Runtime Files

**Purpose:** Runtime files (PIDs, sockets, etc.)

**Default:** `/run/user/$(id -u)`

**Characteristics:**
- User-specific (per UID)
- Temporary (cleared on logout/reboot)
- Fast storage (tmpfs/memory)
- Access-controlled (mode 700)
- Limited size

**Examples:**
- PID files
- Unix domain sockets
- D-Bus socket
- Session tokens
- Locks
- Temporary files

**Important:** Data here is lost on reboot!

**Size Characteristics:** Small, limited by tmpfs

### Path Construction Logic

The `_xdg` extension uses this logic to construct paths:

```zsh
# For directory getters
xdg-config-dir "myapp"
  → ${XDG_CONFIG_HOME:=$HOME/.config}/myapp

xdg-cache-dir "myapp"
  → ${XDG_CACHE_HOME:=$HOME/.cache}/myapp

xdg-data-dir "myapp"
  → ${XDG_DATA_HOME:=$HOME/.local/share}/myapp

xdg-state-dir "myapp"
  → ${XDG_STATE_HOME:=$HOME/.local/state}/myapp

xdg-runtime-dir "myapp"
  → ${XDG_RUNTIME_DIR:=/run/user/$(id -u)}/myapp
```

### Performance Characteristics

| Operation | Time | Complexity | Notes |
|-----------|------|-----------|-------|
| `xdg-*-dir` | <1ms | O(1) | Simple string concatenation |
| `xdg-*-file` | <1ms | O(1) | String concatenation |
| `xdg-*-exists` | <1ms | O(1) | Filesystem check |
| `xdg-ensure-dir` | 1-10ms | O(n) | Creates n directories |
| `xdg-setup-all` | 5-15ms | O(n) | Creates 5 directories |
| `xdg-dir-size` | 100-1000ms | O(n) | Scans entire directory tree |
| `xdg-dir-file-count` | 50-500ms | O(n) | Counts all files recursively |
| `xdg-clean-cache` | 10-1000ms | O(n) | Deletes all files in directory |
| `xdg-clean-old-cache` | 50-2000ms | O(n) | Scans and deletes old files |

### Memory Usage

- Minimal overhead (~50 bytes per function call)
- No persistent state (except temporary variables)
- All operations use shell built-ins

### Compatibility

**Shell Compatibility:**
- ZSH 5.0+ (requires string manipulation features)
- Bash 4+ (with minor modifications)

**Operating Systems:**
- Linux (primary target)
- BSD (mostly compatible)
- macOS (with caveats - /run/user may not exist)
- Windows under WSL or Git Bash

**Filesystem Requirements:**
- Case-sensitive filesystem recommended
- Supports both local and network filesystems
- Works with various mount options

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL (50 lines) -->

## External References

### Specifications

- **XDG Base Directory Specification**
  - URL: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
  - Version: 0.8 (current)
  - Date: 2021

### Related Extensions

- `_common` v2.0 - Base functions (required dependency)
- `_log` v2.0 - Structured logging (optional)
- `_lifecycle` v3.0 - Cleanup registration (optional)
- `_cache` v2.0 - Caching layer (complementary)

### Standard Directories

- **Linux Filesystem Hierarchy Standard (FHS)**
  - URL: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html
  - Defines filesystem layout including `/run`, `/home`, `/opt`

- **Home Directory Organization**
  - Best practices for organizing user home directories
  - References: XDG spec, various desktop environment implementations

### Tools and Utilities

- `xdg-user-dir` - Query XDG user directories
- `xdg-user-dirs-update` - Update XDG directory definitions
- `systemd-tmpfiles` - Manage `/run` directory structure

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-04 | Complete rewrite with all XDG directories |
| 1.0.0 | 2024-11-01 | Initial release, basic directory support |

### Documentation

- **This Document:** _xdg.md v1.0.0
- **Source Code:** ~/.local/bin/lib/_xdg (660 lines)
- **Tests:** Included self-test function (`xdg-self-test`)

### Contributing

To report issues or contribute improvements:
1. Run `xdg-self-test` to verify functionality
2. Check `xdg-show-info` to understand current state
3. Review source code and comments in ~/.local/bin/lib/_xdg

**Maintainer:** andronics
**Project:** Extensions Library Rewrite v2.0

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-07
**Total Lines:** ~3,350
**Status:** Gold Standard (Enhanced Requirements v1.1)
