import os
import sys
import json
import shutil
import subprocess
from dataclasses import dataclass

from typing import List

@dataclass
class Project:
    name: str
    author: str
    version: str
    description: str
    fastfiles: List[str]

def load_project(file_path: str) -> Project:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Project file '{file_path}' does not exist.")

    with open(file_path, 'r') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            raise ValueError(f"Error parsing JSON from '{file_path}': {e}")

    project = Project(
        data.get('name', ''),
        data.get('author', ''),
        data.get('version', ''),
        data.get('description', ''),
        data.get('fastfiles', [])
    )
    return project

def main() -> int:
    try:
        project = load_project('project.t6modm.json')
    except (FileNotFoundError, ValueError) as e:
        print(f'[ERR!] {e}')
        return 1

    command = [
        os.path.join(os.getcwd(), os.environ.get('OAT_HOME', '.OAT'), 'Linker.exe' if os.name == 'nt' else 'Linker'),
        '-v',
        '--output-folder', 'compiled',
        '--base-folder', os.path.join(os.getcwd(), os.environ.get('OAT_HOME', '.OAT')),
        '--source-search-path', os.path.join(os.getcwd(), 'src', 'zone_source'),
        '--add-asset-search-path', os.path.join(os.getcwd(), 'src')
    ]

    for fastfile in project.fastfiles:
        command.append('--load')
        command.append(os.path.normpath(fastfile.replace('$HOME', os.getcwd())).replace('\\', '/'))

    # Clean previous build
    if os.path.exists('compiled'):
        shutil.rmtree('compiled')

    # Ensure output directory exists
    os.makedirs('compiled', exist_ok=True)

    command.append('mod')
    print(command)

    oat = subprocess.Popen(
        command,
        text=True,
        shell=True
    )
    oat.wait()

    if oat.returncode != 0:
        print(f'[\x1b[31mERR!\x1b[0m] Build failed with exit code {oat.returncode}')
        return oat.returncode

    with open(os.path.join('compiled', 'mod.json'), 'w') as f:
        json.dump({
            'name': project.name,
            'author': project.author,
            'version': project.version,
            'description': project.description
        }, f, indent=4)

    print('[\x1b[32mINFO\x1b[0m] Build succeeded.')
    return 0

if __name__ == "__main__":
    sys.exit(main())