#!/usr/bin/env bash
set -e

RUM_REPO="https://github.com/your-org/rumbod-cli"
RUM_VERSION="0.1.0"

echo "╭─────────────────────────────────────╮"
echo "│      rumbod-cli  Setup Wizard       │"
echo "╰─────────────────────────────────────╯"
echo ""

# ── Ensure uv ──
if ! command -v uv &>/dev/null; then
    echo "→ Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# ── Install rumbod-cli ──
echo "→ Installing rumbod-cli v${RUM_VERSION}..."
uv tool install --force rumbod-cli 2>/dev/null || {
    # Install from local wheel if uv tool install fails
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    if [ -f "$SCRIPT_DIR/rumbod_cli-${RUM_VERSION}-py3-none-any.whl" ]; then
        uv tool install --force "$SCRIPT_DIR/rumbod_cli-${RUM_VERSION}-py3-none-any.whl"
    else
        pip install rumbod-cli --break-system-packages 2>/dev/null || \
        pip install "$SCRIPT_DIR/rumbod_cli-${RUM_VERSION}-py3-none-any.whl" --break-system-packages
    fi
}

# ── Create ~/.rum/ structure ──
mkdir -p ~/.rum/{skills,agent-monitor,ponytail,hooks,steering,logs,sessions}
touch ~/.rum/knowledge-base.md 2>/dev/null || true

# ── Interactive API key setup ──
if [ -z "$RUMBOD_NVIDIA_API_KEY" ] && [ ! -f ~/.rum/apikeys.json ]; then
    echo ""
    echo "→ API Key Setup (one-time)"
    echo "  (You can skip all and set env vars later)"
    echo ""
    
    read -rp "  NVIDIA NIM API Key (optional): " nvidia_key
    if [ -n "$nvidia_key" ]; then
        echo "export RUMBOD_NVIDIA_API_KEY='$nvidia_key'" >> ~/.bashrc
        export RUMBOD_NVIDIA_API_KEY="$nvidia_key"
        echo "    ✓ Saved to ~/.bashrc"
    fi
    
    read -rp "  OpenAI API Key (optional): " openai_key
    if [ -n "$openai_key" ]; then
        echo "export RUMBOD_OPENAI_API_KEY='$openai_key'" >> ~/.bashrc
        export RUMBOD_OPENAI_API_KEY="$openai_key"
        echo "    ✓ Saved to ~/.bashrc"
    fi
    
    read -rp "  Anthropic API Key (optional): " anthropic_key
    if [ -n "$anthropic_key" ]; then
        echo "export RUMBOD_ANTHROPIC_API_KEY='$anthropic_key'" >> ~/.bashrc
        export RUMBOD_ANTHROPIC_API_KEY="$anthropic_key"
        echo "    ✓ Saved to ~/.bashrc"
    fi
    
    echo ""
    echo "  ✓ API keys configured. Edit ~/.bashrc to change later."
fi

# ── Verify ──
echo ""
echo "→ Verifying installation..."
if command -v rum-interactive-cli &>/dev/null; then
    echo "  ✓ rum-interactive-cli installed"
else
    echo "  ⚠ rum-interactive-cli not in PATH. Run: source ~/.bashrc"
fi
if command -v rum-cli &>/dev/null; then
    echo "  ✓ rum-cli installed"
fi

echo ""
echo "╭─────────────────────────────────────╮"
echo "│  Setup complete!                    │"
echo "│                                     │"
echo "│  Run:  rum-interactive-cli          │"
echo "│        rum-cli chat 'hello'         │"
echo "╰─────────────────────────────────────╯"
