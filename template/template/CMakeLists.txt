# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(${project_name} VERSION ${project_version})

# add C++ project framework support
set(CPF_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)
include(${CPF_SOURCE_DIR}/cpp_project_framework_callables.cmake)

# set the project type
cpf_set_project_type("LIB")

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# inject conan information
cpf_inject_conan_info()

# specify the header files
set(HEADER_FILES
    ${project_camel_name}.h
)

# specify the source files
set(SRC_FILES
    ${project_camel_name}.cpp
    ${HEADER_FILES}
)

# set postfix for output name of debug build type
if(NOT DEFINED CMAKE_DEBUG_POSTFIX)
    set(CMAKE_DEBUG_POSTFIX _d)
endif()

# add gcov compiler flags
cpf_add_gcov_compiler_flags()

# add binary target
cpf_add_binary_target()

# link target with depending library files
cpf_binary_target_link_libraries()

# rename binary target
cpf_rename_binary_target()

# install targets and files
cpf_install()

# build an installer (make package)
include(CPack)

# add unit tests
cpf_add_unit_tests("static;shared")

# add doxygen target
cpf_add_doxygen_target()

# add benchmark tests
cpf_add_benchmarks("static;shared")
