(module
 (global $global (mut i32) (i32.const 0))
 (func $0 (result f64)
  (if
   (i32.const 0)
   (loop $label$2
    (unreachable)
   )
  )
  (f64.const -nan:0xfffffd63e4e5a)
 )
 (func $1 (result i32)
  (block $label$8
   (block $label$9
    (block $label$16
     (block $label$18
      (block $label$19
       (br_table $label$18 $label$16 $label$19
        (i32.const 0)
       )
      )
      (br_table $label$9 $label$8
       (i32.const 1)
      )
     )
     (unreachable)
    )
    (unreachable)
   )
   (unreachable)
  )
  (i32.const 2)
 )
 (func $skip-empty
  (block $a1
   (block $a2
    (block $a3
     (block $a4
      (br $a4)
     )
     (br $a3)
    )
    (br $a2)
   )
   (br $a1)
  )
 )
 (func $skip-empty-2
  (block $a1
   (block $a2
    (block $a3
     (block $a4
      (br $a4)
     )
     (call $skip-empty)
     (br $a3)
    )
    (call $skip-empty)
    (br $a2)
   )
   (br $a1)
  )
 )
 (func $skip-empty-3
  (block $a1
   (block $a2
    (block $a3
     (block $a4
      (nop)
      (br $a4)
      (nop)
     )
     (nop)
     (call $skip-empty)
     (nop)
     (br $a3)
    )
    (nop)
    (call $skip-empty)
    (nop)
    (br $a2)
   )
   (br $a1)
  )
 )
 (func $skip-empty-4 (param $x i32)
  (block $a1
   (block $a2
    (block $a3
     (block $a4
      (br_table $a1 $a2 $a3 $a4 $a1 $a2 $a3 $a4 (get_local $x))
     )
     (br $a3)
    )
    (br $a2)
   )
   (br $a1)
  )
 )
 (func $skipping (param $0 i32) (result f32)
  (if
   (i32.const 0)
   (unreachable)
  ) ;; branches joining here lead to skip opportunities
  (loop $label$2 (result f32)
   (f32.const 1)
  )
 )
 (func $merging
  (if
   (i32.const 0)
   (return)
   ;; no else, but the else ends up with a return too, and we can merge them
  )
 )
 (func $unswitch
  (block $label$1
   (br_table $label$1 $label$1
    (i32.const 0)
   )
  )
 )
 (func $skip-only-empty
  (if
   (i32.const 1)
   (set_global $global
    (i32.const 0)
   )
  )
 )
 (func $skip-only-one-branch-out (result i32)
  (block $label$1
   (nop)
  )
  (if
   (i32.const 1)
   (unreachable) ;; blocks a path through
  )
  (i32.const 0)
 )
 (func $multipass-for-skips (result f32)
  (if (result f32)
   (i32.const 0)
   (block (result f32)
    (block $label$2
     (br_if $label$2
      (i32.const 536870912)
     )
    )
    (f32.const 9223372036854775808)
   )
   (f32.const 65505)
  )
 )
 (func $branch-merge-vs-replace
  (if
   (i32.const 0)
   (unreachable)
  )
 )
 (func $unswitch-amount
  (block $label$1
   (if
    (i32.const -23)
    (nop)
    (block
     (block $label$4
      (br_table $label$1 $label$4
       (i32.const 44064)
      )
     )
     (unreachable)
    )
   )
  )
 )
)
;; manual TODO: merge branches, all the parts
