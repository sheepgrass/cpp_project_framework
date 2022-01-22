# C++ Project Framework

C++ Project Framework is a framework for creating C++ project.

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
