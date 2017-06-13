(module
  (func $drop-block
    (block
      (drop
        (block $x (result i32)
          (i32.const 0)
        )
      )
    )
  )
  (func $drop-block-br
    (block
      (drop
        (block $x (result i32)
          (br $x (i32.const 1))
          (i32.const 0)
        )
      )
    )
  )
  (func $drop-block-br-if
    (block
      (drop
        (block $x (result i32)
          (drop (br_if $x (i32.const 1) (i32.const 2)))
          (i32.const 0)
        )
      )
    )
  )
  (func $undroppable-block-br-if (param i32)
    (block
      (drop
        (block $x (result i32)
          (call $undroppable-block-br-if (br_if $x (i32.const 1) (i32.const 2)))
          (i32.const 0)
        )
      )
    )
  )
  (func $drop-block-nested-br-if
    (block
      (drop
        (block $x (result i32)
          (if (i32.const 100)
            (block
              (drop (br_if $x (i32.const 1) (i32.const 2)))
              (nop)
            )
          )
          (i32.const 0)
        )
      )
    )
  )
)

