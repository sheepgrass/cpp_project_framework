/**
 * @file    gtest.h
 * @author  Curtis Lo
 * @brief   This file contains helper macros for gtest
 */

#pragma once

#include "gtest/gtest.h"


/// Get the test case name of current test case
#define GET_TEST_CASE_NAME() ((test_info_->test_suite_name() + std::string(".") + test_info_->name()).c_str())

/// Execute the code block with scoped trace
/// @param code code to be executed with scoped trace
#define SCOPED_TRACE_CODE_BLOCK(code) { SCOPED_TRACE(GET_TEST_CASE_NAME()); code; }
