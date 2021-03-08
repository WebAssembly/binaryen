(module
  (type $t0 (func (param i32) (result i32)))
  (func $fib (export "fib") (type $t0) (param $p0 i32) (result i32)
    (if $I0
      (i32.le_s
        (local.get $p0)
        (i32.const 2)
      )
      (then
        (return
          (local.get $p0)
        )
      )
    )
    (i32.add
      (call $fib
        (i32.sub
          (local.get $p0)
          (i32.const 1)
        )
      )
      (call $fib
        (i32.sub
          (local.get $p0)
          (i32.const 2)
        )
      )
    )
  )
  (func $looped (export "looped") (type $t0) (param $p0 i32) (result i32)
    (loop $L0
      (if $I1
        (i32.ge_s
          (local.get $p0)
          (i32.const 0)
        )
        (then
          (local.set $p0
            (i32.sub
              (local.get $p0)
              (i32.const 1)
            )
          )
          (br $L0)
        )
      )
    )
    (local.get $p0)
  )

  (func $t0 (export "t0") (type $t0) (param $p0 i32) (result i32)
    (call $looped
      (local.get $p0)
    )
  )

  (func $t1 (export "t1") (type $t0) (param $p0 i32) (result i32)
    (call $looped
      (i32.add
        (local.get $p0)
        (i32.const 1)
      )
    )
  )
  (func $t2 (export "t2") (type $t0) (param $p0 i32) (result i32)
    (call $fib
      (local.get $p0)
    )
  )

  (func $t3 (export "t3") (type $t0) (param $p0 i32) (result i32)
    (call $fib
      (i32.add
        (local.get $p0)
        (i32.const 1)
      )
    )
  )
  (memory $memory (export "memory") 0)
)
