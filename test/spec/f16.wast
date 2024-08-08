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
