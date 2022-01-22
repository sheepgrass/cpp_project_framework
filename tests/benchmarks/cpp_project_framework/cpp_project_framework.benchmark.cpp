/**
 * @file    cpp_project_framework.benchmark.cpp
 * @author  Curtis Lo
 * @brief   This file contains benchmark test cases for this project
 */

#include "benchmark/benchmark.h"
#include "cpp_project_framework/cpp_project_framework.h"


/// Dummy benchmark
static void DummyBenchmark(benchmark::State& state)
{
    for (auto _ : state)
    {
        // do nothing
    }
}
BENCHMARK(DummyBenchmark);

/// Benchmark main function
BENCHMARK_MAIN();
