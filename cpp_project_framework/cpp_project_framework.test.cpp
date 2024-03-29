/**
 * @file    cpp_project_framework.test.cpp
 * @author  Curtis Lo
 * @brief   This file contains unit test cases for this project
 */

#include "cpp_project_framework.h"

#include "filesystem.h"
#include "gtest.h"
#include "shared_mutex.h"


/// Unit test anonymous namespace
namespace
{

/// Test fixture
class CppProjectFrameworkTest : public testing::Test
{
protected:
    CppProjectFrameworkTest()
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

    ~CppProjectFrameworkTest() override
    {

    }
};

/// Dummy test
TEST_F(CppProjectFrameworkTest, DummyTest)
{
    EXPECT_TRUE(true);
}

 /// Test for GET_TEST_CASE_NAME() macro
TEST(CppProjectFrameworkGoogleTestTest, GetTestCaseName)
{
    EXPECT_STREQ(GET_TEST_CASE_NAME(), "CppProjectFrameworkGoogleTestTest.GetTestCaseName");
}

/// Test for SCOPED_TRACE_CODE_BLOCK() macro
TEST(CppProjectFrameworkGoogleTestTest, ScopedTraceCodeBlock)
{
    SCOPED_TRACE_CODE_BLOCK(EXPECT_STREQ(GET_TEST_CASE_NAME(), "CppProjectFrameworkGoogleTestTest.ScopedTraceCodeBlock"));
}

/// Test for filesystem header
TEST(CppProjectFrameworkFileSystem, FileSystem)
{
    namespace fs = sheepgrass::filesystem;
    EXPECT_TRUE(fs::is_directory(fs::current_path()));
}

/// Test for shared_mutex header
TEST(CppProjectFrameworkSharedMutex, SharedMutex)
{
    sheepgrass::shared_mutex mutex;
    std::shared_lock<sheepgrass::shared_mutex> lock(mutex, std::defer_lock);
    EXPECT_TRUE(lock.try_lock());
}

}
