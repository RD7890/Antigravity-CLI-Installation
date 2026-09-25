#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# ── Spinner helper ────────────────────────────────────────────────────────────
_spin() {
    local msg="$1" pid="$2" i=0
    local frames=("." ".." "...")
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r  %s%s   " "$msg" "${frames[$((i % 3))]}"
        sleep 0.4
        i=$((i + 1))
    done
    printf "\r  %s... done ✓\n" "$msg"
}

run_quiet() {
    local msg="$1"; shift
    "$@" >/dev/null 2>&1 &
    local pid=$!
    _spin "$msg" "$pid"
    wait "$pid"
}
# ─────────────────────────────────────────────────────────────────────────────

echo "=== Native Termux Antigravity CLI Setup ==="
echo

[ "$(uname -m)" = "aarch64" ] || {
    echo "[ERROR] This device is not aarch64."
    exit 1
}

echo "[1/6] Requesting storage permission..."
termux-setup-storage
sleep 3
echo

echo "[2/6] Updating Termux..."
run_quiet "Updating package lists" apt-get update -y
run_quiet "Upgrading packages" apt-get full-upgrade -y
echo

echo "[3/6] Installing prerequisites..."
run_quiet "Installing curl, tar, ca-certificates, glibc-repo" \
    apt-get install -y curl tar ca-certificates resolv-conf glibc-repo
echo

echo "[4/6] Installing glibc..."
run_quiet "Refreshing package lists" apt-get update -y
run_quiet "Installing glibc" apt-get install -y glibc
echo

echo "[5/6] Installing Antigravity CLI..."
run_quiet "Downloading and installing agy" \
    bash -c 'curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash'
echo

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
