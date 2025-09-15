# Tests for check_grype_severity.py

Suggested pytest tests:
- test_no_vulns_pass
- test_one_high_fails

Example:
```python
# tests/test_check_grype_severity.py
from github-actions.devsecops.solution-03-sbom-sca.scripts.check_grype_severity import main
# ...create sample grype json fixtures and assert exit code behavior
```
