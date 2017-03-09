(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (import "global.Math" "pow" (func $Math_pow (param f64 f64) (result f64)))
  (func $b0 (type $0) (param $x i32)
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 8)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1023)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1024)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 2048)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (i32.const 4)
          (get_local $x)
        )
      )
    )
  )
  (func $load-off-2 "load-off-2" (param $0 i32) (result i32)
    (i32.store offset=2
      (i32.add
        (i32.const 1)
        (i32.const 3)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 3)
        (i32.const 1)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (get_local $0)
        (i32.const 5)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 7)
        (get_local $0)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -11) ;; do not fold this!
        (get_local $0)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (get_local $0)
        (i32.const -13) ;; do not fold this!
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -15)
        (i32.const 17)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -21)
        (i32.const 19)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.const 23)
      (get_local $0)
    )
    (i32.store offset=2
      (i32.const -25)
      (get_local $0)
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 2)
          (i32.const 4)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 4)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (get_local $0)
          (i32.const 6)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.const 8)
      )
    )
    (i32.load offset=2
      (i32.add
        (i32.const 10)
        (get_local $0)
      )
    )
  )
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
    (set_local $x (f64.const 5))
    (drop
      (call $Math_pow
        (get_local $x)
        (f64.const 2)
      )
    )
    (drop
      (call $Math_pow
        (tee_local $y (f64.const 7))
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
