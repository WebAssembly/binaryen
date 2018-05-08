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
    (set_local $x
      (i32.const 0)
    )
    (set_local $y
      (i32.const 0)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $almost-interfere (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (drop
      (get_local $x)
    )
    (set_local $y
      (i32.const 0)
    )
    (drop
      (get_local $y)
    )
  )
  (func $redundant-copy (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $y
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $ineffective-store (type $2)
    (local $x i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $x
      (i32.const 0)
    )
    (drop
      (get_local $x)
    )
  )
  (func $block (type $2)
    (local $x i32)
    (block $block0
      (set_local $x
        (i32.const 0)
      )
    )
    (drop
      (get_local $x)
    )
  )
  (func $see-both-sides (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (block $block0
      (set_local $y
        (i32.const 0)
      )
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $see-br-and-ignore-dead (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (block $block
      (br $block)
      (set_local $y
        (i32.const 0)
      )
      (drop
        (get_local $y)
      )
      (set_local $x
        (i32.const -1)
      )
    )
    (drop
      (get_local $x)
    )
  )
  (func $see-block-body (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (block $block
      (set_local $y
        (i32.const 0)
      )
      (drop
        (get_local $y)
      )
      (br $block)
    )
    (drop
      (get_local $x)
    )
  )
  (func $zero-init (type $2)
    (local $x i32)
    (local $y i32)
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $multi (type $2)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (drop
      (get_local $y)
    )
    (drop
      (get_local $z)
    )
  )
  (func $if-else (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (drop
        (get_local $x)
      )
      (drop
        (get_local $y)
      )
    )
  )
  (func $if-else-parallel (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (set_local $x
          (i32.const 0)
        )
        (drop
          (get_local $x)
        )
      )
      (block $block3
        (set_local $y
          (i32.const 1)
        )
        (drop
          (get_local $y)
        )
      )
    )
  )
  (func $if-else-after (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (set_local $x
        (i32.const 0)
      )
      (set_local $y
        (i32.const 1)
      )
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $if-else-through (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $y
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
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $if-through (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $y
      (i32.const 1)
    )
    (if
      (i32.const 0)
      (drop
        (i32.const 1)
      )
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $if-through2 (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (if
      (i32.const 0)
      (set_local $y
        (i32.const 1)
      )
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $y)
    )
  )
  (func $if-through3 (type $2)
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.const 0)
    )
    (if
      (i32.const 0)
      (block $block1
        (drop
          (get_local $x)
        )
        (drop
          (get_local $y)
        )
      )
    )
  )
  (func $if2 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (tee_local $x
        (i32.const 0)
      )
      (block $block1
        (drop
          (get_local $x)
        )
        (drop
          (get_local $y)
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
        (set_local $x
          (i32.const 0)
        )
        (drop
          (get_local $x)
        )
      )
    )
    (drop
      (get_local $y)
    )
  )
  (func $if4 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (set_local $x
          (i32.const 0)
        )
        (drop
          (get_local $x)
        )
        (set_local $y
          (i32.const 1)
        )
      )
    )
    (drop
      (get_local $y)
    )
  )
  (func $if5 (type $2)
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block $block1
        (drop
          (get_local $x)
        )
        (set_local $y
          (i32.const 1)
        )
      )
    )
    (drop
      (get_local $y)
    )
  )
  (func $loop (type $2)
    (local $x i32)
    (local $y i32)
    (loop $in
      (drop
        (get_local $x)
      )
      (set_local $x
        (i32.const 0)
      )
      (drop
        (get_local $y)
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
        (get_local $x)
      )
      (drop
        (get_local $y)
      )
    )
  )
  (func $interfere-in-dead2 (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (unreachable)
      (drop
        (get_local $x)
      )
      (drop
        (get_local $y)
      )
    )
  )
  (func $interfere-in-dead3 (type $2)
    (local $x i32)
    (local $y i32)
    (block $block
      (return)
      (drop
        (get_local $x)
      )
      (drop
        (get_local $y)
      )
    )
  )
  (func $params (type $3) (param $p i32) (param $q f32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (drop
      (get_local $y)
    )
    (drop
      (get_local $z)
    )
    (drop
      (get_local $w)
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
        (get_local $x)
      )
      (drop
        (get_local $y)
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
            (get_local $x)
          )
        )
        (drop
          (get_local $y)
        )
      )
      (drop
        (get_local $z)
      )
    )
    (drop
      (get_local $w)
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
            (set_local $x1
              (i32.const 100)
            )
            (set_local $y2
              (i32.const 101)
            )
            (drop
              (get_local $x1)
            )
            (drop
              (get_local $y2)
            )
          )
          (block $block5
            (set_local $x1
              (i32.const 102)
            )
            (set_local $y3
              (i32.const 103)
            )
            (drop
              (get_local $x1)
            )
            (drop
              (get_local $y3)
            )
          )
        )
        (if
          (i32.const 3)
          (block $block8
            (set_local $x2
              (i32.const 104)
            )
            (set_local $y1
              (i32.const 105)
            )
            (drop
              (get_local $x2)
            )
            (drop
              (get_local $y1)
            )
          )
          (block $block10
            (set_local $x2
              (i32.const 106)
            )
            (set_local $y3
              (i32.const 107)
            )
            (drop
              (get_local $x2)
            )
            (drop
              (get_local $y3)
            )
          )
        )
      )
      (if
        (i32.const 4)
        (block $block13
          (set_local $x3
            (i32.const 108)
          )
          (set_local $y1
            (i32.const 109)
          )
          (drop
            (get_local $x3)
          )
          (drop
            (get_local $y1)
          )
        )
        (block $block15
          (set_local $x3
            (i32.const 110)
          )
          (set_local $y2
            (i32.const 111)
          )
          (drop
            (get_local $x3)
          )
          (drop
            (get_local $y2)
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
            (set_local $x1
              (i32.const 100)
            )
            (set_local $y2
              (i32.const 101)
            )
            (drop
              (get_local $x1)
            )
            (drop
              (get_local $y2)
            )
          )
          (block $block5
            (set_local $x1
              (i32.const 102)
            )
            (set_local $y3
              (i32.const 103)
            )
            (drop
              (get_local $x1)
            )
            (drop
              (get_local $y3)
            )
          )
        )
        (if
          (i32.const 3)
          (block $block8
            (set_local $x2
              (i32.const 104)
            )
            (set_local $y1
              (i32.const 105)
            )
            (drop
              (get_local $x2)
            )
            (drop
              (get_local $y1)
            )
          )
          (block $block10
            (set_local $x2
              (i32.const 106)
            )
            (set_local $y3
              (i32.const 107)
            )
            (drop
              (get_local $x2)
            )
            (drop
              (get_local $y3)
            )
          )
        )
      )
      (if
        (i32.const 4)
        (block $block13
          (set_local $x3
            (i32.const 108)
          )
          (set_local $y1
            (i32.const 109)
          )
          (drop
            (get_local $x3)
          )
          (drop
            (get_local $y1)
          )
        )
        (block $block15
          (set_local $x3
            (i32.const 110)
          )
          (set_local $y2
            (i32.const 111)
          )
          (drop
            (get_local $x3)
          )
          (drop
            (get_local $y2)
          )
        )
      )
    )
  )
  (func $_memcpy (type $FUNCSIG$iiii) (param $i1 i32) (param $i2 i32) (param $i3 i32) (result i32)
    (local $i4 i32)
    (if
      (i32.ge_s
        (get_local $i3)
        (i32.const 4096)
      )
      (drop
        (get_local $i1)
      )
    )
    (set_local $i4
      (get_local $i1)
    )
    (if
      (i32.eq
        (i32.and
          (get_local $i1)
          (i32.const 3)
        )
        (i32.and
          (get_local $i2)
          (i32.const 3)
        )
      )
      (block $block2
        (block $while-out$0
          (loop $while-in$1
            (if
              (i32.eqz
                (i32.and
                  (get_local $i1)
                  (i32.const 3)
                )
              )
              (br $while-out$0)
            )
            (block $block4
              (if
                (i32.eqz
                  (get_local $i3)
                )
                (return
                  (get_local $i4)
                )
              )
              (i32.store8
                (get_local $i1)
                (i32.load8_s
                  (get_local $i2)
                )
              )
              (set_local $i1
                (i32.add
                  (get_local $i1)
                  (i32.const 1)
                )
              )
              (set_local $i2
                (i32.add
                  (get_local $i2)
                  (i32.const 1)
                )
              )
              (set_local $i3
                (i32.sub
                  (get_local $i3)
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
                  (get_local $i3)
                  (i32.const 4)
                )
              )
              (br $while-out$2)
            )
            (block $block7
              (i32.store
                (get_local $i1)
                (i32.load
                  (get_local $i2)
                )
              )
              (set_local $i1
                (i32.add
                  (get_local $i1)
                  (i32.const 4)
                )
              )
              (set_local $i2
                (i32.add
                  (get_local $i2)
                  (i32.const 4)
                )
              )
              (set_local $i3
                (i32.sub
                  (get_local $i3)
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
              (get_local $i3)
              (i32.const 0)
            )
          )
          (br $while-out$4)
        )
        (block $block9
          (i32.store8
            (get_local $i1)
            (i32.load8_s
              (get_local $i2)
            )
          )
          (set_local $i1
            (i32.add
              (get_local $i1)
              (i32.const 1)
            )
          )
          (set_local $i2
            (i32.add
              (get_local $i2)
              (i32.const 1)
            )
          )
          (set_local $i3
            (i32.sub
              (get_local $i3)
              (i32.const 1)
            )
          )
        )
        (br $while-in$5)
      )
    )
    (return
      (get_local $i4)
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
        (set_local $x
          (i32.const 1)
        )
      )
      (nop)
    )
    (drop
      (get_local $x)
    )
  )
  (func $prefer-remove-copies1 (type $2)
    (local $y i32)
    (local $z i32)
    (local $x i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $y
      (get_local $x)
    )
    (set_local $z
      (i32.const 1)
    )
    (drop
      (get_local $y)
    )
    (drop
      (get_local $z)
    )
  )
  (func $prefer-remove-copies2 (type $2)
    (local $y i32)
    (local $z i32)
    (local $x i32)
    (set_local $x
      (i32.const 0)
    )
    (set_local $z
      (get_local $x)
    )
    (set_local $y
      (i32.const 1)
    )
    (drop
      (get_local $y)
    )
    (drop
      (get_local $z)
    )
  )
  (func $in-unreachable
    (local $a i32)
    (block $x
      (return)
      (set_local $a (i32.const 1))
      (drop (get_local $a))
      (set_local $a (get_local $a))
    )
    (block $y
      (unreachable)
      (set_local $a (i32.const 1))
      (drop (get_local $a))
      (set_local $a (get_local $a))
    )
    (block $z
      (br $z)
      (set_local $a (i32.const 1))
      (drop (get_local $a))
      (set_local $a (get_local $a))
    )
    (block $z
      (br_table $z $z
        (i32.const 100)
      )
      (set_local $a (i32.const 1))
      (drop (get_local $a))
      (set_local $a (get_local $a))
    )
  )
  (func $nop-in-unreachable
    (local $x i32)
    (block
      (unreachable)
      (i32.store
        (get_local $x)
        (tee_local $x (i32.const 0))
      )
    )
  )
  (func $loop-backedge
    (local $0 i32) ;; loop phi
    (local $1 i32) ;; value for next loop iteration
    (local $2 i32) ;; a local that might be merged with with $1, perhaps making us prefer it to removing a backedge copy
    (set_local $0
      (i32.const 2)
    )
    (block $out
      (loop $while-in7
        (set_local $2 (i32.const 0)) ;; 2 interferes with 0
        (call $set (get_local $2))
        (set_local $1
          (i32.add
            (get_local $0)
            (i32.const 1)
          )
        )
        (if (call $get)
          (set_local $2 (get_local $1)) ;; copy for 1/2
        )
        (br_if $out (get_local $2))
        (set_local $1 (i32.const 100))
        (set_local $0 (get_local $1)) ;; copy for 1/0, with extra weight should win the tie
        (br $while-in7)
      )
    )
  )
  (func $if-copy1
    (local $x i32)
    (local $y i32)
    (loop $top
      (set_local $x
        (if (result i32)
          (i32.const 1)
          (get_local $x)
          (get_local $y)
        )
      )
      (drop (get_local $x))
      (drop (get_local $y))
      (br $top)
    )
  )
  (func $if-copy2
    (local $x i32)
    (local $y i32)
    (loop $top
      (set_local $x
        (if (result i32)
          (i32.const 1)
          (get_local $y)
          (get_local $x)
        )
      )
      (drop (get_local $x))
      (drop (get_local $y))
      (br $top)
    )
  )
  (func $if-copy3
    (local $x i32)
    (local $y i32)
    (loop $top
      (set_local $x
        (if (result i32)
          (i32.const 1)
          (unreachable)
          (get_local $x)
        )
      )
      (drop (get_local $x))
      (drop (get_local $y))
      (br $top)
    )
  )
  (func $if-copy4
    (local $x i32)
    (local $y i32)
    (loop $top
      (set_local $x
        (if (result i32)
          (i32.const 1)
          (unreachable)
          (get_local $y)
        )
      )
      (drop (get_local $x))
      (drop (get_local $y))
      (br $top)
    )
  )
  (func $if-copy-tee
    (local $x i32)
    (local $y i32)
    (loop $top
      (drop
        (tee_local $x
          (if (result i32)
            (i32.const 1)
            (get_local $x)
            (i32.const 2)
          )
        )
      )
      (drop (get_local $x))
      (drop (get_local $y))
      (br $top)
    )
  )
  (func $tee_br (param $x i32) (result i32)
    (block $b
      (return
        (tee_local $x
          (br $b)
        )
      )
    )
    (i32.const 1)
  )
  (func $unused-tee-with-child-if-no-else (param $0 i32)
   (loop $label$0
    (drop
     (tee_local $0
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
     (tee_local $0
      (if (result f64)
       (get_local $1)
       (get_local $0)
       (unreachable)
      )
     )
     (f64.lt
      (f64.const -128)
      (get_local $0)
     )
    )
  )
  (func $tee_if_with_unreachable_true (param $0 f64) (param $1 i32) (result i64)
    (call $tee_if_with_unreachable_else
     (tee_local $0
      (if (result f64)
       (get_local $1)
       (unreachable)
       (get_local $0)
      )
     )
     (f64.lt
      (f64.const -128)
      (get_local $0)
     )
    )
  )
  (func $pick
   (local $x i32)
   (local $y i32)
   (set_local $x (get_local $y))
   (if (i32.const 1)
    (set_local $x (i32.const 1))
   )
   (set_local $x (get_local $y))
   (set_local $x (get_local $y))
  )
  (func $pick-2
   (local $x i32)
   (local $y i32)
   (set_local $y (get_local $x))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $y (get_local $x))
  )
  (func $many
   (local $x i32)
   (local $y i32)
   (local $z i32)
   (local $w i32)
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $z (i32.const 2))
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $z (i32.const 2))
   (set_local $x (get_local $w))
  )
  (func $loop-copies (param $x i32) (param $y i32)
   (loop $loop
    (set_local $x (get_local $y))
    (set_local $y (get_local $x))
    (br_if $loop (get_local $x))
   )
  )
  (func $proper-type (result f64)
   (local $var$0 i32)
   (local $var$2 f64)
   (set_local $var$0
    (select
     (i32.const 0)
     (i32.const 1)
     (get_local $var$0)
    )
   )
   (tee_local $var$2 ;; the locals will be reordered, this should be the f64
    (get_local $var$2)
   )
  )
)
