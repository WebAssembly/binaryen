#include <assert.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include <math.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "wasm-rt.h"
#include "wasm-rt-impl.h"
#include "wasm-rt-exceptions.h"

/* NOTE: function argument evaluation order is implementation-defined in C,
   so it SHOULD NOT be relied on by tests. */
#if WABT_BIG_ENDIAN
#define v128_i8x16_make(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) \
	simde_wasm_i8x16_make(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
#define v128_u8x16_make(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) \
	simde_wasm_u8x16_make(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
#define v128_i16x8_make(a,b,c,d,e,f,g,h) simde_wasm_i16x8_make(h,g,f,e,d,c,b,a)
#define v128_u16x8_make(a,b,c,d,e,f,g,h) simde_wasm_u16x8_make(h,g,f,e,d,c,b,a)
#define v128_i32x4_make(a,b,c,d) simde_wasm_i32x4_make(d,c,b,a)
#define v128_u32x4_make(a,b,c,d) simde_wasm_u32x4_make(d,c,b,a)
#define v128_i64x2_make(a,b) simde_wasm_i64x2_make(b,a)
#define v128_u64x2_make(a,b) simde_wasm_u64x2_make(b,a)
#define v128_f32x4_make(a,b,c,d) simde_wasm_f32x4_make(d,c,b,a)
#define v128_f64x2_make(a,b) simde_wasm_f64x2_make(b,a)
#define v128_i8x16_extract_lane(a,n) simde_wasm_u8x16_extract_lane(a,15-(n))
#define v128_u8x16_extract_lane(a,n) simde_wasm_u8x16_extract_lane(a,15-(n))
#define v128_i16x8_extract_lane(a,n) simde_wasm_u16x8_extract_lane(a,7-(n))
#define v128_u16x8_extract_lane(a,n) simde_wasm_u16x8_extract_lane(a,7-(n))
#define v128_i32x4_extract_lane(a,n) simde_wasm_u32x4_extract_lane(a,3-(n))
#define v128_u32x4_extract_lane(a,n) simde_wasm_u32x4_extract_lane(a,3-(n))
#define v128_i64x2_extract_lane(a,n) simde_wasm_u64x2_extract_lane(a,1-(n))
#define v128_u64x2_extract_lane(a,n) simde_wasm_u64x2_extract_lane(a,1-(n))
#define v128_f32x4_extract_lane(a,n) simde_wasm_f32x4_extract_lane(a,3-(n))
#define v128_f64x2_extract_lane(a,n) simde_wasm_f64x2_extract_lane(a,1-(n))
#else
#define v128_i8x16_make simde_wasm_i8x16_make
#define v128_u8x16_make simde_wasm_u8x16_make
#define v128_i16x8_make simde_wasm_i16x8_make
#define v128_u16x8_make simde_wasm_u16x8_make
#define v128_i32x4_make simde_wasm_i32x4_make
#define v128_u32x4_make simde_wasm_u32x4_make
#define v128_i64x2_make simde_wasm_i64x2_make
#define v128_u64x2_make simde_wasm_u64x2_make
#define v128_f32x4_make simde_wasm_f32x4_make
#define v128_f64x2_make simde_wasm_f64x2_make
// like is_equal_TYPE below, always use unsigned for these
#define v128_i8x16_extract_lane simde_wasm_u8x16_extract_lane
#define v128_u8x16_extract_lane simde_wasm_u8x16_extract_lane
#define v128_i16x8_extract_lane simde_wasm_u16x8_extract_lane
#define v128_u16x8_extract_lane simde_wasm_u16x8_extract_lane
#define v128_i32x4_extract_lane simde_wasm_u32x4_extract_lane
#define v128_u32x4_extract_lane simde_wasm_u32x4_extract_lane
#define v128_i64x2_extract_lane simde_wasm_u64x2_extract_lane
#define v128_u64x2_extract_lane simde_wasm_u64x2_extract_lane
#define v128_f32x4_extract_lane simde_wasm_f32x4_extract_lane
#define v128_f64x2_extract_lane simde_wasm_f64x2_extract_lane
#endif

static int g_tests_run;
static int g_tests_passed;

static void run_spec_tests(void);

static void error(const char* file, int line, const char* format, ...) {
  va_list args;
  va_start(args, format);
  fprintf(stderr, "%s:%d: assertion failed: ", file, line);
  vfprintf(stderr, format, args);
  va_end(args);
}

#define ASSERT_EXCEPTION(f)                                               \
  do {                                                                    \
    g_tests_run++;                                                        \
    if (wasm_rt_impl_try() == WASM_RT_TRAP_UNCAUGHT_EXCEPTION) {          \
      g_tests_passed++;                                                   \
    } else {                                                              \
      (void)(f);                                                          \
      error(__FILE__, __LINE__, "expected " #f " to throw exception.\n"); \
    }                                                                     \
  } while (0)

#define ASSERT_TRAP(f)                                         \
  do {                                                         \
    g_tests_run++;                                             \
    if (wasm_rt_impl_try() != 0) {                             \
      g_tests_passed++;                                        \
    } else {                                                   \
      (void)(f);                                               \
      error(__FILE__, __LINE__, "expected " #f " to trap.\n"); \
    }                                                          \
  } while (0)

#define ASSERT_EXHAUSTION(f)                                     \
  do {                                                           \
    g_tests_run++;                                               \
    wasm_rt_trap_t code = wasm_rt_impl_try();                    \
    switch (code) {                                              \
      case WASM_RT_TRAP_NONE:                                    \
        (void)(f);                                               \
        error(__FILE__, __LINE__, "expected " #f " to trap.\n"); \
        break;                                                   \
      case WASM_RT_TRAP_EXHAUSTION:                              \
        g_tests_passed++;                                        \
        break;                                                   \
      default:                                                   \
        error(__FILE__, __LINE__,                                \
              "expected " #f                                     \
              " to trap due to exhaustion, got trap code %d.\n", \
              code);                                             \
        break;                                                   \
    }                                                            \
  } while (0)

#define ASSERT_RETURN(f)                               \
  do {                                                 \
    g_tests_run++;                                     \
    int trap_code = wasm_rt_impl_try();                \
    if (trap_code) {                                   \
      error(__FILE__, __LINE__, #f " trapped (%s).\n", \
            wasm_rt_strerror(trap_code));              \
    } else {                                           \
      f;                                               \
      g_tests_passed++;                                \
    }                                                  \
  } while (0)

#define ASSERT_RETURN_T(type, fmt, f, expected)                          \
  do {                                                                   \
    g_tests_run++;                                                       \
    int trap_code = wasm_rt_impl_try();                                  \
    if (trap_code) {                                                     \
      error(__FILE__, __LINE__, #f " trapped (%s).\n",                   \
            wasm_rt_strerror(trap_code));                                \
    } else {                                                             \
      type actual = f;                                                   \
      if (is_equal_##type(actual, expected)) {                           \
        g_tests_passed++;                                                \
      } else {                                                           \
        error(__FILE__, __LINE__,                                        \
              "in " #f ": expected %" fmt ", got %" fmt ".\n", expected, \
              actual);                                                   \
      }                                                                  \
    }                                                                    \
  } while (0)

#define ASSERT_RETURN_FUNCREF(f, expected)                                \
  do {                                                                    \
    g_tests_run++;                                                        \
    int trap_code = wasm_rt_impl_try();                                   \
    if (trap_code) {                                                      \
      error(__FILE__, __LINE__, #f " trapped (%s).\n",                    \
            wasm_rt_strerror(trap_code));                                 \
    } else {                                                              \
      wasm_rt_funcref_t actual = f;                                       \
      if (is_equal_wasm_rt_funcref_t(actual, expected)) {                 \
        g_tests_passed++;                                                 \
      } else {                                                            \
        error(__FILE__, __LINE__,                                         \
              "in " #f ": mismatch between expected and actual funcref"); \
      }                                                                   \
    }                                                                     \
  } while (0)

#define ASSERT_RETURN_EXNREF(f, expected)                                \
  do {                                                                   \
    g_tests_run++;                                                       \
    int trap_code = wasm_rt_impl_try();                                  \
    if (trap_code) {                                                     \
      error(__FILE__, __LINE__, #f " trapped (%s).\n",                   \
            wasm_rt_strerror(trap_code));                                \
    } else {                                                             \
      wasm_rt_exnref_t actual = f;                                       \
      if (is_equal_wasm_rt_exnref_t(actual, expected)) {                 \
        g_tests_passed++;                                                \
      } else {                                                           \
        error(__FILE__, __LINE__,                                        \
              "in " #f ": mismatch between expected and actual exnref"); \
      }                                                                  \
    }                                                                    \
  } while (0)

#define ASSERT_RETURN_NAN_T(type, itype, fmt, f, kind)                        \
  do {                                                                        \
    g_tests_run++;                                                            \
    int trap_code = wasm_rt_impl_try();                                       \
    if (trap_code) {                                                          \
      error(__FILE__, __LINE__, #f " trapped (%s).\n",                        \
            wasm_rt_strerror(trap_code));                                     \
    } else {                                                                  \
      type actual = f;                                                        \
      itype iactual;                                                          \
      memcpy(&iactual, &actual, sizeof(iactual));                             \
      if (is_##kind##_nan_##type(iactual)) {                                  \
        g_tests_passed++;                                                     \
      } else {                                                                \
        error(__FILE__, __LINE__,                                             \
              "in " #f ": expected result to be a " #kind " nan, got 0x%" fmt \
              ".\n",                                                          \
              iactual);                                                       \
      }                                                                       \
    }                                                                         \
  } while (0)

#define MULTI_T_UNPACK_(...) __VA_ARGS__
#define MULTI_T_UNPACK(arg) MULTI_T_UNPACK_ arg
#define MULTI_i8 "%" PRIu8 " "
#define MULTI_i16 "%" PRIu16 " "
#define MULTI_i32 "%u "
#define MULTI_i64 "%" PRIu64 " "
#define MULTI_f32 "%.9g "
#define MULTI_f64 "%.17g "
#define MULTI_str "%s "
#define ASSERT_RETURN_MULTI_T(type, fmt_expected, fmt_got, f, compare,        \
                              expected, found)                                \
  do {                                                                        \
    g_tests_run++;                                                            \
    int trap_code = wasm_rt_impl_try();                                       \
    if (trap_code) {                                                          \
      error(__FILE__, __LINE__, #f " trapped (%s).\n",                        \
            wasm_rt_strerror(trap_code));                                     \
    } else {                                                                  \
      type actual = f;                                                        \
      if (compare) {                                                          \
        g_tests_passed++;                                                     \
      } else {                                                                \
        error(__FILE__, __LINE__,                                             \
              "in " #f ": expected <" fmt_expected ">, got <" fmt_got ">.\n", \
              MULTI_T_UNPACK(expected), MULTI_T_UNPACK(found));               \
      }                                                                       \
    }                                                                         \
  } while (0)


#define ASSERT_RETURN_I32(f, expected) ASSERT_RETURN_T(u32, "u", f, expected)
#define ASSERT_RETURN_I64(f, expected) ASSERT_RETURN_T(u64, PRIu64, f, expected)
#define ASSERT_RETURN_F32(f, expected) ASSERT_RETURN_T(f32, ".9g", f, expected)
#define ASSERT_RETURN_F64(f, expected) ASSERT_RETURN_T(f64, ".17g", f, expected)
#define ASSERT_RETURN_EXTERNREF(f, expected) \
  ASSERT_RETURN_T(wasm_rt_externref_t, "p", f, expected);

#define ASSERT_RETURN_CANONICAL_NAN_F32(f) \
  ASSERT_RETURN_NAN_T(f32, u32, "08x", f, canonical)
#define ASSERT_RETURN_CANONICAL_NAN_F64(f) \
  ASSERT_RETURN_NAN_T(f64, u64, "016x", f, canonical)
#define ASSERT_RETURN_ARITHMETIC_NAN_F32(f) \
  ASSERT_RETURN_NAN_T(f32, u32, "08x", f, arithmetic)
#define ASSERT_RETURN_ARITHMETIC_NAN_F64(f) \
  ASSERT_RETURN_NAN_T(f64, u64, "016x", f, arithmetic)

static bool is_equal_u8(u8 x, u8 y) {
  return x == y;
}

static bool is_equal_u16(u16 x, u16 y) {
  return x == y;
}

static bool is_equal_u32(u32 x, u32 y) {
  return x == y;
}

static bool is_equal_u64(u64 x, u64 y) {
  return x == y;
}

#define is_equal_i8 is_equal_u8
#define is_equal_i16 is_equal_u16
#define is_equal_i32 is_equal_u32
#define is_equal_i64 is_equal_u64

static bool is_equal_wasm_rt_externref_t(wasm_rt_externref_t x,
                                         wasm_rt_externref_t y) {
  return x == y;
}

static inline bool is_equal_wasm_rt_func_type_t(const wasm_rt_func_type_t a,
                                                const wasm_rt_func_type_t b) {
  return (a == b) || (a && b && !memcmp(a, b, 32));
}

static bool is_equal_wasm_rt_funcref_t(wasm_rt_funcref_t x,
                                       wasm_rt_funcref_t y) {
  return is_equal_wasm_rt_func_type_t(x.func_type, y.func_type) &&
         (x.func == y.func) && (x.module_instance == y.module_instance);
}

#ifdef WASM_EXN_MAX_SIZE
static bool is_equal_wasm_rt_exnref_t(wasm_rt_exnref_t x, wasm_rt_exnref_t y) {
  return x.tag == y.tag && x.size == y.size && !memcmp(x.data, y.data, x.size);
}
#endif

wasm_rt_externref_t spectest_make_externref(uintptr_t x) {
  return (wasm_rt_externref_t)(x + 1);  // externref(0) is not null
}

static u32 f32_bits(f32 x) {
  u32 ux;
  memcpy(&ux, &x, sizeof(ux));
  return ux;
}

static u64 f64_bits(f64 x) {
  u64 ux;
  memcpy(&ux, &x, sizeof(ux));
  return ux;
}

static bool is_equal_f32(f32 x, f32 y) {
  return f32_bits(x) == f32_bits(y);
}

static bool is_equal_f64(f64 x, f64 y) {
  return f64_bits(x) == f64_bits(y);
}

static f32 make_nan_f32(u32 x) {
  x |= 0x7f800000;
  f32 res;
  memcpy(&res, &x, sizeof(res));
  return res;
}

static f64 make_nan_f64(u64 x) {
  x |= 0x7ff0000000000000;
  f64 res;
  memcpy(&res, &x, sizeof(res));
  return res;
}

static bool is_canonical_nan_f32(u32 x) {
  return (x & 0x7fffffff) == 0x7fc00000;
}

static bool is_canonical_nan_f64(u64 x) {
  return (x & 0x7fffffffffffffff) == 0x7ff8000000000000;
}

static bool is_arithmetic_nan_f32(u32 x) {
  return (x & 0x7fc00000) == 0x7fc00000;
}

static bool is_arithmetic_nan_f64(u64 x) {
  return (x & 0x7ff8000000000000) == 0x7ff8000000000000;
}

typedef struct w2c_spectest {
  wasm_rt_funcref_table_t spectest_table;
  wasm_rt_funcref_table_t spectest_table64;
  wasm_rt_memory_t spectest_memory;
  uint32_t spectest_global_i32;
  uint64_t spectest_global_i64;
  float spectest_global_f32;
  double spectest_global_f64;
} w2c_spectest;

static w2c_spectest spectest_instance;

/*
 * spectest implementations
 */
void w2c_spectest_print(w2c_spectest* instance) {
  printf("spectest.print()\n");
}

void w2c_spectest_print_i32(w2c_spectest* instance, uint32_t i) {
  printf("spectest.print_i32(%d)\n", i);
}

void w2c_spectest_print_i64(w2c_spectest* instance, uint64_t i) {
  printf("spectest.print_i64(%" PRIu64 ")\n", i);
}

void w2c_spectest_print_f32(w2c_spectest* instance, float f) {
  printf("spectest.print_f32(%g)\n", f);
}

void w2c_spectest_print_i32_f32(w2c_spectest* instance, uint32_t i, float f) {
  printf("spectest.print_i32_f32(%d %g)\n", i, f);
}

void w2c_spectest_print_f64(w2c_spectest* instance, double d) {
  printf("spectest.print_f64(%g)\n", d);
}

void w2c_spectest_print_f64_f64(w2c_spectest* instance, double d1, double d2) {
  printf("spectest.print_f64_f64(%g %g)\n", d1, d2);
}

wasm_rt_funcref_table_t* w2c_spectest_table(w2c_spectest* instance) {
  return &instance->spectest_table;
}

wasm_rt_funcref_table_t* w2c_spectest_table64(w2c_spectest* instance) {
  return &instance->spectest_table64;
}

wasm_rt_memory_t* w2c_spectest_memory(w2c_spectest* instance) {
  return &instance->spectest_memory;
}

uint32_t* w2c_spectest_global_i32(w2c_spectest* instance) {
  return &instance->spectest_global_i32;
}

uint64_t* w2c_spectest_global_i64(w2c_spectest* instance) {
  return &instance->spectest_global_i64;
}

float* w2c_spectest_global_f32(w2c_spectest* instance) {
  return &instance->spectest_global_f32;
}

double* w2c_spectest_global_f64(w2c_spectest* instance) {
  return &instance->spectest_global_f64;
}

static void init_spectest_module(w2c_spectest* instance) {
  instance->spectest_global_i32 = 666;
  instance->spectest_global_i64 = 666l;
  instance->spectest_global_f32 = 666.6;
  instance->spectest_global_f64 = 666.6;
  wasm_rt_allocate_memory(&instance->spectest_memory, 1, 2, false,
                          WASM_DEFAULT_PAGE_SIZE);
  wasm_rt_allocate_funcref_table(&instance->spectest_table, 10, 20);
  wasm_rt_allocate_funcref_table(&instance->spectest_table64, 10, 20);
}

// POSIX-only test config where embedder handles signals instead of w2c runtime
#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
#include <signal.h>

static void posix_signal_handler(int sig, siginfo_t* si, void* unused) {
  wasm_rt_trap((si->si_code == SEGV_ACCERR) ? WASM_RT_TRAP_OOB
                                            : WASM_RT_TRAP_EXHAUSTION);
}

static void posix_install_signal_handler(void) {
  /* install altstack */
  stack_t ss;
  ss.ss_sp = malloc(SIGSTKSZ);
  ss.ss_flags = 0;
  ss.ss_size = SIGSTKSZ;
  if (sigaltstack(&ss, NULL) != 0) {
    perror("sigaltstack failed");
    abort();
  }

  /* install signal handler */
  struct sigaction sa;
  memset(&sa, '\0', sizeof(sa));
  sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
  sigemptyset(&sa.sa_mask);
  sa.sa_sigaction = posix_signal_handler;
  if (sigaction(SIGSEGV, &sa, NULL) != 0 || sigaction(SIGBUS, &sa, NULL) != 0) {
    perror("sigaction failed");
    abort();
  }
}

static void posix_cleanup_signal_handler(void) {
  /* remove signal handler */
  struct sigaction sa;
  memset(&sa, '\0', sizeof(sa));
  sa.sa_handler = SIG_DFL;
  if (sigaction(SIGSEGV, &sa, NULL) != 0 || sigaction(SIGBUS, &sa, NULL)) {
    perror("sigaction failed");
    abort();
  }

  /* disable and free altstack */
  stack_t ss;
  ss.ss_flags = SS_DISABLE;
  if (sigaltstack(&ss, NULL) != 0) {
    perror("sigaltstack failed");
    abort();
  }
  free(ss.ss_sp);
}
#endif

int main(int argc, char** argv) {
#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
  posix_install_signal_handler();
#endif
  wasm_rt_init();
  init_spectest_module(&spectest_instance);
  run_spec_tests();
  printf("%u/%u tests passed.\n", g_tests_passed, g_tests_run);
  wasm_rt_free();
#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
  posix_cleanup_signal_handler();
#endif
  return g_tests_passed != g_tests_run;
}
