"""Validate source and registry consistency without contacting deployed sites."""
import json
import re
import sys
from pathlib import Path
from urllib.parse import urlsplit


def check_registry(root: Path) -> int:
    data = json.loads((root / "sites.json").read_text(encoding="utf-8"))
    names = set()
    urls = set()
    primary_urls = set()
    for site in data["sites"]:
        name, url = site["name"], site["url"]
        folder = site.get("folder", name)
        if not all(re.fullmatch(r"[a-z0-9][a-z0-9-]*", item) for item in (name, folder)):
            raise ValueError("Every site name and folder must be a lower-case slug.")
        address = urlsplit(url)
        if (
            address.scheme != "https" or not address.hostname or address.username is not None
            or address.port is not None or address.path not in ("", "/") or address.query or address.fragment
        ):
            raise ValueError(f"{name}: expected an HTTPS origin.")
        origin = url.rstrip("/").lower()
        if name in names or origin in urls:
            raise ValueError(f"{name}: duplicate site name or URL.")
        names.add(name)
        urls.add(origin)
        if site.get("primary"):
            primary_urls.add(origin)
        page = (root / folder / "index.html").resolve()
        if not page.is_relative_to(root.resolve()) or not page.is_file():
            raise ValueError(f"{name}: missing source page in {folder}.")
    declared = {url.rstrip("/").lower() for url in data["primaries"]}
    if not primary_urls or declared != primary_urls or data["primary"].rstrip("/").lower() not in primary_urls:
        raise ValueError("Primary URLs must match the primary registry entries.")
    return len(names)


if __name__ == "__main__":
    try:
        count = check_registry(Path(__file__).resolve().parents[1])
    except (KeyError, OSError, TypeError, ValueError) as error:
        sys.exit(f"Site registry check failed: {error}")
    print(f"Verified source pages and registry entries for {count} sites.")
