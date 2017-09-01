(module
  (func $a
    (if (i32.const 1)
      (unreachable)
    )
  )
  (func $b
    (if (i32.const 1)
      (unreachable)
      (unreachable)
    )
  )
  (func $a-block
    (block
      (if (i32.const 1)
        (unreachable)
      )
    )
  )
  (func $b-block
    (block
      (if (i32.const 1)
        (unreachable)
        (unreachable)
      )
    )
  )
  (func $a-prepost
    (nop)
    (if (i32.const 1)
      (unreachable)
    )
    (nop)
  )
  (func $b-prepost
    (nop)
    (if (i32.const 1)
      (unreachable)
      (unreachable)
    )
    (nop)
  )
  (func $a-block-prepost
    (nop)
    (block
      (if (i32.const 1)
        (unreachable)
      )
    )
    (nop)
  )
  (func $b-block-prepost
    (nop)
    (block
      (if (i32.const 1)
        (unreachable)
        (unreachable)
      )
    )
    (nop)
  )
  (func $recurse
    (block $a
      (nop)
      (block $b
        (nop)
        (br $b)
        (nop)
      )
      (nop)
    )
  )
  (func $recurse-b
    (block $a
      (nop)
      (block $b
        (nop)
        (br $a)
        (nop)
      )
      (nop)
    )
  )
)

