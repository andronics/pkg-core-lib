# _test - Testing Framework Extension

**Version:** 1.0.0
**Layer:** Infrastructure (Layer 2)
**Dependencies:** _common v2.0 (required)

---

## Overview

The `_test` extension provides a comprehensive testing framework for ZSH scripts and extensions, featuring a clean DSL inspired by modern testing frameworks (RSpec, Jest). It offers 20+ assertion functions, colored output, coverage tracking, XDG-compliant result storage, and setup/teardown support.

**Key Features:**
- Clean describe/it DSL for organizing test suites
- 20+ assertion functions covering common scenarios
- Colored console output for readability
- Setup/teardown hooks for test isolation
- XDG-compliant test result storage
- Coverage tracking for monitored code
- Multiple output modes (colored, plain, JSON)
- Self-contained test runner with summary reports
- Zero external dependencies beyond _common

This framework powers the self-test capabilities across the entire extensions library.

---

## Use Cases

- **Extension Testing:** Test library extensions with comprehensive assertions
- **Script Validation:** Verify shell script behavior and logic
- **Regression Testing:** Ensure changes don't break existing functionality
- **TDD Workflow:** Write tests first, then implement features
- **CI/CD Integration:** Run automated tests in pipelines (JSON output)
- **Documentation Examples:** Verify example code actually works
- **Coverage Analysis:** Track which code paths are tested

---

## Installation

Load the extension in your test file:

```zsh
# Basic loading
source "$(which _test)"

# With error handling
if ! source "$(which _test)" 2>/dev/null; then
    echo "Error: _test extension not found" >&2
    exit 1
fi
```

**Dependencies:**
- **_common v2.0** - Required for validation and path management
- Colors from _common for output formatting

---

## Quick Start

### Basic Test Suite

```zsh
#!/usr/bin/env zsh
source "$(which _test)"

# Define test suite
test-describe "Math Operations" {
    test-it "should add numbers correctly" {
        local result=$((2 + 2))
        test-assert-equals "$result" "4" "2 + 2 should equal 4"
    }

    test-it "should multiply numbers correctly" {
        local result=$((3 * 4))
        test-assert-equals "$result" "12" "3 * 4 should equal 12"
    }
}

# Show summary
test-summary
```

### Test File Structure

```zsh
#!/usr/bin/env zsh
source "$(which _test)"

# Setup function runs before each test
test-setup() {
    export TEST_DIR=$(mktemp -d)
}

# Teardown function runs after each test
test-teardown() {
    rm -rf "$TEST_DIR"
}

# Test suite
test-describe "File Operations" {
    test-it "should create files" {
        touch "$TEST_DIR/test.txt"
        test-assert-file-exists "$TEST_DIR/test.txt"
    }

    test-it "should write content" {
        echo "hello" > "$TEST_DIR/test.txt"
        test-assert-file-contains "$TEST_DIR/test.txt" "hello"
    }
}

test-summary
```

### Running Tests

```zsh
# Run single test file
zsh test_myfeature.zsh

# Run all tests in directory
test-run-all tests/unit

# Run with JSON output (for CI)
TEST_OUTPUT_MODE=json zsh test_myfeature.zsh
```

---

## Architecture

### Test Lifecycle

1. **Definition Phase:**
   - Define test suites with `test-describe`
   - Define individual tests with `test-it`
   - Set up setup/teardown hooks

2. **Execution Phase:**
   - Setup function runs (if defined)
   - Test block executes
   - Assertions record pass/fail
   - Teardown function runs (if defined)

3. **Reporting Phase:**
   - Counters track totals (passed, failed, skipped)
   - Summary displays results
   - Results optionally saved to XDG state directory

### Internal State

```zsh
_TEST_TOTAL=0          # Total assertions run
_TEST_PASSED=0         # Passed assertions
_TEST_FAILED=0         # Failed assertions
_TEST_SKIPPED=0        # Skipped tests

_TEST_CURRENT_DESCRIBE=""  # Current suite name
_TEST_CURRENT_IT=""        # Current test name

_TEST_SETUP_FUNC=""        # Setup function name
_TEST_TEARDOWN_FUNC=""     # Teardown function name

_TEST_COVERAGE=()          # Coverage tracking array
```

---

## Configuration

### Environment Variables

```zsh
# Output mode
TEST_OUTPUT_MODE="colored"  # colored, plain, json

# Verbosity
TEST_VERBOSE="false"        # Enable verbose output

# Coverage tracking
TEST_TRACK_COVERAGE="true"  # Enable coverage tracking

# Results directory (auto-detected from XDG)
TEST_RESULTS_DIR=""         # Defaults to XDG_STATE_HOME/lib/test-results
```

### Configuration Example

```zsh
# JSON output for CI
export TEST_OUTPUT_MODE=json
export TEST_VERBOSE=false

# Run tests
zsh test_suite.zsh
```

---

## API Reference

### Test DSL

#### `test-describe <description> <block>`

Begin a test suite description.

**Parameters:**
- `description` (string) - Suite name/description
- `block` (code) - Code block containing test-it calls

**Example:**
```zsh
test-describe "User Management" {
    test-it "should create users" { ... }
    test-it "should delete users" { ... }
}
```

---

#### `test-it <description> <block>`

Define a single test case.

**Parameters:**
- `description` (string) - Test description
- `block` (code) - Code block containing assertions

**Returns:** Exit code 0 if test passes, 1 if fails

**Example:**
```zsh
test-it "should parse valid JSON" {
    local result=$(echo '{"key":"value"}' | jq -r .key)
    test-assert-equals "$result" "value"
}
```

---

#### `test-setup <function_name>`

Define setup function that runs before each test.

**Parameters:**
- `function_name` (string) - Name of setup function

**Example:**
```zsh
setup_env() {
    export TEST_VAR="value"
}

test-setup setup_env
```

---

#### `test-teardown <function_name>`

Define teardown function that runs after each test.

**Parameters:**
- `function_name` (string) - Name of teardown function

**Example:**
```zsh
cleanup_env() {
    unset TEST_VAR
}

test-teardown cleanup_env
```

---

#### `test-skip <reason>`

Skip current test with reason.

**Parameters:**
- `reason` (string, optional) - Why test is skipped

**Example:**
```zsh
test-it "should work on macOS" {
    if [[ "$(uname)" != "Darwin" ]]; then
        test-skip "macOS only test"
        return
    fi
    # test code...
}
```

---

### Equality Assertions

#### `test-assert-equals <actual> <expected> [message]`

Assert two values are equal.

**Parameters:**
- `actual` (string) - Actual value
- `expected` (string) - Expected value
- `message` (string, optional) - Custom assertion message

**Returns:** 0 if equal, 1 if not equal

**Example:**
```zsh
result=$(echo "hello" | tr '[:lower:]' '[:upper:]')
test-assert-equals "$result" "HELLO" "should uppercase string"
```

---

#### `test-assert-not-equals <actual> <not_expected> [message]`

Assert two values are not equal.

**Parameters:**
- `actual` (string) - Actual value
- `not_expected` (string) - Value that should not match
- `message` (string, optional) - Custom assertion message

**Returns:** 0 if not equal, 1 if equal

**Example:**
```zsh
user_id=$(generate_uuid)
test-assert-not-equals "$user_id" "" "UUID should not be empty"
```

---

### Boolean Assertions

#### `test-assert-true <message> <command...>`

Assert command returns true (exit code 0).

**Parameters:**
- `message` (string) - Assertion message
- `command...` (command) - Command to execute

**Returns:** 0 if command succeeds, 1 if fails

**Example:**
```zsh
test-assert-true "config file should exist" test -f config.json
test-assert-true "should be a directory" [[ -d /tmp ]]
```

---

#### `test-assert-false <message> <command...>`

Assert command returns false (non-zero exit code).

**Parameters:**
- `message` (string) - Assertion message
- `command...` (command) - Command to execute

**Returns:** 0 if command fails, 1 if succeeds

**Example:**
```zsh
test-assert-false "invalid config should fail" validate_config bad.json
test-assert-false "should not be a file" [[ -f /nonexistent ]]
```

---

### String Assertions

#### `test-assert-contains <haystack> <needle> [message]`

Assert string contains substring.

**Parameters:**
- `haystack` (string) - String to search in
- `needle` (string) - Substring to find
- `message` (string, optional) - Custom assertion message

**Example:**
```zsh
output=$(cat logfile.txt)
test-assert-contains "$output" "ERROR" "log should contain error"
```

---

#### `test-assert-not-contains <haystack> <needle> [message]`

Assert string does not contain substring.

**Example:**
```zsh
output=$(cat cleaned.txt)
test-assert-not-contains "$output" "password" "cleaned output should not contain passwords"
```

---

#### `test-assert-matches <string> <regex> [message]`

Assert string matches regex pattern.

**Parameters:**
- `string` (string) - String to test
- `regex` (regex) - Regular expression pattern
- `message` (string, optional) - Custom assertion message

**Example:**
```zsh
email="user@example.com"
test-assert-matches "$email" '^[^@]+@[^@]+\.[^@]+$' "should be valid email"
```

---

#### `test-assert-not-matches <string> <regex> [message]`

Assert string does not match regex pattern.

**Example:**
```zsh
username="valid_user"
test-assert-not-matches "$username" '[^a-zA-Z0-9_]' "username should contain only valid chars"
```

---

#### `test-assert-empty <value> [message]`

Assert value is empty.

**Example:**
```zsh
result=$(get_optional_field)
test-assert-empty "$result" "optional field should be empty"
```

---

#### `test-assert-not-empty <value> [message]`

Assert value is not empty.

**Example:**
```zsh
token=$(generate_token)
test-assert-not-empty "$token" "token should be generated"
```

---

### Numeric Assertions

#### `test-assert-greater-than <value> <threshold> [message]`

Assert value is greater than threshold.

**Parameters:**
- `value` (number) - Value to test
- `threshold` (number) - Minimum value (exclusive)
- `message` (string, optional) - Custom assertion message

**Example:**
```zsh
count=$(count_files)
test-assert-greater-than "$count" "0" "should have at least one file"
```

---

#### `test-assert-less-than <value> <threshold> [message]`

Assert value is less than threshold.

**Example:**
```zsh
response_time=$(measure_response_time)
test-assert-less-than "$response_time" "1000" "response should be under 1 second"
```

---

### Exit Code Assertions

#### `test-assert-exit-code <expected_code> <command...>`

Assert command exits with specific code.

**Parameters:**
- `expected_code` (number) - Expected exit code
- `command...` (command) - Command to execute

**Example:**
```zsh
test-assert-exit-code 0 validate_config valid.json
test-assert-exit-code 1 validate_config invalid.json
test-assert-exit-code 127 nonexistent_command
```

---

### File System Assertions

#### `test-assert-file-exists <filepath> [message]`

Assert file exists.

**Example:**
```zsh
test-assert-file-exists "/etc/hosts" "hosts file should exist"
```

---

#### `test-assert-file-not-exists <filepath> [message]`

Assert file does not exist.

**Example:**
```zsh
test-assert-file-not-exists "/tmp/temp123.txt" "temp file should be deleted"
```

---

#### `test-assert-directory-exists <dirpath> [message]`

Assert directory exists.

**Example:**
```zsh
test-assert-directory-exists "$HOME/.config" "config directory should exist"
```

---

#### `test-assert-file-contains <filepath> <expected> [message]`

Assert file contains specific string.

**Parameters:**
- `filepath` (path) - Path to file
- `expected` (string) - String that should be in file
- `message` (string, optional) - Custom assertion message

**Example:**
```zsh
test-assert-file-contains "/etc/hosts" "localhost" "hosts should contain localhost entry"
```

---

### Command Assertions

#### `test-assert-command-exists <command> [message]`

Assert command is available in PATH.

**Example:**
```zsh
test-assert-command-exists "jq" "jq should be installed"
test-assert-command-exists "git" "git should be available"
```

---

### Output Assertions

#### `test-assert-output-contains <expected> <command...>`

Assert command output (stdout + stderr) contains string.

**Parameters:**
- `expected` (string) - String expected in output
- `command...` (command) - Command to execute

**Example:**
```zsh
test-assert-output-contains "Usage:" myscript --help
test-assert-output-contains "error" myscript invalid-arg
```

---

#### `test-assert-stderr-contains <expected> <command...>`

Assert command stderr contains string.

**Example:**
```zsh
test-assert-stderr-contains "ERROR" myscript --invalid-option
```

---

### Test Runner Functions

#### `test-run`

Run tests from current file. Automatically called when test file is executed.

**Example:**
```zsh
#!/usr/bin/env zsh
source "$(which _test)"

# Define tests...

test-run
test-summary
```

---

#### `test-run-file <filepath>`

Run tests from specific file.

**Parameters:**
- `filepath` (path) - Path to test file

**Example:**
```zsh
test-run-file "tests/unit/test_parser.zsh"
```

---

#### `test-run-all [directory]`

Run all test files in directory.

**Parameters:**
- `directory` (path, optional) - Directory containing tests (default: tests/unit)

**Example:**
```zsh
test-run-all tests/unit
test-run-all tests/integration
```

---

### Reporting Functions

#### `test-summary`

Display test results summary and save results to disk.

**Returns:** 0 if all tests passed, 1 if any failed

**Example:**
```zsh
test-summary
```

**Output:**
```
=========================================
All tests passed!
Total:   15
Passed:  15
Failed:  0
=========================================
```

---

#### `test-stats`

Display test statistics without exiting.

**Example:**
```zsh
test-stats
```

**Output:**
```
Test Statistics:
  Total:   15
  Passed:  15
  Failed:  0
  Skipped: 0
  Pass Rate: 100%
```

---

#### `test-save-results`

Save test results to XDG state directory.

**Storage Location:** `$XDG_STATE_HOME/lib/test-results/results-TIMESTAMP.json`

**Example:**
```zsh
test-save-results
```

**Result File Format:**
```json
{
  "timestamp": "2025-01-04T15:30:45",
  "total": 15,
  "passed": 15,
  "failed": 0,
  "skipped": 0,
  "pass_rate": 100
}
```

---

#### `test-report`

Show test coverage report (if coverage tracking enabled).

**Example:**
```zsh
export TEST_TRACK_COVERAGE=true
# Run tests...
test-report
```

---

### Utility Functions

#### `test-reset`

Reset test counters (useful for self-tests).

**Example:**
```zsh
test-reset
_TEST_TOTAL=0
_TEST_PASSED=0
_TEST_FAILED=0
```

---

#### `test-version`

Display _test extension version.

**Example:**
```zsh
test-version
# Output: lib/_test version 1.0.0
```

---

## Complete Examples

### Example 1: Testing String Functions

```zsh
#!/usr/bin/env zsh
source "$(which _test)"

# Function to test
trim_string() {
    local str="$1"
    # Remove leading/trailing whitespace
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    echo "$str"
}

# Test suite
test-describe "String Trimming" {
    test-it "should remove leading whitespace" {
        result=$(trim_string "  hello")
        test-assert-equals "$result" "hello"
    }

    test-it "should remove trailing whitespace" {
        result=$(trim_string "hello  ")
        test-assert-equals "$result" "hello"
    }

    test-it "should remove both" {
        result=$(trim_string "  hello  ")
        test-assert-equals "$result" "hello"
    }

    test-it "should handle empty string" {
        result=$(trim_string "")
        test-assert-empty "$result"
    }
}

test-summary
exit $?
```

### Example 2: Testing File Operations

```zsh
#!/usr/bin/env zsh
source "$(which _test)"

# Setup: create temp directory for each test
setup_temp_dir() {
    TEST_DIR=$(mktemp -d)
}

# Teardown: cleanup temp directory after each test
cleanup_temp_dir() {
    [[ -d "$TEST_DIR" ]] && rm -rf "$TEST_DIR"
}

test-setup setup_temp_dir
test-teardown cleanup_temp_dir

# Function to test
create_config() {
    local file="$1"
    cat > "$file" <<EOF
{
  "version": "1.0",
  "enabled": true
}
EOF
}

# Test suite
test-describe "Config File Creation" {
    test-it "should create config file" {
        create_config "$TEST_DIR/config.json"
        test-assert-file-exists "$TEST_DIR/config.json"
    }

    test-it "should contain version field" {
        create_config "$TEST_DIR/config.json"
        test-assert-file-contains "$TEST_DIR/config.json" '"version"'
    }

    test-it "should contain enabled field" {
        create_config "$TEST_DIR/config.json"
        test-assert-file-contains "$TEST_DIR/config.json" '"enabled": true'
    }

    test-it "should be valid JSON" {
        create_config "$TEST_DIR/config.json"
        test-assert-exit-code 0 jq empty "$TEST_DIR/config.json"
    }
}

test-summary
exit $?
```

### Example 3: Testing with Conditional Skipping

```zsh
#!/usr/bin/env zsh
source "$(which _test)"

test-describe "Platform-Specific Features" {
    test-it "should work on Linux" {
        if [[ "$(uname)" != "Linux" ]]; then
            test-skip "Linux-only test"
            return
        fi

        test-assert-command-exists "systemctl"
    }

    test-it "should work on macOS" {
        if [[ "$(uname)" != "Darwin" ]]; then
            test-skip "macOS-only test"
            return
        fi

        test-assert-command-exists "launchctl"
    }

    test-it "should work everywhere" {
        test-assert-command-exists "ls"
    }
}

test-summary
exit $?
```

### Example 4: Integration Testing

```zsh
#!/usr/bin/env zsh
source "$(which _test)"
source "$(which _common)"

test-describe "XDG Directory Functions" {
    test-it "should return config home" {
        result=$(common-xdg-config-home)
        test-assert-not-empty "$result"
        test-assert-contains "$result" ".config"
    }

    test-it "should return data home" {
        result=$(common-xdg-data-home)
        test-assert-not-empty "$result"
        test-assert-contains "$result" ".local/share"
    }

    test-it "should ensure directories exist" {
        common-lib-ensure-dirs
        test-assert-directory-exists "$(common-lib-data-dir)"
        test-assert-directory-exists "$(common-lib-cache-dir)"
    }
}

test-summary
exit $?
```

---

## Troubleshooting

### Problem: Tests pass locally but fail in CI

**Symptoms:**
- Tests work on your machine
- CI pipeline fails with assertion errors

**Solution:**
```zsh
# Use JSON output in CI for debugging
export TEST_OUTPUT_MODE=json
export TEST_VERBOSE=true

# Check for environment differences
test-it "should handle CI environment" {
    if [[ -n "${CI:-}" ]]; then
        # CI-specific behavior
        test-assert-true "CI mode" true
    fi
}
```

---

### Problem: Setup/Teardown not executing

**Symptoms:**
- Cleanup not happening
- State leaking between tests

**Solution:**
```zsh
# Ensure setup/teardown are called AFTER defining functions
setup_func() {
    echo "Setting up"
}

teardown_func() {
    echo "Cleaning up"
}

# Call AFTER function definitions
test-setup setup_func
test-teardown teardown_func

# Then define tests
test-describe "Suite" {
    test-it "test" { ... }
}
```

---

### Problem: Assertion message not showing

**Symptoms:**
- Failed assertions don't show details
- Hard to debug failures

**Solution:**
```zsh
# Always provide descriptive messages
test-assert-equals "$actual" "$expected" "User ID should match database value"

# For complex assertions, add context
test-it "should process batch" {
    result=$(process_batch $items)
    test-assert-not-empty "$result" "Batch processing should return results for ${#items} items"
}
```

---

### Problem: Temp files not cleaned up

**Symptoms:**
- /tmp filling up
- Files persist after tests

**Solution:**
```zsh
# Use _lifecycle for automatic cleanup
source "$(which _lifecycle)"
lifecycle-trap-install

setup_temp() {
    TEMP_FILE=$(mktemp)
    lifecycle-track-temp-file "$TEMP_FILE"
}

test-setup setup_temp

# Or manual cleanup in teardown
teardown_temp() {
    [[ -f "$TEMP_FILE" ]] && rm -f "$TEMP_FILE"
}

test-teardown teardown_temp
```

---

## Performance Considerations

### Assertion Overhead

Each assertion has minimal overhead (~1ms), but large test suites can accumulate:

```zsh
# Bad: Redundant assertions
test-it "should process items" {
    for item in "${items[@]}"; do
        result=$(process "$item")
        test-assert-not-empty "$result"
        test-assert-not-equals "$result" "error"
        test-assert-contains "$result" "success"
    done
}

# Good: Single comprehensive assertion
test-it "should process items" {
    results=$(process_all "${items[@]}")
    test-assert-true "all items processed" [[ $(echo "$results" | wc -l) -eq ${#items[@]} ]]
}
```

### File System Operations

File system assertions are slower than in-memory checks:

```zsh
# Optimize by batching file operations
test-it "should create multiple files" {
    create_all_files "$TEST_DIR"

    # Single existence check
    test-assert-true "all files created" [[ $(ls "$TEST_DIR" | wc -l) -eq 10 ]]
}
```

---

## Security Notes

### Safe Test Isolation

```zsh
# Always use unique temp directories
setup_isolated_env() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR" || return 1
}

teardown_isolated_env() {
    cd / # Exit before removing
    [[ -d "$TEST_DIR" ]] && rm -rf "$TEST_DIR"
}
```

### Input Sanitization

```zsh
# Sanitize test inputs
test-it "should handle user input" {
    user_input="'; rm -rf /"
    sanitized=$(sanitize_input "$user_input")

    # Verify sanitization
    test-assert-not-contains "$sanitized" "rm -rf"
}
```

---

## Integration with Other Extensions

### With _lifecycle

```zsh
source "$(which _test)"
source "$(which _lifecycle)"

lifecycle-trap-install

setup() {
    TEST_PID_FILE=$(mktemp)
    lifecycle-track-temp-file "$TEST_PID_FILE"
}

test-setup setup
```

### With _log

```zsh
source "$(which _test)"
source "$(which _log)"

# Capture log output in tests
test-it "should log errors" {
    output=$(log-error "test error" 2>&1)
    test-assert-contains "$output" "ERROR"
}
```

### With _events

```zsh
source "$(which _test)"
source "$(which _events)"

test-it "should emit events" {
    handler_called=false

    test_handler() {
        handler_called=true
    }

    events-on "test.event" "test_handler"
    events-emit "test.event"

    test-assert-true "handler should be called" [[ "$handler_called" == "true" ]]
}
```

---

## Best Practices

### 1. Test Organization

```zsh
# Group related tests
test-describe "Parser" {
    test-describe "JSON parsing" {
        test-it "should parse valid JSON" { ... }
        test-it "should reject invalid JSON" { ... }
    }

    test-describe "XML parsing" {
        test-it "should parse valid XML" { ... }
        test-it "should reject invalid XML" { ... }
    }
}
```

### 2. Descriptive Test Names

```zsh
# Bad: Vague test names
test-it "works" { ... }
test-it "test 1" { ... }

# Good: Clear, specific names
test-it "should parse ISO 8601 timestamps" { ... }
test-it "should reject timestamps with invalid timezone" { ... }
```

### 3. One Assertion Per Test (When Possible)

```zsh
# Bad: Multiple unrelated assertions
test-it "should work" {
    test-assert-equals "$a" "1"
    test-assert-equals "$b" "2"
    test-assert-equals "$c" "3"
}

# Good: Focused tests
test-it "should set variable a to 1" {
    test-assert-equals "$a" "1"
}

test-it "should set variable b to 2" {
    test-assert-equals "$b" "2"
}
```

### 4. Setup/Teardown for Shared State

```zsh
# Use setup/teardown for repeated initialization
setup_database() {
    DB_FILE=$(mktemp)
    sqlite3 "$DB_FILE" "CREATE TABLE users (id INTEGER, name TEXT);"
}

teardown_database() {
    [[ -f "$DB_FILE" ]] && rm -f "$DB_FILE"
}

test-setup setup_database
test-teardown teardown_database
```

### 5. Test Edge Cases

```zsh
test-describe "String Splitting" {
    test-it "should handle normal input" {
        result=$(split "a,b,c")
        test-assert-equals "${#result[@]}" "3"
    }

    test-it "should handle empty string" {
        result=$(split "")
        test-assert-empty "$result"
    }

    test-it "should handle no delimiters" {
        result=$(split "abc")
        test-assert-equals "$result" "abc"
    }

    test-it "should handle trailing delimiter" {
        result=$(split "a,b,c,")
        test-assert-equals "${#result[@]}" "4"
    }
}
```

---

## Version History

### 1.0.0 (2025-01-04)
- Complete rewrite with modern DSL
- 20+ assertion functions
- Setup/teardown support
- XDG-compliant storage
- JSON output mode
- Coverage tracking
- Colored output

---

## See Also

- **_common** - Foundation utilities used by _test
- **_lifecycle** - Automatic cleanup for test resources
- **_log** - Logging integration for test output
- **_events** - Event system testing support

---

## License

Part of the dotfiles library v2.0 - Production-grade shell extensions
