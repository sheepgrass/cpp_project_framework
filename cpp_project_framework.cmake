# @file     cpp_project_framework.cmake
# @author   Curtis Lo

include(${CMAKE_SOURCE_DIR}/cpp_project_framework_callables.cmake)

cpf_detect_build_type()
cpf_detect_virtual_environment()
cpf_install_conan_dependencies()
cpf_inject_conan_info()

# enable testing support
enable_testing()
