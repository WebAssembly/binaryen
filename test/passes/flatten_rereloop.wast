(module
 (memory 1)
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
      (br_table $a1 $a2 $a3 $a4 $a1 $a2 $a3 $a4 (local.get $x))
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
   (global.set $global
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
(module
 (type $0 (func))
 (type $1 (func (result i32)))
 (type $2 (func (param i32) (result i32)))
 (type $3 (func (param i32)))
 (func $trivial (; 0 ;) (type $0)
  (nop)
 )
 (func $trivial2 (; 1 ;) (type $0)
  (block
   (call $trivial)
   (nop)
   (call $trivial)
   (nop)
  )
  (nop)
 )
 (func $return-void (; 2 ;) (type $0)
  (return)
  (unreachable)
 )
 (func $return-val (; 3 ;) (type $1) (result i32)
  (return
   (i32.const 1)
  )
  (unreachable)
 )
 (func $ifs (; 4 ;) (type $2) (param $x i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (block
   (block
    (local.set $1
     (local.get $x)
    )
    (if
     (local.get $1)
     (block
      (block
       (local.set $2
        (local.get $x)
       )
       (if
        (local.get $2)
        (block
         (return
          (i32.const 2)
         )
         (unreachable)
        )
        (block
         (return
          (i32.const 3)
         )
         (unreachable)
        )
       )
      )
      (unreachable)
     )
    )
   )
   (nop)
   (block
    (local.set $3
     (local.get $x)
    )
    (if
     (local.get $3)
     (block
      (return
       (i32.const 4)
      )
      (unreachable)
     )
    )
   )
   (nop)
   (return
    (i32.const 5)
   )
   (unreachable)
  )
  (local.set $5
   (local.get $4)
  )
  (return
   (local.get $5)
  )
 )
 (func $loops (; 5 ;) (type $3) (param $x i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (block
   (block
    (local.set $1
     (local.get $x)
    )
    (if
     (local.get $1)
     (block
      (loop $top
       (block
        (call $trivial)
        (nop)
        (br $top)
        (unreachable)
       )
       (unreachable)
      )
      (unreachable)
     )
    )
   )
   (nop)
   (loop $top2
    (block
     (call $trivial)
     (nop)
     (local.set $2
      (local.get $x)
     )
     (br_if $top2
      (local.get $2)
     )
     (nop)
    )
    (nop)
   )
   (nop)
   (loop $top3
    (block
     (call $trivial)
     (nop)
     (block
      (local.set $3
       (local.get $x)
      )
      (if
       (local.get $3)
       (block
        (br $top3)
        (unreachable)
       )
      )
     )
     (nop)
    )
    (nop)
   )
   (nop)
  )
  (nop)
 )
 (func $br-out (; 6 ;) (type $3) (param $x i32)
  (block $out
   (call $br-out
    (i32.const 5)
   )
   (nop)
   (br $out)
   (unreachable)
  )
  (nop)
 )
 (func $unreachable (; 7 ;) (type $3) (param $x i32)
  (local $1 i32)
  (local $2 i32)
  (block
   (block
    (local.set $1
     (local.get $x)
    )
    (if
     (local.get $1)
     (block
      (block
       (local.set $2
        (local.get $x)
       )
       (if
        (local.get $2)
        (block
         (block $block
          (call $unreachable
           (i32.const 1)
          )
          (nop)
          (unreachable)
          (unreachable)
          (call $unreachable
           (i32.const 2)
          )
          (nop)
         )
         (unreachable)
        )
        (block
         (block $block4
          (call $unreachable
           (i32.const 3)
          )
          (nop)
          (return)
          (unreachable)
          (call $unreachable
           (i32.const 4)
          )
          (nop)
         )
         (unreachable)
        )
       )
      )
      (unreachable)
     )
    )
   )
   (nop)
   (block $out
    (call $unreachable
     (i32.const 5)
    )
    (nop)
    (br $out)
    (unreachable)
    (call $unreachable
     (i32.const 6)
    )
    (nop)
   )
   (nop)
  )
  (nop)
 )
 (func $empty-blocks (; 8 ;) (type $3) (param $x i32)
  (block
   (block $block
   )
   (nop)
   (block $block5
   )
   (nop)
  )
  (nop)
 )
 (func $before-and-after (; 9 ;) (type $3) (param $x i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (block
   (call $before-and-after
    (i32.const 1)
   )
   (nop)
   (block $block
    (call $before-and-after
     (i32.const 2)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 3)
   )
   (nop)
   (block $out
    (call $before-and-after
     (i32.const 4)
    )
    (nop)
    (local.set $1
     (local.get $x)
    )
    (br_if $out
     (local.get $1)
    )
    (nop)
    (call $before-and-after
     (i32.const 5)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 6)
   )
   (nop)
   (loop $loop-in
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 7)
   )
   (nop)
   (loop $top
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 8)
   )
   (nop)
   (loop $top2
    (block
     (call $before-and-after
      (i32.const 9)
     )
     (nop)
     (local.set $2
      (local.get $x)
     )
     (br_if $top2
      (local.get $2)
     )
     (nop)
     (call $before-and-after
      (i32.const 10)
     )
     (nop)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 11)
   )
   (nop)
   (block
    (local.set $3
     (local.get $x)
    )
    (if
     (local.get $3)
     (block
      (call $before-and-after
       (i32.const 12)
      )
      (nop)
     )
    )
   )
   (nop)
   (call $before-and-after
    (i32.const 13)
   )
   (nop)
   (block
    (local.set $4
     (local.get $x)
    )
    (if
     (local.get $4)
     (block
      (call $before-and-after
       (i32.const 14)
      )
      (nop)
     )
     (block
      (call $before-and-after
       (i32.const 15)
      )
      (nop)
     )
    )
   )
   (nop)
   (block
    (local.set $5
     (local.get $x)
    )
    (if
     (local.get $5)
     (block
      (block $block8
       (call $before-and-after
        (i32.const 16)
       )
       (nop)
      )
      (nop)
     )
    )
   )
   (nop)
   (call $before-and-after
    (i32.const 17)
   )
   (nop)
   (block $block9
    (call $before-and-after
     (i32.const 18)
    )
    (nop)
    (block $block10
     (call $before-and-after
      (i32.const 19)
     )
     (nop)
    )
    (nop)
    (call $before-and-after
     (i32.const 20)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 21)
   )
   (nop)
   (block $block11
    (block $block12
     (call $before-and-after
      (i32.const 22)
     )
     (nop)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 23)
   )
   (nop)
   (block $no1
    (block $no2
     (call $before-and-after
      (i32.const 24)
     )
     (nop)
    )
    (nop)
   )
   (nop)
   (call $before-and-after
    (i32.const 25)
   )
   (nop)
  )
  (nop)
 )
 (func $switch (; 10 ;) (type $3) (param $x i32)
  (local $1 i32)
  (local $2 i32)
  (block $out
   (block $a
    (local.set $1
     (local.get $x)
    )
    (br_table $a $a
     (local.get $1)
    )
    (unreachable)
   )
   (nop)
   (call $switch
    (i32.const 1)
   )
   (nop)
   (block $b
    (block $c
     (local.set $2
      (local.get $x)
     )
     (br_table $b $b $b $c
      (local.get $2)
     )
     (unreachable)
    )
    (nop)
    (call $switch
     (i32.const 2)
    )
    (nop)
   )
   (nop)
   (call $switch
    (i32.const 3)
   )
   (nop)
  )
  (nop)
 )
 (func $no-return (; 11 ;) (type $0)
  (if
   (i32.const 1)
   (block
    (drop
     (i32.const 2)
    )
    (nop)
   )
   (block
    (drop
     (i32.const 3)
    )
    (nop)
   )
  )
  (nop)
 )
 (func $if-br-wat (; 12 ;) (type $3) (param $x i32)
  (local $1 i32)
  (local $2 i32)
  (block
   (call $if-br-wat
    (i32.const 0)
   )
   (nop)
   (block $label$2
    (block
     (local.set $1
      (local.get $x)
     )
     (if
      (local.get $1)
      (block
       (call $if-br-wat
        (i32.const 1)
       )
       (nop)
      )
      (block
       (block
        (local.set $2
         (local.get $x)
        )
        (if
         (local.get $2)
         (block
          (br $label$2)
          (unreachable)
         )
        )
       )
       (nop)
      )
     )
    )
    (nop)
    (call $if-br-wat
     (i32.const 2)
    )
    (nop)
   )
   (nop)
   (call $if-br-wat
    (i32.const 3)
   )
   (nop)
  )
  (nop)
 )
 (func $switcher-to-nowhere (; 13 ;) (type $2) (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (block
   (block $switch
    (block $switch-case0
     (block $switch-case
      (local.set $1
       (local.get $0)
      )
      (br_table $switch-case $switch-case0 $switch
       (local.get $1)
      )
      (unreachable)
     )
     (nop)
     (return
      (i32.const 1)
     )
     (unreachable)
    )
    (nop)
    (return
     (i32.const 2)
    )
    (unreachable)
   )
   (nop)
   (return
    (i32.const 3)
   )
   (unreachable)
  )
  (local.set $3
   (local.get $2)
  )
  (return
   (local.get $3)
  )
 )
)
