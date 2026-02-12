#
# Shinerio Plugin — One-click installer for Claude Code (Windows PowerShell)
#
# Usage:
#   .\install.ps1
#

$ErrorActionPreference = "Stop"

$REPO             = "shinerio/shinerio-plugin"
$MARKETPLACE_NAME = "shinerio-marketplace"
$PLUGIN_NAME      = "shinerio-plugin"

function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║    🚀 Shinerio Plugin Installer for Claude Code  ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Info    { param([string]$Msg) Write-Host "[INFO]  $Msg" -ForegroundColor Blue }
function Write-OK      { param([string]$Msg) Write-Host "[OK]    $Msg" -ForegroundColor Green }
function Write-Warn    { param([string]$Msg) Write-Host "[WARN]  $Msg" -ForegroundColor Yellow }
function Write-Fail    { param([string]$Msg) Write-Host "[FAIL]  $Msg" -ForegroundColor Red; exit 1 }

# ── Pre-flight checks ──────────────────────────────────────────────
Write-Header

# Check Claude Code is installed
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-Fail "Claude Code CLI not found. Please install it first: https://docs.anthropic.com/claude/docs/claude-code"
}

try {
    $claudeVersion = & claude --version 2>&1
    Write-Info "Claude Code version: $claudeVersion"
} catch {
    Write-Info "Claude Code version: unknown"
}

# ── Step 1: Add marketplace ────────────────────────────────────────
Write-Info "Adding Shinerio marketplace ($REPO)..."
try {
    & claude plugin marketplace add $REPO 2>&1 | Out-Null
    Write-OK "Marketplace added successfully."
} catch {
    Write-Warn "Marketplace may already be added, continuing..."
}

# ── Step 2: Install plugin ─────────────────────────────────────────
Write-Info "Installing plugin: ${PLUGIN_NAME}@${MARKETPLACE_NAME}..."
try {
    & claude plugin install "${PLUGIN_NAME}@${MARKETPLACE_NAME}" 2>&1 | Out-Null
    Write-OK "Plugin installed successfully!"
} catch {
    Write-Warn "Plugin install command returned an error — it may already be installed."
}

# ── Step 3: Check PicGO availability ────────────────────────────────
Write-Info "Checking PicGO server on port 36677..."
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:36677/api/upload" -TimeoutSec 2 -ErrorAction Stop
    Write-OK "PicGO server is running on port 36677."
} catch {
    Write-Warn "PicGO server not detected on port 36677."
    Write-Warn "To use image upload, start PicGO and ensure the HTTP server is enabled (port 36677)."
}

# ── Done ────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║    ✅  Installation complete!                     ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Available skills:" -ForegroundColor White
Write-Host "  /shinerio-plugin:markmap  — Generate mindmaps from Markdown" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available agents:" -ForegroundColor White
Write-Host "  @test-case-executor      — Run & analyze test cases" -ForegroundColor Cyan
Write-Host ""
Write-Host "Custom command (bundled with plugin):" -ForegroundColor White
Write-Host "  /shinerio-plugin:emb-mindmap [file]  — Quick shortcut for markmap skill" -ForegroundColor Cyan
Write-Host ""
Write-Host "Start Claude Code normally (no --plugin-dir needed!):" -ForegroundColor White
Write-Host "  claude" -ForegroundColor Cyan
Write-Host ""
