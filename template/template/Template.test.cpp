/**
 * @file   ${project_camel_name}.test.cpp
 * @author ${project_author}
 * @brief  This file contains unit test cases for this project
 */

#include "cpp_project_framework/gtest.h"
#include "${project_camel_name}.h"


/// Unit test anonymous namespace
namespace
{

using namespace ${project_name};

/// Test fixture
class ${project_camel_name}Test : public testing::Test
{
protected:
    ${project_camel_name} ${project_name}; ///< ${project_camel_name} instance to be tested

protected:
    ${project_camel_name}Test()
    {

    }

    /// Execute before each test case
    void SetUp() override
    {

    }

    /// Execute after each test case
    void TearDown() override
    {

    }

    ~${project_camel_name}Test() override
    {

    }
};

/// Test for ${project_camel_name} constructor
TEST_F(${project_camel_name}Test, Constructor)
{

}

}
