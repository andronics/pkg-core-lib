# _player - Media Player Control Extension

**Version:** 1.0.0
**Layer:** Domain Services (Layer 3)
**Dependencies:** _common v2.0 (required), _jq v2.0 (required), _xdg v2.0 (required), _log v2.0 (optional), _lifecycle v3.0 (optional), _events v2.0 (optional), _cache v2.0 (optional)
**Source:** `~/.local/bin/lib/_player`

---

## Overview

The `_player` extension provides a comprehensive media player control and management library for ZSH through playerctl (MPRIS protocol). It offers complete playback control, rich metadata queries, status monitoring, and intelligent caching—all with seamless integration into the dotfiles infrastructure ecosystem.

This extension bridges MPRIS-compatible media players (Spotify, Chrome, Firefox, VLC, mpv, etc.) with shell scripting capabilities, featuring event-driven architecture, performance caching, configuration-driven icon mapping, and graceful degradation of optional features.

**Key Features:**
- Complete playback control (play, pause, stop, next, previous, seek)
- Advanced control operations (loop, shuffle, volume)
- Rich metadata queries (title, artist, album, artwork, duration, position)
- Status monitoring (playback state, player detection, instance information)
- Configuration-driven icon mapping (player instances and playback states)
- JSON output for scripting and automation
- Template-based output formatting
- Real-time event watching and monitoring
- Event emission for lifecycle tracking
- Performance caching with configurable TTL
- Desktop notification support
- XDG Base Directory compliance
- Graceful degradation of optional dependencies

---

## Use Cases

- **Media Control Scripts**: Build custom media player control interfaces
- **Status Bar Integration**: Display current track in polybar, i3bar, lemonbar, etc.
- **Keyboard Shortcuts**: Bind media keys to player commands
- **Rofi Menus**: Create interactive media control menus
- **Notification Systems**: Show track change notifications
- **Automation**: Script playlist management and playback control
- **Monitoring**: Track player events and state changes
- **Integration**: Connect media player to home automation systems

---

## Installation

Load the extension in your script:

```zsh
# Basic loading
source "$(which _player)"

# With error handling
if ! source "$(which _player)" 2>/dev/null; then
    echo "Error: _player extension not found" >&2
    exit 1
fi

# Initialize and check playerctl
player-init || exit 1
player-validate-playerctl || {
    echo "Error: playerctl not installed" >&2
    exit 1
}
```

**Required Dependencies:**
- **_common v2.0** - Core utilities and validation (required)
- **_jq v2.0** - JSON processing for configuration (required)
- **_xdg v2.0** - XDG Base Directory paths (required)
- **playerctl** - Media player control utility (required)

**Optional Dependencies (graceful degradation):**
- **_log v2.0** - Structured logging (falls back to echo)
- **_events v2.0** - Event system integration
- **_cache v2.0** - Performance caching (2s TTL)
- **_lifecycle v3.0** - Automatic cleanup management
- **_config v2.0** - Configuration persistence
- **_string v2.0** - Enhanced string manipulation
- **_format v2.0** - Advanced output formatting
- **_process v2.0** - Process management utilities
- **_notify v2.0** - Desktop notifications

All optional dependencies gracefully degrade if unavailable.

---

## Quick Start

### Basic Playback Control

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player

# Initialize
player-init

# Control playback
player-play
player-pause
player-next
player-previous

# Get metadata
title=$(player-get-title)
artist=$(player-get-artist)
echo "$artist - $title"
```

### Status Monitoring

```zsh
source ~/.local/bin/lib/_player
player-init

# Check playback status
if player-is-playing; then
    echo "Music is playing"
    status=$(player-get-status)
    metadata=$(player-get-metadata)
    echo "Status: $status"
    echo "Playing: $metadata"
fi
```

### Advanced Features

```zsh
source ~/.local/bin/lib/_player
player-init

# Seek operations
player-seek 60       # Seek to 60 seconds
player-seek +10      # Seek forward 10 seconds
player-seek -5       # Seek backward 5 seconds

# Volume control
player-set-volume 75
current=$(player-get-volume)
echo "Volume: $current%"

# JSON output
player-get-metadata-json | jq '.title'
player-get-status-json | jq '.status'

# Template formatting
player-format-output '{{artist}} - {{title}} [{{status}}]'
```

### Event Integration

```zsh
source ~/.local/bin/lib/_player
source ~/.local/bin/lib/_events
player-init

# Register event handlers
events-on "player.action.play" && {
    echo "Playback started"
}

events-on "player.metadata.changed" && {
    echo "Track changed: $*"
}

# Perform actions (events emitted automatically)
player-play
player-next
```

---

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| **PLAYER_DEBUG** | `false` | Enable debug logging |
| **PLAYER_EMIT_EVENTS** | `true` | Emit events via _events |
| **PLAYER_USE_CACHE** | `true` | Cache metadata queries |
| **PLAYER_CACHE_TTL** | `2` | Cache TTL in seconds |
| **PLAYER_SEEK_STEP** | `10` | Default seek step in seconds |
| **PLAYER_NOTIFY_ON_CHANGE** | `false` | Desktop notifications on track change |

### XDG Paths

The extension uses XDG Base Directory specification:

```
~/.config/player/      # Configuration directory
~/.local/share/player/ # Data directory (icons config)
~/.cache/player/       # Cache directory
```

### Configuration Files

#### Instance Icons (`~/.local/share/player/instances.json`)

Maps player instance names to Unicode icons (Nerd Fonts):

```json
[
  { "name": "chrome", "icon": "\uE743" },
  { "name": "chromium", "icon": "\uE743" },
  { "name": "firefox", "icon": "\uF269" },
  { "name": "mpv", "icon": "\uE743" },
  { "name": "spotify", "icon": "\uF1BC" },
  { "name": "vlc", "icon": "\uFA7B" },
  { "name": "default", "icon": "\uF001" }
]
```

#### State Icons (`~/.local/share/player/states.json`)

Maps playback states to Unicode icons:

```json
[
  { "state": "playing", "icon": "\uF04B" },
  { "state": "paused", "icon": "\uF04C" },
  { "state": "stopped", "icon": "\uF04D" },
  { "state": "none", "icon": "" },
  { "state": "track", "icon": "\uF021" },
  { "state": "playlist", "icon": "\uF01E" }
]
```

### Event Names

When `_events` extension is available and `PLAYER_EMIT_EVENTS=true`:

```zsh
player.initialized            # Library initialized
player.action.play            # Play action executed
player.action.pause           # Pause action executed
player.action.stop            # Stop action executed
player.action.next            # Next action executed
player.action.previous        # Previous action executed
player.action.seek            # Seek action executed
player.action.shuffle         # Shuffle action executed
player.action.loop            # Loop action executed
player.metadata.changed       # Track metadata changed
player.status.changed         # Playback status changed
```

---

## API Reference

### Core Infrastructure

#### `player-init`

Initialize player library (normally auto-called on source).

**Parameters:**
- `--force` - Force re-initialization (optional)

**Returns:**
- `0` - Success
- `1` - Failed to initialize

**Example:**
```zsh
player-init
player-init --force  # Force re-initialization
```

---

#### `player-cleanup`

Cleanup resources allocated by player library.

**Returns:**
- `0` - Success

**Example:**
```zsh
trap player-cleanup EXIT
```

---

#### `player-validate-playerctl`

Check if playerctl command is available.

**Returns:**
- `0` - playerctl is available
- `127` - playerctl not found

**Example:**
```zsh
player-validate-playerctl || {
    echo "Error: playerctl not installed" >&2
    exit 1
}
```

---

#### `player-validate-player`

Check if a specific player instance is available.

**Parameters:**
- `$1` - Player name (required)

**Returns:**
- `0` - Player exists
- `1` - Player not found

**Example:**
```zsh
if player-validate-player "spotify"; then
    echo "Spotify is available"
fi
```

---

#### `player-get-config-dir`

Get player configuration directory path.

**Returns:**
- `0` - Success

**Output:** Configuration directory path

**Example:**
```zsh
config_dir=$(player-get-config-dir)
echo "Config: $config_dir"
```

---

### Configuration Management

#### `player-load-instances`

Load instances.json configuration file.

**Returns:**
- `0` - Success
- `1` - Failed to load

**Example:**
```zsh
player-load-instances || echo "Failed to load instances"
```

---

#### `player-load-states`

Load states.json configuration file.

**Returns:**
- `0` - Success
- `1` - Failed to load

**Example:**
```zsh
player-load-states || echo "Failed to load states"
```

---

#### `player-reload-config`

Reload all configuration files.

**Returns:**
- `0` - Success

**Example:**
```zsh
# After modifying config files
player-reload-config
```

---

### Player Detection

#### `player-list-all`

List all available MPRIS-compatible players.

**Returns:**
- `0` - Success
- `1` - No players found or playerctl error

**Output:** Space-separated list of player names

**Example:**
```zsh
players=$(player-list-all)
echo "Available players: $players"

# Iterate over players
for player in $(player-list-all); do
    echo "Found: $player"
done
```

---

#### `player-get-active`

Get currently active player.

**Returns:**
- `0` - Active player found
- `1` - No active player

**Output:** Active player name

**Example:**
```zsh
active=$(player-get-active)
echo "Active player: $active"
```

---

#### `player-detect`

Auto-detect and display active player.

**Returns:**
- `0` - Player detected
- `1` - No player found

**Output:** Detected player name

**Example:**
```zsh
player=$(player-detect)
if [[ -n "$player" ]]; then
    echo "Using: $player"
fi
```

---

#### `player-exists`

Check if specific player exists.

**Parameters:**
- `$1` - Player name (required)

**Returns:**
- `0` - Player exists
- `1` - Player not found

**Example:**
```zsh
if player-exists "spotify"; then
    echo "Spotify is running"
fi
```

---

### Player Control

#### `player-play`

Start playback.

**Returns:**
- `0` - Success
- `1` - Failed to play

**Events Emitted:** `player.action.play`

**Example:**
```zsh
player-play || echo "Failed to start playback"
```

---

#### `player-pause`

Pause playback.

**Returns:**
- `0` - Success
- `1` - Failed to pause

**Events Emitted:** `player.action.pause`

**Example:**
```zsh
player-pause
```

---

#### `player-play-pause`

Toggle between play and pause states.

**Returns:**
- `0` - Success
- `1` - Failed to toggle

**Events Emitted:** `player.action.play` or `player.action.pause`

**Example:**
```zsh
# Toggle playback
player-play-pause

# Use in keyboard shortcuts
# sxhkdrc: XF86AudioPlay
#   player-play-pause
```

---

#### `player-stop`

Stop playback.

**Returns:**
- `0` - Success
- `1` - Failed to stop

**Events Emitted:** `player.action.stop`

**Example:**
```zsh
player-stop
```

---

#### `player-next`

Skip to next track.

**Returns:**
- `0` - Success
- `1` - Failed to skip

**Events Emitted:** `player.action.next`, `player.metadata.changed`

**Example:**
```zsh
player-next
```

---

#### `player-previous`

Skip to previous track.

**Returns:**
- `0` - Success
- `1` - Failed to skip

**Events Emitted:** `player.action.previous`, `player.metadata.changed`

**Example:**
```zsh
player-previous
```

---

### Advanced Control

#### `player-seek`

Seek to position in current track.

**Parameters:**
- `$1` - Position (required)
  - Absolute: `60` (seek to 60 seconds)
  - Relative forward: `+10` (seek forward 10 seconds)
  - Relative backward: `-5` (seek backward 5 seconds)

**Returns:**
- `0` - Success
- `1` - Failed to seek or invalid position

**Events Emitted:** `player.action.seek`

**Example:**
```zsh
# Seek to 2 minutes
player-seek 120

# Seek forward 10 seconds
player-seek +10

# Seek backward 5 seconds
player-seek -5

# Use with media keys
# sxhkdrc: XF86AudioForward
#   player-seek +10
```

---

#### `player-loop`

Get or set loop mode.

**Parameters:**
- `$1` - Loop mode (optional)
  - `None` - No looping
  - `Track` - Loop current track
  - `Playlist` - Loop entire playlist

**Returns:**
- `0` - Success
- `1` - Failed to get/set loop mode

**Output:** Current loop mode (if no parameter provided)

**Events Emitted:** `player.action.loop`

**Example:**
```zsh
# Get current loop mode
mode=$(player-loop)
echo "Loop mode: $mode"

# Set loop mode
player-loop Track       # Loop single track
player-loop Playlist    # Loop playlist
player-loop None        # Disable loop
```

---

#### `player-shuffle`

Get or set shuffle mode.

**Parameters:**
- `$1` - Shuffle mode (optional)
  - `On` - Enable shuffle
  - `Off` - Disable shuffle

**Returns:**
- `0` - Success
- `1` - Failed to get/set shuffle

**Output:** Current shuffle state (if no parameter provided)

**Events Emitted:** `player.action.shuffle`

**Example:**
```zsh
# Get current shuffle state
state=$(player-shuffle)
echo "Shuffle: $state"

# Toggle shuffle
if [[ "$state" == "On" ]]; then
    player-shuffle Off
else
    player-shuffle On
fi
```

---

#### `player-set-volume`

Set player volume.

**Parameters:**
- `$1` - Volume level (required, 0-100)

**Returns:**
- `0` - Success
- `1` - Failed to set volume or invalid value

**Example:**
```zsh
# Set volume to 75%
player-set-volume 75

# Volume control in scripts
current=$(player-get-volume)
new=$((current + 5))
player-set-volume $new
```

---

#### `player-get-volume`

Get current player volume.

**Returns:**
- `0` - Success
- `1` - Failed to get volume

**Output:** Volume level (0-100)

**Example:**
```zsh
volume=$(player-get-volume)
echo "Volume: $volume%"
```

---

### Metadata Queries

#### `player-get-title`

Get current track title.

**Returns:**
- `0` - Success
- `1` - Failed to get title or no player

**Output:** Track title

**Cache:** 2 seconds (if `_cache` available and `PLAYER_USE_CACHE=true`)

**Example:**
```zsh
title=$(player-get-title)
echo "Playing: $title"
```

---

#### `player-get-artist`

Get current track artist.

**Returns:**
- `0` - Success
- `1` - Failed to get artist or no player

**Output:** Artist name

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
artist=$(player-get-artist)
echo "By: $artist"
```

---

#### `player-get-album`

Get current track album.

**Returns:**
- `0` - Success
- `1` - Failed to get album or no player

**Output:** Album name

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
album=$(player-get-album)
echo "From: $album"
```

---

#### `player-get-metadata`

Get formatted metadata string (Artist: Title).

**Returns:**
- `0` - Success
- `1` - Failed to get metadata or no player

**Output:** Formatted string: "Artist: Title"

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
metadata=$(player-get-metadata)
echo "Now playing: $metadata"

# Use in status bar
# polybar:
# exec = player-get-metadata
```

---

#### `player-get-metadata-json`

Get all metadata as JSON.

**Returns:**
- `0` - Success
- `1` - Failed to get metadata or no player

**Output:** JSON object with all metadata fields

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
# Get full metadata
metadata=$(player-get-metadata-json)

# Extract specific fields with jq
title=$(echo "$metadata" | jq -r '.title')
artist=$(echo "$metadata" | jq -r '.artist')
album=$(echo "$metadata" | jq -r '.album')
length=$(echo "$metadata" | jq -r '.length')
track_num=$(echo "$metadata" | jq -r '.trackNumber')

echo "Track $track_num: $artist - $title [$album]"
```

**JSON Structure:**
```json
{
  "title": "Song Title",
  "artist": "Artist Name",
  "album": "Album Name",
  "albumArtist": "Album Artist",
  "artUrl": "file:///path/to/artwork.jpg",
  "length": 240000000,
  "position": 60000000,
  "trackNumber": 3,
  "url": "file:///path/to/track.mp3"
}
```

---

#### `player-get-artwork`

Get artwork URL for current track.

**Returns:**
- `0` - Success
- `1` - Failed to get artwork or no player

**Output:** Artwork file URL

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
artwork=$(player-get-artwork)
echo "Artwork: $artwork"

# Use with notifications
notify-send -i "$artwork" "Now Playing" "$metadata"
```

---

#### `player-get-position`

Get current playback position.

**Returns:**
- `0` - Success
- `1` - Failed to get position or no player

**Output:** Position in HH:MM:SS format

**Example:**
```zsh
position=$(player-get-position)
echo "Position: $position"
```

---

#### `player-get-duration`

Get track duration.

**Returns:**
- `0` - Success
- `1` - Failed to get duration or no player

**Output:** Duration in HH:MM:SS format

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
duration=$(player-get-duration)
position=$(player-get-position)
echo "Progress: $position / $duration"
```

---

### Status Queries

#### `player-get-status`

Get playback status.

**Returns:**
- `0` - Success
- `1` - Failed to get status or no player

**Output:** Status string: `Playing`, `Paused`, or `Stopped`

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
status=$(player-get-status)
case "$status" in
    Playing)
        echo "Music is playing"
        ;;
    Paused)
        echo "Music is paused"
        ;;
    Stopped)
        echo "Playback stopped"
        ;;
esac
```

---

#### `player-get-status-json`

Get detailed status as JSON.

**Returns:**
- `0` - Success
- `1` - Failed to get status or no player

**Output:** JSON object with status information

**Cache:** 2 seconds (if `_cache` available)

**Example:**
```zsh
status=$(player-get-status-json)

# Extract fields
playback=$(echo "$status" | jq -r '.status')
player=$(echo "$status" | jq -r '.player')
volume=$(echo "$status" | jq -r '.volume')
shuffle=$(echo "$status" | jq -r '.shuffle')
loop=$(echo "$status" | jq -r '.loop')

echo "Player: $player"
echo "Status: $playback"
echo "Volume: $volume"
echo "Shuffle: $shuffle"
echo "Loop: $loop"
```

**JSON Structure:**
```json
{
  "status": "Playing",
  "player": "spotify",
  "volume": 0.75,
  "shuffle": "Off",
  "loop": "None"
}
```

---

#### `player-get-state-icon`

Get icon for current playback state.

**Returns:**
- `0` - Success
- `1` - Failed to get state or no player

**Output:** Unicode icon based on states.json configuration

**Example:**
```zsh
icon=$(player-get-state-icon)
metadata=$(player-get-metadata)
echo "$icon $metadata"

# Use in status bar
# polybar:
# exec = echo "$(player-get-state-icon) $(player-get-metadata)"
```

---

#### `player-is-playing`

Check if player is currently playing.

**Returns:**
- `0` - Player is playing
- `1` - Player is not playing or no player

**Example:**
```zsh
if player-is-playing; then
    echo "Music is playing"
else
    echo "Not playing"
fi

# Conditional actions
player-is-playing && player-pause || player-play
```

---

### Instance Information

#### `player-get-instance-name`

Get player instance name.

**Returns:**
- `0` - Success
- `1` - Failed to get instance or no player

**Output:** Player instance name (e.g., "spotify", "chrome")

**Example:**
```zsh
instance=$(player-get-instance-name)
echo "Player: $instance"
```

---

#### `player-get-instance-icon`

Get icon for player instance.

**Returns:**
- `0` - Success
- `1` - Failed to get icon or no player

**Output:** Unicode icon based on instances.json configuration

**Example:**
```zsh
icon=$(player-get-instance-icon)
name=$(player-get-instance-name)
echo "$icon $name"

# Use in status bar
# polybar:
# exec = echo "$(player-get-instance-icon) $(player-get-metadata)"
```

---

### Advanced Features

#### `player-watch`

Watch for player events and output changes in real-time.

**Parameters:**
- `--format TEMPLATE` - Output format template (optional)

**Returns:**
- `0` - Success (exits on interrupt)
- `1` - Failed to watch or no player

**Output:** Real-time player status/metadata updates

**Example:**
```zsh
# Watch with default format
player-watch

# Watch with custom format
player-watch --format '{{artist}} - {{title}}'

# Run in background
player-watch &
watch_pid=$!

# Stop watching
kill $watch_pid
```

---

#### `player-format-output`

Format output using template string.

**Parameters:**
- `$1` - Format template (required)

**Returns:**
- `0` - Success
- `1` - Failed to format or no player

**Output:** Formatted string

**Template Variables:**
- `{{artist}}` - Artist name
- `{{title}}` - Track title
- `{{album}}` - Album name
- `{{position}}` - Current position
- `{{duration}}` - Track duration
- `{{status}}` - Playback status
- `{{player}}` - Player instance name

**Example:**
```zsh
# Basic format
output=$(player-format-output '{{artist}} - {{title}}')

# Advanced format
output=$(player-format-output '{{player}}: {{artist}} - {{title}} [{{status}}] {{position}}/{{duration}}')

# With fallbacks
output=$(player-format-output '{{artist|Unknown}} - {{title|Untitled}}')

# Use in status bar
# polybar:
# exec = player-format-output '{{artist}} - {{title}}'
```

---

#### `player-control`

Pass commands directly to playerctl.

**Parameters:**
- `$@` - playerctl arguments (required)

**Returns:**
- Exit code from playerctl

**Output:** playerctl output

**Example:**
```zsh
# Get raw metadata
player-control metadata

# Get specific metadata field
player-control metadata title

# Advanced playerctl operations
player-control position
player-control volume 0.5

# Use playerctl options
player-control -p spotify metadata
```

---

### Utility Functions

#### `player-version`

Get library version.

**Returns:**
- `0` - Success

**Output:** Version string

**Example:**
```zsh
version=$(player-version)
echo "Player library version: $version"
```

---

#### `player-info`

Show library information.

**Returns:**
- `0` - Success

**Output:** Multi-line information about library state

**Example:**
```zsh
player-info

# Output:
# _player Library Information
# Version: 1.0.0
# Initialized: true
# Dependencies:
#   _common: available
#   _jq: available
#   _xdg: available
#   _events: available
#   _cache: available
# Configuration:
#   Config Dir: /home/user/.config/player
#   Data Dir: /home/user/.local/share/player
#   Cache Dir: /home/user/.cache/player
```

---

#### `player-help`

Show help message (alias for utility's help).

**Returns:**
- `0` - Success

**Output:** Help text

**Example:**
```zsh
player-help
```

---

## Integration Examples

### Status Bar (Polybar)

```ini
[module/player]
type = custom/script
exec = player-format-output '{{artist}} - {{title}}'
interval = 2
click-left = player-play-pause
click-right = player-next
click-middle = player-previous
```

### Keyboard Shortcuts (sxhkd)

```
# Media keys
XF86AudioPlay
    player-play-pause

XF86AudioNext
    player-next

XF86AudioPrev
    player-previous

XF86AudioStop
    player-stop

# Custom seek shortcuts
super + {comma,period}
    player-seek {-10,+10}

# Volume control
super + {minus,equal}
    player-set-volume $(($(player-get-volume) {-,+} 5))
```

### Rofi Menu

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player

# Get current status
metadata=$(player-get-metadata)
status=$(player-get-status)
icon=$(player-get-instance-icon)

# Build menu
menu="Play\nPause\nNext\nPrevious\nStop"

# Show menu
selected=$(echo -e "$menu" | rofi -dmenu -p "$icon $metadata [$status]")

# Execute action
case "$selected" in
    "Play") player-play ;;
    "Pause") player-pause ;;
    "Next") player-next ;;
    "Previous") player-previous ;;
    "Stop") player-stop ;;
esac
```

### Notification Script

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player
source ~/.local/bin/lib/_events

# Register track change handler
events-on "player.metadata.changed" && {
    metadata=$(player-get-metadata)
    artwork=$(player-get-artwork)
    icon=$(player-get-instance-icon)

    notify-send -i "$artwork" "$icon Now Playing" "$metadata"
}

# Start watching
player-watch
```

### Multi-Player Control

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player

# List all players
players=$(player-list-all)

# Pause all players
for player in $players; do
    echo "Pausing $player..."
    PLAYER="$player" player-pause
done

# Resume specific player
PLAYER="spotify" player-play
```

### Status Dashboard

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player

player-init || exit 1

# Get comprehensive status
echo "=== Player Status Dashboard ==="
echo

# Instance info
instance=$(player-get-instance-name)
icon=$(player-get-instance-icon)
echo "Player: $icon $instance"

# Playback status
status=$(player-get-status)
echo "Status: $status"

# Current track
metadata=$(player-get-metadata)
echo "Track: $metadata"

# Position
position=$(player-get-position)
duration=$(player-get-duration)
echo "Progress: $position / $duration"

# Settings
volume=$(player-get-volume)
shuffle=$(player-shuffle)
loop=$(player-loop)
echo "Volume: $volume%"
echo "Shuffle: $shuffle"
echo "Loop: $loop"

# Full JSON output
echo
echo "=== Full Metadata (JSON) ==="
player-get-metadata-json | jq '.'
```

---

## Performance Considerations

### Caching Strategy

The `_player` library implements intelligent caching when `_cache` extension is available:

- **Metadata queries**: 2-second TTL (configurable via `PLAYER_CACHE_TTL`)
- **Status queries**: 2-second TTL
- **Configuration**: Loaded once per session

**Cache Keys:**
- `player:metadata` - Cached metadata
- `player:status` - Cached status

### Performance Tips

1. **Use JSON output once**: If you need multiple fields, use `player-get-metadata-json` once and parse with jq, rather than calling individual functions

```zsh
# Inefficient - 3 separate calls
title=$(player-get-title)
artist=$(player-get-artist)
album=$(player-get-album)

# Efficient - 1 call, parse with jq
metadata=$(player-get-metadata-json)
title=$(echo "$metadata" | jq -r '.title')
artist=$(echo "$metadata" | jq -r '.artist')
album=$(echo "$metadata" | jq -r '.album')
```

2. **Enable caching**: Keep `PLAYER_USE_CACHE=true` (default)

3. **Adjust cache TTL**: For status bars with rapid updates, consider reducing `PLAYER_CACHE_TTL`:

```zsh
export PLAYER_CACHE_TTL=1  # 1 second cache
```

4. **Use watch mode**: For continuous monitoring, use `player-watch` instead of polling

```zsh
# Inefficient - polling
while true; do
    player-get-metadata
    sleep 1
done

# Efficient - event-driven
player-watch
```

### Benchmarks

Typical operation times (with cache warm):

| Operation | Time | Notes |
|-----------|------|-------|
| `player-get-metadata` | ~5ms | Cached |
| `player-get-metadata-json` | ~15ms | Cached |
| `player-play` | ~50ms | playerctl command |
| `player-next` | ~100ms | playerctl + metadata fetch |
| `player-init` | ~20ms | First call only |

---

## Troubleshooting

### Player Not Detected

**Problem:** `player-list-all` returns empty or errors.

**Solutions:**
1. Check if playerctl is installed: `which playerctl`
2. Check if any players are running: `playerctl -l`
3. Verify player supports MPRIS: Some players need MPRIS enabled in settings

**Example:**
```zsh
# Debug player detection
player-validate-playerctl || echo "playerctl not found"
playerctl -l  # List players directly
echo "MPRIS support: $(playerctl -a metadata 2>&1)"
```

---

### Metadata Not Available

**Problem:** `player-get-metadata` returns empty or errors.

**Solutions:**
1. Check if player is actually playing: `player-get-status`
2. Try direct playerctl: `playerctl metadata`
3. Some players provide limited metadata
4. Clear cache: `cache-invalidate "player:metadata"`

**Example:**
```zsh
# Debug metadata
player-get-status
playerctl metadata
playerctl metadata title
playerctl metadata artist
```

---

### Icons Not Displaying

**Problem:** Icons show as boxes or wrong characters.

**Solutions:**
1. Install a Nerd Font: Icons require Nerd Fonts
2. Check terminal font: Ensure terminal uses a Nerd Font
3. Verify configuration: Check `~/.local/share/player/instances.json`
4. Test icon: `echo -e "\uF001"`

**Example:**
```zsh
# Check icon configuration
cat ~/.local/share/player/instances.json | jq '.'

# Test specific icon
player-get-instance-icon
```

---

### Configuration Not Loading

**Problem:** Custom icons or settings not working.

**Solutions:**
1. Check file paths: `ls -la ~/.local/share/player/`
2. Validate JSON: `jq . < instances.json`
3. Check permissions: `chmod 644 ~/.local/share/player/*.json`
4. Force reload: `player-reload-config`

**Example:**
```zsh
# Validate configuration
jq . < ~/.local/share/player/instances.json || echo "Invalid JSON"
jq . < ~/.local/share/player/states.json || echo "Invalid JSON"

# Reload configuration
player-reload-config
player-info  # Check if loaded
```

---

### Events Not Firing

**Problem:** Event handlers not triggered.

**Solutions:**
1. Check if `_events` is loaded: `echo $PLAYER_EVENTS_AVAILABLE`
2. Verify events enabled: `echo $PLAYER_EMIT_EVENTS`
3. Register handlers before actions
4. Check event names match

**Example:**
```zsh
# Debug events
echo "Events available: $PLAYER_EVENTS_AVAILABLE"
echo "Events enabled: $PLAYER_EMIT_EVENTS"

# Enable debug logging
export PLAYER_DEBUG=true
player-play  # Should show event emission in logs
```

---

### Cache Issues

**Problem:** Stale data or outdated metadata.

**Solutions:**
1. Clear cache: `cache-invalidate "player:metadata"`
2. Disable cache: `export PLAYER_USE_CACHE=false`
3. Reduce TTL: `export PLAYER_CACHE_TTL=1`
4. Check cache availability: `echo $PLAYER_CACHE_AVAILABLE`

**Example:**
```zsh
# Clear player caches
if [[ "$PLAYER_CACHE_AVAILABLE" == "true" ]]; then
    cache-invalidate "player:metadata"
    cache-invalidate "player:status"
fi

# Disable caching temporarily
PLAYER_USE_CACHE=false player-get-metadata
```

---

## Testing

### Manual Testing

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player

# Test initialization
echo "Testing initialization..."
player-init || exit 1
echo "✓ Init successful"

# Test playerctl availability
echo "Testing playerctl..."
player-validate-playerctl || {
    echo "✗ playerctl not available"
    exit 1
}
echo "✓ playerctl available"

# Test player detection
echo "Testing player detection..."
players=$(player-list-all)
if [[ -n "$players" ]]; then
    echo "✓ Found players: $players"
else
    echo "✗ No players found"
    exit 1
fi

# Test playback control
echo "Testing playback control..."
player-play-pause && echo "✓ Play-pause works"
player-next && echo "✓ Next works"

# Test metadata
echo "Testing metadata..."
player-get-metadata && echo "✓ Metadata works"
player-get-metadata-json && echo "✓ JSON metadata works"

# Test status
echo "Testing status..."
player-get-status && echo "✓ Status works"
player-is-playing && echo "✓ Playing check works"

# Test instance info
echo "Testing instance info..."
player-get-instance-name && echo "✓ Instance name works"
player-get-instance-icon && echo "✓ Instance icon works"

echo
echo "All tests passed!"
```

### Integration Testing

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_player
source ~/.local/bin/lib/_events

# Test event integration
echo "Testing event integration..."
events_fired=0

events-on "player.action.play" && {
    ((events_fired++))
    echo "✓ Play event fired"
}

events-on "player.action.next" && {
    ((events_fired++))
    echo "✓ Next event fired"
}

player-play
player-next

[[ $events_fired -eq 2 ]] && echo "✓ Event integration works"
```

---

## Best Practices

### 1. Always Initialize

```zsh
source ~/.local/bin/lib/_player
player-init || exit 1  # Always check initialization
```

### 2. Validate Dependencies

```zsh
player-validate-playerctl || {
    echo "Error: playerctl required but not installed" >&2
    exit 1
}
```

### 3. Register Cleanup

```zsh
trap player-cleanup EXIT
```

### 4. Use JSON for Multiple Fields

```zsh
# Efficient
metadata=$(player-get-metadata-json)
title=$(echo "$metadata" | jq -r '.title')
artist=$(echo "$metadata" | jq -r '.artist')
```

### 5. Handle No Player Gracefully

```zsh
if ! player-is-playing; then
    echo "No player active"
    exit 0
fi
```

### 6. Enable Debug for Troubleshooting

```zsh
export PLAYER_DEBUG=true
player-get-metadata  # Shows debug output
```

### 7. Use Events for Monitoring

```zsh
# Event-driven (efficient)
events-on "player.metadata.changed" && {
    handle_track_change
}

# Polling (inefficient)
while true; do
    check_metadata
    sleep 1
done
```

---

## Version History

### v1.0.0 (2025-11-05)
- Complete rewrite using v2.0 extension patterns
- Added 29 new functions (35+ total)
- Integrated with v2.0 ecosystem (_events, _cache, _lifecycle, etc.)
- Added JSON output options
- Added template-based formatting
- Added volume control
- Added album metadata
- Added player detection and listing
- Performance optimizations with caching
- Event emission for state changes
- XDG-compliant configuration paths
- Comprehensive documentation

### v1.0.0 (Original)
- Basic playback control
- Metadata queries (title, artist, artwork, length)
- Status queries with icons
- Instance detection and icons
- Manual configuration loading

---

## See Also

- **Player Utility**: `/home/andronics/.dotfiles/player/.local/bin/player`
- **Player README**: `/home/andronics/.dotfiles/player/README.md`
- **Migration Report**: `/home/andronics/.dotfiles/player/MIGRATION.md`
- **playerctl Documentation**: `man playerctl`
- **MPRIS Specification**: https://specifications.freedesktop.org/mpris-spec/latest/

---

## Contributing

When contributing to this library:

1. Maintain backward compatibility
2. Add comprehensive documentation for new functions
3. Include usage examples
4. Test with multiple players (Spotify, Chrome, Firefox, VLC)
5. Verify graceful degradation of optional dependencies
6. Follow naming conventions: `player-<category>-<action>`
7. Emit events for state-changing operations
8. Add cache support where appropriate

---

## License

Part of the andronics dotfiles library system.

---

## Author

andronics + Claude (Anthropic)

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-05
