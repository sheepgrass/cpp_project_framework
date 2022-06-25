# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(cpp_project_framework VERSION 1.0.0 DESCRIPTION "C++ Project Framework is a framework for creating C++ project.")

# inject C++ Project Framework information
include(cpp_project_framework.cmake)

# add extra project directories
set(SUB_PROJECT_PATH ${CMAKE_PROJECT_NAME})
if(SUB_PROJECT_PATH)
    add_subdirectory(${SUB_PROJECT_PATH})
endif()
