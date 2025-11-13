# _audio - PulseAudio Integration and Management Library

**Lines:** 2,840 | **Functions:** 32 | **Examples:** 68 | **Source Lines:** 1,542
**Version:** 1.0.0 | **Layer:** Integration (Layer 3) | **Source:** `~/.local/bin/lib/_audio`
**Enhanced Documentation Requirements:** v1.1 | **Compliance:** 95%

---

## Quick Access Index

### Compact References (Lines 10-400)
- [Function Reference](#function-quick-reference) - 32 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 10 variables
- [Events](#events-quick-reference) - 5 events
- [Return Codes](#return-codes-quick-reference) - Standard codes
- [Volume Levels](#volume-levels-reference) - 6 levels

### Main Sections
- [Overview](#overview) (Lines 400-550, ~150 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 550-700, ~150 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 700-1000, ~300 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 1000-1200, ~200 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 1200-2100, ~900 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2100-2350, ~250 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2350-2600, ~250 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: audio_api -->

**Server Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-check-server` | Check if PulseAudio server is running | 279-291 | O(1) | [→](#audio-check-server) |
| `audio-server-restart` | Restart PulseAudio server | 304-325 | O(1) | [→](#audio-server-restart) |

**Device Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-device-find` | Find device by regex pattern | 345-372 | O(n) | [→](#audio-device-find) |
| `audio-device-get-name` | Get friendly device name from config | 387-412 | O(n) | [→](#audio-device-get-name) |
| `audio-device-get-icon` | Get device icon from config | 427-452 | O(n) | [→](#audio-device-get-icon) |

**Sink Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-sink-get-current` | Get currently active sink ID | 469-496 | O(1) | [→](#audio-sink-get-current) |
| `audio-sink-get-name` | Get device name for sink ID | 512-535 | O(1) | [→](#audio-sink-get-name) |
| `audio-sink-list` | List all available sinks | 548-564 | O(n) | [→](#audio-sink-list) |
| `audio-sink-set` | Set default sink | 590-637 | O(n) | [→](#audio-sink-set) |
| `audio-sink-set-next` | Switch to next sink | 649-676 | O(n) | [→](#audio-sink-set-next) |
| `audio-sink-set-prev` | Switch to previous sink | 688-711 | O(n) | [→](#audio-sink-set-prev) |

**Volume Control:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-volume-get` | Get current volume percentage | 730-780 | O(1) | [→](#audio-volume-get) |
| `audio-volume-set` | Set absolute volume with bounds | 796-840 | O(1) | [→](#audio-volume-set) |
| `audio-volume-increase` | Increase volume by step | 856-883 | O(1) | [→](#audio-volume-increase) |
| `audio-volume-decrease` | Decrease volume by step | 899-918 | O(1) | [→](#audio-volume-decrease) |

**Mute Control:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-mute-query` | Get current mute state | 938-971 | O(1) | [→](#audio-mute-query) |
| `audio-mute-enable` | Enable mute (mute audio) | 985-1014 | O(1) | [→](#audio-mute-enable) |
| `audio-mute-disable` | Disable mute (unmute audio) | 1028-1057 | O(1) | [→](#audio-mute-disable) |
| `audio-mute-toggle` | Toggle mute state | 1071-1104 | O(1) | [→](#audio-mute-toggle) |

**Level and Icon Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-level-get-name` | Get volume level name (muted/low/high) | 1123-1158 | O(1) | [→](#audio-level-get-name) |
| `audio-level-get-icon` | Get icon for current volume level | 1173-1191 | O(1) | [→](#audio-level-get-icon) |

**Visualization:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-spectrum-show` | Display spectrum visualization (cava) | 1208-1224 | O(1) | [→](#audio-spectrum-show) |

**Event Subscription:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-subscribe` | Subscribe to PulseAudio events | 1244-1280 | O(∞) | [→](#audio-subscribe) |

**Utility Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `audio-version` | Display extension version | 1294-1296 | O(1) | [→](#audio-version) |
| `audio-info` | Display comprehensive system information | 1306-1340 | O(1) | [→](#audio-info) |
| `audio-help` | Display comprehensive help text | 1350-1423 | O(1) | [→](#audio-help) |
| `audio-self-test` | Run comprehensive self-tests | 1435-1532 | O(n) | [→](#audio-self-test) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `_audio-init` | Initialize extension (auto-called) | 158-190 | O(1) | Internal |
| `_audio-load-config` | Load devices.json and levels.json | 198-221 | O(n) | Internal |
| `_audio-emit` | Emit event via _events | 236-241 | O(1) | Internal |
| `_audio-check-command` | Verify PulseAudio command availability | 254-263 | O(1) | Internal |
| `_audio-sink-get-ids` | Get array of all sink IDs | 573-575 | O(n) | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description | Source Lines |
|----------|------|---------|-------------|--------------|
| `AUDIO_DEBUG` | boolean | `false` | Enable debug logging output | 114 |
| `AUDIO_EMIT_EVENTS` | boolean | `true` | Emit events via _events extension | 115 |
| `AUDIO_VOLUME_MAX` | integer | `150` | Maximum volume percentage (150% = 1.5x) | 116 |
| `AUDIO_VOLUME_STEP` | integer | `5` | Default volume step for increase/decrease | 117 |
| `AUDIO_USE_PACTL` | boolean | `true` | Prefer pactl over pacmd | 118 |
| `AUDIO_CONFIG_DIR` | path | `~/.config/lib/audio` | Configuration directory (XDG) | 109, 170 |
| `AUDIO_DATA_DIR` | path | `~/.local/share/lib/audio` | Data directory (XDG) | 110, 171 |
| `AUDIO_CACHE_DIR` | path | `~/.cache/lib/audio` | Cache directory (XDG) | 111, 172 |
| `AUDIO_VERSION` | string (readonly) | `1.0.0` | Extension version | 45 |
| `AUDIO_LOADED` | boolean (readonly) | `1` | Extension loaded flag | 39 |

---

## Events Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | When Emitted | Data Parameters | Source Lines |
|-------|--------------|-----------------|--------------|
| `audio.volume.changed` | Volume changed | `sink`, `volume` | 838 |
| `audio.mute.changed` | Mute state changed | `sink`, `muted` | 1012, 1055, 1102 |
| `audio.sink.changed` | Default sink changed | `sink` | 634 |
| `audio.server.restarted` | PulseAudio server restarted | (none) | 318 |
| `audio.error` | Error occurred | `operation` | 322 |
| `audio.initialized` | Extension initialized | `version` | 187 |

**Event Subscription:**
```zsh
source "$(which _events)"
events-on "audio.volume.changed" my_volume_handler
```

---

## Volume Levels Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Level Name | Volume Range | Description | Source Lines |
|------------|--------------|-------------|--------------|
| `muted` | N/A | Audio is muted | 140, 1135-1137 |
| `lowest` | 0-19% | Very quiet | 141, 1144-1145 |
| `low` | 20-39% | Quiet | 142, 1146-1147 |
| `medium` | 40-59% | Normal | 143, 1148-1149 |
| `high` | 60-79% | Loud | 144, 1150-1151 |
| `highest` | 80-150% | Very loud (may distort) | 145, 1152-1153 |

**Usage:**
```zsh
level=$(audio-level-get-name)
icon=$(audio-level-get-icon)
```

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (server down, execution) | Most functions |
| `2` | Invalid arguments | Missing or invalid parameters | Functions with required params |
| `3` | Not found | Device/sink not found | `audio-device-find` |
| `6` | Missing dependency | Optional dependency not available | `audio-spectrum-show` |
| `127` | Command not found | Required PulseAudio command not found | Most functions |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Overview

The `_audio` extension provides comprehensive integration with PulseAudio, offering a clean ZSH API for audio device management, volume control, mute operations, and spectrum visualization. It bridges PulseAudio's powerful audio management with the dotfiles library infrastructure, enabling sophisticated audio automation and scripting.

**Key Features:**
- **Server Management:** Check server status, restart PulseAudio
- **Device Discovery:** Pattern-based device finding with friendly names
- **Sink Management:** Switch between sinks, list all devices
- **Volume Control:** Get/set/increase/decrease with bounds checking
- **Mute Control:** Enable/disable/toggle with state tracking
- **Level Detection:** Map volume to named levels (low/medium/high)
- **Icon Management:** Load device/level icons from JSON config
- **Spectrum Visualization:** Integrate with cava for audio visualization
- **Event Subscription:** Subscribe to PulseAudio server events
- **Event Emission:** Emit events for volume/mute/sink changes
- **Configuration:** JSON-based device/level configuration
- **Graceful Degradation:** Works with optional dependencies missing

**Architecture:**
```
Layer 3: Integration
├── _audio (this extension)
│   ├── Required: _common, _jq, _xdg, pactl/pacmd
│   └── Optional: _log, _cava, _config, _lifecycle, _events
```

**Use Cases:**
- Volume control scripts (keybindings, notifications)
- Audio device switching utilities
- Polybar/i3status audio widgets
- Audio notification daemons
- Automated audio routing
- System audio management tools

**Performance:**
- Initialization: ~5ms (XDG setup + config loading)
- Volume operations: ~10-20ms (pactl execution)
- Sink operations: ~15-30ms (pactl + input migration)
- Event subscription: Long-running (streaming)
- Caching: Not applicable (PulseAudio state is dynamic)

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Installation

### Prerequisites

**Required:**
- ZSH 5.8 or later
- PulseAudio (pulseaudio, pactl, or pacmd)
- Extensions: `_common` v2.0, `_jq` v2.0, `_xdg` v2.0

**Optional:**
- `_log` v2.0 - Structured logging (fallback provided)
- `_cava` v2.0 - Spectrum visualization
- `_config` v2.0 - Configuration management
- `_lifecycle` v3.0 - Cleanup registration
- `_events` v2.0 - Event emission

### Installation Methods

**Method 1: Via Stow (Recommended)**
```zsh
# From dotfiles repository
cd ~/.pkgs
stow lib

# Verify installation
which _audio
# Output: /home/user/.local/bin/lib/_audio

# Test loading
source "$(which _audio)" && audio-version
# Output: 1.0.0
```

**Method 2: Direct Symlink**
```zsh
# Create directory structure
mkdir -p ~/.local/bin/lib

# Link extension
ln -s ~/.pkgs/lib/.local/bin/lib/_audio ~/.local/bin/lib/_audio

# Verify
source ~/.local/bin/lib/_audio && audio-self-test
```

**Method 3: PATH Setup**
```zsh
# Add to ~/.zshrc
export PATH="$HOME/.pkgs/lib/.local/bin/lib:$PATH"

# Reload shell
exec zsh

# Test
source "$(which _audio)" && audio-info
```

### Verifying Installation

Run comprehensive self-tests:
```zsh
source "$(which _audio)"
audio-self-test
```

Expected output:
```
[INFO] Running _audio v1.0.0 self-tests...
✓ PulseAudio server is running
✓ pactl command available
✓ Devices configuration loaded
✓ Levels configuration loaded
✓ Can get current sink (sink=0)
✓ Can get volume (volume=50%)
✓ Can query mute state (muted=no)
✓ Can get level name (level=medium)
Integration availability:
  _cava:      true
  _config:    true
  _lifecycle: true
  _events:    true

Self-tests complete: 8 passed, 0 failed
```

### Configuration Setup

Create configuration files:

**1. Devices Configuration (`~/.local/share/lib/audio/devices.json`):**
```json
[
  {
    "pattern": "alsa_output.*hdmi.*",
    "name": "HDMI Audio",
    "icon": "󰡁"
  },
  {
    "pattern": "alsa_output.*pci.*analog.*",
    "name": "Speakers",
    "icon": ""
  },
  {
    "pattern": "bluez.*",
    "name": "Bluetooth",
    "icon": ""
  }
]
```

**2. Levels Configuration (`~/.local/share/lib/audio/levels.json`):**
```json
{
  "muted": "",
  "lowest": "",
  "low": "",
  "medium": "",
  "high": "",
  "highest": ""
}
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
## Quick Start

### Basic Usage

**Example 1: Get Current Volume**
```zsh
source "$(which _audio)"

# Get volume for current sink
volume=$(audio-volume-get)
echo "Current volume: $volume%"

# Output: Current volume: 75%
```

**Example 2: Set Volume**
```zsh
source "$(which _audio)"

# Set volume to 50%
audio-volume-set 50
# Output: [DEBUG] Setting volume sink=0 volume=50%

# Verify
audio-volume-get
# Output: 50
```

**Example 3: Increase/Decrease Volume**
```zsh
source "$(which _audio)"

# Increase by default step (5%)
audio-volume-increase
# Output: [INFO] Increasing volume current=50% new=55%

# Decrease by custom step (10%)
audio-volume-decrease 10
# Output: [INFO] Decreasing volume current=55% new=45%
```

**Example 4: Toggle Mute**
```zsh
source "$(which _audio)"

# Toggle mute
audio-mute-toggle
# Output: [INFO] Toggling mute sink=0

# Check mute state
muted=$(audio-mute-query)
echo "Muted: $muted"
# Output: Muted: yes
```

**Example 5: Switch Audio Devices**
```zsh
source "$(which _audio)"

# List all sinks
audio-sink-list
# Output:
# 0 alsa_output.pci-0000_00_1b.0.analog-stereo
# 1 alsa_output.pci-0000_00_03.0.hdmi-stereo

# Switch to next sink
audio-sink-set-next
# Output: [INFO] Switching to next sink current=0 next=1
# Output: [SUCCESS] Default sink set sink=1

# Get friendly name
name=$(audio-device-get-name)
echo "Current device: $name"
# Output: Current device: HDMI Audio
```

### Volume Control Examples

**Example 6: Set Volume with Bounds**
```zsh
source "$(which _audio)"

# Set volume to 200% (will be capped at max)
export AUDIO_VOLUME_MAX=150
audio-volume-set 200
# Output: [DEBUG] Setting volume sink=0 volume=150%
# (capped at AUDIO_VOLUME_MAX)

# Set volume to -10% (will be set to 0%)
audio-volume-set -10
# Output: [DEBUG] Setting volume sink=0 volume=0%
```

**Example 7: Smart Volume Increase**
```zsh
source "$(which _audio)"

# Set max volume
export AUDIO_VOLUME_MAX=100

# At 98%, increase by 5 should jump to 100 (not 103)
audio-volume-set 98
audio-volume-increase
audio-volume-get
# Output: 100
# (smart capping prevents overshoot)
```

**Example 8: Get Volume Level and Icon**
```zsh
source "$(which _audio)"

# Get current level name
level=$(audio-level-get-name)
echo "Level: $level"
# Output: Level: medium

# Get icon for level
icon=$(audio-level-get-icon)
echo "Icon: $icon"
# Output: Icon:
```

### Device Management Examples

**Example 9: Find Device by Pattern**
```zsh
source "$(which _audio)"

# Find HDMI device
hdmi_device=$(audio-device-find "hdmi")
echo "HDMI device: $hdmi_device"
# Output: HDMI device: alsa_output.pci-0000_00_03.0.hdmi-stereo

# Find Bluetooth device
bt_device=$(audio-device-find "bluez")
if [[ $? -eq 0 ]]; then
    echo "Bluetooth: $bt_device"
else
    echo "No Bluetooth device found"
fi
```

**Example 10: Get Device Name and Icon**
```zsh
source "$(which _audio)"

# Get current device info
sink=$(audio-sink-get-current)
name=$(audio-device-get-name "$sink")
icon=$(audio-device-get-icon "$sink")

echo "$icon $name"
# Output:  HDMI Audio
```

**Example 11: Switch to Specific Device**
```zsh
source "$(which _audio)"

# Find and switch to speakers
speakers=$(audio-device-find "analog")
if [[ $? -eq 0 ]]; then
    audio-sink-set "$speakers"
    echo "Switched to speakers"
fi
# Output: [SUCCESS] Default sink set sink=alsa_output.pci-0000_00_1b.0.analog-stereo
# Output: Switched to speakers
```

### Mute Control Examples

**Example 12: Conditional Mute**
```zsh
source "$(which _audio)"

# Mute if not already muted
if [[ "$(audio-mute-query)" == "no" ]]; then
    audio-mute-enable
    echo "Audio muted"
fi
# Output: [INFO] Enabling mute sink=0
# Output: Audio muted
```

**Example 13: Temporary Mute**
```zsh
source "$(which _audio)"

# Save current state, mute, do something, restore
original_mute=$(audio-mute-query)
audio-mute-enable

# Do something that needs silence
sleep 5

# Restore original state
if [[ "$original_mute" == "no" ]]; then
    audio-mute-disable
fi
```

### Event Subscription Examples

**Example 14: Monitor Volume Changes**
```zsh
source "$(which _audio)"
source "$(which _events)"

# Register event handler
handle_volume_change() {
    local event_data="$1"
    echo "[EVENT] Volume changed: $event_data"
}

events-on "audio.volume.changed" handle_volume_change

# Now volume changes will trigger the handler
audio-volume-set 75
# Output: [EVENT] Volume changed: sink=0 volume=75
```

**Example 15: Subscribe to PulseAudio Events**
```zsh
source "$(which _audio)"

# Subscribe to all PulseAudio events
audio-subscribe | while read -r event; do
    echo "[AUDIO EVENT] $event"

    case "$event" in
        *"sink id"*"changed"*)
            echo "Sink changed, update UI"
            ;;
        *"sink-input"*"new"*)
            echo "New audio stream started"
            ;;
    esac
done
# Output (streaming):
# [AUDIO EVENT] sink id 0 changed
# Sink changed, update UI
# [AUDIO EVENT] new sink-input id 42
# New audio stream started
```

### Server Management Examples

**Example 16: Check Server Status**
```zsh
source "$(which _audio)"

if audio-check-server; then
    echo "PulseAudio is running"
else
    echo "PulseAudio is not running"
    audio-server-restart
fi
```

**Example 17: Restart PulseAudio**
```zsh
source "$(which _audio)"

# Restart server
audio-server-restart
# Output: [INFO] Restarting PulseAudio server
# Output: [SUCCESS] PulseAudio server restarted
```

### Visualization Examples

**Example 18: Show Spectrum**
```zsh
source "$(which _audio)"
source "$(which _cava)"

# Start spectrum visualization
audio-spectrum-show

# This will launch cava with audio configuration
# Press 'q' to quit
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Configuration

### Environment Variables

Configure extension behavior via environment variables:

**Debug and Logging:**
```zsh
export AUDIO_DEBUG=true              # Enable debug logging
source "$(which _audio)"
audio-volume-get
# Output: [DEBUG] Initializing _audio v1.0.0
# Output: [DEBUG] XDG directories initialized config=...
```

**Volume Behavior:**
```zsh
# Set maximum volume to 100% (no overdrive)
export AUDIO_VOLUME_MAX=100

# Set volume step to 10%
export AUDIO_VOLUME_STEP=10

source "$(which _audio)"
audio-volume-increase
# Will increase by 10%, capped at 100%
```

**Event Emission:**
```zsh
# Disable event emission
export AUDIO_EMIT_EVENTS=false

source "$(which _audio)"
audio-volume-set 50
# No events will be emitted
```

**PulseAudio Command Preference:**
```zsh
# Use pacmd instead of pactl
export AUDIO_USE_PACTL=false

source "$(which _audio)"
# Will use pacmd for all operations
```

### Configuration Files

#### Devices Configuration

Location: `$AUDIO_DATA_DIR/devices.json` (`~/.local/share/lib/audio/devices.json`)

```json
[
  {
    "pattern": "alsa_output.*hdmi.*",
    "name": "HDMI Audio",
    "icon": "󰡁"
  },
  {
    "pattern": "alsa_output.*pci.*analog.*",
    "name": "Speakers",
    "icon": ""
  },
  {
    "pattern": "bluez.*a2dp.*",
    "name": "Bluetooth Headphones",
    "icon": ""
  },
  {
    "pattern": "alsa_output.*usb.*",
    "name": "USB Audio",
    "icon": ""
  }
]
```

**Fields:**
- `pattern` (required): Regex pattern to match device name
- `name` (required): Friendly display name
- `icon` (optional): Icon string (e.g., Nerd Font icon)

**Usage:**
```zsh
source "$(which _audio)"
name=$(audio-device-get-name)
icon=$(audio-device-get-icon)
echo "$icon $name"
# Output:  Speakers
```

#### Levels Configuration

Location: `$AUDIO_DATA_DIR/levels.json` (`~/.local/share/lib/audio/levels.json`)

```json
{
  "muted": "",
  "lowest": "",
  "low": "",
  "medium": "",
  "high": "",
  "highest": ""
}
```

**Fields:**
- `muted`: Icon when audio is muted
- `lowest`: Icon for 0-19% volume
- `low`: Icon for 20-39% volume
- `medium`: Icon for 40-59% volume
- `high`: Icon for 60-79% volume
- `highest`: Icon for 80-150% volume

**Usage:**
```zsh
source "$(which _audio)"
icon=$(audio-level-get-icon)
volume=$(audio-volume-get)
echo "$icon $volume%"
# Output:  75%
```

### XDG Directory Paths

The extension uses XDG-compliant directories:

```zsh
source "$(which _audio)"
audio-info | grep Directory
# Output:
# Config Directory: /home/user/.config/lib/audio
# Data Directory:   /home/user/.local/share/lib/audio
# Cache Directory:  /home/user/.cache/lib/audio
```

**Directory Usage:**
- `$AUDIO_CONFIG_DIR`: Currently unused (reserved for future)
- `$AUDIO_DATA_DIR`: `devices.json`, `levels.json`
- `$AUDIO_CACHE_DIR`: Currently unused (PulseAudio state is dynamic)

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## API Reference

### Server Management

<!-- CONTEXT_GROUP: server_management -->

#### audio-check-server

Check if PulseAudio server is running and accessible.

**Source:** [Lines 279-291](→ L279)

**Synopsis:**
```zsh
audio-check-server
```

**Description:**
Verifies that the PulseAudio server is running and responsive. Tries multiple detection methods:
1. `pulseaudio --check` (if available)
2. `pactl info` (fallback)

**Returns:**
- `0` - Server is running and accessible
- `1` - Server is not running or not accessible

**Example 1: Basic Check**
```zsh
source "$(which _audio)"

if audio-check-server; then
    echo "PulseAudio is ready"
else
    echo "PulseAudio is not available"
fi
```

**Example 2: Conditional Restart**
```zsh
source "$(which _audio)"

if ! audio-check-server; then
    echo "Server down, attempting restart..."
    audio-server-restart
fi
```

**Performance:**
- Runtime: O(1) - Single system call
- Typical: ~5-10ms

---

#### audio-server-restart

Restart PulseAudio server (kill and start).

**Source:** [Lines 304-325](→ L304)

**Synopsis:**
```zsh
audio-server-restart
```

**Description:**
Stops the running PulseAudio server and starts a new instance. Emits `audio.server.restarted` event on success.

**Returns:**
- `0` - Server restarted successfully
- `1` - Failed to restart server
- `127` - `pulseaudio` command not found

**Events:**
- `audio.server.restarted` - Emitted on successful restart
- `audio.error` - Emitted on failure (with `operation=server-restart`)

**Example 1: Basic Restart**
```zsh
source "$(which _audio)"

audio-server-restart
# Output: [INFO] Restarting PulseAudio server
# Output: [SUCCESS] PulseAudio server restarted
```

**Example 2: Restart with Error Handling**
```zsh
source "$(which _audio)"

if ! audio-server-restart; then
    echo "Failed to restart PulseAudio"
    systemctl --user restart pulseaudio
fi
```

**Performance:**
- Runtime: O(1) - System restart operation
- Typical: ~500ms-1s (kill + restart)

**Notes:**
- Existing audio streams will be interrupted
- Applications may need to reconnect
- Use sparingly; consider `pactl` operations first

---

### Device Management

<!-- CONTEXT_GROUP: device_management -->

#### audio-device-find

Find audio device by regex pattern matching.

**Source:** [Lines 345-372](→ L345)

**Synopsis:**
```zsh
audio-device-find PATTERN
```

**Parameters:**
- `PATTERN` (required) - Regex pattern to match device name

**Returns:**
- `0` - Device found (name printed to stdout)
- `1` - No device found matching pattern
- `2` - Invalid arguments
- `127` - No PulseAudio control command available

**Output:**
Device name (raw PulseAudio device string)

**Example 1: Find HDMI Device**
```zsh
source "$(which _audio)"

hdmi=$(audio-device-find "hdmi")
echo "HDMI device: $hdmi"
# Output: HDMI device: alsa_output.pci-0000_00_03.0.hdmi-stereo
```

**Example 2: Find Bluetooth Device**
```zsh
source "$(which _audio)"

if bt=$(audio-device-find "bluez.*a2dp"); then
    echo "Found Bluetooth: $bt"
    audio-sink-set "$bt"
else
    echo "No Bluetooth device found"
fi
```

**Example 3: Find Analog Output**
```zsh
source "$(which _audio)"

analog=$(audio-device-find "analog.*stereo")
echo "Speakers: $analog"
# Output: Speakers: alsa_output.pci-0000_00_1b.0.analog-stereo
```

**Performance:**
- Runtime: O(n) where n = number of sinks
- Typical: ~15-20ms for 2-5 devices

**Notes:**
- Pattern is interpreted as ZSH regex (PCRE-style)
- Matches against raw device name from PulseAudio
- Use `audio-sink-list` to see all available devices
- Case-sensitive matching

---

#### audio-device-get-name

Get friendly device name from configuration.

**Source:** [Lines 387-412](→ L387)

**Synopsis:**
```zsh
audio-device-get-name [DEVICE]
```

**Parameters:**
- `DEVICE` (optional) - Device name or sink ID (defaults to current sink)

**Returns:**
- `0` - Friendly name found (printed to stdout)
- `1` - No friendly name found in configuration (raw name printed)

**Output:**
Friendly device name (from `devices.json`) or raw device name

**Example 1: Get Current Device Name**
```zsh
source "$(which _audio)"

name=$(audio-device-get-name)
echo "Current device: $name"
# Output: Current device: Speakers
```

**Example 2: Get Name for Specific Sink**
```zsh
source "$(which _audio)"

name=$(audio-device-get-name 1)
echo "Sink 1: $name"
# Output: Sink 1: HDMI Audio
```

**Example 3: Fallback to Raw Name**
```zsh
source "$(which _audio)"

# If no pattern matches in devices.json
name=$(audio-device-get-name)
echo "$name"
# Output: alsa_output.pci-0000_00_1b.0.analog-stereo
# (raw name, return code = 1)
```

**Performance:**
- Runtime: O(n) where n = number of patterns in devices.json
- Typical: ~5-10ms

**Dependencies:**
- Requires `devices.json` in `$AUDIO_DATA_DIR`
- Uses `_jq` for JSON parsing

---

#### audio-device-get-icon

Get device icon from configuration.

**Source:** [Lines 427-452](→ L427)

**Synopsis:**
```zsh
audio-device-get-icon [DEVICE]
```

**Parameters:**
- `DEVICE` (optional) - Device name or sink ID (defaults to current sink)

**Returns:**
- `0` - Icon found (printed to stdout)
- `1` - No icon found in configuration (empty string printed)

**Output:**
Icon string (from `devices.json`) or empty string

**Example 1: Get Current Device Icon**
```zsh
source "$(which _audio)"

icon=$(audio-device-get-icon)
echo "Icon: $icon"
# Output: Icon:
```

**Example 2: Build Device Display**
```zsh
source "$(which _audio)"

icon=$(audio-device-get-icon)
name=$(audio-device-get-name)
volume=$(audio-volume-get)

echo "$icon $name: $volume%"
# Output:  Speakers: 75%
```

**Example 3: Get Icon for Specific Sink**
```zsh
source "$(which _audio)"

icon=$(audio-device-get-icon 1)
name=$(audio-device-get-name 1)
echo "$icon $name"
# Output: 󰡁 HDMI Audio
```

**Performance:**
- Runtime: O(n) where n = number of patterns in devices.json
- Typical: ~5-10ms

**Dependencies:**
- Requires `devices.json` in `$AUDIO_DATA_DIR`
- Uses `_jq` for JSON parsing

---

### Sink Management

<!-- CONTEXT_GROUP: sink_management -->

#### audio-sink-get-current

Get the currently active default sink ID.

**Source:** [Lines 469-496](→ L469)

**Synopsis:**
```zsh
audio-sink-get-current
```

**Returns:**
- `0` - Success (sink ID printed to stdout)
- `1` - Failed to get current sink
- `127` - No PulseAudio control command available

**Output:**
Numeric sink ID (e.g., `0`, `1`, `2`)

**Example 1: Get Current Sink**
```zsh
source "$(which _audio)"

sink=$(audio-sink-get-current)
echo "Current sink: $sink"
# Output: Current sink: 0
```

**Example 2: Get Sink Name**
```zsh
source "$(which _audio)"

sink=$(audio-sink-get-current)
name=$(audio-sink-get-name "$sink")
echo "Active: $name"
# Output: Active: alsa_output.pci-0000_00_1b.0.analog-stereo
```

**Example 3: Error Handling**
```zsh
source "$(which _audio)"

if ! audio-check-server; then
    echo "PulseAudio not running"
elif sink=$(audio-sink-get-current); then
    echo "Sink: $sink"
else
    echo "Failed to get sink"
fi
```

**Performance:**
- Runtime: O(1) - Single pactl/pacmd query
- Typical: ~10-15ms

---

#### audio-sink-get-name

Get device name (PulseAudio string) for sink ID.

**Source:** [Lines 512-535](→ L512)

**Synopsis:**
```zsh
audio-sink-get-name SINK_ID
```

**Parameters:**
- `SINK_ID` (required) - Numeric sink ID

**Returns:**
- `0` - Success (device name printed to stdout)
- `1` - Sink not found
- `2` - Invalid arguments
- `127` - No PulseAudio control command available

**Output:**
Device name (e.g., `alsa_output.pci-0000_00_1b.0.analog-stereo`)

**Example 1: Get Name for Sink**
```zsh
source "$(which _audio)"

name=$(audio-sink-get-name 0)
echo "Sink 0: $name"
# Output: Sink 0: alsa_output.pci-0000_00_1b.0.analog-stereo
```

**Example 2: List All Sink Names**
```zsh
source "$(which _audio)"

audio-sink-list | while read -r id name; do
    echo "Sink $id: $name"
done
# Output:
# Sink 0: alsa_output.pci-0000_00_1b.0.analog-stereo
# Sink 1: alsa_output.pci-0000_00_03.0.hdmi-stereo
```

**Performance:**
- Runtime: O(1) - Single query
- Typical: ~10ms

---

#### audio-sink-list

List all available audio sinks.

**Source:** [Lines 548-564](→ L548)

**Synopsis:**
```zsh
audio-sink-list
```

**Returns:**
- `0` - Success (list printed to stdout)
- `1` - Failed to list sinks
- `127` - No PulseAudio control command available

**Output:**
Space-separated list of "ID NAME" pairs (one per line)

**Example 1: List All Sinks**
```zsh
source "$(which _audio)"

audio-sink-list
# Output:
# 0 alsa_output.pci-0000_00_1b.0.analog-stereo
# 1 alsa_output.pci-0000_00_03.0.hdmi-stereo
```

**Example 2: Count Sinks**
```zsh
source "$(which _audio)"

count=$(audio-sink-list | wc -l)
echo "Available sinks: $count"
# Output: Available sinks: 2
```

**Example 3: Build Sink Menu**
```zsh
source "$(which _audio)"

declare -a menu_items
while read -r id name; do
    friendly=$(audio-device-get-name "$id")
    menu_items+=("$id: $friendly")
done < <(audio-sink-list)

for item in "${menu_items[@]}"; do
    echo "$item"
done
# Output:
# 0: Speakers
# 1: HDMI Audio
```

**Performance:**
- Runtime: O(n) where n = number of sinks
- Typical: ~15-20ms

---

#### audio-sink-set

Set the default audio sink.

**Source:** [Lines 590-637](→ L590)

**Synopsis:**
```zsh
audio-sink-set SINK
```

**Parameters:**
- `SINK` (required) - Sink ID or device name

**Returns:**
- `0` - Success
- `1` - Failed to set sink
- `2` - Invalid arguments
- `127` - No PulseAudio control command available

**Events:**
- `audio.sink.changed` - Emitted on success (with `sink=<id>`)

**Example 1: Set Sink by ID**
```zsh
source "$(which _audio)"

audio-sink-set 1
# Output: [INFO] Setting default sink sink=1
# Output: [SUCCESS] Default sink set sink=1
```

**Example 2: Set Sink by Name**
```zsh
source "$(which _audio)"

audio-sink-set "alsa_output.pci-0000_00_03.0.hdmi-stereo"
# Output: [INFO] Setting default sink sink=alsa_output.pci-0000_00_03.0.hdmi-stereo
# Output: [SUCCESS] Default sink set sink=alsa_output.pci-0000_00_03.0.hdmi-stereo
```

**Example 3: Switch to HDMI**
```zsh
source "$(which _audio)"

hdmi=$(audio-device-find "hdmi")
audio-sink-set "$hdmi"
```

**Performance:**
- Runtime: O(n) where n = number of active streams (moved to new sink)
- Typical: ~20-40ms

**Notes:**
- Automatically moves all active sink inputs to new sink
- Changes take effect immediately
- All applications continue playing on new sink

---

#### audio-sink-set-next

Switch to the next available sink in the list.

**Source:** [Lines 649-676](→ L649)

**Synopsis:**
```zsh
audio-sink-set-next
```

**Returns:**
- `0` - Success
- `1` - Failed to switch or no sinks available

**Events:**
- `audio.sink.changed` - Emitted on success

**Example 1: Cycle to Next Sink**
```zsh
source "$(which _audio)"

audio-sink-set-next
# Output: [INFO] Switching to next sink current=0 next=1
# Output: [SUCCESS] Default sink set sink=1
```

**Example 2: Keybinding for Sink Cycling**
```zsh
# In your window manager config
# XF86AudioNext → audio-sink-set-next
```

**Example 3: Cycle with Notification**
```zsh
source "$(which _audio)"

audio-sink-set-next
name=$(audio-device-get-name)
notify-send "Audio Output" "Switched to: $name"
```

**Performance:**
- Runtime: O(n) - Must retrieve all sinks
- Typical: ~30-50ms

**Notes:**
- Wraps around to first sink when at end of list
- Requires at least 2 sinks available

---

#### audio-sink-set-prev

Switch to the previous available sink in the list.

**Source:** [Lines 688-711](→ L688)

**Synopsis:**
```zsh
audio-sink-set-prev
```

**Returns:**
- `0` - Success
- `1` - Failed to switch or no sinks available

**Events:**
- `audio.sink.changed` - Emitted on success

**Example 1: Cycle to Previous Sink**
```zsh
source "$(which _audio)"

audio-sink-set-prev
# Output: [INFO] Switching to previous sink current=1 prev=0
# Output: [SUCCESS] Default sink set sink=0
```

**Example 2: Reverse Cycling**
```zsh
source "$(which _audio)"

# Cycle forward
audio-sink-set-next

# Undo (cycle back)
audio-sink-set-prev
```

**Performance:**
- Runtime: O(n) - Must retrieve all sinks
- Typical: ~30-50ms

**Notes:**
- Wraps around to last sink when at beginning of list
- Requires at least 2 sinks available

---

### Volume Control

<!-- CONTEXT_GROUP: volume_control -->

#### audio-volume-get

Get current volume percentage for sink.

**Source:** [Lines 730-780](→ L730)

**Synopsis:**
```zsh
audio-volume-get [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success (volume printed to stdout)
- `1` - Failed to get volume
- `127` - No PulseAudio control command available

**Output:**
Volume percentage as integer (0-150)

**Example 1: Get Current Volume**
```zsh
source "$(which _audio)"

volume=$(audio-volume-get)
echo "Volume: $volume%"
# Output: Volume: 75%
```

**Example 2: Get Volume for Specific Sink**
```zsh
source "$(which _audio)"

volume=$(audio-volume-get 1)
echo "HDMI volume: $volume%"
# Output: HDMI volume: 50%
```

**Example 3: Volume Status Display**
```zsh
source "$(which _audio)"

volume=$(audio-volume-get)
icon=$(audio-level-get-icon)
echo "$icon $volume%"
# Output:  75%
```

**Performance:**
- Runtime: O(1) - Single pactl query
- Typical: ~10-15ms

**Notes:**
- Returns first channel's volume (left channel for stereo)
- Volume can exceed 100% if overdrive is enabled

---

#### audio-volume-set

Set volume to specific percentage with bounds checking.

**Source:** [Lines 796-840](→ L796)

**Synopsis:**
```zsh
audio-volume-set VOLUME [SINK_ID]
```

**Parameters:**
- `VOLUME` (required) - Volume percentage (0-150)
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to set volume
- `2` - Invalid arguments (non-numeric volume)
- `127` - No PulseAudio control command available

**Events:**
- `audio.volume.changed` - Emitted on success (with `sink`, `volume`)

**Example 1: Set Volume to 50%**
```zsh
source "$(which _audio)"

audio-volume-set 50
# Output: [DEBUG] Setting volume sink=0 volume=50%
```

**Example 2: Set Volume with Bounds**
```zsh
source "$(which _audio)"

export AUDIO_VOLUME_MAX=100

# This will be capped at 100%
audio-volume-set 150
audio-volume-get
# Output: 100
```

**Example 3: Set Volume for Specific Sink**
```zsh
source "$(which _audio)"

audio-volume-set 75 1
# Sets HDMI sink to 75%
```

**Performance:**
- Runtime: O(1) - Single pactl command
- Typical: ~10-20ms

**Notes:**
- Automatically bounds to 0-AUDIO_VOLUME_MAX range
- Emits event after successful change
- Volume affects all channels equally

---

#### audio-volume-increase

Increase volume by step amount with max limit.

**Source:** [Lines 856-883](→ L856)

**Synopsis:**
```zsh
audio-volume-increase [STEP] [SINK_ID]
```

**Parameters:**
- `STEP` (optional) - Increase amount (defaults to `AUDIO_VOLUME_STEP`)
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to increase volume

**Events:**
- `audio.volume.changed` - Emitted on success

**Example 1: Increase by Default Step**
```zsh
source "$(which _audio)"

export AUDIO_VOLUME_STEP=5
audio-volume-increase
# Increases by 5%
```

**Example 2: Increase by Custom Amount**
```zsh
source "$(which _audio)"

audio-volume-increase 10
# Increases by 10%
```

**Example 3: Smart Capping**
```zsh
source "$(which _audio)"

export AUDIO_VOLUME_MAX=100
audio-volume-set 98
audio-volume-increase 5
audio-volume-get
# Output: 100 (jumped to max instead of overshooting)
```

**Performance:**
- Runtime: O(1) - Get + set operations
- Typical: ~20-30ms

**Notes:**
- Smart capping prevents overshoot near max
- If current + step > max, sets to max
- Respects `AUDIO_VOLUME_MAX` setting

---

#### audio-volume-decrease

Decrease volume by step amount with min limit.

**Source:** [Lines 899-918](→ L899)

**Synopsis:**
```zsh
audio-volume-decrease [STEP] [SINK_ID]
```

**Parameters:**
- `STEP` (optional) - Decrease amount (defaults to `AUDIO_VOLUME_STEP`)
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to decrease volume

**Events:**
- `audio.volume.changed` - Emitted on success

**Example 1: Decrease by Default Step**
```zsh
source "$(which _audio)"

export AUDIO_VOLUME_STEP=5
audio-volume-decrease
# Decreases by 5%
```

**Example 2: Decrease by Custom Amount**
```zsh
source "$(which _audio)"

audio-volume-decrease 10
# Decreases by 10%
```

**Example 3: Floor at 0%**
```zsh
source "$(which _audio)"

audio-volume-set 3
audio-volume-decrease 5
audio-volume-get
# Output: 0 (floored at 0%)
```

**Performance:**
- Runtime: O(1) - Get + set operations
- Typical: ~20-30ms

**Notes:**
- Automatically floors at 0%
- Respects `AUDIO_VOLUME_STEP` setting

---

### Mute Control

<!-- CONTEXT_GROUP: mute_control -->

#### audio-mute-query

Get current mute state for sink.

**Source:** [Lines 938-971](→ L938)

**Synopsis:**
```zsh
audio-mute-query [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success (state printed to stdout)
- `1` - Failed to query mute state
- `127` - No PulseAudio control command available

**Output:**
`yes` or `no`

**Example 1: Check Mute State**
```zsh
source "$(which _audio)"

muted=$(audio-mute-query)
if [[ "$muted" == "yes" ]]; then
    echo "Audio is muted"
else
    echo "Audio is playing"
fi
```

**Example 2: Conditional Unmute**
```zsh
source "$(which _audio)"

if [[ "$(audio-mute-query)" == "yes" ]]; then
    audio-mute-disable
    echo "Unmuted"
fi
```

**Performance:**
- Runtime: O(1) - Single pactl query
- Typical: ~10ms

---

#### audio-mute-enable

Enable mute (mute audio output).

**Source:** [Lines 985-1014](→ L985)

**Synopsis:**
```zsh
audio-mute-enable [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to enable mute
- `127` - No PulseAudio control command available

**Events:**
- `audio.mute.changed` - Emitted on success (with `sink`, `muted=yes`)

**Example 1: Mute Audio**
```zsh
source "$(which _audio)"

audio-mute-enable
# Output: [INFO] Enabling mute sink=0
```

**Example 2: Temporary Mute**
```zsh
source "$(which _audio)"

audio-mute-enable
sleep 5
audio-mute-disable
```

**Performance:**
- Runtime: O(1) - Single pactl command
- Typical: ~10-15ms

---

#### audio-mute-disable

Disable mute (unmute audio output).

**Source:** [Lines 1028-1057](→ L1028)

**Synopsis:**
```zsh
audio-mute-disable [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to disable mute
- `127` - No PulseAudio control command available

**Events:**
- `audio.mute.changed` - Emitted on success (with `sink`, `muted=no`)

**Example 1: Unmute Audio**
```zsh
source "$(which _audio)"

audio-mute-disable
# Output: [INFO] Disabling mute sink=0
```

**Example 2: Ensure Unmuted**
```zsh
source "$(which _audio)"

# Always unmute, regardless of current state
audio-mute-disable
```

**Performance:**
- Runtime: O(1) - Single pactl command
- Typical: ~10-15ms

---

#### audio-mute-toggle

Toggle mute state (mute if unmuted, unmute if muted).

**Source:** [Lines 1071-1104](→ L1071)

**Synopsis:**
```zsh
audio-mute-toggle [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success
- `1` - Failed to toggle mute
- `127` - No PulseAudio control command available

**Events:**
- `audio.mute.changed` - Emitted on success (with new state)

**Example 1: Toggle Mute**
```zsh
source "$(which _audio)"

audio-mute-toggle
# Output: [INFO] Toggling mute sink=0
# (state flips)
```

**Example 2: Keybinding for Mute Toggle**
```zsh
# In your window manager config
# XF86AudioMute → audio-mute-toggle
```

**Example 3: Toggle with Notification**
```zsh
source "$(which _audio)"

audio-mute-toggle
new_state=$(audio-mute-query)
if [[ "$new_state" == "yes" ]]; then
    notify-send "Audio" "Muted"
else
    notify-send "Audio" "Unmuted"
fi
```

**Performance:**
- Runtime: O(1) - pactl toggle (or query + set for pacmd)
- Typical: ~10-20ms

**Notes:**
- Uses native `pactl toggle` when available (efficient)
- Falls back to query + conditional enable/disable for `pacmd`

---

### Level and Icon Management

<!-- CONTEXT_GROUP: level_management -->

#### audio-level-get-name

Get volume level name based on current volume and mute state.

**Source:** [Lines 1123-1158](→ L1123)

**Synopsis:**
```zsh
audio-level-get-name [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Success (level name printed to stdout)
- `1` - Failed to get level

**Output:**
Level name: `muted`, `lowest`, `low`, `medium`, `high`, `highest`

**Level Mapping:**
- `muted` - Audio is muted (regardless of volume)
- `lowest` - 0-19%
- `low` - 20-39%
- `medium` - 40-59%
- `high` - 60-79%
- `highest` - 80-150%

**Example 1: Get Current Level**
```zsh
source "$(which _audio)"

level=$(audio-level-get-name)
echo "Level: $level"
# Output: Level: medium
```

**Example 2: Conditional Display**
```zsh
source "$(which _audio)"

level=$(audio-level-get-name)
case "$level" in
    muted)   echo "Audio is muted" ;;
    lowest)  echo "Very quiet" ;;
    low)     echo "Quiet" ;;
    medium)  echo "Normal" ;;
    high)    echo "Loud" ;;
    highest) echo "Very loud" ;;
esac
```

**Performance:**
- Runtime: O(1) - Query mute + query volume
- Typical: ~20-25ms

**Notes:**
- Mute state takes precedence (always returns `muted` when muted)
- Uses fixed ranges (see table above)

---

#### audio-level-get-icon

Get icon for current volume level from levels.json.

**Source:** [Lines 1173-1191](→ L1173)

**Synopsis:**
```zsh
audio-level-get-icon [SINK_ID]
```

**Parameters:**
- `SINK_ID` (optional) - Sink ID (defaults to current sink)

**Returns:**
- `0` - Icon found (printed to stdout)
- `1` - Icon not found (empty string printed)

**Output:**
Icon string (from `levels.json`) or empty string

**Example 1: Get Volume Icon**
```zsh
source "$(which _audio)"

icon=$(audio-level-get-icon)
echo "Icon: $icon"
# Output: Icon:
```

**Example 2: Build Status Display**
```zsh
source "$(which _audio)"

icon=$(audio-level-get-icon)
volume=$(audio-volume-get)
muted=$(audio-mute-query)

if [[ "$muted" == "yes" ]]; then
    echo " Muted"
else
    echo "$icon $volume%"
fi
# Output:  75%
```

**Example 3: Polybar Module**
```zsh
source "$(which _audio)"

# Polybar audio module script
icon=$(audio-level-get-icon)
volume=$(audio-volume-get)
echo "$icon $volume%"
```

**Performance:**
- Runtime: O(1) - Level query + JSON lookup
- Typical: ~25-30ms

**Dependencies:**
- Requires `levels.json` in `$AUDIO_DATA_DIR`
- Uses `_jq` for JSON parsing

---

### Visualization

<!-- CONTEXT_GROUP: visualization -->

#### audio-spectrum-show

Display audio spectrum visualization using cava.

**Source:** [Lines 1208-1224](→ L1208)

**Synopsis:**
```zsh
audio-spectrum-show
```

**Returns:**
- `0` - Success (cava started)
- `1` - Failed to start cava
- `6` - `_cava` extension not available

**Example 1: Show Spectrum**
```zsh
source "$(which _audio)"

audio-spectrum-show
# Launches cava in fullscreen
# Press 'q' to quit
```

**Example 2: Check Availability**
```zsh
source "$(which _audio)"

if audio-spectrum-show; then
    echo "Visualization started"
else
    echo "Cava not available"
fi
```

**Performance:**
- Runtime: Long-running (interactive visualization)
- Startup: ~100-200ms

**Dependencies:**
- Requires `_cava` extension
- Requires `cava` binary installed

**Notes:**
- Launches cava with audio-optimized settings:
  - 16 bars
  - PulseAudio input
  - Auto source detection
  - ASCII max range 7
- Interactive (blocks until quit)

---

### Event Subscription

<!-- CONTEXT_GROUP: event_subscription -->

#### audio-subscribe

Subscribe to PulseAudio server events (streaming).

**Source:** [Lines 1244-1280](→ L1244)

**Synopsis:**
```zsh
audio-subscribe
```

**Returns:**
- `0` - Subscription ended normally
- `1` - Failed to subscribe
- `127` - `pactl` not available

**Output:**
Event stream (one event per line, continuously)

**Event Format:**
- `sink id N changed` - Sink N changed (volume, mute, etc.)
- `new sink id N` - New sink N added
- `sink id N removed` - Sink N removed
- `sink-input id N changed` - Sink input N changed
- `new sink-input id N` - New sink input N added
- `sink-input id N removed` - Sink input N removed

**Example 1: Monitor All Events**
```zsh
source "$(which _audio)"

audio-subscribe | while read -r event; do
    echo "[AUDIO EVENT] $event"
done
# Output (streaming):
# [AUDIO EVENT] sink id 0 changed
# [AUDIO EVENT] new sink-input id 42
# [AUDIO EVENT] sink-input id 42 removed
```

**Example 2: React to Specific Events**
```zsh
source "$(which _audio)"

audio-subscribe | while read -r event; do
    case "$event" in
        *"sink id"*"changed"*)
            echo "Sink changed, update UI"
            update_audio_widget
            ;;
        *"sink-input"*"new"*)
            echo "New audio stream started"
            ;;
    esac
done
```

**Example 3: Background Monitoring**
```zsh
source "$(which _audio)"

audio-subscribe | while read -r event; do
    logger "PulseAudio: $event"
done &

AUDIO_MONITOR_PID=$!
# Later: kill $AUDIO_MONITOR_PID
```

**Performance:**
- Runtime: O(∞) - Long-running stream
- CPU: Very low (event-driven, no polling)

**Notes:**
- Blocks until killed (streaming subscription)
- Use in background or with `while` loop
- Raw PulseAudio events (not filtered)
- Use for reactive audio UIs (e.g., widgets)

---

### Utility Functions

<!-- CONTEXT_GROUP: utility -->

#### audio-version

Display extension version.

**Source:** [Lines 1294-1296](→ L1294)

**Synopsis:**
```zsh
audio-version
```

**Output:**
Version string (e.g., `1.0.0`)

**Example:**
```zsh
source "$(which _audio)"
audio-version
# Output: 1.0.0
```

---

#### audio-info

Display comprehensive extension and system information.

**Source:** [Lines 1306-1340](→ L1306)

**Synopsis:**
```zsh
audio-info
```

**Output:**
Multi-line information display including:
- Extension version
- XDG directory paths
- Configuration settings
- Integration status
- PulseAudio server status
- Current audio state

**Example:**
```zsh
source "$(which _audio)"
audio-info
```

**Output:**
```
_audio Extension Information

Version:          1.0.0
Config Directory: /home/user/.config/lib/audio
Data Directory:   /home/user/.local/share/lib/audio
Cache Directory:  /home/user/.cache/lib/audio

Configuration:
  Debug Mode:       false
  Emit Events:      true
  Volume Max:       150%
  Volume Step:      5%
  Use pactl:        true

Integration Status:
  _common:          yes (required)
  _jq:              yes (required)
  _xdg:             yes (required)
  _log:             yes
  _cava:            true
  _config:          true
  _lifecycle:       true
  _events:          true

PulseAudio Status:
  Server Running:   yes
  Current Sink:     0
  Volume:           75%
  Muted:            no
```

---

#### audio-help

Display comprehensive help information.

**Source:** [Lines 1350-1423](→ L1350)

**Synopsis:**
```zsh
audio-help
```

**Output:**
Multi-line help text including:
- Usage instructions
- Configuration variables
- Function listing (categorized)
- Integration status

**Example:**
```zsh
source "$(which _audio)"
audio-help | less
```

---

#### audio-self-test

Run comprehensive self-tests to validate functionality.

**Source:** [Lines 1435-1532](→ L1435)

**Synopsis:**
```zsh
audio-self-test
```

**Returns:**
- `0` - All tests passed
- `1` - Some tests failed

**Tests Performed:**
1. PulseAudio server availability
2. Command availability (pactl/pacmd)
3. Configuration loading (devices.json, levels.json)
4. Get current sink
5. Get volume
6. Query mute state
7. Get level name
8. Integration detection

**Example:**
```zsh
source "$(which _audio)"
audio-self-test
```

**Output:**
```
[INFO] Running _audio v1.0.0 self-tests...
✓ PulseAudio server is running
✓ pactl command available
✓ Devices configuration loaded
✓ Levels configuration loaded
✓ Can get current sink (sink=0)
✓ Can get volume (volume=75%)
✓ Can query mute state (muted=no)
✓ Can get level name (level=high)
Integration availability:
  _cava:      true
  _config:    true
  _lifecycle: true
  _events:    true

Self-tests complete: 8 passed, 0 failed
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Advanced Usage

### Building Audio Widgets

**Example: Polybar Audio Module**
```zsh
#!/usr/bin/env zsh
# ~/.config/polybar/scripts/audio-module

source "$(which _audio)"

# Get current state
icon=$(audio-level-get-icon)
volume=$(audio-volume-get)
muted=$(audio-mute-query)

# Build output
if [[ "$muted" == "yes" ]]; then
    echo "%{F#666} Muted%{F-}"
else
    echo "$icon $volume%"
fi
```

**Example: i3status Audio Block**
```zsh
#!/usr/bin/env zsh
# ~/.config/i3status/scripts/audio

source "$(which _audio)"

icon=$(audio-level-get-icon)
volume=$(audio-volume-get)
device=$(audio-device-get-name)

echo "$icon $volume% ($device)"
```

### Event-Driven Audio Notifications

**Example: Volume Change Notifications**
```zsh
#!/usr/bin/env zsh

source "$(which _audio)"
source "$(which _events)"

# Volume change handler
handle_volume_change() {
    local event_data="$1"

    # Extract volume from event
    local volume=$(echo "$event_data" | grep -oP 'volume=\K\d+')
    local icon=$(audio-level-get-icon)

    notify-send -t 1000 "Volume" "$icon $volume%"
}

# Mute change handler
handle_mute_change() {
    local event_data="$1"

    if [[ "$event_data" == *"muted=yes"* ]]; then
        notify-send -t 1000 "Audio" " Muted"
    else
        notify-send -t 1000 "Audio" " Unmuted"
    fi
}

# Register handlers
events-on "audio.volume.changed" handle_volume_change
events-on "audio.mute.changed" handle_mute_change

# Keep running
while true; do
    sleep 1
done
```

### Automatic Device Switching

**Example: Switch to Bluetooth When Available**
```zsh
#!/usr/bin/env zsh

source "$(which _audio)"

# Monitor for new sinks
audio-subscribe | while read -r event; do
    if [[ "$event" == *"new sink"* ]]; then
        # Wait for sink to initialize
        sleep 0.5

        # Check if it's Bluetooth
        if bt_sink=$(audio-device-find "bluez"); then
            echo "Bluetooth detected, switching..."
            audio-sink-set "$bt_sink"
            notify-send "Audio" "Switched to Bluetooth"
        fi
    fi
done
```

### Volume Normalization

**Example: Keep Volume Within Range**
```zsh
#!/usr/bin/env zsh

source "$(which _audio)"

# Normalize volume to 0-100% range
normalize_volume() {
    local current=$(audio-volume-get)

    if [[ $current -gt 100 ]]; then
        echo "Volume too high ($current%), normalizing to 100%"
        audio-volume-set 100
    elif [[ $current -lt 20 ]]; then
        echo "Volume too low ($current%), normalizing to 20%"
        audio-volume-set 20
    fi
}

# Run on startup
normalize_volume

# Monitor and normalize
audio-subscribe | while read -r event; do
    if [[ "$event" == *"sink id"*"changed"* ]]; then
        normalize_volume
    fi
done
```

### Multi-Device Management

**Example: Device Profiles**
```zsh
#!/usr/bin/env zsh

source "$(which _audio)"

# Define profiles
declare -A PROFILES=(
    [work]="alsa_output.pci-0000_00_1b.0.analog-stereo:50"
    [gaming]="alsa_output.pci-0000_00_03.0.hdmi-stereo:80"
    [music]="bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink:100"
)

# Load profile
load_profile() {
    local profile="$1"

    if [[ -z "${PROFILES[$profile]}" ]]; then
        echo "Unknown profile: $profile"
        return 1
    fi

    local device="${${PROFILES[$profile]}%%:*}"
    local volume="${${PROFILES[$profile]}##*:}"

    echo "Loading profile: $profile"
    echo "  Device: $device"
    echo "  Volume: $volume%"

    audio-sink-set "$device"
    audio-volume-set "$volume"
    audio-mute-disable
}

# Usage
load_profile "${1:-work}"
```

### Audio State Monitoring

**Example: Log Audio State Changes**
```zsh
#!/usr/bin/env zsh

source "$(which _audio)"

LOG_FILE="$HOME/.local/state/lib/audio/audio.log"
mkdir -p "$(dirname "$LOG_FILE")"

log_state() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local sink=$(audio-sink-get-current)
    local device=$(audio-device-get-name "$sink")
    local volume=$(audio-volume-get)
    local muted=$(audio-mute-query)

    echo "$timestamp | Sink: $device | Volume: $volume% | Muted: $muted" >> "$LOG_FILE"
}

# Log initial state
log_state

# Monitor and log changes
audio-subscribe | while read -r event; do
    if [[ "$event" == *"sink id"*"changed"* ]]; then
        log_state
    fi
done
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Troubleshooting

### Common Issues

**Issue: PulseAudio server not running**

```zsh
source "$(which _audio)"
audio-check-server
# Returns: 1
```

**Solution 1: Start PulseAudio**
```zsh
audio-server-restart
# Output: [SUCCESS] PulseAudio server restarted
```

**Solution 2: Check systemd service**
```zsh
systemctl --user status pulseaudio
systemctl --user restart pulseaudio
```

**Solution 3: Verify PulseAudio installation**
```zsh
which pulseaudio pactl
# Ensure both are installed
```

---

**Issue: No device configuration found**

```zsh
source "$(which _audio)"
audio-device-get-name
# Returns: alsa_output.pci-0000_00_1b.0.analog-stereo (raw name)
```

**Solution: Create devices.json**
```zsh
# Create data directory
mkdir -p ~/.local/share/lib/audio

# Create devices.json
cat > ~/.local/share/lib/audio/devices.json <<'EOF'
[
  {
    "pattern": "alsa_output.*analog.*",
    "name": "Speakers",
    "icon": ""
  }
]
EOF

# Reload extension
source "$(which _audio)"
audio-device-get-name
# Output: Speakers
```

---

**Issue: Volume changes not working**

```zsh
source "$(which _audio)"
audio-volume-set 50
# Returns: 1
```

**Diagnosis:**
```zsh
# Check server
audio-check-server || echo "Server down"

# Check command availability
which pactl pacmd

# Check current sink
audio-sink-get-current || echo "No sink available"

# Check for errors
export AUDIO_DEBUG=true
source "$(which _audio)"
audio-volume-set 50
```

**Solution:**
```zsh
# Restart server
audio-server-restart

# Verify sinks
audio-sink-list

# Try with specific sink
audio-volume-set 50 0
```

---

**Issue: Events not being emitted**

```zsh
source "$(which _audio)"
source "$(which _events)"

events-on "audio.volume.changed" echo

audio-volume-set 50
# No output (event not received)
```

**Diagnosis:**
```zsh
# Check if events are enabled
echo $AUDIO_EMIT_EVENTS
# Output: false (if disabled)

# Check if _events is loaded
echo $EVENTS_LOADED
# Output: 1 (if loaded)
```

**Solution:**
```zsh
# Enable event emission
export AUDIO_EMIT_EVENTS=true

# Reload extension
source "$(which _audio)"

# Try again
audio-volume-set 50
# Output: 50 (event received and echoed)
```

---

**Issue: Spectrum visualization not working**

```zsh
source "$(which _audio)"
audio-spectrum-show
# Returns: 6
```

**Diagnosis:**
```zsh
# Check _cava availability
echo $AUDIO_CAVA_AVAILABLE
# Output: false

# Check if _cava is installed
which _cava

# Check if cava binary is installed
which cava
```

**Solution:**
```zsh
# Install _cava extension (if missing)
source "$(which _cava)"

# Install cava binary (if missing)
# Arch: pacman -S cava
# Ubuntu: apt install cava

# Reload _audio
source "$(which _audio)"
audio-spectrum-show
```

---

### Performance Issues

**Issue: Slow volume queries**

**Diagnosis:**
```zsh
time audio-volume-get
# Output: 0.5s (too slow)
```

**Solution:**
Cache results in your application:
```zsh
# Cache for 1 second
VOLUME_CACHE=""
VOLUME_CACHE_TIME=0

get_volume_cached() {
    local now=$(date +%s)

    if [[ $((now - VOLUME_CACHE_TIME)) -gt 1 ]]; then
        VOLUME_CACHE=$(audio-volume-get)
        VOLUME_CACHE_TIME=$now
    fi

    echo "$VOLUME_CACHE"
}
```

---

**Issue: High CPU usage with audio-subscribe**

**Diagnosis:**
```zsh
audio-subscribe | while read -r event; do
    # Heavy processing on every event
    update_entire_ui
done
# CPU: 100%
```

**Solution:**
Rate-limit or debounce updates:
```zsh
LAST_UPDATE=0

audio-subscribe | while read -r event; do
    local now=$(date +%s%N)
    local diff=$(( (now - LAST_UPDATE) / 1000000 ))

    # Only update every 100ms
    if [[ $diff -gt 100 ]]; then
        update_ui
        LAST_UPDATE=$now
    fi
done
```

---

### Debugging

**Enable debug mode:**
```zsh
export AUDIO_DEBUG=true
source "$(which _audio)"

audio-volume-set 50
# Output:
# [DEBUG] Initializing _audio v1.0.0
# [DEBUG] XDG directories initialized config=... data=... cache=...
# [DEBUG] Loaded devices configuration file=...
# [DEBUG] Loaded levels configuration file=...
# [DEBUG] Setting volume sink=0 volume=50%
```

**Check integration status:**
```zsh
source "$(which _audio)"
audio-info | grep -A 10 "Integration Status"
# Output:
# Integration Status:
#   _common:          yes (required)
#   _jq:              yes (required)
#   _xdg:             yes (required)
#   _log:             yes
#   _cava:            true
#   _config:          true
#   _lifecycle:       true
#   _events:          true
```

**Run self-tests:**
```zsh
source "$(which _audio)"
audio-self-test
# Runs comprehensive diagnostic tests
```

---

## See Also

- `_bspwm` - Window manager integration (similar architecture)
- `_events` - Event system for subscribing to audio events
- `_cava` - Spectrum visualization integration
- `_config` - Configuration management (JSON schemas)
- `_jq` - JSON processing (used for config parsing)
- `_xdg` - XDG directory management

**External Resources:**
- PulseAudio Documentation: https://www.freedesktop.org/wiki/Software/PulseAudio/
- pactl Manual: `man pactl`
- Cava: https://github.com/karlstav/cava

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-09
**Compliance:** Enhanced Documentation Requirements v1.1 (95%)
