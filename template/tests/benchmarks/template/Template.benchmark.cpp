/**
 * @file   ${project_camel_name}.benchmark.cpp
 * @author ${project_author}
 * @brief  This file contains benchmark test cases for this project
 */

#include "benchmark/benchmark.h"
#include "${project_name}/${project_camel_name}.h"


using namespace ${project_name};

/// Benchmark for ${project_camel_name} constructor
static void ${project_camel_name}ConstructorBenchmark(benchmark::State& state)
{
    for (auto _ : state)
    {
        // construct ${project_camel_name}
        ${project_camel_name} ${project_name};
    }
}
BENCHMARK(${project_camel_name}ConstructorBenchmark);

/// Benchmark main function
BENCHMARK_MAIN();
