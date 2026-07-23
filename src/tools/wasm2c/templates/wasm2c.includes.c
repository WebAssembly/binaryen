#include <assert.h>
#include <math.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>
#if defined(__MINGW32__)
#include <malloc.h>
#elif defined(_MSC_VER)
#include <intrin.h>
#include <malloc.h>
#define alloca _alloca
#elif defined(__FreeBSD__) || defined(__OpenBSD__)
#include <stdlib.h>
#else
#include <alloca.h>
#endif
