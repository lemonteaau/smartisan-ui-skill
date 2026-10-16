#!/usr/bin/env python3
"""Build the Smartisan glyph icon font from the vendored Phosphor "fill" SVGs.

Smartisan OS draws its icons as soft, filled, rounded glyphs in pale grey
(see the Settings / Music / App Store apps on a real Smartisan R2). Material's
outline icons are the biggest source of the "Material" look, so the app uses
this font instead for the icons people see most.

Source: Phosphor Icons (MIT, see svg/LICENSE), fill weight, 256-unit grid.

Usage:
    python3 assets/flutter/glyphs/build.py
Outputs:
    assets/flutter/glyphs/smartisan_glyphs.ttf
    assets/flutter/smartisan_glyphs.dart

Weights: plain stems use Phosphor "fill"; stems ending in "-bold" / "-regular"
use those line weights (✓, ×, +, carets, the thin search magnifier), because
Smartisan draws marks and chevrons as lines. `smartisan-more*-bold.svg` are
drawn for this project (Smartisan's chunky "•••").

To add a glyph: copy `<name>-fill.svg` from @phosphor-icons/core into svg/,
add a `semantic_name: file_stem` line to GLYPHS below and rebuild. Never
renumber existing glyphs (code points are assigned in list order).
"""

import os
import re
import sys

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.svgLib.path import parse_path

HERE = os.path.dirname(os.path.abspath(__file__))
SVG_DIR = os.path.join(HERE, "svg")
FONT_OUT = os.path.join(HERE, "smartisan_glyphs.ttf")
DART_OUT = os.path.join(os.path.dirname(HERE), "smartisan_glyphs.dart")
FAMILY = "SmartisanGlyphs"
UPM = 256
FIRST_CODEPOINT = 0xE000

# semantic name (Dart identifier) : Phosphor file stem (without -fill.svg)
GLYPHS = """
home: house
homeSimple: house-simple
dynamic: compass
user: user
search: magnifying-glass-regular
arrowLeft: arrow-left
more: smartisan-more-bold
moreVertical: smartisan-more-vertical-bold
caretRight: caret-right-bold
caretDown: caret-down-bold
caretUp: caret-up-bold
caretLeft: caret-left-bold
like: thumbs-up
dislike: thumbs-down
coin: coin
star: star
starHalf: star-half
heart: heart
share: share-fat
shareNetwork: share-network
comment: chat-circle-dots
chat: chat-circle
danmaku: chat-teardrop-text
reply: arrow-bend-up-left
clock: clock
history: rewind-circle
countdown: clock-countdown
timer: timer
hourglass: hourglass
download: arrow-circle-down
downloadTray: download
upload: upload-simple
uploadTray: upload
cloudDownload: cloud-arrow-down
settings: gear-six
bell: bell
mail: envelope-simple
play: play
pause: pause
playCircle: play-circle
tv: television-simple
fire: fire
trophy: trophy
category: squares-four
film: film-strip
live: broadcast
filter: funnel
sortAscending: sort-ascending
sortDescending: sort-descending
trash: trash
edit: pencil-simple
close: x-bold
closeCircle: x-circle
add: plus-bold
addCircle: plus-circle
minus: minus-bold
minusCircle: minus-circle
check: check-bold
checkCircle: check-circle
info: info
warning: warning
warningCircle: warning-circle
question: question
lock: lock
eye: eye
eyeSlash: eye-slash
link: link
openExternal: arrow-square-out
export: export
image: image
folder: folder
cloud: cloud
refresh: arrow-clockwise
undo: arrow-counter-clockwise
copy: copy
bookmark: bookmark-simple
bookBookmark: book-bookmark
tag: tag
hash: hash
at: at
emoji: smiley
microphone: microphone
camera: camera
videoCamera: video-camera
music: music-notes
headphones: headphones
volume: speaker-high
mute: speaker-slash
fullscreen: corners-out
fullscreenExit: corners-in
pip: picture-in-picture
speed: gauge
subtitles: closed-captioning
hd: high-definition
sliders: sliders-horizontal
list: list-bullets
listNumbers: list-numbers
grid: grid-four
calendar: calendar-blank
location: map-pin
globe: globe
shield: shield-check
key: key
bug: bug
sun: sun
moon: moon
palette: palette
translate: translate
qrCode: qr-code
scan: scan
phone: device-mobile
desktop: desktop
signOut: sign-out
userSwitch: user-switch
userPlus: user-plus
users: users-three
crown: crown
gift: gift
wallet: wallet
flag: flag
block: prohibit
arrowUp: arrow-up
arrowDown: arrow-down
arrowLineUp: arrow-line-up
arrowLineDown: arrow-line-down
arrowsDownUp: arrows-down-up
arrowsClockwise: arrows-clockwise
repeat: repeat
shuffle: shuffle
skipNext: skip-forward
skipPrevious: skip-back
rewind: rewind
fastForward: fast-forward
queue: queue
playlist: playlist
note: note-pencil
article: article
book: book-open
news: newspaper
archive: archive
tray: tray
pin: push-pin
lightning: lightning
sparkle: sparkle
robot: robot
locate: crosshair
magic: magic-wand
brush: paint-brush
send: paper-plane-right
attachment: paperclip
dragHandle: dots-six-vertical
textSize: text-aa
rocket: rocket-launch
idCard: identification-card
store: storefront
clipboard: clipboard-text
receipt: receipt
cards: cards
file: file-text
vibrate: vibrate
battery: battery-full
wifi: wifi-high
loading: circle-notch
eraser: eraser
selectAll: selection-all
tap: hand-tap
"""


def parse_glyphs():
    out = []
    for line in GLYPHS.strip().splitlines():
        name, stem = (s.strip() for s in line.split(":"))
        out.append((name, stem))
    names = [n for n, _ in out]
    if len(names) != len(set(names)):
        sys.exit("duplicate glyph names")
    return out


def svg_paths(path):
    with open(path, encoding="utf-8") as f:
        src = f.read()
    if 'viewBox="0 0 256 256"' not in src:
        sys.exit(f"{path}: unexpected viewBox")
    return re.findall(r'<path[^>]*\sd="([^"]+)"', src)


def build_glyph(paths):
    tt = TTGlyphPen(None)
    # SVG is y-down, fonts are y-up: flip around the 256-unit em box.
    pen = TransformPen(Cu2QuPen(tt, max_err=0.25, reverse_direction=True), (1, 0, 0, -1, 0, UPM))
    for d in paths:
        parse_path(d, pen)
    return tt.glyph()


def main():
    glyphs = parse_glyphs()
    order = [".notdef"]
    cmap = {}
    outlines = {".notdef": TTGlyphPen(None).glyph()}
    metrics = {".notdef": (UPM, 0)}
    for i, (name, stem) in enumerate(glyphs):
        # "-regular" / "-bold" stems use Phosphor's line weights (thin
        # magnifier, ✓, ×, +, chevrons — Smartisan draws these as lines).
        fname = (
            f"{stem}.svg"
            if stem.endswith(("-regular", "-bold"))
            else f"{stem}-fill.svg"
        )
        svg = os.path.join(SVG_DIR, fname)
        if not os.path.exists(svg):
            sys.exit(f"missing {svg}")
        gname = f"g_{name}"
        order.append(gname)
        cmap[FIRST_CODEPOINT + i] = gname
        outlines[gname] = build_glyph(svg_paths(svg))
        metrics[gname] = (UPM, 0)

    fb = FontBuilder(UPM, isTTF=True)
    fb.setupGlyphOrder(order)
    fb.setupCharacterMap(cmap)
    fb.setupGlyf(outlines)
    fb.setupHorizontalMetrics(metrics)
    fb.setupHorizontalHeader(ascent=UPM, descent=0)
    fb.setupNameTable({"familyName": FAMILY, "styleName": "Regular"})
    fb.setupOS2(
        version=4,
        sTypoAscender=UPM,
        sTypoDescender=0,
        sTypoLineGap=0,
        usWinAscent=UPM,
        usWinDescent=0,
        fsSelection=0x80,  # USE_TYPO_METRICS
    )
    fb.setupPost()
    os.makedirs(os.path.dirname(FONT_OUT), exist_ok=True)
    fb.save(FONT_OUT)

    lines = [
        "// GENERATED by tool/smartisan_glyphs/build.py — do not edit by hand.",
        "// Smartisan-style filled glyphs (Phosphor Icons fill weight, MIT).",
        "// Use like Material icons: `Icon(SGlyphs.like)`; colour/size come from IconTheme.",
        "",
        "import 'package:flutter/widgets.dart';",
        "",
        "abstract final class SGlyphs {",
        f"  static const _family = '{FAMILY}';",
        "",
    ]
    for i, (name, stem) in enumerate(glyphs):
        lines.append(f"  /// Phosphor `{stem}`")
        lines.append(
            f"  static const IconData {name} = IconData(0x{FIRST_CODEPOINT + i:X}, fontFamily: _family);"
        )
    lines.append("}")
    with open(DART_OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    print(f"{len(glyphs)} glyphs -> {os.path.relpath(FONT_OUT, HERE)}, {os.path.relpath(DART_OUT, HERE)}")


if __name__ == "__main__":
    main()
