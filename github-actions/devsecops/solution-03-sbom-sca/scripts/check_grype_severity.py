#!/usr/bin/env python3
# Checks grype JSON for severities >= threshold and exits non-zero if found
import sys, json
from enum import Enum

SEVERITY_ORDER = ['UNKNOWN','LOW','MEDIUM','HIGH','CRITICAL']

if len(sys.argv) < 3:
    print('usage: check_grype_severity.py <grype.json> --threshold <LEVEL>')
    sys.exit(2)

path = sys.argv[1]
threshold = 'HIGH'
if '--threshold' in sys.argv:
    threshold = sys.argv[sys.argv.index('--threshold')+1].upper()

with open(path) as f:
    data = json.load(f)

found = []
for r in data.get('matches', []):
    sev = r.get('vulnerability', {}).get('severity', 'UNKNOWN').upper()
    if SEVERITY_ORDER.index(sev) >= SEVERITY_ORDER.index(threshold):
        found.append((sev, r.get('vulnerability', {}).get('id')))

if found:
    print('Found vulnerabilities at or above threshold:')
    for sev, vid in found:
        print(sev, vid)
    sys.exit(1)

print('No vulnerabilities at or above threshold')
