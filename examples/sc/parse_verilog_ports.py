from typing import Union

import pyslang


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


def extract_ports(systemverilog_code: str, top_level_module: str) -> list[dict]:
    try:
        # Parse the SystemVerilog code into a syntax tree
        tree = pyslang.SyntaxTree.fromText(systemverilog_code)
        module = None
        if not isinstance(tree.root, pyslang.ModuleDeclarationSyntax):
            module_lookup = {
                str(m.header.name).strip(): m
                for m in tree.root.members
                if m.header.kind == pyslang.SyntaxKind.ModuleHeader
            }

            if top_level_module in module_lookup:
                print(f"top level module in {module_lookup}")
                module = module_lookup[top_level_module]
            else:
                return None

            tree = pyslang.SyntaxTree.fromText(str(module))
        else:
            header = tree.root.header
            if not (header.kind == pyslang.SyntaxKind.ModuleHeader and str(header.name).strip() == top_level_module):
                return None

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
        print(f"got file path {filepath}")
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