(module
 (type $13 (func (param f32)))
 (table 282 282 anyfunc)
 (memory $0 1 1)
 (func $0
  (block $label$1
   (if
    (i32.const 1)
    (block $label$3
     (call_indirect $13
      (block $label$4 (result f32) ;; but this type may change dangerously
       (nop) ;; fold this
       (br $label$3)
      )
      (i32.const 105)
     )
     (nop) ;; with this
    )
   )
  )
 )
 (func $negative-zero (result f32)
  (if (result f32)
   (i32.const 0)
   (block $label$0 (result f32)
    (f32.const 0)
   )
   (block $label$1 (result f32)
    (f32.const -0)
   )
  )
 )
 (func $negative-zero-b (result f32)
  (if (result f32)
   (i32.const 0)
   (block $label$0 (result f32)
    (f32.const -0)
   )
   (block $label$1 (result f32)
    (f32.const -0)
   )
  )
 )
 (func $negative-zero-c (result f32)
  (if (result f32)
   (i32.const 0)
   (block $label$0 (result f32)
    (f32.const 0)
   )
   (block $label$1 (result f32)
    (f32.const 0)
   )
  )
 )
 (func $break-target-outside-of-return-merged-code
  (block $label$A
   (if
    (unreachable)
    (block
     (block
      (block $label$B
       (if
        (unreachable)
        (br_table $label$A $label$B
         (unreachable)
        )
       )
      )
      (return)
     )
    )
    (block
     (block $label$C
      (if
       (unreachable)
       (br_table $label$A $label$C ;; this all looks mergeable, but $label$A is outside
        (unreachable)
       )
      )
     )
     (return)
    )
   )
  )
 )
 (func $break-target-inside-all-good
  (block $label$A
   (if
    (unreachable)
    (block
     (block
      (block $label$B
       (if
        (unreachable)
        (br_table $label$B $label$B
         (unreachable)
        )
       )
      )
      (return)
     )
    )
    (block
     (block $label$C
      (if
       (unreachable)
       (br_table $label$C $label$C ;; this all looks mergeable, but $label$A is outside
        (unreachable)
       )
      )
     )
     (return)
    )
   )
  )
 )
)

