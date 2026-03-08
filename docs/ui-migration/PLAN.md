# UI Migration Plan

## Overview

This document defines the high-level plan for the terminal/editor UI overhaul across this dotfiles repo.

The main objective is to move from a tightly coupled `Alacritty + Nightfox + conditional Neovim theme` setup to a cleaner, more portable, and more widely supported stack built around:

- `Tokyo Night Moon` as the target theme family for the preferred terminal stack
- `tmux` as the stable runtime layer for local and remote workflows
- a simpler Neovim colorscheme model that works well in normal, nested, remote, and incidental-terminal sessions
- parallel support for `Alacritty` and `Ghostty`

This is a phased migration. The intended order is:

1. Theme migration for the current setup
2. `tmux-256color` baseline
3. Neovim cleanup and polish
4. Ghostty fit-and-finish

## Current Status

- Phases 1-3 are complete in the current dotfiles state.
- Phase 4 now prefers Ghostty while retaining Alacritty support during transition.
- The active stack now uses fixed `Tokyo Night Moon` styling across Ghostty, Alacritty, and tmux.
- Neovim now uses `Tokyo Night Moon` only in Ghostty, and otherwise falls back to terminal-owned colors.
- Ghostty marks its sessions with `DOTFILES_TERM=ghostty`, and tmux preserves that so Neovim can detect Ghostty reliably inside tmux as well.
- tmux now advertises `tmux-256color`, provides explicit truecolor and undercurl support, and keeps its top status line on the terminal's default background so it blends into the terminal instead of painting a separate strip.
- Karabiner terminal launcher mappings now point to Ghostty.

## Success Criteria

The overhaul is successful when all of the following are true:

- `Tokyo Night Moon` is the active theme family for the preferred terminal/editor workflow.
- `Alacritty` continues to work cleanly during the transition.
- `Ghostty` is available alongside `Alacritty` without forcing another theme rethink.
- Neovim looks good out of the box in local, nested, and remote tmux sessions.
- Running Neovim over SSH does not mutate or override the outer terminal palette.
- The setup remains declarative, dotfile-friendly, and viable across macOS and Linux.
- The migration reduces custom theme glue instead of adding more.
- The resulting configuration is easier to understand and maintain than the current setup.

## Constraints

- Do not break the current daily-driver workflow while the migration is in progress.
- Keep Alacritty supported as a fallback while Ghostty becomes the preferred terminal.
- Assume `tmux-256color` is available everywhere that matters.
- Optimize for a tmux-heavy workflow, including nested local/remote tmux sessions.
- Keep terminal-specific Neovim behavior minimal, explicit, and limited to the preferred terminal when it materially improves the experience.
- Avoid palette mutation techniques that rewrite terminal colors at runtime.
- Keep the implementation simple and modular; do not over-engineer the theme layer.
- Preserve existing ergonomics unless there is a clear migration reason to change them.

## Non-Goals

- Do not try to make every TUI perfectly theme-matched in the first pass.
- Do not redesign shell prompt colors, file-manager colors, or every legacy ANSI tool up front.
- Do not switch fully to `Ghostty` before the terminal/theme architecture is settled.
- Do not introduce theme-sync tools that depend on OSC palette rewriting.

## Key Decisions

### 1. Use `Tokyo Night Moon` as the target theme

Reasoning:

- It is closer to the current `Nightfox` taste than more stylized options like `Catppuccin`.
- It has broad upstream support across Neovim, terminals, tmux, and common TUIs.
- It is popular enough to reduce custom integration work and future friction.
- It gives a cleaner long-term path than staying on a niche or semi-custom palette.

### 2. Treat `tmux` as the primary UI contract

Reasoning:

- Real usage is mostly `terminal -> tmux -> nvim` or `terminal -> tmux -> ssh -> tmux -> (n)vim`, not bare terminal sessions.
- The most important compatibility layer is therefore tmux, not any one terminal emulator.
- A stable tmux terminfo strategy matters more than terminal-specific editor detection.

### 3. Decouple terminal theming from Neovim theming

Reasoning:

- The current setup ties Neovim theme activation to `Alacritty` detection.
- That coupling is the main source of inconsistent behavior and janky fallbacks.
- The final architecture should let the terminal own terminal settings and let Neovim own editor colors.

### 4. Do not let Neovim or theme tooling rewrite terminal palettes by default

Reasoning:

- Remote-safe behavior matters.
- A normal Neovim theme is fine over SSH; palette mutation is the dangerous part.
- Avoiding runtime palette rewriting keeps local and remote behavior predictable.

### 5. Prefer `Ghostty` while keeping `Alacritty` as fallback during the transition

Reasoning:

- The migration should stay low-risk and reversible while the newer terminal becomes the default choice.
- `Ghostty` is the likely long-term direction, but keeping Alacritty available makes the transition safer.

### 6. Match Ghostty with one shared flag, and keep everything else simple

Reasoning:

- Ghostty is the preferred terminal, so it is worth matching Neovim there.
- Other terminals such as VSCodium should stay simple and rely on their own palette.
- The logic should be defined once and reused, not duplicated across config files.
- Tmux must preserve the Ghostty marker so the same logic works in the normal `Ghostty -> tmux -> nvim` path.

## High-Level Phases

## Phase 1 - Theme Migration On Current Setup

Goal:

- Adopt `Tokyo Night Moon` as the theme family in the existing `Alacritty`-based workflow.

Expected touchpoints:

- `.config/alacritty.toml`
- `.config/nvim/lua/core/plugins.lua`
- `.config/nvim/lua/plugin_config/colourscheme.lua`
- `.config/nvim/lazy-lock.json`
- `README.md`
- `.config/nvim/SPEC.md`

Success criteria for this phase:

- `Tokyo Night Moon` replaces `Nightfox` as the chosen theme family.
- Current Alacritty ergonomics remain intact.
- Neovim no longer depends on Alacritty-only detection.
- Documentation reflects the new target theme.
- No Ghostty-specific changes are required yet.

## Phase 2 - `tmux-256color` Baseline

Goal:

- Make tmux the stable rendering contract for local and remote work.

Expected touchpoints:

- `.config/tmux/tmux.conf`
- possibly `.config/.bash_prompt` only if truly necessary
- `README.md`
- `.config/nvim/SPEC.md`

Success criteria for this phase:

- tmux advertises `tmux-256color` consistently.
- Truecolor and undercurl support are explicit and stable.
- Nested tmux sessions remain usable and visually correct.
- The configuration no longer relies on inheriting the outer terminal identity as tmux's primary model.
- The status line blends into the terminal background instead of introducing a separate full-width bar color.

## Phase 3 - Neovim Cleanup And Polish

Goal:

- Keep the Ghostty-matched plus terminal-fallback model simple, explicit, and polished.

Expected touchpoints:

- `.config/nvim/lua/plugin_config/colourscheme.lua`
- `.config/nvim/lua/core/options.lua`
- `.config/nvim/lua/plugin_config/lualine.lua` only if needed
- `README.md`
- `.config/nvim/SPEC.md`

Success criteria for this phase:

- Remaining Neovim color settings are consistent with the Ghostty-matched plus terminal-fallback model.
- Neovim looks good in local tmux, nested tmux, and SSH sessions.
- Neovim does not rewrite the outer terminal palette.
- Related UI config and docs are simpler and more predictable than today.

## Phase 4 - Ghostty Feel And Aesthetic

Goal:

- Add `Ghostty` in a way that preserves the feel you like from the current terminal setup.

Expected touchpoints:

- `.config/ghostty/config`
- `.config/homebrew/Brewfile`
- `.config/karabiner/karabiner.json`
- possibly `README.md`

Success criteria for this phase:

- `Ghostty` is the preferred terminal and `Alacritty` remains available as fallback.
- It feels close to the current preferred terminal ergonomics.
- It uses the same theme family and fits the new tmux/Neovim model cleanly.
- Switching between `Alacritty` and `Ghostty` does not require separate Neovim logic.

Current implementation status:

- A local Ghostty config is now present under XDG config.
- Ghostty uses its built-in `TokyoNight Moon` theme instead of a vendored duplicate theme file.
- Ghostty exports a repo-specific terminal marker so tmux and Neovim can recognize it reliably.
- The macOS Ghostty config now hides the native titlebar so the window chrome feels closer to the current terminal setup.
- Homebrew package support is in place so Ghostty can be installed from the repo.
- Karabiner now launches Ghostty from the terminal shortcut.

## Guiding Principles

- Prefer fewer moving parts over perfect cross-tool synchronization.
- Use theme families with strong upstream extras instead of maintaining custom palettes where possible.
- Let ANSI-only tools be "close enough" via terminal palette matching.
- Keep Neovim theme logic simple, explicit, and terminal-agnostic.
- Make remote behavior predictable before chasing local visual polish.

## Likely Out-Of-Scope For Early Phases

These may be revisited later, but should not expand the initial implementation unnecessarily:

- `.config/.bash_prompt`
- `.config/lf/colors`
- `.config/lf/lfrc`
- `.config/ranger/rc.conf`
- `.config/htop/htoprc`
- `.config/btop/btop.conf`

Some of these may eventually get improved theme alignment, but they are not the critical path.

## Additional Decisions

- Neovim now uses a single shared Ghostty detection flag to enable Tokyo Night Moon, and otherwise falls back to terminal-owned colors.
- Tmux status styling should use fixed `Tokyo Night Moon` accents, but keep the status line background on the terminal default so it feels integrated with the outer terminal.
- Ghostty is now the preferred terminal, with Alacritty retained as fallback during transition.
- `btop`, `lazygit`, `fzf`, and `delta` should NOT be included in the early theme pass, as they should mostly inherit colour.
- `UbuntuMono Nerd Font` should remain the font of choice.

## Working Rule For This Migration

When tradeoffs appear, prefer:

1. remote-safe behavior
2. tmux stability
3. simpler Neovim logic
4. theme consistency
5. terminal-specific polish
