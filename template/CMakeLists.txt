# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION ${cmake_version})

# set the project name and version
project(${project_name} VERSION ${project_version} DESCRIPTION "${project_description}")

# inject C++ Project Framework information
include(cpp_project_framework.cmake)

# add extra project directories
set(SUB_PROJECT_PATH ${CMAKE_PROJECT_NAME})
if(SUB_PROJECT_PATH)
    add_subdirectory(${SUB_PROJECT_PATH})
endif()
