# Schema-Exec Examples

This directory contains example schemas demonstrating the `action/v1` schema format and the schema-exec execution engine.

## Examples

### 1. `docker-volume-backup.yaml`
**Purpose**: Backup multiple Docker volumes

**Features demonstrated**:
- Multiple parallel volume backups
- Context variables with gomplate templating
- Result storage with `store_result_as`
- Simple dependency-free parallel execution

**Usage**:
```bash
schema-exec docker-volume-backup.yaml
```

**Requirements**:
- Docker volumes: `postgres_data`, `redis_data`, `nginx_config`

---

### 2. `docker-container-lifecycle.yaml`
**Purpose**: Stop containers, backup volumes, restart containers

**Features demonstrated**:
- Dependency-ordered execution
- Container lifecycle management (stop → backup → start)
- Error handling with `on_error: warn`
- Rollback actions for failure recovery
- Multi-level dependencies

**Usage**:
```bash
schema-exec docker-container-lifecycle.yaml
```

**Requirements**:
- Docker containers: `myapp_web`, `myapp_api`, `myapp_postgres`
- Docker volumes: `myapp_postgres_data`, `myapp_uploads`

---

### 3. `conditional-actions.yaml`
**Purpose**: Conditional action execution based on environment

**Features demonstrated**:
- Conditional execution with `conditions`
- Gomplate template expressions
- Context-driven behavior (production vs development)
- Skip vs fail behavior with `on_false`
- Multiple condition evaluation

**Usage**:
```bash
# Production mode (backups enabled)
schema-exec conditional-actions.yaml

# Development mode (edit context.environment in file)
# Change: environment: "development"
schema-exec conditional-actions.yaml
```

**Requirements**:
- Docker volume: `app_data` (production)
- Docker volume: `app_data_dev` (development)

---

### 4. `volume-restore.yaml`
**Purpose**: Restore Docker volumes from backup archives

**Features demonstrated**:
- Volume restore operations
- Container coordination (stop before restore, start after)
- Dependency chains ensuring proper sequencing
- Rollback for container restart on failure
- Template-based backup file paths

**Usage**:
```bash
# Edit context.backup_date to match your backup
schema-exec volume-restore.yaml
```

**Requirements**:
- Backup files in `~/.local/share/docker-backups/`
- Docker containers: `app_postgres`, `app_web`
- Docker volumes: `postgres_data`, `app_uploads`

---

## Schema Format Reference

All examples follow the `action/v1` schema format:

```yaml
schema: "action/v1"
version: "1.0.0"

metadata:
  name: "example-name"
  description: "What this schema does"

context:
  variable_name: "value"  # Available as {{ .variable_name }} in templates

actions:
  - id: "unique_action_id"
    type: "plugin.resource"      # e.g., "docker.volume"
    resource: "resource_name"     # Or use selector
    action: "operation"           # e.g., "backup", "create"
    params:
      key: "value"
    depends_on:                   # Optional dependencies
      - "other_action_id"
    conditions:                   # Optional conditions
      - expression: "{{ .var }}"
        on_false: "skip"          # Or "fail"
    on_error: "fail"              # Or "warn", "ignore"
    store_result_as: "var_name"  # Store result in context

config:
  on_failure: "stop"              # Or "continue"

rollback:
  enabled: true
  actions: [...]                  # Same format as main actions
```

## Gomplate Template Functions

Context variables support gomplate template expressions:

- `{{ .variable_name }}` - Variable interpolation
- `{{ now | date "2006-01-02" }}` - Current date
- `{{ eq .env "production" }}` - Equality check
- `{{ .backup_dir }}/file.tar.gz` - Path construction

See [gomplate documentation](https://docs.gomplate.ca/) for full reference.

## Common Patterns

### Pattern 1: Stop → Process → Start
```yaml
actions:
  - id: stop_service
    type: docker.container
    action: stop

  - id: process_data
    # ... some operation
    depends_on: [stop_service]

  - id: start_service
    type: docker.container
    action: start
    depends_on: [process_data]
```

### Pattern 2: Parallel with Join
```yaml
actions:
  - id: task_a
    # Independent task

  - id: task_b
    # Independent task

  - id: join_task
    # Runs after both complete
    depends_on: [task_a, task_b]
```

### Pattern 3: Conditional Environment
```yaml
context:
  environment: "production"

actions:
  - id: prod_only
    # ...
    conditions:
      - expression: "{{ eq .environment \"production\" }}"
        on_false: "skip"
```

### Pattern 4: Backup with Rollback
```yaml
actions:
  - id: backup
    # ... backup operation

rollback:
  enabled: true
  actions:
    - id: restore
      # ... restore from backup
```

## Testing Examples

### Dry Run
Test schema without executing actions:
```bash
schema-exec --dry-run example.yaml
```

### Verbose Output
See detailed execution log:
```bash
schema-exec --verbose example.yaml
```

### With Checkpoint
Save state for resume capability:
```bash
schema-exec --save-checkpoint after-backup example.yaml
```

### Resume from Checkpoint
Continue from saved state:
```bash
schema-exec --checkpoint after-backup example.yaml
```

## Creating Your Own Schemas

1. Copy an example as a starting point
2. Modify `metadata` section
3. Update `context` variables
4. Define your `actions` with proper dependencies
5. Add `conditions` for conditional logic
6. Configure `rollback` for failure recovery
7. Validate with `schema-exec --dry-run`

## Plugin Support

Current plugins:
- **docker**: volume, container, network, image operations

To list available plugins:
```bash
schema-exec --list-plugins
```

To see plugin details:
```bash
schema-exec --plugin-info docker
```

## Troubleshooting

**Schema validation failed**:
- Check YAML syntax
- Ensure `schema: "action/v1"` is present
- Verify all required fields in actions

**Plugin not found**:
- Run `schema-exec --list-plugins`
- Check plugin is in `~/.local/libexec/plugins/`

**Action handler not found**:
- Verify `type` and `action` combination exists
- Use `schema-exec --plugin-info <plugin>` to see supported actions

**Circular dependency**:
- Review `depends_on` chains
- Ensure no action depends on itself (directly or indirectly)

---

For more information:
- GitHub: https://github.com/andronics/dotfiles
- Documentation: `~/.local/docs/lib/`
