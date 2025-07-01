import common

def test_basic_setup():
    for item in common.basic_list:
        assert len(item.get_file('rtl')) == 1

def test_memory_setup():
    for item in common.memory_list:
        assert len(item.get_file('rtl')) == 1

def test_arithmetic_setup():
    for item in common.arithmetic_list:
        assert len(item.get_file('rtl')) == 1

def test_block_setup():
    for item in common.block_list:
        assert item.get_file('rtl')
