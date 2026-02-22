Things I'd like to improve about my dotfile setup:

- Workflow
    - [x] Add a helper/alias to run Neovim healthchecks with isolated XDG paths (no live config impact).

- Neovim
    - [x] Add oil.nvim as a supplement to netrw with a simple, mnemonic keymap.
    - [x] Replace nvim-cmp with blink.cmp and update LSP capabilities accordingly.
    - [x] Switch Python LSP stack to ruff + ty only (drop pyright).
    - [-] Configure ruff for lint/format only and ty for full language services (diagnostics, hover, defs, completions).
    - [-] Resolve ruff + ty capability overlaps (e.g., disable ruff references provider if needed).
    - [-] Improve Python root/venv detection for subprojects and pass the resolved env to ty/ruff.
    - [-] Add LSP UI toggles under `<leader>t` for diagnostics, virtual text, inlay hints, and ty workspace checks.
    - [x] Move gitsigns toggles under `<leader>tg*` and add which-key labels for toggle groups.
    - [x] Audit keybinds for nonstandard or non-mnemonic patterns and normalize where it improves consistency.
    - [x] Statusline: show a smartly truncated relative path (lualine filename + shorting).
    - [x] Statusline: add an optional diagnostics summary (counts only).
    - [x] Winbar: add an optional full relative path for extra context.
    - [ ] Most of the info at the bottom right of my nvim statusline isn't very helpful, but it takes up a lot of screen space at the expense of the filename/path and branch. I probably can abbreviate the mode names too, as I never need to look at that text really.
    - [-] Telescope: larger layout, better preview split, and consistent smart path truncation.
        - [ ] Telescope: <leader>gr still throws annoying warning
        - [ ] Telescope: go-references still wastes screen real-estate showing two previews of the content at the expense of the file path
    - [-] Telescope: add a preview toggle mapping for faster scanning. How do I use this?
    - [ ] Fix LSPs for Python projects (auto-detect .venv if it exists, else use system for bare .py files. Handle nested venvs in sub-dirs of monorepos)
    - [ ] Formatting for .md files, but not snippets / autocomplete (annoying)
    - [ ] God-tier VS Code level autocompletions, inline docs, hints, LSP completions, snippets. Fast, rich, elegant, but non-instrusive and easy to toggle/customise.

- Future
    - [-] Simplify and streamline neovim config (particularly lsp.lua) and avoid excessive bespoke code for future proofing
    - [ ] Decide on native Neovim LSP vs Mason (pros/cons) and document the choice.

---

