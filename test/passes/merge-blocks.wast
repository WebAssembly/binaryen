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
  (func $drop-unreachable-br_if (result i32)
    (block $label$0 (result i32)
     (block $label$2 (result i32)
      (br_if $label$2
       (br $label$0
        (i32.const 538976371)
       )
       (i32.const 1918987552)
      )
     )
    )
  )
  (func $drop-block-squared-iloop
   (drop
    (block $label$0 (result i32) ;; this block's type should not change, so the drop remains none and valid
     (drop
      (block $label$1
       (loop $label$2
        (br $label$2)
       )
      )
     )
    )
   )
  )
  (func $br-goes-away-label2-becomes-unreachable
   (block
    (drop
     (block $label$1 (result i32)
      (block $label$2
       (drop
        (br_if $label$1
         (unreachable)
         (i32.eqz
          (br $label$2)
         )
        )
       )
      )
      (i32.const 1)
     )
    )
   )
  )
  (func $loop-block-drop-block-return
   (loop $label$4
    (block $label$5
     (drop
      (block $label$6 (result i32)
       (return)
      )
     )
    )
   )
  )
)

