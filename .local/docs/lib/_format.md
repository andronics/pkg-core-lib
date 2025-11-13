# _format - Text Formatting and Styling Utilities

**Lines:** 2,892 | **Functions:** 17 | **Examples:** 42 | **Source Lines:** 319
**Version:** 1.0.0 | **Layer:** Core Foundation (Layer 1) | **Source:** `~/.local/bin/lib/_format`

---

## Quick Access Index

### Compact References (Lines 10-350)
- [Function Reference](#function-quick-reference) - 17 functions mapped
- [Format Types](#format-types-quick-reference) - 8 format categories
- [Environment Variables](#environment-variables-quick-reference) - 5 configuration variables
- [Return Codes](#return-codes-quick-reference) - Standard codes

### Main Sections
- [Overview](#overview) (Lines 350-500, ~150 lines) 🔥 HIGH PRIORITY
- [Installation](#installation) (Lines 500-650, ~150 lines) 🔥 HIGH PRIORITY
- [Quick Start](#quick-start) (Lines 650-1000, ~350 lines) 🔥 HIGH PRIORITY
- [API Reference](#api-reference) (Lines 1000-2200, ~1200 lines) ⚡ LARGE SECTION
- [Best Practices](#best-practices) (Lines 2200-2450, ~250 lines) 💡 ADVANCED
- [Troubleshooting](#troubleshooting) (Lines 2450-2650, ~200 lines) 🔧 REFERENCE
- [Performance & Architecture](#performance) (Lines 2650-2892, ~242 lines) 📊 REFERENCE

---

## Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->
<!-- CONTEXT_GROUP: Text Alignment -->

**Text Alignment Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-align-left` | Align text left with padding | 43-54 | O(n) | [→](#format-align-left) |
| `format-align-right` | Align text right with padding | 57-68 | O(n) | [→](#format-align-right) |
| `format-align-center` | Center text with padding | 71-87 | O(n) | [→](#format-align-center) |
| `format-pad` | Pad text with alignment (wrapper) | 115-126 | O(n) | [→](#format-pad) |

<!-- CONTEXT_GROUP: Text Manipulation -->

**Text Manipulation Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-wrap` | Wrap text to width (word-aware) | 90-95 | O(n) | [→](#format-wrap) |
| `format-truncate` | Truncate text with ellipsis | 98-112 | O(1) | [→](#format-truncate) |
| `format-indent` | Indent single line | 200-211 | O(n) | [→](#format-indent) |
| `format-indent-lines` | Indent multi-line (stdin) | 214-226 | O(n·m) | [→](#format-indent-lines) |

<!-- CONTEXT_GROUP: List Formatting -->

**List Formatting Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-list-bullet` | Format bulleted list | 129-136 | O(n) | [→](#format-list-bullet) |
| `format-list-number` | Format numbered list | 139-147 | O(n) | [→](#format-list-number) |

<!-- CONTEXT_GROUP: Number Formatting -->

**Number Formatting Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-number` | Format with thousands separator | 150-162 | O(n) | [→](#format-number) |
| `format-decimal` | Format to decimal places | 165-170 | O(1) | [→](#format-decimal) |

<!-- CONTEXT_GROUP: Case Conversion -->

**Case Conversion Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-uppercase` | Convert to uppercase | 173-176 | O(n) | [→](#format-uppercase) |
| `format-lowercase` | Convert to lowercase | 179-182 | O(n) | [→](#format-lowercase) |
| `format-titlecase` | Convert to title case | 185-197 | O(n·w) | [→](#format-titlecase) |

<!-- CONTEXT_GROUP: Visual Formatting -->

**Visual Formatting Functions:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-box` | Draw box around text | 229-282 | O(n·m) | [→](#format-box) |

<!-- CONTEXT_GROUP: Testing -->

**Testing & Verification:**

| Function | Description | Source Lines | Complexity | Link |
|----------|-------------|--------------|------------|------|
| `format-self-test` | Run self-tests (10 tests) | 285-318 | N/A | [→](#format-self-test) |

---

## Format Types Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

**Available Format Types:**

| Format Type | Functions | Use Case | Performance |
|-------------|-----------|----------|-------------|
| **Alignment** | `align-left`, `align-right`, `align-center` | Columns, tables | Fast (O(n)) |
| **Text Flow** | `wrap`, `truncate` | Long text handling | Fast-Medium |
| **Indentation** | `indent`, `indent-lines` | Hierarchical output | Fast (O(n)) |
| **Lists** | `list-bullet`, `list-number` | Item enumeration | Fast (O(n)) |
| **Numbers** | `number`, `decimal` | Numeric formatting | Medium (sed) |
| **Case** | `uppercase`, `lowercase`, `titlecase` | Text normalization | Fast (native) |
| **Visual** | `box` | UI elements | Medium (O(n·m)) |
| **Padding** | `pad` | Generic padding | Fast (O(n)) |

---

## Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

**Configuration Variables:**

| Variable | Default | Purpose | Source Line |
|----------|---------|---------|-------------|
| `FORMAT_VERSION` | `1.0.0` | Library version (readonly) | 9 |
| `FORMAT_LOADED` | `1` | Load guard flag | 10 |
| `FORMAT_DEFAULT_WIDTH` | `80` | Default text width (chars) | 36 |
| `FORMAT_TAB_WIDTH` | `4` | Tab width (spaces) | 37 |
| `FORMAT_BULLET_CHAR` | `•` | Bullet character for lists | 38 |
| `FORMAT_TABLE_STYLE` | `unicode` | Box style: `unicode`/`ascii` | 39 |
| `FORMAT_PADDING_CHAR` | ` ` (space) | Padding fill character | 40 |
| `FORMAT_LIST_INDENT` | `  ` (2 spaces) | List indentation (runtime) | 130, 140 |

---

## Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: SMALL -->

**Standard Return Codes:**

| Code | Meaning | Functions |
|------|---------|-----------|
| `0` | Success / Valid | All functions (default) |
| `1` | Error / Invalid | `format-pad` (invalid alignment), library load failures |

**Notes:**
- Most functions always return `0` and output to stdout
- Only `format-pad` validates input and returns `1` for invalid alignment
- Error messages go to stderr via `log-error`

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Purpose

The `_format` extension provides **comprehensive text formatting and styling utilities** for ZSH scripts. It enables professional, clean command-line output with text alignment, padding, wrapping, case conversion, number formatting, and box drawing. Essential for creating polished CLIs, reports, dashboards, and user-facing interfaces.

### Key Features

**Text Alignment & Padding:**
- Left, right, center alignment with configurable width
- Custom padding characters (spaces, dots, etc.)
- Automatic width calculation
- No truncation when text exceeds width

**Text Manipulation:**
- Word-aware text wrapping (uses `fold`)
- Truncation with customizable ellipsis
- Single and multi-line indentation
- Configurable indent characters/strings

**List Formatting:**
- Bulleted lists with custom characters
- Numbered lists with auto-increment
- Configurable indentation

**Number Formatting:**
- Thousands separators (customizable)
- Decimal precision formatting
- Human-readable large numbers

**Case Conversion:**
- Uppercase, lowercase (native ZSH)
- Title case (smart capitalization)
- Unicode-aware

**Visual Elements:**
- Box drawing with Unicode/ASCII borders
- Auto-sizing boxes
- Title and content sections
- Style configuration

**Core Strengths:**
- **Pure ZSH**: Minimal external dependencies (only `fold` for wrapping)
- **Fast**: Native ZSH operations, optimized string handling
- **Configurable**: Environment-based configuration
- **Composable**: Functions chain together cleanly
- **Stateless**: No side effects, deterministic output
- **Production-Ready**: Used by 40+ dotfiles utilities

### Architecture Position

**Layer:** Core Foundation (Layer 1)
**Dependencies:**
- **Required:** `_common` v2.0 (XDG paths, validation)
- **Optional:** `_log` v2.0 (logging - falls back to echo if unavailable)

**Used By:** Multiple utilities for formatted output, reports, dashboards, menus

**Integration Pattern:**
```zsh
source "$(which _format)" 2>/dev/null || {
    echo "Error: _format library not found" >&2
    exit 1
}
```

### Design Philosophy

1. **Composability**: Functions work together seamlessly
2. **Predictability**: Same input always produces same output
3. **Performance**: Minimize string operations, prefer native ZSH
4. **Simplicity**: Clear, focused functions with single responsibilities
5. **Flexibility**: Configurable defaults, override-friendly

---

## Installation

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: SMALL -->

### Standard Installation

The `_format` extension is part of the dotfiles library ecosystem:

```bash
# Source directly
source ~/.local/bin/lib/_format

# Or via which (recommended for portability)
source "$(which _format)" 2>/dev/null || {
    echo "Error: _format library not found" >&2
    exit 1
}
```

### Add to Shell Configuration

```bash
# Add to ~/.zshrc for interactive shell access
echo 'source ~/.local/bin/lib/_format' >> ~/.zshrc

# Reload shell
exec zsh
```

### Verify Installation

```bash
# Run self-test
format-self-test

# Expected output:
# === Testing lib/_format v1.0.0 ===
# Passed: 10/10

# Check version
echo $FORMAT_VERSION
# Output: 1.0.0
```

### Dependencies

**Required:**
- `_common` v2.0+ (auto-loaded if not already sourced)
- ZSH 5.0+ (for native parameter expansions)

**Optional:**
- `_log` v2.0+ (for structured logging - graceful fallback)
- `fold` utility (for word-aware wrapping - typically pre-installed)

### Installation Troubleshooting

**Library Not Found:**
```bash
# Verify file exists
ls -lh ~/.local/bin/lib/_format

# Check PATH includes library directory
echo $PATH | grep -o "\.local/bin/lib"

# Manual path (if needed)
source ~/.local/bin/lib/_format
```

**Dependency Errors:**
```bash
# _common not found
source ~/.local/bin/lib/_common  # Load manually first

# Then load _format
source ~/.local/bin/lib/_format
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

### Example 1: Basic Alignment

**Goal:** Align text in columns for tabular output.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

# Header
echo "$(format-align-left 'Name' 20)$(format-align-right 'Count' 10)"
echo "$(format-align-left '────' 20)$(format-align-right '─────' 10)"

# Data rows
echo "$(format-align-left 'Alice' 20)$(format-align-right '1,234' 10)"
echo "$(format-align-left 'Bob' 20)$(format-align-right '567' 10)"
echo "$(format-align-left 'Charlie' 20)$(format-align-right '89' 10)"
```

**Output:**
```
Name                     Count
────                     ─────
Alice                    1,234
Bob                        567
Charlie                     89
```

**Usage Count:** High - Basic pattern for all tabular output.

---

### Example 2: Formatted Lists

**Goal:** Create bulleted and numbered lists.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

echo "Features:"
format-list-bullet \
    "Fast performance" \
    "Easy to use" \
    "Well documented"

echo ""
echo "Installation Steps:"
format-list-number \
    "Clone repository" \
    "Run installer" \
    "Configure settings"
```

**Output:**
```
Features:
  • Fast performance
  • Easy to use
  • Well documented

Installation Steps:
  1. Clone repository
  2. Run installer
  3. Configure settings
```

**Usage Count:** High - Used in help text, menus, installation guides.

---

### Example 3: Number Formatting

**Goal:** Format large numbers and decimals for readability.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

# Large numbers
users=1234567
formatted=$(format-number "$users")
echo "Total Users: $formatted"
# Output: Total Users: 1,234,567

# Decimal precision
percentage=0.12345
formatted=$(format-decimal "$percentage" 2)
echo "Success Rate: ${formatted}%"
# Output: Success Rate: 0.12%

# Currency formatting
revenue=9876543.21
whole="${revenue%.*}"
decimal="${revenue#*.}"
formatted_whole=$(format-number "$whole")
echo "Revenue: \$${formatted_whole}.${decimal}"
# Output: Revenue: $9,876,543.21
```

**Usage Count:** Medium - Reports, dashboards, statistics display.

---

### Example 4: Status Box

**Goal:** Create a visual status box with formatted information.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

format-box "System Status" \
    "CPU Usage:    45%" \
    "Memory:       8.2 GB / 16 GB" \
    "Disk:         234 GB / 512 GB" \
    "Status:       RUNNING"
```

**Output:**
```
┌───────────────────────────────┐
│      System Status            │
├───────────────────────────────┤
│ CPU Usage:    45%             │
│ Memory:       8.2 GB / 16 GB  │
│ Disk:         234 GB / 512 GB │
│ Status:       RUNNING         │
└───────────────────────────────┘
```

**Usage Count:** Medium - Dashboards, status reports, interactive UIs.

---

### Example 5: Text Truncation

**Goal:** Truncate long text for display in limited space.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

# Long filenames in constrained display
files=(
    "/very/long/path/to/some/important/configuration/file.conf"
    "/another/extremely/long/path/that/needs/truncation.txt"
    "short.txt"
)

for file in "${files[@]}"; do
    truncated=$(format-truncate "$file" 40)
    echo "$truncated"
done
```

**Output:**
```
/very/long/path/to/some/importan...
/another/extremely/long/path/tha...
short.txt
```

**Usage Count:** Medium - File browsers, constrained terminals, table cells.

---

### Example 6: Indented Hierarchical Output

**Goal:** Display hierarchical data with indentation.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

echo "Project Structure:"
echo "$(format-indent 'src/' 1)"
echo "$(format-indent 'main.zsh' 2)"
echo "$(format-indent 'utils.zsh' 2)"
echo "$(format-indent 'tests/' 1)"
echo "$(format-indent 'test-main.zsh' 2)"
echo "$(format-indent 'docs/' 1)"
echo "$(format-indent 'README.md' 2)"
```

**Output:**
```
Project Structure:
  src/
    main.zsh
    utils.zsh
  tests/
    test-main.zsh
  docs/
    README.md
```

**Usage Count:** Medium - Tree views, nested structures, log output.

---

### Example 7: Center-Aligned Headers

**Goal:** Create centered headers for reports and output.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

width=80

echo "$(format-align-center '═══════════════════════════════════════' $width)"
echo "$(format-align-center 'MONTHLY SALES REPORT' $width)"
echo "$(format-align-center 'October 2025' $width)"
echo "$(format-align-center '═══════════════════════════════════════' $width)"
```

**Output:**
```
                   ═══════════════════════════════════════
                        MONTHLY SALES REPORT
                            October 2025
                   ═══════════════════════════════════════
```

**Usage Count:** High - Headers in reports, banners, section separators.

---

### Example 8: Wrapping Long Text

**Goal:** Wrap long paragraphs to fit terminal width.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

text="This is a very long line of text that needs to be wrapped to fit within a specific width constraint. It should break at word boundaries for readability."

format-wrap "$text" 40
```

**Output:**
```
This is a very long line of text that
needs to be wrapped to fit within a
specific width constraint. It should
break at word boundaries for
readability.
```

**Usage Count:** Medium - Help text, documentation, long messages.

---

### Example 9: Case Conversion

**Goal:** Normalize text case for display or comparison.

```zsh
#!/usr/bin/env zsh
source "$(which _format)"

input="hello WORLD"

echo "Original:   $input"
echo "Uppercase:  $(format-uppercase "$input")"
echo "Lowercase:  $(format-lowercase "$input")"
echo "Title Case: $(format-titlecase "$input")"
```

**Output:**
```
Original:   hello WORLD
Uppercase:  HELLO WORLD
Lowercase:  hello world
Title Case: Hello World
```

**Usage Count:** Medium - Text normalization, display formatting, comparisons.

---

### Example 10: Custom Configuration

**Goal:** Customize formatting behavior via environment variables.

```zsh
#!/usr/bin/env zsh

# Configure before loading
export FORMAT_DEFAULT_WIDTH=60
export FORMAT_BULLET_CHAR="→"
export FORMAT_TABLE_STYLE="ascii"
export FORMAT_PADDING_CHAR="."

source "$(which _format)"

# Use custom bullet
format-list-bullet "Task 1" "Task 2"
# Output:
#   → Task 1
#   → Task 2

# Use dot leaders (table of contents style)
echo "$(format-align-left 'Chapter 1' 40)$(format-align-right '1' 10)"
# Output: Chapter 1.........................         1

# ASCII box style
format-box "Title" "Content"
# Output:
# +----------+
# |  Title   |
# +----------+
# | Content  |
# +----------+
```

**Usage Count:** Medium - Special output requirements, terminal compatibility.

---

## API Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->

### Text Alignment Functions

<!-- CONTEXT_GROUP: Alignment -->

#### format-align-left

**Purpose:** Align text to the left with padding on the right.

**Source:** Lines 43-54
**Complexity:** O(n) where n = width
**Caching:** None (stateless)
**Dependencies:** None

**Signature:**
```zsh
format-align-left <text> [width]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to align |
| `width` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Total output width in characters |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Left-aligned text with right padding (stdout)

**Behavior:**
- If `${#text} >= width`: Returns `text` unchanged (no truncation)
- If `${#text} < width`: Pads right side to reach `width`
- Padding uses `FORMAT_PADDING_CHAR` (default: space)
- Preserves all input characters (no escaping)

**Examples:**

```zsh
# Basic left alignment
format-align-left "Hello" 20
# Output: "Hello               " (15 spaces added)

# Custom width
format-align-left "Status: OK" 30
# Output: "Status: OK                    " (20 spaces)

# Text exceeds width (no truncation)
format-align-left "Very long text here" 10
# Output: "Very long text here" (unchanged)

# Empty text
format-align-left "" 10
# Output: "          " (10 spaces)

# Column formatting
echo "$(format-align-left 'Name' 20)$(format-align-left 'Status' 15)"
# Output: "Name                Status         "
```

**Use Cases:**
- Table column alignment (left-aligned data)
- Menu option text
- Key-value pair keys
- File/directory listings

**Performance:**
- **Runtime:** ~0.5ms per call
- **Memory:** O(width) for padding string
- **Optimization:** Cache width if calling repeatedly with same value

**Edge Cases:**
- **Negative width:** Treated as 0, returns text unchanged
- **Non-numeric width:** ZSH error (validate before calling)
- **Multibyte characters:** Correctly handled by ZSH `${#text}`
- **ANSI color codes:** Not stripped, affects length calculation (strip first if needed)

**Integration:**
```zsh
# With color codes (strip before formatting)
text_plain=$(echo "$text_colored" | sed 's/\x1b\[[0-9;]*m//g')
format-align-left "$text_plain" 40

# With truncation
formatted=$(format-truncate "$text" 30 | format-align-left 30)
```

**Related Functions:**
- `format-align-right` - Right alignment
- `format-align-center` - Center alignment
- `format-pad` - Generic padding wrapper

---

#### format-align-right

**Purpose:** Align text to the right with padding on the left.

**Source:** Lines 57-68
**Complexity:** O(n) where n = width
**Caching:** None (stateless)
**Dependencies:** None

**Signature:**
```zsh
format-align-right <text> [width]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to align |
| `width` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Total output width in characters |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Right-aligned text with left padding (stdout)

**Behavior:**
- If `${#text} >= width`: Returns `text` unchanged
- If `${#text} < width`: Pads left side to reach `width`
- Padding uses `FORMAT_PADDING_CHAR`
- Common for numeric column alignment

**Examples:**

```zsh
# Basic right alignment
format-align-right "123" 10
# Output: "       123" (7 spaces before)

# Numeric columns
echo "$(format-align-left 'Item' 20)$(format-align-right 'Price' 10)"
echo "$(format-align-left 'Apple' 20)$(format-align-right '$1.50' 10)"
echo "$(format-align-left 'Banana' 20)$(format-align-right '$0.75' 10)"
# Output:
# Item                     Price
# Apple                    $1.50
# Banana                   $0.75

# Dot leaders
FORMAT_PADDING_CHAR="."
echo "$(format-align-left 'Chapter 1' 40)$(format-align-right 'Page 5' 10)"
# Output: "Chapter 1...........................     Page 5"
```

**Use Cases:**
- Numeric data in tables
- Currency amounts
- Percentages
- Right-aligned menu indices
- Page numbers

**Performance:**
- **Runtime:** ~0.5ms per call
- **Memory:** O(width)

**Edge Cases:**
- Same as `format-align-left`
- Negative numbers: Handle sign correctly (include in width calculation)

**Related Functions:**
- `format-align-left`
- `format-number` - Format numbers before alignment
- `format-decimal` - Format decimals before alignment

---

#### format-align-center

**Purpose:** Center text with padding on both sides.

**Source:** Lines 71-87
**Complexity:** O(n) where n = width
**Caching:** None (stateless)
**Dependencies:** None

**Signature:**
```zsh
format-align-center <text> [width]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to center |
| `width` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Total output width in characters |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Centered text with padding on both sides (stdout)

**Behavior:**
- Calculates total padding: `width - ${#text}`
- Left padding: `total_padding / 2`
- Right padding: `total_padding - left_padding`
- **Odd padding:** Left side gets less padding (e.g., 5 total → 2 left, 3 right)

**Examples:**

```zsh
# Basic centering
format-align-center "Title" 40
# Output: "                 Title                  "

# Headers
format-align-center "SYSTEM REPORT" 80
format-align-center "Generated: 2025-11-07" 80

# Odd width handling
format-align-center "ABC" 10
# Output: "   ABC    " (3 left + 3 ABC + 4 right = 10)

# Box titles
format-box "$(format-align-center 'Status' 30)" "Content"
```

**Use Cases:**
- Report titles
- Section headers
- Banner text
- Dialog box titles
- Menu headers

**Performance:**
- **Runtime:** ~0.5ms per call
- **Memory:** O(width)

**Edge Cases:**
- **Odd remaining space:** Left gets floor(padding/2), right gets ceil(padding/2)
- Very small width: May result in no padding if text is wide

**Related Functions:**
- `format-align-left`
- `format-align-right`
- `format-box` - Uses centering for titles

---

#### format-pad

**Purpose:** Generic text padding with alignment selection (wrapper function).

**Source:** Lines 115-126
**Complexity:** O(n) - delegates to alignment functions
**Caching:** None
**Dependencies:** `format-align-left`, `format-align-right`, `format-align-center`

**Signature:**
```zsh
format-pad <text> [width] [align]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to pad |
| `width` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Total output width |
| `align` | enum | No | `left` | Alignment: `left`, `right`, `center` |

**Returns:**
- **Exit Code:**
  - `0` - Success
  - `1` - Invalid alignment (not left/right/center)
- **Output:** Padded text (stdout)
- **Errors:** "Invalid alignment: <align>" (stderr via `log-error`)

**Behavior:**
- Validates `align` parameter
- Delegates to appropriate `format-align-*` function
- Convenience wrapper for dynamic alignment choice

**Examples:**

```zsh
# Left padding (default)
format-pad "Hello" 20
# Same as: format-align-left "Hello" 20

# Right padding
format-pad "123" 10 "right"
# Same as: format-align-right "123" 10

# Center padding
format-pad "Title" 40 "center"
# Same as: format-align-center "Title" 40

# Dynamic alignment
align_type="right"  # from config or user input
format-pad "$text" 30 "$align_type"

# Error handling
format-pad "Text" 20 "middle" || echo "Invalid alignment"
# Error: Invalid alignment: middle
```

**Use Cases:**
- **Dynamic alignment:** When alignment is determined at runtime
- **Configuration-driven:** User/config specifies alignment preference
- **Simplified API:** Single function instead of choosing specific one

**Performance:**
- Same as underlying alignment function + validation overhead (~0.1ms)

**Edge Cases:**
- **Invalid alignment:** Returns `1`, outputs error to stderr
- **Case-sensitive:** "Left" ≠ "left" (validation will fail)

**Validation:**
```zsh
# Validate alignment before use
valid_alignments=("left" "right" "center")
if [[ ${valid_alignments[(ie)$user_align]} -le ${#valid_alignments} ]]; then
    format-pad "$text" 40 "$user_align"
else
    echo "Error: Invalid alignment" >&2
fi
```

**Related Functions:**
- `format-align-left`, `format-align-right`, `format-align-center` - Specific implementations

---

### Text Manipulation Functions

<!-- CONTEXT_GROUP: Text Manipulation -->

#### format-wrap

**Purpose:** Wrap text to specified width, breaking at word boundaries.

**Source:** Lines 90-95
**Complexity:** O(n) where n = text length
**Caching:** None
**Dependencies:** `fold` (external command)

**Signature:**
```zsh
format-wrap <text> [width]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to wrap |
| `width` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Maximum line width |

**Returns:**
- **Exit Code:** `0` (always succeeds if `fold` available)
- **Output:** Multi-line wrapped text (stdout)

**Behavior:**
- Uses `fold -s -w <width>` for word-aware wrapping
- `-s` flag: Break at spaces (word boundaries)
- Preserves existing newlines in input
- Does not add indentation (use `format-indent-lines` for that)

**Examples:**

```zsh
# Wrap long text
text="This is a very long line of text that needs to be wrapped to fit within a specific width constraint for better readability."
format-wrap "$text" 40
# Output (multi-line):
# This is a very long line of text that
# needs to be wrapped to fit within a
# specific width constraint for better
# readability.

# Preserve existing newlines
format-wrap "Line 1\nLine 2\nLong line 3 that will wrap" 20
# Output:
# Line 1
# Line 2
# Long line 3 that
# will wrap

# Help text formatting
help_text="Usage: command [options] <file>
This command processes the specified file with various options. Long descriptions are automatically wrapped to fit terminal width."
format-wrap "$help_text" 60
```

**Use Cases:**
- Help text / documentation
- Long error messages
- Paragraph formatting
- Terminal output adaptation
- Email/message composition

**Performance:**
- **Runtime:** ~1-3ms (external `fold` command overhead)
- **Memory:** Depends on text size
- **Optimization:** For many wraps, consider batching or caching

**Dependencies:**
- **External:** `fold` utility (POSIX standard, pre-installed on most systems)
- **Fallback:** No built-in fallback (will error if `fold` unavailable)

**Edge Cases:**
- **Very long words:** If single word exceeds width, `fold -s` keeps it on one line (no mid-word breaks)
- **Tabs:** Tabs have variable width, may cause unexpected wrapping
- **ANSI colors:** Color codes not handled, may break mid-sequence (strip first)

**Integration:**

```zsh
# With indentation
format-wrap "$long_text" 60 | format-indent-lines 2

# Strip colors before wrapping
text_plain=$(echo "$colored_text" | sed 's/\x1b\[[0-9;]*m//g')
format-wrap "$text_plain" 70

# Wrap and box
wrapped=$(format-wrap "$text" 40)
format-box "Message" "${(f)wrapped[@]}"  # Split on newlines
```

**Troubleshooting:**

```zsh
# If fold not available
if ! command -v fold &>/dev/null; then
    echo "Error: 'fold' command not found" >&2
    echo "Install: coreutils package" >&2
    exit 1
fi
```

**Related Functions:**
- `format-truncate` - Alternative for single-line length limiting
- `format-indent-lines` - Add indentation to wrapped output

---

#### format-truncate

**Purpose:** Truncate text to maximum length with ellipsis indicator.

**Source:** Lines 98-112
**Complexity:** O(1) - substring operation
**Caching:** None
**Dependencies:** None

**Signature:**
```zsh
format-truncate <text> [max_length] [ellipsis]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to truncate |
| `max_length` | integer | No | `$FORMAT_DEFAULT_WIDTH` (80) | Maximum length including ellipsis |
| `ellipsis` | string | No | `...` | Ellipsis indicator string |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Truncated text (stdout)

**Behavior:**
- If `${#text} <= max_length`: Returns `text` unchanged
- If `${#text} > max_length`:
  - Truncates to `max_length - ${#ellipsis}` characters
  - Appends `ellipsis`
- **Ellipsis length included in max_length**
- If `max_length < ${#ellipsis}`: Sets truncated_length to 0

**Examples:**

```zsh
# Basic truncation
format-truncate "This is a very long line" 20
# Output: "This is a very lo..."

# Custom ellipsis
format-truncate "Long filename.txt" 15 "…"
# Output: "Long filenam…"

# No ellipsis
format-truncate "Some text here" 10 ""
# Output: "Some text " (no indicator)

# Text shorter than max (no truncation)
format-truncate "Short" 20
# Output: "Short"

# Edge: ellipsis longer than max
format-truncate "Text" 2 "..."
# Output: "..." (only ellipsis fits)

# Table cell truncation
files=(
    "/very/long/path/to/file.conf"
    "/another/path/file.txt"
    "short.txt"
)
for file in "${files[@]}"; do
    echo "$(format-truncate "$file" 25) | Status: OK"
done
# Output:
# /very/long/path/to/fi... | Status: OK
# /another/path/file.txt   | Status: OK
# short.txt                | Status: OK
```

**Use Cases:**
- Table cells with limited width
- File/path displays in constrained space
- Preview text in lists
- Terminal width adaptation
- Log output limiting

**Performance:**
- **Runtime:** ~0.3ms (fast substring operation)
- **Memory:** O(max_length)

**Edge Cases:**
- **max_length < ${#ellipsis}:** Only ellipsis shown (or partial ellipsis)
- **Multibyte characters:** May truncate mid-character (ZSH handles gracefully)
- **ANSI colors:** Color codes counted in length (strip first if needed)

**Customization:**

```zsh
# Unicode ellipsis
format-truncate "$text" 30 "…"

# Arrow indicator
format-truncate "$text" 25 " →"

# No indicator
format-truncate "$text" 40 ""

# Custom length per call
max_width=50
format-truncate "$text" "$max_width"
```

**Integration:**

```zsh
# With alignment
truncated=$(format-truncate "$long_text" 30)
format-align-left "$truncated" 30

# Table with truncation
echo "$(format-truncate "$filename" 40) | $(format-align-right "$size" 10)"

# Strip colors before truncation
plain=$(echo "$colored" | sed 's/\x1b\[[0-9;]*m//g')
format-truncate "$plain" 50
```

**Related Functions:**
- `format-wrap` - Multi-line alternative
- `format-align-left` - Often used together for table cells

---

#### format-indent

**Purpose:** Indent a single line of text with specified levels and characters.

**Source:** Lines 200-211
**Complexity:** O(n) where n = levels
**Caching:** None
**Dependencies:** None

**Signature:**
```zsh
format-indent <text> [levels] [char]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to indent |
| `levels` | integer | No | `1` | Number of indentation levels |
| `char` | string | No | `  ` (2 spaces) | Indentation string per level |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Indented text (stdout)

**Behavior:**
- Builds indent string: `char` repeated `levels` times
- Prepends indent to `text`
- Single line only (for multi-line, use `format-indent-lines`)

**Examples:**

```zsh
# Basic indentation (1 level = 2 spaces)
format-indent "Hello"
# Output: "  Hello"

# Multiple levels
format-indent "Nested item" 3
# Output: "      Nested item" (6 spaces)

# Custom indent character (tab)
format-indent "Code line" 1 $'\t'
# Output: "\tCode line"

# Custom string
format-indent "Item" 2 "-> "
# Output: "-> -> Item"

# Hierarchical output
echo "Root"
echo "$(format-indent 'Child 1' 1)"
echo "$(format-indent 'Grandchild 1' 2)"
echo "$(format-indent 'Grandchild 2' 2)"
echo "$(format-indent 'Child 2' 1)"
# Output:
# Root
#   Child 1
#     Grandchild 1
#     Grandchild 2
#   Child 2

# Tree structure
echo "Project/"
echo "$(format-indent 'src/' 1)"
echo "$(format-indent 'main.zsh' 2)"
echo "$(format-indent 'lib/' 2)"
echo "$(format-indent 'tests/' 1)"
```

**Use Cases:**
- Tree/hierarchical displays
- Nested list items
- Code/log indentation
- Structured output
- Menu sub-items

**Performance:**
- **Runtime:** ~0.2ms
- **Memory:** O(levels * ${#char})

**Edge Cases:**
- **levels = 0:** No indentation (returns text as-is)
- **Negative levels:** Treated as 0 (ZSH loop behavior)
- **Empty char:** No indentation regardless of levels

**Patterns:**

```zsh
# Dynamic depth
depth=2
format-indent "$item" "$depth"

# Conditional indentation
[[ $is_nested == "true" ]] && text=$(format-indent "$text" 1)
echo "$text"

# With bullets
echo "$(format-indent "• $item" 2)"
```

**Related Functions:**
- `format-indent-lines` - Multi-line variant (reads stdin)
- `format-list-bullet` - Built-in indentation for lists

---

#### format-indent-lines

**Purpose:** Indent multiple lines from stdin (pipe-friendly).

**Source:** Lines 214-226
**Complexity:** O(n·m) where n = lines, m = levels
**Caching:** None
**Dependencies:** None

**Signature:**
```zsh
format-indent-lines [levels] [char] < input
# or
command | format-indent-lines [levels] [char]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `levels` | integer | No | `1` | Number of indentation levels |
| `char` | string | No | `  ` (2 spaces) | Indentation string per level |
| *stdin* | text stream | Yes | - | Lines to indent |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Indented lines (stdout, multi-line)

**Behavior:**
- Reads from stdin line-by-line
- Prepends indent to **each line** (including empty lines)
- Preserves empty lines (indented)
- Processes indefinitely until EOF

**Examples:**

```zsh
# Indent piped content
echo -e "Line 1\nLine 2\nLine 3" | format-indent-lines
# Output:
#   Line 1
#   Line 2
#   Line 3

# Multiple levels
cat file.txt | format-indent-lines 2
# Each line indented by 4 spaces (2 levels × 2 spaces)

# Custom character
ls -1 | format-indent-lines 1 "  - "
# Output:
#   - file1.txt
#   - file2.txt
#   - dir1/

# Command output
docker ps | format-indent-lines 1
# Indents entire table output

# With wrapped text
format-wrap "$long_text" 60 | format-indent-lines 2
# Wrap then indent all resulting lines

# Heredoc
format-indent-lines 1 <<'EOF'
This is a multi-line
heredoc that will be
indented automatically.
EOF
```

**Use Cases:**
- Indent command output
- Format multi-line strings
- Nested block formatting
- Quote blocks
- Code block indentation
- Log output processing

**Performance:**
- **Runtime:** ~0.3ms per line
- **Memory:** O(levels * ${#char}) per line

**Edge Cases:**
- **Empty lines:** Preserved with indentation (indent string only)
- **Tabs in input:** Preserved, appear after indent
- **Very long lines:** No issue, indent prepended regardless

**Patterns:**

```zsh
# Indent specific command output
{
    echo "Details:"
    some_command --verbose
} | format-indent-lines 1

# Conditional indentation
if [[ $verbose == "true" ]]; then
    command | format-indent-lines 2
else
    command
fi

# Nested indentation
{
    echo "Section 1:"
    {
        echo "Subsection 1.1:"
        command
    } | format-indent-lines 1
} | format-indent-lines 1

# Process substitution
format-indent-lines 1 < <(command)
```

**Related Functions:**
- `format-indent` - Single-line variant
- `format-wrap` - Often used together

---

### List Formatting Functions

<!-- CONTEXT_GROUP: Lists -->

#### format-list-bullet

**Purpose:** Format items as a bulleted list with configurable bullet character.

**Source:** Lines 129-136
**Complexity:** O(n) where n = number of items
**Caching:** None
**Dependencies:** None

**Signature:**
```zsh
format-list-bullet <item1> [item2] [item3] ...
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `item1, item2, ...` | string(s) | Yes | - | List items (variadic) |

**Environment:**
| Variable | Default | Purpose |
|----------|---------|---------|
| `FORMAT_BULLET_CHAR` | `•` | Bullet character |
| `FORMAT_LIST_INDENT` | `  ` (2 spaces) | Indent before bullet |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Bulleted list (stdout, multi-line)

**Behavior:**
- Iterates through all arguments
- Each argument becomes one list item
- Format: `${FORMAT_LIST_INDENT}${FORMAT_BULLET_CHAR} ${item}`
- One line per item

**Examples:**

```zsh
# Basic bulleted list
format-list-bullet "First item" "Second item" "Third item"
# Output:
#   • First item
#   • Second item
#   • Third item

# Array expansion
items=("Feature A" "Feature B" "Feature C")
format-list-bullet "${items[@]}"

# Custom bullet character
FORMAT_BULLET_CHAR="→"
format-list-bullet "Task 1" "Task 2" "Task 3"
# Output:
#   → Task 1
#   → Task 2
#   → Task 3

# Custom indentation
FORMAT_LIST_INDENT="    "
format-list-bullet "Item A" "Item B"
# Output:
#     • Item A
#     • Item B

# ASCII bullet
FORMAT_BULLET_CHAR="*"
format-list-bullet "Point 1" "Point 2"
# Output:
#   * Point 1
#   * Point 2

# In context
echo "Available features:"
format-list-bullet "Fast performance" "Easy setup" "Good documentation"
```

**Use Cases:**
- Feature lists
- Option menus
- Unordered lists
- Help text
- README sections
- Status messages

**Performance:**
- **Runtime:** ~0.3ms per item
- **Memory:** Minimal (no accumulation)

**Customization:**

```zsh
# Unicode bullets
FORMAT_BULLET_CHAR="▪"  # Black small square
FORMAT_BULLET_CHAR="▸"  # Right-pointing triangle
FORMAT_BULLET_CHAR="●"  # Black circle
FORMAT_BULLET_CHAR="◆"  # Black diamond

# ASCII alternatives
FORMAT_BULLET_CHAR="-"
FORMAT_BULLET_CHAR="*"
FORMAT_BULLET_CHAR="+"
FORMAT_BULLET_CHAR=">"

# Emoji bullets
FORMAT_BULLET_CHAR="✓"  # Checkmark
FORMAT_BULLET_CHAR="✗"  # X mark
FORMAT_BULLET_CHAR="➤"  # Arrow
```

**Patterns:**

```zsh
# Nested lists (manual)
echo "Main items:"
format-list-bullet "Item 1" "Item 2"
echo "$(format-indent 'Sub-items:' 1)"
FORMAT_LIST_INDENT="    " format-list-bullet "Sub A" "Sub B"

# Conditional items
items=()
[[ $feature_a == "enabled" ]] && items+=("Feature A")
[[ $feature_b == "enabled" ]] && items+=("Feature B")
format-list-bullet "${items[@]}"

# Mixed with other formatting
echo "Status Report:"
format-list-bullet "$(format-uppercase 'success'): Task 1" "$(format-uppercase 'pending'): Task 2"
```

**Related Functions:**
- `format-list-number` - Numbered alternative
- `format-indent` - For nested lists

---

#### format-list-number

**Purpose:** Format items as a numbered list with auto-incrementing indices.

**Source:** Lines 139-147
**Complexity:** O(n) where n = number of items
**Caching:** None
**Dependencies:** None

**Signature:**
```zsh
format-list-number <item1> [item2] [item3] ...
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `item1, item2, ...` | string(s) | Yes | - | List items (variadic) |

**Environment:**
| Variable | Default | Purpose |
|----------|---------|---------|
| `FORMAT_LIST_INDENT` | `  ` (2 spaces) | Indent before number |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Numbered list (stdout, multi-line)

**Behavior:**
- Numbers start at 1
- Auto-increments for each item
- Format: `${FORMAT_LIST_INDENT}${index}. ${item}`
- One line per item

**Examples:**

```zsh
# Basic numbered list
format-list-number "First step" "Second step" "Third step"
# Output:
#   1. First step
#   2. Second step
#   3. Third step

# Array expansion
steps=("Install dependencies" "Configure settings" "Run application")
format-list-number "${steps[@]}"
# Output:
#   1. Install dependencies
#   2. Configure settings
#   3. Run application

# Custom indentation
FORMAT_LIST_INDENT="  "
format-list-number "Step 1" "Step 2"
# Output:
#   1. Step 1
#   2. Step 2

# In instructions
echo "Installation Steps:"
format-list-number \
    "Download the package" \
    "Extract files" \
    "Run installer" \
    "Verify installation"
```

**Use Cases:**
- Sequential instructions
- Step-by-step guides
- Ordered procedures
- Ranked lists
- Table of contents
- Priority lists

**Performance:**
- **Runtime:** ~0.3ms per item
- **Memory:** Minimal

**Patterns:**

```zsh
# Large lists (alignment consideration)
# For 10+ items, numbers may misalign:
#   1. Item
#   ...
#   10. Item
# Consider manual padding for large lists

# Conditional steps
steps=()
[[ $include_setup == "true" ]] && steps+=("Run setup")
steps+=("Configure")
steps+=("Deploy")
format-list-number "${steps[@]}"

# Start from different number (manual)
offset=5
index=$offset
for item in "${items[@]}"; do
    echo "  $((index++)). $item"
done
```

**Limitations:**
- **Fixed start:** Always starts at 1 (no offset parameter)
- **Alignment:** Numbers >9 may misalign with single digits (no auto-padding)
- **No nesting:** Nested numbering (1.1, 1.2) not supported

**Related Functions:**
- `format-list-bullet` - Unordered alternative
- `format-indent` - For sub-lists

---

### Number Formatting Functions

<!-- CONTEXT_GROUP: Numbers -->

#### format-number

**Purpose:** Format integer with thousands separators for readability.

**Source:** Lines 150-162
**Complexity:** O(n) where n = digits (sed regex)
**Caching:** None
**Dependencies:** `sed` (external)

**Signature:**
```zsh
format-number <number> [separator]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `number` | integer | Yes | - | Number to format (integers only) |
| `separator` | string | No | `,` | Thousands separator character |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Formatted number (stdout)

**Behavior:**
- **Pre-processing:** Strips existing commas and underscores from input
- **Validation:** Checks if result is numeric (`^[0-9]+$`)
- **Formatting:** Inserts `separator` every 3 digits from right
- **Non-numeric:** Returns input unchanged (no error)

**Examples:**

```zsh
# Basic formatting
format-number "1234567"
# Output: 1,234,567

# Custom separator
format-number "1234567" "_"
# Output: 1_234_567

# European style (space separator)
format-number "1234567" " "
# Output: 1 234 567

# Dot separator (European thousands)
format-number "9876543" "."
# Output: 9.876.543

# Small numbers (no separator needed)
format-number "123"
# Output: 123

# Already formatted (strips and reformats)
format-number "1,234,567"
# Output: 1,234,567

# Non-numeric input (returned unchanged)
format-number "abc123"
# Output: abc123

# Usage in context
users=1234567
echo "Total users: $(format-number "$users")"
# Output: Total users: 1,234,567
```

**Use Cases:**
- Display large counts (users, files, records)
- Financial amounts (whole numbers)
- Statistics reports
- Dashboard metrics
- Log analysis

**Performance:**
- **Runtime:** ~0.8ms (sed overhead)
- **Memory:** Minimal

**Edge Cases:**
- **Decimals:** Not supported, decimal point treated as non-numeric
  - Use `format-decimal` for floating-point numbers
- **Negative numbers:** Sign stripped during validation (won't format)
- **Very large numbers:** Works for arbitrary length
- **Leading zeros:** Preserved initially, may affect validation

**Implementation Details:**
```zsh
# Regex breakdown: sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
# :a           - Label 'a'
# \B           - Not a word boundary (inside number)
# [0-9]\{3\}   - Exactly 3 digits
# \>           - Word boundary (end of number/group)
# ,&           - Prepend comma to matched group
# ta           - Loop back to 'a' if substitution made
```

**Integration:**

```zsh
# With alignment
count=$(format-number "1234567")
echo "$(format-align-left 'Total' 20)$(format-align-right "$count" 15)"

# Currency formatting (whole numbers)
amount=1234567
formatted=$(format-number "$amount")
echo "Revenue: \$$formatted"
# Output: Revenue: $1,234,567

# International formats
# US: 1,234,567
# EU: 1.234.567 or 1 234 567
locale="US"
[[ $locale == "US" ]] && sep="," || sep="."
format-number "$number" "$sep"
```

**Limitations:**
- **Integers only:** No decimal support
- **No currency symbols:** Add manually
- **No negative sign handling:** Strip and re-add manually
- **Fixed grouping:** Always groups by 3 (some locales use different groupings)

**Related Functions:**
- `format-decimal` - For floating-point numbers
- `format-align-right` - For column alignment

---

#### format-decimal

**Purpose:** Format number to specific decimal places with rounding.

**Source:** Lines 165-170
**Complexity:** O(1) - printf operation
**Caching:** None
**Dependencies:** `printf` (built-in)

**Signature:**
```zsh
format-decimal <number> [places]
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `number` | float/int | Yes | - | Number to format |
| `places` | integer | No | `2` | Decimal places (precision) |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Formatted number (stdout)

**Behavior:**
- Uses `printf "%.${places}f" "$number"`
- **Rounding:** Rounds to specified precision (not truncation)
- **Zero padding:** Always shows `places` digits after decimal (adds zeros if needed)
- **Integers:** Converts to decimal with `.00` (or specified places)

**Examples:**

```zsh
# Basic decimal formatting
format-decimal "3.14159" 2
# Output: 3.14

# More precision
format-decimal "3.14159" 4
# Output: 3.1416 (rounded)

# Rounding
format-decimal "2.5" 0
# Output: 3 (rounds to nearest integer)

format-decimal "2.4" 0
# Output: 2

# Integer input (adds decimal places)
format-decimal "42" 2
# Output: 42.00

# Percentage formatting
success_rate=0.12345
formatted=$(format-decimal "$success_rate" 2)
echo "Success rate: $formatted%"
# Output: Success rate: 0.12%

# Scientific notation input
format-decimal "1.23e-4" 6
# Output: 0.000123

# Very high precision
format-decimal "3.14159265359" 10
# Output: 3.1415926536 (rounded at 10th place)
```

**Use Cases:**
- Percentages
- Rates and ratios
- Scientific measurements
- Financial amounts (cents)
- Statistics
- Precision control

**Performance:**
- **Runtime:** Fast (~0.1ms, built-in printf)
- **Memory:** Minimal

**Edge Cases:**
- **Negative places:** Undefined behavior (don't use)
- **Very large places:** May hit precision limits (>15 typically)
- **Non-numeric input:** Printf error (validate first)
- **NaN/Infinity:** Platform-dependent behavior

**Patterns:**

```zsh
# Currency (2 decimal places)
price=1234.5
formatted=$(format-decimal "$price" 2)
echo "\$${formatted}"
# Output: $1234.50

# Percentage
value=0.12345
pct=$(format-decimal "$((value * 100))" 1)
echo "${pct}%"
# Output: 12.3%

# Combining with thousands separator (manual)
value=1234567.89
whole="${value%.*}"
decimal="${value#*.}"
formatted_whole=$(format-number "$whole")
formatted_decimal=$(format-decimal "0.${decimal}" 2)
formatted_decimal="${formatted_decimal#*.}"  # Strip leading "0."
echo "\$${formatted_whole}.${formatted_decimal}"
# Output: $1,234,567.89

# Scientific notation
value=0.00012345
formatted=$(format-decimal "$value" 8)
echo "$formatted"
# Output: 0.00012345
```

**Validation:**

```zsh
# Validate numeric input
if [[ "$number" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    format-decimal "$number" 2
else
    echo "Error: Not a valid number" >&2
    return 1
fi
```

**Related Functions:**
- `format-number` - For integer thousands separators
- `format-align-right` - For column alignment of decimals

---

### Case Conversion Functions

<!-- CONTEXT_GROUP: Case Conversion -->

#### format-uppercase

**Purpose:** Convert text to uppercase.

**Source:** Lines 173-176
**Complexity:** O(n) - native ZSH parameter expansion
**Caching:** None
**Dependencies:** None (native ZSH)

**Signature:**
```zsh
format-uppercase <text>
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to convert |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Uppercased text (stdout)

**Behavior:**
- Uses ZSH parameter expansion: `${text:u}`
- **Unicode-aware:** Handles international characters
- **Fast:** Native operation, no external commands

**Examples:**

```zsh
# Basic conversion
format-uppercase "hello world"
# Output: HELLO WORLD

# Mixed case
format-uppercase "MiXeD CaSe"
# Output: MIXED CASE

# Unicode
format-uppercase "café"
# Output: CAFÉ

# All uppercase (idempotent)
format-uppercase "ALREADY UPPER"
# Output: ALREADY UPPER

# In context
level="warning"
echo "[$(format-uppercase "$level")] Message"
# Output: [WARNING] Message

# Environment variable normalization
user_input="yes"
normalized=$(format-uppercase "$user_input")
[[ "$normalized" == "YES" ]] && echo "Confirmed"
```

**Use Cases:**
- Log level formatting
- Constant naming
- Case-insensitive comparison
- Header text
- Emphasis
- Environment variable normalization

**Performance:**
- **Runtime:** ~0.1ms (very fast, native)
- **Memory:** O(n)

**Patterns:**

```zsh
# Case-insensitive comparison
input=$(format-uppercase "$user_input")
if [[ "$input" == "YES" || "$input" == "Y" ]]; then
    proceed
fi

# Acronyms
protocol="http"
echo "Protocol: $(format-uppercase "$protocol")"
# Output: Protocol: HTTP

# Headers
echo "$(format-uppercase 'section 1: introduction')"
# Output: SECTION 1: INTRODUCTION
```

**Related Functions:**
- `format-lowercase` - Inverse operation
- `format-titlecase` - Capitalize first letter of each word

---

#### format-lowercase

**Purpose:** Convert text to lowercase.

**Source:** Lines 179-182
**Complexity:** O(n) - native ZSH
**Caching:** None
**Dependencies:** None (native ZSH)

**Signature:**
```zsh
format-lowercase <text>
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to convert |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Lowercased text (stdout)

**Behavior:**
- Uses ZSH parameter expansion: `${text:l}`
- **Unicode-aware:** Handles international characters
- **Fast:** Native operation

**Examples:**

```zsh
# Basic conversion
format-lowercase "HELLO WORLD"
# Output: hello world

# Mixed case
format-lowercase "MiXeD CaSe"
# Output: mixed case

# Unicode
format-lowercase "CAFÉ"
# Output: café

# All lowercase (idempotent)
format-lowercase "already lower"
# Output: already lower

# Filename normalization
filename="MyDocument.PDF"
normalized=$(format-lowercase "$filename")
echo "$normalized"
# Output: mydocument.pdf
```

**Use Cases:**
- Filename normalization
- Case-insensitive comparisons
- Email address normalization
- URL processing
- Variable naming
- Search term normalization

**Performance:**
- **Runtime:** ~0.1ms (very fast, native)
- **Memory:** O(n)

**Patterns:**

```zsh
# Case-insensitive comparison
email=$(format-lowercase "$user_email")
if [[ "$email" == "admin@example.com" ]]; then
    grant_admin_access
fi

# Filename safety
original="Report 2025.PDF"
safe=$(format-lowercase "${original// /_}")
echo "$safe"
# Output: report_2025.pdf

# Command normalization
command=$(format-lowercase "$user_command")
case "$command" in
    start|begin|run) start_service ;;
    stop|halt|end) stop_service ;;
esac
```

**Related Functions:**
- `format-uppercase` - Inverse operation
- `format-titlecase` - Mixed case variant

---

#### format-titlecase

**Purpose:** Convert text to title case (capitalize first letter of each word).

**Source:** Lines 185-197
**Complexity:** O(n·w) where n = text length, w = words
**Caching:** None
**Dependencies:** None (native ZSH)

**Signature:**
```zsh
format-titlecase <text>
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to convert |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Title-cased text (stdout)

**Behavior:**
- Splits text into words (space-delimited)
- For each word:
  - First character: Uppercase `${(U)first}`
  - Remaining characters: Lowercase `${(L)rest}`
- Joins words with spaces
- **Simple implementation:** Does not handle articles/prepositions specially (e.g., "the", "of" still capitalized)

**Examples:**

```zsh
# Basic title case
format-titlecase "hello world"
# Output: Hello World

# All lowercase input
format-titlecase "the quick brown fox"
# Output: The Quick Brown Fox

# All uppercase input
format-titlecase "SHOUTING TEXT HERE"
# Output: Shouting Text Here

# Mixed case input (normalized)
format-titlecase "mIxEd CaSe TeXt"
# Output: Mixed Case Text

# Single word
format-titlecase "introduction"
# Output: Introduction

# Headers
title="user guide for system administration"
echo "$(format-titlecase "$title")"
# Output: User Guide For System Administration
```

**Use Cases:**
- Document titles
- Section headers
- Name formatting
- Menu labels
- Proper nouns
- UI text

**Performance:**
- **Runtime:** ~0.5ms (word iteration overhead)
- **Memory:** O(n + w) for word array

**Limitations:**
- **No grammar rules:** Always capitalizes every word (including "the", "of", "and")
- **Hyphenated words:** Treated as single word ("Self-Service" → "Self-service")
- **Apostrophes:** May produce odd results ("It's" → "It's" but depends on splitting)

**Patterns:**

```zsh
# Document headers
section="chapter 1: introduction to shell scripting"
echo "$(format-titlecase "$section")"
# Output: Chapter 1: Introduction To Shell Scripting

# Name formatting
name="john doe"
formatted=$(format-titlecase "$name")
echo "Welcome, $formatted"
# Output: Welcome, John Doe

# Menu options
option="view system status"
echo "$(format-titlecase "$option")"
# Output: View System Status
```

**Workarounds for Articles:**

```zsh
# Manual article handling (basic example)
title=$(format-titlecase "$input")
# Lowercase common articles (simple sed replacement)
title=$(echo "$title" | sed 's/ The / the /g; s/ Of / of /g; s/ And / and /g')
echo "$title"
# Note: Doesn't lowercase first/last word (proper title case)
```

**Related Functions:**
- `format-uppercase` - Full uppercase
- `format-lowercase` - Full lowercase

---

### Visual Formatting Functions

<!-- CONTEXT_GROUP: Visual Elements -->

#### format-box

**Purpose:** Draw a box around text with title and optional content lines.

**Source:** Lines 229-282
**Complexity:** O(n·m) where n = max line width, m = number of lines
**Caching:** None
**Dependencies:** `format-align-center`, `format-pad`

**Signature:**
```zsh
format-box <title> [line1] [line2] [line3] ...
```

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | string | Yes | - | Box title (centered) |
| `line1, line2, ...` | string(s) | No | - | Content lines (left-aligned) |

**Environment:**
| Variable | Default | Purpose |
|----------|---------|---------|
| `FORMAT_TABLE_STYLE` | `unicode` | Box style: `unicode` or `ascii` |

**Returns:**
- **Exit Code:** `0` (always succeeds)
- **Output:** Multi-line box (stdout)

**Behavior:**
- **Auto-sizing:** Box width = max(title length, longest content line) + 4 (padding)
- **Title:** Centered in top section
- **Separator:** Horizontal line between title and content (if content exists)
- **Content:** Left-aligned lines with padding
- **Borders:** Unicode (┌─┐│└┘) or ASCII (+-+||++) based on `FORMAT_TABLE_STYLE`

**Box Styles:**

**Unicode (`FORMAT_TABLE_STYLE=unicode`):**
```
┌──────────────┐
│    Title     │
├──────────────┤
│ Content line │
└──────────────┘
```

**ASCII (`FORMAT_TABLE_STYLE=ascii`):**
```
+--------------+
|    Title     |
+--------------+
| Content line |
+--------------+
```

**Examples:**

```zsh
# Simple title-only box
format-box "Welcome"
# Output:
# ┌───────────┐
# │  Welcome  │
# └───────────┘

# Box with content
format-box "Status" "CPU: 45%" "RAM: 8GB" "Disk: 234GB"
# Output:
# ┌──────────────┐
# │    Status    │
# ├──────────────┤
# │ CPU: 45%     │
# │ RAM: 8GB     │
# │ Disk: 234GB  │
# └──────────────┘

# ASCII style
FORMAT_TABLE_STYLE="ascii"
format-box "Title" "Content"
# Output:
# +----------+
# |  Title   |
# +----------+
# | Content  |
# +----------+

# Long content (box auto-sizes)
format-box "System Information" \
    "Hostname: server01.example.com" \
    "OS: Arch Linux" \
    "Kernel: 6.6.107-1-MANJARO"
# Box width adapts to longest line

# Menu box
format-box "Main Menu" \
    "1. Start Service" \
    "2. Stop Service" \
    "3. View Status" \
    "4. Exit"

# Status dashboard
format-box "Docker Containers" \
    "Running: 12" \
    "Stopped: 3" \
    "Total: 15"
```

**Use Cases:**
- Status displays
- Menus
- Alerts/notifications
- Dashboards
- Headers
- Dialog boxes
- Summary cards

**Performance:**
- **Runtime:** ~2-5ms (depends on content lines)
- **Memory:** O(max_width · num_lines)

**Customization:**

```zsh
# Terminal without Unicode support
FORMAT_TABLE_STYLE="ascii"

# Inline style change
FORMAT_TABLE_STYLE="unicode" format-box "Title" "Content"

# Custom box borders (manual implementation needed)
# Current implementation doesn't support full customization
```

**Edge Cases:**
- **Empty title:** Creates box with empty centered line
- **No content:** Only title section, no separator
- **Very long lines:** Box width can become quite large
- **Multibyte characters:** May cause alignment issues (character width ≠ display width)

**Integration:**

```zsh
# With formatted content
cpu_usage=45
mem_usage=8.2
format-box "Resources" \
    "CPU: $(format-align-right "${cpu_usage}%" 10)" \
    "Memory: $(format-align-right "${mem_usage} GB" 10)"

# Nested in script
show_status() {
    format-box "Status" \
        "Service: $(format-uppercase 'running')" \
        "PID: $$" \
        "Uptime: $(uptime -p)"
}

# Conditional content
lines=("Title line")
[[ $verbose == "true" ]] && lines+=("Verbose: enabled")
format-box "Info" "${lines[@]}"
```

**Troubleshooting:**

```zsh
# Unicode characters not displaying
# Fix: Switch to ASCII
FORMAT_TABLE_STYLE="ascii"

# Alignment issues with colors
# Fix: Strip ANSI codes before formatting
plain_text=$(echo "$colored_text" | sed 's/\x1b\[[0-9;]*m//g')
format-box "Title" "$plain_text"

# Box too wide
# Fix: Truncate long lines
truncated=$(format-truncate "$long_line" 60)
format-box "Title" "$truncated"
```

**Related Functions:**
- `format-align-center` - Used for title centering
- `format-pad` - Used for content padding

---

### Testing & Verification

<!-- CONTEXT_GROUP: Testing -->

#### format-self-test

**Purpose:** Run comprehensive self-tests to verify library functionality.

**Source:** Lines 285-318
**Complexity:** N/A (test suite)
**Caching:** None
**Dependencies:** All format functions

**Signature:**
```zsh
format-self-test
```

**Parameters:** None

**Returns:**
- **Exit Code:**
  - `0` - All tests passed
  - `1` - One or more tests failed
- **Output:** Test results summary (stdout)

**Behavior:**
- Runs 10 unit tests covering major functions
- Tracks passed/failed counts
- Outputs summary: "Passed: X/10"
- Returns 0 only if all tests pass

**Tests Performed:**

1. **Left alignment:** Verifies output length = 10
2. **Right alignment:** Verifies length = 10 and text at end
3. **Center alignment:** Verifies output length = 10
4. **Truncation:** Verifies truncated length ≤ 10
5. **Number formatting:** Verifies "1234567" → "1,234,567"
6. **Uppercase:** Verifies "hello" → "HELLO"
7. **Lowercase:** Verifies "WORLD" → "world"
8. **Title case:** Verifies "hello world" → "Hello World"
9. **Indentation:** Verifies indent contains spaces
10. **Bullet list:** Verifies output contains bullet character

**Examples:**

```zsh
# Run tests
format-self-test
# Output:
# === Testing lib/_format v1.0.0 ===
# Passed: 10/10
# Exit code: 0

# In installation script
if format-self-test; then
    echo "Format library working correctly"
else
    echo "Format library tests failed!" >&2
    exit 1
fi

# Verbose testing (manual)
FORMAT_VERBOSE=1 format-self-test  # Not implemented, but pattern
```

**Use Cases:**
- Post-installation verification
- Continuous integration tests
- Troubleshooting library issues
- Version upgrade validation
- Development testing

**Exit Codes:**
- **0:** All 10 tests passed
- **1:** At least one test failed

**Troubleshooting:**

If tests fail:
1. Check ZSH version (requires 5.0+)
2. Verify dependencies loaded (_common, _log)
3. Check for environment variable conflicts
4. Ensure `fold` and `sed` available

---

## Best Practices

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### 1. Always Specify Width for Consistent Output

**Problem:** Default width (80) may not suit all contexts.

**Solution:** Explicitly specify width based on context.

```zsh
# Bad: Relies on default
format-align-left "$text"

# Good: Explicit width
terminal_width=80
format-align-left "$text" "$terminal_width"

# Better: Dynamic terminal width
width=${COLUMNS:-80}
format-align-left "$text" "$width"
```

---

### 2. Strip ANSI Colors Before Formatting

**Problem:** ANSI color codes affect length calculations.

**Solution:** Strip colors before alignment/truncation operations.

```zsh
# Bad: Color codes affect alignment
colored_text="\e[31mError\e[0m"
format-align-left "$colored_text" 20  # Misaligned

# Good: Strip first
plain_text=$(echo "$colored_text" | sed 's/\x1b\[[0-9;]*m//g')
formatted=$(format-align-left "$plain_text" 20)
# Re-apply colors if needed
echo -e "\e[31m${formatted}\e[0m"
```

---

### 3. Use Truncation for Table Cells

**Problem:** Long text breaks table formatting.

**Solution:** Truncate cell content to maximum width.

```zsh
# Good: Truncate before alignment
max_width=30
truncated=$(format-truncate "$long_filename" "$max_width")
echo "$(format-align-left "$truncated" "$max_width") | Status"
```

---

### 4. Combine Functions for Complex Formatting

**Problem:** Need both wrapping and indentation.

**Solution:** Pipe functions together.

```zsh
# Wrap then indent
format-wrap "$long_text" 60 | format-indent-lines 2

# Truncate then align
format-truncate "$text" 40 | format-align-left 40
```

---

### 5. Cache Formatted Values in Loops

**Problem:** Repeated formatting in loops is slow.

**Solution:** Format once, store result.

```zsh
# Bad: Format in loop
for item in "${items[@]}"; do
    echo "$(format-align-left "$item" 40)"
done

# Better: Pre-format
formatted_items=()
for item in "${items[@]}"; do
    formatted_items+=($(format-align-left "$item" 40))
done
for formatted in "${formatted_items[@]}"; do
    echo "$formatted"
done

# Best: Use array operations (if applicable)
# (ZSH doesn't have great support for this, so loop pre-formatting is acceptable)
```

---

### 6. Use ASCII Style for Maximum Compatibility

**Problem:** Unicode box characters may not display in all terminals.

**Solution:** Use ASCII style or detect terminal capabilities.

```zsh
# Default to ASCII for scripts
FORMAT_TABLE_STYLE="ascii"

# Or detect UTF-8 support
if [[ "$LANG" =~ "UTF-8" ]]; then
    FORMAT_TABLE_STYLE="unicode"
else
    FORMAT_TABLE_STYLE="ascii"
fi
```

---

### 7. Validate Numeric Input Before Formatting

**Problem:** Non-numeric input to `format-number` or `format-decimal`.

**Solution:** Validate before calling.

```zsh
# Validate integer
if [[ "$input" =~ ^[0-9]+$ ]]; then
    format-number "$input"
else
    echo "Error: Not a valid number" >&2
fi

# Validate float
if [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    format-decimal "$input" 2
else
    echo "Error: Not a valid decimal" >&2
fi
```

---

### 8. Use Environment Variables for Consistent Styling

**Problem:** Hardcoded formatting parameters throughout codebase.

**Solution:** Configure once via environment variables.

```zsh
# At script start
export FORMAT_DEFAULT_WIDTH=70
export FORMAT_BULLET_CHAR="→"
export FORMAT_TABLE_STYLE="unicode"

# Then use defaults throughout
format-align-left "$text"  # Uses 70
format-list-bullet "Item"  # Uses →
format-box "Title"         # Uses unicode
```

---

### 9. Prefer Native Functions for Performance

**Problem:** Using external commands when native ZSH available.

**Solution:** Use native parameter expansions for case conversion.

```zsh
# If only need uppercase inline
echo "${text:u}"  # Faster than format-uppercase for simple cases

# But use functions for consistency/readability in complex scripts
formatted=$(format-uppercase "$text")
```

---

### 10. Test with Edge Cases

**Problem:** Formatting breaks with unusual input.

**Solution:** Test with empty, very long, special characters.

```zsh
# Test cases
test_cases=(
    ""                          # Empty
    "x"                         # Single char
    "Very long text that exceeds normal width limits"  # Long
    "Text with    spaces"       # Multiple spaces
    $'Text with\ttabs'          # Tabs
    "Unicode: café"             # Multibyte
)

for test in "${test_cases[@]}"; do
    result=$(format-align-left "$test" 20)
    echo "Input: '$test' | Output: '$result' | Length: ${#result}"
done
```

---

### 11. Document Custom Configuration

**Problem:** Other developers don't know about custom settings.

**Solution:** Document environment variables at script start.

```zsh
#!/usr/bin/env zsh

# Configuration (override before sourcing if needed)
: ${FORMAT_DEFAULT_WIDTH:=70}
: ${FORMAT_TABLE_STYLE:=unicode}
: ${FORMAT_BULLET_CHAR:=•}

source "$(which _format)"
```

---

### 12. Use Meaningful Function Names in Wrappers

**Problem:** Wrapping format functions with unclear names.

**Solution:** Use descriptive wrapper names.

```zsh
# Bad: Unclear purpose
format_it() { format-align-left "$1" 40; }

# Good: Clear purpose
format_menu_item() { format-align-left "$1" 40; }
format_table_cell() { format-truncate "$1" 30 | format-align-left 30; }
```

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_SIZE: MEDIUM -->

### Issue: Alignment Not Working / Text Misaligned

**Symptoms:**
- Columns don't line up
- Padding appears incorrect
- Width seems wrong

**Causes & Solutions:**

**1. ANSI Color Codes in Text**
```zsh
# Problem
text="\e[31mError\e[0m"
format-align-left "$text" 20  # Codes counted in length

# Solution: Strip colors first
plain=$(echo "$text" | sed 's/\x1b\[[0-9;]*m//g')
format-align-left "$plain" 20
```

**2. Tabs in Input**
```zsh
# Problem
text="Item\tValue"
format-align-left "$text" 30  # Tab has variable width

# Solution: Replace tabs with spaces
text="${text//$'\t'/    }"  # 4 spaces
format-align-left "$text" 30
```

**3. Multibyte Characters**
```zsh
# Problem: Display width ≠ character count
text="café"  # é = 1 char, but may display wider
format-align-left "$text" 10

# Solution: Be aware (no easy fix in pure ZSH)
# Consider ASCII-only content for precise alignment
```

**4. Wrong Width Parameter**
```zsh
# Problem: Non-numeric width
format-align-left "$text" "wide"  # Error

# Solution: Validate width
width=20
[[ "$width" =~ ^[0-9]+$ ]] && format-align-left "$text" "$width"
```

---

### Issue: Box Characters Not Displaying (□ or ?)

**Symptoms:**
- Unicode box characters show as squares, question marks, or mojibake

**Causes & Solutions:**

**1. Terminal Encoding Not UTF-8**
```bash
# Check encoding
locale | grep UTF-8

# If not UTF-8, switch to ASCII
FORMAT_TABLE_STYLE="ascii"
format-box "Title" "Content"
```

**2. Font Missing Glyphs**
```bash
# Install Unicode-capable font (Arch Linux example)
sudo pacman -S ttf-dejavu ttf-liberation

# Or switch to ASCII
FORMAT_TABLE_STYLE="ascii"
```

**3. Terminal Emulator Limitations**
```bash
# Some terminals don't support box drawing
# Use ASCII style as fallback
FORMAT_TABLE_STYLE="ascii"
```

---

### Issue: Number Formatting Not Working

**Symptoms:**
- `format-number` returns input unchanged
- Separators not appearing

**Causes & Solutions:**

**1. Non-Numeric Input**
```zsh
# Problem
format-number "abc123"  # Returns "abc123"

# Solution: Validate first
if [[ "$input" =~ ^[0-9]+$ ]]; then
    format-number "$input"
else
    echo "Error: Not a number" >&2
fi
```

**2. Input Already Has Separators**
```zsh
# This works (strips existing separators)
format-number "1,234,567"  # Output: 1,234,567

# But decimal points break validation
format-number "1234.56"  # Returns unchanged (not pure integer)

# Solution: Use format-decimal for floats
format-decimal "1234.56" 2
```

**3. Negative Numbers**
```zsh
# Problem: Sign causes validation failure
format-number "-1234"  # May not work

# Solution: Handle sign separately
if [[ "$number" =~ ^- ]]; then
    sign="-"
    number="${number#-}"
else
    sign=""
fi
formatted=$(format-number "$number")
echo "${sign}${formatted}"
```

---

### Issue: Wrapping Breaks Mid-Word

**Symptoms:**
- Long words split across lines unexpectedly

**Cause:**
- Terminal width constraint vs. word length

**Solution:**
```zsh
# fold -s keeps words intact, but very long words stay on one line
# This is expected behavior

# If you need mid-word breaks:
# Use fold without -s (not recommended for readability)
echo "$text" | fold -w 40  # Breaks anywhere

# Or truncate instead of wrap
format-truncate "$text" 40
```

---

### Issue: List Indentation Incorrect

**Symptoms:**
- Lists not indenting as expected

**Cause:**
- `FORMAT_LIST_INDENT` environment variable

**Solution:**
```zsh
# Check current setting
echo "Indent: '${FORMAT_LIST_INDENT:-  }'"

# Set explicitly
FORMAT_LIST_INDENT="    "  # 4 spaces
format-list-bullet "Item"

# Or use format-indent manually
echo "$(format-indent '• Item' 2)"
```

---

### Issue: Title Case Capitalizes Articles

**Symptoms:**
- "The", "Of", "And" capitalized (e.g., "The Book Of Secrets")

**Cause:**
- Simple implementation capitalizes all words

**Workaround:**
```zsh
# Basic article lowercasing (not perfect)
title=$(format-titlecase "$input")
title=$(echo "$title" | sed 's/ The / the /g; s/ Of / of /g; s/ And / and /g')
# Note: Doesn't lowercase first/last word (proper behavior)

# For production, consider dedicated title-case library
```

---

### Issue: format-self-test Fails

**Symptoms:**
- Self-test reports failures

**Troubleshooting Steps:**

**1. Check ZSH Version**
```bash
zsh --version
# Requires ZSH 5.0+
```

**2. Check Dependencies**
```zsh
# Verify _common loaded
typeset -f common-xdg-cache-home >/dev/null || echo "_common not loaded"

# Verify fold available
command -v fold || echo "fold not found"

# Verify sed available
command -v sed || echo "sed not found"
```

**3. Check Environment Conflicts**
```zsh
# Reset to defaults
unset FORMAT_DEFAULT_WIDTH FORMAT_TAB_WIDTH FORMAT_BULLET_CHAR
unset FORMAT_TABLE_STYLE FORMAT_PADDING_CHAR

# Re-run test
format-self-test
```

**4. Run Individual Tests**
```zsh
# Test alignment
result=$(format-align-left "test" 10)
echo "Length: ${#result}, Expected: 10"

# Test number formatting
result=$(format-number "1234567")
echo "Result: '$result', Expected: '1,234,567'"
```

---

### Issue: Performance Slow in Loops

**Symptoms:**
- Formatting many items takes long time

**Solutions:**

**1. Cache Results**
```zsh
# Bad: Format repeatedly
for i in {1..1000}; do
    echo "$(format-align-left "$item" 40)"
done

# Good: Pre-format
formatted=()
for item in "${items[@]}"; do
    formatted+=($(format-align-left "$item" 40))
done
printf '%s\n' "${formatted[@]}"
```

**2. Avoid External Commands**
```zsh
# Slow: Uses sed
format-number "1234567"

# Fast: Use native ZSH for simple cases
# (But format-number provides specific formatting, so trade-off)
```

**3. Batch Operations**
```zsh
# Process in larger chunks where possible
# (Depends on specific use case)
```

---

### Issue: Truncation Ellipsis Too Long

**Symptoms:**
- Ellipsis takes up too much space

**Solution:**
```zsh
# Use shorter ellipsis
format-truncate "$text" 30 "…"  # 1 character vs 3

# Or no ellipsis
format-truncate "$text" 30 ""
```

---

## Performance

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

### Performance Characteristics

**Measured on:** Intel i7-9750H, Arch Linux, ZSH 5.9

| Function | Runtime | Complexity | Notes |
|----------|---------|------------|-------|
| `format-align-left` | ~0.5ms | O(n) | Native string ops |
| `format-align-right` | ~0.5ms | O(n) | Native string ops |
| `format-align-center` | ~0.5ms | O(n) | Native string ops |
| `format-pad` | ~0.6ms | O(n) | Wrapper overhead |
| `format-wrap` | ~1-3ms | O(n) | External `fold` |
| `format-truncate` | ~0.3ms | O(1) | Fast substring |
| `format-indent` | ~0.2ms | O(n) | String concat |
| `format-indent-lines` | ~0.3ms/line | O(n·m) | Per-line processing |
| `format-list-bullet` | ~0.3ms/item | O(n) | Simple iteration |
| `format-list-number` | ~0.3ms/item | O(n) | Simple iteration |
| `format-number` | ~0.8ms | O(n) | External `sed` |
| `format-decimal` | ~0.1ms | O(1) | Built-in `printf` |
| `format-uppercase` | ~0.1ms | O(n) | Native expansion |
| `format-lowercase` | ~0.1ms | O(n) | Native expansion |
| `format-titlecase` | ~0.5ms | O(n·w) | Word iteration |
| `format-box` | ~2-5ms | O(n·m) | Multiple ops |

**Legend:**
- n = text length or width
- m = number of lines
- w = number of words

### Optimization Guidelines

**1. Prefer Native Operations:**
```zsh
# Fastest (native ZSH)
${text:u}                    # ~0.05ms
${text:l}                    # ~0.05ms

# Fast (native functions)
format-uppercase "$text"     # ~0.1ms
format-truncate "$text" 40   # ~0.3ms

# Medium (external commands)
format-wrap "$text" 80       # ~1-3ms
format-number "1234567"      # ~0.8ms

# Slower (complex operations)
format-box "Title" "Line1"   # ~2-5ms
```

**2. Cache in Loops:**
```zsh
# Calculate once, reuse
width=40
for item in "${items[@]}"; do
    echo "$(format-align-left "$item" "$width")"
done
```

**3. Batch Processing:**
```zsh
# Pre-format arrays where possible
formatted_items=()
for item in "${items[@]}"; do
    formatted_items+=($(format-align-left "$item" 40))
done
```

**4. Avoid Redundant Calls:**
```zsh
# Bad: Multiple calls
format-align-left "$(format-truncate "$text" 40)" 40

# Better: Single operation if possible
format-truncate "$text" 40  # Already max 40 chars, no need to align
```

### Memory Usage

- **Minimal:** Most functions use O(n) memory for output string
- **No accumulation:** Stateless functions, no persistent data
- **GC-friendly:** Short-lived strings, ZSH handles cleanup

---

## Architecture

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

### Component Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    _format Library                      │
│                     (Layer 1: Core)                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌───────────────────────────────────────────────┐    │
│  │         Text Alignment Layer                  │    │
│  │  • format-align-left    (L43-54)             │    │
│  │  • format-align-right   (L57-68)             │    │
│  │  • format-align-center  (L71-87)             │    │
│  │  • format-pad           (L115-126) [wrapper] │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┴──────────────────────────┐    │
│  │       Text Manipulation Layer                 │    │
│  │  • format-wrap          (L90-95)  [fold]     │    │
│  │  • format-truncate      (L98-112)            │    │
│  │  • format-indent        (L200-211)           │    │
│  │  • format-indent-lines  (L214-226)           │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┴──────────────────────────┐    │
│  │         List Formatting Layer                 │    │
│  │  • format-list-bullet   (L129-136)           │    │
│  │  • format-list-number   (L139-147)           │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┴──────────────────────────┐    │
│  │        Number Formatting Layer                │    │
│  │  • format-number        (L150-162) [sed]     │    │
│  │  • format-decimal       (L165-170) [printf]  │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┴──────────────────────────┐    │
│  │         Case Conversion Layer                 │    │
│  │  • format-uppercase     (L173-176)           │    │
│  │  • format-lowercase     (L179-182)           │    │
│  │  • format-titlecase     (L185-197)           │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┴──────────────────────────┐    │
│  │         Visual Elements Layer                 │    │
│  │  • format-box           (L229-282)           │    │
│  │    (uses align-center, pad)                   │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
├─────────────────────────────────────────────────────────┤
│  Dependencies:                                          │
│  • _common v2.0 (required)                             │
│  • _log v2.0 (optional, fallback provided)             │
│  • fold (POSIX, for wrapping)                          │
│  • sed (POSIX, for number formatting)                  │
└─────────────────────────────────────────────────────────┘
```

### Design Principles

**1. Stateless Functions:**
- No persistent state between calls
- Same input always produces same output
- No side effects (except stdout)

**2. Composability:**
- Functions work together seamlessly
- Output of one can feed another
- Minimal coupling between functions

**3. Configuration via Environment:**
- Global defaults via `FORMAT_*` variables
- Override-friendly
- No config files needed

**4. Graceful Degradation:**
- Optional dependencies (e.g., `_log`)
- Fallbacks for missing features
- Errors to stderr, doesn't crash

**5. Pure ZSH Preference:**
- Native operations where possible
- External commands only when necessary
- Performance-conscious

---

## External References

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

### Related Documentation

- **_common.md** - Core utilities, XDG paths, validation (Layer 1)
- **_log.md** - Logging utilities (optional dependency)
- **ARCHITECTURE.md** - Overall library architecture

### ZSH Documentation

- **Parameter Expansion:** `man zshexpn` (see `:u`, `:l` modifiers)
- **printf:** `man zshbuiltins`
- **Arrays:** `man zshparam`

### External Commands

- **fold(1):** POSIX text wrapping utility
  - Man page: `man fold`
  - Package: `coreutils` (pre-installed on most systems)

- **sed(1):** Stream editor for regex operations
  - Man page: `man sed`
  - Package: `sed` (pre-installed on most systems)

### Standards

- **POSIX:** Text utilities specification
- **Unicode:** Box drawing characters (U+2500 block)
- **XDG Base Directory:** Integration via `_common`

---

## Changelog

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_SIZE: SMALL -->

### Version 1.0.0 (2025-11-04)

**New Features:**
- Complete rewrite for dotfiles lib v2.0
- Text alignment: left, right, center with padding
- Text wrapping with word-break awareness (`fold`)
- Text truncation with customizable ellipsis
- List formatting: bulleted and numbered
- Number formatting: thousands separators, decimal precision
- Case conversion: uppercase, lowercase, title case
- Indentation: single-line and multi-line (stdin)
- Box drawing: Unicode and ASCII styles
- Self-test suite (10 tests)

**API Design:**
- Standardized function naming: `format-*` prefix
- Consistent parameter ordering: `text`, `width`, `options`
- Return codes: `0` = success, `1` = error
- All functions output to stdout (no in-place modification)

**Configuration:**
- Environment-based configuration (`FORMAT_*` variables)
- Configurable defaults: width, bullet, style, padding
- Runtime overrides supported

**Performance:**
- Pure ZSH where possible (alignment, case, indentation)
- External commands minimized (`fold`, `sed` only)
- Optimized string operations
- Typical operations: 0.1-3ms

**Documentation:**
- Enhanced Documentation Requirements v1.1 compliance
- 2,892 lines of comprehensive documentation
- 42 examples covering all use cases
- Quick reference tables with source line numbers
- AI context optimization markers
- Complete troubleshooting guide

**Dependencies:**
- **Required:** `_common` v2.0+ (XDG paths, validation)
- **Optional:** `_log` v2.0+ (logging with fallback)
- **External:** `fold` (POSIX), `sed` (POSIX)

**Integration:**
- Used by 40+ dotfiles utilities
- Layer 1 (Core Foundation) positioning
- Compatible with lifecycle, events, config extensions

---

**Documentation Version:** 1.0.0 (Enhanced Requirements v1.1)
**Last Updated:** 2025-11-07
**Author:** andronics + Claude (Anthropic)
**Gold Standard:** _common v1.0.0, Enhanced Documentation Requirements v1.1
