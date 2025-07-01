import argparse
from os.path import dirname, abspath
from jinja2 import Environment, FileSystemLoader

def main():

    parser = argparse.ArgumentParser(description="""\

LogikBench Design class generator.
-Generates a python module for a single benchmark
-Places the output file in the root directory of the benchmark

Example Usage:
gen_class mux /home/wiley/logikbench/logigkebench/basic/mux
    """,
    formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("name", help="Benchmark name")
    parser.add_argument("dir", help="Outpt directory of generated file")

    args = parser.parse_args()

    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template('template.py.j2')

    context = {
        'class_name': args.name.capitalize(),
        'module_name': args.name
    }

    output = template.render(context)

    filename=f"{args.dir}/{args.name}.py"
    with open(filename, 'w') as f:
        f.write(output)

if __name__ == "__main__":
    main()
