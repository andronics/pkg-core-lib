# _schema - Schema Loading, Validation, and Parsing for action/v1

**Lines:** 3,245 | **Functions:** 38 | **Examples:** 89 | **Source Lines:** 962
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_schema`
**Enhanced Documentation Requirements:** v1.1 | **Compliance:** 95%

---

## Quick Access Index

### Compact References (Lines 10-350)
- [Function Reference](#function-quick-reference) - 38 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 13 variables
- [Return Codes](#return-codes-quick-reference) - Standard codes
- [Schema Format](#schema-format-action-v1) - action/v1 schema specification

### Main Sections
- [Overview](#overview) (Lines 350-450, ~100 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 450-550, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 550-800, ~250 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 800-950, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 950-2500, ~1550 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2500-2850, ~350 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2850-3150, ~300 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: schema_api -->

**Feature Detection:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-has-yaml` | Check if YAML parsing is available | 187-189 | O(1) | [→](#schema-has-yaml) |
| `schema-has-json` | Check if JSON parsing is available | 192-194 | O(1) | [→](#schema-has-json) |

**Schema Loading:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-detect-format` | Detect schema format (YAML/JSON) | 243-269 | O(1) | [→](#schema-detect-format) |
| `schema-load-file` | Load and parse schema file to JSON | 272-318 | O(n) | [→](#schema-load-file) |
| `schema-load` | Load schema with template expansion | 321-375 | O(n) | [→](#schema-load) |

**Schema Validation:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-validate` | Validate complete schema structure | 512-554 | O(n*m) | [→](#schema-validate) |
| `_schema-validate-structure` | Validate top-level schema structure | 382-423 | O(1) | Internal |
| `_schema-validate-action` | Validate individual action | 426-471 | O(1) | Internal |
| `_schema-validate-dependencies` | Validate action dependencies | 474-509 | O(n²) | Internal |

**Schema Querying:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-get` | Get schema field value | 561-581 | O(1) | [→](#schema-get) |
| `schema-get-version` | Get schema version | 584-586 | O(1) | [→](#schema-get-version) |
| `schema-get-metadata` | Get metadata (or specific field) | 589-597 | O(1) | [→](#schema-get-metadata) |
| `schema-get-context` | Get template context | 600-602 | O(1) | [→](#schema-get-context) |
| `schema-get-actions` | Get all actions as JSON array | 605-612 | O(1) | [→](#schema-get-actions) |
| `schema-get-action` | Get specific action by ID | 615-626 | O(n) | [→](#schema-get-action) |
| `schema-get-action-count` | Get number of actions | 629-636 | O(1) | [→](#schema-get-action-count) |
| `schema-list-action-ids` | List all action IDs | 639-646 | O(n) | [→](#schema-list-action-ids) |
| `schema-get-rollback` | Get rollback configuration | 649-651 | O(1) | [→](#schema-get-rollback) |
| `schema-get-config` | Get config value | 654-662 | O(1) | [→](#schema-get-config) |

**Schema Discovery:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-find` | Find schema in search paths | 669-701 | O(n) | [→](#schema-find) |
| `schema-list` | List available schemas | 704-720 | O(n) | [→](#schema-list) |

**Schema Cache:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-cache-set` | Cache schema by name | 727-735 | O(1) | [→](#schema-cache-set) |
| `schema-cache-get` | Get cached schema | 738-749 | O(1) | [→](#schema-cache-get) |
| `schema-cache-clear` | Clear schema cache | 752-755 | O(1) | [→](#schema-cache-clear) |

**Utility Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-clear` | Clear current schema | 762-765 | O(1) | [→](#schema-clear) |
| `schema-get-error` | Get last error message | 768-770 | O(1) | [→](#schema-get-error) |
| `schema-clear-error` | Clear last error | 773-775 | O(1) | [→](#schema-clear-error) |
| `schema-dump` | Pretty-print current schema | 778-785 | O(n) | [→](#schema-dump) |

**Information & Help:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `schema-stats` | Display statistics | 791-802 | O(1) | [→](#schema-stats) |
| `schema-help` | Display comprehensive help | 808-921 | O(1) | [→](#schema-help) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `_schema-log-debug` | Debug logging | 157-160 | O(1) | Internal |
| `_schema-log-verbose` | Verbose logging | 162-165 | O(1) | Internal |
| `_schema-log-error` | Error logging | 167-171 | O(1) | Internal |
| `_schema-log-warning` | Warning logging | 173-175 | O(1) | Internal |
| `_schema-log-success` | Success logging | 177-180 | O(1) | Internal |
| `_schema-parse-yaml-yq` | Parse YAML using yq | 201-204 | O(n) | Internal |
| `_schema-parse-yaml-python` | Parse YAML using Python | 207-210 | O(n) | Internal |
| `_schema-parse-yaml` | Auto-detect YAML parser | 213-224 | O(n) | Internal |
| `_schema-parse-json` | Parse JSON using jq | 227-236 | O(n) | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Variable | Type | Default | Description | Source Lines |
|----------|------|---------|-------------|--------------|
| `SCHEMA_DIR` | path | `$XDG_DATA_HOME/schemas` | Primary schema directory | 80 |
| `SCHEMA_CACHE_DIR` | path | `$XDG_CACHE_HOME/schemas` | Cache directory | 81 |
| `SCHEMA_SEARCH_PATHS` | string | `` | Colon-separated search paths | 84 |
| `SCHEMA_STRICT` | boolean | `true` | Enable strict validation | 87 |
| `SCHEMA_VALIDATE_DEPS` | boolean | `true` | Validate action dependencies | 88 |
| `SCHEMA_ALLOW_UNKNOWN_FIELDS` | boolean | `false` | Allow unknown fields | 89 |
| `SCHEMA_VERBOSE` | boolean | `false` | Verbose output | 92 |
| `SCHEMA_DEBUG` | boolean | `false` | Debug output | 93 |
| `SCHEMA_EXPAND_TEMPLATES` | boolean | `true` | Expand templates on load | 94 |
| `SCHEMA_SUPPORTED_VERSIONS` | string | `action/v1` | Supported schema versions | 97 |
| `SCHEMA_VERSION` | string (readonly) | `1.0.0` | Extension version | 44 |
| `SCHEMA_LOADED` | boolean (readonly) | `1` | Extension loaded flag | 45 |
| `SCHEMA_LAST_ERROR` | string | `` | Last error message | 118 |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Code | Meaning | Description | Common Functions |
|------|---------|-------------|------------------|
| `0` | Success | Operation completed successfully | All functions |
| `1` | General error | Operation failed (validation, execution) | Most functions |
| `2` | Invalid arguments | Missing or invalid parameters | Functions with required params |
| `3` | Parse error | Failed to parse YAML/JSON | `schema-load-file`, `schema-load` |
| `4` | Not found | Schema file not found | `schema-load-file`, `schema-find` |
| `6` | Missing dependency | Required tool not available (yq, jq) | Parser functions |

---

## Schema Format: action/v1

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

The `action/v1` schema format is the standard for defining declarative action sequences:

```yaml
schema: "action/v1"                   # Required: Schema version
version: "1.0.0"                      # Optional: Schema file version

metadata:                             # Optional: Schema metadata
  name: "schema-name"
  description: "Schema description"
  author: "Author name"
  created: "2025-11-09"

context:                              # Optional: Template context
  environment: "production"
  project_root: "/path/to/project"
  custom_var: "value"

actions:                              # Required: Action sequence
  - id: "action_id"                   # Required: Unique action ID
    type: "plugin.resource"           # Required: Type (plugin.resource format)
    resource: "resource_name"         # Required: Resource name
    # OR
    selector:                         # Alternative to resource
      label: "key=value"
    action: "operation"               # Required: Operation name
    params:                           # Optional: Action parameters
      key: "value"
      nested:
        key: "value"
    depends_on:                       # Optional: Dependencies
      - "previous_action_id"
    conditions:                       # Optional: Conditions
      - expression: "{{ .environment }}"
        on_false: "skip"              # skip|warn|fail
    on_error: "fail"                  # Optional: fail|warn|ignore
    store_result_as: "var_name"       # Optional: Store result in context

config:                               # Optional: Global config
  on_failure: "stop"                  # stop|continue
  parallel: false                     # Parallel execution

rollback:                             # Optional: Rollback config
  enabled: true
  actions:                            # Rollback actions
    - id: "rollback_id"
      type: "plugin.resource"
      resource: "name"
      action: "rollback"
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Overview

The `_schema` extension is the core schema engine for the declarative action system. It provides comprehensive YAML/JSON schema loading, validation, template expansion, and query capabilities for the `action/v1` schema format.

**Key Features:**
- **Multiple Format Support:** YAML and JSON schema parsing
- **Auto-Detection:** Automatic format detection by extension or content
- **Template Expansion:** Integrated with `_template` for dynamic schemas
- **Schema Validation:** Comprehensive validation with dependency checking
- **Flexible Parsing:** Support for yq or Python YAML parsing
- **Query API:** Rich query interface for schema inspection
- **Discovery:** Schema search across multiple directories
- **Caching:** Built-in schema caching for performance
- **Error Handling:** Detailed error messages and validation reporting

**Dependencies:**
- **Required:** `_common`, `_validation`, `_template`
- **Required Tools:** `yq` or `python3+PyYAML` (for YAML), `jq` (for JSON)

**Architecture Position:**
- **Layer:** Infrastructure (Layer 2)
- **Used By:** `_actions`, `_plugins`, action-driven utilities
- **Uses:** `_common`, `_validation`, `_template`

**Use Cases:**
- Loading declarative action schemas for execution
- Validating schema structure before execution
- Template-driven schema generation
- Schema discovery and management
- Action dependency analysis

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
## Installation

### Prerequisites

The `_schema` extension requires:

1. **Core Dependencies:**
   ```bash
   # Available in ~/.local/bin/lib/ via stow
   source "$(which _common)"
   source "$(which _validation)"
   source "$(which _template)"
   ```

2. **External Tools (at least one YAML parser):**
   ```bash
   # Option 1: yq (recommended)
   sudo pacman -S yq  # Arch/Manjaro
   brew install yq    # macOS

   # Option 2: Python with PyYAML
   sudo pacman -S python-yaml  # Arch/Manjaro
   pip install PyYAML          # pip

   # Required for JSON support
   sudo pacman -S jq
   ```

### Installation via Stow

```bash
# Install library (if not already done)
cd ~/.pkgs
stow lib

# Verify installation
source "$(which _schema)"
schema-stats
```

### Verification

```bash
# Check YAML support
schema-has-yaml && echo "YAML support available" || echo "No YAML support"

# Check JSON support
schema-has-json && echo "JSON support available" || echo "No JSON support"

# Test basic functionality
schema-stats
```

**Expected Output:**
```
Schema Engine Statistics:
  Version: 1.0.0
  YAML Support: Yes
  JSON Support: Yes
  Total Loads: 0
  Total Validations: 0
  Total Errors: 0
  Cached Schemas: 0
  Current Schema: none
  Strict Mode: true
```

---

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
## Quick Start

### Example 1: Basic Schema Loading

**Schema File:** `hello.yaml`
```yaml
schema: "action/v1"
version: "1.0.0"

metadata:
  name: "hello-world"
  description: "Simple hello world schema"

actions:
  - id: "greet"
    type: "shell.command"
    resource: "echo"
    action: "execute"
    params:
      args: ["Hello, World!"]
```

**Load and Query:**
```zsh
source "$(which _schema)"

# Load schema
schema-load "hello.yaml"

# Get version
schema-get-version
# Output: action/v1

# Get metadata
schema-get-metadata "name"
# Output: hello-world

# Get action count
schema-get-action-count
# Output: 1

# List action IDs
schema-list-action-ids
# Output: greet

# Get specific action
schema-get-action "greet"
# Output: JSON representation of action
```

### Example 2: Schema Validation

```zsh
source "$(which _schema)"

# Validate schema file
if schema-validate "myschema.yaml"; then
    echo "Schema is valid"
    # Proceed with loading
    schema-load "myschema.yaml"
else
    echo "Schema validation failed"
    # Get error details
    schema-get-error
fi
```

**Example Validation Errors:**
```
[ERROR] schema: Missing required field: schema
[ERROR] schema: Field 'actions' must be an array
[ERROR] schema: Action #0: Missing required field 'id'
[ERROR] schema: Action 'backup': Unknown dependency 'prepare'
```

### Example 3: Template Expansion

**Schema with Templates:** `deploy.yaml`
```yaml
schema: "action/v1"
version: "1.0.0"

metadata:
  name: "deployment"

context:
  environment: "production"
  app_name: "myapp"
  replica_count: 3

actions:
  - id: "deploy-app"
    type: "k8s.deployment"
    resource: "{{ .app_name }}"
    action: "apply"
    params:
      replicas: "{{ .replica_count }}"
      namespace: "{{ .environment }}"
```

**Load with Template Expansion:**
```zsh
source "$(which _schema)"

# Load schema (templates auto-expanded)
schema-load "deploy.yaml"

# Get expanded action
action=$(schema-get-action "deploy-app")
echo "$action" | jq '.resource'
# Output: "myapp"

echo "$action" | jq '.params.replicas'
# Output: "3"
```

### Example 4: Schema Discovery

```zsh
source "$(which _schema)"

# Set search paths
export SCHEMA_SEARCH_PATHS="./schemas:./configs"

# Find schema by name
schema_path=$(schema-find "docker-teardown.yaml")
if [[ -n "$schema_path" ]]; then
    echo "Found schema at: $schema_path"
    schema-load "$schema_path"
fi

# List all available schemas
schema-list "*.yaml"
```

### Example 5: Working with Actions

```zsh
source "$(which _schema)"

# Load schema
schema-load "complex-workflow.yaml"

# Get all actions
actions=$(schema-get-actions)

# Count actions
count=$(schema-get-action-count)
echo "Total actions: $count"

# Iterate over actions
for action_id in $(schema-list-action-ids); do
    echo "Processing action: $action_id"

    # Get action details
    action=$(schema-get-action "$action_id")

    # Extract fields
    type=$(echo "$action" | jq -r '.type')
    resource=$(echo "$action" | jq -r '.resource')

    echo "  Type: $type"
    echo "  Resource: $resource"
done
```

### Example 6: Dependency Validation

**Schema with Dependencies:** `workflow.yaml`
```yaml
schema: "action/v1"
actions:
  - id: "prepare"
    type: "shell.command"
    resource: "echo"
    action: "execute"

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

**Validate:**
```zsh
source "$(which _schema)"

# Enable dependency validation
export SCHEMA_VALIDATE_DEPS=true

# Validate schema
if schema-validate "workflow.yaml"; then
    echo "All dependencies valid"
else
    # Will report unknown dependencies
    schema-get-error
fi
```

### Example 7: Schema Caching

```zsh
source "$(which _schema)"

# Load and cache schema
schema_json=$(schema-load-file "myschema.yaml")
schema-cache-set "myschema" "$schema_json"

# Later, retrieve from cache
cached=$(schema-cache-get "myschema")
if [[ -n "$cached" ]]; then
    echo "Using cached schema"
    _SCHEMA_CURRENT[json]="$cached"
fi

# Clear cache when needed
schema-cache-clear
```

### Example 8: Error Handling

```zsh
source "$(which _schema)"

# Clear previous errors
schema-clear-error

# Attempt schema load
if ! schema-load "myschema.yaml"; then
    # Get detailed error
    error=$(schema-get-error)
    echo "Schema load failed: $error"

    # Check statistics
    schema-stats
    exit 1
fi

# Clear error after handling
schema-clear-error
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->
## Configuration

### Environment Variables

#### Directory Configuration

```zsh
# Primary schema directory (default: $XDG_DATA_HOME/schemas)
export SCHEMA_DIR="$HOME/.local/share/schemas"

# Cache directory (default: $XDG_CACHE_HOME/schemas)
export SCHEMA_CACHE_DIR="$HOME/.cache/schemas"

# Additional search paths (colon-separated)
export SCHEMA_SEARCH_PATHS="/usr/share/schemas:./local-schemas"
```

#### Validation Configuration

```zsh
# Enable strict validation (default: true)
export SCHEMA_STRICT=true

# Validate action dependencies (default: true)
export SCHEMA_VALIDATE_DEPS=true

# Allow unknown fields in schema (default: false)
export SCHEMA_ALLOW_UNKNOWN_FIELDS=false
```

#### Behavior Configuration

```zsh
# Enable verbose output (default: false)
export SCHEMA_VERBOSE=true

# Enable debug logging (default: false)
export SCHEMA_DEBUG=true

# Enable template expansion (default: true)
export SCHEMA_EXPAND_TEMPLATES=true
```

### Configuration Files

The `_schema` extension uses directories but not configuration files. Schemas are stored in:

```
$SCHEMA_DIR/              # Primary schemas
  └── *.yaml              # Schema files
  └── *.json              # JSON schemas

$SCHEMA_CACHE_DIR/        # Cached schemas
  └── *.json              # Parsed schema cache
```

### Search Path Resolution

Schema discovery searches in this order:

1. **Current Directory:** `./schema-name.yaml`
2. **Schema Directory:** `$SCHEMA_DIR/schema-name.yaml`
3. **Search Paths:** Each path in `$SCHEMA_SEARCH_PATHS`

**Example:**
```zsh
export SCHEMA_SEARCH_PATHS="/etc/schemas:/usr/local/share/schemas"

# Will search:
# 1. ./myschema.yaml
# 2. ~/.local/share/schemas/myschema.yaml
# 3. /etc/schemas/myschema.yaml
# 4. /usr/local/share/schemas/myschema.yaml
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: api_core -->
## API Reference

### Feature Detection Functions

#### `schema-has-yaml`

**Source:** Lines 187-189
**Complexity:** O(1)
**Dependencies:** None

Check if YAML parsing support is available.

**Signature:**
```zsh
schema-has-yaml
```

**Returns:**
- `0` - YAML support available (yq or Python+PyYAML)
- `1` - YAML support not available

**Example:**
```zsh
if schema-has-yaml; then
    echo "YAML schemas supported"
else
    echo "Install yq or python3-yaml for YAML support"
    exit 1
fi
```

**Example: Conditional Loading:**
```zsh
if schema-has-yaml; then
    schema-load "config.yaml"
elif schema-has-json; then
    schema-load "config.json"
else
    echo "No parser available" >&2
    exit 6
fi
```

---

#### `schema-has-json`

**Source:** Lines 192-194
**Complexity:** O(1)
**Dependencies:** None

Check if JSON parsing support is available.

**Signature:**
```zsh
schema-has-json
```

**Returns:**
- `0` - JSON support available (jq installed)
- `1` - JSON support not available

**Example:**
```zsh
if schema-has-json; then
    echo "JSON schemas supported"
else
    echo "Install jq for JSON support"
    exit 1
fi
```

---

<!-- CONTEXT_GROUP: api_loading -->
### Schema Loading Functions

#### `schema-detect-format`

**Source:** Lines 243-269
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Detect schema format based on file extension or content.

**Signature:**
```zsh
schema-detect-format <file>
```

**Parameters:**
- `file` - Path to schema file (required)

**Returns:**
- `0` - Success, format detected
- `2` - Invalid arguments

**Output:** `yaml` or `json`

**Detection Logic:**
1. Check file extension (`.yaml`, `.yml`, `.json`)
2. If extension unknown, check first line for `{` (JSON)
3. Default to `yaml` if undetermined

**Example:**
```zsh
format=$(schema-detect-format "myschema.yaml")
echo "Detected format: $format"
# Output: yaml
```

**Example: Format-Specific Handling:**
```zsh
format=$(schema-detect-format "$schema_file")
case "$format" in
    yaml)
        echo "Processing YAML schema"
        ;;
    json)
        echo "Processing JSON schema"
        ;;
esac
```

---

#### `schema-load-file`

**Source:** Lines 272-318
**Complexity:** O(n) - Linear in file size
**Dependencies:** `schema-detect-format`, `schema-has-yaml`, `schema-has-json`

Load schema file and parse to JSON (without template expansion).

**Signature:**
```zsh
schema-load-file <file>
```

**Parameters:**
- `file` - Path to schema file (required)

**Returns:**
- `0` - Success, outputs JSON to stdout
- `2` - Invalid arguments
- `3` - Parse error
- `4` - File not found
- `6` - Missing required parser (yq, jq, python3+PyYAML)

**Output:** Parsed schema as JSON string

**Example:**
```zsh
schema_json=$(schema-load-file "myschema.yaml")
if [[ $? -eq 0 ]]; then
    echo "Schema loaded successfully"
    echo "$schema_json" | jq '.metadata.name'
fi
```

**Example: Error Handling:**
```zsh
if ! schema_json=$(schema-load-file "config.yaml" 2>&1); then
    case $? in
        3) echo "Parse error: Invalid YAML/JSON" ;;
        4) echo "File not found" ;;
        6) echo "Parser not available" ;;
    esac
    exit 1
fi
```

**Example: Direct jq Processing:**
```zsh
schema_json=$(schema-load-file "myschema.yaml")
action_count=$(echo "$schema_json" | jq '.actions | length')
echo "Actions: $action_count"
```

---

#### `schema-load`

**Source:** Lines 321-375
**Complexity:** O(n) - Linear in file size + template expansion
**Dependencies:** `schema-load-file`, `template-render`, `template-context-set`

Load schema with automatic template expansion and set as current schema.

**Signature:**
```zsh
schema-load <file>
```

**Parameters:**
- `file` - Path to schema file (required)

**Returns:**
- `0` - Success, outputs expanded JSON, sets `_SCHEMA_CURRENT`
- `2` - Invalid arguments
- `3` - Parse or template expansion error
- `4` - File not found
- `6` - Missing parser

**Side Effects:**
- Sets `_SCHEMA_CURRENT[json]` to loaded schema
- Sets `_SCHEMA_CURRENT[file]` to file path
- Increments `_SCHEMA_TOTAL_LOADS` counter

**Output:** Expanded schema as JSON string

**Example:**
```zsh
# Load schema with template expansion
schema-load "deployment.yaml"

# Query the loaded schema
name=$(schema-get-metadata "name")
echo "Loaded schema: $name"
```

**Example: Template Context:**
```yaml
# schema.yaml
context:
  env: "production"
  replicas: 3

actions:
  - id: "deploy"
    params:
      environment: "{{ .env }}"
      count: "{{ .replicas }}"
```

```zsh
schema-load "schema.yaml"
action=$(schema-get-action "deploy")
echo "$action" | jq '.params.environment'
# Output: "production"
```

**Example: Disable Template Expansion:**
```zsh
export SCHEMA_EXPAND_TEMPLATES=false
schema-load "raw-schema.yaml"
# Templates not expanded, raw {{ .var }} preserved
```

**Performance Note:** Template expansion adds overhead. For schemas without templates, consider `schema-load-file` for faster loading.

---

<!-- CONTEXT_GROUP: api_validation -->
### Schema Validation Functions

#### `schema-validate`

**Source:** Lines 512-554
**Complexity:** O(n*m) - n actions, m dependencies each
**Dependencies:** `schema-load-file`, validation internal functions

Comprehensively validate schema structure, actions, and dependencies.

**Signature:**
```zsh
schema-validate <file>
```

**Parameters:**
- `file` - Path to schema file (required)

**Returns:**
- `0` - Validation passed
- `1` - Validation failed (errors reported)
- `2` - Invalid arguments
- Other - From `schema-load-file`

**Side Effects:**
- Increments `_SCHEMA_TOTAL_VALIDATIONS`
- Sets `SCHEMA_LAST_ERROR` on failure

**Validation Checks:**
1. **Structure:** Required fields (`schema`, `actions`)
2. **Schema Version:** Must be supported (`action/v1`)
3. **Actions:** Each action has required fields
4. **Action Format:** IDs (kebab-case), types (plugin.resource)
5. **Dependencies:** All `depends_on` references exist
6. **Circular Deps:** (Detected at execution time by _lifecycle)

**Example:**
```zsh
if schema-validate "myschema.yaml"; then
    echo "✓ Schema validation passed"
    schema-load "myschema.yaml"
else
    echo "✗ Schema validation failed"
    schema-get-error
    exit 1
fi
```

**Example: Validation Report:**
```zsh
export SCHEMA_VERBOSE=true
schema-validate "complex-schema.yaml" 2>&1 | tee validation-report.txt

if [[ $? -ne 0 ]]; then
    echo "Validation errors found, see report"
    exit 1
fi
```

**Example: Disable Dependency Validation:**
```zsh
export SCHEMA_VALIDATE_DEPS=false
schema-validate "schema.yaml"
# Skips dependency checking for faster validation
```

**Common Validation Errors:**

```
# Missing required field
[ERROR] schema: Missing required field: schema
[ERROR] schema: Missing required field: actions

# Invalid schema version
[ERROR] schema: Unsupported schema version: action/v2 (supported: action/v1)

# Action errors
[ERROR] schema: Action #0: Missing required field 'id'
[ERROR] schema: Action #1: Type must be in format 'plugin.resource': invalid-type

# Dependency errors
[ERROR] schema: Action 'deploy': Unknown dependency 'build'
```

---

<!-- CONTEXT_GROUP: api_querying -->
### Schema Querying Functions

#### `schema-get`

**Source:** Lines 561-581
**Complexity:** O(1)
**Dependencies:** `common-validate-required`, jq

Get any field value from the current schema using JSONPath syntax.

**Signature:**
```zsh
schema-get <field> [default]
```

**Parameters:**
- `field` - JSONPath field selector (required)
- `default` - Default value if field not found (optional)

**Returns:**
- `0` - Field found and returned
- `1` - Field not found, default returned
- `2` - Invalid arguments

**Output:** Field value or default

**Example:**
```zsh
# Get top-level field
version=$(schema-get "version" "unknown")
echo "Version: $version"

# Get nested field
author=$(schema-get "metadata.author" "unknown")
echo "Author: $author"

# Get array element
first_action=$(schema-get "actions[0].id")
echo "First action: $first_action"
```

**Example: Complex Queries:**
```zsh
# Get config value with default
on_failure=$(schema-get "config.on_failure" "stop")

# Get rollback setting
rollback_enabled=$(schema-get "rollback.enabled" "false")

# Check for optional field
if description=$(schema-get "metadata.description"); then
    echo "Description: $description"
else
    echo "No description provided"
fi
```

**Error Handling:**
```zsh
# No schema loaded
schema-get "version"
# Output: (empty)
# Return: 1
# Error: [ERROR] schema: No schema loaded
```

---

#### `schema-get-version`

**Source:** Lines 584-586
**Complexity:** O(1)
**Dependencies:** `schema-get`

Get schema version (action/v1, etc).

**Signature:**
```zsh
schema-get-version
```

**Returns:**
- `0` - Version found
- `1` - No schema loaded or no version field

**Output:** Schema version string

**Example:**
```zsh
version=$(schema-get-version)
if [[ "$version" == "action/v1" ]]; then
    echo "Supported schema version"
else
    echo "Unsupported version: $version"
    exit 1
fi
```

---

#### `schema-get-metadata`

**Source:** Lines 589-597
**Complexity:** O(1)
**Dependencies:** `schema-get`

Get metadata object or specific metadata field.

**Signature:**
```zsh
schema-get-metadata [field]
```

**Parameters:**
- `field` - Specific metadata field (optional)

**Returns:**
- `0` - Metadata found
- `1` - No metadata or field not found

**Output:** Metadata JSON or field value

**Example:**
```zsh
# Get entire metadata object
metadata=$(schema-get-metadata)
echo "$metadata" | jq '.name'

# Get specific field
name=$(schema-get-metadata "name")
description=$(schema-get-metadata "description")
author=$(schema-get-metadata "author")

echo "Schema: $name"
echo "Description: $description"
echo "By: $author"
```

**Example: Metadata Display:**
```zsh
echo "=== Schema Metadata ==="
echo "Name: $(schema-get-metadata 'name')"
echo "Version: $(schema-get-metadata 'version')"
echo "Description: $(schema-get-metadata 'description')"
echo "Author: $(schema-get-metadata 'author')"
echo "Created: $(schema-get-metadata 'created')"
```

---

#### `schema-get-context`

**Source:** Lines 600-602
**Complexity:** O(1)
**Dependencies:** `schema-get`

Get template context object.

**Signature:**
```zsh
schema-get-context
```

**Returns:**
- `0` - Context found
- `1` - No context in schema

**Output:** Context JSON object

**Example:**
```zsh
context=$(schema-get-context)
if [[ -n "$context" ]] && [[ "$context" != "null" ]]; then
    echo "Template context available:"
    echo "$context" | jq '.'
else
    echo "No template context"
fi
```

**Example: Extract Context Variables:**
```zsh
context=$(schema-get-context)
environment=$(echo "$context" | jq -r '.environment')
app_name=$(echo "$context" | jq -r '.app_name')

echo "Deploying $app_name to $environment"
```

---

#### `schema-get-actions`

**Source:** Lines 605-612
**Complexity:** O(1)
**Dependencies:** jq

Get all actions as JSON array.

**Signature:**
```zsh
schema-get-actions
```

**Returns:**
- `0` - Actions retrieved
- `1` - No schema loaded

**Output:** JSON array of all actions

**Example:**
```zsh
actions=$(schema-get-actions)
echo "$actions" | jq -r '.[].id'
# Output: List of all action IDs
```

**Example: Iterate Actions:**
```zsh
actions=$(schema-get-actions)
count=$(echo "$actions" | jq 'length')

for ((i=0; i<count; i++)); do
    action=$(echo "$actions" | jq -r ".[$i]")
    id=$(echo "$action" | jq -r '.id')
    type=$(echo "$action" | jq -r '.type')

    echo "[$i] $id ($type)"
done
```

**Example: Filter Actions:**
```zsh
actions=$(schema-get-actions)

# Get only docker.volume actions
docker_actions=$(echo "$actions" | jq '[.[] | select(.type == "docker.volume")]')

# Get actions with dependencies
dependent_actions=$(echo "$actions" | jq '[.[] | select(.depends_on)]')
```

---

#### `schema-get-action`

**Source:** Lines 615-626
**Complexity:** O(n) - Linear search through actions
**Dependencies:** `common-validate-required`, jq

Get specific action by ID.

**Signature:**
```zsh
schema-get-action <action_id>
```

**Parameters:**
- `action_id` - Action ID to retrieve (required)

**Returns:**
- `0` - Action found
- `1` - No schema loaded or action not found
- `2` - Invalid arguments

**Output:** Action JSON object

**Example:**
```zsh
action=$(schema-get-action "deploy-app")
if [[ -n "$action" ]] && [[ "$action" != "null" ]]; then
    echo "Action found:"
    echo "$action" | jq '.'
else
    echo "Action not found: deploy-app"
fi
```

**Example: Extract Action Fields:**
```zsh
action=$(schema-get-action "backup-volume")

id=$(echo "$action" | jq -r '.id')
type=$(echo "$action" | jq -r '.type')
resource=$(echo "$action" | jq -r '.resource')
action_name=$(echo "$action" | jq -r '.action')
params=$(echo "$action" | jq -r '.params')

echo "Action: $id"
echo "Type: $type"
echo "Resource: $resource"
echo "Operation: $action_name"
echo "Parameters:"
echo "$params" | jq '.'
```

---

#### `schema-get-action-count`

**Source:** Lines 629-636
**Complexity:** O(1)
**Dependencies:** jq

Get total number of actions in schema.

**Signature:**
```zsh
schema-get-action-count
```

**Returns:**
- `0` - Count retrieved
- `1` - No schema loaded

**Output:** Number of actions (integer)

**Example:**
```zsh
count=$(schema-get-action-count)
echo "Schema contains $count actions"

if [[ $count -eq 0 ]]; then
    echo "Warning: Empty schema"
fi
```

**Example: Conditional Processing:**
```zsh
count=$(schema-get-action-count)

if [[ $count -gt 10 ]]; then
    echo "Large schema detected, enabling progress reporting"
    export SCHEMA_VERBOSE=true
fi
```

---

#### `schema-list-action-ids`

**Source:** Lines 639-646
**Complexity:** O(n)
**Dependencies:** jq

List all action IDs in order.

**Signature:**
```zsh
schema-list-action-ids
```

**Returns:**
- `0` - IDs listed
- `1` - No schema loaded

**Output:** Action IDs, one per line

**Example:**
```zsh
echo "Actions in schema:"
schema-list-action-ids | while IFS= read -r id; do
    echo "  - $id"
done
```

**Example: Verify Actions Exist:**
```zsh
required_actions=("prepare" "build" "test" "deploy")

for required in "${required_actions[@]}"; do
    if ! schema-list-action-ids | grep -q "^${required}$"; then
        echo "Missing required action: $required"
        exit 1
    fi
done

echo "All required actions present"
```

---

#### `schema-get-rollback`

**Source:** Lines 649-651
**Complexity:** O(1)
**Dependencies:** `schema-get`

Get rollback configuration.

**Signature:**
```zsh
schema-get-rollback
```

**Returns:**
- `0` - Rollback config found
- `1` - No rollback config

**Output:** Rollback JSON object

**Example:**
```zsh
rollback=$(schema-get-rollback)
if [[ -n "$rollback" ]] && [[ "$rollback" != "null" ]]; then
    enabled=$(echo "$rollback" | jq -r '.enabled')
    if [[ "$enabled" == "true" ]]; then
        echo "Rollback enabled"
    fi
fi
```

---

#### `schema-get-config`

**Source:** Lines 654-662
**Complexity:** O(1)
**Dependencies:** `schema-get`

Get global config or specific config field.

**Signature:**
```zsh
schema-get-config [field] [default]
```

**Parameters:**
- `field` - Specific config field (optional)
- `default` - Default value (optional)

**Returns:**
- `0` - Config found
- `1` - Config not found

**Output:** Config JSON or field value

**Example:**
```zsh
# Get entire config
config=$(schema-get-config)

# Get specific field
on_failure=$(schema-get-config "on_failure" "stop")
parallel=$(schema-get-config "parallel" "false")

echo "On failure: $on_failure"
echo "Parallel execution: $parallel"
```

---

<!-- CONTEXT_GROUP: api_discovery -->
### Schema Discovery Functions

#### `schema-find`

**Source:** Lines 669-701
**Complexity:** O(n) - Number of search paths
**Dependencies:** `common-validate-required`

Find schema file in current directory, schema directory, or search paths.

**Signature:**
```zsh
schema-find <schema_name>
```

**Parameters:**
- `schema_name` - Schema filename or basename (required)

**Returns:**
- `0` - Schema found, path output
- `2` - Invalid arguments
- `4` - Schema not found

**Output:** Full path to schema file

**Search Order:**
1. Current directory: `./<schema_name>`
2. Schema directory: `$SCHEMA_DIR/<schema_name>`
3. Search paths: `$SCHEMA_SEARCH_PATHS` (each path)

**Example:**
```zsh
schema_path=$(schema-find "docker-teardown.yaml")
if [[ $? -eq 0 ]]; then
    echo "Found schema at: $schema_path"
    schema-load "$schema_path"
else
    echo "Schema not found"
    exit 4
fi
```

**Example: Search Path Configuration:**
```zsh
export SCHEMA_SEARCH_PATHS="/etc/schemas:/usr/share/schemas"

# Will search:
# 1. ./myschema.yaml
# 2. ~/.local/share/schemas/myschema.yaml
# 3. /etc/schemas/myschema.yaml
# 4. /usr/share/schemas/myschema.yaml

schema_path=$(schema-find "myschema.yaml")
```

---

#### `schema-list`

**Source:** Lines 704-720
**Complexity:** O(n) - Number of files matching pattern
**Dependencies:** find

List all schemas matching pattern in search locations.

**Signature:**
```zsh
schema-list [pattern]
```

**Parameters:**
- `pattern` - Filename glob pattern (default: `*.yaml`)

**Returns:**
- `0` - Success (even if no files found)

**Output:** File paths, one per line

**Example:**
```zsh
# List all YAML schemas
schema-list

# List JSON schemas
schema-list "*.json"

# List specific pattern
schema-list "docker-*.yaml"
```

**Example: Schema Inventory:**
```zsh
echo "Available schemas:"
schema-list "*.yaml" | while IFS= read -r schema_file; do
    basename="$(basename "$schema_file")"
    echo "  - $basename"
done
```

**Example: Find and Validate All:**
```zsh
failed=0
schema-list "*.yaml" | while IFS= read -r schema_file; do
    echo "Validating: $schema_file"
    if ! schema-validate "$schema_file" >/dev/null 2>&1; then
        echo "  ✗ FAILED"
        ((failed++))
    else
        echo "  ✓ OK"
    fi
done

if [[ $failed -gt 0 ]]; then
    echo "$failed schema(s) failed validation"
    exit 1
fi
```

---

<!-- CONTEXT_GROUP: api_cache -->
### Schema Cache Functions

#### `schema-cache-set`

**Source:** Lines 727-735
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Store schema JSON in cache by name.

**Signature:**
```zsh
schema-cache-set <name> <schema_json>
```

**Parameters:**
- `name` - Cache key name (required)
- `schema_json` - Schema JSON to cache (required)

**Returns:**
- `0` - Cached successfully
- `2` - Invalid arguments

**Example:**
```zsh
# Load and cache
schema_json=$(schema-load-file "myschema.yaml")
schema-cache-set "myschema" "$schema_json"

# Later retrieval
cached=$(schema-cache-get "myschema")
```

**Example: Cache Multiple Versions:**
```zsh
for env in dev staging prod; do
    schema_json=$(schema-load-file "app-${env}.yaml")
    schema-cache-set "app-${env}" "$schema_json"
done

# Use specific environment
env="prod"
schema_json=$(schema-cache-get "app-${env}")
```

---

#### `schema-cache-get`

**Source:** Lines 738-749
**Complexity:** O(1)
**Dependencies:** `common-validate-required`

Retrieve cached schema by name.

**Signature:**
```zsh
schema-cache-get <name>
```

**Parameters:**
- `name` - Cache key name (required)

**Returns:**
- `0` - Cache hit, schema returned
- `1` - Cache miss
- `2` - Invalid arguments

**Output:** Cached schema JSON

**Example:**
```zsh
if cached=$(schema-cache-get "myschema"); then
    echo "Cache hit, using cached schema"
    _SCHEMA_CURRENT[json]="$cached"
else
    echo "Cache miss, loading from file"
    schema-load "myschema.yaml"
fi
```

---

#### `schema-cache-clear`

**Source:** Lines 752-755
**Complexity:** O(1)
**Dependencies:** None

Clear all cached schemas.

**Signature:**
```zsh
schema-cache-clear
```

**Returns:**
- `0` - Cache cleared

**Example:**
```zsh
# Clear cache after updates
schema-cache-clear
echo "Schema cache cleared"
```

**Example: Selective Cache Management:**
```zsh
# Clear and reload
schema-cache-clear

for schema_file in $(schema-list); do
    schema_json=$(schema-load-file "$schema_file")
    basename="$(basename "$schema_file" .yaml)"
    schema-cache-set "$basename" "$schema_json"
done

echo "Cache rebuilt with $(wc -l <<< "$(schema-list)") schemas"
```

---

<!-- CONTEXT_GROUP: api_utility -->
### Utility Functions

#### `schema-clear`

**Source:** Lines 762-765
**Complexity:** O(1)
**Dependencies:** None

Clear currently loaded schema from `_SCHEMA_CURRENT`.

**Signature:**
```zsh
schema-clear
```

**Returns:**
- `0` - Cleared successfully

**Side Effects:**
- Clears `_SCHEMA_CURRENT` associative array

**Example:**
```zsh
# Load schema
schema-load "myschema.yaml"

# Process...

# Clear when done
schema-clear
```

**Example: Load Multiple Sequentially:**
```zsh
for schema_file in *.yaml; do
    schema-clear  # Clear previous
    schema-load "$schema_file"

    # Process current schema
    name=$(schema-get-metadata "name")
    echo "Processing: $name"

    # ... execute actions ...
done
```

---

#### `schema-get-error`

**Source:** Lines 768-770
**Complexity:** O(1)
**Dependencies:** None

Get last error message from schema operations.

**Signature:**
```zsh
schema-get-error
```

**Returns:**
- `0` - Always succeeds

**Output:** Last error message (empty if no error)

**Example:**
```zsh
if ! schema-validate "myschema.yaml"; then
    error=$(schema-get-error)
    echo "Validation failed: $error"
    exit 1
fi
```

**Example: Error Logging:**
```zsh
if ! schema-load "config.yaml" 2>/dev/null; then
    error=$(schema-get-error)
    echo "[$(date)] Schema load failed: $error" >> error.log
    exit 1
fi
```

---

#### `schema-clear-error`

**Source:** Lines 773-775
**Complexity:** O(1)
**Dependencies:** None

Clear last error message.

**Signature:**
```zsh
schema-clear-error
```

**Returns:**
- `0` - Always succeeds

**Example:**
```zsh
schema-clear-error

# Attempt operation
if ! schema-load "myschema.yaml"; then
    # Error is fresh, not from previous operations
    echo "Load error: $(schema-get-error)"
fi
```

---

#### `schema-dump`

**Source:** Lines 778-785
**Complexity:** O(n) - Linear in schema size
**Dependencies:** jq

Pretty-print current schema as formatted JSON.

**Signature:**
```zsh
schema-dump
```

**Returns:**
- `0` - Schema dumped
- `1` - No schema loaded

**Output:** Pretty-printed JSON

**Example:**
```zsh
schema-load "myschema.yaml"
schema-dump > schema-expanded.json
```

**Example: Debug Template Expansion:**
```zsh
echo "=== Original Schema ==="
cat myschema.yaml

echo "=== Expanded Schema ==="
schema-load "myschema.yaml" >/dev/null
schema-dump

# Compare to see template expansion results
```

---

#### `schema-stats`

**Source:** Lines 791-802
**Complexity:** O(1)
**Dependencies:** None

Display schema engine statistics and configuration.

**Signature:**
```zsh
schema-stats
```

**Returns:**
- `0` - Always succeeds

**Output:** Statistics report

**Example Output:**
```
Schema Engine Statistics:
  Version: 1.0.0
  YAML Support: Yes
  JSON Support: Yes
  Total Loads: 15
  Total Validations: 12
  Total Errors: 2
  Cached Schemas: 3
  Current Schema: myschema.yaml
  Strict Mode: true
```

**Example: Monitoring:**
```zsh
echo "Before processing:"
schema-stats

# Process schemas...

echo "After processing:"
schema-stats
```

---

#### `schema-help`

**Source:** Lines 808-921
**Complexity:** O(1)
**Dependencies:** None

Display comprehensive help documentation.

**Signature:**
```zsh
schema-help
```

**Returns:**
- `0` - Always succeeds

**Output:** Complete help text with:
- Usage examples
- Function reference
- Configuration options
- Schema format documentation
- Dependencies

**Example:**
```zsh
schema-help | less
```

**Example: Extract Specific Section:**
```zsh
# Show only configuration section
schema-help | sed -n '/^Configuration:/,/^$/p'
```

---

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->
## Advanced Usage

### Example 1: Multi-Environment Schema Management

**Directory Structure:**
```
schemas/
  ├── base/
  │   └── app-base.yaml
  ├── dev/
  │   └── app-dev.yaml
  ├── staging/
  │   └── app-staging.yaml
  └── prod/
      └── app-prod.yaml
```

**Implementation:**
```zsh
#!/usr/bin/env zsh
source "$(which _schema)"

# Configure search paths
export SCHEMA_SEARCH_PATHS="./schemas/base:./schemas/$ENVIRONMENT"

# Load environment-specific schema
schema_path=$(schema-find "app-${ENVIRONMENT}.yaml")
if [[ -z "$schema_path" ]]; then
    echo "No schema for environment: $ENVIRONMENT"
    exit 4
fi

echo "Loading schema: $schema_path"
schema-load "$schema_path"

# Verify environment matches
context_env=$(schema-get-context | jq -r '.environment')
if [[ "$context_env" != "$ENVIRONMENT" ]]; then
    echo "Warning: Environment mismatch!"
    exit 1
fi

# Execute actions...
```

### Example 2: Schema Composition

**Base Schema:** `base.yaml`
```yaml
schema: "action/v1"

metadata:
  name: "base-config"

context:
  log_level: "info"
  timeout: 30

actions:
  - id: "setup-logging"
    type: "util.config"
    resource: "logger"
    action: "configure"
    params:
      level: "{{ .log_level }}"
```

**Extended Schema:** Loaded programmatically
```zsh
source "$(which _schema)"

# Load base schema
base_json=$(schema-load-file "base.yaml")

# Load extension schema
ext_json=$(schema-load-file "extensions.yaml")

# Merge schemas (combine actions)
merged_json=$(jq -s '.[0] * .[1] | .actions = (.[0].actions + .[1].actions)' \
    <(echo "$base_json") <(echo "$ext_json"))

# Cache merged schema
schema-cache-set "merged" "$merged_json"

# Set as current
_SCHEMA_CURRENT[json]="$merged_json"
_SCHEMA_CURRENT[file]="merged"

# Validate merged schema
if ! echo "$merged_json" | jq -e '.schema' >/dev/null; then
    echo "Merge validation failed"
    exit 1
fi

echo "Merged schema has $(echo "$merged_json" | jq '.actions | length') actions"
```

### Example 3: Dynamic Schema Generation

```zsh
source "$(which _schema)"
source "$(which _template)"

# Generate schema from template
cat > /tmp/schema-template.yaml <<'EOF'
schema: "action/v1"

metadata:
  name: "{{ .name }}"
  generated: "{{ .timestamp }}"

context:
  environment: "{{ .env }}"

actions:
{{- range .services }}
  - id: "deploy-{{ . }}"
    type: "k8s.deployment"
    resource: "{{ . }}"
    action: "apply"
    params:
      namespace: "{{ $.env }}"
{{- end }}
EOF

# Set template context
template-context-set "name" "auto-generated-deployment"
template-context-set "timestamp" "$(date -Iseconds)"
template-context-set "env" "production"
template-context-set "services" '["api","web","worker"]'

# Render template to schema
schema_yaml=$(gomplate -f /tmp/schema-template.yaml)
echo "$schema_yaml" > /tmp/generated-schema.yaml

# Load and validate
schema-load "/tmp/generated-schema.yaml"
schema-validate "/tmp/generated-schema.yaml"

echo "Generated schema with $(schema-get-action-count) actions"
```

### Example 4: Schema Preprocessing Pipeline

```zsh
#!/usr/bin/env zsh
source "$(which _schema)"

# Pipeline: validate → expand → cache → execute
process_schema() {
    local schema_file="$1"
    local cache_name="$2"

    echo "=== Schema Processing Pipeline ==="
    echo "File: $schema_file"

    # Step 1: Validate
    echo "[1/4] Validating..."
    if ! schema-validate "$schema_file"; then
        echo "✗ Validation failed"
        return 1
    fi
    echo "✓ Valid"

    # Step 2: Load (with template expansion)
    echo "[2/4] Loading and expanding templates..."
    if ! schema_json=$(schema-load "$schema_file"); then
        echo "✗ Load failed"
        return 1
    fi
    echo "✓ Loaded"

    # Step 3: Cache
    echo "[3/4] Caching..."
    schema-cache-set "$cache_name" "$schema_json"
    echo "✓ Cached as: $cache_name"

    # Step 4: Summary
    echo "[4/4] Summary:"
    echo "  Actions: $(schema-get-action-count)"
    echo "  Version: $(schema-get-version)"
    echo "  Name: $(schema-get-metadata 'name')"

    echo "=== Pipeline Complete ==="
    return 0
}

# Process multiple schemas
for schema_file in schemas/*.yaml; do
    cache_name=$(basename "$schema_file" .yaml)
    process_schema "$schema_file" "$cache_name" || exit 1
done
```

### Example 5: Schema Introspection and Reporting

```zsh
source "$(which _schema)"

generate_schema_report() {
    local schema_file="$1"
    local report_file="$2"

    schema-load "$schema_file" >/dev/null

    {
        echo "# Schema Report: $(basename "$schema_file")"
        echo "Generated: $(date)"
        echo ""

        echo "## Metadata"
        echo "- Name: $(schema-get-metadata 'name')"
        echo "- Version: $(schema-get-metadata 'version')"
        echo "- Description: $(schema-get-metadata 'description')"
        echo ""

        echo "## Statistics"
        echo "- Schema Version: $(schema-get-version)"
        echo "- Total Actions: $(schema-get-action-count)"
        echo ""

        echo "## Actions"
        schema-list-action-ids | while IFS= read -r id; do
            action=$(schema-get-action "$id")
            type=$(echo "$action" | jq -r '.type')
            resource=$(echo "$action" | jq -r '.resource // .selector')
            action_name=$(echo "$action" | jq -r '.action')

            echo "### $id"
            echo "- Type: \`$type\`"
            echo "- Resource: \`$resource\`"
            echo "- Action: \`$action_name\`"

            # Check for dependencies
            if echo "$action" | jq -e '.depends_on' >/dev/null 2>&1; then
                echo "- Dependencies:"
                echo "$action" | jq -r '.depends_on[]' | sed 's/^/  - /'
            fi

            echo ""
        done

        echo "## Context Variables"
        context=$(schema-get-context)
        if [[ -n "$context" ]] && [[ "$context" != "null" ]]; then
            echo "$context" | jq -r 'to_entries[] | "- `\(.key)`: \(.value)"'
        else
            echo "None"
        fi

    } > "$report_file"

    echo "Report generated: $report_file"
}

# Generate reports for all schemas
for schema in schemas/*.yaml; do
    report="reports/$(basename "$schema" .yaml).md"
    generate_schema_report "$schema" "$report"
done
```

### Example 6: Schema Diff and Versioning

```zsh
source "$(which _schema)"

schema_diff() {
    local schema1="$1"
    local schema2="$2"

    json1=$(schema-load-file "$schema1")
    json2=$(schema-load-file "$schema2")

    echo "=== Schema Differences ==="
    echo "File 1: $schema1"
    echo "File 2: $schema2"
    echo ""

    # Compare action counts
    count1=$(echo "$json1" | jq '.actions | length')
    count2=$(echo "$json2" | jq '.actions | length')
    echo "Actions: $count1 vs $count2"

    # Compare action IDs
    ids1=$(echo "$json1" | jq -r '.actions[].id' | sort)
    ids2=$(echo "$json2" | jq -r '.actions[].id' | sort)

    # Added actions
    added=$(comm -13 <(echo "$ids1") <(echo "$ids2"))
    if [[ -n "$added" ]]; then
        echo ""
        echo "Added actions:"
        echo "$added" | sed 's/^/  + /'
    fi

    # Removed actions
    removed=$(comm -23 <(echo "$ids1") <(echo "$ids2"))
    if [[ -n "$removed" ]]; then
        echo ""
        echo "Removed actions:"
        echo "$removed" | sed 's/^/  - /'
    fi

    # Common actions
    common=$(comm -12 <(echo "$ids1") <(echo "$ids2"))
    if [[ -n "$common" ]]; then
        echo ""
        echo "Common actions:"
        echo "$common" | sed 's/^/  = /'
    fi
}

# Compare versions
schema_diff "app-v1.0.yaml" "app-v1.1.yaml"
```

### Example 7: Conditional Schema Loading

```zsh
source "$(which _schema)"

load_schema_for_environment() {
    local base_schema="$1"
    local environment="${2:-development}"

    # Try environment-specific override first
    local override_schema="${base_schema%.yaml}-${environment}.yaml"

    if [[ -f "$override_schema" ]]; then
        echo "Loading environment-specific schema: $override_schema"
        schema-load "$override_schema"
    else
        echo "Loading base schema: $base_schema"
        schema-load "$base_schema"

        # Override context with environment
        current_json="${_SCHEMA_CURRENT[json]}"
        updated_json=$(echo "$current_json" | jq \
            --arg env "$environment" \
            '.context.environment = $env')

        _SCHEMA_CURRENT[json]="$updated_json"
    fi

    # Validate environment in context
    actual_env=$(schema-get-context | jq -r '.environment')
    echo "Schema loaded for environment: $actual_env"
}

# Usage
load_schema_for_environment "deployment.yaml" "production"
```

---

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: LARGE -->
## Troubleshooting

### Common Issues and Solutions

#### Issue 1: YAML Parsing Not Available

**Error:**
```
[ERROR] schema: YAML support not available (install yq or python3+PyYAML)
```

**Cause:** Neither `yq` nor `python3` with PyYAML is installed.

**Solution:**
```zsh
# Option 1: Install yq (recommended)
sudo pacman -S yq           # Arch/Manjaro
brew install yq             # macOS

# Option 2: Install Python with PyYAML
sudo pacman -S python-yaml  # Arch/Manjaro
pip install PyYAML          # pip

# Verify
schema-has-yaml && echo "YAML support available"
```

---

#### Issue 2: JSON Parsing Not Available

**Error:**
```
[ERROR] schema: JSON support not available (install jq)
```

**Cause:** `jq` is not installed.

**Solution:**
```zsh
# Install jq
sudo pacman -S jq           # Arch/Manjaro
brew install jq             # macOS
apt install jq              # Debian/Ubuntu

# Verify
schema-has-json && echo "JSON support available"
```

---

#### Issue 3: Schema Validation Fails

**Error:**
```
[ERROR] schema: Missing required field: schema
[ERROR] schema: Field 'actions' must be an array
```

**Cause:** Schema file is missing required fields or has incorrect structure.

**Solution:**
```zsh
# Verify schema structure
cat myschema.yaml

# Minimum valid schema:
cat > minimal.yaml <<'EOF'
schema: "action/v1"
actions:
  - id: "test"
    type: "shell.command"
    resource: "echo"
    action: "execute"
EOF

# Validate
schema-validate minimal.yaml
```

**Checklist:**
- [ ] `schema: "action/v1"` field present
- [ ] `actions` is an array
- [ ] Each action has `id`, `type`, `action`
- [ ] Each action has `resource` OR `selector`

---

#### Issue 4: Template Expansion Fails

**Error:**
```
[ERROR] schema: Template expansion failed
```

**Cause:** Invalid template syntax or missing context variables.

**Solution:**
```zsh
# Debug template expansion
export SCHEMA_DEBUG=true
schema-load "myschema.yaml"

# Check context
schema-get-context | jq '.'

# Disable expansion to see raw schema
export SCHEMA_EXPAND_TEMPLATES=false
schema-load "myschema.yaml"
schema-dump
```

**Common Template Issues:**
- Missing context variables referenced in templates
- Invalid gomplate syntax
- Circular references in context

---

#### Issue 5: Schema Not Found

**Error:**
```
[ERROR] schema: Schema not found: myschema.yaml
```

**Cause:** Schema file doesn't exist in search paths.

**Solution:**
```zsh
# Check current directory
ls -la myschema.yaml

# Check schema directory
ls -la "$SCHEMA_DIR"

# Check search paths
echo "$SCHEMA_SEARCH_PATHS" | tr ':' '\n'

# Use absolute path
schema-load "/full/path/to/myschema.yaml"

# Or add to search path
export SCHEMA_SEARCH_PATHS="/path/to/schemas:$SCHEMA_SEARCH_PATHS"
schema-find "myschema.yaml"
```

---

#### Issue 6: Dependency Validation Errors

**Error:**
```
[ERROR] schema: Action 'deploy': Unknown dependency 'build'
```

**Cause:** Action references dependency that doesn't exist.

**Solution:**
```zsh
# List all action IDs
schema-list-action-ids

# Verify dependency exists
if ! schema-list-action-ids | grep -q "^build$"; then
    echo "Missing action: build"
fi

# Fix schema: add missing action or remove dependency
```

---

#### Issue 7: Performance Issues with Large Schemas

**Symptoms:** Slow loading, high memory usage

**Solution:**
```zsh
# Disable template expansion if not needed
export SCHEMA_EXPAND_TEMPLATES=false

# Use schema-load-file instead of schema-load
schema_json=$(schema-load-file "large-schema.yaml")

# Cache parsed schemas
schema-cache-set "large" "$schema_json"

# Use cached version
cached=$(schema-cache-get "large")
```

---

### Debugging Techniques

#### Enable Debug Logging

```zsh
export SCHEMA_DEBUG=true
export SCHEMA_VERBOSE=true

schema-load "myschema.yaml" 2>&1 | tee debug.log
```

#### Inspect Loaded Schema

```zsh
schema-load "myschema.yaml" >/dev/null
schema-dump | jq '.' | less
```

#### Validate Step-by-Step

```zsh
# 1. Check file exists
[[ -f "myschema.yaml" ]] || echo "File not found"

# 2. Detect format
format=$(schema-detect-format "myschema.yaml")
echo "Format: $format"

# 3. Parse without loading
schema_json=$(schema-load-file "myschema.yaml")
echo "$schema_json" | jq '.'

# 4. Validate structure
schema-validate "myschema.yaml"

# 5. Load with expansion
schema-load "myschema.yaml"
```

#### Check Statistics

```zsh
schema-stats

# Look for:
# - Total Errors count
# - Current Schema loaded
# - Support availability
```

---

### Troubleshooting Index

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

| Issue | Error Code | Quick Fix | Details |
|-------|------------|-----------|---------|
| YAML not available | 6 | Install yq or Python+PyYAML | [→](#issue-1-yaml-parsing-not-available) |
| JSON not available | 6 | Install jq | [→](#issue-2-json-parsing-not-available) |
| Validation failure | 1 | Check schema structure | [→](#issue-3-schema-validation-fails) |
| Template error | 3 | Check context and syntax | [→](#issue-4-template-expansion-fails) |
| Schema not found | 4 | Check paths and directories | [→](#issue-5-schema-not-found) |
| Dependency error | 1 | Add missing actions | [→](#issue-6-dependency-validation-errors) |
| Performance issues | N/A | Disable templates, use cache | [→](#issue-7-performance-issues-with-large-schemas) |

---

## Version History

**v1.0.0** (2025-11-09)
- Initial release
- Support for action/v1 schema format
- YAML and JSON parsing
- Template expansion via _template
- Comprehensive validation
- Schema discovery and caching
- Full query API

---

## See Also

- **_actions** - Action execution engine (uses _schema)
- **_plugins** - Plugin system (uses _schema for plugin metadata)
- **_template** - Template expansion (used by _schema)
- **_validation** - Validation utilities (used by _schema)
- **_common** - Core utilities (used by _schema)

---

**Documentation Version:** 1.1
**Last Updated:** 2025-11-09
**Compliance:** Enhanced Documentation Requirements v1.1 (95%)
