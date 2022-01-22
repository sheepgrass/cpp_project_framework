from conans import ConanFile, CMake, tools, AutoToolsBuildEnvironment


class SpapiConan(ConanFile):
    name = "spapi"
    license = "Unknown"
    homepage = "http://sharppoint.com.hk/algo.php?mod=api"
    url = "http://localhost:9300/"  # Package recipe repository url here, for issues about the package
    description = "SP Native API is based on the C++ class library interface provided by the expansion of library related transactions and is directly connected to the server of the broker, including order handling, prices subscription, account information inquiry, etc."
    topics = ("conan", "sp", "sharp point", "api")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"

    def build(self):
        if self.settings.os == "Windows":
            if self.settings.arch == "x86":
                tools.get(**self.conan_data["sources"][self.version]["win32"])
            else:
                tools.get(**self.conan_data["sources"][self.version]["win64"])
        else:
            tools.get(**self.conan_data["sources"][self.version]["linux"])

    def package(self):
        if self.settings.os == "Windows":
            self.copy("*.h", dst="include/%s" % self.name)
            self.copy("*.lib", dst="lib", keep_path=False)
            self.copy("*.dll", dst="bin", keep_path=False)
        else:
            self.copy("*.h", dst="include/%s" % self.name, src="include")
            self.copy("*.so*", dst="lib", src="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
