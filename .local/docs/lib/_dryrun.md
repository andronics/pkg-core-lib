# _dryrun - Dry-Run Mode Management Extension

**Lines:** 2,847 | **Functions:** 36 | **Examples:** 67 | **Source Lines:** 718
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_dryrun`

---

## Quick Access Index

### Compact References (Lines 10-280)
- [Function Reference](#function-quick-reference) - 36 functions mapped
- [Dry-Run Modes](#dry-run-modes-quick-reference) - 3 execution modes
- [Environment Variables](#environment-variables-quick-reference) - 4 variables
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 280-380, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 380-450, ~70 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 450-650, ~200 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 650-780, ~130 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 780-2300, ~1520 lines) ⚡ LARGE SECTION
- [Integration Patterns](#integration-patterns) (Lines 2300-2550, ~250 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2550-2750, ~200 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

**Mode Control Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-enable` | Enable dry-run mode globally | 119-127 | [→](#dryrun-enable) |
| `dryrun-disable` | Disable dry-run mode globally | 132-140 | [→](#dryrun-disable) |
| `dryrun-toggle` | Toggle dry-run mode on/off | 145-151 | [→](#dryrun-toggle) |
| `dryrun-is-enabled` | Check if dry-run mode is enabled | 156-158 | [→](#dryrun-is-enabled) |
| `dryrun-set-prefix` | Set custom dry-run message prefix | 164-171 | [→](#dryrun-set-prefix) |
| `dryrun-reset-prefix` | Reset prefix to default | 176-179 | [→](#dryrun-reset-prefix) |

**Execution Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-exec` | Execute command with dry-run awareness | 191-201 | [→](#dryrun-exec) |
| `dryrun-exec-silent` | Execute command silently (no dry-run message) | 208-215 | [→](#dryrun-exec-silent) |
| `dryrun-exec-message` | Execute with custom dry-run message | 220-233 | [→](#dryrun-exec-message) |
| `dryrun-when-live` | Execute only in live mode | 239-245 | [→](#dryrun-when-live) |
| `dryrun-when-dry` | Execute only in dry-run mode | 251-257 | [→](#dryrun-when-dry) |

**Message Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-message` | Print dry-run message | 267-272 | [→](#dryrun-message) |
| `dryrun-info` | Print informational dry-run message | 278-283 | [→](#dryrun-info) |
| `dryrun-warning` | Print warning dry-run message | 289-294 | [→](#dryrun-warning) |

**Scope Management:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-scope` | Execute commands in dry-run scope | 305-324 | [→](#dryrun-scope) |
| `dryrun-live-scope` | Execute commands in live scope | 331-348 | [→](#dryrun-live-scope) |

**File Operations:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-rm` | Remove file with dry-run awareness | 357-359 | [→](#dryrun-rm) |
| `dryrun-rm-rf` | Remove directory recursively | 364-366 | [→](#dryrun-rm-rf) |
| `dryrun-mv` | Move/rename file | 371-373 | [→](#dryrun-mv) |
| `dryrun-cp` | Copy file | 378-380 | [→](#dryrun-cp) |
| `dryrun-mkdir` | Create directory | 385-387 | [→](#dryrun-mkdir) |
| `dryrun-mkdir-p` | Create directory with parents | 392-394 | [→](#dryrun-mkdir-p) |
| `dryrun-touch` | Touch file (update timestamp) | 399-401 | [→](#dryrun-touch) |
| `dryrun-chmod` | Change file permissions | 406-408 | [→](#dryrun-chmod) |
| `dryrun-chown` | Change file ownership | 413-415 | [→](#dryrun-chown) |
| `dryrun-ln-s` | Create symbolic link | 420-422 | [→](#dryrun-ln-s) |

**Write Operations:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-write` | Write to file from stdin | 431-441 | [→](#dryrun-write) |
| `dryrun-append` | Append to file from stdin | 446-456 | [→](#dryrun-append) |

**System Operations:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-systemctl` | Execute systemctl with dry-run | 465-467 | [→](#dryrun-systemctl) |
| `dryrun-pacman` | Execute pacman with dry-run | 472-474 | [→](#dryrun-pacman) |
| `dryrun-git` | Execute git with dry-run | 479-481 | [→](#dryrun-git) |

**Conditional Execution:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-if` | Execute if condition is true | 491-500 | [→](#dryrun-if) |

**Batch Operations:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-batch` | Execute multiple commands sequentially | 510-522 | [→](#dryrun-batch) |
| `dryrun-batch-file` | Execute commands from file | 528-550 | [→](#dryrun-batch-file) |

**Confirmation Helpers:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-confirm` | Require confirmation (auto-yes in dry-run) | 560-573 | [→](#dryrun-confirm) |

**Status Display:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-status` | Show current dry-run status | 582-591 | [→](#dryrun-status) |
| `dryrun-indicator` | Get dry-run indicator string | 596-600 | [→](#dryrun-indicator) |

**Testing:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `dryrun-self-test` | Comprehensive self-test suite | 609-710 | [→](#dryrun-self-test) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `_dryrun-emit` | Emit event via _events (internal) | 108-110 | Internal |

---

## Dry-Run Modes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Mode | State | Behavior | Use Case |
|------|-------|----------|----------|
| **Live Mode** | `DRYRUN_ENABLED=false` | Commands execute normally | Production operations |
| **Dry-Run Mode** | `DRYRUN_ENABLED=true` | Commands are simulated, messages printed | Testing, validation, previews |
| **Mixed Mode** | Scoped execution | Temporary mode changes via scopes | Critical operations in dry-run context |

**Mode Transitions:**

```
       dryrun-enable
   ┌──────────────────────┐
   │                      │
   ▼                      │
LIVE ◄─────────────► DRY-RUN
        dryrun-disable
```

**Scope Behavior:**

```
Live Mode
  │
  ├─► dryrun-scope { ... }      ← Temporarily enables dry-run
  │     └─► dryrun-exec cmd     ← Simulated
  │   (scope exits)
  │
  └─► dryrun-exec cmd           ← Executes normally
```

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `DRYRUN_ENABLED` | boolean | `false` | Global dry-run mode state (exported) |
| `DRYRUN_PREFIX` | string | `[DRY-RUN]` | Prefix for dry-run messages |
| `_DRYRUN_SCOPE_LEVEL` | integer | `0` | Current scope nesting level (internal) |

**Optional Integration Variables:**

| Variable | Required By | Purpose |
|----------|-------------|---------|
| `_LOG_LOADED` | _log extension | Enhanced logging support |
| `_EVENTS_LOADED` | _events extension | Event emission on mode changes |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Constant | Meaning | Description | Common Functions |
|------|----------|---------|-------------|------------------|
| `0` | `DRYRUN_SUCCESS` | Success | Operation completed successfully | All functions |
| `1` | `DRYRUN_ERROR` | Error | File not found, invalid input | `dryrun-batch-file` |

**Special Return Behavior:**

- **Dry-Run Mode:** Most execution functions return `0` (simulated success)
- **Live Mode:** Functions return actual command exit status
- **Scope Functions:** Return wrapped command exit status in both modes

---

## Events Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | When Emitted | Data Parameters | Source Lines |
|-------|--------------|-----------------|--------------|
| `dryrun.enabled` | Dry-run mode enabled | None | 124 |
| `dryrun.disabled` | Dry-run mode disabled | None | 137 |
| `dryrun.exec` | Command executed/simulated | `"simulated"` or `"executed"`, command args | 194, 198 |
| `dryrun.scope.enter` | Entering dry-run scope | Scope level | 311 |
| `dryrun.scope.exit` | Exiting dry-run scope | Scope level | 318 |

**Event Subscription:**
```zsh
source "$(which _events)"
events-on "dryrun.enabled" my_handler_function
dryrun-enable  # Handler will be called
```

**Note:** Events are only emitted if `_events` extension is loaded. Graceful degradation occurs if unavailable.

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Overview

The `_dryrun` extension provides comprehensive dry-run mode management for ZSH scripts, enabling safe command simulation and preview-before-execute workflows. It offers a complete framework for testing destructive operations, generating execution previews, and validating scripts without side effects.

**Key Features:**

- **Global Mode Control** - Enable/disable dry-run mode for entire script execution
- **Execution Wrappers** - Automatic simulation of destructive commands
- **File Operations** - Complete set of dry-run aware file manipulation functions
- **System Integration** - Wrappers for systemctl, pacman, git, and more
- **Scoped Execution** - Temporarily enable/disable dry-run for specific operations
- **Custom Messages** - User-friendly dry-run output with customizable prefixes
- **Batch Processing** - Execute multiple commands or command files
- **Confirmation Helpers** - Interactive prompts with automatic dry-run bypass
- **Event Integration** - Optional event emission for mode changes
- **Zero Dependencies** - Pure ZSH implementation (optional integrations available)
- **Minimal Overhead** - ~0.1ms per operation in dry-run mode

**Design Philosophy:**

1. **Safety First** - Dry-run mode disabled by default (explicit opt-in)
2. **Transparency** - Clear indication of what would happen
3. **Composability** - Works with pipes, redirects, subshells, functions
4. **Consistency** - All functions follow `dryrun-*` naming convention
5. **Minimal Impact** - Zero overhead when disabled

**Layer Position:**

_dryrun is a **Layer 2 (Infrastructure)** extension:
- No dependencies on other Layer 2 extensions
- Depends only on Layer 1 (_common)
- Optional integration with _log and _events
- Used by Layer 3 and higher for safe execution

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

### Basic Installation

Load the extension in your script:

```zsh
# Standard loading (with error handling)
source "$(which _dryrun)" || {
    echo "Error: _dryrun extension not found" >&2
    exit 1
}

# From fixed path (if stowed)
source ~/.local/bin/lib/_dryrun

# With explicit sourcing guard
[[ -z "${_DRYRUN_LOADED}" ]] && source "$(which _dryrun)"
```

### Dependencies

**Required:**
- `_common` v2.0+ - Core utilities (loaded automatically)
- ZSH 5.0+ - Modern ZSH features

**Optional Integrations:**
- `_log` v2.0+ - Enhanced logging (auto-detected, graceful fallback)
- `_events` v2.0+ - Event emission (auto-detected, optional)

**System Requirements:**
- Pure ZSH implementation
- No external commands required
- Works in any POSIX environment

### Verification

```zsh
# Verify loading
source "$(which _dryrun)"
echo "Loaded: ${_DRYRUN_LOADED}"  # Should print: 1

# Check version
echo "Version: ${DRYRUN_VERSION}"  # Should print: 1.0.0

# Run self-test
dryrun-self-test
```

**Expected Output:**
```
=== Testing _dryrun v1.0.0 ===

[TEST] Initial state
  PASS
[TEST] Enable/disable operations
  PASS
[TEST] Toggle operation
  PASS
[TEST] Dry-run execution
  PASS
[TEST] Live execution
  PASS
[TEST] Scoped execution
  PASS
[TEST] Custom prefix
  PASS
[TEST] Conditional execution
  PASS
[TEST] Status display
  PASS
[TEST] Indicator
  PASS

=== All tests PASSED ===
_dryrun v1.0.0
```

### Integration Patterns

**With Argument Parsing:**
```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Support --dry-run flag
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            dryrun-enable
            shift
            ;;
        *)
            shift
            ;;
    esac
done
```

**With Environment Variables:**
```zsh
#!/usr/bin/env zsh
# Enable dry-run via environment
export DRYRUN_ENABLED=true
source "$(which _dryrun)"

# Or check environment flag
[[ "${DRY_RUN:-false}" == "true" ]] && dryrun-enable
```

**With CI/CD:**
```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Dry-run for pull requests, live for main
if [[ "$CI_EVENT_TYPE" == "pull_request" ]]; then
    dryrun-enable
    echo "Running in dry-run mode (PR validation)"
fi
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Quick Start

### Basic Dry-Run Mode

**Enable and Test:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Enable dry-run mode
dryrun-enable

# These commands will be simulated
dryrun-exec rm /tmp/important-file.txt
# Output: [DRY-RUN] Would execute: rm /tmp/important-file.txt

dryrun-exec mkdir /tmp/new-directory
# Output: [DRY-RUN] Would execute: mkdir /tmp/new-directory

# Check status
dryrun-status
# Output: Dry-run mode: ENABLED
#         Prefix: [DRY-RUN]
#         Scope level: 0

# Disable dry-run mode
dryrun-disable

# This command will execute for real
dryrun-exec echo "This runs live"
# Output: This runs live
```

### File Operations

**Safe File Manipulation:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Enable dry-run for testing
dryrun-enable

# File operations (all simulated)
dryrun-rm obsolete.txt
# Output: [DRY-RUN] Would execute: rm obsolete.txt

dryrun-mv old-name.txt new-name.txt
# Output: [DRY-RUN] Would execute: mv old-name.txt new-name.txt

dryrun-cp source.txt backup.txt
# Output: [DRY-RUN] Would execute: cp source.txt backup.txt

dryrun-mkdir-p /path/to/new/directory
# Output: [DRY-RUN] Would execute: mkdir -p /path/to/new/directory

dryrun-chmod 755 script.sh
# Output: [DRY-RUN] Would execute: chmod 755 script.sh

dryrun-ln-s /usr/bin/program /usr/local/bin/program
# Output: [DRY-RUN] Would execute: ln -s /usr/bin/program /usr/local/bin/program
```

### Custom Messages

**User-Friendly Output:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

dryrun-enable

# Custom message instead of raw command
dryrun-exec-message "Cleaning temporary files" rm -rf /tmp/*.tmp
# Output: [DRY-RUN] Cleaning temporary files

# Informational messages
dryrun-info "Processing batch 1 of 10"
# Output: [DRY-RUN] [INFO] Processing batch 1 of 10

# Warning messages
dryrun-warning "This operation is destructive"
# Output: [DRY-RUN] [WARNING] This operation is destructive

# Custom prefix
dryrun-set-prefix "[PREVIEW]"
dryrun-exec mkdir test
# Output: [PREVIEW] Would execute: mkdir test
```

### Scoped Dry-Run

**Temporary Mode Changes:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Start in live mode
echo "Running in live mode"

# Temporarily enable dry-run for preview
dryrun-scope {
    echo "Inside dry-run scope"
    dryrun-exec rm test-file.txt
    # Output: [DRY-RUN] Would execute: rm test-file.txt
}

# Back to live mode automatically
echo "Back in live mode"
dryrun-exec rm test-file.txt
# Actually removes test-file.txt
```

**Mixed Execution:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Enable dry-run globally
dryrun-enable

# Most operations are simulated
dryrun-exec rm file1.txt
# Output: [DRY-RUN] Would execute: rm file1.txt

# But logging must always happen
dryrun-live-scope {
    echo "Audit: Operation attempted at $(date)" >> audit.log
}

# Back to dry-run
dryrun-exec rm file2.txt
# Output: [DRY-RUN] Would execute: rm file2.txt
```

### Conditional Execution

**Mode-Specific Operations:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

dryrun-enable

# Execute only in dry-run mode
dryrun-when-dry echo "This is a preview"
# Output: This is a preview

# Execute only in live mode (skipped in dry-run)
dryrun-when-live send-notification "Operation complete"
# (nothing happens)

dryrun-disable

# Now live-only operations execute
dryrun-when-live send-notification "Operation complete"
# Sends notification
```

### Batch Operations

**Multiple Commands:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

dryrun-enable

# Execute multiple commands
dryrun-batch \
    "rm /tmp/file1.txt" \
    "mkdir /tmp/new-dir" \
    "touch /tmp/new-dir/marker.txt"
# Output: [DRY-RUN] Would execute: rm /tmp/file1.txt
#         [DRY-RUN] Would execute: mkdir /tmp/new-dir
#         [DRY-RUN] Would execute: touch /tmp/new-dir/marker.txt
```

**From File:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Create command file
cat > commands.txt <<'EOF'
# Cleanup operations
rm /tmp/*.tmp
rm /tmp/*.log

# Create directories
mkdir /tmp/processed
mkdir /tmp/archive
EOF

dryrun-enable
dryrun-batch-file commands.txt
# Output: [DRY-RUN] Would execute: rm /tmp/*.tmp
#         [DRY-RUN] Would execute: rm /tmp/*.log
#         [DRY-RUN] Would execute: mkdir /tmp/processed
#         [DRY-RUN] Would execute: mkdir /tmp/archive
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->
## Configuration

### Environment Variables

**Global State:**

```zsh
# Enable dry-run mode globally
export DRYRUN_ENABLED=true
source "$(which _dryrun)"

# Custom prefix
export DRYRUN_PREFIX="[SIMULATION]"
source "$(which _dryrun)"

# Check if dry-run is active
echo "Dry-run: ${DRYRUN_ENABLED}"  # true or false
```

**Runtime Configuration:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Change prefix at runtime
dryrun-set-prefix "[TEST-MODE]"
dryrun-enable
dryrun-exec rm file.txt
# Output: [TEST-MODE] Would execute: rm file.txt

# Reset to default
dryrun-reset-prefix
dryrun-exec mkdir dir
# Output: [DRY-RUN] Would execute: mkdir dir
```

### Script Argument Patterns

**Standard --dry-run Flag:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            dryrun-enable
            shift
            ;;
        --prefix)
            dryrun-set-prefix "$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Show status
dryrun-status
```

**Usage:**
```bash
./script.sh --dry-run               # Enable dry-run
./script.sh --dry-run --prefix "[PREVIEW]"  # Custom prefix
./script.sh                         # Live mode (default)
```

### Integration with Other Extensions

**With _log Extension:**

```zsh
#!/usr/bin/env zsh
source "$(which _log)"
source "$(which _dryrun)"

# _dryrun automatically uses log-* functions if available
dryrun-enable
dryrun-exec rm file.txt
# Uses log-info internally for output
```

**With _events Extension:**

```zsh
#!/usr/bin/env zsh
source "$(which _events)"
source "$(which _dryrun)"

# Subscribe to dry-run events
events-on "dryrun.enabled" 'echo "Dry-run mode activated"'
events-on "dryrun.disabled" 'echo "Live mode activated"'
events-on "dryrun.exec" 'echo "Command: $2 $3 $4"'

# Events fire automatically
dryrun-enable
# Output: Dry-run mode activated

dryrun-exec rm file.txt
# Output: Command: simulated rm file.txt
```

**Graceful Degradation:**

```zsh
#!/usr/bin/env zsh
# _dryrun works without _log and _events
# Automatically provides fallback implementations

source "$(which _dryrun)"
# Works perfectly, uses built-in logging
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## API Reference

<!-- CONTEXT_GROUP: mode-control -->
### Mode Control Functions (Lines 119-179)

All mode control functions for enabling, disabling, and checking dry-run state.

---

#### `dryrun-enable`

**Metadata:**
- **Lines:** 119-127 (9 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Used by:** All dry-run operations
- **Since:** v1.0.0

Enable dry-run mode globally.

**Syntax:**
```zsh
dryrun-enable
```

**Parameters:**
- None

**Returns:**
- `0` - Always (success)

**Side Effects:**
- Sets `DRYRUN_ENABLED=true`
- Exports variable to child processes
- Emits `dryrun.enabled` event (if _events loaded)
- Logs debug message (if _log loaded)

**Example:**
```zsh
dryrun-enable
dryrun-exec rm important-file.txt
# Output: [DRY-RUN] Would execute: rm important-file.txt
```

**Notes:**
- Mode persists across function calls
- Affects all subsequent `dryrun-exec` calls
- Can be disabled with `dryrun-disable`

---

#### `dryrun-disable`

**Metadata:**
- **Lines:** 132-140 (9 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Used by:** All dry-run operations
- **Since:** v1.0.0

Disable dry-run mode globally.

**Syntax:**
```zsh
dryrun-disable
```

**Parameters:**
- None

**Returns:**
- `0` - Always (success)

**Side Effects:**
- Sets `DRYRUN_ENABLED=false`
- Exports variable to child processes
- Emits `dryrun.disabled` event (if _events loaded)
- Logs debug message (if _log loaded)

**Example:**
```zsh
dryrun-disable
dryrun-exec rm important-file.txt
# Actually removes the file
```

**Notes:**
- Mode persists until changed
- All `dryrun-exec` calls will execute for real
- Default state after sourcing extension

---

#### `dryrun-toggle`

**Metadata:**
- **Lines:** 145-151 (7 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `dryrun-enable`, `dryrun-disable`
- **Used by:** Interactive scripts
- **Since:** v1.0.0

Toggle dry-run mode (enable if disabled, disable if enabled).

**Syntax:**
```zsh
dryrun-toggle
```

**Parameters:**
- None

**Returns:**
- `0` - Always (success)

**Example:**
```zsh
dryrun-enable
dryrun-toggle  # Now disabled
dryrun-toggle  # Now enabled again
```

**Notes:**
- Useful for interactive mode switching
- Calls `dryrun-enable` or `dryrun-disable` internally

---

#### `dryrun-is-enabled`

**Metadata:**
- **Lines:** 156-158 (3 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Used by:** All execution functions, user scripts
- **Since:** v1.0.0

Check if dry-run mode is currently enabled.

**Syntax:**
```zsh
dryrun-is-enabled
```

**Parameters:**
- None

**Returns:**
- `0` - Dry-run mode is enabled
- `1` - Dry-run mode is disabled

**Example:**
```zsh
if dryrun-is-enabled; then
    echo "Running in dry-run mode"
else
    echo "Running in live mode"
fi
```

**Notes:**
- Use in conditionals to branch logic
- Zero exit status means enabled (standard convention)
- Very low overhead (~0.01ms)

---

#### `dryrun-set-prefix`

**Metadata:**
- **Lines:** 164-171 (8 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Used by:** User customization
- **Since:** v1.0.0

Set custom prefix for dry-run messages.

**Syntax:**
```zsh
dryrun-set-prefix PREFIX
```

**Parameters:**
- `PREFIX` - New prefix string (required)

**Returns:**
- `0` - Success
- `1` - Error (missing prefix)

**Example:**
```zsh
dryrun-set-prefix "[PREVIEW]"
dryrun-enable
dryrun-exec rm file.txt
# Output: [PREVIEW] Would execute: rm file.txt

dryrun-set-prefix "🔍"
dryrun-exec mkdir dir
# Output: 🔍 Would execute: mkdir dir
```

**Notes:**
- Affects all subsequent dry-run messages
- Prefix can include color codes
- Does not affect message content, only prefix

---

#### `dryrun-reset-prefix`

**Metadata:**
- **Lines:** 176-179 (4 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Used by:** User customization
- **Since:** v1.0.0

Reset prefix to default value.

**Syntax:**
```zsh
dryrun-reset-prefix
```

**Parameters:**
- None

**Returns:**
- `0` - Always (success)

**Example:**
```zsh
dryrun-set-prefix "[CUSTOM]"
dryrun-reset-prefix
echo "Prefix: $DRYRUN_PREFIX"
# Output: Prefix: [DRY-RUN]
```

**Notes:**
- Default prefix is `[DRY-RUN]`
- Defined in `DRYRUN_DEFAULT_PREFIX` constant

---

<!-- CONTEXT_GROUP: execution -->
### Execution Functions (Lines 191-257)

Core functions for executing commands with dry-run awareness.

---

#### `dryrun-exec`

**Metadata:**
- **Lines:** 191-201 (11 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `log-info`, `log-debug`, `_dryrun-emit`
- **Used by:** All operation wrappers, user scripts
- **Since:** v1.0.0
- **Performance:** ~0.1ms overhead in dry-run mode

Execute command with automatic dry-run checking.

**Syntax:**
```zsh
dryrun-exec COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute or simulate
- `ARGS` - Command arguments (optional, preserved as-is)

**Returns:**
- `0` - In dry-run mode (simulated success)
- Command exit status - In live mode

**Side Effects:**
- **Dry-run mode:** Prints message to stderr, emits event
- **Live mode:** Executes command, emits event

**Example:**
```zsh
dryrun-enable
dryrun-exec rm -rf /tmp/test
# Output: [DRY-RUN] Would execute: rm -rf /tmp/test
# Returns: 0

dryrun-disable
dryrun-exec rm -rf /tmp/test
# Actually executes: rm -rf /tmp/test
# Returns: command exit status
```

**Advanced Usage:**

```zsh
# Capture exit status
if dryrun-exec test-command arg1 arg2; then
    echo "Success (or simulated success)"
else
    echo "Failure"
fi

# With output capture (live mode only)
output=$(dryrun-exec echo "Hello")
echo "Output: $output"  # Empty in dry-run, "Hello" in live

# Complex commands
dryrun-exec sh -c 'echo "Line 1"; echo "Line 2"'
```

**Notes:**
- Core function for dry-run infrastructure
- All wrapper functions use this internally
- Simulates success (returns 0) in dry-run mode
- Actual command is never invoked in dry-run mode
- Messages go to stderr (preserves stdout for data)

---

#### `dryrun-exec-silent`

**Metadata:**
- **Lines:** 208-215 (8 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`
- **Used by:** Internal operations, quiet wrappers
- **Since:** v1.0.0

Execute command silently (no dry-run message).

**Syntax:**
```zsh
dryrun-exec-silent COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute or skip
- `ARGS` - Command arguments (optional)

**Returns:**
- `0` - In dry-run mode (always)
- Command exit status - In live mode

**Example:**
```zsh
dryrun-enable

# Silent operation (no output)
dryrun-exec-silent internal-helper-function
dryrun-exec-silent log-debug "Internal message"

# No dry-run messages printed
```

**Use Cases:**
- Internal operations that don't need user visibility
- Helper functions in dry-run aware libraries
- Operations with their own logging
- Avoiding message pollution

**Notes:**
- Still respects dry-run mode (won't execute)
- No stderr output in dry-run mode
- No event emission
- Lower overhead than `dryrun-exec`

---

#### `dryrun-exec-message`

**Metadata:**
- **Lines:** 220-233 (14 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `log-info`, `log-debug`, `_dryrun-emit`
- **Used by:** User-facing operations
- **Since:** v1.0.0

Execute command with custom dry-run message.

**Syntax:**
```zsh
dryrun-exec-message MESSAGE COMMAND [ARGS...]
```

**Parameters:**
- `MESSAGE` - Custom message for dry-run output (required)
- `COMMAND` - Command to execute or simulate
- `ARGS` - Command arguments (optional)

**Returns:**
- `0` - In dry-run mode (simulated success)
- Command exit status - In live mode

**Example:**
```zsh
dryrun-enable

# User-friendly message
dryrun-exec-message "Removing backup files" rm -rf *.backup
# Output: [DRY-RUN] Removing backup files

dryrun-exec-message "Restarting web server" systemctl restart nginx
# Output: [DRY-RUN] Restarting web server

# With variables
count=42
dryrun-exec-message "Processing $count files" process-files
# Output: [DRY-RUN] Processing 42 files
```

**Notes:**
- Message replaces default "Would execute: ..." format
- Actual command still executes in live mode
- Use for user-friendly, high-level operations
- Message can include variables, command substitution

---

#### `dryrun-when-live`

**Metadata:**
- **Lines:** 239-245 (7 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`
- **Used by:** Logging, metrics, notifications
- **Since:** v1.0.0

Execute command only if NOT in dry-run mode.

**Syntax:**
```zsh
dryrun-when-live COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute
- `ARGS` - Command arguments (optional)

**Returns:**
- `0` - In dry-run mode (no-op)
- Command exit status - In live mode

**Example:**
```zsh
dryrun-enable

# Never executes in dry-run
dryrun-when-live send-email "Deployment complete"
dryrun-when-live update-database
dryrun-when-live post-metrics

dryrun-disable

# Now executes
dryrun-when-live send-email "Deployment complete"
```

**Use Cases:**
- Operations that shouldn't be simulated
- Side effects: logging, metrics, notifications
- Database updates in test scripts
- External API calls

**Notes:**
- Silent in dry-run mode (no messages)
- No event emission
- Use for operations with real-world side effects

---

#### `dryrun-when-dry`

**Metadata:**
- **Lines:** 251-257 (7 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`
- **Used by:** Validation, preview generation
- **Since:** v1.0.0

Execute command only if in dry-run mode.

**Syntax:**
```zsh
dryrun-when-dry COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute
- `ARGS` - Command arguments (optional)

**Returns:**
- Command exit status - In dry-run mode
- `0` - In live mode (no-op)

**Example:**
```zsh
dryrun-enable

# Only executes in dry-run
dryrun-when-dry echo "This is a preview"
# Output: This is a preview

dryrun-when-dry validate-config
dryrun-when-dry generate-preview-html

dryrun-disable

# No longer executes
dryrun-when-dry echo "This won't print"
```

**Use Cases:**
- Dry-run specific validation
- Preview generation
- Test harness setup
- Simulation-only output

**Notes:**
- Use for operations that only make sense in dry-run
- Inverse of `dryrun-when-live`

---

<!-- CONTEXT_GROUP: messaging -->
### Message Functions (Lines 267-294)

Functions for printing dry-run specific messages.

---

#### `dryrun-message`

**Metadata:**
- **Lines:** 267-272 (6 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `log-info`
- **Used by:** User scripts, progress reporting
- **Since:** v1.0.0

Print message only in dry-run mode.

**Syntax:**
```zsh
dryrun-message MESSAGE [ARGS...]
```

**Parameters:**
- `MESSAGE` - Message to print
- `ARGS` - Additional message components (optional)

**Returns:**
- `0` - Always (success)

**Example:**
```zsh
dryrun-enable

dryrun-message "Processing item 1 of 10"
# Output: [DRY-RUN] Processing item 1 of 10

dryrun-message "Current directory: $(pwd)"
# Output: [DRY-RUN] Current directory: /home/user

dryrun-disable
dryrun-message "This won't print"
# (no output)
```

**Notes:**
- Only prints in dry-run mode
- Silent in live mode
- Use for progress/status messages during simulation

---

#### `dryrun-info`

**Metadata:**
- **Lines:** 278-283 (6 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `log-info`
- **Used by:** Informational output
- **Since:** v1.0.0

Print informational dry-run message.

**Syntax:**
```zsh
dryrun-info MESSAGE [ARGS...]
```

**Parameters:**
- `MESSAGE` - Information message
- `ARGS` - Additional message components (optional)

**Returns:**
- `0` - Always (success)

**Example:**
```zsh
dryrun-enable

dryrun-info "Files to process: ${#files[@]}"
# Output: [DRY-RUN] [INFO] Files to process: 42

dryrun-info "Estimated time: 5 minutes"
# Output: [DRY-RUN] [INFO] Estimated time: 5 minutes
```

**Notes:**
- Adds `[INFO]` tag to output
- Only prints in dry-run mode

---

#### `dryrun-warning`

**Metadata:**
- **Lines:** 289-294 (6 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `log-warning`
- **Used by:** Warning output
- **Since:** v1.0.0

Print warning dry-run message.

**Syntax:**
```zsh
dryrun-warning MESSAGE [ARGS...]
```

**Parameters:**
- `MESSAGE` - Warning message
- `ARGS` - Additional message components (optional)

**Returns:**
- `0` - Always (success)

**Example:**
```zsh
dryrun-enable

dryrun-warning "This operation is destructive"
# Output: [DRY-RUN] [WARNING] This operation is destructive

dryrun-warning "No backups found"
# Output: [DRY-RUN] [WARNING] No backups found
```

**Notes:**
- Adds `[WARNING]` tag to output
- Only prints in dry-run mode
- Uses `log-warning` for color/formatting if available

---

<!-- CONTEXT_GROUP: scopes -->
### Scope Management (Lines 305-348)

Functions for temporary mode changes with automatic restoration.

---

#### `dryrun-scope`

**Metadata:**
- **Lines:** 305-324 (20 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-is-enabled`, `dryrun-enable`, `dryrun-disable`, `_dryrun-emit`
- **Used by:** Preview workflows, validation
- **Since:** v1.0.0
- **Performance:** ~0.2ms overhead per scope

Execute commands in dry-run scope (temporarily enable).

**Syntax:**
```zsh
dryrun-scope COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute in dry-run mode
- `ARGS` - Command arguments (optional)

**Returns:**
- Command exit status (preserved from wrapped command)

**Side Effects:**
- Temporarily enables dry-run mode
- Increments scope nesting level
- Emits scope enter/exit events
- Restores previous dry-run state after execution

**Example:**
```zsh
# Start in live mode
dryrun-is-enabled || echo "Live mode"

# Temporarily enable dry-run
dryrun-scope {
    echo "Inside dry-run scope"
    dryrun-exec rm test-file.txt
    # Output: [DRY-RUN] Would execute: rm test-file.txt
}

# Back to live mode
dryrun-is-enabled || echo "Still live mode"
```

**Advanced Usage:**

```zsh
# Nested scopes
dryrun-scope {
    echo "Outer scope (dry-run)"
    dryrun-exec rm file1.txt

    dryrun-live-scope {
        echo "Inner scope (live)"
        dryrun-exec rm file2.txt  # Actually executes
    }

    echo "Back to outer scope (dry-run)"
    dryrun-exec rm file3.txt  # Simulated
}

# With functions
preview_operations() {
    dryrun-exec rm obsolete.txt
    dryrun-exec mkdir new-dir
}

dryrun-scope preview_operations
# All operations in function are simulated
```

**Notes:**
- Preserves previous state (live or dry-run)
- Can be nested safely (tracks nesting level)
- Scope exit restores exact previous state
- Use for preview-before-execute patterns

---

#### `dryrun-live-scope`

**Metadata:**
- **Lines:** 331-348 (18 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-is-enabled`, `dryrun-enable`, `dryrun-disable`
- **Used by:** Critical operations in dry-run context
- **Since:** v1.0.0

Execute commands in live scope (temporarily disable dry-run).

**Syntax:**
```zsh
dryrun-live-scope COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - Command to execute in live mode
- `ARGS` - Command arguments (optional)

**Returns:**
- Command exit status (preserved from wrapped command)

**Side Effects:**
- Temporarily disables dry-run mode
- Increments scope nesting level
- Restores previous dry-run state after execution

**Example:**
```zsh
dryrun-enable

# Most operations are simulated
dryrun-exec rm file1.txt
# Output: [DRY-RUN] Would execute: rm file1.txt

# But logging must always happen
dryrun-live-scope {
    echo "Audit: Operation attempted at $(date)" >> audit.log
}

# Back to dry-run
dryrun-exec rm file2.txt
# Output: [DRY-RUN] Would execute: rm file2.txt
```

**Use Cases:**
- Logging in dry-run mode
- Metrics collection
- Audit trail generation
- Operations that must always execute

**Notes:**
- Inverse of `dryrun-scope`
- Preserves previous state
- Use for operations with necessary side effects

---

<!-- CONTEXT_GROUP: file-operations -->
### File Operations (Lines 357-422)

Dry-run aware wrappers for common file operations.

---

#### `dryrun-rm`

**Metadata:**
- **Lines:** 357-359 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Remove file with dry-run awareness.

**Syntax:**
```zsh
dryrun-rm FILE [FILES...]
```

**Parameters:**
- `FILE` - File(s) to remove
- Additional files accepted

**Returns:**
- `0` - In dry-run mode
- `rm` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-rm obsolete.txt old-data.csv
# Output: [DRY-RUN] Would execute: rm obsolete.txt old-data.csv
```

---

#### `dryrun-rm-rf`

**Metadata:**
- **Lines:** 364-366 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Remove directory recursively with dry-run awareness.

**Syntax:**
```zsh
dryrun-rm-rf PATH [PATHS...]
```

**Parameters:**
- `PATH` - Directory/file path(s) to remove

**Returns:**
- `0` - In dry-run mode
- `rm` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-rm-rf /tmp/old-data /var/cache/app
# Output: [DRY-RUN] Would execute: rm -rf /tmp/old-data /var/cache/app
```

**Warning:**
- Very destructive operation
- Use dry-run mode for testing
- Consider `dryrun-confirm` before execution

---

#### `dryrun-mv`

**Metadata:**
- **Lines:** 371-373 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Move/rename file with dry-run awareness.

**Syntax:**
```zsh
dryrun-mv SOURCE DEST
```

**Parameters:**
- `SOURCE` - Source file/directory
- `DEST` - Destination path

**Returns:**
- `0` - In dry-run mode
- `mv` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-mv old-name.txt new-name.txt
# Output: [DRY-RUN] Would execute: mv old-name.txt new-name.txt
```

---

#### `dryrun-cp`

**Metadata:**
- **Lines:** 378-380 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Copy file with dry-run awareness.

**Syntax:**
```zsh
dryrun-cp [OPTIONS] SOURCE DEST
```

**Parameters:**
- `OPTIONS` - Optional cp flags (e.g., -r, -a)
- `SOURCE` - Source file/directory
- `DEST` - Destination path

**Returns:**
- `0` - In dry-run mode
- `cp` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-cp -r source-dir backup-dir
# Output: [DRY-RUN] Would execute: cp -r source-dir backup-dir
```

---

#### `dryrun-mkdir`

**Metadata:**
- **Lines:** 385-387 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Create directory with dry-run awareness.

**Syntax:**
```zsh
dryrun-mkdir DIRECTORY [DIRECTORIES...]
```

**Parameters:**
- `DIRECTORY` - Directory path(s) to create

**Returns:**
- `0` - In dry-run mode
- `mkdir` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-mkdir new-dir another-dir
# Output: [DRY-RUN] Would execute: mkdir new-dir another-dir
```

---

#### `dryrun-mkdir-p`

**Metadata:**
- **Lines:** 392-394 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Create directory with parents.

**Syntax:**
```zsh
dryrun-mkdir-p PATH
```

**Parameters:**
- `PATH` - Directory path to create (with parents)

**Returns:**
- `0` - In dry-run mode
- `mkdir` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-mkdir-p /path/to/nested/directory
# Output: [DRY-RUN] Would execute: mkdir -p /path/to/nested/directory
```

---

#### `dryrun-touch`

**Metadata:**
- **Lines:** 399-401 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Touch file (update timestamp or create).

**Syntax:**
```zsh
dryrun-touch FILE [FILES...]
```

**Parameters:**
- `FILE` - File(s) to touch

**Returns:**
- `0` - In dry-run mode
- `touch` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-touch new-file.txt marker.flag
# Output: [DRY-RUN] Would execute: touch new-file.txt marker.flag
```

---

#### `dryrun-chmod`

**Metadata:**
- **Lines:** 406-408 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Change file permissions.

**Syntax:**
```zsh
dryrun-chmod MODE FILE [FILES...]
```

**Parameters:**
- `MODE` - Permission mode (e.g., 755, u+x)
- `FILE` - File(s) to modify

**Returns:**
- `0` - In dry-run mode
- `chmod` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-chmod 755 script.sh
# Output: [DRY-RUN] Would execute: chmod 755 script.sh

dryrun-chmod u+x,go-w file.sh
# Output: [DRY-RUN] Would execute: chmod u+x,go-w file.sh
```

---

#### `dryrun-chown`

**Metadata:**
- **Lines:** 413-415 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Change file ownership.

**Syntax:**
```zsh
dryrun-chown OWNER[:GROUP] FILE [FILES...]
```

**Parameters:**
- `OWNER[:GROUP]` - New owner and optional group
- `FILE` - File(s) to modify

**Returns:**
- `0` - In dry-run mode
- `chown` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-chown user:group file.txt
# Output: [DRY-RUN] Would execute: chown user:group file.txt

dryrun-chown root config.conf
# Output: [DRY-RUN] Would execute: chown root config.conf
```

---

#### `dryrun-ln-s`

**Metadata:**
- **Lines:** 420-422 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Create symbolic link.

**Syntax:**
```zsh
dryrun-ln-s TARGET LINK
```

**Parameters:**
- `TARGET` - Link target
- `LINK` - Link name

**Returns:**
- `0` - In dry-run mode
- `ln` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-ln-s /usr/bin/app /usr/local/bin/app
# Output: [DRY-RUN] Would execute: ln -s /usr/bin/app /usr/local/bin/app
```

---

<!-- CONTEXT_GROUP: write-operations -->
### Write Operations (Lines 431-456)

Functions for writing and appending to files with dry-run awareness.

---

#### `dryrun-write`

**Metadata:**
- **Lines:** 431-441 (11 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-is-enabled`, `log-info`
- **Used by:** File generation, output redirection
- **Since:** v1.0.0

Write to file with dry-run awareness.

**Syntax:**
```zsh
COMMAND | dryrun-write FILE
```

**Parameters:**
- `FILE` - Output file path (required)
- stdin - Content to write

**Returns:**
- `0` - Both modes (always consumes stdin)

**Side Effects:**
- **Dry-run mode:** Consumes stdin to /dev/null, prints message
- **Live mode:** Writes stdin to file

**Example:**
```zsh
dryrun-enable

echo "content" | dryrun-write output.txt
# Output: [DRY-RUN] Would write to: output.txt
# stdin is consumed (discarded)

cat largefile.txt | dryrun-write processed.txt
# Output: [DRY-RUN] Would write to: processed.txt
# File is read but not written
```

**Important Notes:**
- **Always consumes stdin** (prevents pipeline breakage)
- In dry-run: stdin goes to /dev/null
- In live mode: stdin goes to file
- Use with pipes and redirects

**Advanced Usage:**

```zsh
# Preserve data in dry-run with tee
echo "important data" | tee /tmp/backup.txt | dryrun-write output.txt

# Generate content
generate-report | dryrun-write report.html

# Multi-line content
cat <<'EOF' | dryrun-write config.json
{
  "key": "value"
}
EOF
```

---

#### `dryrun-append`

**Metadata:**
- **Lines:** 446-456 (11 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-is-enabled`, `log-info`
- **Used by:** Log appending, incremental writes
- **Since:** v1.0.0

Append to file with dry-run awareness.

**Syntax:**
```zsh
COMMAND | dryrun-append FILE
```

**Parameters:**
- `FILE` - Output file path (required)
- stdin - Content to append

**Returns:**
- `0` - Both modes (always consumes stdin)

**Side Effects:**
- **Dry-run mode:** Consumes stdin to /dev/null, prints message
- **Live mode:** Appends stdin to file

**Example:**
```zsh
dryrun-enable

echo "new line" | dryrun-append log.txt
# Output: [DRY-RUN] Would append to: log.txt

date | dryrun-append timestamps.log
# Output: [DRY-RUN] Would append to: timestamps.log
```

**Notes:**
- Same stdin consumption behavior as `dryrun-write`
- Uses `>>` redirection in live mode
- Safe for incremental log writing

---

<!-- CONTEXT_GROUP: system-operations -->
### System Operations (Lines 465-481)

Wrappers for common system commands.

---

#### `dryrun-systemctl`

**Metadata:**
- **Lines:** 465-467 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Execute systemctl command with dry-run awareness.

**Syntax:**
```zsh
dryrun-systemctl ACTION SERVICE [OPTIONS]
```

**Parameters:**
- `ACTION` - systemctl action (start, stop, restart, etc.)
- `SERVICE` - Service name
- `OPTIONS` - Additional options (optional)

**Returns:**
- `0` - In dry-run mode
- `systemctl` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-systemctl start nginx
# Output: [DRY-RUN] Would execute: systemctl start nginx

dryrun-systemctl restart postgresql.service
# Output: [DRY-RUN] Would execute: systemctl restart postgresql.service

dryrun-systemctl --user enable mpd
# Output: [DRY-RUN] Would execute: systemctl --user enable mpd
```

**Use Cases:**
- Service management testing
- Deployment script validation
- System configuration dry-runs

---

#### `dryrun-pacman`

**Metadata:**
- **Lines:** 472-474 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Execute pacman command with dry-run awareness.

**Syntax:**
```zsh
dryrun-pacman OPTIONS PACKAGES
```

**Parameters:**
- `OPTIONS` - pacman flags (-S, -R, etc.)
- `PACKAGES` - Package names

**Returns:**
- `0` - In dry-run mode
- `pacman` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-pacman -S neovim
# Output: [DRY-RUN] Would execute: pacman -S neovim

dryrun-pacman -R old-package
# Output: [DRY-RUN] Would execute: pacman -R old-package

dryrun-pacman -Syu
# Output: [DRY-RUN] Would execute: pacman -Syu
```

**Notes:**
- Arch Linux package manager wrapper
- Useful for package installation scripts
- Consider using with `dryrun-confirm`

---

#### `dryrun-git`

**Metadata:**
- **Lines:** 479-481 (3 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-exec`
- **Since:** v1.0.0

Execute git command with dry-run awareness.

**Syntax:**
```zsh
dryrun-git COMMAND [ARGS...]
```

**Parameters:**
- `COMMAND` - git command
- `ARGS` - Command arguments

**Returns:**
- `0` - In dry-run mode
- `git` exit status - In live mode

**Example:**
```zsh
dryrun-enable
dryrun-git add .
# Output: [DRY-RUN] Would execute: git add .

dryrun-git commit -m "Update files"
# Output: [DRY-RUN] Would execute: git commit -m "Update files"

dryrun-git push origin main
# Output: [DRY-RUN] Would execute: git push origin main
```

**Use Cases:**
- Git automation testing
- Deployment script validation
- Repository management dry-runs

---

<!-- CONTEXT_GROUP: conditional -->
### Conditional Execution (Lines 491-500)

Conditional command execution with dry-run awareness.

---

#### `dryrun-if`

**Metadata:**
- **Lines:** 491-500 (10 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-exec`
- **Used by:** Conditional operations
- **Since:** v1.0.0

Execute command if condition is true (with dry-run awareness).

**Syntax:**
```zsh
dryrun-if CONDITION COMMAND [ARGS...]
```

**Parameters:**
- `CONDITION` - Shell expression to evaluate (string)
- `COMMAND` - Command to execute if true
- `ARGS` - Command arguments (optional)

**Returns:**
- `0` - If condition false
- `dryrun-exec` result - If condition true

**Example:**
```zsh
dryrun-enable

# Test file existence
dryrun-if "[[ -f config.json ]]" rm config.json
# If file exists: [DRY-RUN] Would execute: rm config.json

# Test command success
dryrun-if "grep -q error log.txt" send-alert
# If grep succeeds: [DRY-RUN] Would execute: send-alert

# Complex conditions
dryrun-if "[[ $count -gt 10 ]]" process-large-batch
```

**Notes:**
- Condition is evaluated in live mode (always)
- Command respects dry-run mode
- Use shell test syntax in condition string
- Errors in condition are silently ignored (returns false)

---

<!-- CONTEXT_GROUP: batch -->
### Batch Operations (Lines 510-550)

Execute multiple commands sequentially.

---

#### `dryrun-batch`

**Metadata:**
- **Lines:** 510-522 (13 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-exec`, `log-error`
- **Used by:** Multi-step operations
- **Since:** v1.0.0

Execute multiple commands sequentially.

**Syntax:**
```zsh
dryrun-batch CMD1 CMD2 CMD3 ...
```

**Parameters:**
- Each parameter is a command string to execute

**Returns:**
- `0` - All commands succeed
- `1` - Any command fails (continues execution)

**Example:**
```zsh
dryrun-enable

dryrun-batch \
    "rm /tmp/*.tmp" \
    "mkdir /tmp/new" \
    "touch /tmp/new/file"
# Output: [DRY-RUN] Would execute: rm /tmp/*.tmp
#         [DRY-RUN] Would execute: mkdir /tmp/new
#         [DRY-RUN] Would execute: touch /tmp/new/file
```

**Advanced Usage:**

```zsh
# With variables
files=("file1.txt" "file2.txt" "file3.txt")
dryrun-batch \
    "rm ${files[1]}" \
    "rm ${files[2]}" \
    "rm ${files[3]}"

# Complex commands
dryrun-batch \
    "find /tmp -name '*.tmp' -delete" \
    "tar czf backup.tar.gz /data" \
    "rsync -av /data/ remote:/backup/"
```

**Notes:**
- Each command is evaluated via `eval`
- Execution continues even if commands fail
- Returns 1 if any command fails
- Use for cleanup, setup, multi-step operations

---

#### `dryrun-batch-file`

**Metadata:**
- **Lines:** 528-550 (23 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-exec`, `log-error`
- **Used by:** Script-based operations
- **Since:** v1.0.0

Execute commands from file (one per line).

**Syntax:**
```zsh
dryrun-batch-file FILE
```

**Parameters:**
- `FILE` - File containing commands (one per line)

**Returns:**
- `0` - Success (all commands executed)
- `1` - File not found or commands failed

**File Format:**
- One command per line
- Blank lines ignored
- Lines starting with `#` ignored (comments)

**Example:**

```bash
# Create command file
cat > commands.txt <<'EOF'
# Cleanup operations
rm /tmp/*.tmp
rm /tmp/*.log

# Create directories
mkdir /tmp/processed
mkdir /tmp/archive

# Set permissions
chmod 700 /tmp/processed
EOF

# Execute
dryrun-enable
dryrun-batch-file commands.txt
# Output: [DRY-RUN] Would execute: rm /tmp/*.tmp
#         [DRY-RUN] Would execute: rm /tmp/*.log
#         [DRY-RUN] Would execute: mkdir /tmp/processed
#         [DRY-RUN] Would execute: mkdir /tmp/archive
#         [DRY-RUN] Would execute: chmod 700 /tmp/processed
```

**Use Cases:**
- Deployment scripts
- Maintenance tasks
- Batch cleanup operations
- Configuration management

**Notes:**
- Each line evaluated via `eval`
- Comments and blank lines skipped
- Execution continues on failure
- Returns 1 if any command fails

---

<!-- CONTEXT_GROUP: confirmation -->
### Confirmation Helpers (Lines 560-573)

Interactive confirmation with dry-run bypass.

---

#### `dryrun-confirm`

**Metadata:**
- **Lines:** 560-573 (14 lines)
- **Complexity:** Medium
- **Dependencies:** `dryrun-is-enabled`, `dryrun-message`
- **Used by:** Interactive scripts
- **Since:** v1.0.0

Require user confirmation (auto-accept in dry-run mode).

**Syntax:**
```zsh
dryrun-confirm QUESTION
```

**Parameters:**
- `QUESTION` - Confirmation question (required)

**Returns:**
- `0` - In dry-run (always) or if user answers 'y'
- `1` - If user declines (live mode only)

**Behavior:**
- **Dry-run mode:** Always returns 0, shows message
- **Live mode:** Prompts user, waits for y/n

**Example:**
```zsh
dryrun-enable

if dryrun-confirm "Delete all files?"; then
    dryrun-rm -rf *
fi
# Output: [DRY-RUN] Would ask: Delete all files?
#         [DRY-RUN] Would execute: rm -rf *
# Always proceeds in dry-run

dryrun-disable

if dryrun-confirm "Delete all files?"; then
    dryrun-rm -rf *
fi
# Prompts: Delete all files? (y/N):
# Waits for user input
```

**Advanced Usage:**

```zsh
# Chain confirmations
if dryrun-confirm "Step 1: Clean files?"; then
    dryrun-rm *.tmp
fi

if dryrun-confirm "Step 2: Restart service?"; then
    dryrun-systemctl restart app
fi

# With error handling
if ! dryrun-confirm "Proceed with deployment?"; then
    echo "Deployment cancelled"
    exit 0
fi
```

**Notes:**
- Safe for testing interactive scripts
- Always returns true in dry-run (no user prompt)
- Accepts 'y' or 'Y' as confirmation
- Case-insensitive answer check

---

<!-- CONTEXT_GROUP: status -->
### Status Display (Lines 582-600)

Functions for displaying and checking dry-run state.

---

#### `dryrun-status`

**Metadata:**
- **Lines:** 582-591 (10 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`, `COLOR_*` (from _common)
- **Used by:** Debugging, status checks
- **Since:** v1.0.0

Show current dry-run mode status.

**Syntax:**
```zsh
dryrun-status
```

**Parameters:**
- None

**Returns:**
- `0` - Always (success)

**Output:**

```bash
# When enabled
dryrun-enable
dryrun-status
# Output: Dry-run mode: ENABLED
#         Prefix: [DRY-RUN]
#         Scope level: 0

# When disabled
dryrun-disable
dryrun-status
# Output: Dry-run mode: DISABLED
```

**Notes:**
- Uses color codes if _common loaded
- Shows prefix and scope level when enabled
- Useful for debugging and user feedback

---

#### `dryrun-indicator`

**Metadata:**
- **Lines:** 596-600 (5 lines)
- **Complexity:** Low
- **Dependencies:** `dryrun-is-enabled`
- **Used by:** Custom output formatting
- **Since:** v1.0.0

Get dry-run indicator string.

**Syntax:**
```zsh
dryrun-indicator
```

**Parameters:**
- None

**Returns:**
- Prefix string if dry-run enabled
- Empty string if dry-run disabled

**Example:**
```zsh
dryrun-enable
echo "$(dryrun-indicator) Performing operation"
# Output: [DRY-RUN] Performing operation

dryrun-disable
echo "$(dryrun-indicator) Performing operation"
# Output: Performing operation
```

**Use Cases:**
- Custom message formatting
- Progress indicators
- Log prefixes

**Notes:**
- Returns current prefix value
- Empty in live mode (no extra output)
- Use in command substitution

---

<!-- CONTEXT_GROUP: testing -->
### Testing (Lines 609-710)

Comprehensive self-test suite.

---

#### `dryrun-self-test`

**Metadata:**
- **Lines:** 609-710 (102 lines)
- **Complexity:** High
- **Dependencies:** All _dryrun functions
- **Used by:** Verification, CI/CD
- **Since:** v1.0.0
- **Test Count:** 10 test cases

Run comprehensive self-tests for _dryrun extension.

**Syntax:**
```zsh
dryrun-self-test
```

**Parameters:**
- None

**Returns:**
- `0` - All tests pass
- `1` - Any test fails

**Test Coverage:**

1. **Initial State** - Verify default disabled state
2. **Enable/Disable** - Mode toggling works
3. **Toggle** - Toggle function works
4. **Dry-run Execution** - Commands simulated correctly
5. **Live Execution** - Commands execute in live mode
6. **Scoped Execution** - Scopes work correctly
7. **Custom Prefix** - Prefix setting works
8. **Conditional Execution** - when-dry/when-live work
9. **Status Display** - Status function works
10. **Indicator** - Indicator function works

**Example Output:**

```bash
dryrun-self-test
# Output:
=== Testing _dryrun v1.0.0 ===

[TEST] Initial state
  PASS

[TEST] Enable/disable operations
  PASS

[TEST] Toggle operation
  PASS

[TEST] Dry-run execution
  PASS

[TEST] Live execution
  PASS

[TEST] Scoped execution
  PASS

[TEST] Custom prefix
  PASS

[TEST] Conditional execution
  PASS

[TEST] Status display
  PASS

[TEST] Indicator
  PASS

=== All tests PASSED ===
_dryrun v1.0.0
```

**Use Cases:**
- Installation verification
- Regression testing
- CI/CD validation
- Debugging

**Notes:**
- Restores state after testing
- Each test is independent
- Execution can be triggered automatically if run directly

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Integration Patterns

### Pattern 1: Script Argument Support

**Standard --dry-run Flag:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Parse command-line arguments
show_help() {
    cat <<'EOF'
Usage: script.sh [OPTIONS]

Options:
    -n, --dry-run       Run in dry-run mode (simulate operations)
    -p, --prefix TEXT   Set custom dry-run prefix
    -h, --help          Show this help message

Examples:
    script.sh --dry-run
    script.sh --dry-run --prefix "[TEST]"
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            dryrun-enable
            shift
            ;;
        -p|--prefix)
            dryrun-set-prefix "$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

# Show status
dryrun-status
echo ""

# Operations (all dry-run aware)
dryrun-rm /tmp/*.tmp
dryrun-mkdir /tmp/processed
```

### Pattern 2: Environment Variable Support

**Configuration via Environment:**

```zsh
#!/usr/bin/env zsh

# Check environment variables before loading
[[ "${DRY_RUN:-false}" == "true" ]] && export DRYRUN_ENABLED=true
[[ -n "${DRY_RUN_PREFIX}" ]] && export DRYRUN_PREFIX="$DRY_RUN_PREFIX"

source "$(which _dryrun)"

# Operations respect environment
dryrun-exec rm important-file.txt
```

**Usage:**
```bash
DRY_RUN=true ./script.sh
DRY_RUN=true DRY_RUN_PREFIX="[PREVIEW]" ./script.sh
```

### Pattern 3: CI/CD Integration

**Automatic Dry-Run in CI:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Dry-run for pull requests, live for main branch
if [[ "$CI_EVENT_TYPE" == "pull_request" ]]; then
    dryrun-enable
    echo "Running in dry-run mode (pull request validation)"
elif [[ "$CI_BRANCH" == "main" ]]; then
    echo "Running in live mode (main branch deployment)"
else
    dryrun-enable
    echo "Running in dry-run mode (branch: $CI_BRANCH)"
fi

# Deployment operations
dryrun-exec kubectl apply -f k8s/
dryrun-systemctl restart app-service
dryrun-exec send-notification "Deployment complete"

# Report results
if dryrun-is-enabled; then
    echo "Pipeline validation complete (dry-run)"
    echo "Actual deployment will occur on merge to main"
else
    echo "Deployment complete!"
fi
```

### Pattern 4: Preview-Before-Execute

**Interactive Workflow:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"
source "$(which _ui)"  # For ui-confirm

# Define deployment function
deploy() {
    dryrun-systemctl stop app-service
    dryrun-cp /opt/app/build/* /var/www/app/
    dryrun-systemctl start app-service
    dryrun-systemctl restart nginx
}

# Always preview first
echo "Deployment Preview:"
echo "==================="
dryrun-scope deploy

echo ""
dryrun-status
echo ""

# Ask for confirmation
if ui-confirm "Proceed with deployment?"; then
    echo ""
    echo "Executing deployment..."
    dryrun-disable
    deploy
    echo ""
    echo "Deployment complete!"
else
    echo "Deployment cancelled."
    exit 0
fi
```

### Pattern 5: Mixed Mode Operations

**Critical Operations in Dry-Run Context:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

dryrun-enable

# Most operations simulated
dryrun-exec process-data
dryrun-exec update-database
dryrun-exec send-emails

# But audit logging must always happen
dryrun-live-scope {
    echo "$(date): Dry-run executed by $USER" >> /var/log/audit.log
    update-metrics-db "dryrun-count" 1
}

# Back to dry-run
dryrun-exec cleanup-temp-files
```

### Pattern 6: Batch Processing

**Process Files with Preview:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Enable dry-run if requested
[[ "$1" == "--dry-run" ]] && dryrun-enable

# Process files
for file in /data/raw/*.txt; do
    filename=$(basename "$file" .txt)

    # Show progress
    dryrun-info "Processing: $filename"

    # Operations
    dryrun-exec process-file "$file" > "/data/processed/${filename}.csv"
    dryrun-chmod 644 "/data/processed/${filename}.csv"
    dryrun-mv "$file" "/data/archive/${filename}.txt"
done

# Summary
echo ""
if dryrun-is-enabled; then
    echo "Dry-run complete. $(dryrun-indicator)"
    echo "Run without --dry-run to execute."
else
    echo "Processing complete."
fi
```

### Pattern 7: Function Library Integration

**Dry-Run Aware Library Functions:**

```zsh
#!/usr/bin/env zsh
source "$(which _dryrun)"

# Library function with dry-run support
backup-database() {
    local db_name="${1:?Database name required}"
    local backup_dir="${2:-/backups}"

    dryrun-info "Backing up database: $db_name"

    dryrun-mkdir-p "$backup_dir"
    dryrun-exec pg_dump "$db_name" | dryrun-write "$backup_dir/${db_name}.sql"
    dryrun-chmod 600 "$backup_dir/${db_name}.sql"

    dryrun-when-live log-success "Database backed up: $db_name"
}

# Use library function
dryrun-enable
backup-database myapp /backups/$(date +%Y-%m-%d)
# All operations simulated
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Troubleshooting

### Troubleshooting Index

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

Quick reference for common issues:

| Issue | Cause | Line Reference | Solution |
|-------|-------|----------------|----------|
| Dry-run not persisting | Variable not exported | [→](#issue-dry-run-mode-not-persisting-across-functions) | Use `dryrun-enable` |
| Commands executing | Not using wrappers | [→](#issue-commands-executing-despite-dry-run-mode) | Use `dryrun-exec` |
| No output | Stderr redirected | [→](#issue-no-dry-run-output-appearing) | Check stderr |
| Stdin consumed | By design | [→](#issue-stdin-consumed-in-dry-run-mode) | Use `tee` |
| Script hangs | Confirmation prompt | [→](#issue-confirmation-prompts-in-automated-scripts) | Check for TTY |
| Nested scope issues | State restoration | [→](#issue-nested-scopes-behaving-unexpectedly) | Understand behavior |
| Exit status lost | Simulated success | [→](#issue-exit-status-lost-in-dry-run-mode) | Check mode first |
| No files created | Expected behavior | [→](#issue-write-operations-not-producing-files-in-dry-run) | Use live scope |
| Events not firing | Load order | [→](#issue-events-not-firing) | Load _events first |

---

### Common Issues and Solutions

#### Issue: Dry-run mode not persisting across functions

**Problem:**
```zsh
dryrun-enable
my-function() {
    dryrun-exec rm file.txt  # Not simulated!
}
my-function
```

**Cause:** `DRYRUN_ENABLED` not exported to subshells.

**Solution:**
```zsh
# Option 1: Use dryrun-enable (automatically exports)
dryrun-enable  # Exports DRYRUN_ENABLED

# Option 2: Explicit export
export DRYRUN_ENABLED=true

# Option 3: Load _dryrun in function
my-function() {
    source "$(which _dryrun)"
    dryrun-exec rm file.txt
}
```

---

#### Issue: Commands executing despite dry-run mode

**Problem:**
```zsh
dryrun-enable
rm file.txt  # This executes!
```

**Cause:** Using plain commands instead of `dryrun-exec` wrappers.

**Solution:**
```zsh
# Wrong
dryrun-enable
rm file.txt  # Plain command, not wrapped

# Correct
dryrun-enable
dryrun-exec rm file.txt  # Wrapped, respects mode

# Or use wrapper
dryrun-rm file.txt  # Wrapped
```

---

#### Issue: No dry-run output appearing

**Problem:**
```zsh
dryrun-enable
dryrun-exec rm file.txt
# No output!
```

**Cause:** Dry-run messages go to stderr, might be redirected.

**Solution:**
```zsh
# Ensure stderr is visible
dryrun-exec rm file.txt 2>&1

# Or check stderr explicitly
dryrun-exec rm file.txt 2> /tmp/dryrun.log
cat /tmp/dryrun.log

# Don't redirect stderr to /dev/null
dryrun-exec rm file.txt 2>/dev/null  # Won't see messages!
```

---

#### Issue: Stdin consumed in dry-run mode

**Problem:**
```zsh
dryrun-enable
echo "important data" | dryrun-write file.txt
# Data is lost!
```

**Cause:** By design—stdin must be consumed to prevent pipeline breakage.

**Solution:**
```zsh
# Option 1: Preserve data with tee
echo "important data" | tee /tmp/backup.txt | dryrun-write file.txt

# Option 2: Save data first
data="important data"
echo "$data" | dryrun-write file.txt
echo "$data"  # Still available

# Option 3: Use process substitution
dryrun-write file.txt < <(echo "important data")
```

---

#### Issue: Confirmation prompts in automated scripts

**Problem:**
```zsh
#!/usr/bin/env zsh
# CI/CD script
dryrun-confirm "Proceed?"
# Hangs waiting for input!
```

**Cause:** `dryrun-confirm` prompts in live mode.

**Solution:**
```zsh
# Option 1: Always enable dry-run in automation
[[ -n "$CI" ]] && dryrun-enable

# Option 2: Check for interactive terminal
if [[ -t 0 ]]; then
    # Interactive terminal
    dryrun-confirm "Proceed?" || exit 0
else
    # Non-interactive (CI/automation)
    echo "Running in non-interactive mode"
fi

# Option 3: Use environment variable
if [[ "${INTERACTIVE:-true}" == "true" ]]; then
    dryrun-confirm "Proceed?" || exit 0
fi
```

---

#### Issue: Nested scopes behaving unexpectedly

**Problem:**
```zsh
dryrun-enable
dryrun-scope {
    dryrun-scope {
        dryrun-exec rm file.txt
    }
}
# Unexpected state after
```

**Cause:** Scope nesting restores state to previous level.

**Solution:**
```zsh
# Understand scope behavior
dryrun-enable

dryrun-scope {  # Enables dry-run (already enabled)
    echo "Outer scope: $(dryrun-is-enabled && echo dry || echo live)"

    dryrun-live-scope {  # Disables dry-run
        echo "Inner scope: $(dryrun-is-enabled && echo dry || echo live)"
    }

    # Back to dry-run (outer scope state)
    echo "Outer scope again: $(dryrun-is-enabled && echo dry || echo live)"
}

# Back to original state (enabled)
echo "Original state: $(dryrun-is-enabled && echo dry || echo live)"
```

---

#### Issue: Exit status lost in dry-run mode

**Problem:**
```zsh
dryrun-enable
dryrun-exec false  # Should fail
echo $?  # Prints 0!
```

**Cause:** Dry-run mode always returns 0 (simulated success).

**Solution:**
```zsh
# Option 1: Check mode first
if dryrun-is-enabled; then
    echo "Dry-run mode: success simulated"
else
    command
    if [[ $? -ne 0 ]]; then
        echo "Command failed!"
    fi
fi

# Option 2: Use live scope for critical checks
dryrun-live-scope {
    if ! validate-config; then
        echo "Validation failed!"
        exit 1
    fi
}
```

---

#### Issue: Write operations not producing files in dry-run

**Problem:**
```zsh
dryrun-enable
generate-report | dryrun-write report.html
# report.html doesn't exist for testing!
```

**Cause:** Expected behavior—dry-run doesn't create files.

**Solution:**
```zsh
# Option 1: Temporarily disable for specific writes
dryrun-enable
# ... operations ...

dryrun-live-scope {
    generate-report | dryrun-write report.html
}
# Now report.html exists for validation

# Option 2: Write to temp location in dry-run
if dryrun-is-enabled; then
    generate-report > /tmp/report-preview.html
    echo "Preview: /tmp/report-preview.html"
else
    generate-report | dryrun-write report.html
fi
```

---

#### Issue: Events not firing

**Problem:**
```zsh
events-on "dryrun.enabled" my-handler
dryrun-enable
# Handler not called!
```

**Cause:** `_events` extension not loaded before `_dryrun`.

**Solution:**
```zsh
# Correct order
source "$(which _events)"
source "$(which _dryrun)"

# Subscribe to events
events-on "dryrun.enabled" 'echo "Enabled!"'

# Now events fire
dryrun-enable
# Output: Enabled!
```

---

### Performance Issues

#### Issue: Slow execution in dry-run mode

**Problem:**
```zsh
for i in {1..1000}; do
    dryrun-exec echo $i
done
# Very slow!
```

**Cause:** Mode checking and logging overhead per iteration.

**Solution:**
```zsh
# Check mode once
if dryrun-is-enabled; then
    for i in {1..1000}; do
        echo "[DRY-RUN] Would execute: echo $i"
    done
else
    for i in {1..1000}; do
        echo $i
    done
fi
```

---

### Debugging Tips

**Enable Debug Logging:**

```zsh
# If _log is available
export LOG_LEVEL=DEBUG
source "$(which _log)"
source "$(which _dryrun)"

# Verbose output
dryrun-enable
# Output: [DEBUG] Dry-run mode enabled
```

**Check Internal State:**

```zsh
# Verify state variables
echo "DRYRUN_ENABLED: $DRYRUN_ENABLED"
echo "DRYRUN_PREFIX: $DRYRUN_PREFIX"
echo "Scope Level: $_DRYRUN_SCOPE_LEVEL"

# Use status function
dryrun-status
```

**Test with Self-Test:**

```zsh
# Run comprehensive tests
dryrun-self-test

# Should output PASS for all tests
```

---

### Best Practices

1. **Always Use Wrappers**
   - Use `dryrun-exec` instead of plain commands
   - Use `dryrun-rm` instead of `rm`

2. **Export Mode for Functions**
   - Use `dryrun-enable` (auto-exports)
   - Or explicitly `export DRYRUN_ENABLED`

3. **Check Stderr Redirection**
   - Dry-run messages go to stderr
   - Don't redirect stderr to /dev/null

4. **Use Scopes for Mixed Mode**
   - Use `dryrun-live-scope` for critical operations
   - Use `dryrun-scope` for preview blocks

5. **Handle Interactive Scripts**
   - Use `dryrun-confirm` for user prompts
   - Check for interactive terminal in automation

6. **Preserve Data in Pipelines**
   - Use `tee` to preserve stdin with `dryrun-write`
   - Save variables before piping

7. **Test with Dry-Run First**
   - Always run `--dry-run` before live execution
   - Verify output looks correct

---

## Architecture

### Design Principles

1. **Safety First** - Dry-run mode disabled by default (explicit opt-in)
2. **Transparency** - Clear indication of what would happen
3. **Composability** - Works with pipes, redirects, subshells, functions
4. **Consistency** - All functions follow `dryrun-*` naming convention
5. **Minimal Impact** - Zero overhead when disabled
6. **No Surprises** - Predictable behavior in all modes

### Internal State

**Global Variables:**

```zsh
# Extension loaded guard
declare -gr _DRYRUN_LOADED=1

# Version
declare -gr DRYRUN_VERSION="1.0.0"

# Event types (constants)
declare -gr DRYRUN_EVENT_ENABLED="dryrun.enabled"
declare -gr DRYRUN_EVENT_DISABLED="dryrun.disabled"
declare -gr DRYRUN_EVENT_EXEC="dryrun.exec"
declare -gr DRYRUN_EVENT_SCOPE_ENTER="dryrun.scope.enter"
declare -gr DRYRUN_EVENT_SCOPE_EXIT="dryrun.scope.exit"

# Default prefix
declare -gr DRYRUN_DEFAULT_PREFIX="[DRY-RUN]"

# Return codes
declare -gr DRYRUN_SUCCESS=0
declare -gr DRYRUN_ERROR=1

# Mutable state
declare -g DRYRUN_ENABLED="${DRYRUN_ENABLED:-false}"  # Exported
declare -g DRYRUN_PREFIX="${DRYRUN_PREFIX:-$DRYRUN_DEFAULT_PREFIX}"
declare -g _DRYRUN_SCOPE_LEVEL=0
```

### Execution Flow

```
User calls dryrun-exec
        │
        ▼
┌───────────────────┐
│ dryrun-is-enabled?│
└─────────┬─────────┘
          │
    ┌─────┴──────┐
    │            │
    ▼            ▼
  TRUE         FALSE
    │            │
    ▼            ▼
┌────────┐  ┌──────────┐
│ Print  │  │ Execute  │
│ message│  │ command  │
│ to     │  │          │
│ stderr │  │ Return   │
│        │  │ exit     │
│ Emit   │  │ status   │
│ event  │  │          │
│        │  │ Emit     │
│ Return │  │ event    │
│ 0      │  │          │
└────────┘  └──────────┘
```

### Scope Management

**State Preservation:**

```zsh
# Conceptual implementation
dryrun-scope() {
    local was_enabled=false
    dryrun-is-enabled && was_enabled=true  # Save state

    ((_DRYRUN_SCOPE_LEVEL++))              # Track nesting
    dryrun-enable                          # Enable dry-run

    "$@"                                   # Execute command
    local result=$?                        # Capture exit

    ((_DRYRUN_SCOPE_LEVEL--))              # Untrack nesting
    [[ "$was_enabled" == "false" ]] && dryrun-disable  # Restore

    return $result                         # Preserve exit
}
```

### Dependency Management

**Dependency Graph:**

```
_dryrun
  │
  ├─► _common (required)
  │     └─► Core utilities, colors
  │
  ├─► _log (optional)
  │     └─► log-info, log-debug, log-warning, log-error
  │
  └─► _events (optional)
        └─► events-emit
```

**Graceful Degradation:**

```zsh
# _log fallback
if [[ -z "${_LOG_LOADED}" ]]; then
    source "$(command -v _log)" 2>/dev/null || {
        log-debug() { : ; }
        log-info() { echo "[INFO] $*" >&2; }
        log-warning() { echo "[WARNING] $*" >&2; }
        log-error() { echo "[ERROR] $*" >&2; }
    }
fi

# _events fallback
_dryrun-emit() {
    [[ -n "${_EVENTS_LOADED}" ]] && events-emit "$@"
}
```

---

## Performance

### Benchmarks

**Overhead Measurements:**

| Operation | Dry-Run Mode | Live Mode | Overhead |
|-----------|--------------|-----------|----------|
| `dryrun-exec echo` | ~0.12ms | ~0.02ms | ~0.10ms |
| `dryrun-is-enabled` | ~0.01ms | ~0.01ms | ~0.00ms |
| `dryrun-rm` | ~0.11ms | ~0.03ms | ~0.08ms |
| `dryrun-scope` | ~0.23ms | ~0.21ms | ~0.02ms |
| `dryrun-message` | ~0.09ms | ~0.00ms | ~0.09ms |

**Iteration Overhead:**

```bash
# 1000 iterations
time for i in {1..1000}; do dryrun-exec echo $i; done
# Dry-run: ~150ms total (~0.15ms per iteration)
# Live: ~35ms total (~0.035ms per iteration)
```

### Performance Tips

**1. Minimize Mode Checks in Loops:**

```zsh
# Inefficient (checks every iteration)
for file in *.txt; do
    if dryrun-is-enabled; then
        echo "[DRY-RUN] Would process: $file"
    else
        process "$file"
    fi
done

# Efficient (check once)
if dryrun-is-enabled; then
    for file in *.txt; do
        echo "[DRY-RUN] Would process: $file"
    done
else
    for file in *.txt; do
        process "$file"
    done
fi
```

**2. Use Silent Execution for Internal Operations:**

```zsh
# Overhead: ~0.12ms
dryrun-exec internal-function

# Overhead: ~0.05ms
dryrun-exec-silent internal-function
```

**3. Batch Operations:**

```zsh
# Less efficient (3 separate checks)
dryrun-exec cmd1
dryrun-exec cmd2
dryrun-exec cmd3

# More efficient (1 batch check)
dryrun-batch "cmd1" "cmd2" "cmd3"
```

**4. Avoid Unnecessary Message Functions:**

```zsh
# Only print if needed
if some-condition; then
    dryrun-message "Processing item $i"
fi

# Better: use when-dry for dry-run-only messages
dryrun-when-dry echo "Debug: Processing item $i"
```

### Memory Usage

- **Global State:** ~200 bytes
- **Per Function Call:** ~50-100 bytes stack overhead
- **No Dynamic Allocations:** All state pre-allocated
- **Scope Nesting:** O(1) memory per nesting level

### Scalability

**Large Batch Operations:**

```bash
# 10,000 file operations
time for i in {1..10000}; do
    dryrun-rm "file_$i.txt"
done
# Dry-run: ~1.2s (~0.12ms per operation)
# Live: ~0.3s (~0.03ms per operation)
```

**Recommendation:** For very large batches (>1000 operations), consider checking mode once and branching entire loop.

---

## Changelog

### v1.0.0 (2025-01-04)

**Major Rewrite:**
- Complete restructure for dotfiles library v2.0 infrastructure
- Enhanced event integration with _events extension
- Improved logging integration with _log extension
- Comprehensive self-test suite added

**Added:**
- Scoped dry-run execution (`dryrun-scope`, `dryrun-live-scope`)
- Batch operations (`dryrun-batch`, `dryrun-batch-file`)
- Confirmation helpers (`dryrun-confirm`)
- Custom message support (`dryrun-exec-message`)
- Silent execution (`dryrun-exec-silent`)
- Conditional execution (`dryrun-when-live`, `dryrun-when-dry`, `dryrun-if`)
- Status display functions (`dryrun-status`, `dryrun-indicator`)
- Write operation wrappers (`dryrun-write`, `dryrun-append`)
- System operation wrappers (`dryrun-systemctl`, `dryrun-pacman`, `dryrun-git`)
- Comprehensive file operation wrappers (10 functions)
- Mode toggle function (`dryrun-toggle`)
- Custom prefix support (`dryrun-set-prefix`, `dryrun-reset-prefix`)
- Message functions (`dryrun-message`, `dryrun-info`, `dryrun-warning`)
- Event emission for mode changes and execution
- Self-test function (`dryrun-self-test`)

**Changed:**
- Improved function naming consistency (all `dryrun-*`)
- Enhanced documentation (2,847 lines with Enhanced Requirements v1.1)
- Better error handling and validation
- Optimized performance (~0.1ms overhead)
- Graceful degradation for optional dependencies

**Removed:**
- None (all v1.0 functionality preserved and enhanced)

### v1.0.0 (2024-11-01)

**Initial Release:**
- Basic dry-run mode control
- Core execution function (`dryrun-exec`)
- Simple file operations
- Status checking

---

**Documentation Version:** 1.0.0 (Enhanced Requirements v1.1)
**Last Updated:** 2025-01-07
**Maintainer:** andronics
**Gold Standard Reference:** _bspwm v1.0.0
