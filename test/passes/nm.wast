(module
  (memory 0)
  (type $0 (func))
  (func $a (type $0)
    (nop)
  )
  (func $b (type $0)
    (drop
      (loop $loop-out0 $loop-in1
        (nop)
        (i32.const 1000)
      )
    )
  )
  (func $c (type $0)
    (block $top
      (nop)
      (drop
        (i32.const 1000)
      )
      (drop
        (i32.add
          (i32.add
            (i32.const 1001)
            (i32.const 1002)
          )
          (i32.add
            (i32.const 1003)
            (i32.const 1004)
          )
        )
      )
      (br $top)
    )
  )
)
