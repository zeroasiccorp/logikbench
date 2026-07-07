# CLAUDE.md — EBRICK Project Guide

# Code Generation Rules
- IMPORTANT: Do not use emoji, special symbols (like ->), or Unicode characters in comments or code.
- All code must be plain ASCII/UTF-8.

# Testing
- Claude is always launched from inside an activated venv. Just call `pytest`/`pip`/`python` on PATH; do not hard-code or search for a venv path. Do not check `which python` or hunt for per-repo venvs — trust PATH.
- Before declaring any Python change "done", run `flake8 <changed_file>` and confirm zero issues.

## External Dependencies

- [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler) — Build system

## Benchmark Blocks: documentation and references

- Every block you architect and generate (i.e. RTL you design or substantially
  author, as opposed to vendored/imported RTL) MUST ship a `README.md` in the
  block directory containing, at minimum:
  - what the block is and what the circuit contains (function, interface,
    parameters);
  - how it maps in synthesis (LUT/FF/DSP/BRAM expectations) when known;
  - a **References** section.
- The References section MUST cite:
  - the **algorithm / standard** the block implements (papers, specs); and
  - the **hardware-implementation** sources whose architecture the RTL follows
    (e.g. VLSI-architecture papers/textbooks), kept separate from the algorithm
    references.
- State the provenance honestly: if the RTL is an original implementation, say
  so (it follows the cited architectures but is not copied from them); if it is
  vendored/imported, give the source URL, commit/branch, and license instead.
- Also provide a Verilog-2005 self-checking testbench under `testbench/` for
  blocks you generate (see existing blocks for the pattern).
- For vendored/imported blocks, a References/provenance section is still
  required (source, commit, license), even though no hardware-implementation
  citation applies.

### Reference integrity (enforced)
- REAL: every reference must be verified to exist -- exact author, title,
  venue, year must resolve to a real source (web-check at authoring time). If
  you cannot verify it, DO NOT cite it; state the block is an original
  implementation instead. Never emit an unverified/plausible citation.
- USED: every reference must map to a specific algorithm or hardware decision
  in the block. No decorative/background citations -- if you can't tie a
  reference to something concrete in the design, delete it.
- ALLOWED sources: peer-reviewed papers, textbooks, recognized standards, and
  open-source projects. NOT allowed: vendor app notes, datasheets, user
  guides, white papers, product briefs, or any vendor-specific architecture
  name (stay vendor-neutral).
- Keep the algorithm vs hardware-implementation split, and state provenance
  honestly (original vs vendored).

## Verilog Directives

- Only ever edit `*.v` and `*.vh` files, ignore files listed in `.gitignore`.
- Don't remove/change comments unless that is the specific ask
- Keep every comment line within 80 characters total (including the leading ` * ` or `// ` prefix). When laying out tables or aligned columns inside a comment, choose the tightest column widths that still keep cells readable — never let alignment whitespace push a line past 80. If you cannot fit a line, break it onto two lines or shorten labels rather than expanding past the limit.
- Edit surgically, never rewrite files wholesale unless asked.
- NEVER do sweeping refactors (rename a variable across many files, change a naming convention, mass-replace a token) without explicit user approval first. Fix only the specific lines the user asked about. If you notice a broader pattern that looks "wrong" or inconsistent (e.g. an alias used everywhere when a parameter would be clearer), STOP and ask — describe the pattern, propose the change, wait for approval. Do not act on stylistic hunches.
- When introducing new code that follows an existing pattern, match the existing convention in that file (variable names, port-width expressions, parameter usage). If you intentionally diverge, flag it explicitly so the user can correct you immediately rather than discovering it later.
- The order of the file matters: port declaration, includes, loclparams, wires, rest of file.
- Indentation should match default emacs verilog mode on disk when available.
- For all changes, confirm that they do not break verilog mode AUTO_TEMPLATE instantiations
- All testbenches must drive simulus from clock edges and use non-blocking assignment.
- All generated code must be verilog 2005 comptaible
- Never make changes in instance connections below the /*AUTOINST*/ line. These must be updated by verilog template mode. To update, run emacs --batch your_file.v   -l verilog-mode   -f verilog-auto -f save-buffer
- don't use functions in rtl code
- Model replicated/parallel hardware with `generate` (one combinational unit per element) plus an explicit reduction -- do NOT write a single large procedural `for` loop (e.g. WIN x LOOK comparisons, or a 2^N table sweep) that the tool has to unroll. Hitting the slang/yosys "unroll limit" is a SMELL that you coded combinational hardware as a sequential algorithm. Fix it by restructuring into per-element generated hardware (and keep any per-element loop small and bounded); NEVER fix it by raising `--unroll-limit` or by shrinking a design parameter just to squeeze under the default limit. Constant tables (ROMs) belong in a `case` inside a combinational `always` (or BRAM), not an unrolled compute loop and not a function.

## Debugging
- When a verilog test fails and the design and the test disagree on what should happen,  ALWAYS ASK WHO IS RIGHT before changing either one. Do not silently "fix" the test to match the design's current behavior, and do not silently "fix" the design to match what the test assumes. If you cannot prove correctness by reading the design (RTL/spec/comments) and tying it back to a stated requirement, surface the discrepancy to the user and let them adjudicate.  Patching one side to make the other pass hides the real bug.
- Concrete example: if the testbench drives a single chip-level pin (e.g.   NRST) and the design appears to require that pin at multiple internal  endpoints (e.g. each corner reading its own NRST pad), the design is  almost certainly wrong -- there is only one chip-level pin. Do not paper  over this by adding extra drives in the testbench. Flag the design bug.