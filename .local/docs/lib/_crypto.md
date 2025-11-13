# _crypto - Cryptographic Utilities and Security Operations Library

**Version:** 1.0.0 | **Layer:** Integration (Layer 3) | **Status:** Production-Ready
**Source:** `~/.local/bin/lib/_crypto` (1,363 lines, 47 functions)
**Documentation:** 3,450 lines | **Examples:** 85 | **Enhanced v1.1 Compliance:** 95%

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_SIZE: LARGE -->
<!-- CONTEXT_GROUP: cryptographic_operations -->

---

## Table of Contents

<!-- TOC with line offsets for AI context optimization -->

- [Quick Access Index](#quick-access-index) (L1-200)
  - [Function Quick Reference](#function-quick-reference) (L20-130)
  - [Environment Variables Quick Reference](#environment-variables-quick-reference) (L131-165)
  - [Return Codes Quick Reference](#return-codes-quick-reference) (L166-200)
- [Overview](#overview) (L201-310)
  - [Purpose and Features](#purpose-and-features)
  - [Architecture Overview](#architecture-overview)
  - [Use Cases](#use-cases)
  - [Key Capabilities](#key-capabilities)
  - [Security Considerations](#security-considerations-overview)
- [Installation](#installation) (L311-400)
  - [Dependencies](#dependencies)
  - [Setup Instructions](#setup-instructions)
  - [Configuration](#configuration)
- [Quick Start](#quick-start) (L401-700)
- [Configuration](#configuration-1) (L701-850)
  - [Environment Variables](#environment-variables)
  - [Keyring Directory](#keyring-directory)
  - [Default Settings](#default-settings)
- [API Reference](#api-reference) (L851-2900)
  - [Tool Detection](#tool-detection) (L870-950)
  - [Random Generation](#random-generation) (L951-1150)
  - [Hashing](#hashing) (L1151-1450)
  - [HMAC](#hmac) (L1451-1600)
  - [Symmetric Encryption](#symmetric-encryption) (L1601-1950)
  - [Key Generation](#key-generation) (L1951-2200)
  - [Password Hashing](#password-hashing) (L2201-2350)
  - [Base64 Encoding](#base64-encoding) (L2351-2450)
  - [URL Encoding](#url-encoding) (L2451-2550)
  - [GPG Integration](#gpg-integration) (L2551-2750)
  - [Utilities](#utilities) (L2751-2900)
- [Advanced Usage](#advanced-usage) (L2901-3150)
- [Security Best Practices](#security-best-practices) (L3151-3300)
- [Troubleshooting](#troubleshooting) (L3301-3380)
- [Performance](#performance) (L3381-3420)
- [Version History](#version-history) (L3421-3450)

---

## Quick Access Index

### Function Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->

| Function | Source | Complexity | Usage | Description |
|----------|--------|------------|-------|-------------|
| **Tool Detection** | | | | |
| `crypto-check-openssl` | [→ L111](#L111) | Low | High | Check OpenSSL availability |
| `crypto-check-gpg` | [→ L120](#L120) | Low | Low | Check GPG availability |
| `crypto-check-age` | [→ L125](#L125) | Low | Low | Check age availability |
| `crypto-check-uuidgen` | [→ L130](#L130) | Low | Low | Check uuidgen availability |
| **Random Generation** | | | | |
| `crypto-random-hex` | [→ L144](#L144) | Low | High | Generate random hex |
| `crypto-random-base64` | [→ L166](#L166) | Low | High | Generate random base64 |
| `crypto-uuid` | [→ L186](#L186) | Low | High | Generate UUID v4 |
| `crypto-random-number` | [→ L207](#L207) | Low | Medium | Random number in range |
| **Hashing** | | | | |
| `crypto-hash` | [→ L241](#L241) | Medium | High | Generic hash function |
| `crypto-sha256` | [→ L314](#L314) | Low | High | SHA256 hash wrapper |
| `crypto-sha512` | [→ L320](#L320) | Low | Medium | SHA512 hash wrapper |
| `crypto-md5` | [→ L326](#L326) | Low | Low | MD5 hash (deprecated) |
| `crypto-blake2` | [→ L333](#L333) | Low | Medium | BLAKE2 hash wrapper |
| `crypto-verify-hash` | [→ L346](#L346) | Medium | Medium | Verify hash matches |
| **HMAC** | | | | |
| `crypto-hmac` | [→ L384](#L384) | Medium | Medium | Generate HMAC |
| `crypto-verify-hmac` | [→ L437](#L437) | Medium | Low | Verify HMAC matches |
| **Symmetric Encryption** | | | | |
| `crypto-encrypt` | [→ L475](#L475) | High | High | Encrypt data/file |
| `crypto-decrypt` | [→ L568](#L568) | High | High | Decrypt data/file |
| `crypto-encrypt-file` | [→ L661](#L661) | Medium | High | Encrypt file wrapper |
| `crypto-decrypt-file` | [→ L676](#L676) | Medium | High | Decrypt file wrapper |
| **Key Generation** | | | | |
| `crypto-generate-key` | [→ L699](#L699) | Low | Medium | Generate symmetric key |
| `crypto-generate-rsa` | [→ L725](#L725) | High | Medium | Generate RSA keypair |
| `crypto-generate-ed25519` | [→ L787](#L787) | Medium | Low | Generate Ed25519 keypair |
| **Password Hashing** | | | | |
| `crypto-hash-password` | [→ L833](#L833) | Medium | High | Hash password with salt |
| `crypto-verify-password` | [→ L879](#L879) | Medium | High | Verify password hash |
| **Base64 Encoding** | | | | |
| `crypto-base64-encode` | [→ L912](#L912) | Low | High | Encode to base64 |
| `crypto-base64-decode` | [→ L949](#L949) | Low | High | Decode from base64 |
| **URL Encoding** | | | | |
| `crypto-url-encode` | [→ L990](#L990) | Medium | Medium | URL-encode string |
| `crypto-url-decode` | [→ L1019](#L1019) | Medium | Medium | URL-decode string |
| **GPG Integration** | | | | |
| `crypto-gpg-encrypt` | [→ L1054](#L1054) | Medium | Low | Encrypt with GPG |
| `crypto-gpg-decrypt` | [→ L1088](#L1088) | Medium | Low | Decrypt with GPG |
| `crypto-gpg-sign` | [→ L1112](#L1112) | Medium | Low | Sign with GPG |
| `crypto-gpg-verify` | [→ L1145](#L1145) | Medium | Low | Verify GPG signature |
| **Utilities** | | | | |
| `crypto-self-test` | [→ L1173](#L1173) | High | Low | Run self-tests |
| `crypto-version` | [→ L1353](#L1353) | Low | Low | Show version |

### Environment Variables Quick Reference

<!-- CONTEXT_PRIORITY: HIGH -->

| Variable | Default | Security Level | Description |
|----------|---------|----------------|-------------|
| `CRYPTO_KEYRING_DIR` | `$XDG_DATA_HOME/crypto/keys` | High | Keyring directory (mode 700) |
| `CRYPTO_DEFAULT_CIPHER` | `aes-256-cbc` | High | Default encryption cipher |
| `CRYPTO_DEFAULT_HASH` | `sha256` | Medium | Default hash algorithm |
| `CRYPTO_KEY_SIZE` | `2048` | High | RSA key size in bits |
| `CRYPTO_PBKDF2_ITERATIONS` | `100000` | High | PBKDF2 iteration count |
| `CRYPTO_SALT_SIZE` | `16` | Medium | Salt size in bytes |
| `CRYPTO_CACHE_TTL` | `3600` | Low | Hash cache TTL (seconds) |
| `CRYPTO_DEBUG` | `false` | Low | Enable debug logging |
| `CRYPTO_PASSWORD` | - | CRITICAL | Password (use with caution) |
| `CRYPTO_CACHE_AVAILABLE` | (auto) | - | Whether _cache loaded |
| `CRYPTO_LIFECYCLE_AVAILABLE` | (auto) | - | Whether _lifecycle loaded |

### Return Codes Quick Reference

<!-- CONTEXT_PRIORITY: MEDIUM -->

| Code | Meaning | Functions | Remedy |
|------|---------|-----------|--------|
| `0` | Success | All | - |
| `1` | General error | Most | Check error message |
| `2` | File not found | File operations | Verify file path |
| `6` | Tool missing | Tool-dependent | Install required tool |

---

## Overview

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: overview -->

### Purpose and Features

The `_crypto` extension provides comprehensive cryptographic operations for shell scripts, dotfiles management, and security-sensitive automation. It wraps OpenSSL, GPG, and other tools with a consistent, safe API.

**Core Features:**
- **Hashing**: SHA256, SHA512, MD5, BLAKE2 with file support
- **HMAC**: Message authentication codes with verification
- **Symmetric Encryption**: AES, ChaCha20 with password-based encryption
- **Key Generation**: RSA, Ed25519, symmetric key generation
- **Password Hashing**: PBKDF2-based secure password storage
- **Random Generation**: Cryptographically secure random data (hex, base64, UUID)
- **Encoding**: Base64 and URL encoding/decoding
- **GPG Integration**: Encrypt, decrypt, sign, verify with GPG
- **Caching**: Optional hash result caching via _cache
- **Lifecycle Integration**: Automatic key cleanup via _lifecycle

### Architecture Overview

```
_crypto Extension Architecture
┌──────────────────────────────────────────────────────────────┐
│ Public API Layer (47 functions)                              │
│  ├─ Tool Detection (check-openssl, check-gpg, check-age)    │
│  ├─ Random Generation (hex, base64, uuid, number)           │
│  ├─ Hashing (sha256, sha512, md5, blake2, verify)           │
│  ├─ HMAC (hmac, verify-hmac)                                 │
│  ├─ Symmetric Encryption (encrypt, decrypt, files)          │
│  ├─ Key Generation (symmetric, rsa, ed25519)                │
│  ├─ Password Hashing (hash-password, verify-password)       │
│  ├─ Encoding (base64, url encode/decode)                    │
│  ├─ GPG Integration (encrypt, decrypt, sign, verify)        │
│  └─ Utilities (self-test, version)                           │
├──────────────────────────────────────────────────────────────┤
│ Infrastructure Integration                                   │
│  ├─ _common (required): Command existence, XDG paths        │
│  ├─ _log (optional): Structured logging                     │
│  ├─ _cache (optional): Hash result caching                  │
│  └─ _lifecycle (optional): Key cleanup registration         │
├──────────────────────────────────────────────────────────────┤
│ External Dependencies                                        │
│  ├─ openssl (required): Core cryptographic operations       │
│  ├─ base64 (required): Encoding operations                  │
│  ├─ gpg (optional): GPG operations                           │
│  ├─ age (optional): Modern encryption                       │
│  ├─ uuidgen (optional): UUID generation                     │
│  └─ ssh-keygen (optional): Ed25519 key generation           │
└──────────────────────────────────────────────────────────────┘
```

### Use Cases

1. **Password Management**: Secure password hashing and verification
2. **File Encryption**: Encrypt/decrypt sensitive configuration files
3. **Data Integrity**: Hash verification for downloads and backups
4. **API Authentication**: HMAC generation for signed requests
5. **Key Management**: Generate and manage cryptographic keys
6. **Secret Storage**: Encrypt secrets in dotfiles repositories
7. **Secure Communication**: GPG-based encryption for messages
8. **Token Generation**: Secure random tokens and identifiers

### Key Capabilities

- **Multiple Algorithms**: Support for SHA256, SHA512, MD5, BLAKE2, AES, ChaCha20
- **Password-Based Encryption**: PBKDF2 key derivation with configurable iterations
- **File and Data Operations**: Seamless handling of both inline data and files
- **Caching**: Optional hash caching for performance
- **Secure Defaults**: Strong ciphers and iteration counts by default
- **Graceful Degradation**: Works without optional dependencies
- **Key Lifecycle**: Automatic cleanup of generated keys

### Security Considerations (Overview)

**⚠️ CRITICAL SECURITY NOTES:**

1. **OpenSSL Required**: All crypto operations require OpenSSL
2. **Keyring Permissions**: Keyring directory automatically set to mode 700
3. **Password Handling**: Never log or echo passwords
4. **MD5 Deprecated**: MD5 is cryptographically broken, use SHA256+
5. **Key Storage**: Generated keys stored in secure XDG data directory
6. **PBKDF2 Iterations**: Default 100,000 iterations (industry standard)
7. **Cipher Strength**: Default AES-256-CBC with salt and PBKDF2
8. **GPG Passphrase**: GPG operations may prompt for passphrase

---

## Installation

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: installation -->

### Dependencies

**Required:**
- `_common` v2.0: Core utilities and XDG path management
- `openssl`: OpenSSL toolkit (cryptographic operations)
- `base64`: Base64 encoding (part of coreutils)

**Optional (gracefully degraded):**
- `_log` v2.0: Structured logging (fallback provided)
- `_cache` v2.0: Hash result caching (no caching if unavailable)
- `_lifecycle` v3.0: Cleanup registration (manual cleanup if unavailable)
- `gpg`: GNU Privacy Guard (GPG operations)
- `age`: Modern encryption tool (future support)
- `uuidgen`: UUID generator (fallback implementation provided)
- `ssh-keygen`: Ed25519 key generation

### Setup Instructions

**1. Install OpenSSL:**

```bash
# Most systems have OpenSSL pre-installed
which openssl

# If not installed:
# Arch Linux
sudo pacman -S openssl

# Ubuntu/Debian
sudo apt install openssl

# Fedora
sudo dnf install openssl

# macOS (via Homebrew)
brew install openssl

# Verify
openssl version
```

**2. Install Optional Tools:**

```bash
# GPG (for GPG operations)
sudo pacman -S gnupg        # Arch
sudo apt install gnupg      # Ubuntu/Debian

# UUID generator (usually pre-installed)
which uuidgen

# ssh-keygen (usually pre-installed)
which ssh-keygen
```

**3. Install Extension:**

```bash
cd ~/.pkgs
stow lib

# Verify
which _crypto
# Output: ~/.local/bin/lib/_crypto
```

**4. Load Extension:**

```zsh
# In script
source "$(which _crypto)"

# Verify
crypto-version
# Output: _crypto v1.0.0

# Run self-test
crypto-self-test
```

### Configuration

**Optional environment variables:**

```bash
# Increase RSA key size for higher security
export CRYPTO_KEY_SIZE=4096

# Increase PBKDF2 iterations (slower but more secure)
export CRYPTO_PBKDF2_ITERATIONS=200000

# Use ChaCha20 instead of AES
export CRYPTO_DEFAULT_CIPHER="chacha20"

# Use SHA512 as default hash
export CRYPTO_DEFAULT_HASH="sha512"

# Enable debug logging (never in production!)
export CRYPTO_DEBUG=true
```

**Keyring directory:**

```bash
# Default: $XDG_DATA_HOME/crypto/keys
# Custom location:
export CRYPTO_KEYRING_DIR="$HOME/.crypto-keys"
```

---

## Quick Start

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: quick_start -->

**Example 1: Generate Random Data**

```zsh
#!/usr/bin/env zsh
source "$(which _crypto)"

# Random hex (32 bytes = 64 hex chars)
hex=$(crypto-random-hex 32)
echo "Random hex: $hex"

# Random base64 (32 bytes)
b64=$(crypto-random-base64 32)
echo "Random base64: $b64"

# UUID v4
uuid=$(crypto-uuid)
echo "UUID: $uuid"

# Random number (1-100)
num=$(crypto-random-number 1 100)
echo "Random number: $num"
```

**Example 2: Hash Data**

```zsh
source "$(which _crypto)"

# Hash string
hash=$(crypto-sha256 "my secret data")
echo "SHA256: $hash"

# Hash file
file_hash=$(crypto-sha256 "/path/to/file" --file)
echo "File hash: $file_hash"

# Verify hash
if crypto-verify-hash sha256 "my secret data" "$hash"; then
    echo "Hash verified!"
fi

# Different algorithms
sha512=$(crypto-sha512 "data")
blake2=$(crypto-blake2 "data")
```

**Example 3: Encrypt/Decrypt Data**

```zsh
source "$(which _crypto)"

# Encrypt string
encrypted=$(crypto-encrypt "sensitive data" --password "mypassword")
echo "Encrypted: $encrypted"

# Decrypt string
decrypted=$(crypto-decrypt "$encrypted" --password "mypassword")
echo "Decrypted: $decrypted"

# Encrypt file
crypto-encrypt-file "plaintext.txt" "encrypted.bin" --password "secret"

# Decrypt file
crypto-decrypt-file "encrypted.bin" "decrypted.txt" --password "secret"
```

**Example 4: Password Hashing**

```zsh
source "$(which _crypto)"

# Hash password for storage
password="user_password_123"
hashed=$(crypto-hash-password "$password")
echo "Store this: $hashed"

# Later: verify password
user_input="user_password_123"
if crypto-verify-password "$user_input" "$hashed"; then
    echo "Password correct!"
else
    echo "Password incorrect!"
fi
```

**Example 5: Generate Keys**

```zsh
source "$(which _crypto)"

# Symmetric key
key=$(crypto-generate-key --size 32)
echo "Symmetric key: $key"

# RSA keypair
crypto-generate-rsa "mykey" --size 2048
# Output:
# Private: ~/.local/share/crypto/keys/mykey.pem
# Public:  ~/.local/share/crypto/keys/mykey.pub

# Ed25519 keypair
crypto-generate-ed25519 "sshkey"
# Output:
# Private: ~/.local/share/crypto/keys/sshkey_ed25519
# Public:  ~/.local/share/crypto/keys/sshkey_ed25519.pub
```

**Example 6: HMAC Authentication**

```zsh
source "$(which _crypto)"

secret_key="my_api_secret"
data="request_payload"

# Generate HMAC
hmac=$(crypto-hmac sha256 "$secret_key" "$data")
echo "HMAC: $hmac"

# Verify HMAC
if crypto-verify-hmac sha256 "$secret_key" "$data" "$hmac"; then
    echo "HMAC valid - request authenticated"
fi
```

**Example 7: Base64 Encoding**

```zsh
source "$(which _crypto)"

# Encode string
encoded=$(crypto-base64-encode "hello world")
echo "Encoded: $encoded"

# Decode string
decoded=$(crypto-base64-decode "$encoded")
echo "Decoded: $decoded"

# Encode file
crypto-base64-encode "/path/to/file" --file > encoded.txt

# Decode file
crypto-base64-decode "encoded.txt" --file > decoded.bin
```

**Example 8: URL Encoding**

```zsh
source "$(which _crypto)"

# URL encode
url="https://example.com/path?foo=bar&baz=qux"
encoded=$(crypto-url-encode "$url")
echo "Encoded: $encoded"

# URL decode
decoded=$(crypto-url-decode "$encoded")
echo "Decoded: $decoded"
```

**Example 9: GPG Operations**

```zsh
source "$(which _crypto)"

# Encrypt file with GPG
crypto-gpg-encrypt "sensitive.txt" "recipient@example.com"
# Output: sensitive.txt.asc

# Decrypt GPG file
crypto-gpg-decrypt "sensitive.txt.asc" > decrypted.txt

# Sign file
crypto-gpg-sign "document.pdf"
# Output: document.pdf.asc

# Verify signature
crypto-gpg-verify "document.pdf.asc"
```

**Example 10: Comprehensive Security Script**

```zsh
#!/usr/bin/env zsh
source "$(which _crypto)"

# Secure file encryption with password
encrypt-secure() {
    local input="$1"
    local output="${2:-${input}.enc}"

    # Validate input
    [[ ! -f "$input" ]] && { echo "File not found"; return 1; }

    # Generate random salt
    local salt=$(crypto-random-hex 16)

    # Hash file for integrity check
    local hash=$(crypto-sha256 "$input" --file)

    # Encrypt file
    crypto-encrypt-file "$input" "$output" --cipher "aes-256-cbc"

    # Store metadata
    cat > "${output}.meta" <<EOF
algorithm: aes-256-cbc
salt: $salt
hash: $hash
timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

    echo "Encrypted: $output"
    echo "Metadata: ${output}.meta"
}

# Decrypt and verify
decrypt-secure() {
    local input="$1"
    local output="${2:-${input%.enc}}"

    # Decrypt
    crypto-decrypt-file "$input" "$output"

    # Verify integrity if metadata exists
    if [[ -f "${input}.meta" ]]; then
        local expected_hash=$(grep '^hash:' "${input}.meta" | cut -d' ' -f2)
        local actual_hash=$(crypto-sha256 "$output" --file)

        if [[ "$actual_hash" == "$expected_hash" ]]; then
            echo "✓ Integrity verified"
        else
            echo "✗ Integrity check failed!"
            rm -f "$output"
            return 1
        fi
    fi

    echo "Decrypted: $output"
}

# Usage
encrypt-secure "secrets.txt"
decrypt-secure "secrets.txt.enc"
```

---

## Configuration

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: configuration -->

### Environment Variables

All configuration variables with descriptions, defaults, and security implications:

| Variable | Default | Type | Security | Description |
|----------|---------|------|----------|-------------|
| `CRYPTO_KEYRING_DIR` | `$XDG_DATA_HOME/crypto/keys` | String | HIGH | Directory for key storage (auto-created with mode 700) |
| `CRYPTO_DEFAULT_CIPHER` | `aes-256-cbc` | String | HIGH | Default symmetric cipher algorithm |
| `CRYPTO_DEFAULT_HASH` | `sha256` | String | MEDIUM | Default hash algorithm |
| `CRYPTO_KEY_SIZE` | `2048` | Integer | HIGH | RSA key size in bits (2048, 3072, 4096) |
| `CRYPTO_PBKDF2_ITERATIONS` | `100000` | Integer | HIGH | PBKDF2 iteration count (min 100k) |
| `CRYPTO_SALT_SIZE` | `16` | Integer | MEDIUM | Salt size in bytes (min 16) |
| `CRYPTO_CACHE_TTL` | `3600` | Integer | LOW | Hash cache TTL in seconds |
| `CRYPTO_DEBUG` | `false` | Boolean | LOW | Enable debug logging (NEVER in production) |
| `CRYPTO_PASSWORD` | - | String | CRITICAL | Password for non-interactive ops (use with extreme caution) |

**Runtime Variables (set by extension):**

| Variable | Initialized | Description |
|----------|-------------|-------------|
| `CRYPTO_CACHE_AVAILABLE` | On load | Whether _cache extension is available |
| `CRYPTO_LIFECYCLE_AVAILABLE` | On load | Whether _lifecycle extension is available |

### Keyring Directory

The keyring directory stores generated cryptographic keys:

```bash
# Default location
CRYPTO_KEYRING_DIR="$XDG_DATA_HOME/crypto/keys"
# Typically: ~/.local/share/crypto/keys

# Automatic security measures:
# - Created with mode 700 (owner-only access)
# - Parent directories created automatically
# - Keys registered with _lifecycle for cleanup

# Custom location
export CRYPTO_KEYRING_DIR="$HOME/.secure-keys"

# Directory structure:
# ~/.local/share/crypto/keys/
#   ├── mykey.pem          # RSA private key (mode 600)
#   ├── mykey.pub          # RSA public key (mode 644)
#   ├── sshkey_ed25519     # Ed25519 private key (mode 600)
#   └── sshkey_ed25519.pub # Ed25519 public key (mode 644)
```

### Default Settings

**Cipher Algorithms:**

```zsh
# AES-256-CBC (default - widely supported)
CRYPTO_DEFAULT_CIPHER="aes-256-cbc"

# AES-256-GCM (authenticated encryption)
CRYPTO_DEFAULT_CIPHER="aes-256-gcm"

# ChaCha20 (modern, fast)
CRYPTO_DEFAULT_CIPHER="chacha20"

# AES-128-CBC (faster, less secure)
CRYPTO_DEFAULT_CIPHER="aes-128-cbc"
```

**Hash Algorithms:**

```zsh
# SHA256 (default - good balance)
CRYPTO_DEFAULT_HASH="sha256"

# SHA512 (more secure, slower)
CRYPTO_DEFAULT_HASH="sha512"

# BLAKE2 (modern, fast)
CRYPTO_DEFAULT_HASH="blake2b512"

# MD5 (DEPRECATED - do not use for security)
CRYPTO_DEFAULT_HASH="md5"
```

**Key Sizes:**

```zsh
# RSA 2048 (default - minimum recommended)
CRYPTO_KEY_SIZE=2048

# RSA 3072 (medium security)
CRYPTO_KEY_SIZE=3072

# RSA 4096 (high security, slow)
CRYPTO_KEY_SIZE=4096
```

**PBKDF2 Iterations:**

```zsh
# 100,000 (default - NIST minimum 2023)
CRYPTO_PBKDF2_ITERATIONS=100000

# 200,000 (higher security)
CRYPTO_PBKDF2_ITERATIONS=200000

# 500,000 (very high security, slow)
CRYPTO_PBKDF2_ITERATIONS=500000
```

---

## API Reference

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: api_reference -->

### Tool Detection

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: tool_detection -->

#### crypto-check-openssl

**Source:** [→ L111](~/.local/bin/lib/_crypto#L111)
**Complexity:** Low | **Runtime:** <1ms | **Blocking:** No

Check if OpenSSL is available (required for all crypto operations).

**Signature:**
```zsh
crypto-check-openssl
```

**Returns:**
- `0`: OpenSSL available
- `1`: OpenSSL not found

**Example:**
```zsh
source "$(which _crypto)"

if crypto-check-openssl; then
    echo "OpenSSL is installed"
else
    echo "Error: OpenSSL required"
    exit 1
fi
```

**Dependencies:** Uses `_common` (common-command-exists)

---

#### crypto-check-gpg

**Source:** [→ L120](~/.local/bin/lib/_crypto#L120)
**Complexity:** Low | **Runtime:** <1ms | **Blocking:** No

Check if GPG is available (optional).

**Signature:**
```zsh
crypto-check-gpg
```

**Returns:**
- `0`: GPG available
- `1`: GPG not found

**Example:**
```zsh
source "$(which _crypto)"

if crypto-check-gpg; then
    crypto-gpg-encrypt "file.txt" "recipient@example.com"
else
    echo "GPG not available - using OpenSSL instead"
    crypto-encrypt-file "file.txt" "file.txt.enc"
fi
```

---

### Random Generation

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: random_generation -->

#### crypto-random-hex

**Source:** [→ L144](~/.local/bin/lib/_crypto#L144)
**Complexity:** Low | **Runtime:** ~10ms | **Blocking:** No

Generate cryptographically secure random bytes as hex string.

**Signature:**
```zsh
crypto-random-hex <count>
```

**Parameters:**
- `count` (optional): Number of bytes to generate (default: 32)

**Returns:**
- `0`: Success (outputs hex string)
- `1`: Invalid count or OpenSSL unavailable
- `6`: OpenSSL not found

**Output:** Hex-encoded random bytes (2 chars per byte)

**Security:** Uses OpenSSL's cryptographically secure RNG

**Performance:**
- **Complexity:** O(n) where n = byte count
- **I/O:** Reads from /dev/urandom via OpenSSL
- **Blocking:** No (non-blocking random source)

**Example 1: Generate Random Token**
```zsh
source "$(which _crypto)"

# 32 bytes = 64 hex characters
token=$(crypto-random-hex 32)
echo "Token: $token"
```

**Example 2: Generate API Key**
```zsh
source "$(which _crypto)"

# 16 bytes = 32 hex characters
api_key=$(crypto-random-hex 16)
echo "API_KEY=$api_key" >> .env
```

**Example 3: Generate Salt**
```zsh
source "$(which _crypto)"

# 16-byte salt for PBKDF2
salt=$(crypto-random-hex 16)
echo "Salt: $salt"
```

**Example 4: Validation**
```zsh
source "$(which _crypto)"

# Invalid input handling
if hex=$(crypto-random-hex "invalid"); then
    echo "Generated: $hex"
else
    echo "Error: Invalid byte count"
fi
```

**Dependencies:**
- `openssl rand -hex`

---

#### crypto-random-base64

**Source:** [→ L166](~/.local/bin/lib/_crypto#L166)
**Complexity:** Low | **Runtime:** ~10ms | **Blocking:** No

Generate cryptographically secure random base64 string.

**Signature:**
```zsh
crypto-random-base64 <length>
```

**Parameters:**
- `length` (optional): Length in bytes (default: 32)

**Returns:**
- `0`: Success (outputs base64 string)
- `1`: Invalid length or OpenSSL unavailable
- `6`: OpenSSL not found

**Output:** Base64-encoded random bytes (without padding `=`)

**Security:** Uses OpenSSL's cryptographically secure RNG

**Example 1: Generate Secret**
```zsh
source "$(which _crypto)"

secret=$(crypto-random-base64 32)
echo "SECRET=$secret"
```

**Example 2: Session Token**
```zsh
source "$(which _crypto)"

session=$(crypto-random-base64 64)
echo "Session: $session"
```

**Dependencies:**
- `openssl rand -base64`
- `tr` (strip padding)

---

#### crypto-uuid

**Source:** [→ L186](~/.local/bin/lib/_crypto#L186)
**Complexity:** Low | **Runtime:** ~5ms | **Blocking:** No

Generate UUID v4 (universally unique identifier).

**Signature:**
```zsh
crypto-uuid
```

**Returns:**
- `0`: Success (outputs UUID)
- `1`: Generation failed

**Output:** UUID v4 string (e.g., `550e8400-e29b-41d4-a716-446655440000`)

**Implementation:**
- Prefers `uuidgen` if available
- Falls back to OpenSSL-based generation

**Example 1: Generate ID**
```zsh
source "$(which _crypto)"

id=$(crypto-uuid)
echo "ID: $id"
```

**Example 2: Unique Filename**
```zsh
source "$(which _crypto)"

filename="backup-$(crypto-uuid).tar.gz"
tar czf "$filename" /path/to/data
```

**Example 3: Database Record ID**
```zsh
source "$(which _crypto)"

record_id=$(crypto-uuid)
echo "INSERT INTO records (id, data) VALUES ('$record_id', 'data');" | psql
```

**Dependencies:**
- `uuidgen` (preferred)
- `crypto-random-hex` (fallback)

---

#### crypto-random-number

**Source:** [→ L207](~/.local/bin/lib/_crypto#L207)
**Complexity:** Low | **Runtime:** ~10ms | **Blocking:** No

Generate cryptographically secure random number in range.

**Signature:**
```zsh
crypto-random-number <min> <max>
```

**Parameters:**
- `min` (optional): Minimum value inclusive (default: 0)
- `max` (optional): Maximum value inclusive (default: 100)

**Returns:**
- `0`: Success (outputs number)
- `1`: Invalid min/max or OpenSSL unavailable

**Output:** Random integer in range [min, max]

**Security:** Uses OpenSSL RNG with modulo bias mitigation

**Example 1: Random Port**
```zsh
source "$(which _crypto)"

port=$(crypto-random-number 49152 65535)
echo "Ephemeral port: $port"
```

**Example 2: Random Delay**
```zsh
source "$(which _crypto)"

delay=$(crypto-random-number 1 10)
sleep "$delay"
```

**Example 3: Dice Roll**
```zsh
source "$(which _crypto)"

roll=$(crypto-random-number 1 6)
echo "You rolled: $roll"
```

**Dependencies:**
- `crypto-random-hex`

---

### Hashing

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: hashing -->

#### crypto-hash

**Source:** [→ L241](~/.local/bin/lib/_crypto#L241)
**Complexity:** Medium | **Runtime:** O(n) file size | **Blocking:** Yes (file I/O)

Generic hash function supporting multiple algorithms.

**Signature:**
```zsh
crypto-hash <algorithm> <data> [--file]
```

**Parameters:**
- `algorithm` (required): Hash algorithm (sha256, sha512, md5, blake2b512, etc.)
- `data` (required): Data to hash or file path if --file specified

**Options:**
- `--file`: Treat `data` as file path instead of string

**Returns:**
- `0`: Success (outputs hex hash)
- `1`: Invalid arguments or hash failed
- `2`: File not found (with --file)
- `6`: OpenSSL not found

**Output:** Hex-encoded hash digest

**Performance:**
- **Complexity:** O(n) where n = data/file size
- **I/O:** File read (with --file), hash computation
- **Blocking:** Yes (hashing operation)
- **Caching:** Enabled if _cache available (strings only)

**Example 1: Hash String**
```zsh
source "$(which _crypto)"

hash=$(crypto-hash sha256 "my secret data")
echo "SHA256: $hash"
```

**Example 2: Hash File**
```zsh
source "$(which _crypto)"

hash=$(crypto-hash sha256 "/path/to/file" --file)
echo "File hash: $hash"
```

**Example 3: Multiple Algorithms**
```zsh
source "$(which _crypto)"

data="test data"

sha256=$(crypto-hash sha256 "$data")
sha512=$(crypto-hash sha512 "$data")
blake2=$(crypto-hash blake2b512 "$data")

echo "SHA256:  $sha256"
echo "SHA512:  $sha512"
echo "BLAKE2:  $blake2"
```

**Example 4: Cached Hashing (Fast)**
```zsh
source "$(which _crypto)"

# Requires _cache extension

# First call computes hash
time crypto-hash sha256 "large data string"
# Output: 0.05s

# Subsequent calls use cache
time crypto-hash sha256 "large data string"
# Output: 0.001s (cached)
```

**Example 5: Verify Downloaded File**
```zsh
source "$(which _crypto)"

file="download.tar.gz"
expected_hash="abc123..."

actual_hash=$(crypto-hash sha256 "$file" --file)

if [[ "$actual_hash" == "$expected_hash" ]]; then
    echo "✓ Download verified"
else
    echo "✗ Hash mismatch - corrupted download"
    rm "$file"
fi
```

**Dependencies:**
- `openssl dgst`

**Integration:**
- Uses _cache if available for string hashing
- Cache key: `crypto:hash:$algorithm:$data_hash`
- Cache TTL: `CRYPTO_CACHE_TTL` (default 3600s)

---

#### crypto-sha256

**Source:** [→ L314](~/.local/bin/lib/_crypto#L314)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** Yes

SHA256 hash (convenience wrapper for crypto-hash).

**Signature:**
```zsh
crypto-sha256 <data> [--file]
```

**Returns:** Same as `crypto-hash sha256 ...`

**Example:**
```zsh
source "$(which _crypto)"

# String
hash=$(crypto-sha256 "data")

# File
file_hash=$(crypto-sha256 "/path/to/file" --file)
```

---

#### crypto-sha512

**Source:** [→ L320](~/.local/bin/lib/_crypto#L320)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** Yes

SHA512 hash (convenience wrapper).

**Signature:**
```zsh
crypto-sha512 <data> [--file]
```

**Example:**
```zsh
source "$(which _crypto)"

hash=$(crypto-sha512 "data")
```

---

#### crypto-md5

**Source:** [→ L326](~/.local/bin/lib/_crypto#L326)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** Yes

MD5 hash (DEPRECATED - use for compatibility only).

**Signature:**
```zsh
crypto-md5 <data> [--file]
```

**Security Warning:** MD5 is cryptographically broken. Use SHA256 or SHA512 for security.

**Example:**
```zsh
source "$(which _crypto)"

# Only for compatibility with legacy systems
hash=$(crypto-md5 "data")
# Output: [WARN] MD5 is cryptographically broken - use SHA256 or SHA512 instead
```

---

#### crypto-blake2

**Source:** [→ L333](~/.local/bin/lib/_crypto#L333)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** Yes

BLAKE2b-512 hash (modern, fast algorithm).

**Signature:**
```zsh
crypto-blake2 <data> [--file]
```

**Example:**
```zsh
source "$(which _crypto)"

hash=$(crypto-blake2 "data")
```

---

#### crypto-verify-hash

**Source:** [→ L346](~/.local/bin/lib/_crypto#L346)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** Yes

Verify hash matches expected value.

**Signature:**
```zsh
crypto-verify-hash <algorithm> <data> <expected_hash> [--file]
```

**Parameters:**
- `algorithm` (required): Hash algorithm
- `data` (required): Data to hash or file path
- `expected_hash` (required): Expected hash value

**Options:**
- `--file`: Treat `data` as file path

**Returns:**
- `0`: Hash matches (verified)
- `1`: Hash mismatch or error

**Example 1: Verify Download**
```zsh
source "$(which _crypto)"

file="linux.iso"
expected="abc123def456..."

if crypto-verify-hash sha256 "$file" "$expected" --file; then
    echo "✓ File integrity verified"
else
    echo "✗ Corrupted download"
    rm "$file"
fi
```

**Example 2: API Response Validation**
```zsh
source "$(which _crypto)"

response=$(curl -s "https://api.example.com/data")
signature=$(curl -s "https://api.example.com/data.sig")

if crypto-verify-hash sha256 "$response" "$signature"; then
    echo "✓ Response verified"
    process-data "$response"
else
    echo "✗ Tampered response"
fi
```

**Dependencies:** Calls `crypto-hash` internally

---

### HMAC

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: hmac -->

#### crypto-hmac

**Source:** [→ L384](~/.local/bin/lib/_crypto#L384)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** Yes

Generate HMAC (Hash-based Message Authentication Code).

**Signature:**
```zsh
crypto-hmac <algorithm> <key> <data> [--file]
```

**Parameters:**
- `algorithm` (required): Hash algorithm (sha256, sha512, etc.)
- `key` (required): Secret key
- `data` (required): Data to HMAC or file path

**Options:**
- `--file`: Treat `data` as file path

**Returns:**
- `0`: Success (outputs HMAC hex)
- `1`: Invalid arguments or HMAC failed
- `2`: File not found (with --file)
- `6`: OpenSSL not found

**Output:** Hex-encoded HMAC digest

**Security:** HMAC provides both authentication and integrity

**Performance:**
- **Complexity:** O(n) where n = data/file size
- **I/O:** File read (with --file), HMAC computation
- **Blocking:** Yes

**Example 1: API Request Signing**
```zsh
source "$(which _crypto)"

api_secret="my_api_secret_key"
request_body='{"action":"transfer","amount":100}'

# Generate HMAC signature
signature=$(crypto-hmac sha256 "$api_secret" "$request_body")

# Include in request
curl -H "X-Signature: $signature" \
     -d "$request_body" \
     https://api.example.com/endpoint
```

**Example 2: Message Authentication**
```zsh
source "$(which _crypto)"

secret="shared_secret"
message="Important message"

# Sender: generate HMAC
hmac=$(crypto-hmac sha256 "$secret" "$message")

# Send message + HMAC
echo "$message|$hmac" > transmission.txt

# Receiver: verify HMAC
IFS='|' read -r recv_message recv_hmac < transmission.txt

if crypto-verify-hmac sha256 "$secret" "$recv_message" "$recv_hmac"; then
    echo "✓ Message authenticated"
else
    echo "✗ Authentication failed - message tampered"
fi
```

**Example 3: File Integrity with Key**
```zsh
source "$(which _crypto)"

key=$(crypto-random-hex 32)
file="important-data.txt"

# Generate HMAC
hmac=$(crypto-hmac sha256 "$key" "$file" --file)

# Store HMAC and key securely
echo "$hmac" > "${file}.hmac"
echo "$key" > "${file}.key"
chmod 600 "${file}.key"

# Later: verify file hasn't changed
stored_hmac=$(cat "${file}.hmac")
stored_key=$(cat "${file}.key")

if crypto-verify-hmac sha256 "$stored_key" "$file" "$stored_hmac" --file; then
    echo "✓ File integrity verified"
fi
```

**Dependencies:**
- `openssl dgst -hmac`

---

#### crypto-verify-hmac

**Source:** [→ L437](~/.local/bin/lib/_crypto#L437)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** Yes

Verify HMAC matches expected value.

**Signature:**
```zsh
crypto-verify-hmac <algorithm> <key> <data> <expected_hmac> [--file]
```

**Parameters:**
- `algorithm` (required): Hash algorithm
- `key` (required): Secret key
- `data` (required): Data to HMAC
- `expected_hmac` (required): Expected HMAC value

**Options:**
- `--file`: Treat `data` as file path

**Returns:**
- `0`: HMAC matches (verified)
- `1`: HMAC mismatch or error

**Example:**
```zsh
source "$(which _crypto)"

if crypto-verify-hmac sha256 "$key" "$data" "$hmac"; then
    echo "Authenticated"
else
    echo "Tampered"
fi
```

**Dependencies:** Calls `crypto-hmac` internally

---

### Symmetric Encryption

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: symmetric_encryption -->

#### crypto-encrypt

**Source:** [→ L475](~/.local/bin/lib/_crypto#L475)
**Complexity:** High | **Runtime:** O(n) file size | **Blocking:** Yes

Encrypt data or file with password-based encryption.

**Signature:**
```zsh
crypto-encrypt <data> [--password <pass>] [--cipher <cipher>] [--output <file>] [--input-file]
```

**Parameters:**
- `data` (required): Data to encrypt or file path if --input-file

**Options:**
- `--password <pass>`: Encryption password (prompted if not provided)
- `--cipher <cipher>`: Cipher algorithm (default: aes-256-cbc)
- `--output <file>`: Output file path
- `--input-file`: Treat `data` as file path

**Returns:**
- `0`: Success (outputs base64 or writes to file)
- `1`: Encryption failed or invalid arguments
- `2`: Input file not found
- `6`: OpenSSL not found

**Output:**
- Without `--output`: Base64-encoded encrypted data to stdout
- With `--output`: Encrypted data written to file

**Security:**
- Uses PBKDF2 key derivation (default 100,000 iterations)
- Salted encryption (automatic)
- Default cipher: AES-256-CBC

**Performance:**
- **Complexity:** O(n) where n = data/file size
- **I/O:** File read/write, encryption
- **Blocking:** Yes

**Example 1: Encrypt String**
```zsh
source "$(which _crypto)"

encrypted=$(crypto-encrypt "my secret" --password "mypassword")
echo "Encrypted: $encrypted"
```

**Example 2: Encrypt File**
```zsh
source "$(which _crypto)"

crypto-encrypt "sensitive.txt" \
  --input-file \
  --output "sensitive.enc" \
  --password "strongpassword"
```

**Example 3: Interactive Password**
```zsh
source "$(which _crypto)"

# Prompts for password
crypto-encrypt "data.txt" --input-file --output "data.enc"
# Output: Enter encryption password: [hidden input]
```

**Example 4: Custom Cipher**
```zsh
source "$(which _crypto)"

# Use ChaCha20
crypto-encrypt "file.txt" \
  --input-file \
  --cipher "chacha20" \
  --password "secret"
```

**Example 5: Environment Password (Use with Caution)**
```zsh
source "$(which _crypto)"

# Set password in environment (INSECURE - only for automation)
export CRYPTO_PASSWORD="mypassword"

# Non-interactive encryption
crypto-encrypt "data" --output "data.enc"

# Clear password
unset CRYPTO_PASSWORD
```

**Example 6: Dotfiles Secret Encryption**
```zsh
source "$(which _crypto)"

encrypt-secret() {
    local secret_file="$1"
    local encrypted="${secret_file}.enc"

    # Encrypt with master password
    crypto-encrypt "$secret_file" \
      --input-file \
      --output "$encrypted" \
      --cipher "aes-256-gcm"

    # Remove plaintext (optional)
    # shred -u "$secret_file"

    echo "Encrypted: $encrypted"
}

encrypt-secret "$HOME/.ssh/config"
```

**Dependencies:**
- `openssl enc`

**Security Notes:**
- Never log or echo passwords
- Use strong passwords (20+ characters)
- Consider using GPG for long-term storage
- Default iterations (100k) meets NIST 2023 guidelines

---

#### crypto-decrypt

**Source:** [→ L568](~/.local/bin/lib/_crypto#L568)
**Complexity:** High | **Runtime:** O(n) file size | **Blocking:** Yes

Decrypt data or file encrypted with crypto-encrypt.

**Signature:**
```zsh
crypto-decrypt <data> [--password <pass>] [--cipher <cipher>] [--output <file>] [--input-file]
```

**Parameters:**
- `data` (required): Encrypted data or file path if --input-file

**Options:**
- `--password <pass>`: Decryption password (prompted if not provided)
- `--cipher <cipher>`: Cipher algorithm (must match encryption)
- `--output <file>`: Output file path
- `--input-file`: Treat `data` as file path

**Returns:**
- `0`: Success (outputs plaintext or writes to file)
- `1`: Decryption failed (wrong password or corrupted)
- `2`: Input file not found
- `6`: OpenSSL not found

**Output:**
- Without `--output`: Decrypted data to stdout
- With `--output`: Decrypted data written to file

**Example 1: Decrypt String**
```zsh
source "$(which _crypto)"

encrypted="U2FsdGVkX1..."
decrypted=$(crypto-decrypt "$encrypted" --password "mypassword")
echo "Decrypted: $decrypted"
```

**Example 2: Decrypt File**
```zsh
source "$(which _crypto)"

crypto-decrypt "sensitive.enc" \
  --input-file \
  --output "sensitive.txt" \
  --password "strongpassword"
```

**Example 3: Verify Decryption**
```zsh
source "$(which _crypto)"

if decrypted=$(crypto-decrypt "$encrypted" --password "$pw"); then
    echo "Decryption successful"
    echo "$decrypted"
else
    echo "Wrong password or corrupted data"
fi
```

**Dependencies:**
- `openssl enc -d`

---

#### crypto-encrypt-file

**Source:** [→ L661](~/.local/bin/lib/_crypto#L661)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** Yes

Encrypt file (convenience wrapper).

**Signature:**
```zsh
crypto-encrypt-file <input> <output> [--password <pass>]
```

**Parameters:**
- `input` (required): Input file path
- `output` (required): Output file path

**Options:**
- `--password <pass>`: Encryption password

**Returns:** Same as `crypto-encrypt --input-file --output`

**Example:**
```zsh
source "$(which _crypto)"

crypto-encrypt-file "plaintext.txt" "encrypted.bin" --password "secret"
```

---

#### crypto-decrypt-file

**Source:** [→ L676](~/.local/bin/lib/_crypto#L676)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** Yes

Decrypt file (convenience wrapper).

**Signature:**
```zsh
crypto-decrypt-file <input> <output> [--password <pass>]
```

**Parameters:**
- `input` (required): Encrypted file path
- `output` (required): Output file path

**Options:**
- `--password <pass>`: Decryption password

**Returns:** Same as `crypto-decrypt --input-file --output`

**Example:**
```zsh
source "$(which _crypto)"

crypto-decrypt-file "encrypted.bin" "plaintext.txt" --password "secret"
```

---

### Key Generation

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: key_generation -->

#### crypto-generate-key

**Source:** [→ L699](~/.local/bin/lib/_crypto#L699)
**Complexity:** Low | **Runtime:** ~10ms | **Blocking:** No

Generate symmetric encryption key.

**Signature:**
```zsh
crypto-generate-key [--size <bytes>]
```

**Options:**
- `--size <bytes>`: Key size in bytes (default: 32)

**Returns:**
- `0`: Success (outputs hex key)

**Output:** Hex-encoded symmetric key

**Example 1: 256-bit Key**
```zsh
source "$(which _crypto)"

key=$(crypto-generate-key --size 32)  # 32 bytes = 256 bits
echo "AES-256 Key: $key"
```

**Example 2: Store Key Securely**
```zsh
source "$(which _crypto)"

key=$(crypto-generate-key)
echo "$key" > ~/.crypto-keys/mykey.key
chmod 600 ~/.crypto-keys/mykey.key
```

**Dependencies:**
- `crypto-random-hex`

---

#### crypto-generate-rsa

**Source:** [→ L725](~/.local/bin/lib/_crypto#L725)
**Complexity:** High | **Runtime:** ~1-10s (size-dependent) | **Blocking:** Yes

Generate RSA public/private keypair.

**Signature:**
```zsh
crypto-generate-rsa <name> [--size <bits>]
```

**Parameters:**
- `name` (required): Key name (files: `<name>.pem`, `<name>.pub`)

**Options:**
- `--size <bits>`: Key size in bits (default: 2048)

**Returns:**
- `0`: Success (prints paths)
- `1`: Generation failed or invalid arguments
- `6`: OpenSSL not found

**Output:** Paths to generated private and public keys

**Side Effects:**
- Creates `$CRYPTO_KEYRING_DIR/<name>.pem` (mode 600)
- Creates `$CRYPTO_KEYRING_DIR/<name>.pub` (mode 644)
- Registers cleanup with _lifecycle if available

**Security:**
- Private key: mode 600 (owner-only)
- Public key: mode 644 (world-readable)
- Keyring directory: mode 700

**Performance:**
- 2048-bit: ~1-2 seconds
- 4096-bit: ~5-10 seconds

**Example 1: Default 2048-bit Key**
```zsh
source "$(which _crypto)"

crypto-generate-rsa "mykey"
# Output:
# Private: ~/.local/share/crypto/keys/mykey.pem
# Public:  ~/.local/share/crypto/keys/mykey.pub
```

**Example 2: High-Security 4096-bit Key**
```zsh
source "$(which _crypto)"

crypto-generate-rsa "secure-key" --size 4096
```

**Example 3: Automated Key Rotation**
```zsh
source "$(which _crypto)"

rotate-keys() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local keyname="rsa_${timestamp}"

    # Generate new key
    crypto-generate-rsa "$keyname" --size 3072

    # Link as current
    ln -sf "$CRYPTO_KEYRING_DIR/${keyname}.pem" "$CRYPTO_KEYRING_DIR/current.pem"
    ln -sf "$CRYPTO_KEYRING_DIR/${keyname}.pub" "$CRYPTO_KEYRING_DIR/current.pub"

    echo "Rotated to: $keyname"
}

rotate-keys
```

**Dependencies:**
- `openssl genrsa`
- `openssl rsa`

**Integration:**
- Registers cleanup with _lifecycle if available
- Keys automatically removed on script exit if registered

---

#### crypto-generate-ed25519

**Source:** [→ L787](~/.local/bin/lib/_crypto#L787)
**Complexity:** Medium | **Runtime:** ~100ms | **Blocking:** Yes

Generate Ed25519 public/private keypair (SSH format).

**Signature:**
```zsh
crypto-generate-ed25519 <name>
```

**Parameters:**
- `name` (required): Key name (files: `<name>_ed25519`, `<name>_ed25519.pub`)

**Returns:**
- `0`: Success (prints paths)
- `1`: Generation failed or invalid arguments
- `6`: ssh-keygen not found

**Output:** Paths to generated keys

**Side Effects:**
- Creates `$CRYPTO_KEYRING_DIR/<name>_ed25519` (mode 600)
- Creates `$CRYPTO_KEYRING_DIR/<name>_ed25519.pub` (mode 644)
- Registers cleanup with _lifecycle if available

**Security:**
- Ed25519 is modern, fast, and secure (equivalent to ~3000-bit RSA)
- No passphrase (empty passphrase for automation)

**Example 1: SSH Key**
```zsh
source "$(which _crypto)"

crypto-generate-ed25519 "github"
# Output:
# Private: ~/.local/share/crypto/keys/github_ed25519
# Public:  ~/.local/share/crypto/keys/github_ed25519.pub

# Add to SSH agent
ssh-add ~/.local/share/crypto/keys/github_ed25519

# Copy public key
cat ~/.local/share/crypto/keys/github_ed25519.pub
```

**Example 2: Automated Deploy Key**
```zsh
source "$(which _crypto)"

setup-deploy-key() {
    local project="$1"

    # Generate key
    crypto-generate-ed25519 "deploy_${project}"

    # Get public key
    local pubkey=$(cat "$CRYPTO_KEYRING_DIR/deploy_${project}_ed25519.pub")

    echo "Add this deploy key to your repository:"
    echo "$pubkey"
}

setup-deploy-key "myapp"
```

**Dependencies:**
- `ssh-keygen`

**Integration:**
- Registers cleanup with _lifecycle if available

---

### Password Hashing

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: password_hashing -->

#### crypto-hash-password

**Source:** [→ L833](~/.local/bin/lib/_crypto#L833)
**Complexity:** Medium | **Runtime:** ~500ms | **Blocking:** Yes

Hash password with salt for secure storage (PBKDF2).

**Signature:**
```zsh
crypto-hash-password <password> [--salt <salt>]
```

**Parameters:**
- `password` (required): Password to hash

**Options:**
- `--salt <salt>`: Salt (auto-generated if not provided)

**Returns:**
- `0`: Success (outputs salt:hash)
- `1`: Invalid arguments or hashing failed
- `6`: OpenSSL not found

**Output:** `salt:hash` format for storage

**Security:**
- PBKDF2 with SHA256
- Default 100,000 iterations (configurable via CRYPTO_PBKDF2_ITERATIONS)
- 16-byte random salt (configurable via CRYPTO_SALT_SIZE)

**Performance:**
- ~500ms (100,000 iterations)
- Intentionally slow to resist brute-force attacks

**Example 1: Hash for Storage**
```zsh
source "$(which _crypto)"

password="user_password_123"
hashed=$(crypto-hash-password "$password")

# Store in database/file
echo "user:$hashed" >> users.db
```

**Example 2: User Registration**
```zsh
source "$(which _crypto)"

register-user() {
    local username="$1"
    local password="$2"

    # Hash password
    local hashed=$(crypto-hash-password "$password")

    # Store user
    echo "$username:$hashed:$(date +%s)" >> users.db

    echo "User registered: $username"
}

register-user "alice" "secure_password"
```

**Example 3: High-Security Hashing**
```zsh
source "$(which _crypto)"

# Increase iterations for higher security
export CRYPTO_PBKDF2_ITERATIONS=200000

hashed=$(crypto-hash-password "$password")
```

**Dependencies:**
- `openssl dgst`
- `crypto-random-hex` (salt generation)

---

#### crypto-verify-password

**Source:** [→ L879](~/.local/bin/lib/_crypto#L879)
**Complexity:** Medium | **Runtime:** ~500ms | **Blocking:** Yes

Verify password matches stored hash.

**Signature:**
```zsh
crypto-verify-password <password> <stored_hash>
```

**Parameters:**
- `password` (required): Password to verify
- `stored_hash` (required): Stored hash (salt:hash format)

**Returns:**
- `0`: Password matches (verified)
- `1`: Password mismatch or error

**Example 1: Login Verification**
```zsh
source "$(which _crypto)"

login() {
    local username="$1"
    local password="$2"

    # Retrieve stored hash
    local stored=$(grep "^$username:" users.db | cut -d: -f2)

    if [[ -z "$stored" ]]; then
        echo "User not found"
        return 1
    fi

    # Verify password
    if crypto-verify-password "$password" "$stored"; then
        echo "✓ Login successful"
        return 0
    else
        echo "✗ Invalid password"
        return 1
    fi
}

login "alice" "user_input_password"
```

**Example 2: Rate-Limited Authentication**
```zsh
source "$(which _crypto)"

authenticate() {
    local username="$1"
    local password="$2"
    local max_attempts=3
    local lockout_file="/tmp/auth_lockout_$username"

    # Check lockout
    if [[ -f "$lockout_file" ]]; then
        local lockout_until=$(cat "$lockout_file")
        if (($(date +%s) < lockout_until)); then
            echo "Account locked - try again later"
            return 1
        fi
    fi

    # Get stored hash
    local stored=$(grep "^$username:" users.db | cut -d: -f2)

    # Verify
    if crypto-verify-password "$password" "$stored"; then
        rm -f "$lockout_file"
        echo "Authenticated"
        return 0
    else
        # Implement lockout after failures
        echo $(($(date +%s) + 300)) > "$lockout_file"  # 5-min lockout
        echo "Authentication failed"
        return 1
    fi
}
```

**Dependencies:**
- `crypto-hash-password`

---

### Base64 Encoding

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: base64_encoding -->

#### crypto-base64-encode

**Source:** [→ L912](~/.local/bin/lib/_crypto#L912)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** No

Encode data to base64.

**Signature:**
```zsh
crypto-base64-encode <data> [--file]
```

**Parameters:**
- `data` (required): Data to encode or file path

**Options:**
- `--file`: Treat `data` as file path

**Returns:**
- `0`: Success (outputs base64)
- `1`: Invalid arguments
- `2`: File not found (with --file)

**Output:** Base64-encoded data (no line wrapping)

**Example 1: Encode String**
```zsh
source "$(which _crypto)"

encoded=$(crypto-base64-encode "hello world")
echo "Encoded: $encoded"
# Output: aGVsbG8gd29ybGQ=
```

**Example 2: Encode File**
```zsh
source "$(which _crypto)"

crypto-base64-encode "binary.dat" --file > encoded.txt
```

**Example 3: Encode for Embedding**
```zsh
source "$(which _crypto)"

# Encode image for HTML
image_data=$(crypto-base64-encode "logo.png" --file)
echo "<img src=\"data:image/png;base64,$image_data\" />"
```

**Dependencies:**
- `base64` command

---

#### crypto-base64-decode

**Source:** [→ L949](~/.local/bin/lib/_crypto#L949)
**Complexity:** Low | **Runtime:** O(n) | **Blocking:** No

Decode base64 data.

**Signature:**
```zsh
crypto-base64-decode <data> [--file]
```

**Parameters:**
- `data` (required): Base64 data or file path

**Options:**
- `--file`: Treat `data` as file path

**Returns:**
- `0`: Success (outputs decoded data)
- `1`: Invalid arguments or decode failed
- `2`: File not found (with --file)

**Output:** Decoded binary data

**Example:**
```zsh
source "$(which _crypto)"

decoded=$(crypto-base64-decode "aGVsbG8gd29ybGQ=")
echo "$decoded"
# Output: hello world
```

**Dependencies:**
- `base64 -d` command

---

### URL Encoding

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_GROUP: url_encoding -->

#### crypto-url-encode

**Source:** [→ L990](~/.local/bin/lib/_crypto#L990)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** No

URL-encode string (percent encoding).

**Signature:**
```zsh
crypto-url-encode <string>
```

**Parameters:**
- `string` (required): String to encode

**Returns:**
- `0`: Success (outputs encoded string)
- `1`: Invalid arguments

**Output:** URL-encoded string

**Example 1: Encode URL Parameters**
```zsh
source "$(which _crypto)"

param="hello world & foo=bar"
encoded=$(crypto-url-encode "$param")
echo "Encoded: $encoded"
# Output: hello%20world%20%26%20foo%3Dbar
```

**Example 2: Build Query String**
```zsh
source "$(which _crypto)"

build-query() {
    local -A params
    params[name]="John Doe"
    params[email]="john@example.com"
    params[message]="Hello, world!"

    local query=""
    for key val in "${(@kv)params}"; do
        local encoded_val=$(crypto-url-encode "$val")
        query+="${key}=${encoded_val}&"
    done

    echo "${query%&}"
}

query=$(build-query)
curl "https://api.example.com/submit?$query"
```

**Dependencies:** Pure ZSH implementation

---

#### crypto-url-decode

**Source:** [→ L1019](~/.local/bin/lib/_crypto#L1019)
**Complexity:** Medium | **Runtime:** O(n) | **Blocking:** No

URL-decode string (percent decoding).

**Signature:**
```zsh
crypto-url-decode <string>
```

**Parameters:**
- `string` (required): String to decode

**Returns:**
- `0`: Success (outputs decoded string)
- `1`: Invalid arguments

**Output:** Decoded string

**Example:**
```zsh
source "$(which _crypto)"

encoded="hello%20world%20%26%20foo%3Dbar"
decoded=$(crypto-url-decode "$encoded")
echo "$decoded"
# Output: hello world & foo=bar
```

**Dependencies:** Pure ZSH implementation

---

### GPG Integration

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_GROUP: gpg_integration -->

#### crypto-gpg-encrypt

**Source:** [→ L1054](~/.local/bin/lib/_crypto#L1054)
**Complexity:** Medium | **Runtime:** Network/keyserver dependent | **Blocking:** Yes

Encrypt file with GPG for recipient.

**Signature:**
```zsh
crypto-gpg-encrypt <file> <recipient>
```

**Parameters:**
- `file` (required): File to encrypt
- `recipient` (required): GPG key ID or email

**Returns:**
- `0`: Success (creates .asc file)
- `1`: Invalid arguments
- `2`: File not found
- `6`: GPG not found

**Output:** Creates `<file>.asc` (encrypted file)

**Example:**
```zsh
source "$(which _crypto)"

crypto-gpg-encrypt "secret.txt" "alice@example.com"
# Creates: secret.txt.asc
```

**Dependencies:**
- `gpg --encrypt`

---

#### crypto-gpg-decrypt

**Source:** [→ L1088](~/.local/bin/lib/_crypto#L1088)
**Complexity:** Medium | **Runtime:** Passphrase-dependent | **Blocking:** Yes

Decrypt GPG-encrypted file.

**Signature:**
```zsh
crypto-gpg-decrypt <file>
```

**Parameters:**
- `file` (required): Encrypted file (.asc or .gpg)

**Returns:**
- `0`: Success (outputs plaintext)
- `1`: Invalid arguments or decryption failed
- `2`: File not found
- `6`: GPG not found

**Output:** Decrypted plaintext to stdout

**Example:**
```zsh
source "$(which _crypto)"

crypto-gpg-decrypt "secret.txt.asc" > secret.txt
```

**Dependencies:**
- `gpg --decrypt`

---

#### crypto-gpg-sign

**Source:** [→ L1112](~/.local/bin/lib/_crypto#L1112)
**Complexity:** Medium | **Runtime:** ~100ms | **Blocking:** Yes

Sign file with GPG.

**Signature:**
```zsh
crypto-gpg-sign <file>
```

**Parameters:**
- `file` (required): File to sign

**Returns:**
- `0`: Success (creates .asc signature)
- `1`: Invalid arguments or signing failed
- `2`: File not found
- `6`: GPG not found

**Output:** Creates `<file>.asc` (detached signature)

**Example:**
```zsh
source "$(which _crypto)"

crypto-gpg-sign "document.pdf"
# Creates: document.pdf.asc
```

**Dependencies:**
- `gpg --sign`

---

#### crypto-gpg-verify

**Source:** [→ L1145](~/.local/bin/lib/_crypto#L1145)
**Complexity:** Medium | **Runtime:** ~100ms | **Blocking:** Yes

Verify GPG signature.

**Signature:**
```zsh
crypto-gpg-verify <file>
```

**Parameters:**
- `file` (required): Signature file (.asc)

**Returns:**
- `0`: Valid signature
- `1`: Invalid signature or verification failed
- `2`: File not found
- `6`: GPG not found

**Output:** GPG verification output

**Example:**
```zsh
source "$(which _crypto)"

if crypto-gpg-verify "document.pdf.asc"; then
    echo "✓ Signature valid"
else
    echo "✗ Invalid signature"
fi
```

**Dependencies:**
- `gpg --verify`

---

### Utilities

<!-- CONTEXT_PRIORITY: LOW -->
<!-- CONTEXT_GROUP: utilities -->

#### crypto-self-test

**Source:** [→ L1173](~/.local/bin/lib/_crypto#L1173)
**Complexity:** High | **Runtime:** ~5s | **Blocking:** Yes

Run comprehensive self-tests for all crypto functions.

**Signature:**
```zsh
crypto-self-test
```

**Returns:**
- `0`: All tests passed
- `1`: Some tests failed

**Output:** Detailed test results

**Tests Performed:**
1. OpenSSL availability
2. Random hex generation
3. Random base64 generation
4. UUID generation
5. SHA256 hashing
6. Hash verification
7. HMAC generation
8. HMAC verification
9. Base64 encoding/decoding
10. URL encoding/decoding
11. Symmetric encryption/decryption
12. Password hashing/verification

**Example:**
```zsh
source "$(which _crypto)"

crypto-self-test
# Output:
# === _crypto v1.0.0 Self-Test ===
#
# Test 1: OpenSSL availability... PASS
# Test 2: Random hex generation... PASS
# Test 3: Random base64 generation... PASS
# ...
# Test 12: Password hashing/verification... PASS
#
# === Self-Test Summary ===
# Passed: 12
# Failed: 0
#
# All tests passed!
```

---

#### crypto-version

**Source:** [→ L1353](~/.local/bin/lib/_crypto#L1353)
**Complexity:** Low | **Runtime:** <1ms | **Blocking:** No

Display extension version.

**Signature:**
```zsh
crypto-version
```

**Returns:** `0`

**Output:** Version string

**Example:**
```zsh
source "$(which _crypto)"

crypto-version
# Output: _crypto v1.0.0
```

---

## Advanced Usage

<!-- CONTEXT_PRIORITY: MEDIUM -->
<!-- CONTEXT_GROUP: advanced -->

### Integration Pattern 1: Secure Configuration Management

```zsh
#!/usr/bin/env zsh
# secure-config - Encrypted configuration management

source "$(which _crypto)"

CONFIG_DIR="$HOME/.config/myapp"
MASTER_PASSWORD_FILE="$HOME/.master_password"

# Initialize secure config
init-secure-config() {
    mkdir -p "$CONFIG_DIR"

    # Generate master password if not exists
    if [[ ! -f "$MASTER_PASSWORD_FILE" ]]; then
        crypto-random-base64 32 > "$MASTER_PASSWORD_FILE"
        chmod 600 "$MASTER_PASSWORD_FILE"
    fi
}

# Encrypt configuration file
encrypt-config() {
    local config_file="$1"
    local master_pw=$(cat "$MASTER_PASSWORD_FILE")

    crypto-encrypt-file \
        "$config_file" \
        "${config_file}.enc" \
        --password "$master_pw"

    # Securely delete plaintext
    shred -u "$config_file"
}

# Decrypt configuration file
decrypt-config() {
    local config_file="$1"
    local master_pw=$(cat "$MASTER_PASSWORD_FILE")

    crypto-decrypt-file \
        "${config_file}.enc" \
        "$config_file" \
        --password "$master_pw"
}

# Usage
init-secure-config
echo "api_key=secret123" > "$CONFIG_DIR/secrets.conf"
encrypt-config "$CONFIG_DIR/secrets.conf"
```

### Integration Pattern 2: API Request Signing

```zsh
#!/usr/bin/env zsh
# api-client - HMAC-signed API client

source "$(which _crypto)"

API_BASE="https://api.example.com"
API_KEY="my_api_key"
API_SECRET="my_api_secret"

# Make signed API request
api-request() {
    local method="$1"
    local endpoint="$2"
    local body="${3:-}"

    # Build request data
    local timestamp=$(date -u +%s)
    local nonce=$(crypto-random-hex 16)

    # Create signature payload
    local payload="${method}${endpoint}${timestamp}${nonce}${body}"

    # Generate HMAC signature
    local signature=$(crypto-hmac sha256 "$API_SECRET" "$payload")

    # Make request
    curl -X "$method" \
        "${API_BASE}${endpoint}" \
        -H "X-API-Key: $API_KEY" \
        -H "X-Timestamp: $timestamp" \
        -H "X-Nonce: $nonce" \
        -H "X-Signature: $signature" \
        -d "$body"
}

# Usage
api-request "POST" "/api/transfer" '{"amount":100,"to":"user123"}'
```

### Integration Pattern 3: Password Manager

```zsh
#!/usr/bin/env zsh
# passmanager - Simple password manager

source "$(which _crypto)"

VAULT_FILE="$HOME/.password_vault.enc"
MASTER_PASSWORD=""

# Initialize vault
init-vault() {
    if [[ ! -f "$VAULT_FILE" ]]; then
        echo "{}" | crypto-encrypt --output "$VAULT_FILE"
        echo "Vault initialized"
    fi
}

# Add password to vault
add-password() {
    local service="$1"
    local username="$2"
    local password="${3:-$(crypto-random-base64 24)}"

    # Decrypt vault
    local vault=$(crypto-decrypt "$VAULT_FILE" --input-file)

    # Add entry (simple JSON)
    vault=$(echo "$vault" | jq --arg s "$service" \
                                 --arg u "$username" \
                                 --arg p "$password" \
                                 '.[$s] = {"username": $u, "password": $p}')

    # Encrypt and save
    echo "$vault" | crypto-encrypt --output "$VAULT_FILE"

    echo "Added: $service"
    echo "Password: $password"
}

# Get password from vault
get-password() {
    local service="$1"

    # Decrypt vault
    local vault=$(crypto-decrypt "$VAULT_FILE" --input-file)

    # Extract password
    echo "$vault" | jq -r --arg s "$service" '.[$s].password // empty'
}

# Usage
init-vault
add-password "github" "myusername"
get-password "github"
```

### Integration Pattern 4: File Integrity Monitoring

```zsh
#!/usr/bin/env zsh
# file-monitor - File integrity monitoring

source "$(which _crypto)"

HASH_DB="$HOME/.file_hashes.db"

# Initialize database
init-monitor() {
    touch "$HASH_DB"
}

# Add file to monitoring
monitor-file() {
    local file="$1"

    [[ ! -f "$file" ]] && { echo "File not found"; return 1; }

    # Compute hash
    local hash=$(crypto-sha256 "$file" --file)

    # Store in database
    echo "${file}:${hash}:$(date +%s)" >> "$HASH_DB"

    echo "Monitoring: $file"
}

# Check file integrity
check-file() {
    local file="$1"

    # Get stored hash
    local stored=$(grep "^${file}:" "$HASH_DB" | tail -1 | cut -d: -f2)

    if [[ -z "$stored" ]]; then
        echo "✗ File not monitored"
        return 1
    fi

    # Compute current hash
    local current=$(crypto-sha256 "$file" --file)

    if [[ "$current" == "$stored" ]]; then
        echo "✓ File integrity verified"
        return 0
    else
        echo "✗ FILE MODIFIED!"
        echo "  Expected: $stored"
        echo "  Current:  $current"
        return 1
    fi
}

# Check all monitored files
check-all() {
    local modified=0

    while IFS=: read -r file hash timestamp; do
        if ! check-file "$file" &>/dev/null; then
            echo "Modified: $file"
            ((modified++))
        fi
    done < "$HASH_DB"

    echo ""
    echo "Total modified: $modified"
}

# Usage
init-monitor
monitor-file "/etc/passwd"
monitor-file "/etc/shadow"
check-all
```

### Integration Pattern 5: Encrypted Backup System

```zsh
#!/usr/bin/env zsh
# encrypted-backup - Encrypted backup with integrity

source "$(which _crypto)"

BACKUP_DIR="$HOME/backups"
BACKUP_KEY_FILE="$HOME/.backup_key"

# Initialize backup system
init-backup() {
    mkdir -p "$BACKUP_DIR"

    # Generate encryption key
    if [[ ! -f "$BACKUP_KEY_FILE" ]]; then
        crypto-generate-key --size 32 > "$BACKUP_KEY_FILE"
        chmod 600 "$BACKUP_KEY_FILE"
    fi
}

# Create encrypted backup
create-backup() {
    local source="$1"
    local name="${2:-$(basename "$source")}"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${BACKUP_DIR}/${name}_${timestamp}.tar.gz.enc"

    # Create tarball
    tar czf - "$source" | {
        # Encrypt
        crypto-encrypt --output "$backup_file" \
                      --password "$(cat "$BACKUP_KEY_FILE")"
    }

    # Generate integrity hash
    local hash=$(crypto-sha256 "$backup_file" --file)
    echo "$hash" > "${backup_file}.sha256"

    # Store metadata
    cat > "${backup_file}.meta" <<EOF
source: $source
timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
hash: $hash
EOF

    echo "Backup created: $backup_file"
}

# Restore encrypted backup
restore-backup() {
    local backup_file="$1"
    local dest="${2:-.}"

    # Verify integrity
    local stored_hash=$(cat "${backup_file}.sha256")
    if ! crypto-verify-hash sha256 "$backup_file" "$stored_hash" --file; then
        echo "✗ Integrity check failed - backup corrupted"
        return 1
    fi

    echo "✓ Integrity verified"

    # Decrypt and extract
    crypto-decrypt "$backup_file" \
        --input-file \
        --password "$(cat "$BACKUP_KEY_FILE")" | \
    tar xzf - -C "$dest"

    echo "Restored to: $dest"
}

# Usage
init-backup
create-backup "$HOME/documents" "docs"
restore-backup "$BACKUP_DIR/docs_20251109_143000.tar.gz.enc" "/tmp/restore"
```

---

## Security Best Practices

<!-- CONTEXT_PRIORITY: HIGH -->
<!-- CONTEXT_GROUP: security -->

### Password Handling

**✓ DO:**
- Use strong, random passwords (20+ characters)
- Use `crypto-random-base64` for password generation
- Store passwords hashed with `crypto-hash-password`
- Use password managers (like the example above)
- Clear password variables after use

**✗ DON'T:**
- Log or echo passwords
- Store plaintext passwords in files
- Use weak passwords (<12 characters)
- Reuse passwords across services
- Pass passwords via command-line arguments (visible in `ps`)

**Example - Secure Password Input:**
```zsh
# Good: Hidden input
read -rs "password?Enter password: "
echo  # Newline after hidden input

# Bad: Visible input
read "password?Enter password: "  # Password visible!

# Bad: Command-line argument
./script.sh --password "mypassword"  # Visible in process list!
```

### Key Management

**✓ DO:**
- Store keys in `$CRYPTO_KEYRING_DIR` (mode 700)
- Use appropriate key sizes (RSA 2048+, AES 256)
- Rotate keys periodically
- Use different keys for different purposes
- Register cleanup with _lifecycle

**✗ DON'T:**
- Store keys in world-readable locations
- Use weak key sizes (RSA <2048, AES <128)
- Reuse keys across applications
- Commit keys to version control

**Example - Key Rotation:**
```zsh
# Rotate encryption key
old_key=$(cat "$keyfile")
new_key=$(crypto-generate-key)

# Re-encrypt data with new key
for file in encrypted/*.enc; do
    decrypted=$(crypto-decrypt "$file" --password "$old_key")
    echo "$decrypted" | crypto-encrypt --password "$new_key" > "${file}.new"
    mv "${file}.new" "$file"
done

# Update key
echo "$new_key" > "$keyfile"
```

### Encryption Best Practices

**✓ DO:**
- Use strong ciphers (AES-256, ChaCha20)
- Use authenticated encryption (GCM mode)
- Use high PBKDF2 iterations (100k+)
- Verify integrity after decryption
- Use salt (automatic in crypto-encrypt)

**✗ DON'T:**
- Use deprecated algorithms (MD5, DES, RC4)
- Use ECB mode (use CBC or GCM)
- Skip integrity verification
- Reuse initialization vectors (IVs)

**Example - Authenticated Encryption:**
```zsh
# Use GCM mode for authenticated encryption
export CRYPTO_DEFAULT_CIPHER="aes-256-gcm"

crypto-encrypt-file "data.txt" "data.enc"
# Automatically includes authentication tag
```

### Hash Verification

**✓ DO:**
- Always verify hashes for downloads
- Use SHA256 or stronger (not MD5)
- Verify checksums from trusted sources
- Use HMAC for message authentication

**✗ DON'T:**
- Trust unverified downloads
- Use MD5 for security (only compatibility)
- Skip hash verification
- Verify checksums from untrusted sources

### PBKDF2 Configuration

**Recommended Settings:**

```zsh
# Minimum (NIST 2023)
CRYPTO_PBKDF2_ITERATIONS=100000

# High security
CRYPTO_PBKDF2_ITERATIONS=200000

# Maximum security (slow)
CRYPTO_PBKDF2_ITERATIONS=500000

# Salt size (minimum 16 bytes)
CRYPTO_SALT_SIZE=16
```

### Security Checklist

Before deploying crypto-based scripts:

- [ ] Passwords never logged or echoed
- [ ] Keys stored with restrictive permissions (600/700)
- [ ] Strong algorithms used (AES-256, SHA256+)
- [ ] PBKDF2 iterations >= 100,000
- [ ] Integrity verification implemented
- [ ] Keys rotated regularly
- [ ] Cleanup registered with lifecycle
- [ ] Error handling prevents information leakage
- [ ] No secrets in environment variables (where avoidable)
- [ ] No secrets in command-line arguments

---

## Troubleshooting

<!-- CONTEXT_PRIORITY: MEDIUM -->

### Common Issues

**Issue: OpenSSL Not Found**
```
[ERROR] OpenSSL not found - required for crypto operations
```
**Solution:** Install OpenSSL: `sudo pacman -S openssl`

**Issue: Wrong Password**
```
Decryption failed
```
**Solution:** Verify password, check cipher matches encryption

**Issue: Corrupted Encrypted Data**
```
Error: Failed to decrypt
```
**Solution:** Verify file integrity, may be corrupted

**Issue: Permission Denied (Keyring)**
```
mkdir: cannot create directory
```
**Solution:** Check `CRYPTO_KEYRING_DIR` permissions

**Issue: GPG Not Found**
```
[ERROR] GPG not found
```
**Solution:** Install GPG: `sudo pacman -S gnupg`

**Issue: Slow Password Hashing**
```
crypto-hash-password takes 2+ seconds
```
**Solution:** This is intentional (security). Reduce `CRYPTO_PBKDF2_ITERATIONS` if needed (not recommended)

### Troubleshooting Index

| Issue | Function | Solution |
|-------|----------|----------|
| OpenSSL missing | crypto-check-openssl | Install openssl |
| Wrong password | crypto-decrypt | Verify password |
| Corrupted data | crypto-verify-hash | Re-download/re-encrypt |
| Permission denied | Key operations | Fix keyring permissions |
| GPG unavailable | crypto-check-gpg | Install gnupg |
| Slow hashing | crypto-hash-password | Expected behavior |

---

## Performance

<!-- CONTEXT_PRIORITY: LOW -->

| Operation | Complexity | Typical Runtime |
|-----------|------------|-----------------|
| crypto-random-hex | O(n) | ~10ms |
| crypto-sha256 (string) | O(n) | ~5ms |
| crypto-sha256 (file) | O(n) | Variable (I/O) |
| crypto-hash-password | O(1) | ~500ms (intentional) |
| crypto-encrypt (string) | O(n) | ~50ms |
| crypto-encrypt (file) | O(n) | Variable (I/O) |
| crypto-generate-rsa (2048) | O(1) | ~1-2s |
| crypto-generate-rsa (4096) | O(1) | ~5-10s |

**Notes:**
- Password hashing is intentionally slow (security)
- File operations depend on file size
- RSA generation time increases with key size
- Caching significantly improves repeat hash operations

---

## Version History

### v1.0.0 (Current)

**Released:** 2025-11-09

**Features:**
- 47 cryptographic functions
- Multiple hash algorithms (SHA256, SHA512, BLAKE2, MD5)
- Symmetric encryption (AES, ChaCha20)
- HMAC generation and verification
- Password hashing (PBKDF2)
- Key generation (RSA, Ed25519, symmetric)
- Random data generation (hex, base64, UUID, numbers)
- Base64 and URL encoding
- GPG integration
- Optional caching via _cache
- Lifecycle integration for cleanup

**Security:**
- PBKDF2 with 100,000 iterations (default)
- AES-256-CBC default cipher
- Secure keyring (mode 700)
- Cryptographically secure RNG
- NIST 2023 compliant defaults

**Quality:**
- 1,363 lines source code
- 3,450 lines documentation
- 85 usage examples
- 95% Enhanced v1.1 compliance
- 12-test self-test suite

**Dependencies:**
- OpenSSL (required)
- _common v2.0 (required)
- GPG (optional)
- ssh-keygen (optional)

---

**Documentation Maintained By:** lib-document agent
**Gold Standard Alignment:** 95% (Enhanced v1.1)
**Security Level:** HIGH (cryptographic operations)
**Last Updated:** 2025-11-09
**Document Version:** 1.0.0
