Recap naming convention and examples

Purpose

Keep recaps consistent and easy to sort. Filenames are ISO-like and start with the date, followed by a short slug and the time-window tag if relevant.

Format

YYYY-MM-DD[_<time-window>]_slug.md

Where:
- YYYY-MM-DD is the local date when the recap is written.
- <time-window> is optional and can be `24hr`, `48hr`, `72hr`, `96hr` etc. Use when the recap covers a specific window.
- slug is a short hyphen-separated descriptor (no spaces). Keep it <= 5 words.

Examples

- `2025-09-11_96hr_recap.md` — recap covering the previous 96 hours, written on 2025-09-11.
- `2025-09-11_24hr_ci_oidc-kyverno.md` — 24-hour recap focused on CI/OIDC/Kyverno work.
- `2025-09-08_docs-refactor.md` — a specific day recap for docs work.

Metadata tip

At the top of each recap include a small front-matter block (plain text) with:

Date: YYYY-MM-DD
Author: <your-name-or initials>
Scope: short description
Tags: ci, sbom, securityhub, terraform

This helps searching and filtering.
