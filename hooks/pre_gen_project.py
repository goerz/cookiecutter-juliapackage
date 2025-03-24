import re
import sys

NAME_REGEX = r'^[A-Z][a-zA-Z0-9]{4,}\.jl$'
project_name = '{{ cookiecutter.project_name }}'

if not project_name.endswith(".jl"):
    print(f'ERROR: {project_name} is not a valid Julia project name (does not end with `.jl`)')
    sys.exit(1)

if not re.match(NAME_REGEX, project_name):
    print(f'ERROR: {project_name} is not a valid Julia project name!')
    sys.exit(1)
