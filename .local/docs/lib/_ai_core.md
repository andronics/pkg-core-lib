# _ai_core - Tool-Agnostic AI Definition and Artifact Generation

**Lines:** 2,090 | **Functions:** 42 (18 public + 24 internal) | **Examples:** 50+
**Version:** 1.0.0 | **Layer:** Infrastructure (Layer 2) | **Source:** `~/.local/bin/lib/_ai_core`

---

## Quick Access Index

### Compact References (Lines 10-500)
- [Function Reference](#function-quick-reference) - 42 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 20+ variables
- [Events](#events-quick-reference) - 13 events
- [Return Codes](#return-codes-quick-reference) - 25 error codes

### Main Sections
- [Overview](#overview) (Lines 500-650, ~150 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 650-750, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 750-1000, ~250 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 1000-1150, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 1150-2800, ~1650 lines) ⚡ LARGE SECTION
- [Advanced Usage](#advanced-usage) (Lines 2800-3150, ~350 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 3150-3450, ~300 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: Core API Functions -->
<!-- CONTEXT_SIZE: SMALL -->

<!-- CONTEXT_GROUP: Initialization & Lifecycle -->

**Initialization & Lifecycle:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `ai-init` | Initialize AI subsystem with all integrations | 289-319 | [→](#ai-init) |
| `ai-cleanup` | Cleanup function (registered with _lifecycle) | 324-338 | [→](#ai-cleanup) |

<!-- CONTEXT_GROUP: YAML & Definition Management -->

**YAML & Definition Management:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `ai-parse-yaml` | Parse YAML file to JSON (python3/yq) | 347-435 | [→](#ai-parse-yaml) |
| `ai-list-definitions` | List all available definitions by type | 437-481 | [→](#ai-list-definitions) |
| `ai-find-definition` | Find definition file by name | 483-517 | [→](#ai-find-definition) |
| `ai-load-definition` | Load and parse definition file | 519-568 | [→](#ai-load-definition) |
| `ai-get-field` | Extract field from definition JSON | 570-606 | [→](#ai-get-field) |
| `ai-validate-definition` | Validate definition structure and semantics | 608-704 | [→](#ai-validate-definition) |

<!-- CONTEXT_GROUP: Cache Management -->

**Cache Management:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `ai-cache-get` | Get cached artifact (uses _cache if available) | 792-854 | [→](#ai-cache-get) |
| `ai-cache-set` | Store artifact in cache | 860-908 | [→](#ai-cache-set) |
| `ai-cache-invalidate` | Invalidate cached artifacts by pattern | 914-993 | [→](#ai-cache-invalidate) |
| `ai-cache-status` | Show cache statistics | 998-1041 | [→](#ai-cache-status) |

<!-- CONTEXT_GROUP: Template Engine -->

**Template Engine:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `ai-template-render` | Render Mustache-style template with data | 1043-1077 | [→](#ai-template-render) |
| `ai-template-validate` | Validate template syntax | 1647-1719 | [→](#ai-template-validate) |

<!-- CONTEXT_GROUP: Artifact Generation -->

**Artifact Generation:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `ai-hash-sources` | Calculate SHA256 hash of definition + template | 1721-1754 | [→](#ai-hash-sources) |
| `ai-should-regenerate` | Check if cache is valid or needs regeneration | 1756-1806 | [→](#ai-should-regenerate) |
| `ai-generate-artifact` | Generate artifact from definition + template | 1808-1947 | [→](#ai-generate-artifact) |
| `ai-generate-all` | Batch generate all definitions for a tool | 1993-2090 | [→](#ai-generate-all) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `_ai-emit` | Emit event via _events (wrapper) | 242-250 | Internal |
| `_ai-log` | Logging wrapper for _log integration | 253-280 | Internal |
| `_ai-yaml-to-json` | YAML to JSON conversion helper | 397-402 | Internal |
| `_ai-json-get-field` | JSON field extraction helper | 404-435 | Internal |
| `_ai-validate-structure` | Structural validation dispatcher | 636-705 | Internal |
| `_ai-validate-skill-structure` | Skill-specific structure validation | 707-739 | Internal |
| `_ai-validate-command-structure` | Command-specific structure validation | 741-762 | Internal |
| `_ai-validate-agent-structure` | Agent-specific structure validation | 764-790 | Internal |
| `_ai-render-template` | Template rendering entry point | 1079-1095 | Internal |
| `_ai-process-template` | Recursive template processor | 1097-1164 | Internal |
| `_ai-process-tag` | Process individual Mustache tag | 1166-1238 | Internal |
| `_ai-get-value` | Get value from JSON by dot notation | 1240-1278 | Internal |
| `_ai-extract-block` | Extract content between block tags | 1280-1342 | Internal |
| `_ai-process-if-block` | Process {{#if}} conditional blocks | 1344-1386 | Internal |
| `_ai-process-unless-block` | Process {{#unless}} conditional blocks | 1388-1425 | Internal |
| `_ai-process-each-block` | Process {{#each}} iteration blocks | 1427-1510 | Internal |
| `_ai-is-truthy` | Check if value is truthy | 1512-1523 | Internal |
| `_ai-render-partial` | Render partial template | 1525-1554 | Internal |
| `_ai-helper-join` | Join helper for arrays | 1556-1574 | Internal |
| `_ai-helper-upper` | Uppercase conversion helper | 1576-1583 | Internal |
| `_ai-helper-lower` | Lowercase conversion helper | 1585-1592 | Internal |
| `_ai-helper-default` | Default value helper | 1594-1604 | Internal |
| `_ai-helper-trim` | Whitespace trimming helper | 1606-1613 | Internal |
| `_ai-validate-semantic` | Semantic validation (dependencies, etc) | 1949-1991 | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

### Core Settings

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_ENABLED` | boolean | `true` | Enable/disable AI subsystem |
| `AI_DEFAULT_TOOL` | string | `claude` | Default tool for artifact generation |
| `AI_DEBUG` | boolean | `false` | Enable debug logging |
| `AI_VERBOSE` | boolean | `false` | Enable verbose output |
| `AI_TRACE` | boolean | `false` | Enable trace-level logging |

### Directory Paths (XDG-Compliant)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_DATA_DIR` | path | `~/.local/share/ai` | Data directory |
| `AI_STATE_DIR` | path | `~/.local/state/ai` | State directory |
| `AI_CACHE_DIR` | path | `~/.cache/ai` | Cache directory |
| `AI_SHARE_DIR` | path | `~/.local/share/ai` | Shared data directory |

### Definition & Template Paths

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_DEFINITION_DIR` | path | `$AI_SHARE_DIR/definitions` | Definition files location |
| `AI_TEMPLATE_DIR` | path | `$AI_SHARE_DIR/templates` | Template files location |
| `AI_SCHEMA_DIR` | path | `$AI_SHARE_DIR/schemas` | Schema files location |

### Caching Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_CACHE_TTL` | integer | `3600` | Cache TTL in seconds (1 hour) |
| `AI_CACHE_ENABLED` | boolean | `true` | Enable/disable caching |

### Generation Settings

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_AUTO_SYNC` | boolean | `false` | Auto-sync artifacts on definition change |
| `AI_FORCE_REGENERATE` | boolean | `false` | Always regenerate (ignore cache) |

### Event System

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_EMIT_EVENTS` | boolean | `true` | Emit events via _events extension |

### Template Engine

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `AI_TEMPLATE_MAX_DEPTH` | integer | `10` | Max recursion depth for partials |
| `AI_TEMPLATE_CACHE_ENABLED` | boolean | `true` | Enable template caching |

---

## Events Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

| Event | Payload | Description |
|-------|---------|-------------|
| `ai.init` | `version=<version>` | AI subsystem initialized |
| `ai.cleanup` | `complete` | Cleanup operation completed |
| `ai.definition.loaded` | `type=<type> name=<name>` | Definition loaded successfully |
| `ai.template.loaded` | `file=<path>` | Template loaded successfully |
| `ai.generate.start` | `tool=<tool> name=<name> force=<bool>` | Artifact generation started |
| `ai.generate.complete` | `tool=<tool> name=<name> type=<type>` | Artifact generated successfully |
| `ai.generate.error` | `tool=<tool> name=<name> error=<reason>` | Generation failed |
| `ai.artifact.generated` | `tool=<tool> type=<type> name=<name>` | Artifact created |
| `ai.cache.hit` | `tool=<tool> type=<type> name=<name> source=<source>` | Cache hit occurred |
| `ai.cache.miss` | `tool=<tool> type=<type> name=<name>` | Cache miss occurred |
| `ai.cache.set` | `tool=<tool> type=<type> name=<name> size=<bytes> backend=<backend>` | Artifact cached |
| `ai.cache.invalidate` | `pattern=<pattern> count=<num> backend=<backend>` | Cache invalidated |
| `ai.validate.error` | `file=<path> errors=<count>` | Validation failed |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

### Success

| Code | Constant | Meaning |
|------|----------|---------|
| `0` | `AI_ERR_SUCCESS` | Operation successful |

### General Errors

| Code | Constant | Meaning |
|------|----------|---------|
| `1` | `AI_ERR_GENERAL` | General error |
| `2` | `AI_ERR_INVALID_ARGUMENT` | Invalid argument provided |

### Definition Errors (10-19)

| Code | Constant | Meaning |
|------|----------|---------|
| `10` | `AI_ERR_DEFINITION_NOT_FOUND` | Definition file not found |
| `11` | `AI_ERR_DEFINITION_PARSE_FAILED` | YAML parsing failed |
| `12` | `AI_ERR_DEFINITION_INVALID_STRUCTURE` | Invalid structure |
| `13` | `AI_ERR_DEFINITION_INVALID_SEMANTIC` | Semantic validation failed |
| `14` | `AI_ERR_DEFINITION_DEPENDENCY_MISSING` | Missing dependency |
| `15` | `AI_ERR_DEFINITION_CIRCULAR_DEPENDENCY` | Circular dependency detected |

### Template Errors (20-29)

| Code | Constant | Meaning |
|------|----------|---------|
| `20` | `AI_ERR_TEMPLATE_NOT_FOUND` | Template file not found |
| `21` | `AI_ERR_TEMPLATE_PARSE_FAILED` | Template parsing failed |
| `22` | `AI_ERR_TEMPLATE_INVALID_SYNTAX` | Invalid Mustache syntax |
| `23` | `AI_ERR_TEMPLATE_RENDERING_FAILED` | Template rendering failed |
| `24` | `AI_ERR_TEMPLATE_PARTIAL_NOT_FOUND` | Partial template not found |

### Cache Errors (30-39)

| Code | Constant | Meaning |
|------|----------|---------|
| `30` | `AI_ERR_CACHE_MISS` | Cache miss (not an error) |
| `31` | `AI_ERR_CACHE_WRITE_FAILED` | Failed to write cache |
| `32` | `AI_ERR_CACHE_READ_FAILED` | Failed to read cache |

### Validation Errors (40-49)

| Code | Constant | Meaning |
|------|----------|---------|
| `40` | `AI_ERR_VALIDATION_FAILED` | Generic validation failure |
| `41` | `AI_ERR_INVALID_SCHEMA` | Invalid schema version |
| `42` | `AI_ERR_REQUIRED_FIELD_MISSING` | Required field missing |

### Generation Errors (50-59)

| Code | Constant | Meaning |
|------|----------|---------|
| `50` | `AI_ERR_GENERATION_FAILED` | Generic generation failure |
| `51` | `AI_ERR_FILE_NOT_FOUND` | Required file not found |
| `52` | `AI_ERR_FILE_WRITE_FAILED` | File write operation failed |

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### What is _ai_core?

`_ai_core` is a **tool-agnostic AI abstraction layer** that provides:

- **YAML-based definition system** for AI artifacts (skills, commands, agents)
- **Mustache-style template engine** with conditionals, loops, and helpers
- **Smart artifact generation** with hash-based cache invalidation
- **Multi-stage validation** (structural and semantic)
- **Full library integration** with _lifecycle, _events, _config, _log, and _cache
- **XDG-compliant** directory structure

### Key Features

**🎯 Tool Agnostic**
- Works with any AI tool (Claude Code, ChatGPT, etc.)
- Adapter pattern for tool-specific features
- Reusable definitions across tools

**📝 YAML Definitions**
- Simple, human-readable format
- Schema validation (v1)
- Composition via `extends`
- Semantic validation (dependency checking)

**🎨 Powerful Template Engine**
- Mustache-compatible syntax
- Variables: `{{name}}`, `{{user.email}}`
- Conditionals: `{{#if}}`, `{{#unless}}`
- Loops: `{{#each}}`
- Partials: `{{> header}}`
- Helpers: `{{join arr ", "}}`, `{{upper text}}`

**⚡ Smart Caching**
- SHA256 hash-based invalidation
- In-memory + disk persistence
- _cache library integration
- Configurable TTL

**🔌 Full Integration**
- _lifecycle: Automatic cleanup registration
- _events: 13 events for observability
- _config: Settings persistence
- _log: Structured logging
- _cache: High-performance caching

**🛡️ Production Ready**
- Comprehensive error handling
- Graceful degradation
- XDG Base Directory compliance
- Zero external dependencies (yq/python3)

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    AI Abstraction Layer                  │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │ Definitions │  │  Templates   │  │  Generated     │ │
│  │   (YAML)    │──│  (Mustache)  │──│  Artifacts     │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
│         │                  │                   │         │
│         ▼                  ▼                   ▼         │
│  ┌──────────────────────────────────────────────────┐  │
│  │             _ai_core (Core Engine)                │  │
│  │  • YAML Parser  • Template Engine  • Cache Mgr   │  │
│  │  • Validator    • Event Emitter    • Generator   │  │
│  └──────────────────────────────────────────────────┘  │
│         │                  │                   │         │
│         ▼                  ▼                   ▼         │
│  ┌──────────────────────────────────────────────────┐  │
│  │          Library Integration (Layer 2)            │  │
│  │  _lifecycle │ _events │ _config │ _log │ _cache   │  │
│  └──────────────────────────────────────────────────┘  │
│                          │                              │
└──────────────────────────┼──────────────────────────────┘
                           ▼
              ┌─────────────────────────┐
              │   Tool Adapters (L3)    │
              │  _ai_claude │ _ai_gpt   │
              └─────────────────────────┘
```

### Use Cases

**1. Claude Code Integration**
```zsh
# Define a skill once
cat > ~/.local/share/ai/definitions/skills/security-review.yml <<EOF
schema: "ai-definition/v1"
type: "skill"
name: "security-review"
skill:
  instructions: "Review code for security vulnerabilities..."
EOF

# Generate artifact
ai-generate-artifact claude security-review
# → Creates ~/.claude/skills/security-review.md
```

**2. Multi-Tool Support**
```zsh
# Same definition works for multiple tools
ai-generate-artifact claude security-review
ai-generate-artifact chatgpt security-review
ai-generate-artifact cursor security-review
```

**3. Batch Operations**
```zsh
# Generate all skills for a tool
ai-generate-all claude skills
```

**4. Custom Tools**
```zsh
# Create adapter for your own AI tool
source _ai_core
# Define tool-specific template
# Generate artifacts
```

### When to Use

✅ **Use _ai_core when:**
- Building AI tool integrations
- Managing AI artifact lifecycles
- Need consistent definitions across tools
- Want template-based generation
- Require validation and caching

❌ **Don't use _ai_core when:**
- Simple one-off AI interactions
- No need for artifact management
- Tool-specific features are sufficient

---

## Installation

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Prerequisites

**Required:**
- ZSH 5.0+
- _common v2.0+ (dotfiles library)
- yq v4+ **OR** python3 with PyYAML

**Optional (graceful degradation):**
- _log v2.0+ (structured logging)
- _events v2.0+ (event system)
- _cache v2.0+ (high-performance caching)
- _config v2.0+ (settings persistence)
- _lifecycle v2.0+ (cleanup management)

### Installation Steps

**1. Install via GNU Stow (Recommended)**

```bash
cd ~/.pkgs
git pull  # Get latest library updates
stow lib   # Install all library extensions

# Verify installation
which _ai_core
# → ~/.local/bin/lib/_ai_core
```

**2. Manual Installation**

```bash
# Copy library file
cp ~/.pkgs/lib/.local/bin/lib/_ai_core ~/.local/bin/lib/

# Ensure PATH includes ~/.local/bin/lib
echo 'export PATH="$HOME/.local/bin/lib:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
source _ai_core && ai-init
# → [INFO] ai AI subsystem initialized (version 1.0.0)
```

**3. Install YAML Parser**

**Option A: Install yq (Recommended)**
```bash
# Arch Linux
sudo pacman -S yq

# Ubuntu/Debian
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  -O /usr/bin/yq && sudo chmod +x /usr/bin/yq

# macOS
brew install yq
```

**Option B: Use Python (Fallback)**
```bash
# Most systems have python3 already
python3 -c "import yaml" 2>/dev/null && echo "PyYAML installed" || pip3 install pyyaml
```

**4. Create Directory Structure**

```bash
# XDG-compliant directories (auto-created by ai-init)
mkdir -p ~/.local/share/ai/{definitions/{skills,commands,agents},templates/{claude,common},schemas}
mkdir -p ~/.cache/ai/artifacts
mkdir -p ~/.local/state/ai/temp
```

**5. Verify Installation**

```bash
zsh -c '
source _ai_core

# Check initialization
ai-init
echo "Init status: $?"

# Check library availability
echo "AI_CACHE_AVAILABLE: $AI_CACHE_AVAILABLE"
echo "AI_EVENTS_AVAILABLE: $AI_EVENTS_AVAILABLE"

# Check version
echo "Version: $AI_CORE_VERSION"
'
```

Expected output:
```
[INFO] ai AI subsystem initialized (version 1.0.0)
Init status: 0
AI_CACHE_AVAILABLE: true
AI_EVENTS_AVAILABLE: true
Version: 1.0.0
```

### Directory Structure

After installation:

```
~/.local/share/ai/          # Data directory
├── definitions/            # YAML definition files
│   ├── skills/            # Skill definitions
│   ├── commands/          # Command definitions
│   └── agents/            # Agent definitions
├── templates/             # Mustache templates
│   ├── claude/           # Claude-specific templates
│   │   ├── skill.tmpl
│   │   ├── command.tmpl
│   │   └── agent.tmpl
│   └── common/           # Tool-agnostic templates
└── schemas/               # JSON schemas for validation

~/.cache/ai/               # Cache directory
└── artifacts/             # Generated artifact cache
    └── claude/
        ├── skills/
        └── commands/

~/.local/state/ai/         # State directory
└── temp/                  # Temporary files (auto-cleaned)
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

### Basic Usage

**1. Initialize the subsystem**

```zsh
#!/usr/bin/env zsh
source "$(which _ai_core)"

# Initialize (loads config, registers cleanup, etc.)
ai-init

# Check if ready
if [[ $? -eq 0 ]]; then
    echo "AI subsystem ready"
fi
```

**2. Create a simple definition**

```zsh
# Create a skill definition
cat > ~/.local/share/ai/definitions/skills/hello-world.yml <<'EOF'
schema: "ai-definition/v1"
type: "skill"
name: "hello-world"
version: "1.0.0"
description: "A simple hello world skill for testing"

skill:
  triggers:
    keywords:
      - "hello"
      - "test"

  instructions: |
    This is a test skill that demonstrates the AI library.

    When activated, greet the user warmly and offer assistance.

  examples:
    - "Hello! Can you help me?"
    - "I need to test this skill"

  limitations: |
    This is a demonstration skill only.
EOF
```

**3. Create a template**

```zsh
# Create Claude-specific skill template
cat > ~/.local/share/ai/templates/claude/skill.tmpl <<'EOF'
---
name: {{name}}
description: {{description}}
---

# {{name}}

{{skill.instructions}}

{{#if skill.triggers.keywords}}
## Activation
Keywords: {{join skill.triggers.keywords ", "}}
{{/if}}

{{#if skill.examples}}
## Examples

{{#each skill.examples}}
{{this}}

{{/each}}
{{/if}}

{{#if skill.limitations}}
## Limitations

{{skill.limitations}}
{{/if}}
EOF
```

**4. Generate the artifact**

```zsh
# Generate artifact for Claude Code
artifact=$(ai-generate-artifact claude hello-world)

# Display the result
echo "$artifact"
```

Expected output:
```markdown
---
name: hello-world
description: A simple hello world skill for testing
---

# hello-world

This is a test skill that demonstrates the AI library.

When activated, greet the user warmly and offer assistance.

## Activation
Keywords: hello, test

## Examples

Hello! Can you help me?

I need to test this skill


## Limitations

This is a demonstration skill only.
```

### Working with Cache

**Check if artifact needs regeneration:**

```zsh
if ai-should-regenerate claude skill hello-world \
    ~/.local/share/ai/definitions/skills/hello-world.yml \
    ~/.local/share/ai/templates/claude/skill.tmpl; then
    echo "Cache invalid, regenerating..."
else
    echo "Cache valid, using cached version"
fi
```

**Force regeneration:**

```zsh
ai-generate-artifact claude hello-world --force
```

**Cache statistics:**

```zsh
ai-cache-status
# Output:
# AI Cache Status
# ===============
# Memory cache entries: 3
# Disk cache entries: 5
# Cache hits: 12
# Cache misses: 3
# Hit rate: 80.00%
```

**Invalidate cache:**

```zsh
# Invalidate specific artifact
ai-cache-invalidate "ai:artifact:claude:skill:hello-world"

# Invalidate all Claude skills
ai-cache-invalidate "ai:artifact:claude:skill:*"

# Invalidate everything
ai-cache-invalidate "ai:artifact:*"
```

### Working with Definitions

**List available definitions:**

```zsh
# List all skills
ai-list-definitions skills

# List all commands
ai-list-definitions commands

# List all agents
ai-list-definitions agents
```

**Find a definition:**

```zsh
# Find by name
def_file=$(ai-find-definition hello-world)
echo "Found: $def_file"
# → ~/.local/share/ai/definitions/skills/hello-world.yml
```

**Load and inspect a definition:**

```zsh
# Load definition as JSON
definition=$(ai-load-definition ~/.local/share/ai/definitions/skills/hello-world.yml)

# Extract fields
name=$(ai-get-field "$definition" "name")
version=$(ai-get-field "$definition" "version")
desc=$(ai-get-field "$definition" "description")

echo "Name: $name"
echo "Version: $version"
echo "Description: $desc"
```

**Validate a definition:**

```zsh
if ai-validate-definition ~/.local/share/ai/definitions/skills/hello-world.yml; then
    echo "✓ Definition is valid"
else
    echo "✗ Validation failed"
fi
```

### Event-Driven Operations

**Listen for generation events:**

```zsh
source _ai_core
source _events

# Register event handlers
events-on "ai.generate.start" "echo 'Generation started: \$1'"
events-on "ai.generate.complete" "echo 'Generation complete: \$1'"
events-on "ai.cache.hit" "echo 'Cache hit: \$1'"

# Generate artifact (events will fire)
ai-generate-artifact claude hello-world
```

### Batch Operations

**Generate all definitions for a tool:**

```zsh
# Generate all skills for Claude
ai-generate-all claude skills

# Generate all commands
ai-generate-all claude commands
```

### Integration Example

**Complete utility using _ai_core:**

```zsh
#!/usr/bin/env zsh

# Load dependencies
source "$(which _common)" || exit 1
source "$(which _ai_core)" || exit 1

# Initialize AI subsystem
ai-init || common-die "Failed to initialize AI subsystem"

# Main function
main() {
    local operation="$1"
    local name="$2"

    case "$operation" in
        generate)
            ai-generate-artifact claude "$name"
            ;;
        validate)
            local def_file=$(ai-find-definition "$name")
            ai-validate-definition "$def_file"
            ;;
        list)
            ai-list-definitions "${name:-skills}"
            ;;
        *)
            echo "Usage: $0 {generate|validate|list} [name]"
            return 1
            ;;
    esac
}

main "$@"
```

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Configuration Methods

**1. Environment Variables (Runtime)**

```zsh
# Set before sourcing
export AI_DEBUG=true
export AI_CACHE_TTL=7200
export AI_DEFAULT_TOOL=chatgpt

source _ai_core
ai-init
```

**2. Via _config Library**

```zsh
source _config
source _ai_core

# Set configuration
config-set "ai.debug" "true"
config-set "ai.cache_ttl" "7200"
config-set "ai.default_tool" "chatgpt"

# Initialize (loads from config)
ai-init

# Configuration persists across sessions
```

**3. Per-Session Configuration**

```zsh
# Temporary override (doesn't persist)
AI_DEBUG=true ai-generate-artifact claude my-skill
```

### Common Configurations

**Enable debugging:**

```zsh
export AI_DEBUG=true
export AI_VERBOSE=true
export AI_TRACE=true  # Very detailed
```

**Adjust cache behavior:**

```zsh
# Increase cache TTL to 2 hours
export AI_CACHE_TTL=7200

# Disable caching
export AI_CACHE_ENABLED=false

# Force regeneration
export AI_FORCE_REGENERATE=true
```

**Change default tool:**

```zsh
export AI_DEFAULT_TOOL=chatgpt
```

**Custom directory paths:**

```zsh
export AI_DATA_DIR="$HOME/my-ai-data"
export AI_CACHE_DIR="$HOME/my-ai-cache"
export AI_TEMPLATE_DIR="$HOME/my-templates"
```

**Template engine tuning:**

```zsh
# Increase max recursion depth for complex templates
export AI_TEMPLATE_MAX_DEPTH=20

# Disable template caching
export AI_TEMPLATE_CACHE_ENABLED=false
```

### Configuration Reference

See [Environment Variables Quick Reference](#environment-variables-quick-reference) for all available configuration options.

---

## API Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->

This section provides comprehensive documentation for all public functions.

---

### ai-init

Initialize the AI subsystem.

**Source:** Lines 289-319

**Usage:**
```zsh
ai-init
```

**Description:**

Initializes the AI subsystem by:
1. Loading configuration from _config (if available)
2. Creating required directories
3. Registering cleanup function with _lifecycle
4. Emitting initialization event

This function is idempotent (safe to call multiple times).

**Parameters:** None

**Returns:**
- `0` - Success
- `1` - Initialization failed

**Environment:**
- Reads: All `AI_*` configuration variables
- Sets: `_AI_INITIALIZED=true`

**Events:**
- `ai.init` - Emitted with `version=$AI_CORE_VERSION`

**Example:**
```zsh
source _ai_core

if ai-init; then
    echo "AI subsystem ready"
else
    echo "Initialization failed" >&2
    exit 1
fi
```

**Dependencies:**
- _common (required)
- _config (optional - for persistent config)
- _lifecycle (optional - for cleanup registration)

**Notes:**
- Automatically creates XDG directories if missing
- Gracefully degrades when optional libraries unavailable
- Can be called multiple times safely

---

### ai-cleanup

Cleanup function for AI subsystem.

**Source:** Lines 324-338

**Usage:**
```zsh
ai-cleanup
```

**Description:**

Performs cleanup operations:
1. Removes temporary files from `$AI_STATE_DIR/temp`
2. Clears in-memory caches (`_AI_DEFINITION_CACHE`, `_AI_TEMPLATE_CACHE`, `_AI_ARTIFACT_CACHE`)
3. Emits cleanup event

This function is automatically registered with _lifecycle during `ai-init`.

**Parameters:** None

**Returns:** Always `0`

**Events:**
- `ai.cleanup` - Emitted with `complete`

**Example:**
```zsh
# Manually trigger cleanup
ai-cleanup

# Or let _lifecycle handle it automatically on shell exit
```

**Notes:**
- Registered automatically with _lifecycle
- Safe to call manually if needed
- Does not remove persistent cache (only temp files)

---

### ai-parse-yaml

Parse YAML file to JSON.

**Source:** Lines 347-435

**Usage:**
```zsh
json=$(ai-parse-yaml <file>)
```

**Parameters:**
- `file` - Path to YAML file

**Returns:**
- `0` - Success (JSON to stdout)
- `11` - Parse failed (`AI_ERR_DEFINITION_PARSE_FAILED`)

**Description:**

Parses YAML file to JSON using tiered parser approach:
1. First try: python3 + PyYAML (best JSON escaping)
2. Fallback: yq (if python3 unavailable or fails)

The python3 parser is preferred because it properly escapes control characters in JSON output.

**Example:**
```zsh
json=$(ai-parse-yaml ~/.local/share/ai/definitions/skills/my-skill.yml)
if [[ $? -eq 0 ]]; then
    echo "$json" | jq '.name'
fi
```

**Dependencies:**
- python3 with PyYAML **OR** yq v4+

**Notes:**
- Returns proper JSON (escaped newlines, quotes, etc.)
- Parser priority: python3 → yq
- Both parsers support YAML 1.2 spec

---

### ai-list-definitions

List all available definitions by type.

**Source:** Lines 437-481

**Usage:**
```zsh
ai-list-definitions [type]
```

**Parameters:**
- `type` - Optional: `skills`, `commands`, or `agents` (default: all types)

**Returns:**
- `0` - Success (list to stdout)
- `2` - Invalid type argument

**Description:**

Lists definition files in `$AI_DEFINITION_DIR/{type}/*.yml`.

**Example:**
```zsh
# List all skills
ai-list-definitions skills

# List all commands
ai-list-definitions commands

# List everything
ai-list-definitions

# Output format:
# skills/hello-world.yml
# skills/security-review.yml
# commands/analyze.yml
```

**Output Format:**
One definition per line, format: `{type}/{name}.yml`

**Notes:**
- Only lists `.yml` files
- Returns relative paths from `AI_DEFINITION_DIR`
- Empty output if no definitions found

---

### ai-find-definition

Find definition file by name.

**Source:** Lines 483-517

**Usage:**
```zsh
file=$(ai-find-definition <name>)
```

**Parameters:**
- `name` - Definition name (without `.yml` extension)

**Returns:**
- `0` - Success (path to stdout)
- `10` - Not found (`AI_ERR_DEFINITION_NOT_FOUND`)

**Description:**

Searches for definition file in:
1. `$AI_DEFINITION_DIR/skills/{name}.yml`
2. `$AI_DEFINITION_DIR/commands/{name}.yml`
3. `$AI_DEFINITION_DIR/agents/{name}.yml`

Returns the first match found.

**Example:**
```zsh
def_file=$(ai-find-definition hello-world)
if [[ $? -eq 0 ]]; then
    echo "Found at: $def_file"
else
    echo "Definition not found" >&2
fi
```

**Notes:**
- Searches all three types automatically
- Returns absolute path
- Case-sensitive matching

---

### ai-load-definition

Load and parse definition file.

**Source:** Lines 519-568

**Usage:**
```zsh
definition=$(ai-load-definition <file>)
```

**Parameters:**
- `file` - Path to definition YAML file

**Returns:**
- `0` - Success (JSON to stdout)
- `10` - File not found
- `11` - Parse failed

**Description:**

Loads definition file and converts to JSON. Extracts type and name fields for event emission.

**Events:**
- `ai.definition.loaded` - Emitted with `type=<type> name=<name>`

**Example:**
```zsh
def_file=$(ai-find-definition hello-world)
definition=$(ai-load-definition "$def_file")

# Extract fields
name=$(echo "$definition" | jq -r '.name')
version=$(echo "$definition" | jq -r '.version')
```

**Notes:**
- Returns valid JSON
- Emits event with definition metadata
- Uses `ai-parse-yaml` internally

---

### ai-get-field

Extract field from definition JSON.

**Source:** Lines 570-606

**Usage:**
```zsh
value=$(ai-get-field <json> <field_path>)
```

**Parameters:**
- `json` - Definition JSON string
- `field_path` - Dot-notation field path (e.g., `skill.triggers.keywords`)

**Returns:**
- `0` - Success (value to stdout)
- `1` - Field not found or empty

**Description:**

Extracts field value from JSON using jq with dot notation.

**Example:**
```zsh
definition=$(ai-load-definition "$def_file")

# Simple field
name=$(ai-get-field "$definition" "name")

# Nested field
keywords=$(ai-get-field "$definition" "skill.triggers.keywords")

# Array handling
echo "$keywords" | jq -r '.[]'
```

**Notes:**
- Supports nested fields via dot notation
- Returns empty string (with status 1) if field missing
- Arrays returned as JSON

---

### ai-validate-definition

Validate definition structure and semantics.

**Source:** Lines 608-704

**Usage:**
```zsh
ai-validate-definition <file>
```

**Parameters:**
- `file` - Path to definition file

**Returns:**
- `0` - Valid
- `11` - Parse failed
- `12` - Invalid structure
- `13` - Invalid semantics
- `41` - Invalid schema version

**Description:**

Performs multi-stage validation:
1. Schema version check
2. Structural validation (type-specific)
3. Semantic validation (dependencies, etc.)

**Events:**
- `ai.validate.error` - Emitted on failure with `file=<path> errors=<count>`

**Example:**
```zsh
if ai-validate-definition ~/.local/share/ai/definitions/skills/my-skill.yml; then
    echo "✓ Definition is valid"
else
    echo "✗ Validation failed"
    exit 1
fi
```

**Validation Checks:**

**Structural (all types):**
- `schema` field present and valid
- `type` field present (`skill`, `command`, or `agent`)
- `name` field present and non-empty
- `version` field present and valid

**Type-specific:**

*Skills:*
- `skill.instructions` present

*Commands:*
- `command.name` present
- `command.instructions` present

*Agents:*
- `agent.instructions` present

**Semantic:**
- Dependency validation (if `extends` used)
- Circular dependency detection

**Notes:**
- Comprehensive error reporting
- Logs all validation errors
- Used automatically by `ai-generate-artifact`

---

### ai-cache-get

Get cached artifact.

**Source:** Lines 792-854

**Usage:**
```zsh
artifact=$(ai-cache-get <tool> <type> <name>)
```

**Parameters:**
- `tool` - Tool name (e.g., `claude`)
- `type` - Artifact type (e.g., `skill`)
- `name` - Artifact name

**Returns:**
- `0` - Cache hit (artifact to stdout)
- `30` - Cache miss (`AI_ERR_CACHE_MISS`)
- `2` - Invalid arguments

**Description:**

Retrieves cached artifact using tiered approach:
1. _cache library (if available)
2. In-memory cache (fallback)
3. Filesystem cache (fallback)

**Events:**
- `ai.cache.hit` - On success with `source=library|memory|disk`
- `ai.cache.miss` - On miss

**Example:**
```zsh
# Try to get from cache
if artifact=$(ai-cache-get claude skill hello-world); then
    echo "Cache hit!"
    echo "$artifact"
else
    echo "Cache miss, regenerating..."
    artifact=$(ai-generate-artifact claude hello-world)
fi
```

**Cache Key Format:**
`ai:artifact:{tool}:{type}:{name}`

**Notes:**
- Honors `AI_CACHE_ENABLED` setting
- Checks TTL expiration
- Automatically uses _cache library when available
- Graceful fallback to filesystem cache

---

### ai-cache-set

Store artifact in cache.

**Source:** Lines 860-908

**Usage:**
```zsh
ai-cache-set <tool> <type> <name> <content> [ttl]
```

**Parameters:**
- `tool` - Tool name
- `type` - Artifact type
- `name` - Artifact name
- `content` - Artifact content
- `ttl` - Optional: TTL in seconds (default: `$AI_CACHE_TTL`)

**Returns:**
- `0` - Success
- `1` - Write failed
- `2` - Invalid arguments

**Description:**

Stores artifact in cache using:
1. _cache library (if available)
2. In-memory + filesystem (fallback)

**Events:**
- `ai.cache.set` - With `backend=library|filesystem`

**Example:**
```zsh
artifact=$(ai-generate-artifact claude hello-world)
ai-cache-set claude skill hello-world "$artifact"

# With custom TTL (2 hours)
ai-cache-set claude skill hello-world "$artifact" 7200
```

**Notes:**
- Silently succeeds if caching disabled
- Creates cache directories automatically
- Backend choice based on _cache availability

---

### ai-cache-invalidate

Invalidate cached artifacts by pattern.

**Source:** Lines 914-993

**Usage:**
```zsh
ai-cache-invalidate <pattern>
```

**Parameters:**
- `pattern` - Glob pattern for cache keys

**Returns:**
- `0` - Success
- `2` - Invalid arguments

**Description:**

Invalidates cache entries matching pattern. Supports:
- Specific keys: `ai:artifact:claude:skill:hello-world`
- Tool-wide: `ai:artifact:claude:*`
- Type-wide: `ai:artifact:claude:skill:*`
- Everything: `ai:artifact:*`

**Events:**
- `ai.cache.invalidate` - With `pattern count backend`

**Example:**
```zsh
# Invalidate specific artifact
ai-cache-invalidate "ai:artifact:claude:skill:hello-world"

# Invalidate all Claude skills
ai-cache-invalidate "ai:artifact:claude:skill:*"

# Invalidate everything for Claude
ai-cache-invalidate "ai:artifact:claude:*"

# Nuclear option
ai-cache-invalidate "ai:artifact:*"
```

**Notes:**
- Uses _cache library if available
- Falls back to filesystem pattern matching
- Logs count of invalidated entries

---

### ai-cache-status

Show cache statistics.

**Source:** Lines 998-1041

**Usage:**
```zsh
ai-cache-status
```

**Parameters:** None

**Returns:** Always `0`

**Description:**

Displays cache statistics:
- Memory cache entry count
- Disk cache entry count
- Cache hits/misses
- Hit rate percentage

**Example:**
```zsh
ai-cache-status
```

**Output:**
```
AI Cache Status
===============
Memory cache entries: 5
Disk cache entries: 12
Cache hits: 45
Cache misses: 8
Hit rate: 84.91%
```

**Notes:**
- Counts files in `$AI_CACHE_DIR/artifacts`
- Tracks statistics in global variables
- Hit rate calculated from session statistics

---

### ai-template-render

Render Mustache-style template with data.

**Source:** Lines 1043-1077

**Usage:**
```zsh
rendered=$(ai-template-render <template_file> <json_data>)
```

**Parameters:**
- `template_file` - Path to template file
- `json_data` - JSON data string

**Returns:**
- `0` - Success (rendered output to stdout)
- `20` - Template not found
- `21` - Rendering failed

**Description:**

Renders Mustache template with JSON data. Supports:
- Variables: `{{name}}`
- Dot notation: `{{user.email}}`
- Conditionals: `{{#if field}}...{{/if}}`
- Negation: `{{#unless field}}...{{/unless}}`
- Loops: `{{#each array}}{{this}}{{/each}}`
- Partials: `{{> partial_name}}`
- Helpers: `{{join array ", "}}`, `{{upper text}}`

**Example:**
```zsh
# Create template
cat > /tmp/test.tmpl <<'EOF'
Hello {{name}}!

{{#if premium}}
You are a premium user.
{{/if}}

{{#each items}}
- {{this}}
{{/each}}
EOF

# Create data
data='{
  "name": "Alice",
  "premium": true,
  "items": ["Item 1", "Item 2", "Item 3"]
}'

# Render
rendered=$(ai-template-render /tmp/test.tmpl "$data")
echo "$rendered"
```

**Output:**
```
Hello Alice!

You are a premium user.

- Item 1
- Item 2
- Item 3
```

**Supported Helpers:**
- `join <array> <separator>` - Join array elements
- `upper <string>` - Convert to uppercase
- `lower <string>` - Convert to lowercase
- `default <value> <default>` - Use default if empty
- `trim <string>` - Trim whitespace

**Notes:**
- Full Mustache compatibility
- Recursive partial support (max depth: `$AI_TEMPLATE_MAX_DEPTH`)
- Template caching when enabled

---

### ai-template-validate

Validate template syntax.

**Source:** Lines 1647-1719

**Usage:**
```zsh
ai-template-validate <template_file>
```

**Parameters:**
- `template_file` - Path to template file

**Returns:**
- `0` - Valid
- `20` - Template not found
- `22` - Invalid syntax

**Description:**

Validates Mustache template syntax by checking:
- Balanced opening/closing tags
- Valid helper syntax
- Proper nesting

**Example:**
```zsh
if ai-template-validate ~/.local/share/ai/templates/claude/skill.tmpl; then
    echo "✓ Template is valid"
else
    echo "✗ Template has syntax errors"
fi
```

**Notes:**
- Does not execute template
- Checks structure only
- Reports first error found

---

### ai-hash-sources

Calculate SHA256 hash of definition + template.

**Source:** Lines 1721-1754

**Usage:**
```zsh
hash=$(ai-hash-sources <def_file> <template_file>)
```

**Parameters:**
- `def_file` - Path to definition file
- `template_file` - Path to template file

**Returns:**
- `0` - Success (hash to stdout)
- `1` - Hash calculation failed

**Description:**

Calculates combined SHA256 hash of both files for cache invalidation.

**Example:**
```zsh
hash=$(ai-hash-sources \
    ~/.local/share/ai/definitions/skills/my-skill.yml \
    ~/.local/share/ai/templates/claude/skill.tmpl)

echo "Combined hash: $hash"
# → Combined hash: a3f2b8c9d1e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0
```

**Notes:**
- Uses `sha256sum` command
- Hash changes if either file changes
- Used for cache invalidation

---

### ai-should-regenerate

Check if cache is valid or needs regeneration.

**Source:** Lines 1756-1806

**Usage:**
```zsh
if ai-should-regenerate <tool> <type> <name> <def_file> <template_file>; then
    # Regenerate
else
    # Use cache
fi
```

**Parameters:**
- `tool` - Tool name
- `type` - Artifact type
- `name` - Artifact name
- `def_file` - Path to definition file
- `template_file` - Path to template file

**Returns:**
- `0` - Should regenerate
- `1` - Cache is valid

**Description:**

Determines if artifact should be regenerated by:
1. Checking if cache file exists
2. Comparing stored hash with current hash
3. Checking if cache file is readable

**Example:**
```zsh
if ai-should-regenerate claude skill my-skill \
    ~/.local/share/ai/definitions/skills/my-skill.yml \
    ~/.local/share/ai/templates/claude/skill.tmpl; then
    echo "Cache invalid, regenerating..."
    ai-generate-artifact claude my-skill --force
else
    echo "Using cached version"
fi
```

**Notes:**
- Returns true if cache missing
- Returns true if hash mismatch
- Returns true if metadata corrupted
- Used internally by `ai-generate-artifact`

---

### ai-generate-artifact

Generate artifact from definition + template.

**Source:** Lines 1808-1947

**Usage:**
```zsh
artifact=$(ai-generate-artifact <tool> <name> [--force])
```

**Parameters:**
- `tool` - Tool name (e.g., `claude`)
- `name` - Definition name
- `--force` - Optional: Force regeneration (ignore cache)

**Returns:**
- `0` - Success (artifact to stdout)
- `2` - Invalid arguments
- `10` - Definition not found
- `11` - Parse failed
- `12` - Validation failed
- `20` - Template not found
- `21` - Rendering failed

**Description:**

Complete artifact generation pipeline:
1. Find and load definition
2. Validate definition
3. Find template
4. Check cache (unless --force)
5. Perform semantic validation
6. Render template
7. Store in cache
8. Return artifact

**Events:**
- `ai.generate.start` - At beginning
- `ai.generate.error` - On any error
- `ai.artifact.generated` - On success
- `ai.generate.complete` - At end

**Example:**
```zsh
# Generate skill artifact
artifact=$(ai-generate-artifact claude hello-world)
echo "$artifact" > output.md

# Force regeneration
artifact=$(ai-generate-artifact claude hello-world --force)

# With error handling
if ! artifact=$(ai-generate-artifact claude my-skill 2>&1); then
    echo "Generation failed: $artifact" >&2
    exit 1
fi
```

**Template Search Order:**
1. `$AI_TEMPLATE_DIR/{tool}/{type}.tmpl`
2. `$AI_TEMPLATE_DIR/common/{type}.tmpl`

**Notes:**
- Honors cache by default
- Use `--force` to bypass cache
- Comprehensive error reporting
- All operations logged and evented

---

### ai-generate-all

Batch generate all definitions for a tool.

**Source:** Lines 1993-2090

**Usage:**
```zsh
ai-generate-all <tool> [type]
```

**Parameters:**
- `tool` - Tool name
- `type` - Optional: Limit to specific type (`skills`, `commands`, `agents`)

**Returns:**
- `0` - Success
- `1` - Some generations failed

**Description:**

Generates artifacts for all definitions of specified type(s).

**Example:**
```zsh
# Generate all skills
ai-generate-all claude skills

# Generate all commands
ai-generate-all claude commands

# Generate everything
ai-generate-all claude
```

**Output:**
```
Generating artifacts for: claude (skills)
✓ hello-world
✓ security-review
✗ broken-skill (validation failed)
✓ code-analyzer

Summary: 3 succeeded, 1 failed
```

**Notes:**
- Continues on individual failures
- Reports summary at end
- Returns non-zero if any failed
- Respects cache (no --force option)

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Custom Templates

**Create tool-specific templates:**

```zsh
# Create template directory
mkdir -p ~/.local/share/ai/templates/mytool

# Create skill template
cat > ~/.local/share/ai/templates/mytool/skill.tmpl <<'EOF'
# {{name}}

{{skill.instructions}}

{{#if skill.examples}}
## Examples
{{#each skill.examples}}
- {{this}}
{{/each}}
{{/if}}
EOF

# Use with custom tool
ai-generate-artifact mytool my-skill
```

**Template partials:**

```zsh
# Create partial
cat > ~/.local/share/ai/templates/common/header.tmpl <<'EOF'
---
name: {{name}}
version: {{version}}
generated: $(date -Iseconds)
---
EOF

# Use in main template
cat > ~/.local/share/ai/templates/claude/skill.tmpl <<'EOF'
{{> header}}

# {{name}}

{{skill.instructions}}
EOF
```

### Definition Composition

**Extend existing definitions:**

```zsh
# Base definition
cat > ~/.local/share/ai/definitions/skills/base-review.yml <<'EOF'
schema: "ai-definition/v1"
type: "skill"
name: "base-review"
skill:
  instructions: |
    Perform comprehensive code review.
EOF

# Extended definition
cat > ~/.local/share/ai/definitions/skills/security-review.yml <<'EOF'
schema: "ai-definition/v1"
type: "skill"
name: "security-review"
extends: "base-review"
skill:
  instructions: |
    Perform security-focused code review.

    Focus on:
    - SQL injection
    - XSS vulnerabilities
    - Authentication bypass
EOF
```

### Event-Driven Workflows

**Auto-install artifacts on generation:**

```zsh
source _events
source _ai_core

# Define handler
install-artifact() {
    local event_data="$1"

    # Parse event data
    eval "local $event_data"  # Sets tool, type, name

    # Get artifact
    local artifact=$(ai-cache-get "$tool" "$type" "$name")

    # Install to tool-specific location
    case "$tool" in
        claude)
            echo "$artifact" > ~/.claude/${type}s/${name}.md
            echo "Installed to ~/.claude/${type}s/${name}.md"
            ;;
    esac
}

# Register handler
events-on "ai.artifact.generated" install-artifact

# Generate (auto-installs)
ai-generate-artifact claude my-skill
```

**Cache warming:**

```zsh
# Pre-generate all artifacts
warm-cache() {
    local tool="$1"

    echo "Warming cache for $tool..."

    for type in skills commands agents; do
        ai-generate-all "$tool" "$type"
    done

    echo "Cache warmed!"
}

warm-cache claude
```

### Custom Helpers

**Add custom template helpers:**

```zsh
# Define helper in your script
_ai-helper-capitalize() {
    local args="$1"
    local data="$2"
    local value
    value=$(_ai-get-value "$args" "$data")
    # Capitalize first letter
    echo "${value:u:1}${value:l:2}"
}

# Use in template
# {{capitalize name}}
```

### Multi-Tool Workflow

**Generate for multiple tools:**

```zsh
generate-for-all-tools() {
    local definition="$1"

    for tool in claude chatgpt cursor; do
        echo "Generating for $tool..."
        ai-generate-artifact "$tool" "$definition"
    done
}

generate-for-all-tools my-skill
```

### Testing & Validation

**Validate all definitions:**

```zsh
validate-all() {
    local failed=0

    for type in skills commands agents; do
        local defs=( ~/.local/share/ai/definitions/$type/*.yml )

        for def in "${defs[@]}"; do
            if ai-validate-definition "$def"; then
                echo "✓ $def"
            else
                echo "✗ $def"
                (( failed++ ))
            fi
        done
    done

    echo ""
    echo "Failed: $failed"
    return $(( failed > 0 ))
}

validate-all
```

**Test template rendering:**

```zsh
test-template() {
    local template="$1"

    # Create test data
    local test_data='{
        "name": "test",
        "version": "1.0.0",
        "skill": {
            "instructions": "Test instructions",
            "examples": ["Example 1", "Example 2"]
        }
    }'

    # Render
    ai-template-render "$template" "$test_data"
}

test-template ~/.local/share/ai/templates/claude/skill.tmpl
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Common Issues

#### 1. "YAML parsing requires yq or python3"

**Problem:** Neither yq nor python3 with PyYAML is installed.

**Solution:**

```bash
# Option A: Install yq (recommended)
# Arch
sudo pacman -S yq

# Ubuntu/Debian
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  -O /usr/bin/yq && sudo chmod +x /usr/bin/yq

# macOS
brew install yq

# Option B: Install PyYAML
pip3 install pyyaml
```

#### 2. "Definition not found"

**Problem:** `ai-find-definition` returns error.

**Diagnosis:**

```zsh
# Check definition directory
ls -la ~/.local/share/ai/definitions/skills/

# Verify file exists
find ~/.local/share/ai/definitions -name "my-skill.yml"

# Check AI_DEFINITION_DIR
echo "$AI_DEFINITION_DIR"
```

**Solution:**

```zsh
# Ensure definition is in correct location
mkdir -p ~/.local/share/ai/definitions/skills
cp my-skill.yml ~/.local/share/ai/definitions/skills/

# Or set custom path
export AI_DEFINITION_DIR="/path/to/my/definitions"
```

#### 3. "Template not found"

**Problem:** `ai-generate-artifact` can't find template.

**Diagnosis:**

```zsh
# Check template directory
ls -la ~/.local/share/ai/templates/claude/

# Verify expected template exists
ls ~/.local/share/ai/templates/claude/skill.tmpl
```

**Solution:**

```zsh
# Create template
mkdir -p ~/.local/share/ai/templates/claude
cat > ~/.local/share/ai/templates/claude/skill.tmpl <<'EOF'
---
name: {{name}}
---
# {{name}}
{{skill.instructions}}
EOF
```

#### 4. "jq: parse error"

**Problem:** YAML contains unescaped control characters.

**Diagnosis:**

```zsh
# Check parser being used
AI_DEBUG=true ai-parse-yaml my-file.yml 2>&1 | grep -i "using"
```

**Solution:**

```zsh
# Force python3 parser (better escaping)
unset AI_YQ_AVAILABLE  # Temporary override
ai-parse-yaml my-file.yml

# Or install python3 + PyYAML
pip3 install pyyaml
```

#### 5. Cache not working

**Problem:** Artifacts always regenerate.

**Diagnosis:**

```zsh
# Check cache status
ai-cache-status

# Check if caching enabled
echo "$AI_CACHE_ENABLED"

# Check cache directory
ls -la ~/.cache/ai/artifacts/
```

**Solution:**

```zsh
# Enable caching
export AI_CACHE_ENABLED=true

# Check permissions
chmod -R u+rw ~/.cache/ai/

# Clear corrupted cache
ai-cache-invalidate "ai:artifact:*"
```

#### 6. "command not found: cache-get"

**Problem:** _cache library not available.

**Note:** This is not actually an error! The code gracefully falls back to filesystem cache.

**To confirm:**

```zsh
echo "$AI_CACHE_AVAILABLE"
# → false (using filesystem fallback)
```

**To enable _cache library:**

```zsh
# Install _cache
cd ~/.pkgs
stow lib

# Verify
source _cache && echo "Available"
```

#### 7. Validation fails for valid definition

**Problem:** `ai-validate-definition` returns error for seemingly valid file.

**Diagnosis:**

```zsh
# Enable debug mode
AI_DEBUG=true ai-validate-definition my-skill.yml

# Check JSON conversion
ai-parse-yaml my-skill.yml | jq '.'

# Validate schema field
ai-parse-yaml my-skill.yml | jq -r '.schema'
```

**Common causes:**

- Wrong schema version (must be `ai-definition/v1`)
- Missing required fields (`name`, `type`, `version`)
- Invalid type-specific fields
- YAML syntax errors

**Solution:**

```zsh
# Check against working example
cat > ~/.local/share/ai/definitions/skills/test.yml <<'EOF'
schema: "ai-definition/v1"
type: "skill"
name: "test"
version: "1.0.0"
description: "Test skill"
skill:
  instructions: "Test instructions"
EOF

ai-validate-definition ~/.local/share/ai/definitions/skills/test.yml
```

#### 8. Template rendering produces empty output

**Problem:** `ai-template-render` returns empty string.

**Diagnosis:**

```zsh
# Test with simple template
echo "Hello {{name}}" > /tmp/test.tmpl
ai-template-render /tmp/test.tmpl '{"name":"World"}'

# Enable debug mode
AI_DEBUG=true ai-template-render my-template.tmpl "$data"
```

**Common causes:**

- Invalid JSON data
- Field names don't match template variables
- Conditionals evaluating to false

**Solution:**

```zsh
# Validate JSON
echo "$data" | jq '.'

# Check field names match
echo "$data" | jq -r 'keys'
```

### Debug Mode

Enable comprehensive debugging:

```zsh
export AI_DEBUG=true
export AI_VERBOSE=true
export AI_TRACE=true

# Run operation
ai-generate-artifact claude my-skill
```

### Getting Help

**Check function exists:**

```zsh
type ai-generate-artifact
```

**View source:**

```zsh
which _ai_core
cat ~/.local/bin/lib/_ai_core | less
```

**Test in isolation:**

```zsh
zsh -c 'source _ai_core && ai-init && echo "Working"'
```

**Enable all debugging:**

```zsh
#!/usr/bin/env zsh
set -x  # Trace all commands
source _ai_core
ai-init
ai-generate-artifact claude test-skill
```

---


## Performance Characteristics

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

### Complexity Analysis

| Operation | Time Complexity | Space Complexity | Caching | Notes |
|-----------|----------------|------------------|---------|-------|
| `ai-parse-yaml` | O(n) | O(n) | No | n = file size; yq/python |
| `ai-load-definition` | O(n) | O(n) | No | Includes YAML parsing |
| `ai-get-field` | O(1) | O(1) | No | jq direct access |
| `ai-validate-definition` | O(m) | O(1) | No | m = field count |
| `ai-template-render` | O(n*d) | O(n) | Yes* | n = template size, d = depth |
| `ai-generate-artifact` | O(n+m+t) | O(n+m) | Yes | n = def, m = tmpl, t = render |
| `ai-cache-get` | O(1) | O(1) | N/A | Hash lookup (_cache) |
| `ai-cache-set` | O(1) | O(n) | N/A | n = artifact size |
| `ai-cache-invalidate` | O(k) | O(1) | N/A | k = matching entries |
| `ai-hash-sources` | O(n+m) | O(1) | No | n = def size, m = tmpl size |
| `ai-should-regenerate` | O(1) | O(1) | No | Hash comparison only |

\* Template rendering is cached if `AI_TEMPLATE_CACHE_ENABLED=true`

### Caching Strategy

**Multi-Tier Caching:**

1. **Template Cache** (in-memory, per-session):
   - TTL: Session lifetime
   - Backend: ZSH associative array
   - Purpose: Avoid re-rendering identical templates
   - Invalidation: None (session-based)

2. **Artifact Cache** (persistent, hash-based):
   - TTL: Configurable (`AI_CACHE_TTL`, default: 3600s)
   - Backend: `_cache` library (if available) or filesystem
   - Purpose: Skip regeneration when sources unchanged
   - Invalidation: Hash mismatch or manual invalidation
   - Key format: `ai:artifact:{tool}:{type}:{name}`

3. **Source Hash Cache** (computed on demand):
   - No persistence
   - Computed: SHA256(definition content + template content)
   - Purpose: Detect source changes efficiently

**Cache Hit Ratio:**
- Expected: 80-95% for stable definitions
- Measured: Via `ai-cache-status` (shows hits/misses)

### Performance Optimizations

**YAML Parsing:**
- Prefers `yq` (native binary, ~10x faster than Python)
- Falls back to `python3 -c` (interpreted, slower but portable)
- One-time parse per load (results not cached)

**Template Rendering:**
- Recursive descent parser: O(n) per template pass
- Partial depth limit: `AI_TEMPLATE_MAX_DEPTH` (default: 10)
- Tag matching: Regex-based (pre-compiled patterns)
- No DOM tree (streaming render)

**Hash Computation:**
- Uses `shasum -a 256` (native binary)
- Only computes on cache miss or regeneration check
- Compares hashes, not file timestamps (content-addressed)

**File I/O:**
- Lazy loading: Definitions loaded only when accessed
- Atomic writes: Temp file + rename pattern
- No background processes
- No file watching (manual invalidation)

### Bottlenecks

**Known Performance Limitations:**

1. **Large YAML Files (>1MB)**:
   - Parsing dominates: O(n) with n = file size
   - Mitigation: Keep definitions small, modular
   - Workaround: Pre-convert to JSON

2. **Complex Template Nesting (depth >5)**:
   - Recursive rendering: O(n*d)
   - Mitigation: Reduce partial nesting
   - Limit: `AI_TEMPLATE_MAX_DEPTH=10`

3. **Cache Invalidation (pattern matching)**:
   - Full scan: O(k) where k = cache entries
   - Mitigation: Use specific patterns, not wildcards
   - _cache library helps (native hash iteration)

4. **First-Run Overhead**:
   - Cold start: ~50-100ms (dependency loading)
   - Warm start: ~10-20ms (already sourced)
   - Mitigation: Source once, use many times

### Benchmarks

**Typical Operation Times** (on modern hardware):

| Operation | Cold | Warm | Cached |
|-----------|------|------|--------|
| `ai-init` | 50ms | 10ms | N/A |
| `ai-parse-yaml` (100 lines) | 30ms | 30ms | N/A |
| `ai-load-definition` | 80ms | 40ms | N/A |
| `ai-template-render` (1KB) | 20ms | 15ms | 2ms |
| `ai-generate-artifact` | 150ms | 80ms | 5ms |
| `ai-cache-get` | N/A | 3ms | 2ms |

\* Measurements approximate, vary by system

### Scaling Characteristics

**Number of Definitions:**
- Linear lookup: O(n) for `ai-list-definitions`
- No indexing (simple filesystem scan)
- Practical limit: ~1000 definitions (10-50ms scan)

**Artifact Size:**
- No impact on generation time (streaming writes)
- Cache storage: O(n) disk space
- Practical limit: Filesystem constraints

**Concurrent Access:**
- Not thread-safe (ZSH limitation)
- No locking mechanisms
- Use case: Single-user, sequential operations

---

## See Also

- `_ai_claude` - Claude Code adapter (specialized tool integration)
- `_cache` - High-performance caching library
- `_events` - Event system for reactive workflows
- `_config` - Configuration persistence
- `_lifecycle` - Lifecycle management and cleanup
- `_log` - Structured logging

**Related Documentation:**
- [Definition Authoring Guide](../AUTHORING-DEFINITIONS.md)
- [Template Authoring Guide](../AUTHORING-TEMPLATES.md)
- [Integration Examples](../INTEGRATION-EXAMPLES.md)

**External Links:**
- [Mustache Template Syntax](https://mustache.github.io/mustache.5.html)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [yq Documentation](https://mikefarah.gitbook.io/yq/)

---

**Version:** 1.0.0
**Last Updated:** 2025-11-08
**Maintainer:** andronics
**License:** MIT
