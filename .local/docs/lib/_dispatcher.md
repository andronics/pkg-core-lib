# _dispatcher - Git-like Subcommand Dispatcher and Routing System

**Lines:** 3,420 | **Functions:** 27 | **Examples:** 78 | **Source Lines:** 853
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_dispatcher`
**Quality:** Gold Standard v1.1

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

---

## Quick Access Index

### Compact References (Lines 10-250)
- [Function Reference](#function-quick-reference) - 27 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 13 variables
- [Events](#events-quick-reference) - 2 events
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 250-400, ~150 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 400-500, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 500-750, ~250 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 750-900, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 900-2200, ~1300 lines) ⚡ LARGE SECTION
- [Events](#events) (Lines 2200-2350, ~150 lines) ⚡ MEDIUM
- [Examples](#examples) (Lines 2350-2900, ~550 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2900-3100, ~200 lines) 🔧 REFERENCE
- [Architecture](#architecture) (Lines 3100-3250, ~150 lines) 📐 REFERENCE
- [Performance](#performance) (Lines 3250-3350, ~100 lines) 📊 REFERENCE
- [Best Practices](#best-practices) (Lines 3350-3400, ~50 lines) ✨ REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
<!-- CONTEXT_GROUP: core_api -->

**Initialization Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-init` | Initialize dispatcher system | 118-152 | O(1) | [→](#dispatcher-init) |
| `dispatcher-check-init` | Verify dispatcher initialized | 156-161 | O(1) | [→](#dispatcher-check-init) |

**Command Discovery Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-find-command` | Find subcommand executable path | 172-195 | O(1)* | [→](#dispatcher-find-command) |
| `dispatcher-command-exists` | Check if subcommand exists | 199-202 | O(1)* | [→](#dispatcher-command-exists) |
| `dispatcher-get-commands` | List all available subcommands | 209-224 | O(n) | [→](#dispatcher-get-commands) |
| `dispatcher-count-commands` | Count available subcommands | 228-231 | O(n) | [→](#dispatcher-count-commands) |
| `dispatcher-get-command-description` | Extract command description | 238-245 | O(1) | [→](#dispatcher-get-command-description) |

**Command Alias Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-register-alias` | Register command alias | 253-264 | O(1) | [→](#dispatcher-register-alias) |
| `dispatcher-resolve-alias` | Resolve alias to actual command | 268-271 | O(1) | [→](#dispatcher-resolve-alias) |

**Middleware/Hook Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-before` | Register before-command hook | 279-289 | O(1) | [→](#dispatcher-before) |
| `dispatcher-after` | Register after-command hook | 293-303 | O(1) | [→](#dispatcher-after) |

**Global Flag Parsing Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-parse-global-flags` | Parse global flags before routing | 350-391 | O(n) | [→](#dispatcher-parse-global-flags) |
| `dispatcher-is-verbose` | Check if verbose mode enabled | 395-397 | O(1) | [→](#dispatcher-is-verbose) |
| `dispatcher-is-debug` | Check if debug mode enabled | 401-403 | O(1) | [→](#dispatcher-is-debug) |
| `dispatcher-is-dry-run` | Check if dry-run mode enabled | 407-409 | O(1) | [→](#dispatcher-is-dry-run) |

**Command Execution Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-execute-command` | Execute a subcommand with args | 420-466 | O(1) | [→](#dispatcher-execute-command) |
| `dispatcher-execute` | Main execution handler (routing) | 473-516 | O(1) | [→](#dispatcher-execute) |

**Output Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-list-commands` | List commands (simple format) | 524-536 | O(n) | [→](#dispatcher-list-commands) |
| `dispatcher-list-commands-detailed` | List commands with descriptions | 540-557 | O(n) | [→](#dispatcher-list-commands-detailed) |
| `dispatcher-show-help` | Display help message | 564-592 | O(n) | [→](#dispatcher-show-help) |
| `dispatcher-show-version` | Display version information | 599-608 | O(1) | [→](#dispatcher-show-version) |

**Error Handling Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-error` | Print error message to stderr | 616-618 | O(1) | [→](#dispatcher-error) |
| `dispatcher-warning` | Print warning message to stderr | 622-624 | O(1) | [→](#dispatcher-warning) |
| `dispatcher-validate-command` | Validate command before execution | 628-642 | O(1) | [→](#dispatcher-validate-command) |

**Completion Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-generate-completion` | Generate shell completion script | 650-665 | O(n) | [→](#dispatcher-generate-completion) |

**Testing Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `dispatcher-self-test` | Run comprehensive self-tests | 746-834 | O(1) | [→](#dispatcher-self-test) |
| `dispatcher-version` | Print version information | 842-844 | O(1) | [→](#dispatcher-version) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `_dispatcher-run-before-hooks` | Execute before hooks (internal) | 306-316 | Internal |
| `_dispatcher-run-after-hooks` | Execute after hooks (internal) | 319-330 | Internal |
| `_dispatcher-generate-bash-completion` | Generate bash completion (internal) | 668-693 | Internal |
| `_dispatcher-generate-zsh-completion` | Generate zsh completion (internal) | 696-738 | Internal |

*O(1) with caching enabled (default)

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `DISPATCHER_NAME` | string | `""` | Command name (set by dispatcher-init) |
| `DISPATCHER_BIN_DIR` | path | `""` | Directory containing subcommands |
| `DISPATCHER_VERSION_STRING` | string | `"unknown"` | Version string for help/version output |
| `DISPATCHER_DESCRIPTION` | string | `""` | Description for help message |
| `DISPATCHER_VERBOSE` | boolean | `false` | Enable verbose output |
| `DISPATCHER_DEBUG` | boolean | `false` | Enable debug logging |
| `DISPATCHER_DRY_RUN` | boolean | `false` | Dry-run mode (preview without execute) |
| `DISPATCHER_EVENTS_AVAILABLE` | boolean | `false` | _events extension loaded and available |
| `DISPATCHER_LIFECYCLE_AVAILABLE` | boolean | `false` | _lifecycle extension loaded and available |
| `_DISPATCHER_COMMAND_CACHE` | assoc array | `()` | Command path cache (internal) |
| `_DISPATCHER_ALIASES` | assoc array | `()` | Command aliases (internal) |
| `_DISPATCHER_BEFORE_HOOKS` | array | `()` | Before-command hooks (internal) |
| `_DISPATCHER_AFTER_HOOKS` | array | `()` | After-command hooks (internal) |

---

## Events Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | When Emitted | Data Parameters | Source Lines |
|-------|--------------|-----------------|--------------|
| `dispatcher.command.start` | Command execution starts | `command_name`, `subcommand` | 440 |
| `dispatcher.command.complete` | Command execution completes | `command_name`, `subcommand`, `exit_code` | 462 |

**Event Subscription:**
```zsh
source "$(which _events)"
events-on "dispatcher.command.start" my_handler_function
```

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (not initialized, not found, etc.) | Most functions |
| `2` | Invalid arguments | Missing or invalid parameters | Functions with required params |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
<!-- CONTEXT_GROUP: overview -->
## Overview

The `_dispatcher` extension provides a comprehensive Git-like subcommand dispatcher and routing system for building elegant CLI tools with multiple subcommands. It enables automatic command discovery, help generation, completion scripts, middleware hooks, and sophisticated routing—all with a clean, consistent API following the Git/Docker/kubectl command pattern.

**Key Features:**
- **Git-like Command Routing**: Natural `mycommand subcommand args` pattern
- **Automatic Discovery**: Finds subcommands by naming convention (zero configuration)
- **Help Generation**: Auto-generates help from command descriptions in source comments
- **Global Flags**: Parse `--verbose`, `--debug`, `--dry-run` before routing to subcommands
- **Command Aliases**: Create short aliases for frequently-used commands
- **Middleware/Hooks**: Before/after command execution hooks for validation and cleanup
- **Completion**: Generate bash/zsh completion scripts automatically
- **Event Integration**: Emit events on command lifecycle via _events extension
- **Dry-run Support**: Preview commands without execution for safety
- **Command Caching**: Performance optimization for repeated command lookups (100x speedup)
- **Graceful Degradation**: Works with minimal dependencies, enhanced with optional extensions

### Design Philosophy

1. **Convention over Configuration**: Minimal setup, maximum automation through naming conventions
2. **Git-like UX**: Familiar pattern for CLI users (git, docker, kubectl style)
3. **Extensible**: Hooks and events for custom behavior without modifying core
4. **Self-documenting**: Help extracted from code comments, no separate docs needed
5. **Performance**: Caching for fast repeated command lookups, minimal overhead (~3ms)
6. **Safety**: Dry-run mode, validation hooks, graceful error handling

### Dependencies

**Required:**
- `_common` v2.0 - Core utilities and common functions

**Optional (gracefully degraded):**
- `_log` v2.0 - Enhanced logging (fallback logging provided if unavailable)
- `_events` v2.0 - Event emission for command lifecycle monitoring
- `_lifecycle` v3.0 - Cleanup registration (currently unused, reserved for future)

### Use Cases

- **Multi-tool CLI Applications**: Tools with multiple subcommands (package managers, deployment tools)
- **Plugin-based Architectures**: Allow users to extend tools with custom subcommands
- **Workflow Orchestration**: Build deployment/CI tools with validation hooks
- **Development Tool Suites**: Project management, build systems, testing frameworks
- **Administrative Tools**: System administration with access control hooks
- **Interactive CLIs**: Build tools with interactive command selection
- **Testing Frameworks**: Test runners with discovery and reporting
- **Documentation Generators**: Auto-generate docs from command structure

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

### Via GNU Stow (Recommended)

```zsh
# Clone or update dotfiles
cd ~/.pkgs/lib
git pull

# Install via stow (creates symlinks)
cd ~/.pkgs
stow lib

# Verify installation
source "$(which _dispatcher)" && echo "Installed: $(dispatcher-version)"
```

### Manual Installation

```zsh
# Copy to local bin
cp ~/.pkgs/lib/.local/bin/lib/_dispatcher ~/.local/bin/lib/_dispatcher
chmod +x ~/.local/bin/lib/_dispatcher

# Ensure ~/.local/bin/lib in PATH
echo 'export PATH="$HOME/.local/bin/lib:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
source _dispatcher && dispatcher-version
```

### Verification

```zsh
# Test installation
source "$(which _dispatcher)"
dispatcher-self-test

# Expected output:
# === _dispatcher v1.0.0 Self-Test ===
# Test 1: Initialization... PASS
# Test 2: Check initialization... PASS
# ...
# All tests passed!
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
<!-- CONTEXT_GROUP: quickstart -->
## Quick Start

### Step 1: Create Main Dispatcher Script

Create your main command that initializes and routes to subcommands:

```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/myapp

source "$(which _dispatcher)" || {
    echo "Error: _dispatcher not found" >&2
    exit 1
}

# Initialize dispatcher
dispatcher-init "myapp" "$(dirname "$0")" "1.0.0" "My Application"

# Execute command
dispatcher-execute "$@"
```

Make it executable:
```zsh
chmod +x /usr/local/bin/myapp
```

### Step 2: Create Subcommand Scripts

Create individual subcommands following the naming convention `<command>-<subcommand>`:

```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/myapp-list
# Description: List all items

source "$(which _common)"

echo "Listing items..."
# Your implementation here
ls -la ~/.myapp/items/
```

```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/myapp-add
# Description: Add a new item

source "$(which _common)"

item="${1}"

if [[ -z "$item" ]]; then
    log-error "Item name required"
    echo "Usage: myapp add <item>"
    exit 1
fi

echo "Adding item: $item"
# Your implementation here
touch "~/.myapp/items/$item"
log-success "Item added: $item"
```

Make subcommands executable:
```zsh
chmod +x /usr/local/bin/myapp-*
```

### Step 3: Use Your Tool

```zsh
# Show help
myapp help

# List available commands
myapp commands

# Run subcommands
myapp list
myapp add "new-item"

# Get command-specific help
myapp help add
myapp list --help

# Use with global flags
myapp --verbose list
myapp --debug add test-item
myapp --dry-run delete dangerous-item
```

### Step 4: Add Aliases and Hooks (Optional)

Enhance your main script with aliases and validation hooks:

```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/myapp

source "$(which _dispatcher)"
source "$(which _log)"

# Initialize
dispatcher-init "myapp" "$(dirname "$0")" "1.0.0" "My Application"

# Register aliases
dispatcher-register-alias "ls" "list"
dispatcher-register-alias "rm" "remove"
dispatcher-register-alias "add" "create"

# Validation hook
validate-environment() {
    local command="$1"

    # Check data directory exists
    if [[ ! -d ~/.myapp ]]; then
        log-error "Application not initialized"
        log-info "Run: myapp init"
        return 1
    fi

    return 0
}

# Cleanup hook
cleanup-temp() {
    rm -rf /tmp/myapp-*
}

# Register hooks
dispatcher-before "validate-environment"
dispatcher-after "cleanup-temp"

# Parse global flags
eval "$(dispatcher-parse-global-flags "$@")"

# Execute
dispatcher-execute "$@"
```

### Step 5: Generate Completion (Optional)

```zsh
# Generate bash completion
sudo myapp completion bash > /etc/bash_completion.d/myapp
source /etc/bash_completion.d/myapp

# Generate zsh completion
sudo myapp completion zsh > /usr/share/zsh/site-functions/_myapp
# Rebuild completion cache
rm -f ~/.zcompdump
compinit

# Test completion
myapp <TAB>          # Shows available commands
myapp list <TAB>     # Shows command-specific completions
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Configuration

### Environment Variables

Configure dispatcher behavior via environment variables:

```zsh
# Behavior Flags
export DISPATCHER_VERBOSE=false    # Enable verbose output
export DISPATCHER_DEBUG=false      # Enable debug logging
export DISPATCHER_DRY_RUN=false    # Preview mode (no execution)

# These are set by dispatcher-init (don't set manually):
# DISPATCHER_NAME               # Command name
# DISPATCHER_BIN_DIR            # Subcommand directory
# DISPATCHER_VERSION_STRING     # Version for help/version
# DISPATCHER_DESCRIPTION        # Description for help

# Feature availability (auto-detected):
# DISPATCHER_EVENTS_AVAILABLE      # _events loaded
# DISPATCHER_LIFECYCLE_AVAILABLE   # _lifecycle loaded
```

### Subcommand Naming Convention

Subcommands **must** follow the pattern: `<command-name>-<subcommand-name>`

```zsh
# Main command
/usr/local/bin/myapp

# Subcommands (automatically discovered)
/usr/local/bin/myapp-list       # → myapp list
/usr/local/bin/myapp-add        # → myapp add
/usr/local/bin/myapp-remove     # → myapp remove
/usr/local/bin/myapp-status     # → myapp status

# Multi-word subcommands (use hyphens)
/usr/local/bin/myapp-list-all   # → myapp list-all
/usr/local/bin/myapp-add-user   # → myapp add-user
```

### Subcommand Description Format

Add descriptions for auto-generated help:

```zsh
#!/usr/bin/env zsh
# Description: Brief, clear description of what this command does
# (First line matching "# Description:" is extracted)

# Your code here...
```

**Example:**
```zsh
#!/usr/bin/env zsh
# Description: Add a new user to the system

user="${1}"
# Implementation...
```

### Internal State Variables

Internal state managed automatically (don't modify directly):

```zsh
# Command cache (performance optimization)
declare -g -A _DISPATCHER_COMMAND_CACHE=()

# Aliases (managed by dispatcher-register-alias)
declare -g -A _DISPATCHER_ALIASES=()

# Hooks (managed by dispatcher-before/after)
declare -g -a _DISPATCHER_BEFORE_HOOKS=()
declare -g -a _DISPATCHER_AFTER_HOOKS=()
```

### Directory Organization

**Standard Layout:**
```
/usr/local/bin/
├── myapp                  # Main dispatcher script
├── myapp-list             # Subcommand: list
├── myapp-add              # Subcommand: add
├── myapp-remove           # Subcommand: remove
└── myapp-status           # Subcommand: status
```

**Libexec Layout (for complex tools):**
```
/usr/local/
├── bin/
│   └── myapp              # Main script
└── libexec/
    └── myapp/             # Subcommand directory
        ├── myapp-list
        ├── myapp-add
        ├── myapp-remove
        └── myapp-status
```

Use libexec pattern in dispatcher-init:
```zsh
dispatcher-init "myapp" "/usr/local/libexec/myapp" "1.0.0"
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: api_reference -->
## API Reference

### Initialization

#### dispatcher-init

**Source:** Lines 118-152 | **Complexity:** O(1) | **Used by:** All dispatcher-based tools

Initialize the dispatcher system. Must be called before any other dispatcher functions.

**Signature:**
```zsh
dispatcher-init <name> [bin_dir] [version] [description]
```

**Parameters:**
- `$1` (required) - **name**: Command name (e.g., "myapp")
- `$2` (optional) - **bin_dir**: Directory containing subcommands (auto-detected if empty)
- `$3` (optional) - **version**: Version string (default: "unknown")
- `$4` (optional) - **description**: Description for help message

**Returns:**
- Exit code 0 on success
- Exit code 1 if name not provided

**Side Effects:**
- Sets `DISPATCHER_NAME`, `DISPATCHER_BIN_DIR`, `DISPATCHER_VERSION_STRING`, `DISPATCHER_DESCRIPTION`
- Exports variables for subcommand access
- Auto-detects bin directory from calling script if not provided

**Examples:**

*Example 1: Minimal initialization (auto-detect directory)*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"

# Auto-detect bin directory from script location
dispatcher-init "myapp"

dispatcher-execute "$@"
```

*Example 2: Full initialization with all parameters*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"

# Explicit configuration
dispatcher-init "myapp" "/usr/local/libexec/myapp" "1.5.0" \
    "Application for managing items"

dispatcher-execute "$@"
```

*Example 3: Initialize with version only*
```zsh
dispatcher-init "deploy" "" "3.2.1"
# bin_dir auto-detected, version set explicitly
```

*Example 4: Error handling*
```zsh
if ! dispatcher-init ""; then
    echo "Error: Command name required" >&2
    exit 1
fi
```

**Notes:**
- Can only be called once (subsequent calls are no-ops due to state check)
- Auto-detection works by examining `${(%):-%x}` (current script path)
- All parameters except `name` are optional
- Exported variables are available to all subcommands

**Performance:** ~2ms (one-time initialization cost)

---

#### dispatcher-check-init

**Source:** Lines 156-161 | **Complexity:** O(1) | **Used by:** Internal guards

Check if dispatcher has been properly initialized.

**Signature:**
```zsh
dispatcher-check-init
```

**Returns:**
- Exit code 0 if initialized (`DISPATCHER_NAME` is set)
- Exit code 1 if not initialized

**Examples:**

*Example 1: Guard against uninitialized use*
```zsh
dispatcher-check-init || {
    log-error "Dispatcher not initialized - call dispatcher-init first"
    return 1
}
```

*Example 2: Use in functions*
```zsh
my-custom-function() {
    dispatcher-check-init || return 1

    # Safe to use dispatcher functions here
    local commands=($(dispatcher-get-commands))
    echo "Available: ${commands[@]}"
}
```

*Example 3: Conditional initialization*
```zsh
if ! dispatcher-check-init; then
    dispatcher-init "myapp" "$(dirname "$0")" "1.0.0"
fi
```

**Performance:** ~0.01ms (simple variable check)

---

### Command Discovery

#### dispatcher-find-command

**Source:** Lines 172-195 | **Complexity:** O(1) with caching | **Used by:** Command execution

Find a subcommand executable by name and return its full path.

**Signature:**
```zsh
dispatcher-find-command <command>
```

**Parameters:**
- `$1` (required) - **command**: Subcommand name (without prefix)

**Returns:**
- Full path to command executable (stdout)
- Empty string if not found
- Exit code 0 if found, 1 if not found

**Side Effects:**
- Caches result in `_DISPATCHER_COMMAND_CACHE` for performance

**Examples:**

*Example 1: Find and execute command manually*
```zsh
cmd_path=$(dispatcher-find-command "list")
if [[ -n "$cmd_path" ]]; then
    echo "Found: $cmd_path"
    "$cmd_path" --verbose --format=json
else
    echo "Command not found" >&2
fi
```

*Example 2: Check existence before aliasing*
```zsh
if cmd_path=$(dispatcher-find-command "remove"); then
    echo "remove command available at: $cmd_path"
    dispatcher-register-alias "rm" "remove"
else
    log-warn "remove command not found, alias not created"
fi
```

*Example 3: Verify command availability*
```zsh
required_commands=("init" "start" "stop" "status")

for cmd in "${required_commands[@]}"; do
    if ! dispatcher-find-command "$cmd" >/dev/null; then
        log-error "Required command missing: $cmd"
        exit 1
    fi
done
```

*Example 4: Get command path for logging*
```zsh
cmd_path=$(dispatcher-find-command "deploy")
log-info "Executing: $cmd_path"
"$cmd_path" production
```

**Performance:**
- First lookup: ~1ms (filesystem search)
- Cached lookup: ~0.01ms (100x speedup)

**Notes:**
- Results are cached automatically in `_DISPATCHER_COMMAND_CACHE`
- Cache persists for lifetime of dispatcher process
- Search pattern: `${DISPATCHER_BIN_DIR}/${DISPATCHER_NAME}-${command}`

---

#### dispatcher-command-exists

**Source:** Lines 199-202 | **Complexity:** O(1) | **Used by:** Validation

Check if a subcommand exists (convenience wrapper around dispatcher-find-command).

**Signature:**
```zsh
dispatcher-command-exists <command>
```

**Parameters:**
- `$1` (required) - **command**: Subcommand name

**Returns:**
- Exit code 0 if exists
- Exit code 1 if not exists

**Examples:**

*Example 1: Conditional execution*
```zsh
if dispatcher-command-exists "backup"; then
    dispatcher-execute-command "backup" --full
else
    log-warn "Backup command not available, skipping"
fi
```

*Example 2: Validate before registration*
```zsh
if dispatcher-command-exists "list"; then
    dispatcher-register-alias "ls" "list"
    dispatcher-register-alias "l" "list"
fi
```

*Example 3: Feature detection*
```zsh
has_advanced_features() {
    dispatcher-command-exists "optimize" && \
    dispatcher-command-exists "analyze" && \
    dispatcher-command-exists "benchmark"
}

if has_advanced_features; then
    echo "Advanced features available"
fi
```

*Example 4: Guard dangerous operations*
```zsh
if dispatcher-command-exists "nuclear-option"; then
    log-warn "Dangerous command detected: nuclear-option"
    echo "Are you sure you want this available? (y/n)"
    read confirm
    [[ "$confirm" != "y" ]] && rm "$(dispatcher-find-command "nuclear-option")"
fi
```

**Performance:** Same as dispatcher-find-command (~0.01ms cached, ~1ms uncached)

---

#### dispatcher-get-commands

**Source:** Lines 209-224 | **Complexity:** O(n) where n = number of subcommands | **Used by:** Help generation

Get list of all available subcommands.

**Signature:**
```zsh
dispatcher-get-commands
```

**Returns:**
- Space-separated list of command names (without prefix) to stdout

**Examples:**

*Example 1: Get all commands*
```zsh
commands=($(dispatcher-get-commands))
echo "Available commands: ${commands[@]}"
echo "Total: ${#commands[@]}"
```

*Example 2: Iterate and execute*
```zsh
for cmd in $(dispatcher-get-commands); do
    echo "Running $cmd..."
    dispatcher-execute-command "$cmd" --test
done
```

*Example 3: Filter commands*
```zsh
# Get all "list" variants
list_commands=($(dispatcher-get-commands | tr ' ' '\n' | grep '^list'))
echo "List commands: ${list_commands[@]}"
```

*Example 4: Validate completeness*
```zsh
required=("init" "start" "stop" "status" "logs")
available=($(dispatcher-get-commands))

for cmd in "${required[@]}"; do
    if [[ ! " ${available[@]} " =~ " $cmd " ]]; then
        log-error "Missing required command: $cmd"
    fi
done
```

*Example 5: Build custom help*
```zsh
echo "Available operations:"
for cmd in $(dispatcher-get-commands); do
    local desc=$(dispatcher-get-command-description "$cmd")
    printf "  %-15s - %s\n" "$cmd" "$desc"
done
```

**Performance:** ~5ms for ~20 commands (filesystem glob and iteration)

**Notes:**
- Results are not cached (commands may be added/removed)
- Excludes main dispatcher script itself
- Only returns executable files matching naming pattern

---

#### dispatcher-count-commands

**Source:** Lines 228-231 | **Complexity:** O(n) | **Used by:** Statistics

Count available subcommands.

**Signature:**
```zsh
dispatcher-count-commands
```

**Returns:**
- Number of available commands (stdout)

**Examples:**

*Example 1: Check if any commands available*
```zsh
count=$(dispatcher-count-commands)
if (( count == 0 )); then
    log-error "No subcommands found in ${DISPATCHER_BIN_DIR}"
    exit 1
fi

echo "Found $count commands"
```

*Example 2: Statistics reporting*
```zsh
total=$(dispatcher-count-commands)
tested=$(find /tmp/test-results -name '*.pass' | wc -l)
echo "Test coverage: $tested / $total commands"
```

*Example 3: Progress indicator*
```zsh
total=$(dispatcher-count-commands)
current=0

for cmd in $(dispatcher-get-commands); do
    ((current++))
    echo "[$current/$total] Testing $cmd..."
    dispatcher-execute-command "$cmd" --test
done
```

**Performance:** Same as dispatcher-get-commands (~5ms for ~20 commands)

---

#### dispatcher-get-command-description

**Source:** Lines 238-245 | **Complexity:** O(1) | **Used by:** Help generation

Extract description from subcommand script (first line matching `# Description:`).

**Signature:**
```zsh
dispatcher-get-command-description <command>
```

**Parameters:**
- `$1` (required) - **command**: Subcommand name

**Returns:**
- Description string (stdout)
- Empty string if no description found

**Examples:**

*Example 1: Get single description*
```zsh
desc=$(dispatcher-get-command-description "list")
echo "list: $desc"
# Output: list: List all items in the system
```

*Example 2: Build formatted help*
```zsh
for cmd in $(dispatcher-get-commands); do
    desc=$(dispatcher-get-command-description "$cmd")
    if [[ -n "$desc" ]]; then
        printf "%-20s %s\n" "$cmd" "$desc"
    else
        printf "%-20s (no description)\n" "$cmd"
    fi
done
```

*Example 3: Categorize commands*
```zsh
declare -A categories

for cmd in $(dispatcher-get-commands); do
    desc=$(dispatcher-get-command-description "$cmd")

    # Categorize based on description keywords
    if [[ "$desc" =~ "List" ]]; then
        categories[Query]+="$cmd "
    elif [[ "$desc" =~ "Add|Create" ]]; then
        categories[Modify]+="$cmd "
    fi
done

for cat in "${!categories[@]}"; do
    echo "$cat: ${categories[$cat]}"
done
```

*Example 4: Validate descriptions exist*
```zsh
missing_desc=0

for cmd in $(dispatcher-get-commands); do
    desc=$(dispatcher-get-command-description "$cmd")
    if [[ -z "$desc" ]]; then
        log-warn "Command missing description: $cmd"
        ((missing_desc++))
    fi
done

echo "Commands without descriptions: $missing_desc"
```

**Description Format in Subcommand:**
```zsh
#!/usr/bin/env zsh
# Description: Your clear, concise description here
# (Only first matching line is extracted)

# Rest of script...
```

**Performance:** ~1ms (single grep operation per command)

---

### Command Aliases

#### dispatcher-register-alias

**Source:** Lines 253-264 | **Complexity:** O(1) | **Used by:** Main script setup

Register a command alias (short name → actual command).

**Signature:**
```zsh
dispatcher-register-alias <alias> <actual_command>
```

**Parameters:**
- `$1` (required) - **alias**: Alias name (short form)
- `$2` (required) - **actual_command**: Actual command name

**Returns:**
- Exit code 0 on success
- Exit code 1 if invalid arguments

**Side Effects:**
- Stores alias in `_DISPATCHER_ALIASES` associative array

**Examples:**

*Example 1: Register common aliases*
```zsh
dispatcher-register-alias "ls" "list"
dispatcher-register-alias "rm" "remove"
dispatcher-register-alias "cp" "copy"
dispatcher-register-alias "mv" "move"

# Usage: myapp ls → routes to myapp-list
```

*Example 2: Short aliases for long names*
```zsh
dispatcher-register-alias "i" "install"
dispatcher-register-alias "u" "uninstall"
dispatcher-register-alias "up" "update"
dispatcher-register-alias "ug" "upgrade"
```

*Example 3: Convenience aliases*
```zsh
dispatcher-register-alias "st" "status"
dispatcher-register-alias "ci" "commit"
dispatcher-register-alias "co" "checkout"
dispatcher-register-alias "br" "branch"
# Git-like aliases
```

*Example 4: Conditional aliasing*
```zsh
# Only alias if command exists
if dispatcher-command-exists "list"; then
    dispatcher-register-alias "ls" "list"
    dispatcher-register-alias "l" "list"
fi
```

*Example 5: Bulk alias registration*
```zsh
declare -A alias_map=(
    [ls]="list"
    [rm]="remove"
    [add]="create"
    [del]="delete"
)

for alias actual in "${(@kv)alias_map}"; do
    dispatcher-register-alias "$alias" "$actual"
done
```

**Performance:** ~0.1ms per alias

**Notes:**
- Aliases are resolved before command lookup
- Can create multi-level aliases (alias → alias → command)
- Alias names should not conflict with real commands
- No validation that target command exists (allows forward declarations)

---

#### dispatcher-resolve-alias

**Source:** Lines 268-271 | **Complexity:** O(1) | **Used by:** Command execution

Resolve an alias to its actual command name.

**Signature:**
```zsh
dispatcher-resolve-alias <command>
```

**Parameters:**
- `$1` (required) - **command**: Command or alias name

**Returns:**
- Actual command name (stdout)
- Original name if not an alias

**Examples:**

*Example 1: Manual resolution*
```zsh
command="ls"
actual=$(dispatcher-resolve-alias "$command")
echo "Resolved: $command → $actual"
# Output: Resolved: ls → list
```

*Example 2: Check if command is alias*
```zsh
if [[ "$(dispatcher-resolve-alias "rm")" != "rm" ]]; then
    echo "rm is an alias"
else
    echo "rm is a real command"
fi
```

*Example 3: Debug alias chain*
```zsh
show_alias_chain() {
    local cmd="$1"
    local resolved=$(dispatcher-resolve-alias "$cmd")

    echo -n "$cmd"
    while [[ "$cmd" != "$resolved" ]]; do
        echo -n " → $resolved"
        cmd="$resolved"
        resolved=$(dispatcher-resolve-alias "$cmd")
    done
    echo ""
}

show_alias_chain "ls"
# Output: ls → list
```

**Performance:** ~0.01ms (hash table lookup)

---

### Middleware/Hooks

#### dispatcher-before

**Source:** Lines 279-289 | **Complexity:** O(1) | **Used by:** Main script setup

Register a before-command hook (executed before each subcommand).

**Signature:**
```zsh
dispatcher-before <function_name>
```

**Parameters:**
- `$1` (required) - **function_name**: Function to call before command execution

**Hook Function Signature:**
```zsh
hook-function() {
    local command="$1"    # Subcommand name
    shift
    local args=("$@")     # Subcommand arguments

    # Hook implementation
    # Return non-zero to abort command execution
}
```

**Returns:**
- Exit code 0 on success
- Exit code 1 if invalid arguments

**Examples:**

*Example 1: Validation hook*
```zsh
validate-args() {
    local command="$1"
    shift

    # Ensure delete command has arguments
    if [[ "$command" == "delete" ]] && [[ $# -eq 0 ]]; then
        log-error "delete command requires item name"
        echo "Usage: myapp delete <item>"
        return 1  # Abort execution
    fi

    return 0
}

dispatcher-before "validate-args"
```

*Example 2: Environment validation*
```zsh
check-environment() {
    local command="$1"

    # Check required tools
    if ! common-command-exists "jq"; then
        log-error "jq required for $command"
        return 1
    fi

    # Check environment variables
    if [[ -z "$API_KEY" ]]; then
        log-error "API_KEY not set"
        return 1
    fi

    return 0
}

dispatcher-before "check-environment"
```

*Example 3: Logging hook*
```zsh
log-command-start() {
    local command="$1"
    shift

    log-info "Executing: $DISPATCHER_NAME $command $*"
    echo "[$(date)] $USER: $command $*" >> ~/.myapp/audit.log
}

dispatcher-before "log-command-start"
```

*Example 4: Permission check*
```zsh
check-permissions() {
    local command="$1"

    # Dangerous commands require root
    local dangerous=("delete-all" "purge" "reset")

    if [[ " ${dangerous[@]} " =~ " $command " ]]; then
        if [[ $EUID -ne 0 ]]; then
            log-error "Command '$command' requires root privileges"
            log-info "Run: sudo $DISPATCHER_NAME $command"
            return 1
        fi
    fi

    return 0
}

dispatcher-before "check-permissions"
```

*Example 5: Rate limiting*
```zsh
rate-limit() {
    local command="$1"
    local last_file="/tmp/myapp-${command}-last"

    if [[ -f "$last_file" ]]; then
        local last=$(cat "$last_file")
        local now=$(date +%s)
        local diff=$((now - last))

        if (( diff < 5 )); then
            log-error "Rate limit: wait $((5 - diff)) seconds"
            return 1
        fi
    fi

    date +%s > "$last_file"
    return 0
}

dispatcher-before "rate-limit"
```

**Performance:** ~1ms overhead per hook

**Notes:**
- Multiple hooks can be registered (executed in registration order)
- Non-zero return code aborts command execution
- Hook receives command name and all arguments
- Hooks are NOT executed for special commands (help, version, commands)

---

#### dispatcher-after

**Source:** Lines 293-303 | **Complexity:** O(1) | **Used by:** Main script setup

Register an after-command hook (executed after each subcommand).

**Signature:**
```zsh
dispatcher-after <function_name>
```

**Parameters:**
- `$1` (required) - **function_name**: Function to call after command execution

**Hook Function Signature:**
```zsh
hook-function() {
    local command="$1"       # Subcommand name
    local exit_code="$2"     # Command exit code
    shift 2
    local args=("$@")        # Subcommand arguments

    # Hook implementation
    # Return value is ignored
}
```

**Returns:**
- Exit code 0 on success
- Exit code 1 if invalid arguments

**Examples:**

*Example 1: Cleanup hook*
```zsh
cleanup-temp() {
    local command="$1"
    local exit_code="$2"

    # Clean temporary files
    rm -rf /tmp/myapp-${command}-*
    log-debug "Cleaned up temporary files for: $command"
}

dispatcher-after "cleanup-temp"
```

*Example 2: Notification hook*
```zsh
notify-completion() {
    local command="$1"
    local exit_code="$2"

    if (( exit_code == 0 )); then
        notify-send "Success" "Command $command completed successfully"
        log-success "$command completed"
    else
        notify-send "Error" "Command $command failed (exit: $exit_code)"
        log-error "$command failed with exit code: $exit_code"
    fi
}

dispatcher-after "notify-completion"
```

*Example 3: Metrics collection*
```zsh
collect-metrics() {
    local command="$1"
    local exit_code="$2"

    # Log to metrics file
    local metrics_file="~/.myapp/metrics.log"
    local timestamp=$(date +%s)

    echo "$timestamp,$command,$exit_code" >> "$metrics_file"
}

dispatcher-after "collect-metrics"
```

*Example 4: State tracking*
```zsh
track-state() {
    local command="$1"
    local exit_code="$2"
    shift 2
    local item="$1"

    if (( exit_code == 0 )); then
        case "$command" in
            start)
                echo "running" > "~/.myapp/state/${item}.state"
                ;;
            stop)
                echo "stopped" > "~/.myapp/state/${item}.state"
                ;;
        esac
    fi
}

dispatcher-after "track-state"
```

*Example 5: Cache invalidation*
```zsh
invalidate-cache() {
    local command="$1"
    local exit_code="$2"

    # Invalidate cache on successful writes
    if (( exit_code == 0 )); then
        local write_commands=("add" "remove" "update" "delete")
        if [[ " ${write_commands[@]} " =~ " $command " ]]; then
            rm -f ~/.myapp/cache/*
            log-debug "Cache invalidated after: $command"
        fi
    fi
}

dispatcher-after "invalidate-cache"
```

**Performance:** ~1ms overhead per hook

**Notes:**
- Executed even if command fails
- Exit code passed as second parameter
- Cannot abort command (already executed)
- Multiple hooks can be registered
- Return value is ignored (command exit code preserved)

---

### Global Flag Parsing

#### dispatcher-parse-global-flags

**Source:** Lines 350-391 | **Complexity:** O(n) where n = number of arguments | **Used by:** Main script

Parse global flags before subcommand routing, extracting and setting dispatcher behavior flags.

**Signature:**
```zsh
eval "$(dispatcher-parse-global-flags "$@")"
```

**Recognized Flags:**
- `--verbose`, `-v` → Sets `DISPATCHER_VERBOSE=true`
- `--quiet`, `-q` → Sets `DISPATCHER_VERBOSE=false`
- `--debug` → Sets `DISPATCHER_DEBUG=true`
- `--dry-run` → Sets `DISPATCHER_DRY_RUN=true`

**Returns:**
- Variable assignments and modified argument list (for eval)

**Side Effects:**
- Sets and exports `DISPATCHER_VERBOSE`, `DISPATCHER_DEBUG`, `DISPATCHER_DRY_RUN`
- Modifies `$@` to contain only subcommand and its args (flags removed)

**Examples:**

*Example 1: Basic usage*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"
dispatcher-init "myapp"

# Parse global flags BEFORE execute
eval "$(dispatcher-parse-global-flags "$@")"

# Now $@ contains only subcommand and args
# DISPATCHER_* variables are set
dispatcher-execute "$@"
```

*Example 2: Check parsed flags*
```zsh
eval "$(dispatcher-parse-global-flags "$@")"

echo "Verbose: $DISPATCHER_VERBOSE"
echo "Debug: $DISPATCHER_DEBUG"
echo "Dry-run: $DISPATCHER_DRY_RUN"
echo "Remaining args: $@"

dispatcher-execute "$@"
```

*Example 3: Conditional verbose output*
```zsh
eval "$(dispatcher-parse-global-flags "$@")"

if dispatcher-is-verbose; then
    echo "Verbose mode enabled"
    echo "Command: $1"
    echo "Args: ${@:2}"
fi

dispatcher-execute "$@"
```

*Example 4: Debug mode setup*
```zsh
eval "$(dispatcher-parse-global-flags "$@")"

if dispatcher-is-debug; then
    # Enable shell debugging
    set -x

    # Show environment
    echo "Environment:"
    echo "  NAME: $DISPATCHER_NAME"
    echo "  BIN: $DISPATCHER_BIN_DIR"
    echo "  VERSION: $DISPATCHER_VERSION_STRING"
fi

dispatcher-execute "$@"
```

*Example 5: Dry-run validation*
```zsh
eval "$(dispatcher-parse-global-flags "$@")"

if dispatcher-is-dry-run; then
    log-warn "DRY RUN MODE - No changes will be made"
    echo "Would execute: $DISPATCHER_NAME $@"
fi

dispatcher-execute "$@"
```

**Command Line Examples:**
```zsh
# Verbose mode
myapp --verbose list              # DISPATCHER_VERBOSE=true
myapp -v list                     # Same

# Debug mode
myapp --debug deploy              # DISPATCHER_DEBUG=true

# Dry-run mode
myapp --dry-run delete-all        # DISPATCHER_DRY_RUN=true

# Multiple flags
myapp --verbose --debug --dry-run test
# All three flags set

# Quiet mode (disable verbose)
myapp --quiet list                # DISPATCHER_VERBOSE=false
```

**Performance:** ~1ms for typical flag count

**Notes:**
- Flags must come BEFORE subcommand name
- Flags after subcommand are passed to subcommand
- Variables are exported for subcommand access
- Use `eval` to properly handle quoting and array expansion

---

#### dispatcher-is-verbose

**Source:** Lines 395-397 | **Complexity:** O(1)

Check if verbose mode is enabled.

**Signature:**
```zsh
dispatcher-is-verbose
```

**Returns:**
- Exit code 0 if verbose enabled
- Exit code 1 if verbose disabled

**Examples:**

*Example 1: Conditional output*
```zsh
dispatcher-is-verbose && echo "Detailed information..."
```

*Example 2: Verbose logging*
```zsh
if dispatcher-is-verbose; then
    echo "Loading configuration from: $config_file"
    echo "Using database: $db_name"
    echo "Connecting to: $api_endpoint"
fi
```

*Example 3: Progress reporting*
```zsh
for file in *.txt; do
    dispatcher-is-verbose && echo "Processing: $file"
    process_file "$file"
done
```

---

#### dispatcher-is-debug

**Source:** Lines 401-403 | **Complexity:** O(1)

Check if debug mode is enabled.

**Signature:**
```zsh
dispatcher-is-debug
```

**Returns:**
- Exit code 0 if debug enabled
- Exit code 1 if debug disabled

**Examples:**

*Example 1: Debug output*
```zsh
dispatcher-is-debug && echo "DEBUG: variable=$value"
```

*Example 2: Shell tracing*
```zsh
dispatcher-is-debug && set -x
```

*Example 3: Detailed logging*
```zsh
if dispatcher-is-debug; then
    echo "DEBUG: Function called with args: $@"
    echo "DEBUG: Current state:"
    echo "  PWD: $PWD"
    echo "  USER: $USER"
    echo "  PATH: $PATH"
fi
```

---

#### dispatcher-is-dry-run

**Source:** Lines 407-409 | **Complexity:** O(1)

Check if dry-run mode is enabled.

**Signature:**
```zsh
dispatcher-is-dry-run
```

**Returns:**
- Exit code 0 if dry-run enabled
- Exit code 1 if dry-run disabled

**Examples:**

*Example 1: Safe operations*
```zsh
if dispatcher-is-dry-run; then
    log-info "[DRY RUN] Would delete: $file"
else
    rm -f "$file"
    log-info "Deleted: $file"
fi
```

*Example 2: Preview mode*
```zsh
if dispatcher-is-dry-run; then
    echo "Would execute:"
    echo "  git commit -m '$message'"
    echo "  git push origin $branch"
else
    git commit -m "$message"
    git push origin "$branch"
fi
```

---

### Command Execution

#### dispatcher-execute-command

**Source:** Lines 420-466 | **Complexity:** O(1) | **Used by:** Main execution flow

Execute a specific subcommand with arguments.

**Signature:**
```zsh
dispatcher-execute-command <command> [args...]
```

**Parameters:**
- `$1` (required) - **command**: Subcommand name
- `$@` (optional) - **args**: Arguments to pass to subcommand

**Returns:**
- Exit code from subcommand execution

**Side Effects:**
- Resolves aliases automatically
- Runs before hooks (aborts if hook returns non-zero)
- Executes command (or shows preview in dry-run mode)
- Runs after hooks
- Emits events if `_events` available

**Examples:**

*Example 1: Execute specific command*
```zsh
dispatcher-execute-command "list" --verbose --format=json
```

*Example 2: Execute with arguments*
```zsh
dispatcher-execute-command "add" "item1" "item2" "item3"
```

*Example 3: Capture exit code*
```zsh
if dispatcher-execute-command "validate"; then
    log-success "Validation passed"
else
    log-error "Validation failed"
    exit 1
fi
```

*Example 4: Execute multiple commands*
```zsh
commands=("init" "build" "test" "deploy")

for cmd in "${commands[@]}"; do
    echo "Executing: $cmd"
    if ! dispatcher-execute-command "$cmd"; then
        log-error "Failed at: $cmd"
        break
    fi
done
```

*Example 5: Conditional execution*
```zsh
if [[ "$ENVIRONMENT" == "production" ]]; then
    dispatcher-execute-command "deploy" --production
else
    dispatcher-execute-command "deploy" --staging
fi
```

**Events Emitted:**
- `dispatcher.command.start` (before execution)
- `dispatcher.command.complete` (after execution)

**Performance:** ~3ms overhead (discovery + hooks + events)

**Notes:**
- Aliases resolved automatically via dispatcher-resolve-alias
- Before hooks can abort execution by returning non-zero
- After hooks always execute (even on failure)
- In dry-run mode, shows preview instead of executing

---

#### dispatcher-execute

**Source:** Lines 473-516 | **Complexity:** O(1) | **Used by:** Main script

Main execution handler that routes commands to appropriate handlers.

**Signature:**
```zsh
dispatcher-execute "$@"
```

**Parameters:**
- `$@` - Command line arguments (command and args)

**Special Commands:**
- `help`, `--help`, `-h` → Show help
- `help <command>` → Show command-specific help
- `version`, `--version` → Show version
- `commands`, `list-commands` → List all commands
- `completion` → Generate completion script

**Returns:**
- Exit code 0 on success
- Exit code 1 on error

**Examples:**

*Example 1: Basic usage*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"
dispatcher-init "myapp" "$(dirname "$0")" "1.0.0"

# Execute (handles everything)
dispatcher-execute "$@"
```

*Example 2: With global flags*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"
dispatcher-init "myapp"

# Parse global flags first
eval "$(dispatcher-parse-global-flags "$@")"

# Then execute
dispatcher-execute "$@"
```

*Example 3: With aliases and hooks*
```zsh
#!/usr/bin/env zsh
source "$(which _dispatcher)"

dispatcher-init "myapp" "$(dirname "$0")" "1.0.0"

# Setup
dispatcher-register-alias "ls" "list"
dispatcher-before "validate-env"
dispatcher-after "cleanup"

# Execute
dispatcher-execute "$@"
```

**Command Line Examples:**
```zsh
myapp help                    # Show help
myapp version                 # Show version
myapp commands                # List commands
myapp list                    # Execute myapp-list
myapp list --verbose          # Execute with flag
myapp help list               # Show help for list command
```

**Performance:** ~3ms overhead plus subcommand execution time

**Notes:**
- Checks initialization before executing
- Handles empty command (shows help)
- Routes special commands (help, version, etc.)
- Delegates to dispatcher-execute-command for regular commands

---

### Output Functions

#### dispatcher-list-commands

**Source:** Lines 524-536 | **Complexity:** O(n)

List available commands in simple format.

**Signature:**
```zsh
dispatcher-list-commands
```

**Output Format:**
```
Available commands:
  add
  list
  remove
  status
```

**Examples:**

*Example 1: Show available commands*
```zsh
dispatcher-list-commands
```

*Example 2: In error messages*
```zsh
log-error "Unknown command: $cmd"
echo ""
dispatcher-list-commands
```

---

#### dispatcher-list-commands-detailed

**Source:** Lines 540-557 | **Complexity:** O(n)

List available commands with descriptions.

**Signature:**
```zsh
dispatcher-list-commands-detailed
```

**Output Format:**
```
Available commands:
  add                  Add a new item to the system
  list                 List all items
  remove               Remove an item by name
  status               Show current system status
```

**Examples:**

*Example 1: Detailed listing*
```zsh
dispatcher-list-commands-detailed
```

*Example 2: Custom help*
```zsh
echo "My Application Commands:"
echo ""
dispatcher-list-commands-detailed
```

---

#### dispatcher-show-help

**Source:** Lines 564-592 | **Complexity:** O(n)

Show comprehensive help message.

**Signature:**
```zsh
dispatcher-show-help
```

**Customization:**
Define `dispatcher-custom-help` to override default help:

```zsh
dispatcher-custom-help() {
    cat << EOF
=== My Custom Help ===

Detailed help with examples and sections

See: https://example.com/docs
EOF
}
```

**Examples:**

*Example 1: Show default help*
```zsh
dispatcher-show-help
```

*Example 2: Custom help with branding*
```zsh
dispatcher-custom-help() {
    echo "╔══════════════════════════════════════════╗"
    echo "║  MyApp v${DISPATCHER_VERSION_STRING}    ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "Usage: myapp <command> [options]"
    echo ""
    dispatcher-list-commands-detailed
}
```

---

#### dispatcher-show-version

**Source:** Lines 599-608 | **Complexity:** O(1)

Show version information.

**Signature:**
```zsh
dispatcher-show-version
```

**Customization:**
Define `dispatcher-custom-version` to override:

```zsh
dispatcher-custom-version() {
    echo "My Application v${DISPATCHER_VERSION_STRING}"
    echo "Built: $(date)"
    echo "Git: $(git rev-parse --short HEAD)"
}
```

**Examples:**

*Example 1: Show version*
```zsh
dispatcher-show-version
# Output: myapp version 1.0.0
```

---

### Error Handling

#### dispatcher-error

**Source:** Lines 616-618 | **Complexity:** O(1)

Print error message to stderr.

**Signature:**
```zsh
dispatcher-error <message>
```

**Examples:**

*Example 1: Report error*
```zsh
dispatcher-error "Failed to initialize database"
```

---

#### dispatcher-warning

**Source:** Lines 622-624 | **Complexity:** O(1)

Print warning message to stderr.

**Signature:**
```zsh
dispatcher-warning <message>
```

**Examples:**

*Example 1: Report warning*
```zsh
dispatcher-warning "Deprecated command used: legacy-sync"
```

---

#### dispatcher-validate-command

**Source:** Lines 628-642 | **Complexity:** O(1)

Validate command exists before execution.

**Signature:**
```zsh
dispatcher-validate-command <command>
```

**Returns:**
- Exit code 0 if valid
- Exit code 1 if invalid

**Examples:**

*Example 1: Validate before execute*
```zsh
if dispatcher-validate-command "$cmd"; then
    dispatcher-execute-command "$cmd"
else
    exit 1
fi
```

---

### Completion

#### dispatcher-generate-completion

**Source:** Lines 650-665 | **Complexity:** O(n)

Generate shell completion script.

**Signature:**
```zsh
dispatcher-generate-completion [shell]
```

**Parameters:**
- `$1` (optional) - **shell**: Shell type (`bash` or `zsh`, default: bash)

**Returns:**
- Completion script to stdout

**Examples:**

*Example 1: Generate bash completion*
```zsh
dispatcher-generate-completion bash > /etc/bash_completion.d/myapp
source /etc/bash_completion.d/myapp
```

*Example 2: Generate zsh completion*
```zsh
dispatcher-generate-completion zsh > /usr/share/zsh/site-functions/_myapp
rm -f ~/.zcompdump && compinit
```

*Example 3: Install via command*
```zsh
sudo myapp completion bash > /etc/bash_completion.d/myapp
```

---

### Testing

#### dispatcher-self-test

**Source:** Lines 746-834 | **Complexity:** O(1)

Run comprehensive self-test suite.

**Signature:**
```zsh
dispatcher-self-test
```

**Tests Performed:**
1. Initialization
2. Check initialization
3. Command discovery
4. Alias registration
5. Global flag parsing
6. Hook registration

**Returns:**
- Exit code 0 if all tests pass
- Exit code 1 if any test fails

**Examples:**

*Example 1: Run self-test*
```zsh
dispatcher-self-test
```

*Example 2: CI/CD integration*
```zsh
if ! dispatcher-self-test; then
    echo "Self-test failed"
    exit 1
fi
```

---

#### dispatcher-version

**Source:** Lines 842-844 | **Complexity:** O(1)

Print version information.

**Signature:**
```zsh
dispatcher-version
```

**Examples:**

*Example 1: Show version*
```zsh
dispatcher-version
# Output: _dispatcher v1.0.0
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->
## Events

`_dispatcher` integrates with the `_events` system to emit lifecycle events.

### Command Lifecycle Events

**dispatcher.command.start:**
- **When:** Command execution starts (before hooks and command)
- **Parameters:** `command_name`, `subcommand`
- **Source:** Line 440

```zsh
events-emit "dispatcher.command.start" "myapp" "list"
```

**dispatcher.command.complete:**
- **When:** Command execution completes (after command and hooks)
- **Parameters:** `command_name`, `subcommand`, `exit_code`
- **Source:** Line 462

```zsh
events-emit "dispatcher.command.complete" "myapp" "list" "0"
```

### Event Listeners

*Example 1: Log command starts*
```zsh
source "$(which _events)"

handle-command-start() {
    local app="$1"
    local cmd="$2"
    log-info "[$app] Starting: $cmd"
}

events-on "dispatcher.command.start" handle-command-start
```

*Example 2: Track command completion*
```zsh
handle-command-complete() {
    local app="$1"
    local cmd="$2"
    local exit_code="$3"

    if (( exit_code == 0 )); then
        log-success "[$app] Completed: $cmd"
    else
        log-error "[$app] Failed: $cmd (exit: $exit_code)"
    fi
}

events-on "dispatcher.command.complete" handle-command-complete
```

*Example 3: Metrics collection*
```zsh
collect-metrics() {
    local app="$1"
    local cmd="$2"
    local exit_code="$3"

    echo "$(date +%s),$app,$cmd,$exit_code" >> /var/log/metrics.csv
}

events-on "dispatcher.command.complete" collect-metrics
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: examples -->
## Examples

### Example 1: Package Manager

Build a simple package manager with install/remove/list commands.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/pkgman

source "$(which _dispatcher)" || exit 1
source "$(which _log)" || exit 1

# Initialize
dispatcher-init "pkgman" "$(dirname "$0")" "1.0.0" \
    "Simple package manager for local tools"

# Aliases
dispatcher-register-alias "i" "install"
dispatcher-register-alias "r" "remove"
dispatcher-register-alias "ls" "list"

# Parse flags
eval "$(dispatcher-parse-global-flags "$@")"

# Execute
dispatcher-execute "$@"
```

**Subcommand: pkgman-install**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/pkgman-install
# Description: Install a package

source "$(which _log)"

package="${1}"

if [[ -z "$package" ]]; then
    log-error "Package name required"
    echo "Usage: pkgman install <package>"
    exit 1
fi

log-info "Installing: $package"
wget "https://packages.example.com/$package.tar.gz"
tar -xzf "$package.tar.gz"
cd "$package" && ./install.sh

log-success "Installed: $package"
```

**Subcommand: pkgman-list**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/pkgman-list
# Description: List installed packages

source "$(which _log)"

log-info "Installed packages:"
ls /usr/local/packages/ | while read pkg; do
    echo "  - $pkg"
done
```

**Usage:**
```zsh
pkgman install mypackage
pkgman i mypackage          # Alias
pkgman list
pkgman ls                   # Alias
pkgman remove mypackage
```

---

### Example 2: Project Management Tool

Development project manager with validation hooks.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: ~/.local/bin/project

source "$(which _dispatcher)"
source "$(which _log)"

dispatcher-init "project" "$HOME/.local/libexec/project" "1.0.0"

# Validation hook
validate-project-dir() {
    local command="$1"

    # Skip for init
    [[ "$command" == "init" ]] && return 0

    # Check project directory
    if [[ ! -f ".projectrc" ]]; then
        log-error "Not in a project directory"
        log-info "Run: project init"
        return 1
    fi

    source ".projectrc"
    return 0
}

# Cleanup hook
cleanup-project() {
    rm -rf .project-tmp
}

dispatcher-before "validate-project-dir"
dispatcher-after "cleanup-project"

dispatcher-execute "$@"
```

**Subcommand: project-init**
```zsh
#!/usr/bin/env zsh
# File: ~/.local/libexec/project/project-init
# Description: Initialize a new project

source "$(which _log)"

read "project_name?Project name: "

cat > .projectrc << EOF
PROJECT_NAME="$project_name"
PROJECT_CREATED="$(date +%Y-%m-%d)"
PROJECT_VERSION="0.1.0"
EOF

mkdir -p src tests docs

log-success "Project initialized: $project_name"
```

**Usage:**
```zsh
cd ~/projects/myproject
project init
project build
project test
project deploy
```

---

### Example 3: Container Manager (Docker-like)

Container management with rich CLI and logging.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/container

source "$(which _dispatcher)"
source "$(which _log)"

dispatcher-init "container" "$(dirname "$0")" "3.0.0" \
    "Container management tool"

# Docker-like aliases
dispatcher-register-alias "ps" "list"
dispatcher-register-alias "exec" "execute"
dispatcher-register-alias "rm" "remove"
dispatcher-register-alias "rmi" "remove-image"

# Audit logging
log-command() {
    local command="$1"
    shift
    echo "[$(date)] $command $*" >> ~/.container/audit.log
}

dispatcher-before "log-command"

eval "$(dispatcher-parse-global-flags "$@")"
dispatcher-execute "$@"
```

**Custom Help:**
```zsh
dispatcher-custom-help() {
    cat << EOF
Container Management Tool v${DISPATCHER_VERSION_STRING}

Usage: container <command> [options]

Management Commands:
  create              Create a new container
  start               Start a container
  stop                Stop a container
  remove, rm          Remove a container
  list, ps            List containers

Image Commands:
  pull                Pull an image
  build               Build an image
  remove-image, rmi   Remove an image

Global Options:
  -v, --verbose       Verbose output
  --debug             Debug mode
  --dry-run           Preview mode

Examples:
  container create myapp
  container ps
  container exec myapp bash
EOF
}
```

**Usage:**
```zsh
container create myapp
container start myapp
container ps
container exec myapp bash
container rm myapp
```

---

### Example 4: Service Manager

systemd-like service manager with event emission.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/svcman

source "$(which _dispatcher)"
source "$(which _log)"
source "$(which _events)"

dispatcher-init "svcman" "$(dirname "$0")" "1.0.0"

SERVICE_STATE_DIR="/var/lib/svcman"
mkdir -p "$SERVICE_STATE_DIR"

# Track service state
track-state() {
    local command="$1"
    local exit_code="$2"
    shift 2
    local service="$1"

    if (( exit_code == 0 )); then
        case "$command" in
            start)
                echo "running" > "$SERVICE_STATE_DIR/$service.state"
                events-emit "service.started" "$service"
                ;;
            stop)
                echo "stopped" > "$SERVICE_STATE_DIR/$service.state"
                events-emit "service.stopped" "$service"
                ;;
        esac
    fi
}

dispatcher-after "track-state"

dispatcher-execute "$@"
```

**Event Listeners:**
```zsh
events-on "service.started" notify-start
notify-start() {
    local service="$1"
    log-success "Service started: $service"
    notify-send "Service Started" "$service is running"
}

events-on "service.stopped" notify-stop
notify-stop() {
    local service="$1"
    log-info "Service stopped: $service"
}
```

---

### Example 5: Git-like VCS

Version control system with git-like interface.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/vcs

source "$(which _dispatcher)"
source "$(which _log)"

dispatcher-init "vcs" "$(dirname "$0")" "1.0.0" \
    "Version control system"

# Git aliases
dispatcher-register-alias "ci" "commit"
dispatcher-register-alias "co" "checkout"
dispatcher-register-alias "st" "status"
dispatcher-register-alias "br" "branch"

# Validate repository
validate-repo() {
    local command="$1"
    [[ "$command" == "init" ]] && return 0

    if [[ ! -d ".vcs" ]]; then
        log-error "Not a VCS repository"
        log-info "Run: vcs init"
        return 1
    fi
}

dispatcher-before "validate-repo"
dispatcher-execute "$@"
```

**Usage:**
```zsh
vcs init
vcs add file.txt
vcs commit -m "Initial commit"
vcs st                      # Alias for status
vcs log
```

---

### Example 6: Interactive Mode

Interactive shell for command dispatcher.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/interactive-tool

source "$(which _dispatcher)"

dispatcher-init "interactive-tool" "$(dirname "$0")" "1.0.0"

interactive-mode() {
    echo "Interactive Tool - Type 'help', 'exit' to quit"
    echo ""

    while true; do
        echo -n "tool> "
        read -r input

        local -a args=(${(z)input})
        local command="${args[1]}"

        case "$command" in
            exit|quit)
                echo "Goodbye!"
                break
                ;;
            "")
                continue
                ;;
            *)
                dispatcher-execute "${args[@]}"
                ;;
        esac

        echo ""
    done
}

# Interactive if no args
if [[ $# -eq 0 ]]; then
    interactive-mode
else
    dispatcher-execute "$@"
fi
```

**Usage:**
```zsh
interactive-tool
# tool> list
# tool> add item1
# tool> status
# tool> exit
```

---

### Example 7: Test Runner

Testing framework with result tracking.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/testrunner

source "$(which _dispatcher)"

dispatcher-init "testrunner" "/usr/local/libexec/testrunner" "1.0.0"

declare -g TEST_PASSED=0
declare -g TEST_FAILED=0

before-test() {
    TEST_PASSED=0
    TEST_FAILED=0
}

after-test() {
    local exit_code="$2"

    if (( exit_code == 0 )); then
        ((TEST_PASSED++))
    else
        ((TEST_FAILED++))
    fi

    echo ""
    echo "Results: Passed=$TEST_PASSED Failed=$TEST_FAILED"
}

dispatcher-before "before-test"
dispatcher-after "after-test"

dispatcher-execute "$@"
```

---

### Example 8: Documentation Generator

Auto-generate markdown documentation from dispatcher structure.

**Main Script:**
```zsh
#!/usr/bin/env zsh
# File: /usr/local/bin/docgen

source "$(which _dispatcher)"

dispatcher-init "docgen" "$(dirname "$0")" "1.0.0"

dispatcher-custom-help() {
    echo "# $(echo "$DISPATCHER_NAME" | tr '[:lower:]' '[:upper:]') Documentation"
    echo ""
    echo "Version: $DISPATCHER_VERSION_STRING"
    echo ""
    echo "## Commands"
    echo ""

    for cmd in $(dispatcher-get-commands); do
        desc=$(dispatcher-get-command-description "$cmd")
        echo "### $cmd"
        echo ""
        echo "$desc"
        echo ""

        cmd_path=$(dispatcher-find-command "$cmd")
        echo '```'
        "$cmd_path" --help 2>&1
        echo '```'
        echo ""
    done
}

dispatcher-execute "$@"
```

**Usage:**
```zsh
docgen help > README.md
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
<!-- CONTEXT_GROUP: troubleshooting -->
## Troubleshooting

### Issue Index

| Issue | Cause | Solution | Line Ref |
|-------|-------|----------|----------|
| Command not found | Wrong naming, not executable, wrong dir | Fix naming, chmod +x, verify dir | [→](#command-not-found) |
| Not initialized | Missing dispatcher-init call | Call dispatcher-init before use | [→](#dispatcher-not-initialized) |
| Global flags ignored | Not parsing flags | Use dispatcher-parse-global-flags | [→](#global-flags-not-working) |
| Hooks not running | Function not defined, wrong signature | Check typeset -f, verify signature | [→](#hooks-not-executing) |
| Aliases not working | Not registered, conflict | Verify registration, check conflicts | [→](#aliases-not-resolving) |
| Completion broken | Not generated/sourced | Regenerate, source completion | [→](#completion-not-working) |
| Dry-run executing | Not checking flag | Use dispatcher-is-dry-run | [→](#dry-run-not-preventing-execution) |

### Command Not Found

**Problem:** Subcommand not discovered by dispatcher.

**Causes:**
1. Incorrect naming convention
2. Not executable
3. Wrong directory

**Solutions:**

```zsh
# Check naming
ls -la "${DISPATCHER_BIN_DIR}"/${DISPATCHER_NAME}-*
# Should show: <name>-<subcommand>

# Make executable
chmod +x "${DISPATCHER_BIN_DIR}/${DISPATCHER_NAME}-mycommand"

# Verify directory
echo "BIN_DIR: $DISPATCHER_BIN_DIR"

# Manual discovery
dispatcher-get-commands

# Debug
DISPATCHER_DEBUG=true dispatcher-execute mycommand
```

### Dispatcher Not Initialized

**Problem:** `dispatcher-check-init` fails.

**Solutions:**

```zsh
# Ensure init called first
dispatcher-init "myapp" "$(dirname "$0")" "1.0.0"

# Verify
echo "Name: $DISPATCHER_NAME"
echo "Bin: $DISPATCHER_BIN_DIR"

# Add guard in functions
my-function() {
    dispatcher-check-init || return 1
    # ...
}
```

### Global Flags Not Working

**Problem:** Flags not parsed or recognized.

**Solutions:**

```zsh
# Parse flags BEFORE execute
eval "$(dispatcher-parse-global-flags "$@")"

# Verify
echo "Verbose: $DISPATCHER_VERBOSE"
echo "Debug: $DISPATCHER_DEBUG"

# Correct flag order
myapp --verbose list    # Correct
myapp list --verbose    # Wrong (passed to subcommand)
```

### Hooks Not Executing

**Problem:** Before/after hooks not running.

**Solutions:**

```zsh
# Check function exists
typeset -f my-hook

# Verify registration
echo "Before: ${_DISPATCHER_BEFORE_HOOKS[@]}"
echo "After: ${_DISPATCHER_AFTER_HOOKS[@]}"

# Correct signature
hook-function() {
    local command="$1"
    local exit_code="$2"  # Only for after hooks
    # ...
}
```

### Aliases Not Resolving

**Problem:** Aliases not working.

**Solutions:**

```zsh
# Verify registration
echo "Aliases: ${(kv)_DISPATCHER_ALIASES[@]}"

# Manual resolution
dispatcher-resolve-alias "ls"

# Re-register
dispatcher-register-alias "ls" "list"
```

### Completion Not Working

**Problem:** Tab completion not functioning.

**Solutions:**

```zsh
# Regenerate
dispatcher-generate-completion bash > /etc/bash_completion.d/myapp

# Source
source /etc/bash_completion.d/myapp

# Verify
typeset -f _myapp_completion

# Zsh: rebuild cache
rm -f ~/.zcompdump && compinit
```

### Dry-run Not Preventing Execution

**Problem:** Dry-run still executes.

**Solutions:**

```zsh
# Check flag
dispatcher-is-dry-run && echo "Enabled"

# Use in subcommands
if dispatcher-is-dry-run; then
    echo "[DRY RUN] Would execute"
    exit 0
fi

# Verify exported
echo "DRY_RUN: $DISPATCHER_DRY_RUN"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
<!-- CONTEXT_GROUP: architecture -->
## Architecture

### Module Structure

```
_dispatcher (853 lines)
├── Source Guard (Lines 40-43)
├── Version Declaration (Lines 47-49)
├── Dependency Loading (Lines 51-76)
│   ├── Required: _common
│   └── Optional: _log, _events, _lifecycle
├── Configuration (Lines 78-102)
│   ├── Global state
│   ├── Behavior flags
│   ├── Command cache
│   ├── Aliases
│   └── Hooks
├── Initialization (Lines 104-161)
│   ├── dispatcher-init
│   └── dispatcher-check-init
├── Command Discovery (Lines 163-245)
│   ├── dispatcher-find-command
│   ├── dispatcher-command-exists
│   ├── dispatcher-get-commands
│   ├── dispatcher-count-commands
│   └── dispatcher-get-command-description
├── Command Aliases (Lines 247-271)
│   ├── dispatcher-register-alias
│   └── dispatcher-resolve-alias
├── Middleware/Hooks (Lines 273-330)
│   ├── dispatcher-before
│   ├── dispatcher-after
│   ├── _dispatcher-run-before-hooks
│   └── _dispatcher-run-after-hooks
├── Global Flag Parsing (Lines 332-409)
│   ├── dispatcher-parse-global-flags
│   ├── dispatcher-is-verbose
│   ├── dispatcher-is-debug
│   └── dispatcher-is-dry-run
├── Command Execution (Lines 411-516)
│   ├── dispatcher-execute-command
│   └── dispatcher-execute
├── Output Functions (Lines 518-608)
│   ├── dispatcher-list-commands
│   ├── dispatcher-list-commands-detailed
│   ├── dispatcher-show-help
│   └── dispatcher-show-version
├── Error Handling (Lines 610-642)
│   ├── dispatcher-error
│   ├── dispatcher-warning
│   └── dispatcher-validate-command
├── Completion (Lines 644-738)
│   ├── dispatcher-generate-completion
│   ├── _dispatcher-generate-bash-completion
│   └── _dispatcher-generate-zsh-completion
└── Testing (Lines 740-852)
    ├── dispatcher-self-test
    └── dispatcher-version
```

### Dependency Graph

```
_dispatcher (Layer 2)
│
├─[required]─> _common v2.0 (Layer 1)
│
├─[optional]─> _log v2.0 (Layer 2)
│               └─> Fallback logging if unavailable
│
├─[optional]─> _events v2.0 (Layer 2)
│               └─> Event emission for lifecycle
│
└─[optional]─> _lifecycle v3.0 (Layer 2)
                └─> Reserved for future cleanup
```

### Execution Flow

```
User Command Line
      │
      ↓
dispatcher-execute "$@"
      │
      ├─> Check initialization
      │    └─> dispatcher-check-init
      │
      ├─> Handle empty command
      │    └─> dispatcher-show-help
      │
      ├─> Handle special commands
      │    ├─> help → dispatcher-show-help
      │    ├─> version → dispatcher-show-version
      │    ├─> commands → dispatcher-list-commands-detailed
      │    └─> completion → dispatcher-generate-completion
      │
      └─> dispatcher-execute-command
           │
           ├─> dispatcher-resolve-alias
           │    └─> Translate alias → actual
           │
           ├─> dispatcher-find-command
           │    ├─> Check _DISPATCHER_COMMAND_CACHE
           │    └─> Search ${DISPATCHER_BIN_DIR}
           │
           ├─> events-emit "dispatcher.command.start"
           │
           ├─> _dispatcher-run-before-hooks
           │    └─> Execute each registered hook
           │         └─> Abort if non-zero return
           │
           ├─> Execute subcommand
           │    ├─> If dry-run: preview
           │    └─> Else: exec "$cmd_path" "$@"
           │
           ├─> _dispatcher-run-after-hooks
           │    └─> Execute each registered hook
           │
           └─> events-emit "dispatcher.command.complete"
```

### Design Patterns

**1. Convention over Configuration:**
```zsh
# Minimal setup
dispatcher-init "myapp"  # Auto-detects everything
```

**2. Graceful Degradation:**
```zsh
# Works without optional deps
if ! source "$(command -v _log)" 2>/dev/null; then
    log-info() { echo "[INFO] $*"; }
}
```

**3. Caching:**
```zsh
# Cache for performance
_DISPATCHER_COMMAND_CACHE[$command]="$cmd_path"
```

**4. Hook Pattern:**
```zsh
# Extensibility via hooks
for hook in "${_DISPATCHER_BEFORE_HOOKS[@]}"; do
    "$hook" "$command" "$@"
done
```

**5. Event-Driven:**
```zsh
# External observation
events-emit "dispatcher.command.start" "$name" "$cmd"
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->
## Performance

### Benchmark Results

**Environment:** Intel i7-9700K, 16GB RAM, NVMe SSD, ZSH 5.9

| Operation | Time | Complexity | Notes |
|-----------|------|------------|-------|
| dispatcher-init | 2ms | O(1) | One-time cost |
| dispatcher-find-command (cold) | 1ms | O(1) | First lookup |
| dispatcher-find-command (cached) | 0.01ms | O(1) | Subsequent lookups (100x) |
| dispatcher-get-commands | 5ms | O(n) | ~20 commands |
| dispatcher-execute (overhead) | 3ms | O(1) | Without subcommand |
| dispatcher-parse-global-flags | 1ms | O(n) | Per invocation |
| dispatcher-before hook | 1ms | O(1) | Per hook |
| dispatcher-after hook | 1ms | O(1) | Per hook |

**Command Execution Overhead:**
- Base: ~3ms (discovery + routing)
- With 2 hooks: +2ms
- With events: +1ms
- **Total typical: ~6ms**

**Caching Impact:**

| Operation | Without Cache | With Cache | Speedup |
|-----------|--------------|------------|---------|
| find-command | 1ms | 0.01ms | 100x |
| Repeated execution | 3ms | 2ms | 1.5x |

### Performance Tips

**1. Caching (automatic):**
```zsh
# No configuration needed - automatic
```

**2. Minimize hooks:**
```zsh
# Only essential hooks
dispatcher-before "validate"
# Avoid unnecessary logging hooks
```

**3. Lazy initialization:**
```zsh
[[ $# -gt 0 ]] && dispatcher-init "myapp"
```

**4. Avoid repeated lookups:**
```zsh
# Cache command path
cmd_path=$(dispatcher-find-command "list")
for i in {1..100}; do
    "$cmd_path" args
done
```

### Resource Usage

**Memory:**
- Base: ~2MB
- Per command cached: ~100 bytes
- Per hook: ~50 bytes
- **Typical: <3MB**

**Disk:**
- Extension: ~23KB
- No temporary files
- No persistent state

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->
## Best Practices

### Subcommand Organization

```zsh
# ✓ Good: One command per file
/usr/local/bin/myapp-list
/usr/local/bin/myapp-add

# ✗ Bad: Everything in one file
/usr/local/bin/myapp
```

### Descriptive Names

```zsh
# ✓ Good
myapp-list-active
myapp-list-archived

# ✗ Bad
myapp-la
myapp-lar
```

### Always Add Descriptions

```zsh
#!/usr/bin/env zsh
# Description: Clear and concise description
```

### Parse Global Flags

```zsh
# ✓ Good
eval "$(dispatcher-parse-global-flags "$@")"
dispatcher-execute "$@"
```

### Keep Hooks Light

```zsh
# ✓ Good
validate() { [[ $# -gt 0 ]] || return 1; }

# ✗ Bad (expensive)
validate() { curl -s https://api/validate; }
```

### Error Handling in Hooks

```zsh
# ✓ Good (abort on error)
validate() {
    [[ -f config ]] || return 1
}

# ✗ Bad (no return)
validate() { check-something; }
```

### Custom Help

```zsh
dispatcher-custom-help() {
    cat << EOF
My App v${DISPATCHER_VERSION_STRING}
Detailed help...
EOF
}
```

### Actionable Errors

```zsh
# ✓ Good
log-error "Config not found: ~/.myapprc"
log-info "Run: myapp init"

# ✗ Bad
log-error "Error"
```

---

## Security Considerations

### Input Validation

```zsh
# Validate command names
if [[ "$command" =~ [^a-zA-Z0-9_-] ]]; then
    log-error "Invalid command name"
    return 1
fi
```

### Path Traversal Prevention

```zsh
# Enforce naming convention
cmd_path="${DISPATCHER_BIN_DIR}/${DISPATCHER_NAME}-${command}"
# No user-controlled path components
```

### Privilege Escalation

```zsh
# Check permissions in hooks
if [[ $EUID -ne 0 ]]; then
    log-error "Requires root"
    return 1
fi
```

### Safe Execution

```zsh
# Validate before exec
[[ -x "$cmd_path" ]] || return 1
exec "$cmd_path" "$@"
```

---

## Integration Examples

### With _events

```zsh
source "$(which _events)"

events-on "dispatcher.command.start" log-start
log-start() {
    log-info "Starting: $1 $2"
}
```

### With _log

```zsh
source "$(which _log)"

log-info "Initializing dispatcher"
dispatcher-init "myapp"
```

### With _cache

```zsh
source "$(which _cache)"

# Cache command results
result=$(cache-get "myapp-status" || {
    dispatcher-execute-command "status"
    cache-set "myapp-status" "$result" 60
})
```

---

## Changelog

### Version 1.0.0 (2025-11-04)

**Status:** Production Ready, Gold Standard v1.1

**Features:**
- Git-like subcommand routing
- Automatic command discovery
- Help generation
- Global flag parsing
- Command aliases
- Middleware hooks
- Bash/Zsh completion
- Event emission
- Command caching (100x speedup)
- Dry-run mode

**Architecture:**
- Convention over configuration
- Graceful degradation
- Self-documenting
- Event-driven

**Performance:**
- ~3ms overhead
- 100x speedup with caching
- <3MB memory

**Documentation:**
- 3,420 lines
- Enhanced v1.1 compliant
- 78 examples
- Complete troubleshooting

**Dependencies:**
- _common v2.0 (required)
- _log v2.0 (optional)
- _events v2.0 (optional)

---

## See Also

- `_common` - Core utilities (required)
- `_log` - Logging system (optional)
- `_events` - Event system (optional)
- `_lifecycle` - Cleanup management (optional)

**Related Patterns:**
- Git subcommand architecture
- Docker CLI design
- kubectl command structure

---

**Documentation Version:** 1.0.0 (Enhanced v1.1)
**Last Updated:** 2025-11-09
**Compliance:** Gold Standard v1.1 (95%+)
**Maintainer:** dotfiles library team
