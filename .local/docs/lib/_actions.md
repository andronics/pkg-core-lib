# _actions - Action Registry, Dispatcher, and Execution Engine

**Lines:** 3,189 | **Functions:** 29 | **Examples:** 95 | **Source Lines:** 960
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_actions`
**Enhanced Documentation Requirements:** v1.1 | **Compliance:** 95%

---

## Quick Access Index

### Compact References (Lines 10-300)
- [Function Reference](#function-quick-reference) - 29 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 6 variables
- [Events](#events-quick-reference) - 6 events
- [Return Codes](#return-codes-quick-reference) - Standard codes
- [Action States](#action-states-reference) - 5 states

### Main Sections
- [Overview](#overview) (Lines 300-400, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 400-500, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 500-850, ~350 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 850-1000, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 1000-2550, ~1550 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2550-2900, ~350 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2900-3150, ~250 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: actions_api -->

**Action Registration:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-register` | Register action handler | 201-224 | O(1) | [→](#action-register) |
| `action-unregister` | Unregister action handler | 227-243 | O(1) | [→](#action-unregister) |
| `action-exists` | Check if action is registered | 246-255 | O(1) | [→](#action-exists) |
| `action-list` | List registered actions | 258-272 | O(n) | [→](#action-list) |

**Hook Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-hook-register` | Register pre/post hook | 280-306 | O(1) | [→](#action-hook-register) |
| `_actions-execute-hooks` | Execute hooks (internal) | 309-329 | O(1) | Internal |

**Execution Context:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-context-set` | Set execution context variable | 336-344 | O(1) | [→](#action-context-set) |
| `action-context-get` | Get context variable | 347-354 | O(1) | [→](#action-context-get) |
| `action-context-clear` | Clear execution context | 357-360 | O(1) | [→](#action-context-clear) |

**State Management:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-get-state` | Get action execution state | 376-382 | O(1) | [→](#action-get-state) |
| `action-get-result` | Get action result data | 394-400 | O(1) | [→](#action-get-result) |
| `_actions-set-state` | Set action state (internal) | 367-373 | O(1) | Internal |
| `_actions-store-result` | Store action result (internal) | 385-391 | O(1) | Internal |

**Conditional Execution:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `_actions-evaluate-condition` | Evaluate condition expression | 407-436 | O(1) | Internal |
| `_actions-should-execute` | Check if action should execute | 439-474 | O(n) | Internal |

**Action Execution:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-execute-schema` | Execute actions from schema | 596-729 | O(n*m) | [→](#action-execute-schema) |
| `_actions-execute-one` | Execute single action (internal) | 481-593 | O(1) | Internal |
| `_actions-rollback-schema` | Execute rollback (internal) | 736-773 | O(n) | Internal |

**Utilities:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `action-get-error` | Get last error message | 780-782 | O(1) | [→](#action-get-error) |
| `action-clear-state` | Clear execution state | 785-792 | O(1) | [→](#action-clear-state) |
| `action-get-history` | Get execution history | 795-804 | O(n) | [→](#action-get-history) |
| `action-stats` | Display statistics | 810-823 | O(1) | [→](#action-stats) |
| `action-help` | Display comprehensive help | 829-923 | O(1) | [→](#action-help) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `_actions-log-debug` | Debug logging | 156-159 | O(1) | Internal |
| `_actions-log-verbose` | Verbose logging | 161-164 | O(1) | Internal |
| `_actions-log-error` | Error logging | 166-169 | O(1) | Internal |
| `_actions-log-warning` | Warning logging | 171-173 | O(1) | Internal |
| `_actions-log-success` | Success logging | 175-178 | O(1) | Internal |
| `_actions-emit-event` | Emit event via _events | 184-193 | O(1) | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description | Source Lines |
|----------|------|---------|-------------|--------------|
| `ACTIONS_VERBOSE` | boolean | `false` | Verbose output | 95 |
| `ACTIONS_DEBUG` | boolean | `false` | Debug output | 96 |
| `ACTIONS_DRY_RUN` | boolean | `false` | Simulate without execution | 97 |
| `ACTIONS_CONTINUE_ON_ERROR` | boolean | `false` | Continue on action failure | 98 |
| `ACTIONS_ENABLE_ROLLBACK` | boolean | `true` | Enable rollback on failure | 101 |
| `ACTIONS_ROLLBACK_STRATEGY` | string | `best-effort` | Rollback strategy | 102 |
| `ACTIONS_ENABLE_HOOKS` | boolean | `true` | Enable pre/post hooks | 105 |
| `ACTIONS_VERSION` | string (readonly) | `1.0.0` | Extension version | 44 |
| `ACTIONS_LOADED` | boolean (readonly) | `1` | Extension loaded flag | 45 |
| `ACTIONS_LAST_ERROR` | string | `` | Last error message | 133 |

---

## Events Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | When Emitted | Data Parameters | Source Lines |
|-------|--------------|-----------------|--------------|
| `actions.registered` | Action handler registered | `type`, `action`, `handler` | 221 |
| `actions.execute.start` | Action execution started | `action_id`, `type`, `action_name` | 495 |
| `actions.execute.success` | Action completed successfully | `action_id` | 568 |
| `actions.execute.failed` | Action execution failed | `action_id`, `exit_code` | 576 |
| `actions.execute.skipped` | Action skipped (condition) | `action_id` | 512 |
| `actions.schema.execute.start` | Schema execution started | `schema_file`, `action_count` | 638 |
| `actions.schema.execute.success` | Schema execution succeeded | `schema_file` | 726 |
| `actions.schema.execute.failed` | Schema execution failed | `schema_file` | 715 |
| `actions.rollback.start` | Rollback started | (none) | 740 |
| `actions.rollback.complete` | Rollback completed | (none) | 771 |

**Event Subscription:**
```zsh
source "$(which _events)"
events-on "actions.execute.success" my_success_handler
```

---

## Action States Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| State | Description | Set By | Retrieved Via |
|-------|-------------|--------|---------------|
| `pending` | Action registered, not yet executed | `action-execute-schema` | `action-get-state` |
| `running` | Action currently executing | `_actions-execute-one` | `action-get-state` |
| `completed` | Action executed successfully | `_actions-execute-one` | `action-get-state` |
| `failed` | Action execution failed | `_actions-execute-one` | `action-get-state` |
| `skipped` | Action skipped (condition not met) | `_actions-execute-one` | `action-get-state` |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (execution, validation) | Most functions |
| `2` | Invalid arguments | Missing or invalid parameters | Functions with required params |

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Overview

The `_actions` extension is the central action registry and execution engine for the declarative action system. It provides comprehensive action handler registration, dependency-ordered execution, pre/post hooks, execution state tracking, conditional execution, and best-effort rollback capabilities.

**Key Features:**
- **Action Registry:** Register and manage action handlers from plugins
- **Dependency Execution:** Automatic dependency ordering via `_lifecycle`
- **Pre/Post Hooks:** Execute hooks before and after actions
- **State Tracking:** Track action execution state and results
- **Conditional Execution:** Evaluate conditions before executing actions
- **Result Passing:** Store and pass results between actions via context
- **Rollback Support:** Best-effort rollback on failure
- **Event Emission:** Emit events for execution lifecycle
- **Dry Run Mode:** Simulate execution without running actions
- **Error Handling:** Configurable error handling (fail, warn, ignore)

**Dependencies:**
- **Required:** `_common`, `_schema`, `_lifecycle`
- **Optional:** `_events` (for event emission)

**Architecture Position:**
- **Layer:** Infrastructure (Layer 2)
- **Used By:** Action-driven utilities, orchestration tools
- **Uses:** `_common`, `_schema`, `_lifecycle`, `_events`

**Use Cases:**
- Executing declarative action schemas
- Building orchestration workflows
- Implementing plugin-based action systems
- Creating composable automation pipelines
- Managing complex multi-step operations

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

### Prerequisites

The `_actions` extension requires:

1. **Core Dependencies:**
   ```bash
   # Available in ~/.local/bin/lib/ via stow
   source "$(which _common)"
   source "$(which _schema)"
   source "$(which _lifecycle)"
   ```

2. **Optional Dependencies:**
   ```bash
   # For event emission
   source "$(which _events)"
   ```

### Installation via Stow

```bash
# Install library (if not already done)
cd ~/.pkgs
stow lib

# Verify installation
source "$(which _actions)"
action-stats
```

### Verification

```bash
# Check extension loaded
if [[ -n "${ACTIONS_LOADED:-}" ]]; then
    echo "Actions extension loaded"
else
    echo "Failed to load actions extension"
    exit 1
fi

# Display statistics
action-stats
```

**Expected Output:**
```
Actions Engine Statistics:
  Version: 1.0.0
  Registered Actions: 0
  Registered Hooks: 0
  Total Executions: 0
  Total Successes: 0
  Total Failures: 0
  Total Skipped: 0
  Current Execution: none
  Dry Run Mode: false
  Continue On Error: false
  Rollback Enabled: true
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
## Quick Start

### Example 1: Register and Execute Action

**Define Handler Function:**
```zsh
source "$(which _actions)"

# Define action handler
docker-volume-backup() {
    local volume_name="$1"
    local params="$2"

    local destination=$(echo "$params" | jq -r '.destination')

    echo "Backing up volume $volume_name to $destination"

    # Execute backup
    docker run --rm \
        -v "$volume_name:/data:ro" \
        -v "$destination:/backup" \
        alpine tar czf "/backup/${volume_name}.tar.gz" -C /data .

    return $?
}

# Register handler
action-register "docker.volume" "backup" "docker-volume-backup"
```

**Create Schema:** `backup.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "backup-postgres"
    type: "docker.volume"
    resource: "postgres_data"
    action: "backup"
    params:
      destination: "/backup/volumes"
```

**Execute:**
```zsh
action-execute-schema "backup.yaml"
# Output: Backs up postgres_data volume
```

### Example 2: Dependency-Ordered Execution

**Schema with Dependencies:** `workflow.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "prepare"
    type: "shell.command"
    resource: "echo"
    action: "execute"
    params:
      args: ["Preparing..."]

  - id: "build"
    type: "shell.command"
    resource: "make"
    action: "execute"
    depends_on:
      - "prepare"

  - id: "test"
    type: "shell.command"
    resource: "pytest"
    action: "execute"
    depends_on:
      - "build"
```

**Execute:**
```zsh
# Actions execute in dependency order: prepare → build → test
action-execute-schema "workflow.yaml"
```

### Example 3: Pre/Post Hooks

**Register Hook:**
```zsh
source "$(which _actions)"

# Pre-hook: verify volume exists
verify-volume-exists() {
    local action_json="$1"
    local volume=$(echo "$action_json" | jq -r '.resource')

    if ! docker volume inspect "$volume" >/dev/null 2>&1; then
        echo "Error: Volume does not exist: $volume" >&2
        return 1
    fi

    echo "Volume verified: $volume"
    return 0
}

# Register pre-hook
action-hook-register "docker.volume" "backup" "pre" "verify-volume-exists"

# Register action handler
action-register "docker.volume" "backup" "docker-volume-backup"
```

**Execute:**
```zsh
# Pre-hook runs before action
action-execute-schema "backup.yaml"
# Output:
# Volume verified: postgres_data
# Backing up volume postgres_data...
```

### Example 4: Conditional Execution

**Schema with Conditions:** `conditional.yaml`
```yaml
schema: "action/v1"

context:
  environment: "production"
  skip_tests: false

actions:
  - id: "run-tests"
    type: "shell.command"
    resource: "pytest"
    action: "execute"
    conditions:
      - expression: "{{ .skip_tests }}"
        on_false: "skip"  # Skip if skip_tests is false

  - id: "deploy"
    type: "k8s.deployment"
    resource: "app"
    action: "apply"
    conditions:
      - expression: "{{ .environment }}"
        on_false: "fail"  # Fail if environment not set
```

**Execute:**
```zsh
action-execute-schema "conditional.yaml"
# Output: run-tests skipped, deploy executes
```

### Example 5: Execution Context and Result Passing

**Schema:** `context.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "get-version"
    type: "shell.command"
    resource: "git"
    action: "execute"
    params:
      args: ["describe", "--tags"]
    store_result_as: "version"

  - id: "build-image"
    type: "docker.image"
    resource: "myapp"
    action: "build"
    params:
      tag: "{{ .version }}"  # Uses result from previous action
```

**Execute:**
```zsh
action-execute-schema "context.yaml"
# get-version stores result in context
# build-image uses that result as tag
```

### Example 6: Error Handling Strategies

**Schema:** `error-handling.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "optional-cleanup"
    type: "shell.command"
    resource: "rm"
    action: "execute"
    params:
      args: ["-rf", "/tmp/cache"]
    on_error: "warn"  # Continue with warning

  - id: "critical-deploy"
    type: "k8s.deployment"
    resource: "app"
    action: "apply"
    on_error: "fail"  # Stop on failure (default)

  - id: "log-metrics"
    type: "shell.command"
    resource: "logger"
    action: "execute"
    on_error: "ignore"  # Ignore errors completely
```

**Execute:**
```zsh
action-execute-schema "error-handling.yaml"
# optional-cleanup: warns on error, continues
# critical-deploy: fails on error, stops execution
# log-metrics: ignores errors silently
```

### Example 7: Dry Run Mode

**Enable Dry Run:**
```zsh
export ACTIONS_DRY_RUN=true

action-execute-schema "deployment.yaml"
# Output: [DRY RUN] Would execute: prepare
#         [DRY RUN] Would execute: build
#         [DRY RUN] Would execute: deploy

# No actual execution occurs
```

### Example 8: Query Execution State

**Execute and Query:**
```zsh
action-execute-schema "workflow.yaml"

# Get action state
state=$(action-get-state "build")
echo "Build state: $state"
# Output: completed

# Get action result
result=$(action-get-result "build")
echo "Build result: $result"

# Get execution history
echo "Execution history:"
action-get-history
# Output: prepare
#         build
#         test
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Configuration

### Environment Variables

#### Execution Behavior

```zsh
# Enable verbose output (default: false)
export ACTIONS_VERBOSE=true

# Enable debug logging (default: false)
export ACTIONS_DEBUG=true

# Dry run mode - simulate without execution (default: false)
export ACTIONS_DRY_RUN=true

# Continue on action failure (default: false)
export ACTIONS_CONTINUE_ON_ERROR=true
```

#### Rollback Configuration

```zsh
# Enable rollback on failure (default: true)
export ACTIONS_ENABLE_ROLLBACK=true

# Rollback strategy (default: best-effort)
# Options: best-effort
export ACTIONS_ROLLBACK_STRATEGY="best-effort"
```

#### Hook Configuration

```zsh
# Enable pre/post hooks (default: true)
export ACTIONS_ENABLE_HOOKS=true
```

### Configuration Examples

#### Production Configuration

```zsh
# Strict execution, stop on first error
export ACTIONS_VERBOSE=true
export ACTIONS_DEBUG=false
export ACTIONS_DRY_RUN=false
export ACTIONS_CONTINUE_ON_ERROR=false
export ACTIONS_ENABLE_ROLLBACK=true
```

#### Development Configuration

```zsh
# Verbose with continue-on-error
export ACTIONS_VERBOSE=true
export ACTIONS_DEBUG=true
export ACTIONS_DRY_RUN=false
export ACTIONS_CONTINUE_ON_ERROR=true
export ACTIONS_ENABLE_ROLLBACK=true
```

#### Testing Configuration

```zsh
# Dry run for testing
export ACTIONS_VERBOSE=true
export ACTIONS_DEBUG=true
export ACTIONS_DRY_RUN=true
export ACTIONS_CONTINUE_ON_ERROR=false
export ACTIONS_ENABLE_ROLLBACK=false
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: api_registration -->
## API Reference

### Action Registration Functions

#### `action-register`

**Source:** Lines 201-224
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Register action handler function for a specific action type.

**Signature:**
```zsh
action-register <type> <action> <handler_function>
```

**Parameters:**
- `type` - Action type (e.g., `docker.volume`) (required)
- `action` - Action operation (e.g., `backup`) (required)
- `handler_function` - Handler function name (required)

**Returns:**
- `0` - Handler registered successfully
- `1` - Handler function does not exist
- `2` - Invalid arguments

**Side Effects:**
- Adds handler to `_ACTIONS_REGISTRY`
- Increments `_ACTIONS_TOTAL_REGISTERED`
- Emits `actions.registered` event

**Example:**
```zsh
# Define handler
docker-volume-backup() {
    local volume="$1"
    local params="$2"
    # Implementation...
}

# Register handler
action-register "docker.volume" "backup" "docker-volume-backup"
```

**Example: Multiple Handlers:**
```zsh
# Register multiple handlers for same type
action-register "docker.volume" "backup" "docker-volume-backup"
action-register "docker.volume" "remove" "docker-volume-remove"
action-register "docker.volume" "create" "docker-volume-create"

# Different types
action-register "docker.container" "stop" "docker-container-stop"
action-register "k8s.deployment" "apply" "k8s-deployment-apply"
```

**Handler Function Signature:**
```zsh
handler_function <resource_or_selector> <params_json>
```

**Returns:**
- `0` - Success
- Non-zero - Failure

**Output:** Result data (captured if `store_result_as` is set)

---

#### `action-unregister`

**Source:** Lines 227-243
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Unregister previously registered action handler.

**Signature:**
```zsh
action-unregister <type> <action>
```

**Parameters:**
- `type` - Action type (required)
- `action` - Action operation (required)

**Returns:**
- `0` - Handler unregistered
- `1` - Action not registered
- `2` - Invalid arguments

**Example:**
```zsh
# Unregister handler
action-unregister "docker.volume" "backup"
```

**Example: Conditional Unregister:**
```zsh
if action-exists "docker.volume" "backup"; then
    action-unregister "docker.volume" "backup"
    echo "Handler unregistered"
else
    echo "Handler not found"
fi
```

---

#### `action-exists`

**Source:** Lines 246-255
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Check if action handler is registered.

**Signature:**
```zsh
action-exists <type> <action>
```

**Parameters:**
- `type` - Action type (required)
- `action` - Action operation (required)

**Returns:**
- `0` - Action is registered
- `1` - Action not registered
- `2` - Invalid arguments

**Example:**
```zsh
if action-exists "docker.volume" "backup"; then
    echo "Backup handler available"
else
    echo "No backup handler registered"
    exit 1
fi
```

**Example: Graceful Degradation:**
```zsh
# Check if action supported before schema execution
required_actions=(
    "docker.volume:backup"
    "docker.container:stop"
)

for action_key in "${required_actions[@]}"; do
    type="${action_key%:*}"
    action="${action_key#*:}"

    if ! action-exists "$type" "$action"; then
        echo "Missing required handler: $type.$action"
        exit 1
    fi
done

echo "All required handlers available"
```

---

#### `action-list`

**Source:** Lines 258-272
**Complexity:** O(n) - Number of registered actions
**Dependencies:** None

List all registered actions, optionally filtered by type.

**Signature:**
```zsh
action-list [type_filter]
```

**Parameters:**
- `type_filter` - Filter by type prefix (optional)

**Returns:**
- `0` - Always succeeds

**Output:** Registered actions with handlers

**Example:**
```zsh
# List all actions
action-list

# Output:
# Registered Actions:
#   docker.volume.backup => docker-volume-backup
#   docker.volume.remove => docker-volume-remove
#   docker.container.stop => docker-container-stop
```

**Example: Filter by Type:**
```zsh
# List only docker.volume actions
action-list "docker.volume"

# Output:
# Registered Actions:
#   docker.volume.backup => docker-volume-backup
#   docker.volume.remove => docker-volume-remove
```

**Example: Inventory Check:**
```zsh
echo "Available Docker actions:"
action-list "docker" | grep "^  docker" | sed 's/^  //'
```

---

<!-- CONTEXT_GROUP: api_hooks -->
### Hook Management Functions

#### `action-hook-register`

**Source:** Lines 280-306
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Register pre or post hook for an action.

**Signature:**
```zsh
action-hook-register <type> <action> <phase> <handler_function>
```

**Parameters:**
- `type` - Action type (required)
- `action` - Action operation (required)
- `phase` - Hook phase: `pre` or `post` (required)
- `handler_function` - Hook handler function name (required)

**Returns:**
- `0` - Hook registered successfully
- `1` - Handler function does not exist
- `2` - Invalid arguments (invalid phase or missing params)

**Hook Function Signature:**
```zsh
hook_handler <action_json>
```

**Returns:**
- `0` - Continue with action
- Non-zero - Abort action

**Example: Pre-hook Validation:**
```zsh
# Pre-hook to validate volume exists
verify-volume-exists() {
    local action_json="$1"
    local volume=$(echo "$action_json" | jq -r '.resource')

    if ! docker volume inspect "$volume" >/dev/null 2>&1; then
        echo "Error: Volume not found: $volume" >&2
        return 1
    fi

    echo "✓ Volume exists: $volume"
    return 0
}

action-hook-register "docker.volume" "backup" "pre" "verify-volume-exists"
```

**Example: Post-hook Notification:**
```zsh
# Post-hook to send notification
notify-backup-complete() {
    local action_json="$1"
    local volume=$(echo "$action_json" | jq -r '.resource')

    echo "Backup completed: $volume"
    # Send notification...

    return 0
}

action-hook-register "docker.volume" "backup" "post" "notify-backup-complete"
```

**Example: Multiple Hooks:**
```zsh
# Pre-hooks run in registration order
action-hook-register "docker.volume" "remove" "pre" "verify-volume-exists"
action-hook-register "docker.volume" "remove" "pre" "check-volume-empty"

# Post-hooks also run in order
action-hook-register "docker.volume" "remove" "post" "cleanup-metadata"
action-hook-register "docker.volume" "remove" "post" "send-notification"
```

---

<!-- CONTEXT_GROUP: api_context -->
### Execution Context Functions

#### `action-context-set`

**Source:** Lines 336-344
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Set variable in execution context (available to all actions).

**Signature:**
```zsh
action-context-set <key> <value>
```

**Parameters:**
- `key` - Context variable name (required)
- `value` - Variable value (required)

**Returns:**
- `0` - Context variable set
- `2` - Invalid arguments

**Side Effects:**
- Stores value in `_ACTIONS_CONTEXT` associative array

**Example:**
```zsh
# Set context variables
action-context-set "environment" "production"
action-context-set "version" "v1.2.3"
action-context-set "timestamp" "$(date -Iseconds)"
```

**Example: Pre-execution Setup:**
```zsh
# Set context before schema execution
action-context-set "backup_dir" "/backup/$(date +%Y%m%d)"
action-context-set "retention_days" "30"

# Schema actions can reference these via context
action-execute-schema "backup.yaml"
```

---

#### `action-context-get`

**Source:** Lines 347-354
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Get variable from execution context.

**Signature:**
```zsh
action-context-get <key> [default]
```

**Parameters:**
- `key` - Context variable name (required)
- `default` - Default value if not found (optional)

**Returns:**
- `0` - Always succeeds
- `2` - Invalid arguments

**Output:** Variable value or default

**Example:**
```zsh
# Get context variable
env=$(action-context-get "environment" "development")
echo "Environment: $env"
```

**Example: Use in Handler:**
```zsh
my-handler() {
    local resource="$1"
    local params="$2"

    # Get context variable
    local backup_dir=$(action-context-get "backup_dir" "/tmp")

    echo "Backing up to: $backup_dir"
    # Implementation...
}
```

---

#### `action-context-clear`

**Source:** Lines 357-360
**Complexity:** O(1)
**Dependencies:** None

Clear all execution context variables.

**Signature:**
```zsh
action-context-clear
```

**Returns:**
- `0` - Context cleared

**Example:**
```zsh
# Clear context after execution
action-execute-schema "workflow.yaml"
action-context-clear
```

---

<!-- CONTEXT_GROUP: api_state -->
### State Management Functions

#### `action-get-state`

**Source:** Lines 376-382
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Get execution state of an action.

**Signature:**
```zsh
action-get-state <action_id>
```

**Parameters:**
- `action_id` - Action ID from schema (required)

**Returns:**
- `0` - Always succeeds
- `2` - Invalid arguments

**Output:** Action state: `pending`, `running`, `completed`, `failed`, `skipped`, or `unknown`

**Example:**
```zsh
# Execute schema
action-execute-schema "workflow.yaml"

# Check state of specific action
state=$(action-get-state "build")
case "$state" in
    completed)
        echo "Build succeeded"
        ;;
    failed)
        echo "Build failed"
        exit 1
        ;;
    skipped)
        echo "Build was skipped"
        ;;
esac
```

**Example: Monitor All Actions:**
```zsh
# Get all action IDs from schema
source "$(which _schema)"
schema-load "workflow.yaml" >/dev/null

for action_id in $(schema-list-action-ids); do
    state=$(action-get-state "$action_id")
    echo "$action_id: $state"
done
```

---

#### `action-get-result`

**Source:** Lines 394-400
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Get result data from completed action.

**Signature:**
```zsh
action-get-result <action_id>
```

**Parameters:**
- `action_id` - Action ID from schema (required)

**Returns:**
- `0` - Always succeeds
- `2` - Invalid arguments

**Output:** Action result data (if stored)

**Example:**
```zsh
# Schema stores result
# actions:
#   - id: "get-version"
#     store_result_as: "version"
#     ...

action-execute-schema "version.yaml"

# Get stored result
version=$(action-get-result "get-version")
echo "Version: $version"
```

**Example: Chain Results:**
```zsh
action-execute-schema "build-pipeline.yaml"

# Get build artifact
artifact=$(action-get-result "build")

# Get test results
test_output=$(action-get-result "test")

echo "Build artifact: $artifact"
echo "Test output: $test_output"
```

---

<!-- CONTEXT_GROUP: api_execution -->
### Action Execution Functions

#### `action-execute-schema`

**Source:** Lines 596-729
**Complexity:** O(n*m) - n actions, m average dependencies each
**Dependencies:** `schema-load`, `schema-validate`, `lifecycle-cleanup-add`

Execute all actions from schema in dependency order.

**Signature:**
```zsh
action-execute-schema <schema_file>
```

**Parameters:**
- `schema_file` - Path to schema file (required)

**Returns:**
- `0` - All actions completed successfully
- `1` - Execution failed (validation, action error)
- `2` - Invalid arguments

**Side Effects:**
- Loads schema into `_SCHEMA_CURRENT`
- Sets all action states in `_ACTIONS_STATE`
- Stores results in `_ACTIONS_RESULTS`
- Populates `_ACTIONS_HISTORY`
- Increments `_ACTIONS_TOTAL_EXECUTIONS`
- Emits lifecycle events

**Execution Flow:**
1. Load and validate schema
2. Register actions with `_lifecycle` for dependency ordering
3. Get execution order
4. Execute actions sequentially
5. Handle failures (stop or continue based on config)
6. Attempt rollback on failure (if enabled)

**Example:**
```zsh
# Basic execution
if action-execute-schema "deployment.yaml"; then
    echo "Deployment successful"
else
    echo "Deployment failed"
    exit 1
fi
```

**Example: Verbose Execution:**
```zsh
export ACTIONS_VERBOSE=true
export ACTIONS_DEBUG=true

action-execute-schema "complex-workflow.yaml" 2>&1 | tee execution.log
```

**Example: Error Handling:**
```zsh
# Continue on error
export ACTIONS_CONTINUE_ON_ERROR=true

if ! action-execute-schema "workflow.yaml"; then
    echo "Some actions failed, checking which ones:"

    for action_id in $(schema-list-action-ids); do
        state=$(action-get-state "$action_id")
        if [[ "$state" == "failed" ]]; then
            echo "  Failed: $action_id"
        fi
    done
fi
```

**Example: Dry Run:**
```zsh
# Preview execution without running
export ACTIONS_DRY_RUN=true

action-execute-schema "deployment.yaml"
# Output: [DRY RUN] Would execute: action1
#         [DRY RUN] Would execute: action2
#         ...
```

**Performance Notes:**
- Dependency resolution: O(n²) worst case
- Action execution: Sequential (parallel not yet supported)
- Memory: Stores all action states and results in memory

---

<!-- CONTEXT_GROUP: api_utilities -->
### Utility Functions

#### `action-get-error`

**Source:** Lines 780-782
**Complexity:** O(1)
**Dependencies:** None

Get last error message.

**Signature:**
```zsh
action-get-error
```

**Returns:**
- `0` - Always succeeds

**Output:** Last error message (empty if no error)

**Example:**
```zsh
if ! action-execute-schema "workflow.yaml"; then
    error=$(action-get-error)
    echo "Execution failed: $error"
    exit 1
fi
```

---

#### `action-clear-state`

**Source:** Lines 785-792
**Complexity:** O(1)
**Dependencies:** None

Clear all execution state (states, results, context, history).

**Signature:**
```zsh
action-clear-state
```

**Returns:**
- `0` - State cleared

**Side Effects:**
- Clears `_ACTIONS_STATE`
- Clears `_ACTIONS_RESULTS`
- Clears `_ACTIONS_CONTEXT`
- Clears `_ACTIONS_HISTORY`
- Clears `_ACTIONS_CURRENT_EXEC_ID`

**Example:**
```zsh
# Execute schema
action-execute-schema "workflow1.yaml"

# Clear state before next execution
action-clear-state

# Execute new schema with clean state
action-execute-schema "workflow2.yaml"
```

---

#### `action-get-history`

**Source:** Lines 795-804
**Complexity:** O(n) - Number of executed actions
**Dependencies:** None

Get execution history (list of executed actions in order).

**Signature:**
```zsh
action-get-history
```

**Returns:**
- `0` - History returned
- `1` - No execution history

**Output:** Action IDs, one per line, in execution order

**Example:**
```zsh
action-execute-schema "workflow.yaml"

echo "Execution history:"
action-get-history
# Output: prepare
#         build
#         test
#         deploy
```

**Example: Post-Execution Report:**
```zsh
action-execute-schema "deployment.yaml"

echo "=== Execution Report ==="
for action_id in $(action-get-history); do
    state=$(action-get-state "$action_id")
    echo "$action_id: $state"
done
```

---

#### `action-stats`

**Source:** Lines 810-823
**Complexity:** O(1)
**Dependencies:** None

Display action engine statistics.

**Signature:**
```zsh
action-stats
```

**Returns:**
- `0` - Always succeeds

**Output:** Statistics report

**Example Output:**
```
Actions Engine Statistics:
  Version: 1.0.0
  Registered Actions: 12
  Registered Hooks: 4
  Total Executions: 5
  Total Successes: 23
  Total Failures: 2
  Total Skipped: 1
  Current Execution: exec_1699999999_12345
  Dry Run Mode: false
  Continue On Error: false
  Rollback Enabled: true
```

**Example: Monitoring:**
```zsh
echo "Before:"
action-stats

action-execute-schema "workflow.yaml"

echo "After:"
action-stats
```

---

#### `action-help`

**Source:** Lines 829-923
**Complexity:** O(1)
**Dependencies:** None

Display comprehensive help documentation.

**Signature:**
```zsh
action-help
```

**Returns:**
- `0` - Always succeeds

**Output:** Complete help text

**Example:**
```zsh
action-help | less
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## Advanced Usage

### Example 1: Plugin-Based Action System

**Plugin Structure:**
```
plugins/
  ├── docker/
  │   └── plugin.zsh
  ├── kubernetes/
  │   └── plugin.zsh
  └── shell/
      └── plugin.zsh
```

**Docker Plugin:** `plugins/docker/plugin.zsh`
```zsh
#!/usr/bin/env zsh

# Docker volume handlers
docker-volume-backup() {
    local volume="$1"
    local params="$2"
    local dest=$(echo "$params" | jq -r '.destination')

    docker run --rm \
        -v "$volume:/data:ro" \
        -v "$dest:/backup" \
        alpine tar czf "/backup/${volume}.tar.gz" -C /data .
}

docker-volume-remove() {
    local volume="$1"
    docker volume rm "$volume"
}

docker-volume-create() {
    local volume="$1"
    local params="$2"
    local driver=$(echo "$params" | jq -r '.driver // "local"')

    docker volume create --driver "$driver" "$volume"
}

# Register handlers
docker_init() {
    action-register "docker.volume" "backup" "docker-volume-backup"
    action-register "docker.volume" "remove" "docker-volume-remove"
    action-register "docker.volume" "create" "docker-volume-create"
}
```

**Load and Use:**
```zsh
source "$(which _actions)"

# Load plugins
for plugin in plugins/*/plugin.zsh; do
    source "$plugin"

    # Call init function
    plugin_name=$(basename "$(dirname "$plugin")")
    init_func="${plugin_name}_init"

    if typeset -f "$init_func" >/dev/null; then
        "$init_func"
    fi
done

# Execute schema using plugin actions
action-execute-schema "docker-teardown.yaml"
```

### Example 2: Custom Error Recovery

**Implement Recovery Handler:**
```zsh
source "$(which _actions)"

# Override internal execution function for custom recovery
action-execute-schema-with-recovery() {
    local schema_file="$1"
    local max_retries=3
    local retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        echo "Attempt $((retry_count + 1)) of $max_retries"

        if action-execute-schema "$schema_file"; then
            echo "Execution successful"
            return 0
        fi

        ((retry_count++))
        if [[ $retry_count -lt $max_retries ]]; then
            echo "Execution failed, retrying in 5 seconds..."
            sleep 5

            # Clear state for retry
            action-clear-state
        fi
    done

    echo "Execution failed after $max_retries attempts"
    return 1
}

# Use custom execution
action-execute-schema-with-recovery "flaky-deployment.yaml"
```

### Example 3: Parallel Execution (Manual)

**Note:** Built-in parallel execution not yet implemented. Manual approach:

```zsh
source "$(which _actions)"
source "$(which _schema)"

schema-load "workflow.yaml" >/dev/null

# Get actions without dependencies
independent_actions=()
for action_id in $(schema-list-action-ids); do
    action=$(schema-get-action "$action_id")

    if ! echo "$action" | jq -e '.depends_on' >/dev/null 2>&1; then
        independent_actions+=("$action_id")
    fi
done

# Execute independent actions in parallel
pids=()
for action_id in "${independent_actions[@]}"; do
    (
        action=$(schema-get-action "$action_id")
        # Execute action manually
        # ... implementation ...
    ) &
    pids+=($!)
done

# Wait for all to complete
for pid in "${pids[@]}"; do
    wait "$pid" || echo "Action failed"
done
```

### Example 4: Dynamic Handler Registration

**Runtime Handler Creation:**
```zsh
source "$(which _actions)"

# Generate handler dynamically
create_docker_handler() {
    local operation="$1"

    eval "docker-container-${operation}() {
        local container=\"\$1\"
        local params=\"\$2\"

        docker container $operation \"\$container\"
    }"

    action-register "docker.container" "$operation" "docker-container-${operation}"
}

# Create multiple handlers
for op in start stop restart pause unpause; do
    create_docker_handler "$op"
done

# Verify
action-list "docker.container"
```

### Example 5: Execution Middleware

**Wrap Actions with Logging:**
```zsh
source "$(which _actions)"

# Middleware: log execution times
timed-action-wrapper() {
    local handler="$1"
    shift

    local start=$(date +%s)

    "$handler" "$@"
    local exit_code=$?

    local end=$(date +%s)
    local duration=$((end - start))

    echo "[$handler] Duration: ${duration}s" >&2

    return $exit_code
}

# Register with wrapper
register-timed-action() {
    local type="$1"
    local action="$2"
    local handler="$3"

    # Create wrapper function
    local wrapper="${handler}_timed"
    eval "${wrapper}() {
        timed-action-wrapper $handler \"\$@\"
    }"

    action-register "$type" "$action" "$wrapper"
}

# Use timed registration
register-timed-action "docker.volume" "backup" "docker-volume-backup"
```

### Example 6: Action Composition

**Composite Actions:**
```zsh
source "$(which _actions)"

# Composite action: backup + verify
docker-volume-backup-and-verify() {
    local volume="$1"
    local params="$2"

    # Execute backup
    docker-volume-backup "$volume" "$params" || return 1

    # Verify backup exists
    local dest=$(echo "$params" | jq -r '.destination')
    local backup_file="$dest/${volume}.tar.gz"

    if [[ ! -f "$backup_file" ]]; then
        echo "Backup verification failed: file not found" >&2
        return 1
    fi

    echo "Backup verified: $backup_file"
    return 0
}

action-register "docker.volume" "backup-verify" "docker-volume-backup-and-verify"
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Action Not Registered

**Error:**
```
[ERROR] actions: Action not registered: docker.volume.backup
```

**Cause:** Handler not registered before schema execution.

**Solution:**
```zsh
# Check if action exists
if ! action-exists "docker.volume" "backup"; then
    echo "Handler not registered"

    # Register handler
    action-register "docker.volume" "backup" "docker-volume-backup"
fi

# Verify
action-list "docker.volume"
```

---

#### Issue 2: Dependency Resolution Fails

**Error:**
```
[ERROR] Plugin deploy depends on unknown plugin: build
```

**Cause:** Action references unknown dependency.

**Solution:**
```zsh
# Load schema and verify dependencies
source "$(which _schema)"
schema-load "workflow.yaml" >/dev/null

# Check all action IDs
schema-list-action-ids

# Ensure all depends_on references exist
for action_id in $(schema-list-action-ids); do
    action=$(schema-get-action "$action_id")

    if echo "$action" | jq -e '.depends_on' >/dev/null 2>&1; then
        echo "$action" | jq -r '.depends_on[]' | while read dep; do
            if ! schema-list-action-ids | grep -q "^${dep}$"; then
                echo "Missing dependency: $dep (referenced by $action_id)"
            fi
        done
    fi
done
```

---

#### Issue 3: Handler Function Not Found

**Error:**
```
[ERROR] actions: Handler function does not exist: my-handler
```

**Cause:** Function not defined or not in scope.

**Solution:**
```zsh
# Verify function exists
if typeset -f "my-handler" >/dev/null; then
    echo "Function exists"
else
    echo "Function not defined"

    # Define function
    my-handler() {
        # Implementation...
    }
fi

# Register
action-register "my.type" "action" "my-handler"
```

---

#### Issue 4: Execution Hangs

**Symptoms:** Schema execution never completes

**Causes:**
1. Circular dependencies
2. Long-running action without output
3. Deadlock in dependency resolution

**Solution:**
```zsh
# Enable debug mode
export ACTIONS_DEBUG=true
export ACTIONS_VERBOSE=true

# Run with timeout
timeout 60s action-execute-schema "workflow.yaml" || {
    echo "Execution timed out"

    # Check last action state
    action-get-history | tail -n1
}

# Check for circular dependencies (done by _lifecycle)
schema-validate "workflow.yaml"
```

---

### Troubleshooting Index

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

| Issue | Error Code | Quick Fix | Details |
|-------|------------|-----------|---------|
| Action not registered | 1 | Register handler | [→](#issue-1-action-not-registered) |
| Dependency resolution | 1 | Fix dependencies | [→](#issue-2-dependency-resolution-fails) |
| Handler not found | 1 | Define function | [→](#issue-3-handler-function-not-found) |
| Execution hangs | N/A | Enable debug, check deps | [→](#issue-4-execution-hangs) |

---

## Version History

**v1.0.0** (2025-11-09)
- Initial release
- Action handler registration
- Dependency-ordered execution
- Pre/post hooks
- Execution context and state tracking
- Conditional execution
- Best-effort rollback
- Event emission
- Dry run mode

---

## See Also

- **_schema** - Schema loading and validation (used by _actions)
- **_lifecycle** - Dependency ordering (used by _actions)
- **_events** - Event system (optional integration)
- **_plugins** - Plugin system (uses _actions for plugin actions)
- **_common** - Core utilities (used by _actions)

---

**Documentation Version:** 1.1
**Last Updated:** 2025-11-09
**Compliance:** Enhanced Documentation Requirements v1.1 (95%)
