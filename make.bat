@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET TARGET=%1
IF "%TARGET%"=="" SET TARGET=all

IF "%BUILD_TYPE%"=="" (
    SET NO_BUILD_TYPE_TARGETS=
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS!debug release minsizerel relwithdebinfo
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! venv_create venv_delete venv_activate venv_deactivate
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! pip_install_conan conan_list
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! doxygen_delete
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! conan_start_local conan_add_local
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! jenkins_download jenkins_start
    SET NO_BUILD_TYPE_TARGETS=!NO_BUILD_TYPE_TARGETS! echo
    FOR %%G IN (!NO_BUILD_TYPE_TARGETS!) DO (
        IF "%TARGET%"=="%%G" GOTO MAKE_START
    )
    ECHO BUILD_TYPE not set, TARGET="%TARGET%", NO_BUILD_TYPE_TARGETS="!NO_BUILD_TYPE_TARGETS!"
    @EXIT /B 1
)

:MAKE_START

IF "%PYTHON_EXE%"=="" SET PYTHON_EXE=%LOCALAPPDATA%\Continuum\anaconda3\python.exe

IF "%VIRTUAL_ENV%"=="" SET VIRTUAL_ENV=.venv

IF "%JENKINS_HOME%"=="" SET JENKINS_HOME=%USERPROFILE%\.jenkins

SET CMAKE_PROJECT_ARG=
IF NOT "%BUILD_SYSTEM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -G "%BUILD_SYSTEM%"
IF NOT "%TARGET_PLATFORM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -A "%TARGET_PLATFORM%"

SET CMAKE_BUILD_ARG=
IF NOT "%JOBS%"=="" SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j%JOBS% ELSE SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j4

SET CPACK_ARG=
IF NOT "%PACK_FORMAT%"=="" SET CPACK_ARG=%CPACK_ARG% -G %PACK_FORMAT%

@ECHO ON
@CALL :%TARGET%
@ECHO OFF
@EXIT /B %ERRORLEVEL%

:all
@CALL :conan_install
@CALL :cmake_project
@CALL :build
@EXIT /B 0

:debug
SET BUILD_TYPE=Debug
@CALL :all
@EXIT /B 0

:release
SET BUILD_TYPE=Release
@CALL :all
@EXIT /B 0

:minsizerel
SET BUILD_TYPE=MinSizeRel
@CALL :all
@EXIT /B 0

:relwithdebinfo
SET BUILD_TYPE=RelWithDebInfo
@CALL :all
@EXIT /B 0

:venv_create
%PYTHON_EXE% -m venv %VIRTUAL_ENV%
@EXIT /B 0

:venv_delete
RMDIR /S /Q %VIRTUAL_ENV%
@EXIT /B 0

:venv_activate
CALL %VIRTUAL_ENV%\Scripts\activate
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

:help
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target help %CMAKE_BUILD_ARG%
@EXIT /B 0

:target
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target %CMAKE_BUILD_TARGET% %CMAKE_BUILD_ARG%
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

:run
@CALL :build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target run %CMAKE_BUILD_ARG%
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

:package_file_name
@FOR /F delims^=^"^ tokens^=2 %%I IN ('TYPE %BUILD_TYPE%\CPackConfig.cmake ^| FIND "set(CPACK_PACKAGE_FILE_NAME "') DO @SET PACKAGE_FILE_NAME=%%I
@ECHO %PACKAGE_FILE_NAME%
@EXIT /B 0

:doxygen_bin_path
@CALL :venv_activate
@FOR /F "usebackq" %%I IN (`python -c "lines = [l.strip() for l in list(open('%BUILD_TYPE%/conanbuildinfo.txt'))]; print(lines[lines.index('[bindirs_doxygen]') + 1])"`) DO @SET DOXYGEN_BIN_PATH=%%I
@ECHO %DOXYGEN_BIN_PATH%
@EXIT /B 0
@EXIT /B 0

:doxygen_create_config
@CALL :doxygen_bin_path
%DOXYGEN_BIN_PATH%/doxygen -g
@EXIT /B 0

:doxygen
@CALL :doxygen_bin_path
%DOXYGEN_BIN_PATH%/doxygen
@EXIT /B 0

:doxygen_delete
RMDIR /S /Q docs
@EXIT /B 0

:benchmark_folder
@CALL :venv_activate
@CALL :project_name
IF NOT EXIST tests\benchmarks\%PROJECT_NAME% MKDIR tests\benchmarks\%PROJECT_NAME%
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
@CALL :project_version
conan create . %PROJECT_VERSION%@
@EXIT /B 0

:conan_remove_cache
@CALL :venv_activate
@CALL :project_name
conan remove %PROJECT_NAME%*
@EXIT /B 0

:conan_replace_cache
@CALL :conan_remove_cache
@CALL :conan_package
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

:conan_replace_local
@CALL :conan_remove_local
@CALL :conan_upload_local
@EXIT /B 0

:jenkins_download
%PYTHON_EXE% -c "import os, requests; os.makedirs(os.path.expanduser(r'%JENKINS_HOME%'), mode=0o755, exist_ok=True); open(os.path.join(os.path.expanduser(r'%JENKINS_HOME%'), 'jenkins.war'), 'wb').write(requests.get('https://get.jenkins.io/war-stable/latest/jenkins.war', allow_redirects=True).content)"
@EXIT /B 0

:jenkins_start
java -jar %JENKINS_HOME%/jenkins.war --httpPort=8080
@EXIT /B 0

:echo
@ECHO BUILD_TYPE=%BUILD_TYPE%
@ECHO VIRTUAL_ENV=%VIRTUAL_ENV%
@EXIT /B 0
