import siliconcompiler as sc
from siliconcompiler.flows import lintflow

#######################################################
# Run a single benchmark, e.g.:
#   pytest tests/test_lint.py::test_lint_slang[arithmetic-Add] -v
#######################################################


def test_lint_slang(benchmark):
    """Lint every benchmark with the slang frontend."""
    proj = sc.Project(benchmark)
    proj.option.set_nodashboard(True)
    proj.add_fileset("rtl")
    proj.set_flow(lintflow.LintFlow())
    assert proj.run(), f"Lint failed: {benchmark.__class__}"
