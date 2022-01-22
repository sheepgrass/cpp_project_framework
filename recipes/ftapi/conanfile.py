from conans import ConanFile, CMake, tools, AutoToolsBuildEnvironment
import os
import py7zr


class FtapiConan(ConanFile):
    name = "ftapi"
    license = "Unknown"
    homepage = "https://openapi.futunn.com/"
    url = "http://localhost:9300/"  # Package recipe repository url here, for issues about the package
    description = "Futu OpenAPI 量化接口，为您的程序化交易，提供丰富的行情和交易接口，满足每一位开发者的量化投资需求，助力您的宽客梦想。"
    topics = ("conan", "futu", "api")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"

    def build(self):
        file_name = self.conan_data["sources"][self.version]["url"].rsplit("/", 1)[-1]
        folder_name = file_name.rsplit(".", 1)[0]
        tools.download(filename=file_name, overwrite=True, **self.conan_data["sources"][self.version])
        try:
            with py7zr.SevenZipFile(file_name, 'r') as archive:
                archive.extractall()
        except:
            pass
        os.rename(folder_name, "FTAPI")

    def package(self):
        self.copy("*.h", dst="include/%s" % self.name, src="FTAPI/FTAPI4CPP/Include", excludes="google")
        self.copy("*.h", dst="include/google", src="FTAPI/FTAPI4CPP/Include/google")
        if self.settings.os == "Windows":
            lib_path = "FTAPI/FTAPI4CPP/Bin/Windows" + ("-x64/" if self.settings.arch == "x86_64" else "/") + ("Debug" if self.settings.build_type == "Debug" else "Release")
            self.copy("FTAPIChannel.lib", dst="lib", src=lib_path, keep_path=False)
            self.copy("FTAPIChannel.dll", dst="bin", src=lib_path, keep_path=False)
            lib_path += ("/MD" if self.settings.compiler.runtime in ["MD", "MDd"] else "/MT")
            self.copy("FTAPI.lib", dst="lib", src=lib_path, keep_path=False)
            self.copy("libprotobuf.lib", dst="lib", src=lib_path, keep_path=False)
        else:
            lib_path = "FTAPI/FTAPI4CPP/Bin/Centos7"
            self.copy("*.a", dst="lib", src=lib_path, keep_path=False)
            self.copy("*.so*", dst="lib", src=lib_path, keep_path=False)

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
