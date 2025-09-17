"""Compatibility shim for tests: expose convert_trivy from the script
located at solutions/demo-sbom-lab/scripts/push-securityhub.py

This loader keeps the script as-is (so it can remain executable with a
hyphen in the filename) while providing a normal Python module name
(`push_securityhub`) for imports used by the test suite.
"""
from importlib.machinery import SourceFileLoader
from pathlib import Path
import sys

_script_path = Path(__file__).resolve().parent / 'scripts' / 'push-securityhub.py'
if not _script_path.exists():
    raise ImportError(f"Expected script at {_script_path} not found")

# Load the script as a module named _push_securityhub_impl
_mod_name = '_push_securityhub_impl'
_loader = SourceFileLoader(_mod_name, str(_script_path))
_module = _loader.load_module()

# Re-export the conversion function and file path so tests can access them
try:
    convert_trivy = _module.convert_trivy
except AttributeError:
    raise ImportError('convert_trivy not found in push-securityhub script')

# Provide a __file__ attribute that points to the original script (tests use ps.__file__)
__file__ = str(_script_path)

# Also expose any other useful names from the script
for _name in ('map_severity', 'make_finding'):
    if hasattr(_module, _name):
        globals()[_name] = getattr(_module, _name)
