(module
  (memory 10)
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
  (type $2 (func))
  (type $3 (func (param i32 f32)))
  (type $4 (func (param i32)))
  (import $_emscripten_autodebug_i32 "env" "_emscripten_autodebug_i32" (param i32 i32) (result i32))
  (import $get "env" "get" (result i32))
  (import $set "env" "set" (param i32))
  (func $nothing-to-do (type $2)
    (local $x i32)
    (nop)
  )
  (func $merge (type $2)
    (local $x i32)
    (local $y i32)
    (nop)
  )
  (func $leave-type (type $2)
    (local $x i32)
    (local $y f32)
    (nop)
  )
  (func $leave-interfere (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $y
      (i32.const 0)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $almost-interfere (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (drop
      (local.get $x)
    )
    (local.set $y
      (i32.const 0)
    )
    (drop
      (local.get $y)
    )
  )
  (func $redundant-copy (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $y
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $ineffective-store (type $2)
    (local $x i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $x
      (i32.const 0)
    )
    (drop
      (local.get $x)
    )
  )
  (func $block (type $2)
    (local $x i32)
    (block $block0
      (local.set $x
        (i32.const 0)
      )
    )
    (drop
      (local.get $x)
    )
  )
  (func $see-both-sides (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (block $block0
      (local.set $y
        (i32.const 0)
      )
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $see-br-and-ignore-dead (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (block $block
      (br $block)
      (local.set $y
        (i32.const 0)
      )
      (drop
        (local.get $y)
      )
      (local.set $x
        (i32.const -1)
      )
    )
    (drop
      (local.get $x)
    )
  )
  (func $see-block-body (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (block $block
      (local.set $y
        (i32.const 0)
      )
      (drop
        (local.get $y)
      )
      (br $block)
    )
    (drop
      (local.get $x)
    )
  )
  (func $zero-init (type $2)
    (local $x i32)
    (local $y i32)
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $multi (type $2)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (drop
      (local.get $y)
    )
    (drop
      (local.get $z)
    )
  )
  (func $if-else (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
  )
  (func $if-else-parallel (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (local.set $x
          (i32.const 0)
        )
        (drop
          (local.get $x)
        )
      )
      (block $block3
        (local.set $y
          (i32.const 1)
        )
        (drop
          (local.get $y)
        )
      )
    )
  )
  (func $if-else-after (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (local.set $x
        (i32.const 0)
      )
      (local.set $y
        (i32.const 1)
      )
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $if-else-through (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $y
      (i32.const 1)
    )
    (if
      (i32.const 0)
      (drop
        (i32.const 1)
      )
      (drop
        (i32.const 2)
      )
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $if-through (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $y
      (i32.const 1)
    )
    (if
      (i32.const 0)
      (drop
        (i32.const 1)
      )
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $if-through2 (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (if
      (i32.const 0)
      (local.set $y
        (i32.const 1)
      )
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
  (func $if-through3 (type $2)
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.const 0)
    )
    (if
      (i32.const 0)
      (block $block1
        (drop
          (local.get $x)
        )
        (drop
          (local.get $y)
        )
      )
    )
  )
  (func $if2 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (local.tee $x
        (i32.const 0)
      )
      (block $block1
        (drop
          (local.get $x)
        )
        (drop
          (local.get $y)
        )
      )
    )
  )
  (func $if3 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (local.set $x
          (i32.const 0)
        )
        (drop
          (local.get $x)
        )
      )
    )
    (drop
      (local.get $y)
    )
  )
  (func $if4 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (local.set $x
          (i32.const 0)
        )
        (drop
          (local.get $x)
        )
        (local.set $y
          (i32.const 1)
        )
      )
    )
    (drop
      (local.get $y)
    )
  )
  (func $if5 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (drop
          (local.get $x)
        )
        (local.set $y
          (i32.const 1)
        )
      )
    )
    (drop
      (local.get $y)
    )
  )
  (func $loop (type $2)
    (local $x i32)
    (local $y i32)
    (loop $in
      (drop
        (local.get $x)
      )
      (local.set $x
        (i32.const 0)
      )
      (drop
        (local.get $y)
      )
      (br $in)
    )
  )
  (func $interfere-in-dead (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (br $block)
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
  )
  (func $interfere-in-dead2 (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (unreachable)
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
  )
  (func $interfere-in-dead3 (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (return)
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
  )
  (func $params (type $3) (param $p i32) (param $q f32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (drop
      (local.get $y)
    )
    (drop
      (local.get $z)
    )
    (drop
      (local.get $w)
    )
  )
  (func $interfere-in-dead4 (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (br_if $block
        (i32.const 0)
      )
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
  )
  (func $switch (type $2)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (block $switch$def
      (block $switch-case$1
        (block $switch-case$2
          (br_table $switch-case$1 $switch-case$2 $switch-case$1 $switch-case$1 $switch$def
            (i32.const 100)
          )
          (drop
            (local.get $x)
          )
        )
        (drop
          (local.get $y)
        )
      )
      (drop
        (local.get $z)
      )
    )
    (drop
      (local.get $w)
    )
  )
  (func $greedy-can-be-happy (type $2)
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)
    (local $y1 i32)
    (local $y2 i32)
    (local $y3 i32)
    (if
      (i32.const 0)
      (if
        (i32.const 1)
        (if
          (i32.const 2)
          (block $block3
            (local.set $x1
              (i32.const 100)
            )
            (local.set $y2
              (i32.const 101)
            )
            (drop
              (local.get $x1)
            )
            (drop
              (local.get $y2)
            )
          )
          (block $block5
            (local.set $x1
              (i32.const 102)
            )
            (local.set $y3
              (i32.const 103)
            )
            (drop
              (local.get $x1)
            )
            (drop
              (local.get $y3)
            )
          )
        )
        (if
          (i32.const 3)
          (block $block8
            (local.set $x2
              (i32.const 104)
            )
            (local.set $y1
              (i32.const 105)
            )
            (drop
              (local.get $x2)
            )
            (drop
              (local.get $y1)
            )
          )
          (block $block10
            (local.set $x2
              (i32.const 106)
            )
            (local.set $y3
              (i32.const 107)
            )
            (drop
              (local.get $x2)
            )
            (drop
              (local.get $y3)
            )
          )
        )
      )
      (if
        (i32.const 4)
        (block $block13
          (local.set $x3
            (i32.const 108)
          )
          (local.set $y1
            (i32.const 109)
          )
          (drop
            (local.get $x3)
          )
          (drop
            (local.get $y1)
          )
        )
        (block $block15
          (local.set $x3
            (i32.const 110)
          )
          (local.set $y2
            (i32.const 111)
          )
          (drop
            (local.get $x3)
          )
          (drop
            (local.get $y2)
          )
        )
      )
    )
  )
  (func $greedy-can-be-sad (type $2)
    (local $x1 i32)
    (local $y1 i32)
    (local $x2 i32)
    (local $y2 i32)
    (local $x3 i32)
    (local $y3 i32)
    (if
      (i32.const 0)
      (if
        (i32.const 1)
        (if
          (i32.const 2)
          (block $block3
            (local.set $x1
              (i32.const 100)
            )
            (local.set $y2
              (i32.const 101)
            )
            (drop
              (local.get $x1)
            )
            (drop
              (local.get $y2)
            )
          )
          (block $block5
            (local.set $x1
              (i32.const 102)
            )
            (local.set $y3
              (i32.const 103)
            )
            (drop
              (local.get $x1)
            )
            (drop
              (local.get $y3)
            )
          )
        )
        (if
          (i32.const 3)
          (block $block8
            (local.set $x2
              (i32.const 104)
            )
            (local.set $y1
              (i32.const 105)
            )
            (drop
              (local.get $x2)
            )
            (drop
              (local.get $y1)
            )
          )
          (block $block10
            (local.set $x2
              (i32.const 106)
            )
            (local.set $y3
              (i32.const 107)
            )
            (drop
              (local.get $x2)
            )
            (drop
              (local.get $y3)
            )
          )
        )
      )
      (if
        (i32.const 4)
        (block $block13
          (local.set $x3
            (i32.const 108)
          )
          (local.set $y1
            (i32.const 109)
          )
          (drop
            (local.get $x3)
          )
          (drop
            (local.get $y1)
          )
        )
        (block $block15
          (local.set $x3
            (i32.const 110)
          )
          (local.set $y2
            (i32.const 111)
          )
          (drop
            (local.get $x3)
          )
          (drop
            (local.get $y2)
          )
        )
      )
    )
  )
  (func $_memcpy (type $FUNCSIG$iiii) (param $i1 i32) (param $i2 i32) (param $i3 i32) (result i32)
    (local $i4 i32)
    (if
      (i32.ge_s
        (local.get $i3)
        (i32.const 4096)
      )
      (drop
        (local.get $i1)
      )
    )
    (local.set $i4
      (local.get $i1)
    )
    (if
      (i32.eq
        (i32.and
          (local.get $i1)
          (i32.const 3)
        )
        (i32.and
          (local.get $i2)
          (i32.const 3)
        )
      )
      (block $block2
        (block $while-out$0
          (loop $while-in$1
            (if
              (i32.eqz
                (i32.and
                  (local.get $i1)
                  (i32.const 3)
                )
              )
              (br $while-out$0)
            )
            (block $block4
              (if
                (i32.eqz
                  (local.get $i3)
                )
                (return
                  (local.get $i4)
                )
              )
              (i32.store8
                (local.get $i1)
                (i32.load8_s
                  (local.get $i2)
                )
              )
              (local.set $i1
                (i32.add
                  (local.get $i1)
                  (i32.const 1)
                )
              )
              (local.set $i2
                (i32.add
                  (local.get $i2)
                  (i32.const 1)
                )
              )
              (local.set $i3
                (i32.sub
                  (local.get $i3)
                  (i32.const 1)
                )
              )
            )
            (br $while-in$1)
          )
        )
        (block $while-out$2
          (loop $while-in$3
            (if
              (i32.eqz
                (i32.ge_s
                  (local.get $i3)
                  (i32.const 4)
                )
              )
              (br $while-out$2)
            )
            (block $block7
              (i32.store
                (local.get $i1)
                (i32.load
                  (local.get $i2)
                )
              )
              (local.set $i1
                (i32.add
                  (local.get $i1)
                  (i32.const 4)
                )
              )
              (local.set $i2
                (i32.add
                  (local.get $i2)
                  (i32.const 4)
                )
              )
              (local.set $i3
                (i32.sub
                  (local.get $i3)
                  (i32.const 4)
                )
              )
            )
            (br $while-in$3)
          )
        )
      )
    )
    (block $while-out$4
      (loop $while-in$5
        (if
          (i32.eqz
            (i32.gt_s
              (local.get $i3)
              (i32.const 0)
            )
          )
          (br $while-out$4)
        )
        (block $block9
          (i32.store8
            (local.get $i1)
            (i32.load8_s
              (local.get $i2)
            )
          )
          (local.set $i1
            (i32.add
              (local.get $i1)
              (i32.const 1)
            )
          )
          (local.set $i2
            (i32.add
              (local.get $i2)
              (i32.const 1)
            )
          )
          (local.set $i3
            (i32.sub
              (local.get $i3)
              (i32.const 1)
            )
          )
        )
        (br $while-in$5)
      )
    )
    (return
      (local.get $i4)
    )
  )
  (func $this-is-effective-i-tell-you (type $4) (param $x i32)
    (if
      (i32.const -1)
      (block $block1
        (if
          (i32.const 0)
          (nop)
        )
        (local.set $x
          (i32.const 1)
        )
      )
      (nop)
    )
    (drop
      (local.get $x)
    )
  )
  (func $prefer-remove-copies1 (type $2)
    (local $y i32)
    (local $z i32)
    (local $x i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $y
      (local.get $x)
    )
    (local.set $z
      (i32.const 1)
    )
    (drop
      (local.get $y)
    )
    (drop
      (local.get $z)
    )
  )
  (func $prefer-remove-copies2 (type $2)
    (local $y i32)
    (local $z i32)
    (local $x i32)
    (local.set $x
      (i32.const 0)
    )
    (local.set $z
      (local.get $x)
    )
    (local.set $y
      (i32.const 1)
    )
    (drop
      (local.get $y)
    )
    (drop
      (local.get $z)
    )
  )
  (func $in-unreachable
    (local $a i32)
    (block $x
      (return)
      (local.set $a (i32.const 1))
      (drop (local.get $a))
      (local.set $a (local.get $a))
    )
    (block $y
      (unreachable)
      (local.set $a (i32.const 1))
      (drop (local.get $a))
      (local.set $a (local.get $a))
    )
    (block $z
      (br $z)
      (local.set $a (i32.const 1))
      (drop (local.get $a))
      (local.set $a (local.get $a))
    )
    (block $z
      (br_table $z $z
        (i32.const 100)
      )
      (local.set $a (i32.const 1))
      (drop (local.get $a))
      (local.set $a (local.get $a))
    )
  )
  (func $nop-in-unreachable
    (local $x i32)
    (block
      (unreachable)
      (i32.store
        (local.get $x)
        (local.tee $x (i32.const 0))
      )
    )
  )
  (func $loop-backedge
    (local $0 i32) ;; loop phi
    (local $1 i32) ;; value for next loop iteration
    (local $2 i32) ;; a local that might be merged with with $1, perhaps making us prefer it to removing a backedge copy
    (local.set $0
      (i32.const 2)
    )
    (block $out
      (loop $while-in7
        (local.set $2 (i32.const 0)) ;; 2 interferes with 0
        (call $set (local.get $2))
        (local.set $1
          (i32.add
            (local.get $0)
            (i32.const 1)
          )
        )
        (if (call $get)
          (local.set $2 (local.get $1)) ;; copy for 1/2
        )
        (br_if $out (local.get $2))
        (local.set $1 (i32.const 100))
        (local.set $0 (local.get $1)) ;; copy for 1/0, with extra weight should win the tie
        (br $while-in7)
      )
    )
  )
  (func $if-copy1
    (local $x i32)
    (local $y i32)
    (loop $top
      (local.set $x
        (if (result i32)
          (i32.const 1)
          (local.get $x)
          (local.get $y)
        )
      )
      (drop (local.get $x))
      (drop (local.get $y))
      (br $top)
    )
  )
  (func $if-copy2
    (local $x i32)
    (local $y i32)
    (loop $top
      (local.set $x
        (if (result i32)
          (i32.const 1)
          (local.get $y)
          (local.get $x)
        )
      )
      (drop (local.get $x))
      (drop (local.get $y))
      (br $top)
    )
  )
  (func $if-copy3
    (local $x i32)
    (local $y i32)
    (loop $top
      (local.set $x
        (if (result i32)
          (i32.const 1)
          (unreachable)
          (local.get $x)
        )
      )
      (drop (local.get $x))
      (drop (local.get $y))
      (br $top)
    )
  )
  (func $if-copy4
    (local $x i32)
    (local $y i32)
    (loop $top
      (local.set $x
        (if (result i32)
          (i32.const 1)
          (unreachable)
          (local.get $y)
        )
      )
      (drop (local.get $x))
      (drop (local.get $y))
      (br $top)
    )
  )
  (func $if-copy-tee
    (local $x i32)
    (local $y i32)
    (loop $top
      (drop
        (local.tee $x
          (if (result i32)
            (i32.const 1)
            (local.get $x)
            (i32.const 2)
          )
        )
      )
      (drop (local.get $x))
      (drop (local.get $y))
      (br $top)
    )
  )
  (func $tee_br (param $x i32) (result i32)
    (block $b
      (return
        (local.tee $x
          (br $b)
        )
      )
    )
    (i32.const 1)
  )
  (func $unused-tee-with-child-if-no-else (param $0 i32)
   (loop $label$0
    (drop
     (local.tee $0
      (if
       (br $label$0)
       (nop)
      )
     )
    )
   )
  )
  (func $tee_if_with_unreachable_else (param $0 f64) (param $1 i32) (result i64)
    (call $tee_if_with_unreachable_else
     (local.tee $0
      (if (result f64)
       (local.get $1)
       (local.get $0)
       (unreachable)
      )
     )
     (f64.lt
      (f64.const -128)
      (local.get $0)
     )
    )
  )
  (func $tee_if_with_unreachable_true (param $0 f64) (param $1 i32) (result i64)
    (call $tee_if_with_unreachable_else
     (local.tee $0
      (if (result f64)
       (local.get $1)
       (unreachable)
       (local.get $0)
      )
     )
     (f64.lt
      (f64.const -128)
      (local.get $0)
     )
    )
  )
  (func $pick
   (local $x i32)
   (local $y i32)
   (local.set $x (local.get $y))
   (if (i32.const 1)
    (local.set $x (i32.const 1))
   )
   (local.set $x (local.get $y))
   (local.set $x (local.get $y))
  )
  (func $pick-2
   (local $x i32)
   (local $y i32)
   (local.set $y (local.get $x))
   (if (i32.const 1)
    (local.set $y (i32.const 1))
   )
   (local.set $y (local.get $x))
   (local.set $y (local.get $x))
  )
  (func $many
   (local $x i32)
   (local $y i32)
   (local $z i32)
   (local $w i32)
   (local.set $y (local.get $x))
   (local.set $z (local.get $y))
   (local.set $w (local.get $z))
   (local.set $x (local.get $z))
   (if (i32.const 1)
    (local.set $y (i32.const 1))
   )
   (local.set $x (local.get $z))
   (if (i32.const 1)
    (local.set $y (i32.const 1))
   )
   (local.set $y (local.get $x))
   (local.set $z (local.get $y))
   (local.set $w (local.get $z))
   (local.set $z (i32.const 2))
   (local.set $x (local.get $z))
   (if (i32.const 1)
    (local.set $y (i32.const 1))
   )
   (local.set $y (local.get $x))
   (local.set $z (local.get $y))
   (local.set $w (local.get $z))
   (local.set $z (i32.const 2))
   (local.set $x (local.get $w))
  )
  (func $loop-copies (param $x i32) (param $y i32)
   (loop $loop
    (local.set $x (local.get $y))
    (local.set $y (local.get $x))
    (br_if $loop (local.get $x))
   )
  )
  (func $proper-type (result f64)
   (local $var$0 i32)
   (local $var$2 f64)
   (local.set $var$0
    (select
     (i32.const 0)
     (i32.const 1)
     (local.get $var$0)
    )
   )
   (local.tee $var$2 ;; the locals will be reordered, this should be the f64
    (local.get $var$2)
   )
  )
  (func $reuse-param (param $x i32) (param $y i32) (result i32)
   (local $temp i32)
   (i32.add
    (local.tee $temp
     (i32.xor
      (i32.shr_s
       (i32.shl
        (local.get $x) ;; $x and $temp do not interfere
        (i32.const 16)
       )
      (i32.const 16)
     )
     (i32.shr_s
      (i32.shl
        (local.get $y)
        (i32.const 16)
       )
       (i32.const 16)
      )
     )
    )
    (local.get $temp)
   )
  )
)
