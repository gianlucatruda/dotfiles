Things I'd like to improve about my dotfile setup:

- Neovim
    - [ ] Look into oil.nvim as a supplement (not replacement) to netrw in neovim, with convenient keymapping.
    - [ ] Rework Python LSP setup: ruff for formatting, ty for (summonable, not automatic type checks), and pywright for everything else (particularly autocompletions and suggestions and inline docs, respecting .venvs)
    - [ ] Keybinds for toggling LSP information (warnings, type checks, etc.) that bloats the screen and slows down neovim when working on quick scripts, but is nice to optionally enabled when making deeper changes to big, well-established codebases.
    - [ ] blink for enhances neovim completions
    - [ ] A better nvim status that allows me to see more than just the file name (to understand the path), but which truncates smartly when paths are very long so that I can still see the outermost and innermost levels.
    - [ ] Better telescope setup so that long filepaths are readable (maybe using the same smart truncation as above). The split between the list of files and preview window is bad and I usually can't find what I'm looking for. Also the popup should make use of a bigger fraction of the screen real-estate to maximise what I can read.
    - [ ] Look into native neovim LSP support vs Mason and understand the pros/cons.
    - [ ] Handling for sub-project .venvs that break LSP completions and 'go-definition' / go-references' style lookups.
