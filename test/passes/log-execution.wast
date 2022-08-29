(module
  (import "env" "func" (func $import))
  (func $nopp
    (nop)
  )
  (func $intt (result i32)
    (i32.const 10)
  )
  (func $workk
    (if (i32.const 0) (nop))
    (drop (i32.const 1))
  )
  (func $loops
    (loop $x
      (call $loops)
      (br $x)
    )
    (if (call $intt)
      (loop $y
        (call $loops)
      )
    )
    (loop
      (drop (i32.const 10))
      (drop (i32.const 20))
      (drop (i32.const 30))
    )
  )
  (func $loops-similar
    (loop $x
      (call $loops)
      (br $x)
    )
  )
)

