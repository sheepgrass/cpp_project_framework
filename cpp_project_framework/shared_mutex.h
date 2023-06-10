/**
 * @file    shared_mutex.h
 * @author  Curtis Lo
 * @brief   This file chooses suitable alternatives for shared_mutex for C++ standard before C++17
 */

#pragma once

#include <mutex>
#if __cplusplus >= 201402L // C++14 or above
#include <shared_mutex>
#endif


/// Top level namespace for all projects
namespace sheepgrass
{

#if __cplusplus >= 201703L // C++17 or above
using shared_mutex = std::shared_mutex;
template <class Mutex>
using shared_lock = std::shared_lock<Mutex>;
#elif __cplusplus >= 201402L // C++14 or above
using shared_mutex = std::shared_timed_mutex;
template <class Mutex>
using shared_lock = std::shared_lock<Mutex>;
#else
using shared_mutex = std::mutex;
template <class Mutex>
using shared_lock = std::unique_lock<Mutex>;
#endif

} // namespace sheepgrass
