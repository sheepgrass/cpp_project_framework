# C++ Project Framework

C++ Project Framework is a framework for creating C++ project.

## Canonical Project Structure for C++

<http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1204r0.html>

```c++
<name>/
├── <name>/
│   └── ...
├── <module>/
│   └── <module>.h  // header file containing mainly module declarations
│   └── <module>.hpp    // header file containing module declarations and/or definitions
│   └── <module>.cpp    // source file containing module definitions
│   └── <module>.test.cpp   // source file containing module unit tests
└── tests/  // functional/integration tests
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
```

## Similar Projects Creating C++ Project Framework

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

## Visual Studio Code CMake Tools Settings

```json
"cmake.buildDirectory": "${workspaceFolder}/${buildType}"
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
std::map<std::string /* name */, ObjectPtr> objects;    ///< objects to be managed
```

### Paremeter inline documentation: Javadoc style

```c++
virtual ObjectPtr Get(const std::string& name /**< [in] name of the object */)
```
