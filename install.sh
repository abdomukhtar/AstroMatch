#!/usr/bin/env bash
set -euo pipefail

APP_NAME="AstroMatch"
APP_ID="io.github.abdomukhtar.astromatch"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
ICON_DIR="$HOME/.local/share/icons/hicolor"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/$APP_ID.desktop"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

step() { echo -e "${BOLD}  →  $1${NC}"; }
ok()   { echo -e "${GREEN}  ✓  $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠  $1${NC}"; }
err()  { echo -e "${RED}  ✗  $1${NC}"; exit 1; }

echo ""
echo -e "${BOLD}AstroMatch Installer${NC}"
echo "────────────────────────────────────────"
echo ""

[ -f "$SCRIPT_DIR/index.html" ]               || err "index.html not found. Run this script from the AstroMatch folder."
[ -f "$SCRIPT_DIR/assets/icons/icon-512.png" ] || err "Icon assets missing. The archive may be incomplete."

[ -d "$INSTALL_DIR" ] && warn "Previous installation found — updating."

# Copy application files
step "Copying application files..."
mkdir -p "$INSTALL_DIR"
cp -a "$SCRIPT_DIR/." "$INSTALL_DIR/"
ok "Files installed to $INSTALL_DIR"

# Install icons at all standard resolutions
step "Installing icons..."
declare -A SIZES=(
    ["16x16"]="favicon-16.png"
    ["32x32"]="favicon-32.png"
    ["192x192"]="icon-192.png"
    ["512x512"]="icon-512.png"
)
for size in "${!SIZES[@]}"; do
    src="$SCRIPT_DIR/assets/icons/${SIZES[$size]}"
    dst="$ICON_DIR/$size/apps"
    if [ -f "$src" ]; then
        mkdir -p "$dst"
        cp "$src" "$dst/$APP_ID.png"
    fi
done
if [ -f "$SCRIPT_DIR/assets/icons/icon-1024.png" ]; then
    mkdir -p "$ICON_DIR/1024x1024/apps"
    cp "$SCRIPT_DIR/assets/icons/icon-1024.png" "$ICON_DIR/1024x1024/apps/$APP_ID.png"
fi
ok "Icons registered"

# Write desktop entry
step "Creating desktop entry..."
mkdir -p "$DESKTOP_DIR"
cat > "$DESKTOP_FILE" << ENTRY
[Desktop Entry]
Version=1.0
Type=Application
Name=AstroMatch
GenericName=Space Memory Card Game
Comment=AstroMatch — 2-Player Space Memory Game
Exec=xdg-open file://$INSTALL_DIR/index.html
Icon=$APP_ID
Terminal=false
Categories=Game;CardGame;LogicGame;
Keywords=memory;cards;space;game;astro;match;multiplayer;
StartupNotify=true
ENTRY
chmod 644 "$DESKTOP_FILE"
ok "Desktop entry created"

# Refresh caches
step "Refreshing system caches..."
command -v gtk-update-icon-cache   &>/dev/null && gtk-update-icon-cache -f -t "$ICON_DIR" 2>/dev/null || true
command -v update-desktop-database &>/dev/null && update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
command -v xdg-desktop-menu        &>/dev/null && xdg-desktop-menu forceupdate 2>/dev/null || true
ok "Caches updated"

echo ""
echo "────────────────────────────────────────"
echo -e "${GREEN}${BOLD}  Installation complete!${NC}"
echo ""
echo "  Search for \"AstroMatch\" in your application launcher,"
echo "  or run directly:"
echo ""
echo -e "  ${BOLD}xdg-open file://$INSTALL_DIR/index.html${NC}"
echo ""
