#!/usr/bin/env zsh

# _{{NAME}} - {{DESCRIPTION}}
# Part of the dotfiles library v2.0
# Version: {{VERSION}}
#
# Usage:
#   source "$(which _{{NAME}})"
#
# Provides:
#   - {{FEATURE_1}}
#   - {{FEATURE_2}}
#   - {{FEATURE_3}}
#
# Dependencies:
#   - _common (required)
#   - {{DEP_1}} (optional)
#   - {{DEP_2}} (optional)

# ------------------------------
# Source Guard
# ------------------------------

[[ -n "${{{NAME_UPPER}}_LOADED:-}" ]] && return 0

# ------------------------------
# Version
# ------------------------------

declare -gr {{NAME_UPPER}}_VERSION="{{VERSION}}"
declare -g {{NAME_UPPER}}_LOADED=1

# ------------------------------
# Load Dependencies
# ------------------------------

# Load _common (required) from same directory
_{{NAME_UPPER}}_DIR="${${(%):-%x}:A:h}"
if ! source "$_{{NAME_UPPER}}_DIR/_common" 2>/dev/null; then
    # Fallback: try multiple locations
    local _found=false
    for _path in \
        "$HOME/.local/bin/lib/_common" \
        "$HOME/.dotfiles/lib/.local/bin/lib/_common"; do
        if [[ -f "$_path" ]] && source "$_path" 2>/dev/null; then
            _found=true
            break
        fi
    done
    if [[ "$_found" != "true" ]]; then
        echo "[ERROR] _{{NAME}} requires _common extension" >&2
        return 1
    fi
    unset _found _path
fi
unset _{{NAME_UPPER}}_DIR

# Load optional dependencies with graceful degradation
{{NAME}}-check-optional-dependencies() {
    # Check for optional dependency
    if ! common-command-exists "{{OPTIONAL_CMD}}"; then
        echo "[WARNING] {{NAME}}: {{OPTIONAL_CMD}} not found, some features disabled" >&2
        declare -g {{NAME_UPPER}}_{{OPTIONAL_FEATURE}}_AVAILABLE=false
    else
        declare -g {{NAME_UPPER}}_{{OPTIONAL_FEATURE}}_AVAILABLE=true
    fi
}

{{NAME}}-check-optional-dependencies

# ------------------------------
# Configuration Variables
# ------------------------------

# XDG-compliant configuration paths
declare -g {{NAME_UPPER}}_CONFIG_DIR="$(common-xdg-config-home)/{{NAME}}"
declare -g {{NAME_UPPER}}_DATA_DIR="$(common-lib-data-dir)/{{NAME}}"
declare -g {{NAME_UPPER}}_CACHE_DIR="$(common-lib-cache-dir)/{{NAME}}"
declare -g {{NAME_UPPER}}_STATE_DIR="$(common-lib-state-dir)/{{NAME}}"

# Default configuration values
declare -g {{NAME_UPPER}}_DEFAULT_OPTION="${{{NAME_UPPER}}_DEFAULT_OPTION:-default_value}"
declare -g {{NAME_UPPER}}_VERBOSE="${{{NAME_UPPER}}_VERBOSE:-false}"
declare -g {{NAME_UPPER}}_DEBUG="${{{NAME_UPPER}}_DEBUG:-false}"

# Feature flags
declare -g {{NAME_UPPER}}_FEATURE_X_ENABLED="${{{NAME_UPPER}}_FEATURE_X_ENABLED:-true}"

# ------------------------------
# Color Constants (if needed)
# ------------------------------

# Use _common color constants, or define extension-specific ones
declare -gr _{{NAME_UPPER}}_COLOR_INFO="$COLOR_BLUE"
declare -gr _{{NAME_UPPER}}_COLOR_SUCCESS="$COLOR_GREEN"
declare -gr _{{NAME_UPPER}}_COLOR_WARNING="$COLOR_YELLOW"
declare -gr _{{NAME_UPPER}}_COLOR_ERROR="$COLOR_RED"

# ------------------------------
# Internal Helper Functions
# ------------------------------

# Internal helpers are prefixed with underscore
_{{NAME}}-internal-helper() {
    local input="$1"

    # Validate input
    common-validate-required "$input" "input" || return 2

    # Process
    echo "processed: $input"
}

_{{NAME}}-log-debug() {
    [[ "${{NAME_UPPER}}_DEBUG" == "true" ]] || return 0
    echo "[DEBUG] {{NAME}}: $*" >&2
}

_{{NAME}}-log-error() {
    echo -e "${_{{NAME_UPPER}}_COLOR_ERROR}[ERROR] {{NAME}}: $*${COLOR_RESET}" >&2
}

_{{NAME}}-log-warning() {
    echo -e "${_{{NAME_UPPER}}_COLOR_WARNING}[WARNING] {{NAME}}: $*${COLOR_RESET}" >&2
}

_{{NAME}}-log-info() {
    [[ "${{NAME_UPPER}}_VERBOSE" == "true" ]] || return 0
    echo -e "${_{{NAME_UPPER}}_COLOR_INFO}[INFO] {{NAME}}: $*${COLOR_RESET}" >&2
}

# ------------------------------
# Core Public Functions
# ------------------------------

# Public functions follow naming convention: {{NAME}}-verb-noun

{{NAME}}-do-action() {
    local target="$1"
    local option="${2:-default}"

    # Validate required parameters
    common-validate-required "$target" "target" || return 2
    common-validate-enum "$option" "default custom advanced" || {
        _{{NAME}}-log-error "Invalid option: $option (valid: default, custom, advanced)"
        return 2
    }

    _{{NAME}}-log-debug "do-action: target=$target, option=$option"

    # Check feature availability
    if [[ "$option" == "advanced" ]] && [[ "${{NAME_UPPER}}_{{OPTIONAL_FEATURE}}_AVAILABLE" != "true" ]]; then
        _{{NAME}}-log-error "Advanced option requires {{OPTIONAL_CMD}}"
        return 6
    fi

    # Perform action
    case "$option" in
        default)
            echo "Performing default action on $target"
            ;;
        custom)
            echo "Performing custom action on $target"
            ;;
        advanced)
            echo "Performing advanced action on $target"
            ;;
    esac

    _{{NAME}}-log-info "Action completed successfully"
    return 0
}

{{NAME}}-get-info() {
    local what="${1:-all}"

    case "$what" in
        version)
            echo "${{NAME_UPPER}}_VERSION"
            ;;
        config-dir)
            echo "${{NAME_UPPER}}_CONFIG_DIR"
            ;;
        data-dir)
            echo "${{NAME_UPPER}}_DATA_DIR"
            ;;
        all)
            echo "{{NAME}} v${{NAME_UPPER}}_VERSION"
            echo "Config: ${{NAME_UPPER}}_CONFIG_DIR"
            echo "Data: ${{NAME_UPPER}}_DATA_DIR"
            echo "Cache: ${{NAME_UPPER}}_CACHE_DIR"
            ;;
        *)
            _{{NAME}}-log-error "Unknown info type: $what"
            return 2
            ;;
    esac
}

{{NAME}}-check-status() {
    local all_good=true

    echo "{{NAME}} Status Check:"
    echo "  Version: ${{NAME_UPPER}}_VERSION"

    # Check dependencies
    if common-command-exists "{{OPTIONAL_CMD}}"; then
        echo "  Optional features: ${COLOR_GREEN}✓ Available${COLOR_RESET}"
    else
        echo "  Optional features: ${COLOR_YELLOW}! Not available${COLOR_RESET}"
        all_good=false
    fi

    # Check directories
    if [[ -d "${{NAME_UPPER}}_DATA_DIR" ]]; then
        echo "  Data directory: ${COLOR_GREEN}✓ Exists${COLOR_RESET}"
    else
        echo "  Data directory: ${COLOR_YELLOW}! Not created${COLOR_RESET}"
    fi

    # Overall status
    if [[ "$all_good" == "true" ]]; then
        echo "  Status: ${COLOR_GREEN}✓ All systems operational${COLOR_RESET}"
        return 0
    else
        echo "  Status: ${COLOR_YELLOW}! Some features unavailable${COLOR_RESET}"
        return 1
    fi
}

# ------------------------------
# Configuration Management
# ------------------------------

{{NAME}}-init() {
    _{{NAME}}-log-info "Initializing {{NAME}}..."

    # Create XDG directories
    common-ensure-dir "${{NAME_UPPER}}_CONFIG_DIR"
    common-ensure-dir "${{NAME_UPPER}}_DATA_DIR"
    common-ensure-dir "${{NAME_UPPER}}_CACHE_DIR"
    common-ensure-dir "${{NAME_UPPER}}_STATE_DIR"

    # Create default config if needed
    local config_file="${{NAME_UPPER}}_CONFIG_DIR/config.conf"
    if [[ ! -f "$config_file" ]]; then
        _{{NAME}}-log-info "Creating default configuration..."
        cat > "$config_file" <<'EOF'
# {{NAME}} Configuration
# Generated: $(date)

# General settings
{{NAME_UPPER}}_DEFAULT_OPTION=default_value
{{NAME_UPPER}}_VERBOSE=false
{{NAME_UPPER}}_DEBUG=false

# Feature flags
{{NAME_UPPER}}_FEATURE_X_ENABLED=true
EOF
    fi

    _{{NAME}}-log-info "Initialization complete"
    return 0
}

{{NAME}}-load-config() {
    local config_file="${{NAME_UPPER}}_CONFIG_DIR/config.conf"

    if [[ ! -f "$config_file" ]]; then
        _{{NAME}}-log-warning "Config file not found, using defaults"
        return 0
    fi

    _{{NAME}}-log-debug "Loading config from $config_file"

    # Source config file safely
    # shellcheck disable=SC1090
    source "$config_file" 2>/dev/null || {
        _{{NAME}}-log-error "Failed to load config file"
        return 3
    }

    return 0
}

# ------------------------------
# Cache Management
# ------------------------------

{{NAME}}-cache-get() {
    local key="$1"
    common-validate-required "$key" "key" || return 2

    local cache_file="${{NAME_UPPER}}_CACHE_DIR/${key}.cache"

    if [[ -f "$cache_file" ]]; then
        cat "$cache_file"
        return 0
    else
        return 1
    fi
}

{{NAME}}-cache-set() {
    local key="$1"
    local value="$2"

    common-validate-required "$key" "key" || return 2
    common-validate-required "$value" "value" || return 2

    common-ensure-dir "${{NAME_UPPER}}_CACHE_DIR"

    local cache_file="${{NAME_UPPER}}_CACHE_DIR/${key}.cache"
    echo "$value" > "$cache_file"
}

{{NAME}}-cache-clear() {
    local key="${1:-}"

    if [[ -n "$key" ]]; then
        # Clear specific key
        rm -f "${{NAME_UPPER}}_CACHE_DIR/${key}.cache"
        _{{NAME}}-log-info "Cleared cache for: $key"
    else
        # Clear all cache
        rm -rf "${{NAME_UPPER}}_CACHE_DIR"/*
        _{{NAME}}-log-info "Cleared all cache"
    fi
}

# ------------------------------
# Error Handling Example
# ------------------------------

{{NAME}}-with-retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-2}"
    shift 2

    common-validate-numeric "$max_attempts" || return 2
    common-validate-numeric "$delay" || return 2

    common-retry "$max_attempts" "$delay" "$@"
}

{{NAME}}-with-timeout() {
    local timeout="${1:-30}"
    shift

    common-validate-numeric "$timeout" || return 2

    common-timeout "$timeout" "$@"
}

# ------------------------------
# Cleanup and Teardown
# ------------------------------

{{NAME}}-cleanup() {
    _{{NAME}}-log-info "Running cleanup..."

    # Clear temporary files
    local temp_dir="${{NAME_UPPER}}_CACHE_DIR/temp"
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
        _{{NAME}}-log-debug "Removed temp directory"
    fi

    # Additional cleanup tasks
    # ...

    return 0
}

# ------------------------------
# Help and Documentation
# ------------------------------

{{NAME}}-help() {
    cat <<'EOF'
{{NAME}} - {{DESCRIPTION}}
Version: {{VERSION}}

Usage:
  source "$(which _{{NAME}})"
  {{NAME}}-<command> [options]

Commands:
  {{NAME}}-do-action <target> [option]   Perform action on target
  {{NAME}}-get-info [what]               Get information (version, config-dir, data-dir, all)
  {{NAME}}-check-status                  Check extension status
  {{NAME}}-init                          Initialize directories and config
  {{NAME}}-load-config                   Load configuration from file
  {{NAME}}-cache-get <key>               Get cached value
  {{NAME}}-cache-set <key> <value>       Set cached value
  {{NAME}}-cache-clear [key]             Clear cache (all or specific key)
  {{NAME}}-cleanup                       Cleanup temporary files
  {{NAME}}-help                          Show this help message

Configuration:
  Config: ${{NAME_UPPER}}_CONFIG_DIR/config.conf
  Data:   ${{NAME_UPPER}}_DATA_DIR
  Cache:  ${{NAME_UPPER}}_CACHE_DIR

Environment Variables:
  {{NAME_UPPER}}_DEFAULT_OPTION    Default option value
  {{NAME_UPPER}}_VERBOSE           Enable verbose output (true/false)
  {{NAME_UPPER}}_DEBUG             Enable debug output (true/false)
  {{NAME_UPPER}}_FEATURE_X_ENABLED Enable feature X (true/false)

Examples:
  # Initialize extension
  {{NAME}}-init

  # Perform action
  {{NAME}}-do-action "target" "default"

  # Check status
  {{NAME}}-check-status

  # Get version
  {{NAME}}-get-info version

For complete documentation:
  cat $(common-lib-docs-dir)/extensions/_{{NAME}}.md

EOF
}

# ------------------------------
# Self-Test
# ------------------------------

{{NAME}}-self-test() {
    # Require _test framework
    if ! source "$(which _test)" 2>/dev/null; then
        echo "[ERROR] {{NAME}}-self-test requires _test framework" >&2
        return 1
    fi

    echo "=== Testing {{NAME}} v${{NAME_UPPER}}_VERSION ==="
    test-reset

    echo "## Basic Tests"
    test-assert-not-empty "${{NAME_UPPER}}_VERSION" "version should be set"
    test-assert-command-exists "{{NAME}}-help" "help function should exist"
    test-assert-command-exists "{{NAME}}-do-action" "do-action function should exist"

    echo ""
    echo "## Configuration Tests"
    test-assert-not-empty "${{NAME_UPPER}}_CONFIG_DIR" "config dir should be set"
    test-assert-not-empty "${{NAME_UPPER}}_DATA_DIR" "data dir should be set"

    echo ""
    echo "## Functionality Tests"
    result=$({{NAME}}-get-info version)
    test-assert-equals "$result" "${{NAME_UPPER}}_VERSION" "get-info version should work"

    echo ""

    test-summary
    return $?
}

# ------------------------------
# Script Execution Detection
# ------------------------------

# If script is executed directly (not sourced), show help or run self-test
if [[ "${(%):-%x}" == "$0" ]]; then
    case "${1:-help}" in
        self-test)
            {{NAME}}-self-test
            exit $?
            ;;
        help|--help|-h)
            {{NAME}}-help
            exit 0
            ;;
        *)
            echo "Error: Extension must be sourced, not executed directly" >&2
            echo "Usage: source \"$(which _{{NAME}})\"" >&2
            echo "For help: $0 help" >&2
            exit 1
            ;;
    esac
fi

# ------------------------------
# Extension Loaded
# ------------------------------

_{{NAME}}-log-debug "Extension loaded successfully"
