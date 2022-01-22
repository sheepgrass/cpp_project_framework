# CMake Tutorial: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# specify the minimum required cmake version
cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(cpp_project_framework VERSION 1.0)

# detect build type and build folder
message("CMake Build Type: ${CMAKE_BUILD_TYPE}")
message("Source Directory: ${CMAKE_CURRENT_SOURCE_DIR}")
message("Binary Directory: ${CMAKE_CURRENT_BINARY_DIR}")
string(REGEX MATCH "(Debug|Release|MinSizeRel|RelWithDebInfo)$" DETECTED_BUILD_FOLDER ${CMAKE_CURRENT_BINARY_DIR})
message("Detected Build Folder: ${DETECTED_BUILD_FOLDER}")
if(CMAKE_BUILD_TYPE)
    set(DETECTED_BUILD_TYPE ${CMAKE_BUILD_TYPE})
    message("Use CMake Build Type as Detected Build Type: ${DETECTED_BUILD_TYPE}")
else()
    set(DETECTED_BUILD_TYPE ${DETECTED_BUILD_FOLDER})
    message("No CMake Build Type, Use Detected Build Folder as Detected Build Type: ${DETECTED_BUILD_TYPE}")
endif()

# install conan dependencies
if(WIN32)
    set(VENV_ACTIVATE_CMD ".venv\\Scripts\\activate")
else()
    set(VENV_ACTIVATE_CMD "source .venv/bin/activate")
endif()
set(CONAN_INSTALL_CMD "conan install conanfile.txt -b missing -s build_type=${DETECTED_BUILD_TYPE} -if ${DETECTED_BUILD_FOLDER}")
execute_process(COMMAND CMD /c "${VENV_ACTIVATE_CMD} && ${CONAN_INSTALL_CMD}" WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

# add extra project directories
set(SUB_PROJECT_PATH ${CMAKE_PROJECT_NAME})
if(SUB_PROJECT_PATH)
    add_subdirectory(${SUB_PROJECT_PATH})
endif()
