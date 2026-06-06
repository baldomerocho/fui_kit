#!/usr/bin/env python3
"""Generates the README banner and the pub.dev showcase screenshot.

Composes wrapper SVGs that embed (base64) re-tinted copies of a few icons,
then rasterizes them with rsvg-convert and converts to webp with cwebp.

Usage (from the package root):
    python3 tool/generate_images.py
"""

import base64
import os
import re
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "doc", "images")

STYLES = [
    ("Regular Rounded", "RegularRounded", "regular/rounded", "fi-rr"),
    ("Regular Straight", "RegularStraight", "regular/straight", "fi-rs"),
    ("Bold Rounded", "BoldRounded", "bold/rounded", "fi-br"),
    ("Bold Straight", "BoldStraight", "bold/straight", "fi-bs"),
    ("Solid Rounded", "SolidRounded", "solid/rounded", "fi-sr"),
    ("Solid Straight", "SolidStraight", "solid/straight", "fi-ss"),
]

BANNER_ICONS = [
    "heart", "home", "user", "settings", "bell", "search",
    "star", "comment", "camera", "shopping-cart", "calendar", "rocket",
]

ROW_ICONS = [
    "heart", "home", "user", "settings", "bell", "search", "star",
    "comment", "camera", "shopping-cart", "calendar", "bookmark",
]

PALETTE = [
    "#6366F1", "#EC4899", "#F59E0B", "#10B981", "#3B82F6", "#EF4444",
    "#8B5CF6", "#14B8A6", "#F97316", "#0EA5E9", "#22C55E", "#E11D48",
]

FILL_RE = re.compile(r'fill="#[0-9A-Fa-f]{6}"')


def icon_data_uri(style_dir: str, prefix: str, name: str, color: str) -> str:
    path = os.path.join(
        ROOT, "assets", "icons", style_dir, "svg", f"{prefix}-{name}.svg")
    with open(path) as fh:
        svg = fh.read()
    svg = FILL_RE.sub(f'fill="{color}"', svg)
    encoded = base64.b64encode(svg.encode()).decode()
    return f"data:image/svg+xml;base64,{encoded}"


def banner_svg() -> str:
    width, height = 1280, 340
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" '
        f'height="{height}" viewBox="0 0 {width} {height}">',
        f'<rect width="{width}" height="{height}" fill="#0F172A"/>',
        '<text x="640" y="110" text-anchor="middle" '
        'font-family="Helvetica, Arial, sans-serif" font-size="64" '
        'font-weight="bold" fill="#F8FAFC">fui_kit</text>',
        '<text x="640" y="160" text-anchor="middle" '
        'font-family="Helvetica, Arial, sans-serif" font-size="26" '
        'fill="#94A3B8">2,988 flat SVG icons · 6 styles · '
        'made for Flutter</text>',
    ]
    n = len(BANNER_ICONS)
    size = 56
    gap = (width - 160) / n
    y = 220
    for i, name in enumerate(BANNER_ICONS):
        x = 80 + i * gap + (gap - size) / 2
        uri = icon_data_uri("regular/rounded", "fi-rr", name, PALETTE[i])
        parts.append(
            f'<image x="{x:.0f}" y="{y}" width="{size}" height="{size}" '
            f'href="{uri}"/>')
    parts.append("</svg>")
    return "".join(parts)


def showcase_svg() -> str:
    width, height = 1280, 960
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" '
        f'height="{height}" viewBox="0 0 {width} {height}">',
        f'<rect width="{width}" height="{height}" fill="#FFFFFF"/>',
        '<text x="640" y="70" text-anchor="middle" '
        'font-family="Helvetica, Arial, sans-serif" font-size="40" '
        'font-weight="bold" fill="#0F172A">fui_kit — 498 icons in 6 '
        'styles</text>',
    ]
    top = 130
    row_h = 132
    icon_size = 44
    for r, (label, class_name, style_dir, prefix) in enumerate(STYLES):
        y = top + r * row_h
        color = PALETTE[r]
        parts.append(
            f'<text x="80" y="{y + 20}" '
            'font-family="Helvetica, Arial, sans-serif" font-size="22" '
            f'font-weight="bold" fill="#0F172A">{label}</text>')
        parts.append(
            f'<text x="80" y="{y + 46}" '
            'font-family="Courier, monospace" font-size="17" '
            f'fill="#64748B">{class_name}.heart</text>')
        n = len(ROW_ICONS)
        area_x, area_w = 360, width - 360 - 80
        gap = area_w / n
        for i, name in enumerate(ROW_ICONS):
            x = area_x + i * gap + (gap - icon_size) / 2
            uri = icon_data_uri(style_dir, prefix, name, color)
            parts.append(
                f'<image x="{x:.0f}" y="{y}" width="{icon_size}" '
                f'height="{icon_size}" href="{uri}"/>')
        if r < len(STYLES) - 1:
            parts.append(
                f'<line x1="80" y1="{y + 92}" x2="{width - 80}" '
                f'y2="{y + 92}" stroke="#E2E8F0" stroke-width="1"/>')
    parts.append("</svg>")
    return "".join(parts)


def render(svg: str, basename: str, also_png: bool = True) -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    svg_path = os.path.join(OUT_DIR, f"{basename}.svg")
    png_path = os.path.join(OUT_DIR, f"{basename}.png")
    webp_path = os.path.join(OUT_DIR, f"{basename}.webp")
    with open(svg_path, "w") as fh:
        fh.write(svg)
    subprocess.run(["rsvg-convert", "-o", png_path, svg_path], check=True)
    subprocess.run(
        ["cwebp", "-quiet", "-q", "90", png_path, "-o", webp_path],
        check=True)
    os.remove(svg_path)
    if not also_png:
        os.remove(png_path)
    for path in (png_path, webp_path):
        if os.path.exists(path):
            size = os.path.getsize(path) / 1024
            print(f"{os.path.relpath(path, ROOT)}: {size:.0f} KB")


if __name__ == "__main__":
    render(banner_svg(), "banner")
    render(showcase_svg(), "showcase", also_png=False)
