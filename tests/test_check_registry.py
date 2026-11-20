import json
import tempfile
import unittest
from pathlib import Path

from tools.check_registry import check_registry


class CheckRegistryTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        self.data = {
            "primary": "https://portfolio.example",
            "primaries": ["https://portfolio.example"],
            "sites": [
                {"name": "portfolio", "url": "https://portfolio.example/", "primary": True},
                {"name": "design-demo", "url": "https://demo.example", "folder": "demo"},
            ],
        }
        for folder in ("portfolio", "demo"):
            page = self.root / folder / "index.html"
            page.parent.mkdir()
            page.write_text("<!doctype html><title>Fixture</title>", encoding="utf-8")

    def check(self):
        (self.root / "sites.json").write_text(json.dumps(self.data), encoding="utf-8")
        return check_registry(self.root)

    def test_counts_sites_using_default_and_explicit_folders(self):
        self.assertEqual(self.check(), 2)

    def test_rejects_duplicate_names(self):
        self.data["sites"][1]["name"] = "portfolio"
        with self.assertRaisesRegex(ValueError, "duplicate site name or URL"):
            self.check()

    def test_normalizes_origins_when_checking_duplicates(self):
        self.data["sites"][1]["url"] = "https://PORTFOLIO.EXAMPLE"
        with self.assertRaisesRegex(ValueError, "duplicate site name or URL"):
            self.check()

    def test_rejects_non_origin_urls(self):
        for url in (
            "http://demo.example",
            "https://demo.example/work",
            "https://demo.example/?key=value",
            "https://demo.example/#about",
            "https://demo.example:8080",
            "https://user@demo.example",
        ):
            with self.subTest(url=url):
                self.data["sites"][1]["url"] = url
                with self.assertRaisesRegex(ValueError, "expected an HTTPS origin"):
                    self.check()

    def test_rejects_path_like_folder(self):
        self.data["sites"][1]["folder"] = "../outside"
        with self.assertRaisesRegex(ValueError, "must be a lower-case slug"):
            self.check()

    def test_rejects_missing_source_page(self):
        self.data["sites"][1]["folder"] = "absent"
        with self.assertRaisesRegex(ValueError, "missing source page in absent"):
            self.check()

    def test_rejects_missing_or_unlisted_primary(self):
        self.data["primaries"] = []
        with self.assertRaisesRegex(ValueError, "Primary URLs must match"):
            self.check()

        self.data["primaries"] = ["https://portfolio.example"]
        self.data["primary"] = "https://demo.example"
        with self.assertRaisesRegex(ValueError, "Primary URLs must match"):
            self.check()


if __name__ == "__main__":
    unittest.main()
