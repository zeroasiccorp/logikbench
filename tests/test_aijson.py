import inspect
import json
import os

import jsonschema
import pytest

#######################################################
# Validate the per-benchmark ai.json provenance files.
#
# Run a single benchmark, e.g.:
#   pytest tests/test_aijson.py::test_aijson[blocks-Lpddr5] -v
#######################################################

SCHEMA_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "docs", "ai_json_schema.json")


def _load_schema():
    with open(SCHEMA_PATH) as f:
        return json.load(f)


def test_schema_is_valid():
    """The ai.json schema itself must be a valid JSON Schema."""
    schema = _load_schema()
    jsonschema.Draft202012Validator.check_schema(schema)


def test_aijson(benchmark):
    """If a benchmark ships an ai.json, it must validate against the schema, its
    name must agree with the Design, and the spec it links to must exist.
    ai.json is optional and AI-scoped; benchmarks without one are skipped."""
    blockdir = os.path.dirname(inspect.getfile(type(benchmark)))
    path = os.path.join(blockdir, "ai.json")
    if not os.path.exists(path):
        pytest.skip("No ai.json for this benchmark.")

    with open(path) as f:
        doc = json.load(f)

    jsonschema.validate(doc, _load_schema())

    assert doc["name"] == benchmark.name, \
        f"ai.json name {doc['name']!r} != Design name {benchmark.name!r}"

    spec = os.path.join(blockdir, doc["spec_ref"])
    assert os.path.exists(spec), \
        f"ai.json spec_ref points to missing file: {doc['spec_ref']}"
