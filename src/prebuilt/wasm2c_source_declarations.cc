const char* s_source_declarations = R"w2c_template(
// Computes a pointer to an object of the given size in a little-endian memory.
)w2c_template"
R"w2c_template(//
)w2c_template"
R"w2c_template(// On a little-endian host, this is just &mem->data[addr] - the object's size is
)w2c_template"
R"w2c_template(// unused. On a big-endian host, it's &mem->data[mem->size - addr - n], where n
)w2c_template"
R"w2c_template(// is the object's size.
)w2c_template"
R"w2c_template(//
)w2c_template"
R"w2c_template(// Note that mem may be evaluated multiple times.
)w2c_template"
R"w2c_template(//
)w2c_template"
R"w2c_template(// Parameters:
)w2c_template"
R"w2c_template(// mem - The memory.
)w2c_template"
R"w2c_template(// addr - The address.
)w2c_template"
R"w2c_template(// n - The size of the object.
)w2c_template"
R"w2c_template(//
)w2c_template"
R"w2c_template(// Result:
)w2c_template"
R"w2c_template(// A pointer for an object of size n.
)w2c_template"
R"w2c_template(#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(#define MEM_ADDR(mem, addr, n) ((mem)->data_end - (addr) - (n))
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define MEM_ADDR(mem, addr, n) &((mem)->data[addr])
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
// We can only use Segue for this module if it uses a single unshared imported
)w2c_template"
R"w2c_template(// or exported memory
)w2c_template"
R"w2c_template(#if WASM_RT_USE_SEGUE && IS_SINGLE_UNSHARED_MEMORY
)w2c_template"
R"w2c_template(#define WASM_RT_USE_SEGUE_FOR_THIS_MODULE 1
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define WASM_RT_USE_SEGUE_FOR_THIS_MODULE 0
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#if WASM_RT_USE_SEGUE_FOR_THIS_MODULE
)w2c_template"
R"w2c_template(// POSIX uses FS for TLS, GS is free
)w2c_template"
R"w2c_template(static inline void* wasm_rt_segue_read_base() {
)w2c_template"
R"w2c_template(  if (wasm_rt_fsgsbase_inst_supported) {
)w2c_template"
R"w2c_template(    return (void*)__builtin_ia32_rdgsbase64();
)w2c_template"
R"w2c_template(  } else {
)w2c_template"
R"w2c_template(    return wasm_rt_syscall_get_segue_base();
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(static inline void wasm_rt_segue_write_base(void* base) {
)w2c_template"
R"w2c_template(#if WASM_RT_SEGUE_FREE_SEGMENT
)w2c_template"
R"w2c_template(  if (wasm_rt_last_segment_val == base) {
)w2c_template"
R"w2c_template(    return;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
  wasm_rt_last_segment_val = base;
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
  if (wasm_rt_fsgsbase_inst_supported) {
)w2c_template"
R"w2c_template(    __builtin_ia32_wrgsbase64((uintptr_t)base);
)w2c_template"
R"w2c_template(  } else {
)w2c_template"
R"w2c_template(    wasm_rt_syscall_set_segue_base(base);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(#define MEM_ADDR_MEMOP(mem, addr, n) ((uint8_t __seg_gs*)(uintptr_t)addr)
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define MEM_ADDR_MEMOP(mem, addr, n) MEM_ADDR(mem, addr, n)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#define TRAP(x) (wasm_rt_trap(WASM_RT_TRAP_##x), 0)
)w2c_template"
R"w2c_template(
#if WASM_RT_STACK_DEPTH_COUNT
)w2c_template"
R"w2c_template(#define FUNC_PROLOGUE                                            \
)w2c_template"
R"w2c_template(  if (++wasm_rt_call_stack_depth > WASM_RT_MAX_CALL_STACK_DEPTH) \
)w2c_template"
R"w2c_template(    TRAP(EXHAUSTION);
)w2c_template"
R"w2c_template(
#define FUNC_EPILOGUE --wasm_rt_call_stack_depth
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define FUNC_PROLOGUE
)w2c_template"
R"w2c_template(
#define FUNC_EPILOGUE
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#define UNREACHABLE TRAP(UNREACHABLE)
)w2c_template"
R"w2c_template(
static inline bool func_types_eq(const wasm_rt_func_type_t a,
)w2c_template"
R"w2c_template(                                 const wasm_rt_func_type_t b) {
)w2c_template"
R"w2c_template(  return (a == b) || LIKELY(a && b && !memcmp(a, b, 32));
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define CHECK_CALL_INDIRECT(table, ft, x)                \
)w2c_template"
R"w2c_template(  (LIKELY((x) < table.size && table.data[x].func &&      \
)w2c_template"
R"w2c_template(          func_types_eq(ft, table.data[x].func_type)) || \
)w2c_template"
R"w2c_template(   TRAP(CALL_INDIRECT))
)w2c_template"
R"w2c_template(
#define DO_CALL_INDIRECT(table, t, x, ...) ((t)table.data[x].func)(__VA_ARGS__)
)w2c_template"
R"w2c_template(
#define CALL_INDIRECT(table, t, ft, x, ...) \
)w2c_template"
R"w2c_template(  (CHECK_CALL_INDIRECT(table, ft, x),       \
)w2c_template"
R"w2c_template(   DO_CALL_INDIRECT(table, t, x, __VA_ARGS__))
)w2c_template"
R"w2c_template(
static inline bool add_overflow(uint64_t a, uint64_t b, uint64_t* resptr) {
)w2c_template"
R"w2c_template(#if __has_builtin(__builtin_add_overflow)
)w2c_template"
R"w2c_template(  return __builtin_add_overflow(a, b, resptr);
)w2c_template"
R"w2c_template(#elif defined(_MSC_VER)
)w2c_template"
R"w2c_template(  return _addcarry_u64(0, a, b, resptr);
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#error "Missing implementation of __builtin_add_overflow or _addcarry_u64"
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define RANGE_CHECK(mem, offset, len)              \
)w2c_template"
R"w2c_template(  do {                                             \
)w2c_template"
R"w2c_template(    uint64_t res;                                  \
)w2c_template"
R"w2c_template(    if (UNLIKELY(add_overflow(offset, len, &res))) \
)w2c_template"
R"w2c_template(      TRAP(OOB);                                   \
)w2c_template"
R"w2c_template(    if (UNLIKELY(res > (mem)->size))               \
)w2c_template"
R"w2c_template(      TRAP(OOB);                                   \
)w2c_template"
R"w2c_template(  } while (0);
)w2c_template"
R"w2c_template(
#if WASM_RT_USE_SEGUE_FOR_THIS_MODULE && WASM_RT_SANITY_CHECKS
)w2c_template"
R"w2c_template(#include <stdio.h>
)w2c_template"
R"w2c_template(#define WASM_RT_CHECK_BASE(mem)                                               \
)w2c_template"
R"w2c_template(  if (((uintptr_t)((mem)->data)) != ((uintptr_t)wasm_rt_segue_read_base())) { \
)w2c_template"
R"w2c_template(    puts("Segment register mismatch\n");                                      \
)w2c_template"
R"w2c_template(    abort();                                                                  \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define WASM_RT_CHECK_BASE(mem)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
// MEMCHECK_DEFAULT32 is an "accelerated" MEMCHECK used only for
)w2c_template"
R"w2c_template(// default-page-size, 32-bit memories. It may do nothing at all
)w2c_template"
R"w2c_template(// (if hardware bounds-checking is enabled via guard pages)
)w2c_template"
R"w2c_template(// or it may do a slightly faster RANGE_CHECK.
)w2c_template"
R"w2c_template(#if WASM_RT_MEMCHECK_GUARD_PAGES
)w2c_template"
R"w2c_template(#define MEMCHECK_DEFAULT32(mem, a, t) WASM_RT_CHECK_BASE(mem);
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define MEMCHECK_DEFAULT32(mem, a, t)                \
)w2c_template"
R"w2c_template(  WASM_RT_CHECK_BASE(mem);                           \
)w2c_template"
R"w2c_template(  if (UNLIKELY(a + (uint64_t)sizeof(t) > mem->size)) \
)w2c_template"
R"w2c_template(    TRAP(OOB);
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
// MEMCHECK_GENERAL can be used for any memory
)w2c_template"
R"w2c_template(#define MEMCHECK_GENERAL(mem, a, t) \
)w2c_template"
R"w2c_template(  WASM_RT_CHECK_BASE(mem);          \
)w2c_template"
R"w2c_template(  RANGE_CHECK(mem, a, sizeof(t));
)w2c_template"
R"w2c_template(
#ifdef __GNUC__
)w2c_template"
R"w2c_template(#define FORCE_READ_INT(var) __asm__("" ::"r"(var));
)w2c_template"
R"w2c_template(// Clang on Mips requires "f" constraints on floats
)w2c_template"
R"w2c_template(// See https://github.com/llvm/llvm-project/issues/64241
)w2c_template"
R"w2c_template(#if defined(__clang__) && \
)w2c_template"
R"w2c_template(    (defined(mips) || defined(__mips__) || defined(__mips))
)w2c_template"
R"w2c_template(#define FORCE_READ_FLOAT(var) __asm__("" ::"f"(var));
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define FORCE_READ_FLOAT(var) __asm__("" ::"r"(var));
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define FORCE_READ_INT(var)
)w2c_template"
R"w2c_template(#define FORCE_READ_FLOAT(var)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
static inline void load_data(u8* dest, const u8* src, size_t n) {
)w2c_template"
R"w2c_template(  if (!n) {
)w2c_template"
R"w2c_template(    return;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(  for (size_t i = 0; i < n; i++) {
)w2c_template"
R"w2c_template(    dest[i] = src[n - i - 1];
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(  wasm_rt_memcpy(dest, src, n);
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define LOAD_DATA(m, o, i, s)            \
)w2c_template"
R"w2c_template(  do {                                   \
)w2c_template"
R"w2c_template(    RANGE_CHECK((&m), o, s);             \
)w2c_template"
R"w2c_template(    load_data(MEM_ADDR(&m, o, s), i, s); \
)w2c_template"
R"w2c_template(  } while (0)
)w2c_template"
R"w2c_template(
#define DEF_MEM_CHECKS0(name, shared, mem_type, ret_kw, return_type)         \
)w2c_template"
R"w2c_template(  static inline return_type name##_default32(wasm_rt##shared##memory_t* mem, \
)w2c_template"
R"w2c_template(                                             u64 addr) {                     \
)w2c_template"
R"w2c_template(    MEMCHECK_DEFAULT32(mem, addr, mem_type);                                 \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr);                                      \
)w2c_template"
R"w2c_template(  }                                                                          \
)w2c_template"
R"w2c_template(  static inline return_type name(wasm_rt##shared##memory_t* mem, u64 addr) { \
)w2c_template"
R"w2c_template(    MEMCHECK_GENERAL(mem, addr, mem_type);                                   \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr);                                      \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
#define DEF_MEM_CHECKS1(name, shared, mem_type, ret_kw, return_type,         \
)w2c_template"
R"w2c_template(                        val_type1)                                           \
)w2c_template"
R"w2c_template(  static inline return_type name##_default32(wasm_rt##shared##memory_t* mem, \
)w2c_template"
R"w2c_template(                                             u64 addr, val_type1 val1) {     \
)w2c_template"
R"w2c_template(    MEMCHECK_DEFAULT32(mem, addr, mem_type);                                 \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr, val1);                                \
)w2c_template"
R"w2c_template(  }                                                                          \
)w2c_template"
R"w2c_template(  static inline return_type name(wasm_rt##shared##memory_t* mem, u64 addr,   \
)w2c_template"
R"w2c_template(                                 val_type1 val1) {                           \
)w2c_template"
R"w2c_template(    MEMCHECK_GENERAL(mem, addr, mem_type);                                   \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr, val1);                                \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
#define DEF_MEM_CHECKS2(name, shared, mem_type, ret_kw, return_type,         \
)w2c_template"
R"w2c_template(                        val_type1, val_type2)                                \
)w2c_template"
R"w2c_template(  static inline return_type name##_default32(wasm_rt##shared##memory_t* mem, \
)w2c_template"
R"w2c_template(                                             u64 addr, val_type1 val1,       \
)w2c_template"
R"w2c_template(                                             val_type2 val2) {               \
)w2c_template"
R"w2c_template(    MEMCHECK_DEFAULT32(mem, addr, mem_type);                                 \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr, val1, val2);                          \
)w2c_template"
R"w2c_template(  }                                                                          \
)w2c_template"
R"w2c_template(  static inline return_type name(wasm_rt##shared##memory_t* mem, u64 addr,   \
)w2c_template"
R"w2c_template(                                 val_type1 val1, val_type2 val2) {           \
)w2c_template"
R"w2c_template(    MEMCHECK_GENERAL(mem, addr, mem_type);                                   \
)w2c_template"
R"w2c_template(    ret_kw name##_unchecked(mem, addr, val1, val2);                          \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
#define DEFINE_LOAD(name, t1, t2, t3, force_read)                      \
)w2c_template"
R"w2c_template(  static inline t3 name##_unchecked(wasm_rt_memory_t* mem, u64 addr) { \
)w2c_template"
R"w2c_template(    t1 result;                                                         \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&result, MEM_ADDR_MEMOP(mem, addr, sizeof(t1)),     \
)w2c_template"
R"w2c_template(                   sizeof(t1));                                        \
)w2c_template"
R"w2c_template(    force_read(result);                                                \
)w2c_template"
R"w2c_template(    return (t3)(t2)result;                                             \
)w2c_template"
R"w2c_template(  }                                                                    \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS0(name, _, t1, return, t3)
)w2c_template"
R"w2c_template(
#define DEFINE_STORE(name, t1, t2)                                     \
)w2c_template"
R"w2c_template(  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
)w2c_template"
R"w2c_template(                                      t2 value) {                      \
)w2c_template"
R"w2c_template(    t1 wrapped = (t1)value;                                            \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(MEM_ADDR_MEMOP(mem, addr, sizeof(t1)), &wrapped,    \
)w2c_template"
R"w2c_template(                   sizeof(t1));                                        \
)w2c_template"
R"w2c_template(  }                                                                    \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t1, , void, t2)
)w2c_template"
R"w2c_template(
DEFINE_LOAD(i32_load, u32, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load, u64, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(f32_load, f32, f32, f32, FORCE_READ_FLOAT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(f64_load, f64, f64, f64, FORCE_READ_FLOAT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i32_load8_s, s8, s32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load8_s, s8, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i32_load8_u, u8, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load8_u, u8, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i32_load16_s, s16, s32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load16_s, s16, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i32_load16_u, u16, u32, u32, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load16_u, u16, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load32_s, s32, s64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_LOAD(i64_load32_u, u32, u64, u64, FORCE_READ_INT)
)w2c_template"
R"w2c_template(DEFINE_STORE(i32_store, u32, u32)
)w2c_template"
R"w2c_template(DEFINE_STORE(i64_store, u64, u64)
)w2c_template"
R"w2c_template(DEFINE_STORE(f32_store, f32, f32)
)w2c_template"
R"w2c_template(DEFINE_STORE(f64_store, f64, f64)
)w2c_template"
R"w2c_template(DEFINE_STORE(i32_store8, u8, u32)
)w2c_template"
R"w2c_template(DEFINE_STORE(i32_store16, u16, u32)
)w2c_template"
R"w2c_template(DEFINE_STORE(i64_store8, u8, u64)
)w2c_template"
R"w2c_template(DEFINE_STORE(i64_store16, u16, u64)
)w2c_template"
R"w2c_template(DEFINE_STORE(i64_store32, u32, u64)
)w2c_template"
R"w2c_template(
#if defined(_MSC_VER)
)w2c_template"
R"w2c_template(
// Adapted from
)w2c_template"
R"w2c_template(// https://github.com/nemequ/portable-snippets/blob/master/builtin/builtin.h
)w2c_template"
R"w2c_template(
static inline int I64_CLZ(unsigned long long v) {
)w2c_template"
R"w2c_template(  unsigned long r = 0;
)w2c_template"
R"w2c_template(#if defined(_M_AMD64) || defined(_M_ARM)
)w2c_template"
R"w2c_template(  if (_BitScanReverse64(&r, v)) {
)w2c_template"
R"w2c_template(    return 63 - r;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(  if (_BitScanReverse(&r, (unsigned long)(v >> 32))) {
)w2c_template"
R"w2c_template(    return 31 - r;
)w2c_template"
R"w2c_template(  } else if (_BitScanReverse(&r, (unsigned long)v)) {
)w2c_template"
R"w2c_template(    return 63 - r;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(  return 64;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline int I32_CLZ(unsigned long v) {
)w2c_template"
R"w2c_template(  unsigned long r = 0;
)w2c_template"
R"w2c_template(  if (_BitScanReverse(&r, v)) {
)w2c_template"
R"w2c_template(    return 31 - r;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return 32;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline int I64_CTZ(unsigned long long v) {
)w2c_template"
R"w2c_template(  if (!v) {
)w2c_template"
R"w2c_template(    return 64;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  unsigned long r = 0;
)w2c_template"
R"w2c_template(#if defined(_M_AMD64) || defined(_M_ARM)
)w2c_template"
R"w2c_template(  _BitScanForward64(&r, v);
)w2c_template"
R"w2c_template(  return (int)r;
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(  if (_BitScanForward(&r, (unsigned int)(v))) {
)w2c_template"
R"w2c_template(    return (int)(r);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
  _BitScanForward(&r, (unsigned int)(v >> 32));
)w2c_template"
R"w2c_template(  return (int)(r + 32);
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline int I32_CTZ(unsigned long v) {
)w2c_template"
R"w2c_template(  if (!v) {
)w2c_template"
R"w2c_template(    return 32;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  unsigned long r = 0;
)w2c_template"
R"w2c_template(  _BitScanForward(&r, v);
)w2c_template"
R"w2c_template(  return (int)r;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define POPCOUNT_DEFINE_PORTABLE(f_n, T)                            \
)w2c_template"
R"w2c_template(  static inline u32 f_n(T x) {                                      \
)w2c_template"
R"w2c_template(    x = x - ((x >> 1) & (T) ~(T)0 / 3);                             \
)w2c_template"
R"w2c_template(    x = (x & (T) ~(T)0 / 15 * 3) + ((x >> 2) & (T) ~(T)0 / 15 * 3); \
)w2c_template"
R"w2c_template(    x = (x + (x >> 4)) & (T) ~(T)0 / 255 * 15;                      \
)w2c_template"
R"w2c_template(    return (T)(x * ((T) ~(T)0 / 255)) >> (sizeof(T) - 1) * 8;       \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
POPCOUNT_DEFINE_PORTABLE(I32_POPCNT, u32)
)w2c_template"
R"w2c_template(POPCOUNT_DEFINE_PORTABLE(I64_POPCNT, u64)
)w2c_template"
R"w2c_template(
#undef POPCOUNT_DEFINE_PORTABLE
)w2c_template"
R"w2c_template(
#else
)w2c_template"
R"w2c_template(
#define I32_CLZ(x) ((x) ? __builtin_clz(x) : 32)
)w2c_template"
R"w2c_template(#define I64_CLZ(x) ((x) ? __builtin_clzll(x) : 64)
)w2c_template"
R"w2c_template(#define I32_CTZ(x) ((x) ? __builtin_ctz(x) : 32)
)w2c_template"
R"w2c_template(#define I64_CTZ(x) ((x) ? __builtin_ctzll(x) : 64)
)w2c_template"
R"w2c_template(#define I32_POPCNT(x) (__builtin_popcount(x))
)w2c_template"
R"w2c_template(#define I64_POPCNT(x) (__builtin_popcountll(x))
)w2c_template"
R"w2c_template(
#endif
)w2c_template"
R"w2c_template(
#define DIV_S(ut, min, x, y)                                  \
)w2c_template"
R"w2c_template(  ((UNLIKELY((y) == 0))                  ? TRAP(DIV_BY_ZERO)  \
)w2c_template"
R"w2c_template(   : (UNLIKELY((x) == min && (y) == -1)) ? TRAP(INT_OVERFLOW) \
)w2c_template"
R"w2c_template(                                         : (ut)((x) / (y)))
)w2c_template"
R"w2c_template(
#define REM_S(ut, min, x, y)                                 \
)w2c_template"
R"w2c_template(  ((UNLIKELY((y) == 0))                  ? TRAP(DIV_BY_ZERO) \
)w2c_template"
R"w2c_template(   : (UNLIKELY((x) == min && (y) == -1)) ? 0                 \
)w2c_template"
R"w2c_template(                                         : (ut)((x) % (y)))
)w2c_template"
R"w2c_template(
#define I32_DIV_S(x, y) DIV_S(u32, INT32_MIN, (s32)x, (s32)y)
)w2c_template"
R"w2c_template(#define I64_DIV_S(x, y) DIV_S(u64, INT64_MIN, (s64)x, (s64)y)
)w2c_template"
R"w2c_template(#define I32_REM_S(x, y) REM_S(u32, INT32_MIN, (s32)x, (s32)y)
)w2c_template"
R"w2c_template(#define I64_REM_S(x, y) REM_S(u64, INT64_MIN, (s64)x, (s64)y)
)w2c_template"
R"w2c_template(
#define DIVREM_U(op, x, y) \
)w2c_template"
R"w2c_template(  ((UNLIKELY((y) == 0)) ? TRAP(DIV_BY_ZERO) : ((x)op(y)))
)w2c_template"
R"w2c_template(
#define DIV_U(x, y) DIVREM_U(/, x, y)
)w2c_template"
R"w2c_template(#define REM_U(x, y) DIVREM_U(%, x, y)
)w2c_template"
R"w2c_template(
#define ROTL(x, y, mask) \
)w2c_template"
R"w2c_template(  (((x) << ((y) & (mask))) | ((x) >> (((mask) - (y) + 1) & (mask))))
)w2c_template"
R"w2c_template(#define ROTR(x, y, mask) \
)w2c_template"
R"w2c_template(  (((x) >> ((y) & (mask))) | ((x) << (((mask) - (y) + 1) & (mask))))
)w2c_template"
R"w2c_template(
#define I32_ROTL(x, y) ROTL(x, y, 31)
)w2c_template"
R"w2c_template(#define I64_ROTL(x, y) ROTL(x, y, 63)
)w2c_template"
R"w2c_template(#define I32_ROTR(x, y) ROTR(x, y, 31)
)w2c_template"
R"w2c_template(#define I64_ROTR(x, y) ROTR(x, y, 63)
)w2c_template"
R"w2c_template(
#define FMIN(x, y)                                           \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))             ? NAN                  \
)w2c_template"
R"w2c_template(   : (UNLIKELY((y) != (y)))           ? NAN                  \
)w2c_template"
R"w2c_template(   : (UNLIKELY((x) == 0 && (y) == 0)) ? (signbit(x) ? x : y) \
)w2c_template"
R"w2c_template(   : (x < y)                          ? x                    \
)w2c_template"
R"w2c_template(                                      : y)
)w2c_template"
R"w2c_template(
#define FMAX(x, y)                                           \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))             ? NAN                  \
)w2c_template"
R"w2c_template(   : (UNLIKELY((y) != (y)))           ? NAN                  \
)w2c_template"
R"w2c_template(   : (UNLIKELY((x) == 0 && (y) == 0)) ? (signbit(x) ? y : x) \
)w2c_template"
R"w2c_template(   : (x > y)                          ? x                    \
)w2c_template"
R"w2c_template(                                      : y)
)w2c_template"
R"w2c_template(
#define TRUNC_S(ut, st, ft, min, minop, max, x)                             \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))                        ? TRAP(INVALID_CONVERSION) \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x)minop(min) && (x) < (max)))) ? TRAP(INT_OVERFLOW)       \
)w2c_template"
R"w2c_template(                                                 : (ut)(st)(x))
)w2c_template"
R"w2c_template(
#define I32_TRUNC_S_F32(x) \
)w2c_template"
R"w2c_template(  TRUNC_S(u32, s32, f32, (f32)INT32_MIN, >=, 2147483648.f, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_S_F32(x) \
)w2c_template"
R"w2c_template(  TRUNC_S(u64, s64, f32, (f32)INT64_MIN, >=, (f32)INT64_MAX, x)
)w2c_template"
R"w2c_template(#define I32_TRUNC_S_F64(x) \
)w2c_template"
R"w2c_template(  TRUNC_S(u32, s32, f64, -2147483649., >, 2147483648., x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_S_F64(x) \
)w2c_template"
R"w2c_template(  TRUNC_S(u64, s64, f64, (f64)INT64_MIN, >=, (f64)INT64_MAX, x)
)w2c_template"
R"w2c_template(
#define TRUNC_U(ut, ft, max, x)                                              \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))                         ? TRAP(INVALID_CONVERSION) \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x) > (ft) - 1 && (x) < (max)))) ? TRAP(INT_OVERFLOW)       \
)w2c_template"
R"w2c_template(                                                  : (ut)(x))
)w2c_template"
R"w2c_template(
#define I32_TRUNC_U_F32(x) TRUNC_U(u32, f32, 4294967296.f, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_U_F32(x) TRUNC_U(u64, f32, (f32)UINT64_MAX, x)
)w2c_template"
R"w2c_template(#define I32_TRUNC_U_F64(x) TRUNC_U(u32, f64, 4294967296., x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_U_F64(x) TRUNC_U(u64, f64, (f64)UINT64_MAX, x)
)w2c_template"
R"w2c_template(
#define TRUNC_SAT_S(ut, st, ft, min, smin, minop, max, smax, x) \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))         ? 0                           \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x)minop(min)))) ? smin                        \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x) < (max))))   ? smax                        \
)w2c_template"
R"w2c_template(                                  : (ut)(st)(x))
)w2c_template"
R"w2c_template(
#define I32_TRUNC_SAT_S_F32(x)                                            \
)w2c_template"
R"w2c_template(  TRUNC_SAT_S(u32, s32, f32, (f32)INT32_MIN, INT32_MIN, >=, 2147483648.f, \
)w2c_template"
R"w2c_template(              INT32_MAX, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_SAT_S_F32(x)                                              \
)w2c_template"
R"w2c_template(  TRUNC_SAT_S(u64, s64, f32, (f32)INT64_MIN, INT64_MIN, >=, (f32)INT64_MAX, \
)w2c_template"
R"w2c_template(              INT64_MAX, x)
)w2c_template"
R"w2c_template(#define I32_TRUNC_SAT_S_F64(x)                                        \
)w2c_template"
R"w2c_template(  TRUNC_SAT_S(u32, s32, f64, -2147483649., INT32_MIN, >, 2147483648., \
)w2c_template"
R"w2c_template(              INT32_MAX, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_SAT_S_F64(x)                                              \
)w2c_template"
R"w2c_template(  TRUNC_SAT_S(u64, s64, f64, (f64)INT64_MIN, INT64_MIN, >=, (f64)INT64_MAX, \
)w2c_template"
R"w2c_template(              INT64_MAX, x)
)w2c_template"
R"w2c_template(
#define TRUNC_SAT_U(ut, ft, max, smax, x) \
)w2c_template"
R"w2c_template(  ((UNLIKELY((x) != (x)))          ? 0    \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x) > (ft) - 1))) ? 0    \
)w2c_template"
R"w2c_template(   : (UNLIKELY(!((x) < (max))))    ? smax \
)w2c_template"
R"w2c_template(                                   : (ut)(x))
)w2c_template"
R"w2c_template(
#define I32_TRUNC_SAT_U_F32(x) \
)w2c_template"
R"w2c_template(  TRUNC_SAT_U(u32, f32, 4294967296.f, UINT32_MAX, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_SAT_U_F32(x) \
)w2c_template"
R"w2c_template(  TRUNC_SAT_U(u64, f32, (f32)UINT64_MAX, UINT64_MAX, x)
)w2c_template"
R"w2c_template(#define I32_TRUNC_SAT_U_F64(x) TRUNC_SAT_U(u32, f64, 4294967296., UINT32_MAX, x)
)w2c_template"
R"w2c_template(#define I64_TRUNC_SAT_U_F64(x) \
)w2c_template"
R"w2c_template(  TRUNC_SAT_U(u64, f64, (f64)UINT64_MAX, UINT64_MAX, x)
)w2c_template"
R"w2c_template(
#define DEFINE_REINTERPRET(name, t1, t2)         \
)w2c_template"
R"w2c_template(  static inline t2 name(t1 x) {                  \
)w2c_template"
R"w2c_template(    t2 result;                                   \
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&result, &x, sizeof(result)); \
)w2c_template"
R"w2c_template(    return result;                               \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
DEFINE_REINTERPRET(f32_reinterpret_i32, u32, f32)
)w2c_template"
R"w2c_template(DEFINE_REINTERPRET(i32_reinterpret_f32, f32, u32)
)w2c_template"
R"w2c_template(DEFINE_REINTERPRET(f64_reinterpret_i64, u64, f64)
)w2c_template"
R"w2c_template(DEFINE_REINTERPRET(i64_reinterpret_f64, f64, u64)
)w2c_template"
R"w2c_template(
static float quiet_nanf(float x) {
)w2c_template"
R"w2c_template(  uint32_t tmp;
)w2c_template"
R"w2c_template(  wasm_rt_memcpy(&tmp, &x, 4);
)w2c_template"
R"w2c_template(  tmp |= 0x7fc00000lu;
)w2c_template"
R"w2c_template(  wasm_rt_memcpy(&x, &tmp, 4);
)w2c_template"
R"w2c_template(  return x;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double quiet_nan(double x) {
)w2c_template"
R"w2c_template(  uint64_t tmp;
)w2c_template"
R"w2c_template(  wasm_rt_memcpy(&tmp, &x, 8);
)w2c_template"
R"w2c_template(  tmp |= 0x7ff8000000000000llu;
)w2c_template"
R"w2c_template(  wasm_rt_memcpy(&x, &tmp, 8);
)w2c_template"
R"w2c_template(  return x;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_quiet(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return x;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_quietf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return x;
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_floor(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return floor(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_floorf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return floorf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_ceil(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return ceil(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_ceilf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return ceilf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_trunc(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return trunc(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_truncf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return truncf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_nearbyintf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return nearbyintf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_nearbyint(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return nearbyint(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_fabsf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    uint32_t tmp;
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&tmp, &x, 4);
)w2c_template"
R"w2c_template(    tmp = tmp & ~(1UL << 31);
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&x, &tmp, 4);
)w2c_template"
R"w2c_template(    return x;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return fabsf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_fabs(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    uint64_t tmp;
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&tmp, &x, 8);
)w2c_template"
R"w2c_template(    tmp = tmp & ~(1ULL << 63);
)w2c_template"
R"w2c_template(    wasm_rt_memcpy(&x, &tmp, 8);
)w2c_template"
R"w2c_template(    return x;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return fabs(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static double wasm_sqrt(double x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nan(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return sqrt(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static float wasm_sqrtf(float x) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(isnan(x))) {
)w2c_template"
R"w2c_template(    return quiet_nanf(x);
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(  return sqrtf(x);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline void memory_fill(wasm_rt_memory_t* mem, u64 d, u32 val, u64 n) {
)w2c_template"
R"w2c_template(  RANGE_CHECK(mem, d, n);
)w2c_template"
R"w2c_template(  memset(MEM_ADDR(mem, d, n), val, n);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline void memory_copy(wasm_rt_memory_t* dest,
)w2c_template"
R"w2c_template(                               const wasm_rt_memory_t* src,
)w2c_template"
R"w2c_template(                               u64 dest_addr,
)w2c_template"
R"w2c_template(                               u64 src_addr,
)w2c_template"
R"w2c_template(                               u64 n) {
)w2c_template"
R"w2c_template(  RANGE_CHECK(dest, dest_addr, n);
)w2c_template"
R"w2c_template(  RANGE_CHECK(src, src_addr, n);
)w2c_template"
R"w2c_template(  memmove(MEM_ADDR(dest, dest_addr, n), MEM_ADDR(src, src_addr, n), n);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
static inline void memory_init(wasm_rt_memory_t* dest,
)w2c_template"
R"w2c_template(                               const u8* src,
)w2c_template"
R"w2c_template(                               u32 src_size,
)w2c_template"
R"w2c_template(                               u64 dest_addr,
)w2c_template"
R"w2c_template(                               u32 src_addr,
)w2c_template"
R"w2c_template(                               u32 n) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(src_addr + (uint64_t)n > src_size))
)w2c_template"
R"w2c_template(    TRAP(OOB);
)w2c_template"
R"w2c_template(  LOAD_DATA((*dest), dest_addr, src + src_addr, n);
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
typedef enum { RefFunc, RefNull, GlobalGet } wasm_elem_segment_expr_type_t;
)w2c_template"
R"w2c_template(
typedef struct {
)w2c_template"
R"w2c_template(  wasm_elem_segment_expr_type_t expr_type;
)w2c_template"
R"w2c_template(  wasm_rt_func_type_t type;
)w2c_template"
R"w2c_template(  wasm_rt_function_ptr_t func;
)w2c_template"
R"w2c_template(  wasm_rt_tailcallee_t func_tailcallee;
)w2c_template"
R"w2c_template(  size_t module_offset;
)w2c_template"
R"w2c_template(} wasm_elem_segment_expr_t;
)w2c_template"
R"w2c_template(
static inline void funcref_table_init(wasm_rt_funcref_table_t* dest,
)w2c_template"
R"w2c_template(                                      const wasm_elem_segment_expr_t* src,
)w2c_template"
R"w2c_template(                                      u32 src_size,
)w2c_template"
R"w2c_template(                                      u64 dest_addr,
)w2c_template"
R"w2c_template(                                      u32 src_addr,
)w2c_template"
R"w2c_template(                                      u32 n,
)w2c_template"
R"w2c_template(                                      void* module_instance) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(src_addr + (uint64_t)n > src_size))
)w2c_template"
R"w2c_template(    TRAP(OOB);
)w2c_template"
R"w2c_template(  RANGE_CHECK(dest, dest_addr, n);
)w2c_template"
R"w2c_template(  for (u32 i = 0; i < n; i++) {
)w2c_template"
R"w2c_template(    const wasm_elem_segment_expr_t* const src_expr = &src[src_addr + i];
)w2c_template"
R"w2c_template(    wasm_rt_funcref_t* const dest_val = &(dest->data[dest_addr + i]);
)w2c_template"
R"w2c_template(    switch (src_expr->expr_type) {
)w2c_template"
R"w2c_template(      case RefFunc:
)w2c_template"
R"w2c_template(        *dest_val = (wasm_rt_funcref_t){
)w2c_template"
R"w2c_template(            src_expr->type, src_expr->func, src_expr->func_tailcallee,
)w2c_template"
R"w2c_template(            (char*)module_instance + src_expr->module_offset};
)w2c_template"
R"w2c_template(        break;
)w2c_template"
R"w2c_template(      case RefNull:
)w2c_template"
R"w2c_template(        *dest_val = wasm_rt_funcref_null_value;
)w2c_template"
R"w2c_template(        break;
)w2c_template"
R"w2c_template(      case GlobalGet:
)w2c_template"
R"w2c_template(        *dest_val = **(wasm_rt_funcref_t**)((char*)module_instance +
)w2c_template"
R"w2c_template(                                            src_expr->module_offset);
)w2c_template"
R"w2c_template(        break;
)w2c_template"
R"w2c_template(    }
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
// Currently wasm2c only supports initializing externref tables with ref.null.
)w2c_template"
R"w2c_template(static inline void externref_table_init(wasm_rt_externref_table_t* dest,
)w2c_template"
R"w2c_template(                                        u32 src_size,
)w2c_template"
R"w2c_template(                                        u64 dest_addr,
)w2c_template"
R"w2c_template(                                        u32 src_addr,
)w2c_template"
R"w2c_template(                                        u32 n) {
)w2c_template"
R"w2c_template(  if (UNLIKELY(src_addr + (uint64_t)n > src_size))
)w2c_template"
R"w2c_template(    TRAP(OOB);
)w2c_template"
R"w2c_template(  RANGE_CHECK(dest, dest_addr, n);
)w2c_template"
R"w2c_template(  for (u32 i = 0; i < n; i++) {
)w2c_template"
R"w2c_template(    dest->data[dest_addr + i] = wasm_rt_externref_null_value;
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(
#define DEFINE_TABLE_COPY(type)                                              \
)w2c_template"
R"w2c_template(  static inline void type##_table_copy(wasm_rt_##type##_table_t* dest,       \
)w2c_template"
R"w2c_template(                                       const wasm_rt_##type##_table_t* src,  \
)w2c_template"
R"w2c_template(                                       u64 dest_addr, u64 src_addr, u64 n) { \
)w2c_template"
R"w2c_template(    RANGE_CHECK(dest, dest_addr, n);                                         \
)w2c_template"
R"w2c_template(    RANGE_CHECK(src, src_addr, n);                                           \
)w2c_template"
R"w2c_template(    memmove(dest->data + dest_addr, src->data + src_addr,                    \
)w2c_template"
R"w2c_template(            n * sizeof(wasm_rt_##type##_t));                                 \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
DEFINE_TABLE_COPY(funcref)
)w2c_template"
R"w2c_template(DEFINE_TABLE_COPY(externref)
)w2c_template"
R"w2c_template(
#define DEFINE_TABLE_GET(type)                        \
)w2c_template"
R"w2c_template(  static inline wasm_rt_##type##_t type##_table_get(  \
)w2c_template"
R"w2c_template(      const wasm_rt_##type##_table_t* table, u64 i) { \
)w2c_template"
R"w2c_template(    if (UNLIKELY(i >= table->size))                   \
)w2c_template"
R"w2c_template(      TRAP(OOB);                                      \
)w2c_template"
R"w2c_template(    return table->data[i];                            \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
DEFINE_TABLE_GET(funcref)
)w2c_template"
R"w2c_template(DEFINE_TABLE_GET(externref)
)w2c_template"
R"w2c_template(
#define DEFINE_TABLE_SET(type)                                               \
)w2c_template"
R"w2c_template(  static inline void type##_table_set(const wasm_rt_##type##_table_t* table, \
)w2c_template"
R"w2c_template(                                      u64 i, const wasm_rt_##type##_t val) { \
)w2c_template"
R"w2c_template(    if (UNLIKELY(i >= table->size))                                          \
)w2c_template"
R"w2c_template(      TRAP(OOB);                                                             \
)w2c_template"
R"w2c_template(    table->data[i] = val;                                                    \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
DEFINE_TABLE_SET(funcref)
)w2c_template"
R"w2c_template(DEFINE_TABLE_SET(externref)
)w2c_template"
R"w2c_template(
#define DEFINE_TABLE_FILL(type)                                               \
)w2c_template"
R"w2c_template(  static inline void type##_table_fill(const wasm_rt_##type##_table_t* table, \
)w2c_template"
R"w2c_template(                                       u64 d, const wasm_rt_##type##_t val,   \
)w2c_template"
R"w2c_template(                                       u64 n) {                               \
)w2c_template"
R"w2c_template(    RANGE_CHECK(table, d, n);                                                 \
)w2c_template"
R"w2c_template(    for (uint32_t i = d; i < d + n; i++) {                                    \
)w2c_template"
R"w2c_template(      table->data[i] = val;                                                   \
)w2c_template"
R"w2c_template(    }                                                                         \
)w2c_template"
R"w2c_template(  }
)w2c_template"
R"w2c_template(
DEFINE_TABLE_FILL(funcref)
)w2c_template"
R"w2c_template(DEFINE_TABLE_FILL(externref)
)w2c_template"
R"w2c_template(
#if defined(__GNUC__) || defined(__clang__)
)w2c_template"
R"w2c_template(#define FUNC_TYPE_DECL_EXTERN_T(x) extern const char* const x
)w2c_template"
R"w2c_template(#define FUNC_TYPE_EXTERN_T(x) const char* const x
)w2c_template"
R"w2c_template(#define FUNC_TYPE_T(x) static const char* const x
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define FUNC_TYPE_DECL_EXTERN_T(x) extern const char x[]
)w2c_template"
R"w2c_template(#define FUNC_TYPE_EXTERN_T(x) const char x[]
)w2c_template"
R"w2c_template(#define FUNC_TYPE_T(x) static const char x[]
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#if (__STDC_VERSION__ < 201112L) && !defined(static_assert)
)w2c_template"
R"w2c_template(#define static_assert(X) \
)w2c_template"
R"w2c_template(  extern int(*assertion(void))[!!sizeof(struct { int x : (X) ? 2 : -1; })];
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#ifdef _MSC_VER
)w2c_template"
R"w2c_template(#define WEAK_FUNC_DECL(func, fallback)                             \
)w2c_template"
R"w2c_template(  __pragma(comment(linker, "/alternatename:" #func "=" #fallback)) \
)w2c_template"
R"w2c_template(                                                                   \
)w2c_template"
R"w2c_template(      void                                                         \
)w2c_template"
R"w2c_template(      fallback(void** instance_ptr, void* tail_call_stack,         \
)w2c_template"
R"w2c_template(               wasm_rt_tailcallee_t* next)
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define WEAK_FUNC_DECL(func, fallback)                                        \
)w2c_template"
R"w2c_template(  __attribute__((weak)) void func(void** instance_ptr, void* tail_call_stack, \
)w2c_template"
R"w2c_template(                                  wasm_rt_tailcallee_t* next)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
;
