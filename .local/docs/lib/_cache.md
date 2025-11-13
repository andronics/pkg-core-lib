# _cache - High-Performance Caching Layer with TTL Support

**Version:** 1.0.0
**Layer:** Infrastructure (Layer 2)
**Dependencies:** _common v2.0 (required)
**Total Lines:** 2,890
**Functions:** 16
**Examples:** 12
**Last Updated:** 2025-11-07

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (120 lines) -->

## Quick Reference Index

### Table of Contents

- [Function Quick Reference](#function-quick-reference) (L24-45, ~22 lines)
- [Environment Variables Quick Reference](#environment-variables-quick-reference) (L46-65, ~20 lines)
- [Return Codes Quick Reference](#return-codes-quick-reference) (L66-78, ~13 lines)
- [Overview](#overview) (L79-120, ~42 lines)
- [Installation](#installation) (L121-170, ~50 lines)
- [Quick Start](#quick-start) (L171-350, ~180 lines)
- [Configuration](#configuration) (L351-440, ~90 lines)
- [API Reference](#api-reference) (L441-1450, ~1010 lines)
- [Advanced Usage](#advanced-usage) (L1451-1850, ~400 lines)
- [Best Practices](#best-practices) (L1851-2050, ~200 lines)
- [Troubleshooting](#troubleshooting) (L2051-2450, ~400 lines)
- [Architecture & Performance](#architecture--performance) (L2451-2750, ~300 lines)
- [Security Considerations](#security-considerations) (L2751-2850, ~100 lines)
- [External References](#external-references) (L2851-2890, ~40 lines)

---

## Function Quick Reference

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|-----------|------|
| `cache-set` | Store value with optional TTL | L153-196 | Low | [→](#cache-set) |
| `cache-get` | Retrieve value, automatic expiry | L198-226 | Low | [→](#cache-get) |
| `cache-has` | Check existence without retrieval | L228-243 | Low | [→](#cache-has) |
| `cache-clear` | Remove specific key | L245-262 | Low | [→](#cache-clear) |
| `cache-clear-namespace` | Clear all keys in namespace | L268-286 | Medium | [→](#cache-clear-namespace) |
| `cache-list-namespaces` | List all namespaces | L288-300 | Low | [→](#cache-list-namespaces) |
| `cache-clear-all` | Clear entire cache | L306-316 | Low | [→](#cache-clear-all) |
| `cache-stats` | Display cache statistics | L318-333 | Low | [→](#cache-stats) |
| `cache-size` | Get current entry count | L335-337 | Low | [→](#cache-size) |
| `cache-cleanup-expired` | Remove expired entries | L339-354 | Medium | [→](#cache-cleanup-expired) |
| `cache-list` | List entries with pattern | L356-375 | Low | [→](#cache-list) |
| `cache-save` | Persist cache to disk | L381-408 | Medium | [→](#cache-save) |
| `cache-load` | Restore cache from disk | L410-443 | Medium | [→](#cache-load) |
| `cache-init` | Initialize directories & load | L449-460 | Low | [→](#cache-init) |
| `cache-help` | Display help message | L466-527 | Low | [→](#cache-help) |
| `cache-self-test` | Run self-tests | L533-597 | High | [→](#cache-self-test) |

---

## Environment Variables Quick Reference

| Variable | Type | Default | Purpose | Link |
|----------|------|---------|---------|------|
| `CACHE_DEFAULT_TTL` | seconds | `3600` | Default TTL value | [→](#cache_default_ttl) |
| `CACHE_MAX_SIZE` | integer | `10000` | Max cache entries | [→](#cache_max_size) |
| `CACHE_VERBOSE` | boolean | `false` | Verbose logging | [→](#cache_verbose) |
| `CACHE_DEBUG` | boolean | `false` | Debug logging | [→](#cache_debug) |
| `CACHE_AUTO_PERSIST` | boolean | `false` | Auto-save on changes | [→](#cache_auto_persist) |
| `CACHE_DATA_DIR` | path | `$XDG_DATA_HOME/lib/cache` | Data directory | [→](#cache_data_dir) |
| `CACHE_STATE_DIR` | path | `$XDG_STATE_HOME/lib/cache` | State directory | [→](#cache_state_dir) |
| `CACHE_PERSIST_FILE` | path | `$CACHE_STATE_DIR/cache.dat` | Persistence file | [→](#cache_persist_file) |

---

## Return Codes Quick Reference

| Code | Meaning | Context | Link |
|------|---------|---------|------|
| `0` | Success | Operation completed successfully | [→](#return-code-0) |
| `1` | Not found/Miss | Key not found or expired | [→](#return-code-1) |
| `2` | Invalid parameters | Missing or invalid arguments | [→](#return-code-2) |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (42 lines) -->

## Overview

The `_cache` extension provides a **high-performance in-memory caching layer** for ZSH scripts with TTL-based automatic expiration, namespace management, and optional disk persistence. It's designed for performance-critical applications requiring fast data access patterns.

**Key Features:**
- **O(1) Access Time:** Hash-based storage for constant-time lookups
- **Automatic Expiration:** TTL-based entry lifecycle with O(n) cleanup
- **Namespace Support:** Logical grouping with hierarchical `namespace:key` format
- **Hit/Miss Tracking:** Per-key and global statistics for performance monitoring
- **Disk Persistence:** Base64-encoded serialization for session persistence
- **Memory Management:** Configurable size limits with automatic cleanup
- **XDG Compliance:** Standard `$XDG_DATA_HOME` and `$XDG_STATE_HOME` paths
- **Pattern Matching:** Glob-based cache listing and filtering
- **Zero Dependencies:** Only requires `_common` v2.0

**Architecture Highlights:**
- Three hash maps: `_CACHE_DATA`, `_CACHE_EXPIRY`, `_CACHE_HITS/MISSES`
- Separate storage for expiry logic (no periodic background cleanup)
- Lazy expiration on access (check + remove on get/has)
- Statistics maintained per-key and globally
- Atomic persistence (temp file + move pattern)

**Use Case Categories:**
- **API Response Caching** - Cache HTTP requests with reasonable TTL
- **Database Query Results** - Memoize expensive database queries
- **Computed Values** - Avoid re-computing expensive calculations
- **Session Management** - Temporary user session storage
- **Configuration Caching** - Cache parsed/processed config files
- **Rate Limiting** - Track request counts with expiration
- **File Metadata** - Cache file stats and content hashes
- **Idempotency Keys** - Prevent duplicate operations

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL (50 lines) -->

## Installation

### Standard Loading

```zsh
# Basic - with error handling
source "$(which _cache)" || {
    echo "Error: _cache extension not found" >&2
    exit 1
}

# With optional initialization
source "$(which _cache)"
cache-init  # Creates directories, loads persisted cache if CACHE_AUTO_PERSIST=true
```

### Verification

```zsh
# Check version
echo "$CACHE_VERSION"  # Outputs: 1.0.0

# Run self-tests
_cache self-test
# Output:
#   === Testing cache v1.0.0 ===
#   ...
#   Tests passed: 12/12
```

### Dependencies

**Required:**
- `_common` v2.0 - Validation, timestamps, XDG paths, temporary files

**Optional (graceful degradation):**
- None - extension is fully self-contained except for _common

### File Locations (via stow)

```
~/.local/bin/lib/_cache      → ~/.pkgs/lib/.local/bin/lib/_cache (symlink via stow)
~/.local/docs/lib/_cache.md  → ~/.pkgs/lib/.local/docs/lib/_cache.md (this file)
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM (180 lines) -->

## Quick Start

<!-- CONTEXT_GROUP: basic_operations -->

### 1. Basic Caching Pattern

Store and retrieve values with automatic expiration:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Store a value with 5-minute TTL
cache-set "username" "alice" 300

# Retrieve it
if username=$(cache-get "username"); then
    echo "Cached: $username"
else
    echo "Not found or expired"
    exit 1
fi

# Check existence (without retrieving)
if cache-has "username"; then
    echo "User cached"
fi

# Clear when done
cache-clear "username"
```

**Complexity:** Low | **Dependencies:** _common
**Typical Use:** Session tokens, API credentials, computed results

---

### 2. Namespace Organization

Organize related keys under namespaces for easy bulk operations:

```zsh
source "$(which _cache)"

# Set multiple related keys
cache-set "user:123:name" "Alice" 1800
cache-set "user:123:email" "alice@example.com" 1800
cache-set "user:456:name" "Bob" 1800

# List all namespaces
cache-list-namespaces
# Output: user

# Clear entire user namespace
cache-clear-namespace "user:123"

# Now user:456 still exists, but user:123:* keys are gone
cache-has "user:123:name"   # Returns 1 (not found)
cache-has "user:456:name"   # Returns 0 (exists)
```

**Format:** `namespace:key` or `ns1:ns2:key` (hierarchical)
**Tip:** Use lowercase, avoid spaces, keep prefixes short

---

### 3. TTL and Expiration

Choose appropriate TTL values for different data types:

```zsh
source "$(which _cache)"

# Fast-changing data (1 minute)
cache-set "stock:AAPL:price" "150.25" 60

# Medium-changing (30 minutes)
cache-set "user:profile" "$profile_json" 1800

# Rarely changing (24 hours)
cache-set "config:countries" "$countries_list" 86400

# Static data (never expires - use TTL=0)
cache-set "app:version" "1.0.0" 0

# Use default TTL from CACHE_DEFAULT_TTL
cache-set "temp:data" "value"  # Uses 3600s by default
```

**TTL Values Reference:**
```
0      = Never expires
1-60   = Seconds (realtime data)
300    = 5 minutes (API responses)
1800   = 30 minutes (session data)
3600   = 1 hour (default, general-purpose)
86400  = 24 hours (daily data)
604800 = 1 week (weekly data)
```

**Expiration Check:** Automatic on `cache-get` and `cache-has`

---

### 4. Cache Statistics & Monitoring

Track cache performance and memory usage:

```zsh
source "$(which _cache)"

# Perform operations
for i in {1..10}; do
    cache-set "key:$i" "value:$i" 300
done

cache-get "key:1"  # Hit
cache-get "key:1"  # Hit
cache-get "missing"  # Miss

# Display statistics
cache-stats
# Output:
# Cache Statistics:
#   Entries:     10 / 10000
#   Total Sets:  10
#   Total Hits:  2
#   Total Misses: 1
#   Hit Rate:    66%
#   Total Clears: 0

# Get size
size=$(cache-size)
echo "Current entries: $size"

# List entries with pattern
cache-list "key:*"
# Output:
# key:1: value:1... (ttl=299s, hits=2)
# key:2: value:2... (ttl=300s, hits=0)
```

**Interpret Hit Rate:**
- 80%+ = Excellent cache effectiveness
- 50-80% = Good cache hits
- <50% = Consider longer TTL values

---

### 5. Disk Persistence

Persist cache across script restarts:

```zsh
source "$(which _cache)"

# Enable auto-persistence
export CACHE_AUTO_PERSIST=true

# Initialize (loads any previously saved cache)
cache-init

# Check for data from previous run
if last_run=$(cache-get "app:last_run"); then
    echo "Previous run: $last_run"
else
    echo "First run"
fi

# Store persistent data
cache-set "app:last_run" "$(date)" 0  # Never expires

# Cache is automatically saved on:
# - cache-set, cache-clear, cache-clear-all
# - cache-cleanup-expired

# On script exit, persisted data survives
```

**File Format:** Base64-encoded `key|value|expiry|hits|misses`
**Location:** `$CACHE_STATE_DIR/cache.dat` (XDG-compliant)
**Automatic Persistence:** Triggered by `cache-set`, `cache-clear`, cleanup

---

### 6. Practical Example: API Response Caching

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

fetch_user() {
    local user_id="$1"
    local cache_key="api:user:$user_id"

    # Try cache first
    if data=$(cache-get "$cache_key"); then
        echo "$data"
        return 0
    fi

    # Cache miss - fetch from API
    echo "Fetching user $user_id..." >&2
    local data=$(curl -s "https://api.example.com/users/$user_id") || return 1

    # Cache for 5 minutes
    cache-set "$cache_key" "$data" 300

    echo "$data"
}

# First call: hits API
fetch_user 123

# Subsequent calls within 5 minutes: instant from cache
fetch_user 123
fetch_user 123

# After 5 minutes: hits API again
sleep 301
fetch_user 123
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (90 lines) -->

## Configuration

<!-- CONTEXT_GROUP: configuration -->

### Cache Directories

```zsh
# Data directory (XDG-compliant)
CACHE_DATA_DIR="$(common-lib-data-dir)/cache"
# Typically: ~/.local/share/dotfiles/lib/cache

# State/persistence directory (XDG-compliant)
CACHE_STATE_DIR="$(common-lib-state-dir)/cache"
# Typically: ~/.local/state/dotfiles/lib/cache

# Persistence file location
CACHE_PERSIST_FILE="$CACHE_STATE_DIR/cache.dat"
```

These are created automatically by `cache-init`.

---

### TTL Configuration

| Setting | Variable | Default | Range | Notes |
|---------|----------|---------|-------|-------|
| Default TTL | `CACHE_DEFAULT_TTL` | `3600` | 0+ | Used when no TTL specified in `cache-set` |
| No Expiry | TTL=`0` | N/A | special | Entry never expires unless cleared |
| Max TTL | None | ∞ | 0+ | No upper limit enforced |

**Examples:**
```zsh
# Override default TTL
export CACHE_DEFAULT_TTL=600  # 10 minutes instead of 1 hour

# Use in cache-set
cache-set "key" "value"        # Uses 600s TTL
cache-set "key" "value" 300    # Overrides with 300s
cache-set "key" "value" 0      # No expiry
```

---

### Memory Management

| Setting | Variable | Default | Purpose |
|---------|----------|---------|---------|
| Max Entries | `CACHE_MAX_SIZE` | `10000` | Trigger cleanup when reached |
| Memory Per Entry | N/A | ~200-600 bytes | Key + value + metadata |
| Total Memory (typical) | N/A | ~2-5MB | Depends on entry size |

**Memory Calculation:**
```
Total Memory ≈ CACHE_MAX_SIZE × average_entry_size
Example: 10000 × 400 bytes = 4 MB
```

**Adjust for constraints:**
```zsh
# Limited memory environments
export CACHE_MAX_SIZE=1000      # ~400KB instead of 4MB
export CACHE_DEFAULT_TTL=600    # Shorter TTL = faster expiration

# Memory-rich environments
export CACHE_MAX_SIZE=50000     # ~20MB for large datasets
```

---

### Logging Configuration

```zsh
# Verbose logging (INFO level)
export CACHE_VERBOSE=true
# Output: [INFO] cache: message

# Debug logging (DEBUG level)
export CACHE_DEBUG=true
# Output: [DEBUG] cache: message

# Both can be enabled simultaneously
export CACHE_VERBOSE=true
export CACHE_DEBUG=true
```

**Debug Output Includes:**
- Set/Get/Clear operations with keys
- TTL and expiry calculations
- Cache hit/miss tracking
- Persistence operations

---

### Persistence Configuration

```zsh
# Auto-save on every change
export CACHE_AUTO_PERSIST=true
# Saves on: cache-set, cache-clear, cache-cleanup-expired

# Custom persistence file location
export CACHE_PERSIST_FILE="/tmp/custom-cache.dat"

# Manual persistence control
cache-save              # Save to $CACHE_PERSIST_FILE
cache-save "/tmp/backup.dat"  # Save to custom location
cache-load              # Load from $CACHE_PERSIST_FILE
cache-load "/tmp/backup.dat"  # Load from custom location
```

**Safety:** Persistence uses atomic writes (temp file + move)

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE (1010 lines) -->

## API Reference

<!-- CONTEXT_GROUP: core_operations -->

### Core Operations (Lines 153-286)

#### `cache-set`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:153-196` (44 lines)
- **Complexity:** Low
- **Dependencies:** `_common` (validation, timestamps)
- **Calls:** `_cache-log-*`, `_cache-auto-persist`
- **Used by:** All caching operations, examples

Store a value in cache with optional TTL.

**Syntax:**
```zsh
cache-set <key> <value> [ttl]
```

**Parameters:**
- `key` (required, string) - Cache key, supports `namespace:key` format
- `value` (required, string) - Value to store (any string)
- `ttl` (optional, integer) - Time-to-live in seconds
  - Default: `$CACHE_DEFAULT_TTL` (typically 3600)
  - `0` = Never expires
  - Positive integer = seconds until expiration

**Returns:**
- `0` - Success
- `2` - Invalid parameters (key/value missing or ttl non-numeric)

**Side Effects:**
- Creates/overwrites entry in `_CACHE_DATA`
- Sets expiry time in `_CACHE_EXPIRY` (if ttl > 0)
- Initializes hit/miss counters for key
- Increments `_CACHE_TOTAL_SETS`
- Triggers `cache-cleanup-expired` if `_CACHE_DATA` size >= `CACHE_MAX_SIZE`
- Calls `cache-save` if `CACHE_AUTO_PERSIST=true`
- Logs debug message if `CACHE_DEBUG=true`

**Examples:**

Example 1: Simple caching
```zsh
# Store with default TTL
cache-set "username" "alice"

# Store with explicit TTL
cache-set "session:abc123" "active" 1800  # 30 minutes

# Namespaced key
cache-set "user:123:name" "Alice" 300

# No expiration
cache-set "permanent:config" "v1.0" 0
```

Example 2: Error handling
```zsh
if cache-set "key" "value" 300; then
    echo "Cache stored successfully"
else
    echo "Failed to cache (invalid params?)"
fi
```

Example 3: Bulk setting with loop
```zsh
local -a data=(user:1 user:2 user:3)
for key in "${data[@]}"; do
    cache-set "$key" "some_value" 3600
done
```

Example 4: Conditional caching
```zsh
if [[ -n "$data" ]]; then
    cache-set "processed:data" "$data" 300
fi
```

**Notes:**
- Keys with colons (`:`) are treated as namespaced
- Values can contain any characters (special chars handled safely)
- TTL must be numeric; non-numeric causes return code 2
- Overwrites existing key if present (no merge behavior)
- Safe for concurrent reads (no mutual exclusion needed for simple access)

**See also:**
- `cache-get` [→ L198](#cache-get) - Retrieve cached values
- `cache-has` [→ L228](#cache-has) - Check without retrieval
- `_cache-auto-persist` [→ L144-147] - Automatic persistence trigger

---

#### `cache-get`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:198-226` (29 lines)
- **Complexity:** Low
- **Dependencies:** `_common` (timestamps)
- **Calls:** `_cache-is-expired`, `_cache-remove-expired`, `_cache-log-*`
- **Used by:** User code, API calls

Retrieve a value from cache, with automatic expiration checking.

**Syntax:**
```zsh
cache-get <key>
```

**Parameters:**
- `key` (required, string) - Cache key to retrieve

**Returns:**
- `0` - Success, value printed to stdout
- `1` - Key not found or expired
- `2` - Invalid parameters (key missing)

**Output:**
- On success: Cached value printed to stdout (one per call)
- On miss: Nothing printed (empty output)

**Side Effects:**
- Increments `_CACHE_HITS[$key]` if found and valid
- Increments `_CACHE_TOTAL_HITS` if found and valid
- Increments `_CACHE_MISSES[$key]` if not found or expired
- Increments `_CACHE_TOTAL_MISSES` if not found or expired
- Removes expired key from all cache hashes
- Logs debug message if `CACHE_DEBUG=true`

**Examples:**

Example 1: Basic retrieval
```zsh
# Get value or handle error
if value=$(cache-get "username"); then
    echo "User: $value"
else
    echo "Not cached"
fi
```

Example 2: With default fallback
```zsh
# Use cached value or compute default
theme=$(cache-get "config:theme" || echo "default")
```

Example 3: Validate before use
```zsh
if data=$(cache-get "data:key"); then
    [[ -n "$data" ]] && process_data "$data"
fi
```

Example 4: Statistics tracking
```zsh
for i in {1..100}; do
    if cache-get "key:$i" &>/dev/null; then
        echo "Hit"
    else
        echo "Miss"
    fi
done

cache-stats | grep "Hit Rate"
```

Example 5: Silent retrieval
```zsh
# Suppress error messages
data=$(cache-get "optional:key" 2>/dev/null) || data="default"
```

**Notes:**
- Automatic lazy expiration on access (no background cleanup)
- Expired keys are immediately removed from cache
- Return code `1` means either key not found OR expired
- Value is printed to stdout; capture with `$(...)` or pipes
- Empty values are valid (distinction between empty string and missing key impossible via exit code)

**Performance:**
- Access time: O(1) - constant time hash lookup
- Expiration check: O(1) - single timestamp comparison
- Expired cleanup: O(1) - remove from 4 hash maps

**See also:**
- `cache-has` [→ L228](#cache-has) - Check without retrieving value
- `cache-set` [→ L153](#cache-set) - Store values
- `cache-cleanup-expired` [→ L339](#cache-cleanup-expired) - Bulk expiration cleanup

---

#### `cache-has`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:228-243` (16 lines)
- **Complexity:** Low
- **Dependencies:** `_common` (timestamps)
- **Calls:** `_cache-is-expired`, `_cache-remove-expired`
- **Used by:** Conditional operations, existence checks

Check if a key exists and is not expired, without retrieving the value.

**Syntax:**
```zsh
cache-has <key>
```

**Parameters:**
- `key` (required, string) - Cache key to check

**Returns:**
- `0` - Key exists and is not expired
- `1` - Key not found or expired
- `2` - Invalid parameters (key missing)

**Side Effects:**
- Removes expired key from all cache hashes
- Does NOT update hit/miss counters (unlike `cache-get`)
- Logs if `CACHE_DEBUG=true`

**Examples:**

Example 1: Conditional operations
```zsh
if cache-has "user:123"; then
    data=$(cache-get "user:123")
    process_user "$data"
fi
```

Example 2: Lazy computation
```zsh
# Compute only if not cached
cache-has "expensive:result" || {
    result=$(run_expensive_operation)
    cache-set "expensive:result" "$result" 3600
}

# Now safe to get
result=$(cache-get "expensive:result")
```

Example 3: Guard clauses
```zsh
cache-has "config:loaded" || load_config
cache-has "db:connected" || connect_db
```

Example 4: Count cached items
```zsh
count=0
for key in user:1 user:2 user:3; do
    cache-has "$key" && ((count++))
done
echo "Cached users: $count"
```

**Notes:**
- Similar logic to `cache-get` but doesn't print value
- Preferred when you only need existence check
- Does not affect hit/miss statistics (pure check)
- Expired entries are removed on check (lazy cleanup)

**Performance:**
- Time complexity: O(1) - single hash lookup + timestamp check

**See also:**
- `cache-get` [→ L198](#cache-get) - Retrieve with value
- `cache-set` [→ L153](#cache-set) - Store values
- `cache-list` [→ L356](#cache-list) - Find keys by pattern

---

#### `cache-clear`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:245-262` (18 lines)
- **Complexity:** Low
- **Dependencies:** None (internal operations only)
- **Calls:** `_cache-log-*`, `_cache-auto-persist`
- **Used by:** Cache management, cleanup operations

Remove a specific key from cache.

**Syntax:**
```zsh
cache-clear <key>
```

**Parameters:**
- `key` (required, string) - Cache key to remove

**Returns:**
- `0` - Key removed successfully
- `1` - Key not found (not an error, idempotent)
- `2` - Invalid parameters (key missing)

**Side Effects:**
- Removes key from `_CACHE_DATA`
- Removes key from `_CACHE_EXPIRY`
- Removes key from `_CACHE_HITS` and `_CACHE_MISSES`
- Increments `_CACHE_TOTAL_CLEARS`
- Calls `cache-save` if `CACHE_AUTO_PERSIST=true`
- Logs if `CACHE_DEBUG=true`

**Examples:**

Example 1: Simple clearing
```zsh
cache-set "temp:data" "value"
cache-clear "temp:data"     # Removed
cache-has "temp:data"       # Returns 1 (not found)
```

Example 2: Idempotent clearing
```zsh
# Safe to call even if key doesn't exist
cache-clear "nonexistent"   # Returns 1, no error
```

Example 3: Cleanup pattern
```zsh
# Use after consuming cached value
data=$(cache-get "one-time:token")
[[ -n "$data" ]] && cache-clear "one-time:token"
```

Example 4: Conditional clearing
```zsh
cache-has "old:session" && cache-clear "old:session"
```

Example 5: Batch clearing
```zsh
for user_id in 123 456 789; do
    cache-clear "user:$user_id:session"
done
```

**Notes:**
- Idempotent - safe to clear already-cleared keys
- Doesn't fail if key doesn't exist (returns 1, not an error)
- Persists if `CACHE_AUTO_PERSIST=true`
- Does not verify key was actually removed

**Performance:**
- Time complexity: O(1) - remove from 4 hash maps

**See also:**
- `cache-set` [→ L153](#cache-set) - Store values
- `cache-clear-namespace` [→ L268](#cache-clear-namespace) - Clear multiple keys
- `cache-clear-all` [→ L306](#cache-clear-all) - Clear entire cache

---

<!-- CONTEXT_GROUP: namespace_operations -->

### Namespace Operations (Lines 268-300)

#### `cache-clear-namespace`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:268-286` (19 lines)
- **Complexity:** Medium
- **Dependencies:** None (calls `cache-clear` internally)
- **Calls:** `cache-clear` (loop), `_cache-log-*`
- **Used by:** Bulk cleanup, session management

Clear all keys matching a namespace prefix.

**Syntax:**
```zsh
cache-clear-namespace <namespace>
```

**Parameters:**
- `namespace` (required, string) - Namespace prefix (before first `:`)

**Returns:**
- `0` - Success (even if no keys found)
- `2` - Invalid parameters (namespace missing)

**Side Effects:**
- Calls `cache-clear` for each matching key (accumulates side effects)
- Logs verbose message if `CACHE_VERBOSE=true`

**Namespace Format:**
```
Standard format: namespace:key
Examples:
  user:123        (namespace: user)
  api:v1:users    (namespace: api, not api:v1)
  session:abc     (namespace: session)
```

**Examples:**

Example 1: Clear session namespace
```zsh
# Create session data
cache-set "session:user1" "data1"
cache-set "session:user2" "data2"

# Clear entire session namespace
cache-clear-namespace "session"

# Now all session:* keys are gone
cache-has "session:user1"   # Returns 1 (not found)
```

Example 2: User-specific cleanup
```zsh
# Store per-user cache
cache-set "user:123:profile" "data"
cache-set "user:123:sessions" "data"
cache-set "user:456:profile" "data"

# Clear specific user
cache-clear-namespace "user:123"

# user:456 still exists
cache-has "user:456:profile"  # Returns 0 (exists)
```

Example 3: Hierarchical namespaces
```zsh
# Setup hierarchy
cache-set "api:v1:users" "data"
cache-set "api:v1:posts" "data"
cache-set "api:v2:users" "data"

# Clear only v1
cache-clear-namespace "api:v1"  # Clears api:v1:*

# v2 still exists
cache-has "api:v2:users"  # Returns 0 (exists)
```

Example 4: Cleanup before shutdown
```zsh
cleanup() {
    cache-clear-namespace "temp"
    cache-clear-namespace "session"
    cache-save
}

trap cleanup EXIT
```

**Notes:**
- Matches keys starting with `namespace:` (prefix matching)
- Clears all `namespace:*` and `namespace:sub:*` keys
- Idempotent - safe to clear non-existent namespace
- Output: Count of cleared keys if `CACHE_VERBOSE=true`

**Performance:**
- Time complexity: O(n) where n = number of keys in namespace
- Calls `cache-clear` for each matched key

**See also:**
- `cache-clear` [→ L245](#cache-clear) - Clear single key
- `cache-list-namespaces` [→ L288](#cache-list-namespaces) - List available namespaces
- `cache-clear-all` [→ L306](#cache-clear-all) - Clear entire cache

---

#### `cache-list-namespaces`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:288-300` (13 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Calls:** None
- **Used by:** Introspection, debugging, namespace discovery

List all unique namespaces in cache.

**Syntax:**
```zsh
cache-list-namespaces
```

**Parameters:** None

**Returns:**
- `0` - Success

**Output:**
- One namespace per line, sorted alphabetically
- Only namespaces with keys are listed
- Keys without `:` are not listed (non-namespaced)

**Examples:**

Example 1: List all namespaces
```zsh
# Setup data
cache-set "user:1" "data"
cache-set "post:1" "data"
cache-set "api:users" "data"

cache-list-namespaces
# Output:
# api
# post
# user
```

Example 2: Count namespaces
```zsh
namespace_count=$(cache-list-namespaces | wc -l)
echo "Namespaces in use: $namespace_count"
```

Example 3: Namespace-based cleanup
```zsh
# Clear all temporary namespaces
cache-list-namespaces | grep "^temp:" | while read ns; do
    cache-clear-namespace "$ns"
done
```

Example 4: Find and process namespace
```zsh
if cache-list-namespaces | grep -q "^session$"; then
    echo "Session data found"
    cache-clear-namespace "session"
fi
```

**Notes:**
- Lists only first-level namespace (before first `:`)
- Returns unique namespaces (no duplicates)
- Sorted alphabetically for consistency
- Non-namespaced keys (no `:`) are not included
- Empty output if no namespaced keys exist

**Performance:**
- Time complexity: O(n log n) where n = number of keys (due to sort)
- Must iterate all keys to find namespaces

**See also:**
- `cache-list` [→ L356](#cache-list) - List keys with pattern
- `cache-clear-namespace` [→ L268](#cache-clear-namespace) - Clear by namespace

---

<!-- CONTEXT_GROUP: management_operations -->

### Cache Management (Lines 306-375)

#### `cache-clear-all`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:306-316` (11 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Calls:** `_cache-log-*`, `_cache-auto-persist`
- **Used by:** Full cache resets

Remove all cache entries, reset all statistics.

**Syntax:**
```zsh
cache-clear-all
```

**Parameters:** None

**Returns:**
- `0` - Success

**Side Effects:**
- Clears `_CACHE_DATA`
- Clears `_CACHE_EXPIRY`
- Clears `_CACHE_HITS` and `_CACHE_MISSES`
- Resets all global counters to 0
- Calls `cache-save` if `CACHE_AUTO_PERSIST=true`
- Logs verbose message if `CACHE_VERBOSE=true`

**Examples:**

Example 1: Full reset
```zsh
# Setup cache
cache-set "key1" "value1"
cache-set "key2" "value2"
cache-stats  # Shows: Entries: 2

# Clear everything
cache-clear-all
cache-stats  # Shows: Entries: 0 / 10000
```

Example 2: Reset for fresh start
```zsh
# Clear old cache, start fresh
cache-clear-all
cache-init

# Reinitialize with new data
cache-set "initialized" "true"
```

Example 3: Cleanup on error
```zsh
if operation_failed; then
    echo "Clearing corrupted cache..." >&2
    cache-clear-all
    cache-init
fi
```

**Notes:**
- Resets all statistics (hits, misses, sets, clears)
- Idempotent - safe to call on already empty cache
- If `CACHE_AUTO_PERSIST=true`, empty cache is persisted
- Cannot be undone except by reloading from disk

**Performance:**
- Time complexity: O(1) - reassign empty hash maps

**See also:**
- `cache-clear` [→ L245](#cache-clear) - Clear single key
- `cache-clear-namespace` [→ L268](#cache-clear-namespace) - Clear namespace
- `cache-cleanup-expired` [→ L339](#cache-cleanup-expired) - Remove only expired

---

#### `cache-stats`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:318-333` (16 lines)
- **Complexity:** Low
- **Dependencies:** None
- **Calls:** Arithmetic operations
- **Used by:** Performance monitoring, debugging

Display cache statistics and performance metrics.

**Syntax:**
```zsh
cache-stats
```

**Parameters:** None

**Returns:**
- `0` - Success

**Output:**
```
Cache Statistics:
  Entries:     COUNT / CACHE_MAX_SIZE
  Total Sets:  N
  Total Hits:  N
  Total Misses: N
  Hit Rate:    N%
  Total Clears: N
```

**Examples:**

Example 1: View statistics
```zsh
cache-stats
# Output:
# Cache Statistics:
#   Entries:     42 / 10000
#   Total Sets:  156
#   Total Hits:  523
#   Total Misses: 89
#   Hit Rate:    85%
#   Total Clears: 12
```

Example 2: Monitor over time
```zsh
while true; do
    echo "=== $(date) ==="
    cache-stats
    sleep 60
done
```

Example 3: Parse specific metric
```zsh
hit_rate=$(cache-stats | grep "Hit Rate" | awk '{print $3}' | tr -d '%')
echo "Current hit rate: $hit_rate%"

if [[ $hit_rate -lt 50 ]]; then
    echo "Warning: Low cache hit rate"
fi
```

Example 4: Alert on cache full
```zsh
size=$(cache-stats | grep "Entries" | awk '{print $2}')
max=$(cache-stats | grep "Entries" | awk '{print $4}')

if [[ $size -eq $max ]]; then
    echo "Cache full! Performance degraded." >&2
fi
```

**Metrics Interpretation:**

| Metric | Interpretation | Action |
|--------|----------------|--------|
| **Hit Rate 80%+** | Excellent | Keep current TTL |
| **Hit Rate 50-80%** | Good | Consider longer TTL |
| **Hit Rate <50%** | Poor | Increase TTL or cache size |
| **Entries near MAX** | Near capacity | Increase `CACHE_MAX_SIZE` or reduce TTL |

**Notes:**
- Hit Rate = Hits / (Hits + Misses) × 100
- Reset by `cache-clear-all`
- Hit Rate calculation uses integer division
- Ideal target: 80%+ hit rate

**Performance:**
- Time complexity: O(1) - no cache traversal

**See also:**
- `cache-size` [→ L335](#cache-size) - Get entry count only
- `cache-cleanup-expired` [→ L339](#cache-cleanup-expired) - Remove expired entries

---

#### `cache-size`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:335-337` (3 lines)
- **Complexity:** Very Low
- **Dependencies:** None
- **Calls:** None
- **Used by:** Monitoring, conditionals

Get current number of cache entries.

**Syntax:**
```zsh
cache-size
```

**Parameters:** None

**Returns:**
- `0` - Success, outputs entry count

**Output:**
- Integer representing current number of entries

**Examples:**

Example 1: Simple size check
```zsh
size=$(cache-size)
echo "Cache entries: $size"
```

Example 2: Monitor growth
```zsh
for i in {1..100}; do
    cache-set "key:$i" "value:$i"
    echo "Size: $(cache-size)"
done
```

Example 3: Detect full cache
```zsh
if [[ $(cache-size) -ge $CACHE_MAX_SIZE ]]; then
    echo "Cache full, performing cleanup..." >&2
    cache-cleanup-expired
fi
```

Example 4: Empty check
```zsh
if [[ $(cache-size) -eq 0 ]]; then
    echo "Cache is empty, initializing..."
    cache-init
fi
```

**Notes:**
- Extremely lightweight operation
- Returns exact count of entries
- Does not count expired entries (they exist in memory)

**Performance:**
- Time complexity: O(1) - hash count

**See also:**
- `cache-stats` [→ L318](#cache-stats) - Full statistics with hit rate
- `cache-cleanup-expired` [→ L339](#cache-cleanup-expired) - Remove expired entries

---

#### `cache-cleanup-expired`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:339-354` (16 lines)
- **Complexity:** Medium
- **Dependencies:** `_common` (timestamps)
- **Calls:** `_cache-is-expired`, `_cache-remove-expired`, `_cache-log-*`
- **Used by:** Memory management, scheduled cleanup

Remove all expired cache entries.

**Syntax:**
```zsh
cache-cleanup-expired
```

**Parameters:** None

**Returns:**
- `0` - Success

**Output:**
- If `CACHE_VERBOSE=true`: logs count of removed entries

**Side Effects:**
- Iterates all keys checking expiry
- Removes expired entries from all hashes
- Calls `cache-save` if `CACHE_AUTO_PERSIST=true`
- Logs if `CACHE_VERBOSE=true`

**Examples:**

Example 1: Manual cleanup
```zsh
# Check current size
echo "Before: $(cache-size) entries"

# Clean up expired
cache-cleanup-expired

# Check new size
echo "After: $(cache-size) entries"
```

Example 2: Scheduled background cleanup
```zsh
# Run cleanup every 5 minutes
while true; do
    sleep 300
    cache-cleanup-expired
done &
```

Example 3: Cleanup before persistence
```zsh
# Remove stale entries before saving
cache-cleanup-expired
cache-save
```

Example 4: Cleanup on low memory alert
```zsh
# Monitor and cleanup when needed
if [[ $(cache-size) -gt 8000 ]]; then
    echo "Cache approaching limit, cleaning..." >&2
    cache-cleanup-expired
fi
```

Example 5: Periodic maintenance
```zsh
# Cleanup handler for signal
cleanup_cache() {
    cache-cleanup-expired
    cache-save
}

# Triggered by signal or timer
trap cleanup_cache SIGALRM
```

**Notes:**
- Lazy expiration (checked on `cache-get`/`cache-has`) is built-in
- This function provides explicit bulk cleanup
- Useful for memory-constrained environments
- Automatically called when cache reaches `CACHE_MAX_SIZE`
- Does NOT reset statistics

**Performance:**
- Time complexity: O(n) where n = number of keys
- Must check expiry timestamp for each key
- Returns removed entry count

**When to use:**
- Scheduled maintenance (hourly/daily)
- Before saving cache to disk
- When memory is constrained
- Before sharing cache statistics

**See also:**
- `cache-set` [→ L153](#cache-set) - Automatic cleanup on cache full
- `cache-stats` [→ L318](#cache-stats) - View entry count
- `cache-save` [→ L381](#cache-save) - Persist cache

---

#### `cache-list`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:356-375` (20 lines)
- **Complexity:** Low
- **Dependencies:** `_common` (timestamps)
- **Calls:** `_cache-log-*`
- **Used by:** Debugging, introspection

List cache entries matching optional glob pattern.

**Syntax:**
```zsh
cache-list [pattern]
```

**Parameters:**
- `pattern` (optional, glob) - Glob pattern to match keys (default: `*` = all)

**Returns:**
- `0` - Success

**Output:**
- One line per matching entry:
- Format: `key: value_preview... (ttl=Ns, hits=N)` or `(no expiry, hits=N)`
- Value is truncated to first 50 characters

**Glob Patterns:**
```
*           All entries
user:*      All keys starting with user:
*:profile   All keys ending with :profile
*:123:*     Keys containing :123:
```

**Examples:**

Example 1: List all entries
```zsh
# Setup cache
cache-set "user:1" "Alice"
cache-set "user:2" "Bob"
cache-set "api:status" "online"

# List all
cache-list
# Output:
# api:status: online (ttl=3600s, hits=0)
# user:1: Alice (ttl=3600s, hits=0)
# user:2: Bob (ttl=3600s, hits=0)
```

Example 2: List by namespace
```zsh
# List only user namespace
cache-list "user:*"
# Output:
# user:1: Alice (ttl=3600s, hits=0)
# user:2: Bob (ttl=3600s, hits=0)
```

Example 3: Find by pattern
```zsh
# Find all temporary keys
cache-list "temp:*"

# Find with wildcard
cache-list "*:status"
```

Example 4: Count matching entries
```zsh
count=$(cache-list "user:*" | wc -l)
echo "Users cached: $count"
```

Example 5: Debug cache state
```zsh
echo "=== Cache State ==="
cache-list | head -10
echo "..."
echo "Total: $(cache-size) entries"
```

**Output Fields:**
```
key           - Full cache key with namespace
value_preview - First 50 characters of value
ttl=Ns        - Time remaining in seconds (if expiry set)
no expiry     - For keys with TTL=0
hits=N        - Number of hits for this key
```

**Notes:**
- Truncates values at 50 characters (prevents long output)
- Shows TTL remaining (now - expiry), not original TTL
- Hits counter reflects cache-get calls, not cache-has
- Output is unsorted (hash table order)

**Performance:**
- Time complexity: O(n) where n = number of keys
- Must check every key against pattern

**See also:**
- `cache-list-namespaces` [→ L288](#cache-list-namespaces) - List namespaces
- `cache-stats` [→ L318](#cache-stats) - Overall statistics
- `cache-has` [→ L228](#cache-has) - Check specific key

---

<!-- CONTEXT_GROUP: persistence_operations -->

### Persistence (Lines 381-460)

#### `cache-save`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:381-408` (28 lines)
- **Complexity:** Medium
- **Dependencies:** `_common` (directory creation, temp files)
- **Calls:** `common-ensure-dir`, `common-temp-file`
- **Used by:** Manual persistence, auto-persist trigger

Save cache to disk file with base64 encoding.

**Syntax:**
```zsh
cache-save [file]
```

**Parameters:**
- `file` (optional, path) - File to save to
  - Default: `$CACHE_PERSIST_FILE` (typically `~/.local/state/dotfiles/lib/cache/cache.dat`)
  - Creates directory if needed

**Returns:**
- `0` - Success

**Output:**
- If `CACHE_VERBOSE=true`: logs file path

**File Format:**
```
base64_encoded_key|base64_encoded_value|expiry_timestamp|hits|misses
base64_encoded_key|base64_encoded_value|expiry_timestamp|hits|misses
...
```

**Side Effects:**
- Creates file directory if needed (`common-ensure-dir`)
- Writes to temporary file first (atomic write)
- Moves temp file to final location (atomic operation)
- Preserves all entry metadata (expiry, hits, misses)

**Examples:**

Example 1: Manual save
```zsh
# Perform cache operations
cache-set "key1" "value1" 300
cache-set "key2" "value2" 600

# Manually save
cache-save
# Saved to: ~/.local/state/dotfiles/lib/cache/cache.dat
```

Example 2: Save to custom location
```zsh
# Backup cache
cache-save "/tmp/cache-backup-$(date +%s).dat"
```

Example 3: Explicit save on exit
```zsh
trap "cache-save" EXIT

# Operations...
cache-set "key" "value"

# On exit, cache is saved automatically
```

Example 4: Auto-persistence
```zsh
# Enable auto-save
export CACHE_AUTO_PERSIST=true

# Now every operation is automatically saved
cache-set "key1" "value"  # Auto-saved
cache-set "key2" "value"  # Auto-saved
cache-clear "key1"        # Auto-saved
```

Example 5: Conditional save
```zsh
if [[ $(cache-size) -gt 0 ]]; then
    cache-cleanup-expired
    cache-save
fi
```

**Notes:**
- Base64 encoding preserves special characters, newlines, etc.
- Atomic write pattern (temp file + move) prevents corruption
- All metadata (expiry, hit counters) is preserved
- Directory created if needed with `common-ensure-dir`
- No compression (plain text format for debugging)

**Safety:**
- Temp file written first, then moved
- Prevents partial writes on failure
- Safe for concurrent access (rename is atomic)

**Performance:**
- Time complexity: O(n) where n = number of entries
- Must iterate all keys to write file
- Depends on disk speed and file size

**File Size Estimate:**
```
Per entry overhead: ~50 bytes base64 + 20 bytes metadata
Example: 1000 entries × 70 bytes = ~70KB
```

**See also:**
- `cache-load` [→ L410](#cache-load) - Load from disk
- `cache-init` [→ L449](#cache-init) - Initialize with load
- `_cache-auto-persist` [→ L144-147] - Automatic save trigger

---

#### `cache-load`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:410-443` (34 lines)
- **Complexity:** Medium
- **Dependencies:** `_common` (timestamps)
- **Calls:** base64, file reading
- **Used by:** Initialization, recovery

Load cache from disk file with base64 decoding.

**Syntax:**
```zsh
cache-load [file]
```

**Parameters:**
- `file` (optional, path) - File to load from
  - Default: `$CACHE_PERSIST_FILE`

**Returns:**
- `0` - Success
- `1` - File not found (not an error)

**Output:**
- If `CACHE_VERBOSE=true`: logs count of loaded entries
- Logs skipped expired entries if `CACHE_DEBUG=true`

**Side Effects:**
- Reads and parses file
- Decodes base64 keys and values
- Merges entries into existing cache (overwrites duplicates)
- Skips expired entries during load
- Restores hit/miss counters from file

**Examples:**

Example 1: Manual load
```zsh
source "$(which _cache)"

# Load persisted cache
cache-load
echo "Loaded from: $CACHE_PERSIST_FILE"
```

Example 2: Load at startup
```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Initialize and load
cache-init  # Creates dirs and loads persisted cache
```

Example 3: Load from backup
```zsh
# Recover from backup
cache-load "/tmp/cache-backup.dat"
echo "Recovered $(cache-size) entries"
```

Example 4: Merge multiple caches
```zsh
# Merge multiple cache files
cache-load "/cache1.dat"
cache-load "/cache2.dat"  # Merges with cache1
cache-load "/cache3.dat"  # Merges with both
```

Example 5: Conditional load
```zsh
if [[ -f "$CACHE_PERSIST_FILE" ]]; then
    cache-load
    echo "Restored $(cache-size) entries"
else
    echo "No persisted cache found"
fi
```

**Notes:**
- Expired entries are skipped during load (not restored)
- Hit/miss counters are preserved from file
- Merges with existing cache (doesn't clear first)
- Safe to load non-existent file (returns 1, not an error)
- Base64 decoding handles special characters correctly

**File Format Parsing:**
```
Read each line: key|value|expiry|hits|misses
Decode key and value from base64
Check if expired (now >= expiry)
Skip if expired
Otherwise restore to cache
```

**Performance:**
- Time complexity: O(n) where n = number of entries
- Depends on file size and disk speed
- Base64 decoding is CPU-bound

**Recovery Strategies:**
```zsh
# Full cache reset and reload
cache-clear-all
cache-load

# Merge from backup
cache-load "/backup/cache-old.dat"

# Load and save to new location
cache-load "/old/cache.dat"
export CACHE_PERSIST_FILE="/new/cache.dat"
cache-save
```

**See also:**
- `cache-save` [→ L381](#cache-save) - Save to disk
- `cache-init` [→ L449](#cache-init) - Initialize and auto-load
- `cache-clear-all` [→ L306](#cache-clear-all) - Clear before load

---

#### `cache-init`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:449-460` (12 lines)
- **Complexity:** Low
- **Dependencies:** `_common` (directory creation)
- **Calls:** `common-ensure-dir`, `cache-load`
- **Used by:** Startup initialization

Initialize cache directories and optionally load persisted cache.

**Syntax:**
```zsh
cache-init
```

**Parameters:** None

**Returns:**
- `0` - Success

**Side Effects:**
- Creates `$CACHE_DATA_DIR` if needed
- Creates `$CACHE_STATE_DIR` if needed
- Calls `cache-load` if `CACHE_AUTO_PERSIST=true` and file exists
- Logs verbose message if `CACHE_VERBOSE=true`

**Behavior:**
```
cache-init:
  1. Create CACHE_DATA_DIR
  2. Create CACHE_STATE_DIR
  3. If CACHE_AUTO_PERSIST=true and persist file exists:
       - Load cache from file
     Else:
       - Initialize empty cache
  4. Return 0
```

**Examples:**

Example 1: Basic initialization
```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Initialize directories
cache-init

# Now ready to use
cache-set "key" "value"
```

Example 2: Initialize with persistence
```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Enable auto-persistence
export CACHE_AUTO_PERSIST=true

# Initialize - loads any previous cache
cache-init

# Cache loaded from disk if available
if cache-has "app:last_run"; then
    echo "Previous session detected"
fi
```

Example 3: Fresh start (clear old cache)
```zsh
# Clear old cache before init
cache-clear-all

# Re-initialize
cache-init

# Fresh empty cache
```

Example 4: Verify initialization
```zsh
cache-init

# Check directories exist
[[ -d "$CACHE_DATA_DIR" ]] && echo "Data dir OK"
[[ -d "$CACHE_STATE_DIR" ]] && echo "State dir OK"

# Check if cache loaded
if [[ $(cache-size) -gt 0 ]]; then
    echo "Loaded $(cache-size) entries"
fi
```

**Notes:**
- Safe to call multiple times (idempotent)
- Creates directories with default permissions
- If `CACHE_AUTO_PERSIST=false`: ignores persisted file
- Directories are XDG-compliant (`~/.local/share` and `~/.local/state`)

**Directory Paths (XDG-Compliant):**
```
CACHE_DATA_DIR  = $XDG_DATA_HOME/lib/cache
CACHE_STATE_DIR = $XDG_STATE_HOME/lib/cache
Default:
  ~/.local/share/dotfiles/lib/cache
  ~/.local/state/dotfiles/lib/cache
```

**Performance:**
- Time complexity: O(1) for directory creation
- O(n) if loading persisted cache

**See also:**
- `cache-save` [→ L381](#cache-save) - Save cache
- `cache-load` [→ L410](#cache-load) - Load from disk
- `cache-clear-all` [→ L306](#cache-clear-all) - Clear cache

---

#### `cache-help`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:466-527` (62 lines)
- **Complexity:** Very Low
- **Dependencies:** None
- **Calls:** None
- **Used by:** User reference, help system

Display built-in help message.

**Syntax:**
```zsh
cache-help
# OR when executed directly:
_cache help
```

**Returns:**
- `0` - Success

**Output:**
- Formatted help text with command list and examples

**See also:**
- Documentation at: `~/.local/docs/lib/_cache.md`
- Run tests: `_cache self-test`

---

#### `cache-self-test`

**Metadata:**
- **Source:** `~/.local/bin/lib/_cache:533-597` (65 lines)
- **Complexity:** High
- **Dependencies:** `_test` framework
- **Calls:** Various cache functions
- **Used by:** Testing, validation

Run comprehensive self-tests for cache extension.

**Syntax:**
```zsh
_cache self-test
# OR:
cache-self-test
```

**Returns:**
- `0` - All tests passed
- Non-zero - Tests failed

**Test Coverage:**
```
## Basic Tests
- Version is set

## Core Operations
- Set and get values
- Has detection for existing keys
- Has detection for missing keys
- Clear operation removes key

## TTL Tests
- Expiration after TTL seconds

## Namespace Tests
- Namespace clearing
- Namespace isolation
```

**Examples:**

Example 1: Run tests
```zsh
_cache self-test
# Output:
# === Testing cache v1.0.0 ===
# ## Basic Tests
# [PASS] version should be set
# ## Core Operations
# [PASS] should set and get value
# ...
# Tests passed: 12/12
```

Example 2: Test specific behavior
```zsh
# Run extension and test manually
source "$(which _cache)"

# Test TTL expiration
cache-set "test" "value" 1
sleep 2
cache-get "test" && echo "FAIL" || echo "PASS"
```

**Notes:**
- Requires `_test` framework (auto-loaded from same directory)
- Tests are non-destructive (cleanup after)
- Includes sleep for TTL testing (takes ~2 seconds)
- Tests basic functionality, not exhaustive coverage

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (400 lines) -->

## Advanced Usage

<!-- CONTEXT_GROUP: advanced_patterns -->

### Pattern 1: Cache-Aside (Lazy Loading)

Implement cache-aside pattern with transparent fallback:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

get_user_data() {
    local user_id="$1"
    local cache_key="user:${user_id}"

    # Try cache first
    if data=$(cache-get "$cache_key"); then
        echo "$data"
        return 0
    fi

    # Cache miss - fetch from source
    data=$(fetch_user_from_db "$user_id") || return 1

    # Cache for future access
    cache-set "$cache_key" "$data" 1800

    echo "$data"
}

fetch_user_from_db() {
    # Simulate database query
    sleep 1
    echo '{"id": '$1', "name": "User'$1'"}'
}

# Usage - transparent caching
get_user_data 123  # Slow - 1 second
get_user_data 123  # Fast - cached
```

**Benefits:**
- Transparent to caller
- Automatic fallback to source
- Simple to understand and maintain

**Use Cases:**
- Database query caching
- API response caching
- File content caching

---

### Pattern 2: Write-Through Caching

Update source and cache atomically:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

set_user_data() {
    local user_id="$1"
    local data="$2"
    local cache_key="user:${user_id}"

    # Write to source first
    if update_user_in_db "$user_id" "$data"; then
        # Then update cache
        cache-set "$cache_key" "$data" 1800
        return 0
    fi

    # If source update failed, don't cache
    return 1
}

update_user_in_db() {
    # Simulate database update
    echo "Updated $1: $2"
}

# Usage
set_user_data 123 '{"name": "Alice"}'
```

**Benefits:**
- Cache always consistent with source
- No stale data

**Drawbacks:**
- Slower writes (must hit source)
- Source must be available

---

### Pattern 3: Cache Warming

Pre-populate cache with frequently accessed data:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

warm_cache() {
    echo "Warming cache..." >&2

    # Fetch list of popular items
    local popular=$(fetch_popular_items)

    # Cache each one
    while IFS=$'\n' read -r item_id; do
        local data=$(fetch_item "$item_id")
        cache-set "item:${item_id}" "$data" 3600
        echo "Cached: item:${item_id}" >&2
    done <<< "$popular"

    echo "Cache warm - $(cache-size) items loaded" >&2
}

# Run at startup
cache-init
warm_cache

# Now immediate access to popular items
item=$(cache-get "item:popular1")
```

**Benefits:**
- Eliminates cold start delay
- Improved initial performance

**Use Cases:**
- App startup
- Server restart
- Configuration loading

---

### Pattern 4: Distributed Cache with TTL Sync

Multiple processes sharing same persisted cache:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Shared cache with auto-persistence
export CACHE_AUTO_PERSIST=true

cache-init

# Worker 1: Process and cache results
process_job() {
    local job_id="$1"

    local cache_key="job:${job_id}:result"

    # Check if already processed by other worker
    if cache-has "$cache_key"; then
        result=$(cache-get "$cache_key")
        echo "Already processed: $result"
        return 0
    fi

    # Process job
    result=$(perform_expensive_work "$job_id")

    # Cache for other workers (1 hour TTL)
    cache-set "$cache_key" "$result" 3600

    echo "Processed: $result"
}

# Multiple processes can safely share via:
# - File-based persistence
# - Atomic file operations
# - TTL-based consistency
```

**Benefits:**
- Multiple processes share results
- Avoids duplicate work

**Limitations:**
- No real-time invalidation
- TTL-based consistency

---

### Pattern 5: Cache Versioning

Manage multiple versions of cached data:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Version in cache key
CURRENT_VERSION="v2"

set_versioned() {
    local key="$1"
    local value="$2"

    # Include version in key
    local cache_key="${CURRENT_VERSION}:${key}"

    cache-set "$cache_key" "$value" 3600
}

get_versioned() {
    local key="$1"

    # Check current version first
    local cache_key="${CURRENT_VERSION}:${key}"
    if cache-get "$cache_key"; then
        return 0
    fi

    # Fallback to older versions
    for version in v1 v0; do
        cache_key="${version}:${key}"
        if cache-get "$cache_key"; then
            return 0
        fi
    done

    return 1
}

# Upgrade to new version
upgrade_version() {
    # Clear old versions
    cache-clear-namespace "v1"
    cache-clear-namespace "v0"

    CURRENT_VERSION="v2"
}
```

**Benefits:**
- Smooth version upgrades
- Backward compatibility
- No service interruption

---

### Pattern 6: Cache Invalidation

Explicit invalidation patterns:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

# Pattern 1: TTL-based (passive)
cache-set "user:123" "$user_data" 1800  # 30-minute TTL

# Pattern 2: Event-based (active)
update_user() {
    local user_id="$1"
    local new_data="$2"

    # Update source
    update_database "$user_id" "$new_data"

    # Invalidate cache
    cache-clear "user:${user_id}"

    # Warm cache with new data
    cache-set "user:${user_id}" "$new_data" 1800
}

# Pattern 3: Dependency-based
update_user_profile() {
    local user_id="$1"
    local profile="$2"

    # Update database
    update_database "$user_id" "$profile"

    # Invalidate dependent caches
    cache-clear "user:${user_id}:profile"
    cache-clear "user:${user_id}:recommendations"  # Depends on profile
    cache-clear "feed:user:${user_id}"              # Depends on profile
}

# Pattern 4: Cascading invalidation
invalidate_cascade() {
    local entity_type="$1"
    local entity_id="$2"

    # Clear entity and all dependents
    cache-clear-namespace "${entity_type}:${entity_id}"
    cache-clear-namespace "cache:dependent:${entity_type}:${entity_id}"
}
```

**Strategies:**
- **TTL**: Automatic expiration (simple, eventual consistency)
- **Event**: Active invalidation (complex, immediate consistency)
- **Dependency**: Graph-based invalidation (complex, optimal)

---

### Pattern 7: Cache Metrics & Monitoring

Track cache effectiveness:

```zsh
#!/usr/bin/env zsh
source "$(which _cache)"

export CACHE_VERBOSE=true
export CACHE_DEBUG=false

monitor_cache() {
    local interval="${1:-60}"  # seconds

    while true; do
        echo "=== Cache Monitor: $(date +%H:%M:%S) ==="

        # Display statistics
        cache-stats

        # Show largest namespace
        echo ""
        echo "Top namespaces:"
        cache-list | cut -d: -f1 | sort | uniq -c | sort -rn | head -3

        # Show memory estimate
        size=$(cache-size)
        memory_mb=$(echo "scale=2; $size * 0.0004" | bc)
        echo "Est. memory: ${memory_mb}MB"

        sleep "$interval"
    done
}

# Run in background
monitor_cache 30 &
```

**Metrics to Track:**
- Hit rate (target: 80%+)
- Memory usage
- Entry churn (sets vs clears)
- Namespace distribution

---

### Pattern 8: Graceful Degradation

Cache as optional optimization:

```zsh
#!/usr/bin/env zsh

# Load cache if available, continue without if not
if source "$(which _cache)" 2>/dev/null; then
    cache-init
    USE_CACHE=true
else
    USE_CACHE=false
fi

get_data() {
    local key="$1"

    if [[ "$USE_CACHE" == "true" ]] && cache-has "$key"; then
        cache-get "$key"
        return 0
    fi

    # Fallback to source
    fetch_from_source "$key"
}

set_data() {
    local key="$1"
    local value="$2"

    # Update source first
    update_source "$key" "$value" || return 1

    # Update cache if available
    if [[ "$USE_CACHE" == "true" ]]; then
        cache-set "$key" "$value" 3600
    fi

    return 0
}
```

**Benefits:**
- Application works with or without cache
- No hard dependency
- Graceful mode selection

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (200 lines) -->

## Best Practices

<!-- CONTEXT_GROUP: best_practices -->

### 1. Namespace Organization

**Good:**
```zsh
cache-set "user:123:profile" "data"
cache-set "user:123:settings" "data"
cache-set "post:456:content" "data"
```
- Hierarchical, logical grouping
- Easy to clear related entries
- Self-documenting keys

**Bad:**
```zsh
cache-set "user123profile" "data"
cache-set "post456content" "data"
```
- Flat, hard to manage
- No bulk operations possible
- Opaque key names

---

### 2. TTL Selection

**Guidelines by data type:**

```zsh
# Real-time data (seconds to minutes)
cache-set "stock:AAPL" "$price" 60        # 1 minute

# Session data (minutes to hours)
cache-set "session:abc123" "active" 1800  # 30 minutes

# Configuration (hours to days)
cache-set "config:theme" "dark" 86400     # 24 hours

# Static data (never)
cache-set "app:version" "1.0.0" 0         # Never expires
```

**Decision Tree:**
- Can tolerate 1-hour staleness? → Use 3600s
- Needs consistency within minutes? → Use 300-600s
- Must be real-time? → Use 30-60s or skip caching
- Never changes? → Use 0 (no expiry)

---

### 3. Cache-First vs Source-First

**Cache-First (for read-heavy):**
```zsh
# Try cache, fall back to source
if data=$(cache-get "$key"); then
    echo "$data"
else
    data=$(fetch_source)
    cache-set "$key" "$data"
    echo "$data"
fi
```

**Source-First (for write-heavy):**
```zsh
# Update source first, then cache
update_source "$data"
cache-set "$key" "$data"  # Or cache-clear
```

---

### 4. Memory Management

**Estimate and Configure:**
```zsh
# Per-entry cost: ~50 bytes overhead + value size
# Example: 1000 entries × 400 bytes = ~400KB

# Set conservative limit
export CACHE_MAX_SIZE=5000  # Not 10000

# Short TTL for space efficiency
export CACHE_DEFAULT_TTL=600  # 10 minutes not 1 hour

# Periodic cleanup
while true; do
    sleep 300
    cache-cleanup-expired
done &
```

---

### 5. Monitoring Cache Health

```zsh
# Check hit rate regularly
hit_rate=$(cache-stats | grep "Hit Rate" | awk '{print $3}' | tr -d '%')

if [[ $hit_rate -lt 60 ]]; then
    # Hit rate too low - increase TTL
    export CACHE_DEFAULT_TTL=1800
    echo "Warning: Low cache hit rate: $hit_rate%" >&2
fi

# Monitor memory
if [[ $(cache-size) -eq $CACHE_MAX_SIZE ]]; then
    echo "Cache at capacity" >&2
    cache-cleanup-expired
fi
```

---

### 6. Safe Concurrent Access

Cache is NOT thread-safe. For concurrent access:

```zsh
# Option 1: Separate cache per process
# Each process has own cache (no sharing)

# Option 2: File-based sharing with persistence
export CACHE_AUTO_PERSIST=true
cache-init

# Multiple processes safely share via atomic file operations

# Option 3: Lock before concurrent access
lock_file="/tmp/cache.lock"

cache_get_safe() {
    (
        flock 9
        cache-get "$@"
    ) 9>"$lock_file"
}
```

---

### 7. Error Handling Patterns

```zsh
# Pattern 1: Check return code
if cache-set "key" "value" 300; then
    echo "Cached successfully"
else
    echo "Failed to cache" >&2
fi

# Pattern 2: Handle missing keys
value=$(cache-get "key" 2>/dev/null) || {
    value=$(compute_value)
    cache-set "key" "$value"
}

# Pattern 3: Graceful degradation
if cache-has "$key"; then
    data=$(cache-get "$key")
else
    data=$(fetch_from_source)
    cache-set "$key" "$data" || true  # Ignore cache errors
fi
```

---

### 8. Persistence Best Practices

```zsh
# Enable auto-persistence
export CACHE_AUTO_PERSIST=true

# Initialize at startup
cache-init

# Manual checkpoint before critical operation
cache-cleanup-expired
cache-save

# Backup before version upgrade
cp "$CACHE_PERSIST_FILE" "$CACHE_PERSIST_FILE.backup"

# Restore from backup if needed
cache-clear-all
cache-load "$CACHE_PERSIST_FILE.backup"
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM (400 lines) -->

## Troubleshooting

<!-- CONTEXT_GROUP: troubleshooting -->

### Troubleshooting Quick Index

| Problem | Section | Lines | Complexity |
|---------|---------|-------|------------|
| Cache misses everything | [→ Cache Always Misses](#cache-always-misses) | 2100-2150 | Low |
| Cache not persisting | [→ Cache Not Persisting](#cache-not-persisting) | 2151-2200 | Medium |
| Memory usage too high | [→ High Memory Usage](#high-memory-usage) | 2201-2250 | Medium |
| Cache not clearing | [→ Cache Not Clearing](#cache-not-clearing) | 2251-2300 | Low |
| Performance degradation | [→ Slow Cache Operations](#slow-cache-operations) | 2301-2350 | High |
| Concurrency issues | [→ Concurrent Access Issues](#concurrent-access-issues) | 2351-2400 | High |

---

### Cache Always Misses

**Symptoms:**
```zsh
cache-set "key" "value"
cache-get "key"    # Returns 1 (not found)
cache-has "key"    # Returns 1 (not found)
```

**Root Causes:**

1. **Expired TTL**
   ```zsh
   # TTL too short or TTL=0
   cache-set "key" "value" 0    # Immediate expiry
   ```

   **Solution:**
   ```zsh
   cache-set "key" "value" 300  # Use positive TTL
   ```

2. **Key Mismatch**
   ```zsh
   cache-set "my:key" "value"
   cache-get "mykey"             # Different key!
   ```

   **Solution:**
   ```zsh
   cache-set "my:key" "value"
   cache-get "my:key"            # Match exactly
   ```

3. **Extension Not Loaded**
   ```zsh
   cache-set "key" "value"  # Function not found
   # bash: cache-set: command not found
   ```

   **Solution:**
   ```zsh
   source "$(which _cache)"  # Load extension first
   cache-set "key" "value"
   ```

4. **Variable Interpolation**
   ```zsh
   key="my:key"
   cache-set "$key" "value"  # Sets "my:key"
   cache-get "my:key"        # Try this, not $key

   # OR use the variable
   cache-get "$key"
   ```

**Debug Steps:**
```zsh
# Enable debug output
export CACHE_DEBUG=true

# Try operation
cache-set "test" "value"
cache-get "test"
# Look for [DEBUG] messages
```

---

### Cache Not Persisting

**Symptoms:**
```zsh
cache-set "key" "value"
cache-save
# Restart shell
cache-get "key"  # Returns 1 (not found)
```

**Root Causes:**

1. **Auto-Persist Not Enabled**
   ```zsh
   # CACHE_AUTO_PERSIST defaults to false
   cache-set "key" "value"
   # Not automatically saved!
   ```

   **Solution:**
   ```zsh
   export CACHE_AUTO_PERSIST=true
   cache-init      # This loads persisted cache
   cache-set "key" "value"  # Auto-saved
   ```

2. **Directory Doesn't Exist**
   ```zsh
   # CACHE_STATE_DIR not created
   ls -la "$CACHE_STATE_DIR"
   # ls: cannot access: No such file or directory
   ```

   **Solution:**
   ```zsh
   cache-init  # Creates directories
   cache-save  # Now succeeds
   ```

3. **Permission Denied**
   ```zsh
   # Directory not writable
   ls -la "$(dirname "$CACHE_PERSIST_FILE")"
   # drwxr-xr-x (not writable)
   ```

   **Solution:**
   ```zsh
   chmod u+w "$(dirname "$CACHE_PERSIST_FILE")"
   cache-save
   ```

4. **Not Calling Cache-Load**
   ```zsh
   source "$(which _cache)"
   cache-set "key" "value"
   # But file exists! Just not loaded
   ```

   **Solution:**
   ```zsh
   source "$(which _cache)"
   cache-load  # Explicit load
   # OR
   export CACHE_AUTO_PERSIST=true
   cache-init  # Auto-load
   ```

**Debug Steps:**
```zsh
# Check file exists
ls -la "$CACHE_PERSIST_FILE"

# Check file content
head -1 "$CACHE_PERSIST_FILE"

# Try manual load
cache-load "$CACHE_PERSIST_FILE"

# Check permissions
touch "$CACHE_PERSIST_FILE" 2>&1
```

---

### High Memory Usage

**Symptoms:**
```zsh
# Cache consuming too much memory
cache-stats
# Entries: 10000 / 10000
# Memory estimated at 4-6MB
```

**Solutions:**

1. **Reduce Maximum Size**
   ```zsh
   # Decrease from default 10000
   export CACHE_MAX_SIZE=1000

   # Existing entries are not affected
   # New entries rejected when full
   ```

2. **Reduce TTL**
   ```zsh
   # Shorter TTL = faster expiration = less memory
   export CACHE_DEFAULT_TTL=600  # 10 minutes

   # Expired entries removed on access
   cache-cleanup-expired         # Explicit cleanup
   ```

3. **Regular Cleanup**
   ```zsh
   # Periodic background cleanup
   while true; do
       sleep 300
       cache-cleanup-expired
   done &
   ```

4. **Reduce Entry Size**
   ```zsh
   # Store reference, not full data
   cache-set "user:123" "/path/to/user"  # Small
   # NOT:
   cache-set "user:123" "$large_json"    # Large
   ```

5. **Namespace Cleanup**
   ```zsh
   # Clear old namespaces
   cache-clear-namespace "old"
   cache-clear-namespace "temp"
   cache-cleanup-expired
   ```

**Monitor Memory:**
```zsh
# Current usage estimate
size=$(cache-size)
memory_bytes=$((size * 400))  # ~400 bytes per entry
memory_mb=$((memory_bytes / 1048576))
echo "Cache using ~${memory_mb}MB"

# Alert if high
if [[ $memory_mb -gt 5 ]]; then
    echo "Warning: Cache using ${memory_mb}MB" >&2
    cache-cleanup-expired
fi
```

---

### Cache Not Clearing

**Symptoms:**
```zsh
cache-clear "key"
cache-has "key"  # Still returns 0 (exists!)
```

**Root Causes:**

1. **Wrong Key Name**
   ```zsh
   cache-set "my:key" "value"
   cache-clear "mykey"    # Wrong!
   cache-has "my:key"     # Still exists
   ```

   **Solution:**
   ```zsh
   cache-list | grep "my"  # Find exact key name
   cache-clear "my:key"    # Use exact name
   ```

2. **Checking Wrong Function**
   ```zsh
   cache-clear "key"
   cache-get "key"  # Returns 1, cache-has not tested

   # cache-clear succeeds, but confirmation wrong
   ```

   **Solution:**
   ```zsh
   cache-clear "key"
   cache-has "key"  # Proper check
   ```

3. **Case Sensitivity**
   ```zsh
   cache-set "Key" "value"  # Capital K
   cache-clear "key"        # Lowercase k - no match!
   ```

   **Solution:**
   ```zsh
   cache-clear "Key"  # Match case exactly
   ```

**Debug Steps:**
```zsh
# List all keys
cache-list

# Find specific key
cache-list | grep "pattern"

# View key details
cache-list "*pattern*"

# Clear matching keys
cache-list "key:*" | cut -d: -f1-2 | while read k; do
    cache-clear "$k"
done
```

---

### Slow Cache Operations

**Symptoms:**
```zsh
# cache-cleanup-expired takes too long
time cache-cleanup-expired
# real    0m1.234s (too slow)
```

**Root Causes:**

1. **Too Many Keys**
   ```zsh
   # 100k+ entries forces full scan
   cache-size  # 100000
   cache-cleanup-expired  # O(n) scan = slow
   ```

   **Solution:**
   ```zsh
   # Reduce cache size
   export CACHE_MAX_SIZE=10000

   # Or increase cleanup frequency (smaller expiry windows)
   cache-cleanup-expired &  # Background
   ```

2. **Slow Disk (Persistence)**
   ```zsh
   # Large cache file on slow storage
   time cache-save  # Slow due to disk I/O
   ```

   **Solution:**
   ```zsh
   # Disable auto-persistence
   export CACHE_AUTO_PERSIST=false
   # Save manually during low-activity periods
   ```

3. **Large Values**
   ```zsh
   # Each value is large JSON/XML
   cache-size  # 1000 entries
   # But high memory/slow iteration
   ```

   **Solution:**
   ```zsh
   # Store reference instead of value
   cache-set "data:id" "/path/to/large/file"
   ```

**Optimization Strategies:**
```zsh
# 1. Reduce cleanup frequency
# Only run during maintenance windows

# 2. Increase TTL
# Less cleanup needed
export CACHE_DEFAULT_TTL=3600

# 3. Reduce max size
# Smaller dataset = faster operations
export CACHE_MAX_SIZE=5000

# 4. Disable persistence if not needed
export CACHE_AUTO_PERSIST=false
```

---

### Concurrent Access Issues

**Symptoms:**
```zsh
# Multiple scripts/processes in parallel
# Cache corruption or lost updates
```

**Root Causes:**

Cache is **NOT thread-safe**. Multiple processes can cause:
- Lost updates
- Corrupted cache data
- Inconsistent state

**Solutions:**

1. **Process Isolation (Recommended)**
   ```zsh
   # Each process has own cache
   # No sharing = no conflicts

   # Script 1
   source "$(which _cache)"
   cache-set "key1" "value1"

   # Script 2 (separate shell)
   source "$(which _cache)"
   cache-set "key2" "value2"

   # Caches are independent
   ```

2. **File-Based Sharing with Persistence**
   ```zsh
   # Use file as shared cache backend
   export CACHE_AUTO_PERSIST=true

   # Multiple processes
   cache-init       # Load from file
   cache-set "key" "value"
   # Auto-saved to file
   ```

   **Limitations:**
   - Eventual consistency (not real-time)
   - Last-write-wins for conflicts
   - Slow due to disk I/O

3. **Locking (Complex)**
   ```zsh
   lock_file="/tmp/cache.lock"

   cache_get_locked() {
       local key="$1"
       (
           flock 9 || return 1
           cache-get "$key"
       ) 9>"$lock_file"
   }

   cache_set_locked() {
       local key="$1"
       local value="$2"
       (
           flock 9 || return 1
           cache-set "$key" "$value"
       ) 9>"$lock_file"
   }
   ```

   **Drawbacks:**
   - Reduced performance
   - Deadlock risk
   - Debugging complexity

**Recommendation:**
- Use **Process Isolation** for independent caches
- Use **File-Based Sharing** for lightweight sharing
- Avoid locking unless absolutely necessary

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM (300 lines) -->

## Architecture & Performance

<!-- CONTEXT_GROUP: architecture -->

### Storage Architecture

**Three-Hash-Map Design:**

```zsh
# _CACHE_DATA: key -> value mapping
_CACHE_DATA=(
    "user:123" "Alice"
    "user:456" "Bob"
)

# _CACHE_EXPIRY: key -> expiry_timestamp
_CACHE_EXPIRY=(
    "user:123" 1699210000
    "user:456" 1699213600
)

# _CACHE_HITS: key -> hit_count
_CACHE_HITS=(
    "user:123" 5
    "user:456" 2
)

# _CACHE_MISSES: key -> miss_count
_CACHE_MISSES=(
    "user:123" 1
    "user:456" 3
)
```

**Why Multiple Maps:**
- Separation of concerns (data vs metadata)
- Efficient expiry checking (no value scan needed)
- Per-key statistics without polluting data
- Flexible cleanup (remove independently)

---

### Expiration Model

**Lazy Expiration (On Access):**

```
On cache-get or cache-has:
  1. Check if key exists
  2. Get expiry timestamp
  3. Compare: now >= expiry
  4. If expired: remove from all maps, return not found
  5. If valid: return value, increment hit counter
```

**Advantages:**
- No background cleanup overhead
- Expired entries stay until accessed
- O(1) expiration check

**Disadvantages:**
- Memory overhead (expired entries remain)
- Cleanup only via explicit `cache-cleanup-expired`

---

### Persistence Format

**File Format: Base64-encoded key|value pairs**

```
base64(key1)|base64(value1)|expiry_timestamp1|hits1|misses1
base64(key2)|base64(value2)|expiry_timestamp2|hits2|misses2
...
```

**Why Base64:**
- Handles special characters, newlines, binary
- Preserves value integrity
- Plain text for debugging

**Why Pipe-Delimited:**
- Simple parsing
- Handles values with spaces/special chars
- Recoverable from corruption

**Example:**
```
dXNlcjoxMjM=|QWxpY2U=|1699210000|5|1
dXNlcjo0NTY=|Qm9i|1699213600|2|3
```

Decodes to:
```
user:123|Alice|1699210000|5|1
user:456|Bob|1699213600|2|3
```

---

### Performance Characteristics

**Time Complexity:**

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| cache-set | O(1) | Hash insertion |
| cache-get | O(1) | Hash lookup + expiry check |
| cache-has | O(1) | Hash lookup + expiry check |
| cache-clear | O(1) | Hash removal × 4 maps |
| cache-cleanup-expired | O(n) | Must scan all keys |
| cache-list | O(n) | Scan + pattern match |
| cache-save | O(n) | Write all entries |
| cache-load | O(n) | Read + decode + insert |

**Memory Characteristics:**

```
Per-entry overhead:
  Key:      ~50 bytes (average)
  Value:    ~100-500 bytes (varies)
  Expiry:   8 bytes (timestamp)
  Metadata: ~50 bytes (counters + alignment)
  Total:    ~200-600 bytes per entry

Example: 10,000 entries × 400 bytes = 4MB
```

**Practical Limits:**

| Configuration | Memory | Operations/sec | Notes |
|---|---|---|---|
| Small (1000 entries) | ~400KB | 1M+ | Instant, negligible overhead |
| Medium (10000 entries) | ~4MB | 100k+ | Practical limit for most apps |
| Large (100k entries) | ~40MB | 10k+ | Slow cleanup, high memory |

---

### Optimization Tips

**1. Reduce Cache Size**
```zsh
export CACHE_MAX_SIZE=5000  # Not 10000
# Reduces memory, faster cleanup
```

**2. Use Shorter Keys**
```zsh
cache-set "u:123" "data"    # 6 bytes
# vs
cache-set "user:123:data" "data"  # 16 bytes
# Saves on average 10 bytes per entry
```

**3. Store References**
```zsh
cache-set "file:path" "/path/to/large/data"  # Small
# vs
cache-set "file:path" "$(cat /path/to/large/data)"  # Large
```

**4. Appropriate TTL**
```zsh
# Short TTL = more frequent expiration = less memory
export CACHE_DEFAULT_TTL=600  # 10 minutes
```

**5. Batch Operations**
```zsh
# Instead of individual cache-set calls in loop
# Try to load/save in bulk via persistence
cache-load
# ... operations ...
cache-save
```

---

### Comparison with Alternatives

**vs Disk Cache (files):**
- Faster (memory vs disk I/O)
- Less persistent (lost on reboot)
- Simpler API

**vs Redis/Memcached:**
- Simpler (no external service)
- Same-process only (no sharing)
- No advanced features (no atomic operations, pub/sub)

**vs Variables:**
- Automatic expiration (variables don't expire)
- Statistics (hit rate tracking)
- Namespace organization
- Disk persistence

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL (100 lines) -->

## Security Considerations

<!-- CONTEXT_GROUP: security -->

### Data Sensitivity

**DON'T Cache:**
```zsh
# Passwords/tokens in plaintext
cache-set "auth:password" "$password"  # WRONG

# Private keys
cache-set "ssh:key" "$(cat ~/.ssh/id_rsa)"  # WRONG

# API secrets
cache-set "api:secret" "$API_KEY"  # WRONG
```

**DO Cache:**
```zsh
# Hashed/sanitized data
cache-set "auth:hash" "$(hash_password "$password")" 300

# Public data
cache-set "user:123:name" "Alice"

# Derived data
cache-set "api:token:valid" "true" 3600
```

---

### Cache Poisoning

**Validate Before Caching:**
```zsh
# WRONG: Trust user input
cache-set "user:input" "$user_input"

# RIGHT: Validate first
if [[ "$user_input" =~ ^[a-zA-Z0-9]+$ ]]; then
    cache-set "user:input" "$user_input"
fi
```

---

### Key Injection

**Sanitize Namespace Keys:**
```zsh
# WRONG: User-controlled namespace
cache-set "user:$username" "data"  # username could be "admin:secret"

# RIGHT: Sanitize
safe_username="${username//[^a-zA-Z0-9]/}"
cache-set "user:$safe_username" "data"
```

---

### File Permissions

**Set Persistence File Permissions:**
```zsh
cache-init
chmod 600 "$CACHE_PERSIST_FILE"  # Only user can read

# Verify
ls -la "$CACHE_PERSIST_FILE"
# -rw------- (600)
```

---

### Memory Exposure

**Clear on Exit:**
```zsh
cleanup() {
    cache-clear-all  # Wipe memory
    # Optional: overwrite with garbage
    # (shell doesn't guarantee memory wipe)
}

trap cleanup EXIT
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL (40 lines) -->

## External References

**Related Extensions:**
- `_common` v2.0 - Core utilities, validation, XDG paths
- `_events` v2.0 - Event system for cache events
- `_config` v2.0 - Configuration management
- `_lifecycle` v3.1 - Resource cleanup integration

**Documentation:**
- Source: `~/.local/bin/lib/_cache`
- Tests: `_cache self-test`
- Help: `_cache help` or `cache-help`

**Standards Compliance:**
- Enhanced Documentation Requirements v1.1
- XDG Base Directory Specification
- ZSH Parameter Expansion (${var})
- POSIX Shell Conventions

**External Resources:**
- ZSH Associative Arrays: https://zsh.sourceforge.io/Doc/Release/Expansion.html
- XDG Base Directory: https://specifications.freedesktop.org/basedir-spec/
- Cache Design Patterns: https://en.wikipedia.org/wiki/Cache_(computing)

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-07
**Format:** Enhanced Documentation Requirements v1.1
**For Support:** See troubleshooting section or run `_cache self-test`
