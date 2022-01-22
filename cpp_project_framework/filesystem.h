/**
 * @file    filesystem.h
 * @author  Curtis Lo
 * @brief   This file chooses the header and namespace for filesystem according to the supported C++ standard
 */

#pragma once

#if __cplusplus >= 201703L  // C++17 or above
#include <filesystem>
#else
#include <experimental/filesystem>
#endif


/// Top level namespace for all projects
namespace sheepgrass
{

#if __cplusplus >= 201703L  // C++17 or above
namespace filesystem = std::filesystem;
#else
namespace filesystem = std::experimental::filesystem;
#endif

} // namespace sheepgrass
