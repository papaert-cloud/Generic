import json
import subprocess
import sys
from pathlib import Path


def make_grype_json(matches):
    return {"matches": matches}


def write_tmp(tmp_path, data):
    p = tmp_path / "grype.json"
    p.write_text(json.dumps(data))
    return str(p)


def test_no_vulns_pass(tmp_path):
    data = make_grype_json([])
    p = write_tmp(tmp_path, data)
    res = subprocess.run([sys.executable, "../scripts/check_grype_severity.py", p, "--threshold", "HIGH"], cwd=tmp_path)
    assert res.returncode == 0


def test_one_high_fails(tmp_path):
    matches = [{"vulnerability": {"id": "CVE-9999-1", "severity": "HIGH"}}]
    data = make_grype_json(matches)
    p = write_tmp(tmp_path, data)
    res = subprocess.run([sys.executable, "../scripts/check_grype_severity.py", p, "--threshold", "HIGH"], cwd=tmp_path)
    assert res.returncode == 1
