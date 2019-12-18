
// This is all terrible

#ifndef _WIN32
#define LLVM_ON_UNIX
#endif

// Use simple std:: based atomics, no windows specifics
#define LLVM_THREADING_USE_STD_CALL_ONCE 1
