"""Render docs/cover.html to docs/cover.png (1600x900 @2x).

Usage:  python3 docs/render-cover.py        (needs `pip install playwright` and Google Chrome)
"""
import pathlib
from playwright.sync_api import sync_playwright

root = pathlib.Path(__file__).resolve().parent.parent
src = (root / "docs" / "cover.html").read_text(encoding="utf-8")
sprite = (root / "assets" / "icons-sprite.svg").read_text(encoding="utf-8")
built = root / "docs" / "_cover.built.html"
built.write_text(src.replace("<!--SPRITE-->", sprite), encoding="utf-8")

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(channel="chrome")
        page = browser.new_page(viewport={"width": 1600, "height": 900}, device_scale_factor=2)
        page.goto(built.as_uri())
        page.wait_for_load_state("networkidle")
        page.evaluate("document.fonts.ready")
        page.locator(".cover").screenshot(path=str(root / "docs" / "cover.png"))
        browser.close()
finally:
    built.unlink(missing_ok=True)
print("wrote docs/cover.png")
