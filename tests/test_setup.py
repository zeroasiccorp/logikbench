def test_setup(benchmark):
    """Every benchmark exposes at least one RTL source file."""
    assert benchmark.get_file('rtl')
