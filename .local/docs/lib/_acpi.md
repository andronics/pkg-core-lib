# _acpi - ACPI Event and Power Management System

**Lines:** 1,773 | **Functions:** 35 | **Examples:** 40+ | **Source Lines:** 1,450
**Version:** 2.1.0 | **Layer:** Integration (Layer 3) | **Source:** `~/.local/bin/lib/_acpi`

---

## Quick Access Index

### Compact References (Lines 10-550)
- [Function Reference](#function-quick-reference) - 35 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 11 variables
- [ACPI Events](#acpi-events-quick-reference) - 13 event types
- [Power States](#power-states-quick-reference) - 4 states
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 550-750, ~200 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 750-900, ~150 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 900-1,200, ~300 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 1,200-1,400, ~200 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 1,400-2,800, ~1,400 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2,800-3,300, ~500 lines) 💡 ADVANCED
- [Best Practices](#best-practices) (Lines 3,300-3,600, ~300 lines) 🔧 PATTERNS
- [Troubleshooting](#troubleshooting) (Lines 3,600-3,900, ~300 lines) 🔧 DEBUGGING

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: initialization -->

**Initialization & Availability Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-init` | Initialize ACPI extension | 437-463 | [→](#acpi-init) |
| `acpi-check-available` | Check if ACPI system is available | 479-495 | [→](#acpi-check-available) |
| `acpi-require-available` | Exit script if ACPI unavailable | 504-506 | [→](#acpi-require-available) |
| `acpi-get-socket` | Get ACPI socket path | 516-518 | [→](#acpi-get-socket) |
| `acpi-get-sysfs-path` | Get sysfs path for ACPI devices | 528-530 | [→](#acpi-get-sysfs-path) |

<!-- CONTEXT_GROUP: event_listening -->

**Event Listening Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-listen-start` | Start ACPI event listener | 548-590 | [→](#acpi-listen-start) |
| `acpi-listen` | Connect to ACPI socket (blocking) | 602-624 | [→](#acpi-listen) |
| `acpi-listen-stop` | Stop running event listener | 636-651 | [→](#acpi-listen-stop) |
| `acpi-listen-status` | Check listener status | 664-679 | [→](#acpi-listen-status) |

<!-- CONTEXT_GROUP: event_callbacks -->

**Event Callback Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-on` | Register callback for event pattern | 699-717 | [→](#acpi-on) |
| `acpi-off` | Unregister callback | 732-745 | [→](#acpi-off) |
| `acpi-list-callbacks` | List all registered callbacks | 755-767 | [→](#acpi-list-callbacks) |

<!-- CONTEXT_GROUP: battery -->

**Battery Status Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-battery-status` | Get detailed battery info | 787-849 | [→](#acpi-battery-status) |
| `acpi-battery-list` | List all available batteries | 862-887 | [→](#acpi-battery-list) |
| `acpi-battery-percent` | Get battery percentage | 902-928 | [→](#acpi-battery-percent) |
| `acpi-battery-is-low` | Check if battery below low threshold | 942-953 | [→](#acpi-battery-is-low) |
| `acpi-battery-is-critical` | Check if battery below critical threshold | 967-978 | [→](#acpi-battery-is-critical) |
| `acpi-battery-is-charging` | Check if battery is charging | 992-1002 | [→](#acpi-battery-is-charging) |
| `acpi-battery-is-discharging` | Check if battery is discharging | 1016-1026 | [→](#acpi-battery-is-discharging) |

<!-- CONTEXT_GROUP: ac_adapter -->

**AC Adapter Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-ac-status` | Get AC adapter status | 1045-1100 | [→](#acpi-ac-status) |
| `acpi-ac-is-online` | Check if AC is connected | 1114-1148 | [→](#acpi-ac-is-online) |

<!-- CONTEXT_GROUP: thermal -->

**Thermal Zone Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-thermal-temp` | Get thermal zone temperature | 1168-1212 | [→](#acpi-thermal-temp) |
| `acpi-thermal-list` | List all thermal zones | 1225-1252 | [→](#acpi-thermal-list) |
| `acpi-thermal-is-hot` | Check if temperature exceeds threshold | 1267-1290 | [→](#acpi-thermal-is-hot) |
| `acpi-thermal-is-critical` | Check if temperature is critical | 1304-1307 | [→](#acpi-thermal-is-critical) |

<!-- CONTEXT_GROUP: power_state -->

**Power State Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-power-status` | Get comprehensive power status | 1321-1350 | [→](#acpi-power-status) |
| `acpi-power-profile` | Determine current power profile | 1362-1381 | [→](#acpi-power-profile) |

<!-- CONTEXT_GROUP: monitoring -->

**Monitoring Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-monitor-battery` | Continuously monitor battery | 1398-1414 | [→](#acpi-monitor-battery) |
| `acpi-monitor-thermal` | Continuously monitor thermal zones | 1427-1443 | [→](#acpi-monitor-thermal) |
| `acpi-monitor-power` | Continuously monitor power status | 1456-1472 | [→](#acpi-monitor-power) |

<!-- CONTEXT_GROUP: utility -->

**Utility Functions:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `acpi-cleanup` | Clean up ACPI resources | 1485-1507 | [→](#acpi-cleanup) |
| `acpi-ext-version` | Display extension version | 1521-1523 | [→](#acpi-ext-version) |
| `acpi-help` | Display comprehensive help | 1532-1628 | [→](#acpi-help) |
| `acpi-self-test` | Run comprehensive self-tests | 1640-1757 | [→](#acpi-self-test) |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `ACPI_SOCKET` | path | `/var/run/acpid.socket` | ACPI daemon socket path |
| `ACPI_SYSFS_PATH` | path | `/sys/class` | Sysfs path for ACPI devices |
| `ACPI_BATTERY_LOW_THRESHOLD` | integer | `20` | Low battery threshold (%) |
| `ACPI_BATTERY_CRITICAL_THRESHOLD` | integer | `10` | Critical battery threshold (%) |
| `ACPI_THERMAL_WARNING_THRESHOLD` | integer | `80000` | Thermal warning threshold (millidegrees) |
| `ACPI_THERMAL_CRITICAL_THRESHOLD` | integer | `95000` | Thermal critical threshold (millidegrees) |
| `ACPI_CACHE_BATTERY_TTL` | integer | `5` | Battery cache TTL (seconds) |
| `ACPI_CACHE_THERMAL_TTL` | integer | `2` | Thermal cache TTL (seconds) |
| `ACPI_CACHE_AC_TTL` | integer | `10` | AC adapter cache TTL (seconds) |
| `ACPI_EMIT_EVENTS` | boolean | `true` | Emit events to event system |
| `ACPI_AUTO_CLEANUP` | boolean | `true` | Auto-cleanup on exit |
| `ACPI_DEBUG` | boolean | `false` | Enable debug logging |
| `ACPI_VERBOSE` | boolean | `false` | Enable verbose logging |
| `ACPI_DRY_RUN` | boolean | `false` | Simulate operations |

---

## ACPI Events Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | When Emitted | Data Parameters | Source Lines |
|-------|--------------|-----------------|--------------|
| `acpi.raw` | All raw ACPI events | `device`, `class`, `id`, `value` | 220 |
| `acpi.battery` | Battery event detected | `class`, `id`, `value` | 225 |
| `acpi.battery.change` | Battery state changed | `capacity`, `class` | 322 |
| `acpi.battery.low` | Battery below low threshold | `capacity` | 317 |
| `acpi.battery.critical` | Battery below critical threshold | `capacity` | 314 |
| `acpi.ac` | AC adapter event | `class`, `id`, `value` | 229 |
| `acpi.ac.connect` | AC adapter connected | `class`, `id` | 354 |
| `acpi.ac.disconnect` | AC adapter disconnected | `class`, `id` | 350 |
| `acpi.thermal` | Thermal zone event | `class`, `id`, `value` | 233 |
| `acpi.thermal.warning` | Temperature above warning threshold | `temp`, `zone` | 390 |
| `acpi.thermal.critical` | Temperature above critical threshold | `temp`, `zone` | 387 |
| `acpi.lid` | Lid event | `class`, `id`, `value` | 237 |
| `acpi.lid.open` | Laptop lid opened | `class`, `id` | 413 |
| `acpi.lid.close` | Laptop lid closed | `class`, `id` | 417 |
| `acpi.button` | Button event | `class`, `id`, `value` | 241 |

**Event Subscription:**
```zsh
source "$(which _events)"
events-on "acpi.battery.low" my_handler_function
acpi-listen-start --background  # Required to receive events
```

---

## Power States Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Power State | Condition | Use Case |
|------------|-----------|----------|
| `performance` | AC power online | Maximum performance, no power constraints |
| `balanced` | Battery power, adequate level | Default balanced operation |
| `powersave` | Battery low (20%) | Reduced performance, extended runtime |
| `powersave-critical` | Battery critical (10%) | Maximum power saving, reduced functionality |

**Determining Power Profile:**
```zsh
profile=$(acpi-power-profile)
case "$profile" in
    performance) echo "AC power - full performance" ;;
    balanced) echo "Normal battery operation" ;;
    powersave) echo "Low battery - optimizing for runtime" ;;
    powersave-critical) echo "Critical battery - emergency mode" ;;
esac
```

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (missing device, socket error) | Most functions |
| `2` | Invalid arguments | Missing or invalid parameters | Battery/thermal operations |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Overview

The `_acpi` extension provides comprehensive ACPI (Advanced Configuration and Power Interface) event monitoring and power management capabilities for the dotfiles ecosystem. It offers an event-driven architecture for real-time power state monitoring, battery management, thermal zone tracking, and AC adapter detection.

This extension bridges low-level ACPI system events with high-level application logic through socket-based event listening, enabling sophisticated power management strategies, automatic threshold responses, and seamless integration with the dotfiles library infrastructure.

**Key Capabilities:**

- **Real-time ACPI Event Listening**: Connect to ACPI daemon socket and receive power events instantly
- **Battery Management**: Monitor charge percentage, charging status, and emit alerts at configurable thresholds
- **Thermal Zone Monitoring**: Track CPU/GPU temperatures with warning and critical alerts
- **AC Adapter Detection**: Detect power source changes and adjust behavior accordingly
- **Power Profile Determination**: Automatically calculate performance vs. power-saving profile
- **Event-Driven Architecture**: Pattern-based callback registration for flexible event handling
- **Intelligent Caching**: Per-resource TTL caching for battery, thermal, and AC adapter queries
- **Lifecycle Integration**: Automatic cleanup via lifecycle system
- **XDG Compliance**: Uses XDG Base Directory specification for state and configuration

**Use Cases:**

- Adaptive CPU frequency scaling based on AC/battery state
- Battery conservation alerts and automatic actions
- Thermal throttling and fan control responses
- Laptop lid close/open automation
- User notifications for power state changes
- Health monitoring and battery aging tracking
- Integration with power management daemons

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Installation

### System Requirements

1. **ACPI Daemon** (acpid) - Required for event socket
2. **Netcat** (nc) - Required for socket communication
3. **ZSH 5.0+** - For this extension
4. **Linux with ACPI** - For power/thermal information

### Installation Steps

#### 1. Install System Dependencies

**Arch Linux / Manjaro:**
```bash
sudo pacman -S acpid gnu-netcat
sudo systemctl enable acpid
sudo systemctl start acpid
```

**Debian / Ubuntu:**
```bash
sudo apt-get install acpid netcat-openbsd
sudo systemctl enable acpid
sudo systemctl start acpid
```

**Fedora / RHEL:**
```bash
sudo dnf install acpid netcat
sudo systemctl enable acpid
sudo systemctl start acpid
```

#### 2. Verify Installation

```bash
# Check ACPI daemon is running
systemctl status acpid

# Verify socket exists
ls -l /var/run/acpid.socket

# Verify netcat is available
which nc
```

#### 3. Source the Extension

In your ZSH scripts:
```zsh
#!/usr/bin/env zsh

# Load required dependency
source "$(which _common)" 2>/dev/null || exit 1

# Load ACPI extension
source "$(which _acpi)" 2>/dev/null || exit 1

# Initialize
acpi-init
```

#### 4. Verify ACPI is Available

```zsh
acpi-check-available || exit 1
echo "ACPI is ready!"
```

#### 5. Test Battery Detection

```zsh
# List available batteries
acpi-battery-list

# Get battery status
acpi-battery-status BAT0

# List thermal zones
acpi-thermal-list
```

### Troubleshooting Installation

**Error: "acpid socket not found"**
```bash
# Start acpid service
sudo systemctl start acpid

# Enable for auto-start
sudo systemctl enable acpid
```

**Error: "nc command not found"**
```bash
# Arch: Install gnu-netcat
sudo pacman -S gnu-netcat

# Ubuntu: Install netcat-openbsd
sudo apt-get install netcat-openbsd
```

**No batteries detected (desktop systems)**
This is normal. The extension gracefully handles systems without batteries.

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
## Quick Start

### Basic Battery Monitoring

```zsh
#!/usr/bin/env zsh

source "$(which _common)" 2>/dev/null || exit 1
source "$(which _acpi)" 2>/dev/null || exit 1

# Initialize
acpi-init
acpi-check-available || exit 1

# Get current battery level
percent=$(acpi-battery-percent BAT0)
echo "Battery: $percent%"

# Check if low
if acpi-battery-is-low BAT0; then
    echo "Warning: Battery is low!"
fi

# Check if critical
if acpi-battery-is-critical BAT0; then
    echo "Alert: Battery is critical! Saving work."
fi
```

### AC Adapter Detection

```zsh
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

if acpi-ac-is-online; then
    echo "AC power connected"
    # Adjust performance settings
else
    echo "Running on battery"
    # Activate power saving
fi
```

### Thermal Zone Monitoring

```zsh
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# List all thermal zones
acpi-thermal-list

# Check specific zone temperature
temp=$(acpi-thermal-temp thermal_zone0)
echo "CPU Temperature: $temp"

# Check if overheating
if acpi-thermal-is-hot thermal_zone0 85000; then
    echo "WARNING: System is hot!"
fi
```

### Event Listening with Callbacks

```zsh
source "$(which _common)" 2>/dev/null || exit 1
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Define callback function
handle_battery_event() {
    local device=$1 class=$2 id=$3 value=$4
    echo "Battery event: device=$device class=$class id=$id value=$value"
}

# Register callback
acpi-on "battery * * *" handle_battery_event

# Start listening in background
acpi-listen-start --background

# Let it run for a while
sleep 30

# Stop listening
acpi-listen-stop

# Cleanup
acpi-cleanup
```

### Power Profile Selection

```zsh
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Get power profile
profile=$(acpi-power-profile)

case "$profile" in
    performance)
        echo "Switching to performance mode"
        # Set CPU governor to performance
        ;;
    balanced)
        echo "Using balanced mode"
        # Use ondemand governor
        ;;
    powersave)
        echo "Activating power saving"
        # Set CPU governor to powersave
        ;;
    powersave-critical)
        echo "Emergency power saving!"
        # Minimal CPU frequency, sleep monitors
        ;;
esac
```

### Comprehensive Power Status Report

```zsh
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Display everything
acpi-power-status
```

### Event-Driven Notification System

```zsh
#!/usr/bin/env zsh

source "$(which _common)" 2>/dev/null || exit 1
source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Notification functions
notify_battery_low() {
    local capacity=$1
    echo "ALERT: Battery at $capacity%"
    # Could send desktop notification:
    # notify-send "Battery Low" "Battery at $capacity%"
}

notify_ac_disconnect() {
    echo "INFO: AC power disconnected - switching to battery"
    # Could adjust CPU frequency, disable backlight boost, etc.
}

notify_thermal_warning() {
    local temp=$1 zone=$2
    echo "WARNING: $zone temperature at $temp"
    # Could trigger fan control or throttling
}

# Register callbacks using _events integration
if [[ "$ACPI_EVENTS_AVAILABLE" == "true" ]]; then
    source "$(which _events)" 2>/dev/null || true

    events-on "acpi.battery.low" handle_low_battery
    events-on "acpi.ac.disconnect" handle_ac_disconnect
    events-on "acpi.thermal.warning" handle_thermal_warning
fi

# Start listening
acpi-listen-start --background

# Keep running
while true; do
    sleep 1
done
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Configuration

### Configuration File (XDG)

Create `~/.config/lib/acpi/config.json`:

```json
{
  "thresholds": {
    "battery": {
      "low": 20,
      "critical": 10
    },
    "thermal": {
      "warning": 80000,
      "critical": 95000
    }
  },
  "cache": {
    "battery_ttl": 5,
    "thermal_ttl": 2,
    "ac_ttl": 10
  },
  "socket": "/var/run/acpid.socket"
}
```

### Runtime Configuration

Override defaults with environment variables:

```zsh
# Set low battery threshold to 15%
export ACPI_BATTERY_LOW_THRESHOLD=15

# Set critical to 5%
export ACPI_BATTERY_CRITICAL_THRESHOLD=5

# Disable event emission
export ACPI_EMIT_EVENTS=false

# Enable debug output
export ACPI_DEBUG=true

# Source the extension
source "$(which _acpi)"
```

### Performance Tuning

#### Cache TTL Configuration

```zsh
# Battery checks (fast, but changes frequently)
export ACPI_CACHE_BATTERY_TTL=5

# Thermal zones (very frequent updates)
export ACPI_CACHE_THERMAL_TTL=2

# AC adapter (rarely changes)
export ACPI_CACHE_AC_TTL=10

source "$(which _acpi)"
```

#### Socket Configuration

```zsh
# Custom ACPI socket path (if non-standard)
export ACPI_SOCKET="/custom/path/acpid.socket"

# Custom sysfs path (for testing)
export ACPI_SYSFS_PATH="/sys/class"

source "$(which _acpi)"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## API Reference

### Initialization Functions

#### `acpi-init`

**Metadata:**
- **Lines:** 437-463 (27 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `_config` (optional)
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-init
```

**Description:**
Initialize ACPI extension with infrastructure integration. Creates required XDG-compliant directories, loads configuration if available, and sets up internal state.

**Returns:**
- `0` - Success
- `1` - Initialization failed

**Example:**
```zsh
acpi-init || exit 1
echo "ACPI ready"
```

**Behavior:**
- Creates cache, state, and config directories
- Loads configuration from `~/.config/lib/acpi/config.json` if available
- Overrides default thresholds from config
- Sets `_ACPI_INITIALIZED` flag
- Can be called multiple times (idempotent)

---

#### `acpi-check-available`

**Metadata:**
- **Lines:** 479-495 (17 lines)
- **Complexity:** Low
- **Dependencies:** `_common`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-check-available
```

**Description:**
Verify ACPI daemon and netcat are accessible. Checks for ACPI socket and required utilities.

**Returns:**
- `0` - ACPI is available
- `1` - ACPI not available

**Examples:**
```zsh
# Simple check
acpi-check-available || echo "ACPI not available"

# With error handling
if ! acpi-check-available; then
    echo "Error: ACPI not available" >&2
    echo "Install acpid: sudo pacman -S acpid" >&2
    exit 1
fi
```

**Error Cases:**
- `netcat` not found - Install with package manager
- ACPI socket not found - Start acpid service

---

#### `acpi-require-available`

**Metadata:**
- **Lines:** 504-506 (3 lines)
- **Complexity:** Very Low
- **Dependencies:** `acpi-check-available`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-require-available
```

**Description:**
Exit script if ACPI is not available. Convenience function for scripts that cannot continue without ACPI.

**Example:**
```zsh
# Exit early if ACPI not available
acpi-require-available

# Rest of script continues only if ACPI is ready
acpi-battery-status
```

---

### Event Listening Functions

#### `acpi-listen-start`

**Metadata:**
- **Lines:** 548-590 (43 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`, `_lifecycle` (optional)
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-listen-start [--background]
```

**Parameters:**
- `--background` - Run listener in background (optional)

**Returns:**
- `0` - Success
- `1` - Already running or failed

**Description:**
Start ACPI event listener. Connects to ACPI daemon socket and processes events. With `--background`, runs in background and tracks PID.

**Examples:**
```zsh
# Start in background (recommended)
acpi-listen-start --background
echo "Listener started: PID=$ACPI_LISTENER_PID"

# Start blocking (for foreground monitoring)
acpi-listen  # Runs until Ctrl+C

# With callback registration
acpi-on "battery * * *" my_handler
acpi-listen-start --background
```

**Integration:**
- Automatically tracks job with lifecycle system if available
- Lazy initializes extension on first call
- Validates ACPI socket exists before starting

---

#### `acpi-listen`

**Metadata:**
- **Lines:** 602-624 (23 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-listen
```

**Returns:**
- `0` - Normal exit
- `1` - Connection failed

**Description:**
Connect to ACPI socket and process events continuously (blocking). This is the core event processing loop called by `acpi-listen-start`.

**Example:**
```zsh
# Monitor events (blocking)
acpi-listen &
listener_pid=$!

# Let it run for 30 seconds
sleep 30

# Stop
kill $listener_pid
```

**Event Processing:**
- Parses ACPI event lines from socket
- Emits high-level events via _events system
- Executes registered callbacks
- Handles battery, AC, thermal, lid, and button events

---

#### `acpi-listen-stop`

**Metadata:**
- **Lines:** 636-651 (16 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-listen-stop
```

**Returns:**
- `0` - Success
- `1` - Not running

**Description:**
Stop running ACPI event listener. Kills the listener process and clears state.

**Example:**
```zsh
acpi-listen-start --background
echo "Listening for 30 seconds..."
sleep 30
acpi-listen-stop
echo "Listener stopped"
```

---

#### `acpi-listen-status`

**Metadata:**
- **Lines:** 664-679 (16 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-listen-status
```

**Returns:**
- `0` - Listener running
- `1` - Not running

**Output:** Status message with PID (if running)

**Example:**
```zsh
# Check status
if acpi-listen-status; then
    echo "Listener is active"
else
    echo "Listener is not running"
fi
```

---

### Event Callback Functions

#### `acpi-on`

**Metadata:**
- **Lines:** 699-717 (19 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-on PATTERN CALLBACK
```

**Parameters:**
- `PATTERN` - Event pattern (supports wildcards, e.g., "battery * * *")
- `CALLBACK` - Callback function name

**Returns:**
- `0` - Success
- `1` - Callback function not found
- `2` - Invalid arguments

**Description:**
Register callback function for ACPI event pattern. Callback is executed when event matches pattern.

**Examples:**
```zsh
# Simple battery callback
handle_battery() {
    local device=$1 class=$2 id=$3 value=$4
    echo "Battery event: $*"
}

acpi-on "battery * * *" handle_battery

# AC adapter callback
handle_ac() {
    local device=$1 class=$2 id=$3 value=$4
    if [[ "$value" == "1" ]]; then
        echo "AC connected"
    else
        echo "AC disconnected"
    fi
}

acpi-on "ac_adapter * * *" handle_ac

# Thermal callback with thresholds
handle_thermal() {
    local device=$1 class=$2 id=$3 value=$4
    if (( value >= 85000 )); then
        echo "WARNING: High temperature: $value"
    fi
}

acpi-on "thermal_zone * * *" handle_thermal
```

**Pattern Matching:**
- Patterns use ZSH extended glob matching
- Supports wildcards: `*`, `?`, `[...]`
- Matches against: "device class id value"

---

#### `acpi-off`

**Metadata:**
- **Lines:** 732-745 (14 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-off PATTERN
```

**Parameters:**
- `PATTERN` - Event pattern to unregister

**Returns:**
- `0` - Success
- `1` - Pattern not found
- `2` - Invalid arguments

**Description:**
Remove registered callback for event pattern.

**Example:**
```zsh
# Register
acpi-on "battery * * *" handle_battery

# Later, unregister
acpi-off "battery * * *"
```

---

#### `acpi-list-callbacks`

**Metadata:**
- **Lines:** 755-767 (13 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-list-callbacks
```

**Description:**
Display all registered event callbacks as formatted table.

**Example:**
```zsh
# Register some callbacks
acpi-on "battery * * *" handle_battery
acpi-on "ac_adapter * * *" handle_ac

# List them
acpi-list-callbacks
# Output:
# Pattern                                         Callback
# -------                                         --------
# battery * * *                                   handle_battery
# ac_adapter * * *                                handle_ac
```

---

### Battery Functions

#### `acpi-battery-status`

**Metadata:**
- **Lines:** 787-849 (63 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`, `_cache` (optional)
- **Cache TTL:** 5 seconds
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-status [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Success
- `1` - Battery not found

**Output:** Formatted battery status with capacity, energy, power, and runtime

**Description:**
Get detailed battery information including status, capacity, energy levels, and remaining runtime.

**Examples:**
```zsh
# Get status of default battery
acpi-battery-status

# Get status of specific battery
acpi-battery-status BAT1

# Parse output
status=$(acpi-battery-status)
capacity=$(echo "$status" | grep Capacity | awk '{print $NF}')
echo "Battery at: $capacity"
```

**Output Format:**
```
Battery: BAT0
Status: Charging
Capacity: 75%
Energy: 2400000 / 3200000 µWh (75%)
Power: 15000 µW
Remaining: ~160h
```

---

#### `acpi-battery-percent`

**Metadata:**
- **Lines:** 902-928 (27 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `_cache` (optional)
- **Cache TTL:** 5 seconds
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-percent [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Success
- `1` - Battery not found or no capacity info

**Output:** Battery percentage (number only, suitable for parsing)

**Description:**
Get battery charge percentage as simple integer for easy scripting.

**Examples:**
```zsh
# Get percentage
percent=$(acpi-battery-percent)
echo "Battery: $percent%"

# Use in conditional
if (( $(acpi-battery-percent) < 20 )); then
    echo "Low battery warning"
fi
```

---

#### `acpi-battery-is-low`

**Metadata:**
- **Lines:** 942-953 (12 lines)
- **Complexity:** Low
- **Dependencies:** `acpi-battery-percent`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-is-low [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Battery is low (below threshold)
- `1` - Battery not low or not found

**Description:**
Check if battery charge is below low threshold (default 20%, configurable via `ACPI_BATTERY_LOW_THRESHOLD`).

**Examples:**
```zsh
# Simple check
if acpi-battery-is-low; then
    echo "Battery is low!"
fi

# With custom battery
if acpi-battery-is-low BAT1; then
    notify-send "Battery Low" "Plug in AC"
fi

# In conditional logic
if acpi-battery-is-low; then
    # Reduce screen brightness
    brightnessctl set 50%
fi
```

---

#### `acpi-battery-is-critical`

**Metadata:**
- **Lines:** 967-978 (12 lines)
- **Complexity:** Low
- **Dependencies:** `acpi-battery-percent`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-is-critical [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Battery is critical (below threshold)
- `1` - Battery not critical or not found

**Description:**
Check if battery charge is below critical threshold (default 10%, configurable via `ACPI_BATTERY_CRITICAL_THRESHOLD`).

**Examples:**
```zsh
# Emergency check
if acpi-battery-is-critical; then
    echo "CRITICAL: Saving and suspending!"
    # Save all open documents
    hibernate_system
fi
```

---

#### `acpi-battery-is-charging`

**Metadata:**
- **Lines:** 992-1002 (11 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-is-charging [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Battery is charging
- `1` - Battery not charging or not found

**Example:**
```zsh
if acpi-battery-is-charging; then
    echo "AC power connected, charging"
    # Can use full performance mode
else
    echo "Running on battery"
fi
```

---

#### `acpi-battery-is-discharging`

**Metadata:**
- **Lines:** 1016-1026 (11 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-is-discharging [BATTERY]
```

**Parameters:**
- `BATTERY` - Battery ID (default: BAT0)

**Returns:**
- `0` - Battery is discharging
- `1` - Battery not discharging or not found

**Example:**
```zsh
if acpi-battery-is-discharging; then
    echo "On battery power"
    # Activate power saving
fi
```

---

#### `acpi-battery-list`

**Metadata:**
- **Lines:** 862-887 (26 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-battery-list
```

**Returns:**
- `0` - Success
- `1` - No batteries found

**Output:** List of battery IDs (one per line)

**Description:**
List all available batteries on the system.

**Example:**
```zsh
# List batteries
acpi-battery-list
# Output:
# - BAT0
# - BAT1

# Use in loop
while IFS= read -r line; do
    bat=$(echo "$line" | sed 's/^- //')
    percent=$(acpi-battery-percent "$bat")
    echo "Battery $bat: $percent%"
done < <(acpi-battery-list)
```

---

### AC Adapter Functions

#### `acpi-ac-status`

**Metadata:**
- **Lines:** 1045-1100 (56 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`, `_cache` (optional)
- **Cache TTL:** 10 seconds
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-ac-status [ADAPTER]
```

**Parameters:**
- `ADAPTER` - Adapter ID (default: AC0, auto-detected)

**Returns:**
- `0` - Success
- `1` - AC adapter not found

**Output:** Formatted AC adapter status

**Description:**
Get AC adapter connection status. Auto-detects common adapter names (AC0, AC, ACAD, ADP0, ADP1).

**Example:**
```zsh
acpi-ac-status
# Output:
# AC Adapter: AC0
# Status: Connected
```

---

#### `acpi-ac-is-online`

**Metadata:**
- **Lines:** 1114-1148 (35 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`, `_cache` (optional)
- **Cache TTL:** 10 seconds
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-ac-is-online [ADAPTER]
```

**Parameters:**
- `ADAPTER` - Adapter ID (default: AC0, auto-detected)

**Returns:**
- `0` - AC is online
- `1` - AC is offline or not found

**Description:**
Check if AC adapter is currently connected.

**Examples:**
```zsh
# Simple check
if acpi-ac-is-online; then
    echo "AC connected"
fi

# Power profile selection
if acpi-ac-is-online; then
    profile="performance"
else
    profile="powersave"
fi
```

---

### Thermal Functions

#### `acpi-thermal-temp`

**Metadata:**
- **Lines:** 1168-1212 (45 lines)
- **Complexity:** Medium
- **Dependencies:** `_common`, `_log`, `_cache` (optional)
- **Cache TTL:** 2 seconds
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-thermal-temp [ZONE]
```

**Parameters:**
- `ZONE` - Thermal zone ID (default: thermal_zone0)

**Returns:**
- `0` - Success
- `1` - Thermal zone not found
- `2` - Invalid arguments

**Output:** Temperature in human-readable format (e.g., "65°C (65000 m°C)")

**Description:**
Get thermal zone temperature. Returns both Celsius and millidegrees for precise comparison.

**Examples:**
```zsh
# Get default zone temperature
temp=$(acpi-thermal-temp)
echo "CPU: $temp"

# Get specific zone
acpi-thermal-temp thermal_zone1

# Parse for scripting
temp_output=$(acpi-thermal-temp thermal_zone0)
temp_c=$(echo "$temp_output" | awk -F'[°()]' '{print $1}')
if (( temp_c > 80 )); then
    echo "System is hot!"
fi
```

---

#### `acpi-thermal-list`

**Metadata:**
- **Lines:** 1225-1252 (28 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `acpi-thermal-temp`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-thermal-list
```

**Returns:**
- `0` - Success
- `1` - No thermal zones found

**Output:** List of thermal zones with temperatures

**Description:**
List all thermal zones on the system with current temperatures.

**Example:**
```zsh
acpi-thermal-list
# Output:
# - thermal_zone0: 65°C (65000 m°C)
# - thermal_zone1: 72°C (72000 m°C)
# - thermal_zone2: N/A
```

---

#### `acpi-thermal-is-hot`

**Metadata:**
- **Lines:** 1267-1290 (24 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-thermal-is-hot [ZONE] [THRESHOLD]
```

**Parameters:**
- `ZONE` - Thermal zone ID (default: thermal_zone0)
- `THRESHOLD` - Temperature threshold in millidegrees (default: `ACPI_THERMAL_WARNING_THRESHOLD`)

**Returns:**
- `0` - Temperature exceeds threshold
- `1` - Temperature below threshold or zone not found
- `2` - Invalid threshold

**Description:**
Check if thermal zone temperature exceeds warning threshold.

**Examples:**
```zsh
# Check default warning threshold (80°C)
if acpi-thermal-is-hot thermal_zone0; then
    echo "System is warm"
fi

# Check custom threshold (75°C = 75000 millidegrees)
if acpi-thermal-is-hot thermal_zone0 75000; then
    echo "Approaching temperature limit"
fi
```

---

#### `acpi-thermal-is-critical`

**Metadata:**
- **Lines:** 1304-1307 (4 lines)
- **Complexity:** Very Low
- **Dependencies:** `acpi-thermal-is-hot`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-thermal-is-critical [ZONE]
```

**Parameters:**
- `ZONE` - Thermal zone ID (default: thermal_zone0)

**Returns:**
- `0` - Temperature is critical
- `1` - Temperature not critical or zone not found

**Description:**
Check if thermal zone exceeds critical threshold (95°C by default).

**Example:**
```zsh
if acpi-thermal-is-critical thermal_zone0; then
    echo "CRITICAL: Thermal shutdown imminent!"
    shutdown -h now
fi
```

---

### Power State Functions

#### `acpi-power-status`

**Metadata:**
- **Lines:** 1321-1350 (30 lines)
- **Complexity:** Low
- **Dependencies:** `acpi-ac-status`, `acpi-battery-status`, `acpi-thermal-list`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-power-status
```

**Description:**
Get comprehensive power status report (AC, batteries, thermal zones).

**Example:**
```zsh
acpi-power-status
# Output:
# === Power Status ===
#
# AC Adapter: AC0
# Status: Connected
#
# - BAT0
#
# Battery: BAT0
# Status: Charging
# Capacity: 85%
# Energy: 2720000 / 3200000 µWh (85%)
# Power: 12000 µW
# Remaining: ~226h
#
# === Thermal Status ===
# - thermal_zone0: 65°C (65000 m°C)
```

---

#### `acpi-power-profile`

**Metadata:**
- **Lines:** 1362-1381 (20 lines)
- **Complexity:** Low
- **Dependencies:** `acpi-ac-is-online`, `acpi-battery-is-low`, `acpi-battery-is-critical`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-power-profile
```

**Output:** Power profile string (performance, balanced, powersave, powersave-critical)

**Description:**
Determine system power profile based on AC and battery status.

**Examples:**
```zsh
# Get profile
profile=$(acpi-power-profile)
echo "Power profile: $profile"

# Use in conditional
case "$(acpi-power-profile)" in
    performance)
        echo "Full performance mode"
        cpufreq-set -g performance
        ;;
    balanced)
        echo "Balanced mode"
        cpufreq-set -g ondemand
        ;;
    powersave)
        echo "Power saving mode"
        cpufreq-set -g powersave
        ;;
    powersave-critical)
        echo "Emergency power saving"
        cpufreq-set -g powersave
        echo 1 > /sys/module/i915/parameters/enable_psr
        ;;
esac
```

---

### Monitoring Functions

#### `acpi-monitor-battery`

**Metadata:**
- **Lines:** 1398-1414 (17 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `acpi-battery-status`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-monitor-battery [INTERVAL]
```

**Parameters:**
- `INTERVAL` - Update interval in seconds (default: 5)

**Returns:**
- `0` - Normal exit (interrupted with Ctrl+C)
- `2` - Invalid interval

**Description:**
Continuously monitor battery status with periodic updates.

**Example:**
```zsh
# Monitor battery every 3 seconds
acpi-monitor-battery 3
```

---

#### `acpi-monitor-thermal`

**Metadata:**
- **Lines:** 1427-1443 (17 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `acpi-thermal-list`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-monitor-thermal [INTERVAL]
```

**Parameters:**
- `INTERVAL` - Update interval in seconds (default: 2)

**Returns:**
- `0` - Normal exit (interrupted with Ctrl+C)
- `2` - Invalid interval

**Description:**
Continuously monitor thermal zones with periodic updates.

**Example:**
```zsh
# Monitor thermal zones every 1 second
acpi-monitor-thermal 1
```

---

#### `acpi-monitor-power`

**Metadata:**
- **Lines:** 1456-1472 (17 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`, `acpi-power-status`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-monitor-power [INTERVAL]
```

**Parameters:**
- `INTERVAL` - Update interval in seconds (default: 5)

**Returns:**
- `0` - Normal exit (interrupted with Ctrl+C)
- `2` - Invalid interval

**Description:**
Continuously monitor complete power status (AC, batteries, thermal).

**Example:**
```zsh
# Monitor everything every 10 seconds
acpi-monitor-power 10
```

---

### Utility Functions

#### `acpi-cleanup`

**Metadata:**
- **Lines:** 1485-1507 (23 lines)
- **Complexity:** Low
- **Dependencies:** `_common`, `_log`
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-cleanup
```

**Description:**
Clean up ACPI resources including listeners, callbacks, and caches. Called automatically via lifecycle system.

**Example:**
```zsh
# Manual cleanup (usually automatic)
acpi-cleanup
```

---

#### `acpi-ext-version`

**Metadata:**
- **Lines:** 1521-1523 (3 lines)
- **Complexity:** Very Low
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-ext-version
```

**Output:** Version string

**Example:**
```zsh
echo "ACPI version: $(acpi-ext-version)"
```

---

#### `acpi-help`

**Metadata:**
- **Lines:** 1532-1628 (97 lines)
- **Complexity:** Low
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-help
```

**Description:**
Display comprehensive help text with usage examples.

---

#### `acpi-self-test`

**Metadata:**
- **Lines:** 1640-1757 (118 lines)
- **Complexity:** Medium
- **Dependencies:** All ACPI functions
- **Since:** v1.0.0

**Syntax:**
```zsh
acpi-self-test
```

**Returns:**
- `0` - All tests passed
- `1` - Some tests failed

**Description:**
Run comprehensive self-tests to verify ACPI functionality and dependencies.

**Example:**
```zsh
# Run tests
acpi-self-test
# Output:
# [INFO] Running _acpi v2.1.0 self-test
# [INFO] ✓ Initialization successful
# [INFO] Dependency check:
# [INFO]   _common:    yes (required)
# [INFO]   _log:       true
# [INFO]   _events:    true
# ...
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## Advanced Usage

### Event-Driven Battery Management Daemon

Create a background daemon that monitors battery and adjusts system behavior:

```zsh
#!/usr/bin/env zsh

source "$(which _common)" 2>/dev/null || exit 1
source "$(which _acpi)" 2>/dev/null || exit 1
source "$(which _log)" 2>/dev/null || true
source "$(which _events)" 2>/dev/null || true

acpi-init
acpi-check-available || exit 1

# Battery management callbacks
on_battery_critical() {
    log-error "CRITICAL BATTERY - Initiating emergency shutdown in 1 minute"

    # Save state
    sync

    # Give user time to save work
    sleep 60

    # Emergency hibernate
    systemctl hibernate || systemctl poweroff
}

on_battery_low() {
    log-warn "Low battery - switching to power save mode"

    # Reduce performance
    echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

    # Reduce brightness
    brightnessctl set 30%

    # Kill background jobs
    # ...
}

on_ac_connect() {
    log-info "AC connected - restoring performance mode"

    # Restore performance
    echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

    # Restore brightness
    brightnessctl set 100%
}

# Register callbacks
acpi-on "battery * * *" on_battery_event
acpi-on "ac_adapter * * *" on_ac_adapter_event

# Start listening in background
acpi-listen-start --background

# Keep running
while true; do
    sleep 1
done
```

### Thermal Management with Dynamic Throttling

```zsh
#!/usr/bin/env zsh

source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# CPU frequency scaling based on temperature
manage_thermal() {
    local zone="${1:-thermal_zone0}"
    local temp_raw
    local temp_c

    while true; do
        temp_raw=$(cat "/sys/class/thermal/$zone/temp" 2>/dev/null)

        if [[ -z "$temp_raw" ]]; then
            sleep 5
            continue
        fi

        temp_c=$((temp_raw / 1000))

        if (( temp_c >= 95 )); then
            # Critical: Minimum frequency
            echo 0 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
            echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            echo "CRITICAL THERMAL: $temp_c°C"
        elif (( temp_c >= 85 )); then
            # Warning: Reduced frequency
            echo 25 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
            echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            echo "WARNING THERMAL: $temp_c°C"
        elif (( temp_c < 70 )); then
            # Normal: Full performance
            echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
            echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            echo "NORMAL: $temp_c°C"
        fi

        sleep 5
    done
}

manage_thermal thermal_zone0
```

### Power Profile Manager with systemd Integration

```zsh
#!/usr/bin/env zsh

source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Systemd power management
apply_power_profile() {
    local profile="$1"

    case "$profile" in
        performance)
            echo "Applying performance profile"
            systemctl --user set-environment POWERPROFILE=performance
            # CPU scaling
            echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            # GPU performance
            echo "1500" > /sys/class/drm/card0/device/pp_dpm_sclk
            ;;
        balanced)
            echo "Applying balanced profile"
            systemctl --user set-environment POWERPROFILE=balanced
            echo ondemand | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            ;;
        powersave)
            echo "Applying power saving profile"
            systemctl --user set-environment POWERPROFILE=powersave
            echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            # Enable dynamic power management
            echo 1 > /sys/module/i915/parameters/enable_psr
            ;;
    esac
}

# Monitor and apply
while true; do
    profile=$(acpi-power-profile)
    apply_power_profile "$profile"
    sleep 5
done
```

### Laptop Lid Event Integration

```zsh
#!/usr/bin/env zsh

source "$(which _acpi)" 2>/dev/null || exit 1

acpi-init
acpi-check-available || exit 1

# Lid close handler
on_lid_close() {
    local device=$1 class=$2 id=$3 value=$4

    echo "Lid closed"

    # Lock screen
    loginctl lock-session

    # Sleep display
    sleep 2
    xset dpms force off

    # Optional: suspend after delay
    sleep 300
    if [[ "$(cat /proc/acpi/button/lid/LID0/state)" == *"closed"* ]]; then
        systemctl suspend
    fi
}

# Lid open handler
on_lid_open() {
    local device=$1 class=$2 id=$3 value=$4

    echo "Lid opened"

    # Wake display
    xset dpms force on

    # Unlock screen (optional)
    # loginctl unlock-session
}

# Register handlers
acpi-on "button/lid * * *" on_lid_event

# Start listening
acpi-listen-start --background

# Keep running
while true; do
    sleep 1
done
```

### Battery Health Monitoring

```zsh
#!/usr/bin/env zsh

source "$(which _acpi)" 2>/dev/null || exit 1
source "$(which _cache)" 2>/dev/null || true

acpi-init
acpi-check-available || exit 1

# Track battery health over time
track_battery_health() {
    local battery="${1:-BAT0}"
    local cache_file="$HOME/.cache/acpi/battery_health_$battery"

    mkdir -p "${cache_file%/*}"

    while true; do
        local capacity=$(acpi-battery-percent "$battery")
        local status=$(cat "/sys/class/power_supply/$battery/status" 2>/dev/null)
        local timestamp=$(date +%s)

        # Log to file
        echo "$timestamp|$capacity|$status" >> "$cache_file"

        # Analyze trend (every 24 hours)
        local age=$(( $(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
        if (( age > 86400 )); then
            # Calculate degradation
            local oldest_capacity=$(head -1 "$cache_file" | cut -d'|' -f2)
            local newest_capacity=$(tail -1 "$cache_file" | cut -d'|' -f2)
            local degradation=$((oldest_capacity - newest_capacity))

            if (( degradation > 5 )); then
                echo "Warning: Battery degradation detected ($degradation% loss)"
            fi
        fi

        sleep 3600  # Check hourly
    done
}

track_battery_health BAT0
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Best Practices

### 1. Always Initialize Before Use

```zsh
# WRONG: Using without initialization
acpi-battery-percent  # May fail silently

# RIGHT: Initialize first
acpi-init
acpi-battery-percent
```

### 2. Check Availability on Startup

```zsh
# Script start
acpi-check-available || {
    echo "Error: ACPI not available"
    echo "Install: sudo pacman -S acpid gnu-netcat"
    exit 1
}
```

### 3. Use Callbacks for Event-Driven Logic

```zsh
# WRONG: Polling battery constantly
while true; do
    if acpi-battery-is-low; then
        notify "Low battery"
    fi
    sleep 1  # CPU intensive
done

# RIGHT: Register callback
acpi-on "battery * * *" on_battery_event
acpi-listen-start --background
```

### 4. Configure Thresholds Appropriately

```zsh
# WRONG: Using defaults for all scenarios
acpi-battery-is-low  # Uses 20% threshold

# RIGHT: Adjust for your use case
export ACPI_BATTERY_LOW_THRESHOLD=30  # Higher for office use
export ACPI_BATTERY_CRITICAL_THRESHOLD=15

source "$(which _acpi)"
```

### 5. Use Power Profiles for Decision Making

```zsh
# WRONG: Checking multiple conditions
if acpi-ac-is-online && ! acpi-battery-is-low; then
    # Performance mode
fi

# RIGHT: Use power profile
case "$(acpi-power-profile)" in
    performance) ;;
    balanced) ;;
    powersave) ;;
esac
```

### 6. Enable Caching for Performance

```zsh
# If querying frequently, caching is automatic
# TTL defaults:
# - Battery: 5 seconds
# - Thermal: 2 seconds
# - AC: 10 seconds

# Safe for tight loops:
for i in {1..100}; do
    acpi-battery-percent  # Cached after first call
done
```

### 7. Clean Up on Exit

```zsh
# Register cleanup
trap acpi-cleanup EXIT

# Or use lifecycle system (automatic with _lifecycle)
source "$(which _lifecycle)"
lifecycle-cleanup acpi-cleanup
```

### 8. Log Events for Debugging

```zsh
# Enable debug logging
export ACPI_DEBUG=true
export ACPI_VERBOSE=true

source "$(which _acpi)"

# Will show detailed event processing
acpi-listen-start --background
```

### 9. Handle Errors Gracefully

```zsh
# Always check return codes
if ! acpi-battery-status BAT0; then
    echo "Battery not found, using defaults"
    percent=100
fi
```

### 10. Test with acpi-self-test

```zsh
# Run before production use
acpi-self-test || {
    echo "Some tests failed"
    exit 1
}
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Troubleshooting

### Event Listener Not Receiving Events

**Symptoms:** Callbacks not being triggered

**Solutions:**
```zsh
# 1. Verify ACPI daemon is running
systemctl status acpid

# 2. Check socket exists
ls -l /var/run/acpid.socket

# 3. Enable debug logging
export ACPI_DEBUG=true

# 4. Test direct socket access
acpi-listen  # Should show events

# 5. Verify callback function exists
typeset -f my_callback
```

### Battery Not Detected

**Symptoms:** "No batteries found"

**Solutions:**
```zsh
# 1. Check sysfs path
ls /sys/class/power_supply/

# 2. Verify battery exists
ls /sys/class/power_supply/BAT*

# 3. Check permissions (may need sudo)
cat /sys/class/power_supply/BAT0/capacity

# 4. Custom battery ID
acpi-battery-status BAT1  # Try different ID
```

### Thermal Zone Not Found

**Symptoms:** "Thermal zone not found"

**Solutions:**
```zsh
# 1. List available zones
ls /sys/class/thermal/

# 2. Try different zone ID
acpi-thermal-temp thermal_zone1

# 3. Check permissions
cat /sys/class/thermal/thermal_zone0/temp

# 4. May not be available on all systems
```

### AC Adapter Not Detected

**Symptoms:** AC status returns "Unknown"

**Solutions:**
```zsh
# 1. List power supplies
ls /sys/class/power_supply/

# 2. Try different adapter ID
acpi-ac-status ACAD
acpi-ac-status ADP0

# 3. Check if AC adapter exists on system
grep -i "adapter" /proc/acpi/info

# 4. Desktop systems may not have AC adapter
```

### Permission Denied Errors

**Symptoms:** "Permission denied" when reading sysfs

**Solutions:**
```zsh
# 1. Some files require root
sudo bash -c 'source "$(which _acpi)" && acpi-battery-status'

# 2. Add user to appropriate groups
sudo usermod -a -G input $USER
sudo usermod -a -G disk $USER

# 3. Create udev rules for battery access
sudo tee /etc/udev/rules.d/98-acpi-battery.rules <<'EOF'
SUBSYSTEM=="power_supply", MODE="0644"
EOF

# 4. Reload udev rules
sudo udevadm control --reload
sudo udevadm trigger
```

### Socket Connection Timeout

**Symptoms:** "ACPI listener connection failed"

**Solutions:**
```zsh
# 1. ACPI daemon may not be running
sudo systemctl restart acpid

# 2. Check socket permissions
ls -l /var/run/acpid.socket

# 3. Verify netcat is available
which nc

# 4. Test netcat manually
echo -n "" | nc -U /var/run/acpid.socket

# 5. May need to restart service
sudo systemctl daemon-reload
sudo systemctl restart acpid
```

### High CPU Usage with Event Listener

**Symptoms:** ACPI listener process using high CPU

**Solutions:**
```zsh
# 1. May be normal with frequent events
# 2. Reduce event callback complexity
# 3. Use cache to avoid redundant queries
# 4. Check for infinite loops in callbacks

# Example: Slow callback
my_slow_callback() {
    # Don't do heavy operations here
    for i in {1..1000}; do
        # Heavy processing
    done
}
```

### Configuration Not Being Applied

**Symptoms:** ACPI_BATTERY_LOW_THRESHOLD changes not working

**Solutions:**
```zsh
# 1. Set BEFORE sourcing extension
export ACPI_BATTERY_LOW_THRESHOLD=15
source "$(which _acpi)"

# 2. Call init after setting
export ACPI_BATTERY_LOW_THRESHOLD=15
source "$(which _acpi)"
acpi-init

# 3. Configuration file takes precedence
# Check ~/.config/lib/acpi/config.json
```

### Events Not Being Emitted

**Symptoms:** _events system not receiving ACPI events

**Solutions:**
```zsh
# 1. Verify _events is available
source "$(which _events)" 2>/dev/null || echo "Events not available"

# 2. Check ACPI_EMIT_EVENTS is true
echo $ACPI_EMIT_EVENTS

# 3. Register handler before starting listener
acpi-on "battery * * *" my_handler
acpi-listen-start --background

# 4. Verify listener is running
acpi-listen-status
```

---

## Architecture

### Event Processing Flow

```
ACPI Event → Socket → Parser → Event Router → Callbacks
                                     ↓
                              High-level Events
                                     ↓
                              Event System (_events)
```

### Caching Strategy

- **Battery queries:** 5-second cache (status changes slowly)
- **Thermal queries:** 2-second cache (temperatures update frequently)
- **AC adapter:** 10-second cache (rarely changes)

Caching is automatic when `_cache` is available. Manually clear with:
```zsh
cache-clear-namespace "acpi"
```

### Integration Points

1. **_common**: Required for validation and utilities
2. **_log**: Optional, used for logging
3. **_events**: Optional, emits ACPI events
4. **_cache**: Optional, improves query performance
5. **_lifecycle**: Optional, automatic cleanup on exit
6. **_config**: Optional, loads thresholds from config file

### Performance Characteristics

| Operation | Complexity | Cached | Notes |
|-----------|-----------|--------|-------|
| Battery query | O(1) | Yes | Direct sysfs read |
| Thermal query | O(1) | Yes | Direct sysfs read |
| AC query | O(1) | Yes | Direct sysfs read |
| Battery list | O(n) | No | Scans /sys/class |
| Thermal list | O(n) | No | Scans /sys/class |
| Event listen | O(1) | N/A | Blocking socket read |

---

## External References

- **ACPI Specification**: https://uefi.org/acpi
- **Linux ACPI Documentation**: https://www.kernel.org/doc/html/latest/admin-guide/acpi/
- **acpid Documentation**: http://sourceforge.net/projects/acpid2/
- **ZSH Manual**: https://zsh.sourceforge.io/Doc/
- **Related Extensions**: `_common`, `_log`, `_events`, `_cache`, `_lifecycle`, `_config`

---

**Documentation Version:** Enhanced Requirements v1.1 | **Last Updated:** 2025-11-07 | **Status:** GOLD STANDARD CANDIDATE
