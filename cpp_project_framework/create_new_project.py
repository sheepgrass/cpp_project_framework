import os
import shutil
from string import Template
import sys

def to_snake_case(dummy_case):
    return '_'.join(x.lower() for x in dummy_case.split())

def snake_to_camel_case(snake_case):
    return ''.join(x.capitalize() for x in snake_case.split('_'))

def snake_to_title_case(snake_case):
    return ' '.join(x.capitalize() for x in snake_case.split('_'))

def create_new_project():
    base_directory = os.path.join(sys.prefix, 'cpp_project_framework')
    if not os.path.isfile(os.path.join(base_directory, 'cpp_project_framework.cmake')):
        base_directory = '.'
    if not os.path.isfile(os.path.join(base_directory, 'cpp_project_framework.cmake')):
        print(f'FATAL: template files not found', file=sys.stderr)
        exit()

    parameters = {}

    def get_project_name():
        parameters['project_name'] = to_snake_case(input('Project Name (will be auto converted to snake case): '))
        return not parameters['project_name']
    while get_project_name():
        print(f'ERROR: "Project Name" not set', file=sys.stderr)
    parameters['project_camel_name'] = snake_to_camel_case(parameters['project_name'])

    supported_project_types = ('LIB', 'EXE', 'HEADER_ONLY')
    default_project_type = 'LIB'
    def get_project_type():
        parameters['project_type'] = to_snake_case(input(f'Project Type ({supported_project_types}) (default to {default_project_type} if ignored): ')).upper()
        if not parameters['project_type']:
            parameters['project_type'] = default_project_type
        return parameters['project_type'] not in supported_project_types
    while get_project_type():
        print(f'ERROR: "Project Type" ({parameters["project_type"]}) not in supported project types ({supported_project_types})', file=sys.stderr)

    default_project_version = '1.0'
    parameters['project_version'] = input(f'Project Version (default to {default_project_version} if ignored): ')
    if not parameters['project_version']:
        parameters['project_version'] = default_project_version

    parameters['project_author'] = input('Project Author: ')

    default_project_title = snake_to_title_case(parameters['project_name'])
    parameters['project_title'] = input(f'Project Title (space separated title case of Project Name ({default_project_title}) if ignored): ')
    if not parameters['project_title']:
        parameters['project_title'] = default_project_title

    default_project_description = parameters['project_title']
    parameters['project_description'] = input(f'Project Description (same as Project Title ({default_project_description}) if ignored): ')
    if not parameters['project_description']:
        parameters['project_description'] = default_project_description

    default_parent_directory = os.curdir
    parameters['parent_directory'] = input(f'Parent Directory (default to current directory ({default_parent_directory}) if ignored): ')
    if not parameters['parent_directory']:
        parameters['parent_directory'] = default_parent_directory

    def create_directories(directory_key):
        try:
            os.makedirs(parameters[directory_key])
        except FileExistsError:
            print(f'WARNING: {snake_to_title_case(directory_key)} "{parameters[directory_key]}" already exists', file=sys.stderr)

    parameters['project_directory'] = os.path.join(parameters['parent_directory'], parameters['project_name'])
    create_directories('project_directory')

    parameters['source_directory'] = os.path.join(parameters["project_directory"], parameters['project_name'])
    create_directories('source_directory')

    test_package_folder = 'test_package'
    parameters['test_package_directory'] = os.path.join(parameters["project_directory"], test_package_folder)
    create_directories('test_package_directory')

    tests_folder = 'tests'
    benchmarks_folder = 'benchmarks'
    parameters['benchmarks_directory'] = os.path.join(parameters["project_directory"], tests_folder, benchmarks_folder, parameters['project_name'])
    create_directories('benchmarks_directory')

    parameters['vscode_directory'] = os.path.join(parameters["project_directory"], '.vscode')
    create_directories('vscode_directory')

    base_files = (
        '.clang-format',
        '.gitignore',
        'cpp_project_framework_callables.cmake',
        'cpp_project_framework.cmake',
        'LICENSE',
        'make.bat',
        'Makefile',
    )
    for base_file in base_files:
        shutil.copy2(os.path.join(base_directory, base_file), parameters['project_directory'], follow_symlinks=True)

    test_package_files = (
        'CMakeLists.txt',
        'conanfile.py',
        'example.cpp',
    )
    for test_package_file in test_package_files:
        shutil.copy2(os.path.join(base_directory, test_package_folder, test_package_file), parameters['test_package_directory'], follow_symlinks=True)

    template_folder = 'template'
    template_files = (
        'CMakeLists.txt',
        'conanfile.py',
        'conanfile.txt',
        'Doxyfile',
        'README.md',
    )
    for template_file in template_files:
        with open(os.path.join(base_directory, template_folder, template_file), 'r') as fin:
            with open(os.path.join(parameters['project_directory'], template_file), 'w') as fout:
                fout.write(Template(fin.read()).safe_substitute(parameters))

    template_source_files = {
        'CMakeLists.txt',
        'Template.cpp',
        'Template.h',
        'Template.test.cpp',
    }
    if parameters['project_type'] == 'EXE':
        template_source_files.add('main.cpp')
    for template_source_file in template_source_files:
        with open(os.path.join(base_directory, template_folder, template_folder, template_source_file), 'r') as fin:
            with open(os.path.join(parameters['source_directory'], template_source_file.replace('Template', parameters['project_camel_name'])), 'w') as fout:
                fout.write(Template(fin.read()).safe_substitute(parameters))

    template_benchmark_files = (
        'Template.benchmark.cpp',
    )
    for template_benchmark_file in template_benchmark_files:
        with open(os.path.join(base_directory, template_folder, tests_folder, benchmarks_folder, template_folder, template_benchmark_file), 'r') as fin:
            with open(os.path.join(parameters['benchmarks_directory'], template_benchmark_file.replace('Template', parameters['project_camel_name'])), 'w') as fout:
                fout.write(Template(fin.read()).safe_substitute(parameters))

    vscode_files = (
        'c_cpp_properties.json',
        'settings.json',
    )
    for vscode_file in vscode_files:
        shutil.copy2(os.path.join(base_directory, template_folder, 'vscode', vscode_file), parameters['vscode_directory'], follow_symlinks=True)

if __name__ == '__main__':
    create_new_project()

