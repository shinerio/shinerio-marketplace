#!/usr/bin/env bash
#
# Shinerio Plugin — One-click installer for Claude Code
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/shinerio/shinerio-plugin/main/install.sh | bash
#   — or —
#   git clone https://github.com/shinerio/shinerio-plugin.git && cd shinerio-plugin && bash install.sh
#

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

REPO="shinerio/shinerio-plugin"
MARKETPLACE_NAME="shinerio-marketplace"
PLUGIN_NAME="shinerio-plugin"

# ── Helpers ─────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()    { echo -e "${RED}[FAIL]${NC}  $*"; exit 1; }

# ── Pre-flight checks ──────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║    🚀 Shinerio Plugin Installer for Claude Code  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Check Claude Code is installed
if ! command -v claude &> /dev/null; then
    fail "Claude Code CLI not found. Please install it first: https://docs.anthropic.com/claude/docs/claude-code"
fi

CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
info "Claude Code version: ${CLAUDE_VERSION}"

# ── Step 1: Add marketplace ────────────────────────────────────────
info "Adding Shinerio marketplace (${REPO})..."
if claude plugin marketplace add "${REPO}" 2>/dev/null; then
    success "Marketplace added successfully."
else
    warn "Marketplace may already be added, continuing..."
fi

# ── Step 2: Install plugin ─────────────────────────────────────────
info "Installing plugin: ${PLUGIN_NAME}@${MARKETPLACE_NAME}..."
if claude plugin install "${PLUGIN_NAME}@${MARKETPLACE_NAME}" 2>/dev/null; then
    success "Plugin installed successfully!"
else
    warn "Plugin install command returned an error — it may already be installed."
fi

# ── Step 3: Check PicGO availability ────────────────────────────────
info "Checking PicGO server on port 36677..."
if command -v curl &> /dev/null; then
    if curl -s --connect-timeout 2 http://127.0.0.1:36677/api/upload > /dev/null 2>&1; then
        success "PicGO server is running on port 36677."
    else
        warn "PicGO server not detected on port 36677."
        warn "To use image upload, start PicGO and ensure the HTTP server is enabled (port 36677)."
    fi
else
    warn "curl not found — skipping PicGO check. Ensure PicGO is running on port 36677 for image upload."
fi

# ── Done ────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    ✅  Installation complete!                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Available skills:"
echo -e "  ${CYAN}/shinerio-plugin:markmap${NC}  — Generate mindmaps from Markdown"
echo ""
echo -e "Available agents:"
echo -e "  ${CYAN}@test-case-executor${NC}      — Run & analyze test cases"
echo ""
echo -e "Custom command (bundled with plugin):"
echo -e "  ${CYAN}/shinerio-plugin:emb-mindmap [file]${NC}  — Quick shortcut for markmap skill"
echo ""
echo -e "Start Claude Code normally (no ${YELLOW}--plugin-dir${NC} needed!):"
echo -e "  ${CYAN}claude${NC}"
echo ""
