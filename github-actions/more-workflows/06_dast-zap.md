# DAST — OWASP ZAP

Purpose: Perform runtime scanning of deployed staging environments to find injection and other runtime issues.

How to run:
- Create a staging environment accessible from GitHub Actions runners or use self-hosted runners.
- Run ZAP baseline/full scan and store results as artifacts.

Caveats:
- DAST may generate false positives; couple with manual review and triage.
