;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s
;; RUN: not wasm-opt -all --disable-multibyte %s 2>&1 | filecheck %s --check-prefix=NO-FEATURE

(module
  (type $imm_i8_array (array i8))
  (type $imm_i32_array (array i32))
  (type $any_array (array (mut anyref)))
  (type $func_array (array (mut funcref)))
  (type $v128_array (array (mut v128)))

  ;; NO-FEATURE: unexpected false: array.store requires multibyte
  ;; CHECK: unexpected false: array store type must be mutable
  (func $store-immutable (param $a (ref $imm_i8_array))
    (i32.store8 (type $imm_i8_array) (local.get $a) (i32.const 0) (i32.const 0))
  )

  ;; The element type does not need to be i8 for the array to be immutable.
  ;; CHECK: unexpected false: array store type must be mutable
  (func $store-immutable-i32 (param $a (ref $imm_i32_array))
    (i32.store (type $imm_i32_array) (local.get $a) (i32.const 0) (i32.const 0))
  )

  ;; NO-FEATURE: unexpected false: array.load requires multibyte
  ;; CHECK: unexpected false: array load type must be a numeric type
  (func $load-non-numeric (param $a (ref $any_array))
    (drop (i32.load8_u (type $any_array) (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: array store type must be a numeric type
  (func $store-non-numeric (param $a (ref $any_array))
    (i32.store8 (type $any_array) (local.get $a) (i32.const 0) (i32.const 0))
  )

  ;; Function references are not numeric either.
  ;; CHECK: unexpected false: array load type must be a numeric type
  (func $load-func (param $a (ref $func_array))
    (drop (i32.load8_u (type $func_array) (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: alignment must not exceed natural
  (func $bad-align (param $a (ref $imm_i8_array))
    (drop (i32.load8_u (type $imm_i8_array) align=2 (local.get $a) (i32.const 0)))
  )

  ;; The natural alignment is that of the access, not of the array's elements.
  ;; CHECK: unexpected false: alignment must not exceed natural
  (func $bad-align-v128 (param $a (ref $v128_array))
    (drop (v128.load (type $v128_array) align=32 (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: offset must be u32
  (func $bad-offset (param $a (ref $imm_i8_array))
    (drop (i32.load8_u (type $imm_i8_array) offset=4294967296 (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: offset must be u32
  (func $bad-offset-store (param $a (ref $v128_array))
    (v128.store (type $v128_array) offset=4294967296 (local.get $a) (i32.const 0)
      (v128.const i32x4 0 0 0 0)
    )
  )
)
