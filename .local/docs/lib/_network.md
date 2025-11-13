# _network - Network Utilities and Connectivity Checking

**Lines:** 2,743 | **Functions:** 19 | **Examples:** 62 | **Source Lines:** 406
**Version:** 1.0.0 | **Layer:** Integration (Layer 3) | **Source:** `~/.local/bin/lib/_network`

---

## Quick Access Index

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Compact References (Lines 10-300)
- [Function Reference](#function-quick-reference) - 19 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 7 variables
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 300-400, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 400-500, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 500-750, ~250 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 750-850, ~100 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 850-2200, ~1350 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2200-2450, ~250 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2450-2650, ~200 lines) 🔧 REFERENCE
- [Performance](#performance) (Lines 2650-2700, ~50 lines) 💡 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: network-core -->

**Dependency & Availability Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-check-dependencies` | Verify required network tools available | 45-56 | O(1) | [→](#network-check-dependencies) |

**Connectivity Testing Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-is-online` | Check if internet is accessible | 58-71 | O(n) hosts | [→](#network-is-online) |
| `network-wait-online` | Wait for internet connectivity with timeout | 73-92 | O(t) time | [→](#network-wait-online) |
| `network-is-reachable` | Check if specific host is reachable | 94-98 | O(1) | [→](#network-is-reachable) |
| `network-ping-host` | Ping a host with configurable count/timeout | 100-118 | O(1) | [→](#network-ping-host) |
| `network-check-gateway` | Verify default gateway is reachable | 215-226 | O(1) | [→](#network-check-gateway) |

**DNS & Resolution Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-resolve-host` | Resolve hostname to IP address | 120-136 | O(1) | [→](#network-resolve-host) |
| `network-resolve-ip` | Reverse DNS lookup (IP to hostname) | 138-150 | O(1) | [→](#network-resolve-ip) |

**Network Information Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-get-local-ip` | Get local IP address (default interface) | 152-175 | O(1) | [→](#network-get-local-ip) |
| `network-get-public-ip` | Get public/external IP address | 177-199 | O(1) | [→](#network-get-public-ip) |
| `network-get-gateway` | Get default gateway IP address | 201-213 | O(1) | [→](#network-get-gateway) |
| `network-list-interfaces` | List all network interfaces | 228-238 | O(n) | [→](#network-list-interfaces) |
| `network-get-interface-status` | Get interface status (UP/DOWN) | 240-256 | O(1) | [→](#network-get-interface-status) |
| `network-get-interface-mac` | Get MAC address for interface | 258-270 | O(1) | [→](#network-get-interface-mac) |

**Port & Service Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-is-port-open` | Check if TCP port is open | 272-285 | O(1) | [→](#network-is-port-open) |
| `network-wait-port` | Wait for port to become available | 287-308 | O(t) time | [→](#network-wait-port) |

**Utility Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `network-download` | Download file via HTTP/HTTPS | 310-331 | O(s) size | [→](#network-download) |
| `network-info` | Display comprehensive network information | 333-373 | O(n) | [→](#network-info) |
| `network-self-test` | Run comprehensive self-tests | 375-407 | O(n) | [→](#network-self-test) |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Default | Type | Description | Source |
|----------|---------|------|-------------|--------|
| **NETWORK_PING_TIMEOUT** | `5` | Integer | Ping timeout in seconds | L36 |
| **NETWORK_PING_COUNT** | `3` | Integer | Number of ping packets to send | L37 |
| **NETWORK_DNS_SERVERS** | `8.8.8.8 1.1.1.1` | String | Space-separated DNS servers for testing | L38 |
| **NETWORK_CHECK_HOSTS** | `google.com cloudflare.com` | String | Hosts to check for connectivity | L39 |
| **NETWORK_RETRY_MAX** | `3` | Integer | Maximum retry attempts for operations | L40 |
| **NETWORK_RETRY_DELAY** | `2` | Integer | Delay between retries (seconds) | L41 |
| **NETWORK_HTTP_TIMEOUT** | `10` | Integer | HTTP request timeout (seconds) | L42 |

**Configuration Tips:**
- Set `NETWORK_PING_TIMEOUT=2` for faster checks (less reliable)
- Set `NETWORK_CHECK_HOSTS="company.com"` for internal network checks
- Set `NETWORK_RETRY_MAX=10` for flaky network conditions
- All timeouts are in seconds unless specified otherwise

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Constant | Description | Used By |
|------|----------|-------------|---------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | Error | General error (tool missing, host unreachable, etc.) | All functions |

**Note:** The _network extension uses standard shell return codes. Success = 0, any failure = 1. Check function output and logs for specific error details.

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

The `_network` extension provides comprehensive network utilities for ZSH scripts, including connectivity testing, DNS resolution, interface management, port checking, and more. It wraps common network tools (`ping`, `ip`, `ifconfig`, `curl`, etc.) with a consistent, easy-to-use API.

### Key Features

**Connectivity Management:**
- Internet connectivity detection (→ L58)
- Wait for connectivity with timeout (→ L73)
- Host reachability testing (→ L94)
- Gateway connectivity checking (→ L215)
- Configurable retry logic and timeouts

**DNS Operations:**
- Forward DNS resolution (hostname → IP) (→ L120)
- Reverse DNS resolution (IP → hostname) (→ L138)
- Multiple tool fallbacks (getent, host, dig, nslookup)
- Robust error handling

**Network Information:**
- Local IP address detection (→ L152)
- Public IP address discovery (→ L177)
- Default gateway detection (→ L201)
- Interface listing and status (→ L228, L240)
- MAC address retrieval (→ L258)

**Port & Service Checking:**
- TCP port availability testing (→ L272)
- Wait for service startup (→ L287)
- Multiple backend support (nc, telnet)

**Utilities:**
- HTTP/HTTPS file download (→ L310)
- Comprehensive network info display (→ L333)
- Self-test suite (→ L375)

### Architecture Principles

1. **Multi-Backend Support:** Falls back gracefully across tool variations (ip vs ifconfig, curl vs wget)
2. **Configurable Timeouts:** All network operations respect configurable timeout settings
3. **Retry Logic:** Supports automatic retry for transient network issues
4. **Logging Integration:** Uses _log if available, falls back to echo
5. **Zero Required Dependencies:** Gracefully degrades based on available tools
6. **Cross-Platform:** Works with different Linux distributions and tool versions

### Dependencies

**Required (Layer 1):**
- `_common` v2.0 - Core utilities (→ Source L13-22)

**Optional (Layer 2):**
- `_log` v2.0 - Enhanced logging (graceful degradation → Source L25-33)

**External Tools (at least one from each category):**
- **Ping:** `ping` (iputils or busybox)
- **Network Config:** `ip` (iproute2) OR `ifconfig` (net-tools)
- **DNS:** `getent` OR `host` OR `dig` OR `nslookup`
- **HTTP:** `curl` OR `wget` (for downloads and public IP)
- **Port Check:** `nc` (netcat) OR `telnet` (for port testing)

### Performance Characteristics

**Function Performance:**
- `network-is-online`: O(n) where n = number of check hosts (typically 2-5s)
- `network-wait-online`: O(t) where t = timeout duration (blocking)
- `network-ping-host`: O(1) single host check (~1-5s depending on timeout)
- `network-resolve-host`: O(1) DNS query (~100ms-2s)
- `network-get-local-ip`: O(1) fast (~10-50ms)
- `network-get-public-ip`: O(1) HTTP request (~500ms-5s depending on connection)
- `network-wait-port`: O(t) blocking until port available or timeout

**Optimization Tips:**
- Reduce `NETWORK_PING_TIMEOUT` for faster connectivity checks
- Reduce `NETWORK_PING_COUNT` to 1 for quick tests
- Cache results of `network-get-public-ip` if called frequently
- Use `network-is-reachable` for single-host checks instead of `network-is-online`

---

## Installation

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

### Basic Installation

Load the extension in your script:

```zsh
# Method 1: Using which (recommended)
source "$(which _network)" || {
    echo "[ERROR] _network extension not found" >&2
    exit 1
}

# Method 2: Direct path
source ~/.local/bin/lib/_network

# Method 3: With error handling
if ! source "$(which _network)" 2>/dev/null; then
    echo "[ERROR] _network extension not available" >&2
    echo "Install: cd ~/.pkgs && stow lib" >&2
    exit 1
fi
```

### Verify Installation

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

# Check version
echo "Network extension version: $NETWORK_VERSION"

# Check dependencies
if network-check-dependencies; then
    echo "All network tools available"
else
    echo "Some network tools missing (will use fallbacks)"
fi

# Quick connectivity test
if network-is-online; then
    echo "Internet: ONLINE"
    echo "Local IP: $(network-get-local-ip)"
    echo "Gateway: $(network-get-gateway)"
else
    echo "Internet: OFFLINE"
fi
```

### System Requirements

**Minimum Requirements:**
- ZSH 5.0+
- At least one of: `ip` or `ifconfig`
- `ping` command (any version)

**Recommended Tools:**
- `ip` (iproute2) - Modern network configuration
- `curl` - HTTP downloads and public IP detection
- `nc` (netcat) - Port checking
- `host` or `dig` - DNS resolution

**Install Missing Tools:**

```bash
# Arch Linux
sudo pacman -S iproute2 iputils curl bind-tools gnu-netcat

# Debian/Ubuntu
sudo apt install iproute2 iputils-ping curl dnsutils netcat-openbsd

# Fedora/RHEL
sudo dnf install iproute iputils curl bind-utils nmap-ncat

# Alpine Linux
apk add iproute2 iputils curl bind-tools netcat-openbsd
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

### Example 1: Basic Connectivity Check

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

if network-is-online; then
    echo "✓ Internet connection available"
    exit 0
else
    echo "✗ No internet connection"
    exit 1
fi
```

**Performance:** ~2-5 seconds (tests multiple hosts)

---

### Example 2: Wait for Network

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

echo "Waiting for network connectivity..."

if network-wait-online 30; then
    echo "✓ Network available"

    # Get network info
    local_ip=$(network-get-local-ip)
    gateway=$(network-get-gateway)

    echo "  Local IP: $local_ip"
    echo "  Gateway: $gateway"
else
    echo "✗ Network timeout after 30 seconds"
    exit 1
fi
```

**Use Case:** System startup scripts, network-dependent services

---

### Example 3: Host Reachability

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

hosts=(
    "google.com"
    "github.com"
    "192.168.1.1"
)

for host in "${hosts[@]}"; do
    if network-is-reachable "$host"; then
        echo "✓ $host is reachable"
    else
        echo "✗ $host is unreachable"
    fi
done
```

---

### Example 4: DNS Resolution

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

# Forward DNS (hostname → IP)
ip=$(network-resolve-host "google.com")
echo "google.com resolves to: $ip"

# Reverse DNS (IP → hostname)
hostname=$(network-resolve-ip "8.8.8.8")
echo "8.8.8.8 resolves to: $hostname"
```

---

### Example 5: Network Interface Information

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

echo "Network Interfaces:"
network-list-interfaces | while read -r iface; do
    status=$(network-get-interface-status "$iface")
    ip=$(network-get-local-ip "$iface" 2>/dev/null)
    mac=$(network-get-interface-mac "$iface" 2>/dev/null)

    echo ""
    echo "Interface: $iface"
    echo "  Status: $status"
    [[ -n "$ip" ]] && echo "  IP: $ip"
    [[ -n "$mac" ]] && echo "  MAC: $mac"
done
```

---

### Example 6: Port Availability Check

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

host="localhost"
port="3306"

if network-is-port-open "$host" "$port"; then
    echo "✓ MySQL is listening on $host:$port"
else
    echo "✗ MySQL is not available on $host:$port"
fi
```

---

### Example 7: Wait for Service Startup

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

# Start service
echo "Starting database..."
systemctl start mysql

# Wait for port to be available
if network-wait-port "localhost" 3306 30; then
    echo "✓ Database is ready"
else
    echo "✗ Database failed to start within 30 seconds"
    exit 1
fi
```

---

### Example 8: Download File

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

url="https://example.com/file.tar.gz"
output="/tmp/file.tar.gz"

echo "Downloading $url..."
if network-download "$url" "$output"; then
    echo "✓ Download complete: $output"
else
    echo "✗ Download failed"
    exit 1
fi
```

---

### Example 9: Network Status Report

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

# Display comprehensive network information
network-info

# Output example:
# === Network Information ===
#
# Connectivity:
#   Status: ONLINE
#   Local IP: 192.168.1.100
#   Public IP: 203.0.113.45
#   Gateway: 192.168.1.1
#   Gateway Status: REACHABLE
#
# Interfaces:
#   eth0:
#     Status: UP
#     IP: 192.168.1.100
#     MAC: 00:11:22:33:44:55
#   lo:
#     Status: UNKNOWN
#     IP: 127.0.0.1
#     MAC: 00:00:00:00:00:00
```

---

### Example 10: Public IP Detection

```zsh
#!/usr/bin/env zsh
source "$(which _network)"

if network-is-online; then
    public_ip=$(network-get-public-ip)

    if [[ -n "$public_ip" ]]; then
        echo "Your public IP: $public_ip"
    else
        echo "Failed to detect public IP"
    fi
else
    echo "No internet connection"
fi
```

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Environment Variables

All configuration is done via environment variables before sourcing the extension:

```zsh
# Ping configuration
export NETWORK_PING_TIMEOUT=5        # Ping timeout (seconds)
export NETWORK_PING_COUNT=3          # Number of ping packets

# Connectivity testing
export NETWORK_CHECK_HOSTS="google.com cloudflare.com"

# DNS servers for testing (space-separated)
export NETWORK_DNS_SERVERS="8.8.8.8 1.1.1.1"

# Retry behavior
export NETWORK_RETRY_MAX=3           # Maximum retry attempts
export NETWORK_RETRY_DELAY=2         # Delay between retries (seconds)

# HTTP timeout
export NETWORK_HTTP_TIMEOUT=10       # HTTP request timeout (seconds)

# Load extension
source "$(which _network)"
```

### Configuration Profiles

**Profile 1: Fast Checks (Less Reliable)**

```zsh
export NETWORK_PING_TIMEOUT=2
export NETWORK_PING_COUNT=1
export NETWORK_HTTP_TIMEOUT=5
export NETWORK_RETRY_MAX=1
```

**Profile 2: Reliable Checks (Slower)**

```zsh
export NETWORK_PING_TIMEOUT=10
export NETWORK_PING_COUNT=5
export NETWORK_HTTP_TIMEOUT=30
export NETWORK_RETRY_MAX=5
export NETWORK_RETRY_DELAY=5
```

**Profile 3: Internal Network Only**

```zsh
export NETWORK_CHECK_HOSTS="internal.company.com 192.168.1.1"
export NETWORK_PING_TIMEOUT=2
export NETWORK_PING_COUNT=1
```

### Runtime Configuration

Variables can be changed at runtime (affects subsequent calls):

```zsh
source "$(which _network)"

# Quick check
NETWORK_PING_TIMEOUT=1 network-is-online

# More thorough check
NETWORK_PING_TIMEOUT=10 NETWORK_PING_COUNT=5 network-is-online
```

---

## API Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: network-api -->

### Dependency Check

#### network-check-dependencies

Check if required network tools are available.

**Source:** Lines 45-56
**Complexity:** O(1)
**Performance:** <10ms

**Syntax:**
```zsh
network-check-dependencies
```

**Returns:**
- `0` - All required dependencies available
- `1` - Missing critical dependencies (ping, ip/ifconfig)

**Dependencies:**
- Requires: `ping` command
- Requires: At least one of `ip` or `ifconfig`

**Example 1: Basic Check**
```zsh
if network-check-dependencies; then
    echo "Network tools available"
else
    echo "Missing required network tools"
    exit 1
fi
```

**Example 2: Startup Validation**
```zsh
#!/usr/bin/env zsh
source "$(which _network)"

# Validate dependencies before proceeding
network-check-dependencies || {
    echo "[ERROR] Required network tools not found" >&2
    echo "Install: sudo apt install iproute2 iputils-ping" >&2
    exit 1
}

# Proceed with network operations...
```

**Example 3: Conditional Features**
```zsh
# Enable advanced features only if tools available
if network-check-dependencies; then
    USE_ADVANCED_NETWORK=true
else
    USE_ADVANCED_NETWORK=false
    echo "[WARN] Limited network functionality (missing tools)"
fi
```

**Notes:**
- Called automatically by most network functions
- Checks for `ping` command
- Checks for at least one of: `ip` or `ifconfig`
- Does not check optional tools (curl, dig, etc.)
- Logs errors to stderr via _log if available

---

### Connectivity Testing

<!-- CONTEXT_GROUP: network-connectivity -->

#### network-is-online

Check if internet connectivity is available.

**Source:** Lines 58-71
**Complexity:** O(n) where n = number of check hosts
**Performance:** ~2-5 seconds (depends on NETWORK_CHECK_HOSTS)

**Syntax:**
```zsh
network-is-online
```

**Returns:**
- `0` - Internet is accessible (at least one check host reachable)
- `1` - No internet connectivity (all check hosts unreachable)

**Configuration:**
- `NETWORK_CHECK_HOSTS` - Hosts to test (default: "google.com cloudflare.com")
- `NETWORK_PING_COUNT` - Packets to send (default: 3)
- `NETWORK_PING_TIMEOUT` - Timeout per ping (default: 5s)

**Algorithm:**
1. Iterate through hosts in `NETWORK_CHECK_HOSTS`
2. Ping each host with configured count/timeout
3. Return success on first reachable host
4. Return failure if all hosts unreachable

**Example 1: Simple Check**
```zsh
if network-is-online; then
    echo "Internet: ONLINE"
else
    echo "Internet: OFFLINE"
fi
```

**Example 2: Conditional Execution**
```zsh
# Only sync if online
if network-is-online; then
    git pull origin main
    pacman -Syu
else
    echo "Skipping sync (offline)"
fi
```

**Example 3: Custom Check Hosts**
```zsh
# Check internal network only
NETWORK_CHECK_HOSTS="intranet.company.com" network-is-online && {
    echo "Internal network available"
}
```

**Example 4: Fast Check**
```zsh
# Quick check (1 ping, 2 second timeout)
NETWORK_PING_COUNT=1 NETWORK_PING_TIMEOUT=2 network-is-online
```

**Example 5: Retry Logic**
```zsh
# Retry connectivity check 3 times
attempt=1
max_attempts=3

while [[ $attempt -le $max_attempts ]]; do
    if network-is-online; then
        echo "Online on attempt $attempt"
        break
    fi

    echo "Attempt $attempt failed, retrying..."
    ((attempt++))
    sleep 2
done
```

**Notes:**
- Tests multiple hosts for reliability
- First successful ping returns immediately (fast path)
- Respects `NETWORK_CHECK_HOSTS` configuration
- Silent operation (use DEBUG=1 for verbose output)
- Does not test actual HTTP connectivity (use network-download for that)

---

#### network-wait-online

Wait for internet connectivity with timeout.

**Source:** Lines 73-92
**Complexity:** O(t) where t = timeout duration
**Performance:** Blocking, up to timeout seconds

**Syntax:**
```zsh
network-wait-online [timeout]
```

**Parameters:**
- `timeout` - Maximum wait time in seconds (default: NETWORK_RETRY_MAX × NETWORK_RETRY_DELAY)

**Returns:**
- `0` - Internet connectivity established within timeout
- `1` - Timeout reached without connectivity

**Configuration:**
- `NETWORK_RETRY_MAX` - Default max retries (default: 3)
- `NETWORK_RETRY_DELAY` - Delay between checks (default: 2s)

**Algorithm:**
1. Check connectivity via `network-is-online`
2. If online, return success immediately
3. If offline, sleep NETWORK_RETRY_DELAY seconds
4. Repeat until timeout reached

**Example 1: System Startup**
```zsh
#!/usr/bin/env zsh
# Wait for network before starting services

source "$(which _network)"

echo "Waiting for network..."
if network-wait-online 60; then
    echo "Network ready, starting services"
    systemctl start myservice
else
    echo "Network timeout, starting in offline mode"
fi
```

**Example 2: Deployment Script**
```zsh
# Wait for network before deploying
network-wait-online 30 || {
    echo "[ERROR] Network required for deployment" >&2
    exit 1
}

# Network available, proceed with deployment
git pull origin main
docker-compose up -d
```

**Example 3: Network Recovery**
```zsh
# Monitor network and wait for recovery
while true; do
    if ! network-is-online; then
        echo "Network lost, waiting for recovery..."
        network-wait-online 300 || {
            echo "Network down for 5 minutes, alerting admin"
            send_alert "Network outage detected"
        }
    fi
    sleep 60
done
```

**Example 4: Short Timeout**
```zsh
# Quick network check with 10s timeout
if network-wait-online 10; then
    echo "Network available"
else
    echo "Network unavailable (timed out after 10s)"
fi
```

**Example 5: Progress Indication**
```zsh
# Wait with progress indicator
echo -n "Waiting for network"
(
    network-wait-online 60 &
    wait_pid=$!

    while kill -0 $wait_pid 2>/dev/null; do
        echo -n "."
        sleep 1
    done
) && echo " ✓" || echo " ✗"
```

**Notes:**
- Blocking operation (script pauses until online or timeout)
- Uses `network-is-online` for actual connectivity checks
- Default timeout: NETWORK_RETRY_MAX × NETWORK_RETRY_DELAY (typically 6s)
- Logs progress to stderr via _log
- Suitable for systemd service dependencies

---

#### network-is-reachable

Check if a specific host is reachable.

**Source:** Lines 94-98
**Complexity:** O(1)
**Performance:** ~1-5 seconds (depends on ping timeout)

**Syntax:**
```zsh
network-is-reachable <host>
```

**Parameters:**
- `host` - Hostname or IP address (required)

**Returns:**
- `0` - Host is reachable
- `1` - Host is unreachable or invalid

**Example 1: Single Host Check**
```zsh
if network-is-reachable "google.com"; then
    echo "Google is reachable"
else
    echo "Google is unreachable"
fi
```

**Example 2: Gateway Check**
```zsh
gateway=$(network-get-gateway)
if network-is-reachable "$gateway"; then
    echo "Gateway $gateway is reachable"
else
    echo "Gateway $gateway is unreachable - check network cable"
fi
```

**Example 3: Server Monitoring**
```zsh
servers=(
    "web1.example.com"
    "web2.example.com"
    "db.example.com"
)

for server in "${servers[@]}"; do
    if ! network-is-reachable "$server"; then
        echo "[ALERT] Server down: $server"
    fi
done
```

**Example 4: Fast Host Check**
```zsh
# Quick check with 1 ping, 2 second timeout
NETWORK_PING_COUNT=1 NETWORK_PING_TIMEOUT=2 \
    network-is-reachable "192.168.1.1"
```

**Notes:**
- Wrapper around `network-ping-host` with defaults
- Sends silent output (redirect errors if needed)
- Faster than `network-is-online` for single host checks

---

#### network-ping-host

Ping a host with configurable count and timeout.

**Source:** Lines 100-118
**Complexity:** O(1)
**Performance:** count × timeout (typically 3-15 seconds)

**Syntax:**
```zsh
network-ping-host <host> [count] [timeout]
```

**Parameters:**
- `host` - Hostname or IP address (required)
- `count` - Number of ping packets (default: NETWORK_PING_COUNT=3)
- `timeout` - Timeout per packet in seconds (default: NETWORK_PING_TIMEOUT=5)

**Returns:**
- `0` - Host responded to ping
- `1` - Host did not respond or ping failed

**Compatibility:**
- Auto-detects ping variant (iputils vs BSD)
- Uses `-W` flag for iputils ping (Linux)
- Uses `-t` flag for BSD ping (macOS)

**Example 1: Basic Ping**
```zsh
if network-ping-host "8.8.8.8"; then
    echo "Google DNS is responding"
fi
```

**Example 2: Custom Count and Timeout**
```zsh
# Send 5 pings with 2 second timeout each
if network-ping-host "example.com" 5 2; then
    echo "example.com is responsive"
fi
```

**Example 3: Quick Single Ping**
```zsh
# Fast connectivity check (1 ping, 1 second timeout)
network-ping-host "192.168.1.1" 1 1 >/dev/null 2>&1
```

**Example 4: Latency Monitoring**
```zsh
# Monitor latency to host
while true; do
    if network-ping-host "api.example.com" 1 5; then
        echo "$(date): API reachable"
    else
        echo "$(date): API unreachable"
    fi
    sleep 30
done
```

**Example 5: Network Quality Test**
```zsh
# Send 100 pings to measure packet loss
total=100
success=0

for i in {1..$total}; do
    network-ping-host "8.8.8.8" 1 1 >/dev/null 2>&1 && ((success++))
done

loss=$(( (total - success) * 100 / total ))
echo "Packet loss: ${loss}%"
```

**Notes:**
- Low-level function used by other connectivity checks
- Silent operation (all output redirected to /dev/null)
- Auto-detects ping command variant
- Respects NETWORK_PING_COUNT and NETWORK_PING_TIMEOUT if parameters omitted

---

#### network-check-gateway

Check if default gateway is reachable.

**Source:** Lines 215-226
**Complexity:** O(1)
**Performance:** ~1-5 seconds

**Syntax:**
```zsh
network-check-gateway
```

**Returns:**
- `0` - Gateway is reachable
- `1` - Gateway is unreachable or not found

**Example 1: Gateway Connectivity**
```zsh
if network-check-gateway; then
    echo "Router is reachable"
else
    echo "Router is unreachable - check connection"
fi
```

**Example 2: Network Troubleshooting**
```zsh
echo "Network Diagnostics:"

# Test local gateway
if network-check-gateway; then
    echo "✓ Router connectivity: OK"
else
    echo "✗ Router connectivity: FAILED"
    echo "  Check: Network cable, WiFi connection"
fi

# Test internet
if network-is-online; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
    echo "  Check: Router internet connection, ISP status"
fi
```

**Example 3: Startup Validation**
```zsh
# Ensure gateway is reachable before starting services
network-check-gateway || {
    echo "[ERROR] Gateway unreachable - network not ready" >&2
    exit 1
}
```

**Notes:**
- Combines `network-get-gateway` and `network-ping-host`
- Useful for distinguishing local network vs internet issues
- Gateway must be detected first (returns 1 if no gateway found)

---

### DNS & Resolution

<!-- CONTEXT_GROUP: network-dns -->

#### network-resolve-host

Resolve hostname to IP address (forward DNS lookup).

**Source:** Lines 120-136
**Complexity:** O(1)
**Performance:** ~100ms-2s (depends on DNS server)

**Syntax:**
```zsh
network-resolve-host <hostname>
```

**Parameters:**
- `hostname` - Hostname to resolve (required)

**Returns:**
- `0` - Resolution successful (IP printed to stdout)
- `1` - Resolution failed or no DNS tools available

**Tool Priority:**
1. `getent hosts` (preferred - uses system resolver)
2. `host` (bind-tools)
3. `nslookup` (legacy)
4. `dig` (bind-tools)

**Example 1: Simple Resolution**
```zsh
ip=$(network-resolve-host "google.com")
echo "google.com = $ip"
# Output: google.com = 142.250.185.46
```

**Example 2: Validate Host Before Connecting**
```zsh
host="api.example.com"

ip=$(network-resolve-host "$host")
if [[ -n "$ip" ]]; then
    echo "Connecting to $host ($ip)..."
    curl "http://$ip/api"
else
    echo "Failed to resolve $host"
    exit 1
fi
```

**Example 3: DNS Cache Testing**
```zsh
# Resolve multiple times to test DNS caching
for i in {1..5}; do
    time network-resolve-host "google.com" >/dev/null
done
```

**Example 4: Multiple Host Resolution**
```zsh
hosts=(
    "google.com"
    "github.com"
    "cloudflare.com"
)

for host in "${hosts[@]}"; do
    ip=$(network-resolve-host "$host")
    printf "%-20s = %s\n" "$host" "$ip"
done

# Output:
# google.com           = 142.250.185.46
# github.com           = 140.82.121.3
# cloudflare.com       = 104.16.132.229
```

**Example 5: DNS Troubleshooting**
```zsh
host="example.com"

if ! ip=$(network-resolve-host "$host" 2>&1); then
    echo "DNS resolution failed for $host"
    echo "Error: $ip"

    # Try alternate DNS
    echo "Trying Google DNS (8.8.8.8)..."
    dig "@8.8.8.8" "$host" +short
fi
```

**Notes:**
- Returns first IP address only (for multiple A records)
- IPv4 addresses only (no IPv6 AAAA records)
- Uses system resolver (respects /etc/hosts and /etc/resolv.conf)
- Silent on errors (redirect stderr if needed)

---

#### network-resolve-ip

Reverse DNS lookup (IP address to hostname).

**Source:** Lines 138-150
**Complexity:** O(1)
**Performance:** ~100ms-2s (depends on DNS server)

**Syntax:**
```zsh
network-resolve-ip <ip_address>
```

**Parameters:**
- `ip_address` - IP address to resolve (required)

**Returns:**
- `0` - Resolution successful (hostname printed to stdout)
- `1` - Resolution failed or no DNS tools available

**Tool Priority:**
1. `host` (bind-tools - preferred for reverse DNS)
2. `dig -x` (bind-tools)

**Example 1: Simple Reverse Lookup**
```zsh
hostname=$(network-resolve-ip "8.8.8.8")
echo "8.8.8.8 = $hostname"
# Output: 8.8.8.8 = dns.google
```

**Example 2: Identify Connection Source**
```zsh
# Get IP from connection log
ip="203.0.113.45"

hostname=$(network-resolve-ip "$ip")
if [[ -n "$hostname" ]]; then
    echo "Connection from: $hostname ($ip)"
else
    echo "Connection from: $ip (no reverse DNS)"
fi
```

**Example 3: Network Scanner**
```zsh
# Scan local network and resolve hostnames
for i in {1..254}; do
    ip="192.168.1.$i"

    if network-is-reachable "$ip" 2>/dev/null; then
        hostname=$(network-resolve-ip "$ip" 2>/dev/null)
        echo "$ip - ${hostname:-<no reverse DNS>}"
    fi
done
```

**Example 4: Log Analysis**
```zsh
# Parse nginx log and resolve IPs
awk '{print $1}' /var/log/nginx/access.log | sort -u | while read ip; do
    hostname=$(network-resolve-ip "$ip" 2>/dev/null)
    printf "%-15s = %s\n" "$ip" "${hostname:-unknown}"
done
```

**Notes:**
- Requires PTR record in DNS (not all IPs have reverse DNS)
- Strips trailing dot from FQDN
- Returns empty string if no reverse DNS exists
- Slower than forward DNS in some cases

---

### Network Information

<!-- CONTEXT_GROUP: network-info -->

#### network-get-local-ip

Get local IP address (default or specified interface).

**Source:** Lines 152-175
**Complexity:** O(1)
**Performance:** ~10-50ms

**Syntax:**
```zsh
network-get-local-ip [interface]
```

**Parameters:**
- `interface` - Network interface name (optional, default: auto-detect primary)

**Returns:**
- `0` - Success (IP printed to stdout)
- `1` - Failed to get IP or interface not found

**Auto-Detection:**
- If no interface specified, uses default route interface
- Skips loopback (127.0.0.1) when auto-detecting

**Tool Support:**
- `ip addr` (preferred - iproute2)
- `ifconfig` (fallback - net-tools)

**Example 1: Get Primary IP**
```zsh
ip=$(network-get-local-ip)
echo "Local IP: $ip"
# Output: Local IP: 192.168.1.100
```

**Example 2: Specific Interface**
```zsh
eth0_ip=$(network-get-local-ip "eth0")
wlan0_ip=$(network-get-local-ip "wlan0")

echo "Ethernet: $eth0_ip"
echo "WiFi: $wlan0_ip"
```

**Example 3: Configuration Script**
```zsh
# Update application config with local IP
local_ip=$(network-get-local-ip)

cat > app.conf <<EOF
server {
    listen $local_ip:8080;
    server_name localhost;
}
EOF
```

**Example 4: Multi-NIC System**
```zsh
echo "Network Configuration:"
network-list-interfaces | while read iface; do
    ip=$(network-get-local-ip "$iface" 2>/dev/null)
    [[ -n "$ip" ]] && echo "  $iface: $ip"
done
```

**Example 5: IP Change Detection**
```zsh
# Monitor for IP changes
previous_ip=$(network-get-local-ip)

while true; do
    current_ip=$(network-get-local-ip)

    if [[ "$current_ip" != "$previous_ip" ]]; then
        echo "IP changed: $previous_ip → $current_ip"
        previous_ip="$current_ip"
    fi

    sleep 30
done
```

**Notes:**
- Returns IPv4 address only (no IPv6)
- Returns first IP if interface has multiple addresses
- Excludes loopback when auto-detecting
- Returns empty string if interface has no IP

---

#### network-get-public-ip

Get public/external IP address.

**Source:** Lines 177-199
**Complexity:** O(1)
**Performance:** ~500ms-5s (HTTP request)

**Syntax:**
```zsh
network-get-public-ip
```

**Returns:**
- `0` - Success (public IP printed to stdout)
- `1` - Failed (no internet or HTTP tools unavailable)

**Services Used (in order):**
1. `https://api.ipify.org` (primary)
2. `https://ifconfig.me` (fallback)

**Tool Support:**
- `curl` (preferred)
- `wget` (fallback)

**Example 1: Simple Public IP**
```zsh
public_ip=$(network-get-public-ip)
echo "Your public IP: $public_ip"
# Output: Your public IP: 203.0.113.45
```

**Example 2: Firewall Configuration**
```zsh
# Add current public IP to whitelist
public_ip=$(network-get-public-ip) || {
    echo "Failed to get public IP" >&2
    exit 1
}

echo "Adding $public_ip to firewall whitelist..."
sudo ufw allow from "$public_ip"
```

**Example 3: Dynamic DNS Update**
```zsh
# Update DNS record with current public IP
domain="home.example.com"
public_ip=$(network-get-public-ip)

if [[ -n "$public_ip" ]]; then
    echo "Updating $domain to $public_ip"
    curl -X POST "https://api.dnsservice.com/update" \
        -d "domain=$domain&ip=$public_ip"
fi
```

**Example 4: VPN Verification**
```zsh
# Check if VPN is active
echo "IP before VPN: $(network-get-public-ip)"

# Connect VPN
vpn connect

echo "IP after VPN: $(network-get-public-ip)"
```

**Example 5: Public IP Monitoring**
```zsh
# Alert on public IP change
previous_ip=$(network-get-public-ip)

while true; do
    current_ip=$(network-get-public-ip)

    if [[ -n "$current_ip" && "$current_ip" != "$previous_ip" ]]; then
        echo "[ALERT] Public IP changed: $previous_ip → $current_ip"
        send_notification "Public IP changed to $current_ip"
        previous_ip="$current_ip"
    fi

    sleep 300  # Check every 5 minutes
done
```

**Notes:**
- Requires internet connectivity
- Requires curl or wget
- May be blocked by corporate firewalls
- Consider caching result if called frequently (changes infrequently)
- Respects NETWORK_HTTP_TIMEOUT configuration

---

#### network-get-gateway

Get default gateway IP address.

**Source:** Lines 201-213
**Complexity:** O(1)
**Performance:** ~10-50ms

**Syntax:**
```zsh
network-get-gateway
```

**Returns:**
- `0` - Success (gateway IP printed to stdout)
- `1` - Failed (no gateway or tools unavailable)

**Tool Support (in order):**
1. `ip route` (preferred - iproute2)
2. `route -n` (fallback - net-tools)
3. `netstat -rn` (legacy fallback)

**Example 1: Get Gateway**
```zsh
gateway=$(network-get-gateway)
echo "Default gateway: $gateway"
# Output: Default gateway: 192.168.1.1
```

**Example 2: Network Diagnostics**
```zsh
gateway=$(network-get-gateway)

echo "Testing network connectivity..."
echo "Gateway: $gateway"

if network-ping-host "$gateway" 1 2; then
    echo "✓ Gateway reachable"
else
    echo "✗ Gateway unreachable"
fi
```

**Example 3: Routing Configuration**
```zsh
# Add static route via current gateway
gateway=$(network-get-gateway)
sudo ip route add 10.0.0.0/8 via "$gateway"
```

**Example 4: Gateway Monitoring**
```zsh
# Monitor gateway availability
gateway=$(network-get-gateway)

while true; do
    if ! network-ping-host "$gateway" 1 2 >/dev/null 2>&1; then
        echo "$(date): Gateway $gateway unreachable!"
    fi
    sleep 10
done
```

**Notes:**
- Returns IPv4 gateway only
- Returns first gateway if multiple routes exist
- Returns empty string if no default route configured

---

#### network-list-interfaces

List all network interfaces.

**Source:** Lines 228-238
**Complexity:** O(n) where n = number of interfaces
**Performance:** ~10-100ms

**Syntax:**
```zsh
network-list-interfaces
```

**Returns:**
- `0` - Success (interface names printed to stdout, one per line)
- `1` - Failed (no tools available)

**Tool Support:**
- `ip link` (preferred - iproute2)
- `ifconfig -a` (fallback - net-tools)

**Output Format:**
```
eth0
wlan0
lo
docker0
```

**Example 1: List Interfaces**
```zsh
echo "Network Interfaces:"
network-list-interfaces
```

**Example 2: Interface Information**
```zsh
network-list-interfaces | while read iface; do
    status=$(network-get-interface-status "$iface")
    echo "$iface: $status"
done
```

**Example 3: Filter Active Interfaces**
```zsh
echo "Active interfaces:"
network-list-interfaces | while read iface; do
    status=$(network-get-interface-status "$iface")
    [[ "$status" == "UP" ]] && echo "  $iface"
done
```

**Example 4: Interface Statistics**
```zsh
total=0
up=0

network-list-interfaces | while read iface; do
    ((total++))
    status=$(network-get-interface-status "$iface")
    [[ "$status" == "UP" ]] && ((up++))
done

echo "Interfaces: $up/$total UP"
```

**Notes:**
- Includes all interfaces (physical, virtual, loopback, bridges)
- Interface names only (no additional info)
- Use `network-get-interface-status` for interface state
- Use `network-get-local-ip` for IP addresses

---

#### network-get-interface-status

Get interface status (UP/DOWN).

**Source:** Lines 240-256
**Complexity:** O(1)
**Performance:** ~10-50ms

**Syntax:**
```zsh
network-get-interface-status <interface>
```

**Parameters:**
- `interface` - Interface name (required)

**Returns:**
- `0` - Success (status printed to stdout: UP, DOWN, or UNKNOWN)
- `1` - Failed (interface not found or tools unavailable)

**Status Values:**
- `UP` - Interface is enabled and operational
- `DOWN` - Interface is disabled
- `UNKNOWN` - Interface state could not be determined

**Tool Support:**
- `ip link show` (preferred - iproute2)
- `ifconfig` (fallback - net-tools)

**Example 1: Check Interface Status**
```zsh
status=$(network-get-interface-status "eth0")
echo "eth0 is $status"
# Output: eth0 is UP
```

**Example 2: Conditional Actions**
```zsh
if [[ "$(network-get-interface-status wlan0)" == "UP" ]]; then
    echo "WiFi is connected"
else
    echo "WiFi is disconnected"
    sudo ip link set wlan0 up
fi
```

**Example 3: Interface Monitoring**
```zsh
interface="eth0"

while true; do
    status=$(network-get-interface-status "$interface")
    echo "$(date): $interface is $status"
    sleep 5
done
```

**Example 4: System Status Report**
```zsh
echo "Interface Status:"
network-list-interfaces | while read iface; do
    status=$(network-get-interface-status "$iface")
    printf "  %-10s %s\n" "$iface" "$status"
done
```

**Notes:**
- Fast operation (<50ms)
- Works for physical and virtual interfaces
- UP status does not guarantee network connectivity

---

#### network-get-interface-mac

Get MAC address for interface.

**Source:** Lines 258-270
**Complexity:** O(1)
**Performance:** ~10-50ms

**Syntax:**
```zsh
network-get-interface-mac <interface>
```

**Parameters:**
- `interface` - Interface name (required)

**Returns:**
- `0` - Success (MAC address printed to stdout)
- `1` - Failed (interface not found or no MAC)

**Output Format:** `00:11:22:33:44:55` (colon-separated hex)

**Tool Support:**
- `ip link show` (preferred - iproute2)
- `ifconfig` (fallback - net-tools)

**Example 1: Get MAC Address**
```zsh
mac=$(network-get-interface-mac "eth0")
echo "eth0 MAC: $mac"
# Output: eth0 MAC: 00:11:22:33:44:55
```

**Example 2: MAC-Based Configuration**
```zsh
mac=$(network-get-interface-mac "eth0")

# Use MAC for license key
license_key=$(generate_license "$mac")
echo "License key: $license_key"
```

**Example 3: Hardware Inventory**
```zsh
echo "Network Hardware:"
network-list-interfaces | while read iface; do
    mac=$(network-get-interface-mac "$iface" 2>/dev/null)
    [[ -n "$mac" ]] && echo "  $iface: $mac"
done
```

**Example 4: Wake-on-LAN**
```zsh
# Get MAC of remote machine for WoL
remote_host="server1"
remote_iface="eth0"

# (Assuming you have SSH access)
mac=$(ssh "$remote_host" "network-get-interface-mac $remote_iface")
echo "Sending WoL packet to $mac..."
wakeonlan "$mac"
```

**Notes:**
- Virtual interfaces (lo, tun, etc.) may not have MAC addresses
- MAC address is hardware-level identifier
- Returns empty string for interfaces without MAC

---

### Port & Service Functions

<!-- CONTEXT_GROUP: network-ports -->

#### network-is-port-open

Check if TCP port is open on host.

**Source:** Lines 272-285
**Complexity:** O(1)
**Performance:** ~100ms-10s (depends on timeout)

**Syntax:**
```zsh
network-is-port-open <host> <port>
```

**Parameters:**
- `host` - Hostname or IP address (required)
- `port` - TCP port number (required)

**Returns:**
- `0` - Port is open (accepting connections)
- `1` - Port is closed, filtered, or host unreachable

**Tool Support:**
- `nc -z` (netcat - preferred)
- `telnet` (fallback)

**Configuration:**
- `NETWORK_HTTP_TIMEOUT` - Connection timeout (default: 10s)

**Example 1: Simple Port Check**
```zsh
if network-is-port-open "localhost" 80; then
    echo "Web server is running"
else
    echo "Web server is not running"
fi
```

**Example 2: Multiple Port Scan**
```zsh
host="example.com"
ports=(22 80 443 3306 5432)

echo "Port scan: $host"
for port in "${ports[@]}"; do
    if network-is-port-open "$host" "$port"; then
        echo "  $port: OPEN"
    else
        echo "  $port: closed"
    fi
done

# Output:
# Port scan: example.com
#   22: OPEN
#   80: OPEN
#   443: OPEN
#   3306: closed
#   5432: closed
```

**Example 3: Service Dependency Check**
```zsh
# Check dependencies before starting application
dependencies=(
    "localhost:3306:MySQL"
    "localhost:6379:Redis"
    "localhost:5432:PostgreSQL"
)

for dep in "${dependencies[@]}"; do
    IFS=':' read -r host port name <<< "$dep"

    if ! network-is-port-open "$host" "$port"; then
        echo "[ERROR] $name not available on $host:$port" >&2
        exit 1
    fi
done

echo "All dependencies available, starting application..."
```

**Example 4: Fast Port Check**
```zsh
# Quick check with 2 second timeout
NETWORK_HTTP_TIMEOUT=2 network-is-port-open "192.168.1.100" 22
```

**Example 5: Port Scanner**
```zsh
# Simple port scanner
host="${1:-localhost}"
start_port="${2:-1}"
end_port="${3:-1024}"

echo "Scanning $host ports $start_port-$end_port..."

for port in $(seq $start_port $end_port); do
    if network-is-port-open "$host" "$port" 2>/dev/null; then
        echo "Port $port: OPEN"
    fi
done
```

**Notes:**
- TCP connections only (no UDP support)
- Silent operation (redirects stderr)
- Respects NETWORK_HTTP_TIMEOUT
- May be blocked by firewalls
- Some networks block nc or telnet

---

#### network-wait-port

Wait for port to become available.

**Source:** Lines 287-308
**Complexity:** O(t) where t = timeout duration
**Performance:** Blocking, up to timeout seconds

**Syntax:**
```zsh
network-wait-port <host> <port> [timeout]
```

**Parameters:**
- `host` - Hostname or IP address (required)
- `port` - TCP port number (required)
- `timeout` - Maximum wait time in seconds (default: NETWORK_RETRY_MAX × NETWORK_RETRY_DELAY)

**Returns:**
- `0` - Port became available within timeout
- `1` - Timeout reached, port still unavailable

**Configuration:**
- `NETWORK_RETRY_MAX` - Default max retries (default: 3)
- `NETWORK_RETRY_DELAY` - Delay between checks (default: 2s)

**Algorithm:**
1. Check if port is open via `network-is-port-open`
2. If open, return success immediately
3. If closed, sleep NETWORK_RETRY_DELAY seconds
4. Repeat until timeout reached

**Example 1: Wait for Service**
```zsh
echo "Starting MySQL..."
systemctl start mysql

echo "Waiting for MySQL..."
if network-wait-port "localhost" 3306 30; then
    echo "MySQL is ready"
else
    echo "MySQL failed to start within 30 seconds"
    exit 1
fi
```

**Example 2: Docker Container Startup**
```zsh
# Start container
docker-compose up -d postgres

# Wait for PostgreSQL to be ready
network-wait-port "localhost" 5432 60 || {
    echo "PostgreSQL container failed to start"
    docker-compose logs postgres
    exit 1
}

# Run migrations
./run-migrations.sh
```

**Example 3: Multi-Service Startup**
```zsh
services=(
    "MySQL:localhost:3306"
    "Redis:localhost:6379"
    "Elasticsearch:localhost:9200"
)

for service in "${services[@]}"; do
    IFS=':' read -r name host port <<< "$service"

    echo "Waiting for $name..."
    if ! network-wait-port "$host" "$port" 30; then
        echo "[ERROR] $name not available after 30s" >&2
        exit 1
    fi
    echo "✓ $name ready"
done

echo "All services ready!"
```

**Example 4: Remote Service Deployment**
```zsh
# Deploy application
ssh server "systemctl restart myapp"

# Wait for application to be ready
network-wait-port "server" 8080 120 || {
    echo "Application failed to start"
    ssh server "journalctl -u myapp -n 50"
    exit 1
}

echo "Application deployed successfully"
```

**Example 5: Health Check**
```zsh
# Restart service and verify it comes back up
service="nginx"
port=80

systemctl restart "$service"

if network-wait-port "localhost" "$port" 10; then
    echo "$service restarted successfully"
else
    echo "$service failed to restart"
    systemctl status "$service"
    exit 1
fi
```

**Notes:**
- Blocking operation (script waits until port available or timeout)
- Logs progress to stderr via _log
- Useful for orchestration scripts
- Default timeout: NETWORK_RETRY_MAX × NETWORK_RETRY_DELAY (typically 6s)

---

### Utility Functions

<!-- CONTEXT_GROUP: network-utils -->

#### network-download

Download file via HTTP/HTTPS.

**Source:** Lines 310-331
**Complexity:** O(s) where s = file size
**Performance:** Depends on file size and connection speed

**Syntax:**
```zsh
network-download <url> [output_file]
```

**Parameters:**
- `url` - URL to download (required, http:// or https://)
- `output_file` - Destination file path (optional, default: print to stdout)

**Returns:**
- `0` - Download successful
- `1` - Download failed or tools unavailable

**Tool Support:**
- `curl -L` (preferred, follows redirects)
- `wget -O` (fallback)

**Configuration:**
- `NETWORK_HTTP_TIMEOUT` - HTTP request timeout (default: 10s)

**Example 1: Download to File**
```zsh
url="https://example.com/file.tar.gz"
output="/tmp/file.tar.gz"

if network-download "$url" "$output"; then
    echo "Downloaded: $output"
    tar -xzf "$output"
else
    echo "Download failed"
    exit 1
fi
```

**Example 2: Download to stdout**
```zsh
# Pipe download directly to processor
network-download "https://api.github.com/repos/owner/repo/releases/latest" |
    jq -r '.assets[0].browser_download_url'
```

**Example 3: Multiple File Download**
```zsh
urls=(
    "https://example.com/file1.zip"
    "https://example.com/file2.zip"
    "https://example.com/file3.zip"
)

for url in "${urls[@]}"; do
    filename=$(basename "$url")
    echo "Downloading $filename..."

    if network-download "$url" "/tmp/$filename"; then
        echo "✓ $filename"
    else
        echo "✗ $filename failed"
    fi
done
```

**Example 4: API Request**
```zsh
# Download JSON from API
api_url="https://api.example.com/data"
data=$(network-download "$api_url")

if [[ -n "$data" ]]; then
    echo "$data" | jq .
else
    echo "API request failed"
fi
```

**Example 5: With Progress Indication**
```zsh
url="https://releases.example.com/large-file.iso"
output="/tmp/large-file.iso"

echo "Downloading $(basename $url)..."
if network-download "$url" "$output"; then
    size=$(du -h "$output" | cut -f1)
    echo "Download complete: $size"
else
    echo "Download failed"
    rm -f "$output"
fi
```

**Notes:**
- Follows HTTP redirects automatically (curl -L, wget default behavior)
- Respects NETWORK_HTTP_TIMEOUT
- No progress bar (silent download)
- For large files, consider using curl/wget directly for progress indication
- HTTPS supported (uses system CA certificates)

---

#### network-info

Display comprehensive network information.

**Source:** Lines 333-373
**Complexity:** O(n) where n = number of interfaces
**Performance:** ~2-10 seconds (queries multiple sources)

**Syntax:**
```zsh
network-info
```

**Returns:**
- `0` - Always successful (displays information to stdout)

**Information Displayed:**
- Internet connectivity status
- Local IP address (primary interface)
- Public IP address (if online)
- Default gateway
- Gateway reachability
- All network interfaces with status, IP, and MAC

**Example 1: Basic Network Info**
```zsh
network-info

# Output:
# === Network Information ===
#
# Connectivity:
#   Status: ONLINE
#   Local IP: 192.168.1.100
#   Public IP: 203.0.113.45
#   Gateway: 192.168.1.1
#   Gateway Status: REACHABLE
#
# Interfaces:
#   eth0:
#     Status: UP
#     IP: 192.168.1.100
#     MAC: 00:11:22:33:44:55
#   wlan0:
#     Status: DOWN
#   lo:
#     Status: UNKNOWN
#     IP: 127.0.0.1
#     MAC: 00:00:00:00:00:00
```

**Example 2: Save Network Report**
```zsh
# Save network info to file
network-info > /tmp/network-report.txt

# Include in system report
{
    echo "=== System Report ==="
    echo "Date: $(date)"
    echo ""
    network-info
} > system-report.txt
```

**Example 3: Scheduled Network Check**
```zsh
# Cron job: daily network status report
#!/usr/bin/env zsh
source "$(which _network)"

{
    echo "Daily Network Report - $(date)"
    network-info
} | mail -s "Network Status" admin@example.com
```

**Example 4: Troubleshooting Script**
```zsh
#!/usr/bin/env zsh
# Network diagnostics script

source "$(which _network)"

echo "===== Network Diagnostics ====="
echo ""

# Basic info
network-info

echo ""
echo "===== DNS Tests ====="
for host in google.com github.com; do
    ip=$(network-resolve-host "$host" 2>&1)
    echo "$host = $ip"
done

echo ""
echo "===== Connectivity Tests ====="
for host in 8.8.8.8 1.1.1.1; do
    if network-ping-host "$host" 1 2 >/dev/null 2>&1; then
        echo "✓ $host reachable"
    else
        echo "✗ $host unreachable"
    fi
done
```

**Notes:**
- Comprehensive output (multiple queries)
- Slower than individual functions (2-10 seconds)
- Suitable for diagnostics and reports
- All failures are gracefully handled (shows "N/A" if data unavailable)

---

#### network-self-test

Run comprehensive self-tests.

**Source:** Lines 375-407
**Complexity:** O(n) where n = number of tests
**Performance:** ~5-15 seconds (depends on network connectivity)

**Syntax:**
```zsh
network-self-test
```

**Returns:**
- `0` - All tests passed
- `1` - One or more tests failed

**Tests Performed:**
1. Dependency check (ping, ip/ifconfig)
2. Connectivity check (network-is-online)
3. Local IP detection
4. Gateway detection
5. Interface listing
6. DNS resolution (if online)
7. Localhost ping test
8. Port check (if any ports listening)
9. Public IP detection (if online)
10. Interface status check

**Example 1: Basic Self-Test**
```zsh
#!/usr/bin/env zsh
source "$(which _network)"

if network-self-test; then
    echo "All network tests passed"
    exit 0
else
    echo "Some network tests failed"
    exit 1
fi

# Output:
# === Testing lib/_network v1.0.0 ===
# Passed: 10/10
```

**Example 2: Startup Validation**
```zsh
# Validate network subsystem before starting services
source "$(which _network)"

echo "Validating network subsystem..."
if ! network-self-test; then
    echo "[ERROR] Network subsystem validation failed" >&2
    exit 1
fi

echo "Network subsystem OK, starting services..."
```

**Example 3: CI/CD Pipeline**
```zsh
# Include in test suite
test_network() {
    source "$(which _network)"
    network-self-test
}

# Run all tests
test_network || exit 1
```

**Example 4: Periodic Health Check**
```zsh
# Cron job: hourly network health check
#!/usr/bin/env zsh
source "$(which _network)"

if ! network-self-test >/dev/null 2>&1; then
    echo "Network health check failed at $(date)" |
        mail -s "ALERT: Network Issue" admin@example.com
fi
```

**Notes:**
- Comprehensive test suite (exercises all major functions)
- Tests are non-destructive (read-only operations)
- Some tests are skipped if prerequisites unavailable (e.g., skip DNS if offline)
- Suitable for CI/CD validation and health monitoring

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Network Monitoring Script

Complete network monitoring solution with alerting:

```zsh
#!/usr/bin/env zsh
# Network monitoring daemon

source "$(which _network)" || exit 1
source "$(which _log)" 2>/dev/null || {
    log-info() { echo "[INFO] $*"; }
    log-error() { echo "[ERROR] $*" >&2; }
}

# Configuration
MONITOR_INTERVAL=60  # Check every 60 seconds
ALERT_EMAIL="admin@example.com"
ALERT_THRESHOLD=3    # Alert after 3 consecutive failures

# State
consecutive_failures=0
previous_public_ip=""

monitor_connectivity() {
    if network-is-online; then
        log-info "Connectivity: OK"
        consecutive_failures=0
        return 0
    else
        log-error "Connectivity: FAILED"
        ((consecutive_failures++))

        if [[ $consecutive_failures -ge $ALERT_THRESHOLD ]]; then
            send_alert "Internet connectivity lost for $((consecutive_failures * MONITOR_INTERVAL)) seconds"
        fi

        return 1
    fi
}

monitor_gateway() {
    local gateway=$(network-get-gateway)

    if network-check-gateway; then
        log-info "Gateway $gateway: OK"
    else
        log-error "Gateway $gateway: UNREACHABLE"
        send_alert "Default gateway $gateway is unreachable"
    fi
}

monitor_public_ip() {
    local current_ip=$(network-get-public-ip 2>/dev/null)

    if [[ -n "$current_ip" ]]; then
        if [[ -n "$previous_public_ip" && "$current_ip" != "$previous_public_ip" ]]; then
            log-info "Public IP changed: $previous_public_ip → $current_ip"
            send_alert "Public IP changed from $previous_public_ip to $current_ip"
        fi
        previous_public_ip="$current_ip"
    fi
}

send_alert() {
    local message="$1"
    log-error "ALERT: $message"
    echo "$message" | mail -s "[ALERT] Network Monitor" "$ALERT_EMAIL"
}

# Main monitoring loop
log-info "Starting network monitor (interval: ${MONITOR_INTERVAL}s)"

while true; do
    monitor_connectivity
    monitor_gateway
    monitor_public_ip

    sleep "$MONITOR_INTERVAL"
done
```

---

### Dynamic DNS Updater

Update DNS records when public IP changes:

```zsh
#!/usr/bin/env zsh
# Dynamic DNS updater

source "$(which _network)" || exit 1

# Configuration
DDNS_PROVIDER="https://api.ddns-provider.com/update"
DDNS_TOKEN="your-api-token"
DDNS_DOMAIN="home.example.com"
CHECK_INTERVAL=300  # 5 minutes

previous_ip=""

update_dns() {
    local new_ip="$1"

    echo "Updating DNS: $DDNS_DOMAIN → $new_ip"

    response=$(curl -s -X POST "$DDNS_PROVIDER" \
        -H "Authorization: Bearer $DDNS_TOKEN" \
        -d "domain=$DDNS_DOMAIN" \
        -d "ip=$new_ip")

    if [[ $? -eq 0 ]]; then
        echo "DNS update successful"
        return 0
    else
        echo "DNS update failed: $response" >&2
        return 1
    fi
}

# Main loop
echo "Starting Dynamic DNS updater for $DDNS_DOMAIN"

while true; do
    if network-is-online; then
        current_ip=$(network-get-public-ip)

        if [[ -n "$current_ip" && "$current_ip" != "$previous_ip" ]]; then
            echo "Public IP changed: ${previous_ip:-<unknown>} → $current_ip"

            if update_dns "$current_ip"; then
                previous_ip="$current_ip"
            fi
        fi
    else
        echo "Offline, skipping check"
    fi

    sleep "$CHECK_INTERVAL"
done
```

---

### Service Dependency Manager

Wait for all service dependencies before starting application:

```zsh
#!/usr/bin/env zsh
# Service dependency checker

source "$(which _network)" || exit 1

# Define service dependencies
typeset -A DEPENDENCIES=(
    [mysql]="localhost:3306"
    [redis]="localhost:6379"
    [postgres]="localhost:5432"
    [elasticsearch]="localhost:9200"
    [rabbitmq]="localhost:5672"
)

TIMEOUT=120  # 2 minutes timeout per service

check_all_dependencies() {
    local failed=0

    for service host_port in ${(kv)DEPENDENCIES}; do
        IFS=':' read -r host port <<< "$host_port"

        echo "Checking $service ($host:$port)..."

        if network-wait-port "$host" "$port" "$TIMEOUT"; then
            echo "✓ $service is available"
        else
            echo "✗ $service is not available after ${TIMEOUT}s" >&2
            ((failed++))
        fi
    done

    return $failed
}

# Main
echo "===== Service Dependency Check ====="
echo ""

if check_all_dependencies; then
    echo ""
    echo "All dependencies satisfied, starting application..."
    exec /usr/local/bin/myapp
else
    echo ""
    echo "[ERROR] Not all dependencies are available" >&2
    exit 1
fi
```

---

### Network Diagnostics Tool

Comprehensive network troubleshooting tool:

```zsh
#!/usr/bin/env zsh
# Network diagnostics tool

source "$(which _network)" || exit 1

diagnose_connectivity() {
    echo "===== Connectivity Diagnostics ====="
    echo ""

    # Test 1: Local interface
    echo "1. Local Interface:"
    local local_ip=$(network-get-local-ip)
    if [[ -n "$local_ip" ]]; then
        echo "   ✓ Local IP: $local_ip"
    else
        echo "   ✗ No local IP address"
        echo "   → Check: Network interface status, cable connection"
        return 1
    fi

    # Test 2: Gateway
    echo ""
    echo "2. Default Gateway:"
    local gateway=$(network-get-gateway)
    if [[ -n "$gateway" ]]; then
        echo "   Gateway: $gateway"

        if network-check-gateway; then
            echo "   ✓ Gateway is reachable"
        else
            echo "   ✗ Gateway is unreachable"
            echo "   → Check: Router power, network cable"
            return 1
        fi
    else
        echo "   ✗ No default gateway configured"
        echo "   → Check: DHCP server, network configuration"
        return 1
    fi

    # Test 3: DNS
    echo ""
    echo "3. DNS Resolution:"
    if network-resolve-host "google.com" >/dev/null 2>&1; then
        echo "   ✓ DNS is working"
    else
        echo "   ✗ DNS resolution failed"
        echo "   → Check: /etc/resolv.conf, DNS server"
        return 1
    fi

    # Test 4: Internet
    echo ""
    echo "4. Internet Connectivity:"
    if network-is-online; then
        echo "   ✓ Internet is accessible"

        # Bonus: Public IP
        public_ip=$(network-get-public-ip 2>/dev/null)
        [[ -n "$public_ip" ]] && echo "   Public IP: $public_ip"
    else
        echo "   ✗ Internet is not accessible"
        echo "   → Check: ISP connection, router internet status"
        return 1
    fi

    echo ""
    echo "===== All Tests Passed ====="
    return 0
}

# Run diagnostics
diagnose_connectivity
exit $?
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Common Issues and Solutions

#### Issue: "ping command not found"

**Symptoms:**
```
[ERROR] ping not found
network-check-dependencies failing
```

**Cause:** `ping` utility not installed.

**Solution:**
```bash
# Arch Linux
sudo pacman -S iputils

# Debian/Ubuntu
sudo apt install iputils-ping

# Fedora/RHEL
sudo dnf install iputils

# Alpine
apk add iputils
```

**Source Reference:** → L46-49

---

#### Issue: "ip or ifconfig required"

**Symptoms:**
```
[ERROR] ip or ifconfig required
network-check-dependencies failing
```

**Cause:** Neither `ip` nor `ifconfig` are installed.

**Solution:**
```bash
# Install iproute2 (modern, recommended)
sudo pacman -S iproute2      # Arch
sudo apt install iproute2     # Debian/Ubuntu
sudo dnf install iproute      # Fedora/RHEL

# OR install net-tools (legacy fallback)
sudo apt install net-tools    # Debian/Ubuntu
```

**Source Reference:** → L50-52

---

#### Issue: network-is-online always returns false

**Symptoms:**
```
Internet: OFFLINE (but you have internet)
All connectivity checks fail
```

**Causes:**
1. Corporate firewall blocking ICMP
2. Custom DNS blocking check hosts
3. Very slow network (timeouts too short)

**Solutions:**

**Solution 1: Use internal check hosts**
```zsh
# Test internal hosts instead
export NETWORK_CHECK_HOSTS="intranet.company.com 192.168.1.1"
source "$(which _network)"
network-is-online
```

**Solution 2: Increase timeouts**
```zsh
# Increase timeout for slow networks
export NETWORK_PING_TIMEOUT=10
export NETWORK_PING_COUNT=5
source "$(which _network)"
network-is-online
```

**Solution 3: Use HTTP check instead**
```zsh
# Alternative: Check HTTP connectivity
if network-download "http://google.com" >/dev/null 2>&1; then
    echo "Internet available via HTTP"
fi
```

**Source Reference:** → L58-71

---

#### Issue: network-get-public-ip returns empty

**Symptoms:**
```
Public IP detection fails
network-get-public-ip returns nothing
```

**Causes:**
1. No internet connectivity
2. Firewall blocking HTTPS to IP detection services
3. curl/wget not installed

**Solutions:**

**Solution 1: Check connectivity first**
```zsh
if network-is-online; then
    public_ip=$(network-get-public-ip)
else
    echo "No internet connection"
fi
```

**Solution 2: Install HTTP client**
```bash
# Install curl (preferred)
sudo pacman -S curl      # Arch
sudo apt install curl    # Debian/Ubuntu

# OR wget (fallback)
sudo apt install wget
```

**Solution 3: Use alternative service**
```zsh
# Manual check with different service
curl -s https://icanhazip.com
curl -s https://ipinfo.io/ip
```

**Source Reference:** → L177-199

---

#### Issue: network-resolve-host fails

**Symptoms:**
```
DNS resolution fails
Empty output from network-resolve-host
```

**Causes:**
1. No DNS tools installed
2. DNS server unreachable
3. /etc/resolv.conf misconfigured

**Solutions:**

**Solution 1: Install DNS tools**
```bash
# Install bind-tools (host, dig)
sudo pacman -S bind-tools        # Arch
sudo apt install dnsutils         # Debian/Ubuntu
sudo dnf install bind-utils       # Fedora/RHEL
```

**Solution 2: Check DNS configuration**
```bash
# Check /etc/resolv.conf
cat /etc/resolv.conf

# Should contain something like:
# nameserver 8.8.8.8
# nameserver 1.1.1.1

# Test DNS manually
host google.com 8.8.8.8
dig @8.8.8.8 google.com +short
```

**Solution 3: Use alternative resolver**
```zsh
# Query specific DNS server
dig @8.8.8.8 example.com +short
host example.com 1.1.1.1
```

**Source Reference:** → L120-136

---

#### Issue: network-wait-port times out

**Symptoms:**
```
Timeout waiting for localhost:3306
Service appears to be running but port check fails
```

**Causes:**
1. Service listening on different interface (127.0.0.1 vs 0.0.0.0)
2. Firewall blocking connection
3. nc (netcat) not installed
4. Service taking longer than timeout

**Solutions:**

**Solution 1: Increase timeout**
```zsh
# Wait longer for slow-starting services
network-wait-port "localhost" 3306 120  # 2 minute timeout
```

**Solution 2: Install netcat**
```bash
sudo pacman -S gnu-netcat        # Arch
sudo apt install netcat-openbsd  # Debian/Ubuntu
```

**Solution 3: Check service binding**
```bash
# Check what interface service is listening on
sudo netstat -tlnp | grep 3306
sudo ss -tlnp | grep 3306

# If service binds to 127.0.0.1 only, use that instead of "localhost"
network-wait-port "127.0.0.1" 3306 30
```

**Solution 4: Manual port test**
```bash
# Test port manually
nc -zv localhost 3306
telnet localhost 3306

# Check service is actually running
systemctl status mysql
```

**Source Reference:** → L287-308

---

#### Issue: network-get-local-ip returns loopback

**Symptoms:**
```
Local IP: 127.0.0.1 (should be 192.168.x.x)
```

**Cause:** No default route configured, falling back to first non-loopback interface.

**Solution:**
```zsh
# Specify interface explicitly
network-get-local-ip "eth0"
network-get-local-ip "wlan0"

# Check routing table
ip route show
route -n

# Add default route if missing
sudo ip route add default via 192.168.1.1
```

**Source Reference:** → L152-175

---

### Debugging Tips

#### Enable Debug Logging

```zsh
# Enable debug output
export DEBUG=1
source "$(which _network)"

# Now all functions log detailed info
network-is-online
# Output:
# [DEBUG] Pinging google.com...
# [TRACE] Connectivity confirmed via google.com
```

#### Verbose Connectivity Test

```zsh
# Test connectivity with full output
NETWORK_PING_COUNT=3 \
NETWORK_PING_TIMEOUT=5 \
DEBUG=1 \
network-is-online && echo "ONLINE" || echo "OFFLINE"
```

#### Test Individual Components

```zsh
# Test each function independently
echo "1. Ping test:"
network-ping-host "8.8.8.8" 1 2 && echo "✓ OK" || echo "✗ FAIL"

echo "2. DNS test:"
network-resolve-host "google.com" && echo "✓ OK" || echo "✗ FAIL"

echo "3. Gateway test:"
network-check-gateway && echo "✓ OK" || echo "✗ FAIL"

echo "4. HTTP test:"
network-get-public-ip >/dev/null 2>&1 && echo "✓ OK" || echo "✗ FAIL"
```

---

## Performance

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

### Function Performance Summary

| Function | Typical Time | Blocking | Network I/O |
|----------|--------------|----------|-------------|
| `network-check-dependencies` | <10ms | No | No |
| `network-is-online` | 2-5s | No | Yes (ICMP) |
| `network-wait-online` | 0-timeout | Yes | Yes (ICMP) |
| `network-ping-host` | 1-5s | No | Yes (ICMP) |
| `network-resolve-host` | 100ms-2s | No | Yes (DNS) |
| `network-get-local-ip` | 10-50ms | No | No |
| `network-get-public-ip` | 500ms-5s | No | Yes (HTTP) |
| `network-get-gateway` | 10-50ms | No | No |
| `network-is-port-open` | 100ms-10s | No | Yes (TCP) |
| `network-wait-port` | 0-timeout | Yes | Yes (TCP) |
| `network-download` | varies | Yes | Yes (HTTP) |
| `network-info` | 2-10s | No | Yes (multiple) |

### Optimization Strategies

**1. Reduce Timeouts for Fast Checks:**
```zsh
# Fast connectivity check (1s total)
NETWORK_PING_COUNT=1 NETWORK_PING_TIMEOUT=1 network-is-online
```

**2. Cache Results:**
```zsh
# Cache public IP (changes infrequently)
if [[ -z "$PUBLIC_IP_CACHE" ]]; then
    PUBLIC_IP_CACHE=$(network-get-public-ip)
fi
echo "Public IP: $PUBLIC_IP_CACHE"
```

**3. Parallel Checks:**
```zsh
# Check multiple hosts in parallel
{
    network-is-reachable "host1.com" && echo "host1: UP" &
    network-is-reachable "host2.com" && echo "host2: UP" &
    network-is-reachable "host3.com" && echo "host3: UP" &
    wait
}
```

**4. Use Specific Functions:**
```zsh
# Don't use network-is-online if you just need gateway
# Faster:
network-check-gateway

# Slower:
network-is-online  # Tests multiple hosts
```

---

## Version History

**v1.0.0** (2025-11-09)
- Initial release
- 19 network utility functions
- Connectivity testing (online, wait, reachable, ping)
- DNS resolution (forward and reverse)
- Network information (IPs, gateway, interfaces, MAC)
- Port checking (is-open, wait-port)
- Download utility (HTTP/HTTPS)
- Info display and self-test
- Multi-tool fallback support (ip/ifconfig, curl/wget, etc.)
- Comprehensive configuration via environment variables
- Full Enhanced Documentation Requirements v1.1 compliance

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-09
**Maintainer:** andronics

**Gold Standard Compliance:** Enhanced Documentation Requirements v1.1
- ✅ Quick Reference Tables (Functions, Env Vars, Return Codes)
- ✅ Source Line References (all functions documented with →L### notation)
- ✅ Context Markers (PRIORITY, SIZE, GROUP throughout)
- ✅ Hierarchical TOC with line offsets
- ✅ 62+ comprehensive examples
- ✅ Troubleshooting section with solutions
- ✅ Performance characteristics documented
- ✅ Function metadata (complexity, performance)
- ✅ Advanced usage patterns
- ✅ Complete API coverage (19/19 functions)
