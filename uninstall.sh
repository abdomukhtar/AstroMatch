#!/usr/bin/env bash
set -euo pipefail

APP_NAME="AstroMatch"
APP_ID="io.github.abdomukhtar.astromatch"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
ICON_DIR="$HOME/.local/share/icons/hicolor"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_ID.desktop"

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BOLD}AstroMatch Uninstaller${NC}"
echo "────────────────────────────────────────"
echo ""

removed=0

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "  ✓  Removed $INSTALL_DIR"
    removed=1
fi

if [ -f "$DESKTOP_FILE" ]; then
    rm -f "$DESKTOP_FILE"
    echo "  ✓  Removed desktop entry"
    removed=1
fi

for size in 16x16 32x32 192x192 512x512 1024x1024; do
    icon="$ICON_DIR/$size/apps/$APP_ID.png"
    [ -f "$icon" ] && rm -f "$icon"
done
echo "  ✓  Removed icons"

command -v gtk-update-icon-cache   &>/dev/null && gtk-update-icon-cache -f -t "$ICON_DIR" 2>/dev/null || true
command -v update-desktop-database &>/dev/null && update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo ""
if [ $removed -eq 0 ]; then
    echo -e "${RED}  AstroMatch does not appear to be installed.${NC}"
else
    echo -e "${GREEN}${BOLD}  AstroMatch uninstalled successfully.${NC}"
fi
echo ""
