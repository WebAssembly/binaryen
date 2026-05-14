const char* s_atomicops_source_declarations = R"w2c_template(#include <stdatomic.h>
)w2c_template"
R"w2c_template(
#ifndef WASM_RT_C11_AVAILABLE
)w2c_template"
R"w2c_template(#error "C11 is required for Wasm threads and shared memory support"
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#define ATOMIC_ALIGNMENT_CHECK(addr, t1) \
)w2c_template"
R"w2c_template(  if (UNLIKELY(addr % sizeof(t1))) {     \
)w2c_template"
R"w2c_template(    TRAP(UNALIGNED);                     \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
#define DEFINE_SHARED_LOAD(name, t1, t2, t3, force_read)                      \
)w2c_template"
R"w2c_template(  static inline t3 name##_unchecked(wasm_rt_shared_memory_t* mem, u64 addr) { \
)w2c_template"
R"w2c_template(    t1 result;                                                                \
)w2c_template"
R"w2c_template(    result = atomic_load_explicit(                                            \
)w2c_template"
R"w2c_template(        (_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1)),                \
)w2c_template"
R"w2c_template(        memory_order_relaxed);                                                \
)w2c_template"
R"w2c_template(    force_read(result);                                                       \
)w2c_template"
R"w2c_template(    return (t3)(t2)result;                                                    \
)w2c_template"
R"w2c_template(  }                                                                           \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS0(name, _shared_, t1, return, t3)
)w2c_template"
R"w2c_template(
DEFINE_SHARED_LOAD(i32_load_shared, u32, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load_shared, u64, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(f32_load_shared, f32, f32, f32, FORCE_READ_FLOAT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(f64_load_shared, f64, f64, f64, FORCE_READ_FLOAT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i32_load8_s_shared, s8, s32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load8_s_shared, s8, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i32_load8_u_shared, u8, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load8_u_shared, u8, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i32_load16_s_shared, s16, s32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load16_s_shared, s16, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i32_load16_u_shared, u16, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load16_u_shared, u16, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load32_s_shared, s32, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_SHARED_LOAD(i64_load32_u_shared, u32, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(
#define DEFINE_SHARED_STORE(name, t1, t2)                                     \
)w2c_template"
R"w2c_template(  static inline void name##_unchecked(wasm_rt_shared_memory_t* mem, u64 addr, \
)w2c_template"
R"w2c_template(                                      t2 value) {                             \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                                   \
)w2c_template"
R"w2c_template(    atomic_store_explicit(                                                    \
)w2c_template"
R"w2c_template(        (_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1)), wrapped,       \
)w2c_template"
R"w2c_template(        memory_order_relaxed);                                                \
)w2c_template"
R"w2c_template(  }                                                                           \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _shared_, t1, , void, t2)
)w2c_template"
R"w2c_template(
DEFINE_SHARED_STORE(i32_store_shared, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i64_store_shared, u64, u64)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(f32_store_shared, f32, f32)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(f64_store_shared, f64, f64)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i32_store8_shared, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i32_store16_shared, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i64_store8_shared, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i64_store16_shared, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_SHARED_STORE(i64_store32_shared, u32, u64)
)w2c_template"
R"w2c_template(
#define DEFINE_ATOMIC_LOAD(name, t1, t2, t3, force_read)                    \
)w2c_template"
R"w2c_template(  static inline t3 name##_unchecked(wasm_rt_memory_t* mem, u64 addr) {      \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                       \
)w2c_template"
R"w2c_template(    t1 result;                                                              \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&result, MEM_ADDR(mem, addr, sizeof(t1)), sizeof(t1));   \
)w2c_template"
R"w2c_template(    force_read(result);                                                     \
)w2c_template"
R"w2c_template(    return (t3)(t2)result;                                                  \
)w2c_template"
R"w2c_template(  }                                                                         \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS0(name, _, t1, return, t3)                                  \
)w2c_template"
R"w2c_template(  static inline t3 name##_shared_unchecked(wasm_rt_shared_memory_t* mem,    \
)w2c_template"
R"w2c_template(                                           u64 addr) {                      \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                       \
)w2c_template"
R"w2c_template(    t1 result;                                                              \
)w2c_template"
R"w2c_template(    result =                                                                \
)w2c_template"
R"w2c_template(        atomic_load((_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1))); \
)w2c_template"
R"w2c_template(    force_read(result);                                                     \
)w2c_template"
R"w2c_template(    return (t3)(t2)result;                                                  \
)w2c_template"
R"w2c_template(  }                                                                         \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS0(name##_shared, _shared_, t1, return, t3)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_LOAD(i32_atomic_load, u32, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i64_atomic_load, u64, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i32_atomic_load8_u, u8, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i64_atomic_load8_u, u8, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i32_atomic_load16_u, u16, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i64_atomic_load16_u, u16, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_LOAD(i64_atomic_load32_u, u32, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(
#define DEFINE_ATOMIC_STORE(name, t1, t2)                                  \
)w2c_template"
R"w2c_template(  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr,     \
)w2c_template"
R"w2c_template(                                      t2 value) {                          \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                      \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                                \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(MEM_ADDR(mem, addr, sizeof(t1)), &wrapped, sizeof(t1)); \
)w2c_template"
R"w2c_template(  }                                                                        \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t1, , void, t2)                                 \
)w2c_template"
R"w2c_template(  static inline void name##_shared_unchecked(wasm_rt_shared_memory_t* mem, \
)w2c_template"
R"w2c_template(                                             u64 addr, t2 value) {         \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                      \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                                \
)w2c_template"
R"w2c_template(    atomic_store((_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1)),    \
)w2c_template"
R"w2c_template(                 wrapped);                                                 \
)w2c_template"
R"w2c_template(  }                                                                        \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name##_shared, _shared_, t1, , void, t2)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_STORE(i32_atomic_store, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i64_atomic_store, u64, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i32_atomic_store8, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i32_atomic_store16, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i64_atomic_store8, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i64_atomic_store16, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_STORE(i64_atomic_store32, u32, u64)
)w2c_template"
R"w2c_template(
#define DEFINE_ATOMIC_RMW(name, opname, op, t1, t2)                      \
)w2c_template"
R"w2c_template(  static inline t2 name##_unchecked(wasm_rt_memory_t* mem, u64 addr,     \
)w2c_template"
R"w2c_template(                                    t2 value) {                          \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                    \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                              \
)w2c_template"
R"w2c_template(    t1 ret;                                                              \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&ret, MEM_ADDR(mem, addr, sizeof(t1)), sizeof(t1));   \
)w2c_template"
R"w2c_template(    ret = ret op wrapped;                                                \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(MEM_ADDR(mem, addr, sizeof(t1)), &ret, sizeof(t1));   \
)w2c_template"
R"w2c_template(    return (t2)ret;                                                      \
)w2c_template"
R"w2c_template(  }                                                                      \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t1, return, t2, t2)                           \
)w2c_template"
R"w2c_template(  static inline t2 name##_shared_unchecked(wasm_rt_shared_memory_t* mem, \
)w2c_template"
R"w2c_template(                                           u64 addr, t2 value) {         \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                    \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                              \
)w2c_template"
R"w2c_template(    t1 ret = atomic_##opname(                                            \
)w2c_template"
R"w2c_template(        (_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1)), wrapped); \
)w2c_template"
R"w2c_template(    return (t2)ret;                                                      \
)w2c_template"
R"w2c_template(  }                                                                      \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name##_shared, _shared_, t1, return, t2, t2)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_RMW(i32_atomic_rmw8_add_u, fetch_add, +, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw16_add_u, fetch_add, +, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw_add, fetch_add, +, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw8_add_u, fetch_add, +, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw16_add_u, fetch_add, +, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw32_add_u, fetch_add, +, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw_add, fetch_add, +, u64, u64)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_RMW(i32_atomic_rmw8_sub_u, fetch_sub, -, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw16_sub_u, fetch_sub, -, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw_sub, fetch_sub, -, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw8_sub_u, fetch_sub, -, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw16_sub_u, fetch_sub, -, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw32_sub_u, fetch_sub, -, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw_sub, fetch_sub, -, u64, u64)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_RMW(i32_atomic_rmw8_and_u, fetch_and, &, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw16_and_u, fetch_and, &, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw_and, fetch_and, &, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw8_and_u, fetch_and, &, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw16_and_u, fetch_and, &, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw32_and_u, fetch_and, &, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw_and, fetch_and, &, u64, u64)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_RMW(i32_atomic_rmw8_or_u, fetch_or, |, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw16_or_u, fetch_or, |, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw_or, fetch_or, |, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw8_or_u, fetch_or, |, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw16_or_u, fetch_or, |, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw32_or_u, fetch_or, |, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw_or, fetch_or, |, u64, u64)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_RMW(i32_atomic_rmw8_xor_u, fetch_xor, ^, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw16_xor_u, fetch_xor, ^, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i32_atomic_rmw_xor, fetch_xor, ^, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw8_xor_u, fetch_xor, ^, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw16_xor_u, fetch_xor, ^, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw32_xor_u, fetch_xor, ^, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_RMW(i64_atomic_rmw_xor, fetch_xor, ^, u64, u64)
)w2c_template"
R"w2c_template(
#define DEFINE_ATOMIC_XCHG(name, opname, t1, t2)                           \
)w2c_template"
R"w2c_template(  static inline t2 name##_unchecked(wasm_rt_memory_t* mem, u64 addr,       \
)w2c_template"
R"w2c_template(                                    t2 value) {                            \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                      \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                                \
)w2c_template"
R"w2c_template(    t1 ret;                                                                \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&ret, MEM_ADDR(mem, addr, sizeof(t1)), sizeof(t1));     \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(MEM_ADDR(mem, addr, sizeof(t1)), &wrapped, sizeof(t1)); \
)w2c_template"
R"w2c_template(    return (t2)ret;                                                        \
)w2c_template"
R"w2c_template(  }                                                                        \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t1, return, t2, t2)                             \
)w2c_template"
R"w2c_template(  static inline t2 name##_shared_unchecked(wasm_rt_shared_memory_t* mem,   \
)w2c_template"
R"w2c_template(                                           u64 addr, t2 value) {           \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t1);                                      \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                                \
)w2c_template"
R"w2c_template(    t1 ret = atomic_##opname(                                              \
)w2c_template"
R"w2c_template(        (_Atomic volatile t1*)MEM_ADDR(mem, addr, sizeof(t1)), wrapped);   \
)w2c_template"
R"w2c_template(    return (t2)ret;                                                        \
)w2c_template"
R"w2c_template(  }                                                                        \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name##_shared, _shared_, t1, return, t2, t2)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_XCHG(i32_atomic_rmw8_xchg_u, exchange, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i32_atomic_rmw16_xchg_u, exchange, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i32_atomic_rmw_xchg, exchange, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i64_atomic_rmw8_xchg_u, exchange, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i64_atomic_rmw16_xchg_u, exchange, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i64_atomic_rmw32_xchg_u, exchange, u32, u64)
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_XCHG(i64_atomic_rmw_xchg, exchange, u64, u64)
)w2c_template"
R"w2c_template(
#define DEFINE_ATOMIC_CMP_XCHG(name, t1, t2)                                 \
)w2c_template"
R"w2c_template(  static inline t1 name##_unchecked(wasm_rt_memory_t* mem, u64 addr,         \
)w2c_template"
R"w2c_template(                                    t1 expected, t1 replacement) {           \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t2);                                        \
)w2c_template"
R"w2c_template(    t2 expected_wrapped = (t2)expected;                                      \
)w2c_template"
R"w2c_template(    t2 replacement_wrapped = (t2)replacement;                                \
)w2c_template"
R"w2c_template(    t2 ret;                                                                  \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&ret, MEM_ADDR(mem, addr, sizeof(t2)), sizeof(t2));       \
)w2c_template"
R"w2c_template(    if (ret == expected_wrapped) {                                           \
)w2c_template"
R"w2c_template(      wasm_rt_memcpy(MEM_ADDR(mem, addr, sizeof(t2)), &replacement_wrapped,  \
)w2c_template"
R"w2c_template(                     sizeof(t2));                                            \
)w2c_template"
R"w2c_template(    }                                                                        \
)w2c_template"
R"w2c_template(    return (t1)expected_wrapped;                                             \
)w2c_template"
R"w2c_template(  }                                                                          \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS2(name, _, t2, return, t1, t1, t1)                           \
)w2c_template"
R"w2c_template(  static inline t1 name##_shared_unchecked(                                  \
)w2c_template"
R"w2c_template(      wasm_rt_shared_memory_t* mem, u64 addr, t1 expected, t1 replacement) { \
)w2c_template"
R"w2c_template(    ATOMIC_ALIGNMENT_CHECK(addr, t2);                                        \
)w2c_template"
R"w2c_template(    t2 expected_wrapped = (t2)expected;                                      \
)w2c_template"
R"w2c_template(    t2 replacement_wrapped = (t2)replacement;                                \
)w2c_template"
R"w2c_template(    atomic_compare_exchange_strong(                                          \
)w2c_template"
R"w2c_template(        (_Atomic volatile t2*)MEM_ADDR(mem, addr, sizeof(t2)),               \
)w2c_template"
R"w2c_template(        &expected_wrapped, replacement_wrapped);                             \
)w2c_template"
R"w2c_template(    return (t1)expected_wrapped;                                             \
)w2c_template"
R"w2c_template(  }                                                                          \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS2(name##_shared, _shared_, t2, return, t1, t1, t1)
)w2c_template"
R"w2c_template(
DEFINE_ATOMIC_CMP_XCHG(i32_atomic_rmw8_cmpxchg_u, u32, u8);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i32_atomic_rmw16_cmpxchg_u, u32, u16);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i32_atomic_rmw_cmpxchg, u32, u32);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i64_atomic_rmw8_cmpxchg_u, u64, u8);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i64_atomic_rmw16_cmpxchg_u, u64, u16);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i64_atomic_rmw32_cmpxchg_u, u64, u32);
)w2c_template"
R"w2c_template(DEFINE_ATOMIC_CMP_XCHG(i64_atomic_rmw_cmpxchg, u64, u64);
)w2c_template"
R"w2c_template(
#define atomic_fence() atomic_thread_fence(memory_order_seq_cst)
)w2c_template"
;
