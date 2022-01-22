#include "ta-lib/ta_libc.h"

int main()
{
    if (TA_Initialize() == TA_SUCCESS)
    {
        TA_Shutdown();
    }
    return 0;
}
