# _process - Process Management and Monitoring

**Version:** 1.0.0
**Status:** Production
**Category:** Infrastructure

---

## Table of Contents

1. [Overview](#overview)
2. [Use Cases](#use-cases)
3. [Quick Start](#quick-start)
4. [Configuration](#configuration)
5. [API Reference](#api-reference)
6. [Events](#events)
7. [Examples](#examples)
8. [Troubleshooting](#troubleshooting)
9. [Architecture](#architecture)
10. [Performance](#performance)
11. [Changelog](#changelog)

---

## Overview

### Purpose

`_process` is a comprehensive process management and monitoring library that provides production-grade tools for process control, PID file management, resource monitoring, health checking, and graceful shutdown coordination. It serves as the foundation for daemon management, service orchestration, and system administration tasks throughout the dotfiles ecosystem.

This extension enables reliable process lifecycle management with automatic cleanup, resource monitoring with alerting, process group coordination, and sophisticated signal handling—all with graceful degradation and optional dependency management.

### Key Features

- **Process Detection & Validation**: Find processes by name, PID, port, or command
- **Process Information**: CPU usage, memory consumption, status, uptime
- **Process Control**: Start, stop, restart, signal sending with timeouts
- **PID File Management**: Create, read, validate, and cleanup PID files
- **Resource Monitoring**: Real-time CPU/memory tracking with alert thresholds
- **Process Groups**: Coordinate multiple related processes
- **Process Tree Operations**: Manage parent-child relationships
- **Graceful Shutdown**: Coordinated SIGTERM with fallback SIGKILL
- **Health Checking**: Process liveness and health verification
- **Event Integration**: Emit events for monitoring and automation
- **Cache Integration**: Optional caching for performance
- **Lifecycle Integration**: Automatic cleanup registration

### Dependencies

**Required:**
- `_common v2.0`: Core utilities and validation
- `ps`, `kill`: Process utilities (system dependencies)
- `pgrep`: Process finding (system dependency)

**Optional (gracefully degraded):**
- `_log v2.0`: Structured logging (falls back to echo)
- `_events v2.0`: Event emission for monitoring
- `_cache v2.0`: Process info caching for performance
- `_lifecycle v3.0`: Cleanup registration
- `lsof`, `ss`, `netstat`: Port-based process finding

### Version Information

- **Current Version**: 1.0.0
- **API Stability**: Stable
- **Breaking Changes**: None since v1.0.0
- **Deprecations**: None

---

## Use Cases

### 1. Service and Daemon Management

Manage long-running services with PID files, graceful shutdown, and automatic restart.

**When to Use:**
- Custom daemon processes
- Background services
- Application servers
- Queue workers
- Scheduled tasks

**Example Scenario:**
```zsh
# Service manager
service_start() {
    local service_name="${1}"
    local command="${2}"

    if process-check-pid-file "$service_name"; then
        log-info "Service already running: $service_name"
        return 0
    fi

    log-info "Starting service: $service_name"

    # Start service in background
    eval "$command" > "$(_process-get-log-file "$service_name")" 2>&1 &
    local pid=$!

    # Track with PID file
    process-write-pid "$service_name" "$pid"

    log-success "Service started: $service_name (PID: $pid)"
}

# Stop service gracefully
service_stop() {
    local service_name="${1}"

    if ! process-check-pid-file "$service_name"; then
        log-warn "Service not running: $service_name"
        return 0
    fi

    log-info "Stopping service: $service_name"
    process-stop "$service_name" --timeout 30 --force
}
```

### 2. Process Health Monitoring

Monitor process resource usage with alerting when thresholds are exceeded.

**When to Use:**
- Production monitoring
- Resource leak detection
- Performance tracking
- SLA enforcement
- Capacity planning

**Example Scenario:**
```zsh
# Monitor critical process
monitor_critical_process() {
    local service_name="${1}"

    log-info "Starting health monitoring for: $service_name"

    # Monitor with alerts
    process-monitor "$service_name" \
        --alert-cpu 80.0 \
        --alert-mem 1048576 \
        --interval 10 &

    local monitor_pid=$!
    process-write-pid "${service_name}_monitor" "$monitor_pid"
}

# Alert handler
events-on "$PROCESS_EVENT_ALERT" 'handle_alert'

handle_alert() {
    local service="${1}"
    local pid="${2}"
    local metric="${3}"
    local value="${4}"

    log-error "ALERT: $service - $metric threshold exceeded: $value"
    # Send notification, page on-call, etc.
}
```

### 3. Application Lifecycle Management

Coordinate application startup, shutdown, and restart with dependency management.

**When to Use:**
- Multi-process applications
- Service orchestration
- Deployment automation
- Rolling updates
- Blue-green deployments

**Example Scenario:**
```zsh
# Application lifecycle manager
app_start() {
    log-info "Starting application stack"

    # Start database first
    service_start "app_database" "postgres -D /var/lib/postgres"
    sleep 5  # Wait for DB startup

    # Start cache
    service_start "app_cache" "redis-server"
    sleep 2

    # Start application
    service_start "app_server" "node server.js"

    # Group for coordinated shutdown
    process-group-add "application" "app_database"
    process-group-add "application" "app_cache"
    process-group-add "application" "app_server"

    log-success "Application started"
}

app_stop() {
    log-info "Stopping application stack"

    # Stop in reverse order
    process-group-stop "application" --timeout 30 --force
}
```

### 4. Resource Usage Tracking

Track and report process resource consumption for analysis and optimization.

**When to Use:**
- Performance analysis
- Resource optimization
- Cost analysis (cloud)
- Capacity planning
- Debugging memory leaks

**Example Scenario:**
```zsh
# Resource tracker
track_resources() {
    local service_name="${1}"
    local duration="${2:-3600}"  # 1 hour default
    local interval=5

    local pid=$(process-read-pid "$service_name")
    local end_time=$(($(date +%s) + duration))

    echo "timestamp,cpu,memory" > "/tmp/${service_name}_metrics.csv"

    while (( $(date +%s) < end_time )); do
        if ! process-exists "$pid"; then
            log-error "Process died during monitoring"
            break
        fi

        local timestamp=$(date +%s)
        local cpu=$(process-get-cpu "$pid")
        local mem=$(process-get-memory "$pid")

        echo "$timestamp,$cpu,$mem" >> "/tmp/${service_name}_metrics.csv"

        sleep "$interval"
    done

    log-success "Resource tracking complete: /tmp/${service_name}_metrics.csv"
}
```

### 5. Graceful Shutdown Coordination

Implement graceful shutdown patterns for clean process termination.

**When to Use:**
- Signal handling
- Transaction cleanup
- Connection draining
- State persistence
- Clean exits

**Example Scenario:**
```zsh
# Graceful shutdown handler
setup_shutdown_handler() {
    local service_name="${1}"

    # Trap signals
    trap "shutdown_handler '$service_name'" SIGTERM SIGINT

    log-info "Shutdown handler registered for: $service_name"
}

shutdown_handler() {
    local service_name="${1}"

    log-info "Shutdown signal received for: $service_name"

    # Notify application to stop accepting new work
    process-signal "$service_name" "USR1"

    # Wait for in-flight work to complete
    sleep 10

    # Graceful shutdown
    process-stop "$service_name" --timeout 30 --force

    log-success "Graceful shutdown complete"
}
```

### 6. PID File-Based Locking

Use PID files for single-instance enforcement and coordination.

**When to Use:**
- Singleton processes
- Cron job coordination
- Resource access control
- Duplicate prevention
- Lock files

**Example Scenario:**
```zsh
# Single-instance enforcer
ensure_single_instance() {
    local lock_name="${1}"

    if process-check-pid-file "$lock_name"; then
        local existing_pid=$(process-read-pid "$lock_name")
        log-error "Another instance is running (PID: $existing_pid)"
        return 1
    fi

    # Claim lock
    process-write-pid "$lock_name" $$

    # Register cleanup
    trap "process-remove-pid '$lock_name'" EXIT

    log-success "Lock acquired: $lock_name"
}

# Usage
ensure_single_instance "backup_job" || exit 1
# ... run backup ...
```

### 7. Process Supervision

Supervise processes with automatic restart on failure.

**When to Use:**
- Critical services
- Fault tolerance
- High availability
- Auto-recovery
- Resilience patterns

**Example Scenario:**
```zsh
# Process supervisor
supervise_process() {
    local service_name="${1}"
    local command="${2}"
    local restart_count=0

    while (( restart_count < PROCESS_MAX_RESTARTS )); do
        log-info "Starting $service_name (attempt $((restart_count + 1)))"

        # Start process
        eval "$command" &
        local pid=$!
        process-write-pid "$service_name" "$pid"

        # Wait for process to exit
        wait "$pid"
        local exit_code=$?

        log-warn "$service_name exited with code $exit_code"

        ((restart_count++))

        if (( restart_count < PROCESS_MAX_RESTARTS )); then
            log-info "Restarting in ${PROCESS_RESTART_DELAY}s"
            sleep "$PROCESS_RESTART_DELAY"
        fi
    done

    log-error "$service_name failed $restart_count times - giving up"
}
```

### 8. System Administration Tasks

Perform administrative tasks with process management utilities.

**When to Use:**
- System maintenance
- Process cleanup
- Diagnostics
- Troubleshooting
- Automation scripts

**Example Scenario:**
```zsh
# System maintenance
cleanup_stuck_processes() {
    log-info "Checking for stuck processes"

    # Find processes using specific port
    local port=8080
    local pid=$(process-find-by-port "$port")

    if [[ -n "$pid" ]]; then
        log-warn "Found process on port $port: $pid"

        # Get process info
        process-get-info "$pid"

        # Kill if necessary
        if confirm "Kill process $pid?"; then
            process-stop "$pid" --force
        fi
    fi

    # Cleanup stale PID files
    process-cleanup
}
```

---

## Quick Start

### Installation

```zsh
# Source the extension
source "$(which _process)"

# Verify installation
process-version
# Output: _process v1.0.0

# Run self-test
process-self-test
```

### Basic Usage

```zsh
# Check if process exists
if process-exists 1234; then
    echo "Process is running"
fi

# Find process by name
pid=$(process-find-by-name "nginx")

# Get process information
process-get-info "$pid"

# Stop process gracefully
process-stop "$pid" --timeout 10 --force

# PID file management
process-write-pid "myapp" 1234
pid=$(process-read-pid "myapp")
process-remove-pid "myapp"

# Monitor process resources
process-monitor "myapp" --alert-cpu 80 --alert-mem 1048576 &
```

### Environment Configuration

```zsh
# PID file directory
export PROCESS_PID_DIR="/run/user/$(id -u)/process"

# State directory
export PROCESS_STATE_DIR="$HOME/.local/state/process"

# Graceful shutdown timeout
export PROCESS_DEFAULT_TIMEOUT=10

# Monitor interval
export PROCESS_MONITOR_INTERVAL=5

# Max restart attempts
export PROCESS_MAX_RESTARTS=3

# Enable debug mode
export PROCESS_DEBUG=true
```

### Common Patterns

```zsh
# Pattern 1: Service with PID file
start_service() {
    local name="${1}"
    local cmd="${2}"

    if process-check-pid-file "$name"; then
        log-info "Already running"
        return 0
    fi

    eval "$cmd" &
    process-write-pid "$name" $!
}

# Pattern 2: Resource monitoring
monitor_service() {
    local name="${1}"

    process-monitor "$name" \
        --alert-cpu 75 \
        --alert-mem 524288 \
        --interval 10
}

# Pattern 3: Graceful shutdown
stop_service() {
    local name="${1}"

    process-stop "$name" --timeout 30 --force
    process-remove-pid "$name"
}
```

---

## Configuration

### Environment Variables

#### Directory Configuration

**PROCESS_PID_DIR**
- **Type**: Directory path
- **Default**: `$(common-xdg-runtime-dir)/process`
- **Description**: Directory for PID files
- **Example**: `export PROCESS_PID_DIR="/var/run/myapp"`

**PROCESS_STATE_DIR**
- **Type**: Directory path
- **Default**: `$(common-lib-state-dir)/process`
- **Description**: Directory for process state and metadata
- **Example**: `export PROCESS_STATE_DIR="$HOME/.local/state/myapp"`

**PROCESS_LOG_DIR**
- **Type**: Directory path
- **Default**: `$(common-lib-state-dir)/process/logs`
- **Description**: Directory for process logs
- **Example**: `export PROCESS_LOG_DIR="/var/log/myapp"`

#### Timeout Configuration

**PROCESS_DEFAULT_TIMEOUT**
- **Type**: Integer (seconds)
- **Default**: `10`
- **Description**: Default timeout for graceful shutdown
- **Example**: `export PROCESS_DEFAULT_TIMEOUT=30`

#### Monitoring Configuration

**PROCESS_MONITOR_INTERVAL**
- **Type**: Integer (seconds)
- **Default**: `5`
- **Description**: Interval between monitoring checks
- **Example**: `export PROCESS_MONITOR_INTERVAL=10`

#### Restart Configuration

**PROCESS_MAX_RESTARTS**
- **Type**: Integer
- **Default**: `3`
- **Description**: Maximum restart attempts for supervised processes
- **Example**: `export PROCESS_MAX_RESTARTS=5`

**PROCESS_RESTART_DELAY**
- **Type**: Integer (seconds)
- **Default**: `5`
- **Description**: Delay between restart attempts
- **Example**: `export PROCESS_RESTART_DELAY=10`

#### Cache Configuration

**PROCESS_CACHE_TTL**
- **Type**: Integer (seconds)
- **Default**: `2`
- **Description**: Time-to-live for cached process info (requires _cache)
- **Example**: `export PROCESS_CACHE_TTL=5`

#### Debug Configuration

**PROCESS_DEBUG**
- **Type**: Boolean (`true`|`false`)
- **Default**: `false`
- **Description**: Enable verbose debug logging
- **Example**: `export PROCESS_DEBUG=true`

### Configuration Examples

#### Development Configuration
```zsh
# Fast failures for development
export PROCESS_DEFAULT_TIMEOUT=5
export PROCESS_MONITOR_INTERVAL=2
export PROCESS_MAX_RESTARTS=1
export PROCESS_DEBUG=true
```

#### Production Configuration
```zsh
# Conservative settings for production
export PROCESS_DEFAULT_TIMEOUT=30
export PROCESS_MONITOR_INTERVAL=10
export PROCESS_MAX_RESTARTS=5
export PROCESS_RESTART_DELAY=10
export PROCESS_CACHE_TTL=5
```

#### High-Availability Configuration
```zsh
# Aggressive restart and monitoring
export PROCESS_DEFAULT_TIMEOUT=60
export PROCESS_MONITOR_INTERVAL=5
export PROCESS_MAX_RESTARTS=10
export PROCESS_RESTART_DELAY=3
```

---

## API Reference

### Process Detection

#### process-exists

Check if process with given PID exists.

**Signature:**
```zsh
process-exists <pid>
```

**Parameters:**
- `pid` (required): Process ID to check

**Returns:**
- Exit code 0 if process exists
- Exit code 1 if process does not exist

**Example:**
```zsh
# Check if process is running
if process-exists 1234; then
    echo "Process is running"
else
    echo "Process is not running"
fi

# Check current shell
if process-exists $$; then
    echo "Current shell PID: $$"
fi

# Validate PID before operation
pid=5678
if process-exists "$pid"; then
    process-stop "$pid"
else
    log-error "Process $pid not found"
fi
```

**Notes:**
- Uses `kill -0` for efficient check
- Does not send actual signal
- Returns false for invalid PIDs

---

#### process-is-running

Alias for `process-exists`. Check if process is running.

**Signature:**
```zsh
process-is-running <pid>
```

**Parameters:**
- `pid` (required): Process ID to check

**Returns:**
- Exit code 0 if process running
- Exit code 1 if process not running

**Example:**
```zsh
# Semantic alias
if process-is-running "$pid"; then
    echo "Process alive"
fi
```

---

#### process-find-by-name

Find first process matching exact name.

**Signature:**
```zsh
pid=$(process-find-by-name <name>)
```

**Parameters:**
- `name` (required): Exact process name to find

**Returns:**
- PID to stdout if found
- Nothing if not found
- Exit code 0 if found, 1 otherwise

**Example:**
```zsh
# Find nginx process
nginx_pid=$(process-find-by-name "nginx")

if [[ -n "$nginx_pid" ]]; then
    echo "Found nginx: $nginx_pid"
    process-get-info "$nginx_pid"
fi

# Find and stop
pid=$(process-find-by-name "old_daemon")
[[ -n "$pid" ]] && process-stop "$pid"
```

**Notes:**
- Uses `pgrep -x` for exact match
- Returns only first match
- Use `process-find-all-by-name` for all matches

---

#### process-find-all-by-name

Find all processes matching exact name.

**Signature:**
```zsh
pids=($(process-find-all-by-name <name>))
```

**Parameters:**
- `name` (required): Exact process name to find

**Returns:**
- PIDs to stdout (one per line)
- Nothing if not found

**Example:**
```zsh
# Find all python processes
pids=($(process-find-all-by-name "python"))

echo "Found ${#pids[@]} python processes"
for pid in "${pids[@]}"; do
    echo "  PID $pid: $(process-get-command $pid)"
done

# Stop all matching processes
for pid in $(process-find-all-by-name "old_worker"); do
    process-stop "$pid" --force
done
```

**Notes:**
- Uses `pgrep -x` for exact match
- Returns all matching PIDs
- One PID per line

---

#### process-find-by-port

Find process listening on specific port.

**Signature:**
```zsh
pid=$(process-find-by-port <port>)
```

**Parameters:**
- `port` (required): Port number to check

**Returns:**
- PID to stdout if found
- Nothing if not found
- Exit code 0 if found, 1 if not found, 6 if no tool available

**Example:**
```zsh
# Find what's on port 8080
pid=$(process-find-by-port 8080)

if [[ -n "$pid" ]]; then
    log-info "Port 8080 in use by PID $pid"
    process-get-info "$pid"
else
    log-info "Port 8080 is free"
fi

# Kill process on port
pid=$(process-find-by-port 3000)
[[ -n "$pid" ]] && process-stop "$pid" --force
```

**Notes:**
- Tries `lsof`, `ss`, `netstat` in order
- Returns exit code 6 if no suitable tool found
- Returns first matching process
- Useful for port conflict resolution

---

### PID File Management

#### process-write-pid

Write PID to file.

**Signature:**
```zsh
process-write-pid <name> <pid>
```

**Parameters:**
- `name` (required): Service/process name
- `pid` (required): Process ID to write

**Returns:**
- Exit code 0 on success
- Exit code 1 on failure

**Example:**
```zsh
# Start service and track PID
my_service &
local pid=$!

process-write-pid "my_service" "$pid"
log-info "Service started: $pid"

# Track multiple services
start_services() {
    redis-server &
    process-write-pid "redis" $!

    postgres -D /data &
    process-write-pid "postgres" $!
}
```

**Notes:**
- Creates PID file at `$PROCESS_PID_DIR/<name>.pid`
- Overwrites existing file
- Validates PID format
- Parent directory created automatically

---

#### process-read-pid

Read PID from file.

**Signature:**
```zsh
pid=$(process-read-pid <name>)
```

**Parameters:**
- `name` (required): Service/process name

**Returns:**
- PID to stdout if found
- Nothing if file doesn't exist
- Exit code 0 if found, 1 otherwise

**Example:**
```zsh
# Read PID
pid=$(process-read-pid "my_service")

if [[ -n "$pid" ]]; then
    echo "Service PID: $pid"
else
    echo "Service not running"
fi

# Stop service by name
stop_service() {
    local name="${1}"
    local pid=$(process-read-pid "$name")

    [[ -z "$pid" ]] && return 1

    process-stop "$pid"
    process-remove-pid "$name"
}
```

**Notes:**
- Reads from `$PROCESS_PID_DIR/<name>.pid`
- Returns empty string if file missing
- Does not validate if process exists

---

#### process-remove-pid

Remove PID file.

**Signature:**
```zsh
process-remove-pid <name>
```

**Parameters:**
- `name` (required): Service/process name

**Returns:**
- Exit code 0 (always succeeds)

**Example:**
```zsh
# Cleanup after stop
process-stop "my_service"
process-remove-pid "my_service"

# Cleanup handler
cleanup() {
    process-remove-pid "my_service"
    process-remove-pid "helper_service"
}
trap cleanup EXIT
```

**Notes:**
- Safe to call even if file doesn't exist
- Removes `$PROCESS_PID_DIR/<name>.pid`
- Use after process termination

---

#### process-check-pid-file

Check if PID file exists and process is running.

**Signature:**
```zsh
process-check-pid-file <name>
```

**Parameters:**
- `name` (required): Service/process name

**Returns:**
- Exit code 0 if PID file exists and process running
- Exit code 1 otherwise

**Example:**
```zsh
# Check if service is running
if process-check-pid-file "my_service"; then
    echo "Service is running"
else
    echo "Service is not running"
fi

# Prevent duplicate starts
start_service() {
    if process-check-pid-file "my_service"; then
        log-info "Service already running"
        return 0
    fi

    # Start service...
}

# Status check
service_status() {
    local name="${1}"

    if process-check-pid-file "$name"; then
        local pid=$(process-read-pid "$name")
        log-success "$name is running (PID: $pid)"
    else
        log-warn "$name is not running"
    fi
}
```

**Notes:**
- Validates both file existence and process liveness
- Removes stale PID files automatically
- Best for service status checks

---

### Process Information

#### process-get-cpu

Get process CPU usage percentage.

**Signature:**
```zsh
cpu=$(process-get-cpu <pid>)
```

**Parameters:**
- `pid` (required): Process ID

**Returns:**
- CPU percentage to stdout (float)
- "0" if process not found

**Example:**
```zsh
# Get CPU usage
cpu=$(process-get-cpu 1234)
echo "CPU usage: $cpu%"

# Monitor CPU
while true; do
    cpu=$(process-get-cpu "$pid")
    echo "$(date): CPU $cpu%"
    sleep 5
done

# Alert on high CPU
cpu=$(process-get-cpu "$pid")
if (( $(echo "$cpu > 80" | bc -l) )); then
    log-error "High CPU usage: $cpu%"
fi
```

**Notes:**
- Returns instantaneous CPU usage
- Cached if _cache available (TTL: 2s)
- Returns "0" for non-existent processes

---

#### process-get-memory

Get process memory usage in kilobytes.

**Signature:**
```zsh
mem=$(process-get-memory <pid>)
```

**Parameters:**
- `pid` (required): Process ID

**Returns:**
- Memory in KB to stdout (integer)
- "0" if process not found

**Example:**
```zsh
# Get memory usage
mem=$(process-get-memory 1234)
echo "Memory: $mem KB ($((mem / 1024)) MB)"

# Monitor memory
while true; do
    mem=$(process-get-memory "$pid")
    mem_mb=$((mem / 1024))
    echo "$(date): Memory ${mem_mb} MB"
    sleep 5
done

# Alert on memory leak
mem=$(process-get-memory "$pid")
if (( mem > 1048576 )); then  # 1 GB
    log-error "High memory usage: $((mem / 1024)) MB"
fi
```

**Notes:**
- Returns RSS (Resident Set Size)
- Cached if _cache available (TTL: 2s)
- Returns "0" for non-existent processes

---

#### process-get-command

Get process command name.

**Signature:**
```zsh
cmd=$(process-get-command <pid>)
```

**Parameters:**
- `pid` (required): Process ID

**Returns:**
- Command name to stdout
- Nothing if process not found

**Example:**
```zsh
# Get command name
cmd=$(process-get-command 1234)
echo "Command: $cmd"

# List all tracked processes
for pid in "${tracked_pids[@]}"; do
    cmd=$(process-get-command "$pid")
    echo "PID $pid: $cmd"
done

# Verify process identity
expected="nginx"
actual=$(process-get-command "$pid")
if [[ "$actual" == "$expected" ]]; then
    echo "Correct process"
fi
```

**Notes:**
- Returns command name only (not full path)
- Use `ps -p $pid -o args=` for full command line

---

#### process-get-info

Print comprehensive process information.

**Signature:**
```zsh
process-get-info <pid>
```

**Parameters:**
- `pid` (required): Process ID

**Returns:**
- Exit code 0 if process exists
- Exit code 1 if process not found
- Formatted info to stdout

**Example:**
```zsh
# Display process info
process-get-info 1234
# Output:
# PID:         1234
# CPU:         2.5%
# Memory:      45678 KB
# Command:     nginx
# Start Time:  Mon Nov  4 10:30:15 2025

# Info for all services
for service in "${services[@]}"; do
    pid=$(process-read-pid "$service")
    echo "=== $service ==="
    process-get-info "$pid"
    echo ""
done
```

**Notes:**
- Comprehensive summary format
- Includes CPU, memory, command, start time
- Human-readable output

---

### Process Control

#### process-stop

Stop process gracefully with timeout and optional force.

**Signature:**
```zsh
process-stop <name_or_pid> [--timeout <seconds>] [--force]
```

**Parameters:**
- `name_or_pid` (required): Service name or PID
- `--timeout <seconds>` (optional): Graceful shutdown timeout (default: 10)
- `--force` (optional): Force kill (SIGKILL) if timeout exceeded

**Returns:**
- Exit code 0 on success
- Exit code 1 on failure

**Example:**
```zsh
# Stop by PID
process-stop 1234

# Stop by name (uses PID file)
process-stop "my_service"

# Custom timeout
process-stop "my_service" --timeout 30

# Force kill after timeout
process-stop "my_service" --timeout 10 --force

# Graceful then force
stop_service() {
    local name="${1}"

    if process-stop "$name" --timeout 30; then
        log-success "Stopped gracefully"
    elif process-stop "$name" --force; then
        log-warn "Force stopped"
    else
        log-error "Failed to stop"
    fi
}
```

**Notes:**
- Sends SIGTERM for graceful shutdown
- Waits up to timeout seconds
- Sends SIGKILL if --force and still running
- Cleans up PID file automatically
- Use --force for stuck processes

---

#### process-signal

Send signal to process.

**Signature:**
```zsh
process-signal <name_or_pid> <signal>
```

**Parameters:**
- `name_or_pid` (required): Service name or PID
- `signal` (required): Signal name or number (e.g., TERM, HUP, USR1, 15)

**Returns:**
- Exit code 0 on success
- Exit code 1 on failure

**Example:**
```zsh
# Reload configuration (SIGHUP)
process-signal "nginx" "HUP"

# Graceful shutdown (SIGTERM)
process-signal 1234 "TERM"

# Force kill (SIGKILL)
process-signal 1234 "KILL"

# Custom signal (SIGUSR1)
process-signal "my_service" "USR1"

# Signal handler communication
notify_service() {
    local service="${1}"
    local event="${2}"

    case "$event" in
        reload) process-signal "$service" "HUP" ;;
        pause)  process-signal "$service" "STOP" ;;
        resume) process-signal "$service" "CONT" ;;
        status) process-signal "$service" "USR1" ;;
    esac
}
```

**Notes:**
- Accepts signal name (TERM, HUP) or number (15, 1)
- Does not wait for process to respond
- Use for custom signal handling
- Common signals: TERM (15), HUP (1), KILL (9), USR1 (10), USR2 (12)

---

#### process-restart

Restart process (stop then start).

**Signature:**
```zsh
process-restart <name> <command>
```

**Parameters:**
- `name` (required): Service name
- `command` (required): Command to execute

**Returns:**
- New PID to stdout
- Exit code 0 on success

**Example:**
```zsh
# Restart service
new_pid=$(process-restart "my_service" "python server.py")
echo "Restarted with PID: $new_pid"

# Restart with full command
process-restart "web_server" "nginx -g 'daemon off;'"

# Restart all services
restart_all() {
    process-restart "api" "./api-server --port 8080"
    process-restart "worker" "./worker --queue default"
    process-restart "scheduler" "./scheduler --interval 60"
}
```

**Notes:**
- Stops existing process (force if necessary)
- Waits 1 second between stop and start
- Starts command in background
- Logs to `$PROCESS_LOG_DIR/<name>.log`
- Registers in process registry
- Emits restart event

---

### Process Monitoring

#### process-monitor

Monitor process resources with alerts.

**Signature:**
```zsh
process-monitor <name_or_pid> [--alert-cpu <percent>] [--alert-mem <kb>] [--interval <seconds>]
```

**Parameters:**
- `name_or_pid` (required): Service name or PID
- `--alert-cpu <percent>` (optional): Alert threshold for CPU usage
- `--alert-mem <kb>` (optional): Alert threshold for memory usage (KB)
- `--interval <seconds>` (optional): Check interval (default: 5)

**Returns:**
- Exit code 0 when process exits
- Exit code 1 if process not found

**Example:**
```zsh
# Basic monitoring
process-monitor "my_service" &

# With CPU alert
process-monitor "my_service" --alert-cpu 80 &

# With memory alert
process-monitor "my_service" --alert-mem 1048576 &  # 1 GB

# With both alerts
process-monitor "my_service" \
    --alert-cpu 75.0 \
    --alert-mem 524288 \
    --interval 10 &

# Monitor and react
process-monitor "my_service" --alert-cpu 90 &
events-on "$PROCESS_EVENT_ALERT" 'handle_alert'

handle_alert() {
    local service="${1}"
    local metric="${3}"
    local value="${4}"

    if [[ "$metric" == "cpu" ]]; then
        log-error "High CPU: $value%"
        # Restart or scale out
    fi
}
```

**Notes:**
- Runs in foreground (use `&` for background)
- Emits events: monitor, alert, died
- Exits when process terminates
- Alerts triggered when thresholds exceeded

---

### Process Groups

#### process-group-add

Add process to named group.

**Signature:**
```zsh
process-group-add <group> <name_or_pid>
```

**Parameters:**
- `group` (required): Group name
- `name_or_pid` (required): Service name or PID

**Returns:**
- Exit code 0 on success
- Exit code 1 on failure

**Example:**
```zsh
# Create application group
process-group-add "webapp" "nginx"
process-group-add "webapp" "app_server"
process-group-add "webapp" "redis"

# Add by PID
pid=$(process-find-by-name "worker")
process-group-add "workers" "$pid"

# Group related services
start_microservices() {
    for service in api gateway auth users; do
        eval "./${service}-server" &
        process-write-pid "$service" $!
        process-group-add "microservices" "$service"
    done
}
```

**Notes:**
- Groups allow coordinated control
- Process can be in multiple groups
- Use for related processes
- Cleanup with `process-group-stop`

---

#### process-group-stop

Stop all processes in group.

**Signature:**
```zsh
process-group-stop <group> [--timeout <seconds>] [--force]
```

**Parameters:**
- `group` (required): Group name
- `--timeout <seconds>` (optional): Graceful shutdown timeout
- `--force` (optional): Force kill if timeout exceeded

**Returns:**
- Exit code 0 on success
- Exit code 1 if group empty/not found

**Example:**
```zsh
# Stop entire application
process-group-stop "webapp"

# With timeout and force
process-group-stop "webapp" --timeout 30 --force

# Graceful shutdown sequence
shutdown_application() {
    log-info "Shutting down application"

    # Stop in order
    process-group-stop "workers" --timeout 60
    process-group-stop "api_servers" --timeout 30
    process-group-stop "databases" --timeout 120 --force

    log-success "Shutdown complete"
}
```

**Notes:**
- Stops all processes in group
- Removes group after stop
- Respects timeout and force options
- Useful for coordinated shutdown

---

#### process-group-list

List processes in group.

**Signature:**
```zsh
process-group-list <group>
```

**Parameters:**
- `group` (required): Group name

**Returns:**
- Exit code 0 if group exists
- Exit code 1 if group empty/not found
- Process list to stdout

**Example:**
```zsh
# List group members
process-group-list "webapp"
# Output:
# Processes in group webapp:
#   PID 1234: nginx
#   PID 1235: python
#   PID 1236: redis-server

# Check group status
check_group_health() {
    local group="${1}"

    process-group-list "$group" | while read -r line; do
        if [[ "$line" =~ "PID ([0-9]+)" ]]; then
            local pid="${match[1]}"
            local cpu=$(process-get-cpu "$pid")
            local mem=$(process-get-memory "$pid")
            echo "$line - CPU: $cpu%, Mem: $mem KB"
        fi
    done
}
```

**Notes:**
- Shows PIDs and commands
- Indicates dead processes
- Useful for status checking

---

### Process Tree Operations

#### process-get-children

Get child process IDs.

**Signature:**
```zsh
children=($(process-get-children <pid>))
```

**Parameters:**
- `pid` (required): Parent process ID

**Returns:**
- Child PIDs to stdout (one per line)
- Nothing if no children

**Example:**
```zsh
# Get children
children=($(process-get-children 1234))

echo "Process 1234 has ${#children[@]} children"
for child in "${children[@]}"; do
    echo "  Child PID: $child"
done

# Recursive tree walk
walk_tree() {
    local pid="${1}"
    local indent="${2:-0}"

    printf "%${indent}sPID %s: %s\n" "" "$pid" "$(process-get-command $pid)"

    for child in $(process-get-children "$pid"); do
        walk_tree "$child" $((indent + 2))
    done
}
```

**Notes:**
- Returns immediate children only
- Use recursively for full tree
- Uses `pgrep -P`

---

#### process-kill-tree

Kill process and all descendants.

**Signature:**
```zsh
process-kill-tree <pid> [--signal <signal>]
```

**Parameters:**
- `pid` (required): Root process ID
- `--signal <signal>` (optional): Signal to send (default: TERM)

**Returns:**
- Exit code 0 on success

**Example:**
```zsh
# Kill process tree
process-kill-tree 1234

# Kill tree with SIGKILL
process-kill-tree 1234 --signal KILL

# Graceful tree shutdown
graceful_tree_stop() {
    local pid="${1}"

    # Try SIGTERM first
    process-kill-tree "$pid" --signal TERM
    sleep 5

    # Force if still running
    if process-exists "$pid"; then
        process-kill-tree "$pid" --signal KILL
    fi
}
```

**Notes:**
- Recursively kills all descendants
- Kills children before parent
- Use with caution (kills entire tree)
- Useful for process groups spawned from parent

---

### Utility Functions

#### process-list

List all tracked processes.

**Signature:**
```zsh
process-list
```

**Returns:**
- Process list to stdout

**Example:**
```zsh
# Show tracked processes
process-list
# Output:
# Tracked processes:
#   [1234] nginx: nginx -g daemon off
#   [1235] api: python server.py
#   [1236] worker: ruby worker.rb

# Count tracked processes
count=$(process-list | grep -c '^\[')
echo "Tracking $count processes"
```

**Notes:**
- Shows internal process registry
- Includes PID, name, command
- Only shows processes tracked via this library

---

#### process-cleanup

Cleanup dead processes from registry.

**Signature:**
```zsh
process-cleanup
```

**Returns:**
- Exit code 0
- Cleanup count to logs

**Example:**
```zsh
# Periodic cleanup
while true; do
    process-cleanup
    sleep 3600
done

# Cleanup on exit
trap process-cleanup EXIT

# Manual cleanup
process-cleanup
log-info "Registry cleaned"
```

**Notes:**
- Removes stale PID files
- Cleans internal registry
- Safe to call anytime
- Automatic when possible

---

#### process-version

Print version information.

**Signature:**
```zsh
process-version
```

**Returns:**
- Version string to stdout

**Example:**
```zsh
process-version
# Output: _process v1.0.0
```

---

#### process-self-test

Run comprehensive self-test suite.

**Signature:**
```zsh
process-self-test
```

**Returns:**
- Exit code 0 if all tests pass
- Exit code 1 if any test fails
- Test results to stdout

**Example:**
```zsh
# Run tests
process-self-test

# Output:
# === _process v1.0.0 Self-Test ===
# Test 1: ps availability... PASS
# Test 2: kill availability... PASS
# Test 3: Process detection... PASS (current PID: 12345)
# Test 4: Get CPU usage... PASS (CPU: 0.5%)
# Test 5: Get memory usage... PASS (Memory: 8456 KB)
# Test 6: Get command... PASS (Command: zsh)
# Test 7: PID file operations... PASS
# Test 8: Process group operations... PASS
#
# === Self-Test Summary ===
# Passed: 8
# Failed: 0
# All tests passed!
```

**Notes:**
- Validates installation
- Tests core functionality
- Run after installation or updates

---

## Events

The `_process` extension emits events when `_events` is available, enabling monitoring, alerting, and integration with other systems.

### Event Constants

```zsh
PROCESS_EVENT_START="process.start"        # Process started
PROCESS_EVENT_STOP="process.stop"          # Process stopped
PROCESS_EVENT_KILL="process.kill"          # Process killed
PROCESS_EVENT_RESTART="process.restart"    # Process restarted
PROCESS_EVENT_DIED="process.died"          # Process died unexpectedly
PROCESS_EVENT_MONITOR="process.monitor"    # Monitoring check
PROCESS_EVENT_ALERT="process.alert"        # Alert threshold exceeded
```

### Event Emission

Events are emitted automatically when `_events` is loaded:

```zsh
# Check if events available
if [[ "$PROCESS_EVENTS_AVAILABLE" == "true" ]]; then
    echo "Event emission enabled"
fi
```

### Event Handlers

#### process.stop Event

Emitted when process is stopped gracefully.

**Payload:**
- `service`: Service name or PID
- `pid`: Process ID

**Example:**
```zsh
source "$(which _events)"

events-on "$PROCESS_EVENT_STOP" 'handle_stop'

handle_stop() {
    local service="${1}"
    local pid="${2}"

    log-info "Process stopped: $service (PID: $pid)"
    # Log to monitoring system
    # Update status dashboard
}
```

---

#### process.kill Event

Emitted when process is force-killed (SIGKILL).

**Payload:**
- `service`: Service name or PID
- `pid`: Process ID

**Example:**
```zsh
events-on "$PROCESS_EVENT_KILL" 'handle_kill'

handle_kill() {
    local service="${1}"
    local pid="${2}"

    log-warn "Process force-killed: $service (PID: $pid)"
    # Send alert
    # Investigate why graceful shutdown failed
}
```

---

#### process.restart Event

Emitted when process is restarted.

**Payload:**
- `service`: Service name
- `new_pid`: New process ID

**Example:**
```zsh
events-on "$PROCESS_EVENT_RESTART" 'handle_restart'

handle_restart() {
    local service="${1}"
    local new_pid="${2}"

    log-info "Process restarted: $service (new PID: $new_pid)"
    # Update load balancer
    # Notify dependent services
}
```

---

#### process.died Event

Emitted when monitored process dies.

**Payload:**
- `service`: Service name or PID
- `pid`: Process ID

**Example:**
```zsh
events-on "$PROCESS_EVENT_DIED" 'handle_died'

handle_died() {
    local service="${1}"
    local pid="${2}"

    log-error "Process died unexpectedly: $service (PID: $pid)"

    # Attempt restart
    if [[ "$service" == "critical_service" ]]; then
        process-restart "$service" "./start-critical-service.sh"
    fi
}
```

---

#### process.monitor Event

Emitted periodically during monitoring.

**Payload:**
- `service`: Service name or PID
- `pid`: Process ID
- `cpu`: CPU usage percentage
- `memory`: Memory usage in KB

**Example:**
```zsh
events-on "$PROCESS_EVENT_MONITOR" 'handle_monitor'

handle_monitor() {
    local service="${1}"
    local pid="${2}"
    local cpu="${3}"
    local mem="${4}"

    # Log to time-series database
    influxdb_write "process_metrics" \
        "service=$service,pid=$pid" \
        "cpu=$cpu,memory=$mem"
}
```

---

#### process.alert Event

Emitted when resource threshold exceeded.

**Payload:**
- `service`: Service name or PID
- `pid`: Process ID
- `metric`: Metric name (cpu, memory)
- `value`: Current value

**Example:**
```zsh
events-on "$PROCESS_EVENT_ALERT" 'handle_alert'

handle_alert() {
    local service="${1}"
    local pid="${2}"
    local metric="${3}"
    local value="${4}"

    log-error "ALERT: $service - $metric=$value"

    case "$metric" in
        cpu)
            # CPU alert
            if (( $(echo "$value > 90" | bc -l) )); then
                # Critical CPU usage
                notify-send "Critical CPU" "$service: $value%"
            fi
            ;;
        memory)
            # Memory alert
            if (( value > 2097152 )); then  # 2 GB
                # High memory usage
                notify-send "High Memory" "$service: $((value / 1024)) MB"
            fi
            ;;
    esac
}
```

---

### Event Integration Example

Complete monitoring system with event handlers:

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _events)"
source "$(which _log)"

# Configure event handlers
setup_event_handlers() {
    events-on "$PROCESS_EVENT_ALERT" 'handle_resource_alert'
    events-on "$PROCESS_EVENT_DIED" 'handle_process_died'
    events-on "$PROCESS_EVENT_RESTART" 'log_restart'
}

handle_resource_alert() {
    local service="${1}"
    local pid="${2}"
    local metric="${3}"
    local value="${4}"

    log-error "ALERT: $service - $metric threshold exceeded: $value"

    # Send notification
    notify-send "Process Alert" "$service: $metric=$value" --urgency=critical

    # Log to monitoring
    echo "$(date -Iseconds)|$service|$metric|$value" >> /var/log/process-alerts.log
}

handle_process_died() {
    local service="${1}"
    local pid="${2}"

    log-error "Process died: $service (PID: $pid)"

    # Auto-restart critical services
    if [[ "$service" == "critical_"* ]]; then
        log-info "Auto-restarting critical service: $service"
        # Implement restart logic
    fi
}

log_restart() {
    local service="${1}"
    local new_pid="${2}"

    log-info "Service restarted: $service (PID: $new_pid)"
}

# Start monitoring
monitor_services() {
    local -a services=(api worker scheduler)

    for service in "${services[@]}"; do
        process-monitor "$service" \
            --alert-cpu 80 \
            --alert-mem 1048576 \
            --interval 10 &
    done

    wait
}

setup_event_handlers
monitor_services
```

---

## Examples

### Example 1: Service Manager with PID Files

Complete service management system with start, stop, restart, and status commands.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"

# Service configuration
SERVICE_NAME="myapp"
SERVICE_CMD="python3 /opt/myapp/server.py --port 8080"
SERVICE_USER="myapp"

# Service directory structure
SERVICE_HOME="/opt/myapp"
SERVICE_LOGS="/var/log/myapp"

# Initialize directories
init_service() {
    mkdir -p "$SERVICE_LOGS"
    mkdir -p "$(dirname $(_process-get-pid-file "$SERVICE_NAME"))"

    log-info "Service directories initialized"
}

# Start service
service_start() {
    log-info "Starting $SERVICE_NAME"

    # Check if already running
    if process-check-pid-file "$SERVICE_NAME"; then
        local pid=$(process-read-pid "$SERVICE_NAME")
        log-info "Service already running (PID: $pid)"
        return 0
    fi

    # Start service
    cd "$SERVICE_HOME"

    if [[ "$(whoami)" == "root" ]] && [[ -n "$SERVICE_USER" ]]; then
        # Start as different user
        su - "$SERVICE_USER" -c "$SERVICE_CMD" \
            >> "$SERVICE_LOGS/stdout.log" 2>> "$SERVICE_LOGS/stderr.log" &
    else
        # Start as current user
        eval "$SERVICE_CMD" \
            >> "$SERVICE_LOGS/stdout.log" 2>> "$SERVICE_LOGS/stderr.log" &
    fi

    local pid=$!

    # Verify process started
    sleep 2
    if ! process-exists "$pid"; then
        log-error "Failed to start service"
        return 1
    fi

    # Track PID
    process-write-pid "$SERVICE_NAME" "$pid"

    log-success "Service started (PID: $pid)"
    return 0
}

# Stop service
service_stop() {
    log-info "Stopping $SERVICE_NAME"

    if ! process-check-pid-file "$SERVICE_NAME"; then
        log-warn "Service not running"
        return 0
    fi

    local pid=$(process-read-pid "$SERVICE_NAME")

    # Graceful shutdown
    if process-stop "$SERVICE_NAME" --timeout 30 --force; then
        log-success "Service stopped"
        process-remove-pid "$SERVICE_NAME"
        return 0
    else
        log-error "Failed to stop service"
        return 1
    fi
}

# Restart service
service_restart() {
    log-info "Restarting $SERVICE_NAME"

    service_stop
    sleep 2
    service_start
}

# Service status
service_status() {
    if process-check-pid-file "$SERVICE_NAME"; then
        local pid=$(process-read-pid "$SERVICE_NAME")

        log-success "$SERVICE_NAME is running"
        echo ""
        process-get-info "$pid"
        echo ""

        # Check health endpoint (if applicable)
        if command -v curl >/dev/null; then
            if curl -sf http://localhost:8080/health > /dev/null; then
                log-success "Health check: OK"
            else
                log-warn "Health check: FAILED"
            fi
        fi
    else
        log-warn "$SERVICE_NAME is not running"
        return 1
    fi
}

# Reload configuration
service_reload() {
    log-info "Reloading $SERVICE_NAME configuration"

    if ! process-check-pid-file "$SERVICE_NAME"; then
        log-error "Service not running"
        return 1
    fi

    # Send SIGHUP to reload
    if process-signal "$SERVICE_NAME" "HUP"; then
        log-success "Configuration reloaded"
    else
        log-error "Failed to reload configuration"
        return 1
    fi
}

# Service logs
service_logs() {
    local lines="${1:-50}"

    if [[ -f "$SERVICE_LOGS/stdout.log" ]]; then
        echo "=== stdout ==="
        tail -n "$lines" "$SERVICE_LOGS/stdout.log"
    fi

    if [[ -f "$SERVICE_LOGS/stderr.log" ]]; then
        echo ""
        echo "=== stderr ==="
        tail -n "$lines" "$SERVICE_LOGS/stderr.log"
    fi
}

# Main command dispatcher
main() {
    case "${1:-}" in
        start)
            init_service
            service_start
            ;;
        stop)
            service_stop
            ;;
        restart)
            service_restart
            ;;
        status)
            service_status
            ;;
        reload)
            service_reload
            ;;
        logs)
            service_logs "${2:-50}"
            ;;
        *)
            echo "Usage: $0 {start|stop|restart|status|reload|logs}"
            echo ""
            echo "Commands:"
            echo "  start     Start the service"
            echo "  stop      Stop the service"
            echo "  restart   Restart the service"
            echo "  status    Show service status"
            echo "  reload    Reload configuration (SIGHUP)"
            echo "  logs [N]  Show last N lines of logs (default: 50)"
            return 1
            ;;
    esac
}

main "$@"
```

**Usage:**
```zsh
# Start service
sudo ./service-manager start

# Check status
./service-manager status

# Restart
sudo ./service-manager restart

# View logs
./service-manager logs 100

# Stop
sudo ./service-manager stop
```

---

### Example 2: Process Health Monitor with Alerts

Production monitoring system with threshold alerts and automatic recovery.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"
source "$(which _events)"

# Monitoring configuration
MONITOR_INTERVAL=10
CPU_THRESHOLD=80.0
MEM_THRESHOLD=1048576  # 1 GB in KB

# Alert tracking
declare -A ALERT_COUNTS=()
ALERT_COOLDOWN=300  # 5 minutes
declare -A LAST_ALERT_TIME=()

# Initialize monitoring
init_monitoring() {
    # Setup event handlers
    events-on "$PROCESS_EVENT_ALERT" 'handle_alert'
    events-on "$PROCESS_EVENT_DIED" 'handle_process_died'

    log-info "Monitoring system initialized"
}

# Monitor single service
monitor_service() {
    local service_name="${1}"

    if ! process-check-pid-file "$service_name"; then
        log-error "Service not running: $service_name"
        return 1
    fi

    log-info "Starting monitoring: $service_name"

    process-monitor "$service_name" \
        --alert-cpu "$CPU_THRESHOLD" \
        --alert-mem "$MEM_THRESHOLD" \
        --interval "$MONITOR_INTERVAL"
}

# Handle resource alerts
handle_alert() {
    local service="${1}"
    local pid="${2}"
    local metric="${3}"
    local value="${4}"

    # Check cooldown
    local now=$(date +%s)
    local last_alert=${LAST_ALERT_TIME[$service]:=0}

    if (( now - last_alert < ALERT_COOLDOWN )); then
        log-debug "Alert suppressed (cooldown): $service"
        return 0
    fi

    # Update alert tracking
    ALERT_COUNTS[$service]=$((${ALERT_COUNTS[$service]:=0} + 1))
    LAST_ALERT_TIME[$service]=$now

    local count=${ALERT_COUNTS[$service]}

    log-error "ALERT [$count]: $service - $metric=$value (PID: $pid)"

    # Send notification
    send_alert "$service" "$metric" "$value" "$count"

    # Take action based on severity
    if (( count >= 3 )); then
        log-error "Multiple alerts for $service - taking action"
        handle_critical_alert "$service" "$metric"
    fi
}

# Send alert notification
send_alert() {
    local service="${1}"
    local metric="${2}"
    local value="${3}"
    local count="${4}"

    # Desktop notification
    if command -v notify-send >/dev/null; then
        notify-send "Process Alert" \
            "$service: $metric=$value (alert #$count)" \
            --urgency=critical
    fi

    # Log to file
    echo "$(date -Iseconds)|$service|$metric|$value|$count" \
        >> /var/log/process-alerts.log

    # Could also:
    # - Send email
    # - Post to Slack/Discord
    # - Update monitoring dashboard
    # - Trigger PagerDuty
}

# Handle critical alerts
handle_critical_alert() {
    local service="${1}"
    local metric="${2}"

    log-warn "Critical alert for $service - attempting recovery"

    case "$metric" in
        cpu)
            # High CPU - restart service
            log-info "Restarting service due to high CPU"
            restart_service "$service"
            ;;
        memory)
            # High memory - restart or scale
            log-info "Restarting service due to high memory"
            restart_service "$service"
            ;;
    esac
}

# Handle process death
handle_process_died() {
    local service="${1}"
    local pid="${2}"

    log-error "Process died: $service (PID: $pid)"

    # Reset alert count
    ALERT_COUNTS[$service]=0
    LAST_ALERT_TIME[$service]=0

    # Attempt restart
    log-info "Attempting automatic restart: $service"
    restart_service "$service"
}

# Restart service (implement based on your service manager)
restart_service() {
    local service="${1}"

    log-info "Restarting service: $service"

    # Call your service manager
    systemctl restart "$service" 2>/dev/null || \
    service "$service" restart 2>/dev/null || \
    /path/to/service-manager restart "$service"

    if [[ $? -eq 0 ]]; then
        log-success "Service restarted: $service"
    else
        log-error "Failed to restart service: $service"
    fi
}

# Monitor multiple services
monitor_all() {
    local -a services=("$@")

    if [[ ${#services[@]} -eq 0 ]]; then
        log-error "No services specified"
        return 1
    fi

    log-info "Monitoring ${#services[@]} services"

    # Start monitoring each service in background
    for service in "${services[@]}"; do
        monitor_service "$service" &
    done

    # Wait for all monitors
    wait
}

# Status report
status_report() {
    echo "=== Process Monitoring Status ==="
    echo ""
    echo "Alert Counts:"

    if [[ ${#ALERT_COUNTS[@]} -eq 0 ]]; then
        echo "  No alerts"
    else
        for service in "${(@k)ALERT_COUNTS}"; do
            echo "  $service: ${ALERT_COUNTS[$service]} alerts"
        done
    fi

    echo ""
    echo "Monitored Services:"

    for service in "$@"; do
        if process-check-pid-file "$service"; then
            local pid=$(process-read-pid "$service")
            local cpu=$(process-get-cpu "$pid")
            local mem=$(process-get-memory "$pid")
            local mem_mb=$((mem / 1024))

            printf "  %-20s PID: %-6s CPU: %5s%%  Mem: %5s MB\n" \
                "$service" "$pid" "$cpu" "$mem_mb"
        else
            printf "  %-20s NOT RUNNING\n" "$service"
        fi
    done
}

# Main
main() {
    case "${1:-}" in
        monitor)
            shift
            init_monitoring
            monitor_all "$@"
            ;;
        status)
            shift
            status_report "$@"
            ;;
        *)
            echo "Usage: $0 {monitor|status} <services...>"
            echo ""
            echo "Commands:"
            echo "  monitor <services...>  Monitor services with alerts"
            echo "  status <services...>   Show monitoring status"
            echo ""
            echo "Example:"
            echo "  $0 monitor nginx postgres redis"
            return 1
            ;;
    esac
}

main "$@"
```

**Usage:**
```zsh
# Monitor multiple services
./health-monitor monitor nginx postgres redis

# Check status
./health-monitor status nginx postgres redis
```

---

### Example 3: Graceful Shutdown Handler

Coordinated shutdown with cleanup and state persistence.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"

# Application state
APP_NAME="myapp"
SHUTDOWN_INITIATED=false

# Initialize application
init_app() {
    log-info "Initializing $APP_NAME"

    # Setup signal handlers
    trap 'graceful_shutdown' SIGTERM SIGINT

    # Register cleanup
    trap 'cleanup' EXIT

    # Write PID file
    process-write-pid "$APP_NAME" $$

    log-success "Application initialized (PID: $$)"
}

# Graceful shutdown handler
graceful_shutdown() {
    if $SHUTDOWN_INITIATED; then
        log-warn "Shutdown already in progress"
        return 0
    fi

    SHUTDOWN_INITIATED=true

    log-info "=== Graceful Shutdown Initiated ==="

    # Step 1: Stop accepting new work
    log-info "Step 1: Stopping new work acceptance"
    stop_accepting_work
    sleep 2

    # Step 2: Wait for in-flight work to complete
    log-info "Step 2: Waiting for in-flight work"
    wait_for_work_completion 30

    # Step 3: Save application state
    log-info "Step 3: Saving application state"
    save_application_state

    # Step 4: Close connections
    log-info "Step 4: Closing connections"
    close_connections

    # Step 5: Stop worker processes
    log-info "Step 5: Stopping workers"
    stop_workers

    # Step 6: Final cleanup
    log-info "Step 6: Final cleanup"
    cleanup

    log-success "=== Graceful Shutdown Complete ==="
    exit 0
}

# Stop accepting new work
stop_accepting_work() {
    # Set flag file
    touch "/tmp/${APP_NAME}.shutting_down"

    # Notify load balancer (if applicable)
    if command -v curl >/dev/null; then
        curl -X POST http://loadbalancer/remove/$(hostname) 2>/dev/null
    fi

    log-info "No longer accepting new work"
}

# Wait for work to complete
wait_for_work_completion() {
    local timeout="${1:-30}"
    local elapsed=0

    log-info "Waiting up to ${timeout}s for work completion"

    while (( elapsed < timeout )); do
        # Check if work queue is empty
        local work_count=$(get_work_count)

        if (( work_count == 0 )); then
            log-success "All work completed"
            return 0
        fi

        log-debug "Waiting... ($work_count jobs remaining)"
        sleep 1
        ((elapsed++))
    done

    log-warn "Timeout reached with $work_count jobs remaining"
    return 1
}

# Get current work count (implement based on your app)
get_work_count() {
    # Example: check queue length
    # redis-cli LLEN work_queue 2>/dev/null || echo 0

    # Or check active connections
    # netstat -an | grep -c ESTABLISHED

    # Placeholder
    echo 0
}

# Save application state
save_application_state() {
    local state_file="/var/lib/${APP_NAME}/state.json"

    log-info "Saving state to: $state_file"

    # Build state JSON
    cat > "$state_file" <<EOF
{
    "shutdown_time": "$(date -Iseconds)",
    "pid": $$,
    "uptime": $(( $(date +%s) - $(stat -c %Y $(_process-get-pid-file "$APP_NAME") 2>/dev/null || echo 0) )),
    "clean_shutdown": true
}
EOF

    log-success "Application state saved"
}

# Close connections
close_connections() {
    # Close database connections
    log-debug "Closing database connections"
    # db.close()

    # Close cache connections
    log-debug "Closing cache connections"
    # redis.quit()

    # Close external API connections
    log-debug "Closing API connections"
    # api.disconnect()

    log-success "Connections closed"
}

# Stop worker processes
stop_workers() {
    # Stop worker group
    if [[ -n "${_PROCESS_GROUPS[workers]}" ]]; then
        log-info "Stopping worker group"
        process-group-stop "workers" --timeout 20 --force
    fi

    # Or stop individually
    for worker in worker1 worker2 worker3; do
        if process-check-pid-file "$worker"; then
            log-debug "Stopping $worker"
            process-stop "$worker" --timeout 10 --force
        fi
    done

    log-success "Workers stopped"
}

# Cleanup
cleanup() {
    log-info "Running cleanup"

    # Remove shutdown flag
    rm -f "/tmp/${APP_NAME}.shutting_down"

    # Remove PID file
    process-remove-pid "$APP_NAME"

    # Remove temporary files
    rm -f /tmp/${APP_NAME}.*

    log-success "Cleanup complete"
}

# Application main loop
run_application() {
    log-info "Starting application main loop"

    while ! $SHUTDOWN_INITIATED; do
        # Application logic
        # process_work()

        sleep 1
    done
}

# Start workers
start_workers() {
    for i in {1..3}; do
        ./worker.sh "$i" &
        local worker_pid=$!

        process-write-pid "worker${i}" "$worker_pid"
        process-group-add "workers" "worker${i}"

        log-info "Started worker${i} (PID: $worker_pid)"
    done
}

# Main
main() {
    init_app
    start_workers
    run_application
}

main "$@"
```

---

### Example 4: Resource Usage Tracker

Track and analyze process resource consumption over time.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"

# Tracker configuration
TRACK_INTERVAL=5
TRACK_DURATION=3600  # 1 hour
OUTPUT_DIR="/var/lib/process-tracker"

# Track process resources
track_process() {
    local target="${1}"
    local duration="${2:-$TRACK_DURATION}"
    local interval="${3:-$TRACK_INTERVAL}"

    # Resolve PID
    local pid
    if [[ "$target" =~ ^[0-9]+$ ]]; then
        pid="$target"
    else
        pid=$(process-read-pid "$target")
    fi

    if [[ -z "$pid" ]] || ! process-exists "$pid"; then
        log-error "Process not found: $target"
        return 1
    fi

    local output_file="${OUTPUT_DIR}/${target}_$(date +%Y%m%d_%H%M%S).csv"
    mkdir -p "$OUTPUT_DIR"

    log-info "Tracking $target (PID: $pid) for ${duration}s"
    log-info "Output: $output_file"

    # CSV header
    echo "timestamp,elapsed,cpu,memory_kb,memory_mb" > "$output_file"

    local start_time=$(date +%s)
    local end_time=$((start_time + duration))

    while (( $(date +%s) < end_time )); do
        if ! process-exists "$pid"; then
            log-warn "Process died during tracking"
            break
        fi

        local timestamp=$(date +%s)
        local elapsed=$((timestamp - start_time))
        local cpu=$(process-get-cpu "$pid")
        local mem_kb=$(process-get-memory "$pid")
        local mem_mb=$((mem_kb / 1024))

        echo "$timestamp,$elapsed,$cpu,$mem_kb,$mem_mb" >> "$output_file"

        log-debug "[$elapsed s] CPU: $cpu%, Mem: ${mem_mb} MB"

        sleep "$interval"
    done

    log-success "Tracking complete: $output_file"

    # Generate report
    generate_report "$output_file"
}

# Generate statistics report
generate_report() {
    local data_file="${1}"

    if [[ ! -f "$data_file" ]]; then
        log-error "Data file not found: $data_file"
        return 1
    fi

    log-info "Generating statistics report"

    # Skip header, calculate stats
    local cpu_values=$(tail -n +2 "$data_file" | cut -d, -f3)
    local mem_values=$(tail -n +2 "$data_file" | cut -d, -f5)

    # Calculate averages
    local cpu_avg=$(echo "$cpu_values" | awk '{sum+=$1; n++} END {print sum/n}')
    local mem_avg=$(echo "$mem_values" | awk '{sum+=$1; n++} END {print sum/n}')

    # Calculate max
    local cpu_max=$(echo "$cpu_values" | sort -n | tail -1)
    local mem_max=$(echo "$mem_values" | sort -n | tail -1)

    # Calculate min
    local cpu_min=$(echo "$cpu_values" | sort -n | head -1)
    local mem_min=$(echo "$mem_values" | sort -n | head -1)

    # Print report
    echo ""
    echo "=== Resource Usage Report ==="
    echo "Data file: $data_file"
    echo ""
    echo "CPU Usage:"
    printf "  Average: %.2f%%\n" "$cpu_avg"
    printf "  Minimum: %.2f%%\n" "$cpu_min"
    printf "  Maximum: %.2f%%\n" "$cpu_max"
    echo ""
    echo "Memory Usage:"
    printf "  Average: %.0f MB\n" "$mem_avg"
    printf "  Minimum: %.0f MB\n" "$mem_min"
    printf "  Maximum: %.0f MB\n" "$mem_max"
    echo ""

    # Save report
    local report_file="${data_file%.csv}_report.txt"
    {
        echo "=== Resource Usage Report ==="
        echo "Data file: $data_file"
        echo "Generated: $(date)"
        echo ""
        echo "CPU Usage:"
        printf "  Average: %.2f%%\n" "$cpu_avg"
        printf "  Minimum: %.2f%%\n" "$cpu_min"
        printf "  Maximum: %.2f%%\n" "$cpu_max"
        echo ""
        echo "Memory Usage:"
        printf "  Average: %.0f MB\n" "$mem_avg"
        printf "  Minimum: %.0f MB\n" "$mem_min"
        printf "  Maximum: %.0f MB\n" "$mem_max"
    } > "$report_file"

    log-success "Report saved: $report_file"
}

# Track multiple processes
track_multiple() {
    local duration="${1}"
    shift
    local -a processes=("$@")

    log-info "Tracking ${#processes[@]} processes"

    local -a pids=()
    for proc in "${processes[@]}"; do
        track_process "$proc" "$duration" &
        pids+=($!)
    done

    # Wait for all tracking to complete
    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    log-success "All tracking complete"
}

# Compare processes
compare_processes() {
    local -a data_files=("$@")

    echo "=== Process Comparison ==="
    echo ""
    printf "%-30s %10s %10s %10s\n" "Process" "Avg CPU" "Avg Mem" "Max Mem"
    printf "%-30s %10s %10s %10s\n" "--------" "-------" "-------" "-------"

    for file in "${data_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            continue
        fi

        local name=$(basename "$file" .csv)
        local cpu_avg=$(tail -n +2 "$file" | cut -d, -f3 | awk '{sum+=$1; n++} END {print sum/n}')
        local mem_avg=$(tail -n +2 "$file" | cut -d, -f5 | awk '{sum+=$1; n++} END {print sum/n}')
        local mem_max=$(tail -n +2 "$file" | cut -d, -f5 | sort -n | tail -1)

        printf "%-30s %9.2f%% %9.0f MB %9.0f MB\n" \
            "$name" "$cpu_avg" "$mem_avg" "$mem_max"
    done
}

# Main
main() {
    case "${1:-}" in
        track)
            track_process "${2}" "${3}" "${4}"
            ;;
        multi)
            shift
            local duration="${1}"
            shift
            track_multiple "$duration" "$@"
            ;;
        report)
            generate_report "${2}"
            ;;
        compare)
            shift
            compare_processes "$@"
            ;;
        *)
            echo "Usage: $0 {track|multi|report|compare} [args...]"
            echo ""
            echo "Commands:"
            echo "  track <proc> [duration] [interval]   Track single process"
            echo "  multi <duration> <proc1> [proc2...]  Track multiple processes"
            echo "  report <data_file>                   Generate statistics report"
            echo "  compare <file1> [file2...]           Compare processes"
            echo ""
            echo "Examples:"
            echo "  $0 track nginx 3600 5"
            echo "  $0 multi 1800 nginx postgres redis"
            echo "  $0 report /var/lib/process-tracker/nginx_*.csv"
            echo "  $0 compare /var/lib/process-tracker/*.csv"
            return 1
            ;;
    esac
}

main "$@"
```

---

### Example 5: Multi-Process Coordinator

Coordinate multiple related processes with dependencies.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"

# Process definitions
declare -A PROCESSES=(
    [database]="postgres -D /var/lib/postgres"
    [cache]="redis-server /etc/redis/redis.conf"
    [queue]="rabbitmq-server"
    [api]="python3 /opt/api/server.py"
    [worker]="python3 /opt/api/worker.py"
    [frontend]="nginx -c /etc/nginx/nginx.conf"
)

# Dependency graph (child => parents)
declare -A DEPENDENCIES=(
    [cache]=""
    [database]=""
    [queue]=""
    [api]="database cache"
    [worker]="database cache queue"
    [frontend]="api"
)

# Start order (topological sort result)
START_ORDER=(database cache queue api worker frontend)

# Stop order (reverse)
STOP_ORDER=(frontend worker api queue cache database)

# Start single process
start_process() {
    local name="${1}"

    if process-check-pid-file "$name"; then
        log-info "$name already running"
        return 0
    fi

    # Check dependencies
    local deps="${DEPENDENCIES[$name]}"
    for dep in $deps; do
        if ! process-check-pid-file "$dep"; then
            log-error "Dependency not running: $dep"
            return 1
        fi
    done

    log-info "Starting $name"

    # Start process
    local command="${PROCESSES[$name]}"
    eval "$command" >> "$(_process-get-log-file "$name")" 2>&1 &
    local pid=$!

    # Wait for startup
    sleep 2

    if ! process-exists "$pid"; then
        log-error "Failed to start $name"
        return 1
    fi

    # Track PID
    process-write-pid "$name" "$pid"
    process-group-add "application" "$name"

    log-success "$name started (PID: $pid)"

    # Health check (if applicable)
    health_check "$name"
}

# Stop single process
stop_process() {
    local name="${1}"

    if ! process-check-pid-file "$name"; then
        log-info "$name not running"
        return 0
    fi

    log-info "Stopping $name"

    if process-stop "$name" --timeout 30 --force; then
        log-success "$name stopped"
    else
        log-error "Failed to stop $name"
        return 1
    fi
}

# Health check
health_check() {
    local name="${1}"

    case "$name" in
        database)
            # Check PostgreSQL
            pg_isready -q && log-success "$name health: OK"
            ;;
        cache)
            # Check Redis
            redis-cli ping | grep -q PONG && log-success "$name health: OK"
            ;;
        api|frontend)
            # Check HTTP endpoint
            sleep 2
            if command -v curl >/dev/null; then
                local port=$([[ "$name" == "api" ]] && echo 8080 || echo 80)
                curl -sf http://localhost:${port}/health > /dev/null && \
                    log-success "$name health: OK"
            fi
            ;;
    esac
}

# Start all processes
start_all() {
    log-info "Starting application stack"

    for process in "${START_ORDER[@]}"; do
        if ! start_process "$process"; then
            log-error "Failed to start $process - aborting"
            stop_all
            return 1
        fi

        # Wait between starts
        sleep 1
    done

    log-success "All processes started"
    status_all
}

# Stop all processes
stop_all() {
    log-info "Stopping application stack"

    for process in "${STOP_ORDER[@]}"; do
        stop_process "$process"
    done

    log-success "All processes stopped"
}

# Restart all processes
restart_all() {
    log-info "Restarting application stack"

    stop_all
    sleep 5
    start_all
}

# Status of all processes
status_all() {
    echo "=== Application Status ==="
    echo ""

    for process in "${START_ORDER[@]}"; do
        if process-check-pid-file "$process"; then
            local pid=$(process-read-pid "$process")
            local cpu=$(process-get-cpu "$pid")
            local mem=$(process-get-memory "$pid")
            local mem_mb=$((mem / 1024))

            printf "%-12s ✓ PID: %-6s CPU: %5s%%  Mem: %5s MB\n" \
                "$process" "$pid" "$cpu" "$mem_mb"
        else
            printf "%-12s ✗ NOT RUNNING\n" "$process"
        fi
    done
}

# Start specific processes
start_selected() {
    local -a selected=("$@")

    for process in "${selected[@]}"; do
        if [[ -z "${PROCESSES[$process]}" ]]; then
            log-error "Unknown process: $process"
            continue
        fi

        start_process "$process"
    done
}

# Stop specific processes
stop_selected() {
    local -a selected=("$@")

    for process in "${selected[@]}"; do
        stop_process "$process"
    done
}

# Main
main() {
    case "${1:-}" in
        start)
            if [[ -n "${2}" ]]; then
                shift
                start_selected "$@"
            else
                start_all
            fi
            ;;
        stop)
            if [[ -n "${2}" ]]; then
                shift
                stop_selected "$@"
            else
                stop_all
            fi
            ;;
        restart)
            restart_all
            ;;
        status)
            status_all
            ;;
        *)
            echo "Usage: $0 {start|stop|restart|status} [process...]"
            echo ""
            echo "Commands:"
            echo "  start [process...]   Start all or specific processes"
            echo "  stop [process...]    Stop all or specific processes"
            echo "  restart              Restart all processes"
            echo "  status               Show status of all processes"
            echo ""
            echo "Available processes:"
            for process in "${START_ORDER[@]}"; do
                echo "  - $process"
            done
            return 1
            ;;
    esac
}

main "$@"
```

---

### Example 6: Process Supervision with Auto-Restart

Supervise critical processes with automatic restart on failure.

```zsh
#!/usr/bin/env zsh

source "$(which _process)"
source "$(which _log)"
source "$(which _events)"

# Supervision configuration
MAX_RESTART_ATTEMPTS=5
RESTART_DELAY=5
RESTART_WINDOW=300  # 5 minutes

# Supervised process tracking
declare -A RESTART_COUNTS=()
declare -A RESTART_TIMESTAMPS=()

# Supervise single process
supervise_process() {
    local name="${1}"
    local command="${2}"

    log-info "Starting supervision: $name"

    local restart_count=0
    local window_start=$(date +%s)

    while true; do
        # Reset counter if window expired
        local now=$(date +%s)
        if (( now - window_start > RESTART_WINDOW )); then
            log-debug "Restart window expired, resetting counter"
            restart_count=0
            window_start=$now
        fi

        # Check restart limit
        if (( restart_count >= MAX_RESTART_ATTEMPTS )); then
            log-error "$name failed $restart_count times - giving up"
            send_critical_alert "$name" "Max restart attempts reached"
            return 1
        fi

        # Start process
        if (( restart_count > 0 )); then
            log-info "Restarting $name (attempt $((restart_count + 1))/$MAX_RESTART_ATTEMPTS)"
        else
            log-info "Starting $name"
        fi

        # Execute command
        eval "$command" >> "$(_process-get-log-file "$name")" 2>&1 &
        local pid=$!

        # Track PID
        process-write-pid "$name" "$pid"
        RESTART_COUNTS[$name]=$restart_count
        RESTART_TIMESTAMPS[$name]=$now

        log-success "$name started (PID: $pid)"

        # Wait for process to exit
        wait "$pid"
        local exit_code=$?

        log-warn "$name exited with code $exit_code"

        # Increment restart counter
        ((restart_count++))

        # Delay before restart
        if (( restart_count < MAX_RESTART_ATTEMPTS )); then
            log-info "Waiting ${RESTART_DELAY}s before restart"
            sleep "$RESTART_DELAY"
        fi
    done
}

# Supervise multiple processes
supervise_all() {
    local -a services=("$@")

    if [[ ${#services[@]} -eq 0 ]]; then
        log-error "No services specified"
        return 1
    fi

    log-info "Supervising ${#services[@]} services"

    # Read service definitions from config
    local config_file="/etc/supervisor/services.conf"
    if [[ ! -f "$config_file" ]]; then
        log-error "Config file not found: $config_file"
        return 1
    fi

    # Start supervision for each service
    for service in "${services[@]}"; do
        local command=$(grep "^${service}=" "$config_file" | cut -d= -f2-)

        if [[ -z "$command" ]]; then
            log-error "No command defined for: $service"
            continue
        fi

        # Supervise in background
        supervise_process "$service" "$command" &
    done

    # Setup event handlers
    events-on "$PROCESS_EVENT_DIED" 'log_process_death'

    # Wait for all supervisors
    wait
}

# Log process death
log_process_death() {
    local service="${1}"
    local pid="${2}"

    local restart_count=${RESTART_COUNTS[$service]:=0}
    local last_start=${RESTART_TIMESTAMPS[$service]:=0}
    local uptime=$(($(date +%s) - last_start))

    log-warn "Process death: $service (PID: $pid, uptime: ${uptime}s, restarts: $restart_count)"

    # Log to file
    echo "$(date -Iseconds)|$service|$pid|$exit_code|$uptime|$restart_count" \
        >> /var/log/supervisor/deaths.log
}

# Send critical alert
send_critical_alert() {
    local service="${1}"
    local message="${2}"

    log-error "CRITICAL: $service - $message"

    # Desktop notification
    if command -v notify-send >/dev/null; then
        notify-send "Process Supervision" \
            "$service: $message" \
            --urgency=critical
    fi

    # Could also:
    # - Send email
    # - Page on-call
    # - Post to Slack
}

# Supervision status
status() {
    echo "=== Supervision Status ==="
    echo ""

    for service in "${(@k)RESTART_COUNTS}"; do
        local restart_count=${RESTART_COUNTS[$service]}
        local last_start=${RESTART_TIMESTAMPS[$service]}
        local uptime=$(($(date +%s) - last_start))

        if process-check-pid-file "$service"; then
            local pid=$(process-read-pid "$service")
            printf "%-20s ✓ PID: %-6s Uptime: %5ss  Restarts: %d\n" \
                "$service" "$pid" "$uptime" "$restart_count"
        else
            printf "%-20s ✗ DEAD (restarts: %d)\n" \
                "$service" "$restart_count"
        fi
    done
}

# Main
main() {
    case "${1:-}" in
        start)
            shift
            supervise_all "$@"
            ;;
        status)
            status
            ;;
        *)
            echo "Usage: $0 {start|status} [services...]"
            echo ""
            echo "Commands:"
            echo "  start <services...>  Start supervision"
            echo "  status               Show supervision status"
            echo ""
            echo "Configuration:"
            echo "  File: /etc/supervisor/services.conf"
            echo "  Format: service_name=command"
            return 1
            ;;
    esac
}

main "$@"
```

**Configuration file (/etc/supervisor/services.conf):**
```
api=python3 /opt/api/server.py --port 8080
worker=python3 /opt/api/worker.py --queue default
scheduler=python3 /opt/api/scheduler.py --interval 60
```

---

## Troubleshooting

### Common Issues

#### Issue: "ps not found"

**Symptom:**
```
[ERROR] _process requires ps - cannot load
```

**Cause:** `ps` command not installed or not in PATH

**Solution:**
```zsh
# Install procps (Arch/Manjaro)
sudo pacman -S procps-ng

# Install procps (Ubuntu/Debian)
sudo apt-get install procps

# Verify
which ps
ps --version
```

---

#### Issue: "Process not found" with valid PID

**Symptom:**
```
[ERROR] Process not running: 1234
```

**Cause:** Process doesn't exist or insufficient permissions

**Solutions:**
```zsh
# Check if process exists
ps -p 1234

# Check permissions
sudo ps -p 1234

# Verify PID is numeric
if [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo "Valid PID"
fi
```

---

#### Issue: "Stale PID file"

**Symptom:**
PID file exists but process is dead

**Cause:** Process crashed without cleanup

**Solution:**
```zsh
# Check PID file validity
process-check-pid-file "my_service"
# Automatically removes stale files

# Manual cleanup
process-remove-pid "my_service"

# Cleanup all stale files
process-cleanup
```

---

#### Issue: "Permission denied" killing process

**Symptom:**
```
kill: (1234) - Operation not permitted
```

**Cause:** Insufficient permissions to send signal

**Solutions:**
```zsh
# Run with sudo
sudo process-stop 1234

# Check process owner
ps -p 1234 -o user=

# Only kill own processes
pgrep -u $(whoami)
```

---

#### Issue: "Process won't stop gracefully"

**Symptom:**
Process ignores SIGTERM and times out

**Solutions:**
```zsh
# Use force flag
process-stop "my_service" --timeout 10 --force

# Longer timeout
process-stop "my_service" --timeout 60 --force

# Direct SIGKILL
process-signal "my_service" "KILL"

# Kill entire process tree
pid=$(process-read-pid "my_service")
process-kill-tree "$pid" --signal KILL
```

---

#### Issue: "lsof not found" for port detection

**Symptom:**
```
[ERROR] No suitable tool found (lsof, ss, or netstat required)
```

**Cause:** No port detection tool available

**Solutions:**
```zsh
# Install lsof (preferred)
sudo pacman -S lsof

# Alternative: use ss (usually installed)
ss -lpn "sport = :8080"

# Alternative: use netstat
sudo pacman -S net-tools
netstat -lnp | grep :8080
```

---

#### Issue: "High memory usage in monitoring"

**Symptom:**
Monitoring consumes excessive memory

**Solutions:**
```zsh
# Increase monitor interval
export PROCESS_MONITOR_INTERVAL=30

# Reduce cache TTL
export PROCESS_CACHE_TTL=1

# Monitor fewer processes
# Or stagger monitoring start times
for service in "${services[@]}"; do
    process-monitor "$service" &
    sleep 5
done
```

---

#### Issue: "Cannot find process by name"

**Symptom:**
```
process-find-by-name "nginx"  # Returns nothing
```

**Cause:** Process name mismatch or not running

**Solutions:**
```zsh
# Check actual process name
ps aux | grep nginx

# pgrep requires exact match
pgrep -x "nginx"        # Exact match
pgrep "nginx"           # Partial match

# Check all processes
pgrep -a "nginx"        # Show full command

# Use different detection method
pid=$(process-find-by-port 80)
```

---

### Debugging Techniques

#### Enable Debug Mode

```zsh
# Enable process debug logging
export PROCESS_DEBUG=true

# Make operations
process-stop "my_service"

# Disable
export PROCESS_DEBUG=false
```

#### Inspect PID Files

```zsh
# List all PID files
ls -la "$PROCESS_PID_DIR"

# Read PID file
cat "$PROCESS_PID_DIR/my_service.pid"

# Check PID validity
pid=$(cat "$PROCESS_PID_DIR/my_service.pid")
process-exists "$pid" && echo "Running" || echo "Dead"
```

#### Monitor Process Behavior

```zsh
# Watch process in real-time
watch -n 1 'process-get-info 1234'

# Continuous monitoring
while true; do
    clear
    process-get-info 1234
    sleep 2
done

# Log monitoring data
while true; do
    echo "$(date): CPU=$(process-get-cpu 1234) MEM=$(process-get-memory 1234)"
    sleep 5
done
```

#### Test Process Control

```zsh
# Start test process
sleep 1000 &
pid=$!

# Test operations
process-write-pid "test" "$pid"
process-check-pid-file "test"
process-get-info "$pid"
process-stop "test" --force
process-remove-pid "test"
```

---

### Performance Issues

#### Slow Process Detection

```zsh
# Cache process info
export PROCESS_CACHE_TTL=10
source "$(which _cache)"

# Reduce monitoring frequency
export PROCESS_MONITOR_INTERVAL=30

# Use PID files instead of name lookup
# FASTER: pid=$(process-read-pid "service")
# SLOWER: pid=$(process-find-by-name "service")
```

#### High CPU from Monitoring

```zsh
# Reduce check frequency
process-monitor "service" --interval 60

# Monitor fewer metrics
# Only alert on critical thresholds
process-monitor "service" --alert-cpu 95

# Stagger monitor starts
for service in "${services[@]}"; do
    process-monitor "$service" &
    sleep 10  # Delay between starts
done
```

---

## Architecture

### Design Principles

#### 1. PID-Centric Operations

All process operations centered on PID as primary identifier:

```zsh
# Core abstraction
process-exists <pid>      # Check liveness
process-get-cpu <pid>     # Get metrics
process-signal <pid> SIG  # Send signal
```

**Benefits:**
- Direct kernel interface
- No ambiguity
- Efficient operations
- Portable across systems

#### 2. PID File Management

PID files enable name-based process management:

```zsh
# Name → PID mapping
process-write-pid "service" $pid
pid=$(process-read-pid "service")

# Validation
process-check-pid-file "service"  # File + process check
```

**Use Cases:**
- Service management
- Singleton enforcement
- Process discovery
- State persistence

#### 3. Graceful Degradation

Optional dependencies handled gracefully:

```zsh
# Logging fallback
if ! source "_log"; then
    log-info() { echo "[INFO] $*"; }
fi

# Cache availability check
if [[ "$PROCESS_CACHE_AVAILABLE" == "true" ]]; then
    # Use caching
fi
```

#### 4. Signal-Based Control

POSIX signals for process control:

```zsh
# Graceful shutdown pattern
kill -TERM $pid     # Request shutdown
# Wait with timeout
kill -KILL $pid     # Force if necessary
```

**Signals:**
- TERM (15): Graceful shutdown
- KILL (9): Force kill
- HUP (1): Reload config
- USR1/USR2 (10/12): Custom

---

### Component Architecture

```
_process v2.0
├── Detection Layer
│   ├── process-exists
│   ├── process-find-by-name
│   ├── process-find-all-by-name
│   └── process-find-by-port
├── Information Layer
│   ├── process-get-cpu
│   ├── process-get-memory
│   ├── process-get-command
│   └── process-get-info
├── Control Layer
│   ├── process-stop
│   ├── process-signal
│   └── process-restart
├── PID File Layer
│   ├── process-write-pid
│   ├── process-read-pid
│   ├── process-remove-pid
│   └── process-check-pid-file
├── Monitoring Layer
│   └── process-monitor
├── Group Management
│   ├── process-group-add
│   ├── process-group-stop
│   └── process-group-list
├── Tree Operations
│   ├── process-get-children
│   └── process-kill-tree
└── Utilities
    ├── process-list
    ├── process-cleanup
    └── process-self-test
```

---

### Integration Patterns

#### Pattern 1: Basic Process Control

```zsh
source "$(which _process)"

# Start → Track → Stop
my_service &
process-write-pid "my_service" $!
# ...
process-stop "my_service"
```

#### Pattern 2: Service Management

```zsh
# Full service lifecycle
start_service() {
    process-check-pid-file "service" && return 0
    eval "$command" &
    process-write-pid "service" $!
}

stop_service() {
    process-stop "service" --timeout 30 --force
    process-remove-pid "service"
}
```

#### Pattern 3: Monitoring with Alerts

```zsh
# Resource monitoring
process-monitor "service" \
    --alert-cpu 80 \
    --alert-mem 1048576 \
    --interval 10 &

events-on "$PROCESS_EVENT_ALERT" 'handle_alert'
```

#### Pattern 4: Process Groups

```zsh
# Coordinate related processes
for service in api worker scheduler; do
    start_service "$service"
    process-group-add "app" "$service"
done

# Shutdown group
process-group-stop "app" --force
```

---

## Performance

### Optimization Strategies

#### 1. Process Info Caching

Enable caching for repeated queries:

```zsh
# Enable caching (requires _cache)
export PROCESS_CACHE_TTL=5

source "$(which _cache)"
source "$(which _process)"

# First call: cache miss
cpu=$(process-get-cpu $pid)

# Subsequent calls within TTL: cache hit
cpu=$(process-get-cpu $pid)  # Instant
```

**Performance Gain:** 10-100x faster for cached queries

---

#### 2. PID Files vs Name Lookup

Use PID files instead of name-based lookup:

```zsh
# SLOW: name lookup
pid=$(process-find-by-name "service")

# FAST: PID file read
pid=$(process-read-pid "service")
```

**Performance Gain:** 5-10x faster

---

#### 3. Batch Operations

Group related operations:

```zsh
# Inefficient: multiple calls
for pid in "${pids[@]}"; do
    cpu=$(process-get-cpu "$pid")
    mem=$(process-get-memory "$pid")
    cmd=$(process-get-command "$pid")
done

# Efficient: single ps call
ps -p "${pids[*]}" -o pid=,pcpu=,rss=,comm= | \
while read pid cpu mem cmd; do
    # Process data
done
```

---

#### 4. Monitoring Interval Tuning

```zsh
# High frequency (resource intensive)
export PROCESS_MONITOR_INTERVAL=1

# Balanced (recommended)
export PROCESS_MONITOR_INTERVAL=10

# Low frequency (minimal overhead)
export PROCESS_MONITOR_INTERVAL=60
```

---

### Performance Benchmarks

#### Process Detection

```zsh
# PID existence check
time process-exists 1234
# ~1ms

# Name-based lookup
time process-find-by-name "nginx"
# ~5-10ms

# Port-based lookup
time process-find-by-port 80
# ~20-50ms (tool dependent)
```

#### Resource Queries

```zsh
# Without caching
time process-get-cpu 1234
# ~10-20ms

# With caching
time process-get-cpu 1234  # First
# ~10-20ms
time process-get-cpu 1234  # Cached
# <1ms
```

---

### Memory Management

#### Monitoring Overhead

```zsh
# Single monitor process
process-monitor "service" &
# Memory: ~2-5 MB

# Multiple monitors
for service in "${services[@]}"; do
    process-monitor "$service" &
done
# Memory: ~2-5 MB per monitor
```

#### Registry Size

```zsh
# Process registry overhead
# ~100 bytes per tracked process
# Negligible for typical use
```

---

### Scaling Considerations

#### Large Process Counts

```zsh
# Monitor 100+ processes
# - Use process groups
# - Stagger monitor starts
# - Increase intervals
# - Enable caching

for service in "${services[@]}"; do
    process-monitor "$service" --interval 30 &
    sleep 1  # Stagger starts
done
```

#### High-Frequency Monitoring

```zsh
# 1-second intervals for critical processes
export PROCESS_MONITOR_INTERVAL=1

# But increase cache TTL
export PROCESS_CACHE_TTL=10
```

---

## Changelog

### v1.0.0 (2025-11-04)

**Major Release - Complete Rewrite**

#### Added
- Complete process lifecycle management
- PID file management system
- Resource monitoring with alerts
- Process group coordination
- Process tree operations
- Graceful shutdown patterns
- Signal handling utilities
- Event emission support
- Cache integration for performance
- Lifecycle integration for cleanup
- Comprehensive self-test suite

#### Detection
- `process-exists`: Check process liveness
- `process-find-by-name`: Find by exact name
- `process-find-all-by-name`: Find all matches
- `process-find-by-port`: Find by listening port

#### Control
- `process-stop`: Graceful stop with timeout
- `process-signal`: Send arbitrary signals
- `process-restart`: Stop and restart
- `process-kill-tree`: Kill process tree

#### Monitoring
- `process-monitor`: Real-time resource monitoring
- Configurable alert thresholds
- CPU and memory tracking
- Event emission on alerts

#### Architecture
- PID-centric operations
- PID file abstraction
- Graceful dependency degradation
- Signal-based control
- Event-driven monitoring

#### Documentation
- 2,400+ line comprehensive guide
- 6 production-ready examples
- Complete API reference
- Troubleshooting guide
- Performance optimization guide

#### Dependencies
- Required: _common v2.0, ps, kill, pgrep
- Optional: _log v2.0, _events v2.0, _cache v2.0, _lifecycle v3.0, lsof/ss/netstat

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-11-04
**Maintainer:** dotfiles ecosystem
**License:** MIT
