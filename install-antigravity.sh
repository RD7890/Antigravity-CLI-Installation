#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# ── ANSI Styles ───────────────────────────────────────────────────────────────
R="\033[0m";    B="\033[1m";    DIM="\033[2m";  IT="\033[3m"
RED="\033[91m"; GRN="\033[92m"; YLW="\033[93m"
BLU="\033[94m"; MGT="\033[95m"; CYN="\033[96m"; WHT="\033[97m"

# ── Banner ────────────────────────────────────────────────────────────────────
clear
printf "\n"
printf "${B}${CYN}     ___        __  _                        _ __      ${R}\n"
printf "${B}${CYN}    /   |  ____/ /_(_)___ __________ __   __(_) /___  __${R}\n"
printf "${B}${CYN}   / /| | / __  __/ / __  / ___/ __  / | / / / __/ / / /${R}\n"
printf "${B}${CYN}  / ___ |/ / / /_/ / /_/ / /  / /_/ /| |/ / / /_/ /_/ / ${R}\n"
printf "${B}${CYN} /_/  |_/_/  \__/_/\__, /_/   \__,_/ |___/_/\__/\__, /  ${R}\n"
printf "${B}${CYN}                   /____/    ${MGT}CLI Installer${CYN}        /____/  ${R}\n"
printf "\n"
printf " ${DIM}${WHT}  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
printf "   ${DIM}${CYN}Termux Native Installer  ·  Android aarch64${R}\n"
printf " ${DIM}${WHT}  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
printf "\n"
sleep 0.6

# ── Spinner ───────────────────────────────────────────────────────────────────
FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

_spin() {
    local msg="$1" pid="$2" i=0
    while kill -0 "$pid" 2>/dev/null; do
        local f="${FRAMES[$((i % ${#FRAMES[@]}))]}"
        printf "\r    ${CYN}${f}${R}  ${WHT}%s${DIM}...${R}  " "$msg"
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
    printf "\n  ${B}${BLU}◈ Step %s${R}  ${B}${WHT}%s${R}\n" "$1" "$2"
    printf "  ${DIM}  ─────────────────────────────────${R}\n"
}

# ── Error ─────────────────────────────────────────────────────────────────────
err() {
    printf "\n  ${B}${RED}✗  ERROR:${R}  %s\n\n" "$1" >&2
    exit 1
}

# ── Arch check ────────────────────────────────────────────────────────────────
[ "$(uname -m)" = "aarch64" ] || err "This device is not aarch64."

# ─────────────────────────────────────────────────────────────────────────────
step "1 / 6" "Requesting Storage Permission"
printf "\n    ${YLW}⚠${R}  ${DIM}Allow storage access in the dialog that appears...${R}\n\n"
termux-setup-storage
sleep 3

step "2 / 6" "Updating Termux"
run_quiet "Updating package lists"  apt-get update -y
run_quiet "Upgrading packages"      apt-get full-upgrade -y

step "3 / 6" "Installing Prerequisites"
run_quiet "curl · tar · ca-certificates · glibc-repo" \
    apt-get install -y curl tar ca-certificates resolv-conf glibc-repo

step "4 / 6" "Installing glibc"
run_quiet "Refreshing package lists" apt-get update -y
run_quiet "Installing glibc"         apt-get install -y glibc

step "5 / 6" "Installing Antigravity CLI"
run_quiet "Fetching and running official installer" \
    bash -c 'curl -fsSL https://raw.githubusercontent.com/wallentx/antigravity-cli-termux/dev/install.sh | bash'

step "6 / 6" "Verifying Installation"
hash -r
run_quiet "Checking agy binary"          command -v agy
run_quiet "Checking glibc loader"        test -x "$PREFIX/glibc/lib/ld-linux-aarch64.so.1"

# ── Success ───────────────────────────────────────────────────────────────────
printf "\n"
printf " ${DIM}${WHT}  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
printf "\n"
printf "   ${B}${GRN}⚡  Antigravity CLI installed successfully!${R}\n\n"
printf "   ${DIM}Version :${R}  ${CYN}$(agy --version 2>/dev/null || echo 'unknown')${R}\n"
printf "   ${DIM}Run     :${R}  ${B}${WHT}agy${R}\n"
printf "\n"
printf " ${DIM}${WHT}  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${R}\n"
printf "\n"
