# _plugins - Plugin Discovery, Loading, and Initialization System

**Lines:** 2,897 | **Functions:** 19 | **Examples:** 78 | **Source Lines:** 768
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_plugins`
**Enhanced Documentation Requirements:** v1.1 | **Compliance:** 95%

---

## Quick Access Index

### Compact References (Lines 10-250)
- [Function Reference](#function-quick-reference) - 19 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 2 variables
- [Plugin States](#plugin-states-reference) - 5 states
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 250-350, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 350-450, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 450-750, ~300 lines) 🔥 HIGH PRIORITY
- [Plugin Structure](#plugin-structure) (Lines 750-900, ~150 lines) 🔥 HIGH PRIORITY
- [API Reference](#api-reference) (Lines 900-2250, ~1350 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2250-2600, ~350 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2600-2850, ~250 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: plugins_api -->

**Plugin Discovery:**

| Function | Description | Source Lines | Complexity | Dependencies | Link |
|----------|-------------|--------------|------------|--------------|------|
| `plugin-discover` | Discover plugins in search paths | 66-118 | O(n) | `schema-load-file` | [→](#plugin-discover) |
| `_plugin-load-metadata` | Load plugin metadata (internal) | 123-153 | O(1) | `schema-load-file` | Internal |

**Plugin Metadata:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `plugin-get-metadata` | Get full plugin metadata JSON | 161-171 | O(1) | [→](#plugin-get-metadata) |
| `plugin-get` | Get specific metadata field | 175-195 | O(1) | [→](#plugin-get) |
| `plugin-list` | List all plugins | 199-207 | O(n) | [→](#plugin-list) |
| `plugin-get-state` | Get plugin state | 211-214 | O(1) | [→](#plugin-get-state) |

**Plugin Enable/Disable:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `plugin-is-enabled` | Check if plugin is enabled | 223-236 | O(1) | [→](#plugin-is-enabled) |
| `plugin-enable` | Enable plugin | 240-256 | O(1) | [→](#plugin-enable) |
| `plugin-disable` | Disable plugin | 260-276 | O(1) | [→](#plugin-disable) |

**Plugin Loading:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `plugin-load` | Load plugin code | 285-361 | O(1) | [→](#plugin-load) |
| `plugin-init` | Initialize plugin | 370-419 | O(1) | [→](#plugin-init) |
| `plugin-init-all` | Initialize all plugins | 534-615 | O(n²) | [→](#plugin-init-all) |

**Dependency Resolution:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `_plugin-get-dep-list` | Get dependency-ordered list | 429-469 | O(n²) | Internal |
| `_plugin-resolve-deps` | Resolve dependencies (DEPRECATED) | 474-529 | O(n²) | Internal |

**Plugin Utilities:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `plugin-get-path` | Get plugin directory path | 623-626 | O(1) | [→](#plugin-get-path) |
| `plugin-exists` | Check if plugin exists | 631-634 | O(1) | [→](#plugin-exists) |
| `plugin-validate` | Validate plugin structure | 639-689 | O(n) | [→](#plugin-validate) |
| `plugin-info` | Display plugin information | 693-719 | O(1) | [→](#plugin-info) |

**Bootstrap:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `plugin-bootstrap` | Discover and initialize all | 728-756 | O(n²) | [→](#plugin-bootstrap) |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description | Source Lines |
|----------|------|---------|-------------|--------------|
| `PLUGINS_SEARCH_PATHS` | array | See below | Plugin search directories | 50-54 |
| `PLUGINS_CONFIG_DIR` | path | `$XDG_CONFIG_HOME/plugins` | Enable/disable config directory | 57 |
| `_PLUGINS_LOADED` | boolean (readonly) | `1` | Extension loaded flag | 8 |

**Default Search Paths:**
1. `$HOME/.local/libexec/plugins`
2. `$XDG_DATA_HOME/plugins` (or `$HOME/.local/share/plugins`)
3. `/usr/local/libexec/plugins`

---

## Plugin States Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| State | Description | Set By | Retrieved Via |
|-------|-------------|--------|---------------|
| `discovered` | Plugin found, metadata loaded | `plugin-discover` | `plugin-get-state` |
| `loaded` | Plugin code sourced | `plugin-load` | `plugin-get-state` |
| `initialized` | Plugin init function executed | `plugin-init` | `plugin-get-state` |
| `failed` | Plugin load/init failed | `plugin-load`, `plugin-init` | `plugin-get-state` |
| `disabled` | Plugin explicitly disabled | `plugin-disable`, `plugin-load` | `plugin-get-state` |
| `unknown` | Plugin not in registry | N/A | `plugin-get-state` |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (load, init, validation) | Most functions |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Overview

The `_plugins` extension provides a comprehensive plugin system for discovering, loading, and initializing modular components. It supports plugin metadata, dependency resolution, enable/disable functionality, and automatic initialization ordering.

**Key Features:**
- **Auto-Discovery:** Scans multiple search paths for plugins
- **Metadata Management:** YAML/JSON plugin metadata with validation
- **Dependency Resolution:** Automatic topological sorting
- **Enable/Disable:** Runtime plugin control via config files
- **Lazy Loading:** Plugins loaded only when needed
- **State Tracking:** Monitor plugin lifecycle states
- **Validation:** Comprehensive plugin structure validation
- **Integration:** Works with `_schema` and `_actions` for plugin actions

**Dependencies:**
- **Required:** `_common`, `_schema`, `_actions`
- **Optional:** `_log` (for logging), `_events` (for event emission)

**Architecture Position:**
- **Layer:** Infrastructure (Layer 2)
- **Used By:** Application frameworks, extensible utilities
- **Uses:** `_common`, `_schema`, `_actions`, `_log`, `_events`

**Use Cases:**
- Building extensible applications
- Creating plugin-based architectures
- Managing modular components
- Implementing action handlers via plugins
- Dynamic feature loading

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

### Prerequisites

The `_plugins` extension requires:

1. **Core Dependencies:**
   ```bash
   # Available in ~/.local/bin/lib/ via stow
   source "$(which _common)"
   source "$(which _schema)"
   source "$(which _actions)"
   ```

2. **Optional Dependencies:**
   ```bash
   # For enhanced logging
   source "$(which _log)"

   # For event emission
   source "$(which _events)"
   ```

### Installation via Stow

```bash
# Install library (if not already done)
cd ~/.pkgs
stow lib

# Verify installation
source "$(which _plugins)"
echo "Plugins loaded: $_PLUGINS_LOADED"
```

### Verification

```bash
# Source extension
source "$(which _plugins)"

# Check search paths
printf '%s\n' "${PLUGINS_SEARCH_PATHS[@]}"

# Test discovery
plugin-discover
echo "Discovered $(plugin-list | wc -l) plugins"
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
## Quick Start

### Example 1: Basic Plugin Discovery and Initialization

**Plugin Directory Structure:**
```
~/.local/libexec/plugins/
  ├── docker/
  │   ├── plugin.yaml
  │   └── plugin.zsh
  └── kubernetes/
      ├── plugin.yaml
      └── plugin.zsh
```

**Plugin Metadata:** `docker/plugin.yaml`
```yaml
name: "docker"
version: "1.0.0"
description: "Docker integration plugin"
author: "Your Name"

dependencies: []

provides:
  actions:
    - "docker.volume.backup"
    - "docker.volume.remove"
    - "docker.container.stop"
```

**Plugin Code:** `docker/plugin.zsh`
```zsh
#!/usr/bin/env zsh

# Docker volume backup handler
docker-volume-backup() {
    local volume="$1"
    local params="$2"
    # Implementation...
}

# Plugin init function
docker_init() {
    action-register "docker.volume" "backup" "docker-volume-backup"
    action-register "docker.volume" "remove" "docker-volume-remove"
    action-register "docker.container" "stop" "docker-container-stop"

    echo "Docker plugin initialized"
}
```

**Use Plugin System:**
```zsh
#!/usr/bin/env zsh
source "$(which _plugins)"
source "$(which _actions)"

# Bootstrap plugin system
plugin-bootstrap

# Plugins are now discovered, loaded, and initialized
# Use plugin-provided actions
action-execute-schema "docker-teardown.yaml"
```

### Example 2: Manual Plugin Discovery and Loading

```zsh
source "$(which _plugins)"

# Discover plugins
echo "Discovering plugins..."
plugin-discover

# List discovered plugins
echo "Available plugins:"
plugin-list

# Load specific plugin
if plugin-load "docker"; then
    echo "Docker plugin loaded"

    # Initialize plugin
    if plugin-init "docker"; then
        echo "Docker plugin initialized"
    fi
fi

# Check plugin state
state=$(plugin-get-state "docker")
echo "Docker plugin state: $state"
```

### Example 3: Plugin with Dependencies

**Plugin A Metadata:** `base/plugin.yaml`
```yaml
name: "base"
version: "1.0.0"
description: "Base utilities plugin"
dependencies: []
```

**Plugin B Metadata:** `advanced/plugin.yaml`
```yaml
name: "advanced"
version: "1.0.0"
description: "Advanced features plugin"
dependencies:
  - "base"  # Requires base plugin
```

**Automatic Dependency Resolution:**
```zsh
source "$(which _plugins)"

# Discover and initialize all
plugin-bootstrap

# Dependencies resolved automatically:
# 1. base plugin loaded and initialized
# 2. advanced plugin loaded and initialized
```

### Example 4: Enable/Disable Plugins

```zsh
source "$(which _plugins)"

# Discover all plugins
plugin-discover

# Disable specific plugin
plugin-disable "kubernetes"
echo "Kubernetes plugin disabled"

# Initialize all (kubernetes will be skipped)
plugin-init-all

# Later, re-enable
plugin-enable "kubernetes"

# Manually load and init now-enabled plugin
plugin-load "kubernetes"
plugin-init "kubernetes"
```

### Example 5: Query Plugin Information

```zsh
source "$(which _plugins)"

# Discover plugins
plugin-discover

# Get plugin metadata
metadata=$(plugin-get-metadata "docker")
echo "$metadata" | jq '.'

# Get specific fields
version=$(plugin-get "docker" "version")
description=$(plugin-get "docker" "description")

echo "Docker Plugin v$version"
echo "Description: $description"

# Display full info
plugin-info "docker"
```

### Example 6: Validate Plugins

```zsh
source "$(which _plugins)"

# Discover plugins
plugin-discover

# Validate all plugins
echo "Validating plugins..."
for plugin in $(plugin-list); do
    if plugin-validate "$plugin"; then
        echo "✓ $plugin"
    else
        echo "✗ $plugin (validation failed)"
    fi
done
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Plugin Structure

### Directory Layout

Each plugin must follow this structure:

```
plugin-name/
  ├── plugin.yaml       # Required: Plugin metadata
  └── plugin.zsh        # Required: Plugin code
```

**Search Path Example:**
```
~/.local/libexec/plugins/
  ├── docker/
  │   ├── plugin.yaml
  │   └── plugin.zsh
  ├── kubernetes/
  │   ├── plugin.yaml
  │   └── plugin.zsh
  └── utils/
      ├── plugin.yaml
      └── plugin.zsh
```

### Plugin Metadata Format

**File:** `plugin.yaml`

```yaml
name: "plugin-name"              # Required: Plugin name
version: "1.0.0"                 # Required: Semantic version
description: "Plugin description" # Required: Short description

author: "Your Name"              # Optional: Author name
license: "MIT"                   # Optional: License
homepage: "https://..."          # Optional: Homepage URL

dependencies:                    # Optional: Plugin dependencies
  - "other-plugin"
  - "another-plugin"

provides:                        # Optional: What plugin provides
  actions:                       # Action handlers
    - "type.resource.action"
  commands:                      # Shell commands
    - "my-command"
  features:                      # Features list
    - "feature-name"

config:                          # Optional: Plugin configuration
  key: "value"
```

### Plugin Code Structure

**File:** `plugin.zsh`

```zsh
#!/usr/bin/env zsh

# Plugin implementation

# Define action handlers
plugin-name-handler() {
    local resource="$1"
    local params="$2"
    # Implementation...
}

# Define helper functions
plugin-name-util() {
    # Utility function...
}

# Required: Plugin initialization function
# Name must be: <plugin-name>_init (replace - with _)
plugin_name_init() {
    # Register action handlers
    action-register "type.resource" "action" "plugin-name-handler"

    # Initialize state
    # Setup resources
    # Etc.

    return 0
}
```

**Naming Convention:**
- Plugin directory: `plugin-name` (kebab-case)
- Init function: `plugin_name_init` (snake_case with `_init` suffix)
- Replace hyphens with underscores: `my-plugin` → `my_plugin_init`

### Example Complete Plugin

**Metadata:** `hello/plugin.yaml`
```yaml
name: "hello"
version: "1.0.0"
description: "Simple hello world plugin"
author: "Example Author"

dependencies: []

provides:
  actions:
    - "hello.world.greet"
```

**Code:** `hello/plugin.zsh`
```zsh
#!/usr/bin/env zsh

# Hello world handler
hello-world-greet() {
    local name="$1"
    local params="$2"

    local message=$(echo "$params" | jq -r '.message // "Hello"')

    echo "$message, $name!"
    return 0
}

# Plugin init
hello_init() {
    action-register "hello.world" "greet" "hello-world-greet"

    echo "Hello plugin initialized"
    return 0
}
```

**Usage:**
```zsh
source "$(which _plugins)"
plugin-bootstrap

# Use hello plugin
action-execute-schema "greet.yaml"
```

**Schema:** `greet.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "greet-user"
    type: "hello.world"
    resource: "World"
    action: "greet"
    params:
      message: "Hello"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: api_discovery -->
## API Reference

### Plugin Discovery Functions

#### `plugin-discover`

**Source:** Lines 66-118
**Complexity:** O(n) - Number of plugin directories searched
**Dependencies:** `_plugin-load-metadata`, `schema-load-file`

Discover all plugins in search paths or specified path.

**Signature:**
```zsh
plugin-discover [search_path]
```

**Parameters:**
- `search_path` - Specific directory to search (optional, uses `PLUGINS_SEARCH_PATHS` by default)

**Returns:**
- `0` - Discovery completed (even if no plugins found)

**Side Effects:**
- Populates `_PLUGINS_REGISTRY` with plugin metadata
- Sets `_PLUGINS_STATE` to `discovered` for found plugins
- Sets `_PLUGINS_PATHS` with plugin directories
- Extracts dependencies to `_PLUGINS_DEPS`

**Search Pattern:** Looks for `plugin.yaml` or `plugin.yml` files

**Example:**
```zsh
# Discover in default paths
plugin-discover

# Discover in specific directory
plugin-discover "$HOME/custom-plugins"
```

**Example: Custom Search Paths:**
```zsh
# Add custom search path
export PLUGINS_SEARCH_PATHS=(
    "$HOME/.local/libexec/plugins"
    "$HOME/project/plugins"
    "/opt/plugins"
)

plugin-discover

echo "Discovered plugins:"
plugin-list
```

**Example: Discovery Report:**
```zsh
plugin-discover

discovered_count=$(plugin-list | wc -l)
echo "Discovered $discovered_count plugins"

for plugin in $(plugin-list); do
    version=$(plugin-get "$plugin" "version")
    description=$(plugin-get "$plugin" "description")
    echo "  $plugin v$version: $description"
done
```

**Performance Note:** Discovery is O(n) in number of directories and uses recursive glob matching (`**/plugin.{yaml,yml}`).

---

<!-- CONTEXT_GROUP: api_metadata -->
### Plugin Metadata Functions

#### `plugin-get-metadata`

**Source:** Lines 161-171
**Complexity:** O(1)
**Dependencies:** None

Get full metadata JSON for a plugin.

**Signature:**
```zsh
plugin-get-metadata <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Metadata returned
- `1` - Plugin not found

**Output:** Plugin metadata as JSON

**Example:**
```zsh
metadata=$(plugin-get-metadata "docker")
echo "$metadata" | jq '.'

# Output:
# {
#   "name": "docker",
#   "version": "1.0.0",
#   "description": "Docker integration",
#   "dependencies": ["base"]
# }
```

**Example: Extract All Fields:**
```zsh
metadata=$(plugin-get-metadata "docker")

name=$(echo "$metadata" | jq -r '.name')
version=$(echo "$metadata" | jq -r '.version')
description=$(echo "$metadata" | jq -r '.description')
author=$(echo "$metadata" | jq -r '.author // "Unknown"')

echo "Plugin: $name v$version"
echo "Description: $description"
echo "Author: $author"
```

---

#### `plugin-get`

**Source:** Lines 175-195
**Complexity:** O(1)
**Dependencies:** `plugin-get-metadata`

Get specific field from plugin metadata.

**Signature:**
```zsh
plugin-get <name> <field> [default]
```

**Parameters:**
- `name` - Plugin name (required)
- `field` - Metadata field name (required)
- `default` - Default value if field not found (optional)

**Returns:**
- `0` - Field found and returned
- `1` - Plugin not found or field not found

**Output:** Field value or default

**Example:**
```zsh
version=$(plugin-get "docker" "version" "unknown")
description=$(plugin-get "docker" "description" "No description")

echo "Docker plugin v$version"
echo "Description: $description"
```

**Example: Check Optional Fields:**
```zsh
# Get optional homepage
homepage=$(plugin-get "docker" "homepage" "")
if [[ -n "$homepage" ]]; then
    echo "Homepage: $homepage"
fi

# Get license
license=$(plugin-get "docker" "license" "Unknown")
echo "License: $license"
```

---

#### `plugin-list`

**Source:** Lines 199-207
**Complexity:** O(n) - Number of plugins
**Dependencies:** None

List all discovered plugins, optionally filtered by state.

**Signature:**
```zsh
plugin-list [state_filter]
```

**Parameters:**
- `state_filter` - Filter by state (optional): `discovered`, `loaded`, `initialized`, `failed`, `disabled`

**Returns:**
- `0` - Always succeeds

**Output:** Plugin names, one per line

**Example:**
```zsh
# List all plugins
echo "All plugins:"
plugin-list

# List only initialized plugins
echo "Initialized plugins:"
plugin-list "initialized"

# List failed plugins
echo "Failed plugins:"
plugin-list "failed"
```

**Example: Count by State:**
```zsh
echo "Plugin Status:"
echo "  Discovered: $(plugin-list 'discovered' | wc -l)"
echo "  Loaded: $(plugin-list 'loaded' | wc -l)"
echo "  Initialized: $(plugin-list 'initialized' | wc -l)"
echo "  Failed: $(plugin-list 'failed' | wc -l)"
echo "  Disabled: $(plugin-list 'disabled' | wc -l)"
```

---

#### `plugin-get-state`

**Source:** Lines 211-214
**Complexity:** O(1)
**Dependencies:** None

Get current state of a plugin.

**Signature:**
```zsh
plugin-get-state <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Always succeeds

**Output:** Plugin state: `discovered`, `loaded`, `initialized`, `failed`, `disabled`, or `unknown`

**Example:**
```zsh
state=$(plugin-get-state "docker")
case "$state" in
    initialized)
        echo "Docker plugin ready"
        ;;
    failed)
        echo "Docker plugin failed to initialize"
        ;;
    disabled)
        echo "Docker plugin is disabled"
        ;;
    *)
        echo "Docker plugin state: $state"
        ;;
esac
```

---

<!-- CONTEXT_GROUP: api_enable -->
### Plugin Enable/Disable Functions

#### `plugin-is-enabled`

**Source:** Lines 223-236
**Complexity:** O(1)
**Dependencies:** None

Check if a plugin is enabled.

**Signature:**
```zsh
plugin-is-enabled <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin enabled (no `.disabled` marker file)
- `1` - Plugin disabled (`.disabled` marker exists)

**Default:** Plugins are enabled unless explicitly disabled

**Disable Marker:** `$PLUGINS_CONFIG_DIR/<name>.disabled`

**Example:**
```zsh
if plugin-is-enabled "docker"; then
    echo "Docker plugin is enabled"
    plugin-load "docker"
else
    echo "Docker plugin is disabled"
fi
```

**Example: Conditional Loading:**
```zsh
for plugin in $(plugin-list); do
    if plugin-is-enabled "$plugin"; then
        echo "Loading: $plugin"
        plugin-load "$plugin"
    else
        echo "Skipping disabled plugin: $plugin"
    fi
done
```

---

#### `plugin-enable`

**Source:** Lines 240-256
**Complexity:** O(1)
**Dependencies:** None

Enable a plugin by removing disable marker.

**Signature:**
```zsh
plugin-enable <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin enabled
- `1` - Plugin not found in registry

**Side Effects:**
- Removes `$PLUGINS_CONFIG_DIR/<name>.disabled` file

**Example:**
```zsh
# Enable plugin
plugin-enable "kubernetes"

# Verify
if plugin-is-enabled "kubernetes"; then
    echo "Kubernetes plugin enabled"
fi

# Load and init
plugin-load "kubernetes"
plugin-init "kubernetes"
```

**Note:** Enabling does not automatically load/init. Call `plugin-load` and `plugin-init` after enabling.

---

#### `plugin-disable`

**Source:** Lines 260-276
**Complexity:** O(1)
**Dependencies:** None

Disable a plugin by creating disable marker.

**Signature:**
```zsh
plugin-disable <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin disabled
- `1` - Plugin not found in registry

**Side Effects:**
- Creates `$PLUGINS_CONFIG_DIR/<name>.disabled` file

**Example:**
```zsh
# Disable plugin
plugin-disable "experimental"

# Verify
if ! plugin-is-enabled "experimental"; then
    echo "Experimental plugin disabled"
fi
```

**Note:** Disabling does not unload already-loaded plugins. It only prevents loading in future `plugin-init-all` calls.

---

<!-- CONTEXT_GROUP: api_loading -->
### Plugin Loading Functions

#### `plugin-load`

**Source:** Lines 285-361
**Complexity:** O(1)
**Dependencies:** `plugin-is-enabled`

Load plugin code (source `plugin.zsh` file).

**Signature:**
```zsh
plugin-load <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin loaded successfully
- `1` - Plugin load failed (not discovered, disabled, or source error)

**Side Effects:**
- Sources `<plugin_dir>/plugin.zsh`
- Sets `_PLUGINS_STATE[name]` to `loaded` or `failed`
- Emits `plugin.loaded` event (if `_events` loaded)

**Checks:**
1. Already loaded → return success
2. Not discovered → fail
3. Disabled → skip (set state to `disabled`)
4. Plugin directory exists
5. `plugin.zsh` file exists
6. Source file

**Example:**
```zsh
if plugin-load "docker"; then
    echo "Docker plugin loaded"
else
    echo "Failed to load docker plugin"
    exit 1
fi
```

**Example: Batch Loading:**
```zsh
required_plugins=("docker" "kubernetes" "aws")

for plugin in "${required_plugins[@]}"; do
    if ! plugin-load "$plugin"; then
        echo "Failed to load required plugin: $plugin"
        exit 1
    fi
done
```

**Example: Error Handling:**
```zsh
if ! plugin-load "optional"; then
    state=$(plugin-get-state "optional")
    case "$state" in
        disabled)
            echo "Plugin intentionally disabled"
            ;;
        failed)
            echo "Plugin failed to load"
            ;;
        *)
            echo "Plugin not available"
            ;;
    esac
fi
```

---

#### `plugin-init`

**Source:** Lines 370-419
**Complexity:** O(1)
**Dependencies:** `plugin-load`

Initialize a plugin by calling its `<name>_init` function.

**Signature:**
```zsh
plugin-init <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin initialized successfully
- `1` - Plugin initialization failed

**Side Effects:**
- Calls `<name>_init` function (hyphens → underscores)
- Sets `_PLUGINS_STATE[name]` to `initialized` or `failed`
- Emits `plugin.initialized` event (if `_events` loaded)

**Init Function:**
- Name: `<plugin-name>` → `<plugin_name>_init`
- Optional: Plugin can omit init function
- If omitted: Plugin marked `initialized` without calling anything

**Example:**
```zsh
# Load and initialize
if plugin-load "docker" && plugin-init "docker"; then
    echo "Docker plugin ready"
else
    echo "Docker plugin initialization failed"
    exit 1
fi
```

**Example: Check Init Function:**
```zsh
plugin_name="my-plugin"
init_func="${plugin_name//-/_}_init"

if typeset -f "$init_func" >/dev/null; then
    echo "Init function exists: $init_func"
else
    echo "No init function, plugin will be marked initialized without calling anything"
fi

plugin-init "$plugin_name"
```

---

#### `plugin-init-all`

**Source:** Lines 534-615
**Complexity:** O(n²) - Dependency resolution
**Dependencies:** `plugin-is-enabled`, `plugin-init`, `_plugin-get-dep-list`

Initialize all discovered plugins in dependency order.

**Signature:**
```zsh
plugin-init-all
```

**Returns:**
- `0` - All plugins initialized successfully
- `1` - Some plugins failed to initialize

**Side Effects:**
- Sets `_PLUGINS_INIT_ORDER` with dependency-ordered plugin list
- Initializes all enabled plugins
- Skips disabled plugins

**Dependency Resolution:**
1. Build dependency graph from metadata
2. Topologically sort plugins
3. Initialize in order (dependencies first)

**Example:**
```zsh
# Discover and initialize all
plugin-discover
plugin-init-all

# Check results
echo "Initialization results:"
for plugin in $(plugin-list); do
    state=$(plugin-get-state "$plugin")
    echo "  $plugin: $state"
done
```

**Example: Error Handling:**
```zsh
if ! plugin-init-all; then
    echo "Some plugins failed to initialize"

    echo "Failed plugins:"
    for plugin in $(plugin-list "failed"); do
        echo "  - $plugin"
    done

    exit 1
fi

echo "All plugins initialized successfully"
```

**Example: Selective Initialization:**
```zsh
# Disable non-essential plugins
plugin-disable "experimental"
plugin-disable "debug-tools"

# Initialize only enabled plugins
plugin-init-all

# Later, enable and init specific plugin
plugin-enable "debug-tools"
plugin-load "debug-tools"
plugin-init "debug-tools"
```

---

<!-- CONTEXT_GROUP: api_utilities -->
### Plugin Utility Functions

#### `plugin-get-path`

**Source:** Lines 623-626
**Complexity:** O(1)
**Dependencies:** None

Get the directory path for a plugin.

**Signature:**
```zsh
plugin-get-path <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Always succeeds

**Output:** Plugin directory path (empty if not found)

**Example:**
```zsh
path=$(plugin-get-path "docker")
if [[ -n "$path" ]]; then
    echo "Docker plugin located at: $path"
    ls -la "$path"
fi
```

**Example: Read Plugin Files:**
```zsh
path=$(plugin-get-path "docker")
if [[ -f "$path/README.md" ]]; then
    cat "$path/README.md"
fi
```

---

#### `plugin-exists`

**Source:** Lines 631-634
**Complexity:** O(1)
**Dependencies:** None

Check if a plugin exists (has been discovered).

**Signature:**
```zsh
plugin-exists <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin exists in registry
- `1` - Plugin not found

**Example:**
```zsh
if plugin-exists "docker"; then
    echo "Docker plugin available"
else
    echo "Docker plugin not found"
    exit 1
fi
```

**Example: Conditional Feature:**
```zsh
# Check if optional plugin exists
if plugin-exists "telemetry"; then
    echo "Telemetry available, enabling metrics"
    plugin-load "telemetry"
    plugin-init "telemetry"
else
    echo "Telemetry not available, running without metrics"
fi
```

---

#### `plugin-validate`

**Source:** Lines 639-689
**Complexity:** O(n) - Number of dependencies
**Dependencies:** `plugin-get-metadata`, `plugin-exists`

Validate plugin structure and metadata.

**Signature:**
```zsh
plugin-validate <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Plugin valid
- `1` - Validation failed

**Output:** Validation errors or success message

**Validation Checks:**
1. Plugin exists in registry
2. Metadata has required fields (`name`, `version`, `description`)
3. Plugin code file exists (`plugin.zsh`)
4. All dependencies exist in registry

**Example:**
```zsh
if plugin-validate "docker"; then
    echo "Docker plugin is valid"
    plugin-load "docker"
else
    echo "Docker plugin validation failed"
    exit 1
fi
```

**Example: Validate All Plugins:**
```zsh
failed_plugins=()

for plugin in $(plugin-list); do
    if ! plugin-validate "$plugin" >/dev/null 2>&1; then
        failed_plugins+=("$plugin")
    fi
done

if [[ ${#failed_plugins[@]} -gt 0 ]]; then
    echo "Invalid plugins found:"
    printf '  - %s\n' "${failed_plugins[@]}"
    exit 1
fi

echo "All plugins valid"
```

---

#### `plugin-info`

**Source:** Lines 693-719
**Complexity:** O(1)
**Dependencies:** `plugin-get-metadata`, `plugin-get-state`

Display detailed information about a plugin.

**Signature:**
```zsh
plugin-info <name>
```

**Parameters:**
- `name` - Plugin name (required)

**Returns:**
- `0` - Information displayed
- `1` - Plugin not found

**Output:** Formatted plugin information

**Example:**
```zsh
plugin-info "docker"

# Output:
# Plugin: docker
# State: initialized
# Path: /home/user/.local/libexec/plugins/docker
#
# Metadata:
# {
#   "name": "docker",
#   "version": "1.0.0",
#   "description": "Docker integration",
#   ...
# }
#
# Dependencies:
#   - base
```

**Example: Generate Plugin Reports:**
```zsh
mkdir -p reports

for plugin in $(plugin-list); do
    plugin-info "$plugin" > "reports/${plugin}.txt"
done

echo "Plugin reports generated in reports/"
```

---

<!-- CONTEXT_GROUP: api_bootstrap -->
### Bootstrap Function

#### `plugin-bootstrap`

**Source:** Lines 728-756
**Complexity:** O(n²) - Discovery + dependency resolution
**Dependencies:** `plugin-discover`, `plugin-init-all`

Discover and initialize all plugins in one call.

**Signature:**
```zsh
plugin-bootstrap
```

**Returns:**
- `0` - Bootstrap completed successfully
- `1` - Discovery or initialization failed

**Side Effects:**
- Discovers all plugins in search paths
- Initializes all enabled plugins in dependency order

**Equivalent To:**
```zsh
plugin-discover && plugin-init-all
```

**Example:**
```zsh
#!/usr/bin/env zsh
source "$(which _plugins)"

# Bootstrap entire plugin system
if plugin-bootstrap; then
    echo "Plugin system ready"
else
    echo "Plugin system initialization failed"
    exit 1
fi

# Use plugins...
```

**Example: Application Startup:**
```zsh
#!/usr/bin/env zsh

# Load dependencies
source "$(which _common)"
source "$(which _schema)"
source "$(which _actions)"
source "$(which _plugins)"

# Configure search paths
export PLUGINS_SEARCH_PATHS=(
    "$HOME/.myapp/plugins"
    "/etc/myapp/plugins"
)

# Bootstrap plugins
echo "Loading plugins..."
if ! plugin-bootstrap; then
    echo "Warning: Some plugins failed to load"
    # Continue anyway or exit based on requirements
fi

# Application logic...
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## Advanced Usage

### Example 1: Plugin Development Workflow

**Create Plugin Structure:**
```bash
mkdir -p ~/.local/libexec/plugins/my-plugin
cd ~/.local/libexec/plugins/my-plugin
```

**Create Metadata:**
```bash
cat > plugin.yaml <<'EOF'
name: "my-plugin"
version: "0.1.0"
description: "My custom plugin"
author: "Developer Name"

dependencies: []

provides:
  actions:
    - "my.plugin.action"
EOF
```

**Create Plugin Code:**
```bash
cat > plugin.zsh <<'EOF'
#!/usr/bin/env zsh

# Plugin handler
my-plugin-action() {
    local resource="$1"
    local params="$2"

    echo "Executing my-plugin action on: $resource"
    # Implementation...

    return 0
}

# Plugin init
my_plugin_init() {
    action-register "my.plugin" "action" "my-plugin-action"

    echo "My plugin initialized"
    return 0
}
EOF
```

**Test Plugin:**
```zsh
source "$(which _plugins)"
source "$(which _actions)"

# Discover and initialize
plugin-bootstrap

# Verify
if plugin-exists "my-plugin"; then
    echo "Plugin discovered"
    plugin-info "my-plugin"

    # Test action
    action-list "my.plugin"
fi
```

### Example 2: Conditional Plugin Loading

**Load Plugins Based on Environment:**
```zsh
source "$(which _plugins)"

# Discover all
plugin-discover

# Environment-specific loading
environment="${ENVIRONMENT:-development}"

case "$environment" in
    production)
        # Only essential plugins in production
        plugin-disable "debug-tools"
        plugin-disable "experimental"
        ;;
    development)
        # All plugins in dev
        ;;
    testing)
        # Disable real integrations
        plugin-disable "docker"
        plugin-disable "kubernetes"
        # Enable mocks
        plugin-enable "mock-docker"
        plugin-enable "mock-kubernetes"
        ;;
esac

# Initialize based on environment
plugin-init-all

echo "Loaded for environment: $environment"
plugin-list "initialized"
```

### Example 3: Plugin Versioning and Compatibility

**Check Plugin Versions:**
```zsh
source "$(which _plugins)"

check_plugin_version() {
    local plugin="$1"
    local min_version="$2"

    local version=$(plugin-get "$plugin" "version")

    # Simple version comparison (major.minor.patch)
    if [[ "$version" < "$min_version" ]]; then
        echo "Error: $plugin version $version < required $min_version"
        return 1
    fi

    echo "✓ $plugin version $version (>= $min_version)"
    return 0
}

# Discover plugins
plugin-discover

# Check required versions
required_plugins=(
    "docker:1.0.0"
    "kubernetes:2.1.0"
)

for req in "${required_plugins[@]}"; do
    plugin="${req%:*}"
    min_version="${req#*:}"

    if ! check_plugin_version "$plugin" "$min_version"; then
        echo "Version requirement not met"
        exit 1
    fi
done

echo "All version requirements satisfied"
```

### Example 4: Plugin Hot-Reloading

**Reload Plugin After Updates:**
```zsh
source "$(which _plugins)"

reload_plugin() {
    local plugin="$1"

    echo "Reloading plugin: $plugin"

    # Get plugin path
    local path=$(plugin-get-path "$plugin")
    if [[ -z "$path" ]]; then
        echo "Plugin not found: $plugin"
        return 1
    fi

    # Re-source plugin code
    source "$path/plugin.zsh"

    # Re-initialize
    init_func="${plugin//-/_}_init"
    if typeset -f "$init_func" >/dev/null; then
        "$init_func"
        echo "Plugin reloaded: $plugin"
    else
        echo "No init function found"
    fi
}

# Usage
reload_plugin "my-plugin"
```

### Example 5: Plugin Configuration Management

**Plugin-Specific Configuration:**
```zsh
source "$(which _plugins)"

# Load plugin configs from XDG_CONFIG_HOME
load_plugin_configs() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/plugins"

    for plugin in $(plugin-list); do
        local config_file="$config_dir/${plugin}.conf"

        if [[ -f "$config_file" ]]; then
            echo "Loading config for: $plugin"

            # Source config file
            source "$config_file"

            # Or parse and inject into plugin context
            # plugin-context-set "$plugin" "config" "$(cat "$config_file")"
        fi
    done
}

plugin-bootstrap
load_plugin_configs
```

### Example 6: Plugin Dependency Graph Visualization

**Generate Dependency Graph:**
```zsh
source "$(which _plugins)"

generate_dependency_graph() {
    plugin-discover

    echo "digraph plugins {"
    echo "  rankdir=LR;"
    echo "  node [shape=box];"

    for plugin in $(plugin-list); do
        metadata=$(plugin-get-metadata "$plugin")
        deps=$(echo "$metadata" | jq -r '.dependencies[]? // empty')

        if [[ -z "$deps" ]]; then
            echo "  \"$plugin\";"
        else
            while IFS= read -r dep; do
                echo "  \"$plugin\" -> \"$dep\";"
            done <<< "$deps"
        fi
    done

    echo "}"
}

# Generate DOT file
generate_dependency_graph > plugins.dot

# Render with graphviz
dot -Tpng plugins.dot -o plugins.png
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Plugin Not Discovered

**Symptoms:** Plugin not appearing in `plugin-list`

**Causes:**
1. Plugin not in search paths
2. Missing or invalid `plugin.yaml`
3. Incorrect directory structure

**Solution:**
```zsh
# Check search paths
printf '%s\n' "${PLUGINS_SEARCH_PATHS[@]}"

# Manually check plugin directory
plugin_dir="$HOME/.local/libexec/plugins/my-plugin"
ls -la "$plugin_dir"

# Verify plugin.yaml exists
if [[ -f "$plugin_dir/plugin.yaml" ]]; then
    echo "Metadata file exists"
    cat "$plugin_dir/plugin.yaml"
else
    echo "Missing plugin.yaml"
fi

# Validate metadata
source "$(which _schema)"
schema-validate "$plugin_dir/plugin.yaml"

# Add custom search path
export PLUGINS_SEARCH_PATHS+=(
    "/path/to/my/plugins"
)

# Re-discover
plugin-discover
```

---

#### Issue 2: Plugin Load Fails

**Error:** Plugin state shows `failed`

**Causes:**
1. Syntax error in `plugin.zsh`
2. Missing dependencies
3. Permission issues

**Solution:**
```zsh
# Get plugin path
path=$(plugin-get-path "my-plugin")

# Manually source to see error
zsh -n "$path/plugin.zsh"  # Check syntax
source "$path/plugin.zsh"  # Try sourcing

# Check dependencies
metadata=$(plugin-get-metadata "my-plugin")
deps=$(echo "$metadata" | jq -r '.dependencies[]')

for dep in $deps; do
    if ! plugin-exists "$dep"; then
        echo "Missing dependency: $dep"
    fi
done

# Check permissions
ls -la "$path/plugin.zsh"
```

---

#### Issue 3: Init Function Not Called

**Symptoms:** Plugin loads but doesn't initialize

**Causes:**
1. Wrong init function name
2. Init function not defined
3. Init function returns non-zero

**Solution:**
```zsh
# Check expected init function name
plugin_name="my-plugin"
init_func="${plugin_name//-/_}_init"
echo "Expected init function: $init_func"

# Check if function exists
if typeset -f "$init_func" >/dev/null; then
    echo "Init function exists"
else
    echo "Init function not found"

    # List all functions in plugin
    path=$(plugin-get-path "$plugin_name")
    grep -n "^[a-z_-]*[a-z_-]*()" "$path/plugin.zsh"
fi

# Manually call init to see errors
"$init_func"
```

---

#### Issue 4: Circular Dependency Detected

**Error:**
```
[ERROR] Circular dependency detected: plugin-a plugin-b plugin-a
```

**Cause:** Plugins have circular dependency references

**Solution:**
```zsh
# Review plugin dependencies
for plugin in $(plugin-list); do
    echo "Plugin: $plugin"
    echo "  Dependencies:"
    plugin-get-metadata "$plugin" | jq -r '.dependencies[]?' | sed 's/^/    - /'
done

# Fix: Remove circular dependency from plugin.yaml
# A depends on B, B depends on A → remove one dependency
```

---

### Troubleshooting Index

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

| Issue | Quick Fix | Details |
|-------|-----------|---------|
| Plugin not discovered | Check paths, verify plugin.yaml | [→](#issue-1-plugin-not-discovered) |
| Plugin load fails | Check syntax, dependencies | [→](#issue-2-plugin-load-fails) |
| Init not called | Check function name | [→](#issue-3-init-function-not-called) |
| Circular dependency | Review dependencies | [→](#issue-4-circular-dependency-detected) |

---

## Version History

**v1.0.0** (2025-11-09)
- Initial release
- Plugin discovery and loading
- Metadata management
- Dependency resolution
- Enable/disable functionality
- State tracking
- Validation support

---

## See Also

- **_schema** - Schema loading (used for plugin metadata)
- **_actions** - Action system (plugins register action handlers)
- **_common** - Core utilities (used by _plugins)
- **_log** - Logging (optional integration)
- **_events** - Event system (optional integration)

---

**Documentation Version:** 1.1
**Last Updated:** 2025-11-09
**Compliance:** Enhanced Documentation Requirements v1.1 (95%)
