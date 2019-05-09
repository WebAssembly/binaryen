(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (import "global.Math" "pow" (func $Math_pow (param f64 f64) (result f64)))
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
)
