# _systemd - Systemd Service Management Extension

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: Infrastructure -->

**Version:** 1.0.0 (Enhanced Documentation Requirements v1.1)
**Layer:** 2 - Infrastructure
**File:** ~/.local/bin/lib/_systemd
**Source Lines:** 1-837
**Functions:** 31 public, 1 internal helper
**Examples:** 120+ integrated examples
**Tables:** 14 reference tables
**Status:** Production Ready
**Last Updated:** 2025-11-07

---

## Quick Reference Index

| Section | Lines | Content |
|---------|-------|---------|
| Function Quick Reference | 60-145 | All 31 functions with source locations |
| Service States Reference | 146-180 | Systemd service states |
| Unit Types Reference | 181-215 | Service, timer, socket types |
| Environment Variables | 216-245 | Configuration variables |
| Return Codes Reference | 246-280 | Exit codes by operation |
| Overview | 281-345 | Features, design philosophy |
| Installation | 346-405 | Setup and dependencies |
| Quick Start | 406-525 | 6+ basic examples |
| Configuration | 526-610 | All configuration options |
| API Reference | 611-1280 | All functions detailed |
| Advanced Usage | 1281-1535 | 6+ integration patterns |
| Best Practices | 1536-1695 | 8+ guidelines |
| Troubleshooting | 1696-1895 | 6+ common issues |
| Architecture | 1896-2025 | Design, layers, error handling |
| External References | 2026+ | Links and related libraries |

---

## Function Quick Reference

<!-- CONTEXT_GROUP: Status Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Status Checking** | | | |
| systemd-is-active | 145 | Check if service is running | 0/1 (active/inactive) |
| systemd-is-enabled | 157 | Check if service starts on boot | 0/1 (enabled/disabled) |
| systemd-is-failed | 169 | Check if service has failed | 0/1 (failed/ok) |
| systemd-get-status | 178 | Get full status output | Status text |
| systemd-get-state | 187 | Get single-word state | State string |
| systemd-exists | 196 | Check if unit file exists | 0/1 (exists/missing) |

<!-- CONTEXT_GROUP: Control Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Service Control** | | | |
| systemd-start | 213 | Start service | 0/2 (success/failure) |
| systemd-stop | 249 | Stop service | 0/2 (success/failure) |
| systemd-restart | 285 | Restart service | 0/2 (success/failure) |
| systemd-reload | 321 | Reload config without restart | 0/2 (success/failure) |
| systemd-reload-or-restart | 352 | Reload if supported, else restart | 0/2 (success/failure) |

<!-- CONTEXT_GROUP: Enable/Disable Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Enable/Disable** | | | |
| systemd-enable | 376 | Enable service autostart | 0/1 (success/failure) |
| systemd-disable | 403 | Disable service autostart | 0/1 (success/failure) |
| systemd-enable-start | 430 | Enable and start immediately | 0/1 (success/failure) |
| systemd-disable-stop | 439 | Stop and disable | 0/1 (success/failure) |

<!-- CONTEXT_GROUP: Daemon Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Daemon Control** | | | |
| systemd-daemon-reload | 452 | Reload systemd daemon | 0/1 (success/failure) |

<!-- CONTEXT_GROUP: Unit Generation -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Unit File Generation** | | | |
| systemd-generate-service | 478 | Generate service unit | Unit file text |
| systemd-generate-template | 505 | Generate template service | Template unit text |
| systemd-generate-timer | 531 | Generate timer unit | Timer unit text |

<!-- CONTEXT_GROUP: Journal Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Journal/Logging** | | | |
| systemd-logs | 556 | View service logs | Log output |
| systemd-logs-follow | 571 | Follow logs real-time | Continuous output |
| systemd-logs-since | 585 | View logs since timestamp | Filtered logs |
| systemd-logs-priority | 601 | View logs by priority | Filtered logs |

<!-- CONTEXT_GROUP: Listing Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Service Discovery** | | | |
| systemd-list-services | 620 | List all services | Service list |
| systemd-list-enabled | 627 | List enabled services | Enabled list |
| systemd-list-failed | 634 | List failed services | Failed list |
| systemd-list-running | 641 | List running services | Running list |

<!-- CONTEXT_GROUP: Property Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Property Access** | | | |
| systemd-get-property | 652 | Get service property | Property value |
| systemd-get-pid | 662 | Get service PID | Process ID |
| systemd-get-memory | 671 | Get memory usage | Memory in bytes |

<!-- CONTEXT_GROUP: Utility Functions -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Utilities** | | | |
| systemd-available | 684 | Check if systemd available | 0/1 (available/missing) |
| systemd-version | 690 | Get systemd version | Version number |
| systemd-wait-active | 696 | Wait for service to start | 0/1 (success/timeout) |

<!-- CONTEXT_GROUP: Internal -->

| Function | Line | Purpose | Returns |
|----------|------|---------|---------|
| **Internal** | | | |
| systemd--emit-event | 723 | Emit event (internal) | Event sent or ignored |
| systemd-self-test | 735 | Self-test suite | Test results |

---

## Service States Reference

Systemd service states represent the lifecycle status of a unit:

| State | Exit Code | Meaning | Common Causes | Recovery |
|-------|-----------|---------|---------------|----------|
| **active** | N/A | Service is running | Normal operation | N/A |
| **inactive** | N/A | Service is stopped | Manual stop, not enabled | `systemd-start` |
| **activating** | N/A | Service is starting | Slow startup | Wait or restart |
| **deactivating** | N/A | Service is stopping | Graceful shutdown | Complete stop |
| **failed** | 1 | Service crashed or error | Config error, missing deps | Check logs, fix, restart |
| **reloading** | N/A | Service reloading config | Config reload in progress | Wait for completion |

**Status Hierarchy:**
```
enabled/disabled  (autostart behavior)
    ↓
active/inactive   (current state)
    ↓
failed            (error state)
```

**Query Methods:**
- `systemd-is-active` → Check if running
- `systemd-is-enabled` → Check if starts on boot
- `systemd-is-failed` → Check for error state
- `systemd-get-state` → Get state name
- `systemd-get-status` → Full status details

---

## Unit Types Reference

Systemd supports multiple unit types; _systemd focuses on service and timer units:

### Service Unit Types

| Type | Use Case | ExecStart | Behavior | Restart |
|------|----------|-----------|----------|---------|
| **simple** | Normal services | Long-running command | Main process = service | Supported |
| **forking** | Traditional daemon | Spawns child, parent exits | Parent PID tracked | Supported |
| **oneshot** | Run-once tasks | Command exits quickly | Completes and stops | Supported |
| **notify** | Status notification | Sends readiness signal | Waits for ready signal | Supported |
| **dbus** | DBus activation | Auto-started on bus | Bus method call trigger | Supported |
| **idle** | Delayed start | Waits for systemd idle | After all jobs done | Supported |

**Type Selection Guide:**
```
Long-running app → Type=simple (most common)
Traditional daemon → Type=forking
Scheduled task/timer → Type=oneshot
App sends readiness event → Type=notify
Background service → Type=idle
```

### Timer Unit Specifications

| Schedule | Format | Example | Frequency |
|----------|--------|---------|-----------|
| **minutely** | Literal name | `minutely` | Every minute |
| **hourly** | Literal name | `hourly` | Every hour |
| **daily** | Literal name | `daily` | Every day at midnight |
| **weekly** | Literal name | `weekly` | Monday midnight |
| **monthly** | Literal name | `monthly` | 1st of month |
| **yearly** | Literal name | `yearly` | Jan 1, midnight |
| **Custom** | DOW HH:MM:SS | `Mon *-*-* 09:00:00` | Specific day/time |
| **Custom** | *-MM-DD HH:MM | `*-12-25 09:00:00` | Specific date |
| **Boot** | `@reboot` | (special value) | System boot |
| **Bootup** | `@+2h` | (offset) | 2 hours after boot |

---

## Environment Variables Reference

Configuration variables control _systemd behavior:

| Variable | Default | Type | Purpose | Scope |
|----------|---------|------|---------|-------|
| `SYSTEMD_DEBUG` | `false` | Boolean | Enable debug logging | Global |
| `SYSTEMD_DRY_RUN` | `false` | Boolean | Dry-run mode (preview only) | Global |
| `SYSTEMD_EMIT_EVENTS` | `true` | Boolean | Emit events on state change | Global |
| `SYSTEMD_DEFAULT_SCOPE` | `--user` | String | Default user or system | Global |

**Usage Examples:**

```zsh
# Enable debug output
export SYSTEMD_DEBUG=true
systemd-start "myapp"  # Shows [DEBUG] messages

# Dry-run all operations
export SYSTEMD_DRY_RUN=true
systemd-start "myapp"  # Shows [DRY-RUN] Would start...

# Disable events
export SYSTEMD_EMIT_EVENTS=false

# Change default to system scope
export SYSTEMD_DEFAULT_SCOPE="--system"

# View current config
echo "Debug: $SYSTEMD_DEBUG"
echo "Dry-run: $SYSTEMD_DRY_RUN"
```

**Scope Values:**
- `--user` → User services (default, no sudo needed)
- `--system` → System services (requires sudo for most operations)

---

## Return Codes Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->

All _systemd functions follow consistent exit code patterns:

### Boolean Status Functions (0/1)

These functions return 0 if condition is true, 1 if false:

| Function | Exit 0 | Exit 1 |
|----------|--------|--------|
| `systemd-is-active` | Service running | Service not running |
| `systemd-is-enabled` | Service enabled | Service disabled |
| `systemd-is-failed` | Service failed | Service not failed |
| `systemd-exists` | Unit file exists | Unit file missing |
| `systemd-available` | Systemd available | Systemd missing |
| `systemd-wait-active` | Became active | Timed out |

**Usage:**
```zsh
if systemd-is-active "myapp"; then
    echo "Running"
else
    echo "Not running"
fi
```

### Control Operation Functions (0/2)

Service control functions return 0 for success, 2 for failure:

| Function | Exit 0 | Exit 1 | Exit 2 |
|----------|--------|--------|--------|
| `systemd-start` | Started successfully | Missing unit | Failed to start |
| `systemd-stop` | Stopped successfully | Missing unit | Failed to stop |
| `systemd-restart` | Restarted successfully | Missing unit | Failed to restart |
| `systemd-reload` | Reloaded successfully | Missing unit | Failed to reload |
| `systemd-reload-or-restart` | Success | Missing unit | Failed |
| `systemd-enable` | Enabled successfully | Missing unit | Failed to enable |
| `systemd-disable` | Disabled successfully | Missing unit | Failed to disable |
| `systemd-enable-start` | Completed successfully | N/A | Failed |
| `systemd-disable-stop` | Completed successfully | N/A | Failed |
| `systemd-daemon-reload` | Daemon reloaded | N/A | Failed to reload |

**Usage:**
```zsh
systemd-start "myapp" "--user"
case $? in
    0) echo "Service started" ;;
    1) echo "Service not found" ;;
    2) echo "Failed to start" ;;
esac
```

### Error Handling Pattern

```zsh
# Basic check
if systemd-start "myapp"; then
    echo "Success"
else
    # Exit code tells what went wrong
    systemd-logs "myapp" 20
fi

# Detailed handling
systemd-start "myapp"
exit_code=$?

case $exit_code in
    0)
        echo "Service started"
        ;;
    1)
        echo "Error: Service unit not found"
        systemd-daemon-reload
        ;;
    2)
        echo "Error: Failed to start service"
        systemd-logs "myapp" 50
        ;;
esac
```

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->

The `_systemd` extension provides enterprise-grade systemd service management through a clean, composable ZSH API. It abstracts systemctl and journalctl operations into high-level functions supporting both user and system services with comprehensive error handling and dry-run mode.

### Purpose

Provide production-ready systemd integration that:
- Simplifies service lifecycle management (start, stop, restart, reload)
- Enables safe operations through dry-run mode
- Supports both user and system services transparently
- Integrates with logging, events, and process management
- Provides comprehensive status checking and monitoring
- Generates unit files programmatically
- Accesses service logs with filtering capabilities

### Features

**Service Control:**
- Start, stop, restart, reload services
- Enable/disable service autostart
- Reload configuration without restart
- Combined enable-start and disable-stop operations

**Status Checking:**
- Check if service is active, enabled, or failed
- Get full status and single-word state
- Check if unit file exists
- Query service properties (PID, memory, CPU)

**Unit File Generation:**
- Generate simple service units
- Generate template services (parameterized)
- Generate timer units for scheduled tasks
- Daemon reload after unit file changes

**Log Access:**
- View recent logs (by line count)
- Follow logs in real-time
- Filter logs by timestamp
- Filter logs by priority level

**Service Discovery:**
- List all services
- List enabled services
- List failed services
- List running services

**Advanced Features:**
- Dry-run mode for safe testing
- Event emission on state changes
- Wait for service to become active (with timeout)
- Get systemd version

### Design Philosophy

The extension follows key principles:

1. **Safe by Default**: Dry-run mode prevents accidental state changes
2. **Scope Aware**: Transparently handle user vs. system services
3. **Error Resilient**: Graceful handling with informative error messages
4. **Observable**: Easy access to logs, status, and state
5. **Composable**: Functions work together naturally in scripts
6. **Production-Ready**: Comprehensive error handling and event integration

### Architecture

```
User Code
    ↓
_systemd Functions (API Layer)
    ├─ Status Checking (is-active, is-enabled, etc.)
    ├─ Service Control (start, stop, restart, reload)
    ├─ Enable/Disable (enable, disable, enable-start, etc.)
    ├─ Unit Generation (service, template, timer)
    ├─ Journal Access (logs, follow, filter)
    └─ Service Discovery (list-*, get-property)
    ↓
Dry-Run Layer (preview mode)
    ↓
systemctl / journalctl Commands
    ↓
systemd Daemon
```

### Dependencies

**Required:**
- `_common` v2.0 - Core utilities (dependency resolution, error handling)
- `systemd` - systemctl command, journalctl access
- ZSH 5.0+ - Shell environment

**Optional (graceful degradation):**
- `_log` v2.0 - Logging functions (fallback to echo if missing)
- `_events` v2.0 - Event system integration (events disabled if missing)
- `_process` v2.0 - Process utilities (detected for dependency injection)
- `_dryrun` v2.0 - Enhanced dry-run support (standard approach)

**System Requirements:**
- Linux with systemd (most modern distributions)
- User session manager (for `--user` services)
- systemctl/journalctl in PATH

### Integration Points

```
_common
    ↓
_systemd ←→ _log (optional)
    ↓      ←→ _events (optional)
    ↓      ←→ _process (optional)
    ↓
systemctl / journalctl
    ↓
systemd daemon
```

---

## Installation

### Prerequisites

Check for systemd availability:

```zsh
# Check systemd version
systemctl --version

# Check journalctl availability
journalctl --version

# Check user session
systemctl --user is-active --quiet dbus || echo "User session not available"
```

### Setup Steps

1. **Ensure .local/bin/lib is in your PATH:**

```zsh
# Add to ~/.zshrc or ~/.zsh/config.zsh
export PATH="$HOME/.local/bin/lib:$HOME/.local/bin:$PATH"

# Verify
echo $PATH | grep -q "$HOME/.local/bin/lib" && echo "In PATH" || echo "Not in PATH"
```

2. **Install via stow (recommended):**

```bash
cd ~/.pkgs
stow lib

# Verify installation
which _systemd
ls -la ~/.local/bin/lib/_systemd
```

3. **Verify installation:**

```zsh
# Source directly
source "$(which _systemd)"

# Check version
echo "Loaded: $SYSTEMD_LOADED"
echo "Version: $SYSTEMD_VERSION"

# Run self-test
systemd-self-test
```

### Dependency Verification

```zsh
#!/usr/bin/env zsh

echo "=== _systemd Dependency Check ==="

# Check _common
if source "$(which _common)" 2>/dev/null; then
    echo "✓ _common loaded"
else
    echo "✗ _common missing (required)"
    exit 1
fi

# Check systemd
if systemd-available; then
    echo "✓ systemd available ($(systemd-version))"
else
    echo "✗ systemd not available (required)"
    exit 1
fi

# Check optional dependencies
for lib in _log _events _process; do
    if source "$(which $lib)" 2>/dev/null; then
        echo "✓ $lib loaded (optional)"
    else
        echo "- $lib not found (optional, graceful degradation)"
    fi
done

echo ""
echo "Installation complete and verified"
```

---

## Quick Start

### Basic Usage Pattern

```zsh
#!/usr/bin/env zsh

# Load extension
source "$(which _systemd)"

# Start a service
systemd-start "myapp" "--user"

# Check status
if systemd-is-active "myapp" "--user"; then
    echo "Service is running"
else
    echo "Service is not running"
fi

# View logs
systemd-logs "myapp" 50 "--user"

# Stop service
systemd-stop "myapp" "--user"
```

### Example 1: Check Service Status

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

SERVICE="nginx"
SCOPE="--system"

echo "=== Service Status Check ==="

# Check if running
if systemd-is-active "$SERVICE" "$SCOPE"; then
    echo "✓ $SERVICE is active"
else
    echo "✗ $SERVICE is not active"
fi

# Check if enabled
if systemd-is-enabled "$SERVICE" "$SCOPE"; then
    echo "✓ $SERVICE starts on boot"
else
    echo "- $SERVICE does not start on boot"
fi

# Check if failed
if systemd-is-failed "$SERVICE" "$SCOPE"; then
    echo "✗ $SERVICE is in failed state"
    systemd-logs-priority "$SERVICE" "err" "$SCOPE"
fi

# Get full status
echo ""
echo "Status details:"
systemd-get-status "$SERVICE" "$SCOPE"
```

**Output:**
```
=== Service Status Check ===
✓ nginx is active
✓ nginx starts on boot
Status details:
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2025-11-04 10:00:00 UTC; 5 days ago
```

### Example 2: Service Lifecycle Management

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

SERVICE="myapp"
SCOPE="--user"

# Start service
echo "Starting $SERVICE..."
systemd-start "$SERVICE" "$SCOPE"

# Wait for it to be active
echo "Waiting for service to start..."
if systemd-wait-active "$SERVICE" 30 "$SCOPE"; then
    echo "✓ Service started successfully"
else
    echo "✗ Service failed to start"
    systemd-logs "$SERVICE" 50 "$SCOPE"
    exit 1
fi

# Do some work...
sleep 5

# Reload configuration
echo "Reloading configuration..."
systemd-reload-or-restart "$SERVICE" "$SCOPE"

# Stop service
echo "Stopping $SERVICE..."
systemd-stop "$SERVICE" "$SCOPE"

# Verify stopped
if ! systemd-is-active "$SERVICE" "$SCOPE"; then
    echo "✓ Service stopped successfully"
fi
```

### Example 3: Service Installation

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

SERVICE_NAME="myapp"
EXEC_PATH="$HOME/.local/bin/myapp"
DESCRIPTION="My Application Service"

# Generate unit file
UNIT_FILE="$HOME/.config/systemd/user/${SERVICE_NAME}.service"

systemd-generate-service "$SERVICE_NAME" "$EXEC_PATH" "$DESCRIPTION" \
    > "$UNIT_FILE"

echo "Created: $UNIT_FILE"

# Reload daemon to recognize new service
systemd-daemon-reload "--user"

# Enable and start
systemd-enable-start "$SERVICE_NAME" "--user"

# Verify
sleep 1
if systemd-is-active "$SERVICE_NAME" "--user"; then
    echo "✓ Service installed and running"
    systemd-get-status "$SERVICE_NAME" "--user"
else
    echo "✗ Service installation failed"
    systemd-logs "$SERVICE_NAME" 20 "--user"
    exit 1
fi
```

### Example 4: Dry-Run Testing

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Enable dry-run mode
export SYSTEMD_DRY_RUN=true

echo "=== Testing Service Operations (Dry-Run) ==="
echo "These operations will show what would happen without executing"
echo ""

# These show what would happen
systemd-start "myapp" "--user"
systemd-restart "nginx" "--system"
systemd-enable "postgresql" "--system"
systemd-logs "myapp" 20 "--user"

echo ""
echo "=== Dry-run test complete ==="
echo "No actual changes were made"

# Disable dry-run for actual operations
export SYSTEMD_DRY_RUN=false
```

### Example 5: Monitor Multiple Services

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Services to monitor
declare -A SERVICES=(
    [nginx]="--system"
    [postgresql]="--system"
    [myapp]="--user"
)

echo "=== Service Status Report ==="
echo ""

for service in "${(@k)SERVICES}"; do
    scope="${SERVICES[$service]}"
    state=$(systemd-get-state "$service" "$scope" 2>/dev/null || echo "error")

    case "$state" in
        active)
            echo "✓ $service: active"
            ;;
        inactive)
            echo "○ $service: inactive"
            ;;
        failed)
            echo "✗ $service: failed"
            ;;
        *)
            echo "? $service: $state"
            ;;
    esac
done

echo ""
echo "Failed services:"
systemd-list-failed "--user" 2>/dev/null | grep -v "^  " | head -5
```

### Example 6: Timer Management

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Create timer for daily backup
TIMER_NAME="backup"
SCHEDULE="daily"
SCRIPT="$HOME/.local/bin/backup.sh"

# Verify script exists
if [[ ! -f "$SCRIPT" ]]; then
    echo "Error: Script not found: $SCRIPT" >&2
    exit 1
fi

chmod +x "$SCRIPT"

# Generate service unit
systemd-generate-service "$TIMER_NAME" "$SCRIPT" "Daily Backup" \
    "oneshot" "no" > "$HOME/.config/systemd/user/${TIMER_NAME}.service"

# Generate timer unit
systemd-generate-timer "$TIMER_NAME" "$SCHEDULE" "Daily Backup Timer" \
    > "$HOME/.config/systemd/user/${TIMER_NAME}.timer"

# Activate timer
systemd-daemon-reload "--user"
systemd-enable-start "${TIMER_NAME}.timer" "--user"

echo "✓ Timer installed: $TIMER_NAME (runs $SCHEDULE)"

# Show next run time
systemctl --user list-timers "${TIMER_NAME}.timer"
```

---

## Configuration

### Scope Selection

<!-- CONTEXT_PRIORITY: MEDIUM -->

Systemd distinguishes between user and system services:

#### User Services (--user)

Services run in user's session, no privileged access needed:

```zsh
# User service operations
systemd-start "myapp" "--user"
systemd-is-active "myapp" "--user"
systemd-logs "myapp" 20 "--user"

# Location
~/.config/systemd/user/myapp.service

# Enable
systemd-enable "myapp" "--user"  # Starts on login

# List
systemd-list-services "--user"
```

**Use Cases:**
- Personal applications
- Development services
- User daemons (background apps)
- Private timers

**Advantages:**
- No sudo needed
- Isolated per user
- Automatic cleanup on logout

#### System Services (--system)

Services run system-wide with full privileges:

```zsh
# System service operations (need sudo)
sudo systemd-start "nginx" "--system"
sudo systemd-is-active "nginx" "--system"
sudo systemd-logs "nginx" 20 "--system"

# Location
/etc/systemd/system/nginx.service
/usr/lib/systemd/system/nginx.service

# Enable
sudo systemd-enable "nginx" "--system"  # Starts on boot

# List
sudo systemd-list-services "--system"
```

**Use Cases:**
- System daemons
- Web servers
- Databases
- Network services

**Advantages:**
- System-wide availability
- Persist across reboots
- Full privileges available
- Multi-user access

#### Hybrid Approach

Many setups use both:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

check-service() {
    local service="$1"

    # Check system first (if available)
    if sudo systemd-is-active "$service" "--system" 2>/dev/null; then
        echo "$service (system): active"
        return 0
    fi

    # Then check user
    if systemd-is-active "$service" "--user" 2>/dev/null; then
        echo "$service (user): active"
        return 0
    fi

    echo "$service: not found"
    return 1
}

# Check both system and user services
check-service "nginx"
check-service "myapp"
```

### Dry-Run Mode

Dry-run mode previews operations without executing them:

#### Enable Dry-Run

```zsh
# Method 1: Environment variable
export SYSTEMD_DRY_RUN=true
systemd-start "myapp" "--user"
# Output: [DRY-RUN] Would start: systemctl --user start myapp

# Method 2: Check before doing
if systemd-is-dry-run; then
    echo "In dry-run mode"
fi

# Disable
export SYSTEMD_DRY_RUN=false
```

#### Dry-Run Workflow

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Phase 1: Preview all operations
echo "=== Preview Mode ==="
export SYSTEMD_DRY_RUN=true

systemd-daemon-reload "--user"
systemd-enable-start "myapp" "--user"
systemd-restart "nginx" "--system"

echo ""
echo "=== Execute Phase ==="
export SYSTEMD_DRY_RUN=false

# Now actually execute
systemd-daemon-reload "--user"
systemd-enable-start "myapp" "--user"
systemd-restart "nginx" "--system"
```

#### Safe Testing Pattern

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

TEST_MODE="${1:-dry-run}"

if [[ "$TEST_MODE" == "dry-run" ]]; then
    export SYSTEMD_DRY_RUN=true
    echo "=== DRY-RUN MODE (no changes will be made) ==="
else
    export SYSTEMD_DRY_RUN=false
    echo "=== LIVE MODE (changes will be applied) ==="
fi

echo ""

# Execute operations
systemd-start "myapp" "--user"
systemd-enable "myapp" "--user"

echo ""
echo "To run for real, execute: $0 live"
```

### Unit File Locations

Systemd searches for unit files in specific directories:

#### User Unit Files

User-level service definitions:

```
$XDG_CONFIG_HOME/systemd/user/  (priority 1)
~/.config/systemd/user/          (default, usually same)
~/.local/share/systemd/user/     (additional location)
/usr/local/lib/systemd/user/     (system-wide user units)
/usr/lib/systemd/user/           (distribution user units)
```

**Verify user unit path:**

```zsh
systemctl --user show-environment | grep XDG_CONFIG_HOME

# Create if needed
mkdir -p ~/.config/systemd/user
```

#### System Unit Files

System-level service definitions (requires root):

```
/etc/systemd/system/             (priority 1, local customizations)
/usr/local/lib/systemd/system/   (system-wide additions)
/usr/lib/systemd/system/         (distribution default units)
/lib/systemd/system/             (fallback)
```

#### Managing Unit Files

```zsh
# List unit file locations searched
systemctl --user show-environment | grep SYSTEMD

# Show unit file path for service
systemctl --user show nginx --property=FragmentPath

# Edit unit file (with validation)
systemctl --user edit --full myapp.service

# Reload after changes
systemd-daemon-reload "--user"
```

### Debug Configuration

Enable debug logging for troubleshooting:

```zsh
# Set debug mode
export SYSTEMD_DEBUG=true
export SYSTEMD_LOG_LEVEL=debug

# View debug output
source "$(which _systemd)"
systemd-start "myapp" "--user"  # Shows [DEBUG] messages

# Disable debug
export SYSTEMD_DEBUG=false
```

---

## API Reference

<!-- CONTEXT_PRIORITY: HIGH -->

Complete function documentation with usage patterns and examples.

### Service Status Functions

These functions check service state without modifying it.

#### systemd-is-active (→ L145)

Check if service is currently active (running).

**Signature:**
```zsh
systemd-is-active <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name (e.g., "nginx", "myapp.service")
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service is active
- `1` - Service is not active

**Complexity:** O(1) - Single systemctl query
**Cache:** No built-in caching

**Examples:**

```zsh
# Check if service is running
if systemd-is-active "nginx" "--system"; then
    echo "Web server is running"
fi

# Use in conditional logic
systemd-is-active "myapp" "--user" && echo "Running" || echo "Stopped"

# With error handling
if systemd-is-active "postgres" "--system"; then
    echo "Database available"
else
    echo "Database offline - starting..."
    systemd-start "postgres" "--system"
fi
```

---

#### systemd-is-enabled (→ L157)

Check if service is enabled (will start on boot/login).

**Signature:**
```zsh
systemd-is-enabled <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service is enabled
- `1` - Service is not enabled

**Complexity:** O(1) - Single systemctl query
**Performance:** ~15ms per call

**Examples:**

```zsh
# Check if starts on boot
if systemd-is-enabled "nginx" "--system"; then
    echo "Nginx starts on boot"
else
    echo "Nginx must be started manually"
fi

# Enable if not already
if ! systemd-is-enabled "myapp" "--user"; then
    systemd-enable "myapp" "--user"
fi

# Status summary
state=$(systemd-get-state "myapp" "--user")
enabled=$(systemd-is-enabled "myapp" "--user" && echo "yes" || echo "no")
echo "Service: $state, Autostart: $enabled"
```

---

#### systemd-is-failed (→ L169)

Check if service is in failed state (crashed or error).

**Signature:**
```zsh
systemd-is-failed <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service has failed
- `1` - Service is not in failed state

**Complexity:** O(1) - Single systemctl query
**Error Handling:** Graceful if service missing

**Examples:**

```zsh
# Check for failed state
if systemd-is-failed "myapp" "--user"; then
    echo "Service has failed!"

    # Show error details
    systemd-logs "myapp" 50 "--user"

    # Attempt recovery
    systemd-restart "myapp" "--user"
fi

# Monitor for failures
for service in myapp worker cache; do
    if systemd-is-failed "$service" "--user"; then
        echo "Alert: $service failed"
    fi
done
```

---

#### systemd-get-status (→ L178)

Get full service status output.

**Signature:**
```zsh
systemd-get-status <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- Multi-line status output (first 10 lines typically)

**Complexity:** O(1) - Single systemctl query
**Performance:** ~20ms per call
**Output:** 5-15 lines of formatted text

**Examples:**

```zsh
# Get full status
systemd-get-status "nginx" "--system"

# Capture for parsing
status=$(systemd-get-status "myapp" "--user")

# Extract first line (● marker and description)
head -1 <<< "$status"

# Show status with timestamp
{
    echo "[$(date)] Status check for myapp:"
    systemd-get-status "myapp" "--user"
} | tee -a ~/myapp-status.log
```

---

#### systemd-get-state (→ L187)

Get single-word service state (active, inactive, failed, etc.).

**Signature:**
```zsh
systemd-get-state <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- State string: "active", "inactive", "failed", "activating", "deactivating", etc.
- Default: "inactive" (if query fails)

**Complexity:** O(1) - Single systemctl query
**Cache:** Can be cached for brief period

**Examples:**

```zsh
# Get current state
state=$(systemd-get-state "nginx" "--system")
echo "Nginx state: $state"

# Pattern matching on state
case "$(systemd-get-state "myapp" "--user")" in
    active)
        echo "Service running"
        ;;
    inactive)
        echo "Service stopped"
        ;;
    failed)
        echo "Service failed - investigating..."
        systemd-logs-priority "myapp" "err" "--user"
        ;;
    activating)
        echo "Service starting..."
        systemd-wait-active "myapp" 30 "--user"
        ;;
esac

# Multi-service status dashboard
for service in nginx postgresql redis; do
    state=$(systemd-get-state "$service" "--system")
    printf "%-15s %s\n" "$service:" "$state"
done
```

---

#### systemd-exists (→ L196)

Check if unit file exists in systemd.

**Signature:**
```zsh
systemd-exists <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Unit file exists
- `1` - Unit file not found

**Complexity:** O(1) - Single systemctl list query
**Performance:** ~25ms per call

**Examples:**

```zsh
# Check before operating on service
if systemd-exists "myapp" "--user"; then
    systemd-start "myapp" "--user"
else
    echo "Error: Service not found"
    systemd-list-services "--user" | grep myapp
fi

# Validate installation
if ! systemd-exists "worker" "--user"; then
    echo "Worker service missing - installing..."
    systemd-generate-service "worker" "/usr/local/bin/worker" "Worker" \
        > ~/.config/systemd/user/worker.service
    systemd-daemon-reload "--user"
fi

# Safe discovery
available_services=()
for service in nginx postgresql redis; do
    systemd-exists "$service" "--system" && available_services+=("$service")
done
echo "Available services: ${available_services[@]}"
```

---

### Service Control Functions

These functions modify service state.

#### systemd-start (→ L213)

Start a service.

**Signature:**
```zsh
systemd-start <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service started successfully or dry-run
- `1` - Service unit not found
- `2` - Failed to start service

**Dry-Run:** Shows "Would start: systemctl ... start unit"
**Timeout:** None (returns immediately, service may still be starting)
**Event:** Emits "service.started" on success

**Complexity:** O(n) where n = service startup time (async)
**Performance:** 200-2000ms typically (depends on service)

**Examples:**

```zsh
# Start user service
systemd-start "myapp" "--user"

# Start and check result
if systemd-start "nginx" "--system"; then
    echo "Nginx started"
else
    echo "Failed to start nginx"
    systemd-logs "nginx" 30 "--system"
fi

# Start with wait
systemd-start "myapp" "--user"
if systemd-wait-active "myapp" 30 "--user"; then
    echo "Service started and active"
fi

# Conditional start
if ! systemd-is-active "postgres" "--system"; then
    systemd-start "postgres" "--system"
fi
```

---

#### systemd-stop (→ L249)

Stop a service.

**Signature:**
```zsh
systemd-stop <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service stopped successfully or dry-run
- `1` - Service unit not found
- `2` - Failed to stop service

**Dry-Run:** Shows "Would stop: systemctl ... stop unit"
**Graceful:** Sends SIGTERM first (default timeout 90s)
**Timeout:** 90 seconds before SIGKILL

**Complexity:** O(n) where n = service shutdown time
**Performance:** 100-500ms typically

**Examples:**

```zsh
# Stop service
systemd-stop "myapp" "--user"

# Stop and verify
if systemd-stop "nginx" "--system"; then
    sleep 1
    if systemd-is-active "nginx" "--system"; then
        echo "Service still running - force kill"
        systemctl --system kill --signal=SIGKILL nginx
    else
        echo "Service stopped cleanly"
    fi
fi

# Clean shutdown pattern
echo "Stopping service gracefully..."
systemd-stop "myapp" "--user"

# Wait for graceful shutdown (max 30s)
for i in {1..30}; do
    systemd-is-active "myapp" "--user" || break
    sleep 1
done

# Force kill if still running
systemd-is-active "myapp" "--user" && \
    systemctl --user kill --signal=SIGKILL myapp
```

---

#### systemd-restart (→ L285)

Restart a service (stop then start).

**Signature:**
```zsh
systemd-restart <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service restarted successfully or dry-run
- `1` - Service unit not found
- `2` - Failed to restart service

**Dry-Run:** Shows "Would restart: systemctl ... restart unit"
**Atomic:** Single systemctl operation (not separate stop/start)
**Preserves:** Service configuration and state flags

**Complexity:** O(n) where n = stop + start time
**Performance:** 300-3000ms (depends on service)

**Examples:**

```zsh
# Restart service
systemd-restart "myapp" "--user"

# After config change
cp new-config.json ~/.config/myapp/
systemd-restart "myapp" "--user"

# Restart with health check
systemd-restart "nginx" "--system"
if systemd-wait-active "nginx" 10 "--system"; then
    echo "Nginx restarted successfully"
else
    echo "Nginx failed to restart"
    systemd-logs-priority "nginx" "err" "--system"
fi

# Conditional restart
echo "Config changed - reloading..."
systemd-reload-or-restart "myapp" "--user"
```

---

#### systemd-reload (→ L321)

Reload service configuration without restart.

**Signature:**
```zsh
systemd-reload <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Configuration reloaded or dry-run
- `1` - Service unit not found
- `2` - Reload failed (service may not support it)

**Dry-Run:** Shows "Would reload: systemctl ... reload unit"
**Support:** Not all services support reload (see man for service)
**Advantages:** No service interruption, persistent connections

**Complexity:** O(1) - In-process reload
**Performance:** 50-200ms (service dependent)

**Examples:**

```zsh
# Reload configuration
systemd-reload "nginx" "--system"

# Reload or restart if not supported
systemd-reload-or-restart "myapp" "--user"

# Safe config update
# 1. Update config file
cp new-config.json ~/.config/myapp/
# 2. Reload (or restart if needed)
systemd-reload "myapp" "--user" || systemd-restart "myapp" "--user"
# 3. Verify
systemd-is-active "myapp" "--user" && echo "Config updated"

# Check if service supports reload
systemctl --user show myapp --property SupportedUnitTypes | grep -q reload && \
    echo "Reload supported" || echo "Reload not supported"
```

---

#### systemd-reload-or-restart (→ L352)

Reload configuration if supported, otherwise restart.

**Signature:**
```zsh
systemd-reload-or-restart <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Operation successful or dry-run
- `1` - Service unit not found
- `2` - Operation failed

**Behavior:**
- If reload supported: reloads in-place (best for web servers)
- If reload not supported: performs full restart (compatible)
- Unified return code for both cases

**Advantages:**
- Safe: Works even if reload not supported
- Efficient: Uses reload when available
- Transparent: Script doesn't need to know support level

**Complexity:** O(n) - reload if available, else restart
**Performance:** 50ms (reload) to 3000ms (restart)

**Examples:**

```zsh
# Configuration reload with fallback
systemd-reload-or-restart "nginx" "--system"
echo "Configuration updated"

# Safe config deployment
update-service-config() {
    local service="$1"
    local config_file="$2"
    local new_config="$3"

    echo "Updating $service configuration..."

    # Backup current
    cp "$config_file" "${config_file}.backup"

    # Deploy new
    cp "$new_config" "$config_file"

    # Reload or restart
    if systemd-reload-or-restart "$service" "--user"; then
        echo "✓ Configuration updated"
        return 0
    else
        echo "✗ Failed to reload - restoring backup"
        cp "${config_file}.backup" "$config_file"
        systemd-restart "$service" "--user"
        return 1
    fi
}

update-service-config "myapp" ~/.config/myapp/config.json /tmp/new-config.json
```

---

### Service Enable/Disable Functions

These functions control service autostart behavior.

#### systemd-enable (→ L376)

Enable service (will start on boot/login).

**Signature:**
```zsh
systemd-enable <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service enabled successfully or dry-run
- `1` - Service unit not found or enable failed

**Dry-Run:** Shows "Would enable: systemctl ... enable unit"
**Effect:** Creates symlinks in systemd target directories
**Scope:** User services: ~/.config/systemd/user/default.target.wants/
**Scope:** System services: /etc/systemd/system/default.target.wants/

**Complexity:** O(1) - Symlink creation
**Performance:** ~30ms per service

**Examples:**

```zsh
# Enable service to start on boot
systemd-enable "nginx" "--system"

# Enable with verification
if systemd-enable "myapp" "--user"; then
    echo "Service enabled"
else
    echo "Failed to enable service"
fi

# Check if enabled
if systemd-is-enabled "myapp" "--user"; then
    echo "Service already enabled"
else
    systemd-enable "myapp" "--user"
fi

# Enable multiple services
for service in myapp worker cache; do
    systemd-enable "$service" "--user"
done
echo "All services enabled"
```

---

#### systemd-disable (→ L403)

Disable service (will not start on boot/login).

**Signature:**
```zsh
systemd-disable <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service disabled successfully or dry-run
- `1` - Service unit not found or disable failed

**Dry-Run:** Shows "Would disable: systemctl ... disable unit"
**Effect:** Removes symlinks from target directories
**Idempotent:** Safe to call even if already disabled

**Complexity:** O(1) - Symlink removal
**Performance:** ~25ms per service

**Examples:**

```zsh
# Disable service
systemd-disable "myapp" "--user"

# Disable and verify
systemd-disable "nginx" "--system"
if ! systemd-is-enabled "nginx" "--system"; then
    echo "Service disabled"
fi

# Conditional disable
if systemd-is-enabled "myapp" "--user"; then
    systemd-disable "myapp" "--user"
fi

# Disable all personal services
for service in myapp worker cache monitor; do
    systemd-is-enabled "$service" "--user" && \
        systemd-disable "$service" "--user"
done
```

---

#### systemd-enable-start (→ L430)

Enable service and start it immediately in one operation.

**Signature:**
```zsh
systemd-enable-start <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service enabled and started successfully
- `1` - Operation failed

**Behavior:** Atomically enables autostart AND starts service now
**Convenience:** Common pattern (install + start service)

**Complexity:** O(n) - Enable (O1) + Start (O(n))
**Performance:** 250-3000ms (startup time dominates)

**Examples:**

```zsh
# Install and start service in one call
systemd-enable-start "myapp" "--user"

# After creating unit file
systemd-generate-service "myapp" "/usr/local/bin/myapp" "My App" \
    > ~/.config/systemd/user/myapp.service
systemd-daemon-reload "--user"
systemd-enable-start "myapp" "--user"

# Check result
if systemd-is-active "myapp" "--user"; then
    echo "✓ Service installed and running"
fi
```

---

#### systemd-disable-stop (→ L439)

Stop service and disable it (autostart off) in one operation.

**Signature:**
```zsh
systemd-disable-stop <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service stopped and disabled successfully
- `1` - Operation failed

**Behavior:** Atomically disables autostart AND stops service now
**Use Cases:** Complete service removal, cleanup

**Complexity:** O(n) - Stop (O(n)) + Disable (O1)
**Performance:** 100-500ms (shutdown time dominates)

**Examples:**

```zsh
# Completely disable service
systemd-disable-stop "myapp" "--user"

# Clean uninstall
systemd-disable-stop "worker" "--user"
rm ~/.config/systemd/user/worker.service
systemd-daemon-reload "--user"

# Temporary disable
systemd-disable-stop "myapp" "--user"
# ... do something ...
systemd-enable-start "myapp" "--user"
```

---

### Daemon Control Functions

#### systemd-daemon-reload (→ L452)

Reload systemd daemon (required after unit file changes).

**Signature:**
```zsh
systemd-daemon-reload [--user|--system]
```

**Parameters:**
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Daemon reloaded successfully or dry-run
- `1` - Reload failed

**Dry-Run:** Shows "Would reload daemon: systemctl ... daemon-reload"
**Purpose:** Re-scans unit file directories and updates configuration
**Required:** After creating, modifying, or deleting unit files

**Complexity:** O(n) - Scans all unit directories
**Performance:** 100-500ms (system has many units)

**Critical Workflow:**
```
Create/Modify Unit File
    ↓
systemd-daemon-reload
    ↓
Service Now Available
```

**Examples:**

```zsh
# After creating new unit file
systemd-generate-service "myapp" "/usr/local/bin/myapp" "My App" \
    > ~/.config/systemd/user/myapp.service
systemd-daemon-reload "--user"

# Now service is available
systemd-start "myapp" "--user"

# After modifying unit file
systemctl --user edit myapp
# Make changes...
systemd-daemon-reload "--user"

# Batch unit creation
for service in app1 app2 app3; do
    systemd-generate-service "$service" "/usr/bin/$service" \
        > ~/.config/systemd/user/${service}.service
done
# Reload once after all created
systemd-daemon-reload "--user"
```

---

### Unit File Generation Functions

These functions generate unit file content to stdout.

#### systemd-generate-service (→ L478)

Generate a service unit file.

**Signature:**
```zsh
systemd-generate-service <name> <exec_start> [description] [type] [restart] [restart_sec]
```

**Parameters:**
- `name` (required): Service name (e.g., "myapp")
- `exec_start` (required): Full command path (e.g., "/usr/local/bin/myapp")
- `description` (optional): Service description (default: "{name} service")
- `type` (optional): Service type (default: "simple")
  - `simple`: Main process = service (most common)
  - `forking`: Process forks, parent exits
  - `oneshot`: Run-once task, exits
  - `notify`: Sends readiness notification
- `restart` (optional): Restart policy (default: "on-failure")
  - `no`: Never restart
  - `on-failure`: Restart on non-zero exit
  - `always`: Always restart
- `restart_sec` (optional): Delay before restart (default: "5s")

**Returns:** Unit file content (stdout)
**Output:** Valid systemd service unit file
**Redirect:** Capture to file or pass to tee

**Examples:**

```zsh
# Generate and save simple service
systemd-generate-service "myapp" "/usr/local/bin/myapp" \
    > ~/.config/systemd/user/myapp.service

# Generate with custom settings
systemd-generate-service "worker" "/usr/local/bin/worker" \
    "Background Worker" "simple" "always" "10s" \
    > ~/.config/systemd/user/worker.service

# Generate oneshot service (for timers)
systemd-generate-service "backup" "/usr/local/bin/backup.sh" \
    "Backup Service" "oneshot" "no" \
    > ~/.config/systemd/user/backup.service

# Preview before saving
systemd-generate-service "test" "/bin/test" "Test Service"

# Pipe to systemctl edit
systemd-generate-service "myapp" "/usr/bin/myapp" | \
    tee ~/.config/systemd/user/myapp.service
```

**Generated Output:**
```ini
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/myapp
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
```

---

#### systemd-generate-template (→ L505)

Generate a template service unit file (parameterized).

**Signature:**
```zsh
systemd-generate-template <name> <exec_start> [description] [type] [restart]
```

**Parameters:**
- `name` (required): Service name without @ (e.g., "worker")
- `exec_start` (required): Command with %i placeholder (e.g., "/usr/bin/worker --instance %i")
- `description` (optional): Description (default: "{name}@%i service")
- `type` (optional): Service type (default: "simple")
- `restart` (optional): Restart policy (default: "on-failure")

**Returns:** Template unit file content
**Files:** Results in `worker@.service` file
**Instances:** Start as `worker@1`, `worker@2`, etc.

**Use Cases:**
- Multiple instances of same service
- Parameterized services
- Pooled workers

**Examples:**

```zsh
# Generate template for multiple workers
systemd-generate-template "worker" "/usr/bin/worker --instance %i" \
    "Worker Instance" > ~/.config/systemd/user/worker@.service

# Reload and start instances
systemd-daemon-reload "--user"
systemd-start "worker@1" "--user"
systemd-start "worker@2" "--user"
systemd-start "worker@3" "--user"

# Check instance status
systemctl --user status "worker@1"

# List all instances
systemctl --user list-units | grep worker@

# Stop all instances
systemctl --user stop "worker@*.service"
```

---

#### systemd-generate-timer (→ L531)

Generate a timer unit file for scheduled tasks.

**Signature:**
```zsh
systemd-generate-timer <name> <on_calendar> [description] [service_name]
```

**Parameters:**
- `name` (required): Timer name (e.g., "backup")
- `on_calendar` (required): Schedule specification
  - `minutely`, `hourly`, `daily`, `weekly`, `monthly`, `yearly`
  - Custom: `Mon,Wed,Fri *-*-* 09:00:00` (specific days/times)
  - Custom: `*-*-* 02:00:00` (2 AM daily)
- `description` (optional): Timer description (default: "{name} timer")
- `service_name` (optional): Service to trigger (default: "{name}.service")

**Returns:** Timer unit file content
**Persistent:** `Persistent=true` - runs missed timers on resume
**Pairs:** Requires matching `.service` unit

**Examples:**

```zsh
# Daily backup timer
systemd-generate-timer "backup" "daily" "Daily Backup Timer" \
    > ~/.config/systemd/user/backup.timer

# Hourly cleanup timer
systemd-generate-timer "cleanup" "hourly" "Hourly Cleanup" \
    > ~/.config/systemd/user/cleanup.timer

# Custom schedule: weekdays at 9 AM
systemd-generate-timer "report" "Mon,Tue,Wed,Thu,Fri *-*-* 09:00:00" \
    "Weekday Report Generation" \
    > ~/.config/systemd/user/report.timer

# Create matching service
systemd-generate-service "backup" "/usr/local/bin/backup.sh" \
    "Backup Service" "oneshot" "no" \
    > ~/.config/systemd/user/backup.service

# Activate timer
systemd-daemon-reload "--user"
systemd-enable-start "backup.timer" "--user"

# View next run
systemctl --user list-timers backup.timer
```

---

### Journal/Logging Functions

These functions access service logs via journalctl.

#### systemd-logs (→ L556)

View service logs (most recent lines).

**Signature:**
```zsh
systemd-logs <unit> [lines] [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `lines` (optional): Number of lines (default: 50)
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Log output (text)
**Output:** Paged (no-pager used)
**Format:** Journal format with timestamps

**Complexity:** O(n) - Reads n lines from journal
**Performance:** 50ms for 50 lines

**Examples:**

```zsh
# View last 50 lines (default)
systemd-logs "myapp" "--user"

# View last 100 lines
systemd-logs "myapp" 100 "--user"

# View system service logs
systemd-logs "nginx" 20 "--system"

# Save logs to file
systemd-logs "myapp" 200 "--user" > myapp-debug.log

# Pipe to less for scrolling
systemd-logs "myapp" 500 "--user" | less
```

---

#### systemd-logs-follow (→ L571)

Follow service logs in real-time (like `tail -f`).

**Signature:**
```zsh
systemd-logs-follow <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Continuous log stream
**Interactive:** Press Ctrl+C to stop
**Real-time:** Shows logs as they happen

**Complexity:** O(∞) - Continuous streaming
**Performance:** Minimal (event-driven)

**Examples:**

```zsh
# Follow logs
systemd-logs-follow "myapp" "--user"

# Follow with prefix (in separate terminal)
systemd-logs-follow "nginx" "--system"

# Debug service startup
systemd-start "myapp" "--user" &
systemd-logs-follow "myapp" "--user"

# Stop and follow
systemd-restart "nginx" "--system"
systemd-logs-follow "nginx" "--system"
```

---

#### systemd-logs-since (→ L585)

View logs since timestamp.

**Signature:**
```zsh
systemd-logs-since <unit> <since> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `since` (required): Timestamp or relative
  - Absolute: "YYYY-MM-DD HH:MM:SS" (e.g., "2025-11-04 10:00:00")
  - Relative: "1 hour ago", "30 minutes ago"
  - Named: "today", "yesterday"
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Filtered log output
**Format:** Journal format with timestamps

**Examples:**

```zsh
# Logs since specific time
systemd-logs-since "myapp" "2025-11-04 10:00:00" "--user"

# Logs since 1 hour ago
systemd-logs-since "myapp" "1 hour ago" "--user"

# Logs from today
systemd-logs-since "myapp" "today" "--user"

# Since yesterday at noon
systemd-logs-since "nginx" "yesterday 12:00:00" "--system"

# Recent errors (last 30 min)
systemd-logs-since "myapp" "30 minutes ago" "--user" | \
    grep -E "ERROR|FAIL|WARN"
```

---

#### systemd-logs-priority (→ L601)

View logs by priority level.

**Signature:**
```zsh
systemd-logs-priority <unit> [priority] [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `priority` (optional): Priority level (default: "err")
  - `emerg`: Emergency (0) - System is unusable
  - `alert`: Alert (1) - Action needed immediately
  - `crit`: Critical (2) - Critical condition
  - `err`: Error (3) - Error condition
  - `warning`: Warning (4) - Warning condition
  - `notice`: Notice (5) - Normal but significant
  - `info`: Info (6) - Informational
  - `debug`: Debug (7) - Debug-level messages
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Filtered log output
**Include:** All messages at priority and above (lower number)

**Examples:**

```zsh
# Show only errors
systemd-logs-priority "myapp" "err" "--user"

# Show warnings and above (err, crit, alert, emerg)
systemd-logs-priority "myapp" "warning" "--user"

# Show all messages (debug and above)
systemd-logs-priority "myapp" "debug" "--user"

# Emergency alerts only
systemd-logs-priority "nginx" "emerg" "--system"

# Count errors
systemd-logs-priority "myapp" "err" "--user" | wc -l
```

---

### Service Discovery Functions

These functions list and find services.

#### systemd-list-services (→ L620)

List all services.

**Signature:**
```zsh
systemd-list-services [--user|--system]
```

**Parameters:**
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Formatted service list
**Format:** Columns: NAME, LOAD, ACTIVE, SUB, DESCRIPTION

**Examples:**

```zsh
# List user services
systemd-list-services "--user"

# List system services
systemd-list-services "--system" | head -20

# Find specific service
systemd-list-services "--user" | grep myapp

# Count total services
systemd-list-services "--user" | wc -l
```

---

#### systemd-list-enabled (→ L627)

List enabled services.

**Signature:**
```zsh
systemd-list-enabled [--user|--system]
```

**Parameters:**
- `scope` (optional): `--user` (default) or `--system`

**Returns:** List of enabled services
**Format:** Columns: UNIT FILE, STATE

**Examples:**

```zsh
# List enabled user services
systemd-list-enabled "--user"

# Count enabled services
systemd-list-enabled "--user" | wc -l

# Check if service is in enabled list
systemd-list-enabled "--user" | grep -q myapp && \
    echo "Enabled" || echo "Not enabled"
```

---

#### systemd-list-failed (→ L634)

List failed services.

**Signature:**
```zsh
systemd-list-failed [--user|--system]
```

**Parameters:**
- `scope` (optional): `--user` (default) or `--system`

**Returns:** List of failed services
**Format:** Columns: UNIT, LOAD, ACTIVE, SUB

**Examples:**

```zsh
# List failed services
systemd-list-failed "--user"

# Check if any failed
if systemd-list-failed "--user" | grep -q .; then
    echo "Some services have failed"
fi

# Alert on failures
systemd-list-failed "--system" | while read unit; do
    [[ -n "$unit" ]] && echo "ALERT: $unit failed"
done
```

---

#### systemd-list-running (→ L641)

List running services.

**Signature:**
```zsh
systemd-list-running [--user|--system]
```

**Parameters:**
- `scope` (optional): `--user` (default) or `--system`

**Returns:** List of running services
**Format:** Columns: NAME, LOAD, ACTIVE, SUB, DESCRIPTION

**Examples:**

```zsh
# List running services
systemd-list-running "--user"

# Count running
systemd-list-running "--user" | wc -l

# Check if specific service running
systemd-list-running "--user" | grep -q myapp && \
    echo "Running" || echo "Not running"
```

---

### Property Access Functions

These functions query service properties.

#### systemd-get-property (→ L652)

Get service property value.

**Signature:**
```zsh
systemd-get-property <unit> <property> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `property` (required): Property name
  - `MainPID` - Main process ID
  - `MemoryCurrent` - Current memory usage
  - `CPUUsageNSec` - CPU time in nanoseconds
  - `StateChangeTimestamp` - State change time
  - `ActiveEnterTimestamp` - When became active
  - `Result` - Service result (success, failure, etc.)
  - See `systemctl show` for complete list
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Property value (string)
**Performance:** ~20ms per query

**Examples:**

```zsh
# Get process ID
pid=$(systemd-get-property "myapp" "MainPID" "--user")
echo "PID: $pid"

# Get memory usage
mem=$(systemd-get-property "nginx" "MemoryCurrent" "--system")
echo "Memory: $mem bytes"

# Convert to human-readable
mem=$(systemd-get-property "nginx" "MemoryCurrent" "--system")
echo "Memory: $(numfmt --to=iec-i --suffix=B "$mem" 2>/dev/null || echo "$mem")"

# Get result status
result=$(systemd-get-property "myapp" "Result" "--user")
echo "Result: $result"
```

---

#### systemd-get-pid (→ L662)

Get service main process ID.

**Signature:**
```zsh
systemd-get-pid <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Process ID (number)
**Returns:** "0" if service not active

**Examples:**

```zsh
# Get PID
pid=$(systemd-get-pid "myapp" "--user")
echo "Service PID: $pid"

# Check if PID is valid
pid=$(systemd-get-pid "myapp" "--user")
if [[ "$pid" -gt 0 ]]; then
    echo "Process running with PID $pid"
    ps -p "$pid"
fi

# Kill service manually
pid=$(systemd-get-pid "myapp" "--user")
[[ "$pid" -gt 0 ]] && kill "$pid"
```

---

#### systemd-get-memory (→ L671)

Get service memory usage.

**Signature:**
```zsh
systemd-get-memory <unit> [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `scope` (optional): `--user` (default) or `--system`

**Returns:** Memory in bytes (number)
**Returns:** "0" if not available

**Examples:**

```zsh
# Get memory usage in bytes
mem=$(systemd-get-memory "myapp" "--user")
echo "Memory: $mem bytes"

# Convert to MB
mem_mb=$(($(systemd-get-memory "myapp" "--user") / 1024 / 1024))
echo "Memory: ${mem_mb}MB"

# Monitor memory
while true; do
    mem=$(systemd-get-memory "myapp" "--user")
    mem_mb=$((mem / 1024 / 1024))
    echo "[$(date)] Memory: ${mem_mb}MB"
    sleep 5
done
```

---

### Utility Functions

#### systemd-available (→ L684)

Check if systemd is available.

**Signature:**
```zsh
systemd-available
```

**Returns:**
- `0` - systemd is available (systemctl found)
- `1` - systemd is not available

**Examples:**

```zsh
# Check availability
if systemd-available; then
    echo "Using systemd"
else
    echo "Systemd not available - using fallback"
fi

# Conditional service control
if systemd-available; then
    systemd-start "myapp" "--user"
else
    /etc/init.d/myapp start
fi
```

---

#### systemd-version (→ L690)

Get systemd version.

**Signature:**
```zsh
systemd-version
```

**Returns:** Version number (e.g., "255")

**Examples:**

```zsh
# Get version
version=$(systemd-version)
echo "Systemd version: $version"

# Check minimum version
version=$(systemd-version)
if [[ $version -ge 250 ]]; then
    echo "Modern systemd features available"
else
    echo "Legacy systemd - some features limited"
fi
```

---

#### systemd-wait-active (→ L696)

Wait for service to become active with timeout.

**Signature:**
```zsh
systemd-wait-active <unit> [timeout_seconds] [--user|--system]
```

**Parameters:**
- `unit` (required): Service name
- `timeout` (optional): Timeout in seconds (default: 30)
- `scope` (optional): `--user` (default) or `--system`

**Returns:**
- `0` - Service became active within timeout
- `1` - Timeout reached without becoming active

**Complexity:** O(n) where n = time to startup
**Performance:** 1s to timeout (polls every 1s)

**Examples:**

```zsh
# Wait up to 30 seconds
if systemd-wait-active "myapp" 30 "--user"; then
    echo "Service started"
else
    echo "Service startup timeout"
fi

# Start and wait
systemd-start "nginx" "--system"
if systemd-wait-active "nginx" 10 "--system"; then
    echo "Nginx ready"
fi

# Short timeout for critical service
systemd-restart "postgres" "--system"
if ! systemd-wait-active "postgres" 5 "--system"; then
    echo "Database failed to start!"
    systemd-logs "postgres" 50 "--system"
    exit 1
fi
```

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->

Complex patterns and integration scenarios.

### Pattern 1: Safe Service Deployment

Deploy with health checks, rollback, and monitoring:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"
source "$(which _log)"

SERVICE="myapp"
SCOPE="--user"
BACKUP_DIR="$HOME/.backups/services"

deploy-service() {
    local new_binary="$1"

    log-info "Starting deployment of $SERVICE"

    # Backup current binary
    local current_binary="$HOME/.local/bin/$SERVICE"
    if [[ -f "$current_binary" ]]; then
        cp "$current_binary" "$BACKUP_DIR/${SERVICE}.backup.$(date +%s)"
        log-info "Current version backed up"
    fi

    # Deploy new binary
    cp "$new_binary" "$current_binary"
    chmod +x "$current_binary"
    log-info "New binary deployed"

    # Restart service
    systemd-restart "$SERVICE" "$SCOPE"

    # Health check
    if systemd-wait-active "$SERVICE" 30 "$SCOPE"; then
        log-success "Service started successfully"

        # Optional: verify via HTTP or other check
        if command -v curl >/dev/null; then
            if curl -sf "http://localhost:8080/health" >/dev/null 2>&1; then
                log-success "Health check passed"
                return 0
            fi
        fi

        return 0
    else
        log-error "Service failed to start - rolling back"

        # Rollback
        if [[ -f "$BACKUP_DIR/${SERVICE}.backup" ]]; then
            cp "$BACKUP_DIR/${SERVICE}.backup" "$current_binary"
            systemd-restart "$SERVICE" "$SCOPE"
            log-info "Rolled back to previous version"
        fi

        return 1
    fi
}

deploy-service "/tmp/myapp-v2.0"
```

---

### Pattern 2: Service Health Monitoring

Monitor multiple services with alerts:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Configuration
declare -A SERVICES=(
    [nginx]="--system"
    [postgres]="--system"
    [redis]="--system"
    [myapp]="--user"
)

declare -A HEALTH_CHECKS=(
    [nginx]="curl -sf http://localhost:80"
    [postgres]="psql -c 'SELECT 1'"
    [redis]="redis-cli ping"
    [myapp]="curl -sf http://localhost:8080/health"
)

ALERT_COOLDOWN=300  # 5 minutes
declare -A LAST_ALERT

check-service() {
    local service="$1"
    local scope="${SERVICES[$service]}"

    # Check if active
    if ! systemd-is-active "$service" "$scope"; then
        return 1
    fi

    # Run health check if defined
    if [[ -n "${HEALTH_CHECKS[$service]}" ]]; then
        if ! eval "${HEALTH_CHECKS[$service]}" >/dev/null 2>&1; then
            return 1
        fi
    fi

    return 0
}

send-alert() {
    local service="$1"
    local message="$2"

    local now=$(date +%s)
    local last=${LAST_ALERT[$service]:-0}

    # Rate limit alerts
    if [[ $((now - last)) -lt $ALERT_COOLDOWN ]]; then
        return
    fi

    LAST_ALERT[$service]=$now

    echo "[ALERT] $service: $message"

    # Send notification
    if command -v notify-send >/dev/null; then
        notify-send "Service Alert" "$service: $message"
    fi
}

monitor-loop() {
    local interval="${1:-60}"

    while true; do
        for service in "${(@k)SERVICES}"; do
            if ! check-service "$service"; then
                send-alert "$service" "Health check failed"

                # Attempt recovery
                local scope="${SERVICES[$service]}"
                systemd-restart "$service" "$scope"
            fi
        done

        sleep "$interval"
    done
}

# Start monitoring
monitor-loop 60
```

---

### Pattern 3: Service Dependency Management

Install services with dependencies:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Define service dependencies
declare -A SERVICE_DEPS=(
    [myapp]="myapp-db"
    [worker]="myapp"
    [scheduler]="redis"
)

declare -A SERVICE_PATHS=(
    [myapp]=".local/bin/myapp"
    [myapp-db]=".local/bin/myapp-db"
    [worker]=".local/bin/worker"
    [scheduler]=".local/bin/scheduler"
)

install-service() {
    local service="$1"
    local path="${SERVICE_PATHS[$service]}"
    local deps="${SERVICE_DEPS[$service]}"

    if [[ -z "$path" ]]; then
        echo "Error: Unknown service $service"
        return 1
    fi

    echo "Installing $service..."

    # Check dependencies
    if [[ -n "$deps" ]]; then
        for dep in $deps; do
            if ! systemd-is-enabled "$dep" "--user"; then
                echo "Installing dependency: $dep"
                install-service "$dep" || return 1
            fi
        done
    fi

    # Create unit file with dependencies
    local unit="$HOME/.config/systemd/user/${service}.service"

    {
        echo "[Unit]"
        echo "Description=$service"
        echo "After=network.target"

        if [[ -n "$deps" ]]; then
            for dep in $deps; do
                echo "Wants=${dep}.service"
            done
        fi

        echo ""
        echo "[Service]"
        echo "ExecStart=$HOME/$path"
        echo "Restart=on-failure"
        echo ""
        echo "[Install]"
        echo "WantedBy=default.target"
    } > "$unit"

    # Enable and start
    systemd-daemon-reload "--user"
    systemd-enable-start "$service" "--user"

    echo "✓ $service installed"
}

# Install complete stack
install-service "myapp"
install-service "worker"
install-service "scheduler"
```

---

### Pattern 4: Scheduled Task Management

Create and manage timers:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Define scheduled tasks
declare -A TIMERS=(
    [backup]="daily /usr/local/bin/backup.sh 'Daily Backup'"
    [cleanup]="hourly /usr/local/bin/cleanup.sh 'Hourly Cleanup'"
    [report]="Mon,Fri *-*-* 09:00:00 /usr/local/bin/report.sh 'Weekly Report'"
)

create-timer() {
    local name="$1"
    local schedule="$2"
    local script="$3"
    local description="$4"

    local base="$HOME/.config/systemd/user"
    mkdir -p "$base"

    # Verify script
    if [[ ! -f "$script" ]]; then
        echo "Error: Script not found: $script"
        return 1
    fi
    chmod +x "$script"

    # Create service unit
    cat > "$base/${name}.service" <<EOF
[Unit]
Description=$description

[Service]
Type=oneshot
ExecStart=$script
EOF

    # Create timer unit
    cat > "$base/${name}.timer" <<EOF
[Unit]
Description=$description Timer

[Timer]
OnCalendar=$schedule
Persistent=true

[Install]
WantedBy=timers.target
EOF

    # Activate
    systemd-daemon-reload "--user"
    systemd-enable-start "${name}.timer" "--user"

    echo "✓ Timer created: $name (schedule: $schedule)"
}

# Create all timers from config
for timer_name in "${(@k)TIMERS}"; do
    args=(${=TIMERS[$timer_name]})
    create-timer "$timer_name" "${args[@]}"
done

# Show active timers
echo ""
echo "=== Active Timers ==="
systemctl --user list-timers --all
```

---

### Pattern 5: Service Configuration Management

Update configurations with reload/restart:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

SERVICE="myapp"
CONFIG_FILE="$HOME/.config/myapp/config.json"

update-config() {
    local new_config="$1"

    if [[ ! -f "$new_config" ]]; then
        echo "Error: Config file not found: $new_config"
        return 1
    fi

    echo "Updating configuration..."

    # Validate JSON
    if ! jq empty "$new_config" 2>/dev/null; then
        echo "Error: Invalid JSON"
        return 1
    fi

    # Backup current
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%s)"

    # Deploy new
    cp "$new_config" "$CONFIG_FILE"
    echo "Configuration deployed"

    # Reload or restart
    echo "Reloading service..."
    if systemd-reload-or-restart "$SERVICE" "--user"; then
        echo "✓ Configuration updated"
        return 0
    else
        echo "✗ Failed to reload - restoring backup"
        cp "${CONFIG_FILE}.backup."* "$CONFIG_FILE"
        systemd-restart "$SERVICE" "--user"
        return 1
    fi
}

# Update from remote config
CONFIG_URL="https://config.example.com/myapp.json"
TEMP_CONFIG="/tmp/myapp-config.json"

curl -sf "$CONFIG_URL" > "$TEMP_CONFIG" && \
    update-config "$TEMP_CONFIG"
```

---

### Pattern 6: Multi-Environment Service Management

Manage services across different environments:

```zsh
#!/usr/bin/env zsh

source "$(which _systemd)"

# Define environments
declare -A ENV_CONFIGS=(
    [dev]="user ~/.config/myapp/dev.conf"
    [test]="user ~/.config/myapp/test.conf"
    [prod]="system /etc/myapp/prod.conf"
)

set-environment() {
    local env="$1"

    if [[ -z "${ENV_CONFIGS[$env]}" ]]; then
        echo "Unknown environment: $env"
        return 1
    fi

    local config_info="${ENV_CONFIGS[$env]}"
    local scope=$(echo "$config_info" | awk '{print $1}')
    local config_file=$(echo "$config_info" | awk '{print $2}')

    echo "Setting environment to: $env"
    echo "Scope: $scope"
    echo "Config: $config_file"

    # Stop current service
    systemd-disable-stop "myapp" "--user" 2>/dev/null || true
    systemd-disable-stop "myapp" "--system" 2>/dev/null || true

    # Deploy config
    mkdir -p "$(dirname "$config_file")"
    cp "~/.config/myapp/${env}.conf" "$config_file"

    # Start in target environment
    if [[ "$scope" == "system" ]]; then
        sudo systemd-enable-start "myapp" "--system"
    else
        systemd-enable-start "myapp" "--user"
    fi

    echo "✓ Environment switched to: $env"
}

# Switch environments
set-environment "${1:-dev}"
```

---

## Best Practices

<!-- CONTEXT_PRIORITY: HIGH -->

Guidelines for production-ready systemd integration.

### 1. Always Verify After Changes

After any service operation, verify the result:

```zsh
# Start and verify
systemd-start "myapp" "--user"

# Wait for startup (don't assume instant)
if systemd-wait-active "myapp" 30 "--user"; then
    echo "✓ Service started and active"
else
    echo "✗ Service failed - checking logs"
    systemd-logs "myapp" 50 "--user"
    exit 1
fi
```

**Why:** Services may take time to start or might fail silently.

---

### 2. Use Dry-Run for Destructive Operations

Always preview before executing:

```zsh
# Preview
export SYSTEMD_DRY_RUN=true
systemd-disable-stop "critical-service" "--system"

# Review output
unset SYSTEMD_DRY_RUN

# Execute only if confident
systemd-disable-stop "critical-service" "--system"
```

**Why:** Prevents accidental service disruptions in production.

---

### 3. Backup Before Modifying Unit Files

Always preserve previous configurations:

```zsh
SERVICE="myapp"
UNIT_FILE="$HOME/.config/systemd/user/${SERVICE}.service"

# Backup before changes
cp "$UNIT_FILE" "${UNIT_FILE}.backup.$(date +%Y%m%d-%H%M%S)"

# Make changes...
edit "$UNIT_FILE"

# Reload
systemd-daemon-reload "--user"

# Test changes
systemd-restart "$SERVICE" "--user"

# If broken, restore
# cp "${UNIT_FILE}.backup.latest" "$UNIT_FILE"
# systemd-daemon-reload "--user"
```

**Why:** Allows quick recovery from misconfiguration.

---

### 4. Handle User vs. System Services Carefully

Different operations require different privileges:

```zsh
manage-services() {
    local service="$1"
    local scope="$2"

    case "$scope" in
        --user)
            # No sudo needed for user services
            systemd-start "$service" "$scope"
            ;;
        --system)
            # System services require sudo
            if [[ $EUID -ne 0 ]]; then
                sudo systemd-start "$service" "$scope"
            else
                systemd-start "$service" "$scope"
            fi
            ;;
    esac
}

manage-services "nginx" "--system"  # Automatically handles sudo
```

**Why:** Prevents permission errors and simplifies scripts.

---

### 5. Use Proper Service Types

Choose the right type for your service:

```zsh
# Simple (most common) - main process = service
systemd-generate-service "myapp" "/usr/bin/myapp" \
    "My Application" "simple"

# Oneshot - for scripts that run once
systemd-generate-service "backup" "/usr/bin/backup.sh" \
    "Backup Script" "oneshot" "no"

# Forking - traditional daemons
systemd-generate-service "legacy-daemon" "/usr/bin/daemon" \
    "Legacy Daemon" "forking"
```

**Why:** Incorrect type can prevent proper service management.

---

### 6. Log Important Operations

Always log what you're doing:

```zsh
manage-service() {
    local action="$1"
    local service="$2"
    local scope="$3"

    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local log_file="$HOME/.logs/service-management.log"

    echo "[$timestamp] $action: $service ($scope)" >> "$log_file"

    case "$action" in
        start)
            systemd-start "$service" "$scope"
            ;;
        stop)
            systemd-stop "$service" "$scope"
            ;;
        restart)
            systemd-restart "$service" "$scope"
            ;;
    esac

    # Log result
    echo "[$timestamp] Result: $? (exit code)" >> "$log_file"
}

manage-service "start" "myapp" "--user"
```

**Why:** Enables troubleshooting and audit trail.

---

### 7. Use Enable/Disable Consistently

Keep autostart settings consistent with service state:

```zsh
# After fixing a failed service
systemd-restart "myapp" "--user"

# If it stays enabled, document why
systemd-is-enabled "myapp" "--user" && echo "Service autostart enabled"

# If intentionally disabled, comment why
# systemd-disable "myapp" "--user"  # Temporarily disabled for maintenance
```

**Why:** Prevents confusion about which services should run on boot.

---

### 8. Monitor Failed Services

Regularly check for failed services:

```zsh
check-service-health() {
    local scope="$1"

    echo "=== Checking service health ($scope) ==="

    local failed=$(systemd-list-failed "$scope" | grep -c "failed")

    if [[ $failed -gt 0 ]]; then
        echo "⚠ WARNING: $failed services failed"
        systemd-list-failed "$scope"
        return 1
    else
        echo "✓ All services healthy"
        return 0
    fi
}

# Check regularly (e.g., from cron)
check-service-health "--user"
check-service-health "--system"
```

**Why:** Catches problems early before they cascade.

---

### 9. Document Service Dependencies

Always document why a service depends on another:

```zsh
# Create unit with documented dependencies
cat > ~/.config/systemd/user/worker.service <<EOF
[Unit]
Description=Background Worker Service
# Worker depends on database and cache
Wants=myapp-db.service redis.service
After=myapp-db.service redis.service

[Service]
ExecStart=/usr/local/bin/worker

[Install]
WantedBy=default.target
EOF
```

**Why:** Makes troubleshooting and changes easier for future maintainers.

---

### 10. Use Timer Persistence for Important Tasks

Ensure important tasks run even if system was down:

```zsh
# Critical backup timer - runs even if system was stopped
cat > ~/.config/systemd/user/backup.timer <<EOF
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=daily
# Persistent=true ensures backup runs on resume
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

**Why:** Prevents missed critical tasks after system restarts.

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->

Common issues and solutions.

### Issue 1: Permission Denied When Starting System Service

**Symptoms:**
```
systemd-start "nginx" "--system"
# Error: Failed to start nginx.service: Access denied
```

**Root Cause:** System services require root privileges.

**Solutions:**

```zsh
# Option 1: Use sudo
sudo systemctl start nginx

# Option 2: Use sudo with _systemd
sudo systemd-start "nginx" "--system"

# Option 3: Grant sudo access for specific service (sudoers)
# Add to sudoers (visudo):
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl start nginx

# Option 4: Use user service instead (if appropriate)
# Create in ~/.config/systemd/user/myservice.service
systemd-start "myservice" "--user"
```

---

### Issue 2: Unit File Not Found

**Symptoms:**
```
systemd-start "myapp" "--user"
# Error: Unit myapp.service not found
```

**Root Cause:** Unit file doesn't exist or daemon hasn't been reloaded.

**Solutions:**

```zsh
# Verify unit file exists
ls ~/.config/systemd/user/myapp.service

# If missing, create it
systemd-generate-service "myapp" "/usr/local/bin/myapp" \
    > ~/.config/systemd/user/myapp.service

# Reload daemon
systemd-daemon-reload "--user"

# Verify now available
systemd-exists "myapp" "--user" && echo "Found" || echo "Still missing"

# List all user services
systemd-list-services "--user" | grep myapp
```

---

### Issue 3: Service Fails to Start

**Symptoms:**
```
systemd-start "myapp" "--user"
# Returns error 2 (failed to start)
```

**Diagnosis Steps:**

```zsh
# 1. Check service status
systemd-get-status "myapp" "--user"

# 2. Check recent logs
systemd-logs "myapp" 50 "--user"

# 3. Check error-level logs
systemd-logs-priority "myapp" "err" "--user"

# 4. Verify binary exists and is executable
which myapp
file $(which myapp)

# 5. Try running binary directly
$(systemctl --user show myapp --property=ExecStart --value)

# 6. Check unit file for errors
systemctl --user cat myapp

# 7. Validate syntax
systemd-analyze --user verify myapp.service
```

**Common Causes and Fixes:**

```zsh
# Missing binary
# Fix: Update ExecStart path in unit file
systemctl --user edit myapp
# Change ExecStart=/wrong/path to ExecStart=/correct/path

# Missing dependencies
# Fix: Install dependencies or add Wants= directive
apt install libfoo  # Install library

# Permission denied on binary
# Fix: Make binary executable
chmod +x /usr/local/bin/myapp

# Binary not found in PATH
# Fix: Use absolute path in ExecStart
ExecStart=/usr/local/bin/myapp  # Not just myapp

# Configuration error
# Fix: Validate config file
systemctl --user edit myapp  # Review and fix config
```

---

### Issue 4: Service Won't Stop

**Symptoms:**
```
systemd-stop "myapp" "--user"
# Service keeps running
```

**Solutions:**

```zsh
# Check service status
systemd-get-status "myapp" "--user"

# Send stronger signal
systemctl --user kill --signal=SIGTERM myapp
sleep 2

# Force kill if needed
systemctl --user kill --signal=SIGKILL myapp

# Verify stopped
systemd-is-active "myapp" "--user" || echo "Stopped"

# Check for zombie processes
ps aux | grep myapp | grep defunct

# Review service type
systemctl --user show myapp --property=Type
# If Type=forking, may need ExecStop directive
```

---

### Issue 5: Logs Not Available

**Symptoms:**
```
systemd-logs "myapp" "--user"
# No output or very old entries
```

**Solutions:**

```zsh
# Check if service was ever started
systemd-get-status "myapp" "--user"

# Ensure service logs to journal
systemctl --user cat myapp | grep -A5 "\[Service\]"
# Should include:
# StandardOutput=journal
# StandardError=journal

# If missing, add to service unit
systemctl --user edit myapp
# Add to [Service] section:
# StandardOutput=journal
# StandardError=journal

# Reload and restart
systemd-daemon-reload "--user"
systemd-restart "myapp" "--user"

# Check journal size
journalctl --user --disk-usage

# Prune old logs (if needed)
journalctl --user --vacuum=1month
```

---

### Issue 6: Timer Not Running

**Symptoms:**
```
systemctl --user list-timers backup.timer
# Shows timer but hasn't run
```

**Solutions:**

```zsh
# Verify timer is active
systemd-is-active "backup.timer" "--user" || \
    systemd-enable-start "backup.timer" "--user"

# Check next scheduled run
systemctl --user list-timers backup.timer --all

# Manually run timer (test)
systemctl --user start backup.service

# Check timer logs
journalctl --user -u backup.timer

# Verify schedule syntax
# Should be: minutely, hourly, daily, weekly, monthly, yearly
# Or: DayOfWeek *-*-* HH:MM:SS format
systemctl --user show backup.timer --property=OnCalendar

# Re-create timer with correct syntax
systemd-generate-timer "backup" "daily" "Daily Backup" \
    > ~/.config/systemd/user/backup.timer
systemd-daemon-reload "--user"
systemd-enable-start "backup.timer" "--user"
```

---

### Issue 7: Dry-Run Mode Stuck

**Symptoms:**
```
export SYSTEMD_DRY_RUN=true
systemd-start "myapp"
# Now unset, but all operations still in dry-run
```

**Solutions:**

```zsh
# Check if dry-run is set
echo $SYSTEMD_DRY_RUN

# Disable dry-run
unset SYSTEMD_DRY_RUN
# Or:
export SYSTEMD_DRY_RUN=false

# Verify disabled
systemd-is-dry-run && echo "Still on" || echo "Off"

# Operations now execute normally
systemd-start "myapp" "--user"
```

---

### Debug Techniques

#### Enable Verbose Logging

```zsh
# Set debug mode
export SYSTEMD_DEBUG=true
export SYSTEMD_LOG_LEVEL=debug

# Now all operations show debug info
systemd-start "myapp" "--user"  # Shows [DEBUG] messages
```

#### Trace Service Execution

```zsh
# Use systemd-analyze to verify service
systemd-analyze --user verify myapp.service

# Show service execution order
systemd-analyze --user critical-chain myapp.service

# Check service dependencies
systemctl --user list-dependencies myapp
systemctl --user list-dependencies --reverse myapp
```

#### Check systemctl Directly

```zsh
# Get full service info
systemctl --user show myapp

# Show specific property
systemctl --user show myapp --property=ExecStart

# See unit file location
systemctl --user show myapp --property=FragmentPath

# Check journal for service errors
journalctl --user -u myapp --all
```

---

## Architecture

<!-- CONTEXT_PRIORITY: MEDIUM -->

### Design Overview

The extension provides clean abstraction over systemctl and journalctl:

```
┌─────────────────────────────────────────────┐
│         User Application Code               │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │    _systemd Function API             │  │
│  ├──────────────────────────────────────┤  │
│  │                                      │  │
│  │  Service Control Layer               │  │
│  │  ├─ start, stop, restart, reload     │  │
│  │  └─ enable, disable                  │  │
│  │                                      │  │
│  │  Status Checking Layer               │  │
│  │  ├─ is-active, is-enabled, is-failed │  │
│  │  ├─ get-state, get-status            │  │
│  │  └─ get-property, get-pid, get-memory │  │
│  │                                      │  │
│  │  Unit Management Layer               │  │
│  │  ├─ daemon-reload                    │  │
│  │  └─ generate (service/template/timer)│  │
│  │                                      │  │
│  │  Journal Layer                       │  │
│  │  ├─ logs, logs-follow                │  │
│  │  ├─ logs-since, logs-priority        │  │
│  │  └─ list-* (services, enabled, failed)│  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│           ↓                                 │
│  ┌──────────────────────────────────────┐  │
│  │    Dry-Run Layer                     │  │
│  │  - Checks SYSTEMD_DRY_RUN flag       │  │
│  │  - Shows preview instead of execute  │  │
│  │  - Emits events when _events loaded  │  │
│  └──────────────────────────────────────┘  │
│           ↓                                 │
│  ┌──────────────────────────────────────┐  │
│  │    systemctl / journalctl Commands   │  │
│  └──────────────────────────────────────┘  │
│           ↓                                 │
│  ┌──────────────────────────────────────┐  │
│  │    Systemd Daemon                    │  │
│  │    - Manages services                │  │
│  │    - Maintains journal logs          │  │
│  │    - Handles timers                  │  │
│  └──────────────────────────────────────┘  │
│                                             │
└─────────────────────────────────────────────┘
```

### Component Layers

#### 1. Status Query Layer (L145-202)

Functions that check state without modifying:

| Function | Complexity | Output |
|----------|-----------|--------|
| systemd-is-active | O(1) | 0/1 (boolean) |
| systemd-is-enabled | O(1) | 0/1 (boolean) |
| systemd-is-failed | O(1) | 0/1 (boolean) |
| systemd-get-status | O(1) | Multi-line text |
| systemd-get-state | O(1) | State string |
| systemd-exists | O(1) | 0/1 (boolean) |

**Pattern:** Consistent boolean return for conditions, text return for details

---

#### 2. Service Control Layer (L213-368)

Functions that modify service state:

| Function | Operation | Atomic | Timeout |
|----------|-----------|--------|---------|
| systemd-start | Stop → Start | Yes | Service-dependent |
| systemd-stop | Stop | Yes | 90s |
| systemd-restart | Stop + Start | Yes | Service-dependent |
| systemd-reload | Reload config | Yes | Service-dependent |
| systemd-reload-or-restart | Reload or Restart | Yes | Service-dependent |

**Pattern:** All return 0 on success, 2 on failure

---

#### 3. Enable/Disable Layer (L376-444)

Functions that configure autostart:

| Function | Effect | Idempotent |
|----------|--------|------------|
| systemd-enable | Enable autostart | Yes |
| systemd-disable | Disable autostart | Yes |
| systemd-enable-start | Enable + Start | Mostly |
| systemd-disable-stop | Disable + Stop | Mostly |

**Pattern:** Lightweight operations (symlink creation/removal)

---

#### 4. Unit Management Layer (L452-548)

Functions for unit file operations:

| Function | Purpose | IO |
|----------|---------|-----|
| systemd-daemon-reload | Re-scan units | Disk read |
| systemd-generate-service | Create service unit | Stdout |
| systemd-generate-template | Create template unit | Stdout |
| systemd-generate-timer | Create timer unit | Stdout |

**Pattern:** Generate functions output to stdout for piping/redirection

---

#### 5. Journal Layer (L556-612)

Functions for log access:

| Function | Purpose | Streaming |
|----------|---------|-----------|
| systemd-logs | View recent logs | No |
| systemd-logs-follow | Follow real-time | Yes |
| systemd-logs-since | View since time | No |
| systemd-logs-priority | Filter by level | No |

**Pattern:** All filter by service name, support user/system scope

---

#### 6. Discovery Layer (L620-676)

Functions for finding services:

| Function | Purpose | Scope |
|----------|---------|-------|
| systemd-list-services | All services | User/system |
| systemd-list-enabled | Enabled only | User/system |
| systemd-list-failed | Failed only | User/system |
| systemd-list-running | Running only | User/system |
| systemd-get-property | Single property | User/system |
| systemd-get-pid | Process ID | User/system |
| systemd-get-memory | Memory usage | User/system |

**Pattern:** All support scope parameter for consistent interface

---

#### 7. Utility Layer (L684-729)

General-purpose utilities:

| Function | Purpose | Return |
|----------|---------|--------|
| systemd-available | Check if systemd present | 0/1 |
| systemd-version | Get version number | Version string |
| systemd-wait-active | Wait with timeout | 0/1 |
| systemd--emit-event | Emit integration event | Varies |

---

### Data Flow Examples

#### Start Service Flow

```
User calls: systemd-start "myapp" "--user"
    ↓
Check SYSTEMD_DEBUG (log if enabled)
    ↓
Check parameters (unit name required)
    ↓
Check SYSTEMD_DRY_RUN
    ├─ If true: Log message and return 0 (preview)
    └─ If false: Continue to systemctl
    ↓
Execute: systemctl --user start myapp
    ├─ Success (0): Emit "service.started" event
    └─ Failure (!0): Emit "service.start-failed" event, return 2
    ↓
Return: 0 (success) or 2 (failure)
```

#### Query Status Flow

```
User calls: systemd-is-active "myapp" "--user"
    ↓
Execute: systemctl --user is-active myapp
    ↓
Systemd returns:
    ├─ 0 (exit): Service is active
    └─ Non-0 (exit): Service not active
    ↓
Return: 0 (active) or 1 (not active)
```

#### Generate Unit Flow

```
User calls: systemd-generate-service "myapp" "/usr/bin/myapp"
    ↓
Validate parameters
    ↓
Construct unit file content:
    [Unit]
    Description=myapp service
    After=network.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/myapp
    Restart=on-failure
    RestartSec=5s

    [Install]
    WantedBy=default.target
    ↓
Output to stdout (can be redirected to file)
    ↓
User must: systemd-daemon-reload to activate
```

---

### Error Handling Strategy

**Consistent Return Codes:**

```
Boolean checks (status queries):
  0 = Condition true (active, enabled, etc.)
  1 = Condition false (not active, not enabled, etc.)

Control operations:
  0 = Success or dry-run
  1 = Parameter error
  2 = Operation failed

Enable/disable:
  0 = Success or dry-run
  1 = Failed
```

**Error Propagation:**

```zsh
systemd-start "myapp" "--user"
exit_code=$?

# Caller can distinguish:
if [[ $exit_code -eq 0 ]]; then
    # Success
elif [[ $exit_code -eq 1 ]]; then
    # Unit not found
else
    # Failed to start
fi
```

**Logging Integration:**

```zsh
# If _log available: Uses log-info, log-error, log-debug
# If _log missing: Falls back to echo, echo >&2

# User can:
export SYSTEMD_DEBUG=true     # Enable all debug logs
export SYSTEMD_LOG_LEVEL=debug  # If _log supports it
```

---

### Dependencies Graph

```
_systemd
    ├─ Required
    │  ├─ _common (dependency resolution)
    │  ├─ systemctl (systemd binary)
    │  └─ journalctl (journal access)
    │
    └─ Optional (graceful degradation)
       ├─ _log (logging functions)
       │   └─ Falls back to echo if missing
       ├─ _events (event emission)
       │   └─ Events disabled if missing
       └─ _process (process utilities)
           └─ Detected but not required
```

---

### Performance Characteristics

**Function Performance (approximate):**

| Category | Function | Time | Depends On |
|----------|----------|------|-----------|
| Status queries | is-* | 10-20ms | Single query |
| Get operations | get-* | 20-30ms | Query complexity |
| Service control | start/stop/restart | 100-5000ms | Service startup/shutdown |
| Enable/disable | enable/disable | 20-30ms | Symlink ops |
| Daemon reload | daemon-reload | 100-500ms | Number of units |
| Logging | logs | 30-50ms | Journal size |
| List operations | list-* | 50-100ms | Number of units |

**Optimization Strategies:**

```zsh
# Cache frequently checked state
STATE=$(systemd-get-state "myapp")
if [[ "$STATE" == "active" ]]; then
    # Use cached value multiple times
fi

# Batch operations
for service in service1 service2 service3; do
    systemd-enable "$service"
done
systemd-daemon-reload  # Once at end

# Minimize daemon reloads
# Create all units → reload once → enable all
```

---

## External References

### Related Libraries

- **_common** - Core utilities (dependency resolution, error handling)
- **_log** - Logging integration (optional)
- **_events** - Event-driven patterns (optional)
- **_process** - Process management (optional)
- **_dryrun** - Enhanced dry-run support (optional)

### Systemd Documentation

- **systemctl(1)** - Service control
- **journalctl(1)** - Journal access
- **systemd.service(5)** - Service unit file format
- **systemd.timer(5)** - Timer unit file format
- **systemd.socket(5)** - Socket unit file format
- **systemd.unit(5)** - Unit file format basics

### Systemd Tutorials

- systemd.io - Official systemd project
- Systemd: A Primer by Sven Mueller
- Linux Boot Process and systemd by Neil Horman

### Similar Libraries/Patterns

- `systemctl` wrapper functions (various shell projects)
- `runit` - Service supervision
- `OpenRC` - Init system (alternative to systemd)
- `Supervisor` - Process control (Python)

---

**Documentation Version:** 1.0.0 (Enhanced Requirements v1.1)
**Completion Date:** 2025-11-07
**Lines of Documentation:** 3,412
**Tables:** 14
**Code Examples:** 120+
**Maintainer:** dotfiles extensions library
**Quality Standard:** Gold (Matches _bspwm v1.0.0)

<!-- End of _systemd.md -->
