# _wifi v2.0 - Comprehensive WiFi Network Management

<!-- HEADER BLOCK -->
**Version:** 1.0.0
**Type:** Library Extension (Layer 3: Integration)
**Part of:** dotfiles library v2.0
**Source:** ~/.local/bin/lib/_wifi (1,593 lines)
**Functions:** 33 public, 7 internal helpers
**Examples:** 50+ practical usage examples
**Complexity:** Medium (state-driven, event-based)
**Dependencies:** _common (required), iwd/iwctl (required)
**Documentation Size:** 3,425 lines

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

---

## Quick Access Index

### Table of Contents with Line Offsets

| Section | Lines | Purpose |
|---------|-------|---------|
| [Function Quick Reference](#function-quick-reference) | 45-87 | All functions with source lines |
| [Network Types Reference](#network-types-reference) | 89-105 | Security types and modes |
| [Connection States Reference](#connection-states-reference) | 107-122 | Device connection states |
| [Environment Variables Reference](#environment-variables-reference) | 124-152 | All configuration options |
| [Return Codes Reference](#return-codes-reference) | 154-172 | All possible return values |
| [Overview](#overview) | 174-210 | Features and capabilities |
| [Architecture](#architecture) | 212-268 | Layer design and components |
| [Installation](#installation) | 270-330 | Setup and verification |
| [Quick Start](#quick-start) | 332-415 | 7 basic examples |
| [Configuration](#configuration) | 417-510 | Environment variables and tuning |
| [API Reference](#api-reference) | 512-2240 | All 33 functions documented |
| [Advanced Usage](#advanced-usage) | 2242-2480 | 8 integration patterns |
| [Best Practices](#best-practices) | 2482-2570 | 10 guidelines |
| [Troubleshooting](#troubleshooting) | 2572-2825 | 8 common issues |
| [Performance](#performance) | 2827-2900 | Benchmarks and optimization |
| [See Also](#see-also) | 2902-2920 | Related documentation |

---

## Function Quick Reference

<!-- CONTEXT_GROUP: Initialization -->
<!-- CONTEXT_PRIORITY: HIGH -->

| Function | Lines | Category | Parameters | Return | Purpose |
|----------|-------|----------|-----------|--------|---------|
| `wifi-init` | 352-390 | Initialization | - | 0/1 | Initialize extension, create dirs, check daemon |
| `wifi-check-available` | 402-406 | Initialization | - | 0/1 | Verify WiFi is available (iwctl + iwd) |
| `wifi-require-available` | 416-423 | Initialization | - | 0/1 | Require WiFi available, log error if not |

<!-- CONTEXT_GROUP: Device Management -->
| `wifi-device-list` | 438-469 | Devices | - | 0/1 | List all WiFi devices (with caching) |
| `wifi-device-show` | 480-494 | Devices | device | 0/1/2 | Show detailed device information |
| `wifi-device-get-default` | 504-506 | Devices | - | 0/1 | Get first available device (or cached) |
| `wifi-device-is-up` | 519-531 | Devices | device | 0/1 | Check if device is powered on |

<!-- CONTEXT_GROUP: Network Scanning -->
| `wifi-scan` | 550-581 | Scanning | device | 0/1/2 | Trigger network scan on device |
| `wifi-get-networks` | 593-647 | Scanning | device [fmt] | 0/1/2 | List discovered networks (raw/bars/dbms) |
| `wifi-network-exists` | 661-673 | Scanning | device ssid | 0/1 | Check if network is visible |
| `wifi-get-signal-strength` | 686-706 | Scanning | device ssid [fmt] | 0/1 | Get signal strength (bars/dbms/quality) |
| `wifi-get-security-type` | 718-737 | Scanning | device ssid | 0/1 | Get security type (psk/open/8021x) |

<!-- CONTEXT_GROUP: Connection Management -->
| `wifi-connect` | 759-799 | Connection | device ssid [pass] | 0/1/2 | Connect to network with optional password |
| `wifi-connect-hidden` | 812-845 | Connection | device ssid [pass] | 0/1/2 | Connect to hidden network |
| `wifi-disconnect` | 858-884 | Connection | device | 0/1/2 | Disconnect from current network |
| `wifi-is-connected` | 897-909 | Connection | device | 0/1 | Check if device is connected |
| `wifi-get-connected-ssid` | 920-939 | Connection | device | 0/1 | Get SSID of connected network |
| `wifi-get-connection-status` | 950-957 | Connection | device | 0/1 | Get comprehensive connection status |

<!-- CONTEXT_GROUP: Saved Networks -->
| `wifi-known-list` | 971-978 | Known | - | 0/1 | List all saved networks |
| `wifi-known-show` | 989-999 | Known | ssid | 0/1/2 | Show saved network details |
| `wifi-known-forget` | 1012-1033 | Known | ssid | 0/1/2 | Remove network from saved list |
| `wifi-known-forget-all` | 1043-1072 | Known | - | 0/1 | Remove all saved networks (DESTRUCTIVE) |
| `wifi-known-exists` | 1085-1096 | Known | ssid | 0/1 | Check if network is saved |

<!-- CONTEXT_GROUP: Access Point Mode -->
| `wifi-ap-start` | 1115-1145 | AP Mode | device ssid [pass] | 0/1/2 | Start WiFi hotspot |
| `wifi-ap-stop` | 1158-1178 | AP Mode | device | 0/1/2 | Stop WiFi hotspot |
| `wifi-ap-is-active` | 1192-1203 | AP Mode | device | 0/1 | Check if hotspot is running |

<!-- CONTEXT_GROUP: Utility Functions -->
| `wifi-signal-to-bars` | 1217-1231 | Utility | rssi | 0 | Convert dBm to signal bars (****) |
| `wifi-signal-to-quality` | 1241-1255 | Utility | rssi | 0 | Convert dBm to percentage (0-100%) |
| `wifi-cleanup` | 1263-1278 | Utility | - | 0 | Clean up resources and monitoring |
| `wifi-version` | 1286-1288 | Utility | - | 0 | Print extension version |
| `wifi-help` | 1290-1405 | Utility | - | 0 | Display comprehensive help |
| `wifi-self-test` | 1407-1505 | Utility | - | 0/1 | Run validation tests |
| `wifi-info` | 1507-1569 | Utility | - | 0 | Display system and config info |

---

## Network Types Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->

| Type | Code | Security | Details | Example |
|------|------|----------|---------|---------|
| **Open Network** | `open` | None | No authentication required | Free WiFi hotspots |
| **WPA Personal** | `psk` | Pre-Shared Key | 8-63 character password | Home WiFi (most common) |
| **WPA2 Personal** | `psk` | Pre-Shared Key | Modern standard for PSK | Updated home WiFi |
| **WPA3 Personal** | `psk` | Enhanced security | Latest standard | New routers |
| **WPA Enterprise** | `8021x` | 802.1X + RADIUS | Certificate-based | Corporate networks |
| **WPA2 Enterprise** | `8021x` | 802.1X + RADIUS | Standard enterprise | University WiFi |
| **Hidden Network** | `hidden` | Varies | SSID not broadcast | Requires explicit SSID |

---

## Connection States Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->

| State | Description | Function Check | Example |
|-------|-------------|-----------------|---------|
| **Connected** | Device connected to network | `wifi-is-connected` returns 0 | Actively using WiFi |
| **Disconnected** | Device not connected | `wifi-is-connected` returns 1 | No active connection |
| **Scanning** | Searching for networks | `wifi-scan` in progress | Discovering APs |
| **Associating** | Attempting to join network | `wifi-connect` in progress | Authentication phase |
| **Authenticating** | Verifying credentials | Connection handshake | Password validation |
| **Powered On** | Device powered and active | `wifi-device-is-up` returns 0 | Device ready for scanning |
| **Powered Off** | Device disabled | `wifi-device-is-up` returns 1 | Device not available |
| **AP Mode** | Device in Access Point mode | `wifi-ap-is-active` returns 0 | Acting as WiFi hotspot |

---

## Environment Variables Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: Configuration -->

| Variable | Default | Type | Purpose | Range |
|----------|---------|------|---------|-------|
| `WIFI_DEBUG` | `false` | bool | Enable debug logging output | true/false |
| `WIFI_EMIT_EVENTS` | `true` | bool | Emit events via _events library | true/false |
| `WIFI_AUTO_SCAN` | `true` | bool | Auto-scan on initialization | true/false |
| `WIFI_CACHE_SCANS` | `true` | bool | Cache scan results in memory | true/false |
| `WIFI_DRY_RUN` | `false` | bool | Dry-run mode (no actual changes) | true/false |
| `WIFI_SCAN_TIMEOUT` | `10` | int | Network scan timeout | 1-60 seconds |
| `WIFI_CONNECT_TIMEOUT` | `30` | int | Connection attempt timeout | 1-120 seconds |
| `WIFI_CACHE_TTL` | `30` | int | Cache validity period | 1-3600 seconds |
| `WIFI_SIGNAL_FORMAT` | `bars` | str | Default signal display format | bars/dbms/quality |
| `WIFI_SIGNAL_EXCELLENT` | `-50` | int | Excellent signal threshold | -30 to -70 dBm |
| `WIFI_SIGNAL_GOOD` | `-60` | int | Good signal threshold | -40 to -80 dBm |
| `WIFI_SIGNAL_FAIR` | `-70` | int | Fair signal threshold | -50 to -90 dBm |
| `WIFI_SIGNAL_POOR` | `-80` | int | Poor signal threshold | -60 to -100 dBm |
| `WIFI_DEFAULT_DEVICE` | empty | str | Default WiFi device to use | Device name (e.g., wlan0) |

---

## Return Codes Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->

| Code | Meaning | When Returned | Action Required |
|------|---------|---------------|-----------------|
| `0` | Success | Operation completed successfully | None - proceed normally |
| `1` | Failure | Operation failed (device/network issues) | Check logs, retry or troubleshoot |
| `2` | Invalid Arguments | Required parameter missing/invalid | Verify function call arguments |
| `3` | Network Not Found | Specified network doesn't exist | Check SSID, rescan networks |
| `4` | Connection Failed | Authentication or timeout | Verify password, check signal |
| `5` | Device Not Available | WiFi hardware unavailable | Check device, start iwd daemon |
| `6` | Permission Denied | Insufficient privileges | Run with sudo if needed |
| `7` | Configuration Error | Invalid configuration detected | Check environment variables |

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->

The `_wifi` extension provides a comprehensive, production-grade WiFi network management interface through a clean ZSH API that abstracts the complexity of `iwd` (iNet Wireless Daemon) and `iwctl` command-line utilities. It enables seamless device discovery, network scanning with real-time signal monitoring, flexible connection management, saved network operations, WiFi hotspot creation, and event-driven integration with the dotfiles infrastructure layer.

### Core Capabilities

<!-- CONTEXT_GROUP: Features -->

**Device Management** (→ L438-531)
- Automatic discovery and enumeration of WiFi adapters
- Detailed device status reporting (power state, connection, scanning)
- Power state verification and management
- Device-specific configuration persistence

**Network Scanning** (→ L550-737)
- Trigger adaptive network scans with configurable timeouts
- Real-time signal strength monitoring and reporting
- Network security type identification (open, WPA, enterprise)
- Support for hidden networks detection
- Multiple signal strength formats (bars, dBm, quality percentage)

**Connection Management** (→ L759-957)
- Connect to visible networks with automatic credential storage
- Support for hidden networks with explicit SSID specification
- Graceful disconnection with state cleanup
- Real-time connection status monitoring
- Auto-reconnection to previously known networks

**Saved Network Operations** (→ L971-1096)
- List all saved network credentials
- Detailed view of specific network configurations
- Secure network credential removal
- Bulk operations (forget all networks)
- Known network verification and management

**Access Point Mode** (→ L1115-1203)
- Transform WiFi device into hotspot (AP mode)
- Support for password-protected and open hotspots
- Per-device AP state management
- Seamless AP start/stop operations

**Signal Processing** (→ L1217-1255)
- RSSI (dBm) to signal bar visualization
- Logarithmic quality percentage calculation
- Configurable signal strength thresholds
- Real-time quality assessment

**Infrastructure Integration** (→ L64-89)
- Seamless _lifecycle integration for automatic cleanup
- Event system integration for state change notifications
- Performance caching layer for expensive operations
- Structured logging with debug modes
- Configuration management framework

### Design Philosophy

1. **Comprehensive Coverage**: All 33 functions implement the complete WiFi lifecycle
2. **Clean Abstraction**: Users interact with intuitive APIs, never iwd internals
3. **Graceful Degradation**: Full functionality without optional libraries
4. **State Consistency**: Internal tracking matches hardware state
5. **Production Ready**: Extensive validation, error handling, dry-run support
6. **Performance Optimized**: Caching, batch operations, minimal overhead
7. **Event-Driven**: React to WiFi state changes in real-time

---

## Architecture

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: Design -->

### Layered Architecture Design

```
┌─────────────────────────────────────────────────────┐
│         WiFi Utility Application (CLI)              │
│  • Remote WiFi management                           │
│  • Status monitoring                                │
│  • Interactive connection workflows                 │
├─────────────────────────────────────────────────────┤
│        _wifi Extension v2.0 (33 functions)         │
│  ┌──────────────────┬─────────────────────────┐    │
│  │ Public API Layer │ 33 production functions │    │
│  │                  │ (initialization,        │    │
│  │                  │  devices, scanning,    │    │
│  │                  │  connection, AP mode)  │    │
│  ├──────────────────┼─────────────────────────┤    │
│  │ Business Logic   │ State management        │    │
│  │ Layer            │ Signal processing       │    │
│  │                  │ Device validation       │    │
│  │                  │ Event emission          │    │
│  ├──────────────────┼─────────────────────────┤    │
│  │ Integration      │ iwctl/iwd IPC          │    │
│  │ Layer            │ Output parsing          │    │
│  │                  │ Error handling          │    │
│  └──────────────────┴─────────────────────────┘    │
├─────────────────────────────────────────────────────┤
│       Infrastructure Layer (Optional)               │
│  _lifecycle (cleanup) | _events (state)             │
│  _cache (perf) | _log (structured logging)          │
├─────────────────────────────────────────────────────┤
│     System Layer: iwctl / iwd (iNet Wireless)      │
└─────────────────────────────────────────────────────┘
```

### Component Organization

<!-- CONTEXT_GROUP: Components -->

**Module Structure** (1,593 lines):

1. **Header & Dependencies** (L1-90)
   - Source guard to prevent multiple loading
   - Version declaration (1.0.0)
   - Required (_common) and optional (_log, _events, _cache, _lifecycle, _config) loading

2. **Configuration** (L91-138)
   - XDG directory initialization (cache, state, config)
   - System paths (/var/lib/iwd for credentials)
   - Behavior flags and timeouts
   - Signal strength thresholds
   - Event name constants

3. **Internal State** (L139-157)
   - Initialization flag tracking
   - Active connection per-device mapping
   - Monitoring process tracking
   - Event callback registration
   - Device list caching with TTL

4. **Internal Helpers** (L160-336, 7 functions)
   - `_wifi-init-dirs` - Create required XDG directories
   - `_wifi-emit` - Conditional event emission
   - `_wifi-check-daemon` - Verify iwd is running
   - `_wifi-validate-device` - Validate device existence
   - `_wifi-get-default-device` - Auto-detect primary device
   - `_wifi-format-rssi` - Signal strength conversion
   - `_wifi-parse-network-line` - iwctl output parsing

5. **Public API** (L338-1569, 33 functions)
   - Initialization (3): wifi-init, wifi-check-available, wifi-require-available
   - Devices (4): wifi-device-list, wifi-device-show, wifi-device-get-default, wifi-device-is-up
   - Scanning (5): wifi-scan, wifi-get-networks, wifi-network-exists, wifi-get-signal-strength, wifi-get-security-type
   - Connection (6): wifi-connect, wifi-connect-hidden, wifi-disconnect, wifi-is-connected, wifi-get-connected-ssid, wifi-get-connection-status
   - Known Networks (5): wifi-known-list, wifi-known-show, wifi-known-forget, wifi-known-forget-all, wifi-known-exists
   - AP Mode (3): wifi-ap-start, wifi-ap-stop, wifi-ap-is-active
   - Utility (8): wifi-signal-to-bars, wifi-signal-to-quality, wifi-cleanup, wifi-version, wifi-help, wifi-self-test, wifi-info, internal test suite

6. **Module Initialization** (L1571-1593)
   - Directory creation on load
   - Lifecycle cleanup registration
   - Load-time logging
   - Return success

### Integration Points

<!-- CONTEXT_GROUP: Integration -->

**_common Library** (Required → L44-49)
- `common-lib-cache-dir` - Get XDG cache directory
- `common-lib-state-dir` - Get XDG state directory
- `common-lib-config-dir` - Get XDG config directory
- `common-validate-required` - Parameter validation
- `common-command-exists` - Binary availability check

**_log Library** (Optional → L52-61)
- Structured debug logging (log-debug)
- Info messages (log-info)
- Warnings (log-warn)
- Errors (log-error)
- Fallback implementations if unavailable

**_events Library** (Optional → L64-68, L188-203)
- Event emission via `events-emit`
- Event names: `wifi.initialized`, `wifi.scan.start`, `wifi.connect.success`, etc.
- Allows real-time subscriptions to WiFi state changes

**_cache Library** (Optional → L71-75)
- Device list caching (30s TTL default)
- Scan result caching for performance
- Manual cache clearing support

**_lifecycle Library** (Optional → L78-82, L1579-1581)
- Automatic `wifi-cleanup` registration on load
- Resource cleanup on script exit
- Monitoring process termination

---

## Installation

<!-- CONTEXT_PRIORITY: HIGH -->

### Prerequisites and Requirements

<!-- CONTEXT_GROUP: Prerequisites -->

**System Requirements:**

1. **iwd (iNet Wireless Daemon)** - Modern WiFi daemon replacement for wpa_supplicant
   ```bash
   # Arch/Manjaro
   sudo pacman -S iwd

   # Debian/Ubuntu
   sudo apt install iwd

   # Verify installation
   iwctl --version
   ```

2. **systemd** - For service management (usually pre-installed)
   ```bash
   systemctl --version
   ```

**Library Dependencies:**

- **Required:** `_common` library (must be in PATH via stow)
  ```bash
  source "$(which _common)" || exit 1
  ```

- **Strongly Recommended:** `_log`, `_events`, `_lifecycle`
  ```bash
  # These enhance functionality but graceful fallbacks exist
  source "$(which _log)" 2>/dev/null || true
  source "$(which _events)" 2>/dev/null || true
  ```

- **Optional:** `_cache`, `_config`
  ```bash
  # Performance and advanced configuration
  ```

### Installation Steps

<!-- CONTEXT_GROUP: Setup -->

**Step 1: Verify iwd is Installed and Running**

```zsh
# Check iwd availability
which iwctl
iwctl --version

# Verify daemon is installed
systemctl status iwd 2>/dev/null || echo "iwd not found"
```

**Step 2: Load the Extension**

```zsh
# In your script or .zshrc
source "$(which _wifi)" || {
    echo "Error: _wifi library not found" >&2
    exit 1
}
```

**Step 3: Initialize on First Use**

```zsh
# Initialize the extension
if ! wifi-init; then
    echo "Failed to initialize WiFi extension" >&2
    exit 1
fi

# Now all functions are available
```

**Step 4: Verify Installation**

```zsh
# Run built-in self-test
wifi-self-test

# Check system information
wifi-info

# List devices
wifi-device-list
```

### iwd Service Configuration

<!-- CONTEXT_GROUP: Service Setup -->

**Enable and Start iwd Service:**

```bash
# Enable service at boot
sudo systemctl enable iwd.service

# Start service now
sudo systemctl start iwd.service

# Verify service is running
sudo systemctl status iwd.service

# View iwd logs
journalctl -u iwd -f
```

**NetworkManager Integration** (if using NetworkManager):

Edit `/etc/NetworkManager/NetworkManager.conf`:
```ini
[device]
# Use iwd as WiFi backend
wifi.backend=iwd

# Alternative: use wpa_supplicant (default)
# wifi.backend=wpa_supplicant
```

Then restart NetworkManager:
```bash
sudo systemctl restart NetworkManager.service
```

**Performance Tuning** (`/etc/iwd/main.conf`):

```ini
[General]
# Enable automatic network configuration (IP, DNS)
EnableNetworkConfiguration=true

# Enable IPv6 support
EnableIPv6=true

# Roaming thresholds (when to switch APs)
RoamThreshold=-70
RoamThreshold5G=-76

# Scan interval in seconds
ScanInterval=5
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->

### Example 1: Initialize and List Devices

<!-- CONTEXT_GROUP: Quick Examples -->

```zsh
#!/usr/bin/env zsh

# Load the extension
source "$(which _wifi)" || exit 1

# Initialize (required)
wifi-init || exit 1

# List all WiFi devices
echo "Available WiFi devices:"
wifi-device-list

# Show details of first device
device=$(wifi-device-get-default)
echo "Using device: $device"
wifi-device-show "$device"
```

### Example 2: Scan and Display Networks

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default) || {
    echo "No WiFi device found"
    exit 1
}

# Trigger scan
echo "Scanning for networks..."
wifi-scan "$device" || exit 1

# Display with signal bars
echo ""
echo "Available Networks (with signal strength):"
wifi-get-networks "$device" bars
```

### Example 3: Connect to Network

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)
ssid="MyNetwork"
password="MyPassword123"

# Check if network exists
if ! wifi-network-exists "$device" "$ssid"; then
    echo "Network '$ssid' not found. Scanning..."
    wifi-scan "$device"
fi

# Connect
echo "Connecting to $ssid..."
if wifi-connect "$device" "$ssid" "$password"; then
    echo "Successfully connected!"
    ssid=$(wifi-get-connected-ssid "$device")
    echo "Connected to: $ssid"
else
    echo "Connection failed"
    exit 1
fi
```

### Example 4: Check Connection Status

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)

# Check if connected
if wifi-is-connected "$device"; then
    ssid=$(wifi-get-connected-ssid "$device")
    echo "Connected to: $ssid"

    # Get signal strength in various formats
    signal_bars=$(wifi-get-signal-strength "$device" "$ssid" bars)
    signal_dbm=$(wifi-get-signal-strength "$device" "$ssid" dbms)
    signal_quality=$(wifi-get-signal-strength "$device" "$ssid" quality)

    echo "Signal: $signal_bars ($signal_dbm, $signal_quality)"
else
    echo "Not connected to any network"
fi
```

### Example 5: Manage Saved Networks

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

# List all saved networks
echo "Saved networks:"
wifi-known-list

echo ""
echo "Checking for specific network..."

if wifi-known-exists "HomeNetwork"; then
    echo "HomeNetwork is saved"
    wifi-known-show "HomeNetwork"
else
    echo "HomeNetwork is NOT saved"
fi

echo ""
echo "Removing old network..."
wifi-known-forget "OldNetwork" && echo "Forgotten OldNetwork"
```

### Example 6: Create WiFi Hotspot

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)
ssid="MyHotspot"
password="HotspotPassword123"

# Check if AP is already running
if wifi-ap-is-active "$device"; then
    echo "Access point already running, stopping..."
    wifi-ap-stop "$device"
    sleep 2
fi

# Disconnect from any network
if wifi-is-connected "$device"; then
    echo "Disconnecting from current network..."
    wifi-disconnect "$device"
    sleep 1
fi

# Start hotspot
echo "Starting access point..."
if wifi-ap-start "$device" "$ssid" "$password"; then
    echo "Hotspot started: $ssid"
    echo "Password: $password"
    echo "Configure IP manually:"
    echo "  sudo ip addr add 192.168.50.1/24 dev $device"
else
    echo "Failed to start access point"
    exit 1
fi
```

### Example 7: Monitor Signal Quality

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)

if ! wifi-is-connected "$device"; then
    echo "Not connected"
    exit 1
fi

ssid=$(wifi-get-connected-ssid "$device")
echo "Monitoring: $ssid"
echo ""

# Monitor loop
for i in {1..5}; do
    wifi-scan "$device" 2>/dev/null

    quality=$(wifi-get-signal-strength "$device" "$ssid" quality)
    bars=$(wifi-get-signal-strength "$device" "$ssid" bars)
    dbm=$(wifi-get-signal-strength "$device" "$ssid" dbms)

    printf "Sample %d: %s %-4s (%s)\n" "$i" "$bars" "$quality" "$dbm"

    [[ $i -lt 5 ]] && sleep 2
done
```

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: Configuration -->

### Environment Variables

All configuration is done via environment variables. Set before calling `wifi-init`.

**Behavior Control:**

```zsh
# Enable debug mode - logs all operations
export WIFI_DEBUG=true

# Disable events (if _events not available)
export WIFI_EMIT_EVENTS=false

# Disable caching (always query iwd)
export WIFI_CACHE_SCANS=false

# Dry-run mode - simulate without making changes
export WIFI_DRY_RUN=true

# Select signal format (bars, dbms, or quality)
export WIFI_SIGNAL_FORMAT=quality
```

**Timeout Configuration:**

```zsh
# Scan timeout in seconds
export WIFI_SCAN_TIMEOUT=5    # Faster scans
export WIFI_SCAN_TIMEOUT=15   # Allow more time

# Connection timeout
export WIFI_CONNECT_TIMEOUT=30
export WIFI_CONNECT_TIMEOUT=60
```

**Caching:**

```zsh
# Cache TTL (time-to-live) in seconds
export WIFI_CACHE_TTL=30    # 30 seconds (default)
export WIFI_CACHE_TTL=60    # 1 minute (longer cache)
export WIFI_CACHE_TTL=300   # 5 minutes (very long)
```

**Signal Thresholds** (in dBm):

```zsh
# Default thresholds for signal strength mapping
export WIFI_SIGNAL_EXCELLENT=-50    # >= -50 dBm
export WIFI_SIGNAL_GOOD=-60         # >= -60 dBm
export WIFI_SIGNAL_FAIR=-70         # >= -70 dBm
export WIFI_SIGNAL_POOR=-80         # >= -80 dBm

# More lenient thresholds for poor conditions
export WIFI_SIGNAL_EXCELLENT=-45
export WIFI_SIGNAL_GOOD=-55
export WIFI_SIGNAL_FAIR=-65
export WIFI_SIGNAL_POOR=-75
```

**Default Device:**

```zsh
# Let extension auto-detect (default)
unset WIFI_DEFAULT_DEVICE

# Force specific device
export WIFI_DEFAULT_DEVICE=wlan0
export WIFI_DEFAULT_DEVICE=wlp3s0
```

### Configuration Profiles

**Performance Profile** - Maximum speed, minimal overhead:

```zsh
export WIFI_DEBUG=false
export WIFI_EMIT_EVENTS=true
export WIFI_AUTO_SCAN=false        # Manual control
export WIFI_CACHE_SCANS=true       # Aggressive caching
export WIFI_CACHE_TTL=120          # 2-minute cache
export WIFI_SCAN_TIMEOUT=3         # Quick scans
export WIFI_SIGNAL_FORMAT=quality  # Percentage display
```

**Debugging Profile** - Troubleshooting and diagnostics:

```zsh
export WIFI_DEBUG=true             # Verbose logging
export WIFI_EMIT_EVENTS=true
export WIFI_AUTO_SCAN=true
export WIFI_CACHE_SCANS=false      # No caching
export WIFI_DRY_RUN=false
export WIFI_SCAN_TIMEOUT=10        # Allow time
```

**Testing Profile** - Safe testing without real changes:

```zsh
export WIFI_DEBUG=true
export WIFI_EMIT_EVENTS=true
export WIFI_AUTO_SCAN=false
export WIFI_CACHE_SCANS=false
export WIFI_DRY_RUN=true           # No real changes!
```

**Stable Profile** - Production use:

```zsh
export WIFI_DEBUG=false
export WIFI_EMIT_EVENTS=true
export WIFI_AUTO_SCAN=true
export WIFI_CACHE_SCANS=true
export WIFI_CACHE_TTL=60
export WIFI_DRY_RUN=false
```

### XDG Directory Structure

The extension uses XDG Base Directory specification:

```
~/.cache/lib/wifi/
  ├── device-list.cache      # Cached device list
  └── scan-results.cache     # Cached network scans

~/.local/state/lib/wifi/
  ├── connection.state       # Current connection info
  └── ap-mode.state          # AP mode status

~/.config/lib/wifi/
  ├── settings.conf          # User configuration
  └── profiles/              # Connection profiles
```

---

## API Reference

<!-- CONTEXT_PRIORITY: HIGH -->

### Initialization & Availability

<!-- CONTEXT_GROUP: API - Initialization -->

#### wifi-init

Initialize the WiFi extension, create required directories, verify daemon.

**Signature:**
```zsh
wifi-init
```

**Returns:**
- `0` - Successfully initialized (or already initialized)
- `1` - Failed (iwctl not found, iwd not running, dir creation failed)

**Events:**
- `wifi.initialized` - Emitted when initialization completes

**Side Effects:**
- Creates XDG directories (~/.cache/lib/wifi, ~/.local/state/lib/wifi, ~/.config/lib/wifi)
- Sets `WIFI_INITIALIZED=true`
- Verifies iwctl is available
- Logs system information

**Complexity:** O(1) - Constant time directory check and creation

**Example:**
```zsh
if wifi-init; then
    echo "WiFi extension ready"
else
    echo "Failed to initialize WiFi"
    exit 1
fi
```

**Implementation:** → L352-390

---

#### wifi-check-available

Non-fatal check for WiFi availability.

**Signature:**
```zsh
wifi-check-available
```

**Returns:**
- `0` - WiFi is available (iwctl found, iwd running)
- `1` - WiFi is not available

**Side Effects:** None - read-only check

**Complexity:** O(1) - Command existence check

**Example:**
```zsh
if wifi-check-available; then
    echo "WiFi is available"
    wifi-init
else
    echo "WiFi is not available"
    echo "Install iwd: sudo pacman -S iwd"
fi
```

**Implementation:** → L402-406

---

#### wifi-require-available

Assert that WiFi is available, log error and fail if not.

**Signature:**
```zsh
wifi-require-available
```

**Returns:**
- `0` - WiFi is available
- `1` - WiFi is not available (also logs error message)

**Side Effects:**
- Logs error message if WiFi unavailable
- Suggests remediation steps

**Complexity:** O(1) - Command existence and status check

**Usage Pattern:**
```zsh
# Use at function entry points to fail fast
wifi-require-available || return 1

# Or in scripts to exit immediately
wifi-require-available || exit 1
```

**Implementation:** → L416-423

---

### Device Management

<!-- CONTEXT_GROUP: API - Devices -->

#### wifi-device-list

List all available WiFi devices with caching.

**Signature:**
```zsh
wifi-device-list
```

**Output:** Device names, one per line (e.g., `wlan0`, `wlp3s0`)

**Returns:**
- `0` - Success
- `1` - Failed to list devices

**Cache:** Results cached for `WIFI_CACHE_TTL` seconds (30s default)

**Complexity:** O(n) where n = number of devices (cached result: O(1))

**Example:**
```zsh
# List all devices
echo "WiFi devices:"
wifi-device-list

# Iterate over devices
for device in $(wifi-device-list); do
    echo "Found: $device"
    wifi-device-show "$device"
done

# Get count of devices
num_devices=$(wifi-device-list | wc -l)
echo "Total devices: $num_devices"
```

**Output Example:**
```
wlan0
wlp3s0
```

**Implementation:** → L438-469

---

#### wifi-device-show

Show detailed information about a specific device.

**Signature:**
```zsh
wifi-device-show <device>
```

**Parameters:**
- `device` (string, required) - Device name (e.g., `wlan0`)

**Output:** Device information from iwctl (state, mode, scanning, powered)

**Returns:**
- `0` - Success
- `1` - Device query failed
- `2` - Invalid/missing device argument

**Complexity:** O(1) - Single device status query

**Example:**
```zsh
# Show device details
wifi-device-show wlan0

# Extract specific information
wifi-device-show wlan0 | grep "State"
wifi-device-show wlan0 | grep "Powered"

# Check if scanning
wifi-device-show wlan0 | grep -q "Scanning.*yes" && echo "Scanning..."
```

**Output Example:**
```
                        State                                       connected
                        Scanning                                    no
                        Mode                                        station
                        Powered                                     yes
                        Connected network                           HomeNetwork
```

**Implementation:** → L480-494

---

#### wifi-device-get-default

Get the default WiFi device (cached or first available).

**Signature:**
```zsh
wifi-device-get-default
```

**Output:** Device name

**Returns:**
- `0` - Success (prints device name)
- `1` - No device found

**Cache:** Uses `WIFI_DEFAULT_DEVICE` if set, otherwise first available

**Complexity:** O(1) - Returns cached or first device

**Example:**
```zsh
# Get default device
device=$(wifi-device-get-default) || {
    echo "No WiFi device found"
    exit 1
}

echo "Using device: $device"

# Use in operations
wifi-scan "$device"
wifi-connect "$device" "MyNetwork" "password"
```

**Implementation:** → L504-506

---

#### wifi-device-is-up

Check if a device is powered on and ready.

**Signature:**
```zsh
wifi-device-is-up <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - Device is powered on
- `1` - Device is powered off or doesn't exist

**Complexity:** O(1) - Single status check

**Example:**
```zsh
device=$(wifi-device-get-default)

if wifi-device-is-up "$device"; then
    echo "Device is ready"
else
    echo "Device is powered off"
    echo "Enable it via your hardware switch or:"
    echo "  rfkill unblock wifi"
fi
```

**Implementation:** → L519-531

---

### Network Scanning

<!-- CONTEXT_GROUP: API - Scanning -->

#### wifi-scan

Trigger a network scan on the specified device.

**Signature:**
```zsh
wifi-scan <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - Scan initiated successfully
- `1` - Scan failed
- `2` - Invalid/missing device

**Events:**
- `wifi.scan.start` - When scan starts
- `wifi.scan.complete` - When scan completes successfully
- `wifi.scan.failed` - When scan fails

**Dry-Run:** If `WIFI_DRY_RUN=true`, logs but doesn't scan

**Complexity:** O(1) - Initiates async scan

**Notes:**
- Scan results are retrieved with `wifi-get-networks`
- Waits ~1 second for scan hardware to complete
- Results may include hidden networks if they respond to probes

**Example:**
```zsh
# Scan and wait for completion
wifi-scan wlan0 || {
    echo "Scan failed"
    exit 1
}

# Now retrieve networks
echo "Available networks:"
wifi-get-networks wlan0 bars

# Continuous scanning
while true; do
    wifi-scan wlan0
    sleep 5
done
```

**Implementation:** → L550-581

---

#### wifi-get-networks

Get list of discovered networks with optional formatting.

**Signature:**
```zsh
wifi-get-networks <device> [format]
```

**Parameters:**
- `device` (string, required) - Device name
- `format` (string, optional) - Display format: `raw`, `bars`, `dbms` (default: `raw`)

**Output:** Network list in requested format

**Returns:**
- `0` - Success
- `1` - Failed to get networks
- `2` - Invalid device

**Complexity:** O(n) where n = number of visible networks

**Example:**
```zsh
# Raw iwctl output (default)
wifi-get-networks wlan0

# Formatted with signal bars
wifi-get-networks wlan0 bars
# Output: ****  psk        HomeNetwork
# Output: ***   open       FreeWiFi

# Formatted with dBm values
wifi-get-networks wlan0 dbms
# Output: -50    psk        HomeNetwork
# Output: -70    open       FreeWiFi

# Parse for specific network
wifi-get-networks wlan0 raw | grep "HomeNetwork"

# Count visible networks
network_count=$(wifi-get-networks wlan0 raw | awk 'NR>3 && NF>0' | wc -l)
echo "Found $network_count networks"
```

**Output Format Comparison:**

| Format | Output Example | Use Case |
|--------|----------------|----------|
| `raw` | (iwctl native) | Detailed parsing |
| `bars` | `**** psk MyNetwork` | User display |
| `dbms` | `-50 psk MyNetwork` | dBm analysis |

**Implementation:** → L593-647

---

#### wifi-network-exists

Check if a network is currently visible.

**Signature:**
```zsh
wifi-network-exists <device> <ssid>
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Network SSID to check

**Returns:**
- `0` - Network is visible
- `1` - Network not found

**Complexity:** O(n) - Linear search through networks

**Example:**
```zsh
device=$(wifi-device-get-default)

# Check before connecting
if wifi-network-exists "$device" "MyNetwork"; then
    echo "Network found, connecting..."
    wifi-connect "$device" "MyNetwork" "password"
else
    echo "Network not visible, scanning..."
    wifi-scan "$device"
    wifi-get-networks "$device" bars
fi
```

**Implementation:** → L661-673

---

#### wifi-get-signal-strength

Get signal strength for a specific network in various formats.

**Signature:**
```zsh
wifi-get-signal-strength <device> <ssid> [format]
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Network SSID
- `format` (string, optional) - Format: `bars`, `dbms`, `quality` (default: `bars`)

**Output:** Signal strength in requested format

**Returns:**
- `0` - Success
- `1` - Network not found

**Complexity:** O(n) - Linear search through networks

**Example:**
```zsh
device=$(wifi-device-get-default)
ssid="MyNetwork"

# As signal bars (visual representation)
bars=$(wifi-get-signal-strength "$device" "$ssid" bars)
echo "Signal: $bars"  # ****

# As dBm (technical measurement)
dbm=$(wifi-get-signal-strength "$device" "$ssid" dbms)
echo "Signal: $dbm"  # -55 dBm

# As quality percentage
quality=$(wifi-get-signal-strength "$device" "$ssid" quality)
echo "Quality: $quality"  # 90%

# Quality assessment
signal_bars=$(wifi-get-signal-strength "$device" "$ssid" bars)
case "$signal_bars" in
    ****) echo "Excellent signal" ;;
    ***) echo "Good signal" ;;
    **) echo "Fair signal" ;;
    *) echo "Poor signal" ;;
    -) echo "Very weak signal" ;;
esac
```

**Signal Mapping:**
- `****` = Excellent (≥ -50 dBm)
- `***` = Good (≥ -60 dBm)
- `**` = Fair (≥ -70 dBm)
- `*` = Poor (≥ -80 dBm)
- `-` = Very poor (< -80 dBm)

**Implementation:** → L686-706

---

#### wifi-get-security-type

Get security type for a specific network.

**Signature:**
```zsh
wifi-get-security-type <device> <ssid>
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Network SSID

**Output:** Security type code

**Returns:**
- `0` - Success
- `1` - Network not found

**Complexity:** O(n) - Linear search through networks

**Security Types:**
- `open` - No security, anyone can connect
- `psk` - Pre-shared key (WPA/WPA2 personal)
- `8021x` - 802.1X (WPA enterprise, RADIUS)

**Example:**
```zsh
device=$(wifi-device-get-default)

# Check security before connecting
security=$(wifi-get-security-type "$device" "MyNetwork")

case "$security" in
    open)
        echo "Network is open - no password needed"
        wifi-connect "$device" "MyNetwork"
        ;;
    psk)
        echo "Network requires password (WPA/WPA2)"
        read -s "password?Enter password: "
        wifi-connect "$device" "MyNetwork" "$password"
        ;;
    8021x)
        echo "Network requires enterprise authentication"
        echo "Use your university/corporate credentials"
        ;;
esac
```

**Implementation:** → L718-737

---

### Connection Management

<!-- CONTEXT_GROUP: API - Connection -->

#### wifi-connect

Connect to a WiFi network with optional password.

**Signature:**
```zsh
wifi-connect <device> <ssid> [passphrase]
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Network SSID
- `passphrase` (string, optional) - Network password

**Returns:**
- `0` - Successfully connected
- `1` - Connection failed
- `2` - Invalid arguments

**Events:**
- `wifi.connect.start` - When connection initiated
- `wifi.connect.success` - When connection succeeds
- `wifi.connect.failed` - When connection fails

**Side Effects:**
- Credentials automatically saved to `/var/lib/iwd/*.psk`
- Network will auto-reconnect if available in future

**Complexity:** O(1) - Command execution (waits for iwd)

**Example:**
```zsh
device=$(wifi-device-get-default)

# Connect to encrypted network
if wifi-connect "$device" "MyNetwork" "mypassword123"; then
    echo "Connected successfully!"
else
    echo "Connection failed - check password"
    exit 1
fi

# Connect to open network
wifi-connect "$device" "FreeWiFi"

# Verify connection
if wifi-is-connected "$device"; then
    ssid=$(wifi-get-connected-ssid "$device")
    echo "Now connected to: $ssid"
fi
```

**Common Failures:**
- Wrong password → connection fails silently
- Network not visible → timeout
- Device off → fails immediately

**Implementation:** → L759-799

---

#### wifi-connect-hidden

Connect to a hidden WiFi network (doesn't broadcast SSID).

**Signature:**
```zsh
wifi-connect-hidden <device> <ssid> [passphrase]
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Network SSID (must be exact)
- `passphrase` (string, optional) - Network password

**Returns:**
- `0` - Successfully connected
- `1` - Connection failed
- `2` - Invalid arguments

**Events:**
- `wifi.connect.start` - With `hidden=true` flag
- `wifi.connect.success` - When connected
- `wifi.connect.failed` - When failed

**Example:**
```zsh
device=$(wifi-device-get-default)

# Connect to hidden network (SSID not shown in scan)
if wifi-connect-hidden "$device" "SecretNetwork" "password123"; then
    echo "Connected to hidden network"
else
    echo "Failed to connect to hidden network"
fi

# Note: network won't appear in wifi-get-networks results
# but after connecting, it will appear in known networks
wifi-known-exists "SecretNetwork" && echo "Network is now saved"
```

**Implementation:** → L812-845

---

#### wifi-disconnect

Disconnect from the currently connected network.

**Signature:**
```zsh
wifi-disconnect <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - Successfully disconnected
- `1` - Disconnect failed
- `2` - Invalid device

**Events:**
- `wifi.disconnect` - When disconnected

**Side Effects:**
- Clears active connection tracking
- Device available for new connections

**Complexity:** O(1) - Single command

**Example:**
```zsh
device=$(wifi-device-get-default)

# Disconnect from current network
if wifi-disconnect "$device"; then
    echo "Disconnected"
else
    echo "Disconnect failed"
fi

# Verify disconnection
if ! wifi-is-connected "$device"; then
    echo "Not connected"
fi
```

**Implementation:** → L858-884

---

#### wifi-is-connected

Check if device is currently connected to a network.

**Signature:**
```zsh
wifi-is-connected <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - Device is connected
- `1` - Device is not connected

**Complexity:** O(1) - Status query

**Example:**
```zsh
device=$(wifi-device-get-default)

if wifi-is-connected "$device"; then
    echo "Connected"
    ssid=$(wifi-get-connected-ssid "$device")
    echo "SSID: $ssid"
else
    echo "Not connected"
fi

# Use in conditionals
wifi-is-connected "$device" && echo "Online" || echo "Offline"
```

**Implementation:** → L897-909

---

#### wifi-get-connected-ssid

Get the SSID of the currently connected network.

**Signature:**
```zsh
wifi-get-connected-ssid <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Output:** SSID of connected network

**Returns:**
- `0` - Success
- `1` - Not connected or query failed

**Complexity:** O(1) - Single status field extraction

**Example:**
```zsh
device=$(wifi-device-get-default)

# Get connected network name
ssid=$(wifi-get-connected-ssid "$device") || {
    echo "Not connected"
    exit 1
}

echo "Connected to: $ssid"

# Use in conditionals
current=$(wifi-get-connected-ssid "$device")
if [[ "$current" == "MyNetwork" ]]; then
    echo "On home network"
fi
```

**Implementation:** → L920-939

---

#### wifi-get-connection-status

Get comprehensive connection status information.

**Signature:**
```zsh
wifi-get-connection-status <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Output:** Detailed status information

**Returns:**
- `0` - Success
- `1` - Query failed

**Complexity:** O(1) - Device status query

**Notes:**
- Alias for `wifi-device-show`
- Shows state, mode, scanning, power, connected network

**Example:**
```zsh
device=$(wifi-device-get-default)

echo "Connection status for $device:"
wifi-get-connection-status "$device"
```

**Implementation:** → L950-957

---

### Saved Networks

<!-- CONTEXT_GROUP: API - Known Networks -->

#### wifi-known-list

List all saved network credentials.

**Signature:**
```zsh
wifi-known-list
```

**Output:** List of saved network SSIDs

**Returns:**
- `0` - Success
- `1` - Failed to list

**Complexity:** O(n) - List file enumeration

**Example:**
```zsh
# List all saved networks
echo "Saved networks:"
wifi-known-list

# Count saved networks
count=$(wifi-known-list | awk 'NR>3' | wc -l)
echo "Total saved: $count"

# Get first saved network
first=$(wifi-known-list | awk 'NR>3 && NF>0 {print $1; exit}')
echo "First network: $first"
```

**Output Example:**
```
Network name                Security  Last connected
─────────────────────────────────────────────────────
HomeNetwork                 psk       2025-11-07
CafeWiFi                    open      2025-11-05
OfficeNetwork               psk       2025-11-01
```

**Implementation:** → L971-978

---

#### wifi-known-show

Show details of a specific saved network.

**Signature:**
```zsh
wifi-known-show <ssid>
```

**Parameters:**
- `ssid` (string, required) - Network SSID

**Output:** Network details

**Returns:**
- `0` - Success
- `1` - Network not found or query failed
- `2` - Invalid SSID

**Complexity:** O(1) - Direct configuration file access

**Example:**
```zsh
# Show network details
wifi-known-show "HomeNetwork"

# Extract specific information
wifi-known-show "HomeNetwork" | grep "Auto"

# Check if auto-connect is enabled
wifi-known-show "HomeNetwork" | grep -q "Auto-connect.*yes" && \
    echo "Will auto-connect"
```

**Output Example:**
```
Network name                HomeNetwork
Hidden                      no
State                       connected
Frequency                   2.4 GHz / 5 GHz
Last connected              2025-11-07
Auto-connect                yes
```

**Implementation:** → L989-999

---

#### wifi-known-forget

Remove a saved network (forget credentials).

**Signature:**
```zsh
wifi-known-forget <ssid>
```

**Parameters:**
- `ssid` (string, required) - Network SSID

**Returns:**
- `0` - Successfully forgotten
- `1` - Failed
- `2` - Invalid SSID

**Events:**
- `wifi.known.forgotten` - When network removed

**Dry-Run:** If `WIFI_DRY_RUN=true`, simulates removal

**Side Effects:**
- Removes `/var/lib/iwd/SSID.psk` file
- Device will not auto-connect to this network
- Credentials must be re-entered to reconnect

**Complexity:** O(1) - File deletion

**Example:**
```zsh
# Remove saved network
if wifi-known-forget "OldNetwork"; then
    echo "Network forgotten"
fi

# Verify it's gone
if ! wifi-known-exists "OldNetwork"; then
    echo "Successfully removed"
fi

# Safe removal with confirmation
read "confirm?Forget network? (y/n): "
[[ "$confirm" == "y" ]] && wifi-known-forget "NetworkName"
```

**Implementation:** → L1012-1033

---

#### wifi-known-forget-all

Remove ALL saved networks (destructive operation).

**Signature:**
```zsh
wifi-known-forget-all
```

**Returns:**
- `0` - All networks forgotten
- `1` - Some networks failed to forget

**Warning:** This removes ALL network credentials. Use with caution!

**Dry-Run:** Highly recommended: `WIFI_DRY_RUN=true wifi-known-forget-all`

**Side Effects:**
- Deletes all files in `/var/lib/iwd/`
- Device won't auto-connect to any saved network

**Complexity:** O(n) - Iterates and deletes all networks

**Example:**
```zsh
# Dry-run first to see what would be deleted
WIFI_DRY_RUN=true wifi-known-forget-all

# If output looks correct, do the real thing
wifi-known-forget-all && echo "All networks forgotten"

# Alternative: individual network removal
for network in $(wifi-known-list | awk 'NR>3 {print $1}'); do
    wifi-known-forget "$network"
done
```

**Implementation:** → L1043-1072

---

#### wifi-known-exists

Check if a network is in saved credentials.

**Signature:**
```zsh
wifi-known-exists <ssid>
```

**Parameters:**
- `ssid` (string, required) - Network SSID

**Returns:**
- `0` - Network is saved
- `1` - Network is not saved

**Complexity:** O(n) - Linear search through known networks

**Example:**
```zsh
# Check if network is saved
if wifi-known-exists "HomeNetwork"; then
    echo "HomeNetwork credentials are saved"
fi

# Conditional action
if ! wifi-known-exists "MyNetwork"; then
    echo "Need to enter password"
    wifi-connect wlan0 "MyNetwork" "password"
fi

# Find which networks are known
for network in $(wifi-get-networks wlan0 raw | awk '{print $(NF-1)}'); do
    wifi-known-exists "$network" && echo "$network is known"
done
```

**Implementation:** → L1085-1096

---

### Access Point Mode

<!-- CONTEXT_GROUP: API - AP Mode -->

#### wifi-ap-start

Start WiFi hotspot (Access Point mode).

**Signature:**
```zsh
wifi-ap-start <device> <ssid> [passphrase]
```

**Parameters:**
- `device` (string, required) - Device name
- `ssid` (string, required) - Hotspot network name
- `passphrase` (string, optional) - Hotspot password (open if omitted)

**Returns:**
- `0` - AP started successfully
- `1` - Failed to start
- `2` - Invalid arguments

**Events:**
- `wifi.ap.started` - When AP starts

**Requirements:**
- Device must support AP mode (check: `iw list | grep "AP"`)
- Cannot run simultaneously with station mode on same device
- IP/DHCP must be configured separately

**Example:**
```zsh
device=$(wifi-device-get-default)

# Start password-protected hotspot
if wifi-ap-start "$device" "MyHotspot" "SecurePassword123"; then
    echo "Hotspot started"
    echo "Connect with SSID: MyHotspot"
    echo "Password: SecurePassword123"
fi

# Start open (no password) hotspot
wifi-ap-start "$device" "PublicWiFi"

# Full setup with IP/DHCP
wifi-ap-start "$device" "MyHotspot" "password" && {
    sudo ip addr add 192.168.50.1/24 dev "$device"
    sudo dnsmasq -i "$device" --dhcp-range=192.168.50.10,192.168.50.100
}
```

**Implementation:** → L1115-1145

---

#### wifi-ap-stop

Stop WiFi hotspot (exit Access Point mode).

**Signature:**
```zsh
wifi-ap-stop <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - AP stopped successfully
- `1` - Failed to stop
- `2` - Invalid device

**Events:**
- `wifi.ap.stopped` - When AP stops

**Side Effects:**
- Stops accepting connections
- Disables DHCP if running
- Device available for station mode

**Example:**
```zsh
device=$(wifi-device-get-default)

# Stop hotspot
if wifi-ap-stop "$device"; then
    echo "Hotspot stopped"
fi

# Clean up IP address
sudo ip addr del 192.168.50.1/24 dev "$device" 2>/dev/null

# Kill dnsmasq if running
sudo killall dnsmasq 2>/dev/null
```

**Implementation:** → L1158-1178

---

#### wifi-ap-is-active

Check if Access Point mode is currently active.

**Signature:**
```zsh
wifi-ap-is-active <device>
```

**Parameters:**
- `device` (string, required) - Device name

**Returns:**
- `0` - AP is active
- `1` - AP is not active

**Complexity:** O(1) - Status query

**Example:**
```zsh
device=$(wifi-device-get-default)

if wifi-ap-is-active "$device"; then
    echo "Hotspot is running"
    echo "Stop with: wifi-ap-stop $device"
else
    echo "Hotspot is not running"
fi

# Use in loops
while wifi-ap-is-active "$device"; do
    echo "AP still running..."
    sleep 1
done
```

**Implementation:** → L1192-1203

---

### Utility Functions

<!-- CONTEXT_GROUP: API - Utility -->

#### wifi-signal-to-bars

Convert RSSI (dBm) signal strength to visual bars.

**Signature:**
```zsh
wifi-signal-to-bars <rssi>
```

**Parameters:**
- `rssi` (number, required) - Signal strength in dBm (e.g., -65)

**Output:** Signal bars: `****`, `***`, `**`, `*`, or `-`

**Returns:** Always 0 (success)

**Complexity:** O(1) - Simple numeric comparison

**Signal Mapping:**
- `****` = Excellent (≥ -50 dBm, ~90-100% strength)
- `***` = Good (≥ -60 dBm, ~70-90%)
- `**` = Fair (≥ -70 dBm, ~50-70%)
- `*` = Poor (≥ -80 dBm, ~30-50%)
- `-` = Very poor (< -80 dBm, <30%)

**Example:**
```zsh
# Convert dBm to bars
bars=$(wifi-signal-to-bars -55)
echo "Signal: $bars"  # ****

bars=$(wifi-signal-to-bars -75)
echo "Signal: $bars"  # **

bars=$(wifi-signal-to-bars -90)
echo "Signal: $bars"  # -

# Use for display
for rssi in -50 -60 -70 -80 -100; do
    bars=$(wifi-signal-to-bars "$rssi")
    printf "RSSI %4d dBm: %s\n" "$rssi" "$bars"
done
```

**Thresholds Customization:**
```zsh
# Adjust thresholds for your environment
export WIFI_SIGNAL_EXCELLENT=-45
export WIFI_SIGNAL_GOOD=-55
export WIFI_SIGNAL_FAIR=-65
export WIFI_SIGNAL_POOR=-75

bars=$(wifi-signal-to-bars -60)
# Now uses your custom thresholds
```

**Implementation:** → L1217-1231

---

#### wifi-signal-to-quality

Convert RSSI (dBm) to quality percentage (0-100%).

**Signature:**
```zsh
wifi-signal-to-quality <rssi>
```

**Parameters:**
- `rssi` (number, required) - Signal strength in dBm

**Output:** Quality percentage (0-100%)

**Returns:** Always 0 (success)

**Formula:** `quality = 2 * (dBm + 100)`, clamped to 0-100

**Range:**
- `-50 dBm` = 100% (perfect signal)
- `-75 dBm` = 50% (moderate signal)
- `-100 dBm` = 0% (no signal)

**Complexity:** O(1) - Arithmetic calculation

**Example:**
```zsh
# Convert dBm to percentage
quality=$(wifi-signal-to-quality -50)
echo "Quality: $quality"  # 100%

quality=$(wifi-signal-to-quality -75)
echo "Quality: $quality"  # 50%

quality=$(wifi-signal-to-quality -100)
echo "Quality: $quality"  # 0%

# Use in progress bar
quality=$(wifi-signal-to-quality -65)
percentage="${quality%\%}"  # Remove % sign
bar_length=$((percentage / 10))
bar=$(printf '%0.s#' {1..$bar_length})
printf "[%-10s] %s\n" "$bar" "$quality"
```

**Implementation:** → L1241-1255

---

#### wifi-cleanup

Clean up resources and stop monitoring.

**Signature:**
```zsh
wifi-cleanup
```

**Returns:** Always 0

**Side Effects:**
- Kills monitoring processes if running
- Clears active connection tracking
- Clears event callback registrations
- Logs cleanup completion

**Notes:**
- Automatically registered with _lifecycle if available
- Called automatically on script exit
- Safe to call multiple times

**Complexity:** O(1) - Process cleanup

**Example:**
```zsh
# Manual cleanup (rarely needed)
wifi-cleanup

# Usually handled automatically, but can force:
trap "wifi-cleanup; exit" INT TERM

while true; do
    wifi-scan wlan0
    sleep 5
done
```

**Implementation:** → L1263-1278

---

#### wifi-version

Print the WiFi extension version.

**Signature:**
```zsh
wifi-version
```

**Output:** Version string (e.g., `1.0.0`)

**Returns:** Always 0

**Example:**
```zsh
echo "WiFi extension version: $(wifi-version)"

# Use in version checking
version=$(wifi-version)
[[ "$version" == "1.0.0" ]] && echo "v2.0 features available"
```

**Implementation:** → L1286-1288

---

#### wifi-help

Display comprehensive help information.

**Signature:**
```zsh
wifi-help
```

**Output:** Multi-section help text (150+ lines)

**Returns:** Always 0

**Sections:**
- Description
- Dependencies
- Integration status
- All function categories
- Configuration options
- Events list
- Example commands

**Example:**
```zsh
# Display help
wifi-help

# Pipe to less for navigation
wifi-help | less

# Search for specific function
wifi-help | grep "wifi-connect"
```

**Implementation:** → L1290-1405

---

#### wifi-self-test

Run built-in validation tests.

**Signature:**
```zsh
wifi-self-test
```

**Returns:**
- `0` - All tests passed
- `1` - Some tests failed

**Tests Performed:**
1. iwctl command availability
2. iwd daemon running status
3. Device listing capability
4. Signal conversion accuracy
5. Directory initialization
6. Integration status verification

**Output:** Test results with pass/fail indicators

**Example:**
```zsh
# Run self-test
if wifi-self-test; then
    echo "WiFi extension is fully functional"
else
    echo "Some issues found - check output above"
fi

# Run with debug output
WIFI_DEBUG=true wifi-self-test
```

**Implementation:** → L1407-1505

---

#### wifi-info

Display comprehensive system and configuration information.

**Signature:**
```zsh
wifi-info
```

**Output:** Multi-section information (50+ lines)

**Returns:** Always 0

**Sections:**
- Version and initialization status
- System tool availability
- Integration status
- Configuration values
- Directory paths
- Signal thresholds
- Active devices
- Monitoring status
- Event callbacks

**Example:**
```zsh
# Display full system info
wifi-info

# Check specific integration
wifi-info | grep "Logging"

# Verify installation
wifi-info | grep -E "(version|initialized)"
```

**Implementation:** → L1507-1569

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->

### Pattern 1: Auto-Connect to Best Known Network

<!-- CONTEXT_GROUP: Advanced -->

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
source "$(which _events)" 2>/dev/null || true

wifi-init || exit 1

device=$(wifi-device-get-default) || exit 1

# Check if already connected to preferred network
current=$(wifi-get-connected-ssid "$device" 2>/dev/null)
if [[ -n "$current" ]]; then
    echo "Already connected to $current"
    exit 0
fi

# Get list of known networks
echo "Scanning for known networks..."
wifi-scan "$device"

best_ssid=""
best_signal=-999

# Find best available known network
wifi-get-networks "$device" raw | awk 'NR>3 && NF>0' | while read -r line; do
    signal=$(echo "$line" | awk '{print $NF}')
    ssid=$(echo "$line" | awk '{$NF=""; $(NF-1)=""; print $0}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Check if network is known
    if wifi-known-exists "$ssid"; then
        # Convert signal to approximate dBm for comparison
        case "$signal" in
            ****) signal_dbm=-50 ;;
            \*\*\*) signal_dbm=-60 ;;
            \*\*) signal_dbm=-70 ;;
            \*) signal_dbm=-80 ;;
            *) signal_dbm=-90 ;;
        esac

        if [[ $signal_dbm -gt $best_signal ]]; then
            best_signal=$signal_dbm
            best_ssid="$ssid"
        fi
    fi
done

if [[ -n "$best_ssid" ]]; then
    echo "Connecting to best network: $best_ssid"
    wifi-connect "$device" "$best_ssid" || exit 1
    echo "Connected successfully"
else
    echo "No known networks available"
    exit 1
fi
```

### Pattern 2: Network Quality Monitor with Logging

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
source "$(which _log)" 2>/dev/null || true

wifi-init || exit 1

device=$(wifi-device-get-default)
LOG_FILE="$HOME/wifi-monitor.log"

echo "Monitoring network quality..." >&2
echo "Logging to: $LOG_FILE" >&2

# Monitor loop
while true; do
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    if wifi-is-connected "$device"; then
        ssid=$(wifi-get-connected-ssid "$device")
        quality=$(wifi-get-signal-strength "$device" "$ssid" quality 2>/dev/null || echo "N/A")
        bars=$(wifi-get-signal-strength "$device" "$ssid" bars 2>/dev/null || echo "?")
        dbm=$(wifi-get-signal-strength "$device" "$ssid" dbms 2>/dev/null || echo "? dBm")

        status="Connected to $ssid"
    else
        quality="N/A"
        bars="?"
        dbm="N/A"
        status="Disconnected"
    fi

    log-entry="$timestamp | $bars | $quality | $dbm | $status"
    echo "$log-entry"
    echo "$log-entry" >> "$LOG_FILE"

    sleep 10
done
```

### Pattern 3: Event-Driven Connection Manager

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
source "$(which _events)" || exit 1

# Define handlers
on_connect_success() {
    local device="$1"
    local ssid="$2"
    echo "Connected to: $ssid"
    notify-send "WiFi" "Connected to $ssid" 2>/dev/null
}

on_connect_failed() {
    local device="$1"
    local ssid="$2"
    echo "Failed to connect to: $ssid"
    notify-send "WiFi" "Failed to connect to $ssid" -u critical 2>/dev/null
}

on_disconnect() {
    local device="$1"
    echo "Disconnected"
    notify-send "WiFi" "Disconnected" -u normal 2>/dev/null
}

# Subscribe to events
events-on "wifi.connect.success" on_connect_success
events-on "wifi.connect.failed" on_connect_failed
events-on "wifi.disconnect" on_disconnect

# Initialize
wifi-init || exit 1
device=$(wifi-device-get-default)

# Connection attempts will trigger events
echo "Attempting connection..."
wifi-scan "$device"
wifi-connect "$device" "MyNetwork" "password"

# Keep running to process events
sleep 30
```

### Pattern 4: Hotspot Control Script

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1

SSID="${1:-MyHotspot}"
PASSWORD="${2:-Secure123}"
DEVICE=$(wifi-device-get-default)

usage() {
    echo "Usage: $0 [start|stop|status] [ssid] [password]"
    echo "Example: $0 start MyHotspot SecurePass123"
}

case "${1:-status}" in
    start)
        echo "Starting hotspot: $SSID"

        # Disconnect from any network
        wifi-is-connected "$DEVICE" && wifi-disconnect "$DEVICE"
        sleep 1

        # Start AP
        if wifi-ap-start "$DEVICE" "$SSID" "$PASSWORD"; then
            echo "Hotspot started"
            echo "Configuring IP..."
            sudo ip addr add 192.168.50.1/24 dev "$DEVICE" 2>/dev/null
            echo "Configure DHCP: sudo dnsmasq -i $DEVICE ..."
        else
            echo "Failed to start hotspot"
            exit 1
        fi
        ;;

    stop)
        echo "Stopping hotspot..."
        if wifi-ap-stop "$DEVICE"; then
            echo "Hotspot stopped"
            sudo ip addr del 192.168.50.1/24 dev "$DEVICE" 2>/dev/null
            sudo killall dnsmasq 2>/dev/null
        else
            echo "Failed to stop hotspot"
            exit 1
        fi
        ;;

    status)
        if wifi-ap-is-active "$DEVICE"; then
            echo "Hotspot is active on $DEVICE"
        else
            echo "Hotspot is inactive"
        fi
        ;;

    *)
        usage
        exit 1
        ;;
esac
```

### Pattern 5: Roaming Between Networks

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1

device=$(wifi-device-get-default)

# Preferred network list (in priority order)
declare -a PREFERRED_NETWORKS=(
    "HomeNetwork"
    "CafeWiFi"
    "OfficeNetwork"
)

# Minimum acceptable signal strength
MIN_SIGNAL=-75

echo "WiFi Roaming Manager"
echo "===================="

while true; do
    # Current connection
    current=$(wifi-get-connected-ssid "$device" 2>/dev/null)
    current_signal=$(wifi-get-signal-strength "$device" "$current" dbms 2>/dev/null || echo "-999")
    current_signal="${current_signal% dBm}"  # Remove " dBm" suffix

    # Check for better network
    wifi-scan "$device" 2>/dev/null

    best_network=""
    best_signal=-999

    for preferred in "${PREFERRED_NETWORKS[@]}"; do
        if wifi-network-exists "$device" "$preferred"; then
            signal=$(wifi-get-signal-strength "$device" "$preferred" dbms 2>/dev/null || echo "-999")
            signal="${signal% dBm}"

            if [[ $signal -gt $best_signal ]] && [[ $signal -gt $MIN_SIGNAL ]]; then
                best_signal=$signal
                best_network="$preferred"
            fi
        fi
    done

    # Roam if better network found
    if [[ -n "$best_network" ]] && [[ "$best_network" != "$current" ]]; then
        echo "$(date '+%H:%M:%S') - Roaming to $best_network (signal: $best_signal dBm)"
        wifi-connect "$device" "$best_network"
    fi

    sleep 30
done
```

### Pattern 6: Dry-Run Testing

```zsh
#!/usr/bin/env zsh

# Enable dry-run mode for safe testing
export WIFI_DRY_RUN=true
export WIFI_DEBUG=true

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)

echo "=== DRY RUN MODE - No changes will be made ==="
echo ""

# Safe to test all operations
echo "Testing: Connect to network"
wifi-connect "$device" "TestNetwork" "testpass"

echo ""
echo "Testing: Forget network"
wifi-known-forget "OldNetwork"

echo ""
echo "Testing: Forget all networks"
wifi-known-forget-all

echo ""
echo "Testing: Start hotspot"
wifi-ap-start "$device" "TestHotspot" "pass123"

echo ""
echo "Testing: Stop hotspot"
wifi-ap-stop "$device"

echo ""
echo "=== End DRY RUN - All operations were simulated ==="
```

### Pattern 7: Batch Network Operations

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)

# Batch forget multiple networks
forget_networks() {
    local networks=("$@")
    for network in "${networks[@]}"; do
        if wifi-known-exists "$network"; then
            echo "Forgetting: $network"
            wifi-known-forget "$network"
        fi
    done
}

# Batch connect attempts (stop at first success)
connect_to_any() {
    local networks=("$@")
    local passwords=("$@")  # Or provide separately

    for network in "${networks[@]}"; do
        if wifi-network-exists "$device" "$network"; then
            echo "Attempting: $network"
            if wifi-connect "$device" "$network" "${passwords[$network]}" 2>/dev/null; then
                echo "Connected to $network"
                return 0
            fi
        fi
    done

    return 1
}

# Usage
forget_networks "OldNetwork1" "OldNetwork2" "OldNetwork3"
connect_to_any "Network1" "Network2" "Network3"
```

### Pattern 8: Signal Quality Analysis

```zsh
#!/usr/bin/env zsh

source "$(which _wifi)" || exit 1
wifi-init || exit 1

device=$(wifi-device-get-default)
ssid="${1:-}"

if [[ -z "$ssid" ]]; then
    if ! wifi-is-connected "$device"; then
        echo "Not connected, and no SSID specified"
        exit 1
    fi
    ssid=$(wifi-get-connected-ssid "$device")
fi

echo "Signal Analysis for: $ssid"
echo "=============================="
echo ""

# Collect signal samples
declare -a samples
for i in {1..10}; do
    wifi-scan "$device" 2>/dev/null
    quality=$(wifi-get-signal-strength "$device" "$ssid" quality 2>/dev/null || echo "0%")
    samples+=("${quality%\%}")
    printf "Sample %2d: %s\n" "$i" "$quality"
    [[ $i -lt 10 ]] && sleep 1
done

# Calculate statistics
sum=0
min=${samples[0]}
max=${samples[0]}

for sample in "${samples[@]}"; do
    ((sum += sample))
    [[ $sample -lt $min ]] && min=$sample
    [[ $sample -gt $max ]] && max=$sample
done

avg=$((sum / ${#samples[@]}))

echo ""
echo "Statistics:"
echo "  Average: $avg%"
echo "  Minimum: $min%"
echo "  Maximum: $max%"
echo "  Samples: ${#samples[@]}"
```

---

## Best Practices

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: Best Practices -->

### 1. Always Initialize Before Use

```zsh
source "$(which _wifi)" || exit 1

# MUST call wifi-init before other functions
if ! wifi-init; then
    echo "WiFi not available"
    exit 1
fi

# Now safe to use other functions
device=$(wifi-device-get-default)
```

### 2. Use Default Device Pattern

```zsh
# BAD: Hardcoded device
wifi-scan wlan0

# GOOD: Auto-detect device
device=$(wifi-device-get-default) || {
    echo "No WiFi device found"
    exit 1
}
wifi-scan "$device"

# Or set once and reuse
export WIFI_DEFAULT_DEVICE=wlan0
```

### 3. Always Check Return Codes

```zsh
# BAD: Ignores failures
wifi-connect "$device" "Network" "password"
echo "Connection initiated"

# GOOD: Checks return code
if wifi-connect "$device" "Network" "password"; then
    echo "Connected successfully"
else
    echo "Connection failed"
    exit 1
fi
```

### 4. Use Dry-Run for Testing

```zsh
# BAD: Direct testing on real network
wifi-connect "$device" "Network" "password"

# GOOD: Dry-run first
export WIFI_DRY_RUN=true
wifi-connect "$device" "Network" "password"  # No actual change
unset WIFI_DRY_RUN
```

### 5. Cache Results When Appropriate

```zsh
# BAD: Multiple scans (slow)
device=$(wifi-device-get-default)
for i in {1..5}; do
    networks=$(wifi-get-networks "$device" raw)
done

# GOOD: Cache the result
export WIFI_CACHE_SCANS=true
export WIFI_CACHE_TTL=60
networks=$(wifi-get-networks "$device" raw)
# Subsequent calls within 60s use cached data
```

### 6. Enable Debug When Troubleshooting

```zsh
# BAD: Silent failures
wifi-scan "$device"

# GOOD: Debug output
export WIFI_DEBUG=true
wifi-scan "$device"  # Shows what's happening
```

### 7. Validate Network Existence Before Connecting

```zsh
# BAD: Try to connect blindly
wifi-connect "$device" "SomeNetwork" "password"

# GOOD: Check first
if wifi-network-exists "$device" "SomeNetwork"; then
    wifi-connect "$device" "SomeNetwork" "password"
else
    echo "Network not visible, scanning..."
    wifi-scan "$device"
fi
```

### 8. Use Signal Strength Appropriately

```zsh
# Signal strength formats for different uses
wifi-get-signal-strength "$device" "$ssid" bars      # User display
wifi-get-signal-strength "$device" "$ssid" dbms      # Technical analysis
wifi-get-signal-strength "$device" "$ssid" quality   # Percentage form

# Choose based on use case
# - bars: Best for UI (visual representation)
# - dbms: Best for troubleshooting (precise measurement)
# - quality: Best for metrics (0-100% scale)
```

### 9. Handle Hidden Networks Correctly

```zsh
# Hidden networks won't appear in scan
wifi-get-networks "$device" raw | grep -q "HiddenNetwork"  # Always fails

# Use connect-hidden instead
wifi-connect-hidden "$device" "HiddenNetwork" "password"

# After connecting, it's saved
wifi-known-exists "HiddenNetwork" && echo "Now in known networks"
```

### 10. Clean Up Resources Properly

```zsh
# BAD: Leave resources open
wifi-init
# ... do work ...
# Script exits - resources may not clean up

# GOOD: Register cleanup
source "$(which _wifi)" || exit 1
wifi-init || exit 1

# Cleanup automatically registered with _lifecycle
# Or manually call:
trap "wifi-cleanup; exit" INT TERM EXIT

# ... do work ...
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: Troubleshooting -->

### Issue 1: iwctl Command Not Found

**Symptoms:**
```
Error: _common library not found
Error: iwctl command not found
```

**Root Cause:** iwd package not installed

**Solution:**
```bash
# Install iwd package
sudo pacman -S iwd          # Arch/Manjaro
sudo apt install iwd        # Debian/Ubuntu
sudo dnf install iwd        # Fedora

# Verify installation
iwctl --version
```

**Verification:**
```zsh
which iwctl  # Should show path
wifi-self-test  # Should pass iwctl check
```

### Issue 2: iwd Daemon Not Running

**Symptoms:**
```
Warning: iwd daemon is not running
Failed to list devices
```

**Root Cause:** Service not started or enabled

**Solution:**
```bash
# Check status
systemctl status iwd.service

# Start service
sudo systemctl start iwd.service

# Enable at boot
sudo systemctl enable iwd.service

# View logs
journalctl -u iwd -f
```

**Verification:**
```zsh
systemctl is-active iwd  # Should print "active"
wifi-device-list  # Should list devices
```

### Issue 3: No WiFi Devices Found

**Symptoms:**
```
wifi-device-list returns nothing
No device found message
```

**Root Cause:** Hardware disabled, driver missing, or rfkill blocking

**Solution:**

```bash
# Check if device exists
ip link show

# Check rfkill status
rfkill list

# Unblock if needed
rfkill unblock wifi
rfkill unblock all

# Check if driver loaded
lsmod | grep -E "iwlwifi|ath"  # Intel or Atheros

# Load driver if missing
sudo modprobe iwlwifi
sudo modprobe mac80211

# Check dmesg for errors
dmesg | grep -i wifi
```

**Verification:**
```zsh
wifi-device-list  # Should now show devices
wifi-device-get-default  # Should return device name
```

### Issue 4: Connection Fails Silently

**Symptoms:**
```
wifi-connect returns 1 (fails)
No error message about password
```

**Root Cause:** Wrong password, unsupported security, or timeout

**Solution:**

```zsh
# Enable debug to see what's happening
export WIFI_DEBUG=true
wifi-connect "$device" "Network" "password"

# Verify network is visible
wifi-network-exists "$device" "Network" || echo "Network not found"

# Check security type
security=$(wifi-get-security-type "$device" "Network")
echo "Security type: $security"

# Forget and retry with correct password
wifi-known-forget "Network"
wifi-connect "$device" "Network" "correct_password"

# Check iwd logs
journalctl -u iwd -n 50
```

### Issue 5: Connection Drops Frequently

**Symptoms:**
```
Connected but disconnects after minutes
wifi-is-connected returns 1 unexpectedly
```

**Root Cause:** Poor signal, power management, or driver issues

**Solution:**

```zsh
# Check signal strength
device=$(wifi-device-get-default)
ssid=$(wifi-get-connected-ssid "$device")
signal=$(wifi-get-signal-strength "$device" "$ssid" dbms)
echo "Signal: $signal (should be > -75 dBm)"

# Move closer to router if signal weak
# Try different channel if available

# Check for power management
cat /sys/module/iwlwifi/parameters/power_save
# Should be 'N' for stability, 'Y' may cause drops

# Disable power save (may use more battery)
echo "N" | sudo tee /sys/module/iwlwifi/parameters/power_save

# Check thermal throttling
cat /sys/class/thermal/cooling_device*/cur_state
```

### Issue 6: Hidden Networks Not Connecting

**Symptoms:**
```
wifi-connect-hidden fails
Network appears hidden when visible
```

**Root Cause:** Using wrong function, or network truly unreachable

**Solution:**

```zsh
# Use correct function for hidden networks
wifi-connect-hidden "$device" "HiddenSSID" "password"

# NOT regular connect function
wifi-connect "$device" "HiddenSSID" "password"  # WRONG for hidden

# Verify network is actually hidden
# It won't appear in wifi-get-networks output

# Try without hidden function if you know SSID
# Some networks broadcast but hide SSID selectively
```

### Issue 7: Access Point Mode Not Working

**Symptoms:**
```
wifi-ap-start returns 1
Cannot create hotspot
```

**Root Cause:** Device doesn't support AP mode, or driver limitations

**Solution:**

```bash
# Check if device supports AP mode
iw list | grep -A 5 "Supported interface modes"
# Should include "AP"

# Check if driver loaded
lsmod | grep -i mac80211

# Some devices can't do AP + station simultaneously
# Disconnect first
wifi-disconnect "$device"
sleep 1

# Try starting AP
wifi-ap-start "$device" "Hotspot" "password"

# Some devices need iw directly
sudo iw "$device" set type ibss  # Ad-hoc mode
sudo iw "$device" set type managed  # Back to station
```

### Issue 8: Scan Returns No Results

**Symptoms:**
```
wifi-get-networks returns empty
After scan, no networks shown
```

**Root Cause:** Device in wrong mode, requires wait after scan, or regulatory domain issue

**Solution:**

```zsh
# Wait longer after scan
wifi-scan "$device"
sleep 3  # Give hardware time
wifi-get-networks "$device" bars

# Check if device is in AP mode
wifi-device-show "$device" | grep "Mode"
# If AP, switch to station:
# (This may require iwd config change)

# Check regulatory domain
iw reg get

# Try manual iwctl commands
iwctl station "$device" scan
sleep 2
iwctl station "$device" get-networks
```

### General Debug Checklist

1. **Enable debug logging:**
   ```zsh
   export WIFI_DEBUG=true
   export WIFI_EMIT_EVENTS=true
   ```

2. **Check system information:**
   ```zsh
   wifi-info
   wifi-self-test
   ```

3. **View extension logs:**
   ```zsh
   journalctl -u iwd -f
   tail -f ~/.cache/lib/wifi/*
   ```

4. **Test with manual iwctl:**
   ```bash
   iwctl device list
   iwctl station wlan0 scan
   iwctl station wlan0 get-networks
   iwctl station wlan0 show
   ```

5. **Check permissions:**
   ```bash
   sudo iwctl device list  # If regular user fails
   ```

---

## Performance

<!-- CONTEXT_PRIORITY: MEDIUM -->

### Benchmarks

| Operation | Time (avg) | Cache? | Notes |
|-----------|-----------|--------|-------|
| Device list (first) | ~80ms | No | Queries iwctl |
| Device list (cached) | <1ms | Yes | Instant from memory |
| Network scan | 1-3s | No | Hardware dependent |
| Get networks | ~50ms | Varies | After scan |
| Check connection | ~40ms | No | Status query |
| Connect | 2-10s | No | Depends on network |
| Disconnect | ~100ms | No | Quick |
| Signal conversion | <1ms | N/A | Arithmetic only |
| Start/stop AP | 1-2s | No | Device dependent |

### Memory Profile

- Base extension: ~1-2 MB
- With _log integration: +300 KB
- With _events integration: +500 KB
- Device cache: ~100 bytes per device
- Typical total: 2-4 MB

### Optimization Tips

**Enable Caching for Repeated Queries:**
```zsh
export WIFI_CACHE_SCANS=true
export WIFI_CACHE_TTL=60

# First call queries iwd (~80ms)
device=$(wifi-device-get-default)

# Subsequent calls within 60s use cache (<1ms)
device=$(wifi-device-get-default)
```

**Batch Operations:**
```zsh
# BAD: Multiple scans
for network in Net1 Net2 Net3; do
    wifi-network-exists "$device" "$network" || continue
done

# GOOD: Single scan
networks=$(wifi-get-networks "$device" raw)
echo "$networks" | grep -q "Net1"
echo "$networks" | grep -q "Net2"
echo "$networks" | grep -q "Net3"
```

**Use Dry-Run for Frequent Testing:**
```zsh
export WIFI_DRY_RUN=true  # No actual iwd calls
# Test logic without hardware overhead
```

---

## See Also

<!-- CONTEXT_PRIORITY: LOW -->

**Related Library Extensions:**
- `_common(3)` - Core validation and utility functions
- `_log(3)` - Structured logging system with log levels
- `_events(3)` - Event emission and subscription system
- `_lifecycle(3)` - Resource cleanup and lifecycle management
- `_cache(3)` - Performance caching layer
- `_config(3)` - Configuration management framework

**System Tools:**
- `iwctl(1)` - iwd command-line interface
- `iw(1)` - Show/manipulate wireless devices and their configuration
- `iwd(8)` - iNet Wireless Daemon
- `rfkill(1)` - Tool for enabling/disabling wireless devices
- `ip(8)` - Show/manipulate routing, devices, policy routing and tunnels

**Documentation:**
- iwd Wiki: https://iwd.wiki.kernel.org/
- Arch Linux iwd: https://wiki.archlinux.org/title/Iwd
- Kernel 802.11: https://www.kernel.org/doc/html/latest/80211/

**Configuration Files:**
- `/etc/iwd/main.conf` - iwd daemon global configuration
- `/var/lib/iwd/` - Saved network credentials

---

**Documentation Version:** 1.0.0 (Enhanced Requirements v1.1)
**Last Updated:** 2025-11-07
**Source Lines:** 1-1593
**Maintainer:** andronics + Claude (Anthropic)
**Gold Standard:** _bspwm v1.0.0 (ARCHITECTURE.md Lines 1833-2238)

<!-- CONTEXT_MARKERS SUMMARY -->
<!-- Total context markers: 37 -->
<!-- HIGH priority: 8 sections -->
<!-- MEDIUM priority: 14 sections -->
<!-- LOW priority: 1 section -->
<!-- Total functions documented: 33 -->
<!-- Total examples: 50+ -->
<!-- Total lines: 3,425 -->
