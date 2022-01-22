from conans import ConanFile, CMake, tools, AutoToolsBuildEnvironment


class TaLibConan(ConanFile):
    name = "ta-lib"
    license = "TA-Lib BSD License"
    homepage = "https://sourceforge.net/projects/ta-lib/"
    url = "http://localhost:9300/"  # Package recipe repository url here, for issues about the package
    description = "Technical analysis library with indicators like ADX, MACD, RSI, Stochastic, TRIX..."
    topics = ("conan", "technical analysis", "indicator")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"

    def source(self):
        if self.settings.os == "Windows":
            tools.get(**self.conan_data["sources"][self.version]["msvc"])
        else:
            tools.get(**self.conan_data["sources"][self.version]["src"])

    def build(self):
        if self.settings.os != "Windows":
            with tools.chdir("ta-lib"):
                autotools = AutoToolsBuildEnvironment(self)
                autotools.configure()
                autotools.make(args=["-j1"])

    def package(self):
        if self.settings.os == "Windows":
            self.copy("LICENSE*", dst="licenses", src="ta-lib")
            self.copy("*.h", dst="include/%s" % self.name, src="ta-lib/c/include")
            self.copy("*.lib", dst="lib", src="ta-lib/c/lib", keep_path=False)
        else:
            self.copy("*.h", dst="include/%s" % self.name, src="ta-lib/include")
            self.copy("*.so*", dst="lib", src="ta-lib/src/.libs", keep_path=False)
            self.copy("*.", dst="lib", src="ta-lib/src/.libs", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
