Things I'd like to improve about my dotfile setup:

- Workflow
    - [x] Add a helper/alias to run Neovim healthchecks with isolated XDG paths (no live config impact).

- Neovim
    - [x] Add oil.nvim as a supplement to netrw with a simple, mnemonic keymap.
    - [x] Replace nvim-cmp with blink.cmp and update LSP capabilities accordingly.
    - [x] Switch Python LSP stack to ruff + ty only (drop pyright).
    - [x] Configure ruff for lint/format only and ty for full language services (diagnostics, hover, defs, completions).
    - [x] Improve Python root/venv detection for subprojects and pass the resolved env to ty/ruff.
    - [ ] Resolve ruff + ty capability overlaps (e.g., disable ruff references provider if needed).
    - [ ] Add LSP UI toggles under `<leader>t` for diagnostics, virtual text, inlay hints, and ty workspace checks.
    - [ ] Move gitsigns toggles under `<leader>tg*` and add which-key labels for toggle groups.
    - [ ] Audit keybinds for nonstandard or non-mnemonic patterns and normalize where it improves consistency.
    - [ ] Statusline: show a smartly truncated path (outermost + innermost segments).
    - [ ] Statusline: add an optional diagnostics summary (counts only).
    - [ ] Winbar: add an optional full relative path for extra context.
    - [ ] Telescope: larger layout, better preview split, and consistent smart path truncation.
    - [ ] Telescope: add a preview toggle mapping for faster scanning.
    - [ ] Decide on native Neovim LSP vs Mason (pros/cons) and document the choice.
