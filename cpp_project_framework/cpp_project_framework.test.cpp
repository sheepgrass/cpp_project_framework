/**
 * @file    cpp_project_framework.test.cpp
 * @author  Curtis Lo
 */

#include "gtest/gtest.h"
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

}
