/**
 * @file    cpp_project_framework.test.cpp
 * @author  Curtis Lo
 */

#include "gtest.h"
#include "cpp_project_framework.h"


namespace
{

class CppProjectFrameworkTest : public testing::Test
{
protected:
    CppProjectFrameworkTest()
    {

    }

    void SetUp() override
    {
        
    }

    void TearDown() override
    {
        
    }

    ~CppProjectFrameworkTest() override
    {

    }
};

TEST_F(CppProjectFrameworkTest, DummyTest)
{
    EXPECT_TRUE(true);
}

TEST(CppProjectFrameworkGoogleTestTest, GetTestCaseName)
{
    EXPECT_STREQ(GET_TEST_CASE_NAME(), "CppProjectFrameworkGoogleTestTest.GetTestCaseName");
}

TEST(CppProjectFrameworkGoogleTestTest, ScopedTraceCodeBlock)
{
    SCOPED_TRACE_CODE_BLOCK(EXPECT_STREQ(GET_TEST_CASE_NAME(), "CppProjectFrameworkGoogleTestTest.ScopedTraceCodeBlock"));
}

}
