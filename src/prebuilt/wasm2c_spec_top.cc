const char* s_spec_top = R"w2c_template(#include <assert.h>
)w2c_template"
R"w2c_template(#define __STDC_FORMAT_MACROS
)w2c_template"
R"w2c_template(#include <inttypes.h>
)w2c_template"
R"w2c_template(#include <math.h>
)w2c_template"
R"w2c_template(#include <stdarg.h>
)w2c_template"
R"w2c_template(#include <stdbool.h>
)w2c_template"
R"w2c_template(#include <stdint.h>
)w2c_template"
R"w2c_template(#include <stdio.h>
)w2c_template"
R"w2c_template(#include <stdlib.h>
)w2c_template"
R"w2c_template(#include <string.h>
)w2c_template"
R"w2c_template(
#include "wasm-rt.h"
)w2c_template"
R"w2c_template(#include "wasm-rt-impl.h"
)w2c_template"
R"w2c_template(#include "wasm-rt-exceptions.h"
)w2c_template"
R"w2c_template(
/* NOTE: function argument evaluation order is implementation-defined in C,
)w2c_template"
R"w2c_template(   so it SHOULD NOT be relied on by tests. */
)w2c_template"
R"w2c_template(#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(#define v128_i8x16_make(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) \
)w2c_template"
R"w2c_template(	simde_wasm_i8x16_make(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_u8x16_make(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) \
)w2c_template"
R"w2c_template(	simde_wasm_u8x16_make(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_i16x8_make(a,b,c,d,e,f,g,h) simde_wasm_i16x8_make(h,g,f,e,d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_u16x8_make(a,b,c,d,e,f,g,h) simde_wasm_u16x8_make(h,g,f,e,d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_i32x4_make(a,b,c,d) simde_wasm_i32x4_make(d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_u32x4_make(a,b,c,d) simde_wasm_u32x4_make(d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_i64x2_make(a,b) simde_wasm_i64x2_make(b,a)
)w2c_template"
R"w2c_template(#define v128_u64x2_make(a,b) simde_wasm_u64x2_make(b,a)
)w2c_template"
R"w2c_template(#define v128_f32x4_make(a,b,c,d) simde_wasm_f32x4_make(d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_f64x2_make(a,b) simde_wasm_f64x2_make(b,a)
)w2c_template"
R"w2c_template(#define v128_i8x16_extract_lane(a,n) simde_wasm_u8x16_extract_lane(a,15-(n))
)w2c_template"
R"w2c_template(#define v128_u8x16_extract_lane(a,n) simde_wasm_u8x16_extract_lane(a,15-(n))
)w2c_template"
R"w2c_template(#define v128_i16x8_extract_lane(a,n) simde_wasm_u16x8_extract_lane(a,7-(n))
)w2c_template"
R"w2c_template(#define v128_u16x8_extract_lane(a,n) simde_wasm_u16x8_extract_lane(a,7-(n))
)w2c_template"
R"w2c_template(#define v128_i32x4_extract_lane(a,n) simde_wasm_u32x4_extract_lane(a,3-(n))
)w2c_template"
R"w2c_template(#define v128_u32x4_extract_lane(a,n) simde_wasm_u32x4_extract_lane(a,3-(n))
)w2c_template"
R"w2c_template(#define v128_i64x2_extract_lane(a,n) simde_wasm_u64x2_extract_lane(a,1-(n))
)w2c_template"
R"w2c_template(#define v128_u64x2_extract_lane(a,n) simde_wasm_u64x2_extract_lane(a,1-(n))
)w2c_template"
R"w2c_template(#define v128_f32x4_extract_lane(a,n) simde_wasm_f32x4_extract_lane(a,3-(n))
)w2c_template"
R"w2c_template(#define v128_f64x2_extract_lane(a,n) simde_wasm_f64x2_extract_lane(a,1-(n))
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define v128_i8x16_make simde_wasm_i8x16_make
)w2c_template"
R"w2c_template(#define v128_u8x16_make simde_wasm_u8x16_make
)w2c_template"
R"w2c_template(#define v128_i16x8_make simde_wasm_i16x8_make
)w2c_template"
R"w2c_template(#define v128_u16x8_make simde_wasm_u16x8_make
)w2c_template"
R"w2c_template(#define v128_i32x4_make simde_wasm_i32x4_make
)w2c_template"
R"w2c_template(#define v128_u32x4_make simde_wasm_u32x4_make
)w2c_template"
R"w2c_template(#define v128_i64x2_make simde_wasm_i64x2_make
)w2c_template"
R"w2c_template(#define v128_u64x2_make simde_wasm_u64x2_make
)w2c_template"
R"w2c_template(#define v128_f32x4_make simde_wasm_f32x4_make
)w2c_template"
R"w2c_template(#define v128_f64x2_make simde_wasm_f64x2_make
)w2c_template"
R"w2c_template(// like is_equal_TYPE below, always use unsigned for these
)w2c_template"
R"w2c_template(#define v128_i8x16_extract_lane simde_wasm_u8x16_extract_lane
)w2c_template"
R"w2c_template(#define v128_u8x16_extract_lane simde_wasm_u8x16_extract_lane
)w2c_template"
R"w2c_template(#define v128_i16x8_extract_lane simde_wasm_u16x8_extract_lane
)w2c_template"
R"w2c_template(#define v128_u16x8_extract_lane simde_wasm_u16x8_extract_lane
)w2c_template"
R"w2c_template(#define v128_i32x4_extract_lane simde_wasm_u32x4_extract_lane
)w2c_template"
R"w2c_template(#define v128_u32x4_extract_lane simde_wasm_u32x4_extract_lane
)w2c_template"
R"w2c_template(#define v128_i64x2_extract_lane simde_wasm_u64x2_extract_lane
)w2c_template"
R"w2c_template(#define v128_u64x2_extract_lane simde_wasm_u64x2_extract_lane
)w2c_template"
R"w2c_template(#define v128_f32x4_extract_lane simde_wasm_f32x4_extract_lane
)w2c_template"
R"w2c_template(#define v128_f64x2_extract_lane simde_wasm_f64x2_extract_lane
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
static int g_tests_run;
)w2c_template"
R"w2c_template(static int g_tests_passed;
)w2c_template"
R"w2c_template(
static void run_spec_tests(void);
)w2c_template"
R"w2c_template(
static void error(const char* file, int line, const char* format, ...) {
)w2c_template"
R"w2c_template(  va_list args;
)w2c_template"
R"w2c_template(  va_start(args, format);
)w2c_template"
R"w2c_template(  fprintf(stderr, "%s:%d: assertion failed: ", file, line);
)w2c_template"
R"w2c_template(  vfprintf(stderr, format, args);
)w2c_template"
R"w2c_template(  va_end(args);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define ASSERT_EXCEPTION(f)                                               \
)w2c_template"
R"w2c_template(  do {                                                                    \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                        \
)w2c_template"
R"w2c_template(    if (wasm_rt_impl_try() == WASM_RT_TRAP_UNCAUGHT_EXCEPTION) {          \
)w2c_template"
R"w2c_template(      g_tests_passed++;                                                   \
)w2c_template"
R"w2c_template(    } else {                                                              \
)w2c_template"
R"w2c_template(      (void)(f);                                                          \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, "expected " #f " to throw exception.\n"); \
)w2c_template"
R"w2c_template(    }                                                                     \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_TRAP(f)                                         \
)w2c_template"
R"w2c_template(  do {                                                         \
)w2c_template"
R"w2c_template(    g_tests_run++;                                             \
)w2c_template"
R"w2c_template(    if (wasm_rt_impl_try() != 0) {                             \
)w2c_template"
R"w2c_template(      g_tests_passed++;                                        \
)w2c_template"
R"w2c_template(    } else {                                                   \
)w2c_template"
R"w2c_template(      (void)(f);                                               \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, "expected " #f " to trap.\n"); \
)w2c_template"
R"w2c_template(    }                                                          \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_EXHAUSTION(f)                                     \
)w2c_template"
R"w2c_template(  do {                                                           \
)w2c_template"
R"w2c_template(    g_tests_run++;                                               \
)w2c_template"
R"w2c_template(    wasm_rt_trap_t code = wasm_rt_impl_try();                    \
)w2c_template"
R"w2c_template(    switch (code) {                                              \
)w2c_template"
R"w2c_template(      case WASM_RT_TRAP_NONE:                                    \
)w2c_template"
R"w2c_template(        (void)(f);                                               \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__, "expected " #f " to trap.\n"); \
)w2c_template"
R"w2c_template(        break;                                                   \
)w2c_template"
R"w2c_template(      case WASM_RT_TRAP_EXHAUSTION:                              \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                        \
)w2c_template"
R"w2c_template(        break;                                                   \
)w2c_template"
R"w2c_template(      default:                                                   \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                \
)w2c_template"
R"w2c_template(              "expected " #f                                     \
)w2c_template"
R"w2c_template(              " to trap due to exhaustion, got trap code %d.\n", \
)w2c_template"
R"w2c_template(              code);                                             \
)w2c_template"
R"w2c_template(        break;                                                   \
)w2c_template"
R"w2c_template(    }                                                            \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN(f)                               \
)w2c_template"
R"w2c_template(  do {                                                 \
)w2c_template"
R"w2c_template(    g_tests_run++;                                     \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                \
)w2c_template"
R"w2c_template(    if (trap_code) {                                   \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n", \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));              \
)w2c_template"
R"w2c_template(    } else {                                           \
)w2c_template"
R"w2c_template(      f;                                               \
)w2c_template"
R"w2c_template(      g_tests_passed++;                                \
)w2c_template"
R"w2c_template(    }                                                  \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN_T(type, fmt, f, expected)                          \
)w2c_template"
R"w2c_template(  do {                                                                   \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                       \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                                  \
)w2c_template"
R"w2c_template(    if (trap_code) {                                                     \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n",                   \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));                                \
)w2c_template"
R"w2c_template(    } else {                                                             \
)w2c_template"
R"w2c_template(      type actual = f;                                                   \
)w2c_template"
R"w2c_template(      if (is_equal_##type(actual, expected)) {                           \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                                \
)w2c_template"
R"w2c_template(      } else {                                                           \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                        \
)w2c_template"
R"w2c_template(              "in " #f ": expected %" fmt ", got %" fmt ".\n", expected, \
)w2c_template"
R"w2c_template(              actual);                                                   \
)w2c_template"
R"w2c_template(      }                                                                  \
)w2c_template"
R"w2c_template(    }                                                                    \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN_FUNCREF(f, expected)                                \
)w2c_template"
R"w2c_template(  do {                                                                    \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                        \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                                   \
)w2c_template"
R"w2c_template(    if (trap_code) {                                                      \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n",                    \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));                                 \
)w2c_template"
R"w2c_template(    } else {                                                              \
)w2c_template"
R"w2c_template(      wasm_rt_funcref_t actual = f;                                       \
)w2c_template"
R"w2c_template(      if (is_equal_wasm_rt_funcref_t(actual, expected)) {                 \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                                 \
)w2c_template"
R"w2c_template(      } else {                                                            \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                         \
)w2c_template"
R"w2c_template(              "in " #f ": mismatch between expected and actual funcref"); \
)w2c_template"
R"w2c_template(      }                                                                   \
)w2c_template"
R"w2c_template(    }                                                                     \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN_EXNREF(f, expected)                                \
)w2c_template"
R"w2c_template(  do {                                                                   \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                       \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                                  \
)w2c_template"
R"w2c_template(    if (trap_code) {                                                     \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n",                   \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));                                \
)w2c_template"
R"w2c_template(    } else {                                                             \
)w2c_template"
R"w2c_template(      wasm_rt_exnref_t actual = f;                                       \
)w2c_template"
R"w2c_template(      if (is_equal_wasm_rt_exnref_t(actual, expected)) {                 \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                                \
)w2c_template"
R"w2c_template(      } else {                                                           \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                        \
)w2c_template"
R"w2c_template(              "in " #f ": mismatch between expected and actual exnref"); \
)w2c_template"
R"w2c_template(      }                                                                  \
)w2c_template"
R"w2c_template(    }                                                                    \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN_NAN_T(type, itype, fmt, f, kind)                        \
)w2c_template"
R"w2c_template(  do {                                                                        \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                            \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                                       \
)w2c_template"
R"w2c_template(    if (trap_code) {                                                          \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n",                        \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));                                     \
)w2c_template"
R"w2c_template(    } else {                                                                  \
)w2c_template"
R"w2c_template(      type actual = f;                                                        \
)w2c_template"
R"w2c_template(      itype iactual;                                                          \
)w2c_template"
R"w2c_template(      memcpy(&iactual, &actual, sizeof(iactual));                             \
)w2c_template"
R"w2c_template(      if (is_##kind##_nan_##type(iactual)) {                                  \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                                     \
)w2c_template"
R"w2c_template(      } else {                                                                \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                             \
)w2c_template"
R"w2c_template(              "in " #f ": expected result to be a " #kind " nan, got 0x%" fmt \
)w2c_template"
R"w2c_template(              ".\n",                                                          \
)w2c_template"
R"w2c_template(              iactual);                                                       \
)w2c_template"
R"w2c_template(      }                                                                       \
)w2c_template"
R"w2c_template(    }                                                                         \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define MULTI_T_UNPACK_(...) __VA_ARGS__
)w2c_template"
R"w2c_template(#define MULTI_T_UNPACK(arg) MULTI_T_UNPACK_ arg
)w2c_template"
R"w2c_template(#define MULTI_i8 "%" PRIu8 " "
)w2c_template"
R"w2c_template(#define MULTI_i16 "%" PRIu16 " "
)w2c_template"
R"w2c_template(#define MULTI_i32 "%u "
)w2c_template"
R"w2c_template(#define MULTI_i64 "%" PRIu64 " "
)w2c_template"
R"w2c_template(#define MULTI_f32 "%.9g "
)w2c_template"
R"w2c_template(#define MULTI_f64 "%.17g "
)w2c_template"
R"w2c_template(#define MULTI_str "%s "
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_MULTI_T(type, fmt_expected, fmt_got, f, compare,        \
)w2c_template"
R"w2c_template(                              expected, found)                                \
)w2c_template"
R"w2c_template(  do {                                                                        \
)w2c_template"
R"w2c_template(    g_tests_run++;                                                            \
)w2c_template"
R"w2c_template(    int trap_code = wasm_rt_impl_try();                                       \
)w2c_template"
R"w2c_template(    if (trap_code) {                                                          \
)w2c_template"
R"w2c_template(      error(__FILE__, __LINE__, #f " trapped (%s).\n",                        \
)w2c_template"
R"w2c_template(            wasm_rt_strerror(trap_code));                                     \
)w2c_template"
R"w2c_template(    } else {                                                                  \
)w2c_template"
R"w2c_template(      type actual = f;                                                        \
)w2c_template"
R"w2c_template(      if (compare) {                                                          \
)w2c_template"
R"w2c_template(        g_tests_passed++;                                                     \
)w2c_template"
R"w2c_template(      } else {                                                                \
)w2c_template"
R"w2c_template(        error(__FILE__, __LINE__,                                             \
)w2c_template"
R"w2c_template(              "in " #f ": expected <" fmt_expected ">, got <" fmt_got ">.\n", \
)w2c_template"
R"w2c_template(              MULTI_T_UNPACK(expected), MULTI_T_UNPACK(found));               \
)w2c_template"
R"w2c_template(      }                                                                       \
)w2c_template"
R"w2c_template(    }                                                                         \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(

)w2c_template"
R"w2c_template(#define ASSERT_RETURN_I32(f, expected) ASSERT_RETURN_T(u32, "u", f, expected)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_I64(f, expected) ASSERT_RETURN_T(u64, PRIu64, f, expected)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_F32(f, expected) ASSERT_RETURN_T(f32, ".9g", f, expected)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_F64(f, expected) ASSERT_RETURN_T(f64, ".17g", f, expected)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_EXTERNREF(f, expected) \
)w2c_template"
R"w2c_template(  ASSERT_RETURN_T(wasm_rt_externref_t, "p", f, expected);
)w2c_template"
R"w2c_template(
#define ASSERT_RETURN_CANONICAL_NAN_F32(f) \
)w2c_template"
R"w2c_template(  ASSERT_RETURN_NAN_T(f32, u32, "08x", f, canonical)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_CANONICAL_NAN_F64(f) \
)w2c_template"
R"w2c_template(  ASSERT_RETURN_NAN_T(f64, u64, "016x", f, canonical)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_ARITHMETIC_NAN_F32(f) \
)w2c_template"
R"w2c_template(  ASSERT_RETURN_NAN_T(f32, u32, "08x", f, arithmetic)
)w2c_template"
R"w2c_template(#define ASSERT_RETURN_ARITHMETIC_NAN_F64(f) \
)w2c_template"
R"w2c_template(  ASSERT_RETURN_NAN_T(f64, u64, "016x", f, arithmetic)
)w2c_template"
R"w2c_template(
static bool is_equal_u8(u8 x, u8 y) {
)w2c_template"
R"w2c_template(  return x == y;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_u16(u16 x, u16 y) {
)w2c_template"
R"w2c_template(  return x == y;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_u32(u32 x, u32 y) {
)w2c_template"
R"w2c_template(  return x == y;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_u64(u64 x, u64 y) {
)w2c_template"
R"w2c_template(  return x == y;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define is_equal_i8 is_equal_u8
)w2c_template"
R"w2c_template(#define is_equal_i16 is_equal_u16
)w2c_template"
R"w2c_template(#define is_equal_i32 is_equal_u32
)w2c_template"
R"w2c_template(#define is_equal_i64 is_equal_u64
)w2c_template"
R"w2c_template(
static bool is_equal_wasm_rt_externref_t(wasm_rt_externref_t x,
)w2c_template"
R"w2c_template(                                         wasm_rt_externref_t y) {
)w2c_template"
R"w2c_template(  return x == y;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline bool is_equal_wasm_rt_func_type_t(const wasm_rt_func_type_t a,
)w2c_template"
R"w2c_template(                                                const wasm_rt_func_type_t b) {
)w2c_template"
R"w2c_template(  return (a == b) || (a && b && !memcmp(a, b, 32));
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_wasm_rt_funcref_t(wasm_rt_funcref_t x,
)w2c_template"
R"w2c_template(                                       wasm_rt_funcref_t y) {
)w2c_template"
R"w2c_template(  return is_equal_wasm_rt_func_type_t(x.func_type, y.func_type) &&
)w2c_template"
R"w2c_template(         (x.func == y.func) && (x.module_instance == y.module_instance);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#ifdef WASM_EXN_MAX_SIZE
)w2c_template"
R"w2c_template(static bool is_equal_wasm_rt_exnref_t(wasm_rt_exnref_t x, wasm_rt_exnref_t y) {
)w2c_template"
R"w2c_template(  return x.tag == y.tag && x.size == y.size && !memcmp(x.data, y.data, x.size);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
wasm_rt_externref_t spectest_make_externref(uintptr_t x) {
)w2c_template"
R"w2c_template(  return (wasm_rt_externref_t)(x + 1);  // externref(0) is not null
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static u32 f32_bits(f32 x) {
)w2c_template"
R"w2c_template(  u32 ux;
)w2c_template"
R"w2c_template(  memcpy(&ux, &x, sizeof(ux));
)w2c_template"
R"w2c_template(  return ux;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static u64 f64_bits(f64 x) {
)w2c_template"
R"w2c_template(  u64 ux;
)w2c_template"
R"w2c_template(  memcpy(&ux, &x, sizeof(ux));
)w2c_template"
R"w2c_template(  return ux;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_f32(f32 x, f32 y) {
)w2c_template"
R"w2c_template(  return f32_bits(x) == f32_bits(y);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_equal_f64(f64 x, f64 y) {
)w2c_template"
R"w2c_template(  return f64_bits(x) == f64_bits(y);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static f32 make_nan_f32(u32 x) {
)w2c_template"
R"w2c_template(  x |= 0x7f800000;
)w2c_template"
R"w2c_template(  f32 res;
)w2c_template"
R"w2c_template(  memcpy(&res, &x, sizeof(res));
)w2c_template"
R"w2c_template(  return res;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static f64 make_nan_f64(u64 x) {
)w2c_template"
R"w2c_template(  x |= 0x7ff0000000000000;
)w2c_template"
R"w2c_template(  f64 res;
)w2c_template"
R"w2c_template(  memcpy(&res, &x, sizeof(res));
)w2c_template"
R"w2c_template(  return res;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_canonical_nan_f32(u32 x) {
)w2c_template"
R"w2c_template(  return (x & 0x7fffffff) == 0x7fc00000;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_canonical_nan_f64(u64 x) {
)w2c_template"
R"w2c_template(  return (x & 0x7fffffffffffffff) == 0x7ff8000000000000;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_arithmetic_nan_f32(u32 x) {
)w2c_template"
R"w2c_template(  return (x & 0x7fc00000) == 0x7fc00000;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static bool is_arithmetic_nan_f64(u64 x) {
)w2c_template"
R"w2c_template(  return (x & 0x7ff8000000000000) == 0x7ff8000000000000;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
typedef struct w2c_spectest {
)w2c_template"
R"w2c_template(  wasm_rt_funcref_table_t spectest_table;
)w2c_template"
R"w2c_template(  wasm_rt_funcref_table_t spectest_table64;
)w2c_template"
R"w2c_template(  wasm_rt_memory_t spectest_memory;
)w2c_template"
R"w2c_template(  uint32_t spectest_global_i32;
)w2c_template"
R"w2c_template(  uint64_t spectest_global_i64;
)w2c_template"
R"w2c_template(  float spectest_global_f32;
)w2c_template"
R"w2c_template(  double spectest_global_f64;
)w2c_template"
R"w2c_template(} w2c_spectest;
)w2c_template"
R"w2c_template(
static w2c_spectest spectest_instance;
)w2c_template"
R"w2c_template(
/*
)w2c_template"
R"w2c_template( * spectest implementations
)w2c_template"
R"w2c_template( */
)w2c_template"
R"w2c_template(void w2c_spectest_print(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  printf("spectest.print()\n");
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_i32(w2c_spectest* instance, uint32_t i) {
)w2c_template"
R"w2c_template(  printf("spectest.print_i32(%d)\n", i);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_i64(w2c_spectest* instance, uint64_t i) {
)w2c_template"
R"w2c_template(  printf("spectest.print_i64(%" PRIu64 ")\n", i);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_f32(w2c_spectest* instance, float f) {
)w2c_template"
R"w2c_template(  printf("spectest.print_f32(%g)\n", f);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_i32_f32(w2c_spectest* instance, uint32_t i, float f) {
)w2c_template"
R"w2c_template(  printf("spectest.print_i32_f32(%d %g)\n", i, f);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_f64(w2c_spectest* instance, double d) {
)w2c_template"
R"w2c_template(  printf("spectest.print_f64(%g)\n", d);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
void w2c_spectest_print_f64_f64(w2c_spectest* instance, double d1, double d2) {
)w2c_template"
R"w2c_template(  printf("spectest.print_f64_f64(%g %g)\n", d1, d2);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
wasm_rt_funcref_table_t* w2c_spectest_table(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_table;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
wasm_rt_funcref_table_t* w2c_spectest_table64(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_table64;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
wasm_rt_memory_t* w2c_spectest_memory(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_memory;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
uint32_t* w2c_spectest_global_i32(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_global_i32;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
uint64_t* w2c_spectest_global_i64(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_global_i64;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
float* w2c_spectest_global_f32(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_global_f32;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
double* w2c_spectest_global_f64(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  return &instance->spectest_global_f64;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static void init_spectest_module(w2c_spectest* instance) {
)w2c_template"
R"w2c_template(  instance->spectest_global_i32 = 666;
)w2c_template"
R"w2c_template(  instance->spectest_global_i64 = 666l;
)w2c_template"
R"w2c_template(  instance->spectest_global_f32 = 666.6;
)w2c_template"
R"w2c_template(  instance->spectest_global_f64 = 666.6;
)w2c_template"
R"w2c_template(  wasm_rt_allocate_memory(&instance->spectest_memory, 1, 2, false,
)w2c_template"
R"w2c_template(                          WASM_DEFAULT_PAGE_SIZE);
)w2c_template"
R"w2c_template(  wasm_rt_allocate_funcref_table(&instance->spectest_table, 10, 20);
)w2c_template"
R"w2c_template(  wasm_rt_allocate_funcref_table(&instance->spectest_table64, 10, 20);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
// POSIX-only test config where embedder handles signals instead of w2c runtime
)w2c_template"
R"w2c_template(#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
)w2c_template"
R"w2c_template(#include <signal.h>
)w2c_template"
R"w2c_template(
static void posix_signal_handler(int sig, siginfo_t* si, void* unused) {
)w2c_template"
R"w2c_template(  wasm_rt_trap((si->si_code == SEGV_ACCERR) ? WASM_RT_TRAP_OOB
)w2c_template"
R"w2c_template(                                            : WASM_RT_TRAP_EXHAUSTION);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static void posix_install_signal_handler(void) {
)w2c_template"
R"w2c_template(  /* install altstack */
)w2c_template"
R"w2c_template(  stack_t ss;
)w2c_template"
R"w2c_template(  ss.ss_sp = malloc(SIGSTKSZ);
)w2c_template"
R"w2c_template(  ss.ss_flags = 0;
)w2c_template"
R"w2c_template(  ss.ss_size = SIGSTKSZ;
)w2c_template"
R"w2c_template(  if (sigaltstack(&ss, NULL) != 0) {
)w2c_template"
R"w2c_template(    perror("sigaltstack failed");
)w2c_template"
R"w2c_template(    abort();
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
  /* install signal handler */
)w2c_template"
R"w2c_template(  struct sigaction sa;
)w2c_template"
R"w2c_template(  memset(&sa, '\0', sizeof(sa));
)w2c_template"
R"w2c_template(  sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
)w2c_template"
R"w2c_template(  sigemptyset(&sa.sa_mask);
)w2c_template"
R"w2c_template(  sa.sa_sigaction = posix_signal_handler;
)w2c_template"
R"w2c_template(  if (sigaction(SIGSEGV, &sa, NULL) != 0 || sigaction(SIGBUS, &sa, NULL) != 0) {
)w2c_template"
R"w2c_template(    perror("sigaction failed");
)w2c_template"
R"w2c_template(    abort();
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static void posix_cleanup_signal_handler(void) {
)w2c_template"
R"w2c_template(  /* remove signal handler */
)w2c_template"
R"w2c_template(  struct sigaction sa;
)w2c_template"
R"w2c_template(  memset(&sa, '\0', sizeof(sa));
)w2c_template"
R"w2c_template(  sa.sa_handler = SIG_DFL;
)w2c_template"
R"w2c_template(  if (sigaction(SIGSEGV, &sa, NULL) != 0 || sigaction(SIGBUS, &sa, NULL)) {
)w2c_template"
R"w2c_template(    perror("sigaction failed");
)w2c_template"
R"w2c_template(    abort();
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
  /* disable and free altstack */
)w2c_template"
R"w2c_template(  stack_t ss;
)w2c_template"
R"w2c_template(  ss.ss_flags = SS_DISABLE;
)w2c_template"
R"w2c_template(  if (sigaltstack(&ss, NULL) != 0) {
)w2c_template"
R"w2c_template(    perror("sigaltstack failed");
)w2c_template"
R"w2c_template(    abort();
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  free(ss.ss_sp);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
int main(int argc, char** argv) {
)w2c_template"
R"w2c_template(#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
)w2c_template"
R"w2c_template(  posix_install_signal_handler();
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(  wasm_rt_init();
)w2c_template"
R"w2c_template(  init_spectest_module(&spectest_instance);
)w2c_template"
R"w2c_template(  run_spec_tests();
)w2c_template"
R"w2c_template(  printf("%u/%u tests passed.\n", g_tests_passed, g_tests_run);
)w2c_template"
R"w2c_template(  wasm_rt_free();
)w2c_template"
R"w2c_template(#ifdef WASM2C_TEST_EMBEDDER_SIGNAL_HANDLING
)w2c_template"
R"w2c_template(  posix_cleanup_signal_handler();
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(  return g_tests_passed != g_tests_run;
)w2c_template"
R"w2c_template(}
)w2c_template"
;
