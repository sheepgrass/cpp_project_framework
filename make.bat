@ECHO OFF

IF "%BUILD_TYPE%"=="" (
    ECHO BUILD_TYPE not set
    EXIT /B 1
)

SET CMAKE_PROJECT_ARG=
IF NOT "%BUILD_SYSTEM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -G "%BUILD_SYSTEM%"
IF NOT "%TARGET_PLATFORM%"=="" SET CMAKE_PROJECT_ARG=%CMAKE_PROJECT_ARG% -A "%TARGET_PLATFORM%"

SET CMAKE_BUILD_ARG=
if NOT "%JOBS%"=="" SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j%JOBS% ELSE SET CMAKE_BUILD_ARG=%CMAKE_BUILD_ARG% -j4

SET CPACK_ARG=
IF NOT "%PACK_FORMAT%"=="" SET CPACK_ARG=%CPACK_ARG% -G %PACK_FORMAT%

SET TARGET=%1
@ECHO ON
@CALL :%TARGET%
@ECHO OFF
EXIT /B %ERRORLEVEL%

:venv_create
%LOCALAPPDATA%\Continuum\anaconda3\python.exe -m venv .venv
EXIT /B 0

:venv_activate
CALL .venv\Scripts\activate
@ECHO ON
EXIT /B 0

:venv_deactivate
CALL deactivate
EXIT /B 0

:pip_install_conan
CALL :venv_activate
pip install -U conan
conan
EXIT /B 0

:conan_install
CALL :venv_activate
conan install . -b missing -s build_type=%BUILD_TYPE% -if %BUILD_TYPE%
EXIT /B 0

:cmake_project
cmake -S . -B %BUILD_TYPE% -DCMAKE_BUILD_TYPE=%BUILD_TYPE% %CMAKE_PROJECT_ARG%
EXIT /B 0

:build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% %CMAKE_BUILD_ARG%
EXIT /B 0

:clean
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --target clean %CMAKE_BUILD_ARG%
EXIT /B 0

:clean_and_build
cmake --build %BUILD_TYPE% --config %BUILD_TYPE% --clean-first %CMAKE_BUILD_ARG%
EXIT /B 0

:package
CALL :build
cd %BUILD_TYPE% && cpack -C %BUILD_TYPE% %CPACK_ARG%
EXIT /B 0

:echo
ECHO %BUILD_TYPE%
EXIT /B 0
