(module
  (global $global$0 (mut i32) (i32.const 10))
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
  (func $if-block
   (block $label
    (if
     (i32.const 1)
     (block
      (drop (i32.const 2))
      (drop (i32.const 3))
     )
    )
   )
  )
  (func $if-block-bad
   (block $label
    (if
     (br $label) ;; use outside of arm
     (block
      (drop (i32.const 2))
      (drop (i32.const 3))
     )
    )
   )
  )
  (func $if-block-br
   (block $label
    (if
     (i32.const 1)
     (br $label)
    )
   )
  )
  (func $if-block-br-1
   (block $label
    (if
     (i32.const 1)
     (br $label)
     (drop (i32.const 3))
    )
   )
  )
  (func $if-block-br-2
   (block $label
    (if
     (i32.const 1)
     (drop (i32.const 3))
     (br $label)
    )
   )
  )
  (func $if-block-br-3
   (block $label
    (if
     (i32.const 1)
     (br $label)
     (br $label)
    )
   )
  )
  (func $if-block-br-4-eithre
   (block $label
    (if
     (i32.const 1)
     (drop (i32.const 2))
     (drop (i32.const 3))
    )
   )
  )
  (func $if-block-br-5-value (result i32)
   (block $label (result i32)
    (if (result i32)
     (i32.const 1)
     (i32.const 2)
     (i32.const 3)
    )
   )
  )
  (func $restructure-if-outerType-change
   (loop $label$1
    (br_if $label$1
     (block $label$2
      (block $label$3
       (if
        (block $label$4
         (unreachable)
        )
        (br $label$3)
       )
      )
      (unreachable)
     )
    )
   )
  )
  (func $if-arm-unreachable
   (block $label$1
    (if
     (unreachable) ;; unreachable condition
     (nop)
     (unreachable)
    )
   )
  )
  (func $propagate-type-if-we-optimize
   (if
    (i32.const 1)
    (nop)
    (block
     (drop
      (loop $label$3 (result i64)
       (br_if $label$3
        (block $label$4 (result i32)
         (if
          (i32.const 0)
          (unreachable)
          (unreachable)
         )
        )
       )
       (i64.const -9)
      )
     )
     (unreachable)
    )
   )
  )
  (func $br-value-blocktypechange (result f32)
   (set_global $global$0
    (i32.const 0)
   )
   (block $label$1 (result f32)
    (set_global $global$0
     (i32.const 0)
    )
    (br_if $label$1
     (unreachable)
     (i32.const 0)
    )
   )
  )
)
