import json
import os
import sys
from pathlib import Path

# Add demo-sbom-lab to sys.path for test discovery
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import push_securityhub as ps


SAMPLE_TRIVY = {
    "Results": [
        {
            "Target": "example-image",
            "Vulnerabilities": [
                {
                    "VulnerabilityID": "CVE-2023-0001",
                    "PkgName": "libexample",
                    "InstalledVersion": "1.2.3",
                    "Severity": "HIGH",
                    "Description": "Sample vulnerability for testing"
                }
            ]
        }
    ]
}


def test_convert_trivy(tmp_path):
    in_file = tmp_path / 'scan.json'
    out_file = tmp_path / 'findings.json'
    in_file.write_text(json.dumps(SAMPLE_TRIVY))

    findings = ps.convert_trivy(SAMPLE_TRIVY)
    assert 'Findings' in findings
    assert len(findings['Findings']) == 1
    f = findings['Findings'][0]
    assert f['Title'].startswith('Vulnerability:')
    assert f['Severity']['Label'] == 'HIGH'
    assert f['Resources'][0]['Id'] == 'libexample'

    # run script end-to-end
    os.system(f'python3 {ps.__file__} {in_file} {out_file}')
    assert out_file.exists()
    data = json.loads(out_file.read_text())
    assert 'Findings' in data and len(data['Findings']) == 1
