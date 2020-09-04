(module
  (type $t0 (func (param i32) (result i32)))
  (func $test (export "test") (type $t0) (param $p0 i32) (result i32)
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
    (call $test
      (local.get $p0)
    )
  )

  (func $t1 (export "t1") (type $t0) (param $p0 i32) (result i32)
    (call $test
      (i32.add
        (local.get $p0)
        (i32.const 1)
      )
    )
  )
  (memory $memory (export "memory") 0)
)
