/**
 * @file    cpp_project_framework.test.cpp
 * @author  Curtis Lo
 */

#include "gtest/gtest.h"
#include "cpp_project_framework.h"


namespace
{

class IDGeneratorTest : public testing::Test
{
protected:
    IDGeneratorTest()
    {

    }

    void SetUp() override
    {
        
    }

    void TearDown() override
    {
        
    }

    ~IDGeneratorTest() override
    {

    }
};

TEST_F(IDGeneratorTest, Constructor)
{
    EXPECT_TRUE(true);
}

}
