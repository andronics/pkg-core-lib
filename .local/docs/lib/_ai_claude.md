# _ai_claude - Claude Code CLI Adapter

**Lines:** 964 | **Functions:** 21 (19 public + 2 internal) | **Examples:** 35+
**Version:** 1.0.0 | **Layer:** Integration (Layer 3) | **Source:** `~/.local/bin/lib/_ai_claude`

---

## Quick Access Index

### Compact References (Lines 10-300)
- [Function Reference](#function-quick-reference) - 21 functions mapped
- [Environment Variables](#environment-variables-quick-reference) - 10+ variables
- [Artifact Types](#artifact-types) - Skills, Commands, Agents

### Main Sections
- [Overview](#overview) (Lines 300-450, ~150 lines) 🔥 HIGH PRIORITY
- [Prerequisites](#prerequisites) (Lines 450-550, ~100 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 550-800, ~250 lines) 🔥 HIGH PRIORITY
- [Configuration](#configuration) (Lines 800-950, ~150 lines) ⚡ MEDIUM
- [API Reference](#api-reference) (Lines 950-1800, ~850 lines) ⚡ LARGE SECTION
- [Artifact Types](#artifact-types-detailed) (Lines 1800-2000, ~200 lines) 💡 REFERENCE
- [Troubleshooting](#troubleshooting) (Lines 2000-2200, ~200 lines) 🔧 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

**CLI Detection & Compatibility:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-check-installed` | Check if Claude Code CLI is installed | 108-126 | [→](#claude-check-installed) |
| `claude-get-version` | Get Claude Code CLI version | 128-154 | [→](#claude-get-version) |
| `claude-check-compatibility` | Check version compatibility | 156-185 | [→](#claude-check-compatibility) |

**CLI Execution:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-exec` | Execute Claude CLI command | 187-254 | [→](#claude-exec) |
| `claude-exec-json` | Execute and parse JSON response | 256-316 | [→](#claude-exec-json) |

**Session Management:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-session-start` | Start new Claude session | 318-401 | [→](#claude-session-start) |
| `claude-session-continue` | Continue existing session | 403-466 | [→](#claude-session-continue) |
| `claude-session-end` | End Claude session | 468-507 | [→](#claude-session-end) |

**Configuration:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-config-get` | Get configuration value | 509-536 | [→](#claude-config-get) |
| `claude-config-set` | Set configuration value | 538-570 | [→](#claude-config-set) |
| `claude-model-get` | Get current model | 572-580 | [→](#claude-model-get) |
| `claude-model-set` | Set default model | 582-597 | [→](#claude-model-set) |

**Initialization:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-init` | Initialize Claude adapter | 599-623 | [→](#claude-init) |

**Artifact Generation:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-generate-skill` | Generate skill artifact | 625-663 | [→](#claude-generate-skill) |
| `claude-generate-command` | Generate command artifact | 665-702 | [→](#claude-generate-command) |
| `claude-generate-agent` | Generate agent artifact | 704-773 | [→](#claude-generate-agent) |

**Artifact Installation:**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `claude-install-artifact` | Install artifact to ~/.claude/ | 775-817 | [→](#claude-install-artifact) |
| `claude-ensure-artifact` | Smart install (skip if exists) | 819-889 | [→](#claude-ensure-artifact) |
| `claude-ensure-all` | Batch ensure all artifacts | 891-964 | [→](#claude-ensure-all) |

**Internal Functions (Private API):**

| Function | Description | Source Lines | Link |
|----------|-------------|--------------|------|
| `_claude-log` | Logging wrapper | 91-106 | Internal |
| `_claude-get-install-path` | Get installation path for artifact type | 747-773 | Internal |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

### Claude CLI Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CLAUDE_CLI_PATH` | string | `claude` | Path to Claude CLI executable |
| `CLAUDE_DEFAULT_MODEL` | string | `sonnet` | Default Claude model |
| `CLAUDE_MIN_VERSION` | string | `1.0.0` | Minimum required CLI version |

### Session Management

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CLAUDE_SESSION_DIR` | path | `$AI_STATE_DIR/claude/sessions` | Session storage directory |
| `CLAUDE_SESSION_TTL` | integer | `3600` | Session TTL in seconds |

### Artifact Installation

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CLAUDE_INSTALL_DIR` | path | `~/.claude` | Claude Code artifact directory |
| `CLAUDE_SKILLS_DIR` | path | `$CLAUDE_INSTALL_DIR/skills` | Skills installation directory |
| `CLAUDE_COMMANDS_DIR` | path | `$CLAUDE_INSTALL_DIR/commands` | Commands installation directory |
| `CLAUDE_AGENTS_DIR` | path | `$CLAUDE_INSTALL_DIR/agents` | Agents installation directory |

### Behavior

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CLAUDE_AUTO_INSTALL` | boolean | `true` | Auto-install generated artifacts |

---

## Artifact Types

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

### Skills

Claude Code skills are specialized capabilities that enhance Claude's functionality.

**Location:** `~/.claude/skills/`
**Format:** Markdown with YAML frontmatter
**Activation:** Keyword-based or explicit

**Example:**
```markdown
---
name: security-review
description: Comprehensive security code review
---

# security-review

Review code for common security vulnerabilities including SQL injection, XSS, CSRF...
```

### Commands

Claude Code commands are slash commands that trigger specific behaviors.

**Location:** `~/.claude/commands/`
**Format:** Markdown with YAML frontmatter
**Activation:** `/command-name [args]`

**Example:**
```markdown
---
command: /security-review
description: Perform security audit on codebase
arguments: [--depth, --report]
---

# /security-review

Perform comprehensive security audit...
```

### Agents

Claude Code agents are specialized sub-agents with specific roles and expertise.

**Location:** `~/.claude/agents/`
**Format:** Markdown with YAML frontmatter
**Activation:** Task tool invocation

**Example:**
```markdown
---
name: security-expert
description: Security analysis specialist
role: Security Auditor
---

# security-expert

Specialized agent for security analysis...
```

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### What is _ai_claude?

`_ai_claude` is a **Claude Code CLI adapter** that extends `_ai_core` with Claude-specific functionality:

- **CLI integration** - Detect, validate, and execute Claude Code CLI commands
- **Session management** - Create and manage conversational sessions
- **Artifact generation** - Generate Claude-specific skills, commands, and agents
- **Smart installation** - Install artifacts to `~/.claude/` with conflict detection
- **Configuration management** - Get/set Claude Code settings
- **Model management** - Select and configure Claude models

### Key Features

**🎯 Claude Code Integration**
- Automatic CLI detection and version checking
- Headless execution support
- JSON response parsing
- Error handling and logging

**💬 Session Management**
- Create multi-turn conversations
- Session persistence
- Session metadata tracking
- Configurable TTL

**📦 Artifact Management**
- Generate skills, commands, and agents
- Template-based generation (via _ai_core)
- Smart installation to `~/.claude/`
- Conflict detection and prevention

**⚙️ Configuration**
- Get/set Claude Code configuration
- Model selection (sonnet, opus, haiku)
- Installation path management

**🔌 Full _ai_core Integration**
- Uses core template engine
- Honors core caching
- Emits core events
- Follows core validation

### Architecture

```
┌────────────────────────────────────────────┐
│         Claude Code CLI Adapter             │
├────────────────────────────────────────────┤
│                                             │
│  ┌──────────────┐  ┌──────────────────┐   │
│  │ CLI Wrapper  │  │ Artifact Manager │   │
│  │ • Detection  │  │ • Generation     │   │
│  │ • Execution  │  │ • Installation   │   │
│  │ • Sessions   │  │ • Validation     │   │
│  └──────────────┘  └──────────────────┘   │
│         │                    │             │
│         ▼                    ▼             │
│  ┌────────────────────────────────────┐   │
│  │       _ai_core (Template Engine)    │   │
│  │  • YAML Parser • Template Renderer │   │
│  │  • Cache Manager • Event Emitter   │   │
│  └────────────────────────────────────┘   │
│                    │                       │
└────────────────────┼───────────────────────┘
                     ▼
         ┌──────────────────────┐
         │  Claude Code CLI      │
         │  ~/.claude/ artifacts │
         └──────────────────────┘
```

### Use Cases

**1. Generate Claude Skills**
```zsh
# Create skill definition
cat > ~/.local/share/ai/definitions/skills/security-review.yml <<EOF
schema: "ai-definition/v1"
type: "skill"
name: "security-review"
skill:
  instructions: "Perform security review..."
EOF

# Generate and install
claude-generate-skill security-review
# → Creates ~/.claude/skills/security-review.md
```

**2. Batch Install All Skills**
```zsh
# Ensure all skills are installed
claude-ensure-all skills
```

**3. Session Management**
```zsh
# Start session
session_id=$(claude-session-start "Help me review this code for security issues")

# Continue conversation
claude-session-continue "$session_id" "Focus on SQL injection"

# End session
claude-session-end "$session_id"
```

**4. Configuration Management**
```zsh
# Set model
claude-model-set opus

# Get current model
model=$(claude-model-get)
echo "Using model: $model"
```

### When to Use

✅ **Use _ai_claude when:**
- Building Claude Code integrations
- Managing Claude skills/commands/agents
- Need programmatic CLI access
- Want template-based artifact generation
- Require session management

❌ **Don't use _ai_claude when:**
- Using Claude Code interactively
- No need for automation
- Working with other AI tools (use _ai_core directly)

---

## Prerequisites

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Requirements

**Required:**
- _ai_core v1.0+ (artifact generation engine)
- Claude Code CLI v1.0+

**Optional:**
- _lifecycle v2.0+ (session cleanup)
- _events v2.0+ (event monitoring)
- _config v2.0+ (configuration persistence)

### Installing Claude Code CLI

**macOS/Linux:**

```bash
# Via npm (recommended)
npm install -g @anthropic/claude-code

# Or download binary
curl -L https://claude.com/download/cli | bash

# Verify installation
claude --version
```

**Arch Linux:**

```bash
# Via AUR
yay -S claude-code

# Or manual
wget https://github.com/anthropics/claude-code/releases/latest/download/claude-linux
chmod +x claude-linux
sudo mv claude-linux /usr/local/bin/claude
```

### Verifying Installation

```zsh
# Check CLI
which claude
# → /usr/local/bin/claude

claude --version
# → Claude Code v1.2.3

# Check adapter
source _ai_claude

if claude-check-installed; then
    echo "Claude Code CLI ready"
    echo "Version: $(claude-get-version)"
fi
```

### Setting Up Directories

```bash
# Claude Code artifact directories (auto-created)
mkdir -p ~/.claude/{skills,commands,agents}

# Definition directories (from _ai_core)
mkdir -p ~/.local/share/ai/definitions/{skills,commands,agents}

# Templates
mkdir -p ~/.local/share/ai/templates/claude
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

### Basic Workflow

**1. Initialize adapter**

```zsh
#!/usr/bin/env zsh
source "$(which _ai_core)"
source "$(which _ai_claude)"

# Initialize both systems
ai-init
claude-init

# Verify Claude CLI
if ! claude-check-installed; then
    echo "Claude Code CLI not found" >&2
    exit 1
fi

echo "Ready to generate artifacts"
```

**2. Create skill definition**

```zsh
# Create definition
cat > ~/.local/share/ai/definitions/skills/code-security.yml <<'EOF'
schema: "ai-definition/v1"
type: "skill"
name: "code-security"
version: "1.0.0"
description: "Security code review specialist"

skill:
  triggers:
    keywords:
      - "security"
      - "vulnerability"
      - "audit"

  scope:
    tools:
      - "Read"
      - "Grep"
      - "Bash"

  preferences:
    model: "sonnet"

  instructions: |
    You are a security code review specialist.

    When reviewing code, check for:
    - SQL injection vulnerabilities
    - Cross-site scripting (XSS)
    - Authentication bypass
    - Insecure deserialization
    - Path traversal
    - Command injection
    - CSRF vulnerabilities

    Provide:
    1. Severity rating (CRITICAL/HIGH/MEDIUM/LOW)
    2. Affected code location
    3. Proof of concept
    4. Remediation steps

  examples:
    - "Review this authentication handler for security issues"
    - "Check this SQL query for injection vulnerabilities"

  limitations: |
    This skill focuses on common OWASP Top 10 vulnerabilities.
    For specialized security audits, consult a security expert.
EOF
```

**3. Generate artifact**

```zsh
# Generate skill
claude-generate-skill code-security

# Check where it was installed
ls -l ~/.claude/skills/code-security.md
```

**4. Use in Claude Code**

```bash
# Claude Code CLI
claude

# In Claude Code session:
# > I need a security review
# (skill activates automatically based on keyword)
```

### Working with Commands

**Create command definition:**

```zsh
cat > ~/.local/share/ai/definitions/commands/security-scan.yml <<'EOF'
schema: "ai-definition/v1"
type: "command"
name: "security-scan"
version: "1.0.0"
description: "Run automated security scan"

command:
  name: "security-scan"

  arguments:
    - "--depth"
    - "--output"

  scope:
    context:
      - "codebase"
      - "dependencies"

  instructions: |
    Perform automated security scanning:

    1. Scan all source files for common vulnerabilities
    2. Check dependencies for known CVEs
    3. Analyze authentication/authorization code
    4. Review API endpoints for security flaws

    Report findings in severity order.

  usage: |
    Use `/security-scan` to run a full security audit.

    Options:
    - `--depth shallow|deep` - Scan depth
    - `--output summary|detailed` - Report format

  examples:
    - "/security-scan"
    - "/security-scan --depth deep"
    - "/security-scan --depth deep --output detailed"

  output: |
    Structured security report with:
    - Vulnerability count by severity
    - Detailed findings
    - Remediation recommendations
EOF
```

**Generate and use:**

```zsh
# Generate
claude-generate-command security-scan

# Use in Claude Code
# > /security-scan --depth deep
```

### Working with Agents

**Create agent definition:**

```zsh
cat > ~/.local/share/ai/definitions/agents/security-auditor.yml <<'EOF'
schema: "ai-definition/v1"
type: "agent"
name: "security-auditor"
version: "1.0.0"
description: "Specialized security audit agent"

agent:
  role:
    persona: "Senior Security Auditor"
    expertise:
      - "OWASP Top 10"
      - "Cryptography"
      - "Authentication systems"
      - "Secure coding practices"

  scope:
    tools:
      - "Read"
      - "Grep"
      - "Bash"
      - "WebFetch"

  preferences:
    model: "opus"

  instructions: |
    You are a senior security auditor specializing in application security.

    Your role:
    1. Identify security vulnerabilities
    2. Assess risk and impact
    3. Recommend remediation
    4. Verify fixes

    Your approach:
    - Thorough and methodical
    - Risk-based prioritization
    - Clear communication
    - Actionable recommendations

  workflow: |
    1. **Discovery**: Analyze codebase structure and attack surface
    2. **Analysis**: Deep-dive into security-critical components
    3. **Testing**: Verify vulnerability theories
    4. **Reporting**: Document findings with PoCs
    5. **Remediation**: Guide fix implementation

  constraints: |
    - No actual exploitation of vulnerabilities
    - No unauthorized access attempts
    - Stay within defined scope
    - Respect data privacy

  examples:
    - "Audit this authentication system for vulnerabilities"
    - "Review API security controls"
EOF
```

**Generate and use:**

```zsh
# Generate
claude-generate-agent security-auditor

# Use via Task tool in Claude Code
# > Use the Task tool with security-auditor agent to audit this codebase
```

### Batch Operations

**Install all artifacts:**

```zsh
# Ensure all skills installed
claude-ensure-all skills

# Ensure all commands
claude-ensure-all commands

# Ensure all agents
claude-ensure-all agents
```

**Force regeneration:**

```zsh
# Force regenerate all skills
for skill in ~/.local/share/ai/definitions/skills/*.yml; do
    name=$(basename "$skill" .yml)
    claude-generate-skill "$name" --force
done
```

### Session Example

**Interactive conversation:**

```zsh
# Start session
session_id=$(claude-session-start "I need to review code for security issues")
echo "Session ID: $session_id"

# Continue (multi-turn)
response=$(claude-session-continue "$session_id" "Focus on authentication")
echo "Response: $response"

response=$(claude-session-continue "$session_id" "Check for SQL injection")
echo "Response: $response"

# End session
claude-session-end "$session_id"
```

---

## Configuration

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Model Selection

**Set default model:**

```zsh
# Set to opus (most capable)
claude-model-set opus

# Set to sonnet (balanced)
claude-model-set sonnet

# Set to haiku (fastest)
claude-model-set haiku

# Get current model
model=$(claude-model-get)
echo "Current model: $model"
```

**Per-artifact model:**

In definition YAML:
```yaml
skill:
  preferences:
    model: "opus"  # Override default for this skill
```

### Installation Paths

**Customize paths:**

```zsh
# Custom Claude install directory
export CLAUDE_INSTALL_DIR="$HOME/my-claude-artifacts"

# Custom skills directory
export CLAUDE_SKILLS_DIR="$CLAUDE_INSTALL_DIR/my-skills"

# Reinitialize
claude-init
```

### CLI Path

**Custom CLI location:**

```zsh
# If Claude CLI is not in PATH
export CLAUDE_CLI_PATH="/opt/claude/bin/claude"

# Verify
claude-check-installed
```

### Session Configuration

**Adjust session behavior:**

```zsh
# Increase session TTL to 2 hours
export CLAUDE_SESSION_TTL=7200

# Custom session directory
export CLAUDE_SESSION_DIR="$HOME/my-sessions"
```

### Auto-Installation

**Control auto-install behavior:**

```zsh
# Disable auto-install
export CLAUDE_AUTO_INSTALL=false

# Now generation doesn't auto-install
artifact=$(claude-generate-skill my-skill)

# Manual install
echo "$artifact" > ~/.claude/skills/my-skill.md
```

---

## API Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: LARGE -->

### claude-check-installed

Check if Claude Code CLI is installed and accessible.

**Source:** Lines 108-126

**Usage:**
```zsh
if claude-check-installed; then
    echo "Claude Code is installed"
fi
```

**Parameters:** None

**Returns:**
- `0` - CLI is installed and accessible
- `1` - CLI not found

**Description:**

Checks for Claude Code CLI in PATH. Result is cached in `$_CLAUDE_AVAILABLE`.

**Events:**
- `ai.claude.detected` - Emitted with `path=<cli_path>`

**Example:**
```zsh
if ! claude-check-installed; then
    echo "Please install Claude Code CLI" >&2
    echo "Visit: https://claude.com/download" >&2
    exit 1
fi
```

**Notes:**
- Caches result for performance
- Checks `$CLAUDE_CLI_PATH` variable
- Falls back to `claude` in PATH

---

### claude-get-version

Get Claude Code CLI version string.

**Source:** Lines 128-154

**Usage:**
```zsh
version=$(claude-get-version)
```

**Parameters:** None

**Returns:**
- Version string (e.g., "1.2.3")
- Empty string if version can't be determined

**Description:**

Extracts version from `claude --version` output.

**Example:**
```zsh
version=$(claude-get-version)
echo "Claude Code version: $version"

# Version comparison
if [[ "$version" < "1.0.0" ]]; then
    echo "Please upgrade Claude Code" >&2
fi
```

**Notes:**
- Caches version in `$_CLAUDE_VERSION`
- Parses semver format (X.Y.Z)

---

### claude-check-compatibility

Check if installed version meets minimum requirements.

**Source:** Lines 156-185

**Usage:**
```zsh
if claude-check-compatibility; then
    echo "Version is compatible"
fi
```

**Parameters:** None

**Returns:**
- `0` - Compatible
- `1` - Incompatible or can't determine

**Description:**

Checks if installed version >= `$CLAUDE_MIN_VERSION` (default: 1.0.0).

**Example:**
```zsh
if ! claude-check-compatibility; then
    required="$CLAUDE_MIN_VERSION"
    current=$(claude-get-version)
    echo "Claude Code version $required required, found $current" >&2
    exit 1
fi
```

---

### claude-exec

Execute Claude Code CLI command.

**Source:** Lines 187-254

**Usage:**
```zsh
output=$(claude-exec <args...>)
```

**Parameters:**
- `args...` - Command arguments to pass to CLI

**Returns:**
- `0` - Success (output to stdout)
- Non-zero - CLI error code

**Description:**

Executes Claude CLI command with error handling and logging.

**Example:**
```zsh
# Get help
claude-exec --help

# Execute prompt
response=$(claude-exec --prompt "What is the capital of France?" --model sonnet)
echo "$response"

# With timeout
response=$(claude-exec --prompt "Analyze this large file" --timeout 300)
```

**Notes:**
- Logs execution with _claude-log
- Preserves exit code
- Streams output to stdout

---

### claude-exec-json

Execute Claude CLI and parse JSON response.

**Source:** Lines 256-316

**Usage:**
```zsh
json=$(claude-exec-json <args...>)
```

**Parameters:**
- `args...` - Command arguments

**Returns:**
- `0` - Success (JSON to stdout)
- Non-zero - Error

**Description:**

Executes CLI command expecting JSON response, validates and parses.

**Example:**
```zsh
# Get JSON response
json=$(claude-exec-json --prompt "List files" --format json)

# Parse with jq
files=$(echo "$json" | jq -r '.files[]')

# Error handling
if ! json=$(claude-exec-json --prompt "..." 2>&1); then
    echo "JSON parsing failed: $json" >&2
    exit 1
fi
```

**Notes:**
- Validates JSON output
- Returns parsed JSON string
- Better error reporting than raw exec

---

### claude-session-start

Start new Claude conversation session.

**Source:** Lines 318-401

**Usage:**
```zsh
session_id=$(claude-session-start <prompt> [--model <model>])
```

**Parameters:**
- `prompt` - Initial prompt for session
- `--model` - Optional: Model to use (sonnet/opus/haiku)

**Returns:**
- `0` - Success (session ID to stdout)
- `1` - Failed to create session

**Description:**

Creates new conversation session with metadata and history tracking.

**Example:**
```zsh
# Start session
session_id=$(claude-session-start "Help me review this code")
echo "Session: $session_id"

# Start with opus
session_id=$(claude-session-start "Complex analysis task" --model opus)
```

**Session Metadata:**
- Session ID (unique)
- Model used
- Creation timestamp
- Message count

**Storage:**
`$CLAUDE_SESSION_DIR/{session_id}/meta.json`

**Notes:**
- Sessions persist across script runs
- Automatic cleanup after TTL
- History stored as JSON

---

### claude-session-continue

Continue existing session.

**Source:** Lines 403-466

**Usage:**
```zsh
response=$(claude-session-continue <session_id> <message>)
```

**Parameters:**
- `session_id` - Session identifier
- `message` - Message to send

**Returns:**
- `0` - Success (response to stdout)
- `1` - Session not found or error

**Description:**

Continues conversation in existing session.

**Example:**
```zsh
# Multi-turn conversation
session_id=$(claude-session-start "Review this code")

response=$(claude-session-continue "$session_id" "Focus on security")
echo "Claude: $response"

response=$(claude-session-continue "$session_id" "Check authentication")
echo "Claude: $response"
```

**Notes:**
- Maintains conversation context
- Updates message count
- Appends to history

---

### claude-session-end

End Claude session.

**Source:** Lines 468-507

**Usage:**
```zsh
claude-session-end <session_id>
```

**Parameters:**
- `session_id` - Session to end

**Returns:**
- `0` - Success
- `1` - Session not found

**Description:**

Ends session and optionally cleans up metadata.

**Example:**
```zsh
# End session (keep metadata)
claude-session-end "$session_id"

# Session files remain for auditing
ls $CLAUDE_SESSION_DIR/$session_id/
```

**Notes:**
- Marks session as ended
- Metadata preserved
- History kept for auditing

---

### claude-generate-skill

Generate Claude skill artifact.

**Source:** Lines 625-663

**Usage:**
```zsh
artifact=$(claude-generate-skill <name> [--force])
```

**Parameters:**
- `name` - Skill definition name
- `--force` - Optional: Force regeneration

**Returns:**
- `0` - Success (artifact to stdout)
- Non-zero - Generation failed

**Description:**

Generates skill artifact using _ai_core and installs to `~/.claude/skills/`.

**Example:**
```zsh
# Generate skill
claude-generate-skill security-review

# Force regenerate
claude-generate-skill security-review --force

# Capture artifact
artifact=$(claude-generate-skill code-analyzer)
echo "$artifact"
```

**Workflow:**
1. Load definition from `$AI_DEFINITION_DIR/skills/{name}.yml`
2. Render template `$AI_TEMPLATE_DIR/claude/skill.tmpl`
3. Validate generated artifact
4. Install to `~/.claude/skills/{name}.md`
5. Return artifact content

**Notes:**
- Uses _ai_core generation engine
- Honors cache (unless --force)
- Auto-installs if `$CLAUDE_AUTO_INSTALL=true`

---

### claude-generate-command

Generate Claude command artifact.

**Source:** Lines 665-702

**Usage:**
```zsh
artifact=$(claude-generate-command <name> [--force])
```

**Parameters:**
- `name` - Command definition name
- `--force` - Optional: Force regeneration

**Returns:**
- `0` - Success
- Non-zero - Failed

**Description:**

Generates command artifact and installs to `~/.claude/commands/`.

**Example:**
```zsh
# Generate command
claude-generate-command security-scan

# Multiple commands
for cmd in scan audit review; do
    claude-generate-command "security-$cmd"
done
```

**Format:**
Commands include:
- Command name (with `/` prefix)
- Arguments specification
- Usage examples
- Output format

**Notes:**
- Template: `claude/command.tmpl`
- Install path: `~/.claude/commands/{name}.md`

---

### claude-generate-agent

Generate Claude agent artifact.

**Source:** Lines 704-773

**Usage:**
```zsh
artifact=$(claude-generate-agent <name> [--force])
```

**Parameters:**
- `name` - Agent definition name
- `--force` - Optional: Force regeneration

**Returns:**
- `0` - Success
- Non-zero - Failed

**Description:**

Generates agent artifact and installs to `~/.claude/agents/`.

**Example:**
```zsh
# Generate agent
claude-generate-agent security-auditor

# With specific model
# (Set in definition YAML)
claude-generate-agent data-analyst
```

**Agent Structure:**
- Name and description
- Role and persona
- Expertise areas
- Available tools
- Workflow
- Constraints

**Notes:**
- Template: `claude/agent.tmpl`
- Install path: `~/.claude/agents/{name}.md`
- Used via Task tool in Claude Code

---

### claude-ensure-artifact

Smart artifact installation (skip if exists).

**Source:** Lines 819-889

**Usage:**
```zsh
claude-ensure-artifact <type> <name> [--force]
```

**Parameters:**
- `type` - Artifact type (`skill`, `command`, or `agent`)
- `name` - Artifact name
- `--force` - Optional: Force reinstall

**Returns:**
- `0` - Artifact ensured (installed or already exists)
- `1` - Failed

**Description:**

Ensures artifact is installed, skipping if already present (unless --force).

**Example:**
```zsh
# Ensure skill installed
claude-ensure-artifact skill security-review

# Force reinstall
claude-ensure-artifact skill security-review --force

# Ensure command
claude-ensure-artifact command security-scan
```

**Workflow:**
1. Check if artifact exists at install path
2. If exists and not --force: skip
3. If not exists or --force: generate and install
4. Log result

**Notes:**
- Idempotent operation
- Useful for initialization scripts
- Respects existing artifacts

---

### claude-ensure-all

Batch ensure all artifacts of a type.

**Source:** Lines 891-964

**Usage:**
```zsh
claude-ensure-all <type>
```

**Parameters:**
- `type` - Artifact type (`skills`, `commands`, or `agents`)

**Returns:**
- `0` - All ensured successfully
- `1` - Some failed

**Description:**

Ensures all definitions of given type are installed.

**Example:**
```zsh
# Ensure all skills
claude-ensure-all skills

# Ensure all commands
claude-ensure-all commands

# Ensure everything
claude-ensure-all skills
claude-ensure-all commands
claude-ensure-all agents
```

**Output:**
```
Ensuring all skills...
✓ security-review (already installed)
✓ code-analyzer (generated)
✗ broken-skill (validation failed)

Summary: 2 succeeded, 1 failed
```

**Notes:**
- Skips already-installed artifacts
- Reports summary
- Continues on individual failures

---

## Artifact Types Detailed

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Skill Artifacts

**Purpose:** Enhance Claude with specialized capabilities.

**Structure:**
```markdown
---
name: skill-name
description: Brief description
tools: Read,Grep,Bash
model: sonnet
---

# skill-name

Detailed instructions...

## Activation
Keywords: keyword1, keyword2

## Examples

Example usage...

## Limitations

Known limitations...
```

**Activation:**
- Keyword matching (automatic)
- Explicit request by user
- Context-based activation

**Best Practices:**
- Clear, focused instructions
- Specific keywords
- Realistic examples
- Document limitations

---

### Command Artifacts

**Purpose:** Provide slash commands for specific tasks.

**Structure:**
```markdown
---
command: /command-name
description: Brief description
arguments: arg1, arg2
---

# /command-name

Command description and behavior...

## Usage

```
/command-name [args]
```

Usage details...

## Output

Expected output format...
```

**Activation:**
- User types `/command-name`
- Arguments parsed automatically
- Help available via `/help command-name`

**Best Practices:**
- Clear argument specification
- Usage examples
- Expected output format
- Error handling documentation

---

### Agent Artifacts

**Purpose:** Specialized sub-agents via Task tool.

**Structure:**
```markdown
---
name: agent-name
description: Agent role
role: Specific Role
tools: Read,Write,Bash
model: opus
---

# agent-name

Role and capabilities...

## Expertise
- Area 1
- Area 2

## Workflow

Step-by-step process...

## Constraints

Operational constraints...
```

**Activation:**
- Via Task tool: `Use the Task tool with agent-name agent`
- User explicitly requests agent
- Autonomous task delegation

**Best Practices:**
- Specific role definition
- Clear expertise areas
- Documented workflow
- Explicit constraints

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Common Issues

#### 1. "Claude Code CLI not found"

**Problem:** `claude-check-installed` returns false.

**Solution:**

```zsh
# Check PATH
echo "$PATH" | tr ':' '\n' | grep claude

# Install CLI
npm install -g @anthropic/claude-code

# Or set custom path
export CLAUDE_CLI_PATH="/path/to/claude"

# Verify
which claude
claude --version
```

#### 2. Artifacts not appearing in Claude Code

**Problem:** Generated artifacts don't show up.

**Diagnosis:**

```zsh
# Check installation directory
ls -la ~/.claude/skills/

# Verify artifact format
cat ~/.claude/skills/my-skill.md

# Check frontmatter
head -n 10 ~/.claude/skills/my-skill.md
```

**Solution:**

```zsh
# Restart Claude Code CLI
# Artifacts are loaded at startup

# Or manually reload configuration
claude --reload-config
```

#### 3. "Session not found"

**Problem:** Can't continue session.

**Diagnosis:**

```zsh
# Check session directory
ls -la $CLAUDE_SESSION_DIR/

# Check session metadata
cat $CLAUDE_SESSION_DIR/$session_id/meta.json
```

**Solution:**

```zsh
# Session may have expired (check TTL)
echo "$CLAUDE_SESSION_TTL"

# Increase TTL
export CLAUDE_SESSION_TTL=7200  # 2 hours

# Or create new session
session_id=$(claude-session-start "...")
```

#### 4. Version compatibility error

**Problem:** Installed version too old.

**Solution:**

```zsh
# Check required version
echo "$CLAUDE_MIN_VERSION"

# Check installed version
claude-get-version

# Upgrade
npm update -g @anthropic/claude-code

# Verify
claude-check-compatibility
```

#### 5. Template rendering fails

**Problem:** Artifact generation produces errors.

**Diagnosis:**

```zsh
# Test template directly
ai-template-render ~/.local/share/ai/templates/claude/skill.tmpl "$json_data"

# Check template syntax
ai-template-validate ~/.local/share/ai/templates/claude/skill.tmpl
```

**Solution:**

See [_ai_core Troubleshooting](./_ ai_core.md#troubleshooting) for template issues.

---

## See Also

- `_ai_core` - Core artifact generation engine
- [Definition Authoring Guide](../AUTHORING-DEFINITIONS.md)
- [Template Authoring Guide](../AUTHORING-TEMPLATES.md)
- [Integration Examples](../INTEGRATION-EXAMPLES.md)

**Claude Code Documentation:**
- [Claude Code CLI](https://docs.claude.com/claude-code)
- [Skills Guide](https://docs.claude.com/claude-code/skills)
- [Commands Reference](https://docs.claude.com/claude-code/commands)

---

**Version:** 1.0.0
**Last Updated:** 2025-11-08
**Maintainer:** andronics
**License:** MIT
