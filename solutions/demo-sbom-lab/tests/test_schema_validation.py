import pytest
from push_securityhub import convert_trivy, validate_findings_schema


def test_empty_results_ok():
    out = convert_trivy({'Results': []})
    assert 'Findings' in out
    # empty list is allowed but must be a list
    assert validate_findings_schema({'Findings': []})


def test_convert_and_validate_sample():
    sample = {
        'Results': [
            {
                'Target': 'img',
                'Vulnerabilities': [
                    {
                        'VulnerabilityID': 'CVE-1',
                        'PkgName': 'pkg',
                        'InstalledVersion': '1.0',
                        'Severity': 'LOW'
                    }
                ]
            }
        ]
    }
    out = convert_trivy(sample)
    assert validate_findings_schema(out)


def test_validate_raises_on_missing_fields():
    with pytest.raises(ValueError):
        validate_findings_schema({'NotFindings': []})
