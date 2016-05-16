(module
  (memory 10)
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (import $_emscripten_autodebug_i32 "env" "_emscripten_autodebug_i32" (param i32 i32) (result i32))
  (table)
  (func $nothing-to-do
    (local $x i32)
  )
  (func $merge
    (local $x i32)
    (local $y i32)
  )
  (func $leave-type
    (local $x i32)
    (local $y f32)
  )
  (func $leave-interfere
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (set_local $y (i32.const 0))
    (get_local $x)
    (get_local $y)
  )
  (func $almost-interfere
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (get_local $x)
    (set_local $y (i32.const 0))
    (get_local $y)
  )
  (func $redundant-copy
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (set_local $y (get_local $x))
    (get_local $y)
  )
  (func $ineffective-store
    (local $x i32)
    (set_local $x (i32.const 0))
    (set_local $x (i32.const 0))
    (get_local $x)
  )
  (func $block
    (local $x i32)
    (block
      (set_local $x (i32.const 0))
    )
    (get_local $x)
  )
  (func $see-both-sides
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (block
      (set_local $y (i32.const 0))
    )
    (get_local $x)
    (get_local $y)
  )
  (func $see-br-and-ignore-dead
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (block $block
      (br $block)
      (set_local $y (i32.const 0))
      (get_local $y)
      (set_local $x (i32.const -1))
    )
    (get_local $x)
  )
  (func $see-block-body
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (block $block
      (set_local $y (i32.const 0))
      (get_local $y)
      (br $block)
    )
    (get_local $x)
  )
  (func $zero-init
    (local $x i32)
    (local $y i32)
    (get_local $x)
    (get_local $y)
  )
  (func $multi
    (local $x i32) ;; x is free, but y and z conflict
    (local $y i32)
    (local $z i32)
    (get_local $y)
    (get_local $z)
  )
  (func $if-else
    (local $x i32)
    (local $y i32)
    (if ;; x and y conflict when they are merged into their shared predecessor
      (i32.const 0)
      (get_local $x)
      (get_local $y)
    )
  )
  (func $if-else-parallel
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block
        (set_local $x (i32.const 0))
        (get_local $x)
      )
      (block
        (set_local $y (i32.const 1))
        (get_local $y)
      )
    )
  )
  (func $if-else-after
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (set_local $x (i32.const 0))
      (set_local $y (i32.const 1))
    )
    (get_local $x)
    (get_local $y)
  )
  (func $if-else-through
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (set_local $y (i32.const 1))
    (if
      (i32.const 0)
      (i32.const 1)
      (i32.const 2)
    )
    (get_local $x)
    (get_local $y)
  )
  (func $if-through
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (set_local $y (i32.const 1))
    (if
      (i32.const 0)
      (i32.const 1)
    )
    (get_local $x)
    (get_local $y)
  )
  (func $if-through2
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (if
      (i32.const 0)
      (set_local $y (i32.const 1))
    )
    (get_local $x)
    (get_local $y)
  )
  (func $if-through2
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 0))
    (if
      (i32.const 0)
      (block
        (get_local $x)
        (get_local $y)
      )
    )
  )
  (func $if2
    (local $x i32)
    (local $y i32)
    (if
      (set_local $x (i32.const 0))
      (block
        (get_local $x)
        (get_local $y)
      )
    )
  )
  (func $if3
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block
        (set_local $x (i32.const 0))
        (get_local $x)
      )
    )
    (get_local $y)
  )
  (func $if4
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block
        (set_local $x (i32.const 0))
        (get_local $x)
        (set_local $y (i32.const 1)) ;; we might not go through here, but it's ok
      )
    )
    (get_local $y)
  )
  (func $if5
    (local $x i32)
    (local $y i32)
    (if
      (i32.const 0)
      (block
        (get_local $x) ;; we might go through here, and it causes interference
        (set_local $y (i32.const 1))
      )
    )
    (get_local $y)
  )
  (func $loop
    (local $x i32)
    (local $y i32)
    (loop $out $in
      (get_local $x)
      (set_local $x (i32.const 0)) ;; effective, due to looping
      (get_local $y)
      (br $in)
    )
  )
  (func $interfere-in-dead
    (local $x i32)
    (local $y i32)
    (block $block
      (br $block)
      (get_local $x)
      (get_local $y)
    )
  )
  (func $interfere-in-dead2
    (local $x i32)
    (local $y i32)
    (block $block
      (unreachable)
      (get_local $x)
      (get_local $y)
    )
  )
  (func $interfere-in-dead3
    (local $x i32)
    (local $y i32)
    (block $block
      (return)
      (get_local $x)
      (get_local $y)
    )
  )
  (func $params (param $p i32) (param $q f32)
    (local $x i32) ;; x is free, but others conflict
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (get_local $y)
    (get_local $z)
    (get_local $w)
  )
  (func $interfere-in-dead
    (local $x i32)
    (local $y i32)
    (block $block
      (br_if $block (i32.const 0))
      (get_local $x)
      (get_local $y)
    )
  )
  (func $switch
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
          (get_local $x) ;; unreachable
        )
        (get_local $y)
      )
      (get_local $z)
    )
    (get_local $w)
  )
  (func $greedy-can-be-happy
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
          (block
            (set_local $x1 (i32.const 100))
            (set_local $y2 (i32.const 101))
            (get_local $x1)
            (get_local $y2)
          )
          (block
            (set_local $x1 (i32.const 102))
            (set_local $y3 (i32.const 103))
            (get_local $x1)
            (get_local $y3)
          )
        )
        (if
          (i32.const 3)
          (block
            (set_local $x2 (i32.const 104))
            (set_local $y1 (i32.const 105))
            (get_local $x2)
            (get_local $y1)
          )
          (block
            (set_local $x2 (i32.const 106))
            (set_local $y3 (i32.const 107))
            (get_local $x2)
            (get_local $y3)
          )
        )
      )
      (if
        (i32.const 4)
        (block
          (set_local $x3 (i32.const 108))
          (set_local $y1 (i32.const 109))
          (get_local $x3)
          (get_local $y1)
        )
        (block
          (set_local $x3 (i32.const 110))
          (set_local $y2 (i32.const 111))
          (get_local $x3)
          (get_local $y2)
        )
      )
    )
  )
  (func $greedy-can-be-sad
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
          (block
            (set_local $x1 (i32.const 100))
            (set_local $y2 (i32.const 101))
            (get_local $x1)
            (get_local $y2)
          )
          (block
            (set_local $x1 (i32.const 102))
            (set_local $y3 (i32.const 103))
            (get_local $x1)
            (get_local $y3)
          )
        )
        (if
          (i32.const 3)
          (block
            (set_local $x2 (i32.const 104))
            (set_local $y1 (i32.const 105))
            (get_local $x2)
            (get_local $y1)
          )
          (block
            (set_local $x2 (i32.const 106))
            (set_local $y3 (i32.const 107))
            (get_local $x2)
            (get_local $y3)
          )
        )
      )
      (if
        (i32.const 4)
        (block
          (set_local $x3 (i32.const 108))
          (set_local $y1 (i32.const 109))
          (get_local $x3)
          (get_local $y1)
        )
        (block
          (set_local $x3 (i32.const 110))
          (set_local $y2 (i32.const 111))
          (get_local $x3)
          (get_local $y2)
        )
      )
    )
  )
  (func $_memcpy (param $i1 i32) (param $i2 i32) (param $i3 i32) (result i32)
    (local $i4 i32)
    (if
      (i32.ge_s
        (get_local $i3)
        (i32.const 4096)
      )
      (get_local $i1)
      (get_local $i2)
      (get_local $i3)
      (return)
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
      (block
        (loop $while-out$0 $while-in$1
          (if
            (i32.eqz
              (i32.and
                (get_local $i1)
                (i32.const 3)
              )
            )
            (br $while-out$0)
          )
          (block
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
        (loop $while-out$2 $while-in$3
          (if
            (i32.eqz
              (i32.ge_s
                (get_local $i3)
                (i32.const 4)
              )
            )
            (br $while-out$2)
          )
          (block
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
    (loop $while-out$4 $while-in$5
      (if
        (i32.eqz
          (i32.gt_s
            (get_local $i3)
            (i32.const 0)
          )
        )
        (br $while-out$4)
      )
      (block
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
    (return
      (get_local $i4)
    )
  )
  (func $this-is-effective-i-tell-you (param $x i32)
    (if
      (i32.const -1)
      (block
        (if ;; this is important for the bug
          (i32.const 0)
          (nop)
        )
        (set_local $x ;; this set is effective!
          (i32.const 1)
        )
      )
      (nop) ;; this is enough for the bug
    )
    (get_local $x) ;; this ends up with the wrong value in the test
  )
)

