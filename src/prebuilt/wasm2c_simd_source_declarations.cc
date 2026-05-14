const char* s_simd_source_declarations = R"w2c_template(#if defined(__GNUC__) && defined(__x86_64__)
)w2c_template"
R"w2c_template(#define SIMD_FORCE_READ(var) __asm__("" ::"x"(var));
)w2c_template"
R"w2c_template(#elif defined(__GNUC__) && defined(__aarch64__)
)w2c_template"
R"w2c_template(#define SIMD_FORCE_READ(var) __asm__("" ::"w"(var));
)w2c_template"
R"w2c_template(#elif defined(__s390x__)
)w2c_template"
R"w2c_template(#define SIMD_FORCE_READ(var) __asm__("" ::"d"(var));
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define SIMD_FORCE_READ(var)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(// TODO: equivalent constraint for ARM and other architectures
)w2c_template"
R"w2c_template(
#define DEFINE_SIMD_LOAD_FUNC(name, func, t)                             \
)w2c_template"
R"w2c_template(  static inline v128 name##_unchecked(wasm_rt_memory_t* mem, u64 addr) { \
)w2c_template"
R"w2c_template(    v128 result = func(MEM_ADDR(mem, addr, sizeof(t)));                  \
)w2c_template"
R"w2c_template(    SIMD_FORCE_READ(result);                                             \
)w2c_template"
R"w2c_template(    return result;                                                       \
)w2c_template"
R"w2c_template(  }                                                                      \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS0(name, _, t, return, v128);
)w2c_template"
R"w2c_template(
#define DEFINE_SIMD_LOAD_LANE(name, func, t, lane)                     \
)w2c_template"
R"w2c_template(  static inline v128 name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
)w2c_template"
R"w2c_template(                                      v128 vec) {                      \
)w2c_template"
R"w2c_template(    v128 result = func(MEM_ADDR(mem, addr, sizeof(t)), vec, lane);     \
)w2c_template"
R"w2c_template(    SIMD_FORCE_READ(result);                                           \
)w2c_template"
R"w2c_template(    return result;                                                     \
)w2c_template"
R"w2c_template(  }                                                                    \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t, return, v128, v128);
)w2c_template"
R"w2c_template(
#define DEFINE_SIMD_STORE(name, t)                                     \
)w2c_template"
R"w2c_template(  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
)w2c_template"
R"w2c_template(                                      v128 value) {                    \
)w2c_template"
R"w2c_template(    simde_wasm_v128_store(MEM_ADDR(mem, addr, sizeof(t)), value);      \
)w2c_template"
R"w2c_template(  }                                                                    \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t, , void, v128);
)w2c_template"
R"w2c_template(
#define DEFINE_SIMD_STORE_LANE(name, func, t, lane)                    \
)w2c_template"
R"w2c_template(  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
)w2c_template"
R"w2c_template(                                      v128 value) {                    \
)w2c_template"
R"w2c_template(    func(MEM_ADDR(mem, addr, sizeof(t)), value, lane);                 \
)w2c_template"
R"w2c_template(  }                                                                    \
)w2c_template"
R"w2c_template(  DEF_MEM_CHECKS1(name, _, t, , void, v128);
)w2c_template"
R"w2c_template(
// clang-format off
)w2c_template"
R"w2c_template(#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(static inline v128 v128_impl_load32_zero(const void* a) {
)w2c_template"
R"w2c_template(  return simde_wasm_i8x16_swizzle(
)w2c_template"
R"w2c_template(      simde_wasm_v128_load32_zero(a),
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3));
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(static inline v128 v128_impl_load64_zero(const void* a) {
)w2c_template"
R"w2c_template(  return simde_wasm_i8x16_swizzle(
)w2c_template"
R"w2c_template(      simde_wasm_v128_load64_zero(a),
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7));
)w2c_template"
R"w2c_template(}
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define v128_impl_load32_zero simde_wasm_v128_load32_zero
)w2c_template"
R"w2c_template(#define v128_impl_load64_zero simde_wasm_v128_load64_zero
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
DEFINE_SIMD_LOAD_FUNC(v128_load, simde_wasm_v128_load, v128)
)w2c_template"
R"w2c_template(
DEFINE_SIMD_LOAD_FUNC(v128_load8_splat, simde_wasm_v128_load8_splat, u8)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(v128_load16_splat, simde_wasm_v128_load16_splat, u16)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(v128_load32_splat, simde_wasm_v128_load32_splat, u32)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(v128_load64_splat, simde_wasm_v128_load64_splat, u64)
)w2c_template"
R"w2c_template(
DEFINE_SIMD_LOAD_FUNC(i16x8_load8x8, simde_wasm_i16x8_load8x8, u64)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(u16x8_load8x8, simde_wasm_u16x8_load8x8, u64)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(i32x4_load16x4, simde_wasm_i32x4_load16x4, u64)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(u32x4_load16x4, simde_wasm_u32x4_load16x4, u64)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(i64x2_load32x2, simde_wasm_i64x2_load32x2, u64)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(u64x2_load32x2, simde_wasm_u64x2_load32x2, u64)
)w2c_template"
R"w2c_template(
DEFINE_SIMD_LOAD_FUNC(v128_load32_zero, v128_impl_load32_zero, u32)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_FUNC(v128_load64_zero, v128_impl_load64_zero, u64)
)w2c_template"
R"w2c_template(
#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane0, simde_wasm_v128_load8_lane, u8, 15)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane1, simde_wasm_v128_load8_lane, u8, 14)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane2, simde_wasm_v128_load8_lane, u8, 13)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane3, simde_wasm_v128_load8_lane, u8, 12)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane4, simde_wasm_v128_load8_lane, u8, 11)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane5, simde_wasm_v128_load8_lane, u8, 10)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane6, simde_wasm_v128_load8_lane, u8, 9)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane7, simde_wasm_v128_load8_lane, u8, 8)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane8, simde_wasm_v128_load8_lane, u8, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane9, simde_wasm_v128_load8_lane, u8, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane10, simde_wasm_v128_load8_lane, u8, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane11, simde_wasm_v128_load8_lane, u8, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane12, simde_wasm_v128_load8_lane, u8, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane13, simde_wasm_v128_load8_lane, u8, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane14, simde_wasm_v128_load8_lane, u8, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane15, simde_wasm_v128_load8_lane, u8, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane0, simde_wasm_v128_load16_lane, u16, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane1, simde_wasm_v128_load16_lane, u16, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane2, simde_wasm_v128_load16_lane, u16, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane3, simde_wasm_v128_load16_lane, u16, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane4, simde_wasm_v128_load16_lane, u16, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane5, simde_wasm_v128_load16_lane, u16, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane6, simde_wasm_v128_load16_lane, u16, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane7, simde_wasm_v128_load16_lane, u16, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane0, simde_wasm_v128_load32_lane, u32, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane1, simde_wasm_v128_load32_lane, u32, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane2, simde_wasm_v128_load32_lane, u32, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane3, simde_wasm_v128_load32_lane, u32, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load64_lane0, simde_wasm_v128_load64_lane, u64, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load64_lane1, simde_wasm_v128_load64_lane, u64, 0)
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane0, simde_wasm_v128_load8_lane, u8, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane1, simde_wasm_v128_load8_lane, u8, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane2, simde_wasm_v128_load8_lane, u8, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane3, simde_wasm_v128_load8_lane, u8, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane4, simde_wasm_v128_load8_lane, u8, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane5, simde_wasm_v128_load8_lane, u8, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane6, simde_wasm_v128_load8_lane, u8, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane7, simde_wasm_v128_load8_lane, u8, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane8, simde_wasm_v128_load8_lane, u8, 8)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane9, simde_wasm_v128_load8_lane, u8, 9)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane10, simde_wasm_v128_load8_lane, u8, 10)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane11, simde_wasm_v128_load8_lane, u8, 11)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane12, simde_wasm_v128_load8_lane, u8, 12)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane13, simde_wasm_v128_load8_lane, u8, 13)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane14, simde_wasm_v128_load8_lane, u8, 14)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load8_lane15, simde_wasm_v128_load8_lane, u8, 15)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane0, simde_wasm_v128_load16_lane, u16, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane1, simde_wasm_v128_load16_lane, u16, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane2, simde_wasm_v128_load16_lane, u16, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane3, simde_wasm_v128_load16_lane, u16, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane4, simde_wasm_v128_load16_lane, u16, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane5, simde_wasm_v128_load16_lane, u16, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane6, simde_wasm_v128_load16_lane, u16, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load16_lane7, simde_wasm_v128_load16_lane, u16, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane0, simde_wasm_v128_load32_lane, u32, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane1, simde_wasm_v128_load32_lane, u32, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane2, simde_wasm_v128_load32_lane, u32, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load32_lane3, simde_wasm_v128_load32_lane, u32, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load64_lane0, simde_wasm_v128_load64_lane, u64, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_LOAD_LANE(v128_load64_lane1, simde_wasm_v128_load64_lane, u64, 1)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
DEFINE_SIMD_STORE(v128_store, v128)
)w2c_template"
R"w2c_template(
#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane0, simde_wasm_v128_store8_lane, u8, 15)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane1, simde_wasm_v128_store8_lane, u8, 14)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane2, simde_wasm_v128_store8_lane, u8, 13)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane3, simde_wasm_v128_store8_lane, u8, 12)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane4, simde_wasm_v128_store8_lane, u8, 11)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane5, simde_wasm_v128_store8_lane, u8, 10)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane6, simde_wasm_v128_store8_lane, u8, 9)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane7, simde_wasm_v128_store8_lane, u8, 8)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane8, simde_wasm_v128_store8_lane, u8, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane9, simde_wasm_v128_store8_lane, u8, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane10, simde_wasm_v128_store8_lane, u8, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane11, simde_wasm_v128_store8_lane, u8, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane12, simde_wasm_v128_store8_lane, u8, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane13, simde_wasm_v128_store8_lane, u8, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane14, simde_wasm_v128_store8_lane, u8, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane15, simde_wasm_v128_store8_lane, u8, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane0, simde_wasm_v128_store16_lane, u16, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane1, simde_wasm_v128_store16_lane, u16, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane2, simde_wasm_v128_store16_lane, u16, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane3, simde_wasm_v128_store16_lane, u16, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane4, simde_wasm_v128_store16_lane, u16, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane5, simde_wasm_v128_store16_lane, u16, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane6, simde_wasm_v128_store16_lane, u16, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane7, simde_wasm_v128_store16_lane, u16, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane0, simde_wasm_v128_store32_lane, u32, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane1, simde_wasm_v128_store32_lane, u32, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane2, simde_wasm_v128_store32_lane, u32, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane3, simde_wasm_v128_store32_lane, u32, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store64_lane0, simde_wasm_v128_store64_lane, u64, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store64_lane1, simde_wasm_v128_store64_lane, u64, 0)
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane0, simde_wasm_v128_store8_lane, u8, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane1, simde_wasm_v128_store8_lane, u8, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane2, simde_wasm_v128_store8_lane, u8, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane3, simde_wasm_v128_store8_lane, u8, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane4, simde_wasm_v128_store8_lane, u8, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane5, simde_wasm_v128_store8_lane, u8, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane6, simde_wasm_v128_store8_lane, u8, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane7, simde_wasm_v128_store8_lane, u8, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane8, simde_wasm_v128_store8_lane, u8, 8)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane9, simde_wasm_v128_store8_lane, u8, 9)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane10, simde_wasm_v128_store8_lane, u8, 10)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane11, simde_wasm_v128_store8_lane, u8, 11)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane12, simde_wasm_v128_store8_lane, u8, 12)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane13, simde_wasm_v128_store8_lane, u8, 13)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane14, simde_wasm_v128_store8_lane, u8, 14)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store8_lane15, simde_wasm_v128_store8_lane, u8, 15)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane0, simde_wasm_v128_store16_lane, u16, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane1, simde_wasm_v128_store16_lane, u16, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane2, simde_wasm_v128_store16_lane, u16, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane3, simde_wasm_v128_store16_lane, u16, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane4, simde_wasm_v128_store16_lane, u16, 4)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane5, simde_wasm_v128_store16_lane, u16, 5)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane6, simde_wasm_v128_store16_lane, u16, 6)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store16_lane7, simde_wasm_v128_store16_lane, u16, 7)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane0, simde_wasm_v128_store32_lane, u32, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane1, simde_wasm_v128_store32_lane, u32, 1)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane2, simde_wasm_v128_store32_lane, u32, 2)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store32_lane3, simde_wasm_v128_store32_lane, u32, 3)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store64_lane0, simde_wasm_v128_store64_lane, u64, 0)
)w2c_template"
R"w2c_template(DEFINE_SIMD_STORE_LANE(v128_store64_lane1, simde_wasm_v128_store64_lane, u64, 1)
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#if WABT_BIG_ENDIAN
)w2c_template"
R"w2c_template(#define v128_const(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) simde_wasm_i8x16_const(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
)w2c_template"
R"w2c_template(#define v128_i8x16_extract_lane(v, l) simde_wasm_i8x16_extract_lane(v, 15-(l))
)w2c_template"
R"w2c_template(#define v128_u8x16_extract_lane(v, l) simde_wasm_u8x16_extract_lane(v, 15-(l))
)w2c_template"
R"w2c_template(#define v128_i16x8_extract_lane(v, l) simde_wasm_i16x8_extract_lane(v, 7-(l))
)w2c_template"
R"w2c_template(#define v128_u16x8_extract_lane(v, l) simde_wasm_u16x8_extract_lane(v, 7-(l))
)w2c_template"
R"w2c_template(#define v128_i32x4_extract_lane(v, l) simde_wasm_i32x4_extract_lane(v, 3-(l))
)w2c_template"
R"w2c_template(#define v128_i64x2_extract_lane(v, l) simde_wasm_i64x2_extract_lane(v, 1-(l))
)w2c_template"
R"w2c_template(#define v128_f32x4_extract_lane(v, l) simde_wasm_f32x4_extract_lane(v, 3-(l))
)w2c_template"
R"w2c_template(#define v128_f64x2_extract_lane(v, l) simde_wasm_f64x2_extract_lane(v, 1-(l))
)w2c_template"
R"w2c_template(#define v128_i8x16_replace_lane(v, l, x) simde_wasm_i8x16_replace_lane(v, 15-(l), x)
)w2c_template"
R"w2c_template(#define v128_u8x16_replace_lane(v, l, x) simde_wasm_u8x16_replace_lane(v, 15-(l), x)
)w2c_template"
R"w2c_template(#define v128_i16x8_replace_lane(v, l, x) simde_wasm_i16x8_replace_lane(v, 7-(l), x)
)w2c_template"
R"w2c_template(#define v128_u16x8_replace_lane(v, l, x) simde_wasm_u16x8_replace_lane(v, 7-(l), x)
)w2c_template"
R"w2c_template(#define v128_i32x4_replace_lane(v, l, x) simde_wasm_i32x4_replace_lane(v, 3-(l), x)
)w2c_template"
R"w2c_template(#define v128_i64x2_replace_lane(v, l, x) simde_wasm_i64x2_replace_lane(v, 1-(l), x)
)w2c_template"
R"w2c_template(#define v128_f32x4_replace_lane(v, l, x) simde_wasm_f32x4_replace_lane(v, 3-(l), x)
)w2c_template"
R"w2c_template(#define v128_f64x2_replace_lane(v, l, x) simde_wasm_f64x2_replace_lane(v, 1-(l), x)
)w2c_template"
R"w2c_template(#define v128_i8x16_bitmask(v) simde_wasm_i8x16_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0)))
)w2c_template"
R"w2c_template(#define v128_i16x8_bitmask(v) simde_wasm_i16x8_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1)))
)w2c_template"
R"w2c_template(#define v128_i32x4_bitmask(v) simde_wasm_i32x4_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3)))
)w2c_template"
R"w2c_template(#define v128_i64x2_bitmask(v) simde_wasm_i64x2_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
)w2c_template"
R"w2c_template(#define v128_i8x16_swizzle(v1, v2) simde_wasm_i8x16_swizzle(v1, simde_wasm_v128_xor(v2, simde_wasm_i8x16_splat(15)))
)w2c_template"
R"w2c_template(#define v128_i8x16_shuffle(v1,v2,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) simde_wasm_i8x16_shuffle(v2,v1,31-(p),31-(o),31-(n),31-(m),31-(l),31-(k),31-(j),31-(i),31-(h),31-(g),31-(f),31-(e),31-(d),31-(c),31-(b),31-(a))
)w2c_template"
R"w2c_template(#define v128_i16x8_extmul_high_i8x16 simde_wasm_i16x8_extmul_low_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extmul_high_u8x16 simde_wasm_u16x8_extmul_low_u8x16
)w2c_template"
R"w2c_template(#define v128_i16x8_extmul_low_i8x16  simde_wasm_i16x8_extmul_high_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extmul_low_u8x16  simde_wasm_u16x8_extmul_high_u8x16
)w2c_template"
R"w2c_template(#define v128_i32x4_extmul_high_i16x8 simde_wasm_i32x4_extmul_low_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extmul_high_u16x8 simde_wasm_u32x4_extmul_low_u16x8
)w2c_template"
R"w2c_template(#define v128_i32x4_extmul_low_i16x8  simde_wasm_i32x4_extmul_high_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extmul_low_u16x8  simde_wasm_u32x4_extmul_high_u16x8
)w2c_template"
R"w2c_template(#define v128_i64x2_extmul_high_i32x4 simde_wasm_i64x2_extmul_low_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extmul_high_u32x4 simde_wasm_u64x2_extmul_low_u32x4
)w2c_template"
R"w2c_template(#define v128_i64x2_extmul_low_i32x4  simde_wasm_i64x2_extmul_high_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extmul_low_u32x4  simde_wasm_u64x2_extmul_high_u32x4
)w2c_template"
R"w2c_template(#define v128_i16x8_extend_high_i8x16 simde_wasm_i16x8_extend_low_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extend_high_u8x16 simde_wasm_u16x8_extend_low_u8x16
)w2c_template"
R"w2c_template(#define v128_i16x8_extend_low_i8x16  simde_wasm_i16x8_extend_high_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extend_low_u8x16  simde_wasm_u16x8_extend_high_u8x16
)w2c_template"
R"w2c_template(#define v128_i32x4_extend_high_i16x8 simde_wasm_i32x4_extend_low_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extend_high_u16x8 simde_wasm_u32x4_extend_low_u16x8
)w2c_template"
R"w2c_template(#define v128_i32x4_extend_low_i16x8  simde_wasm_i32x4_extend_high_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extend_low_u16x8  simde_wasm_u32x4_extend_high_u16x8
)w2c_template"
R"w2c_template(#define v128_i64x2_extend_high_i32x4 simde_wasm_i64x2_extend_low_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extend_high_u32x4 simde_wasm_u64x2_extend_low_u32x4
)w2c_template"
R"w2c_template(#define v128_i64x2_extend_low_i32x4  simde_wasm_i64x2_extend_high_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extend_low_u32x4  simde_wasm_u64x2_extend_high_u32x4
)w2c_template"
R"w2c_template(#define v128_i32x4_trunc_sat_f64x2_zero(a)      \
)w2c_template"
R"w2c_template(  simde_wasm_i8x16_swizzle(                     \
)w2c_template"
R"w2c_template(      simde_wasm_i32x4_trunc_sat_f64x2_zero(a), \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
)w2c_template"
R"w2c_template(#define v128_u32x4_trunc_sat_f64x2_zero(a)      \
)w2c_template"
R"w2c_template(  simde_wasm_i8x16_swizzle(                     \
)w2c_template"
R"w2c_template(      simde_wasm_u32x4_trunc_sat_f64x2_zero(a), \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
)w2c_template"
R"w2c_template(#define v128_i16x8_narrow_i32x4(a,b) simde_wasm_i16x8_narrow_i32x4(b,a)
)w2c_template"
R"w2c_template(#define v128_u16x8_narrow_i32x4(a,b) simde_wasm_u16x8_narrow_i32x4(b,a)
)w2c_template"
R"w2c_template(#define v128_i8x16_narrow_i16x8(a,b) simde_wasm_i8x16_narrow_i16x8(b,a)
)w2c_template"
R"w2c_template(#define v128_u8x16_narrow_i16x8(a,b) simde_wasm_u8x16_narrow_i16x8(b,a)
)w2c_template"
R"w2c_template(#define v128_f64x2_promote_low_f32x4(a)                        \
)w2c_template"
R"w2c_template(  simde_wasm_f64x2_promote_low_f32x4(simde_wasm_i8x16_swizzle( \
)w2c_template"
R"w2c_template(      a,                                                       \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
)w2c_template"
R"w2c_template(#define v128_f32x4_demote_f64x2_zero(a)      \
)w2c_template"
R"w2c_template(  simde_wasm_i8x16_swizzle(                  \
)w2c_template"
R"w2c_template(      simde_wasm_f32x4_demote_f64x2_zero(a), \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
)w2c_template"
R"w2c_template(#define v128_f64x2_convert_low_i32x4(a)                        \
)w2c_template"
R"w2c_template(  simde_wasm_f64x2_convert_low_i32x4(simde_wasm_i8x16_swizzle( \
)w2c_template"
R"w2c_template(      a,                                                       \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
)w2c_template"
R"w2c_template(#define v128_f64x2_convert_low_u32x4(a)                        \
)w2c_template"
R"w2c_template(  simde_wasm_f64x2_convert_low_u32x4(simde_wasm_i8x16_swizzle( \
)w2c_template"
R"w2c_template(      a,                                                       \
)w2c_template"
R"w2c_template(      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
)w2c_template"
R"w2c_template(#else
)w2c_template"
R"w2c_template(#define v128_const simde_wasm_i8x16_const
)w2c_template"
R"w2c_template(#define v128_i8x16_extract_lane simde_wasm_i8x16_extract_lane
)w2c_template"
R"w2c_template(#define v128_u8x16_extract_lane simde_wasm_u8x16_extract_lane
)w2c_template"
R"w2c_template(#define v128_i16x8_extract_lane simde_wasm_i16x8_extract_lane
)w2c_template"
R"w2c_template(#define v128_u16x8_extract_lane simde_wasm_u16x8_extract_lane
)w2c_template"
R"w2c_template(#define v128_i32x4_extract_lane simde_wasm_i32x4_extract_lane
)w2c_template"
R"w2c_template(#define v128_i64x2_extract_lane simde_wasm_i64x2_extract_lane
)w2c_template"
R"w2c_template(#define v128_f32x4_extract_lane simde_wasm_f32x4_extract_lane
)w2c_template"
R"w2c_template(#define v128_f64x2_extract_lane simde_wasm_f64x2_extract_lane
)w2c_template"
R"w2c_template(#define v128_i8x16_replace_lane simde_wasm_i8x16_replace_lane
)w2c_template"
R"w2c_template(#define v128_u8x16_replace_lane simde_wasm_u8x16_replace_lane
)w2c_template"
R"w2c_template(#define v128_i16x8_replace_lane simde_wasm_i16x8_replace_lane
)w2c_template"
R"w2c_template(#define v128_u16x8_replace_lane simde_wasm_u16x8_replace_lane
)w2c_template"
R"w2c_template(#define v128_i32x4_replace_lane simde_wasm_i32x4_replace_lane
)w2c_template"
R"w2c_template(#define v128_i64x2_replace_lane simde_wasm_i64x2_replace_lane
)w2c_template"
R"w2c_template(#define v128_f32x4_replace_lane simde_wasm_f32x4_replace_lane
)w2c_template"
R"w2c_template(#define v128_f64x2_replace_lane simde_wasm_f64x2_replace_lane
)w2c_template"
R"w2c_template(#define v128_i8x16_bitmask simde_wasm_i8x16_bitmask
)w2c_template"
R"w2c_template(#define v128_i16x8_bitmask simde_wasm_i16x8_bitmask
)w2c_template"
R"w2c_template(#define v128_i32x4_bitmask simde_wasm_i32x4_bitmask
)w2c_template"
R"w2c_template(#define v128_i64x2_bitmask simde_wasm_i64x2_bitmask
)w2c_template"
R"w2c_template(#define v128_i8x16_swizzle simde_wasm_i8x16_swizzle
)w2c_template"
R"w2c_template(#define v128_i8x16_shuffle simde_wasm_i8x16_shuffle
)w2c_template"
R"w2c_template(#define v128_i16x8_extmul_high_i8x16 simde_wasm_i16x8_extmul_high_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extmul_high_u8x16 simde_wasm_u16x8_extmul_high_u8x16
)w2c_template"
R"w2c_template(#define v128_i16x8_extmul_low_i8x16  simde_wasm_i16x8_extmul_low_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extmul_low_u8x16  simde_wasm_u16x8_extmul_low_u8x16
)w2c_template"
R"w2c_template(#define v128_i32x4_extmul_high_i16x8 simde_wasm_i32x4_extmul_high_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extmul_high_u16x8 simde_wasm_u32x4_extmul_high_u16x8
)w2c_template"
R"w2c_template(#define v128_i32x4_extmul_low_i16x8  simde_wasm_i32x4_extmul_low_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extmul_low_u16x8  simde_wasm_u32x4_extmul_low_u16x8
)w2c_template"
R"w2c_template(#define v128_i64x2_extmul_high_i32x4 simde_wasm_i64x2_extmul_high_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extmul_high_u32x4 simde_wasm_u64x2_extmul_high_u32x4
)w2c_template"
R"w2c_template(#define v128_i64x2_extmul_low_i32x4  simde_wasm_i64x2_extmul_low_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extmul_low_u32x4  simde_wasm_u64x2_extmul_low_u32x4
)w2c_template"
R"w2c_template(#define v128_i16x8_extend_high_i8x16 simde_wasm_i16x8_extend_high_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extend_high_u8x16 simde_wasm_u16x8_extend_high_u8x16
)w2c_template"
R"w2c_template(#define v128_i16x8_extend_low_i8x16  simde_wasm_i16x8_extend_low_i8x16
)w2c_template"
R"w2c_template(#define v128_u16x8_extend_low_u8x16  simde_wasm_u16x8_extend_low_u8x16
)w2c_template"
R"w2c_template(#define v128_i32x4_extend_high_i16x8 simde_wasm_i32x4_extend_high_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extend_high_u16x8 simde_wasm_u32x4_extend_high_u16x8
)w2c_template"
R"w2c_template(#define v128_i32x4_extend_low_i16x8  simde_wasm_i32x4_extend_low_i16x8
)w2c_template"
R"w2c_template(#define v128_u32x4_extend_low_u16x8  simde_wasm_u32x4_extend_low_u16x8
)w2c_template"
R"w2c_template(#define v128_i64x2_extend_high_i32x4 simde_wasm_i64x2_extend_high_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extend_high_u32x4 simde_wasm_u64x2_extend_high_u32x4
)w2c_template"
R"w2c_template(#define v128_i64x2_extend_low_i32x4  simde_wasm_i64x2_extend_low_i32x4
)w2c_template"
R"w2c_template(#define v128_u64x2_extend_low_u32x4  simde_wasm_u64x2_extend_low_u32x4
)w2c_template"
R"w2c_template(#define v128_i32x4_trunc_sat_f64x2_zero simde_wasm_i32x4_trunc_sat_f64x2_zero
)w2c_template"
R"w2c_template(#define v128_u32x4_trunc_sat_f64x2_zero simde_wasm_u32x4_trunc_sat_f64x2_zero
)w2c_template"
R"w2c_template(#define v128_i16x8_narrow_i32x4 simde_wasm_i16x8_narrow_i32x4
)w2c_template"
R"w2c_template(#define v128_u16x8_narrow_i32x4 simde_wasm_u16x8_narrow_i32x4
)w2c_template"
R"w2c_template(#define v128_i8x16_narrow_i16x8 simde_wasm_i8x16_narrow_i16x8
)w2c_template"
R"w2c_template(#define v128_u8x16_narrow_i16x8 simde_wasm_u8x16_narrow_i16x8
)w2c_template"
R"w2c_template(#define v128_f64x2_promote_low_f32x4 simde_wasm_f64x2_promote_low_f32x4
)w2c_template"
R"w2c_template(#define v128_f32x4_demote_f64x2_zero simde_wasm_f32x4_demote_f64x2_zero
)w2c_template"
R"w2c_template(#define v128_f64x2_convert_low_i32x4 simde_wasm_f64x2_convert_low_i32x4
)w2c_template"
R"w2c_template(#define v128_f64x2_convert_low_u32x4 simde_wasm_f64x2_convert_low_u32x4
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(// clang-format on
)w2c_template"
;
