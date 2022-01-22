from conans import ConanFile, CMake


class CppProjectFrameworkConan(ConanFile):
    name = "cpp_project_framework"
    version = "1.0"
    license = "GNU Affero General Public License v3.0"
    author = "Curtis Lo"
    homepage = "https://github.com/sheepgrass/cpp_project_framework"
    url = "http://localhost:9300/"  # Package recipe repository url here, for issues about the package
    description = "C++ Project Framework is a framework for creating C++ project."
    topics = ("c++", "project", "framework")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"
    exports_sources = "%s/*" % name, "test_package/*.*"
    build_requires = "gtest/1.10.0"
    exports_resources = ".gitignore", "LICENSE", "conanfile.txt", "CMakeLists.txt", "make.bat", "Makefile", "cpp_project_framework_callables.cmake", "cpp_project_framework.cmake"

    def export_sources(self):
        for resource in self.exports_resources:
            self.copy(resource)

    def build(self):
        cmake = CMake(self)
        self.run("conan install conanfile.txt -b missing -s build_type=%s -if ." % cmake.build_type)
        cmake.configure(source_folder=self.name)
        cmake.build()

        # Explicit way:
        # self.run('cmake %s/cpp_project_framework %s'
        #          % (self.source_folder, cmake.command_line))
        # self.run("cmake --build . %s" % cmake.build_config)

    def package(self):
        self.copy("*.h", dst="include", src=self.name)
        self.copy("*.lib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.dylib*", dst="lib", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)
        for resource in self.exports_resources:
            self.copy(resource, dst="res")

    def package_info(self):
        self.cpp_info.libs = []
