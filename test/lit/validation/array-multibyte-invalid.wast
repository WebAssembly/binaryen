;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

(module
  (type $imm (array i8))
  (type $any_arr (array (mut anyref)))

  ;; CHECK: unexpected false: array store type must be mutable
  (func $store-immutable (param $a (ref $imm))
    (i32.store8 (type $imm) (local.get $a) (i32.const 0) (i32.const 0))
  )

  ;; CHECK: unexpected false: array load type must be a numeric type
  (func $load-non-numeric (param $a (ref $any_arr))
    (drop (i32.load8_u (type $any_arr) (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: array store type must be a numeric type
  (func $store-non-numeric (param $a (ref $any_arr))
    (i32.store8 (type $any_arr) (local.get $a) (i32.const 0) (i32.const 0))
  )

  ;; CHECK: unexpected false: alignment must not exceed natural
  (func $bad-align (param $a (ref $imm))
    (drop (i32.load8_u (type $imm) align=2 (local.get $a) (i32.const 0)))
  )

  ;; CHECK: unexpected false: offset must be u32
  (func $bad-offset (param $a (ref $imm))
    (drop (i32.load8_u (type $imm) offset=4294967296 (local.get $a) (i32.const 0)))
  )
)
