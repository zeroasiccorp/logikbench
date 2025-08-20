from typing import Union

import pyslang


def extract_ports(systemverilog_code: str, top_level_module: str) -> list[dict]:

    class IOExtractor:
        def __init__(self):
            self.ports = []

        def __call__(self, obj: Union[pyslang.Token, pyslang.SyntaxNode]) -> None:
            # Check if this is a variable symbol (includes logic declarations)
            if isinstance(obj, pyslang.PortSymbol):
                # Get the type of the variable
                direction = None
                if obj.direction == pyslang.ArgumentDirection.In:
                    direction = "input"
                elif obj.direction == pyslang.ArgumentDirection.Out:
                    direction = "output"
                else:
                    raise NotImplementedError

                name = obj.name
                vector = ""
                if isinstance(obj.type, pyslang.PackedArrayType):
                    vector = str(obj.type.range)

                self.ports.append(dict(name=name, direction=direction, vector=vector))

    try:
        # Parse the SystemVerilog code into a syntax tree
        tree = pyslang.SyntaxTree.fromText(systemverilog_code)

        # Make sure file has the module we are looking for
        if isinstance(tree.root, pyslang.ModuleDeclarationSyntax):
            header = tree.root.header
            assert header.kind == pyslang.SyntaxKind.ModuleHeader, "Expected a module header"
            assert str(header.name).strip() == top_level_module, \
                f"Expected module {top_level_module}, found {header.name}"
        else:
            module_lookup = {
                str(m.header.name).strip(): m
                for m in tree.root.members
                if m.header.kind == pyslang.SyntaxKind.ModuleHeader
            }

            assert top_level_module in module_lookup, f"Module {top_level_module} not found in file"
            module = str(module_lookup[top_level_module])
            tree = pyslang.SyntaxTree.fromText(module)

        compilation = pyslang.Compilation()
        compilation.addSyntaxTree(tree)
        io_extractor = IOExtractor()
        compilation.getRoot().visit(io_extractor)

        return io_extractor.ports

    except Exception as e:
        raise Exception(f"Failed to extract logic declarations: {e}")


def extract_ports_from_file(filepath: str, top_level_module: str) -> list[dict]:
    try:
        with open(filepath, "r", encoding="utf-8") as file:
            content = file.read()
        return extract_ports(content, top_level_module)
    except FileNotFoundError:
        raise Exception(f"File not found: {filepath}")
    except Exception as e:
        raise Exception(f"Failed to process file {filepath}: {e}")


def extract_modules_from_file(filepath: str) -> list[str]:
    try:
        with open(filepath, "r", encoding="utf-8") as file:
            content = file.read()

        tree = pyslang.SyntaxTree.fromText(content)

        modules = []

        if isinstance(tree.root, pyslang.ModuleDeclarationSyntax):
            header = tree.root.header
            modules.append(str(header.name).strip())
        else:
            modules = [
                str(m.header.name).strip()
                for m in tree.root.members
                if m.header.kind == pyslang.SyntaxKind.ModuleHeader
            ]

        return modules
    except FileNotFoundError:
        raise Exception(f"File not found: {filepath}")
    except Exception as e:
        raise Exception(f"Failed to process file {filepath}: {e}")