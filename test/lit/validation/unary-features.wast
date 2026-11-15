;; Test that validator errors when unary operations use features that are not
;; enabled.

;; RUN: not wasm-opt %s --mvp-features 2>&1 | filecheck %s --check-prefix NONE
;; RUN: not wasm-opt %s --mvp-features --enable-simd 2>&1 | filecheck %s --check-prefix SIMD
;; RUN: not wasm-opt %s --mvp-features --enable-sign-ext 2>&1 | filecheck %s --check-prefix SIGNEXT
;; RUN: not wasm-opt %s --mvp-features --enable-nontrapping-float-to-int 2>&1 | filecheck %s --check-prefix NTFI
;; RUN: not wasm-opt %s --mvp-features --enable-simd --enable-sign-ext --enable-nontrapping-float-to-int 2>&1 | filecheck %s --check-prefix NOREL
;; RUN: not wasm-opt %s --mvp-features --enable-relaxed-simd --enable-sign-ext --enable-nontrapping-float-to-int 2>&1 | filecheck %s --check-prefix RELONLY
;; RUN: wasm-opt %s --mvp-features --enable-simd --enable-relaxed-simd --enable-sign-ext --enable-nontrapping-float-to-int -o - -S | filecheck %s --check-prefix ALL

;; No features enabled

;; NONE:      Unary operation requires additional features, on
;; NONE-NEXT: (i32.trunc_sat_f32_s
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i32.trunc_sat_f32_u
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i64.trunc_sat_f32_s
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i64.trunc_sat_f32_u
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i32.trunc_sat_f64_s
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i32.trunc_sat_f64_u
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i64.trunc_sat_f64_s
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i64.trunc_sat_f64_u
;; NONE:      [--enable-nontrapping-float-to-int]

;; NONE:      Unary operation requires additional features, on
;; NONE-NEXT: (i32.extend8_s
;; NONE:      [--enable-sign-ext]
;; NONE:      (i32.extend16_s
;; NONE:      [--enable-sign-ext]
;; NONE:      (i64.extend8_s
;; NONE:      [--enable-sign-ext]
;; NONE:      (i64.extend16_s
;; NONE:      [--enable-sign-ext]
;; NONE:      (i64.extend32_s
;; NONE:      [--enable-sign-ext]

;; NONE:      function nested
;; NONE-NEXT: (i32.trunc_sat_f32_s
;; NONE:      [--enable-nontrapping-float-to-int]
;; NONE:      (i32.extend8_s
;; NONE:      [--enable-sign-ext]

;; NONE:      Unary operation requires additional features, on
;; NONE-NEXT: (i8x16.splat
;; NONE:      [--enable-simd]
;; NONE:      (i16x8.splat
;; NONE:      [--enable-simd]
;; NONE:      (i32x4.splat
;; NONE:      [--enable-simd]
;; NONE:      (i64x2.splat
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.splat
;; NONE:      [--enable-simd]
;; NONE:      (f64x2.splat
;; NONE:      [--enable-simd]
;; NONE:      (v128.not
;; NONE:      [--enable-simd]
;; NONE:      (i8x16.neg
;; NONE:      [--enable-simd]
;; NONE:      (i16x8.neg
;; NONE:      [--enable-simd]
;; NONE:      (i32x4.neg
;; NONE:      [--enable-simd]
;; NONE:      (i64x2.neg
;; NONE:      [--enable-simd]
;; NONE:      (i8x16.all_true
;; NONE:      [--enable-simd]
;; NONE:      (i16x8.all_true
;; NONE:      [--enable-simd]
;; NONE:      (i32x4.all_true
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.abs
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.neg
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.sqrt
;; NONE:      [--enable-simd]
;; NONE:      (f64x2.abs
;; NONE:      [--enable-simd]
;; NONE:      (f64x2.neg
;; NONE:      [--enable-simd]
;; NONE:      (f64x2.sqrt
;; NONE:      [--enable-simd]
;; NONE:      (i32x4.trunc_sat_f32x4_s
;; NONE:      [--enable-simd]
;; NONE:      (i32x4.trunc_sat_f32x4_u
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.convert_i32x4_s
;; NONE:      [--enable-simd]
;; NONE:      (f32x4.convert_i32x4_u
;; NONE:      [--enable-simd]

;; NONE:      Unary operation requires additional features, on
;; NONE-NEXT: (i32x4.relaxed_trunc_f32x4_s
;; NONE:      [--enable-simd --enable-relaxed-simd]
;; NONE:      (i32x4.relaxed_trunc_f32x4_u
;; NONE:      [--enable-simd --enable-relaxed-simd]
;; NONE:      (i32x4.relaxed_trunc_f64x2_s_zero
;; NONE:      [--enable-simd --enable-relaxed-simd]
;; NONE:      (i32x4.relaxed_trunc_f64x2_u_zero
;; NONE-NEXT:  (v128.const
;; NONE-NEXT: )
;; NONE-NEXT: [--enable-simd --enable-relaxed-simd]
;; NONE-NEXT: Fatal: error validating input

;; SIMD:      function truncsat
;; SIMD-NEXT: (i32.trunc_sat_f32_s
;; SIMD:      [--enable-nontrapping-float-to-int]
;; SIMD:      (i64.trunc_sat_f64_u
;; SIMD:      [--enable-nontrapping-float-to-int]
;; SIMD:      function signext
;; SIMD-NEXT: (i32.extend8_s
;; SIMD:      [--enable-sign-ext]
;; SIMD:      (i64.extend32_s
;; SIMD:      [--enable-sign-ext]
;; SIMD:      function nested
;; SIMD-NEXT: (i32.trunc_sat_f32_s
;; SIMD:      [--enable-nontrapping-float-to-int]
;; SIMD:      (i32.extend8_s
;; SIMD:      [--enable-sign-ext]
;; SIMD-NOT:  function simd
;; SIMD:      function relaxed
;; SIMD-NEXT: (i32x4.relaxed_trunc_f32x4_s
;; SIMD:      [--enable-relaxed-simd]
;; SIMD:      (i32x4.relaxed_trunc_f32x4_u
;; SIMD:      [--enable-relaxed-simd]
;; SIMD:      (i32x4.relaxed_trunc_f64x2_s_zero
;; SIMD:      [--enable-relaxed-simd]
;; SIMD:      (i32x4.relaxed_trunc_f64x2_u_zero
;; SIMD:      [--enable-relaxed-simd]
;; SIMD-NEXT: Fatal: error validating input

;; Only sign-ext enabled

;; SIGNEXT-NOT:  function signext
;; SIGNEXT:      function truncsat
;; SIGNEXT-NEXT: (i32.trunc_sat_f32_s
;; SIGNEXT:      [--enable-nontrapping-float-to-int]
;; SIGNEXT:      (i64.trunc_sat_f64_u
;; SIGNEXT:      [--enable-nontrapping-float-to-int]
;; SIGNEXT:      function nested
;; SIGNEXT-NEXT: (i32.trunc_sat_f32_s
;; SIGNEXT:      [--enable-nontrapping-float-to-int]
;; SIGNEXT-NEXT: [wasm-validator error in function simd]

;; Only nontrapping-float-to-int enabled

;; NTFI-NOT:  function truncsat
;; NTFI:      function signext
;; NTFI-NEXT: (i32.extend8_s
;; NTFI:      [--enable-sign-ext]
;; NTFI:      (i64.extend32_s
;; NTFI:      [--enable-sign-ext]
;; NTFI:      function nested
;; NTFI-NEXT: (i32.extend8_s
;; NTFI-NEXT:  (i32.trunc_sat_f32_s
;; NTFI:      [--enable-sign-ext]
;; NTFI-NEXT: [wasm-validator error in function simd]

;; All features except relaxed SIMD enabled

;; NOREL-NOT:  function truncsat
;; NOREL-NOT:  function signext
;; NOREL-NOT:  function nested
;; NOREL-NOT:  function simd
;; NOREL:      function relaxed
;; NOREL-NEXT: (i32x4.relaxed_trunc_f32x4_s
;; NOREL-NEXT:  (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; NOREL-NEXT: )
;; NOREL-NEXT: [--enable-relaxed-simd]
;; NOREL-NEXT: [wasm-validator error in function relaxed] unexpected false: Unary operation requires additional features, on
;; NOREL-NEXT: (i32x4.relaxed_trunc_f32x4_u
;; NOREL-NEXT:  (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; NOREL-NEXT: )
;; NOREL-NEXT: [--enable-relaxed-simd]
;; NOREL-NEXT: [wasm-validator error in function relaxed] unexpected false: Unary operation requires additional features, on
;; NOREL-NEXT: (i32x4.relaxed_trunc_f64x2_s_zero
;; NOREL-NEXT:  (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; NOREL-NEXT: )
;; NOREL-NEXT: [--enable-relaxed-simd]
;; NOREL-NEXT: [wasm-validator error in function relaxed] unexpected false: Unary operation requires additional features, on
;; NOREL-NEXT: (i32x4.relaxed_trunc_f64x2_u_zero
;; NOREL-NEXT:  (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; NOREL-NEXT: )
;; NOREL-NEXT: [--enable-relaxed-simd]
;; NOREL-NEXT: Fatal: error validating input

;; Relaxed SIMD enabled without SIMD

;; RELONLY-NOT:  function truncsat
;; RELONLY-NOT:  function signext
;; RELONLY-NOT:  function nested
;; RELONLY:      function simd
;; RELONLY:      Unary operation requires additional features, on
;; RELONLY-NEXT: (i8x16.splat
;; RELONLY:      [--enable-simd]
;; RELONLY:      (f32x4.convert_i32x4_u
;; RELONLY:      [--enable-simd]
;; RELONLY:      function relaxed
;; RELONLY:      Unary operation requires additional features, on
;; RELONLY-NEXT: (i32x4.relaxed_trunc_f32x4_s
;; RELONLY:      [--enable-simd]
;; RELONLY:      (i32x4.relaxed_trunc_f32x4_u
;; RELONLY:      [--enable-simd]
;; RELONLY:      (i32x4.relaxed_trunc_f64x2_s_zero
;; RELONLY:      [--enable-simd]
;; RELONLY:      (i32x4.relaxed_trunc_f64x2_u_zero
;; RELONLY:      [--enable-simd]
;; RELONLY-NEXT: Fatal: error validating input

;; All features enabled

;; ALL: (func $truncsat
;; ALL: (i32.trunc_sat_f32_s
;; ALL: (i64.trunc_sat_f64_u
;; ALL: (func $signext
;; ALL: (i32.extend8_s
;; ALL: (i64.extend32_s
;; ALL: (func $nested
;; ALL: (func $simd
;; ALL: (i8x16.splat
;; ALL: (f32x4.convert_i32x4_u
;; ALL: (func $relaxed
;; ALL: (i32x4.relaxed_trunc_f32x4_s
;; ALL: (i32x4.relaxed_trunc_f64x2_u_zero
;; ALL: (func $mvp
;; ALL: (f64.reinterpret_i64

(module
  (func $truncsat
    (drop (i32.trunc_sat_f32_s (f32.const 0)))
    (drop (i32.trunc_sat_f32_u (f32.const 0)))
    (drop (i64.trunc_sat_f32_s (f32.const 0)))
    (drop (i64.trunc_sat_f32_u (f32.const 0)))
    (drop (i32.trunc_sat_f64_s (f64.const 0)))
    (drop (i32.trunc_sat_f64_u (f64.const 0)))
    (drop (i64.trunc_sat_f64_s (f64.const 0)))
    (drop (i64.trunc_sat_f64_u (f64.const 0)))
  )

  (func $signext
    (drop (i32.extend8_s (i32.const 0)))
    (drop (i32.extend16_s (i32.const 0)))
    (drop (i64.extend8_s (i64.const 0)))
    (drop (i64.extend16_s (i64.const 0)))
    (drop (i64.extend32_s (i64.const 0)))
  )

  (func $nested
    (drop (i32.extend8_s (i32.trunc_sat_f32_s (f32.const 0))))
  )

  (func $simd
    (drop (i8x16.splat (i32.const 0)))
    (drop (i16x8.splat (i32.const 0)))
    (drop (i32x4.splat (i32.const 0)))
    (drop (i64x2.splat (i64.const 0)))
    (drop (f32x4.splat (f32.const 0)))
    (drop (f64x2.splat (f64.const 0)))
    (drop (v128.not (v128.const i32x4 0 0 0 0)))
    (drop (i8x16.neg (v128.const i32x4 0 0 0 0)))
    (drop (i16x8.neg (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.neg (v128.const i32x4 0 0 0 0)))
    (drop (i64x2.neg (v128.const i32x4 0 0 0 0)))
    (drop (i8x16.all_true (v128.const i32x4 0 0 0 0)))
    (drop (i16x8.all_true (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.all_true (v128.const i32x4 0 0 0 0)))
    (drop (f32x4.abs (v128.const i32x4 0 0 0 0)))
    (drop (f32x4.neg (v128.const i32x4 0 0 0 0)))
    (drop (f32x4.sqrt (v128.const i32x4 0 0 0 0)))
    (drop (f64x2.abs (v128.const i32x4 0 0 0 0)))
    (drop (f64x2.neg (v128.const i32x4 0 0 0 0)))
    (drop (f64x2.sqrt (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.trunc_sat_f32x4_s (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.trunc_sat_f32x4_u (v128.const i32x4 0 0 0 0)))
    (drop (f32x4.convert_i32x4_s (v128.const i32x4 0 0 0 0)))
    (drop (f32x4.convert_i32x4_u (v128.const i32x4 0 0 0 0)))
  )

  (func $relaxed
    (drop (i32x4.relaxed_trunc_f32x4_s (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.relaxed_trunc_f32x4_u (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.relaxed_trunc_f64x2_s_zero (v128.const i32x4 0 0 0 0)))
    (drop (i32x4.relaxed_trunc_f64x2_u_zero (v128.const i32x4 0 0 0 0)))
  )

  (func $mvp (param i32 i64 f32 f64)
    (drop (i32.clz (local.get 0)))
    (drop (i32.ctz (local.get 0)))
    (drop (i32.popcnt (local.get 0)))
    (drop (i32.eqz (local.get 0)))
    (drop (i64.eqz (local.get 1)))
    (drop (f32.neg (local.get 2)))
    (drop (f64.sqrt (local.get 3)))
    (drop (i32.wrap_i64 (local.get 1)))
    (drop (i64.extend_i32_s (local.get 0)))
    (drop (i64.extend_i32_u (local.get 0)))
    (drop (i32.trunc_f32_s (local.get 2)))
    (drop (i64.trunc_f64_u (local.get 3)))
    (drop (f32.convert_i32_s (local.get 0)))
    (drop (f64.promote_f32 (local.get 2)))
    (drop (f32.demote_f64 (local.get 3)))
    (drop (i32.reinterpret_f32 (local.get 2)))
    (drop (f64.reinterpret_i64 (local.get 1)))
  )
)
