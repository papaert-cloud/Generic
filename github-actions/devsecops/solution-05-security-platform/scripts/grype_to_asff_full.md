# Developer notes: grype_to_asff expected mapping

This document describes fields mapping from Grype JSON to ASFF fields; use it to extend `grype_to_asff.py` for full schema compliance.

- grype.match.vulnerability.id -> ASFF Title and Id
- grype.match.vulnerability.severity -> ASFF Severity.Label
- grype.match.artifact.name -> ASFF Resource Details
- Include CWE, CVE urls, and references where possible

Refer to: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-format.html
