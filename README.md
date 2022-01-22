# C++ Project Framework

C++ Project Framework is a framework for creating C++ project.

## Canonical Project Structure for C++

    http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1204r0.html

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

## Create Python Virtual Environment under Current Project

    # Linux
    python3 -m venv .venv
    source .venv/bin/activate
    ...
    deactivate

    # Windows
    %LOCALAPPDATA%\Continuum\anaconda3\python.exe -m venv .venv
    .venv\Scripts\activate
    ...
    deactivate

## Install Conan

    https://docs.conan.io/en/latest/installation.html

    source .venv/bin/activate
    pip install conan
    conan

## Search for Repository (Package Recipes) in ConanCenter

    https://conan.io/center

    conan search --remote=conan-center g3log
    conan inspect g3log/1.3.3

## Create Conan File

    https://docs.conan.io/en/latest/getting_started.html

    # conanfile.txt
    [requires]

    [generators]
    cmake_multi

## Conan Multi-configuration Generator

    https://docs.conan.io/en/latest/integrations/build_system/cmake/cmake_multi_generator.html

## CMake Build Types

    CMAKE_BUILD_TYPE=[Debug|Release|MinSizeRel|RelWithDebInfo]

## Install Required Dependencies by Conan

    https://docs.conan.io/en/latest/reference/commands/consumer/install.html

    conan install . -b missing -s build_type={CMAKE_BUILD_TYPE} -if {CMAKE_BUILD_TYPE}

## Conan Package Location

    # Linux
    ~/.conan/data

    # Windows
    %USERPROFILE%\.conan\data

## Generate CMake Project

    https://cmake.org/cmake/help/latest/manual/cmake.1.html#generate-a-project-buildsystem

    cmake -S . -B {CMAKE_BUILD_TYPE} -DCMAKE_BUILD_TYPE={CMAKE_BUILD_TYPE} [-G "Visual Studio 14 2015" -A x64]

## Build CMake Project

    https://cmake.org/cmake/help/v3.14/manual/cmake.1.html#build-a-project

    cmake --build {CMAKE_BUILD_TYPE} [--clean-first -j4 -v]

## Open CMake Generated Project

    https://cmake.org/cmake/help/latest/manual/cmake.1.html#open-a-project

    cmake --open {CMAKE_BUILD_TYPE}

## Generate CMake Installer by CPack

    https://cmake.org/cmake/help/latest/manual/cpack.1.html#manual:cpack(1)

    cd {CMAKE_BUILD_TYPE} && cpack -C {CMAKE_BUILD_TYPE} [-G ZIP]

## Create Conan Package Recipe

    https://docs.conan.io/en/latest/creating_packages/getting_started.html

    mkdir package && cd package
    conan new {CMAKE_PROJECT_NAME}/{CMAKE_PROJECT_VERSION} -t

## Create Conan Package

    https://docs.conan.io/en/latest/creating_packages/getting_started.html

    conan create . demo/testing

## Get List of Conan Repository Servers (Remotes) in Use

    https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html

    conan remote list

## Add Conan Repository Server (Remote)

    conan remote add local http://localhost:9300

## Search Conan Package

    conan search {PACKAGE_NAME} -r=local

## Upload Conan Package to Conan Repository Server (Remote)

    https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html

    conan upload {CMAKE_PROJECT_NAME}/{CMAKE_PROJECT_VERSION}@demo/testing --all -r=local

## Remove Local Conan Package Cache

    conan remove {CMAKE_PROJECT_NAME}*

## Run Simple Open Source Conan Repository Server

    https://docs.conan.io/en/latest/uploading_packages/running_your_server.html

    conan_server

## Simple Open Source Conan Repository Server Config File Location

    # Linux
    ~/.conan_server/server.conf

    # Windows
    %USERPROFILE%\.conan_server\server.conf

## Simple Open Source Conan Repository Server Package Location

    # Linux
    ~/.conan_server/data

    # Windows
    %USERPROFILE%\.conan_server\data

## Support Google Test

    https://github.com/google/googletest
    https://raymii.org/s/tutorials/Cpp_project_setup_with_cmake_and_unit_tests.html
    https://gitlab.kitware.com/cmake/community/-/wikis/doc/ctest/Testing-With-CTest

    # conanfile.txt
    [build_requires]
    gtest/1.10.0

    # CMakeLists.txt (root project)
    enable_testing()
    ...
    add_subdirectory(${SUB_PROJECT_PATH})

    # CMakeLists.txt (subdirectory project)
    enable_testing()
    set(TEST_EXE ${PROJECT_NAME}.test)
    set(TEST_SRC_FILES ${PROJECT_NAME}.test.cpp)
    add_executable(${TEST_EXE} ${TEST_SRC_FILES})
    conan_target_link_libraries(${TEST_EXE})
    add_test(NAME ${TEST_EXE} COMMAND ${TEST_EXE})

## Run CMake Tests by CTest

    https://cmake.org/cmake/help/latest/manual/ctest.1.html

    cd {CMAKE_BUILD_TYPE} && ctest -C {CMAKE_BUILD_TYPE}
