;; Test float 16 operations.

(module
  (memory (data "\40\51\AD\DE"))

  (func (export "f32.load_f16") (result f32) (f32.load_f16 (i32.const 0)))
  (func (export "f32.store_f16") (f32.store_f16 (i32.const 0) (f32.const 100.5)))
  (func (export "i32.load16_u") (result i32) (i32.load16_u (i32.const 2)))
  (func (export "f16x8.splat") (param $0 f32) (result v128) (f16x8.splat (local.get $0)))
  (func (export "f16x8.extract_lane_first") (param $0 v128) (result f32) (f16x8.extract_lane 0 (local.get $0)))
  (func (export "f16x8.extract_lane_last") (param $0 v128) (result f32) (f16x8.extract_lane 7 (local.get $0)))
  (func (export "f16x8.replace_lane_first") (param $0 v128) (param $1 f32) (result v128) (f16x8.replace_lane 0 (local.get $0) (local.get $1)))
  (func (export "f16x8.replace_lane_last") (param $0 v128) (param $1 f32) (result v128) (f16x8.replace_lane 7 (local.get $0) (local.get $1)))
  (func (export "f16x8.eq") (param $0 v128) (param $1 v128) (result v128) (f16x8.eq (local.get $0) (local.get $1)))
  (func (export "f16x8.ne") (param $0 v128) (param $1 v128) (result v128) (f16x8.ne (local.get $0) (local.get $1)))
  (func (export "f16x8.lt") (param $0 v128) (param $1 v128) (result v128) (f16x8.lt (local.get $0) (local.get $1)))
  (func (export "f16x8.gt") (param $0 v128) (param $1 v128) (result v128) (f16x8.gt (local.get $0) (local.get $1)))
  (func (export "f16x8.le") (param $0 v128) (param $1 v128) (result v128) (f16x8.le (local.get $0) (local.get $1)))
  (func (export "f16x8.ge") (param $0 v128) (param $1 v128) (result v128) (f16x8.ge (local.get $0) (local.get $1)))
  (func (export "f16x8.add") (param $0 v128) (param $1 v128) (result v128) (f16x8.add (local.get $0) (local.get $1)))
  (func (export "f16x8.sub") (param $0 v128) (param $1 v128) (result v128) (f16x8.sub (local.get $0) (local.get $1)))
  (func (export "f16x8.mul") (param $0 v128) (param $1 v128) (result v128) (f16x8.mul (local.get $0) (local.get $1)))
  (func (export "f16x8.div") (param $0 v128) (param $1 v128) (result v128) (f16x8.div (local.get $0) (local.get $1)))
  (func (export "f16x8.min") (param $0 v128) (param $1 v128) (result v128) (f16x8.min (local.get $0) (local.get $1)))
  (func (export "f16x8.max") (param $0 v128) (param $1 v128) (result v128) (f16x8.max (local.get $0) (local.get $1)))
  (func (export "f16x8.pmin") (param $0 v128) (param $1 v128) (result v128) (f16x8.pmin (local.get $0) (local.get $1)))
  (func (export "f16x8.pmax") (param $0 v128) (param $1 v128) (result v128) (f16x8.pmax (local.get $0) (local.get $1)))
  (func (export "f16x8.abs") (param $0 v128) (result v128) (f16x8.abs (local.get $0)))
  (func (export "f16x8.neg") (param $0 v128) (result v128) (f16x8.neg (local.get $0)))
  (func (export "f16x8.sqrt") (param $0 v128) (result v128) (f16x8.sqrt (local.get $0)))
  (func (export "f16x8.ceil") (param $0 v128) (result v128) (f16x8.ceil (local.get $0)))
  (func (export "f16x8.floor") (param $0 v128) (result v128) (f16x8.floor (local.get $0)))
  (func (export "f16x8.trunc") (param $0 v128) (result v128) (f16x8.trunc (local.get $0)))
  (func (export "f16x8.nearest") (param $0 v128) (result v128) (f16x8.nearest (local.get $0)))
  (func (export "f16x8.madd") (param $0 v128) (param $1 v128) (param $2 v128) (result v128) (f16x8.madd (local.get $0) (local.get $1) (local.get $2)))
  (func (export "f16x8.nmadd") (param $0 v128) (param $1 v128) (param $2 v128) (result v128) (f16x8.nmadd (local.get $0) (local.get $1) (local.get $2)))
  (func (export "i16x8.trunc_sat_f16x8_s") (param $0 v128) (result v128) (i16x8.trunc_sat_f16x8_s (local.get $0)))
  (func (export "i16x8.trunc_sat_f16x8_u") (param $0 v128) (result v128) (i16x8.trunc_sat_f16x8_u (local.get $0)))
  (func (export "f16x8.convert_i16x8_s") (param $0 v128) (result v128) (f16x8.convert_i16x8_s (local.get $0)))
  (func (export "f16x8.convert_i16x8_u") (param $0 v128) (result v128) (f16x8.convert_i16x8_u (local.get $0)))
  (func (export "f32x4.promote_low_f16x8") (param $0 v128) (result v128) (f32x4.promote_low_f16x8 (local.get $0)))
  (func (export "f16x8.demote_f32x4_zero") (param $0 v128) (result v128) (f16x8.demote_f32x4_zero (local.get $0)))
  (func (export "f16x8.demote_f64x2_zero") (param $0 v128) (result v128) (f16x8.demote_f64x2_zero (local.get $0)))
  ;; Multiple operation tests:
  (func (export "splat_replace") (result v128) (f16x8.replace_lane 0 (f16x8.splat (f32.const 1)) (f32.const 99))
 )
)

(assert_return (invoke "f32.load_f16") (f32.const 42.0))
(invoke "f32.store_f16")
(assert_return (invoke "f32.load_f16") (f32.const 100.5))
;; Ensure that the above operations didn't write to memory they shouldn't have.
(assert_return (invoke "i32.load16_u") (i32.const 0xDEAD))

;; lane accesses
(assert_return (invoke "f16x8.splat" (f32.const 100.5)) (v128.const i16x8 0x5648 0x5648 0x5648 0x5648 0x5648 0x5648 0x5648 0x5648))
(assert_return (invoke "f16x8.extract_lane_first" (v128.const i16x8 0x5648 0 0 0 0 0 0 0)) (f32.const 100.5))
(assert_return (invoke "f16x8.extract_lane_last" (v128.const i16x8 0 0 0 0 0 0 0 0xc500)) (f32.const -5))
(assert_return (invoke "f16x8.replace_lane_first" (v128.const i64x2 0 0) (f32.const 100.5)) (v128.const i16x8 0x5648 0 0 0 0 0 0 0))
(assert_return (invoke "f16x8.replace_lane_last" (v128.const i64x2 0 0) (f32.const 100.5)) (v128.const i16x8 0 0 0 0 0 0 0 0x5648))

;; comparisons
(assert_return (invoke "f16x8.eq"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8  -1 0      0      0      -1      0      0     0)
)
(assert_return (invoke "f16x8.ne"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8   0 -1     -1     -1     0      -1     -1     -1)
)
(assert_return (invoke "f16x8.lt"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8   0 -1     0      0     0       0      0      0)
)
(assert_return (invoke "f16x8.gt"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8   0 0      -1     0      0       0      -1    0)
)
(assert_return (invoke "f16x8.le"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8  -1 -1     0      0      -1     0      0      0)
)
(assert_return (invoke "f16x8.ge"
    ;;                0 -1     1      nan    inf    nan    inf    nan
    ;;                0 0      -1     nan    inf    0      -inf   inf
    (v128.const i16x8 0 0xbc00 0x3c00 0x7e00 0x7c00 0x7e00 0x7c00 0x7e00)
    (v128.const i16x8 0 0      0xbc00 0x7e00 0x7c00 0      0xfc00 0x7c00)
  )
  (v128.const i16x8  -1 0      -1     0      -1     0      -1     0)
)

;; arithmetic operations
(assert_return (invoke "f16x8.add"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     inf    3      -1     0      1      2
    (v128.const i16x8 0x7e00 0x7e00  0x7c00 0x4200 0xbc00 0      0x3c00 0x4000))
(assert_return (invoke "f16x8.sub"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     nan    0      -1     -2     1      0
    (v128.const i16x8 0x7e00 0x7e00  0x7e00 0      0xbc00 0xc000 0x3c00 0))
(assert_return (invoke "f16x8.mul"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     inf    2.25   0      -1     0      1
    (v128.const i16x8 0x7e00 0x7e00  0x7c00 0x4080 0x8000 0xbc00 0      0x3c00))
(assert_return (invoke "f16x8.div"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     nan    1      -inf   -1     inf    1
    (v128.const i16x8 0x7e00 0x7e00  0x7e00 0x3c00 0xfc00 0xbc00 0x7c00 0x3c00))
(assert_return (invoke "f16x8.min"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     inf    1.5    -1     -1     0      1
    (v128.const i16x8 0x7e00 0x7e00  0x7c00 0x3e00 0xbc00 0xbc00 0      0x3c00))
(assert_return (invoke "f16x8.max"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    nan     inf    1.5    0      1      1      1
    (v128.const i16x8 0x7e00 0x7e00  0x7c00 0x3e00 0      0x3c00 0x3c00 0x3c00))
(assert_return (invoke "f16x8.pmin"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    -nan    inf    1.5    -1     -1     0      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0      0x3c00))
(assert_return (invoke "f16x8.pmax"
    ;;                nan    -nan    inf    1.5    -1     -1     1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0xbc00 0xbc00 0x3c00 0x3c00)
    ;;                42     -nan    inf    1.5    0      1      0      1
    (v128.const i16x8 0x5140 0xfe00  0x7c00 0x3e00 0      0x3c00 0      0x3c00))
    ;;                nan    -nan    inf    1.5    0      1      1      1
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0x3e00 0      0x3c00 0x3c00 0x3c00))

;; unary arithmetic
(assert_return (invoke "f16x8.abs"
    ;;                nan    -nan    inf    -inf   -1     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0xfc00 0xbc00 0x3c00 0x3e00 0x3ccd))
    ;;                nan    nan     inf    inf    1      1      1.5    1.2...
    (v128.const i16x8 0x7e00 0x7e00  0x7c00 0x7c00 0x3c00 0x3c00 0x3e00 0x3ccd))
(assert_return (invoke "f16x8.neg"
    ;;                nan    -nan    inf    -inf   -1     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0xfe00  0x7c00 0xfc00 0xbc00 0x3c00 0x3e00 0x3ccd))
    ;;                -nan   nan     -inf   inf    1      -1     -1.5   -1.2...
    (v128.const i16x8 0xfe00 0x7e00  0xfc00 0x7c00 0x3c00 0xbc00 0xbe00 0xbccd))
;; XXX Avoid tests that return -nan since it's non-deterministic.
(assert_return (invoke "f16x8.sqrt"
    ;;                nan    0       inf    4      16     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0       0x7c00 0x4400 0x4c00 0x3c00 0x3e00 0x3ccd))
    ;;                nan    0       inf    2      4      1      1.22.. 1.09...
    (v128.const i16x8 0x7e00 0       0x7c00 0x4000 0x4400 0x3c00 0x3ce6 0x3c62))
(assert_return (invoke "f16x8.ceil"
    ;;                nan    0       inf    -inf   -1     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x3e00 0x3ccd))
    ;;                nan    0       inf    -inf   -1     1      2      2
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x4000 0x4000))
(assert_return (invoke "f16x8.floor"
    ;;                nan    0       inf    -inf   -1     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x3e00 0x3ccd))
    ;;                nan    0       inf    -inf   -1     1      1      1
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x3c00 0x3c00))
(assert_return (invoke "f16x8.nearest"
    ;;                nan    0       inf    -inf   -1     1      1.5    1.2...
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x3e00 0x3ccd))
    ;;                nan    0       inf    -inf   -1     1      2      1
    (v128.const i16x8 0x7e00 0       0x7c00 0xfc00 0xbc00 0x3c00 0x4000 0x3c00))
;; ternary operations
(assert_return (invoke "f16x8.madd"
    ;; Lane 0 illustrates the difference between fused/unfused. e.g.
    ;; fused: (positive overflow) + -inf = -inf
    ;; unfused: (inf) + -inf = NaN
    ;;
    ;;                1e4    inf    -1      0      1      1.5    -2     1
    (v128.const i16x8 0x70e2 0x7c00 0xbc00  0      0x3c00 0x3e00 0xc000 0x3c00)
    ;;                1e4    inf    -1      0      1      1.5    4      1
    (v128.const i16x8 0x70e2 0x7c00 0xbc00  0      0x3c00 0x3e00 0x4400 0x3c00)
    ;;                -inf   inf    -1      0      1      2      1      -1
    (v128.const i16x8 0xfc00 0x7c00 0xbc00  0      0x3c00 0x4000 0x3c00 0xbc00))
    ;;                -inf   inf    0       0      2      4.25   -7     0
    (v128.const i16x8 0xfc00 0x7c00 0       0      0x4000 0x4440 0xc700 0))
(assert_return (invoke "f16x8.nmadd"
    ;; Lane 0 illustrates the difference between fused/unfused. e.g.
    ;; fused: -(positive overflow) + inf = inf
    ;; unfused: (-inf) + -inf = NaN
    ;;
    ;;                1e4    -inf   -1      0      1      1.5    -2     1
    (v128.const i16x8 0x70e2 0xfc00 0xbc00  0      0x3c00 0x3e00 0xc000 0x3c00)
    ;;                1e4    inf    -1      0      1      1.5    4      1
    (v128.const i16x8 0x70e2 0x7c00 0xbc00  0      0x3c00 0x3e00 0x4400 0x3c00)
    ;;                inf    inf    -1      0      1      2      1      -1
    (v128.const i16x8 0x7c00 0x7c00 0xbc00  0      0x3c00 0x4000 0x3c00 0xbc00))
    ;;                inf    inf    -2      0      0      -0.25  9      -2
    (v128.const i16x8 0x7c00 0x7c00 0xc000  0      0      0xb400 0x4880 0xc000))

(assert_return (invoke "splat_replace")
    (v128.const i16x8 0x5630 0x3c00 0x3c00 0x3c00 0x3c00 0x3c00 0x3c00 0x3c00)
)

;; conversions
(assert_return (invoke "i16x8.trunc_sat_f16x8_s"
    ;;                42     nan    inf    -inf   65504  -65504 0 0
    (v128.const i16x8 0x5140 0x7e00 0x7c00 0xfc00 0x7bff 0xfbff 0 0))
    (v128.const i16x8 42     0      32767  -32768 32767  -32768 0 0))
(assert_return (invoke "i16x8.trunc_sat_f16x8_u"
    ;;                42     nan    inf    -inf   65504  -65504 0 0
    (v128.const i16x8 0x5140 0x7e00 0x7c00 0xfc00 0x7bff 0xfbff 0 0))
    (v128.const i16x8 42     0      65535  0      65504  0      0 0))
(assert_return (invoke "f16x8.convert_i16x8_s"
    ;; 32767 is not representable as a whole integer in FP16, so it becomes 32768.
    (v128.const i16x8 0 1      -1     32767  -32768 0 0 0))
    ;;                0 1      -1     32768  -32768 0 0 0
    (v128.const i16x8 0 0x3c00 0xbc00 0x7800 0xf800 0 0 0))
(assert_return (invoke "f16x8.convert_i16x8_u"
    ;; Unlike f32/64, f16 can't represent the full 2^16 integer range so 2^16 becomes infinity.
    (v128.const i16x8 0 1      -1     -32    0 0 0 0))
    ;;                  1      inf    65504
    (v128.const i16x8 0 0x3c00 0x7c00 0x7bff 0 0 0 0))

(assert_return (invoke "f32x4.promote_low_f16x8"
    ;;                1.0    -1.0   2.0    -2.0   0 0 0 0
    (v128.const i16x8 0x3c00 0xbc00 0x4000 0xc000 0 0 0 0))
    ;;                1.0        -1.0       2.0        -2.0
    (v128.const i32x4 0x3f800000 0xbf800000 0x40000000 0xc0000000))

;; Edge cases: Infinities, NaNs, Zeros
(assert_return (invoke "f32x4.promote_low_f16x8"
    ;;                inf    -inf   nan    -0.0   0 0 0 0
    (v128.const i16x8 0x7c00 0xfc00 0x7e00 0x8000 0 0 0 0))
    ;;                inf        -inf       nan        -0.0
    (v128.const i32x4 0x7f800000 0xff800000 0x7fc00000 0x80000000))

;; Edge cases: Denormal
(assert_return (invoke "f32x4.promote_low_f16x8"
    ;;                denormal
    (v128.const i16x8 0x0001 0      0 0 0 0 0 0))
    ;;                2^-24
    (v128.const i32x4 0x33800000 0      0 0))

(assert_return (invoke "f16x8.demote_f32x4_zero"
    ;;                1.0        2.0        3.0        4.0
    (v128.const i32x4 0x3f800000 0x40000000 0x40400000 0x40800000))
    ;;                1.0    2.0    3.0    4.0    0 0 0 0
    (v128.const i16x8 0x3c00 0x4000 0x4200 0x4400 0 0 0 0))

(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                1.0                2.0
    (v128.const i64x2 0x3ff0000000000000 0x4000000000000000))
    ;;                1.0    2.0    0 0 0 0 0 0
    (v128.const i16x8 0x3c00 0x4000 0 0 0 0 0 0))

;; Edge cases: Infinities, NaNs, Zeros
(assert_return (invoke "f16x8.demote_f32x4_zero"
    ;;                inf        -inf       nan        -0.0
    (v128.const i32x4 0x7f800000 0xff800000 0x7fc00000 0x80000000))
    ;;                inf    -inf   nan    -0.0   0 0 0 0
    (v128.const i16x8 0x7c00 0xfc00 0x7e00 0x8000 0 0 0 0))

;; Edge cases: Overflow
(assert_return (invoke "f16x8.demote_f32x4_zero"
    ;;                1e5        -1e5       65504      -65504
    (v128.const i32x4 0x47c35000 0xc7c35000 0x477fe000 0xc77fe000))
    ;;                inf    -inf   65504  -65504 0 0 0 0
    (v128.const i16x8 0x7c00 0xfc00 0x7bff 0xfbff 0 0 0 0))

;; Edge cases: Infinities, NaNs, Zeros
(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                inf                -inf
    (v128.const i64x2 0x7ff0000000000000 0xfff0000000000000))
    ;;                inf    -inf   0 0 0 0 0 0
    (v128.const i16x8 0x7c00 0xfc00 0 0 0 0 0 0))

(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                nan                -0.0
    (v128.const i64x2 0x7ff8000000000000 0x8000000000000000))
    ;;                nan    -0.0   0 0 0 0 0 0
    (v128.const i16x8 0x7e00 0x8000 0 0 0 0 0 0))

;; Edge cases: Overflow
(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                1e5                -1e5
    (v128.const i64x2 0x40f86a0000000000 0xc0f86a0000000000))
    ;;                inf    -inf   0 0 0 0 0 0
    (v128.const i16x8 0x7c00 0xfc00 0 0 0 0 0 0))

(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                65504              -65504
    (v128.const i64x2 0x40effc0000000000 0xc0effc0000000000))
    ;;                65504  -65504 0 0 0 0 0 0
    (v128.const i16x8 0x7bff 0xfbff 0 0 0 0 0 0))

;; Precision loss cases
(assert_return (invoke "f16x8.demote_f32x4_zero"
    ;;                1.000244140625 1.000244140625 1.000244140625 1.000244140625
    (v128.const i32x4 0x3f800800     0x3f800800     0x3f800800     0x3f800800))
    ;;                1.0    1.0    1.0    1.0     0 0 0 0
    (v128.const i16x8 0x3c00 0x3c00 0x3c00 0x3c00 0 0 0 0))

(assert_return (invoke "f16x8.demote_f64x2_zero"
    ;;                1.000244140625      1.000244140625
    (v128.const i64x2 0x3ff0010000000000 0x3ff0010000000000))
    ;;                1.0    1.0    0 0 0 0 0 0
    (v128.const i16x8 0x3c00 0x3c00 0 0 0 0 0 0))

;; TODO: Test Non-canonical NaN cases when an f16 const is supported in wat.
;; (assert_return (invoke "f16x8.demote_f32x4_zero"
;;    ;;                non-canonical NaN
;;    (v128.const i32x4 0x7f800001 0 0 0))
;;    (v128.const f16x8 nan:arithmetic 0 0 0 0 0 0 0))
;; (assert_return (invoke "f16x8.demote_f64x2_zero"
;;    ;;                non-canonical NaN
;;    (v128.const i64x2 0x7ff0000000000001 0))
;;    (v128.const f16x8 nan:arithmetic 0 0 0 0 0 0 0))
