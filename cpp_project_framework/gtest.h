/**
 * @file    gtest.h
 * @author  Curtis Lo
 */

#pragma once

#include "gtest/gtest.h"


#define GET_TEST_CASE_NAME() ((test_info_->test_suite_name() + std::string(".") + test_info_->name()).c_str())
#define SCOPED_TRACE_CODE_BLOCK(code) { SCOPED_TRACE(GET_TEST_CASE_NAME()); code; }
