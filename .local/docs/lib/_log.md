# _log - Modern Logging Extension

**Lines:** 3,847 | **Functions:** 38 | **Examples:** 78 | **Source Lines:** 778
**Version:** 1.0.0 | **Layer:** Core Foundation (Layer 1) | **Source:** `~/.local/bin/lib/_log`

---

## Quick Access Index

### Compact References (Lines 10-350)
- [Function Reference](#function-quick-reference) - 38 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 9 variables
- [Return Codes](#return-codes-quick-reference) - Standard codes
- [Log Levels](#log-levels-quick-reference) - 6 levels + success

### Main Sections
- [Overview](#overview) (Lines 350-450, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 450-550, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 550-850, ~300 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 850-1000, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 1000-2900, ~1900 lines) ⚡ LARGE SECTION
- [Complete Examples](#complete-examples) (Lines 2900-3400, ~500 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 3400-3600, ~200 lines) 🔧 REFERENCE
- [Best Practices](#best-practices) (Lines 3600-3800, ~200 lines) 📖 GUIDELINES

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

**Core Logging Functions:**

<!-- CONTEXT_GROUP: core_logging -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-trace` | Log trace message (most verbose) | 317-321 | [→](#log-trace) |
| `log-debug` | Log debug message | 324-328 | [→](#log-debug) |
| `log-info` | Log informational message | 331-335 | [→](#log-info) |
| `log-success` | Log success message (info level with success styling) | 338-342 | [→](#log-success) |
| `log-warning` | Log warning message | 345-349 | [→](#log-warning) |
| `log-error` | Log error message | 352-356 | [→](#log-error) |
| `log-fatal` | Log fatal error message | 359-363 | [→](#log-fatal) |

**Structured Logging Functions:**

<!-- CONTEXT_GROUP: structured_logging -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-trace-with` | Log trace with structured key=value fields | 516-520 | [→](#log-trace-with) |
| `log-debug-with` | Log debug with structured fields | 522-526 | [→](#log-debug-with) |
| `log-info-with` | Log info with structured fields | 528-532 | [→](#log-info-with) |
| `log-success-with` | Log success with structured fields | 534-538 | [→](#log-success-with) |
| `log-warning-with` | Log warning with structured fields | 540-544 | [→](#log-warning-with) |
| `log-error-with` | Log error with structured fields | 546-550 | [→](#log-error-with) |
| `log-fatal-with` | Log fatal with structured fields | 552-556 | [→](#log-fatal-with) |

**Configuration Functions:**

<!-- CONTEXT_GROUP: configuration -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-set-level` | Set minimum log level to display | 564-573 | [→](#log-set-level) |
| `log-set-mode` | Set logging mode (cli/daemon/hybrid/file) | 577-590 | [→](#log-set-mode) |
| `log-enable-timestamps` | Enable timestamp prefix in log messages | 593-595 | [→](#log-enable-timestamps) |
| `log-disable-timestamps` | Disable timestamp prefix | 598-600 | [→](#log-disable-timestamps) |
| `log-set-timestamp-format` | Set timestamp format (strftime) | 604-606 | [→](#log-set-timestamp-format) |
| `log-enable-json` | Enable JSON output format | 609-611 | [→](#log-enable-json) |
| `log-disable-json` | Disable JSON output (return to text) | 614-616 | [→](#log-disable-json) |
| `log-set-file` | Set log file path (for file mode) | 620-625 | [→](#log-set-file) |
| `log-set-systemd-tag` | Set systemd journal tag | 629-631 | [→](#log-set-systemd-tag) |
| `log-enable-function-names` | Include calling function name in logs | 634-636 | [→](#log-enable-function-names) |
| `log-disable-function-names` | Disable function name display | 639-641 | [→](#log-disable-function-names) |

**Dry-Run Helpers:**

<!-- CONTEXT_GROUP: dry_run -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-is-dry-run` | Check if running in dry-run mode | 648-653 | [→](#log-is-dry-run) |
| `log-dry-run-prefix` | Get dry-run prefix string | 656-660 | [→](#log-dry-run-prefix) |

**Journal/File Viewing Functions:**

<!-- CONTEXT_GROUP: viewing -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-view` | View systemd journal (daemon/hybrid mode) | 668-678 | [→](#log-view) |
| `log-watch` | Follow systemd journal in real-time | 682-691 | [→](#log-watch) |
| `log-view-file` | View log file (file mode) | 695-708 | [→](#log-view-file) |
| `log-watch-file` | Follow log file in real-time | 713-724 | [→](#log-watch-file) |
| `log-clear-file` | Clear log file contents | 728-738 | [→](#log-clear-file) |

**Information Functions:**

<!-- CONTEXT_GROUP: information -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-get-mode` | Get current log mode | 745-747 | [→](#log-get-mode) |
| `log-get-level` | Get current log level | 750-752 | [→](#log-get-level) |
| `log-show-config` | Display current logging configuration | 755-771 | [→](#log-show-config) |

**Internal Functions (Private API):**

<!-- CONTEXT_GROUP: internal -->

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `log-detect-mode` | Auto-detect appropriate logging mode | 130-148 | Internal |
| `log-init` | Initialize logging system | 151-173 | Internal |
| `log-should-log` | Check if log level should be shown | 176-182 | Internal |
| `_log-format-message` | Format log message with timestamp/color/prefix | 189-245 | Internal |
| `_log-output` | Route log message to appropriate destination(s) | 252-310 | Internal |
| `_log-parse-fields` | Parse structured fields from arguments | 371-400 | Internal |
| `_log-format-structured` | Format structured log entry | 403-511 | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `LOG_MODE` | string | `auto` | Logging mode: auto, cli, daemon, hybrid, file |
| `LOG_LEVEL` | string | `info` | Minimum log level: trace, debug, info, warning, error, fatal |
| `LOG_TIMESTAMPS` | boolean | `false` | Enable timestamp prefix in log messages |
| `LOG_TIMESTAMP_FORMAT` | string | `%Y-%m-%d %H:%M:%S` | strftime format for timestamps |
| `LOG_OUTPUT_FORMAT` | string | `text` | Output format: text, json |
| `LOG_COLOR` | string | `auto` | Color output control: auto, always, never |
| `LOG_FILE` | path | `` | Path to log file (for file mode) |
| `LOG_SYSTEMD_TAG` | string | `log` | Tag for systemd journal entries |
| `LOG_SHOW_FUNCTION` | boolean | `false` | Include calling function name in logs |

**Internal Variables (Read-Only):**

| Variable | Type | Description |
|----------|------|-------------|
| `LOG_LOADED` | boolean | Source guard (prevents double-loading) |
| `LOG_VERSION` | string | Extension version (1.0.0) |
| `_LOG_LEVEL_VALUES` | assoc array | Map of log levels to numeric values |
| `_LOG_LEVEL_PREFIX` | assoc array | Map of log levels to display prefixes |
| `LOG_COLOR_*` | string | Color codes for each log level |

---

## Log Levels Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Level | Value | Function | Systemd Priority | Use Case |
|-------|-------|----------|------------------|----------|
| `trace` | 0 | `log-trace` | debug | Fine-grained debugging, variable inspection |
| `debug` | 1 | `log-debug` | debug | Development debugging, cache hits, internal state |
| `info` | 2 | `log-info` | info | Normal operations, informational messages |
| `success` | 2 | `log-success` | info | Successful operations (info level with styling) |
| `warning` | 3 | `log-warning` | warning | Concerning but non-fatal conditions |
| `error` | 4 | `log-error` | err | Error conditions requiring attention |
| `fatal` | 5 | `log-fatal` | crit | Fatal errors before application termination |

**Level Filtering:**
- Messages are shown if their level value >= `LOG_LEVEL` value
- Example: `LOG_LEVEL=warning` shows warning, error, and fatal only
- Default level is `info` (shows info, success, warning, error, fatal)

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Functions |
|------|---------|-------------|-----------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | Error | Invalid parameter or operation failed | `log-set-level`, `log-set-mode`, viewing functions |

**Note:** Logging functions themselves rarely return errors - they log to their configured destination(s) and continue. Configuration and viewing functions return standard exit codes.

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Overview

The `_log` extension provides a modern, production-grade logging system for ZSH scripts, supporting both CLI tools (with colored console output) and daemons (with systemd journal integration). It offers structured logging, multiple log levels, timestamp support, JSON output, automatic mode detection, and comprehensive output routing.

**Key Features:**
- **Multi-mode logging**: CLI (colored console), daemon (systemd journal), hybrid (both), file (disk)
- **Six log levels**: trace, debug, info, warning, error, fatal (plus success styling)
- **Structured logging**: Key=value pairs for machine parsing and analytics
- **Automatic mode detection**: TTY-aware, systemd-aware, intelligent defaults
- **Flexible output formats**: Human-readable text or JSON
- **Timestamp support**: Customizable strftime formats
- **Color management**: Auto-detect TTY, always/never override
- **Systemd integration**: Journal logging with proper priorities
- **Dry-run detection**: Automatic detection of multiple dry-run flags
- **Zero-config defaults**: Works out of the box with smart detection
- **Graceful degradation**: Optional dependency on _common for colors

This extension provides the logging backbone for the entire dotfiles ecosystem, serving as the Layer 1 core foundation for all CLI tools, daemons, and automation scripts.

**Design Philosophy:**
- **Simplicity**: Zero configuration required for common use cases
- **Flexibility**: Highly configurable for complex scenarios
- **Performance**: Level filtering happens early to avoid expensive formatting
- **Safety**: Structured logging prevents log injection attacks
- **Integration**: Seamless systemd journal integration for daemon processes
- **Observability**: Multiple output targets for comprehensive logging

---

## Use Cases

- **CLI Tools**: Colored console output with clear level indicators for interactive use
- **System Daemons**: Systemd journal integration with proper priorities for production services
- **Background Scripts**: File-based logging for cron jobs and long-running processes
- **Hybrid Applications**: Log to both console (for debugging) and journal (for persistence)
- **Structured Analytics**: Key-value pairs exported as JSON for log aggregation systems
- **Debugging Workflows**: Trace and debug levels with conditional output for development
- **Production Monitoring**: Integration with systemd journalctl for centralized logging
- **Multi-target Logging**: Console + journal + file simultaneously for comprehensive coverage
- **Dry-Run Validation**: Automatic dry-run prefix for simulation modes

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

Load the extension in your script:

```zsh
# Basic loading (zero configuration)
source "$(which _log)"

# With error handling
if ! source "$(which _log)" 2>/dev/null; then
    echo "Error: _log extension not found" >&2
    exit 1
fi

# Pre-configure before loading
export LOG_LEVEL=debug
export LOG_TIMESTAMPS=true
source "$(which _log)"
```

**Dependencies:**

| Dependency | Required | Purpose | Fallback Behavior |
|------------|----------|---------|-------------------|
| **_common v2.0** | Optional | Color codes and utilities | Uses built-in ANSI fallbacks |
| **systemd-cat** | Optional | Journal logging | Silently skips journal output |
| **jq** | Optional | Better JSON formatting | Uses built-in JSON formatter |
| **journalctl** | Optional | Journal viewing | `log-view`/`log-watch` fail gracefully |

**Installation via stow:**

```bash
cd ~/.pkgs
stow lib

# Creates symlink:
# ~/.local/bin/lib/_log → ~/.pkgs/lib/.local/bin/lib/_log
```

**Verification:**

```zsh
# Check if loaded
typeset -f log-info >/dev/null && echo "✓ _log loaded"

# Check version
echo "LOG_VERSION: $LOG_VERSION"

# Test basic logging
log-info "Test message"
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Quick Start

### Example 1: Basic Logging (Auto-Detected Mode)

```zsh
#!/usr/bin/env zsh
source "$(which _log)"

# Logs automatically adapt to environment (CLI vs daemon)
log-info "Application starting"
log-debug "Configuration loaded from /etc/myapp/config"
log-warning "Deprecated API endpoint used"
log-error "Failed to connect to database"
log-success "Operation completed successfully"
```

**Output (CLI mode with TTY):**
```
[INFO] Application starting
[DEBUG] Configuration loaded from /etc/myapp/config
[WARNING] Deprecated API endpoint used
[ERROR] Failed to connect to database
[SUCCESS] Operation completed successfully
```

**Performance:** O(1) level check, ~0.5ms per log call

---

### Example 2: CLI Tool with Colored Output

```zsh
#!/usr/bin/env zsh
source "$(which _log)"

# Force CLI mode with colors
log-set-mode "cli"
log-set-level "info"  # Hide debug messages

log-info "Processing files..."
log-success "Processed 150 files"
log-warning "3 files skipped"
log-error "2 files failed"
```

**Output (with ANSI colors):**
```
[INFO] Processing files...
[SUCCESS] Processed 150 files
[WARNING] 3 files skipped
[ERROR] 2 files failed
```

**Color Mapping:**
- INFO: Green
- SUCCESS: Green (bold)
- WARNING: Yellow
- ERROR: Red
- FATAL: Red + Bold

---

### Example 3: Daemon with Journal Integration

```zsh
#!/usr/bin/env zsh
source "$(which _log)"

# Force daemon mode for systemd service
log-set-mode "daemon"
log-set-systemd-tag "myapp"
log-set-level "info"

log-info "Daemon started (PID: $$)"
log-debug "Listening on port 8080"  # Hidden (below info level)
log-error "Failed to connect to database"

# View logs later:
# journalctl --user -t myapp -f
# journalctl --user -t myapp -n 50 -p info
```

**Journal Output:**
```
Jan 07 15:30:45 hostname myapp[12345]: [INFO] Daemon started (PID: 12345)
Jan 07 15:30:46 hostname myapp[12345]: [ERROR] Failed to connect to database
```

**Systemd Priority Mapping:**
- trace/debug → debug
- info/success → info
- warning → warning
- error → err
- fatal → crit

---

### Example 4: Structured Logging

```zsh
source "$(which _log)"

# Log with key=value pairs
log-info-with "User logged in" user_id=12345 ip="192.168.1.1" method="oauth"
log-error-with "Database query failed" query="SELECT * FROM users" duration_ms=3500

# Enable JSON for parsing
log-enable-json
log-info-with "API request" method="GET" path="/api/users" status=200 duration_ms=145
```

**Text Output:**
```
[INFO] User logged in [user_id=12345 ip=192.168.1.1 method=oauth]
[ERROR] Database query failed [query=SELECT * FROM users duration_ms=3500]
```

**JSON Output:**
```json
{"level":"info","message":"API request","timestamp":"2025-01-07T15:30:45-05:00","method":"GET","path":"/api/users","status":"200","duration_ms":"145"}
```

**Use Cases:**
- Log aggregation systems (ELK, Splunk, Loki)
- Metrics extraction and monitoring
- Structured search and filtering
- Automated alerting on specific field values

---

### Example 5: File Logging

```zsh
source "$(which _log)"

# Setup file logging
log-set-mode "file"
log-set-file "/var/log/myapp/app.log"
log-enable-timestamps

log-info "Application started"
log-debug "Processing batch 1/10"
log-success "Batch processing complete"

# View logs
log-view-file 20        # Last 20 lines
log-watch-file          # Follow in real-time
```

**File Output:**
```
[2025-01-07 15:30:45] [INFO] Application started
[2025-01-07 15:30:46] [DEBUG] Processing batch 1/10
[2025-01-07 15:31:10] [SUCCESS] Batch processing complete
```

**Features:**
- Automatic directory creation
- Graceful handling of permission errors
- Errors/fatals always shown on stderr (even in file mode)
- Compatible with log rotation tools (logrotate)

---

### Example 6: Hybrid Mode (Console + Journal)

```zsh
source "$(which _log)"

# Log to both console and journal simultaneously
log-set-mode "hybrid"
log-set-systemd-tag "myapp"
log-enable-timestamps

log-info "Starting in hybrid mode"
log-info "Check console and journal for this message"
```

**Console Output:**
```
[2025-01-07 15:30:45] [INFO] Starting in hybrid mode
[2025-01-07 15:30:45] [INFO] Check console and journal for this message
```

**Journal Output:**
```
Jan 07 15:30:45 hostname myapp[12345]: [2025-01-07 15:30:45] [INFO] Starting in hybrid mode
Jan 07 15:30:45 hostname myapp[12345]: [2025-01-07 15:30:45] [INFO] Check console and journal for this message
```

**Use Cases:**
- Development: See logs immediately while they're also persisted
- Production debugging: Console output + permanent journal storage
- Multi-channel monitoring: Live console + centralized log aggregation

---

## Architecture

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Mode Detection Flow

The extension automatically detects the appropriate logging mode based on the execution environment:

```
┌─────────────────────────────────────┐
│  LOG_MODE=auto (default)            │
└───────────┬─────────────────────────┘
            │
            ├─ TTY detected (fd 1 or 2)?
            │  └─ YES → CLI mode (colored console)
            │
            ├─ Parent process == systemd?
            │  └─ YES → Daemon mode (journal)
            │
            └─ Otherwise → CLI mode (plain)
```

**Detection Implementation (Lines 130-148):**

```zsh
log-detect-mode() {
    if [[ "$LOG_MODE" == "auto" ]]; then
        if [[ -t 1 ]] || [[ -t 2 ]]; then
            LOG_MODE="cli"      # Interactive terminal
        else
            local ppid_comm=$(cat /proc/$PPID/comm 2>/dev/null || echo "")
            if [[ "$ppid_comm" == "systemd" ]]; then
                LOG_MODE="daemon"   # Systemd service
            else
                LOG_MODE="cli"      # Piped/redirected
            fi
        fi
    fi
}
```

**Performance:** O(1) with one procfs read, ~0.1ms overhead

---

### Message Flow Architecture

```
log-info "Message"
     │
     ├─ 1. Level Check (log-should-log)
     │    └─ Compare level value vs threshold
     │       └─ Return early if below threshold (FAST PATH)
     │
     ├─ 2. Format Message (_log-format-message)
     │    ├─ Add timestamp (if enabled)
     │    ├─ Add function name (if enabled)
     │    ├─ Add level prefix with color
     │    └─ Build text or JSON output
     │
     └─ 3. Route Output (_log-output)
          ├─ CLI mode → stdout/stderr
          ├─ Daemon mode → systemd-cat (+ TTY if available)
          ├─ Hybrid mode → both systemd-cat + stdout/stderr
          └─ File mode → append to file (+ stderr for errors)
```

**Critical Optimizations:**
- **Early level check**: Avoids expensive formatting for filtered messages
- **Lazy timestamp generation**: Only computed if message will be shown
- **Direct routing**: No intermediate buffers or pipes
- **Minimal subshells**: Format functions use ZSH builtins where possible

**Performance Characteristics:**
- Level check: O(1), ~0.01ms
- Message formatting: O(n) where n = message length, ~0.5ms
- Output routing: O(1) write, ~0.1ms
- Total: ~0.6ms per logged message (CLI mode)
- Total: ~2ms per logged message (daemon mode, systemd overhead)

---

### Log Level Hierarchy

```
Level      Value   Visibility
─────      ─────   ──────────
trace        0     ████████ (most verbose)
debug        1     ███████
info         2     ██████ (default threshold)
success      2     ██████
warning      3     ████
error        4     ███
fatal        5     ██
```

**Filtering Logic:**

```zsh
# Configured: LOG_LEVEL=info (value=2)
log-trace    # value=0 < 2 → HIDDEN
log-debug    # value=1 < 2 → HIDDEN
log-info     # value=2 >= 2 → SHOWN
log-success  # value=2 >= 2 → SHOWN
log-warning  # value=3 >= 2 → SHOWN
log-error    # value=4 >= 2 → SHOWN
log-fatal    # value=5 >= 2 → SHOWN
```

**Implementation (Lines 176-182):**

```zsh
log-should-log() {
    local level="$1"
    local level_value="${_LOG_LEVEL_VALUES[$level]:-999}"
    local threshold_value="${_LOG_LEVEL_VALUES[${LOG_LEVEL}]:-2}"
    [[ $level_value -ge $threshold_value ]]
}
```

---

### Output Routing Matrix

| Mode | Console (stdout) | Console (stderr) | Systemd Journal | File |
|------|------------------|------------------|-----------------|------|
| **cli** | info, debug, trace, success | warning, error, fatal | ✗ | ✗ |
| **daemon** | (if TTY available) | (if TTY available) | ✓ All | ✗ |
| **hybrid** | info, debug, trace, success | warning, error, fatal | ✓ All | ✗ |
| **file** | ✗ | error, fatal only | ✗ | ✓ All |

**Rationale:**
- **CLI mode**: Warnings/errors to stderr for proper redirection (`cmd 2>errors.log`)
- **Daemon mode**: Journal is primary, TTY is optional debugging aid
- **Hybrid mode**: Maximum visibility for development
- **File mode**: Critical errors always visible on stderr

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Environment Variable Configuration

All configuration variables can be set **before** or **after** sourcing the extension:

```zsh
# Method 1: Pre-configure (before sourcing)
export LOG_MODE=daemon
export LOG_LEVEL=debug
export LOG_TIMESTAMPS=true
source "$(which _log)"

# Method 2: Runtime configure (after sourcing)
source "$(which _log)"
log-set-mode "daemon"
log-set-level "debug"
log-enable-timestamps
```

**Configuration Precedence:**
1. Runtime function calls (highest priority)
2. Environment variables set before sourcing
3. Default values (fallback)

---

### LOG_MODE Configuration

**Values:** `auto`, `cli`, `daemon`, `hybrid`, `file`

**Usage:**

```zsh
# Auto-detect (default)
LOG_MODE=auto source "$(which _log)"

# Force CLI mode (colored console)
LOG_MODE=cli source "$(which _log)"

# Force daemon mode (systemd journal)
LOG_MODE=daemon source "$(which _log)"

# Hybrid mode (console + journal)
LOG_MODE=hybrid source "$(which _log)"

# File mode (disk logging)
LOG_MODE=file LOG_FILE=/var/log/app.log source "$(which _log)"
```

**Auto-Detection Logic:**
- TTY detected → `cli`
- Parent is systemd → `daemon`
- Piped/redirected → `cli` (no colors)

**Source Reference:** Lines 52, 130-148, 258-309

---

### LOG_LEVEL Configuration

**Values:** `trace`, `debug`, `info`, `warning`, `error`, `fatal`

**Usage:**

```zsh
# Show all messages (most verbose)
LOG_LEVEL=trace source "$(which _log)"

# Show debug and above
LOG_LEVEL=debug source "$(which _log)"

# Show info and above (default)
LOG_LEVEL=info source "$(which _log)"

# Show only warnings and errors
LOG_LEVEL=warning source "$(which _log)"

# Show only errors and fatal
LOG_LEVEL=error source "$(which _log)"

# Show only fatal messages
LOG_LEVEL=fatal source "$(which _log)"
```

**Level Filtering:**
- Messages with level value < threshold are discarded immediately
- No formatting overhead for filtered messages
- Early return in `log-should-log` function

**Source Reference:** Lines 61, 176-182

---

### LOG_TIMESTAMPS Configuration

**Values:** `true`, `false`

**Usage:**

```zsh
# Enable timestamps
LOG_TIMESTAMPS=true source "$(which _log)"

# Runtime enable
log-enable-timestamps

# Runtime disable
log-disable-timestamps

# Custom format
LOG_TIMESTAMP_FORMAT="%H:%M:%S" log-enable-timestamps
```

**Output Examples:**

```zsh
# Without timestamps
[INFO] Application started

# With timestamps (default format)
[2025-01-07 15:30:45] [INFO] Application started

# With custom format (%H:%M:%S)
[15:30:45] [INFO] Application started

# With ISO 8601 format
[2025-01-07T15:30:45-05:00] [INFO] Application started
```

**Source Reference:** Lines 64, 226-229, 593-606

---

### LOG_OUTPUT_FORMAT Configuration

**Values:** `text`, `json`

**Usage:**

```zsh
# Text output (default, human-readable)
LOG_OUTPUT_FORMAT=text source "$(which _log)"

# JSON output (machine-parseable)
LOG_OUTPUT_FORMAT=json source "$(which _log)"

# Runtime enable JSON
log-enable-json

# Runtime disable JSON
log-disable-json
```

**Text Output:**
```
[INFO] User login [user_id=12345 ip=192.168.1.1]
```

**JSON Output (with jq):**
```json
{
  "level": "info",
  "message": "User login",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "user_id": "12345",
  "ip": "192.168.1.1"
}
```

**JSON Output (without jq, fallback):**
```json
{"level":"info","message":"User login","timestamp":"2025-01-07T15:30:45-05:00","user_id":"12345","ip":"192.168.1.1"}
```

**Source Reference:** Lines 72, 198-221, 424-468, 609-616

---

### LOG_COLOR Configuration

**Values:** `auto`, `always`, `never`

**Usage:**

```zsh
# Auto-detect TTY (default)
LOG_COLOR=auto source "$(which _log)"

# Always use colors (even when piped)
LOG_COLOR=always source "$(which _log)"

# Never use colors
LOG_COLOR=never source "$(which _log)"
```

**Auto-Detection:**
```zsh
if [[ -t 1 ]]; then
    LOG_COLOR=always
else
    LOG_COLOR=never
fi
```

**Use Cases:**
- `auto`: Standard behavior, works in most cases
- `always`: Force colors for `less -R`, specific pager configurations
- `never`: Plain text for log files, email output, CI/CD systems

**Source Reference:** Lines 84, 156-162, 238-241

---

### LOG_FILE Configuration

**Values:** Any valid file path

**Usage:**

```zsh
# Set log file
LOG_FILE=/var/log/myapp/app.log source "$(which _log)"

# Runtime configuration
log-set-file "/var/log/myapp/app.log"

# XDG-compliant location
LOG_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/myapp/app.log"
source "$(which _log)"
```

**Automatic Behaviors:**
- Directory is created automatically if it doesn't exist
- File is touched on initialization
- Errors/fatals always shown on stderr (even in file mode)
- Graceful handling of permission errors

**Integration with Log Rotation:**

```bash
# /etc/logrotate.d/myapp
/var/log/myapp/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    postrotate
        # Signal app to reopen log file (if needed)
        killall -USR1 myapp
    endscript
}
```

**Source Reference:** Lines 75, 165-172, 620-625

---

### LOG_SYSTEMD_TAG Configuration

**Values:** Any valid systemd journal identifier

**Usage:**

```zsh
# Set journal tag
LOG_SYSTEMD_TAG=myapp source "$(which _log)"

# Runtime configuration
log-set-systemd-tag "myapp-worker"

# View journal with tag
journalctl --user -t myapp -f
journalctl --user -t myapp -n 100 -p info
```

**Tag Naming Conventions:**
- Use lowercase
- Use hyphens (not underscores) for multi-word tags
- Be specific: `myapp-worker` not `worker`
- Match systemd unit name if applicable

**Source Reference:** Lines 78, 629-631

---

### LOG_SHOW_FUNCTION Configuration

**Values:** `true`, `false`

**Usage:**

```zsh
# Enable function names
LOG_SHOW_FUNCTION=true source "$(which _log)"

# Runtime enable
log-enable-function-names

# Runtime disable
log-disable-function-names
```

**Output Examples:**

```zsh
# Without function names
[INFO] Processing file

# With function names
[INFO] process_batch | Processing file
```

**Use Cases:**
- Debugging complex call chains
- Identifying which function logged a message
- Tracing execution flow through logs

**Caveats:**
- Adds slight overhead (funcstack inspection)
- Function name is from calling context (not always obvious)
- May clutter logs in simple scripts

**Source Reference:** Lines 87, 232-234, 481-483, 634-641

---

## API Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->

This section documents all 38 public functions provided by the _log extension.

---

### Core Logging Functions

<!-- CONTEXT_GROUP: core_logging -->

#### `log-trace`

**Metadata:**
- **Lines:** 317-321 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** General debugging, variable inspection
- **Since:** v1.0.0

**Syntax:**
```zsh
log-trace MESSAGE...
```

**Description:**

Log trace message (most verbose debugging level). Trace messages are typically used for fine-grained debugging, variable inspection, and detailed execution flow tracking. This is the most verbose log level and is rarely enabled in production.

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 0 (trace)
**Systemd Priority:** debug

**Examples:**

```zsh
# Basic trace
log-trace "Entering function parse_config"

# Variable inspection
log-trace "Variable state: x=$x, y=$y, z=$z"

# Loop iteration tracking
for i in {1..100}; do
    log-trace "Processing iteration $i"
done

# Conditional tracing
[[ $DEBUG_VERBOSE == true ]] && log-trace "Internal state: $(declare -p internal_vars)"
```

**Output (text format):**
```
[TRACE] Entering function parse_config
[TRACE] Variable state: x=10, y=20, z=30
```

**Use Cases:**
- Fine-grained debugging during development
- Tracking variable values through complex logic
- Debugging loop iterations and recursion
- Temporary debugging instrumentation (removed before production)

**Performance:** ~0.6ms per call (if shown), ~0.01ms if filtered

**Source Code:** Lines 317-321

```zsh
log-trace() {
    log-should-log "trace" || return 0
    local msg=$(_log-format-message "trace" "$LOG_COLOR_TRACE" "$@")
    _log-output "trace" "debug" "$msg"
}
```

---

#### `log-debug`

**Metadata:**
- **Lines:** 324-328 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** Development debugging, cache operations, internal state
- **Since:** v1.0.0

**Syntax:**
```zsh
log-debug MESSAGE...
```

**Description:**

Log debug message for development debugging. Debug messages provide visibility into internal operations, cache hits/misses, configuration loading, and other development-relevant information. Hidden by default in production (LOG_LEVEL=info).

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 1 (debug)
**Systemd Priority:** debug

**Examples:**

```zsh
# Configuration debugging
log-debug "Configuration loaded: $(cat config.json | wc -l) lines"

# Cache operations
log-debug "Cache hit for key: user:12345"
log-debug "Cache miss for key: user:67890, fetching from database"

# State transitions
log-debug "State transition: idle → processing"

# API responses
log-debug "API response: status=200, body_length=${#response}"

# File operations
log-debug "Reading file: $filepath (size: $(stat -c%s "$filepath") bytes)"
```

**Output (text format with timestamps):**
```
[2025-01-07 15:30:45] [DEBUG] Configuration loaded: 145 lines
[2025-01-07 15:30:46] [DEBUG] Cache hit for key: user:12345
```

**Use Cases:**
- Development debugging and troubleshooting
- Cache hit/miss logging for optimization
- Configuration loading verification
- API request/response debugging
- State transition tracking

**Performance:** ~0.6ms per call (if shown), ~0.01ms if filtered

**Best Practices:**
- Use for information relevant to developers, not end users
- Remove or disable in production (set LOG_LEVEL=info)
- Avoid logging sensitive data (passwords, tokens, keys)
- Use structured logging for machine-parseable debug data

**Source Code:** Lines 324-328

```zsh
log-debug() {
    log-should-log "debug" || return 0
    local msg=$(_log-format-message "debug" "$LOG_COLOR_DEBUG" "$@")
    _log-output "debug" "debug" "$msg"
}
```

---

#### `log-info`

**Metadata:**
- **Lines:** 331-335 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** General operations, informational messages
- **Since:** v1.0.0

**Syntax:**
```zsh
log-info MESSAGE...
```

**Description:**

Log informational message (default log level). Info messages represent normal operations, progress updates, and general informational events. This is the default threshold - all info, warning, error, and fatal messages are shown.

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 2 (info)
**Systemd Priority:** info

**Examples:**

```zsh
# Application lifecycle
log-info "Application started (PID: $$)"
log-info "Server listening on port 8080"
log-info "Application shutting down gracefully"

# Progress updates
log-info "Processing batch 5/10"
log-info "Backup started: /data → /backups/backup-$(date +%Y%m%d).tar.gz"

# State changes
log-info "Connection established to database"
log-info "Cache initialized with 1000 entries"

# User actions
log-info "User 'alice' logged in from 192.168.1.100"
log-info "Configuration reloaded from disk"
```

**Output (text format):**
```
[INFO] Application started (PID: 12345)
[INFO] Server listening on port 8080
[INFO] Processing batch 5/10
```

**Use Cases:**
- Application startup/shutdown messages
- Progress updates for long-running operations
- State changes and transitions
- User action logging
- Configuration changes
- Normal operational events

**Performance:** ~0.6ms per call (CLI mode), ~2ms (daemon mode)

**Best Practices:**
- Use for messages that users/operators should see
- Keep messages concise and actionable
- Include relevant context (IDs, counts, paths)
- Avoid flooding with too many info messages in tight loops

**Source Code:** Lines 331-335

```zsh
log-info() {
    log-should-log "info" || return 0
    local msg=$(_log-format-message "info" "$LOG_COLOR_INFO" "$@")
    _log-output "info" "info" "$msg"
}
```

---

#### `log-success`

**Metadata:**
- **Lines:** 338-342 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** Success indicators, completion messages
- **Since:** v1.0.0

**Syntax:**
```zsh
log-success MESSAGE...
```

**Description:**

Log success message (info level with success styling). Success messages highlight successful operations, completions, and positive outcomes. Uses the same threshold as info (level 2) but with distinct visual styling (green color, SUCCESS prefix).

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 2 (info, same as `log-info`)
**Systemd Priority:** info

**Examples:**

```zsh
# Deployment success
log-success "Deployment completed successfully to production"

# Backup completion
log-success "Backup created: /backups/db-2025-01-07.tar.gz (2.3GB)"

# Batch processing
log-success "Processed 1000/1000 files with 0 errors"

# Migration success
log-success "Database migration applied: 20250107_add_users_table"

# Operation completion
log-success "Cache warmed: 5000 entries loaded in 2.3s"

# Authentication
log-success "User 'alice' authenticated successfully"
```

**Output (text format with color):**
```
[SUCCESS] Deployment completed successfully to production
[SUCCESS] Backup created: /backups/db-2025-01-07.tar.gz (2.3GB)
[SUCCESS] Processed 1000/1000 files with 0 errors
```

**Visual Styling:**
- **Color:** Green (same as info)
- **Prefix:** `[SUCCESS]` instead of `[INFO]`
- **Weight:** Bold (in terminals supporting bold)

**Use Cases:**
- Deployment/rollout completion
- Backup/restore success
- Batch processing completion
- Migration/upgrade success
- Test suite pass
- Operation completion with positive outcome

**Performance:** ~0.6ms per call (CLI mode)

**Difference from `log-info`:**
- Same log level (2) - filtered identically
- Different styling for visual distinction
- Semantic meaning: positive outcome vs. neutral information
- Same systemd priority (info)

**Source Code:** Lines 338-342

```zsh
log-success() {
    log-should-log "info" || return 0  # Note: info threshold, not success
    local msg=$(_log-format-message "success" "$LOG_COLOR_SUCCESS" "$@")
    _log-output "info" "info" "$msg"  # Note: outputs as info level
}
```

---

#### `log-warning`

**Metadata:**
- **Lines:** 345-349 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** Concerning conditions, deprecation notices
- **Since:** v1.0.0

**Syntax:**
```zsh
log-warning MESSAGE...
```

**Description:**

Log warning message for concerning but non-fatal conditions. Warnings indicate potential problems, deprecated features, resource constraints, or unusual conditions that don't prevent operation but require attention.

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 3 (warning)
**Systemd Priority:** warning

**Output Routing:**
- **CLI mode:** stderr (for redirection: `cmd 2>warnings.log`)
- **Daemon mode:** systemd journal with warning priority
- **Hybrid mode:** both stderr and journal
- **File mode:** log file + stderr

**Examples:**

```zsh
# Resource warnings
log-warning "Disk usage above 80%: /dev/sda1 at 87%"
log-warning "Memory usage high: 7.2GB / 8GB used"

# Deprecation notices
log-warning "API endpoint /v1/users is deprecated, use /v2/users"
log-warning "Configuration option 'legacy_mode' will be removed in v3.0"

# Retry warnings
log-warning "Database connection failed, retrying (attempt 2/3)"
log-warning "API request timed out, retrying with exponential backoff"

# Configuration warnings
log-warning "Invalid configuration value for 'max_connections', using default: 100"
log-warning "Environment variable DB_PASSWORD not set, using default"

# Unusual conditions
log-warning "No cache entries found, cold start will be slower"
log-warning "TLS certificate expires in 7 days"
```

**Output (text format with color):**
```
[WARNING] Disk usage above 80%: /dev/sda1 at 87%
[WARNING] API endpoint /v1/users is deprecated, use /v2/users
[WARNING] Database connection failed, retrying (attempt 2/3)
```

**Visual Styling:**
- **Color:** Yellow
- **Prefix:** `[WARNING]`
- **Output:** stderr (visible separately from stdout)

**Use Cases:**
- Resource constraints (disk, memory, CPU)
- Deprecated feature usage
- Retry attempts
- Configuration issues (non-fatal)
- Unusual but recoverable conditions
- Performance degradation notices
- Security concerns (non-critical)

**When to Use Warning vs Error:**
- **Warning:** Operation continues, but attention needed
- **Error:** Operation failed, requires intervention

**Performance:** ~0.6ms per call (CLI mode)

**Source Code:** Lines 345-349

```zsh
log-warning() {
    log-should-log "warning" || return 0
    local msg=$(_log-format-message "warning" "$LOG_COLOR_WARNING" "$@")
    _log-output "warning" "warning" "$msg"
}
```

---

#### `log-error`

**Metadata:**
- **Lines:** 352-356 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** Error conditions, failures requiring attention
- **Since:** v1.0.0

**Syntax:**
```zsh
log-error MESSAGE...
```

**Description:**

Log error message for failure conditions requiring attention. Errors indicate operations that failed, invalid states, or problems that require intervention. Unlike fatal errors, the application continues running after logging an error.

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds - logging itself doesn't fail)

**Log Level:** 4 (error)
**Systemd Priority:** err

**Output Routing:**
- **CLI mode:** stderr (separate from stdout for redirection)
- **Daemon mode:** systemd journal with err priority
- **Hybrid mode:** both stderr and journal
- **File mode:** log file + stderr (always visible)

**Examples:**

```zsh
# Connection failures
log-error "Failed to connect to database: connection refused"
log-error "API request failed: HTTP 500 Internal Server Error"

# File operations
log-error "Failed to read configuration file: $config_file (permission denied)"
log-error "Failed to write to disk: /data/output.txt (disk full)"

# Validation failures
log-error "Invalid input data: expected JSON, got plain text"
log-error "Schema validation failed: missing required field 'user_id'"

# Operation failures
log-error "Backup failed: rsync exited with code 23"
log-error "Migration rollback failed: cannot revert changes"

# Authentication/authorization
log-error "Authentication failed for user: $username (invalid credentials)"
log-error "Authorization denied: user lacks 'admin' role"

# Resource exhaustion
log-error "Failed to allocate memory: out of heap space"
log-error "Connection pool exhausted: all 100 connections in use"
```

**Output (text format with color):**
```
[ERROR] Failed to connect to database: connection refused
[ERROR] Failed to read configuration file: /etc/app/config.yml (permission denied)
[ERROR] Invalid input data: expected JSON, got plain text
```

**Visual Styling:**
- **Color:** Red
- **Prefix:** `[ERROR]`
- **Output:** stderr (for proper stream separation)

**Use Cases:**
- Connection/network failures
- File I/O errors
- Validation failures
- API/service errors
- Authentication/authorization failures
- Resource exhaustion
- Operation failures (non-fatal to application)

**When to Use Error vs Fatal:**
- **Error:** Operation failed, but application continues
- **Fatal:** Application cannot continue, must exit

**When to Use Error vs Warning:**
- **Error:** Operation failed, requires intervention
- **Warning:** Operation succeeded, but condition needs attention

**Common Pattern - Error with Context:**

```zsh
# Bad: Vague error
log-error "Operation failed"

# Good: Specific context
log-error "Failed to process file: $filepath (error: $error_msg)"

# Better: Actionable error with context
if ! process_file "$filepath"; then
    log-error "Failed to process file: $filepath"
    log-error "  Reason: ${ERROR_REASON:-unknown}"
    log-error "  Action: Check file permissions and format"
fi
```

**Performance:** ~0.6ms per call (CLI mode), ~2ms (daemon mode)

**Source Code:** Lines 352-356

```zsh
log-error() {
    log-should-log "error" || return 0
    local msg=$(_log-format-message "error" "$LOG_COLOR_ERROR" "$@")
    _log-output "error" "err" "$msg"
}
```

---

#### `log-fatal`

**Metadata:**
- **Lines:** 359-363 (5 lines)
- **Complexity:** Low
- **Dependencies:** `log-should-log`, `_log-format-message`, `_log-output`
- **Used by:** Fatal errors before application termination
- **Since:** v1.0.0

**Syntax:**
```zsh
log-fatal MESSAGE...
```

**Description:**

Log fatal error message for unrecoverable conditions that require application termination. Fatal messages are logged immediately before the application exits due to a critical failure. This is the highest severity level.

**Parameters:**
- `MESSAGE...` - One or more message strings (concatenated with spaces)

**Returns:** 0 (always succeeds - caller must handle exit)

**Log Level:** 5 (fatal)
**Systemd Priority:** crit

**Output Routing:**
- **CLI mode:** stderr (always visible)
- **Daemon mode:** systemd journal with crit priority + stderr
- **Hybrid mode:** both stderr and journal
- **File mode:** log file + stderr (always visible)

**Examples:**

```zsh
# Critical resource unavailable
log-fatal "Critical dependency not available: database unreachable"
exit 1

# Unrecoverable configuration error
if [[ ! -f "$REQUIRED_CONFIG" ]]; then
    log-fatal "Required configuration file missing: $REQUIRED_CONFIG"
    exit 2
fi

# System resource exhaustion
log-fatal "Cannot allocate required memory: system out of resources"
exit 3

# Corruption detected
log-fatal "Data corruption detected in core database: cannot proceed"
exit 4

# Security violation
log-fatal "Security check failed: unauthorized access attempt detected"
exit 5

# Dependency failure
if ! command -v required_tool &>/dev/null; then
    log-fatal "Required tool 'required_tool' not found in PATH"
    exit 127
fi
```

**Output (text format with color):**
```
[FATAL] Critical dependency not available: database unreachable
[FATAL] Required configuration file missing: /etc/app/critical.conf
[FATAL] Data corruption detected in core database: cannot proceed
```

**Visual Styling:**
- **Color:** Red + Bold
- **Prefix:** `[FATAL]`
- **Output:** stderr (always shown, even in file mode)
- **Weight:** Maximum visual weight to draw attention

**Use Cases:**
- Missing critical dependencies
- Unrecoverable configuration errors
- System resource exhaustion
- Data corruption detection
- Security violations
- License validation failures
- Required service unavailability

**Important Notes:**

1. **`log-fatal` does NOT exit** - You must explicitly exit:
   ```zsh
   log-fatal "Critical error"
   exit 1  # You must do this!
   ```

2. **Use meaningful exit codes:**
   ```zsh
   log-fatal "Database unreachable"
   exit 1  # General error

   log-fatal "Invalid arguments"
   exit 2  # Misuse of command

   log-fatal "Required command not found"
   exit 127  # Command not found
   ```

3. **Cleanup before exit:**
   ```zsh
   log-fatal "Critical failure detected"
   cleanup_resources  # Release locks, close connections
   exit 1
   ```

**Common Pattern - Fatal with Cleanup:**

```zsh
fatal() {
    log-fatal "$@"
    # Cleanup
    [[ -n "${TEMP_DIR:-}" ]] && rm -rf "$TEMP_DIR"
    [[ -n "${LOCK_FILE:-}" ]] && rm -f "$LOCK_FILE"
    # Exit
    exit "${FATAL_EXIT_CODE:-1}"
}

# Usage
[[ -f "$REQUIRED_FILE" ]] || fatal "Missing required file: $REQUIRED_FILE"
```

**Performance:** ~0.6ms per call (CLI mode), ~2ms (daemon mode)

**Best Practices:**
- Always exit immediately after `log-fatal`
- Use specific exit codes (not just `1`)
- Clean up resources before exit
- Provide actionable error messages
- Include context (file paths, values, reasons)

**Source Code:** Lines 359-363

```zsh
log-fatal() {
    log-should-log "fatal" || return 0
    local msg=$(_log-format-message "fatal" "$LOG_COLOR_FATAL" "$@")
    _log-output "fatal" "crit" "$msg"
}
```

---

### Structured Logging Functions

<!-- CONTEXT_GROUP: structured_logging -->

#### `log-trace-with`

**Metadata:**
- **Lines:** 516-520 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured debugging, variable inspection with context
- **Since:** v1.0.0

**Syntax:**
```zsh
log-trace-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log trace message with structured key=value fields. Combines trace-level logging with structured data for detailed debugging with machine-parseable context. Fields are formatted as `key=value` pairs and appear in both text (bracketed) and JSON output.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs (quoted if value contains spaces)

**Returns:** 0 (always succeeds)

**Log Level:** 0 (trace)
**Systemd Priority:** debug

**Examples:**

```zsh
# Function entry with parameters
log-trace-with "Entering function" function="parse_config" args="config.json" depth=3

# Variable state inspection
log-trace-with "Variable snapshot" x=$x y=$y z=$z timestamp=$(date +%s)

# Loop iteration with context
for i in {1..100}; do
    log-trace-with "Processing iteration" index=$i total=100 percent=$((i * 100 / 100))
done

# Complex debugging scenario
log-trace-with "Cache lookup" key="user:$user_id" hit=$cache_hit latency_ns=$latency

# Multi-value debugging
log-trace-with "State transition" \
    from="$old_state" \
    to="$new_state" \
    trigger="$event" \
    timestamp="$(date -Iseconds)"
```

**Output (text format):**
```
[TRACE] Entering function [function=parse_config args=config.json depth=3]
[TRACE] Variable snapshot [x=10 y=20 z=30 timestamp=1704650445]
```

**Output (JSON format):**
```json
{
  "level": "trace",
  "message": "Entering function",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "function": "parse_config",
  "args": "config.json",
  "depth": "3"
}
```

**Field Naming Conventions:**
- Use snake_case: `user_id`, `request_count`
- Be specific: `http_status` not `status`
- Include units: `duration_ms`, `size_bytes`, `timeout_sec`
- Use consistent naming across codebase

**Performance:** ~1.2ms per call (field parsing overhead)

**Use Cases:**
- Detailed debugging with structured context
- Variable inspection with metadata
- Loop iteration tracking with progress
- Complex state debugging
- Temporary instrumentation during development

**Source Code:** Lines 516-520

```zsh
log-trace-with() {
    log-should-log "trace" || return 0
    local msg=$(_log-format-structured "trace" "$LOG_COLOR_TRACE" "$@")
    _log-output "trace" "debug" "$msg"
}
```

---

#### `log-debug-with`

**Metadata:**
- **Lines:** 522-526 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured development debugging
- **Since:** v1.0.0

**Syntax:**
```zsh
log-debug-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log debug message with structured key=value fields. Provides development debugging visibility with machine-parseable context for analytics, monitoring, and automated processing.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds)

**Log Level:** 1 (debug)
**Systemd Priority:** debug

**Examples:**

```zsh
# Cache operations with metrics
log-debug-with "Cache operation" \
    operation="get" \
    key="user:123" \
    hit="true" \
    latency_ms="5" \
    size_bytes="1024"

# Database query debugging
log-debug-with "Database query executed" \
    query="SELECT * FROM users WHERE active=true" \
    duration_ms="145" \
    rows_returned="523" \
    connection_id="$conn_id"

# HTTP request debugging
log-debug-with "HTTP request" \
    method="GET" \
    url="/api/users" \
    status=200 \
    duration_ms=87 \
    response_size=2048

# Configuration loading
log-debug-with "Configuration loaded" \
    file="$config_file" \
    lines=$(wc -l < "$config_file") \
    checksum=$(md5sum "$config_file" | cut -d' ' -f1) \
    size_bytes=$(stat -c%s "$config_file")

# State machine transitions
log-debug-with "State transition" \
    from="idle" \
    to="processing" \
    trigger="user_action" \
    timestamp="$(date -Iseconds)"
```

**Output (text format with timestamps):**
```
[2025-01-07 15:30:45] [DEBUG] Cache operation [operation=get key=user:123 hit=true latency_ms=5 size_bytes=1024]
[2025-01-07 15:30:46] [DEBUG] HTTP request [method=GET url=/api/users status=200 duration_ms=87 response_size=2048]
```

**Output (JSON format):**
```json
{
  "level": "debug",
  "message": "Cache operation",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "operation": "get",
  "key": "user:123",
  "hit": "true",
  "latency_ms": "5",
  "size_bytes": "1024"
}
```

**Use Cases:**
- Cache operation metrics
- Database query analysis
- HTTP request/response tracking
- Configuration validation
- Performance profiling
- State transition debugging

**Integration with Monitoring:**

```zsh
# Log structured data, parse with jq for metrics
log-enable-json
log-debug-with "API call" method="$method" path="$path" duration_ms=$duration

# Later: Extract metrics
# journalctl --user -t myapp -o json | jq -r 'select(.message=="API call") | .duration_ms'
```

**Performance:** ~1.2ms per call (field parsing + formatting)

**Source Code:** Lines 522-526

```zsh
log-debug-with() {
    log-should-log "debug" || return 0
    local msg=$(_log-format-structured "debug" "$LOG_COLOR_DEBUG" "$@")
    _log-output "debug" "info" "$msg"
}
```

---

#### `log-info-with`

**Metadata:**
- **Lines:** 528-532 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured operational logging, metrics collection
- **Since:** v1.0.0

**Syntax:**
```zsh
log-info-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log informational message with structured key=value fields. Ideal for operational metrics, request logging, and structured data that will be aggregated, analyzed, or monitored. This is the primary structured logging function for production use.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds)

**Log Level:** 2 (info)
**Systemd Priority:** info

**Examples:**

```zsh
# HTTP request logging
log-info-with "Request processed" \
    method="POST" \
    path="/api/users" \
    status=201 \
    duration_ms=145 \
    client_ip="192.168.1.100" \
    user_id=12345

# Batch processing metrics
log-info-with "Batch completed" \
    batch_id="batch-20250107-001" \
    items_processed=1000 \
    items_failed=3 \
    duration_sec=23.5 \
    throughput_per_sec=42.5

# Deployment tracking
log-info-with "Deployment started" \
    version="1.2.3" \
    environment="production" \
    deployer="alice" \
    commit="a1b2c3d4"

# User action logging
log-info-with "User login" \
    user_id=12345 \
    username="alice" \
    ip="192.168.1.100" \
    method="oauth" \
    session_id="sess-abc123"

# Resource utilization
log-info-with "Resource check" \
    cpu_percent=45.2 \
    memory_mb=2048 \
    disk_percent=67.3 \
    open_connections=42

# Business metrics
log-info-with "Order placed" \
    order_id="ORD-123456" \
    customer_id=789 \
    amount_usd=99.99 \
    items=3 \
    payment_method="credit_card"
```

**Output (text format):**
```
[INFO] Request processed [method=POST path=/api/users status=201 duration_ms=145 client_ip=192.168.1.100 user_id=12345]
[INFO] Batch completed [batch_id=batch-20250107-001 items_processed=1000 items_failed=3 duration_sec=23.5 throughput_per_sec=42.5]
```

**Output (JSON format):**
```json
{
  "level": "info",
  "message": "Request processed",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "method": "POST",
  "path": "/api/users",
  "status": "201",
  "duration_ms": "145",
  "client_ip": "192.168.1.100",
  "user_id": "12345"
}
```

**Use Cases:**
- HTTP request/response logging
- Batch processing metrics
- Deployment tracking
- User action audit logs
- Resource utilization monitoring
- Business metrics and KPIs
- SLA monitoring
- Error rate tracking

**Analytics Integration:**

```zsh
# Enable JSON output for log aggregation
export LOG_OUTPUT_FORMAT=json
export LOG_MODE=hybrid
source "$(which _log)"

# Log structured metrics
log-info-with "API call" method="$method" path="$path" duration_ms=$duration status=$status

# Aggregate with standard tools:
# journalctl --user -t myapp -o json | jq -r 'select(.message=="API call")'
# Parse for metrics dashboards (Grafana, Prometheus, etc.)
```

**Field Naming Standards:**

```zsh
# Good: Consistent, specific, includes units
log-info-with "Request" method="POST" path="/api" duration_ms=100 status_code=200

# Bad: Vague, inconsistent, missing units
log-info-with "Request" type="POST" url="/api" time=100 code=200
```

**Performance:** ~1.2ms per call (field parsing), ~2.5ms (daemon mode with JSON)

**Source Code:** Lines 528-532

```zsh
log-info-with() {
    log-should-log "info" || return 0
    local msg=$(_log-format-structured "info" "$LOG_COLOR_INFO" "$@")
    _log-output "info" "info" "$msg"
}
```

---

#### `log-success-with`

**Metadata:**
- **Lines:** 534-538 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured success tracking, completion metrics
- **Since:** v1.0.0

**Syntax:**
```zsh
log-success-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log success message with structured key=value fields. Highlights successful operations with machine-parseable context for tracking completions, measuring success rates, and monitoring SLAs. Uses info level (2) with success styling.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds)

**Log Level:** 2 (info, same as `log-info`)
**Systemd Priority:** info

**Examples:**

```zsh
# Deployment success with metrics
log-success-with "Deployment complete" \
    version="1.2.3" \
    environment="production" \
    duration_sec=45 \
    rollback_available="true" \
    health_check="passed"

# Backup completion
log-success-with "Backup created" \
    file="/backups/db-2025-01-07.tar.gz" \
    size_mb=2048 \
    duration_sec=123 \
    compression_ratio=3.2 \
    checksum="a1b2c3d4e5f6"

# Batch processing success
log-success-with "Batch processing complete" \
    batch_id="batch-001" \
    items_total=1000 \
    items_processed=1000 \
    items_failed=0 \
    success_rate=100.0 \
    duration_sec=45

# Migration success
log-success-with "Database migration applied" \
    migration="20250107_add_users_table" \
    direction="up" \
    rows_affected=0 \
    duration_ms=523

# Integration test success
log-success-with "Integration tests passed" \
    total_tests=250 \
    passed=250 \
    failed=0 \
    skipped=0 \
    duration_sec=67.8 \
    coverage_percent=92.5
```

**Output (text format with color):**
```
[SUCCESS] Deployment complete [version=1.2.3 environment=production duration_sec=45 rollback_available=true health_check=passed]
[SUCCESS] Backup created [file=/backups/db-2025-01-07.tar.gz size_mb=2048 duration_sec=123 compression_ratio=3.2 checksum=a1b2c3d4e5f6]
```

**Output (JSON format):**
```json
{
  "level": "info",
  "message": "Deployment complete",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "version": "1.2.3",
  "environment": "production",
  "duration_sec": "45",
  "rollback_available": "true",
  "health_check": "passed"
}
```

**Use Cases:**
- Deployment completion tracking
- Backup/restore success metrics
- Batch processing completion
- Migration success tracking
- Test suite results
- SLA compliance monitoring
- Success rate calculation
- Performance benchmarking

**SLA Monitoring Pattern:**

```zsh
# Track operation success for SLA reporting
start=$(date +%s%N)

if perform_operation; then
    end=$(date +%s%N)
    duration_ms=$(( (end - start) / 1000000 ))
    log-success-with "Operation completed" \
        operation="data_sync" \
        duration_ms=$duration_ms \
        sla_target_ms=1000 \
        sla_met=$( [[ $duration_ms -lt 1000 ]] && echo "true" || echo "false" )
else
    log-error-with "Operation failed" operation="data_sync"
fi

# Later: Calculate SLA compliance
# journalctl -o json | jq -r 'select(.operation=="data_sync" and .sla_met=="true")' | wc -l
```

**Performance:** ~1.2ms per call (field parsing)

**Source Code:** Lines 534-538

```zsh
log-success-with() {
    log-should-log "info" || return 0  # Note: info threshold
    local msg=$(_log-format-structured "success" "$LOG_COLOR_SUCCESS" "$@")
    _log-output "info" "info" "$msg"  # Note: outputs as info
}
```

---

#### `log-warning-with`

**Metadata:**
- **Lines:** 540-544 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured warning tracking, threshold monitoring
- **Since:** v1.0.0

**Syntax:**
```zsh
log-warning-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log warning message with structured key=value fields. Tracks concerning conditions with context for alerting, threshold monitoring, and automated responses. Warnings indicate non-fatal issues that require attention.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds)

**Log Level:** 3 (warning)
**Systemd Priority:** warning

**Examples:**

```zsh
# Resource threshold warnings
log-warning-with "High memory usage" \
    current_mb=7200 \
    total_mb=8192 \
    percent=87.9 \
    threshold_percent=80 \
    process="worker"

# Retry attempt tracking
log-warning-with "Operation retry" \
    operation="database_connect" \
    attempt=2 \
    max_attempts=3 \
    last_error="connection refused" \
    backoff_sec=5

# Performance degradation
log-warning-with "Slow query detected" \
    query="SELECT * FROM large_table" \
    duration_ms=5000 \
    threshold_ms=1000 \
    rows_returned=50000

# Deprecation tracking
log-warning-with "Deprecated API usage" \
    endpoint="/v1/users" \
    replacement="/v2/users" \
    removal_version="3.0.0" \
    caller_ip="192.168.1.100"

# Configuration warnings
log-warning-with "Using default value" \
    parameter="max_connections" \
    default_value=100 \
    reason="environment variable not set" \
    env_var="MAX_CONNECTIONS"

# Certificate expiration
log-warning-with "Certificate expiring soon" \
    domain="example.com" \
    days_remaining=7 \
    expiration_date="2025-01-14" \
    renewal_required="true"
```

**Output (text format):**
```
[WARNING] High memory usage [current_mb=7200 total_mb=8192 percent=87.9 threshold_percent=80 process=worker]
[WARNING] Operation retry [operation=database_connect attempt=2 max_attempts=3 last_error=connection refused backoff_sec=5]
```

**Output (JSON format):**
```json
{
  "level": "warning",
  "message": "High memory usage",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "current_mb": "7200",
  "total_mb": "8192",
  "percent": "87.9",
  "threshold_percent": "80",
  "process": "worker"
}
```

**Use Cases:**
- Resource threshold monitoring
- Retry attempt tracking
- Performance degradation detection
- Deprecation warnings
- Configuration validation
- Certificate expiration alerts
- Rate limiting notifications
- Capacity planning indicators

**Alerting Integration:**

```zsh
# Log structured warnings for automated alerting
log-warning-with "Disk usage high" \
    mount_point="/data" \
    used_percent=85 \
    threshold=80 \
    alert_severity="medium"

# External alerting tool watches journal:
# journalctl -f -o json | jq -r 'select(.level=="warning" and .alert_severity=="high")'
# Trigger alerts based on field values
```

**Threshold Monitoring Pattern:**

```zsh
# Check threshold and log with context
check_disk_usage() {
    local mount_point="$1"
    local threshold="${2:-80}"
    local used_percent=$(df -h "$mount_point" | awk 'NR==2 {print $5}' | tr -d '%')

    if [[ $used_percent -gt $threshold ]]; then
        log-warning-with "Disk usage above threshold" \
            mount_point="$mount_point" \
            used_percent=$used_percent \
            threshold=$threshold \
            available=$(df -h "$mount_point" | awk 'NR==2 {print $4}')
    fi
}

check_disk_usage "/data" 80
```

**Performance:** ~1.2ms per call

**Source Code:** Lines 540-544

```zsh
log-warning-with() {
    log-should-log "warning" || return 0
    local msg=$(_log-format-structured "warning" "$LOG_COLOR_WARNING" "$@")
    _log-output "warning" "warning" "$msg"
}
```

---

#### `log-error-with`

**Metadata:**
- **Lines:** 546-550 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured error tracking, failure analysis
- **Since:** v1.0.0

**Syntax:**
```zsh
log-error-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log error message with structured key=value fields. Tracks failure conditions with detailed context for debugging, error analysis, and automated incident response. Provides machine-parseable error data for monitoring systems.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds)

**Log Level:** 4 (error)
**Systemd Priority:** err

**Examples:**

```zsh
# Database error with full context
log-error-with "Database query failed" \
    query="INSERT INTO users (id, name) VALUES (?, ?)" \
    error="duplicate key violation" \
    constraint="users_pkey" \
    retry_count=3 \
    duration_ms=523

# API error tracking
log-error-with "API request failed" \
    method="POST" \
    url="https://api.example.com/users" \
    status_code=500 \
    error_message="Internal Server Error" \
    retry_after_sec=60 \
    request_id="req-abc123"

# File operation error
log-error-with "File operation failed" \
    operation="write" \
    file_path="/data/output.txt" \
    error="permission denied" \
    errno=13 \
    user=$(whoami) \
    file_perms=$(stat -c%a "/data/output.txt" 2>/dev/null || echo "unknown")

# Validation error
log-error-with "Input validation failed" \
    field="email" \
    value="$email_input" \
    error="invalid format" \
    expected_pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" \
    source="user_input"

# Connection error
log-error-with "Connection failed" \
    host="database.example.com" \
    port=5432 \
    error="connection refused" \
    timeout_sec=30 \
    retry_attempt=3 \
    max_retries=5

# Authentication error
log-error-with "Authentication failed" \
    username="$username" \
    method="password" \
    error="invalid credentials" \
    source_ip="$REMOTE_ADDR" \
    attempt_count=3 \
    lockout_triggered="true"
```

**Output (text format):**
```
[ERROR] Database query failed [query=INSERT INTO users (id, name) VALUES (?, ?) error=duplicate key violation constraint=users_pkey retry_count=3 duration_ms=523]
[ERROR] API request failed [method=POST url=https://api.example.com/users status_code=500 error_message=Internal Server Error retry_after_sec=60 request_id=req-abc123]
```

**Output (JSON format):**
```json
{
  "level": "error",
  "message": "Database query failed",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "query": "INSERT INTO users (id, name) VALUES (?, ?)",
  "error": "duplicate key violation",
  "constraint": "users_pkey",
  "retry_count": "3",
  "duration_ms": "523"
}
```

**Use Cases:**
- Database error tracking
- API failure logging
- File I/O error analysis
- Validation error details
- Connection failure debugging
- Authentication error monitoring
- Error rate calculation
- Incident response data

**Error Rate Monitoring Pattern:**

```zsh
# Track errors for rate calculation
perform_operation() {
    local start=$(date +%s%N)
    local result

    if execute_query "$@"; then
        local duration_ms=$(( ($(date +%s%N) - start) / 1000000 ))
        log-info-with "Query succeeded" query="$1" duration_ms=$duration_ms
        return 0
    else
        local duration_ms=$(( ($(date +%s%N) - start) / 1000000 ))
        log-error-with "Query failed" \
            query="$1" \
            error="$?" \
            duration_ms=$duration_ms \
            operation_id="$OPERATION_ID"
        return 1
    fi
}

# Calculate error rate:
# success=$(journalctl -o json | jq -r 'select(.message=="Query succeeded")' | wc -l)
# failed=$(journalctl -o json | jq -r 'select(.message=="Query failed")' | wc -l)
# error_rate=$(echo "scale=2; $failed / ($success + $failed) * 100" | bc)
```

**Incident Response Pattern:**

```zsh
# Structured errors for automated incident creation
log-error-with "Service unavailable" \
    service="payment_gateway" \
    error="connection timeout" \
    severity="high" \
    impact="customer_facing" \
    auto_escalate="true" \
    oncall_group="platform"

# Monitoring system watches for severity=high and creates incidents
```

**Performance:** ~1.2ms per call

**Source Code:** Lines 546-550

```zsh
log-error-with() {
    log-should-log "error" || return 0
    local msg=$(_log-format-structured "error" "$LOG_COLOR_ERROR" "$@")
    _log-output "error" "err" "$msg"
}
```

---

#### `log-fatal-with`

**Metadata:**
- **Lines:** 552-556 (5 lines)
- **Complexity:** Medium (structured field parsing)
- **Dependencies:** `log-should-log`, `_log-format-structured`, `_log-output`
- **Used by:** Structured fatal error tracking before termination
- **Since:** v1.0.0

**Syntax:**
```zsh
log-fatal-with MESSAGE [KEY=VALUE...]
```

**Description:**

Log fatal error message with structured key=value fields before application termination. Captures critical failure context for post-mortem analysis, debugging, and automated incident creation. This is the highest severity structured logging function.

**Parameters:**
- `MESSAGE` - Primary message string
- `KEY=VALUE...` - Zero or more key=value pairs

**Returns:** 0 (always succeeds - caller must handle exit)

**Log Level:** 5 (fatal)
**Systemd Priority:** crit

**Examples:**

```zsh
# Critical dependency failure
if ! ping -c 1 database.example.com &>/dev/null; then
    log-fatal-with "Critical dependency unreachable" \
        service="database" \
        host="database.example.com" \
        error="no route to host" \
        uptime_sec=$SECONDS \
        exit_code=1
    exit 1
fi

# Configuration validation failure
if [[ ! -f "$REQUIRED_CONFIG" ]]; then
    log-fatal-with "Required configuration missing" \
        file="$REQUIRED_CONFIG" \
        error="file not found" \
        pwd="$PWD" \
        user="$(whoami)" \
        exit_code=2
    exit 2
fi

# Resource exhaustion
log-fatal-with "Out of memory" \
    requested_mb=2048 \
    available_mb=$(free -m | awk 'NR==2 {print $7}') \
    total_mb=$(free -m | awk 'NR==2 {print $2}') \
    process="$0" \
    pid=$$ \
    exit_code=3
exit 3

# Data corruption detected
log-fatal-with "Data corruption detected" \
    file="$DATA_FILE" \
    expected_checksum="$EXPECTED_CHECKSUM" \
    actual_checksum=$(md5sum "$DATA_FILE" | cut -d' ' -f1) \
    size_bytes=$(stat -c%s "$DATA_FILE") \
    corruption_type="checksum_mismatch" \
    exit_code=4
exit 4

# License validation failure
log-fatal-with "License validation failed" \
    license_file="$LICENSE_FILE" \
    error="expired" \
    expiration_date="$EXPIRY_DATE" \
    current_date="$(date -Iseconds)" \
    contact="license@example.com" \
    exit_code=5
exit 5

# Security violation
log-fatal-with "Security check failed" \
    check="file_permissions" \
    file="$SENSITIVE_FILE" \
    expected_perms="0600" \
    actual_perms=$(stat -c%a "$SENSITIVE_FILE") \
    owner=$(stat -c%U "$SENSITIVE_FILE") \
    security_policy="strict" \
    exit_code=6
exit 6
```

**Output (text format with bold):**
```
[FATAL] Critical dependency unreachable [service=database host=database.example.com error=no route to host uptime_sec=45 exit_code=1]
[FATAL] Required configuration missing [file=/etc/app/config.yml error=file not found pwd=/opt/app user=appuser exit_code=2]
```

**Output (JSON format):**
```json
{
  "level": "fatal",
  "message": "Critical dependency unreachable",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "service": "database",
  "host": "database.example.com",
  "error": "no route to host",
  "uptime_sec": "45",
  "exit_code": "1"
}
```

**Use Cases:**
- Missing critical dependencies
- Configuration validation failures
- Resource exhaustion (memory, disk, handles)
- Data corruption detection
- License/activation failures
- Security violations
- Required service unavailability
- Unrecoverable errors

**Post-Mortem Analysis Pattern:**

```zsh
# Capture comprehensive context for debugging
log-fatal-with "Application crash" \
    error="$ERROR_MESSAGE" \
    exit_code=$EXIT_CODE \
    uptime_sec=$SECONDS \
    version="$APP_VERSION" \
    hostname="$(hostname)" \
    pid=$$ \
    memory_mb=$(free -m | awk 'NR==2 {print $3}') \
    load_avg="$(uptime | awk -F'load average:' '{print $2}')" \
    last_operation="$LAST_OPERATION" \
    stack_trace="$(caller 0)" \
    user="$(whoami)" \
    pwd="$PWD"
exit $EXIT_CODE
```

**Automated Incident Creation:**

```zsh
# Fatal errors trigger immediate alerts
log-fatal-with "Service critical failure" \
    service="payment_processor" \
    error="database connection lost" \
    severity="critical" \
    impact="revenue_impacting" \
    auto_escalate="true" \
    oncall_group="platform" \
    runbook="https://wiki.example.com/runbooks/payment-processor" \
    exit_code=1

# Monitoring system creates high-priority incident automatically
```

**Important Notes:**

1. **Always exit after `log-fatal-with`:**
   ```zsh
   log-fatal-with "Critical error" error="$err" exit_code=1
   exit 1  # Required!
   ```

2. **Include exit_code field for tracking:**
   ```zsh
   # Makes it easy to analyze exit patterns
   log-fatal-with "Error" exit_code=$EXIT_CODE
   exit $EXIT_CODE
   ```

3. **Capture comprehensive context:**
   ```zsh
   # More context = easier debugging
   log-fatal-with "Failure" \
       error="$ERROR" \
       file="$FILE" \
       line="$LINE" \
       function="$FUNCTION" \
       version="$VERSION"
   ```

**Performance:** ~1.2ms per call (final operation before exit)

**Source Code:** Lines 552-556

```zsh
log-fatal-with() {
    log-should-log "fatal" || return 0
    local msg=$(_log-format-structured "fatal" "$LOG_COLOR_FATAL" "$@")
    _log-output "fatal" "crit" "$msg"
}
```

---

### Configuration Functions

<!-- CONTEXT_GROUP: configuration -->

#### `log-set-level`

**Metadata:**
- **Lines:** 564-573 (10 lines)
- **Complexity:** Low (validation + assignment)
- **Dependencies:** `_LOG_LEVEL_VALUES` (assoc array)
- **Used by:** Runtime configuration
- **Since:** v1.0.0

**Syntax:**
```zsh
log-set-level LEVEL
```

**Description:**

Set minimum log level to display. Messages below this level are filtered out early (no formatting overhead). Valid levels are: trace, debug, info, warning, error, fatal.

**Parameters:**
- `LEVEL` (string) - One of: trace, debug, info, warning, error, fatal

**Returns:**
- `0` - Success, level set
- `1` - Error, invalid level (logs error message)

**Examples:**

```zsh
# Show all messages (most verbose)
log-set-level "trace"

# Show debug and above
log-set-level "debug"

# Show info and above (default)
log-set-level "info"

# Show only warnings, errors, and fatal
log-set-level "warning"

# Show only errors and fatal
log-set-level "error"

# Show only fatal messages
log-set-level "fatal"

# Error handling
if ! log-set-level "invalid"; then
    echo "Failed to set log level" >&2
fi

# Runtime adjustment based on flag
if [[ "$VERBOSE" == "true" ]]; then
    log-set-level "debug"
else
    log-set-level "info"
fi
```

**Level Hierarchy:**

```
trace (0)    ← Most verbose
  ↓
debug (1)
  ↓
info (2)     ← Default
  ↓
warning (3)
  ↓
error (4)
  ↓
fatal (5)    ← Least verbose
```

**Filtering Behavior:**

```zsh
# Set level to warning
log-set-level "warning"

# These are filtered (not shown)
log-trace "..."    # level 0 < 3
log-debug "..."    # level 1 < 3
log-info "..."     # level 2 < 3

# These are shown
log-warning "..."  # level 3 >= 3
log-error "..."    # level 4 >= 3
log-fatal "..."    # level 5 >= 3
```

**Use Cases:**
- Enable debug logging during development
- Reduce verbosity in production
- Temporary troubleshooting (raise level, then restore)
- User-controlled verbosity (`--verbose` flag)
- Environment-based configuration

**Performance:** O(1) validation + assignment, ~0.01ms

**Validation:**

```zsh
# Invalid levels are rejected
log-set-level "invalid"
# Output: [ERROR] Invalid log level: invalid (valid: trace, debug, info, warning, error, fatal)
# Returns: 1
```

**Source Code:** Lines 564-573

```zsh
log-set-level() {
    local level="$1"
    if [[ -n "${_LOG_LEVEL_VALUES[$level]}" ]]; then
        LOG_LEVEL="$level"
        return 0
    else
        log-error "Invalid log level: $level (valid: trace, debug, info, warning, error, fatal)"
        return 1
    fi
}
```

---

#### `log-set-mode`

**Metadata:**
- **Lines:** 577-590 (14 lines)
- **Complexity:** Low (validation + assignment + re-init)
- **Dependencies:** `log-init`
- **Used by:** Runtime mode switching
- **Since:** v1.0.0

**Syntax:**
```zsh
log-set-mode MODE
```

**Description:**

Set logging mode and reinitialize the logging system. Modes control output routing: cli (console), daemon (systemd journal), hybrid (both), file (disk), or auto (detect).

**Parameters:**
- `MODE` (string) - One of: auto, cli, daemon, hybrid, file

**Returns:**
- `0` - Success, mode set and system reinitialized
- `1` - Error, invalid mode (logs error message)

**Mode Descriptions:**

| Mode | Output Destinations | Use Case |
|------|---------------------|----------|
| `auto` | Auto-detected (TTY → cli, systemd → daemon) | Default, smart detection |
| `cli` | Console (stdout/stderr) with colors | Interactive CLI tools |
| `daemon` | Systemd journal (+ TTY if available) | Systemd services |
| `hybrid` | Console + systemd journal | Development, debugging daemons |
| `file` | Log file (+ stderr for errors) | Cron jobs, background scripts |

**Examples:**

```zsh
# Auto-detect mode (default)
log-set-mode "auto"

# Force CLI mode (colored console)
log-set-mode "cli"
log-info "This goes to console with colors"

# Force daemon mode (systemd journal)
log-set-mode "daemon"
log-set-systemd-tag "myapp"
log-info "This goes to systemd journal"

# Hybrid mode (both console and journal)
log-set-mode "hybrid"
log-info "This appears in both console and journal"

# File mode
log-set-mode "file"
log-set-file "/var/log/myapp/app.log"
log-info "This goes to file"

# Error handling
if ! log-set-mode "invalid"; then
    echo "Failed to set mode" >&2
fi

# Runtime switching based on environment
if [[ -n "${SYSTEMD_EXEC_PID:-}" ]]; then
    log-set-mode "daemon"
else
    log-set-mode "cli"
fi
```

**Mode Selection Flow:**

```
log-set-mode "auto"
     ↓
log-detect-mode()
     ↓
     ├─ TTY detected? → cli
     ├─ Parent == systemd? → daemon
     └─ Otherwise → cli
```

**Reinitializes Logging System:**

When you call `log-set-mode`, it triggers `log-init` which:
1. Re-detects mode (if auto)
2. Re-evaluates color settings
3. Creates log file directory (if file mode)
4. Touches log file (if file mode)

**Use Cases:**
- Switch from auto to explicit mode for testing
- Enable hybrid mode during daemon development
- Switch to file mode for cron jobs
- Force cli mode for scripts run by systemd (debugging)
- Runtime mode switching based on flags

**Performance:** O(1) validation + re-init, ~0.5ms

**Source Code:** Lines 577-590

```zsh
log-set-mode() {
    local mode="$1"
    case "$mode" in
        auto|cli|daemon|hybrid|file)
            LOG_MODE="$mode"
            log-init  # Reinitialize with new mode
            return 0
            ;;
        *)
            log-error "Invalid log mode: $mode (valid: auto, cli, daemon, hybrid, file)"
            return 1
            ;;
    esac
}
```

---

#### `log-enable-timestamps`

**Metadata:**
- **Lines:** 593-595 (3 lines)
- **Complexity:** Trivial (assignment)
- **Dependencies:** None
- **Used by:** Runtime timestamp control
- **Since:** v1.0.0

**Syntax:**
```zsh
log-enable-timestamps
```

**Description:**

Enable timestamp prefix in log messages. Timestamps use the format specified by `LOG_TIMESTAMP_FORMAT` (default: `%Y-%m-%d %H:%M:%S`).

**Parameters:** None

**Returns:** 0 (always succeeds)

**Examples:**

```zsh
# Enable timestamps
log-enable-timestamps
log-info "This message has a timestamp"
# Output: [2025-01-07 15:30:45] [INFO] This message has a timestamp

# Enable with custom format
log-set-timestamp-format "%H:%M:%S"
log-enable-timestamps
log-info "Short timestamp"
# Output: [15:30:45] [INFO] Short timestamp

# ISO 8601 format
log-set-timestamp-format "%Y-%m-%dT%H:%M:%S%z"
log-enable-timestamps
log-info "ISO timestamp"
# Output: [2025-01-07T15:30:45-0500] [INFO] ISO timestamp

# Toggle timestamps
log-enable-timestamps
log-info "With timestamp"
log-disable-timestamps
log-info "Without timestamp"
# Output:
# [2025-01-07 15:30:45] [INFO] With timestamp
# [INFO] Without timestamp
```

**Default Format:** `%Y-%m-%d %H:%M:%S`

**Output Format:**
```
[TIMESTAMP] [LEVEL] MESSAGE
```

**Use Cases:**
- File logging (track when events occurred)
- Debugging (correlate events with external logs)
- Audit trails (timestamp all operations)
- Performance analysis (measure time between log entries)
- Compliance (regulatory requirements for timestamped logs)

**Performance Impact:**
- Adds `date` command invocation per log message
- Overhead: ~0.3ms per message (date command)
- Total: ~0.9ms per message (vs ~0.6ms without timestamps)

**Considerations:**
- Systemd journal adds timestamps automatically (no need for daemon mode)
- Console timestamps useful for file redirection
- Consider disabling for high-frequency logging

**Related Functions:**
- `log-disable-timestamps` - Disable timestamps
- `log-set-timestamp-format` - Change format

**Source Code:** Lines 593-595

```zsh
log-enable-timestamps() {
    LOG_TIMESTAMPS="true"
}
```

---

#### `log-disable-timestamps`

**Metadata:**
- **Lines:** 598-600 (3 lines)
- **Complexity:** Trivial (assignment)
- **Dependencies:** None
- **Used by:** Runtime timestamp control
- **Since:** v1.0.0

**Syntax:**
```zsh
log-disable-timestamps
```

**Description:**

Disable timestamp prefix in log messages. Messages will not include timestamp prefix.

**Parameters:** None

**Returns:** 0 (always succeeds)

**Examples:**

```zsh
# Disable timestamps
log-disable-timestamps
log-info "No timestamp"
# Output: [INFO] No timestamp

# Toggle at runtime
log-enable-timestamps
log-info "With timestamp"
log-disable-timestamps
log-info "Without timestamp"
# Output:
# [2025-01-07 15:30:45] [INFO] With timestamp
# [INFO] Without timestamp
```

**Use Cases:**
- CLI tools (timestamps not needed for interactive use)
- Daemon mode (systemd adds timestamps automatically)
- Cleaner console output
- Performance optimization (high-frequency logging)
- Minimal output formatting

**Performance Benefit:**
- Saves `date` command invocation per message
- Reduces overhead by ~0.3ms per message

**Related Functions:**
- `log-enable-timestamps` - Enable timestamps
- `log-set-timestamp-format` - Change format

**Source Code:** Lines 598-600

```zsh
log-disable-timestamps() {
    LOG_TIMESTAMPS="false"
}
```

---

#### `log-set-timestamp-format`

**Metadata:**
- **Lines:** 604-606 (3 lines)
- **Complexity:** Trivial (assignment)
- **Dependencies:** None (format used by `date` command)
- **Used by:** Timestamp customization
- **Since:** v1.0.0

**Syntax:**
```zsh
log-set-timestamp-format FORMAT
```

**Description:**

Set timestamp format using strftime format string. Format is passed to the `date` command for timestamp generation.

**Parameters:**
- `FORMAT` (string) - strftime format string

**Returns:** 0 (always succeeds)

**Common Formats:**

```zsh
# Default format: 2025-01-07 15:30:45
log-set-timestamp-format "%Y-%m-%d %H:%M:%S"

# Time only: 15:30:45
log-set-timestamp-format "%H:%M:%S"

# ISO 8601: 2025-01-07T15:30:45-0500
log-set-timestamp-format "%Y-%m-%dT%H:%M:%S%z"

# ISO 8601 with timezone: 2025-01-07T15:30:45-05:00
log-set-timestamp-format "%Y-%m-%dT%H:%M:%S%:z"

# RFC 3339: 2025-01-07T15:30:45.123456789-05:00
log-set-timestamp-format "%Y-%m-%dT%H:%M:%S.%N%:z"

# Unix timestamp: 1704650445
log-set-timestamp-format "%s"

# Human-readable: Mon Jan 07 03:30:45 PM EST 2025
log-set-timestamp-format "%a %b %d %I:%M:%S %p %Z %Y"

# Date only: 2025-01-07
log-set-timestamp-format "%Y-%m-%d"

# Time with milliseconds: 15:30:45.123
log-set-timestamp-format "%H:%M:%S.%3N"
```

**Examples:**

```zsh
# ISO 8601 format for JSON logs
log-set-timestamp-format "%Y-%m-%dT%H:%M:%S%z"
log-enable-timestamps
log-enable-json
log-info "API call"
# Output: {"level":"info","message":"API call","timestamp":"2025-01-07T15:30:45-0500"}

# Short time format for development
log-set-timestamp-format "%H:%M:%S"
log-enable-timestamps
log-info "Quick timestamp"
# Output: [15:30:45] [INFO] Quick timestamp

# Microsecond precision for performance analysis
log-set-timestamp-format "%H:%M:%S.%6N"
log-enable-timestamps
log-info "High precision"
# Output: [15:30:45.123456] [INFO] High precision
```

**strftime Format Specifiers:**

| Specifier | Description | Example |
|-----------|-------------|---------|
| `%Y` | Year (4 digits) | 2025 |
| `%m` | Month (01-12) | 01 |
| `%d` | Day of month (01-31) | 07 |
| `%H` | Hour (00-23) | 15 |
| `%M` | Minute (00-59) | 30 |
| `%S` | Second (00-59) | 45 |
| `%N` | Nanoseconds | 123456789 |
| `%3N` | Milliseconds | 123 |
| `%6N` | Microseconds | 123456 |
| `%z` | Timezone offset | -0500 |
| `%:z` | Timezone offset with colon | -05:00 |
| `%s` | Unix timestamp | 1704650445 |
| `%a` | Weekday abbreviation | Mon |
| `%b` | Month abbreviation | Jan |

**Use Cases:**
- ISO 8601 for JSON logs and APIs
- Short format for development/debugging
- High precision for performance analysis
- Custom format for specific requirements
- Locale-specific formats

**Performance:** O(1) assignment, no overhead until timestamps enabled

**Related Functions:**
- `log-enable-timestamps` - Enable timestamps
- `log-disable-timestamps` - Disable timestamps

**Source Code:** Lines 604-606

```zsh
log-set-timestamp-format() {
    LOG_TIMESTAMP_FORMAT="$1"
}
```

---

#### `log-enable-json`

**Metadata:**
- **Lines:** 609-611 (3 lines)
- **Complexity:** Trivial (assignment)
- **Dependencies:** None (jq optional for better formatting)
- **Used by:** JSON output configuration
- **Since:** v1.0.0

**Syntax:**
```zsh
log-enable-json
```

**Description:**

Enable JSON output format for all log messages. Structured data is emitted as JSON objects with fields for level, message, timestamp, and any additional structured fields.

**Parameters:** None

**Returns:** 0 (always succeeds)

**JSON Output Format:**

**Basic Log (with jq available):**
```json
{
  "level": "info",
  "message": "User login",
  "timestamp": "2025-01-07T15:30:45-05:00"
}
```

**Structured Log (with jq available):**
```json
{
  "level": "info",
  "message": "API request",
  "timestamp": "2025-01-07T15:30:45-05:00",
  "method": "POST",
  "path": "/api/users",
  "status": "201",
  "duration_ms": "145"
}
```

**Fallback Format (without jq):**
```json
{"level":"info","message":"API request","timestamp":"2025-01-07T15:30:45-05:00","method":"POST","path":"/api/users","status":"201","duration_ms":"145"}
```

**Examples:**

```zsh
# Enable JSON output
log-enable-json

# Basic logging
log-info "Application started"
# Output: {"level":"info","message":"Application started","timestamp":"2025-01-07T15:30:45-05:00"}

# Structured logging
log-info-with "Request processed" method="GET" path="/api/users" status=200
# Output: {"level":"info","message":"Request processed","timestamp":"2025-01-07T15:30:45-05:00","method":"GET","path":"/api/users","status":"200"}

# With function names
log-enable-function-names
log-info "Test"
# Output: {"level":"info","message":"Test","timestamp":"2025-01-07T15:30:45-05:00","function":"main"}

# Parsing JSON logs
log-enable-json
log-info-with "API call" method="$method" duration_ms=$duration

# Extract specific fields with jq
# ./script.sh | jq -r 'select(.message=="API call") | .duration_ms'
```

**Use Cases:**
- Log aggregation systems (ELK, Splunk, Loki)
- Structured search and filtering
- Machine parsing and analytics
- Metrics extraction
- Automated alerting based on field values
- Integration with monitoring tools
- Export to data analysis tools

**JSON vs Text Output:**

**Text Output:**
```
[INFO] Request processed [method=GET path=/api/users status=200]
```

**JSON Output:**
```json
{"level":"info","message":"Request processed","timestamp":"2025-01-07T15:30:45-05:00","method":"GET","path":"/api/users","status":"200"}
```

**Advantages of JSON:**
- Machine-parseable
- Structured field extraction
- Type-safe (with proper parsing)
- Standard format for log aggregation
- Easy integration with monitoring tools

**Disadvantages:**
- Less human-readable
- Slightly larger output size
- Requires parsing tools for viewing

**Performance:**
- With jq: ~2ms per message (jq invocation overhead)
- Without jq: ~0.8ms per message (string concatenation)
- Recommend: Use jq for development, fallback for production

**Integration Examples:**

```zsh
# ELK Stack integration
log-enable-json
./script.sh | filebeat -c filebeat.yml

# Loki integration
log-enable-json
./script.sh | promtail -config.file=promtail.yml

# Simple analysis with jq
journalctl --user -t myapp -o json | jq -r 'select(.level=="error")'
```

**Related Functions:**
- `log-disable-json` - Return to text format
- All `*-with` functions - Add structured fields

**Source Code:** Lines 609-611

```zsh
log-enable-json() {
    LOG_OUTPUT_FORMAT="json"
}
```

---

#### `log-disable-json`

**Metadata:**
- **Lines:** 614-616 (3 lines)
- **Complexity:** Trivial (assignment)
- **Dependencies:** None
- **Used by:** Output format control
- **Since:** v1.0.0

**Syntax:**
```zsh
log-disable-json
```

**Description:**

Disable JSON output format and return to human-readable text format.

**Parameters:** None

**Returns:** 0 (always succeeds)

**Examples:**

```zsh
# Disable JSON (return to text)
log-disable-json
log-info "Human readable"
# Output: [INFO] Human readable

# Toggle between formats
log-enable-json
log-info "JSON output"
log-disable-json
log-info "Text output"
# Output:
# {"level":"info","message":"JSON output","timestamp":"..."}
# [INFO] Text output

# Runtime switching based on environment
if [[ "${LOG_FORMAT:-text}" == "json" ]]; then
    log-enable-json
else
    log-disable-json
fi
```

**Use Cases:**
- Default human-readable console output
- Development/debugging (easier to read)
- Interactive CLI tools
- Simple logging without aggregation needs

**Related Functions:**
- `log-enable-json` - Enable JSON output

**Source Code:** Lines 614-616

```zsh
log-disable-json() {
    LOG_OUTPUT_FORMAT="text"
}
```

---

Due to length constraints, I'll continue the documentation in the next message. The API Reference is quite extensive with 38 functions to document comprehensively. Let me continue with the remaining functions:

