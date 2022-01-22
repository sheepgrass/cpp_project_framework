# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(cpp_project_framework VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# inject Conan information
include(${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
conan_basic_setup()

# specify the header files
set(HEADER_FILES
)

# specify the source files
set(SRC_FILES
    ${HEADER_FILES}
)

# set postfix for output name of debug build type
if(NOT DEFINED CMAKE_DEBUG_POSTFIX)
    set(CMAKE_DEBUG_POSTFIX _d)
endif()

# build the static and shared libraries (make)
add_library(static_lib STATIC ${SRC_FILES})
add_library(shared_lib SHARED ${SRC_FILES})

# link with depending library files
conan_target_link_libraries(static_lib)
conan_target_link_libraries(shared_lib)

# rename the generated static and shared libraries
set(LIBRARY_NAME "${PROJECT_NAME}")
set_target_properties(static_lib PROPERTIES OUTPUT_NAME ${LIBRARY_NAME})
set_target_properties(shared_lib PROPERTIES OUTPUT_NAME ${LIBRARY_NAME})

# install the static and shared libraries and header files (make install)
install(TARGETS static_lib shared_lib DESTINATION lib)
install(FILES ${HEADER_FILES} DESTINATION include/${LIBRARY_NAME})

# build an installer (make package)
include(CPack)
