#!/usr/bin/env python3
"""Generate an editable stock-layout comparison for the Borne and Flow Lite84."""

from __future__ import annotations

import html
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SVG_PATH = ROOT / "keyboard-layout-comparison.svg"
HTML_PATH = ROOT / "keyboard-layout-comparison.html"

W, H = 1600, 1450
PITCH = 70
CAP = 62


def esc(value: object) -> str:
    return html.escape(str(value), quote=True)


def key(
    board: str,
    key_id: str,
    x: float,
    y: float,
    primary: str,
    secondary: str = "",
    width_u: float = 1.0,
    height_u: float = 1.0,
    role: str = "typing",
    angle: float = 0,
) -> str:
    w = width_u * PITCH - (PITCH - CAP)
    h = height_u * PITCH - (PITCH - CAP)
    classes = f"key {board}-key role-{role}"
    transform = f'translate({x:.1f} {y:.1f})'
    if angle:
        transform += f' rotate({angle:.1f} {w / 2:.1f} {h / 2:.1f})'
    if "\n" in primary and not secondary:
        primary, secondary = primary.split("\n", 1)
    if secondary:
        primary_y = h * 0.43
        secondary_y = h * 0.69
        primary_size = 17 if len(primary) <= 6 else 14
        secondary_size = 12
    else:
        primary_y = h * 0.58
        secondary_y = 0
        primary_size = 17 if len(primary) <= 6 else 13
        secondary_size = 0
    title = f"{board.title()}: {primary}" + (f" / {secondary}" if secondary else "")
    parts = [
        f'<g id="{esc(board)}-key-{esc(key_id)}" class="{classes}" '
        f'data-board="{esc(board)}" data-key-id="{esc(key_id)}" '
        f'data-stock-primary="{esc(primary)}" data-stock-secondary="{esc(secondary)}" '
        f'data-role="{esc(role)}" transform="{transform}">',
        f"<title>{esc(title)}</title>",
        f'<rect class="key-shadow" x="1" y="3" width="{w:.1f}" height="{h:.1f}" rx="10"/>',
        f'<rect class="keycap" width="{w:.1f}" height="{h:.1f}" rx="10"/>',
        f'<rect class="role-mark" x="8" y="7" width="{max(15, min(w - 16, 28)):.1f}" height="3" rx="1.5"/>',
        f'<text class="key-label" x="{w / 2:.1f}" y="{primary_y:.1f}" '
        f'font-size="{primary_size}" text-anchor="middle">{esc(primary)}</text>',
    ]
    if secondary:
        parts.append(
            f'<text class="key-secondary" x="{w / 2:.1f}" y="{secondary_y:.1f}" '
            f'font-size="{secondary_size}" text-anchor="middle">{esc(secondary)}</text>'
        )
    parts.append("</g>")
    return "".join(parts)


def encoder(board: str, key_id: str, cx: float, cy: float, label: str) -> str:
    return f"""
      <g id="{board}-control-{key_id}" class="encoder {board}-encoder" data-board="{board}" data-control-id="{key_id}" data-stock-primary="Unlabelled rotary encoder">
        <title>{esc(label)}. Rotation and press actions are not printed on the stock keycaps.</title>
        <circle class="encoder-shadow" cx="{cx + 2}" cy="{cy + 4}" r="34"/>
        <circle class="encoder-ring" cx="{cx}" cy="{cy}" r="34"/>
        <circle class="encoder-face" cx="{cx}" cy="{cy}" r="27"/>
        <path class="encoder-highlight" d="M {cx - 17} {cy - 16} A 24 24 0 0 1 {cx + 14} {cy - 18}"/>
        <text class="control-caption" x="{cx}" y="{cy + 53}" text-anchor="middle">Encoder</text>
      </g>
    """


def borne_layout() -> tuple[str, list[dict[str, object]]]:
    out: list[str] = []
    data: list[dict[str, object]] = []
    y0 = 218
    row_pitch = 76
    left_x = 105
    left_offsets = [18, 8, -6, -18, -6, 10]
    left_columns = [
        [("esc", "Esc", "modifier"), ("tab", "Tab", "modifier"), ("caps", "Caps\nLock", "modifier"), ("lshift", "Shift", "modifier")],
        [("1", "1\n!", "typing"), ("q", "Q", "typing"), ("a", "A", "typing"), ("z", "Z", "typing")],
        [("2", "2\n@", "typing"), ("w", "W", "typing"), ("s", "S", "typing"), ("x", "X", "typing")],
        [("3", "3\n#", "typing"), ("e", "E", "typing"), ("d", "D", "typing"), ("c", "C", "typing")],
        [("4", "4\n$", "typing"), ("r", "R", "typing"), ("f", "F", "typing"), ("v", "V", "typing")],
        [("5", "5\n%", "typing"), ("t", "T", "typing"), ("g", "G", "typing"), ("b", "B", "typing")],
    ]
    for col, cells in enumerate(left_columns):
        x = left_x + col * PITCH
        for row, (kid, label, role) in enumerate(cells):
            y = y0 + left_offsets[col] + row * row_pitch
            out.append(key("borne", f"l-{kid}", x, y, label, role=role))
            data.append({"id": f"l-{kid}", "legend": label, "role": role})

    right_x = 1010
    right_offsets = [10, -6, -18, -6, 8, 18]
    right_columns = [
        [("6", "6\n^", "typing"), ("y", "Y", "typing"), ("h", "H", "typing"), ("n", "N", "typing")],
        [("7", "7\n&", "typing"), ("u", "U", "typing"), ("j", "J", "typing"), ("m", "M", "typing")],
        [("8", "8\n*", "typing"), ("i", "I", "typing"), ("k", "K", "typing"), ("comma", ",\n<", "typing")],
        [("9", "9\n(", "typing"), ("o", "O", "typing"), ("l", "L", "typing"), ("dot", ".\n>", "typing")],
        [("0", "0\n)", "typing"), ("p", "P", "typing"), ("semicolon", ";\n:", "typing"), ("slash", "/\n?", "typing")],
        [("backspace", "Back\nSpace", "editing"), ("enter-upper", "Enter", "editing"), ("quote", "'\n\"", "typing"), ("delete", "Delete", "editing")],
    ]
    for col, cells in enumerate(right_columns):
        x = right_x + col * PITCH
        for row, (kid, label, role) in enumerate(cells):
            y = y0 + right_offsets[col] + row * row_pitch
            out.append(key("borne", f"r-{kid}", x, y, label, role=role))
            data.append({"id": f"r-{kid}", "legend": label, "role": role})

    for kid, label, x, y in [
        ("l-up", "↑", 535, 228),
        ("l-down", "↓", 535, 304),
        ("r-left", "←", 940, 220),
        ("r-right", "→", 940, 296),
    ]:
        out.append(key("borne", kid, x, y, label, role="navigation"))
        data.append({"id": kid, "legend": label, "role": "navigation"})

    thumb_specs = [
        ("l-ctrl", 348, 555, "Ctrl", "modifier", 0, 1.0),
        ("l-fn", 423, 565, "Fn", "layer", 7, 1.0),
        ("l-space", 498, 550, "Space", "editing", 25, 1.35),
        ("r-enter-thumb", 920, 550, "Enter", "editing", -25, 1.35),
        ("r-fn", 1021, 565, "Fn", "layer", -7, 1.0),
        ("r-win", 1096, 555, "Win", "modifier", 0, 1.0),
    ]
    for kid, x, y, label, role, angle, width in thumb_specs:
        out.append(key("borne", kid, x, y, label, width_u=width, role=role, angle=angle))
        data.append({"id": kid, "legend": label, "role": role})

    out.append(encoder("borne", "left-encoder", 566, 423, "Left rotary encoder"))
    out.append(encoder("borne", "right-encoder", 969, 415, "Right rotary encoder"))
    data.extend([
        {"id": "left-encoder", "legend": "Unlabelled encoder", "role": "encoder"},
        {"id": "right-encoder", "legend": "Unlabelled encoder", "role": "encoder"},
    ])
    return "\n".join(out), data


def lofree_layout() -> tuple[str, list[dict[str, object]]]:
    out: list[str] = []
    data: list[dict[str, object]] = []
    x0 = 225
    y0 = 900
    row_pitch = 74

    def add_row(row_id: str, row: list[tuple], y: float) -> None:
        x = x0
        for idx, spec in enumerate(row):
            kid, primary = spec[0], spec[1]
            secondary = spec[2] if len(spec) > 2 else ""
            width = spec[3] if len(spec) > 3 else 1.0
            role = spec[4] if len(spec) > 4 else "typing"
            out.append(key("lofree", kid, x, y, primary, secondary, width_u=width, role=role))
            data.append({"id": kid, "legend": primary, "secondary": secondary, "role": role})
            x += width * PITCH

    function_row = [("esc", "Esc", "", 1, "modifier")]
    fn_secondary = ["Screen −", "Screen +", "Mission", "Search", "Light −", "Light +", "Previous", "Play/Pause", "Next", "Mute", "Volume −", "Volume +"]
    function_row += [(f"f{i}", f"F{i}", fn_secondary[i - 1], 1, "function") for i in range(1, 13)]
    function_row += [
        ("prtsc", "PrtSc", "Calculator", 1, "function"),
        ("insert", "Ins", "Voice", 1, "function"),
        ("delete", "Del", "Lock", 1, "editing"),
    ]
    add_row("function", function_row, y0)

    add_row("number", [
        ("grave", "`", "~"), ("1", "1", "!"), ("2", "2", "@"), ("3", "3", "#"),
        ("4", "4", "$"), ("5", "5", "%"), ("6", "6", "^"), ("7", "7", "&"),
        ("8", "8", "*"), ("9", "9", "("), ("0", "0", ")"), ("minus", "−", "_"),
        ("equal", "=", "+"), ("backspace", "Backspace", "", 2, "editing"), ("home", "Home", "", 1, "navigation")
    ], y0 + row_pitch)

    add_row("qwerty", [
        ("tab", "Tab", "", 1.5, "modifier"),
        *[(letter.lower(), letter) for letter in "QWERTYUIOP"],
        ("lbracket", "[", "{"), ("rbracket", "]", "}"),
        ("backslash", "\\", "|", 1.5), ("end", "End", "", 1, "navigation")
    ], y0 + row_pitch * 2)

    add_row("home", [
        ("caps", "Caps", "", 1.75, "modifier"),
        *[(letter.lower(), letter) for letter in "ASDFGHJKL"],
        ("semicolon", ";", ":"), ("quote", "'", '"'),
        ("enter", "Enter", "", 2.25, "editing"), ("pageup", "PgUp", "", 1, "navigation")
    ], y0 + row_pitch * 3)

    add_row("shift", [
        ("lshift", "Shift", "", 2.25, "modifier"),
        *[(letter.lower(), letter) for letter in "ZXCVBNM"],
        ("comma", ",", "<"), ("dot", ".", ">"), ("slash", "/", "?"),
        ("rshift", "Shift", "", 1.75, "modifier"),
        ("up", "↑", "", 1, "navigation"), ("pagedown", "PgDn", "", 1, "navigation")
    ], y0 + row_pitch * 4)

    add_row("bottom", [
        ("lctrl", "Ctrl", "", 1.25, "modifier"),
        ("win", "Win", "", 1.25, "modifier"),
        ("lalt", "⌘ Alt", "", 1.25, "modifier"),
        ("space", "Space", "", 6.25, "editing"),
        ("ralt", "⌘ Alt", "", 1, "modifier"),
        ("fn", "Fn", "", 1, "layer"),
        ("rctrl", "Ctrl", "", 1, "modifier"),
        ("left", "←", "", 1, "navigation"),
        ("down", "↓", "", 1, "navigation"),
        ("right", "→", "", 1, "navigation"),
    ], y0 + row_pitch * 5)
    return "\n".join(out), data


def render() -> tuple[str, str]:
    borne, borne_data = borne_layout()
    lofree, lofree_data = lofree_layout()
    metadata = {
        "version": 1,
        "basis": "Physical stock keycap legends",
        "sources": [
            {"type": "user-photo", "description": "YIVU Borne as received"},
            {"type": "user-photo", "description": "Lofree Flow Lite84 at the user's work desk"},
            {"type": "web", "url": "https://www.lofree.co/products/flow-lite84-mechanical-keyboard", "description": "Official Lofree product layout"},
            {"type": "web", "url": "https://cdn.shopify.com/s/files/1/2779/9046/files/Flow_Lite84_User_Manual.pdf?v=1747372676", "description": "Official Lofree Flow Lite84 manual"},
            {"type": "web", "url": "https://www.amazon.co.uk/dp/B0GSTX5BR5", "description": "YIVU Borne product listing"},
        ],
        "boards": {
            "borne": {"name": "YIVU Borne", "controls": 60, "keys": borne_data},
            "lofree": {"name": "Lofree Flow Lite84", "keys": 84, "keys_data": lofree_data},
        },
    }
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" role="img" aria-labelledby="svg-title svg-desc">
  <title id="svg-title">Stock keyboard layout comparison: YIVU Borne and Lofree Flow Lite84</title>
  <desc id="svg-desc">The split, column-staggered 60-control Borne is above the conventional 84-key ANSI Lofree Flow Lite84. All visible labels reproduce the stock keycap legends.</desc>
  <metadata id="layout-data"><![CDATA[{json.dumps(metadata, ensure_ascii=False, separators=(',', ':'))}]]></metadata>
  <defs>
    <filter id="panel-shadow" x="-10%" y="-10%" width="120%" height="130%"><feDropShadow dx="0" dy="7" stdDeviation="10" flood-opacity="0.10"/></filter>
    <filter id="key-shadow-filter" x="-20%" y="-20%" width="140%" height="150%"><feGaussianBlur in="SourceAlpha" stdDeviation="1.5"/><feOffset dy="2"/><feComponentTransfer><feFuncA type="linear" slope="0.22"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge></filter>
    <linearGradient id="encoder-metal" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f4f6f8"/><stop offset="0.45" stop-color="#9aa4af"/><stop offset="0.7" stop-color="#edf0f2"/><stop offset="1" stop-color="#6f7882"/></linearGradient>
  </defs>
  <style>
    :root {{ color-scheme: light dark; }}
    text {{ font-family: Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }}
    .canvas {{ fill: #eef2f5; }}
    .panel {{ fill: #ffffff; stroke: #d5dce3; stroke-width: 1.5; filter: url(#panel-shadow); }}
    .panel-title {{ fill: #17202a; font-size: 30px; font-weight: 500; }}
    .panel-subtitle {{ fill: #647180; font-size: 16px; font-weight: 400; }}
    .badge {{ fill: #e6ebf0; }}
    .badge-text {{ fill: #3d4956; font-size: 14px; font-weight: 500; }}
    .board-plate {{ fill: #20262d; stroke: #101419; stroke-width: 2; }}
    .lofree-case {{ fill: #c8c7c2; stroke: #a5a6a2; stroke-width: 2; }}
    .key-shadow {{ fill: #000000; opacity: .16; }}
    .keycap {{ stroke-width: 1.2; filter: url(#key-shadow-filter); }}
    .borne-key .keycap {{ fill: #505861; stroke: #242a31; }}
    .borne-key .key-label {{ fill: #f7f9fb; }}
    .borne-key .key-secondary {{ fill: #d4d9df; }}
    .lofree-key .keycap {{ fill: #f8f8f5; stroke: #bbbdbb; }}
    .lofree-key .key-label {{ fill: #32383f; }}
    .lofree-key .key-secondary {{ fill: #717980; }}
    .key-label {{ font-weight: 500; dominant-baseline: middle; }}
    .key-secondary {{ font-weight: 400; dominant-baseline: middle; }}
    .role-mark {{ opacity: .9; }}
    .role-typing .role-mark {{ fill: #8a96a3; opacity: .28; }}
    .role-modifier .role-mark {{ fill: #4879b9; }}
    .role-editing .role-mark {{ fill: #b46c45; }}
    .role-navigation .role-mark {{ fill: #4b946d; }}
    .role-function .role-mark {{ fill: #7f68ad; }}
    .role-layer .role-mark {{ fill: #c49138; }}
    .encoder-shadow {{ fill: #000000; opacity: .22; }}
    .encoder-ring {{ fill: #3a4148; stroke: #161b20; stroke-width: 2; }}
    .encoder-face {{ fill: url(#encoder-metal); stroke: #5a626a; stroke-width: 1; }}
    .encoder-highlight {{ fill: none; stroke: #ffffff; stroke-opacity: .62; stroke-width: 2; stroke-linecap: round; }}
    .control-caption {{ fill: #657180; font-size: 13px; }}
    .roller-body {{ fill: url(#encoder-metal); stroke: #7b8186; stroke-width: 1; }}
    .roller-line {{ stroke: #6e7479; stroke-width: 1; }}
    .legend-label {{ fill: #66727f; font-size: 14px; }}
    .legend-swatch {{ stroke: none; }}
    .note {{ fill: #6a7683; font-size: 14px; }}
  </style>

  <rect class="canvas" width="{W}" height="{H}"/>

  <g id="borne-panel" data-layout="stock">
    <rect class="panel" x="45" y="40" width="1510" height="675" rx="26"/>
    <text class="panel-title" x="85" y="91">YIVU Borne</text>
    <text class="panel-subtitle" x="85" y="119">Stock keycap legends · split column-staggered 4×6 · adjustable split gap</text>
    <g transform="translate(1260 67)"><rect class="badge" width="250" height="38" rx="19"/><text class="badge-text" x="125" y="24" text-anchor="middle">60 controls · 2 encoders</text></g>
    <path class="board-plate" d="M78 183 Q78 157 104 157 H603 Q635 157 647 187 L682 566 Q685 596 657 611 L590 648 H86 Q64 648 64 626 V205 Q64 183 78 183 Z"/>
    <path class="board-plate" d="M918 187 Q930 157 962 157 H1461 Q1487 157 1487 183 V626 Q1487 648 1465 648 H961 L894 611 Q866 596 869 566 L904 187 Z"/>
    <g id="borne-stock-keys">{borne}</g>
    <text class="note" x="800" y="670" text-anchor="middle">Encoder rotation and press actions are not printed on the stock keycaps.</text>
  </g>

  <g id="lofree-panel" data-layout="stock">
    <rect class="panel" x="45" y="745" width="1510" height="665" rx="26"/>
    <text class="panel-title" x="85" y="796">Lofree Flow Lite84</text>
    <text class="panel-subtitle" x="85" y="824">Stock ANSI legends · conventional staggered 75% layout · dedicated navigation column</text>
    <g transform="translate(1260 772)"><rect class="badge" width="250" height="38" rx="19"/><text class="badge-text" x="125" y="24" text-anchor="middle">84 keys · volume roller</text></g>
    <rect class="lofree-case" x="190" y="850" width="1195" height="485" rx="32"/>
    <g id="lofree-volume-roller" transform="translate(1285 866)">
      <rect class="roller-body" x="0" y="0" width="70" height="24" rx="8"/>
      <path class="roller-line" d="M9 3 V21 M17 3 V21 M25 3 V21 M33 3 V21 M41 3 V21 M49 3 V21 M57 3 V21"/>
      <text class="control-caption" x="-12" y="17" text-anchor="end">Volume roller</text>
    </g>
    <g id="lofree-stock-keys">{lofree}</g>
  </g>

  <g id="role-legend" transform="translate(260 1370)">
    <g transform="translate(0 0)"><rect class="legend-swatch" fill="#4879b9" width="18" height="5" rx="2"/><text class="legend-label" x="28" y="8">modifier</text></g>
    <g transform="translate(150 0)"><rect class="legend-swatch" fill="#b46c45" width="18" height="5" rx="2"/><text class="legend-label" x="28" y="8">editing</text></g>
    <g transform="translate(285 0)"><rect class="legend-swatch" fill="#4b946d" width="18" height="5" rx="2"/><text class="legend-label" x="28" y="8">navigation</text></g>
    <g transform="translate(450 0)"><rect class="legend-swatch" fill="#7f68ad" width="18" height="5" rx="2"/><text class="legend-label" x="28" y="8">function/media</text></g>
    <g transform="translate(650 0)"><rect class="legend-swatch" fill="#c49138" width="18" height="5" rx="2"/><text class="legend-label" x="28" y="8">layer</text></g>
    <text class="note" x="860" y="8">1u key scale normalized · split gap illustrative</text>
  </g>
</svg>'''

    html_fragment = f'''<div id="keyboard-layout-comparison" style="width:100%;max-width:100%;">
  <style>
    #keyboard-layout-comparison svg {{ display:block; width:100%; height:auto; }}
    #keyboard-layout-comparison .canvas {{ fill:var(--background); }}
    #keyboard-layout-comparison .panel {{ fill:var(--card); stroke:var(--border); }}
    #keyboard-layout-comparison .panel-title,
    #keyboard-layout-comparison .lofree-key .key-label {{ fill:var(--foreground); }}
    #keyboard-layout-comparison .panel-subtitle,
    #keyboard-layout-comparison .note,
    #keyboard-layout-comparison .legend-label,
    #keyboard-layout-comparison .control-caption,
    #keyboard-layout-comparison .lofree-key .key-secondary {{ fill:var(--muted-foreground); }}
    #keyboard-layout-comparison .badge {{ fill:var(--muted); }}
    #keyboard-layout-comparison .badge-text {{ fill:var(--muted-foreground); }}
    #keyboard-layout-comparison .lofree-case {{ fill:var(--secondary); stroke:var(--border); }}
    #keyboard-layout-comparison .lofree-key .keycap {{ fill:var(--card); stroke:var(--border); }}
  </style>
{svg}
</div>'''
    return svg, html_fragment


def main() -> None:
    svg, fragment = render()
    SVG_PATH.write_text(svg, encoding="utf-8")
    HTML_PATH.write_text(fragment, encoding="utf-8")


if __name__ == "__main__":
    main()
