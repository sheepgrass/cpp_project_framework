@ECHO OFF

IF "%BUILD_TYPE%"=="" (
    ECHO BUILD_TYPE not set
    @EXIT /B 1
)

IF "%PYTHON_EXE%"=="" SET PYTHON_EXE=%LOCALAPPDATA%\Continuum\anaconda3\python.exe

SET CMAKE_PROJECT_ARG=
IF NOT "%BUILD_SYSTEM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -G "%BUILD_SYSTEM%"
IF NOT "%TARGET_PLATFORM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -A "%TARGET_PLATFORM%"

SET CMAKE_BUILD_ARG=
if NOT "%JOBS%"=="" SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j%JOBS% ELSE SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j4

SET CPACK_ARG=
IF NOT "%PACK_FORMAT%"=="" SET CPACK_ARG=%CPACK_ARG% -G %PACK_FORMAT%

SET TARGET=%1
IF "%TARGET%"=="" SET TARGET=all

SET ARGS=%*

@ECHO ON
@CALL :%TARGET%
@ECHO OFF
@EXIT /B %ERRORLEVEL%

:all
@CALL :conan_install
@CALL :cmake_project
@CALL :build
@EXIT /B 0

:venv_create
%PYTHON_EXE% -m venv .venv
@EXIT /B 0

:venv_delete
RMDIR /S /Q .venv
@EXIT /B 0

:venv_activate
CALL .venv\Scripts\activate
@EXIT /B 0

:venv_deactivate
CALL deactivate
@EXIT /B 0

:pip_install_conan
@CALL :venv_activate
pip install -U conan
conan
@EXIT /B 0

:conan_list
@CALL :venv_activate
conan remote list
@EXIT /B 0

:conan_install
@CALL :venv_activate
conan install conanfile.txt -b missing -s build_type=%BUILD_TYPE% -if %BUILD_TYPE%
@EXIT /B 0

:cmake_project
cmake -S . -B %BUILD_TYPE% -DCMAKE_BUILD_TYPE=%BUILD_TYPE% %CMAKE_PROJECT_ARG%
@EXIT /B 0

:build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% %CMAKE_BUILD_ARG%
@EXIT /B 0

:clean
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target clean %CMAKE_BUILD_ARG%
@EXIT /B 0

:clean_and_build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --clean-first %CMAKE_BUILD_ARG%
@EXIT /B 0

:cmake_open
cmake --open %BUILD_TYPE%
@EXIT /B 0

:package
@CALL :build
CD %BUILD_TYPE%
cpack -C %BUILD_TYPE% %CPACK_ARG%
CD ..
@EXIT /B 0

:test
@CALL :build
CD %BUILD_TYPE%
ctest -C %BUILD_TYPE%
CD ..
@EXIT /B 0

:coverage
@CALL :build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target coverage %CMAKE_BUILD_ARG%
@EXIT /B 0

:delete
RMDIR /S /Q %BUILD_TYPE%
@EXIT /B 0

:project_name
@FOR /F %%I IN ('TYPE %BUILD_TYPE%\CMakeCache.txt ^| FIND "CMAKE_PROJECT_NAME:STATIC="') DO @SET PROJECT_NAME=%%I
@SET PROJECT_NAME=%PROJECT_NAME:~26%
@ECHO %PROJECT_NAME%
@EXIT /B 0

:project_version
@FOR /F %%I IN ('TYPE %BUILD_TYPE%\CMakeCache.txt ^| FIND "CMAKE_PROJECT_VERSION:STATIC="') DO @SET PROJECT_VERSION=%%I
@SET PROJECT_VERSION=%PROJECT_VERSION:~29%
@ECHO %PROJECT_VERSION%
@EXIT /B 0

:doxygen_bin_path
@CALL :venv_activate
@FOR /F "usebackq" %%I IN (`python -c "lines = [l.strip() for l in list(open('%BUILD_TYPE%/conanbuildinfo.txt'))]; print(lines[lines.index('[bindirs_doxygen]') + 1])"`) DO @SET DOXYGEN_BIN_PATH=%%I
@ECHO %DOXYGEN_BIN_PATH%
@EXIT /B 0
@EXIT /B 0

:doxygen
@CALL :doxygen_bin_path
%DOXYGEN_BIN_PATH%/%ARGS%
@EXIT /B 0

:doxygen_delete
RMDIR /S /Q docs
@EXIT /B 0

:recipe_create
@CALL :venv_activate
@CALL :project_name
@CALL :project_version
IF NOT EXIST package MKDIR package
CD package
conan new %PROJECT_NAME%/%PROJECT_VERSION% -t
CD ..
@EXIT /B 0

:conan_package_test
@CALL :venv_activate
conan create . demo/testing
@EXIT /B 0

:conan_package
@CALL :venv_activate
conan create .
@EXIT /B 0

:conan_remove_cache
@CALL :venv_activate
@CALL :project_name
conan remove %PROJECT_NAME%*
@EXIT /B 0

:conan_start_local
@CALL :venv_activate
conan_server
@EXIT /B 0

:conan_add_local
@CALL :venv_activate
conan remote add local http://localhost:9300/
@EXIT /B 0

:conan_upload_local_test
@CALL :venv_activate
@CALL :project_name
@CALL :project_version
conan upload %PROJECT_NAME%/%PROJECT_VERSION%@demo/testing --all -r=local
@EXIT /B 0

:conan_upload_local
@CALL :venv_activate
@CALL :project_name
@CALL :project_version
conan upload %PROJECT_NAME%/%PROJECT_VERSION% --all -r=local
@EXIT /B 0

:conan_remove_local
@CALL :venv_activate
@CALL :project_name
conan remove %PROJECT_NAME%* -r local
@EXIT /B 0

:echo
ECHO %BUILD_TYPE%
@EXIT /B 0
