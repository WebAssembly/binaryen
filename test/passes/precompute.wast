(module
  (memory 0)
  (type $0 (func (param i32)))
  (func $x (type $0) (param $x i32)
    (drop
      (i32.add
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (get_local $x)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.sub
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (i32.sub
        (i32.add
          (i32.const 0)
          (i32.const 4)
        )
        (i32.const 1)
      )
    )
    (loop $in
      (br $in)
    )
    (block $b
      (br_if $b (i32.const 0))
      (br_if $b (i32.const 1))
      (call $x (i32.const 4))
    )
    (block $c
      (br_if $c (i32.const 0))
      (call $x (i32.const 4))
      (br_if $c (i32.const 1))
    )
  )
)
