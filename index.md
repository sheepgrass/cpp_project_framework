---
title: "C++ Project Framework"
---

## Features

C++ Project Framework (CPF) provides tools to help in different stages of C++ development:

- C++ Canonical Project Structure Creation (by CPF)
- Cross Platform C++ Project Creation (by CMake)
- Unit Tests (by Google Test)
- Functional/Integration Tests (by CTest (CMake))
- Package/Installer Creation (by CPack (CMake))
- Code Coverage Report (by gcovr or OpenCppCoverage)
- Package Management (by Conan)
- Source Code Documentation (by Doxygen)
- Continous Integration/Continous Delivery (by Jenkins)

## Prerequisites

```yaml
Build System Generator: CMake >= 3.10
Build System: GNU Make >= 4.2 (Linux), MSBuild >= 14.0 (Visual Studio 2015) (Windows)
Compiler: g++ >= 9.1 (Linux), MSVC >= 14.0 (Visual Studio 2015) (Windows)
Version Control System: Git >= 2.16
Package Manager Scripting: Python >= 3.6
```

## Usage

### Install C++ Project Framework Python Package from PyPI

```sh
# Upgrade pip to latest version
$ python -m pip install --upgrade pip

# Install C++ Project Framework
$ python -m pip install cpp_project_framework
```

### Create New C++ Project by C++ Project Framework Python Script

```sh
$ create_new_cpp_project
Project Name (will be auto converted to snake case): Test Cpp Project Framework
Project Type (('LIB', 'EXE', 'HEADER_ONLY')) (default to LIB if ignored):
Project Version (default to 1.0 if ignored):
Project Author: Curtis Lo
Project Title (space separated title case of Project Name (Test Cpp Project Framework) if ignored):
Project Description (same as Project Title (Test Cpp Project Framework) if ignored):
Parent Directory (default to current directory (.) if ignored):
C++ Standard (default to 14 if ignored):
CMake Version (default to 3.10 if ignored):
```

## Canonical Project Structure for C++

The C++ project created would follow below cononical project structure:

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
