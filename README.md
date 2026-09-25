# 🚀 Antigravity CLI — Termux Installation Guide

> **Antigravity CLI (`agy`)** is Google's AI-first development platform. This repo provides a one-shot install script for **Android (Termux, aarch64)**.

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| **Device** | Android phone/tablet (64-bit ARM — `aarch64`) |
| **App** | [Termux](https://f-droid.org/packages/com.termux/) from F-Droid *(not Play Store)* |
| **Storage** | ~500 MB free |
| **Internet** | Active connection required |

> ⚠️ **Important:** Use the **F-Droid** version of Termux, not the Google Play Store version. The Play Store version has outdated binaries.

---

## ⚡ Quick Install (One-Liner)

Open Termux and run:

```bash
curl -fsSL https://raw.githubusercontent.com/RD7890/Antigravity-CLI-Installation/main/install-antigravity.sh | bash
```

---

## 📥 Manual Installation

If you prefer to inspect the script before running it:

```bash
# 1. Download the script
curl -fsSL https://raw.githubusercontent.com/RD7890/Antigravity-CLI-Installation/main/install-antigravity.sh -o install-antigravity.sh

# 2. Review it (optional but recommended)
cat install-antigravity.sh

# 3. Make it executable
chmod +x install-antigravity.sh

# 4. Run it
bash install-antigravity.sh
```

---

## 🔍 What the Script Does

The script runs **5 automated steps**:

| Step | Action |
|------|--------|
| `1/5` | Updates Termux packages (`apt update && apt full-upgrade`) |
| `2/5` | Installs prerequisites: `curl`, `tar`, `ca-certificates`, `resolv-conf`, `glibc-repo` |
| `3/5` | Installs `glibc` (required to run Linux binaries on Termux) |
| `4/5` | Downloads and runs the official Antigravity CLI installer |
| `5/5` | Verifies that `agy` binary and glibc loader are correctly installed |

---

## ✅ Verify Installation

After installation completes, verify it works:

```bash
agy --version
```

You should see the installed version of the Antigravity CLI printed.

---

## 🚀 Getting Started with `agy`

```bash
# Launch the Antigravity CLI interactive session
agy

# Start a new chat
agy chat

# Get help
agy --help
```

---

## 🛠️ Troubleshooting

### `agy: command not found`
Restart your Termux session or run:
```bash
hash -r
source ~/.bashrc
```

### `ERROR: This device is not aarch64`
This script only supports **64-bit ARM** Android devices. Check your device architecture:
```bash
uname -m
```

### `glibc loader not found`
Re-run the script. If it persists, manually install:
```bash
apt install -y glibc-repo
apt update
apt install -y glibc
```

### Network/SSL errors
```bash
apt install -y ca-certificates
apt install -y resolv-conf
```

---

## 📁 Repository Contents

```
Antigravity-CLI-Installation/
├── install-antigravity.sh   # Main installer script
└── README.md                # This guide
```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<p align="center">Made with ❤️ for the Antigravity + Termux community</p>
