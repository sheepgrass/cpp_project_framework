# @file     cpp_project_framework_callables.cmake
# @author   Curtis Lo

# detect build type and build folder
macro(cpf_detect_build_type)
    message("CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
    message("CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}")
    message("CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}")
    if(NOT CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_CONFIGURATION_TYPES Debug Release MinSizeRel RelWithDebInfo)
    endif()
    message("CMAKE_CONFIGURATION_TYPES=${CMAKE_CONFIGURATION_TYPES}")
    list(JOIN CMAKE_CONFIGURATION_TYPES "|" SUPPORTED_BUILD_TYPES)
    message("SUPPORTED_BUILD_TYPES=${SUPPORTED_BUILD_TYPES}")
    string(REGEX MATCH "(${SUPPORTED_BUILD_TYPES})$" DETECTED_BUILD_FOLDER ${CMAKE_CURRENT_BINARY_DIR})
    message("DETECTED_BUILD_FOLDER=${DETECTED_BUILD_FOLDER}")
    if(NOT DETECTED_BUILD_FOLDER IN_LIST CMAKE_CONFIGURATION_TYPES)
        message(FATAL_ERROR "DETECTED_BUILD_FOLDER (${DETECTED_BUILD_FOLDER}) must be in one of the CMAKE_CONFIGURATION_TYPES (${CMAKE_CONFIGURATION_TYPES})")
    endif()
    if(CMAKE_BUILD_TYPE)
        if(NOT DETECTED_BUILD_FOLDER STREQUAL CMAKE_BUILD_TYPE)
            message(FATAL_ERROR "DETECTED_BUILD_FOLDER (${DETECTED_BUILD_FOLDER}) must be same as CMAKE_BUILD_TYPE (${CMAKE_BUILD_TYPE})")
        endif()
        set(DETECTED_BUILD_TYPE ${CMAKE_BUILD_TYPE})
        message("CMAKE_BUILD_TYPE found, DETECTED_BUILD_TYPE=CMAKE_BUILD_TYPE=${DETECTED_BUILD_TYPE}")
    else()
        set(DETECTED_BUILD_TYPE ${DETECTED_BUILD_FOLDER})
        message("CMAKE_BUILD_TYPE not found, DETECTED_BUILD_TYPE=DETECTED_BUILD_FOLDER=${DETECTED_BUILD_TYPE}")
    endif()
    string(TOUPPER ${DETECTED_BUILD_TYPE} DETECTED_BUILD_TYPE_UPPER)
endmacro()

# check if python virtual environment exists
macro(cpf_detect_virtual_environment)
    set(VENV_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.venv)
    if(IS_DIRECTORY ${VENV_PATH})
        message("python virtual environment found, VENV_PATH=${VENV_PATH}")
    else()
        find_program(PYTHON_PATH NAMES python3 python HINTS "$ENV{LOCALAPPDATA}\\Continuum\\anaconda3" REQUIRED)
        message("PYTHON_PATH=${PYTHON_PATH}")
        execute_process(COMMAND ${PYTHON_PATH} -m venv .venv WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
        if(IS_DIRECTORY ${VENV_PATH})
            message("python virtual environment created, VENV_PATH=${VENV_PATH}")
        else()
            message(FATAL_ERROR "python virtual environment not found, VENV_PATH=${VENV_PATH}")
        endif()
    endif()
    if(WIN32)
        set(VENV_ACTIVATE_CMD ".venv\\Scripts\\activate")
    else()
        set(VENV_ACTIVATE_CMD "source .venv/bin/activate")
    endif()
endmacro()

# install conan dependencies
macro(cpf_install_conan_dependencies)
    set(PIP_INSTALL_CONAN_CMD "pip install -U conan")
    set(CONAN_INSTALL_CMD "conan install conanfile.txt -b missing -s build_type=${DETECTED_BUILD_TYPE} -if ${DETECTED_BUILD_FOLDER}")
    if(WIN32)
        execute_process(COMMAND CMD /c "${VENV_ACTIVATE_CMD} && ${PIP_INSTALL_CONAN_CMD} && ${CONAN_INSTALL_CMD}" WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    else()
        execute_process(COMMAND bash -c "${VENV_ACTIVATE_CMD} && ${PIP_INSTALL_CONAN_CMD} && ${CONAN_INSTALL_CMD}" WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
endmacro()

# inject conan information
macro(cpf_inject_conan_info)
    if(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
    message("cmake_multi generator conan information detected")
    include(${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
    conan_basic_setup()
    elseif(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    message("cmake generator conan information detected")
    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()
    else()
    message("no cmake generator conan information detected")
    endif()
endmacro()

# get variable by build type
function(cpf_get_variable_by_build_type VARIABLE_NAME)
    if (DEFINED ${VARIABLE_NAME}_${DETECTED_BUILD_TYPE_UPPER})
        set(CPF_GET_VARIABLE ${${VARIABLE_NAME}_${DETECTED_BUILD_TYPE_UPPER}} PARENT_SCOPE)
    else()
        set(CPF_GET_VARIABLE ${${VARIABLE_NAME}} PARENT_SCOPE)
    endif()
endfunction()

# set project type
macro(cpf_set_project_type PROJECT_TYPE_ARG)
    message("PROJECT_TYPE_ARG=${PROJECT_TYPE_ARG}")
    set(PROJECT_TYPE ${PROJECT_TYPE_ARG})

    if(PROJECT_TYPE STREQUAL "LIB")
        set(IS_LIB TRUE)
    elseif(PROJECT_TYPE STREQUAL "EXE")
        set(IS_EXE TRUE)
    elseif(PROJECT_TYPE STREQUAL "HEADER_ONLY")
        set(IS_HEADER_ONLY TRUE)
    endif()

    set(SUPPORTED_PROJECT_TYPES "LIB" "EXE" "HEADER_ONLY")
    if(PROJECT_TYPE)
        if(NOT PROJECT_TYPE IN_LIST SUPPORTED_PROJECT_TYPES)
            message(WARNING "PROJECT_TYPE (${PROJECT_TYPE}) should be in one of the SUPPORTED_PROJECT_TYPES (${SUPPORTED_PROJECT_TYPES})")
            set(PROJECT_TYPE "")
        endif()
    endif()

    if(NOT PROJECT_TYPE)
        if(IS_LIB)
            set(PROJECT_TYPE "LIB")
        elseif(IS_EXE)
            set(PROJECT_TYPE "EXE")
        else()
            set(PROJECT_TYPE "HEADER_ONLY")
            set(IS_HEADER_ONLY TRUE)
        endif()
    endif()

    message("PROJECT_TYPE=${PROJECT_TYPE}")
    message("IS_LIB=${IS_LIB}")
    message("IS_EXE=${IS_EXE}")
    message("IS_HEADER_ONLY=${IS_HEADER_ONLY}")
endmacro()

# find all header files
macro(cpf_find_all_header_files)
    if(NOT HEADER_FILES)
        file(GLOB HEADER_FILES *.h *.hpp)
    endif()
endmacro()

# add binary target
macro(cpf_add_binary_target)
    # build the static and shared libraries (make)
    if(IS_LIB)
        add_library(static_lib STATIC ${SRC_FILES})
        add_library(shared_lib SHARED ${SRC_FILES})
    endif()

    # build the executable (make)
    if(IS_EXE)
        add_executable(exe ${SRC_FILES})
    endif()
endmacro()

# link binary target with depending library files
macro(cpf_binary_target_link_libraries)
    # specify depending library files
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
endmacro()

# rename binary target
macro(cpf_rename_binary_target)
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
endmacro()

# install targets and files
macro(cpf_install)
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
endmacro()

# add gcov compiler flags
macro(cpf_add_gcov_compiler_flags)
    if(UNIX)
        set(GCOV_COMPILER_FLAGS "--coverage")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${GCOV_COMPILER_FLAGS}")
        set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE ON)
    endif()
endmacro()

# build and execute unit test (make test)
macro(cpf_add_unit_tests LINK_TYPES)
    enable_testing()

    set(SUPPORTED_LINK_TYPES static shared)
    message("LINK_TYPES=${LINK_TYPES}")
    message("SUPPORTED_LINK_TYPES=${SUPPORTED_LINK_TYPES}")

    if(NOT TEST_UNITS)
        file(GLOB TEST_UNIT_FILES *.test.cpp)
        foreach(TEST_UNIT_FILE ${TEST_UNIT_FILES})
            get_filename_component(TEST_UNIT_FILE_NAME ${TEST_UNIT_FILE} NAME)
            if(TEST_UNIT_FILE_NAME MATCHES "^(.+)\.test\.cpp$")
                list(APPEND TEST_UNITS ${CMAKE_MATCH_1})
            endif()
        endforeach()
    endif()
    message("TEST_UNITS=${TEST_UNITS}")

    foreach(TEST_UNIT ${TEST_UNITS})
        set(TEST_SRC_FILES ${TEST_UNIT}.test.cpp)
        message("    TEST_SRC_FILES=${TEST_SRC_FILES}")

        set(UNIT_TEST_EXE )
        foreach(LINK_TYPE ${LINK_TYPES})
            if(TARGET ${LINK_TYPE}_lib)
                set(UNIT_TEST_EXE ${TEST_UNIT}.${LINK_TYPE}.test)
                message("        UNIT_TEST_EXE=${UNIT_TEST_EXE}")
                add_executable(${UNIT_TEST_EXE} ${TEST_SRC_FILES})
                if(WIN32)
                    if(LINK_TYPE STREQUAL "shared")
                        add_dependencies(${UNIT_TEST_EXE} static_lib)
                    endif()
                endif()
                target_link_libraries(${UNIT_TEST_EXE} ${LINK_TYPE}_lib)
                conan_target_link_libraries(${UNIT_TEST_EXE})
                add_test(NAME ${UNIT_TEST_EXE} COMMAND ${UNIT_TEST_EXE})
                cpf_add_unit_test_gcov_target()
            endif()
        endforeach()
        if(NOT UNIT_TEST_EXE)
            set(UNIT_TEST_EXE ${TEST_UNIT}.test)
            message("        UNIT_TEST_EXE=${UNIT_TEST_EXE}")
            add_executable(${UNIT_TEST_EXE} ${TEST_SRC_FILES})
            conan_target_link_libraries(${UNIT_TEST_EXE})
            add_test(NAME ${UNIT_TEST_EXE} COMMAND ${UNIT_TEST_EXE})
            cpf_add_unit_test_gcov_target()
        endif()
    endforeach()
endmacro()

# add unit test gcov target
macro(cpf_add_unit_test_gcov_target)
    if(GCOV_COMPILER_FLAGS)
        set(GCOV_OBJECT_DIR ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${UNIT_TEST_EXE}.dir)
        set(GCOV_TARGET ${UNIT_TEST_EXE}.gcov)
        message("        GCOV_OBJECT_DIR=${GCOV_OBJECT_DIR}")
        message("        GCOV_TARGET=${GCOV_TARGET}")
        add_custom_target(${GCOV_TARGET}
            COMMAND mkdir -p ${GCOV_TARGET}
            COMMAND ${CMAKE_MAKE_PROGRAM} test
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            )
        add_custom_command(TARGET ${GCOV_TARGET}
            COMMAND echo "=================== GCOV ===================="
            COMMAND gcov -b ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp -o ${GCOV_OBJECT_DIR}
            COMMAND echo "-- Coverage files have been output to ${CMAKE_CURRENT_BINARY_DIR}/${GCOV_TARGET}"
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${GCOV_TARGET}
            )
        add_dependencies(${GCOV_TARGET} ${UNIT_TEST_EXE})
        cpf_add_unit_test_lcov_target()
    endif()
endmacro()

# add unit test lcov target
macro(cpf_add_unit_test_lcov_target)
    set(LCOV_TARGET ${UNIT_TEST_EXE}.lcov)
    add_custom_target(${LCOV_TARGET}
        COMMAND mkdir -p ${LCOV_TARGET}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
    add_custom_command(TARGET ${LCOV_TARGET}
        COMMAND echo "=================== LCOV ===================="
        COMMAND echo "-- Passing lcov tool under code coverage"
        COMMAND lcov --capture --directory ${GCOV_OBJECT_DIR} --output-file coverage.info
        COMMAND echo "-- Generating HTML output files"
        COMMAND genhtml coverage.info --output-directory .
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${LCOV_TARGET}
        )
    add_dependencies(${LCOV_TARGET} ${GCOV_TARGET})
endmacro()
