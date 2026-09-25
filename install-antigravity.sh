#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# ── ANSI Styles ───────────────────────────────────────────────────────────────
R="\033[0m";    B="\033[1m";    DIM="\033[2m"
RED="\033[91m"; GRN="\033[92m"; YLW="\033[93m"
BLU="\033[94m"; CYN="\033[96m"; WHT="\033[97m"

# ── Banner ────────────────────────────────────────────────────────────────────
clear
printf "  ${B}${GRN}Antigravity CLI${R}  ${DIM}—  Termux Installer  ·  aarch64${R}\n"
printf "  ${DIM}${WHT}⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"

# ── Spinner ───────────────────────────────────────────────────────────────────
FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

_spin() {
    local msg="$1" pid="$2" i=0
    while kill -0 "$pid" 2>/dev/null; do
        local f="${FRAMES[$((i % ${#FRAMES[@]}))]}"
        printf "\r    ${GRN}${f}${R}  ${WHT}%s${DIM}...${R}  " "$msg"
        sleep 0.08
        i=$((i + 1))
    done
    printf "\r    ${GRN}✓${R}  ${WHT}%s${R}%30s\n" "$msg" ""
}

run_quiet() {
    local msg="$1"; shift
    "$@" >/dev/null 2>&1 &
    local pid=$!
    _spin "$msg" "$pid"
    wait "$pid"
}

# ── Step header ───────────────────────────────────────────────────────────────
step() {
    printf "  ${B}${GRN}◈ %s${R}  ${WHT}%s${R}\n" "$1" "$2"
}

# ── Error ─────────────────────────────────────────────────────────────────────
err() {
    printf "\n  ${B}${RED}✗  ERROR:${R}  %s\n\n" "$1" >&2
    exit 1
}

# ── Arch check ────────────────────────────────────────────────────────────────
[ "$(uname -m)" = "aarch64" ] || err "This device is not aarch64."

# ─────────────────────────────────────────────────────────────────────────────
step "1/6" "Requesting Storage Permission"
printf "    ${YLW}⚠${R}  ${DIM}Allow storage access in the dialog...${R}\n"
termux-setup-storage
sleep 3
step "2/6" "Updating Termux"
run_quiet "Updating package lists"  apt-get update -y
run_quiet "Upgrading packages"      apt-get full-upgrade -y
step "3/6" "Installing Prerequisites"
run_quiet "curl · tar · ca-certificates · glibc-repo" \
    apt-get install -y curl tar ca-certificates resolv-conf glibc-repo
step "4/6" "Installing glibc"
run_quiet "Refreshing package lists" apt-get update -y
run_quiet "Installing glibc"         apt-get install -y glibc
step "5/6" "Installing Antigravity CLI"
_INSTALLED_VER="$(agy --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
_LATEST_VER="$(curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh 2>/dev/null \
    | grep -oE 'VERSION=[^ ]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
if command -v agy >/dev/null 2>&1 && { [ -z "$_LATEST_VER" ] || [ "$_INSTALLED_VER" = "$_LATEST_VER" ]; }; then
    printf "    ${GRN}✓${R}  ${WHT}Already installed${R}  ${DIM}(${_INSTALLED_VER:-latest})${R}\n"
else
    [ -n "$_LATEST_VER" ] && [ -n "$_INSTALLED_VER" ] && \
        printf "    ${YLW}↑${R}  ${DIM}Update: v${_INSTALLED_VER} → v${_LATEST_VER}${R}\n"
    run_quiet "Fetching and running official installer" \
        bash -c 'curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash'
fi
step "6/6" "Verifying"
hash -r
run_quiet "Checking agy binary"   bash -c 'command -v agy'
run_quiet "Checking glibc loader" test -x "$PREFIX/glibc/lib/ld-linux-aarch64.so.1"
printf "  ${DIM}${WHT}⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
printf "  ${B}${GRN}⚡  Ready!${R}  ${DIM}Version:${R} ${GRN}${_INSTALLED_VER:-$(agy --version 2>/dev/null || echo 'latest')}${R}\n"
printf "\n"
printf "  ${B}${WHT}Basic Commands${R}\n"
printf "  ${GRN}›${R}  ${B}agy${R}               ${DIM}Start interactive session${R}\n"
printf "  ${GRN}›${R}  ${B}agy chat${R}          ${DIM}Start a new chat${R}\n"
printf "  ${GRN}›${R}  ${B}agy --help${R}        ${DIM}Show all commands${R}\n"
printf "  ${GRN}›${R}  ${B}agy --version${R}     ${DIM}Show installed version${R}\n"
printf "  ${DIM}${WHT}⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
