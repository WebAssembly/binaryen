(module
  (func $dummy)

  (func (export "i32.popcnt") (param $0 i32) (result i32)
    (i32.popcnt (get_local $0)))

  (func (export "check_popcnt_i64") (param $0 i64) (param $r i64) (result i32)
    (i64.eq (i64.popcnt (get_local $0)) (get_local $r)))

  (func (export "check_extend_ui32") (param $0 i32) (param $r i64) (result i32)
    (i64.eq (i64.extend_u/i32 (get_local $0)) (get_local $r)))

  (func (export "check_extend_si32") (param $0 i32) (param $r i64) (result i32)
    (i64.eq (i64.extend_s/i32 (get_local $0)) (get_local $r)))

  (func (export "check_eqz_i64") (param $0 i64) (result i32)
    (i64.eqz (get_local $0)))

  (func (export "i32.clz") (param $0 i32) (result i32)
    (i32.clz (get_local $0)))

  (func (export "i32.ctz") (param $0 i32) (result i32)
    (i32.ctz (get_local $0)))

  (func (export "check_clz_i64") (param $0 i64) (param $r i64) (result i32)
    (i64.eq (i64.clz (get_local $0)) (get_local $r)))

  (func (export "check_ctz_i64") (param $0 i64) (param $r i64) (result i32)
    (i64.eq (i64.ctz (get_local $0)) (get_local $r)))
)

(assert_return (invoke "i32.popcnt" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.popcnt" (i32.const 1)) (i32.const 1))
(assert_return (invoke "i32.popcnt" (i32.const 0x7fffffff)) (i32.const 31))
(assert_return (invoke "i32.popcnt" (i32.const 0xffffffff)) (i32.const 32))

(assert_return (invoke "check_popcnt_i64" (i32.const 0) (i32.const 0)
                                          (i32.const 0) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 1) (i32.const 0)
                                          (i32.const 1) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 0) (i32.const 1)
                                          (i32.const 1) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 0x7fffffff) (i32.const 0)
                                          (i32.const 31) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 0x7fffffff) (i32.const 1)
                                          (i32.const 32) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 0x7fffffff) (i32.const 0x7fffffff)
                                          (i32.const 62) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_popcnt_i64" (i32.const 0xffffffff) (i32.const 0xffffffff)
                                          (i32.const 64) (i32.const 0))
               (i32.const 1))

(assert_return (invoke "check_extend_ui32" (i32.const 0)
                                           (i32.const 0) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_ui32" (i32.const 1)
                                           (i32.const 1) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_ui32" (i32.const 0x7fffffff)
                                           (i32.const 0x7fffffff) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_ui32" (i32.const 0xffffffff)
                                           (i32.const 0xffffffff) (i32.const 0))
               (i32.const 1))

(assert_return (invoke "check_extend_si32" (i32.const 0)
                                           (i32.const 0) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_si32" (i32.const 1)
                                           (i32.const 1) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_si32" (i32.const 0x7fffffff)
                                           (i32.const 0x7fffffff) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_extend_si32" (i32.const 0x80000000)
                                           (i32.const 0x80000000) (i32.const 0xffffffff))
               (i32.const 1))
(assert_return (invoke "check_extend_si32" (i32.const 0xffffffff)
                                           (i32.const 0xffffffff) (i32.const 0xffffffff))
               (i32.const 1))

(assert_return (invoke "check_eqz_i64" (i32.const 0) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_eqz_i64" (i32.const 1) (i32.const 0))
               (i32.const 0))
(assert_return (invoke "check_eqz_i64" (i32.const 0) (i32.const 1))
               (i32.const 0))

(assert_return (invoke "i32.clz" (i32.const 0)) (i32.const 32))
(assert_return (invoke "i32.clz" (i32.const 1)) (i32.const 31))
(assert_return (invoke "i32.clz" (i32.const 0x7fffffff)) (i32.const 1))
(assert_return (invoke "i32.clz" (i32.const 0xffffffff)) (i32.const 0))

(assert_return (invoke "i32.ctz" (i32.const 0)) (i32.const 32))
(assert_return (invoke "i32.ctz" (i32.const 1)) (i32.const 0))
(assert_return (invoke "i32.ctz" (i32.const 0xfffffffe)) (i32.const 1))
(assert_return (invoke "i32.ctz" (i32.const 0x80000000)) (i32.const 31))

(assert_return (invoke "check_clz_i64"
                       (i32.const 0) (i32.const 0)
                       (i32.const 64) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_clz_i64"
                       (i32.const 1) (i32.const 0)
                       (i32.const 63) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_clz_i64"
                       (i32.const 0x80000000) (i32.const 0)
                       (i32.const 32) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_clz_i64"
                       (i32.const 0) (i32.const 1)
                       (i32.const 31) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_clz_i64"
                       (i32.const 0) (i32.const 0x80000000)
                       (i32.const 0) (i32.const 0))
               (i32.const 1))

(assert_return (invoke "check_ctz_i64"
                       (i32.const 0) (i32.const 0)
                       (i32.const 64) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_ctz_i64"
                       (i32.const 0) (i32.const 0x80000000)
                       (i32.const 63) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_ctz_i64"
                       (i32.const 0) (i32.const 1)
                       (i32.const 32) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_ctz_i64"
                       (i32.const 0x80000000) (i32.const 0)
                       (i32.const 31) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "check_ctz_i64"
                       (i32.const 1) (i32.const 0)
                       (i32.const 0) (i32.const 0))
               (i32.const 1))
