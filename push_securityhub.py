"""Top-level compatibility shim for tests that import `push_securityhub`.

This loader finds the script file under `solutions/demo-sbom-lab/scripts/
push-securityhub.py` and loads it as a module so `import push_securityhub`
works from the repository root or CI environments.
"""
from importlib.machinery import SourceFileLoader
from pathlib import Path
_script_path = Path(__file__).resolve().parent / 'solutions' / 'demo-sbom-lab' / 'scripts' / 'push-securityhub.py'
if not _script_path.exists():
	raise ImportError(f"Expected script at {_script_path} not found")
_mod = SourceFileLoader('push_securityhub_impl', str(_script_path)).load_module()

convert_trivy = getattr(_mod, 'convert_trivy')
map_severity = getattr(_mod, 'map_severity', None)
make_finding = getattr(_mod, 'make_finding', None)
__file__ = str(_script_path)
