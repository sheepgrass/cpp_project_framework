ifndef BUILD_TYPE
  NO_BUILD_TYPE_TARGETS = \
    debug release minsizerel relwithdebinfo \
    venv_create venv_delete venv_activate venv_deactivate \
    pip_install_conan conan_list \
    doxygen_delete \
    conan_start_local conan_add_local \
    gcc_list_include_paths gcc_list_lib_paths \
    jenkins_download jenkins_start jenkins_start_no_csp \
    echo
  ifeq ($(filter $(MAKECMDGOALS),$(NO_BUILD_TYPE_TARGETS)),)
    $(error BUILD_TYPE not set, MAKEFLAGS="$(MAKEFLAGS)", MAKECMDGOALS="$(MAKECMDGOALS)", NO_BUILD_TYPE_TARGETS="$(NO_BUILD_TYPE_TARGETS)")
  endif
endif

SHELL = bash

ifndef PYTHON_EXE
  PYTHON_EXE = python3
endif

ifndef VIRTUAL_ENV
  VIRTUAL_ENV = .venv
endif

ifndef JENKINS_HOME
  JENKINS_HOME = ~/.jenkins
endif

CMAKE_PROJECT_ARG =
ifdef BUILD_SYSTEM
  CMAKE_PROJECT_ARG += -G "$(BUILD_SYSTEM)"
endif
ifdef TARGET_PLATFORM
  CMAKE_PROJECT_ARG += -A $(TARGET_PLATFORM)
endif

CMAKE_BUILD_ARG =
ifdef JOBS
  CMAKE_BUILD_ARG += -j$(JOBS)
else
  CMAKE_BUILD_ARG += -j4
endif

CPACK_ARG =
ifdef PACK_FORMAT
  CPACK_ARG += -G $(PACK_FORMAT)
endif

.PHONY: all \
	debug release minsizerel relwithdebinfo \
	venv_create venv_delete venv_activate venv_deactivate \
	pip_install_conan conan_list conan_install \
	cmake_project help target build clean clean_and_build cmake_open package run test coverage delete \
	project_name project_version doxygen_bin_path doxygen_create_config doxygen doxygen_delete benchmark_folder \
	recipe_create conan_package_test conan_package conan_remove_cache conan_replace_cache \
	conan_start_local conan_add_local conan_upload_local_test conan_upload_local conan_remove_local conan_replace_local \
	echo

all: conan_install cmake_project build

debug:
	BUILD_TYPE=Debug make $(MAKEFLAGS)

release:
	BUILD_TYPE=Release make $(MAKEFLAGS)

minsizerel:
	export BUILD_TYPE=MinSizeRel make $(MAKEFLAGS)

relwithdebinfo:
	export BUILD_TYPE=RelWithDebInfo make $(MAKEFLAGS)

venv_create:
	$(PYTHON_EXE) -m venv $(VIRTUAL_ENV)

venv_delete:
	rm -rf $(VIRTUAL_ENV)

venv_activate:
	source $(VIRTUAL_ENV)/bin/activate

venv_deactivate:
	deactivate

pip_install_conan:
	source $(VIRTUAL_ENV)/bin/activate && \
	pip install -U conan && \
	conan

conan_list:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan remote list

conan_install:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan install conanfile.txt -b missing -s build_type=$(BUILD_TYPE) -if $(BUILD_TYPE)

cmake_project:
	cmake -S . -B $(BUILD_TYPE) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) $(CMAKE_PROJECT_ARG)

help:
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --target help $(CMAKE_BUILD_ARG)

target:
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --target ${CMAKE_BUILD_TARGET} $(CMAKE_BUILD_ARG)

build:
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) $(CMAKE_BUILD_ARG)

clean:
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --target clean $(CMAKE_BUILD_ARG)

clean_and_build:
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --clean-first $(CMAKE_BUILD_ARG)

cmake_open:
	cmake --open $(BUILD_TYPE)

package: build
	cd $(BUILD_TYPE) && cpack -C $(BUILD_TYPE) $(CPACK_ARG)

run: build
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --target run $(CMAKE_BUILD_ARG)

test: build
	cd $(BUILD_TYPE) && ctest -C $(BUILD_TYPE)

coverage: build
	cmake --build $(BUILD_TYPE) --config $(BUILD_TYPE) --target coverage $(CMAKE_BUILD_ARG)

delete:
	rm -rf $(BUILD_TYPE)

project_name:
	@cat $(BUILD_TYPE)/CMakeCache.txt | grep "CMAKE_PROJECT_NAME:STATIC=" | cut -d'=' -f2

project_version:
	@cat $(BUILD_TYPE)/CMakeCache.txt | grep "CMAKE_PROJECT_VERSION:STATIC=" | cut -d'=' -f2

package_file_name:
	@cat $(BUILD_TYPE)/CPackConfig.cmake | grep "^set(CPACK_PACKAGE_FILE_NAME " | cut -d'"' -f2

doxygen_bin_path:
	@source $(VIRTUAL_ENV)/bin/activate && \
	python -c "lines = [l.strip() for l in list(open('$(BUILD_TYPE)/conanbuildinfo.txt'))]; print(lines[lines.index('[bindirs_doxygen]') + 1])"

doxygen_create_config:
	`make -s doxygen_bin_path`/doxygen -g

doxygen:
	`make -s doxygen_bin_path`/doxygen

doxygen_delete:
	rm -rf docs

benchmark_folder:
	source $(VIRTUAL_ENV)/bin/activate && \
	mkdir -p tests/benchmarks/`make -s project_name`

recipe_create:
	source $(VIRTUAL_ENV)/bin/activate && \
	mkdir -p package && cd package && \
	conan new `make -s project_name`/`make -s project_version` -t

conan_package_test:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan create . demo/testing

conan_package:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan create . `make -s project_version`@

conan_remove_cache:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan remove "`make -s project_name`*"

conan_replace_cache: conan_remove_cache conan_package

conan_start_local:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan_server

conan_add_local:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan remote add local http://localhost:9300/

conan_upload_local_test:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan upload `make -s project_name`/`make -s project_version`@demo/testing --all -r=local

conan_upload_local:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan upload `make -s project_name`/`make -s project_version` --all -r=local

conan_remove_local:
	source $(VIRTUAL_ENV)/bin/activate && \
	conan remove "`make -s project_name`*" -r local

conan_replace_local: conan_remove_local conan_upload_local

gcc_list_include_paths:
	@echo | gcc -xc++ -E -Wp,-v - 2>&1 | grep '^[[:space:]]*/' | sed 's/^[[:space:]]*//'

gcc_list_lib_paths:
	@gcc -print-search-dirs | sed '/^lib/b 1;d;:1;s,/[^/.][^/]*/\.\./,/,;t 1;s,:[^=]*=,:;,;s,;,;  ,g' | tr \; \\012 | tr : \\012 | grep '^[[:space:]]*/' | sed 's/^[[:space:]]*//'

jenkins_download:
	$(PYTHON_EXE) -c "import os, requests; os.makedirs(os.path.expanduser(r'$(JENKINS_HOME)'), mode=0o755, exist_ok=True); open(os.path.join(os.path.expanduser(r'$(JENKINS_HOME)'), 'jenkins.war'), 'wb').write(requests.get('https://get.jenkins.io/war-stable/latest/jenkins.war', allow_redirects=True).content)"

jenkins_start:
	java -jar $(JENKINS_HOME)/jenkins.war --httpPort=8080

jenkins_start_no_csp:
	java -Dhudson.model.DirectoryBrowserSupport.CSP= -jar $(JENKINS_HOME)/jenkins.war --httpPort=8080

echo:
	@echo -e BUILD_TYPE=$(BUILD_TYPE)\\nVIRTUAL_ENV=$(VIRTUAL_ENV)
