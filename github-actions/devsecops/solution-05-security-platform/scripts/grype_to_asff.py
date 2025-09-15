#!/usr/bin/env python3
"""
Simple converter stub: grype JSON -> ASFF BatchImportFindings JSON
Note: This is a minimal example; for production, map fields carefully to ASFF schema.
"""
import json, sys

if len(sys.argv) < 5:
    print('usage: grype_to_asff.py --input grype.json --output asff.json')
    sys.exit(2)

inp = sys.argv[sys.argv.index('--input')+1]
out = sys.argv[sys.argv.index('--output')+1]

with open(inp) as f:
    g = json.load(f)

asff = {
    "Findings": []
}
for m in g.get('matches', []):
    vuln = m.get('vulnerability', {})
    finding = {
        'Title': vuln.get('id'),
        'Description': vuln.get('dataSource', '') + ' ' + vuln.get('version', ''),
        'ProductArn': 'arn:aws:securityhub:us-east-1:005965605891:product/005965605891/default',
        'Resources': [],
        'CreatedAt': vuln.get('published'),
        'Severity': {'Label': vuln.get('severity', 'MEDIUM')}
    }
    asff['Findings'].append(finding)

with open(out, 'w') as f:
    json.dump(asff, f, indent=2)

print('ASFF written to', out)
