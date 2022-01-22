#ifdef WIN32
#include "spapi/spapidll.h"
#else
#ifdef __linux__
#define __LINUX__ __linux__
#endif
#include "spapi/ApiProxyWrapper.h"
#endif

int main()
{
    return 0;
}
