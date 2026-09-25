#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

echo "=== Native Termux Antigravity CLI Setup ==="

[ "$(uname -m)" = "aarch64" ] || {
    echo "[ERROR] This device is not aarch64."
    exit 1
}

echo "[1/6] Requesting storage permission..."
if command -v termux-setup-storage >/dev/null 2>&1; then
    termux-setup-storage
    sleep 3
else
    echo "[WARN] termux-setup-storage not found — skipping (install Termux:API if needed)."
fi

echo "[2/6] Updating Termux..."
apt update
apt full-upgrade -y

echo "[3/6] Installing prerequisites..."
apt install -y curl tar ca-certificates resolv-conf glibc-repo

echo "[4/6] Installing glibc..."
apt update
apt install -y glibc

echo "[5/6] Installing Antigravity CLI..."
curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash

echo "[6/6] Verifying..."
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
