ifndef BUILD_TYPE
$(error BUILD_TYPE not set)
endif

ifndef PYTHON_EXE
PYTHON_EXE = python3
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

.PHONY: all venv_create venv_activate venv_deactivate conan_install cmake_project build clean clean_and_build cmake_open package delete echo

all: conan_install cmake_project build

venv_create:
	$(PYTHON_EXE) -m venv .venv

venv_activate:
	source .venv/bin/activate

venv_deactivate:
	deactivate

pip_install_conan: venv_activate
	pip install -U conan
	conan

conan_install:
	conan install . -b missing -s build_type=$(BUILD_TYPE) -if $(BUILD_TYPE)

cmake_project:
	cmake -S . -B $(BUILD_TYPE) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) $(CMAKE_PROJECT_ARG)

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

delete:
	rm -rf %BUILD_TYPE%

echo:
	@echo $(BUILD_TYPE)
