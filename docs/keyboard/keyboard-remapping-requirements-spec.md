# Keyboard Remapping Requirements Specification

## 1. Document control

| Field             | Value                                                                         |
| ----------------- | ----------------------------------------------------------------------------- |
| Status            | Requirements baseline                                                         |
| Version           | 1.0                                                                           |
| Date              | 2026-08-22                                                                    |
| Target systems    | macOS first, with low-priority Linux and iPadOS context                       |
| Target keyboards  | Keychron K6, YIVU Borne, Lofree Flow Lite84, personal MacBook Pro US keyboard |
| Dotfiles baseline | `gianlucatruda/dotfiles` commit `03d32c0c66568f517b9d5afda2e46488b3a0147d`    |

## 2. Purpose

This document defines the requirements for a future keyboard remapping design.

The future design will cover firmware and software remapping across four keyboards. It will support a fast, keyboard-first macOS workflow. It will preserve the user's current muscle memory where possible.

This document records requirements only. It does not define a new layout. It does not select firmware mappings. It does not change Karabiner, AeroSpace, macOS, Ghostty, Tmux, Vim, Neovim, Zen, Shottr, GhostPepper, or the keyboard diagrams.

## 3. Requirement words

The following words have fixed meanings in this document:

- **MUST**: The future design must satisfy the requirement.
- **SHOULD**: The future design should satisfy the requirement unless a higher-priority requirement prevents it.
- **MAY**: The future design can satisfy the requirement when useful.
- **TIE-BREAK ONLY**: The requirement can decide between two otherwise equal designs. It must not override a higher-priority requirement.

## 4. Priority order

### 4.1 Priority 0: current macOS workflow

The current browser, terminal, Tmux, AeroSpace, screenshot, dictation, coding, and writing workflows are the highest priority.

The future design MUST preserve these workflows unless the user explicitly changes a requirement.

### 4.2 Priority 1: consistency across the four regular keyboards

The future design SHOULD make the four regular keyboards feel coherent. A semantic action should use the same logical modifier and the same general finger pattern on each keyboard.

Comfort, reliable access, and existing muscle memory are part of this priority.

### 4.3 Priority 2: future Linux portability

Linux portability is TIE-BREAK ONLY. The likely target is Omarchy or a similar keyboard-first Linux environment.

This requirement must not reduce the quality of the current macOS workflow.

### 4.4 Priority 3: occasional iPadOS use

iPadOS use is TIE-BREAK ONLY. The relevant device is an M1 iPad Air.

This requirement must not reduce the quality of the current macOS workflow or regular keyboard use.

## 5. User and workflow profile

### 5.1 Main applications

- The user spends approximately 95% of computer time in a browser or terminal.
- Zen is the main browser.
- Ghostty is the terminal.
- Ghostty usually runs Tmux.
- Tmux usually runs Bash and Neovim.
- Obsidian is an occasional application.
- Obsidian uses Vim bindings when possible.
- Markdown is a frequent writing format.

### 5.2 Main interaction model

The workflow is Vim-inspired. H, J, K, and L are the main spatial navigation keys.

The workflow uses a separate modifier or prefix for each navigation scope:

| Scope                            | Logical modifier or prefix | Main selectors                      |
| -------------------------------- | -------------------------- | ----------------------------------- |
| Text and page navigation         | Right Command              | H, J, K, L, D, U                    |
| Application launch               | Right Command              | 0 to 6                              |
| Browser tab selection            | Command                    | Number row and Tab                  |
| macOS application switching      | Command                    | Tab                                 |
| AeroSpace windows and workspaces | Option                     | H, J, K, L, number row, Tab         |
| Tmux panes and windows           | Control-B prefix           | H, J, K, L, number row, Tab         |
| Screenshots                      | Control+Option+Command     | 6, 7, 8, 9                          |
| Dictation                        | Fn/Globe                   | Tap or configured trigger           |
| Escape                           | Right Shift                | Tap                                 |
| Control and backtick             | Caps Lock                  | Chord for Control, tap for backtick |

This separation is an important pattern. It gives one consistent navigation grammar at several levels.

### 5.3 High-value physical inputs

The following inputs are high priority:

- Left Control or an equivalent Caps chord
- Left Option
- Left Command
- Right Command
- Fn/Globe
- Left Shift
- Tab
- Number row 0 to 9
- H, J, K, and L
- D and U
- Backtick and tilde
- Escape
- The standard US punctuation keys used for code and Markdown

The built-in arrow keys are low priority. The user normally uses Right Command+H/J/K/L.

### 5.4 Overarching patterns

The future design MUST preserve these patterns:

- H, J, K, and L express a direction.
- A modifier or prefix selects the navigation scope.
- A number selects a known item in the selected scope.
- Tab moves to a recent or adjacent item in the selected scope.
- Left Command keeps normal macOS and application behaviour.
- Right Command keeps the custom navigation and launch behaviour.
- High-frequency actions stay direct and reliable.
- Firmware and software must produce one defined final event.
- Standard US characters remain available for code and Markdown.

These patterns are more important than the printed label on an individual key.

## 6. Target hardware

### 6.1 Keychron K6

- Compact 65% ANSI keyboard
- 68 keys
- Mac keycap legends
- Physical Left Control, Left Option, Left Command, Right Command, Fn1, and Fn2
- Physical Right Shift and arrow cluster
- Number row is present
- No dedicated function row

### 6.2 YIVU Borne

- Split, column-staggered keyboard
- Extended Corne-style 4x6 layout
- 60 controls, including two rotary encoders
- Two firmware layer keys labelled Fn
- Visible thumb keys include Control, Space, Enter, Fn, and Win
- No dedicated physical number row outside the 4x6 matrix
- No dedicated built-in arrow cluster is required for the normal workflow
- QMK/Vial firmware processes events before Karabiner and macOS

The current Borne firmware layers and encoder actions are not stored in the dotfiles repository.

### 6.3 Lofree Flow Lite84

- Conventional staggered 75% ANSI layout
- 84 keys
- Dedicated function row
- Dedicated navigation column
- Dedicated arrow cluster
- Modifier row includes Control, Windows/Command-style keys, Alt-style keys, Fn, and a second Control
- Volume roller

### 6.4 Personal MacBook Pro keyboard

- Built-in US ANSI keyboard
- 78 keys
- Physical function row
- Dedicated Fn/Globe key
- Left and right Command
- Left and right Option
- Left and right Shift
- Touch ID
- Inverted-T half-height arrow cluster

## 7. Input processing model

The future design MUST account for the order of input processing.

For the Borne, the normal order is:

1. Physical switch or encoder
2. QMK/Vial firmware
3. USB HID event
4. Karabiner
5. macOS or a global application listener
6. Foreground application
7. Ghostty, when the foreground application is the terminal
8. Tmux
9. Bash, Vim, Neovim, or another terminal application

For the other keyboards, the normal order starts with the keyboard controller. It then continues through the applicable internal, USB, or Bluetooth HID transport.

Global tools can consume an event before the foreground application receives it. These tools include Karabiner, AeroSpace, Shottr, GhostPepper, and macOS.

The future design MUST distinguish the following concepts:

- A physical key label
- A firmware key code
- A USB HID event
- A Karabiner logical event
- An application shortcut
- A Tmux prefix sequence
- A Vim or Readline command

## 8. Core modifier requirements

### 8.1 Command sides

Left Command and Right Command MUST remain logically different.

- Left Command is the normal macOS and application Command modifier.
- Right Command is the navigation and application-launch modifier.

The future design MUST preserve access to both roles.

### 8.2 Right Shift

Right Shift currently produces Escape through Karabiner.

The future design MUST preserve a fast and reliable Escape action on every regular keyboard.

Right Shift is not required as a Shift key. Left Shift MUST remain available for capital letters, symbols, and Shift shortcuts.

### 8.3 Caps Lock dual role

Caps Lock currently has two actions:

- Tap alone: send the grave/backtick key
- Hold or chord: send Left Control

The future design MUST preserve reliable access to both actions.

Caps Lock is not required as a capital-lock toggle.

### 8.4 Option

Option is the AeroSpace modifier. It is also the terminal Alt/Meta modifier when the event reaches Ghostty.

The future design MUST preserve direct access to Option. It MUST also account for global AeroSpace shortcuts that consume Option combinations before Ghostty receives them.

### 8.5 Fn and Globe

The Apple Fn/Globe event toggles GhostPepper dictation.

The future design MUST preserve an event that GhostPepper can detect.

A QMK or keyboard-firmware layer key labelled Fn is not automatically equivalent to the Apple Fn/Globe HID event.

### 8.6 Multi-modifier chords

The future design MUST keep Control+Option+Command chords practical. The user uses these chords frequently for screenshots.

The current screenshot chord SHOULD use Left Command. A chord with Right Command+6 matches the Karabiner application-launch rule because that rule permits additional modifiers. It can launch Spotify instead of reaching Zen.

## 9. Required global behaviours

### 9.1 Right Command navigation

| Input           | Required current action |
| --------------- | ----------------------- |
| Right Command+H | Left Arrow              |
| Right Command+J | Down Arrow              |
| Right Command+K | Up Arrow                |
| Right Command+L | Right Arrow             |
| Right Command+D | Page Down               |
| Right Command+U | Page Up                 |

Additional held modifiers are currently allowed by the Karabiner rules.

Page Down and Page Up are full-page events. They are not Vim half-page Control-D and Control-U events.

### 9.2 Application launch

| Input           | Required current action |
| --------------- | ----------------------- |
| Right Command+0 | Finder                  |
| Right Command+1 | Zen                     |
| Right Command+2 | Ghostty                 |
| Right Command+3 | Obsidian                |
| Right Command+4 | Todoist                 |
| Right Command+5 | Calendar                |
| Right Command+6 | Spotify                 |

These actions currently have priority over foreground-application shortcuts that use Right Command with the same numbers.

### 9.3 Screenshots

| Input                    | Application    |
| ------------------------ | -------------- |
| Control+Option+Command+6 | Zen screenshot |
| Control+Option+Command+7 | Shottr action  |
| Control+Option+Command+8 | Shottr action  |
| Control+Option+Command+9 | Shottr action  |

The exact Shottr actions for 7, 8, and 9 are not stored in the repository.

### 9.4 Dictation

Fn/Globe toggles GhostPepper dictation.

The GhostPepper configuration is not stored in the repository.

## 10. macOS baseline

### 10.1 Keyboard and text input

- Homebrew Bash is the default shell when the setup script can install it.
- Full keyboard access is enabled for all controls.
- Key repeat is very fast with `KeyRepeat=1`.
- Initial repeat delay is short with `InitialKeyRepeat=10`.
- Tapping the Apple Fn/Globe key has no built-in macOS action because `AppleFnUsageType=0`.
- Automatic capitalization is disabled.
- Smart dashes are disabled.
- Automatic period substitution is disabled.
- Smart quotes are disabled.
- Automatic spelling correction is disabled.
- Messages smart quotes are separately disabled.
- Metric units are enabled.
- Shell locale is `en_GB.UTF-8`.

The macOS configuration does not contain a `hidutil` modifier remap. Karabiner provides the key remaps.

### 10.2 Focus, windows, Mission Control, and Spaces

- Tab can move focus through all controls and modal dialogs.
- Sidebar icons use the medium size.
- Scroll bars appear while scrolling.
- Window resize animation is almost immediate.
- Focus-ring animation is disabled.
- Mission Control animation duration is `0.1`.
- Mission Control groups windows by application.
- Spaces do not reorder by recent use.
- Application window restoration on quit is disabled.
- Automatic termination of inactive applications is disabled.
- Help Viewer windows do not float above other windows.
- The login-window clock can show the host information when clicked.

### 10.3 Dock and hot corners

- Dock icon size is 55 pixels.
- Dock stack items highlight on pointer hover.
- Window minimization uses the scale effect.
- Windows minimize into their application icon.
- Dock items use spring-loading.
- Dock auto-hide is enabled.
- Dock show and hide delays are zero.
- Dock launch animation is disabled.
- Recent applications are hidden.
- Hidden applications are translucent.
- Open-application indicators are shown.
- Launchpad layout is reset when `macos.sh` deletes its database.

Control-modified hot corners are active:

| Corner       | Action          |
| ------------ | --------------- |
| Top-left     | Mission Control |
| Bottom-left  | Show Desktop    |
| Bottom-right | Lock Screen     |

The Caps-to-Control chord can satisfy this Control requirement.

### 10.4 Finder and file handling

- Command-Q is enabled in Finder.
- Finder window and Get Info animations are disabled.
- External drives, mounted servers, and removable media appear on the desktop.
- Internal hard drives do not appear on the desktop.
- Hidden files and all filename extensions are shown.
- Status bar, path bar, and full POSIX path title are shown.
- Column view is the default.
- Finder search starts in the current folder.
- Folders sort before files.
- Directory spring-loading has no delay.
- File extension and Empty Trash warnings are disabled.
- The user Library directory and `/Volumes` are visible.
- Network and USB volumes do not receive `.DS_Store` files.
- Icon views show item information.
- Desktop icon labels appear at the side.
- Icon views snap items to a 100-pixel grid.
- Desktop icons use 50-pixel size.
- Other standard icon views use 80-pixel size.
- General, Open With, and Sharing and Permissions panes are expanded in Get Info.

### 10.5 Other system behaviour

- Password is required immediately after sleep or screen saver start.
- Screenshots use PNG.
- Standby delay is 12 hours.
- Time Machine does not offer new disks as backup volumes.
- Activity Monitor opens its main window at launch.
- Activity Monitor shows all processes.
- Activity Monitor sorts by CPU use.
- The Activity Monitor Dock icon shows CPU use.
- TextEdit creates UTF-8 plain-text files.
- Disk Utility has its debug menu and advanced image options enabled.
- Mac App Store WebKit developer tools and the debug menu are enabled.
- Automatic update checks and background downloads are enabled.
- System data files and critical updates install automatically.
- Applications from the Mac App Store update automatically.
- Photos does not open automatically for connected devices.
- Application quarantine confirmation is disabled.
- Crash Reporter dialogs are suppressed.
- Save and print panels open expanded.
- Printer applications quit after jobs finish.

These settings form the current environment. Most are not direct keyboard requirements, but they are part of the workflow baseline.

## 11. Karabiner baseline

### 11.1 Selected profile

- Profile name: `Gianluca`
- Profile is selected.
- Virtual HID keyboard type is ANSI.
- Karabiner menu-bar icon is hidden.

### 11.2 Profile-wide simple modification

- Right Shift sends Escape.

### 11.3 Profile-wide complex modifications

- Caps tap sends grave/backtick.
- Caps chord sends Left Control.
- Right Command+H/J/K/L sends arrow events.
- Right Command+D/U sends Page Down/Page Up.
- Right Command+0 to 6 launches applications.
- Mouse button 3 sends Mission Control.
- Mouse button 4 sends Command+left bracket for Back.
- Mouse button 5 sends Command+right bracket for Forward.

The profile-wide simple and complex modifications apply to every processed matching device. They do not contain conditions for the four target keyboard model names. The future design MUST identify when firmware output from a target keyboard also enters these profile-wide rules.

### 11.4 Function-key translations

| Input event | Output event               |
| ----------- | -------------------------- |
| F3          | Mission Control            |
| F4          | Launchpad                  |
| F5          | Keyboard illumination down |
| F6          | Keyboard illumination up   |
| F9          | Fast-forward or next       |

These translations apply only when the keyboard firmware sends the related function-key event through Karabiner.

### 11.5 Device-specific rules

| HID identity | Known identity                                                         | Device-specific action              |
| ------------ | ---------------------------------------------------------------------- | ----------------------------------- |
| `046d:b319`  | Logitech K810                                                          | Modifier swaps and Caps LED control |
| `05ac:024f`  | Apple keyboard interface with exact model not stored in the repository | Physical grave sends Escape         |
| `0413:0308`  | Unnamed keyboard                                                       | Caps LED manipulation disabled      |
| `046d:b01a`  | Unnamed Logitech combined keyboard and pointing interface              | Processed, with no key remap        |
| `046d:c08b`  | Logitech G502 HERO interfaces                                          | Vendor-specific events ignored      |
| `3434:d030`  | Keychron Link interface                                                | Processed as a pointing interface   |
| `3434:d031`  | Keychron Link interfaces                                               | Vendor-specific events ignored      |

The Logitech K810 is not one of the four target keyboards. Its rules remain part of the current configuration baseline.

K810 modifier behaviour:

| Physical K810 key | Logical output |
| ----------------- | -------------- |
| Left Command      | Left Option    |
| Left Option       | Left Command   |
| Right Control     | Right Option   |
| Right Option      | Right Command  |

### 11.6 Inactive Karabiner rules

The following rules exist but are disabled:

- Right Command becomes Hyper: Command+Control+Option+Shift
- Hyper+H/J/K/L sends arrows

The separate Caps modification library contains alternative Caps behaviours. These rules are not active.

The future design MUST use active rules as the baseline. It MUST NOT treat disabled or import-library rules as current behaviour.

## 12. AeroSpace requirements

### 12.1 Environment

- AeroSpace starts at login.
- AeroSpace starts Borders with a 5-pixel border.
- The active border colour is `0xffe1e3e4`.
- The inactive border colour is `0xff494d64`.
- Root layout is tiled.
- Root orientation is automatic.
- Container normalization is enabled.
- Inner and outer gaps are 15 pixels.
- Accordion padding is 30 pixels.
- Shottr windows float.
- System Settings windows float.

### 12.2 Main mode

| Input                  | Action                                        |
| ---------------------- | --------------------------------------------- |
| Option+/               | Cycle tiled horizontal or vertical layout     |
| Option+,               | Cycle accordion horizontal or vertical layout |
| Option+H/J/K/L         | Focus left/down/up/right                      |
| Option+Shift+H/J/K/L   | Move window left/down/up/right                |
| Option+Shift+-         | Resize by -50                                 |
| Option+Shift+=         | Resize by +50                                 |
| Option+1 to 6          | Switch to workspace 1 to 6                    |
| Option+Shift+1 to 6    | Move window to workspace and switch there     |
| Option+Shift+Z         | Fullscreen current window                     |
| Option+Tab             | Switch to previous workspace                  |
| Option+Shift+Tab       | Move workspace to the next monitor            |
| Option+Shift+semicolon | Enter service mode                            |

### 12.3 Service mode

| Input                | Action                                            |
| -------------------- | ------------------------------------------------- |
| Escape               | Reload configuration and return to main mode      |
| R                    | Flatten workspace tree and return to main mode    |
| F                    | Toggle floating or tiling and return to main mode |
| Backspace            | Close all windows except the current window       |
| Option+Shift+H/J/K/L | Join containers in the selected direction         |

### 12.4 Interaction requirements

- AeroSpace MUST continue to receive logical Option events.
- Option+H/J/K/L MUST remain a distinct scope from Right Command+H/J/K/L.
- Option+number MUST remain a distinct scope from Command+number and Right Command+number.
- Option+Tab MUST remain a distinct scope from Command+Tab and Control+Tab.
- AeroSpace can consume its configured global shortcuts before Ghostty or Zen receives them.

## 13. Tmux requirements

### 13.1 Prefix

- Local prefix: Control-B
- Tmux started under SSH: Control-A

The future design MUST keep Control-B practical. It SHOULD also preserve Control-A for SSH use.

### 13.2 Common navigation

| Sequence             | Action                                                   |
| -------------------- | -------------------------------------------------------- |
| Prefix, then H/J/K/L | Select pane left/down/up/right                           |
| Prefix, then 1 to 5  | Select tmux window 1 to 5 through retained tmux defaults |
| Prefix, then Tab     | Select previous tmux window                              |

These are among the user's most frequent terminal sequences.

### 13.3 Other configured bindings

| Sequence             | Action                                                |
| -------------------- | ----------------------------------------------------- |
| Prefix, then `+`     | Grow pane by 10 toward the available neighbour        |
| Prefix, then `_`     | Shrink pane by 10 relative to the available neighbour |
| Prefix, then Shift-H | Swap window left                                      |
| Prefix, then Shift-L | Swap window right                                     |
| Prefix, then `"`     | Split vertically in the current directory             |
| Prefix, then `%`     | Split horizontally in the current directory           |
| Prefix, then R       | Reload Tmux configuration                             |

### 13.4 Tmux behaviour

- Mouse is enabled.
- Copy mode uses Vi keys.
- Copy mode writes to the system clipboard.
- Scrollback limit is 30,000 lines.
- Window numbers are renumbered after closes.
- The alternate screen is enabled.
- Escape delay is 50 ms.
- Tmux uses `tmux-256color` and advertises RGB support.
- Tmux refreshes selected display, SSH, authentication, platform, and terminal-marker variables when a client attaches.
- Status line is at the top.
- Windows rename automatically as directory and process.

### 13.5 Interaction requirements

- Caps chords currently provide Control for the Tmux prefix.
- Right Shift currently provides Escape inside Tmux applications.
- Shifted Tmux symbols require Left Shift because Right Shift sends Escape.
- AeroSpace Option bindings and Karabiner Right Command bindings act before Tmux.

### 13.6 Retained default bindings

Tmux default bindings remain active unless the configuration replaces them. Important retained defaults include:

- Prefix, then `0` to `9` selects a numbered window.
- Prefix, then `c` creates a new window.
- Prefix, then `n`/`p` selects the next/previous window.
- Prefix, then `z` toggles pane zoom.
- Prefix, then `[` enters copy mode.
- Prefix, then `]` pastes the most recent buffer.
- Prefix, then `x` kills the current pane after confirmation.
- Prefix, then `&` kills the current window after confirmation.
- Prefix, then `d` detaches the current client.

The future design MUST not assume that only the custom Tmux bindings are in use.

## 14. Zen browser requirements

### 14.1 Tab and window navigation

| Input           | Action                                                           |
| --------------- | ---------------------------------------------------------------- |
| Command+1 to 8  | Select tab 1 to 8                                                |
| Command+9       | Select last tab                                                  |
| Control+Tab     | Quickly cycle or toggle tabs through inherited browser behaviour |
| Command+T       | New tab                                                          |
| Command+Shift+T | Restore closed tab, window, or session                           |
| Command+W       | Close tab                                                        |
| Command+Shift+W | Close window                                                     |
| Command+N       | New window                                                       |
| Command+Shift+N | New private window                                               |

### 14.2 Navigation and page control

| Input                                  | Action               |
| -------------------------------------- | -------------------- |
| Command+L                              | Focus address bar    |
| Command+R                              | Reload               |
| Command+Shift+R                        | Reload without cache |
| F5                                     | Reload               |
| Command+F                              | Find                 |
| F3 / Shift+F3                          | Next/previous result |
| Command+left bracket or Command+Left   | Back                 |
| Command+right bracket or Command+Right | Forward              |
| Option+Home                            | Home                 |
| Command+0                              | Reset zoom           |
| Command+= or Command++                 | Zoom in              |
| Command+- or Command+_                 | Zoom out             |
| F11 or Command+Shift+F                 | Fullscreen           |

### 14.3 Copy operations

The following actions are distinct:

| Input             | Action                           |
| ----------------- | -------------------------------- |
| Command+C         | Normal copy                      |
| Control+Command+C | Copy raw URL                     |
| Shift+Command+C   | Copy URL as a Markdown hyperlink |

Control+C in a terminal remains the normal interrupt action. It must not be confused with the Zen URL-copy action.

### 14.4 Zen-specific actions

| Input                            | Action              |
| -------------------------------- | ------------------- |
| Command+B                        | Toggle compact mode |
| Command+Shift+P                  | Toggle pinned tab   |
| Control+Option+Command+6         | Browser screenshot  |
| Command+Option+I                 | Developer tools     |
| Command+Option+Shift+right brace | Picture-in-Picture  |

### 14.5 Application and system actions

- Command+Tab switches macOS applications.
- Command+H hides Zen.
- Command+Option+H hides other applications.
- Command+M minimizes Zen.
- Command+Q quits Zen.
- Command+comma opens preferences.

### 14.6 Interaction requirements

- Left Command MUST retain normal Zen shortcuts.
- Right Command+0 to 6 MUST retain the current Karabiner launcher priority.
- Right Command+H/J/K/L MUST retain navigation priority.
- Right Shift cannot provide Shift for Zen shortcuts.
- F3 and F5 are Zen shortcuts, but the Karabiner function-key translations can replace these events before Zen receives them.
- Command+F and Command+R remain direct alternatives for Find and Reload.
- Zen's manually synchronized shortcut file is a repository snapshot, not guaranteed live state.

## 15. Ghostty and Bash requirements

### 15.1 Ghostty

- Ghostty opens maximized.
- Title bar is hidden.
- Font is Hack Nerd Font at 14 points.
- Theme is TokyoNight Moon.
- Mouse pointer hides during typing.
- Ghostty exports `DOTFILES_TERM=ghostty`.
- No custom Ghostty key bindings are stored in the repository.

On a US Standard or US International macOS input layout, Ghostty normally treats Option as terminal Alt when `macos-option-as-alt` is unset. The active macOS input source controls this default.

### 15.2 Bash and Readline

- Bash uses Vi editing mode.
- Insert mode uses a beam cursor.
- Command mode uses a block cursor.
- Right Shift currently provides Escape to leave insert mode.
- Tab cycles completion candidates.
- Completion ignores case.
- Completion immediately adds a trailing slash for a directory symlink.
- Completion can use text after the cursor.
- Completion shows visible file type marks.
- Completion shows all results without paging.
- Completion asks for confirmation above 200 candidates.
- Up and Down search command history by the typed prefix.
- Option+Delete deletes the preceding word.
- UTF-8 meta input and output are enabled.
- Hidden files do not complete unless the input begins with a dot.
- Case-insensitive globbing is enabled.
- Bash appends to command history.
- Bash omits duplicate commands and commands that start with a space from history.
- Bash command and Node REPL histories allow 32,768 entries.
- `cd` spelling correction is enabled.
- `autocd` and recursive `globstar` are enabled.
- FZF provides standard shell bindings such as Control-R, Control-T, and Option-C.
- Zoxide handles `cd` when available.
- Neovim is the normal editor. Vim is the fallback.

### 15.3 Other terminal tools

- FZF loads its installed Bash bindings and fuzzy completion at shell start.
- The common FZF bindings include Control-R for history, Control-T for files, and Option-C for directories.
- The exact generated FZF binding text depends on the installed FZF version.
- `sf` searches readable files with Ripgrep and FZF, then opens the result in Neovim or Vim.
- `sfa` runs `sf -a` and includes hidden files except `.git`.
- `sd` selects a directory with FZF and changes to it.
- `v` opens a path in Neovim or Vim.
- `y` starts Yazi.
- `lg` starts LazyGit.
- `clc` copies the last shell command to the macOS clipboard.
- `batmd` displays Markdown in the terminal.
- `llmq` opens a prompt in the configured visual editor, sends it to an LLM command, and displays the Markdown result.

These commands reinforce the keyboard-first workflow. They do not add a separate system-wide modifier layer.

## 16. Vim and Neovim requirements

### 16.1 General editing model

- Vim motion and modal editing are central to the user's muscle memory.
- H, J, K, and L MUST remain direct and reliable.
- Escape MUST remain fast and easy.
- Control MUST remain easy for terminal, Vim, and plugin commands.
- Standard US punctuation MUST remain available for code and Markdown.
- Backtick and tilde MUST remain available even when a physical grave key sends Escape.

### 16.2 Neovim core mappings

| Input                         | Action                         |
| ----------------------------- | ------------------------------ |
| Space                         | Leader                         |
| Visual J/K                    | Move selected lines down/up    |
| Space I D                     | Insert ISO date                |
| Space Tab                     | Previous buffer                |
| Lowercase J/K without a count | Move by displayed wrapped line |
| Space E                       | Diagnostic float               |
| Space Q                       | Diagnostic location list       |

### 16.3 Completion

| Input     | Action                                  |
| --------- | --------------------------------------- |
| Tab       | Next completion or snippet position     |
| Shift+Tab | Previous completion or snippet position |
| Control-N | Next completion                         |
| Control-P | Previous completion                     |
| Space T C | Toggle completion auto-trigger          |

Shift+Tab requires Left Shift under the current global Right-Shift-to-Escape rule.

### 16.4 LSP

The configured LSP mappings include:

- `gd`: definition
- `gr`: references
- `gI`: implementation
- `gD`: declaration
- `K`: hover
- Control-K: signature help
- Space R N: rename
- Space C A: code action
- Space D: type definition
- Space D S: document symbols
- Space W S: workspace symbols
- Space W A/W R/W L: workspace folder actions
- Space F: format
- Space T L D/V/I/W/A: LSP display and diagnostics toggles

### 16.5 Search, files, and Git

The configured mappings include:

- Space question mark: recent files
- Space Space: buffers
- Space slash: current-buffer fuzzy search
- Space S slash: grep open files
- Space S S: Telescope picker list
- Space G F: Git files
- Space S F: project files
- Space S Shift-F: all project files except `.git`
- Space S H/W/G/Shift-G/D/R: help, word, grep, all-file grep, diagnostics, resume
- Space O or minus: Oil file explorer
- Space G G: LazyGit
- `[c` and `]c`: previous and next Git hunk
- Space H S: stage the current hunk or selected lines
- Space H R: reset the current hunk or selected lines
- Space H Shift-S: stage the buffer
- Space H U: undo hunk staging
- Space H Shift-R: reset the buffer
- Space H P: preview the hunk
- Space H B: show blame for the current line
- Space H D: compare with the index
- Space H Shift-D: compare with the last commit
- `ih`: select a Git hunk in operator or visual mode
- Space T G B: toggle blame for the current line
- Space T G D: toggle deleted lines

### 16.6 Treesitter text objects

| Input                   | Action                             |
| ----------------------- | ---------------------------------- |
| `aa` / `ia`             | Select outer/inner parameter       |
| `af` / `if`             | Select outer/inner function        |
| `ac` / `ic`             | Select outer/inner class           |
| `]m` / `[m`             | Go to next/previous function start |
| `]M` / `[M`             | Go to next/previous function end   |
| `]]` / `[[`             | Go to next/previous class start    |
| `][` / `[]`             | Go to next/previous class end      |
| Space A / Space Shift-A | Swap parameter forward/backward    |

### 16.7 Markdown behaviour

- Line wrap and word wrap are enabled.
- Markdown formatting uses Prettier through `formatprg`.
- Space F formats the complete Markdown buffer through `gq` and Prettier.
- Marksman provides Markdown LSP features.
- Markdown Treesitter parsers are installed.
- Spell checking is not enabled.
- Markdown `textwidth` is not set.
- Format-on-save is not enabled.
- System clipboard integration is enabled.

### 16.8 Vim fallback

The fallback Vim configuration has no custom mappings. Standard Vim commands remain active.

The fallback configuration enables syntax, filetype support, autoindent, search highlighting, line numbers, wrapping, mouse support, system clipboard access, persistent undo, and external-file checks.

### 16.9 Effect of the current modifier remaps

- Right Shift sends Escape before Vim or Neovim receives the event.
- Left Shift is necessary for Visual Shift-J/Shift-K and other uppercase commands.
- Left Shift is necessary for `gI`, `K`, `[M`, `]M`, Space Shift-A, and other shifted mappings.
- Caps chords can provide Control for Control-K, Control-N, Control-P, and other Control mappings.
- A Caps tap provides the backtick used by Vim marks and by Markdown code spans.
- Right Command+H/J/K/L reaches Vim or Neovim as arrow-key events, not as Command-modified letters.

## 17. Cross-application interaction rules

### 17.1 Obsidian

- Obsidian is an occasional application.
- The user enables Vim-style editing in Obsidian.
- No Obsidian configuration is stored in the repository snapshot.
- Escape, Control, standard US punctuation, and normal Command shortcuts MUST remain practical in Obsidian.

### 17.2 Directional navigation layers

The future design MUST preserve these separate navigation layers:

| Physical or logical pattern      | Scope                                    |
| -------------------------------- | ---------------------------------------- |
| Right Command+H/J/K/L            | Text, page, and general arrow navigation |
| Option+H/J/K/L                   | AeroSpace window focus                   |
| Tmux prefix, then H/J/K/L        | Tmux pane focus                          |
| Plain H/J/K/L in Vim normal mode | Editor movement                          |

### 17.3 Number-selection layers

The future design MUST preserve these separate selection layers:

| Pattern                  | Scope               |
| ------------------------ | ------------------- |
| Command+number           | Browser tab         |
| Right Command+number     | Application launch  |
| Option+number            | AeroSpace workspace |
| Tmux prefix, then number | Tmux window         |

### 17.4 Tab layers

The future design MUST preserve these separate Tab actions:

| Pattern                   | Scope                        |
| ------------------------- | ---------------------------- |
| Control+Tab               | Browser tab cycle            |
| Command+Tab               | macOS application cycle      |
| Option+Tab                | AeroSpace previous workspace |
| Tmux prefix, then Tab     | Previous Tmux window         |
| Space, then Tab in Neovim | Previous Neovim buffer       |

This parallel structure is a primary design constraint.

## 18. Cross-keyboard consistency requirements

### 18.1 Semantic consistency

The same logical modifier name MUST mean the same workflow scope on all four keyboards.

The physical location can differ when the keyboard shape requires it. The logical role must remain clear.

### 18.2 High-frequency access

The future design MUST give practical access to:

- Right Command with H/J/K/L
- Right Command with 0 to 6
- Command with Tab and the number row
- Option with Tab, H/J/K/L, and the number row
- Control-B followed by H/J/K/L, number keys, or Tab
- Control+Option+Command with 6 to 9
- Fn/Globe for dictation
- Left Shift for all Shift actions
- Escape
- Backtick and tilde

### 18.3 Standard character access

All normal US ANSI letters, numbers, and symbols MUST remain available.

Markdown and coding make the following symbols especially relevant:

- Backtick and tilde
- Brackets and braces
- Parentheses
- Slash and backslash
- Hyphen, underscore, equals, and plus
- Colon and semicolon
- Single and double quotes
- Less-than and greater-than signs
- Hash, asterisk, ampersand, pipe, and dollar sign

### 18.4 Firmware and software overlap

The future design MUST account for duplicate processing.

For example, a Borne firmware mapping and a Karabiner mapping can both change the same input. The final event must be defined once and must not depend on accidental double remapping.

### 18.5 Device and transport identity

Karabiner device conditions use HID vendor and product IDs. They do not use marketing model names.

The same keyboard can expose different identities over USB, Bluetooth, and a wireless receiver. A future mapping design must treat this as a requirement condition.

## 19. Low-priority portability context

### 19.1 Linux

Linux portability is TIE-BREAK ONLY.

Relevant facts:

- Vim bindings already transfer naturally across operating systems.
- External keyboard firmware transfers with the keyboard.
- Karabiner and macOS defaults do not transfer.
- Linux normally uses Super where macOS uses Command.
- The important target is semantic muscle memory, not identical operating-system modifier names.
- Separate Linux dotfiles can implement system-level actions.

No active Linux remapping design is in scope for this document.

### 19.2 iPadOS

iPadOS portability is TIE-BREAK ONLY.

Relevant facts:

- The M1 iPad Air keyboard case cannot receive the same software remapping as macOS.
- An external programmable keyboard can send its firmware-defined HID events to iPadOS.
- Obsidian with Vim bindings is the main iPadOS use case.
- Right Shift as Escape would be useful.
- Caps tap as backtick and Caps chord as Control would be useful.

No iPadOS-specific optimization is in scope unless two macOS designs are otherwise equal.

## 20. Non-goals

This specification does not:

- Select a final key layout
- Select Borne layers
- Select encoder actions
- Flash keyboard firmware
- Change QMK, Vial, or Karabiner
- Change macOS settings
- Change AeroSpace, Tmux, Zen, Ghostty, Bash, Vim, or Neovim
- Change the existing keyboard diagrams
- Optimize for Linux before macOS
- Optimize for iPadOS before the four regular keyboards
- Require use of the built-in arrow clusters
- Restore Caps Lock as a capital-lock key
- Restore Right Shift as a Shift key

## 21. Acceptance criteria for a future design

A future design is acceptable only if all Priority 0 requirements pass.

The future design must make it possible to verify the following points on each regular keyboard:

1. Right Command+H/J/K/L performs the required navigation.
2. Right Command+D/U performs Page Down/Page Up.
3. Right Command+0 to 6 launches the required applications.
4. Command+number and Command+Tab retain browser and macOS actions.
5. Control+Tab retains browser tab cycling.
6. Option+number, Option+Tab, and Option+H/J/K/L retain AeroSpace actions.
7. Control-B followed by H/J/K/L, number, or Tab retains Tmux navigation.
8. Control+Option+Command+6 to 9 retains screenshot actions.
9. Fn/Globe toggles GhostPepper dictation.
10. Right Shift or its agreed equivalent provides Escape.
11. Caps tap provides backtick and Caps chord provides Control.
12. Left Shift can produce all capital letters, symbols, and Shift shortcuts.
13. All standard US ANSI characters remain available.
14. Zen raw-URL and Markdown-link copy shortcuts remain distinct.
15. Vim, Neovim, Readline Vi mode, Tmux Vi copy mode, and Obsidian Vim mode remain practical.
16. No unintended firmware-plus-Karabiner double remap changes the final event.

Priority 2 and Priority 3 requirements can only decide between designs that already pass these criteria.

## 22. Open facts

The following facts are not stored in the current repository or conversation artifacts:

- The complete current Borne firmware keymap and all layers
- Current Borne encoder actions
- The exact HID identity of each regular keyboard over each connection mode
- The exact Shottr actions assigned to Control+Option+Command+7, 8, and 9
- The GhostPepper shortcut implementation and accepted HID event
- The live Zen profile state after its last manual synchronization
- The active macOS keyboard input source
- Any remaps in untracked `~/.config/.extra`
- Any manual macOS keyboard shortcuts that are not written by `macos.sh`
- Any live application shortcuts that are not stored in the repository
- Future Omarchy keybinding and compositor configuration
- Actual iPadOS behaviour with each external keyboard

These are information gaps. They are not design decisions.

## 23. Source baseline

Repository: <https://github.com/gianlucatruda/dotfiles>

Audited snapshot: <https://github.com/gianlucatruda/dotfiles/tree/03d32c0c66568f517b9d5afda2e46488b3a0147d>

Primary repository sources:

- `macos.sh`
- `.config/karabiner/karabiner.json`
- `.config/karabiner/complex_modifications/1584620783.json`
- `.config/aerospace/aerospace.toml`
- `.config/tmux/tmux.conf`
- `.config/ghostty/config`
- `.config/.inputrc`
- `.bash_profile`
- `.config/.exports`
- `.config/.aliases`
- `.config/.functions`
- `.vimrc`
- `.config/nvim/lua/core/keymaps.lua`
- `.config/nvim/lua/core/options.lua`
- `.config/nvim/lua/plugin_config/*.lua`
- `.config/zen/zen-keyboard-shortcuts.json`
- `.config/homebrew/Brewfile`
- `README.md`

Visual layout baseline:

- `keyboard-layout-comparison.svg`
- Keychron K6 photo supplied by the user
- YIVU Borne photos supplied by the user
- Lofree Flow Lite84 photo supplied by the user
- Personal MacBook Pro keyboard photo supplied by the user
