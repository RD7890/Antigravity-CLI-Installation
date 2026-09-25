#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

echo "=== Native Termux Antigravity CLI Setup ==="

[ "$(uname -m)" = "aarch64" ] || {
    echo "[ERROR] This device is not aarch64."
    exit 1
}

echo "[1/5] Updating Termux..."
apt update
apt full-upgrade -y

echo "[2/5] Installing prerequisites..."
apt install -y curl tar ca-certificates resolv-conf glibc-repo

echo "[3/5] Installing glibc..."
apt update
apt install -y glibc

echo "[4/5] Installing Antigravity CLI..."
curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash

echo "[5/5] Verifying..."
hash -r

command -v agy >/dev/null 2>&1 || {
    echo "[ERROR] agy was not installed."
    exit 1
}

[ -x "$PREFIX/glibc/lib/ld-linux-aarch64.so.1" ] || {
    echo "[ERROR] Termux glibc loader not found."
    exit 1
}

echo
echo "=== Antigravity CLI installed successfully ==="
agy --version
echo
echo "Run: agy"
