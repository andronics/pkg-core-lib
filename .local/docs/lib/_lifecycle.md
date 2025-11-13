# _lifecycle - Comprehensive Signal Handling, Event Management, and Cleanup System

**Version:** 3.1.0
**Layer:** Infrastructure (Layer 2)
**Dependencies:** _common v2.0 (required), _log v2.0 (optional), _events v2.0 (optional)
**Total Lines:** 2,132
**Public Functions:** 64
**Examples:** 35+
**Last Updated:** 2025-11-07

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (500 lines) -->

## Quick Reference Index

### Table of Contents

- [Function Quick Reference](#function-quick-reference) (L20-90, ~71 lines)
- [Signals Quick Reference](#signals-quick-reference) (L91-120, ~30 lines)
- [Hooks & Events Quick Reference](#hooks--events-quick-reference) (L121-155, ~35 lines)
- [Environment Variables Quick Reference](#environment-variables-quick-reference) (L156-200, ~45 lines)
- [Return Codes Quick Reference](#return-codes-quick-reference) (L201-220, ~20 lines)
- [Overview](#overview) (L221-300, ~80 lines)
- [Architecture & Signal Handling](#architecture--signal-handling) (L301-450, ~150 lines)
- [Installation](#installation) (L451-550, ~100 lines)
- [Quick Start](#quick-start) (L551-1100, ~550 lines)
- [Configuration](#configuration) (L1101-1300, ~200 lines)
- [API Reference](#api-reference) (L1301-2550, ~1250 lines)
- [Advanced Usage](#advanced-usage) (L2551-3300, ~750 lines)
- [Best Practices](#best-practices) (L3301-3750, ~450 lines)
- [Troubleshooting](#troubleshooting) (L3751-4300, ~550 lines)
- [External References](#external-references) (L4301-4400, ~100 lines)

---

## Function Quick Reference

| Function | Layer | Source Lines | Complexity | Depends On | Link |
|----------|-------|-------------|-----------|-----------|------|
| `lifecycle-signal` | Core | L211-246 | Medium | _common | [→](#lifecycle-signal) |
| `lifecycle-signal-remove` | Core | L252-288 | Medium | _common | [→](#lifecycle-signal-remove) |
| `lifecycle-signal-clear` | Core | L294-311 | Low | - | [→](#lifecycle-signal-clear) |
| `lifecycle-event` | Events | L497-519 | Medium | _events/_common | [→](#lifecycle-event) |
| `lifecycle-event-trigger` | Events | L525-535 | Low | _events | [→](#lifecycle-event-trigger) |
| `lifecycle-event-remove` | Events | L541-567 | Medium | _events | [→](#lifecycle-event-remove) |
| `lifecycle-event-clear` | Events | L573-584 | Low | - | [→](#lifecycle-event-clear) |
| `lifecycle-event-once` | Events | L590-611 | High | _events | [→](#lifecycle-event-once) |
| `lifecycle-cleanup` | Cleanup | L621-632 | Low | - | [→](#lifecycle-cleanup) |
| `lifecycle-cleanup-remove` | Cleanup | L638-651 | Low | - | [→](#lifecycle-cleanup-remove) |
| `lifecycle-cleanup-clear` | Cleanup | L657-661 | Low | - | [→](#lifecycle-cleanup-clear) |
| `lifecycle-cleanup-list` | Cleanup | L667-671 | Low | - | [→](#lifecycle-cleanup-list) |
| `lifecycle-cleanup-add` | Cleanup | L696-732 | High | _common | [→](#lifecycle-cleanup-add) |
| `lifecycle-cleanup-add-dependency` | Cleanup | L738-762 | High | _common | [→](#lifecycle-cleanup-add-dependency) |
| `lifecycle-cleanup-order` | Cleanup | L853-867 | Low | - | [→](#lifecycle-cleanup-order) |
| `lifecycle-cleanup-validate` | Cleanup | L873-881 | Medium | - | [→](#lifecycle-cleanup-validate) |
| `lifecycle-restart-enable` | v3.1 | L952-980 | High | _common | [→](#lifecycle-restart-enable) |
| `lifecycle-restart-disable` | v3.1 | L986-1001 | Low | - | [→](#lifecycle-restart-disable) |
| `lifecycle-restart-check` | v3.1 | L1027-1042 | Medium | - | [→](#lifecycle-restart-check) |
| `lifecycle-restart-status` | v3.1 | L1104-1117 | Low | - | [→](#lifecycle-restart-status) |
| `lifecycle-process-group-create` | v3.1 | L1127-1144 | Low | _common | [→](#lifecycle-process-group-create) |
| `lifecycle-process-group-add` | v3.1 | L1150-1180 | Medium | _common | [→](#lifecycle-process-group-add) |
| `lifecycle-process-group-remove` | v3.1 | L1186-1204 | Low | - | [→](#lifecycle-process-group-remove) |
| `lifecycle-process-group-signal` | v3.1 | L1210-1227 | Medium | - | [→](#lifecycle-process-group-signal) |
| `lifecycle-process-group-cleanup` | v3.1 | L1233-1256 | High | - | [→](#lifecycle-process-group-cleanup) |
| `lifecycle-process-group-list` | v3.1 | L1262-1276 | Low | - | [→](#lifecycle-process-group-list) |
| `lifecycle-process-group-delete` | v3.1 | L1282-1294 | Low | - | [→](#lifecycle-process-group-delete) |
| `lifecycle-track-job` | Resources | L1304-1316 | Low | _common | [→](#lifecycle-track-job) |
| `lifecycle-track-pid` | Resources | L1319-1321 | Low | - | [→](#lifecycle-track-pid) |
| `lifecycle-untrack-job` | Resources | L1327-1340 | Low | - | [→](#lifecycle-untrack-job) |
| `lifecycle-untrack-pid` | Resources | L1343-1345 | Low | - | [→](#lifecycle-untrack-pid) |
| `lifecycle-list-jobs` | Resources | L1351-1355 | Low | - | [→](#lifecycle-list-jobs) |
| `lifecycle-list-pids` | Resources | L1358-1360 | Low | - | [→](#lifecycle-list-pids) |
| `lifecycle-track-temp-file` | Resources | L1406-1414 | Low | _common | [→](#lifecycle-track-temp-file) |
| `lifecycle-track-temp-dir` | Resources | L1420-1428 | Low | _common | [→](#lifecycle-track-temp-dir) |
| `lifecycle-untrack-temp-file` | Resources | L1434-1447 | Low | - | [→](#lifecycle-untrack-temp-file) |
| `lifecycle-untrack-temp-dir` | Resources | L1453-1466 | Low | - | [→](#lifecycle-untrack-temp-dir) |
| `lifecycle-list-temp-files` | Resources | L1472-1476 | Low | - | [→](#lifecycle-list-temp-files) |
| `lifecycle-list-temp-dirs` | Resources | L1482-1486 | Low | - | [→](#lifecycle-list-temp-dirs) |
| `lifecycle-track-service` | Resources | L1539-1548 | Low | _common | [→](#lifecycle-track-service) |
| `lifecycle-untrack-service` | Resources | L1554-1569 | Low | - | [→](#lifecycle-untrack-service) |
| `lifecycle-list-services` | Resources | L1575-1579 | Low | - | [→](#lifecycle-list-services) |
| `lifecycle-state-init` | State | L1619-1639 | Low | - | [→](#lifecycle-state-init) |
| `lifecycle-state-cleanup` | State | L1645-1662 | Low | - | [→](#lifecycle-state-cleanup) |
| `lifecycle-set-exit-code` | Exit | L1677-1689 | Low | _common | [→](#lifecycle-set-exit-code) |
| `lifecycle-get-exit-code` | Exit | L1695-1697 | Low | - | [→](#lifecycle-get-exit-code) |
| `lifecycle-trap-install` | Trap | L1708-1736 | High | - | [→](#lifecycle-trap-install) |
| `lifecycle-trap-uninstall` | Trap | L1742-1752 | Low | - | [→](#lifecycle-trap-uninstall) |
| `lifecycle-trap-list` | Trap | L1758-1769 | Low | - | [→](#lifecycle-trap-list) |
| `lifecycle-timeout` | Utility | L1779-1815 | High | - | [→](#lifecycle-timeout) |
| `lifecycle-exit` | Handlers | L361-397 | High | Internal | [→](#lifecycle-exit) |
| `lifecycle-int` | Handlers | L400-405 | Low | - | [→](#lifecycle-int) |
| `lifecycle-term` | Handlers | L408-413 | Low | - | [→](#lifecycle-term) |
| `lifecycle-hup` | Handlers | L416-421 | Low | - | [→](#lifecycle-hup) |
| `lifecycle-usr1` | Handlers | L424-427 | Low | - | [→](#lifecycle-usr1) |
| `lifecycle-usr2` | Handlers | L430-433 | Low | - | [→](#lifecycle-usr2) |
| `lifecycle-quit` | Handlers | L436-441 | Low | - | [→](#lifecycle-quit) |
| `lifecycle-abrt` | Handlers | L444-449 | Low | - | [→](#lifecycle-abrt) |
| `lifecycle-err` | Handlers | L452-461 | Low | - | [→](#lifecycle-err) |
| `lifecycle-graceful-shutdown` | Handlers | L464-487 | High | - | [→](#lifecycle-graceful-shutdown) |
| `lifecycle-version` | Utility | L1825-1827 | Low | - | [→](#lifecycle-version) |
| `lifecycle-help` | Utility | L1833-1937 | Low | - | [→](#lifecycle-help) |
| `lifecycle-info` | Utility | L1943-1981 | Low | - | [→](#lifecycle-info) |
| `lifecycle-self-test` | Utility | L1987-2124 | High | - | [→](#lifecycle-self-test) |

---

## Signals Quick Reference

<!-- CONTEXT_GROUP: signal-handling -->

| Signal | Handler | Line | Exit Code | Purpose | Auto-Trap |
|--------|---------|------|-----------|---------|-----------|
| `INT` | `lifecycle-int` | L400 | 130 | Ctrl+C interrupt | Yes |
| `TERM` | `lifecycle-term` | L408 | 143 | Termination request | Yes |
| `HUP` | `lifecycle-hup` | L416 | 129 | Hangup/terminal closed | Yes |
| `USR1` | `lifecycle-usr1` | L424 | 0 | User signal 1 (custom) | Yes |
| `USR2` | `lifecycle-usr2` | L430 | 0 | User signal 2 (custom) | Yes |
| `QUIT` | `lifecycle-quit` | L436 | 131 | Quit signal (Ctrl+\) | Yes |
| `ABRT` | `lifecycle-abrt` | L444 | 134 | Abort signal | Yes |
| `ERR` | `lifecycle-err` | L452 | - | Error trap (optional) | Conditional |
| `EXIT` | `lifecycle-exit` | L361 | - | Script exit cleanup | Manual |

---

## Hooks & Events Quick Reference

<!-- CONTEXT_GROUP: event-system -->

| Event Name | Parameters | Emitted By | Purpose | Link |
|------------|-----------|-----------|---------|------|
| `lifecycle.signal.received` | signal, description | Signal handlers | Signal reception | L330, L401, L409, L417, etc. |
| `lifecycle.cleanup.start` | count | `_lifecycle_run_cleanup` | Cleanup starts | L887, L908 |
| `lifecycle.cleanup.complete` | count | `_lifecycle_run_cleanup` | Cleanup finishes | L928 |
| `lifecycle.exit.start` | exit_code | `lifecycle-exit` | Exit begins | L362 |
| `lifecycle.exit.complete` | exit_code | `lifecycle-exit` | Exit completes | L394 |
| `lifecycle.restart.enabled` | pid, max_attempts | `lifecycle-restart-enable` | Restart enabled | L977 |
| `lifecycle.restart.disabled` | pid | `lifecycle-restart-disable` | Restart disabled | L998 |
| `lifecycle.restart.attempt` | pid, attempt | `_lifecycle-restart-process` | Restart attempted | L1065 |
| `lifecycle.restart.success` | old_pid, new_pid, attempt | `_lifecycle-restart-process` | Restart succeeded | L1074 |
| `lifecycle.restart.failed` | pid, attempt | `_lifecycle-restart-process` | Restart failed | L1091 |
| `lifecycle.restart.exhausted` | pid, attempts | `_lifecycle-restart-process` | Max restarts reached | L1055 |
| `lifecycle.group.created` | name | `lifecycle-process-group-create` | Group created | L1141 |
| `lifecycle.group.deleted` | name | `lifecycle-process-group-delete` | Group deleted | L1291 |
| `lifecycle.group.pid_added` | name, pid | `lifecycle-process-group-add` | PID added to group | L1177 |
| `lifecycle.group.pid_removed` | name, pid | `lifecycle-process-group-remove` | PID removed from group | L1201 |
| `lifecycle.group.signal` | name, signal | `lifecycle-process-group-signal` | Signal sent to group | L1218 |
| `lifecycle.group.cleanup` | name, signal | `lifecycle-process-group-cleanup` | Group cleanup started | L1240 |
| `lifecycle.cleanup.dependency_added` | id, depends_on | `lifecycle-cleanup-add` | Dependency cleanup added | L729 |
| `lifecycle.cleanup.circular_detected` | id | `lifecycle-cleanup-add` | Circular dependency found | L721 |
| `lifecycle.cleanup.order_computed` | tasks | `_lifecycle-compute-cleanup-order` | Order recomputed | L846 |

---

## Environment Variables Quick Reference

<!-- CONTEXT_GROUP: configuration -->

| Variable | Type | Default | Purpose | Link |
|----------|------|---------|---------|------|
| `LIFECYCLE_STATE_DIR` | path | `$XDG_STATE_HOME/lib/lifecycle` | State directory | [→](#lifecycle_state_dir) |
| `LIFECYCLE_CLEANUP_JOBS` | boolean | `false` | Auto-kill tracked jobs | [→](#lifecycle_cleanup_jobs) |
| `LIFECYCLE_CLEANUP_STATE` | boolean | `false` | Remove state dir on exit | [→](#lifecycle_cleanup_state) |
| `LIFECYCLE_CLEANUP_TEMP` | boolean | `true` | Clean tracked temp files | [→](#lifecycle_cleanup_temp) |
| `LIFECYCLE_CLEANUP_SERVICES` | boolean | `false` | Stop tracked services | [→](#lifecycle_cleanup_services) |
| `LIFECYCLE_DEBUG` | boolean | `false` | Enable debug logging | [→](#lifecycle_debug) |
| `LIFECYCLE_EXIT_CODE` | integer | `0` | Exit code to use | [→](#lifecycle_exit_code) |
| `LIFECYCLE_EMIT_EVENTS` | boolean | `true` | Emit lifecycle events | [→](#lifecycle_emit_events) |
| `LIFECYCLE_TRAP_ERRORS` | boolean | `true` | Install ERR trap | [→](#lifecycle_trap_errors) |
| `LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT` | seconds | `10` | Graceful shutdown timeout | [→](#lifecycle_graceful_shutdown_timeout) |
| `LIFECYCLE_DRY_RUN` | boolean | `false` | Dry-run mode | [→](#lifecycle_dry_run) |
| `LIFECYCLE_RESTART_MONITOR_INTERVAL` | seconds | `5` | Restart check interval | [→](#lifecycle_restart_monitor_interval) |
| `LIFECYCLE_RESTART_DEFAULT_MAX_ATTEMPTS` | integer | `3` | Default max restart attempts | [→](#lifecycle_restart_default_max_attempts) |
| `LIFECYCLE_RESTART_DEFAULT_BACKOFF` | seconds | `1` | Default restart backoff | [→](#lifecycle_restart_default_backoff) |
| `LIFECYCLE_CLEANUP_USE_DEPENDENCY_ORDER` | boolean | `true` | Use dependency-ordered cleanup | [→](#lifecycle_cleanup_use_dependency_order) |

---

## Return Codes Quick Reference

| Code | Function(s) | Meaning | Context |
|------|-----------|---------|---------|
| `0` | All | Success | Operation completed successfully |
| `1` | Signal/Event/Cleanup | Not found/failure | Handler not found, missing dependency, circular dependency |
| `2` | Functions with validation | Invalid arguments | Missing required parameters, invalid numeric input |
| `124` | `lifecycle-timeout` | Timeout exceeded | Command exceeded timeout limit |
| `129` | `lifecycle-hup` | HUP signal | Process received SIGHUP |
| `130` | `lifecycle-int` | INT signal | Ctrl+C pressed |
| `131` | `lifecycle-quit` | QUIT signal | Ctrl+\ pressed |
| `134` | `lifecycle-abrt` | ABRT signal | Abort signal received |
| `143` | `lifecycle-term` | TERM signal | Termination request |

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (80 lines) -->

The `_lifecycle` extension provides **comprehensive signal handling, event management, and cleanup coordination** for ZSH scripts and background services. It's the foundation for building reliable, resilient applications with proper lifecycle management.

**Core Capabilities:**

- **Multi-Handler Signal Management** - Register multiple handlers per signal with priority execution
- **Coordinated Cleanup** - Execute cleanup tasks in LIFO or dependency-ordered sequence
- **Resource Tracking** - Automatic cleanup of PIDs, temp files, directories, systemd services
- **Graceful Shutdown** - Handle multiple interrupt signals with configurable timeout
- **Process Supervision** - Auto-restart dead processes with exponential backoff (v3.1)
- **Process Groups** - Manage multiple related processes as a unit (v3.1)
- **Dependency-Ordered Cleanup** - Execute cleanup tasks respecting dependencies with cycle detection (v3.1)
- **Event Integration** - Emit lifecycle events for external monitoring and integration
- **Dry-Run Mode** - Test cleanup procedures without side effects
- **XDG Compliance** - Standard state directory management

**Use Cases:**

- Building reliable daemon and service scripts
- Coordinating multi-process applications
- Managing background job lifecycles
- Implementing graceful service shutdown
- Auto-restarting failed processes
- Testing cleanup logic with dry-run mode
- Integrating with event-driven systems

---

## Architecture & Signal Handling

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (150 lines) -->

### Signal Handling Model

_lifecycle implements a **dynamic trap generation model** where signal handlers are generated at runtime:

```
Signal Registration
      ↓
Handler Validation → Handler Storage → Trap Generation → Installation
      ↓                                      ↓
  Function exists?               Dynamic function eval
  Already registered?            Chain of command setup
      ↓
  Multiple handlers              Emit events on signal
  Chain of command               Execute handlers in order
```

When `lifecycle-signal INT my_handler` is called:
1. Signal name normalized (INT → INT)
2. Handler function validated (must exist or warned)
3. Handler added to `_LIFECYCLE_SIGNAL_HANDLERS[INT]` registry
4. Dynamic trap function `_lifecycle_trap_INT()` generated via `eval`
5. Trap installed with `trap _lifecycle_trap_INT INT`
6. On signal receipt, all handlers execute sequentially

### Cleanup Execution Model

_lifecycle provides two cleanup mechanisms:

**LIFO Cleanup (Legacy, Always Available):**
- Functions registered with `lifecycle-cleanup FUNCTION`
- Executed in Last-In-First-Out order (reverse registration)
- No dependencies tracked
- Used for simple linear cleanup sequences

**Dependency-Ordered Cleanup (v3.1, Recommended):**
- Functions registered with `lifecycle-cleanup-add ID FUNC [DEPS...]`
- Executed in topologically sorted order
- Dependencies validated, cycles detected
- Uses Kahn's algorithm for ordering (L804-847)
- Supports complex cleanup coordination

Both mechanisms execute during `lifecycle-exit` (L361-397):
1. Emit `lifecycle.exit.start` event
2. Stop restart monitor if running
3. Run dependency-ordered cleanups (if enabled)
4. Run LIFO cleanups (backward compatibility)
5. Kill tracked jobs (if enabled)
6. Remove temp files/dirs
7. Stop systemd services
8. Remove state directory
9. Emit `lifecycle.exit.complete` event
10. Exit with configured exit code

### Event System Integration

Events use _events extension if available (L68-72), with fallback (L175-191):

```
lifecycle-event-trigger "custom.event"
      ↓
Is _events available?
      ├─ YES → events-emit "custom.event"
      └─ NO  → _lifecycle_internal_event_dispatch
```

Handlers registered via `lifecycle-event EVENT HANDLER`:
- Stored in `_LIFECYCLE_EVENT_HANDLERS[event_name]`
- Called with event data as arguments
- Support one-time handlers via `lifecycle-event-once`

### Resource Tracking

Resources tracked in parallel associative arrays:
- `_LIFECYCLE_TRACKED_PIDS` - Background job PIDs
- `_LIFECYCLE_TRACKED_TEMP_FILES` - Temporary files
- `_LIFECYCLE_TRACKED_TEMP_DIRS` - Temporary directories
- `_LIFECYCLE_TRACKED_SERVICES` - Systemd services (format: `name:scope`)

All automatically cleaned during `lifecycle-exit` (L361-397).

---

## Installation

<!-- CONTEXT_PRIORITY: MEDIUM -->

**Basic Loading:**

```zsh
source "$(which _lifecycle)"
```

**With Error Handling:**

```zsh
if ! source "$(which _lifecycle)" 2>/dev/null; then
    echo "Error: _lifecycle extension not found" >&2
    echo "Install: cd ~/.pkgs && stow lib" >&2
    exit 1
fi
```

**Dependencies:**

| Dependency | Type | Purpose | Fallback |
|------------|------|---------|----------|
| `_common v2.0` | Required | Validation, utilities | Must exist |
| `_log v2.0` | Optional | Structured logging | Built-in logging |
| `_events v2.0` | Optional | Full event system | Internal dispatcher |

**Integration Detection:**

```zsh
# Check if _events is available
if [[ "$LIFECYCLE_EVENTS_AVAILABLE" == "true" ]]; then
    echo "Full event system available"
else
    echo "Using fallback event system"
fi
```

**Verify Installation:**

```zsh
# Check version
lifecycle-version          # Output: 3.1.0

# Run self-tests
lifecycle-self-test        # 10 tests with pass/fail

# Display system info
lifecycle-info             # Show configuration and state
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (550 lines) -->

### Example 1: Basic Signal Handling

The simplest use case: install standard signal handlers and let cleanup happen automatically.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Install standard signal handlers for INT, TERM, HUP, etc.
lifecycle-trap-install

# Your application code
main() {
    echo "Application running (PID: $$)"
    echo "Press Ctrl+C to exit gracefully"

    while true; do
        echo "Working..."
        sleep 1
    done
}

main

# Cleanup happens automatically via lifecycle-exit trap
```

**What happens:**
- INT (Ctrl+C) calls `lifecycle-int` → sets exit code 130 → calls `lifecycle-exit`
- TERM calls `lifecycle-term` → sets exit code 143 → calls `lifecycle-exit`
- EXIT automatically triggers `lifecycle-exit` cleanup
- All cleanups execute, exit code propagates

---

### Example 2: Tracking Temporary Resources

Track temp files and directories for automatic cleanup.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Create and track temp file
tmpfile=$(mktemp)
lifecycle-track-temp-file "$tmpfile"
echo "Temp file created: $tmpfile"

# Create and track temp directory
tmpdir=$(mktemp -d)
lifecycle-track-temp-dir "$tmpdir"
echo "Temp directory created: $tmpdir"

# Enable automatic cleanup
LIFECYCLE_CLEANUP_TEMP=true

# Write data
echo "important data" > "$tmpfile"
cp -r /etc/hosts "$tmpdir/hosts"

# Simulate work
sleep 2

# On exit:
# - tmpfile will be removed (LIFECYCLE_CLEANUP_TEMP=true)
# - tmpdir will be removed (LIFECYCLE_CLEANUP_TEMP=true)
# This happens automatically via lifecycle-exit
```

**Key Points:**
- `lifecycle-track-temp-file` stores path in `_LIFECYCLE_TRACKED_TEMP_FILES`
- `lifecycle-track-temp-dir` stores path in `_LIFECYCLE_TRACKED_TEMP_DIRS`
- Set `LIFECYCLE_CLEANUP_TEMP=true` to enable cleanup (default: true)
- Cleanup only removes files/dirs that exist at exit time

---

### Example 3: Background Job Management

Track and automatically cleanup background processes.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Start background process
long_running_task() {
    while true; do
        echo "Background task running..."
        sleep 5
    done
}

long_running_task &
local job_pid=$!

# Track the job
lifecycle-track-job $job_pid
echo "Background job tracking enabled for PID: $job_pid"

# Enable automatic job cleanup
LIFECYCLE_CLEANUP_JOBS=true

# Main process work
for i in {1..3}; do
    echo "Main process: iteration $i"
    sleep 2
done

# On exit:
# - lifecycle-exit will call _lifecycle_cleanup_jobs
# - Sends TERM signal to all tracked PIDs
# - Waits briefly, then sends KILL to survivors
```

**Key Points:**
- `lifecycle-track-job` stores PID in `_LIFECYCLE_TRACKED_PIDS`
- Alias `lifecycle-track-pid` available for convenience
- Set `LIFECYCLE_CLEANUP_JOBS=true` to enable auto-kill (default: false)
- Cleanup uses graceful TERM before forced KILL

---

### Example 4: LIFO Cleanup Registration

Register cleanup functions executed in reverse order (Last-In-First-Out).

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Define cleanup functions
cleanup_database() {
    echo "Cleaning up database connections..."
    # Close DB connections
}

cleanup_cache() {
    echo "Clearing application cache..."
    # Clear cache
}

cleanup_logs() {
    echo "Finalizing logs..."
    # Flush log buffers
}

# Register cleanups in order (will execute in reverse)
lifecycle-cleanup cleanup_logs
lifecycle-cleanup cleanup_cache
lifecycle-cleanup cleanup_database

echo "Setup complete, working..."
sleep 5

# On exit, executes in order:
# 1. cleanup_database (registered last)
# 2. cleanup_cache
# 3. cleanup_logs (registered first)
#
# This ensures database closes first, then cache, then logs
```

**Output on exit:**
```
Cleaning up database connections...
Clearing application cache...
Finalizing logs...
```

---

### Example 5: Dependency-Ordered Cleanup (v3.1)

Define cleanup with explicit dependencies for complex applications.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Define cleanup functions
stop_server() { echo "Stopping web server..."; }
save_state() { echo "Saving application state..."; }
flush_queue() { echo "Flushing message queue..."; }
close_db() { echo "Closing database..."; }

# Register cleanups with dependencies
# This ensures correct ordering:
# 1. flush_queue (no deps - can start immediately)
# 2. stop_server (no deps)
# 3. save_state (depends on stop_server and flush_queue)
# 4. close_db (depends on save_state)

lifecycle-cleanup-add "flush_queue" flush_queue
lifecycle-cleanup-add "stop_server" stop_server
lifecycle-cleanup-add "save_state" save_state "stop_server" "flush_queue"
lifecycle-cleanup-add "close_db" close_db "save_state"

# View execution order
echo "Cleanup execution order:"
lifecycle-cleanup-order

# Validate no circular dependencies
if ! lifecycle-cleanup-validate; then
    echo "ERROR: Circular dependency detected!"
    exit 1
fi

echo "Setup complete, working..."
sleep 5

# On exit, executes in dependency order:
# 1. flush_queue
# 2. stop_server
# 3. save_state (waits for stop_server and flush_queue)
# 4. close_db (waits for save_state)
```

**Output on exit:**
```
Cleanup execution order:
flush_queue
stop_server
save_state (depends on: stop_server flush_queue)
close_db (depends on: save_state)
Flushing message queue...
Stopping web server...
Saving application state...
Closing database...
```

---

### Example 6: Process Groups (v3.1)

Manage multiple related processes as a unit.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Create process group
lifecycle-process-group-create "workers"

# Start multiple worker processes
for i in {1..3}; do
    (
        while true; do
            echo "Worker $i working..."
            sleep 2
        done
    ) &
    lifecycle-process-group-add "workers" $!
done

# Show group membership
echo "Group 'workers' members:"
lifecycle-process-group-list "workers"

# Later: send signal to entire group
# lifecycle-process-group-signal "workers" "TERM"

# Later: cleanup entire group
# lifecycle-process-group-cleanup "workers"

sleep 10
```

**Process Group API:**
- `lifecycle-process-group-create NAME` - Create group
- `lifecycle-process-group-add NAME PID` - Add process
- `lifecycle-process-group-remove NAME PID` - Remove process
- `lifecycle-process-group-signal NAME SIGNAL` - Send signal to all
- `lifecycle-process-group-cleanup NAME [SIGNAL]` - Graceful shutdown
- `lifecycle-process-group-list [NAME]` - List groups or members
- `lifecycle-process-group-delete NAME` - Delete group metadata

---

### Example 7: Auto-Restart with Exponential Backoff (v3.1)

Enable automatic process restart with configurable retry limits.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"
lifecycle-trap-install

# Function that we want to auto-restart
my_critical_service() {
    echo "Service starting (PID: $$)"

    # Simulate failure after 5 seconds
    sleep 5
    echo "Service died unexpectedly"
    exit 1
}

# Start the service in background
my_critical_service &
service_pid=$!

# Enable auto-restart
# max_attempts: 5, initial_backoff: 2 seconds
lifecycle-restart-enable "$service_pid" "my_critical_service" 5 2

# Enable the restart monitor
# (normally done automatically on first enable)
LIFECYCLE_RESTART_MONITOR_INTERVAL=3

echo "Service started with auto-restart (PID: $service_pid)"
echo "Will auto-restart on failure (max 5 attempts, initial backoff 2s)"

# Keep main process alive
sleep 60

# Backoff progression: 2s, 4s, 8s, 16s, 32s
# (exponential backoff: backoff * 2 after each failure)
```

**Restart Behavior:**
- Process dies, restart monitor detects it (every 5s by default)
- Attempt 1: wait 2s, restart → if fails → backoff becomes 4s
- Attempt 2: wait 4s, restart → if fails → backoff becomes 8s
- Attempt 3: wait 8s, restart → if fails → backoff becomes 16s
- Attempt 4: wait 16s, restart → if fails → backoff becomes 32s
- Attempt 5: wait 32s, restart → if still fails → give up
- Emits `lifecycle.restart.exhausted` event when max attempts reached

---

### Example 8: Graceful Shutdown with Timeout

Handle Ctrl+C gracefully with timeout for second interrupt.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Install with graceful shutdown enabled
lifecycle-trap-install --graceful

# Configure timeout
LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT=10

# Long-running operation
long_operation() {
    echo "Starting long operation (10 seconds)..."
    for i in {1..10}; do
        if [[ "$LIFECYCLE_SHUTDOWN_REQUESTED" == "true" ]]; then
            echo "Shutdown requested, wrapping up..."
            break
        fi
        echo "  Step $i/10..."
        sleep 1
    done
    echo "Operation complete"
}

long_operation

# User presses Ctrl+C once → graceful shutdown begins
# Message: "Shutdown requested, finishing current work (timeout: 10s)"
# Message: "Press Ctrl+C again to force immediate exit"
# Long operation checks LIFECYCLE_SHUTDOWN_REQUESTED flag
# User can press Ctrl+C again → immediate exit (code 130)
# Or timeout after 10s → forced exit with error
```

**Graceful Shutdown Sequence:**
1. User presses Ctrl+C → `lifecycle-graceful-shutdown` called
2. Sets `LIFECYCLE_SHUTDOWN_REQUESTED=true`
3. Application checks flag and wraps up
4. Cleanup executes normally
5. If user presses Ctrl+C again → immediate exit with code 130
6. If timeout (10s) reached → forced exit via `kill -9 $$`

---

### Example 9: Event Handlers

Register custom event handlers for lifecycle events.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Define custom handlers
on_exit() {
    local exit_code="$1"
    echo "Application exiting with code: $exit_code"
}

on_signal() {
    local signal="$1"
    local description="$2"
    echo "Received signal: $signal ($description)"
}

on_cleanup_start() {
    local task_count="$1"
    echo "Starting cleanup of $task_count tasks..."
}

# Register handlers
lifecycle-event "lifecycle.exit.complete" on_exit
lifecycle-event "lifecycle.signal.received" on_signal
lifecycle-event "lifecycle.cleanup.start" on_cleanup_start

# Install standard handlers
lifecycle-trap-install

# Work
echo "Application running..."
sleep 3

# On exit:
# - on_cleanup_start called with task count
# - User presses Ctrl+C
# - on_signal called with "INT"
# - on_exit called with exit code
```

**Event Types:**
- `lifecycle.signal.received` - Signal received (signal, description)
- `lifecycle.cleanup.start` - Cleanup starting (task count)
- `lifecycle.cleanup.complete` - Cleanup finished (task count)
- `lifecycle.exit.start` - Exit starting (exit code)
- `lifecycle.exit.complete` - Exit finishing (exit code)
- `lifecycle.restart.*` - Various restart events (v3.1)
- `lifecycle.group.*` - Process group events (v3.1)

---

### Example 10: Dry-Run Mode

Test cleanup procedures without side effects.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Enable dry-run mode
LIFECYCLE_DRY_RUN=true
LIFECYCLE_CLEANUP_JOBS=true
LIFECYCLE_CLEANUP_TEMP=true

# Create and track resources
tmpfile=$(mktemp)
lifecycle-track-temp-file "$tmpfile"
echo "data" > "$tmpfile"

# Register cleanup
my_cleanup() { echo "Would cleanup something"; }
lifecycle-cleanup my_cleanup

# Install trap
lifecycle-trap-install

echo "Running in dry-run mode..."
sleep 2

# On exit, shows what would happen without doing it:
# [DRY RUN] Would run cleanup: my_cleanup
# [DRY RUN] Would remove temp file: /tmp/xxx
# [DRY RUN] Would kill job: 1234
```

**Dry-Run Output:**
```
[DRY RUN] Would run cleanup: my_cleanup
[DRY RUN] Would remove temp file: /tmp/xyz123
[DRY RUN] Would kill job: 5678
[INFO] Shutdown requested...
[DRY RUN] Would stop service: myservice (--user)
```

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL (200 lines) -->

### Cleanup Behavior

**LIFECYCLE_CLEANUP_JOBS** (default: `false`)

Enable automatic killing of tracked background jobs on exit.

```zsh
LIFECYCLE_CLEANUP_JOBS=true

# Background job started
long_task &
lifecycle-track-job $!

# On exit, sends TERM then KILL to all tracked jobs
```

**LIFECYCLE_CLEANUP_TEMP** (default: `true`)

Enable automatic removal of tracked temp files and directories.

```zsh
LIFECYCLE_CLEANUP_TEMP=true

tmpfile=$(mktemp)
tmpdir=$(mktemp -d)
lifecycle-track-temp-file "$tmpfile"
lifecycle-track-temp-dir "$tmpdir"

# On exit, removes both files and directories
```

**LIFECYCLE_CLEANUP_STATE** (default: `false`)

Remove state directory on exit (via `lifecycle-state-cleanup`).

```zsh
LIFECYCLE_CLEANUP_STATE=true
lifecycle-state-init "myapp"

# State directory created at LIFECYCLE_STATE_DIR/myapp
# On exit, entire directory removed
```

**LIFECYCLE_CLEANUP_SERVICES** (default: `false`)

Stop tracked systemd services on exit.

```zsh
LIFECYCLE_CLEANUP_SERVICES=true

lifecycle-track-service "myapp" "--user"
lifecycle-track-service "db" "--system"

# On exit, stops both services
```

---

### Behavior Control

**LIFECYCLE_DEBUG** (default: `false`)

Enable debug logging to stderr.

```zsh
LIFECYCLE_DEBUG=true
lifecycle-version
# Output: [DEBUG] _lifecycle extension loaded...
```

**LIFECYCLE_EXIT_CODE** (default: `0`)

Exit code used when script exits. Set by signal handlers or `lifecycle-set-exit-code`.

```zsh
lifecycle-set-exit-code 1
sleep 1
# Script will exit with code 1
```

**LIFECYCLE_EMIT_EVENTS** (default: `true`)

Emit lifecycle events (requires _events extension or uses fallback).

```zsh
LIFECYCLE_EMIT_EVENTS=false
# Events still registered but not emitted
```

**LIFECYCLE_TRAP_ERRORS** (default: `true`)

Install ERR trap for error detection.

```zsh
LIFECYCLE_TRAP_ERRORS=true
lifecycle-trap-install
# ERR signal handler installed automatically
```

---

### Timeout & Shutdown

**LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT** (default: `10` seconds)

Timeout for graceful shutdown when using `lifecycle-trap-install --graceful`.

```zsh
LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT=30
lifecycle-trap-install --graceful

# User has 30 seconds to finish work before forced exit
```

**LIFECYCLE_DRY_RUN** (default: `false`)

Enable dry-run mode (test cleanups without executing).

```zsh
LIFECYCLE_DRY_RUN=true
# All cleanup operations logged but not executed
```

---

### Restart Capabilities (v3.1)

**LIFECYCLE_RESTART_MONITOR_INTERVAL** (default: `5` seconds)

How often to check if restarted processes are still alive.

```zsh
LIFECYCLE_RESTART_MONITOR_INTERVAL=3  # Check every 3 seconds
lifecycle-restart-enable 1234 "myapp"
```

**LIFECYCLE_RESTART_DEFAULT_MAX_ATTEMPTS** (default: `3`)

Default maximum restart attempts if not specified.

```zsh
LIFECYCLE_RESTART_DEFAULT_MAX_ATTEMPTS=5
lifecycle-restart-enable 1234 "myapp"  # Uses 5 attempts
```

**LIFECYCLE_RESTART_DEFAULT_BACKOFF** (default: `1` second)

Initial backoff duration for restart attempts.

```zsh
LIFECYCLE_RESTART_DEFAULT_BACKOFF=2
lifecycle-restart-enable 1234 "myapp"  # Initial: 2s, then 4s, 8s, 16s...
```

**LIFECYCLE_CLEANUP_USE_DEPENDENCY_ORDER** (default: `true`)

Use dependency-ordered cleanup if available; fallback to LIFO.

```zsh
LIFECYCLE_CLEANUP_USE_DEPENDENCY_ORDER=false
# Uses only LIFO cleanup, ignores dependency-ordered cleanups
```

---

### State Directory

**LIFECYCLE_STATE_DIR** (default: `$XDG_STATE_HOME/lib/lifecycle`)

Base state directory for application state files.

```zsh
LIFECYCLE_STATE_DIR="/var/lib/myapp/state"
lifecycle-state-init "myapp"
# Creates /var/lib/myapp/state/myapp
```

---

## API Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE (1250 lines) -->

### Signal Management

<!-- CONTEXT_GROUP: signal-api -->

#### lifecycle-signal

**Purpose:** Register a handler function for a specific signal

**Signature:**
```zsh
lifecycle-signal SIGNAL HANDLER_FUNCTION
```

**Parameters:**
- `SIGNAL` - Signal name (INT, TERM, HUP, USR1, USR2, QUIT, ABRT, ERR, or SIG-prefixed)
- `HANDLER_FUNCTION` - Shell function to execute when signal received

**Returns:**
- `0` - Success
- `1` - Error (missing arguments, handler validation failed)

**Source:** L211-246

**Behavior:**
- Normalizes signal name (removes SIG prefix, uppercases)
- Validates handler function exists (warns if missing)
- Stores handler in `_LIFECYCLE_SIGNAL_HANDLERS[signal]` registry
- Generates dynamic trap function via `eval`
- Installs trap with ZSH's `trap` command
- Multiple handlers per signal supported (chain of command)
- Warns if handler not found but still registers it

**Example: Basic Signal Handler**

```zsh
source "$(which _lifecycle)"

my_handler() {
    echo "Received signal!"
    cleanup_resources
    exit 0
}

lifecycle-signal INT my_handler
lifecycle-signal TERM my_handler

# Press Ctrl+C → my_handler executed
```

**Example: Multiple Handlers per Signal**

```zsh
handler_1() { echo "First handler"; }
handler_2() { echo "Second handler"; }

lifecycle-signal INT handler_1
lifecycle-signal INT handler_2

# Both execute in order when INT received
```

**Example: Signal Name Normalization**

```zsh
# All equivalent
lifecycle-signal INT my_handler
lifecycle-signal SIGINT my_handler
lifecycle-signal int my_handler
```

---

#### lifecycle-signal-remove

**Purpose:** Remove a specific handler from a signal

**Signature:**
```zsh
lifecycle-signal-remove SIGNAL HANDLER_FUNCTION
```

**Parameters:**
- `SIGNAL` - Signal name
- `HANDLER_FUNCTION` - Handler to remove

**Returns:**
- `0` - Success
- `1` - Error

**Source:** L252-288

**Example:**

```zsh
my_handler() { echo "handling"; }

lifecycle-signal INT my_handler
# ... later ...
lifecycle-signal-remove INT my_handler

# my_handler no longer called on INT
```

---

#### lifecycle-signal-clear

**Purpose:** Remove all handlers from a signal

**Signature:**
```zsh
lifecycle-signal-clear SIGNAL
```

**Parameters:**
- `SIGNAL` - Signal name

**Returns:**
- `0` - Success
- `1` - Error (missing signal)

**Source:** L294-311

**Example:**

```zsh
# Clear all INT handlers
lifecycle-signal-clear INT
```

---

### Common Signal Handlers

<!-- CONTEXT_GROUP: signal-handlers -->

These are pre-defined signal handlers that can be registered directly.

#### lifecycle-int

**Purpose:** Handle INT signal (Ctrl+C)

**Signature:**
```zsh
lifecycle-int
```

**Behavior:**
- Emits `lifecycle.signal.received` event
- Sets exit code to 130
- Calls `lifecycle-exit` for cleanup
- Standard way to handle Ctrl+C

**Source:** L400-405

**Example:**

```zsh
lifecycle-signal INT lifecycle-int
# Ctrl+C → graceful exit with code 130
```

---

#### lifecycle-term

**Purpose:** Handle TERM signal (termination request)

**Signature:**
```zsh
lifecycle-term
```

**Behavior:**
- Emits `lifecycle.signal.received` event
- Sets exit code to 143
- Calls `lifecycle-exit` for cleanup
- Standard response to `kill $pid`

**Source:** L408-413

**Example:**

```zsh
lifecycle-signal TERM lifecycle-term
# kill $pid → graceful exit with code 143
```

---

#### lifecycle-hup

**Purpose:** Handle HUP signal (hangup)

**Signature:**
```zsh
lifecycle-hup
```

**Behavior:**
- Emitted when terminal closes
- Sets exit code to 129
- Calls `lifecycle-exit`

**Source:** L416-421

---

#### lifecycle-graceful-shutdown

**Purpose:** Handle graceful shutdown with timeout

**Signature:**
```zsh
lifecycle-graceful-shutdown
```

**Behavior:**
- First interrupt: sets `LIFECYCLE_SHUTDOWN_REQUESTED=true`, emits event
- Second interrupt: forces immediate exit with code 130
- Timeout (after LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT seconds): forced exit

**Source:** L464-487

**Example:**

```zsh
lifecycle-trap-install --graceful
# First Ctrl+C: graceful, timeout 10s
# Second Ctrl+C: immediate exit
```

---

#### lifecycle-err

**Purpose:** Handle ERR pseudo-signal (command errors)

**Signature:**
```zsh
lifecycle-err
```

**Behavior:**
- Captures command failures
- Logs error with line number
- Sets appropriate exit code
- Only installed if `LIFECYCLE_TRAP_ERRORS=true`

**Source:** L452-461

**Example:**

```zsh
LIFECYCLE_TRAP_ERRORS=true
lifecycle-trap-install

false  # This command fails
# lifecycle-err catches it, logs line number, exits with error
```

---

#### lifecycle-exit

**Purpose:** Main exit handler - coordinates all cleanup operations

**Signature:**
```zsh
lifecycle-exit [EXIT_CODE]
```

**Behavior:**
- Emits `lifecycle.exit.start` event
- Stops restart monitor if running (v3.1)
- Runs all cleanup functions (dependency-ordered + LIFO)
- Kills tracked jobs (if enabled)
- Removes tracked temp files/dirs (if enabled)
- Stops tracked systemd services (if enabled)
- Removes state directory (if enabled)
- Emits `lifecycle.exit.complete` event
- Exits with configured `LIFECYCLE_EXIT_CODE`

**Source:** L361-397

**Cleanup Order:**
1. Dependency-ordered cleanups (if enabled)
2. LIFO cleanups (backward compatibility)
3. Kill tracked jobs
4. Remove tracked temp resources
5. Stop tracked services
6. Remove state directory

**Example:**

```zsh
trap lifecycle-exit EXIT
# Automatically called on script exit
```

---

### Event Management

<!-- CONTEXT_GROUP: event-api -->

#### lifecycle-event

**Purpose:** Register a handler for a lifecycle event

**Signature:**
```zsh
lifecycle-event EVENT_NAME HANDLER_FUNCTION
```

**Parameters:**
- `EVENT_NAME` - Event identifier (e.g., "lifecycle.signal.received")
- `HANDLER_FUNCTION` - Function to call when event emitted

**Returns:**
- `0` - Success
- `1` - Error

**Source:** L497-519

**Example: Monitoring Exit**

```zsh
on_exit() {
    local exit_code="$1"
    echo "Application exiting with code: $exit_code"
    log_metrics
}

lifecycle-event "lifecycle.exit.complete" on_exit
```

**Example: Tracking Signals**

```zsh
on_signal() {
    local signal="$1"
    local description="$2"
    echo "Signal received: $signal - $description"
}

lifecycle-event "lifecycle.signal.received" on_signal
```

---

#### lifecycle-event-trigger

**Purpose:** Manually emit an event

**Signature:**
```zsh
lifecycle-event-trigger EVENT_NAME [ARG1 ARG2 ...]
```

**Parameters:**
- `EVENT_NAME` - Event identifier
- `ARG...` - Arguments passed to handlers

**Source:** L525-535

**Example:**

```zsh
lifecycle-event-trigger "custom.app.startup" "app-v1.0" "config.yml"

# Handlers receive: $1="app-v1.0", $2="config.yml"
```

---

#### lifecycle-event-once

**Purpose:** Register handler that executes only once

**Signature:**
```zsh
lifecycle-event-once EVENT_NAME HANDLER_FUNCTION
```

**Parameters:**
- `EVENT_NAME` - Event identifier
- `HANDLER_FUNCTION` - Function to execute once

**Returns:**
- `0` - Success
- `1` - Error

**Source:** L590-611

**Example:**

```zsh
on_first_startup() {
    echo "Initializing application..."
}

lifecycle-event-once "lifecycle.startup" on_first_startup

lifecycle-event-trigger "lifecycle.startup"  # Executes
lifecycle-event-trigger "lifecycle.startup"  # Does nothing
```

---

#### lifecycle-event-remove

**Purpose:** Unregister a specific event handler

**Signature:**
```zsh
lifecycle-event-remove EVENT_NAME HANDLER_FUNCTION
```

**Source:** L541-567

**Example:**

```zsh
lifecycle-event-remove "lifecycle.signal.received" my_handler
```

---

#### lifecycle-event-clear

**Purpose:** Remove all handlers from an event

**Signature:**
```zsh
lifecycle-event-clear EVENT_NAME
```

**Source:** L573-584

---

### Cleanup Management - LIFO (Legacy)

<!-- CONTEXT_GROUP: cleanup-api -->

#### lifecycle-cleanup

**Purpose:** Register a cleanup function (LIFO execution order)

**Signature:**
```zsh
lifecycle-cleanup FUNCTION_OR_COMMAND
```

**Parameters:**
- `FUNCTION_OR_COMMAND` - Shell function name or command string

**Returns:**
- `0` - Success
- `1` - Error

**Source:** L621-632

**Execution Order:** Last-In-First-Out (reverse registration order)

**Example: Function Cleanup**

```zsh
cleanup_logs() {
    echo "Flushing logs..."
    # Flush operations
}

lifecycle-cleanup cleanup_logs
```

**Example: Command Cleanup**

```zsh
# Can also pass inline commands
lifecycle-cleanup "rm -rf /tmp/myapp/*"
```

---

#### lifecycle-cleanup-remove

**Purpose:** Unregister a cleanup function

**Signature:**
```zsh
lifecycle-cleanup-remove FUNCTION_OR_COMMAND
```

**Source:** L638-651

---

#### lifecycle-cleanup-clear

**Purpose:** Remove all cleanup functions

**Signature:**
```zsh
lifecycle-cleanup-clear
```

**Source:** L657-661

---

#### lifecycle-cleanup-list

**Purpose:** List all registered cleanup functions

**Signature:**
```zsh
lifecycle-cleanup-list
```

**Output:** One cleanup per line

**Source:** L667-671

---

### Cleanup Management - Dependency-Ordered (v3.1)

<!-- CONTEXT_GROUP: cleanup-dependency-api -->

#### lifecycle-cleanup-add

**Purpose:** Register cleanup with ID and optional dependencies

**Signature:**
```zsh
lifecycle-cleanup-add CLEANUP_ID FUNCTION_OR_COMMAND [DEPENDENCY_ID...]
```

**Parameters:**
- `CLEANUP_ID` - Unique identifier for this cleanup
- `FUNCTION_OR_COMMAND` - Function or command to execute
- `DEPENDENCY_ID...` - IDs of cleanups this depends on

**Returns:**
- `0` - Success
- `1` - Circular dependency detected
- `2` - Invalid arguments

**Source:** L696-732

**Behavior:**
- Stores cleanup in `_LIFECYCLE_CLEANUP_REGISTRY`
- Stores dependencies in `_LIFECYCLE_CLEANUP_DEPS`
- Validates no circular dependencies (DFS algorithm)
- Recomputes execution order (topological sort)
- Emits event on success or circular dependency error

**Example: Basic Registration**

```zsh
lifecycle-cleanup-add "stop_server" "killall myserver"
```

**Example: With Dependencies**

```zsh
cleanup_app() { echo "App cleanup"; }
cleanup_db() { echo "DB cleanup"; }

# App cleanup must complete before DB cleanup
lifecycle-cleanup-add "stop_app" cleanup_app
lifecycle-cleanup-add "close_db" cleanup_db "stop_app"

# Execution order: stop_app → close_db
```

**Example: Complex Dependencies**

```zsh
# Dependency graph:
#     flush_queue ──┐
#                   ├─→ save_state ──→ close_db
#   stop_server ──┘

lifecycle-cleanup-add "flush_queue" "kafka-flush"
lifecycle-cleanup-add "stop_server" "systemctl stop"
lifecycle-cleanup-add "save_state" "save" "flush_queue" "stop_server"
lifecycle-cleanup-add "close_db" "psql-close" "save_state"

# Execution order:
# 1. flush_queue (no dependencies)
# 2. stop_server (no dependencies)
# 3. save_state (waits for both 1 and 2)
# 4. close_db (waits for 3)
```

---

#### lifecycle-cleanup-add-dependency

**Purpose:** Add dependency to existing cleanup

**Signature:**
```zsh
lifecycle-cleanup-add-dependency CLEANUP_ID DEPENDS_ON_ID
```

**Parameters:**
- `CLEANUP_ID` - ID of cleanup to modify
- `DEPENDS_ON_ID` - ID of cleanup it should depend on

**Returns:**
- `0` - Success
- `1` - Circular dependency detected
- `2` - Invalid arguments

**Source:** L738-762

**Example:**

```zsh
lifecycle-cleanup-add "task_a" "cmd_a"
lifecycle-cleanup-add "task_b" "cmd_b"

# Later, make task_b depend on task_a
lifecycle-cleanup-add-dependency "task_b" "task_a"
```

---

#### lifecycle-cleanup-order

**Purpose:** Display cleanup execution order

**Signature:**
```zsh
lifecycle-cleanup-order
```

**Output:** One cleanup per line, with dependencies shown

**Source:** L853-867

**Example:**

```zsh
lifecycle-cleanup-order
# Output:
# flush_queue
# stop_server
# save_state (depends on: flush_queue stop_server)
# close_db (depends on: save_state)
```

---

#### lifecycle-cleanup-validate

**Purpose:** Validate dependency graph (check for cycles)

**Signature:**
```zsh
lifecycle-cleanup-validate
```

**Returns:**
- `0` - Graph is valid (no cycles)
- `1` - Circular dependency detected

**Source:** L873-881

**Example:**

```zsh
lifecycle-cleanup-add "a" "cmd_a"
lifecycle-cleanup-add "b" "cmd_b" "a"
lifecycle-cleanup-add "c" "cmd_c" "b"

if lifecycle-cleanup-validate; then
    echo "Dependency graph is valid"
else
    echo "ERROR: Circular dependencies detected"
fi
```

---

### Restart Management (v3.1)

<!-- CONTEXT_GROUP: restart-api -->

#### lifecycle-restart-enable

**Purpose:** Enable auto-restart for a process with exponential backoff

**Signature:**
```zsh
lifecycle-restart-enable PID RESTART_COMMAND [MAX_ATTEMPTS] [INITIAL_BACKOFF]
```

**Parameters:**
- `PID` - Process ID to monitor
- `RESTART_COMMAND` - Command to execute to restart (e.g., "myapp --daemon")
- `MAX_ATTEMPTS` - Maximum restart attempts (default: LIFECYCLE_RESTART_DEFAULT_MAX_ATTEMPTS)
- `INITIAL_BACKOFF` - Initial backoff in seconds (default: LIFECYCLE_RESTART_DEFAULT_BACKOFF)

**Returns:**
- `0` - Success
- `2` - Invalid arguments (invalid PID, missing command)

**Source:** L952-980

**Behavior:**
- Stores restart config in `_LIFECYCLE_RESTART_ENABLED[pid]`
- Starts restart monitor if not already running
- Monitor runs in background, checking every LIFECYCLE_RESTART_MONITOR_INTERVAL seconds
- On process death: exponentially increases backoff and retries
- After max attempts: disables restart and emits `lifecycle.restart.exhausted`

**Example: Simple Restart**

```zsh
my_service &
pid=$!

# Enable restart: 3 attempts, 2 second initial backoff
lifecycle-restart-enable $pid "my_service" 3 2

# Monitor will check every 5 seconds (default)
# If my_service dies:
#   - Waits 2 seconds, restarts → fails
#   - Waits 4 seconds, restarts → fails
#   - Waits 8 seconds, restarts → fails (max attempts reached)
```

---

#### lifecycle-restart-disable

**Purpose:** Disable auto-restart for a process

**Signature:**
```zsh
lifecycle-restart-disable PID
```

**Source:** L986-1001

---

#### lifecycle-restart-check

**Purpose:** Manually check all restarted processes and restart dead ones

**Signature:**
```zsh
lifecycle-restart-check
```

**Returns:** Number of restarts performed

**Source:** L1027-1042

**Example:**

```zsh
# Usually called by background monitor, but can be manual
lifecycle-restart-check
echo "Performed $? restarts"
```

---

#### lifecycle-restart-status

**Purpose:** Query restart status of a process

**Signature:**
```zsh
lifecycle-restart-status PID
```

**Output:**
- If enabled: "enabled" + attempt count, max attempts, current backoff
- If disabled: "disabled"

**Source:** L1104-1117

**Example:**

```zsh
lifecycle-restart-status 1234
# Output:
# enabled
# attempts: 2
# max_attempts: 5
# backoff: 8s
```

---

### Process Groups (v3.1)

<!-- CONTEXT_GROUP: process-group-api -->

#### lifecycle-process-group-create

**Purpose:** Create named process group

**Signature:**
```zsh
lifecycle-process-group-create GROUP_NAME
```

**Parameters:**
- `GROUP_NAME` - Unique identifier for group

**Returns:**
- `0` - Success
- `1` - Group already exists
- `2` - Invalid arguments

**Source:** L1127-1144

**Example:**

```zsh
lifecycle-process-group-create "workers"
lifecycle-process-group-create "backends"
```

---

#### lifecycle-process-group-add

**Purpose:** Add PID to process group

**Signature:**
```zsh
lifecycle-process-group-add GROUP_NAME PID
```

**Parameters:**
- `GROUP_NAME` - Group identifier
- `PID` - Process ID to add

**Returns:**
- `0` - Success
- `2` - Invalid arguments

**Behavior:**
- Creates group if doesn't exist
- Checks for duplicates (no-op if already added)
- Stores PID in `_LIFECYCLE_PROCESS_GROUPS[group_name]`

**Source:** L1150-1180

**Example:**

```zsh
# Start workers and add to group
for i in {1..5}; do
    worker_process &
    lifecycle-process-group-add "workers" $!
done
```

---

#### lifecycle-process-group-remove

**Purpose:** Remove PID from process group

**Signature:**
```zsh
lifecycle-process-group-remove GROUP_NAME PID
```

**Source:** L1186-1204

---

#### lifecycle-process-group-signal

**Purpose:** Send signal to entire process group

**Signature:**
```zsh
lifecycle-process-group-signal GROUP_NAME SIGNAL
```

**Parameters:**
- `GROUP_NAME` - Group identifier
- `SIGNAL` - Signal name (TERM, KILL, HUP, etc.)

**Source:** L1210-1227

**Example:**

```zsh
# Gracefully stop all workers
lifecycle-process-group-signal "workers" "TERM"

# Force kill if needed
lifecycle-process-group-signal "workers" "KILL"
```

---

#### lifecycle-process-group-cleanup

**Purpose:** Cleanup entire process group (graceful then forced)

**Signature:**
```zsh
lifecycle-process-group-cleanup GROUP_NAME [SIGNAL]
```

**Parameters:**
- `GROUP_NAME` - Group identifier
- `SIGNAL` - Initial signal (default: TERM)

**Behavior:**
1. Sends SIGNAL to all processes
2. Waits 0.5 seconds
3. Force kills any survivors with KILL

**Source:** L1233-1256

**Example:**

```zsh
# Graceful cleanup (TERM first, then KILL)
lifecycle-process-group-cleanup "workers"

# With different initial signal
lifecycle-process-group-cleanup "workers" "HUP"
```

---

#### lifecycle-process-group-list

**Purpose:** List process groups or PIDs in a group

**Signature:**
```zsh
lifecycle-process-group-list [GROUP_NAME]
```

**Output:**
- No argument: list all group names
- With group name: list PIDs in that group

**Source:** L1262-1276

**Example:**

```zsh
# List all groups
lifecycle-process-group-list

# List PIDs in specific group
lifecycle-process-group-list "workers"
```

---

#### lifecycle-process-group-delete

**Purpose:** Delete group metadata (doesn't kill processes)

**Signature:**
```zsh
lifecycle-process-group-delete GROUP_NAME
```

**Source:** L1282-1294

---

### Resource Tracking

<!-- CONTEXT_GROUP: resource-tracking -->

#### lifecycle-track-job / lifecycle-track-pid

**Purpose:** Track background job for automatic cleanup

**Signature:**
```zsh
lifecycle-track-job PID
lifecycle-track-pid PID   # Alias
```

**Parameters:**
- `PID` - Process ID of background job

**Returns:**
- `0` - Success
- `1` - Invalid PID

**Source:** L1304-1321

**Behavior:**
- Stores PID in `_LIFECYCLE_TRACKED_PIDS` array
- On exit (if LIFECYCLE_CLEANUP_JOBS=true), sends TERM then KILL
- Must set LIFECYCLE_CLEANUP_JOBS=true for automatic cleanup

**Example:**

```zsh
LIFECYCLE_CLEANUP_JOBS=true
lifecycle-trap-install

# Start background process
long_task &
pid=$!

# Track it for cleanup
lifecycle-track-job $pid

# ... later on exit ...
# TERM sent, then KILL if needed
```

---

#### lifecycle-untrack-job / lifecycle-untrack-pid

**Purpose:** Stop tracking a background job

**Signature:**
```zsh
lifecycle-untrack-job PID
lifecycle-untrack-pid PID
```

**Source:** L1327-1345

---

#### lifecycle-list-jobs / lifecycle-list-pids

**Purpose:** List all tracked jobs

**Signature:**
```zsh
lifecycle-list-jobs
lifecycle-list-pids    # Alias
```

**Output:** One PID per line

**Source:** L1351-1360

---

#### lifecycle-track-temp-file

**Purpose:** Track temporary file for automatic cleanup

**Signature:**
```zsh
lifecycle-track-temp-file FILE_PATH
```

**Parameters:**
- `FILE_PATH` - Path to temporary file

**Returns:**
- `0` - Success
- `1` - Invalid arguments

**Source:** L1406-1414

**Behavior:**
- Stores path in `_LIFECYCLE_TRACKED_TEMP_FILES`
- On exit (if LIFECYCLE_CLEANUP_TEMP=true), removes file
- Must set LIFECYCLE_CLEANUP_TEMP=true for automatic cleanup

**Example:**

```zsh
LIFECYCLE_CLEANUP_TEMP=true

# Create temp file
tmpfile=$(mktemp)
lifecycle-track-temp-file "$tmpfile"

# Use it
echo "data" > "$tmpfile"

# On exit, file automatically removed
```

---

#### lifecycle-track-temp-dir

**Purpose:** Track temporary directory for automatic cleanup

**Signature:**
```zsh
lifecycle-track-temp-dir DIR_PATH
```

**Source:** L1420-1428

---

#### lifecycle-untrack-temp-file

**Purpose:** Stop tracking temporary file

**Signature:**
```zsh
lifecycle-untrack-temp-file FILE_PATH
```

**Source:** L1434-1447

---

#### lifecycle-untrack-temp-dir

**Purpose:** Stop tracking temporary directory

**Signature:**
```zsh
lifecycle-untrack-temp-dir DIR_PATH
```

**Source:** L1453-1466

---

#### lifecycle-list-temp-files / lifecycle-list-temp-dirs

**Purpose:** List tracked temporary resources

**Signature:**
```zsh
lifecycle-list-temp-files
lifecycle-list-temp-dirs
```

**Output:** One path per line

**Source:** L1472-1486

---

#### lifecycle-track-service

**Purpose:** Track systemd service for cleanup

**Signature:**
```zsh
lifecycle-track-service SERVICE_NAME [SCOPE]
```

**Parameters:**
- `SERVICE_NAME` - Systemd service name
- `SCOPE` - "--user" (default) or "--system"

**Returns:**
- `0` - Success
- `1` - Invalid arguments

**Source:** L1539-1548

**Behavior:**
- Stores in `_LIFECYCLE_TRACKED_SERVICES` as "name:scope"
- On exit (if LIFECYCLE_CLEANUP_SERVICES=true), stops service
- Requires systemctl to be available

**Example:**

```zsh
LIFECYCLE_CLEANUP_SERVICES=true

# Track user service
lifecycle-track-service "myapp" "--user"

# Track system service
lifecycle-track-service "postgresql" "--system"

# On exit, both services stopped
```

---

#### lifecycle-untrack-service

**Purpose:** Stop tracking a systemd service

**Signature:**
```zsh
lifecycle-untrack-service SERVICE_NAME [SCOPE]
```

**Source:** L1554-1569

---

#### lifecycle-list-services

**Purpose:** List all tracked services

**Signature:**
```zsh
lifecycle-list-services
```

**Output:** One service per line (format: "name:scope")

**Source:** L1575-1579

---

### State Management

<!-- CONTEXT_GROUP: state-api -->

#### lifecycle-state-init

**Purpose:** Initialize state directory for application

**Signature:**
```zsh
lifecycle-state-init [NAME]
```

**Parameters:**
- `NAME` - Application name (default: SCRIPT_NAME or "script")

**Returns:**
- `0` - Success
- `1` - Failed to create directory

**Behavior:**
- Creates `$LIFECYCLE_STATE_DIR/$NAME` directory
- Respects LIFECYCLE_DRY_RUN mode
- Path available via `$LIFECYCLE_STATE_DIR`

**Source:** L1619-1639

**Example:**

```zsh
lifecycle-state-init "myapp"
# Creates: $XDG_STATE_HOME/lib/lifecycle/myapp

# Use for storing state
echo "state data" > "$LIFECYCLE_STATE_DIR/state.json"
```

---

#### lifecycle-state-cleanup

**Purpose:** Remove state directory

**Signature:**
```zsh
lifecycle-state-cleanup
```

**Returns:**
- `0` - Success
- `1` - Failed to remove

**Source:** L1645-1662

**Behavior:**
- Removes entire `$LIFECYCLE_STATE_DIR` directory
- Only called on exit if LIFECYCLE_CLEANUP_STATE=true

---

### Exit Code Management

<!-- CONTEXT_GROUP: exit-api -->

#### lifecycle-set-exit-code

**Purpose:** Set exit code to use when script exits

**Signature:**
```zsh
lifecycle-set-exit-code CODE
```

**Parameters:**
- `CODE` - Exit code (0-255)

**Returns:**
- `0` - Success
- `1` - Invalid arguments
- `2` - Non-numeric code

**Source:** L1677-1689

**Example:**

```zsh
if some_operation; then
    lifecycle-set-exit-code 0
else
    lifecycle-set-exit-code 1
fi

# Script exits with that code
```

---

#### lifecycle-get-exit-code

**Purpose:** Get current exit code

**Signature:**
```zsh
lifecycle-get-exit-code
```

**Output:** Current exit code

**Source:** L1695-1697

---

### Trap Management

<!-- CONTEXT_GROUP: trap-api -->

#### lifecycle-trap-install

**Purpose:** Install standard signal handlers

**Signature:**
```zsh
lifecycle-trap-install [--graceful]
```

**Parameters:**
- `--graceful` - Use graceful shutdown handler for INT

**Returns:**
- `0` - Success

**Behavior:**
- Installs EXIT trap → `lifecycle-exit`
- Installs INT trap → `lifecycle-int` (or `lifecycle-graceful-shutdown` if --graceful)
- Installs TERM, HUP, USR1, USR2, QUIT, ABRT
- Optionally installs ERR trap (if LIFECYCLE_TRAP_ERRORS=true)

**Source:** L1708-1736

**Example: Standard Installation**

```zsh
lifecycle-trap-install

# All standard signals handled
# INT, TERM, HUP cause immediate exit
```

**Example: Graceful Installation**

```zsh
lifecycle-trap-install --graceful

# INT signal: graceful shutdown with timeout
# Second INT or timeout: forced exit
```

---

#### lifecycle-trap-uninstall

**Purpose:** Uninstall all signal handlers

**Signature:**
```zsh
lifecycle-trap-uninstall
```

**Returns:**
- `0` - Success

**Source:** L1742-1752

---

#### lifecycle-trap-list

**Purpose:** Display active traps

**Signature:**
```zsh
lifecycle-trap-list
```

**Output:** Signal: handler list, one per line

**Source:** L1758-1769

**Example:**

```zsh
lifecycle-trap-list
# Output:
# INT: lifecycle-int
# TERM: lifecycle-term
# HUP: lifecycle-hup
```

---

### Timeout Handling

#### lifecycle-timeout

**Purpose:** Execute command with timeout

**Signature:**
```zsh
lifecycle-timeout SECONDS COMMAND [ARGS...]
```

**Parameters:**
- `SECONDS` - Timeout in seconds
- `COMMAND` - Command to execute
- `ARGS...` - Command arguments

**Returns:**
- Command exit code (or 124 if timeout)

**Source:** L1779-1815

**Behavior:**
1. Executes command in background
2. Monitors with sleep timeout
3. If timeout reached: sends TERM, waits, sends KILL
4. Returns command's exit code (or 124 for timeout)

**Example:**

```zsh
# Run with 5 second timeout
lifecycle-timeout 5 curl https://example.com

# Returns 124 if timeout, else curl's exit code
```

---

### Utility Functions

#### lifecycle-version

**Purpose:** Display version

**Signature:**
```zsh
lifecycle-version
```

**Output:** Version string (3.1.0)

**Source:** L1825-1827

---

#### lifecycle-help

**Purpose:** Display comprehensive help

**Signature:**
```zsh
lifecycle-help
```

**Source:** L1833-1937

---

#### lifecycle-info

**Purpose:** Display system information

**Signature:**
```zsh
lifecycle-info
```

**Output:** Configuration, integration status, active handlers, tracked resources

**Source:** L1943-1981

---

#### lifecycle-self-test

**Purpose:** Run self-tests

**Signature:**
```zsh
lifecycle-self-test
```

**Returns:**
- `0` - All tests passed
- `1` - Some tests failed

**Tests:**
1. Signal registration
2. Event system
3. LIFO cleanup registry
4. Job tracking
5. Temp file tracking
6. Exit code management
7. Integration detection
8. Dependency-ordered cleanup
9. Process groups
10. Restart capabilities

**Source:** L1987-2124

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (750 lines) -->

### Pattern 1: Multi-Stage Service Shutdown

Coordinate complex cleanup across multiple resources.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Define cleanup stages
stop_workers() {
    echo "Stopping worker processes..."
    lifecycle-process-group-cleanup "workers" "TERM"
}

flush_data() {
    echo "Flushing pending data..."
    # Flush to persistent storage
}

close_database() {
    echo "Closing database connections..."
    psql -c "DISCARD ALL"
}

archive_logs() {
    echo "Archiving logs..."
    # Compress and move logs
}

# Set up dependency-ordered cleanup
lifecycle-cleanup-add "stop_workers" stop_workers
lifecycle-cleanup-add "flush_data" flush_data "stop_workers"
lifecycle-cleanup-add "close_db" close_database "flush_data"
lifecycle-cleanup-add "archive_logs" archive_logs

lifecycle-trap-install --graceful
LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT=30

# Start worker processes
for i in {1..10}; do
    (while true; do sleep 1; done) &
    lifecycle-process-group-add "workers" $!
done

# Main loop
while [[ "$LIFECYCLE_SHUTDOWN_REQUESTED" != "true" ]]; do
    # Do work
    sleep 1
done

echo "Cleanup order:"
lifecycle-cleanup-order
```

**Execution Order on Exit:**
1. stop_workers
2. flush_data (waits for workers)
3. close_db (waits for flush)
4. archive_logs

---

### Pattern 2: Auto-Restart with Health Check

Restart processes only if they actually failed.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Health check function
health_check() {
    local pid="$1"

    # Check if process exists
    kill -0 "$pid" 2>/dev/null || return 1

    # Check if process is responsive (example)
    # curl http://localhost:8080/health >/dev/null 2>&1 || return 1

    return 0
}

# Start service
my_service &
pid=$!

echo "Service started (PID: $pid)"

# Enable auto-restart with exponential backoff
# max_attempts: 5, initial_backoff: 2s
lifecycle-restart-enable "$pid" "my_service" 5 2

lifecycle-trap-install

# Monitor loop
while [[ "$LIFECYCLE_SHUTDOWN_REQUESTED" != "true" ]]; do
    # Periodic health check
    if ! health_check "$pid"; then
        echo "Health check failed, restart monitor will handle it"
    fi
    sleep 5
done
```

---

### Pattern 3: Event-Driven Logging

Log all lifecycle events to file.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

LOG_FILE="/var/log/myapp.log"

# Log handler
log_event() {
    local event="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    shift
    echo "[$timestamp] $event $*" >> "$LOG_FILE"
}

# Register handlers for all events
lifecycle-event "lifecycle.exit.start" log_event "EXIT_START"
lifecycle-event "lifecycle.exit.complete" log_event "EXIT_COMPLETE"
lifecycle-event "lifecycle.signal.received" log_event "SIGNAL_RECEIVED"
lifecycle-event "lifecycle.cleanup.start" log_event "CLEANUP_START"
lifecycle-event "lifecycle.cleanup.complete" log_event "CLEANUP_COMPLETE"
lifecycle-event "lifecycle.restart.attempt" log_event "RESTART_ATTEMPT"
lifecycle-event "lifecycle.group.cleanup" log_event "GROUP_CLEANUP"

lifecycle-trap-install

# Application code
echo "Application running"
sleep 5
```

---

### Pattern 4: Graceful Shutdown with Progress

Show progress during shutdown.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Cleanup with progress indication
cleanup_with_progress() {
    local step="$1"
    local total="$2"
    local name="$3"

    echo -n "[$step/$total] $name... "
    # Do cleanup
    echo "done"
}

cleanup_task_1() { cleanup_with_progress 1 3 "Stopping services"; }
cleanup_task_2() { cleanup_with_progress 2 3 "Flushing data"; }
cleanup_task_3() { cleanup_with_progress 3 3 "Closing connections"; }

lifecycle-cleanup-add "task1" cleanup_task_1
lifecycle-cleanup-add "task2" cleanup_task_2 "task1"
lifecycle-cleanup-add "task3" cleanup_task_3 "task2"

lifecycle-trap-install --graceful

echo "Application started..."
sleep 10
```

**Output on Ctrl+C:**
```
[1/3] Stopping services... done
[2/3] Flushing data... done
[3/3] Closing connections... done
```

---

### Pattern 5: Resource Pooling

Manage dynamic resource allocation.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Temp file pool
allocate_temp() {
    local file=$(mktemp)
    lifecycle-track-temp-file "$file"
    echo "$file"
}

# Get temp file count
temp_count() {
    local count=0
    for f in $(lifecycle-list-temp-files); do
        [[ -f "$f" ]] && ((count++))
    done
    echo $count
}

lifecycle-trap-install
LIFECYCLE_CLEANUP_TEMP=true

# Allocate resources
echo "Allocating resources..."
for i in {1..10}; do
    allocate_temp >/dev/null
done

echo "Allocated $(temp_count) temp files"

# On exit: all cleaned up automatically
sleep 5
```

---

### Pattern 6: Multi-PID Tracking

Track and manage multiple processes hierarchically.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Create process groups
lifecycle-process-group-create "primary"
lifecycle-process-group-create "secondary"
lifecycle-process-group-create "cleanup"

# Start primary services
primary_service &
lifecycle-process-group-add "primary" $!
lifecycle-process-group-add "primary" $!  # Second instance

# Start secondary services
secondary_service &
lifecycle-process-group-add "secondary" $!

# Register cleanup handlers
cleanup_handler() {
    echo "Running cleanup..."
    lifecycle-process-group-signal "primary" "TERM"
    lifecycle-process-group-signal "secondary" "TERM"
}

lifecycle-cleanup cleanup_handler

lifecycle-trap-install

echo "Services running..."
sleep 10
```

---

### Pattern 7: Conditional Cleanup

Execute cleanup based on conditions.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

cleanup_on_error() {
    local exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        echo "ERROR: Application failed, keeping state for debugging"
        LIFECYCLE_CLEANUP_STATE=false
        LIFECYCLE_CLEANUP_TEMP=false
    else
        echo "SUCCESS: Normal cleanup"
        LIFECYCLE_CLEANUP_STATE=true
        LIFECYCLE_CLEANUP_TEMP=true
    fi
}

lifecycle-event "lifecycle.exit.start" cleanup_on_error

lifecycle-state-init "myapp"
lifecycle-trap-install

# Application code
if false; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi
```

---

### Pattern 8: Metrics Collection

Collect lifecycle metrics before exit.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

on_exit_metrics() {
    local exit_code="$1"

    echo "=== Exit Metrics ==="
    echo "Exit Code: $exit_code"
    echo "Duration: $((SECONDS / 60))m $(($SECONDS % 60))s"
    echo "Signal Handlers: ${#_LIFECYCLE_SIGNAL_HANDLERS[@]}"
    echo "Event Handlers: ${#_LIFECYCLE_EVENT_HANDLERS[@]}"
    echo "Tracked PIDs: ${#_LIFECYCLE_TRACKED_PIDS[@]}"
    echo "Tracked Files: ${#_LIFECYCLE_TRACKED_TEMP_FILES[@]}"
    echo "Tracked Dirs: ${#_LIFECYCLE_TRACKED_TEMP_DIRS[@]}"
}

lifecycle-event "lifecycle.exit.complete" on_exit_metrics

lifecycle-trap-install

echo "Application running..."
sleep 5
```

---

## Best Practices

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (450 lines) -->

### 1. Always Install Signal Handlers Early

Install signal handlers at the start of your script.

```zsh
#!/usr/bin/env zsh

source "$(which _lifecycle)"

# Do this FIRST
lifecycle-trap-install

# Then everything else
. "$(which _common)"
. "$(which _config)"

main "$@"
```

**Why:** Ensures all signal handlers are active before any real work begins.

---

### 2. Use Graceful Shutdown for Long-Running Operations

Enable graceful shutdown for services that need cleanup time.

```zsh
# For services that need to complete in-flight requests
lifecycle-trap-install --graceful
LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT=30

# For quick-exit services
lifecycle-trap-install
```

**Why:** Gives applications time to finish work before forced exit.

---

### 3. Prefer Dependency-Ordered Cleanup

Use `lifecycle-cleanup-add` instead of `lifecycle-cleanup` for complex applications.

```zsh
# GOOD: Clear dependencies
lifecycle-cleanup-add "stop_api" stop_api
lifecycle-cleanup-add "close_db" close_db "stop_api"

# LESS IDEAL: No dependency tracking
lifecycle-cleanup close_db
lifecycle-cleanup stop_api  # Will execute first (LIFO), but should be last
```

**Why:** Makes cleanup order explicit and prevents ordering bugs.

---

### 4. Validate Dependency Graphs

Always validate before relying on dependency-ordered cleanup.

```zsh
# Define all cleanups
lifecycle-cleanup-add "a" cmd_a
lifecycle-cleanup-add "b" cmd_b "a"
lifecycle-cleanup-add "c" cmd_c "b"

# Validate
if ! lifecycle-cleanup-validate; then
    echo "ERROR: Circular dependencies!"
    exit 1
fi

# Safe to proceed
lifecycle-trap-install
```

**Why:** Catches circular dependencies before they cause issues.

---

### 5. Track All Resources Immediately

Register resources immediately after creation.

```zsh
# GOOD: Track immediately
tmpfile=$(mktemp)
lifecycle-track-temp-file "$tmpfile"

long_task &
lifecycle-track-job $!

# BAD: Track later
tmpfile=$(mktemp)
# ... lots of code ...
lifecycle-track-temp-file "$tmpfile"  # Risk of losing track
```

**Why:** Prevents resource leaks if exception occurs between creation and registration.

---

### 6. Use Process Groups for Batch Operations

Group related processes for coordinated management.

```zsh
# GOOD: Use process groups
lifecycle-process-group-create "workers"
for i in {1..10}; do
    worker &
    lifecycle-process-group-add "workers" $!
done

# Later: cleanup entire group
lifecycle-process-group-cleanup "workers"

# BAD: Individual process tracking
for i in {1..10}; do
    worker &
    lifecycle-track-job $!
done
# Would need to manage cleanup manually
```

**Why:** Simplifies managing multiple related processes.

---

### 7. Handle Signals in Cleanup Functions

Account for signal safety in cleanup code.

```zsh
cleanup_cache() {
    # Use simple commands, avoid complex operations
    rm -rf "$CACHE_DIR"

    # Avoid:
    # - Calling other lifecycle functions (could re-enter trap)
    # - Long-running operations (timeout)
    # - External processes (might fail)
}

lifecycle-cleanup cleanup_cache
```

**Why:** Cleanup runs in signal context, which restricts what's safe.

---

### 8. Set Exit Code Before Exit

Use `lifecycle-set-exit-code` to control exit status.

```zsh
if validate_config; then
    echo "Config valid"
    lifecycle-set-exit-code 0
else
    echo "Config invalid" >&2
    lifecycle-set-exit-code 1
fi

# Script exits with that code
```

**Why:** Enables proper signal handling and exit code propagation.

---

### 9. Enable Dry-Run Mode for Testing

Test cleanup procedures without side effects.

```zsh
# For testing
LIFECYCLE_DRY_RUN=true
LIFECYCLE_DEBUG=true

# Would remove file: /tmp/xxx
# Would kill job: 1234

# For production
LIFECYCLE_DRY_RUN=false
```

**Why:** Safely verify cleanup logic before running in production.

---

### 10. Monitor Process Groups

Check group status periodically in long-running applications.

```zsh
monitor_workers() {
    local group="workers"
    local pids=$(lifecycle-process-group-list "$group")

    echo "Active workers: $(echo "$pids" | wc -l)"

    # Check if any died
    for pid in $pids; do
        if ! kill -0 "$pid" 2>/dev/null; then
            echo "Worker $pid died unexpectedly"
        fi
    done
}

# Call periodically
while true; do
    monitor_workers
    sleep 5
done
```

---

### 11. Use Event Handlers for Integration

Register event handlers for monitoring and logging.

```zsh
# Log all events
all_events() {
    echo "[$(date '+%T')] Event triggered with: $*" >> /var/log/app.log
}

lifecycle-event "lifecycle.exit.start" all_events
lifecycle-event "lifecycle.signal.received" all_events
lifecycle-event "lifecycle.restart.attempt" all_events

lifecycle-trap-install
```

**Why:** Provides visibility into application lifecycle without modifying code.

---

### 12. Configure Based on Context

Set configuration appropriate for your environment.

```zsh
# Development: verbose cleanup
if [[ "$ENVIRONMENT" == "dev" ]]; then
    LIFECYCLE_DEBUG=true
    LIFECYCLE_CLEANUP_STATE=true
    LIFECYCLE_CLEANUP_JOBS=true
fi

# Production: minimal cleanup
if [[ "$ENVIRONMENT" == "prod" ]]; then
    LIFECYCLE_DEBUG=false
    LIFECYCLE_CLEANUP_JOBS=false  # Keep for debugging
fi

lifecycle-trap-install
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (550 lines) -->

### Problem: Cleanup Functions Not Executing

**Symptoms:** Cleanup functions registered but not called on exit

**Diagnosis:**
```zsh
# Check if cleanup functions registered
lifecycle-cleanup-list

# Check if trap installed
lifecycle-trap-list

# Check if EXIT trap exists
trap -p EXIT
```

**Solutions:**

1. **Ensure trap installed:**
   ```zsh
   lifecycle-trap-install
   trap -p EXIT  # Should show: trap 'lifecycle-exit' EXIT
   ```

2. **Check cleanup registration:**
   ```zsh
   lifecycle-cleanup cleanup_func
   lifecycle-cleanup-list  # Should show your function
   ```

3. **Verify function exists:**
   ```zsh
   typeset -f cleanup_func  # Should output function body
   ```

---

### Problem: Signals Not Being Caught

**Symptoms:** Signal handlers not executing on Ctrl+C or termination signals

**Diagnosis:**
```zsh
# Check registered handlers
lifecycle-trap-list

# Check if signal handler function exists
typeset -f lifecycle-int
```

**Solutions:**

1. **Install signal handlers:**
   ```zsh
   lifecycle-trap-install
   lifecycle-trap-list  # Should show multiple signals
   ```

2. **Check specific signal:**
   ```zsh
   lifecycle-signal INT lifecycle-int
   trap -p INT  # Verify trap installed
   ```

3. **Enable debug mode:**
   ```zsh
   LIFECYCLE_DEBUG=true
   # Will show signal reception messages
   ```

---

### Problem: Resources Not Cleaned Up

**Symptoms:** Temp files remain after script exit, jobs still running, etc.

**Diagnosis:**
```zsh
# Check tracked resources
echo "Temp files: $(lifecycle-list-temp-files)"
echo "Temp dirs: $(lifecycle-list-temp-dirs)"
echo "Jobs: $(lifecycle-list-jobs)"
echo "Services: $(lifecycle-list-services)"
```

**Solutions:**

1. **Enable cleanup for resources:**
   ```zsh
   LIFECYCLE_CLEANUP_TEMP=true      # For files and dirs
   LIFECYCLE_CLEANUP_JOBS=true      # For background jobs
   LIFECYCLE_CLEANUP_SERVICES=true  # For systemd services
   ```

2. **Verify resource registration:**
   ```zsh
   tmpfile=$(mktemp)
   lifecycle-track-temp-file "$tmpfile"
   lifecycle-list-temp-files  # Should show your file
   ```

3. **Check cleanup order:**
   ```zsh
   # If using dependency cleanup:
   lifecycle-cleanup-order
   # If using LIFO:
   lifecycle-cleanup-list
   ```

---

### Problem: Circular Dependencies Detected

**Symptoms:** `lifecycle-cleanup-add` fails with "Circular dependency detected"

**Diagnosis:**
```zsh
# Visualize dependency graph
lifecycle-cleanup-order

# Validate graph
lifecycle-cleanup-validate
# Output: ERROR: Circular dependency detected
```

**Solutions:**

1. **Review dependencies:**
   ```zsh
   # Bad:
   lifecycle-cleanup-add "a" cmd_a "b"
   lifecycle-cleanup-add "b" cmd_b "a"
   # a depends on b, b depends on a = cycle!

   # Good:
   lifecycle-cleanup-add "a" cmd_a
   lifecycle-cleanup-add "b" cmd_b "a"
   # Only one direction
   ```

2. **Simplify dependencies:**
   ```zsh
   # Bad: complex web
   lifecycle-cleanup-add "a" cmd_a "b" "c" "d"
   lifecycle-cleanup-add "b" cmd_b "c"
   lifecycle-cleanup-add "c" cmd_c "d"
   lifecycle-cleanup-add "d" cmd_d "a"  # Cycle!

   # Good: linear chain
   lifecycle-cleanup-add "d" cmd_d
   lifecycle-cleanup-add "c" cmd_c "d"
   lifecycle-cleanup-add "b" cmd_b "c"
   lifecycle-cleanup-add "a" cmd_a "b"
   ```

---

### Problem: Auto-Restart Not Working

**Symptoms:** Process restarts not happening despite `lifecycle-restart-enable`

**Diagnosis:**
```zsh
# Check restart status
lifecycle-restart-status 1234

# Check if monitor running
ps aux | grep lifecycle-restart-monitor

# Manual check
lifecycle-restart-check
```

**Solutions:**

1. **Enable restart:**
   ```zsh
   pid=$!
   lifecycle-restart-enable "$pid" "my_command" 3 2

   # Verify enabled
   lifecycle-restart-status "$pid"  # Should show "enabled"
   ```

2. **Check monitor interval:**
   ```zsh
   LIFECYCLE_RESTART_MONITOR_INTERVAL=3  # Check every 3 seconds

   # Default is 5 seconds, so might miss death
   ```

3. **Check command syntax:**
   ```zsh
   # Good:
   lifecycle-restart-enable 1234 "my_app --daemon"

   # Bad (command won't execute):
   lifecycle-restart-enable 1234 "function_that_doesnt_exist"
   ```

---

### Problem: Graceful Shutdown Not Working

**Symptoms:** Ctrl+C causes immediate exit instead of graceful shutdown

**Diagnosis:**
```zsh
# Check if graceful installed
trap -p INT  # Should show lifecycle-graceful-shutdown

# Check shutdown flag
echo $LIFECYCLE_SHUTDOWN_REQUESTED
```

**Solutions:**

1. **Install with graceful flag:**
   ```zsh
   # Graceful shutdown
   lifecycle-trap-install --graceful

   # vs. immediate
   lifecycle-trap-install
   ```

2. **Set timeout:**
   ```zsh
   LIFECYCLE_GRACEFUL_SHUTDOWN_TIMEOUT=30
   lifecycle-trap-install --graceful
   ```

3. **Check application code:**
   ```zsh
   # Application should check the flag:
   while [[ "$LIFECYCLE_SHUTDOWN_REQUESTED" != "true" ]]; do
       # Do work
   done
   ```

---

### Problem: Dry-Run Not Working

**Symptoms:** Operations execute despite LIFECYCLE_DRY_RUN=true

**Diagnosis:**
```zsh
# Check dry-run flag
echo $LIFECYCLE_DRY_RUN

# Check debug output
LIFECYCLE_DEBUG=true
# Should show [DRY RUN] messages
```

**Solutions:**

1. **Enable before loading lifecycle:**
   ```zsh
   LIFECYCLE_DRY_RUN=true
   source "$(which _lifecycle)"

   # vs. after (might not work):
   source "$(which _lifecycle)"
   LIFECYCLE_DRY_RUN=true
   ```

2. **Check cleanup types:**
   ```zsh
   # Dry-run affects:
   LIFECYCLE_CLEANUP_JOBS=true
   LIFECYCLE_CLEANUP_TEMP=true
   LIFECYCLE_CLEANUP_SERVICES=true
   LIFECYCLE_CLEANUP_STATE=true

   # But not LIFO cleanups (they always run unless you override)
   ```

---

### Problem: Memory Leaks from Tracked Resources

**Symptoms:** Arrays growing unbounded, lots of tracked resources

**Diagnosis:**
```zsh
# Check sizes
echo "PIDs tracked: ${#_LIFECYCLE_TRACKED_PIDS[@]}"
echo "Files tracked: ${#_LIFECYCLE_TRACKED_TEMP_FILES[@]}"
echo "Services tracked: ${#_LIFECYCLE_TRACKED_SERVICES[@]}"
```

**Solutions:**

1. **Untrack when done:**
   ```zsh
   tmpfile=$(mktemp)
   lifecycle-track-temp-file "$tmpfile"

   # Use file
   cat "$tmpfile"

   # Done using, untrack
   lifecycle-untrack-temp-file "$tmpfile"
   rm "$tmpfile"
   ```

2. **List before exit:**
   ```zsh
   # Verify no orphaned resources
   lifecycle-list-jobs
   lifecycle-list-temp-files
   lifecycle-list-services
   ```

---

### Problem: Events Not Firing

**Symptoms:** Event handlers registered but never called

**Diagnosis:**
```zsh
# Check if events available
echo $LIFECYCLE_EVENTS_AVAILABLE

# Check event emission enabled
echo $LIFECYCLE_EMIT_EVENTS

# Check handler registered
lifecycle-event my-event my-handler
# No output = registered
```

**Solutions:**

1. **Enable event emission:**
   ```zsh
   LIFECYCLE_EMIT_EVENTS=true
   source "$(which _lifecycle)"
   ```

2. **Check _events available:**
   ```zsh
   # If LIFECYCLE_EVENTS_AVAILABLE=false, uses fallback
   # Fallback has limited features

   # Ensure _events loaded:
   source "$(which _events)"
   ```

3. **Check handler syntax:**
   ```zsh
   # Define handler properly:
   my_handler() {
       echo "Event fired with: $*"
   }

   # Register handler:
   lifecycle-event "my.event" my_handler

   # Trigger:
   lifecycle-event-trigger "my.event" "arg1" "arg2"
   ```

---

## External References

<!-- CONTEXT_PRIORITY: LOW -->

- **ZSH Trap Documentation**: https://zsh.sourceforge.io/Doc/Release/Functions.html#Trap-Functions
- **Signal Handling**: man 7 signal
- **Systemd Services**: man systemd.unit
- **Process Management**: man ps, man kill
- **Related Extensions**:
  - `_common` - Core utilities and validation
  - `_log` - Structured logging
  - `_events` - Event system with history
  - `_config` - Configuration management
  - `_xdg` - XDG Base Directory support

---

**Documentation Version:** 1.0.0
**Generated:** 2025-11-07
**Status:** Complete Gold Standard (Enhanced Requirements v1.1)
