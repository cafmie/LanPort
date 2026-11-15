#!/usr/bin/env python3
"""Regenerate LanPort PNG/ICO web + exe icons from assets/icon.webp.

Requires: pip install pillow

  python scripts/generate-icons.py
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "icon.webp"
ASSETS = ROOT / "assets"
WEB = ROOT / "src" / "pc_transfer" / "web"


def main() -> None:
    if not SOURCE.exists():
        raise SystemExit(f"Missing source artwork: {SOURCE}")

    im = Image.open(SOURCE).convert("RGBA")
    ASSETS.mkdir(parents=True, exist_ok=True)
    WEB.mkdir(parents=True, exist_ok=True)

    im.save(ASSETS / "icon.png", format="PNG", optimize=True)
    im.save(
        ASSETS / "icon.ico",
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
    )

    im.save(WEB / "icon.png", format="PNG", optimize=True)
    im.resize((192, 192), Image.Resampling.LANCZOS).save(
        WEB / "icon-192.png", format="PNG", optimize=True
    )
    im.resize((180, 180), Image.Resampling.LANCZOS).save(
        WEB / "apple-touch-icon.png", format="PNG", optimize=True
    )
    im.save(
        WEB / "favicon.ico",
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48)],
    )

    print(f"OK from {SOURCE.relative_to(ROOT)} → assets/ + web favicons")


if __name__ == "__main__":
    main()
