(module
  (type $0 (func (param i32)))
  (import "global.Math" "pow" (func $Math_pow (param f64 f64) (result f64)))
  (import "env" "invoke_vif" (func $invoke_vif (param i32 i32 f32)))
  (memory 256 256)
  (table 7 7 funcref)
  (elem (i32.const 0) $pow2 $pow.2 $exc $other_safe $other_unsafe $deep_safe $deep_unsafe)
  (func $pow2
    (local $x f64)
    (local $y f64)
    (drop
      (call $Math_pow
        (f64.const 1)
        (f64.const 2)
      )
    )
    (drop
      (call $Math_pow
        (f64.const 1)
        (f64.const 3)
      )
    )
    (drop
      (call $Math_pow
        (f64.const 2)
        (f64.const 1)
      )
    )
    (local.set $x (f64.const 5))
    (drop
      (call $Math_pow
        (local.get $x)
        (f64.const 2)
      )
    )
    (drop
      (call $Math_pow
        (local.tee $y (f64.const 7))
        (f64.const 2)
      )
    )
    (drop
      (call $Math_pow
        (f64.const 8)
        (f64.const 2)
      )
    )
  )
  (func $pow.2
    (drop
      (call $Math_pow
        (f64.const 1)
        (f64.const 0.5)
      )
    )
    (drop
      (call $Math_pow
        (f64.const 1)
        (f64.const 0.51)
      )
    )
  )
  (func $exc
    (call $invoke_vif
      (i32.const 3) ;; other_safe()
      (i32.const 42)
      (f32.const 3.14159)
    )
    (call $invoke_vif
      (i32.const 4) ;; other_unsafe()
      (i32.const 55)
      (f32.const 2.18281828)
    )
    (call $invoke_vif
      (i32.const 5) ;; deep_safe()
      (i32.const 100)
      (f32.const 1.111)
    )
    (call $invoke_vif
      (i32.const 6) ;; deep_unsafe()
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
    (drop
      (call $Math_pow
        (f64.const 1)
        (f64.const 3)
      )
    )
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
(module
  (type $0 (func (param i32)))
  (import "global.Math" "pow" (func $Math_pow (param f64 f64) (result f64)))
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
