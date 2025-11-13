# _ui - User Interface and Formatting Utilities Extension

**Version:** 1.0.0
**Layer:** Core Utilities (Layer 1)
**Dependencies:** None (standalone, optional _common v2.0 for colors)
**Source:** `~/.local/bin/lib/_ui`

---

## Table of Contents

1. [Overview](#overview)
2. [Use Cases](#use-cases)
3. [Quick Start](#quick-start)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [API Reference](#api-reference)
   - [Table Formatting](#table-formatting)
   - [Progress Indicators](#progress-indicators)
   - [Colored Output](#colored-output)
   - [User Interaction](#user-interaction)
   - [Boxes and Borders](#boxes-and-borders)
   - [List Formatting](#list-formatting)
   - [Status Indicators](#status-indicators)
   - [Alignment](#alignment)
7. [Events](#events)
8. [Examples](#examples)
9. [Troubleshooting](#troubleshooting)
10. [Architecture](#architecture)
11. [Performance](#performance)
12. [Changelog](#changelog)

---

## Overview

The `_ui` extension provides comprehensive user interface and formatting utilities for ZSH scripts, enabling creation of professional, visually appealing command-line interfaces with tables, progress bars, colored output, interactive prompts, boxes, and status indicators.

**Key Features:**

- Table formatting (fixed, custom, auto, dynamic widths)
- Progress bars and spinners
- Colored output with status messages
- Interactive prompts and confirmations
- Selection menus
- Box drawing with Unicode borders
- Headers and banners
- Bulleted and numbered lists
- Key-value pair formatting
- Status indicators with icons
- Text alignment (left, right, center)
- No external dependencies
- Pure ZSH implementation
- Terminal capability detection

---

## Use Cases

### Status Tables

Display structured system information.

```zsh
source ~/.local/bin/lib/_ui

ui-table-header "SERVICE" "STATUS" "CPU" "MEMORY"
ui-table-separator
ui-table-row "nginx" "running" "2.5%" "128M"
ui-table-row "postgres" "running" "8.2%" "512M"
ui-table-row "redis" "stopped" "0%" "0M"
```

### Progress Indicators

Show progress for long operations.

```zsh
source ~/.local/bin/lib/_ui

for i in {1..100}; do
    ui-progress $i 100 50
    sleep 0.05
done
ui-progress-complete
```

### User Menus

Create interactive selection interfaces.

```zsh
source ~/.local/bin/lib/_ui

choice=$(ui-select "Choose environment:" \
    "Development" \
    "Staging" \
    "Production")

echo "Selected: $choice"
```

### Status Messages

Display colored status output.

```zsh
source ~/.local/bin/lib/_ui

ui-success "Build completed successfully"
ui-warning "Disk usage above 80%"
ui-error "Connection to database failed"
ui-info "Starting backup process"
```

### Visual Boxes

Create boxed content for emphasis.

```zsh
source ~/.local/bin/lib/_ui

ui-box "System Status" \
    "CPU Usage: 45%" \
    "Memory: 8.2 GB / 16 GB" \
    "Disk: 234 GB / 512 GB" \
    "Uptime: 15 days"
```

### Report Generation

Generate formatted reports.

```zsh
source ~/.local/bin/lib/_ui

ui-header "Monthly Report"

ui-subheader "Summary"
ui-list "Revenue: +15%" "Costs: -8%" "Profit: +23%"

ui-subheader "Details"
ui-numbered-list \
    "Q1 results published" \
    "New product launched" \
    "Team expanded by 5"
```

---

## Quick Start

### Basic Output

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

# Colored messages
ui-success "Operation successful"
ui-error "Something went wrong"
ui-warning "This is a warning"
ui-info "Informational message"

# Simple table
ui-table-header "NAME" "VALUE" "STATUS"
ui-table-separator
ui-table-row "item1" "123" "active"
ui-table-row "item2" "456" "inactive"
```

### Progress Bar

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

# Show progress
for i in {1..50}; do
    ui-progress $i 50 30
    sleep 0.1
done
ui-progress-complete

echo "Processing complete!"
```

### User Prompts

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

# Get input
name=$(ui-prompt "Enter your name" "John Doe")
echo "Hello, $name!"

# Confirm action
if ui-confirm "Delete file?"; then
    rm file.txt
    ui-success "File deleted"
else
    ui-info "Cancelled"
fi
```

### Visual Elements

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

# Banner
ui-banner "IMPORTANT MESSAGE"

# Box
ui-box "Configuration" \
    "Host: localhost" \
    "Port: 8080" \
    "Debug: false"

# Lists
echo "Features:"
ui-list "Fast" "Reliable" "Secure"
```

---

## Installation

Load the extension in your script:

```zsh
# Basic loading
source "$(which _ui)"

# With error handling
if ! source "$(which _ui)" 2>/dev/null; then
    echo "Error: _ui extension not found" >&2
    exit 1
fi

# From fixed path
source ~/.local/bin/lib/_ui
```

**Dependencies:**
- None (standalone)

**Optional Dependencies:**
- **_common v2.0** - Enhanced color definitions (fallback to built-in)

All dependencies are optional and gracefully degrade if unavailable.

---

## Configuration

### Color Variables

If `_common` is loaded, colors are inherited. Otherwise, built-in colors are used:

| Variable | Value | Usage |
|----------|-------|-------|
| **COLOR_GREEN** | `\033[0;32m` | Success messages |
| **COLOR_BLUE** | `\033[0;34m` | Info messages |
| **COLOR_YELLOW** | `\033[1;33m` | Warning messages |
| **COLOR_RED** | `\033[0;31m` | Error messages |
| **COLOR_CYAN** | `\033[0;36m` | Debug messages |
| **COLOR_MAGENTA** | `\033[0;35m` | Accent |
| **COLOR_BOLD** | `\033[1m` | Bold text |
| **COLOR_NC** | `\033[0m` | Reset/no color |

### Custom Colors

```zsh
# Load UI extension
source ~/.local/bin/lib/_ui

# Override colors
COLOR_GREEN='\033[1;32m'  # Bright green
COLOR_RED='\033[1;31m'    # Bright red

# Use custom colors
ui-success "Now using bright green"
ui-error "Now using bright red"
```

### Terminal Detection

The extension automatically detects terminal capabilities:

- ANSI color support
- Unicode character support
- Terminal width

```zsh
# Check terminal width (impacts formatting)
echo $COLUMNS

# Fallback to 80 if not detected
```

---

## API Reference

### Table Formatting

#### `ui-table-header`

Print table header row.

**Syntax:**
```zsh
ui-table-header <col1> <col2> <col3> [col4]
```

**Parameters:**
- Up to 4 column headers

**Returns:**
- Always returns 0

**Example:**
```zsh
ui-table-header "NAME" "STATUS" "SIZE" "MODIFIED"
ui-table-separator
ui-table-row "file1.txt" "active" "1.5M" "2025-01-01"
ui-table-row "file2.txt" "inactive" "2.3M" "2025-01-02"
```

**Notes:**
- Fixed widths: 25, 20, 15, 20 characters
- For custom widths, use `ui-table-custom-header`

---

#### `ui-table-row`

Print table data row.

**Syntax:**
```zsh
ui-table-row <col1> <col2> <col3> [col4]
```

**Parameters:**
- Up to 4 column values

**Example:**
```zsh
ui-table-row "nginx" "running" "80" "TCP"
```

---

#### `ui-table-separator`

Print table separator line.

**Syntax:**
```zsh
ui-table-separator [width]
```

**Parameters:**
- `width` - Line width in characters (default: 80)

**Example:**
```zsh
ui-table-header "COL1" "COL2"
ui-table-separator 50
ui-table-row "value1" "value2"
```

---

#### `ui-table-custom-header`

Print table header with custom column widths.

**Syntax:**
```zsh
ui-table-custom-header <width1> <width2> ... -- <col1> <col2> ...
```

**Parameters:**
- Widths before `--`
- Column headers after `--`

**Example:**
```zsh
ui-table-custom-header 30 15 20 -- "SERVICE NAME" "CPU" "MEMORY"
ui-table-custom-row 30 15 20 -- "nginx-server" "2.5%" "128M"
```

---

#### `ui-table-custom-row`

Print table row with custom column widths.

**Syntax:**
```zsh
ui-table-custom-row <width1> <width2> ... -- <val1> <val2> ...
```

**Example:**
```zsh
ui-table-custom-row 30 15 20 -- "postgresql-db" "8.2%" "512M"
```

---

#### `ui-table-auto-header`

Print table header with automatically calculated widths.

**Syntax:**
```zsh
ui-table-auto-header <col1> <col2> <col3> ...
```

**Parameters:**
- Column headers (any number)

**Returns:**
- Always returns 0

**Side Effects:**
- Stores widths in `_UI_TABLE_AUTO_WIDTHS` global array

**Example:**
```zsh
ui-table-auto-header "NAME" "DESCRIPTION" "STATUS"
ui-table-auto-row "Item 1" "Short description" "Active"
ui-table-auto-row "Item 2 with long name" "Another description" "Inactive"
```

**Notes:**
- Width = header length + 2 (padding)
- Minimum width = 10 characters
- Use `ui-table-auto-row` for data rows

---

#### `ui-table-auto-row`

Print table row using auto-calculated widths.

**Syntax:**
```zsh
ui-table-auto-row <val1> <val2> <val3> ...
```

**Example:**
```zsh
ui-table-auto-header "NAME" "SIZE" "DATE"
ui-table-auto-row "file1.txt" "1.5M" "2025-01-01"
ui-table-auto-row "file2.txt" "2.3M" "2025-01-02"
```

---

#### `ui-table-dynamic-set`

Set min:max width constraints for dynamic table.

**Syntax:**
```zsh
ui-table-dynamic-set <min1:max1> <min2:max2> ...
```

**Parameters:**
- Width constraints in format `min:max`

**Example:**
```zsh
# Column 1: 12-40 chars, Column 2: 10-30 chars
ui-table-dynamic-set "12:40" "10:30" "8:20"
ui-table-dynamic-header "NAME" "DESCRIPTION" "STATUS"
```

---

#### `ui-table-dynamic-header`

Print dynamic table header (respects constraints).

**Syntax:**
```zsh
ui-table-dynamic-header <col1> <col2> ...
```

**Example:**
```zsh
ui-table-dynamic-set "15:50" "10:30"
ui-table-dynamic-header "SERVICE NAME" "DESCRIPTION"
ui-table-dynamic-row "nginx" "Web server"
ui-table-dynamic-row "postgres" "Database server"
```

---

#### `ui-table-dynamic-row`

Print dynamic table row.

**Syntax:**
```zsh
ui-table-dynamic-row <val1> <val2> ...
```

---

### Progress Indicators

#### `ui-progress`

Show progress bar.

**Syntax:**
```zsh
ui-progress <current> <total> [width]
```

**Parameters:**
- `current` - Current progress value
- `total` - Total value (100%)
- `width` - Progress bar width in characters (default: 50)

**Returns:**
- Always returns 0

**Example:**
```zsh
for i in {1..100}; do
    ui-progress $i 100 30
    sleep 0.05
done
ui-progress-complete
```

**Output:**
```
[=========>            ] 45%
```

**Notes:**
- Updates in place (uses `\r`)
- Call `ui-progress-complete` when done
- No newline until complete

---

#### `ui-progress-complete`

Complete progress bar (add newline).

**Syntax:**
```zsh
ui-progress-complete
```

**Example:**
```zsh
ui-progress 100 100
ui-progress-complete
echo "Done!"
```

---

#### `ui-progress-message`

Show progress with message.

**Syntax:**
```zsh
ui-progress-message <current> <total> <message>
```

**Parameters:**
- `current` - Current progress
- `total` - Total items
- `message` - Progress message

**Example:**
```zsh
for i in {1..50}; do
    ui-progress-message $i 50 "Processing files"
    process_file "$i"
done
echo ""  # Newline after complete
```

**Output:**
```
[15/50] Processing files...
```

---

#### `ui-spinner`

Show spinner for background process.

**Syntax:**
```zsh
ui-spinner <pid> [message]
```

**Parameters:**
- `pid` - Process ID to monitor
- `message` - Status message (default: "Working")

**Example:**
```zsh
# Start background process
long_task &
pid=$!

# Show spinner
ui-spinner $pid "Processing data"
# Output: Processing data ✓
```

**Notes:**
- Blocks until process completes
- Shows rotating spinner (-, \, |, /)
- Displays checkmark when complete

---

### Colored Output

#### `ui-success`

Print success message (green checkmark).

**Syntax:**
```zsh
ui-success <message> [args...]
```

**Example:**
```zsh
ui-success "Build completed successfully"
# Output: ✓ Build completed successfully
```

---

#### `ui-error`

Print error message (red X).

**Syntax:**
```zsh
ui-error <message> [args...]
```

**Example:**
```zsh
ui-error "Connection failed"
# Output: ✗ Connection failed
```

**Notes:**
- Outputs to stderr
- Returns 0 (doesn't exit)

---

#### `ui-warning`

Print warning message (yellow warning symbol).

**Syntax:**
```zsh
ui-warning <message> [args...]
```

**Example:**
```zsh
ui-warning "Disk usage above 80%"
# Output: ⚠ Disk usage above 80%
```

---

#### `ui-info`

Print info message (blue info symbol).

**Syntax:**
```zsh
ui-info <message> [args...]
```

**Example:**
```zsh
ui-info "Starting backup process"
# Output: ℹ Starting backup process
```

---

#### `ui-debug`

Print debug message (cyan).

**Syntax:**
```zsh
ui-debug <message> [args...]
```

**Example:**
```zsh
ui-debug "Variable value: $foo"
# Output: [DEBUG] Variable value: bar
```

---

#### `ui-color`

Print colored text.

**Syntax:**
```zsh
ui-color <color> <message> [args...]
```

**Parameters:**
- `color` - Color name (red, green, blue, yellow, cyan, magenta, bold)
- `message` - Text to color

**Example:**
```zsh
ui-color "red" "This is red text"
ui-color "green" "This is green text"
ui-color "bold" "This is bold text"
```

---

### User Interaction

#### `ui-prompt`

Prompt user for input.

**Syntax:**
```zsh
result=$(ui-prompt <question> [default])
```

**Parameters:**
- `question` - Question to ask
- `default` - Default value (optional)

**Returns:**
- User input (or default if empty)

**Example:**
```zsh
name=$(ui-prompt "Enter your name" "John Doe")
echo "Hello, $name"

port=$(ui-prompt "Enter port number")
echo "Using port: $port"
```

---

#### `ui-confirm`

Ask for yes/no confirmation.

**Syntax:**
```zsh
ui-confirm <question> [default]
```

**Parameters:**
- `question` - Confirmation question
- `default` - Default answer: y or n (default: n)

**Returns:**
- `0` if yes
- `1` if no

**Example:**
```zsh
if ui-confirm "Delete all files?"; then
    rm -rf *
    ui-success "Files deleted"
else
    ui-info "Cancelled"
fi

# With default yes
if ui-confirm "Continue?" "y"; then
    echo "Continuing..."
fi
```

---

#### `ui-select`

Display selection menu.

**Syntax:**
```zsh
choice=$(ui-select <prompt> <option1> <option2> ...)
```

**Parameters:**
- `prompt` - Menu prompt
- Options - List of choices

**Returns:**
- Selected option text
- Exit status 0 on valid selection, 1 on invalid

**Example:**
```zsh
env=$(ui-select "Choose environment:" \
    "Development" \
    "Staging" \
    "Production")

if [[ $? -eq 0 ]]; then
    echo "Selected: $env"
else
    echo "Invalid selection"
    exit 1
fi
```

**Output:**
```
Choose environment:
  1) Development
  2) Staging
  3) Production
Enter number: 2
```

---

### Boxes and Borders

#### `ui-box`

Print box around text.

**Syntax:**
```zsh
ui-box <title> <line1> <line2> ...
```

**Parameters:**
- `title` - Box title
- Lines - Content lines

**Example:**
```zsh
ui-box "System Information" \
    "Hostname: server01" \
    "OS: Linux 5.10" \
    "Memory: 16 GB" \
    "CPU: 8 cores"
```

**Output:**
```
┌────────────────────────────┐
│ System Information         │
├────────────────────────────┤
│ Hostname: server01         │
│ OS: Linux 5.10             │
│ Memory: 16 GB              │
│ CPU: 8 cores               │
└────────────────────────────┘
```

---

#### `ui-header`

Print section header with separator.

**Syntax:**
```zsh
ui-header <title> [width]
```

**Parameters:**
- `title` - Header text
- `width` - Line width (default: 80)

**Example:**
```zsh
ui-header "Configuration Settings"
echo "Debug: false"
echo "Port: 8080"
```

**Output:**
```

Configuration Settings
════════════════════════════════════════════════════════════════════════════════
```

---

#### `ui-subheader`

Print subsection header.

**Syntax:**
```zsh
ui-subheader <title> [width]
```

**Example:**
```zsh
ui-header "Report"
ui-subheader "Summary"
echo "Total: 42"
ui-subheader "Details"
echo "Item 1: 10"
```

---

#### `ui-banner`

Print banner (boxed message).

**Syntax:**
```zsh
ui-banner <message>
```

**Example:**
```zsh
ui-banner "PRODUCTION DEPLOYMENT"
```

**Output:**
```

╔══════════════════════════╗
║ PRODUCTION DEPLOYMENT   ║
╚══════════════════════════╝

```

---

### List Formatting

#### `ui-list`

Print bulleted list.

**Syntax:**
```zsh
ui-list <item1> <item2> ...
```

**Example:**
```zsh
echo "Features:"
ui-list "Fast performance" "Easy to use" "Well documented"
```

**Output:**
```
Features:
  • Fast performance
  • Easy to use
  • Well documented
```

---

#### `ui-numbered-list`

Print numbered list.

**Syntax:**
```zsh
ui-numbered-list <item1> <item2> ...
```

**Example:**
```zsh
echo "Steps:"
ui-numbered-list \
    "Install dependencies" \
    "Configure settings" \
    "Run application"
```

**Output:**
```
Steps:
  1. Install dependencies
  2. Configure settings
  3. Run application
```

---

#### `ui-key-value`

Print key-value pairs.

**Syntax:**
```zsh
ui-key-value <key1> <val1> <key2> <val2> ...
```

**Parameters:**
- Alternating keys and values

**Example:**
```zsh
ui-key-value \
    "Name" "John Doe" \
    "Age" "30" \
    "City" "New York" \
    "Email" "john@example.com"
```

**Output:**
```
  Name                 : John Doe
  Age                  : 30
  City                 : New York
  Email                : john@example.com
```

---

### Status Indicators

#### `ui-status`

Print status with icon.

**Syntax:**
```zsh
ui-status <type> <message> [args...]
```

**Parameters:**
- `type` - Status type (success/ok/pass, error/fail, warning/warn, info, skip)
- `message` - Status message

**Example:**
```zsh
ui-status "success" "Test passed"
ui-status "error" "Test failed"
ui-status "warning" "Test skipped"
ui-status "info" "Test running"
ui-status "skip" "Test not applicable"
```

**Output:**
```
[  OK  ] Test passed
[ FAIL ] Test failed
[ WARN ] Test skipped
[ INFO ] Test running
[ SKIP ] Test not applicable
```

---

### Alignment

#### `ui-center`

Center text.

**Syntax:**
```zsh
ui-center <text> [width]
```

**Parameters:**
- `text` - Text to center
- `width` - Total width (default: 80)

**Example:**
```zsh
ui-center "TITLE" 80
ui-center "Subtitle" 80
```

---

#### `ui-right`

Right-align text.

**Syntax:**
```zsh
ui-right <text> [width]
```

**Example:**
```zsh
ui-right "Page 1 of 10" 80
```

---

#### `ui-version-info`

Display extension version.

**Syntax:**
```zsh
ui-version-info
```

**Example:**
```zsh
ui-version-info
# Output: extensions/_ui version 1.0.0
```

---

## Events

The `_ui` extension does not emit events in v2.0. Event support may be added in future versions for user interactions.

**Potential Future Events:**
- `ui.prompt` - User prompt displayed
- `ui.confirm` - Confirmation requested
- `ui.select` - Menu selection made

---

## Examples

### Example 1: System Status Dashboard

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

# Header
ui-banner "SYSTEM STATUS DASHBOARD"

# System info
ui-header "System Information"
ui-key-value \
    "Hostname" "$(hostname)" \
    "OS" "$(uname -s)" \
    "Kernel" "$(uname -r)" \
    "Uptime" "$(uptime -p)"

# Services status
echo ""
ui-header "Services"
ui-table-header "SERVICE" "STATUS" "CPU" "MEMORY"
ui-table-separator
ui-table-row "nginx" "running" "2.5%" "128M"
ui-table-row "postgres" "running" "8.2%" "512M"
ui-table-row "redis" "running" "1.1%" "64M"
ui-table-row "docker" "stopped" "0%" "0M"

# Disk usage
echo ""
ui-header "Disk Usage"
while read line; do
    read -r dev size used avail pct mount <<< "$line"
    if [[ "$mount" == "/" || "$mount" == "/home" ]]; then
        ui-status "info" "$mount: $used / $size ($pct used)"
    fi
done < <(df -h | tail -n +2)

# Summary
echo ""
ui-box "Summary" \
    "✓ 3 services running" \
    "✗ 1 service stopped" \
    "⚠ Disk usage OK"
```

---

### Example 2: Interactive Deployment Script

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

ui-banner "DEPLOYMENT SCRIPT"

# Select environment
env=$(ui-select "Choose deployment environment:" \
    "Development" \
    "Staging" \
    "Production")

[[ $? -ne 0 ]] && exit 1

ui-info "Selected environment: $env"
echo ""

# Confirm
if ! ui-confirm "Deploy to $env?"; then
    ui-warning "Deployment cancelled"
    exit 0
fi

# Deploy
ui-header "Deployment Progress"

steps=("Build" "Test" "Package" "Upload" "Restart")
total=${#steps[@]}

for i in "${!steps[@]}"; do
    step="${steps[$i]}"
    percent=$(( (i + 1) * 100 / total ))

    ui-progress-message $((i + 1)) $total "$step"

    # Simulate work
    case "$step" in
        Build)
            sleep 2
            ui-success "Build completed"
            ;;
        Test)
            sleep 1
            ui-success "Tests passed"
            ;;
        Package)
            sleep 1
            ui-success "Package created"
            ;;
        Upload)
            sleep 2
            ui-success "Uploaded to $env"
            ;;
        Restart)
            sleep 1
            ui-success "Service restarted"
            ;;
    esac
done

echo ""
ui-box "Deployment Complete" \
    "Environment: $env" \
    "Time: $(date)" \
    "Status: Success"
```

---

### Example 3: File Processing Report

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

files=($(find /data -name "*.txt"))
total=${#files[@]}

ui-header "FILE PROCESSING REPORT"
echo "Total files: $total"
echo ""

# Process files
processed=0
errors=0
skipped=0

for file in "${files[@]}"; do
    ((processed++))
    percent=$((processed * 100 / total))

    ui-progress $processed $total 50

    # Process (simulate)
    if [[ $(( RANDOM % 10 )) -eq 0 ]]; then
        ((errors++))
    elif [[ $(( RANDOM % 20 )) -eq 0 ]]; then
        ((skipped++))
    fi
done
ui-progress-complete

echo ""
ui-subheader "Results"

ui-table-header "METRIC" "COUNT" "PERCENTAGE"
ui-table-separator
ui-table-row "Processed" "$processed" "100%"
ui-table-row "Success" "$((processed - errors - skipped))" "$((100 * (processed - errors - skipped) / total))%"
ui-table-row "Errors" "$errors" "$((100 * errors / total))%"
ui-table-row "Skipped" "$skipped" "$((100 * skipped / total))%"

echo ""
if [[ $errors -eq 0 ]]; then
    ui-success "Processing completed without errors"
else
    ui-warning "Processing completed with $errors errors"
fi
```

---

### Example 4: Configuration Wizard

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

ui-banner "CONFIGURATION WIZARD"

# Collect settings
echo ""
ui-header "Application Settings"

app_name=$(ui-prompt "Application name" "MyApp")
port=$(ui-prompt "Port number" "8080")
debug=$(ui-confirm "Enable debug mode?" "n" && echo "true" || echo "false")

echo ""
ui-header "Database Settings"

db_type=$(ui-select "Database type:" "PostgreSQL" "MySQL" "SQLite")
db_host=$(ui-prompt "Database host" "localhost")
db_name=$(ui-prompt "Database name" "$app_name")

echo ""
ui-header "Confirmation"

ui-box "Review Configuration" \
    "App Name: $app_name" \
    "Port: $port" \
    "Debug: $debug" \
    "Database: $db_type" \
    "DB Host: $db_host" \
    "DB Name: $db_name"

echo ""
if ui-confirm "Save configuration?"; then
    # Save config
    config_file="config.json"
    cat > "$config_file" << EOF
{
  "app_name": "$app_name",
  "port": $port,
  "debug": $debug,
  "database": {
    "type": "$db_type",
    "host": "$db_host",
    "name": "$db_name"
  }
}
EOF

    ui-success "Configuration saved to $config_file"
else
    ui-warning "Configuration not saved"
fi
```

---

### Example 5: Test Runner with Results

```zsh
#!/usr/bin/env zsh
source ~/.local/bin/lib/_ui

tests=(
    "test_authentication"
    "test_database_connection"
    "test_api_endpoints"
    "test_file_upload"
    "test_user_permissions"
)

ui-banner "TEST SUITE"

ui-header "Running Tests"

passed=0
failed=0
skipped=0

for test in "${tests[@]}"; do
    echo ""
    ui-info "Running: $test"

    # Simulate test
    result=$((RANDOM % 10))

    if [[ $result -lt 7 ]]; then
        ui-status "success" "$test passed"
        ((passed++))
    elif [[ $result -lt 9 ]]; then
        ui-status "error" "$test failed"
        ((failed++))
    else
        ui-status "skip" "$test skipped"
        ((skipped++))
    fi
done

# Summary
echo ""
ui-header "Test Results"

total=${#tests[@]}

ui-table-header "STATUS" "COUNT" "PERCENTAGE"
ui-table-separator
ui-table-row "Passed" "$passed" "$((100 * passed / total))%"
ui-table-row "Failed" "$failed" "$((100 * failed / total))%"
ui-table-row "Skipped" "$skipped" "$((100 * skipped / total))%"
ui-table-row "Total" "$total" "100%"

echo ""
if [[ $failed -eq 0 ]]; then
    ui-success "All tests passed!"
else
    ui-error "$failed test(s) failed"
    exit 1
fi
```

---

## Troubleshooting

### Issue: Colors not displaying

**Problem:** Output shows escape codes instead of colors.

**Cause:** Terminal doesn't support ANSI colors or `TERM` not set.

**Solution:**
```zsh
# Check terminal type
echo $TERM

# Set if missing
export TERM=xterm-256color

# Test colors
ui-success "Test"
ui-error "Test"
```

---

### Issue: Unicode characters not rendering

**Problem:** Box borders show as question marks or broken characters.

**Cause:** Terminal doesn't support UTF-8 or locale not set.

**Solution:**
```zsh
# Check locale
locale

# Set UTF-8 locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Test
ui-box "Test" "Line 1" "Line 2"
```

---

### Issue: Progress bar not updating

**Problem:** Multiple progress lines instead of updating in place.

**Cause:** Output redirected or terminal doesn't support `\r`.

**Solution:**
```zsh
# Don't redirect progress output
ui-progress $i $total

# If logging, skip progress
if [[ -t 1 ]]; then
    # Interactive terminal
    ui-progress $i $total
else
    # Redirected/piped
    echo "Progress: $i/$total"
fi
```

---

### Issue: Table columns misaligned

**Problem:** Table columns don't line up.

**Cause:** Data wider than column width or tabs in data.

**Solution:**
```zsh
# Use custom widths
ui-table-custom-header 40 20 15 -- "NAME" "VALUE" "STATUS"
ui-table-custom-row 40 20 15 -- "$long_name" "$value" "$status"

# Or use dynamic widths
ui-table-dynamic-set "20:50" "10:30"
ui-table-dynamic-header "NAME" "VALUE"
```

---

### Issue: Prompt not waiting for input

**Problem:** `ui-prompt` returns immediately without user input.

**Cause:** stdin not available or redirected.

**Solution:**
```zsh
# Check if interactive
if [[ ! -t 0 ]]; then
    echo "Error: Not running in interactive mode"
    exit 1
fi

# Use prompt
name=$(ui-prompt "Enter name")
```

---

## Architecture

### Design Principles

1. **No Dependencies:** Pure ZSH, works standalone
2. **Terminal Agnostic:** Detects capabilities, degrades gracefully
3. **Composable:** Functions work together naturally
4. **Efficient:** Minimal overhead, optimized for common cases
5. **User-Friendly:** Intuitive APIs, sensible defaults

### Function Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| **Tables** | Structured data display | `ui-table-header`, `ui-table-row` |
| **Progress** | Operation feedback | `ui-progress`, `ui-spinner` |
| **Messages** | Status output | `ui-success`, `ui-error` |
| **Input** | User interaction | `ui-prompt`, `ui-confirm`, `ui-select` |
| **Visual** | Decorative elements | `ui-box`, `ui-banner`, `ui-header` |
| **Lists** | Item enumeration | `ui-list`, `ui-numbered-list` |
| **Formatting** | Text manipulation | `ui-center`, `ui-right` |

### Color System

```
┌─────────────┐
│ Load _common│
└──────┬──────┘
       │
    ┌──┴───┐
    │      │
    ▼      ▼
┌────────┐ ┌────────┐
│ Found  │ │ Missing│
└───┬────┘ └───┬────┘
    │          │
    ▼          ▼
Use _common  Define own
colors       colors
```

---

## Performance

### Benchmarks

| Operation | Time | Notes |
|-----------|------|-------|
| `ui-success` | 0.2ms | Simple echo |
| `ui-table-row` | 0.3ms | Printf formatting |
| `ui-progress` | 0.5ms | Updates in place |
| `ui-box` | 2ms | Multi-line output |
| `ui-prompt` | Variable | Waits for user |
| `ui-select` | Variable | Waits for user |

### Performance Tips

1. **Batch Table Operations:**
```zsh
# Efficient
{
    ui-table-header "A" "B" "C"
    ui-table-separator
    for item in "${items[@]}"; do
        ui-table-row "$item" "val" "status"
    done
} | less
```

2. **Throttle Progress Updates:**
```zsh
# Update every 100 items, not every item
if (( i % 100 == 0 )); then
    ui-progress $i $total
fi
```

3. **Use Appropriate Table Type:**
```zsh
# Fixed widths - fastest
ui-table-header "A" "B"
ui-table-row "val1" "val2"

# Auto widths - moderate
ui-table-auto-header "A" "B"
ui-table-auto-row "val1" "val2"

# Dynamic widths - slowest (calculation overhead)
ui-table-dynamic-set "10:50" "10:30"
ui-table-dynamic-header "A" "B"
```

### Memory Usage

- No persistent state (except table width arrays)
- `_UI_TABLE_AUTO_WIDTHS`: ~50 bytes per column
- `_UI_TABLE_DYNAMIC_WIDTHS`: ~50 bytes per column
- All other functions: stack-only

---

## Changelog

### v1.0.0 (2025-01-04)

**Added:**
- Complete rewrite for lib infrastructure
- Dynamic table widths
- Auto-width tables
- Custom-width tables
- Progress with message
- Spinner function
- Debug message function
- Key-value formatting
- Status indicators
- Text alignment functions
- Enhanced box drawing
- Comprehensive documentation

**Changed:**
- Improved table formatting
- Better color handling
- Enhanced terminal detection
- Optimized performance
- Consistent function naming

**Fixed:**
- Unicode rendering issues
- Progress bar flickering
- Table alignment edge cases

### v1.0.0 (2024-11-01)

**Initial Release:**
- Basic table functions
- Progress bars
- Colored output
- User prompts
- Box drawing
- Lists

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-01-04
**Maintainer:** andronics
