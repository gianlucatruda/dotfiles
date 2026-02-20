# AGENTS.md

Guide for coding agents working with this dotfiles repository.

## Philosophy

**Clarity over cleverness. Simplicity over flexibility. The right amount of complexity is the minimum needed.**

Personal dotfiles for Bash + Tmux + Neovim on macOS. Forked from Mathias Bynens in 2017, heavily customized since.

Core values:
- **Modular** - Each component has single responsibility, separate files
- **Simple** - No over-engineering. Three similar lines beats premature abstraction
- **Performant** - Lazy load where appropriate. Minimal dependencies
- **Maintainable** - Code is self-documenting. Comments explain "why", not "what"

---

## Architecture

### Shell Configuration
- `.bash_profile` - Entry point, loads everything
- `.config/.aliases` - Simple command shortcuts
- `.config/.functions` - Complex bash functions
- `.config/.exports` - Environment variables
- `.config/.extra` - Private/local configs (not committed, create manually)

Load order matters. All sourced from `.bash_profile`.

### Neovim Configuration
- Plugin manager: `lazy.nvim`
- Plugin declarations in `lua/core/plugins.lua`
- Individual plugin configs in `lua/plugin_config/`
- `lua/plugin_config/init.lua` loads all configs (ORDER MATTERS)

### Other
- `bootstrap.sh` - Syncs dotfiles to home directory
- `scripts/` - Standalone utilities with `gt-` prefix
- `.config/homebrew/Brewfile` - Package declarations

---

## Adding Components

### Neovim Plugin
1. Add declaration to `lua/core/plugins.lua`
2. Create config file in `lua/plugin_config/pluginname.lua`
3. Load it in `lua/plugin_config/init.lua`

Keymap conventions: Leader is `<Space>`, use descriptive text like `{ desc = '[S]earch [F]iles' }`, mnemonic letters after leader.

### Shell Component
- Aliases → `.config/.aliases`
- Functions → `.config/.functions`
- Scripts → `scripts/gt-*`

### Homebrew Package
Edit `.config/homebrew/Brewfile` directly, or install and dump:
```bash
brew install package
brew bundle dump --force --file .config/homebrew/Brewfile
```

---

## Rules for Agents

### Always
- Read existing code first to understand patterns
- Match existing style and conventions
- Keep it minimal - only add what's explicitly needed
- Maintain modularity (right file for right purpose)
- The code is the source of truth - read it to understand specifics

### Validation (Neovim)
- When verifying Neovim changes, run with isolated XDG paths so installs and caches do not touch the user's live config; suggest this workflow to users.
- Example:
```bash
XDG_CONFIG_HOME="$PWD/.config" \
XDG_DATA_HOME="$(mktemp -d)" \
XDG_STATE_HOME="$(mktemp -d)" \
XDG_CACHE_HOME="$(mktemp -d)" \
nvim --headless "+checkhealth" "+qall"
```

### Never
- Run tests (user will do this)
- Change keybindings without explicit request
- Add unnecessary plugins/dependencies
- Create documentation files proactively
- Over-comment self-evident code
- Add error handling for impossible scenarios
- Create helpers for single-use operations
- Add TODO/FIXME comments (fix it or don't)
- Over-engineer or add premature abstractions
- Remove used code (if it's there, it's used)

### Be Careful With
- `.bash_profile` load order
- `plugin_config/init.lua` load order (ORDER MATTERS)
- Commented code (kept as reference, don't remove)
- System-specific configs (use `.extra`, not committed)

---

*Last updated: 2026-02-20*
