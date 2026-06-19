# rumbod-cli

**AI agent CLI** — NVIDIA NIM, OpenAI, Anthropic — sub-agents, web search, Docker, GitHub, databases, and autonomous task loops.

```
      ╭─────────────────────────────────────╮
      │     rumbod interactive              │
      │  NVIDIA · OpenAI · Anthropic         │
      │  type / for menu · /help            │
      ╰─────────────────────────────────────╯
```

---

## One-Liner Install

### Option A: curl (recommended)
```bash
bash -c "$(curl -sL https://raw.githubusercontent.com/rumboom/rumbod-cli/main/install.sh)"
```

### Option B: wget
```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/rumboom/rumbod-cli/main/install.sh)"
```

### Option C: Base64 self-extracting
Save [dist/files/rum-install.sh](dist/files/rum-install.sh), then:
```bash
bash rum-install.sh
```

### Option D: pip / uv
```bash
pip install rumbod-cli --break-system-packages
# or
uv tool install rumbod-cli
```

---

## First Run

On first install, you'll be prompted for API keys (press Enter to skip any):

```
→ API Key Setup (press Enter to skip any)

  NVIDIA NIM API Key: nvapi-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  OpenAI API Key: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Anthropic API Key: sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

You can also set them via environment variables or `/apikey add`:

```bash
export RUMBOD_NVIDIA_API_KEY="nvapi-..."
export RUMBOD_OPENAI_API_KEY="sk-..."
export RUMBOD_ANTHROPIC_API_KEY="sk-ant-..."
```

---

## Usage

```bash
# Interactive TUI (full-featured)
rum-interactive-cli

# Quick chat
rum-cli chat "find the FVG strategy in /root/ECC and explain it"

# Sub-agent for complex tasks
rum-cli spawn "audit all strategy files and report metrics"

# API usage tracking
rum-cli apiusage
```

### Slash Commands (inside TUI)

| Command | Description |
|---------|-------------|
| `/model` | Switch model (`/model list`) |
| `/web_search` | Search the web |
| `/spawn` | Sub-agent for delegated work |
| `/task` | Autonomous multi-step task loop |
| `/strategies` | Find Claude Code strategy files |
| `/github` | GitHub issues, PRs, repos |
| `/docker` | Docker ps, logs, stats |
| `/db` | SQLite queries |
| `/apiusage` | Token usage report |
| `/apikey` | Manage API keys |
| `/provider` | Provider config |
| `/kb` | Knowledge base |
| `/skill` | Load skills |
| `/doctor` | Diagnostics |
| `/compact` | Clear conversation history |

---

## Slash Commands

| Slash | What it does |
|-------|-------------|
| `/help` | Show all commands |
| `/context` | Project scan (languages, git, tree) |
| `/doctor` | Test provider connectivity |
| `/sessions` | List conversation sessions |
| `/clear` | Clear screen |
| `/cancel` | Cancel current operation |
| `/ponytail` | Lazy dev mode (lite/full/ultra) |
| `/upgrade` | Self-upgrade via uv |
| `/monitor` | Health check |
| `/spec` | Feature specs |

---

## Architecture

```
rumbod_cli/
├── interactive.py    # TUI with 20+ slash commands, tool-calling loop
├── models.py         # NVIDIA/OpenAI/Anthropic providers with streaming
├── subagent.py       # Plan→execute agent loop with JSON repair
├── task_loop.py      # Autonomous task loop + parallel execution
├── context.py        # Project scanning, system prompt
├── providers.py      # Provider config, round-robin, key resolution
├── apiusage.py       # Persistent per-model token tracking
├── apikeys.py        # API key management
├── tools/            # 10 tool modules (shell, git, network, Docker, DB, ...)
│   ├── shell.py      # Shell execution with security validation
│   ├── git.py        # Git status/diff
│   ├── websearch.py  # DuckDuckGo + httpx fetch
│   ├── network.py    # Ping, DNS, ports, HTTP
│   ├── docker_.py    # Docker management
│   ├── github_.py    # GitHub API
│   ├── database.py   # SQLite queries
│   ├── process.py    # Process management
│   └── filesystem.py # File read/write/glob
└── specs/            # Feature specifications
```

### Key Design Decisions

- **No shell=True** — Commands run via `asyncio.create_subprocess_exec` (safe by default)
- **Allowlist security** — Only approved commands execute; shell injection chars blocked
- **Self-contained** — `~/.rum/` directory, completely separate from `~/.claude/`
- **Anti-fabrication** — System prompt forbids simulated data; runtime guard detects fake output
- **Multi-provider** — NVIDIA NIM (free tier) primary, OpenAI/Anthropic fallback with auto-rotate

---

## Tests

```bash
# Run all 181 tests
pytest tests/ -v

# Specific modules
pytest tests/test_models.py -v
pytest tests/test_subagent.py -v
pytest tests/test_tools.py -v
```

---

## License

MIT
