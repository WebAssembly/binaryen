;; Tests for lowering get_local and set_local.

(module
  (func $dummy)

  (func (export "check_extend_ui32") (param $0 i32) (param $r i64) (result i32)
    (local $x i32)
    (local $result i64)
    (local $extend i64)
    (set_local $x (get_local $0))
    (set_local $result (get_local $r))
    (set_local $extend (i64.extend_u/i32 (get_local $x)))
    (i64.eq (get_local $extend) (get_local $result)))
)

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
