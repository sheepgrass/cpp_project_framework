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

parameters = {
    'project_name': input('Project Name (will be auto converted to snake case): '),
    'project_version': input('Project Version (default to 1.0 if ignored): '),
    'project_author': input('Project Author: '),
    'project_title': input('Project Title (space separated title case of Project Name if ignored): '),
    'project_description': input('Project Description (same as Project Title if ignored): '),
    'parent_directory': input('Parent Directory (default to ".mod" folder under current directory if ignored): '),
}

if not parameters['project_name']:
    print(f'ERROR: exit as "Project Name" not set', file=sys.stderr)
    exit()
parameters['project_name'] = to_snake_case(parameters['project_name'])
parameters['project_camel_name'] = snake_to_camel_case(parameters['project_name'])
if not parameters['project_version']:
    parameters['project_version'] = '1.0'
if not parameters['project_title']:
    parameters['project_title'] = snake_to_title_case(parameters['project_name'])
if not parameters['project_description']:
    parameters['project_description'] = parameters['project_title']
if not parameters['parent_directory']:
    parameters['parent_directory'] = os.path.join(os.curdir, '.mod')

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
    shutil.copy2(base_file, parameters['project_directory'], follow_symlinks=True)

test_package_files = (
    'CMakeLists.txt',
    'conanfile.py',
    'example.cpp',
)
for test_package_file in test_package_files:
    shutil.copy2(os.path.join(test_package_folder, test_package_file), parameters['test_package_directory'], follow_symlinks=True)

template_folder = 'template'
template_files = (
    'CMakeLists.txt',
    'conanfile.py',
    'conanfile.txt',
    'Doxyfile',
    'README.md',
)
for template_file in template_files:
    with open(os.path.join(template_folder, template_file), 'r') as fin:
        with open(os.path.join(parameters['project_directory'], template_file), 'w') as fout:
            fout.write(Template(fin.read()).safe_substitute(parameters))

template_source_files = (
    'CMakeLists.txt',
    'Template.cpp',
    'Template.h',
    'Template.test.cpp',
)
for template_source_file in template_source_files:
    with open(os.path.join(template_folder, template_folder, template_source_file), 'r') as fin:
        with open(os.path.join(parameters['source_directory'], template_source_file.replace('Template', parameters['project_camel_name'])), 'w') as fout:
            fout.write(Template(fin.read()).safe_substitute(parameters))

vscode_files = (
    'c_cpp_properties.json',
    'settings.json',
)
for vscode_file in vscode_files:
    shutil.copy2(os.path.join(template_folder, 'vscode', vscode_file), parameters['vscode_directory'], follow_symlinks=True)
