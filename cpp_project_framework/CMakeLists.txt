# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(cpp_project_framework VERSION 1.0.0)

# add C++ project framework support
set(CPF_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)
include(${CPF_SOURCE_DIR}/cpp_project_framework_callables.cmake)

# set the project type
cpf_set_project_type("HEADER_ONLY")

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# specify extra include directories
set(EXTRA_INCLUDE_PATHS )
if(EXTRA_INCLUDE_PATHS)
    include_directories(${EXTRA_INCLUDE_PATHS})
endif()

# specify extra library directories
set(EXTRA_LIB_PATHS )
if(EXTRA_LIB_PATHS)
    link_directories(${EXTRA_LIB_PATHS})
endif()

# add extra project directories
set(SUB_PROJECT_PATH )
if(SUB_PROJECT_PATH)
    add_subdirectory(${SUB_PROJECT_PATH})
endif()

# inject conan information
cpf_inject_conan_info()

# specify the header files
set(HEADER_FILES cpp_project_framework.h gtest.h filesystem.h)

# find all header files
cpf_find_all_header_files()

# specify the source files
set(SRC_FILES cpp_project_framework.cpp ${HEADER_FILES})

# set the main source file containing the main function
if(IS_EXE)
    set(MAIN_SRC_FILE main.cpp)
endif()

# set postfix for output name of debug build type
if(NOT DEFINED CMAKE_DEBUG_POSTFIX)
    set(CMAKE_DEBUG_POSTFIX _d)
endif()

# add gcov compiler flags
cpf_add_gcov_compiler_flags()

# enable msvc updated __cplusplus macro
cpf_enable_msvc_updated_cplusplus_macro()

# suppress specific msvc compiler warnings
cpf_suppress_msvc_compiler_warnings("")

# suppress specific msvc linker warnings
cpf_suppress_msvc_linker_warnings("4099")

# add binary target
cpf_add_binary_target()

# specify depending library files
set(USER_STATIC_MODULES )
set(USER_DYNAMIC_MODULES )
set(BOOST_STATIC_MODULES )
set(BOOST_DYNAMIC_MODULES )

if(UNIX)
    string(REGEX REPLACE  "([^;]+)" "\\1.a" USER_STATIC_LIBS "${USER_STATIC_MODULES}")
    string(REGEX REPLACE  "([^;]+)" "\\1.so" USER_DYNAMIC_LIBS "${USER_DYNAMIC_MODULES}")
    string(REGEX REPLACE "([^;]+)" "boost_\\1.a" BOOST_STATIC_LIBS "${BOOST_STATIC_MODULES}")
    string(REGEX REPLACE "([^;]+)" "boost_\\1.so" BOOST_DYNAMIC_LIBS "${BOOST_DYNAMIC_MODULES}")
else()
    set(USER_STATIC_LIBS "${USER_STATIC_MODULES}")
    set(USER_DYNAMIC_LIBS "${USER_DYNAMIC_MODULES}")
    set(BOOST_STATIC_LIBS "${BOOST_STATIC_MODULES}")
    set(BOOST_DYNAMIC_LIBS "${BOOST_DYNAMIC_MODULES}")
endif()

# link target with depending library files
cpf_binary_target_link_libraries()

# rename binary target
cpf_rename_binary_target()

# install targets and files
cpf_install()
foreach(RES_FILE ".gitignore" "LICENSE" "conanfile.txt" "CMakeLists.txt" "make.bat" "Makefile" "cpp_project_framework_callables.cmake" "cpp_project_framework.cmake")
    install(FILES ${CPF_SOURCE_DIR}/${RES_FILE} DESTINATION res)
endforeach()
install(FILES ${CPF_SOURCE_DIR}/${PROJECT_NAME}/CMakeLists.txt DESTINATION res/${PROJECT_NAME})
install(DIRECTORY ${CPF_SOURCE_DIR}/test_package/ DESTINATION res/test_package PATTERN "build" EXCLUDE)

# build an installer (make package)
include(CPack)

# add unit tests
if(IS_LIB)
    cpf_add_unit_tests("static;shared")
else()
    cpf_add_unit_tests("")
endif()
if(NOT (ANDROID AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
    foreach(UNIT_TEST_EXE ${UNIT_TEST_EXE_LIST})
        if(UNIX)
            target_link_libraries(${UNIT_TEST_EXE} stdc++fs)
        endif()
    endforeach()
endif()

# add doxygen target
cpf_add_doxygen_target()

# add benchmark tests
if(IS_LIB)
    cpf_add_benchmarks("static;shared")
else()
    cpf_add_benchmarks("")
endif()
