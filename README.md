# Antigravity CLI — Termux Installation Guide

> **Antigravity CLI (`agy`)** is Google's AI-first development platform. This repo provides a one-shot install script for **Android (Termux, aarch64)**.

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| **Device** | Android phone/tablet (64-bit ARM — `aarch64`) |
| **App** | Termux from F-Droid *(not Play Store)* |
| **Storage** | ~500 MB free |
| **Internet** | Active connection required |

> ⚠️ **Important:** Use the **F-Droid** version of Termux, not the Google Play Store version. The Play Store version has outdated binaries.

### Download Termux

<a href="https://f-droid.org/packages/com.termux/">
  <img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="75">
</a>

&nbsp;&nbsp;or&nbsp;&nbsp;

<a href="https://github.com/termux/termux-app/releases/latest">
  <img src="https://img.shields.io/github/v/release/termux/termux-app?color=black&label=Download%20Termux%20APK&logo=github&style=for-the-badge" alt="Download Termux APK from GitHub">
</a>

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

The script runs **6 automated steps**:

| Step | Action |
|------|--------|
| `1/6` | Requests Android storage permission via `termux-setup-storage` |
| `2/6` | Updates Termux packages (`apt update && apt full-upgrade`) |
| `3/6` | Installs prerequisites: `curl`, `tar`, `ca-certificates`, `resolv-conf`, `glibc-repo` |
| `4/6` | Installs `glibc` (required to run Linux binaries on Termux) |
| `5/6` | Downloads and runs the official Antigravity CLI installer *(skipped if already up-to-date)* |
| `6/6` | Verifies that `agy` binary and glibc loader are correctly installed |

---

## ✅ Verify Installation

After installation completes, verify it works:

```bash
agy --version
```

---

## 🚀 Basic Commands

```bash
agy               # Start interactive session
agy chat          # Start a new chat
agy --help        # Show all commands
agy --version     # Show installed version
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
