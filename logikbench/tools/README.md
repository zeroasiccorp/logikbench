# Adding a tool

`logikbench/tools/` is LogikBench's tool-extension point. SiliconCompiler (SC)
ships a fixed set of tools; LB lets you add tools SC does not provide -- in
particular **proprietary/commercial EDA tools** (Design Compiler, Genus, Vivado,
Innovus, PrimeTime, VCS, JasperGold, ...) -- without modifying or forking SC.

A tool in LB is nothing special: it is an **SC `Task` subclass** that happens to
live under `tools/<tool>/` instead of inside `siliconcompiler`. The reference
implementation is [`tardigrade/tardigrade.py`](tardigrade/tardigrade.py); copy
its shape.

## The pattern (from `tools/tardigrade`)

1. **Base task** subclassing `siliconcompiler.Task` (or an SC tool base such as
   `siliconcompiler.tools.yosys.YosysTask` when SC already knows the executable).
   It declares what every task for this tool shares:
   - `tool(self)` -> the tool name
   - `setup(self)` -> `self.set_exe("<exe>", vswitch="<version flag>")` and log
     scrapers via `self.add_regex("errors", ...)` / `add_regex("warnings", ...)`
   - `parse_version(self, stdout)` -> extract the version string

2. **Concrete task per role** (synthesis, pnr, sim, ...), subclassing the base:
   - `task(self)` -> the node/task name (e.g. "synthesis")
   - `add_parameter(...)` in `__init__` for its inputs (liberty, options, ...)
   - `setup(self)` -> declare required filesets
     (`get_fileset_file_keys(...)` + `add_required_key`) and outputs
     (`add_output_file(ext=...)`)
   - `runtime_options(self)` -> build the tool's command line
   - `pre_process` / `post_process` -> stage inputs and scrape results into
     `self.record_metric(name, value, source_file=...)`

That is the whole contract. SC handles execution, version checking, and
tool/license detection at run time, so a tool that is not installed simply is
not selectable -- it never breaks anything else.

## Wiring it into a flow

Flows live in `logikbench/flows/<task>/<class>.py` and keep a plain name->Task
dict (`_SYNTH`) that maps a `--tool` value to its Task class. Adding a tool is
one entry:

```python
# logikbench/flows/syn/asic.py
from logikbench.tools.design_compiler.design_compiler import Synthesis as DCSynthesis

class ASICSynthesis(Flowgraph):
    _SYNTH = {
        "yosys": YosysSynthesis,
        "tardigrade": TardigradeSynthesis,
        "design_compiler": DCSynthesis,   # <-- new tool, one line
    }
    def __init__(self, tool="yosys", name="asic_synth"):
        ...
        self.node("synthesis", self._SYNTH[tool]())
```

So: **subclass SC `Task` under `tools/<tool>/` (like tardigrade), then add one
line to the relevant flow's `_SYNTH` dict.** No central registry to maintain.

## Monolithic vendor tools

Some tools do several stages in one opaque invocation (e.g. Vivado project mode:
synthesis + place-and-route together). That is still just a Task -- it appears as
the single node in both the `syn` and `pnr` flows for its class, or a
tool-specific flow collapses the nodes. The flow module decides node
granularity; the tool is always the same Task-subclass pattern.

## Custom variants of SC tools

If SC already ships the tool but LB needs a customized variant (e.g. Yosys driven
by LB-specific TCL scripts), subclass the SC tool's base (`YosysTask`) rather than
`Task`, and keep the LB assets (scripts, etc.) under `tools/<tool>/`. See
[`yosys/yosys.py`](yosys/yosys.py).
