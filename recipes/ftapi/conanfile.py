from conans import ConanFile, CMake, tools, MSBuild
import os
import py7zr
import shutil


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

    def source(self):
        file_name = self.conan_data["sources"][self.version]["url"].rsplit("/", 1)[-1]
        folder_name = file_name.rsplit(".", 1)[0]
        tools.download(filename=file_name, overwrite=True, **self.conan_data["sources"][self.version])
        try:
            with py7zr.SevenZipFile(file_name, 'r') as archive:
                archive.extractall()
        except:
            pass
        os.rename(folder_name, "FTAPI")
        shutil.move("FTAPI/FTAPI4CPP/Include", "Include")
        shutil.move("FTAPI/FTAPI4CPP/Src", "Src")
        shutil.move("FTAPI/FTAPI4CPP/Bin", "Bin")
        try:
            os.remove("FTAPI")
        except:
            pass
        try:
            os.remove(file_name)
        except:
            pass

    def build(self):
        if self.settings.os == "Windows":
            with tools.chdir("Src"):
                msbuild = MSBuild(self)
                runtime = "MD" if self.settings.compiler.runtime in ["MD", "MDd"] else "MT"
                build_type = "Debug" if self.settings.build_type == "Debug" else "Release"
                configuration = build_type + "-" + runtime
                msbuild.build("FTAPI.sln", build_type=configuration)

            cmake = CMake(self)
            cmake.definitions["CMAKE_INSTALL_PREFIX"] = "install"
            cmake.definitions["protobuf_BUILD_TESTS"] = "OFF"
            cmake.definitions["protobuf_DEBUG_POSTFIX"] = ""
            if self.settings.compiler.runtime in ["MD", "MDd"]:
                cmake.definitions["protobuf_MSVC_STATIC_RUNTIME"] = "OFF"
            cmake.configure(source_folder="Src/protobuf/cmake", build_folder="protobuf")
            cmake.build()

    def package(self):
        self.copy("*.h", dst="include/%s" % self.name, src="Include", excludes="google")
        self.copy("*.h", dst="include/google", src="Include/google")
        if self.settings.os == "Windows":
            lib_path = "Bin/Windows" + ("-x64/" if self.settings.arch == "x86_64" else "/") + ("Debug" if self.settings.build_type == "Debug" else "Release")
            self.copy("FTAPIChannel.lib", dst="lib", src=lib_path, keep_path=False)
            self.copy("FTAPIChannel.dll", dst="bin", src=lib_path, keep_path=False)
            lib_path += ("/MD" if self.settings.compiler.runtime in ["MD", "MDd"] else "/MT")
            self.copy("FTAPI.lib", dst="lib", src=lib_path, keep_path=False)
            self.copy("*.lib", dst="lib", src="protobuf/%s" % self.settings.build_type, keep_path=False)
        else:
            lib_path = "Bin/Centos7"
            self.copy("*.a", dst="lib", src=lib_path, keep_path=False)
            self.copy("*.so*", dst="lib", src=lib_path, keep_path=False)

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
