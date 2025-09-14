#!/usr/bin/env python3
"""Convert Trivy JSON scan results into AWS Security Hub BatchImportFindings format.
Usage: push-securityhub.py <trivy-scan.json> <out-findings.json>
"""
import sys
import json
import uuid
from datetime import datetime

SEVERITY_MAP = {
    'CRITICAL': (90, 'CRITICAL'),
    'HIGH': (70, 'HIGH'),
    'MEDIUM': (50, 'MEDIUM'),
    'LOW': (30, 'LOW'),
    'UNKNOWN': (0, 'INFORMATIONAL'),
}


def map_severity(level):
    lvl = (level or '').upper()
    if lvl in SEVERITY_MAP:
        normalized, label = SEVERITY_MAP[lvl]
    else:
        normalized, label = (0, 'INFORMATIONAL')
    return {
        'Label': label,
        'Normalized': normalized,
        'Original': level or ''
    }


def make_finding(vuln, product_arn, account_id):
    now = datetime.utcnow().isoformat(timespec='seconds') + 'Z'
    vid = vuln.get('VulnerabilityID') or str(uuid.uuid4())
    title = f"Vulnerability: {vid}"
    desc = vuln.get('Description') or vuln.get('Title') or ''
    severity = map_severity(vuln.get('Severity'))

    finding = {
        'SchemaVersion': '2018-10-08',
        'Id': f"trivy/{vid}/{uuid.uuid4()}",
        'ProductArn': product_arn,
        'GeneratorId': 'trivy',
        'AwsAccountId': account_id,
        'Types': ['Software and Configuration Checks'],
        'CreatedAt': now,
        'UpdatedAt': now,
        'Severity': severity,
        'Title': title,
        'Description': desc,
        'Resources': [
            {
                'Type': 'Other',
                'Id': vuln.get('PkgName') or vuln.get('PackageName') or 'unknown',
                'Details': {
                    'Other': {
                        'PackageVersion': vuln.get('InstalledVersion') or vuln.get('Version') or ''
                    }
                }
            }
        ],
        'RecordState': 'ACTIVE'
    }
    return finding


def convert_trivy(trivy_json, product_arn='arn:aws:securityhub:::product/third-party/trivy', account_id='000000000000'):
    findings = []
    results = trivy_json.get('Results') or []
    for r in results:
        vulns = r.get('Vulnerabilities') or []
        for v in vulns:
            findings.append(make_finding(v, product_arn, account_id))
    return {'Findings': findings}


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage: push-securityhub.py <trivy-scan.json> <out-findings.json>')
        sys.exit(2)
    inpath = sys.argv[1]
    outpath = sys.argv[2]
    with open(inpath, 'r') as f:
        trivy = json.load(f)
    findings = convert_trivy(trivy)
    with open(outpath, 'w') as f:
        json.dump(findings, f, indent=2)
    print(f'Wrote {len(findings["Findings"])} findings to {outpath}')
