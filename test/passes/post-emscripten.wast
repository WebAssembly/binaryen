(module
  (type $0 (func (param i32)))
  (import "env" "invoke_vif" (func $invoke_vif (param i32 i32 f32)))
  (memory 256 256)
  (table 7 7 funcref)
  (elem (i32.const 0) $f1 $exc $other_safe $other_unsafe $deep_safe $deep_unsafe)
  (func $f1)
  (func $exc
    (call $invoke_vif
      (i32.const 2) ;; other_safe()
      (i32.const 42)
      (f32.const 3.14159)
    )
    (call $invoke_vif
      (i32.const 3) ;; other_unsafe()
      (i32.const 55)
      (f32.const 2.18281828)
    )
    (call $invoke_vif
      (i32.const 4) ;; deep_safe()
      (i32.const 100)
      (f32.const 1.111)
    )
    (call $invoke_vif
      (i32.const 5) ;; deep_unsafe()
      (i32.const 999)
      (f32.const 1.414)
    )
    (call $invoke_vif
      (i32.add (i32.const 1) (i32.const 1)) ;; nonconstant
      (i32.const 42)
      (f32.const 3.14159)
    )
  )
  (func $other_safe (param i32) (param f32)
  )
  (func $other_unsafe (param i32) (param f32)
  )
  (func $deep_safe (param i32) (param f32)
    (call $other_safe (unreachable) (unreachable))
  )
  (func $deep_unsafe (param i32) (param f32)
    (call $other_unsafe (unreachable) (unreachable))
  )
)
(module ;; no invokes
  (func $call
    (call $call)
  )
)
(module ;; non-constant base for elem
  (type $0 (func (param i32)))
  (import "env" "invoke_vif" (func $invoke_vif (param i32 i32 f32)))
  (import "env" "glob" (global $glob i32)) ;; non-constant table offset
  (memory 256 256)
  (table 7 7 funcref)
  (elem (global.get $glob) $other_safe)
  (func $exc
    (call $invoke_vif
      (i32.const 3) ;; other_safe()
      (i32.const 42)
      (f32.const 3.14159)
    )
  )
  (func $other_safe (param i32) (param f32)
  )
)
(module ;; indirect call in the invoke target, which we assume might throw
  (type $none_=>_none (func))
  (import "env" "invoke_vif" (func $invoke_vif (param i32 i32 f32)))
  (import "env" "glob" (global $glob i32)) ;; non-constant table offset
  (memory 256 256)
  (table 7 7 funcref)
  (elem (i32.const 0) $other_safe)
  (func $exc
    (call $invoke_vif
      (i32.const 0) ;; other_safe()
      (i32.const 42)
      (f32.const 3.14159)
    )
  )
  (func $other_safe (param i32) (param f32)
   (call_indirect (type $none_=>_none)
    (i32.const 0)
   )
  )
)
