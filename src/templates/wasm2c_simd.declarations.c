#if defined(__GNUC__) && defined(__x86_64__)
#define SIMD_FORCE_READ(var) __asm__("" ::"x"(var));
#elif defined(__GNUC__) && defined(__aarch64__)
#define SIMD_FORCE_READ(var) __asm__("" ::"w"(var));
#elif defined(__s390x__)
#define SIMD_FORCE_READ(var) __asm__("" ::"d"(var));
#else
#define SIMD_FORCE_READ(var)
#endif
// TODO: equivalent constraint for ARM and other architectures

#define DEFINE_SIMD_LOAD_FUNC(name, func, t)                             \
  static inline v128 name##_unchecked(wasm_rt_memory_t* mem, u64 addr) { \
    v128 result = func(MEM_ADDR(mem, addr, sizeof(t)));                  \
    SIMD_FORCE_READ(result);                                             \
    return result;                                                       \
  }                                                                      \
  DEF_MEM_CHECKS0(name, _, t, return, v128);

#define DEFINE_SIMD_LOAD_LANE(name, func, t, lane)                     \
  static inline v128 name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
                                      v128 vec) {                      \
    v128 result = func(MEM_ADDR(mem, addr, sizeof(t)), vec, lane);     \
    SIMD_FORCE_READ(result);                                           \
    return result;                                                     \
  }                                                                    \
  DEF_MEM_CHECKS1(name, _, t, return, v128, v128);

#define DEFINE_SIMD_STORE(name, t)                                     \
  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
                                      v128 value) {                    \
    simde_wasm_v128_store(MEM_ADDR(mem, addr, sizeof(t)), value);      \
  }                                                                    \
  DEF_MEM_CHECKS1(name, _, t, , void, v128);

#define DEFINE_SIMD_STORE_LANE(name, func, t, lane)                    \
  static inline void name##_unchecked(wasm_rt_memory_t* mem, u64 addr, \
                                      v128 value) {                    \
    func(MEM_ADDR(mem, addr, sizeof(t)), value, lane);                 \
  }                                                                    \
  DEF_MEM_CHECKS1(name, _, t, , void, v128);

// clang-format off
#if WABT_BIG_ENDIAN
static inline v128 v128_impl_load32_zero(const void* a) {
  return simde_wasm_i8x16_swizzle(
      simde_wasm_v128_load32_zero(a),
      simde_wasm_i8x16_const(12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3));
}
static inline v128 v128_impl_load64_zero(const void* a) {
  return simde_wasm_i8x16_swizzle(
      simde_wasm_v128_load64_zero(a),
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7));
}
#else
#define v128_impl_load32_zero simde_wasm_v128_load32_zero
#define v128_impl_load64_zero simde_wasm_v128_load64_zero
#endif

DEFINE_SIMD_LOAD_FUNC(v128_load, simde_wasm_v128_load, v128)

DEFINE_SIMD_LOAD_FUNC(v128_load8_splat, simde_wasm_v128_load8_splat, u8)
DEFINE_SIMD_LOAD_FUNC(v128_load16_splat, simde_wasm_v128_load16_splat, u16)
DEFINE_SIMD_LOAD_FUNC(v128_load32_splat, simde_wasm_v128_load32_splat, u32)
DEFINE_SIMD_LOAD_FUNC(v128_load64_splat, simde_wasm_v128_load64_splat, u64)

DEFINE_SIMD_LOAD_FUNC(i16x8_load8x8, simde_wasm_i16x8_load8x8, u64)
DEFINE_SIMD_LOAD_FUNC(u16x8_load8x8, simde_wasm_u16x8_load8x8, u64)
DEFINE_SIMD_LOAD_FUNC(i32x4_load16x4, simde_wasm_i32x4_load16x4, u64)
DEFINE_SIMD_LOAD_FUNC(u32x4_load16x4, simde_wasm_u32x4_load16x4, u64)
DEFINE_SIMD_LOAD_FUNC(i64x2_load32x2, simde_wasm_i64x2_load32x2, u64)
DEFINE_SIMD_LOAD_FUNC(u64x2_load32x2, simde_wasm_u64x2_load32x2, u64)

DEFINE_SIMD_LOAD_FUNC(v128_load32_zero, v128_impl_load32_zero, u32)
DEFINE_SIMD_LOAD_FUNC(v128_load64_zero, v128_impl_load64_zero, u64)

#if WABT_BIG_ENDIAN
DEFINE_SIMD_LOAD_LANE(v128_load8_lane0, simde_wasm_v128_load8_lane, u8, 15)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane1, simde_wasm_v128_load8_lane, u8, 14)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane2, simde_wasm_v128_load8_lane, u8, 13)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane3, simde_wasm_v128_load8_lane, u8, 12)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane4, simde_wasm_v128_load8_lane, u8, 11)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane5, simde_wasm_v128_load8_lane, u8, 10)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane6, simde_wasm_v128_load8_lane, u8, 9)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane7, simde_wasm_v128_load8_lane, u8, 8)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane8, simde_wasm_v128_load8_lane, u8, 7)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane9, simde_wasm_v128_load8_lane, u8, 6)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane10, simde_wasm_v128_load8_lane, u8, 5)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane11, simde_wasm_v128_load8_lane, u8, 4)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane12, simde_wasm_v128_load8_lane, u8, 3)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane13, simde_wasm_v128_load8_lane, u8, 2)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane14, simde_wasm_v128_load8_lane, u8, 1)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane15, simde_wasm_v128_load8_lane, u8, 0)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane0, simde_wasm_v128_load16_lane, u16, 7)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane1, simde_wasm_v128_load16_lane, u16, 6)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane2, simde_wasm_v128_load16_lane, u16, 5)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane3, simde_wasm_v128_load16_lane, u16, 4)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane4, simde_wasm_v128_load16_lane, u16, 3)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane5, simde_wasm_v128_load16_lane, u16, 2)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane6, simde_wasm_v128_load16_lane, u16, 1)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane7, simde_wasm_v128_load16_lane, u16, 0)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane0, simde_wasm_v128_load32_lane, u32, 3)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane1, simde_wasm_v128_load32_lane, u32, 2)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane2, simde_wasm_v128_load32_lane, u32, 1)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane3, simde_wasm_v128_load32_lane, u32, 0)
DEFINE_SIMD_LOAD_LANE(v128_load64_lane0, simde_wasm_v128_load64_lane, u64, 1)
DEFINE_SIMD_LOAD_LANE(v128_load64_lane1, simde_wasm_v128_load64_lane, u64, 0)
#else
DEFINE_SIMD_LOAD_LANE(v128_load8_lane0, simde_wasm_v128_load8_lane, u8, 0)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane1, simde_wasm_v128_load8_lane, u8, 1)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane2, simde_wasm_v128_load8_lane, u8, 2)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane3, simde_wasm_v128_load8_lane, u8, 3)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane4, simde_wasm_v128_load8_lane, u8, 4)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane5, simde_wasm_v128_load8_lane, u8, 5)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane6, simde_wasm_v128_load8_lane, u8, 6)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane7, simde_wasm_v128_load8_lane, u8, 7)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane8, simde_wasm_v128_load8_lane, u8, 8)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane9, simde_wasm_v128_load8_lane, u8, 9)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane10, simde_wasm_v128_load8_lane, u8, 10)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane11, simde_wasm_v128_load8_lane, u8, 11)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane12, simde_wasm_v128_load8_lane, u8, 12)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane13, simde_wasm_v128_load8_lane, u8, 13)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane14, simde_wasm_v128_load8_lane, u8, 14)
DEFINE_SIMD_LOAD_LANE(v128_load8_lane15, simde_wasm_v128_load8_lane, u8, 15)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane0, simde_wasm_v128_load16_lane, u16, 0)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane1, simde_wasm_v128_load16_lane, u16, 1)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane2, simde_wasm_v128_load16_lane, u16, 2)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane3, simde_wasm_v128_load16_lane, u16, 3)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane4, simde_wasm_v128_load16_lane, u16, 4)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane5, simde_wasm_v128_load16_lane, u16, 5)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane6, simde_wasm_v128_load16_lane, u16, 6)
DEFINE_SIMD_LOAD_LANE(v128_load16_lane7, simde_wasm_v128_load16_lane, u16, 7)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane0, simde_wasm_v128_load32_lane, u32, 0)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane1, simde_wasm_v128_load32_lane, u32, 1)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane2, simde_wasm_v128_load32_lane, u32, 2)
DEFINE_SIMD_LOAD_LANE(v128_load32_lane3, simde_wasm_v128_load32_lane, u32, 3)
DEFINE_SIMD_LOAD_LANE(v128_load64_lane0, simde_wasm_v128_load64_lane, u64, 0)
DEFINE_SIMD_LOAD_LANE(v128_load64_lane1, simde_wasm_v128_load64_lane, u64, 1)
#endif

DEFINE_SIMD_STORE(v128_store, v128)

#if WABT_BIG_ENDIAN
DEFINE_SIMD_STORE_LANE(v128_store8_lane0, simde_wasm_v128_store8_lane, u8, 15)
DEFINE_SIMD_STORE_LANE(v128_store8_lane1, simde_wasm_v128_store8_lane, u8, 14)
DEFINE_SIMD_STORE_LANE(v128_store8_lane2, simde_wasm_v128_store8_lane, u8, 13)
DEFINE_SIMD_STORE_LANE(v128_store8_lane3, simde_wasm_v128_store8_lane, u8, 12)
DEFINE_SIMD_STORE_LANE(v128_store8_lane4, simde_wasm_v128_store8_lane, u8, 11)
DEFINE_SIMD_STORE_LANE(v128_store8_lane5, simde_wasm_v128_store8_lane, u8, 10)
DEFINE_SIMD_STORE_LANE(v128_store8_lane6, simde_wasm_v128_store8_lane, u8, 9)
DEFINE_SIMD_STORE_LANE(v128_store8_lane7, simde_wasm_v128_store8_lane, u8, 8)
DEFINE_SIMD_STORE_LANE(v128_store8_lane8, simde_wasm_v128_store8_lane, u8, 7)
DEFINE_SIMD_STORE_LANE(v128_store8_lane9, simde_wasm_v128_store8_lane, u8, 6)
DEFINE_SIMD_STORE_LANE(v128_store8_lane10, simde_wasm_v128_store8_lane, u8, 5)
DEFINE_SIMD_STORE_LANE(v128_store8_lane11, simde_wasm_v128_store8_lane, u8, 4)
DEFINE_SIMD_STORE_LANE(v128_store8_lane12, simde_wasm_v128_store8_lane, u8, 3)
DEFINE_SIMD_STORE_LANE(v128_store8_lane13, simde_wasm_v128_store8_lane, u8, 2)
DEFINE_SIMD_STORE_LANE(v128_store8_lane14, simde_wasm_v128_store8_lane, u8, 1)
DEFINE_SIMD_STORE_LANE(v128_store8_lane15, simde_wasm_v128_store8_lane, u8, 0)
DEFINE_SIMD_STORE_LANE(v128_store16_lane0, simde_wasm_v128_store16_lane, u16, 7)
DEFINE_SIMD_STORE_LANE(v128_store16_lane1, simde_wasm_v128_store16_lane, u16, 6)
DEFINE_SIMD_STORE_LANE(v128_store16_lane2, simde_wasm_v128_store16_lane, u16, 5)
DEFINE_SIMD_STORE_LANE(v128_store16_lane3, simde_wasm_v128_store16_lane, u16, 4)
DEFINE_SIMD_STORE_LANE(v128_store16_lane4, simde_wasm_v128_store16_lane, u16, 3)
DEFINE_SIMD_STORE_LANE(v128_store16_lane5, simde_wasm_v128_store16_lane, u16, 2)
DEFINE_SIMD_STORE_LANE(v128_store16_lane6, simde_wasm_v128_store16_lane, u16, 1)
DEFINE_SIMD_STORE_LANE(v128_store16_lane7, simde_wasm_v128_store16_lane, u16, 0)
DEFINE_SIMD_STORE_LANE(v128_store32_lane0, simde_wasm_v128_store32_lane, u32, 3)
DEFINE_SIMD_STORE_LANE(v128_store32_lane1, simde_wasm_v128_store32_lane, u32, 2)
DEFINE_SIMD_STORE_LANE(v128_store32_lane2, simde_wasm_v128_store32_lane, u32, 1)
DEFINE_SIMD_STORE_LANE(v128_store32_lane3, simde_wasm_v128_store32_lane, u32, 0)
DEFINE_SIMD_STORE_LANE(v128_store64_lane0, simde_wasm_v128_store64_lane, u64, 1)
DEFINE_SIMD_STORE_LANE(v128_store64_lane1, simde_wasm_v128_store64_lane, u64, 0)
#else
DEFINE_SIMD_STORE_LANE(v128_store8_lane0, simde_wasm_v128_store8_lane, u8, 0)
DEFINE_SIMD_STORE_LANE(v128_store8_lane1, simde_wasm_v128_store8_lane, u8, 1)
DEFINE_SIMD_STORE_LANE(v128_store8_lane2, simde_wasm_v128_store8_lane, u8, 2)
DEFINE_SIMD_STORE_LANE(v128_store8_lane3, simde_wasm_v128_store8_lane, u8, 3)
DEFINE_SIMD_STORE_LANE(v128_store8_lane4, simde_wasm_v128_store8_lane, u8, 4)
DEFINE_SIMD_STORE_LANE(v128_store8_lane5, simde_wasm_v128_store8_lane, u8, 5)
DEFINE_SIMD_STORE_LANE(v128_store8_lane6, simde_wasm_v128_store8_lane, u8, 6)
DEFINE_SIMD_STORE_LANE(v128_store8_lane7, simde_wasm_v128_store8_lane, u8, 7)
DEFINE_SIMD_STORE_LANE(v128_store8_lane8, simde_wasm_v128_store8_lane, u8, 8)
DEFINE_SIMD_STORE_LANE(v128_store8_lane9, simde_wasm_v128_store8_lane, u8, 9)
DEFINE_SIMD_STORE_LANE(v128_store8_lane10, simde_wasm_v128_store8_lane, u8, 10)
DEFINE_SIMD_STORE_LANE(v128_store8_lane11, simde_wasm_v128_store8_lane, u8, 11)
DEFINE_SIMD_STORE_LANE(v128_store8_lane12, simde_wasm_v128_store8_lane, u8, 12)
DEFINE_SIMD_STORE_LANE(v128_store8_lane13, simde_wasm_v128_store8_lane, u8, 13)
DEFINE_SIMD_STORE_LANE(v128_store8_lane14, simde_wasm_v128_store8_lane, u8, 14)
DEFINE_SIMD_STORE_LANE(v128_store8_lane15, simde_wasm_v128_store8_lane, u8, 15)
DEFINE_SIMD_STORE_LANE(v128_store16_lane0, simde_wasm_v128_store16_lane, u16, 0)
DEFINE_SIMD_STORE_LANE(v128_store16_lane1, simde_wasm_v128_store16_lane, u16, 1)
DEFINE_SIMD_STORE_LANE(v128_store16_lane2, simde_wasm_v128_store16_lane, u16, 2)
DEFINE_SIMD_STORE_LANE(v128_store16_lane3, simde_wasm_v128_store16_lane, u16, 3)
DEFINE_SIMD_STORE_LANE(v128_store16_lane4, simde_wasm_v128_store16_lane, u16, 4)
DEFINE_SIMD_STORE_LANE(v128_store16_lane5, simde_wasm_v128_store16_lane, u16, 5)
DEFINE_SIMD_STORE_LANE(v128_store16_lane6, simde_wasm_v128_store16_lane, u16, 6)
DEFINE_SIMD_STORE_LANE(v128_store16_lane7, simde_wasm_v128_store16_lane, u16, 7)
DEFINE_SIMD_STORE_LANE(v128_store32_lane0, simde_wasm_v128_store32_lane, u32, 0)
DEFINE_SIMD_STORE_LANE(v128_store32_lane1, simde_wasm_v128_store32_lane, u32, 1)
DEFINE_SIMD_STORE_LANE(v128_store32_lane2, simde_wasm_v128_store32_lane, u32, 2)
DEFINE_SIMD_STORE_LANE(v128_store32_lane3, simde_wasm_v128_store32_lane, u32, 3)
DEFINE_SIMD_STORE_LANE(v128_store64_lane0, simde_wasm_v128_store64_lane, u64, 0)
DEFINE_SIMD_STORE_LANE(v128_store64_lane1, simde_wasm_v128_store64_lane, u64, 1)
#endif

#if WABT_BIG_ENDIAN
#define v128_const(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) simde_wasm_i8x16_const(p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a)
#define v128_i8x16_extract_lane(v, l) simde_wasm_i8x16_extract_lane(v, 15-(l))
#define v128_u8x16_extract_lane(v, l) simde_wasm_u8x16_extract_lane(v, 15-(l))
#define v128_i16x8_extract_lane(v, l) simde_wasm_i16x8_extract_lane(v, 7-(l))
#define v128_u16x8_extract_lane(v, l) simde_wasm_u16x8_extract_lane(v, 7-(l))
#define v128_i32x4_extract_lane(v, l) simde_wasm_i32x4_extract_lane(v, 3-(l))
#define v128_i64x2_extract_lane(v, l) simde_wasm_i64x2_extract_lane(v, 1-(l))
#define v128_f32x4_extract_lane(v, l) simde_wasm_f32x4_extract_lane(v, 3-(l))
#define v128_f64x2_extract_lane(v, l) simde_wasm_f64x2_extract_lane(v, 1-(l))
#define v128_i8x16_replace_lane(v, l, x) simde_wasm_i8x16_replace_lane(v, 15-(l), x)
#define v128_u8x16_replace_lane(v, l, x) simde_wasm_u8x16_replace_lane(v, 15-(l), x)
#define v128_i16x8_replace_lane(v, l, x) simde_wasm_i16x8_replace_lane(v, 7-(l), x)
#define v128_u16x8_replace_lane(v, l, x) simde_wasm_u16x8_replace_lane(v, 7-(l), x)
#define v128_i32x4_replace_lane(v, l, x) simde_wasm_i32x4_replace_lane(v, 3-(l), x)
#define v128_i64x2_replace_lane(v, l, x) simde_wasm_i64x2_replace_lane(v, 1-(l), x)
#define v128_f32x4_replace_lane(v, l, x) simde_wasm_f32x4_replace_lane(v, 3-(l), x)
#define v128_f64x2_replace_lane(v, l, x) simde_wasm_f64x2_replace_lane(v, 1-(l), x)
#define v128_i8x16_bitmask(v) simde_wasm_i8x16_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0)))
#define v128_i16x8_bitmask(v) simde_wasm_i16x8_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1)))
#define v128_i32x4_bitmask(v) simde_wasm_i32x4_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3)))
#define v128_i64x2_bitmask(v) simde_wasm_i64x2_bitmask(simde_wasm_i8x16_swizzle(v, simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
#define v128_i8x16_swizzle(v1, v2) simde_wasm_i8x16_swizzle(v1, simde_wasm_v128_xor(v2, simde_wasm_i8x16_splat(15)))
#define v128_i8x16_shuffle(v1,v2,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) simde_wasm_i8x16_shuffle(v2,v1,31-(p),31-(o),31-(n),31-(m),31-(l),31-(k),31-(j),31-(i),31-(h),31-(g),31-(f),31-(e),31-(d),31-(c),31-(b),31-(a))
#define v128_i16x8_extmul_high_i8x16 simde_wasm_i16x8_extmul_low_i8x16
#define v128_u16x8_extmul_high_u8x16 simde_wasm_u16x8_extmul_low_u8x16
#define v128_i16x8_extmul_low_i8x16  simde_wasm_i16x8_extmul_high_i8x16
#define v128_u16x8_extmul_low_u8x16  simde_wasm_u16x8_extmul_high_u8x16
#define v128_i32x4_extmul_high_i16x8 simde_wasm_i32x4_extmul_low_i16x8
#define v128_u32x4_extmul_high_u16x8 simde_wasm_u32x4_extmul_low_u16x8
#define v128_i32x4_extmul_low_i16x8  simde_wasm_i32x4_extmul_high_i16x8
#define v128_u32x4_extmul_low_u16x8  simde_wasm_u32x4_extmul_high_u16x8
#define v128_i64x2_extmul_high_i32x4 simde_wasm_i64x2_extmul_low_i32x4
#define v128_u64x2_extmul_high_u32x4 simde_wasm_u64x2_extmul_low_u32x4
#define v128_i64x2_extmul_low_i32x4  simde_wasm_i64x2_extmul_high_i32x4
#define v128_u64x2_extmul_low_u32x4  simde_wasm_u64x2_extmul_high_u32x4
#define v128_i16x8_extend_high_i8x16 simde_wasm_i16x8_extend_low_i8x16
#define v128_u16x8_extend_high_u8x16 simde_wasm_u16x8_extend_low_u8x16
#define v128_i16x8_extend_low_i8x16  simde_wasm_i16x8_extend_high_i8x16
#define v128_u16x8_extend_low_u8x16  simde_wasm_u16x8_extend_high_u8x16
#define v128_i32x4_extend_high_i16x8 simde_wasm_i32x4_extend_low_i16x8
#define v128_u32x4_extend_high_u16x8 simde_wasm_u32x4_extend_low_u16x8
#define v128_i32x4_extend_low_i16x8  simde_wasm_i32x4_extend_high_i16x8
#define v128_u32x4_extend_low_u16x8  simde_wasm_u32x4_extend_high_u16x8
#define v128_i64x2_extend_high_i32x4 simde_wasm_i64x2_extend_low_i32x4
#define v128_u64x2_extend_high_u32x4 simde_wasm_u64x2_extend_low_u32x4
#define v128_i64x2_extend_low_i32x4  simde_wasm_i64x2_extend_high_i32x4
#define v128_u64x2_extend_low_u32x4  simde_wasm_u64x2_extend_high_u32x4
#define v128_i32x4_trunc_sat_f64x2_zero(a)      \
  simde_wasm_i8x16_swizzle(                     \
      simde_wasm_i32x4_trunc_sat_f64x2_zero(a), \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
#define v128_u32x4_trunc_sat_f64x2_zero(a)      \
  simde_wasm_i8x16_swizzle(                     \
      simde_wasm_u32x4_trunc_sat_f64x2_zero(a), \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
#define v128_i16x8_narrow_i32x4(a,b) simde_wasm_i16x8_narrow_i32x4(b,a)
#define v128_u16x8_narrow_i32x4(a,b) simde_wasm_u16x8_narrow_i32x4(b,a)
#define v128_i8x16_narrow_i16x8(a,b) simde_wasm_i8x16_narrow_i16x8(b,a)
#define v128_u8x16_narrow_i16x8(a,b) simde_wasm_u8x16_narrow_i16x8(b,a)
#define v128_f64x2_promote_low_f32x4(a)                        \
  simde_wasm_f64x2_promote_low_f32x4(simde_wasm_i8x16_swizzle( \
      a,                                                       \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
#define v128_f32x4_demote_f64x2_zero(a)      \
  simde_wasm_i8x16_swizzle(                  \
      simde_wasm_f32x4_demote_f64x2_zero(a), \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7))
#define v128_f64x2_convert_low_i32x4(a)                        \
  simde_wasm_f64x2_convert_low_i32x4(simde_wasm_i8x16_swizzle( \
      a,                                                       \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
#define v128_f64x2_convert_low_u32x4(a)                        \
  simde_wasm_f64x2_convert_low_u32x4(simde_wasm_i8x16_swizzle( \
      a,                                                       \
      simde_wasm_i8x16_const(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))
#else
#define v128_const simde_wasm_i8x16_const
#define v128_i8x16_extract_lane simde_wasm_i8x16_extract_lane
#define v128_u8x16_extract_lane simde_wasm_u8x16_extract_lane
#define v128_i16x8_extract_lane simde_wasm_i16x8_extract_lane
#define v128_u16x8_extract_lane simde_wasm_u16x8_extract_lane
#define v128_i32x4_extract_lane simde_wasm_i32x4_extract_lane
#define v128_i64x2_extract_lane simde_wasm_i64x2_extract_lane
#define v128_f32x4_extract_lane simde_wasm_f32x4_extract_lane
#define v128_f64x2_extract_lane simde_wasm_f64x2_extract_lane
#define v128_i8x16_replace_lane simde_wasm_i8x16_replace_lane
#define v128_u8x16_replace_lane simde_wasm_u8x16_replace_lane
#define v128_i16x8_replace_lane simde_wasm_i16x8_replace_lane
#define v128_u16x8_replace_lane simde_wasm_u16x8_replace_lane
#define v128_i32x4_replace_lane simde_wasm_i32x4_replace_lane
#define v128_i64x2_replace_lane simde_wasm_i64x2_replace_lane
#define v128_f32x4_replace_lane simde_wasm_f32x4_replace_lane
#define v128_f64x2_replace_lane simde_wasm_f64x2_replace_lane
#define v128_i8x16_bitmask simde_wasm_i8x16_bitmask
#define v128_i16x8_bitmask simde_wasm_i16x8_bitmask
#define v128_i32x4_bitmask simde_wasm_i32x4_bitmask
#define v128_i64x2_bitmask simde_wasm_i64x2_bitmask
#define v128_i8x16_swizzle simde_wasm_i8x16_swizzle
#define v128_i8x16_shuffle simde_wasm_i8x16_shuffle
#define v128_i16x8_extmul_high_i8x16 simde_wasm_i16x8_extmul_high_i8x16
#define v128_u16x8_extmul_high_u8x16 simde_wasm_u16x8_extmul_high_u8x16
#define v128_i16x8_extmul_low_i8x16  simde_wasm_i16x8_extmul_low_i8x16
#define v128_u16x8_extmul_low_u8x16  simde_wasm_u16x8_extmul_low_u8x16
#define v128_i32x4_extmul_high_i16x8 simde_wasm_i32x4_extmul_high_i16x8
#define v128_u32x4_extmul_high_u16x8 simde_wasm_u32x4_extmul_high_u16x8
#define v128_i32x4_extmul_low_i16x8  simde_wasm_i32x4_extmul_low_i16x8
#define v128_u32x4_extmul_low_u16x8  simde_wasm_u32x4_extmul_low_u16x8
#define v128_i64x2_extmul_high_i32x4 simde_wasm_i64x2_extmul_high_i32x4
#define v128_u64x2_extmul_high_u32x4 simde_wasm_u64x2_extmul_high_u32x4
#define v128_i64x2_extmul_low_i32x4  simde_wasm_i64x2_extmul_low_i32x4
#define v128_u64x2_extmul_low_u32x4  simde_wasm_u64x2_extmul_low_u32x4
#define v128_i16x8_extend_high_i8x16 simde_wasm_i16x8_extend_high_i8x16
#define v128_u16x8_extend_high_u8x16 simde_wasm_u16x8_extend_high_u8x16
#define v128_i16x8_extend_low_i8x16  simde_wasm_i16x8_extend_low_i8x16
#define v128_u16x8_extend_low_u8x16  simde_wasm_u16x8_extend_low_u8x16
#define v128_i32x4_extend_high_i16x8 simde_wasm_i32x4_extend_high_i16x8
#define v128_u32x4_extend_high_u16x8 simde_wasm_u32x4_extend_high_u16x8
#define v128_i32x4_extend_low_i16x8  simde_wasm_i32x4_extend_low_i16x8
#define v128_u32x4_extend_low_u16x8  simde_wasm_u32x4_extend_low_u16x8
#define v128_i64x2_extend_high_i32x4 simde_wasm_i64x2_extend_high_i32x4
#define v128_u64x2_extend_high_u32x4 simde_wasm_u64x2_extend_high_u32x4
#define v128_i64x2_extend_low_i32x4  simde_wasm_i64x2_extend_low_i32x4
#define v128_u64x2_extend_low_u32x4  simde_wasm_u64x2_extend_low_u32x4
#define v128_i32x4_trunc_sat_f64x2_zero simde_wasm_i32x4_trunc_sat_f64x2_zero
#define v128_u32x4_trunc_sat_f64x2_zero simde_wasm_u32x4_trunc_sat_f64x2_zero
#define v128_i16x8_narrow_i32x4 simde_wasm_i16x8_narrow_i32x4
#define v128_u16x8_narrow_i32x4 simde_wasm_u16x8_narrow_i32x4
#define v128_i8x16_narrow_i16x8 simde_wasm_i8x16_narrow_i16x8
#define v128_u8x16_narrow_i16x8 simde_wasm_u8x16_narrow_i16x8
#define v128_f64x2_promote_low_f32x4 simde_wasm_f64x2_promote_low_f32x4
#define v128_f32x4_demote_f64x2_zero simde_wasm_f32x4_demote_f64x2_zero
#define v128_f64x2_convert_low_i32x4 simde_wasm_f64x2_convert_low_i32x4
#define v128_f64x2_convert_low_u32x4 simde_wasm_f64x2_convert_low_u32x4
#endif
// clang-format on
