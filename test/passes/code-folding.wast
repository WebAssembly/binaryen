(module
 (type $13 (func (param f32)))
 (table 282 282 funcref)
 (memory $0 1 1)
 (func $0
  (block $label$1
   (if
    (i32.const 1)
    (block $label$3
     (call_indirect (type $13)
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
       (br_table $label$C $label$C ;; this all looks mergeable, and is, B ~~ C
        (unreachable)
       )
      )
     )
     (return)
    )
   )
  )
 )
 (func $leave-inner-block-type
  (block $label$1
   (drop
    (block $label$2 (result i32) ;; leave this alone (otherwise, if we make it unreachable, we need to do more updating)
     (br_if $label$2
      (unreachable)
      (unreachable)
     )
     (drop
      (i32.const 1)
     )
     (br $label$1)
    )
   )
   (drop
    (i32.const 1)
   )
  )
 )
)
(module
 (memory $0 (shared 1 1))
 (export "func_2224" (func $0))
 (func $0 (result i32)
  (local $var$0 i32)
  (if (result i32)
   (i32.const 0)
   (i32.load offset=22
    (local.get $var$0)
   )
   (i32.atomic.load offset=22
    (local.get $var$0)
   )
  )
 )
)
(module
 (type $0 (func))
 (global $global$0 (mut i32) (i32.const 10))
 (func $determinism (; 0 ;) (type $0)
  (block $label$1
   (br_if $label$1
    (i32.const 1)
   )
   (global.set $global$0
    (i32.sub
     (global.get $global$0)
     (i32.const 1)
    )
   )
   (unreachable)
  )
  (block $label$2
   (br_if $label$2
    (i32.const 0)
   )
   (if
    (global.get $global$0)
    (block
     (global.set $global$0
      (i32.sub
       (global.get $global$0)
       (i32.const 1)
      )
     )
     (unreachable)
    )
   )
   (unreachable)
  )
  (if
   (global.get $global$0)
   (block
    (global.set $global$0
     (i32.sub
      (global.get $global$0)
      (i32.const 1)
     )
    )
    (unreachable)
   )
  )
  (unreachable)
 )
 (func $careful-of-the-switch (param $0 i32)
  (block $label$1
    (block $label$3
      (block $label$5
       (block $label$7 ;;  this is block is equal to $label$8 when accounting for the internal 7/8 difference
        (br_table $label$3 $label$7 ;; the reference to $label$3 must remain valid, cannot hoist out of it!
         (i32.const 0)
        )
       )
       (br $label$1)
      )
      (block $label$8
       (br_table $label$3 $label$8
        (i32.const 0)
       )
      )
      (br $label$1)
    )
    (unreachable)
  )
 )
)

