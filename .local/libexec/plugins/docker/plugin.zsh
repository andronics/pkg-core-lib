#!/usr/bin/env zsh
# Docker Plugin v1.0.0
# Provides Docker resource management handlers for schema-driven actions

# Plugin guard
[[ -n "${_PLUGIN_DOCKER_LOADED:-}" ]] && return 0
declare -g _PLUGIN_DOCKER_LOADED=1

# Load dependencies
# Check if already loaded (should be loaded by schema-exec)
if [[ -z "${COMMON_LOADED:-}" ]]; then
    source "$(which _common)" 2>/dev/null || {
        echo "Error: Docker plugin requires _common library" >&2
        return 1
    }
fi
if [[ -z "${ACTIONS_LOADED:-}" ]]; then
    source "$(which _actions)" 2>/dev/null || {
        echo "Error: Docker plugin requires _actions library" >&2
        return 1
    }
fi
[[ -z "${LOG_LOADED:-}" ]] && source "$(which _log)" 2>/dev/null || true
[[ -z "${EVENTS_LOADED:-}" ]] && source "$(which _events)" 2>/dev/null || true

###########################################
# Plugin Configuration
###########################################

declare -g DOCKER_PLUGIN_BACKUP_DIR="${DOCKER_PLUGIN_BACKUP_DIR:-${HOME}/.local/share/docker-backups}"
declare -g DOCKER_PLUGIN_PRUNE_CONFIRMATION="${DOCKER_PLUGIN_PRUNE_CONFIRMATION:-true}"
declare -g DOCKER_PLUGIN_RESTIC_REPO="${DOCKER_PLUGIN_RESTIC_REPO:-}"

###########################################
# Utility Functions
###########################################

# Check if Docker is available
_docker_plugin_check_docker() {
    # Use absolute path since PATH may be restricted in sandbox
    local docker_cmd="/usr/bin/docker"

    if [[ ! -x "$docker_cmd" ]]; then
        log-error "Docker command not found at $docker_cmd"
        return 1
    fi

    if ! "$docker_cmd" ps &>/dev/null; then
        log-error "Docker daemon not accessible"
        return 1
    fi

    return 0
}

# Parse resource/selector from params
_docker_plugin_parse_resource() {
    local resource_or_selector="$1"

    # If it's a selector expression, evaluate it
    # For now, just return as-is (selector support can be added later)
    echo "$resource_or_selector"
}

# Extract param from JSON params
_docker_plugin_get_param() {
    local params_json="$1"
    local param_name="$2"
    local default="${3:-}"

    if [[ -z "$params_json" || "$params_json" == "null" ]]; then
        echo "$default"
        return 0
    fi

    local value
    value="$(echo "$params_json" | jq -r ".$param_name // empty" 2>/dev/null)"

    if [[ -z "$value" ]]; then
        echo "$default"
    else
        echo "$value"
    fi
}

###########################################
# Volume Handlers
###########################################

# docker.volume create handler
docker_volume_create() {
    local volume_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local driver=$(_docker_plugin_get_param "$params_json" "driver" "local")
    local opts=$(_docker_plugin_get_param "$params_json" "options" "")

    log-info "Creating Docker volume: $volume_name (driver: $driver)"

    local create_cmd="/usr/bin/docker volume create --driver $driver"

    if [[ -n "$opts" ]]; then
        # Parse options JSON and add --opt flags
        while IFS= read -r opt; do
            [[ -z "$opt" ]] && continue
            local key=$(echo "$opt" | cut -d'=' -f1)
            local val=$(echo "$opt" | cut -d'=' -f2-)
            create_cmd+=" --opt ${key}=${val}"
        done < <(echo "$opts" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"' 2>/dev/null)
    fi

    create_cmd+=" $volume_name"

    if eval "$create_cmd"; then
        log-success "Volume created: $volume_name"
        echo "$volume_name"
        return 0
    else
        log-error "Failed to create volume: $volume_name"
        return 1
    fi
}

# docker.volume remove handler
docker_volume_remove() {
    local volume_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local force=$(_docker_plugin_get_param "$params_json" "force" "false")

    log-info "Removing Docker volume: $volume_name"

    local remove_cmd="/usr/bin/docker volume rm"
    [[ "$force" == "true" ]] && remove_cmd+=" -f"
    remove_cmd+=" $volume_name"

    if eval "$remove_cmd"; then
        log-success "Volume removed: $volume_name"
        return 0
    else
        log-error "Failed to remove volume: $volume_name"
        return 1
    fi
}

# docker.volume backup handler
docker_volume_backup() {
    local volume_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local backup_file=$(_docker_plugin_get_param "$params_json" "backup_file" "")
    local compression=$(_docker_plugin_get_param "$params_json" "compression" "gzip")

    # Create backup directory
    mkdir -p "$DOCKER_PLUGIN_BACKUP_DIR" || {
        log-error "Failed to create backup directory: $DOCKER_PLUGIN_BACKUP_DIR"
        return 1
    }

    # Generate backup filename if not provided
    if [[ -z "$backup_file" ]]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        backup_file="$DOCKER_PLUGIN_BACKUP_DIR/${volume_name}_${timestamp}.tar.gz"
    fi

    log-info "Backing up Docker volume: $volume_name -> $backup_file"

    # Use a temporary container to backup the volume
    /usr/bin/docker run --rm \
        -v "${volume_name}:/source:ro" \
        -v "$(dirname "$backup_file"):/backup" \
        alpine \
        tar czf "/backup/$(basename "$backup_file")" -C /source . || {
        log-error "Failed to backup volume: $volume_name"
        return 1
    }

    log-success "Volume backed up: $volume_name -> $backup_file"
    echo "$backup_file"
    return 0
}

# docker.volume restore handler
docker_volume_restore() {
    local volume_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local backup_file=$(_docker_plugin_get_param "$params_json" "backup_file" "")

    if [[ -z "$backup_file" || ! -f "$backup_file" ]]; then
        log-error "Backup file not found: $backup_file"
        return 1
    fi

    log-info "Restoring Docker volume: $volume_name <- $backup_file"

    # Ensure volume exists
    /usr/bin/docker volume inspect "$volume_name" &>/dev/null || {
        log-info "Creating volume for restore: $volume_name"
        /usr/bin/docker volume create "$volume_name" || {
            log-error "Failed to create volume: $volume_name"
            return 1
        }
    }

    # Use a temporary container to restore the volume
    /usr/bin/docker run --rm \
        -v "${volume_name}:/target" \
        -v "$(dirname "$backup_file"):/backup:ro" \
        alpine \
        sh -c "rm -rf /target/* /target/..?* /target/.[!.]* 2>/dev/null || true && tar xzf /backup/$(basename "$backup_file") -C /target" || {
        log-error "Failed to restore volume: $volume_name"
        return 1
    }

    log-success "Volume restored: $volume_name <- $backup_file"
    return 0
}

# docker.volume prune handler
docker_volume_prune() {
    local selector="$1"  # Not used for prune
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local force=$(_docker_plugin_get_param "$params_json" "force" "false")

    if [[ "$DOCKER_PLUGIN_PRUNE_CONFIRMATION" == "true" && "$force" != "true" ]]; then
        log-warn "Volume prune requires force=true in params or DOCKER_PLUGIN_PRUNE_CONFIRMATION=false"
        return 1
    fi

    log-info "Pruning unused Docker volumes"

    if /usr/bin/docker volume prune -f; then
        log-success "Unused volumes pruned"
        return 0
    else
        log-error "Failed to prune volumes"
        return 1
    fi
}

# docker.volume inspect handler
docker_volume_inspect() {
    local volume_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    log-debug "Inspecting Docker volume: $volume_name"

    local inspect_output
    inspect_output=$(/usr/bin/docker volume inspect "$volume_name" 2>/dev/null) || {
        log-error "Failed to inspect volume: $volume_name"
        return 1
    }

    echo "$inspect_output"
    return 0
}

###########################################
# Container Handlers
###########################################

# docker.container start handler
docker_container_start() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    log-info "Starting Docker container: $container_name"

    if /usr/bin/docker start "$container_name"; then
        log-success "Container started: $container_name"
        return 0
    else
        log-error "Failed to start container: $container_name"
        return 1
    fi
}

# docker.container stop handler
docker_container_stop() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local timeout=$(_docker_plugin_get_param "$params_json" "timeout" "10")

    log-info "Stopping Docker container: $container_name (timeout: ${timeout}s)"

    if /usr/bin/docker stop -t "$timeout" "$container_name"; then
        log-success "Container stopped: $container_name"
        return 0
    else
        log-error "Failed to stop container: $container_name"
        return 1
    fi
}

# docker.container restart handler
docker_container_restart() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local timeout=$(_docker_plugin_get_param "$params_json" "timeout" "10")

    log-info "Restarting Docker container: $container_name"

    if /usr/bin/docker restart -t "$timeout" "$container_name"; then
        log-success "Container restarted: $container_name"
        return 0
    else
        log-error "Failed to restart container: $container_name"
        return 1
    fi
}

# docker.container remove handler
docker_container_remove() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    local force=$(_docker_plugin_get_param "$params_json" "force" "false")
    local volumes=$(_docker_plugin_get_param "$params_json" "volumes" "false")

    log-info "Removing Docker container: $container_name"

    local remove_cmd="/usr/bin/docker rm"
    [[ "$force" == "true" ]] && remove_cmd+=" -f"
    [[ "$volumes" == "true" ]] && remove_cmd+=" -v"
    remove_cmd+=" $container_name"

    if eval "$remove_cmd"; then
        log-success "Container removed: $container_name"
        return 0
    else
        log-error "Failed to remove container: $container_name"
        return 1
    fi
}

# docker.container pause handler
docker_container_pause() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    log-info "Pausing Docker container: $container_name"

    if /usr/bin/docker pause "$container_name"; then
        log-success "Container paused: $container_name"
        return 0
    else
        log-error "Failed to pause container: $container_name"
        return 1
    fi
}

# docker.container unpause handler
docker_container_unpause() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    log-info "Unpausing Docker container: $container_name"

    if /usr/bin/docker unpause "$container_name"; then
        log-success "Container unpaused: $container_name"
        return 0
    else
        log-error "Failed to unpause container: $container_name"
        return 1
    fi
}

# docker.container inspect handler
docker_container_inspect() {
    local container_name="$1"
    local params_json="${2:-{}}"

    _docker_plugin_check_docker || return 1

    log-debug "Inspecting Docker container: $container_name"

    local inspect_output
    inspect_output=$(/usr/bin/docker inspect "$container_name" 2>/dev/null) || {
        log-error "Failed to inspect container: $container_name"
        return 1
    }

    echo "$inspect_output"
    return 0
}

###########################################
# Network Handlers (abbreviated for space)
###########################################

docker_network_create() {
    local network_name="$1"
    local params_json="${2:-{}}"
    _docker_plugin_check_docker || return 1

    local driver=$(_docker_plugin_get_param "$params_json" "driver" "bridge")

    if /usr/bin/docker network create --driver "$driver" "$network_name"; then
        log-success "Network created: $network_name"
        return 0
    else
        log-error "Failed to create network: $network_name"
        return 1
    fi
}

docker_network_remove() {
    local network_name="$1"
    _docker_plugin_check_docker || return 1

    if /usr/bin/docker network rm "$network_name"; then
        log-success "Network removed: $network_name"
        return 0
    else
        log-error "Failed to remove network: $network_name"
        return 1
    fi
}

docker_network_inspect() {
    local network_name="$1"
    _docker_plugin_check_docker || return 1
    /usr/bin/docker network inspect "$network_name" 2>/dev/null
}

###########################################
# Image Handlers (abbreviated for space)
###########################################

docker_image_pull() {
    local image_name="$1"
    _docker_plugin_check_docker || return 1

    log-info "Pulling Docker image: $image_name"

    if /usr/bin/docker pull "$image_name"; then
        log-success "Image pulled: $image_name"
        return 0
    else
        log-error "Failed to pull image: $image_name"
        return 1
    fi
}

docker_image_remove() {
    local image_name="$1"
    local params_json="${2:-{}}"
    _docker_plugin_check_docker || return 1

    local force=$(_docker_plugin_get_param "$params_json" "force" "false")

    local remove_cmd="/usr/bin/docker rmi"
    [[ "$force" == "true" ]] && remove_cmd+=" -f"
    remove_cmd+=" $image_name"

    if eval "$remove_cmd"; then
        log-success "Image removed: $image_name"
        return 0
    else
        log-error "Failed to remove image: $image_name"
        return 1
    fi
}

docker_image_inspect() {
    local image_name="$1"
    _docker_plugin_check_docker || return 1
    /usr/bin/docker image inspect "$image_name" 2>/dev/null
}

###########################################
# Plugin Initialization
###########################################

# Plugin init function (called by _plugins system)
docker_init() {
    log-info "Initializing Docker plugin v1.0.0"

    # Check Docker availability
    if ! _docker_plugin_check_docker; then
        log-error "Docker plugin initialization failed: Docker not available"
        return 1
    fi

    # Register all action handlers
    # Volume handlers
    action-register "docker.volume" "create" docker_volume_create
    action-register "docker.volume" "remove" docker_volume_remove
    action-register "docker.volume" "backup" docker_volume_backup
    action-register "docker.volume" "restore" docker_volume_restore
    action-register "docker.volume" "prune" docker_volume_prune
    action-register "docker.volume" "inspect" docker_volume_inspect

    # Container handlers
    action-register "docker.container" "start" docker_container_start
    action-register "docker.container" "stop" docker_container_stop
    action-register "docker.container" "restart" docker_container_restart
    action-register "docker.container" "remove" docker_container_remove
    action-register "docker.container" "pause" docker_container_pause
    action-register "docker.container" "unpause" docker_container_unpause
    action-register "docker.container" "inspect" docker_container_inspect

    # Network handlers
    action-register "docker.network" "create" docker_network_create
    action-register "docker.network" "remove" docker_network_remove
    action-register "docker.network" "inspect" docker_network_inspect

    # Image handlers
    action-register "docker.image" "pull" docker_image_pull
    action-register "docker.image" "remove" docker_image_remove
    action-register "docker.image" "inspect" docker_image_inspect

    log-success "Docker plugin initialized successfully"
    log-info "Registered 18 action handlers"

    return 0
}

# Export handlers
# Note: In zsh, functions are automatically available in subshells, no need to export
# (export -f is a bash-ism not supported in zsh)

log-debug "Docker plugin loaded (v1.0.0)"
return 0
