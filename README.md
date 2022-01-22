# C++ Project Framework

C++ Project Framework is a framework for creating C++ project.

## Canonical Project Structure for C++

Canonical Project Structure:
<http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1204r0.html>

The Pitchfork Layout:
<https://api.csswg.org/bikeshed/?force=1&url=https://raw.githubusercontent.com/vector-of-bool/pitchfork/develop/data/spec.bs>

```c++
<name>/
├── <name>/
│   └── ...
├── <module>/
│   ├── <module>.h        // header file containing mainly module declarations
│   ├── <module>.hpp      // header file containing module declarations and/or definitions
│   ├── <module>.cpp      // source file containing module definitions
│   ├── <module>.test.cpp // source file containing module unit tests
│   └── main.cpp          // source file containing the main function for exe
├── ...
└── tests/ // functional/integration tests
    ├── benchmarks/ // benchmark/performance tests
    │   ├── <benchmark>/
    │   │   └── <benchmark>.benchmark.cpp // source file containing module benchmark tests
    │   └── ...
    └── ...
```

## Prerequisites

```yaml
Build System Generator: CMake >= 3.10
Build System: GNU Make >= 4.2 (Linux), MSBuild >= 14.0 (Visual Studio 2015) (Windows)
Compiler: g++ >= 9.1 (Linux), MSVC >= 14.0 (Visual Studio 2015) (Windows)
Version Control System (VCS): Git >= 2.16
Package Manager Scripting: Python >= 3.6
C++ Standard: >= C++14
```

## Optional Prerequisites

```yaml
Integrated Development Environment (IDE): Visual Studio Code >= 1.49
Visual Studio Code Extensions:
    C/C++ >= 1.0.1
    C++ Intellisense >= 0.2.2
    Clang-Format >= 1.9.0
    CMake >= 0.0.17
    CMake Tools >= 1.4.2
    Python >= 2020.8
    Remote - SSH >= 0.55.0
    Remote Development >= 0.20.0
    GitLens >= 10.2.2
    Doxygen Documentation Generator >= 1.1.0
    C++ TestMate >= 3.6.23
    Five Server (Live Server) >= 0.0.34
```

## Recommended C++ Development Environment

<https://www.reddit.com/r/cpp/comments/af74l1/recommendations_for_setting_up_a_modern_c_dev/>

```yaml
build system generator: CMake
build system: Ninja
compiler: clang++ (cross-platform), MSBuild/MSVC (Windows), g++ (Linux)
Integrated Development Environment (IDE): Visual Studio Code, Qt Creator
static code analyzers: clang-tidy, Cppcheck, Clazy
source code formatter: clang-format
source code documentation generator: Doxygen
software distribution packaging system: CPack
C++ libraries:
    general-purpose: C++ Standard Library
    general-purpose: Boost C++ Libraries
    string formatting: fmt
    logging: spdlog
    automated testing: Google Test / Google Mock
    graphical user interface (GUI): Qt
package manager: Conan, vcpkg
continuous integration (CI): Jenkins, CDash
version control system (VCS): Git
code coverage: OpenCppCoverage (Windows), gcov + gcovr (Linux)
```

## Chosen C++ Development Environment

<https://en.cppreference.com/w/cpp/compiler_support>

```yaml
# Required (manual install)
Build System Generator: CMake >= 3.10
Build System: GNU Make >= 4.2 (Linux), MSBuild >= 14.0 (Visual Studio 2015) (Windows)
Compiler: g++ >= 9.1 (Linux), MSVC >= 14.0 (Visual Studio 2015) (Windows)
Version Control System (VCS): Git >= 2.16
Package Manager Scripting: Python >= 3.6 (or Anaconda3 on Windows)
C++ Standard: >= C++14

# Required (distributed with manual installed tools)
Testing Tool: CTest (CMake)
Software Distribution Packaging System: CPack (CMake)
Python Package Installer: pip >= 9.0 (Python)

# Required (auto installed by C++ Project Framework)
Package Manager: Conan (pip)
Code Coverage Report: gcovr (pip), OpenCppCoverage (Windows)

# C++ Libraries
General Purpose: C++ Standard Library (compiler included)
General Purpose: Boost (boost)
Unit Test Framework: Google Test (gtest)
Logging: Boost Log (boost::log)
Embedded Local Key-Value Store: RocksDB (rocksdb)
Embedded Local SQL Database:  SQLite (sqlite)

# Optional
Integrated Development Environment (IDE): Visual Studio Code >= 1.49
Source Code Documentation Generator: Doxygen >= 1.8
Graphical User Interface: Qt
Continous Integration (CI): Jenkins
Debugger: gdb (Linux), WinDbg (Windows), Visual Studio Debugger (Windows)
Performance Profiler: perf (Linux), gprof (Linux), orbit (Linux, Windows)
Source Code Formatter: ClangFormat (clang-format)
```

## Similar Projects Creating C++ Project Framework

Pitchfork
<https://github.com/vector-of-bool/pitchfork>

```yaml
Pitchfork is a set of conventions for native C and C++ projects. The most prominent being the project layout conventions.
```

Boiler plate for C++ projects
<https://github.com/bsamseth/cpp-project>

```yaml
This is a boiler plate for C++ projects. What you get:

Sources, headers and mains separated in distinct folders
Use of modern CMake for much easier compiling
Setup for tests using doctest
Continuous testing with Travis-CI and Appveyor, with support for C++17.
Code coverage reports, including automatic upload to Coveralls.io and/or Codecov.io
Code documentation with Doxygen
```

cpp-project-template
<https://github.com/Bo-Yuan-Huang/cpp-starter>

```yaml
This is a starting template for C++ projects that supports:

Hierarchical sources and headers
Access to Google Tests
Use of CMake for much easier compiling
Code documentation with Doxygen
Continuous testing with Travis-CI
Code coverage with Coveralls.io
Static analysis with Coverity Sacn
```

C++ Project Template
<https://github.com/TimothyHelton/cpp_project_template>

```yaml
When setting out on a new project in C++ there are a few configuration steps which need to be completed prior to actually getting down to writing code. This repository is going to be a C++ project template that already has the following components:

Directory Structure
Make Build (CMake)
Unit Test Framework (Google Test)
API Documentation (Doxygen)
```

moderncpp-project-template
<https://github.com/madduci/moderncpp-project-template>

```yaml
This repository aims to represent a template for Modern C++ projects, including static analysis checks, autoformatting, a BDD/TDD capable test-suite and packaging

Requirements
a modern C++17 compiler (gcc-8, clang-6.0, MSVC 2017 or above)
cmake 3.10+
conan 1.4+
conan_package_tools (optional)
cppcheck (optional)
clang-format (optional)
clang-check (optional)
```

## Useful Resources for C++

cppreference
<http://www.cppreference.com/>

```yaml
Our goal is to provide programmers with a complete online reference for the C and C++ languages and standard libraries, i.e. a more convenient version of the C and C++ standards.
```

cplusplus
<https://www.cplusplus.com/>

```yaml
Description of the most important classes, functions and objects of the Standard Language Library, with descriptive fully-functional short programs as examples
```

C++ Papyrus - C++ Annotations about Modern C++
<https://github.com/caiorss/C-Cpp-Notes>

```yaml
This repository contains annotations and examples about moodern C++, system programming and building systems for C and C++.
```

Awesome C++
<https://github.com/fffaraz/awesome-cpp>
<https://awesome-cpp.readthedocs.io/en/latest/README.html>

```yaml
A curated list of awesome C++ (or C) frameworks, libraries, resources, and shiny things. Inspired by awesome-... stuff.
```

## Package C++ Project Framework Python Project

[How To Package Your Python Code](https://python-packaging.readthedocs.io/en/latest/index.html)

[Packaging Python Projects](https://packaging.python.org/tutorials/packaging-projects/)

Go to `cpp_project_framework` root folder first, activate python virtual evironment (create it if not yet created), then follow below procedures:

### Install C++ Project Framework Python Package Locally

```bash
# Upgrade pip to latest version
python -m pip install --upgrade pip

# Install the package locally
python -m pip install .
```

### Generate C++ Project Framework Python Distribution Archives

```bash
# Upgrade PyPA's build to latest version
python -m pip install --upgrade build

# Generate distribution archives in dist directory
python -m build

# Check the generated archives
ls dist
cpp_project_framework-1.0.0-py3-none-any.whl
cpp_project_framework-1.0.0.tar.gz
```

The `tar.gz` file is a source archive whereas the `.whl` file is a built distribution.

### Upload Generated C++ Project Framework Python Distribution Archives to Test Python Package Index (TestPyPI)

```bash
# Upgrade PyPI's twine to latest version
python -m pip install --upgrade twine

# Upload all of the arhives under dist directory to TestPyPI
python -m twine upload --repository testpypi dist/*
```

### Install C++ Project Framework Python Package from TestPyPI

```bash
# Upgrade pip to latest version
python -m pip install --upgrade pip

# Install the package from TestPyPI
python -m pip install --index-url https://test.pypi.org/simple/ --no-deps cpp_project_framework
```

## Create New C++ Project by Python Script with Template

After installed the C++ project framework python package (namely `cpp_project_framework`), input the required parameters as prompted in below python script and a new C++ project with `C++ Project Framework` project structure will be created:

Method 1 (by calling C++ project framework python module):

```bash
python -m cpp_project_framework.create_new_project
```

Method 2 (by running C++ project framework python script):

```bash
create_new_cpp_project
```

## Visual Studio Code CMake Tools Settings

[Configuring CMake Tools](https://vector-of-bool.github.io/docs/vscode-cmake-tools/settings.html)

### Allow Building in Different Directories per Build Type

<https://github.com/microsoft/vscode-cmake-tools/issues/151>

File > Preferences > Settings > Extensions > CMake Tools > Cmake: Build Directory

.vscode/settings.json

```json
{
    "cmake.buildDirectory": "${workspaceFolder}/${buildType}"
}
```

## Visual Studio Code C++ Include Path Setting

.vscode/c_cpp_properties.json

```json
{
    "configurations": [
        {
            "includePath": [
                "${workspaceFolder}/**",
                "~/.conan/data/**"
            ],
            "windowsSdkVersion": "10.0.10240.0"
        }
    ]
}
```

## Manually Specify a Python Interpreter

<https://code.visualstudio.com/docs/python/environments#_manually-specify-an-interpreter>

File > Preferences > Settings > Extensions > Python > Python: Default Interpreter Path

.vscode/settings.json

```json
{
    "python.defaultInterpreterPath": "./.venv/bin/python"
}
```

## C++ TestMate Visual Studio Code Extension for Test Explorer Setting

File > Preferences > Settings > Extensions > C++ TestMate > TestMate > Cpp > Tests: Executables

.vscode/settings.json

```json
{
    "testMate.cpp.test.executables": "{build,Build,BUILD,out,Out,OUT,Debug,Release}/**/*{test,Test,TEST}*"
}
```

## C++ Code Formatting using Visual Studio Code with ClangFormat

<https://code.visualstudio.com/docs/cpp/cpp-ide#_code-formatting>

<https://clang.llvm.org/docs/ClangFormatStyleOptions.html>

Format an entire file with Format Document (Shift+Alt+F) or just the current selection with Format Selection (Ctrl+K Ctrl+F) in right-click context menu.

### Create ClangFormat File inside Visual Studio Code Workspace

```yaml
# .clang-format
UseTab: Never
IndentWidth: 4
BreakBeforeBraces: Allman
AllowShortIfStatementsOnASingleLine: false
IndentCaseLabels: false
ColumnLimit: 0
PointerAlignment: Left
AccessModifierOffset: -4
```

## Setup Remote SSH for Visual Studio Code

<https://code.visualstudio.com/docs/remote/ssh>

Start by selecting `Remote-SSH: Add New SSH Host...` from the Command Palette (`F1`, `Ctrl+Shift+P`) or clicking on the `Add New` icon in the SSH `Remote Explorer` in the Activity Bar.

%USERPROFILE%/.ssh/config

```
Host curtis@127.0.0.1:10022
  HostName ubuntu
  User curtis
  Port 10022
  IdentityFile %USERPROFILE%\\.ssh\\id_rsa
```

### Generate SSH Key Pair

<https://code.visualstudio.com/docs/remote/troubleshooting#_quick-start-using-ssh-keys>


On Linux SSH Server Side:

```bash
# Linux
cd ~/.ssh
ssh-keygen -t rsa -b 4096
cat id_rsa.pub >> authorized_keys
chmod 644 authorized_keys
```

`id_rsa.pub` is the **`public`** key generated and `id_rsa` is the **`private`** key generated.
`authorized_keys` is the file with keys that SSH server accepted for.

On Windows SSH Client Side:

Copy `id_rsa` from `~/.ssh/id_rsa` on Linux SSH server side to `%USERPROFILE%/.ssh/id_rsa` on Windows SSH client side.

## Setup Git

<https://stackoverflow.com/questions/68775869/support-for-password-authentication-was-removed-please-use-a-personal-access-to>

### Configure Git Client User

```bash
git config --global user.name "Curtis Lo"
git config --global user.email "github_email"
git config -l
```

### Clone Git Repository

```bash
git clone https://github.com/sheepgrass/cpp_project_framework.git
```

### Remember Git Credential

```bash
git config --global credential.helper cache
```

## Install Build Essential (GCC, Make)

```bash
# Linux (Ubuntu)
sudo apt install build-essential
```

## Install CMake

```bash
# Linux (Ubuntu)
sudo apt-get install cmake
```

## Create Python Virtual Environment under Current Project

```bash
# Linux
python3 -m venv .venv
source .venv/bin/activate
...
deactivate
```

```cmd
# Windows
%LOCALAPPDATA%\Continuum\anaconda3\python.exe -m venv .venv
.venv\Scripts\activate
...
deactivate
```

## Install Conan

<https://docs.conan.io/en/latest/installation.html>

```bash
source .venv/bin/activate
pip install -U conan
conan
```

## Search for Repository (Package Recipes) in ConanCenter

<https://conan.io/center>

```bash
conan search --remote=conan-center g3log
conan inspect g3log/1.3.3
```

## Create Conan File

<https://docs.conan.io/en/latest/getting_started.html>

```ini
# conanfile.txt
[requires]

[generators]
cmake_multi
```

## Conan Multi-configuration Generator

<https://docs.conan.io/en/latest/integrations/build_system/cmake/cmake_multi_generator.html>

## Conan for New GCC ABI

[How to manage the GCC >= 5 ABI](https://docs.conan.io/en/latest/howtos/manage_gcc_abi.html)

When Conan creates the default profile the first time it runs, it adjusts the `compiler.libcxx` setting to `libstdc++` for backwards compatibility. However, if you are using GCC >= 5 your compiler is likely to be using the new CXX11 ABI by default (`libstdc++11`).

If you want Conan to use the new ABI, edit the default profile at `~/.conan/profiles/default` adjusting `compiler.libcxx=libstdc++11` or override this setting in the profile you are using.

```bash
# Linux
vim ~/.conan/profiles/default
```

```ini
[settings]
os=Linux
os_build=Linux
arch=x86_64
arch_build=x86_64
compiler=gcc
compiler.version=9
compiler.libcxx=libstdc++11
build_type=Release
```

## CMake Build Types

```ini
CMAKE_BUILD_TYPE=[Debug|Release|MinSizeRel|RelWithDebInfo]
```

## Install Required Dependencies by Conan

<https://docs.conan.io/en/latest/reference/commands/consumer/install.html>

```bash
conan install . -b missing -s build_type={CMAKE_BUILD_TYPE} -if {CMAKE_BUILD_TYPE}
```

## Conan Package Location

```bash
# Linux
~/.conan/data
```

```cmd
# Windows
%USERPROFILE%\.conan\data
```

## Generate CMake Project

<https://cmake.org/cmake/help/latest/manual/cmake.1.html#generate-a-project-buildsystem>

```bash
cmake -S . -B {CMAKE_BUILD_TYPE} -DCMAKE_BUILD_TYPE={CMAKE_BUILD_TYPE} [-G "Visual Studio 14 2015" -A x64]
```

## Build CMake Project

<https://cmake.org/cmake/help/v3.14/manual/cmake.1.html#build-a-project>

```bash
cmake --build {CMAKE_BUILD_TYPE} [--clean-first -j4 -v]
```

## Build Specific Target of CMake Project

<https://cmake.org/cmake/help/v3.14/manual/cmake.1.html#build-a-project>

```bash
cmake --build {CMAKE_BUILD_TYPE} --target {CMAKE_BUILD_TARGET} [-j4 -v]
```

## Open CMake Generated Project

<https://cmake.org/cmake/help/latest/manual/cmake.1.html#open-a-project>

```bash
cmake --open {CMAKE_BUILD_TYPE}
```

## Generate CMake Installer by CPack

<https://cmake.org/cmake/help/latest/manual/cpack.1.html#manual:cpack(1)>

```bash
cd {CMAKE_BUILD_TYPE} && cpack -C {CMAKE_BUILD_TYPE} [-G ZIP]
```

## Create Conan Package Recipe

<https://docs.conan.io/en/latest/creating_packages/getting_started.html>

```bash
mkdir package && cd package
conan new {CMAKE_PROJECT_NAME}/{CMAKE_PROJECT_VERSION} -t
```

## Create Conan Package

<https://docs.conan.io/en/latest/creating_packages/getting_started.html>

```bash
conan create . demo/testing
```

## Download Existing Package Recipe

<https://docs.conan.io/en/latest/reference/commands/misc/download.html>

```bash
conan download g3log/1.3.3@ -re
```

## Copy Existing Recipe and Package to Another User Channel

<https://docs.conan.io/en/latest/reference/commands/misc/copy.html>

```bash
conan copy g3log/1.3.3@ sheepgrass/modified
```

## Conan Center Index Recipes

<https://github.com/conan-io/conan-center-index/tree/master/recipes>

## Modify Existing Package Recipe

<https://docs.conan.io/en/latest/howtos/collaborate_packages.html>

<https://dmerej.info/blog/post/chuck-norris-part-4-python-ctypes/>

<https://stackoverflow.com/questions/63670642/cant-create-boost-conan-package-from-conan-center-index-conanfile-didnt-spec>

```bash
# Linux
mkdir g3log && cd g3log
conan download g3log/1.3.3@ -re
cp -rv ~/.conan/data/g3log/1.3.3/_/_/export/* .
cp -rv ~/.conan/data/g3log/1.3.3/_/_/export_source/* .
conan create . 1.3.3@sheepgrass/modified
conan upload g3log/1.3.3@sheepgrass/modified --all -r=local
```

```cmd
# Windows
mkdir g3log && cd g3log
conan download g3log/1.3.3@ -re
xcopy %USERPROFILE%\.conan\data\g3log\1.3.3\_\_\export\* . /E
xcopy %USERPROFILE%\.conan\data\g3log\1.3.3\_\_\export_source\* . /E
conan create . 1.3.3@sheepgrass/modified
conan upload g3log/1.3.3@sheepgrass/modified --all -r=local
```

### Create Patch File in Unified Diff Format for Existing Package using WinMerge

<https://docs.conan.io/en/latest/reference/tools.html#tools-patch>

1. Set original source file as 1st file

2. Set modified source file as 2nd file

3. Compare them

4. In menu, select "Tools > Generate Patch..."

5. Set "Result" to target patch file path and name with extension *.patch

6. Set "Format > Style:" to "Unified"

7. Set "Format > Context:" to "3"

8. Set "Whitespaces" to "Compare"

9. Uncheck "Ignore blank lines"

10. Check "Case sensitive"

11. Check "Ignore carriage return differences (Windows/Unix/Mac)"

12. Click "OK" to generate patch file

13. Modify patch file to make diff path relative to "source_subfolder"

14. Add patch file to conandata.yml:

    ```yaml
    patches:
    [version]:
    - base_path: source_subfolder
        patch_file: patches/?.patch
    ```

15. Calculate MD5 checksum for the patch file:

    ```cmd
    certutil -hashfile ?.patch md5
    ```

16. Add patch file to conanmanifest.txt:

    ```txt
    export_source/patches/?.patch: [md5]
    ```

17. Add patch files to export sources of conan recipe file conanfile.py:

    ```python
    exports_sources = ["CMakeLists.txt", "patches/*"]
    ```

18. Add patch snippet to conan recipe file conanfile.py:

    ```python
    if "patches" in self.conan_data and self.version in self.conan_data["patches"]:
        for patch in self.conan_data["patches"][self.version]:
            tools.patch(**patch)
    ```

## Get List of Conan Repository Servers (Remotes) in Use

<https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html>

```bash
conan remote list
```

## Add Conan Repository Server (Remote)

```bash
conan remote add local http://localhost:9300
```

## Search Conan Package

```bash
conan search {PACKAGE_NAME} -r=local
```

## Upload Conan Package to Conan Repository Server (Remote)

<https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html>

```bash
conan upload {CMAKE_PROJECT_NAME}/{CMAKE_PROJECT_VERSION}@demo/testing --all -r=local
```

## Remove Local Conan Package Cache

```bash
conan remove {CMAKE_PROJECT_NAME}*
```

## Run Simple Open Source Conan Repository Server

<https://docs.conan.io/en/latest/uploading_packages/running_your_server.html>

```bash
conan_server
```

## Simple Open Source Conan Repository Server Config File Location

```bash
# Linux
~/.conan_server/server.conf
```

```cmd
# Windows
%USERPROFILE%\.conan_server\server.conf
```

## Simple Open Source Conan Repository Server Package Location

```bash
# Linux
~/.conan_server/data
```

```cmd
# Windows
%USERPROFILE%\.conan_server\data
```

## Set BUILD_TYPE Environment Variable

```bash
# Linux
export BUILD_TYPE=Debug
```

```cmd
# Windows
set BUILD_TYPE=Debug
```

## Activate Python Virtual Environment

```bash
# Linux
`make venv_activate`
```

```cmd
# Windows
make venv_activate
```

## Make Steps

```bash
# Set Build Type
export BUILD_TYPE=Debug

# Create Virtual Environment
make venv_create

# Activate Virtual Environment
make venv_activate

# Install Conan Package Manager
make pip_install_conan

# Install Project Dependencies
make conan_install

# Create CMake Project
make cmake_project

# Open Generated Project in Default IDE
make cmake_open

# List of CMake Build Targets
make help

# Build Specific CMake Target
make target CMAKE_BUILD_TARGET=<target>

# Build Project
make build

# Test Project
make test

# Create Code Coverage Report
make coverage

# Create Package/Installer
make package

# Create New Conan Package Recipe
make recipe_create

# Create Conan Test Package
make conan_package_test

# Create Conan Package
make conan_package

# Start Local Conan Repository Server
make conan_start_local

# Add Local Conan Repository Server to Remote List
make conan_add_local

# Upload Conan Test Package to Local Conan Repository Server
make conan_upload_local_test

# Upload Conan Package to Local Conan Repository Server
make conan_upload_local

# Generate Source Code Documentation
make doxygen
```

## Remove Steps

```bash
# Remove Source Code Documentation
make doxygen_delete

# Remove Conan Package from Local Conan Repository Server
make conan_remove_local

# Remove Conan Package from Cache
make conan_remove_cache

# Clean Project
make clean

# Delete Whole Build Folder
make delete

# Deactivate Virtual Environment
make venv_deactivate

# Delete Whole Virtual Environment
make venv_delete
```

## Support Google Test

<https://github.com/google/googletest>

<https://raymii.org/s/tutorials/Cpp_project_setup_with_cmake_and_unit_tests.html>

<https://gitlab.kitware.com/cmake/community/-/wikis/doc/ctest/Testing-With-CTest>

```ini
# conanfile.txt
[build_requires]
gtest/1.10.0
```

```cmake
# CMakeLists.txt (root project)
enable_testing()
...
add_subdirectory(${SUB_PROJECT_PATH})
```

```cmake
# CMakeLists.txt (subdirectory project)
enable_testing()
set(TEST_EXE ${PROJECT_NAME}.test)
set(TEST_SRC_FILES ${PROJECT_NAME}.test.cpp)
add_executable(${TEST_EXE} ${TEST_SRC_FILES})
conan_target_link_libraries(${TEST_EXE})
add_test(NAME ${TEST_EXE} COMMAND ${TEST_EXE})
```

## Run CMake Tests by CTest

<https://cmake.org/cmake/help/latest/manual/ctest.1.html>

```bash
cd {CMAKE_BUILD_TYPE} && ctest -C {CMAKE_BUILD_TYPE}
```

## Generate Unit Test Code Coverage Report by gcov and lcov

<https://jhbell.com/using-cmake-and-gcov>

<https://github.com/jhbell/cmake-gcov>

<https://dr-kino.github.io/2019/12/22/test-coverage-using-gtest-gcov-and-lcov/>

<https://github.com/dr-kino/BraveCoverage>

<https://stackoverflow.com/questions/37978016/cmake-gcov-c-creating-wrong-gcno-files>

<https://github.com/bilke/cmake-modules/blob/master/CodeCoverage.cmake>

<https://stackoverflow.com/questions/13116488/detailed-guide-on-using-gcov-with-cmake-cdash>

<https://medium.com/@naveen.maltesh/generating-code-coverage-report-using-gnu-gcov-lcov-ee54a4de3f11>

<http://ltp.sourceforge.net/coverage/lcov.php>

```bash
# Generate gcov info file with g++ compiler flags "-fprofile-arcs -ftest-coverage" or simply "--coverage"
g++ -o main -fprofile-arcs -ftest-coverage main_test.cpp -L /usr/lib -I/usr/include
g++ -o main --coverage main_test.cpp -L /usr/lib -I/usr/include

# Generate gcov data file from generated gcov info file
gcov -b ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp -o ${GCOV_OBJECT_DIR}

lcov --capture --directory ${GCOV_OBJECT_DIR} --output-file coverage.info
genhtml coverage.info --output-directory .
```

## Generate Unit Test Code Coverage Report by gcovr

<https://gcovr.com/en/stable/guide.html>

<https://github.com/gcovr/gcovr>

```bash
# Compile and generate binary object files with debug info and coverage info without optimization
g++ --coverage -g -O0 -o main main_test.cpp -L /usr/lib -I/usr/include

# Install gcovr
source .venv/bin/activate
pip install -U gcovr

# Generate coverage report by gcovr (tabular report on console)
gcovr -r ${CMAKE_CURRENT_SOURCE_DIR} --object-directory ${CMAKE_CURRENT_BINARY_DIR}

# Generate coverage report by gcovr (text file output)
gcovr -r ${CMAKE_CURRENT_SOURCE_DIR} --object-directory ${CMAKE_CURRENT_BINARY_DIR} -o gcov_report.txt

# Generate coverage report by gcovr (html file output)
gcovr -r ${CMAKE_CURRENT_SOURCE_DIR} --object-directory ${CMAKE_CURRENT_BINARY_DIR} --html-details gcov_report.html
```

## Generate Unit Test Code Coverage Report by OpenCppCoverage for Windows

<https://github.com/OpenCppCoverage/OpenCppCoverage>

```bash
# Generate coverage report by OpenCppCoverage
OpenCppCoverage.exe --sources "${NATIVE_CURRENT_SOURCE_DIR}" -- "${NATIVE_UNIT_TEST_EXE_PATH}" --working_dir "${NATIVE_UNIT_TEST_EXE_DIR}" --export_type html:"${NATIVE_COVERAGE_TARGET_DIR}"
```

## Generate Source Code Documentation by Doxygen

<https://www.doxygen.nl/manual/starting.html>

<https://github.com/doxygen/doxygen>

```ini
# conanfile.txt
[build_requires]
doxygen/1.8.20
```

```bash
# Generate Doxygen Config File
doxygen -g

# Generate Source Code Documentation
doxygen
```

## View Test Coverage Report or Doxygen Documentation by Five Server Visual Studio Code Extension

<https://marketplace.visualstudio.com/items?itemName=yandeu.five-server>

```
Right-Click a File in the Explorer > Open with Five Server
```

Example Test Coverage Report Path:
`Debug/cpp_project_framework/coverage/CoverageReport-2020-01-01-01h01m01s/CoverageReport.html`

Example Doxygen Documentation Path:
`doxygen/html/index.html`

## Preferred Doxygen Documentation Rules

### Overall styles: C++ style /// > Javadoc style /** */, (Qt style /*! */ or //! not preferred)

### File documentation: Javadoc style

```c++
/**
* @file    cpp_project_framework.h
* @author  Curtis Lo
* @brief   This file is just a dummy header file
*/
```

### Single line brief description: C++ style

```c++
/// Get the test case name of current test case
#define GET_TEST_CASE_NAME() ((test_info_->test_suite_name() + std::string(".") + test_info_->name()).c_str())
```

### Brief description with other documenation: C++ style with @brief command

```c++
/// @brief Execute the code block with scoped trace
/// @param code code to be executed with scoped trace
#define SCOPED_TRACE_CODE_BLOCK(code) { SCOPED_TRACE(GET_TEST_CASE_NAME()); code; }
```

### Brief description after member: C++ style

```c++
std::map<std::string /* name */, ObjectPtr> objects; ///< objects to be managed
```

### Paremeter inline documentation: Javadoc style

```c++
virtual ObjectPtr Get(const std::string& name /**< [in] name of the object */)
```

### Brief description for variables

Brief description sentence for variables must start with lowercase word

```c++
std::map<std::string /* name */, ObjectPtr> objects; ///< objects to be managed
```

```c++
virtual ObjectPtr Get(const std::string& name /**< [in] name of the object */)
```

### Brief description for files, classes, functions, methods

Brief description sentence for files, classes, functions, methods, macro functions must start with captalized word

```c++
/**
* @file    cpp_project_framework.h
* @author  Curtis Lo
* @brief   This file is just a dummy header file
*/
```

```c++
/// Get the test case name of current test case
#define GET_TEST_CASE_NAME() ((test_info_->test_suite_name() + std::string(".") + test_info_->name()).c_str())
```

## Preferred C++ Programming Styles

Google C++ Style Guide
<https://google.github.io/styleguide/cppguide.html>

GROMACS Style Guide
<http://manual.gromacs.org/current/dev-manual/style.html>

ISO C++ Coding Standards
<https://isocpp.org/wiki/faq/coding-standards>

### C++ Naming Styles

#### C++ General Naming Rules

For the purposes of the naming rules below, a "word" is anything that you would write in English without internal spaces. This includes abbreviations, such as acronyms and initialisms. For names written in mixed case (also sometimes referred to as "camel case" or "Pascal case"), in which the first letter of each word is capitalized, prefer to capitalize abbreviations as single words, e.g., StartRpc() rather than StartRPC(), Id rather than ID, UtcTimestamp rather than UTCTimestamp.

#### C++ Variable Names (all kinds of variables including but not limited to followings: global, local, const, static, member, parameters)

The names of variables (including function parameters) and data members are all lowercase, with underscores between words, i.e. snake case => snake_case

For simplicity and easy memorization of the naming rule, prefix or suffix should not be added to the variable names for different type of variables. For examples, the followings naming styles are not preferred: leading "k" in constant variables, prefix "g_" in global variables, trailing underscore in data member variables. This also makes easier to move variables to different scopes without renaming them.

#### C++ Type Names (all kinds of types including but not limited to followings: struct, class, enum, typedef, using alias)

Type names start with a capital letter and have a capital letter for each new word, with no underscores, i.e. camel case => CamelCase

#### C++ Function Names (function and member method)

Function names start with a capital letter and have a capital letter for each new word, with no underscores, i.e. camel case => CamelCase

#### C++ Namespace Names (namespace)

The names of namespaces are all lowercase, with underscores between words, i.e. snake case => snake_case

#### C++ Macro Names (#define, including but not limited to followings: macro constant, macro function)

Macros should not be used. However, if they are absolutely needed, then they should be named with all capitals and underscores, i.e. macro case => MACRO_CASE

#### C++ Enumerator Member Names (enum member)

The names of enumerator members are all lowercase, with underscores between words, i.e. snake case => snake_case

#### C++ Main File Name (file containing the main() entry function)

Main file name must have the same name as the final program binary name which should be all lowercase, with underscores between words, i.e. snake case => snake_case

#### C++ Class File Names (file containing a single class declaration and/or definition)

Class file names must have the same name as the single class name it contains which should start with a capital letter and have a capital letter for each new word, with no underscores, i.e. camel case => CamelCase

#### C++ Template Parameter Names

Template parameters should follow the naming style for their category: type template parameters should follow the rules for type names, and non-type template parameters should follow the rules for variable names.

#### C++ Unit Test Test Suite Names

Unit test test suite names must follow the nameing convention of type/class names with "Test" as postfix, i.e. camel case => CamelCaseTest

#### C++ Unit Test Test Case Names

Unit test test case names must follow the nameing convention of function names, i.e. camel case => CamelCase

#### C++ Benchmark Function Names

Benchmark Function names must follow the nameing convention of function names with "Benchmark" as postfix, i.e. camel case => CamelCaseBenchmark

### C++ Code Formatting Styles

#### C++ Indentation

Use 4 spaces at a time for indentation. Do not use tabs in code. You should set your editor to emit spaces when you hit the tab key.

#### C++ Comments

Offset by exactly 1 space from the comment mark (e.g. //, /// or /*).

```c++
/// Structure representing a UTC date
struct UtcDate
```

#### C++ Alignment of Comments

Offset by exactly 1 space from the end of longest line to be aligned.

```c++
constexpr uint32_t utc_date_null_value = UINT32_MAX; ///< null value for UtcDate
constexpr uint16_t year_null_value = UINT16_MAX;     ///< null value for year
constexpr uint8_t month_null_value = UINT8_MAX;      ///< null value for month
constexpr uint8_t day_null_value = UINT8_MAX;        ///< null value for day
```

#### C++ Integer Literal

Integer literal
<https://en.cppreference.com/w/cpp/language/integer_literal>

Fundamental types
<https://en.cppreference.com/w/cpp/language/types>

```text
Signed 8-bit integer (int8_t or char): 0 (no suffix)
Unsigned 8-bit integer (uint8_t or unsigned char): 0U (suffix with U)
Signed 16-bit integer (int16_t or short): 0 (no suffix)
Unsigned 16-bit integer (uint16_t or unsigned short): 0U (suffix with U)
Signed 32-bit integer (int32_t or long): 0L (suffix with L)
Unsigned 32-bit integer (uint32_t or unsigned long): 0UL (suffix with UL)
Signed 64-bit integer (int64_t or long long): 0LL (suffix with LL)
Unsigned 64-bit integer (uint64_t or unsigned long long): 0ULL (suffix with ULL)
```

#### C++ Include Header Ordering

Google C++ Style Guide: Names and Order of Includes
<https://google.github.io/styleguide/cppguide.html#Names_and_Order_of_Includes>

Include header ordering should follow above "Google C++ Style Guide: Names and Order of Includes".
Except "All of a project's header files should be listed as descendants of the project's source directory without use of UNIX directory aliases . (the current directory) or .. (the parent directory)." as its useful for identifying same project headers.

Include headers in the following order: Related header, C system headers, C++ standard library headers, other libraries' headers, your project's headers.
Separate each non-empty group with one blank line.
Within each section the includes should be ordered alphabetically.

C system headers (e.g. \<stdlib.h>) and C++ standard library headers (e.g. \<cstdlib>) must be enclosed by angle brackets
Other headers (e.g. "boost/asio.hpp") must be enclosed by double quotes

In dir/foo.cc or dir/foo_test.cc, whose main purpose is to implement or test the stuff in dir2/foo2.h, order your includes as follows:

```text
dir2/foo2.h.
A blank line
C system headers (more precisely: headers in angle brackets with the .h extension), e.g., <unistd.h>, <stdlib.h>.
A blank line
C++ standard library headers (without file extension), e.g., <algorithm>, <cstddef>.
A blank line
Other libraries' .h files.
A blank line
Your project's .h files.
```

For example, the includes in google-awesome-project/src/foo/internal/fooserver.cc might look like this:

```c++
#include "foo/server/fooserver.h"

#include <sys/types.h>
#include <unistd.h>

#include <string>
#include <vector>

#include "base/basictypes.h"
#include "base/commandlineflags.h"

#include "foo/server/bar.h"
```

## Support Microbenchmark Performance Test

Micro benchmarking libraries for C++
<https://www.bfilipek.com/2016/01/micro-benchmarking-libraries-for-c.html>

Google Benchmark
<https://github.com/google/benchmark>

sltbench
<https://github.com/ivafanas/sltbench>

SkyPat
<https://github.com/skymizer/SkyPat>

```ini
# conanfile.txt
[build_requires]
benchmark/1.5.1
```

## Use Git Submodules

Git Tools - Submodules
<https://www.git-scm.com/book/en/v2/Git-Tools-Submodules>

git-submodule - Initialize, update or inspect submodules
<https://git-scm.com/docs/git-submodule>

```bash
git submodule add <repository url> [<submodule name>]
```
