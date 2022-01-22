# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(cpp_project_framework VERSION 1.0)

# set the project type
if(NOT IS_EXE)
    if (PROJECT_TYPE EQUAL "LIB")
        set(IS_LIB TRUE)
    endif()
endif()
if(NOT IS_LIB)
    if(PROJECT_TYPE EQUAL "EXE")
        set(IS_EXE TRUE)
    endif()
endif()
if(NOT IS_EXE AND NOT IS_LIB)
    set(PROJECT_TYPE "HEADER_ONLY")
    set(IS_HEADER_ONLY TRUE)
endif()

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# specify extra include directories
set(EXTRA_INCLUDE_PATHS )
if(EXTRA_INCLUDE_PATHS)
    include_directories(${EXTRA_INCLUDE_PATHs})
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

# inject Conan information
include(${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
conan_basic_setup()

# specify the header files
set(HEADER_FILES cpp_project_framework.h)

# find all header files
if(NOT HEADER_FILES)
    file(GLOB HEADER_FILES *.h *.hpp)
endif()

# specify the source files
set(SRC_FILES cpp_project_framework.cpp ${HEADER_FILES})

# set postfix for output name of debug build type
if(NOT DEFINED CMAKE_DEBUG_POSTFIX)
    set(CMAKE_DEBUG_POSTFIX _d)
endif()

# build the static and shared libraries (make)
if(IS_LIB)
    add_library(static_lib STATIC ${SRC_FILES})
    add_library(shared_lib SHARED ${SRC_FILES})
endif()

# build the executable (make)
if(IS_EXE)
    add_executable(exe ${SRC_FILES})
endif()

# specify depending library files
set(USER_STATIC_MODULES )
set(USER_DYNAMIC_MODULES )
set(BOOST_STATIC_MODULES )
set(BOOST_DYNAMIC_MODULES )

string(REGEX REPLACE  "([^;]+)" "\\1.a" USER_STATIC_LIBS "${USER_STATIC_MODULES}")
string(REGEX REPLACE  "([^;]+)" "\\1.so" USER_DYNAMIC_LIBS "${USER_DYNAMIC_MODULES}")
string(REGEX REPLACE "([^;]+)" "boost_\\1.a" BOOST_STATIC_LIBS "${BOOST_STATIC_MODULES}")
string(REGEX REPLACE "([^;]+)" "boost_\\1.so" BOOST_DYNAMIC_LIBS "${BOOST_DYNAMIC_MODULES}")

set(STATIC_LIBS ${USER_STATIC_LIBS} ${BOOST_STATIC_LIBS})
set(DYNAMIC_LIBS ${USER_DYNAMIC_LIBS} ${BOOST_DYNAMIC_LIBS})

set(LIB_FILES ${STATIC_LIBS} ${DYNAMIC_LIBS})

# link with depending library files
if(IS_LIB)
    target_link_libraries(static_lib ${LIB_FILES})
    target_link_libraries(shared_lib ${LIB_FILES})
endif()
if(IS_EXE)
    target_link_libraries(exe ${LIB_FILES})
endif()

# link with depending library files using conan
if(IS_LIB)
    conan_target_link_libraries(static_lib)
    conan_target_link_libraries(shared_lib)
endif()
if(IS_EXE)
    conan_target_link_libraries(exe)
endif()

# rename the generated static and shared libraries
if(IS_LIB)
    set(LIBRARY_NAME "${PROJECT_NAME}")
    set_target_properties(static_lib PROPERTIES OUTPUT_NAME ${LIBRARY_NAME})
    set_target_properties(shared_lib PROPERTIES OUTPUT_NAME ${LIBRARY_NAME})
endif()

# rename the generated executable
if(IS_EXE)
    set(EXE_NAME "${PROJECT_NAME}")
    set_target_properties(exe PROPERTIES OUTPUT_NAME ${EXE_NAME})
endif()

# install the static and shared libraries and header files (make install)
if(IS_LIB)
    install(TARGETS static_lib shared_lib DESTINATION lib)
    install(FILES ${HEADER_FILES} DESTINATION include/${LIBRARY_NAME})
endif()

# install the executable (make install)
if(IS_EXE)
    install(TARGETS exe DESTINATION bin)
endif()

# install the header files (make install)
if(IS_HEADER_ONLY)
set(LIBRARY_NAME "${PROJECT_NAME}")
install(FILES ${HEADER_FILES} DESTINATION include/${LIBRARY_NAME})
endif()

# build an installer (make package)
include(CPack)

# build and execute unit test (make test)
enable_testing()
set(TEST_EXE ${PROJECT_NAME}.test)
set(TEST_SRC_FILES cpp_project_framework.cpp)
add_executable(${TEST_EXE} ${TEST_SRC_FILES})
conan_target_link_libraries(${TEST_EXE})
add_test(NAME ${TEST_EXE} COMMAND ${TEST_EXE})
