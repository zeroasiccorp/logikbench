import argparse
from os.path import dirname, abspath
from jinja2 import Environment, FileSystemLoader

def main():
    parser = argparse.ArgumentParser(description="""\

LogikBench Design class generator.
-Generates benchmark python modules
-If script is run without name, all group benchmarks are generated

Example Usage:
gen_class mux
    """,
    formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("group", help="Benchmark group name")
    parser.add_argument("-name", help="Benchmark name")

    args = parser.parse_args()

    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template('template.py.j2')

    if args.name:
        lb_list = [args.name]
    else:
        paths = glob.glob(f"../logikbench/{args.group}/*")
        lb_list = [os.path.basename(item) for item in paths]

    for item in lb_list:
        dir = f"../logikbench/{args.group}/item"
        context = {
            'class_name': item.name.capitalize(),
            'module_name': item.name
            output = template.render(context)
            filename=f"../logikbench/{args.group}/{item.name}.py"
    with open(filename, 'w') as f:
        f.write(output)

if __name__ == "__main__":
    main()
