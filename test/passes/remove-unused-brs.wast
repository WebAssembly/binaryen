(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (type $1 (func))
  (type $2 (func (result i32)))
  (func $b0-yes (type $0) (param $i1 i32)
    (block $topmost
      (br $topmost)
    )
  )
  (func $b1 (type $0) (param $i1 i32)
    (block $topmost
      (block
        (drop
          (i32.const 0)
        )
        (br $topmost)
      )
    )
  )
  (func $b2 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br $topmost)
      )
    )
  )
  (func $b3-yes (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br $inner)
      )
    )
  )
  (func $b4 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br $topmost)
        )
      )
    )
  )
  (func $b5 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br $inner)
        )
      )
    )
  )
  (func $b6 (type $0) (param $i1 i32)
    (block $topmost
      (br_if $topmost
        (i32.const 1)
      )
    )
  )
  (func $b7 (type $0) (param $i1 i32)
    (block $topmost
      (block
        (drop
          (i32.const 0)
        )
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b8 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b9 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b10 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br_if $topmost
            (i32.const 1)
          )
        )
      )
    )
  )
  (func $b11 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br_if $inner
            (i32.const 1)
          )
        )
      )
    )
  )
  (func $b12-yes (type $1)
    (block $topmost
      (if
        (i32.const 1)
        (block $block1
          (drop
            (i32.const 12)
          )
          (block
            (drop
              (i32.const 1)
            )
            (br $topmost)
          )
        )
        (block $block3
          (drop
            (i32.const 27)
          )
          (block
            (drop
              (i32.const 2)
            )
            (br $topmost)
          )
        )
      )
    )
  )
  (func $b13 (type $2) (result i32)
    (block $topmost (result i32)
      (if
        (i32.const 1)
        (block $block1
          (drop
            (i32.const 12)
          )
          (drop
            (br_if $topmost
              (i32.const 1)
              (i32.const 1)
            )
          )
        )
        (block $block3
          (drop
            (i32.const 27)
          )
          (br $topmost
            (i32.const 2)
          )
        )
      )
      (i32.const 3)
    )
  )
  (func $b14 (type $2) (result i32)
    (block $topmost (result i32)
      (if (result i32)
        (i32.const 1)
        (block $block1 (result i32)
          (i32.const 12)
        )
        (block $block3 (result i32)
          (i32.const 27)
        )
      )
    )
  )
  (func $b15 (type $1)
    (block $topmost
      (if
        (i32.const 17)
        (br $topmost)
      )
    )
  )
  (func $b15b (type $1)
    (block $topmost
      (if
        (i32.const 18)
        (block
          (drop
            (i32.const 0)
          )
          (br $topmost)
        )
      )
    )
  )
  (func $b16 (type $1)
    (block $a
      (block $b
        (block $c
          (br $a)
        )
        (br $a)
      )
      (br $a)
    )
    (block $a
      (block $b
        (block $c
          (br $c)
        )
        (br $b)
      )
      (br $a)
    )
    (block $a
      (block $b
        (block $c
          (br $b)
        )
        (br $a)
      )
      (br $a)
    )
  )
  (func $b17 (type $1)
    (block $a
      (if
        (i32.const 0)
        (block $block1
          (br $a)
        )
        (block $block3
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
        (block $block6
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (block $block8
          (br $a)
        )
        (drop
          (i32.const 1)
        )
      )
    )
    (block $c
      (block $b
        (if
          (i32.const 0)
          (block $block11
            (br $b)
          )
          (block $block13
            (br $c)
          )
        )
      )
    )
  )
  (func $ret-1 (type $1)
    (return)
  )
  (func $ret-2 (type $1)
    (block $block0
      (block $block1
        (return)
      )
    )
  )
  (func $ret-3 (type $1)
    (block $block0
      (if
        (i32.const 0)
        (return)
        (block $block3
          (return)
        )
      )
    )
  )
  (func $ret-value (type $2) (result i32)
    (block $block0
      (block $block1
        (return
          (i32.const 1)
        )
      )
    )
  )
  (func $no-select-but-the-last (type $1)
    (block $a
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
        (block $block2
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (drop
            (i32.const 3)
          )
        )
      )
      (if
        (i32.const 0)
        (block $block4
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (drop
            (i32.const 3)
          )
        )
        (drop
          (i32.const 1)
        )
      )
      (if
        (block $block6 (result i32)
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (i32.const 3)
        )
        (drop
          (i32.const 0)
        )
        (drop
          (i32.const 1)
        )
      )
      (if
        (block $a (result i32)
          (br $a
            (i32.const 0)
          )
        )
        (block $a
          (block
            (drop
              (i32.const 1)
            )
            (br $a)
          )
        )
        (block $a
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
        )
      )
    )
  )
  (func $side-effects-and-order (type $2) (result i32)
    (local $x i32)
    (block $do-once$0
      (if
        (call $b13)
        (block
          (drop
            (i32.const 0)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0
      (if
        (call $b13)
        (block
          (drop
            (call $b14)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0
      (if
        (i32.const 0)
        (block
          (drop
            (call $b14)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0 (result i32)
      (if
        (tee_local $x
          (i32.const 1)
        )
        (br $do-once$0
          (tee_local $x
            (i32.const 2)
          )
        )
      )
      (i32.const 1)
    )
  )
  (func $loops
    (loop $in
      (block $out
        (if (i32.const 0) (br $out))
        (br $in) ;; we can conditionalize this, and then the br out can vanish
      )
    )
    (loop $in
      (br $in)
    )
    (loop
      (block $out
        (if (i32.const 0) (br $out))
        (br $out)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0) (br $out))
        (br $out)
      )
    )
    (loop $in)
    (loop $in
      (block $out)
    )
    (loop $in
      (block $out
        (if (i32.const 0) (br $out))
        (br_if $in (i32.const 1))
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0) (br $in))
        (br $out)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0) (unreachable))
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (block
            (call $loops)
            (br $out)
          )
        )
        (br $in)
      )
    )
    (loop $in-todo ;; br_if into if
      (block $out-todo
        (if (i32.const 0) (br $out-todo))
        (call $loops)
        (br $in-todo)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (br $out)
          (call $loops)
        )
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (call $loops)
          (br $out)
        )
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (call $loops)
          )
          (br $out)
        )
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (br $out)
          (call $loops)
        )
        (drop (i32.const 100))
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (call $loops)
          (br $out)
        )
        (drop (i32.const 101))
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (call $loops)
          )
          (br $out)
        )
        (drop (i32.const 102))
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (br $out)
          (call $loops)
        )
        (return)
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (br $out)
          (call $loops)
        )
        (br $out)
        (br $in)
      )
    )
    (loop $in
      (block $out
        (if (i32.const 0)
          (br $out)
          (call $loops)
        )
        (drop
          (block $out2 (result i32)
            (br $out2 (i32.const 1))
          )
        )
        (br $in)
      )
    )
    (loop $in
      (block $out
        (br_if $out (i32.const 0))
        (br $in)
      )
    )
    (loop $in-todo2 ;; if-ify
      (block $out-todo2
        (br_if $out-todo2 (i32.const 0))
        (call $loops)
        (br $in-todo2)
      )
    )
    (loop $in
      (block $out
        (br $out)
        (br $in)
      )
    )
    (loop $in
      (block $out
        (br_if $in (i32.const 0))
        (br $in)
      )
    )
    (loop $in-not ;; do NOT if-ify, the block can't be removed
      (block $out-not
        (br_if $out-not (i32.const -1))
        (br_if $out-not (i32.const 0))
        (call $loops)
        (br $in-not)
      )
    )
    (loop $in-todo2 ;; if-ify a slice with 2 things
      (block $out-todo2
        (br_if $out-todo2 (i32.const 0))
        (call $loops)
        (drop (i32.const 1))
        (br $in-todo2)
      )
    )
  )
  (func $br_if_in_block (result i32)
    (block $outval (result i32)
      (block $in
        (if (i32.const 1) (br $in) (br $in))
        (drop (i32.const 2))
        (if (i32.const 3) (unreachable) (br $in))
        (drop (i32.const 4))
        (if (i32.const 5) (br $in) (unreachable))
        (drop (i32.const 6))
      )
      (if (result i32) (i32.const 6) (br $outval (i32.const 7)) (i32.const 8))
    )
  )
  (func $threading
    (drop
      (block $value-out (result i32)
        (block $value-in (result i32)
          (block $out
            (block $in
              (if (i32.const 1)
                (br $in)
              )
              (br_if $in (i32.const 2))
              (br $value-in (i32.const 3))
            )
            (br $out)
          )
          (i32.const 4)
        )
      )
    )
    (block $stack1
      (block $stack2
        (block $stack3
          (block $stack4
            (if (i32.const 1)
              (br $stack4)
            )
            (unreachable)
          )
          (br $stack3)
        )
        (br $stack2)
      )
      (br $stack1)
    )
  )
  (func $if-to-br_if-conflict (param $x i32) (param $y i32) (result i32)
    (block $leave
      (set_local $y
        (block $out (result i32)
          (if
            (get_local $x)
            (br $out
              (block (result i32)
                (set_local $x (i32.const 0))
                (i32.const 1)
              )
            )
            (br_if $leave (i32.const 1))
          )
          (unreachable)
        )
      )
    )
    (i32.add (get_local $x) (get_local $y))
  )
  (func $if-to-br_if-conflict2 (param $x i32) (param $y i32) (result i32)
    (block $leave
      (set_local $y
        (block $out (result i32)
          (if
            (get_local $x)
            (br_if $leave (i32.const 1))
            (br $out
              (block (result i32)
                (set_local $x (i32.const 0))
                (i32.const 1)
              )
            )
          )
          (unreachable)
        )
      )
    )
    (i32.add (get_local $x) (get_local $y))
  )
  (func $if-to-br_if-value-sideeffect (param $x i32) (param $y i32) (result i32)
    (block $leave
      (set_local $y
        (block $out (result i32)
          (if
            (get_local $x)
            (br $out
              (block (result i32)
                (drop (call $if-to-br_if-value-sideeffect (i32.const 0) (i32.const 1)))
                (nop)
                (i32.const 1)
              )
            )
          )
          (unreachable)
        )
      )
    )
    (i32.add (get_local $x) (get_local $y))
  )
  (func $fuzz (param $j i32) (param $g i32)
    (block $label$break$c
      (loop $label$continue$d
        (block $label$break$d
          (if
            (i32.lt_s
              (get_local $j)
              (i32.const 2147483640)
            )
            (block $x
              (block $y
                (block $z
                  (br_if $y
                    (get_local $j)
                  )
                  (br $x) ;; don't be confused by this
                )
                (nop) ;; get me to the store!
              )
            )
            (block $switch$26
              (nop)
            )
          )
          (i32.store
            (i32.const 5724)
            (i32.const -254899267)
          )
          (br $label$continue$d)
        )
      )
    )
  )
  (func $iffify
    (block $yes
      (br_if $yes
        (i32.const 0)
      )
      (drop (i32.const 1))
      (drop (i32.const 2))
    )
    (block $no
      (br_if $no
        (i32.const 0)
      )
      (drop (i32.const 1))
      (br $no)
      (drop (i32.const 2))
    )
    (block $no2
      (br_if $no2
        (i32.const 0)
      )
    )
    (block $no3
      (br $no3)
      (drop (i32.const 1))
      (drop (i32.const 2))
    )
    (block $no5
      (block $no4
        (br_if $no5
          (i32.const 0)
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
      )
    )
  )
  (func $loop-if (result i32)
    (block $outer (result i32)
      (loop $typed (result i32)
        ;; we can move the br after us into our if-else, which means we are the final
        ;; element in the block,
        (if
          (i32.const 2)
          (block
            (drop (call $loop-if))
            (br $outer (i32.const 0))
          )
        )
        (br $typed)
      )
    )
  )
  (func $block-break (param $0 i32)
    (block $block$7$break
      (block $shape$6$continue
        (call $block-break (i32.const 1))
        (br $block$7$break)
      )
    )
  )
  (func $loop-break (param $0 i32)
    (block $block$7$break
      (loop $shape$6$continue
        (call $loop-break (i32.const 1))
        (br_if $shape$6$continue
          (get_local $0)
        )
        (br $block$7$break)
      )
    )
  )
  (func $untaken-brs-might-prevent-block-removal (param $0 f32) (param $1 i32) (param $2 f32) (param $3 i32) (param $4 i32) (param $5 f64) (param $6 f32) (result i32)
   (block $label$0 (result i32)
    (block $label$1 ;; this block has no taken brs, but we can't remove it without removing them first
     (br_if $label$1
      (i32.const 607395945)
     )
     (br_if $label$1
      (i32.load16_s offset=3 align=1
       (select
        (call $untaken-brs-might-prevent-block-removal
         (f32.const 1.4904844647389837e-07)
         (br_if $label$0
          (i32.store16 offset=4 align=1
           (i32.const 1900641)
           (br $label$0
            (i32.const 1628075109)
           )
          )
          (i32.const 1764950569)
         )
         (f32.const 1.1910939690100655e-32)
         (i32.const 1628057906)
         (i32.const 859068982)
         (f64.const 2.524518840347722e-258)
         (f32.const -nan:0x40a63)
        )
        (i32.const 688529440)
        (i32.const 1751478890)
       )
      )
     )
    )
    (i32.const 1935947830)
   )
  )
  (func $unexitable-loops-result (param $0 i32) (result i64)
   (loop $label$0
    (loop $label$1
     (if
      (i32.load8_s
       (i32.const 201460482)
      )
      (br $label$0)
      (block $label$3
       (br_if $label$3
        (get_local $0)
       )
      )
     )
     (br $label$1)
    )
   )
  )
  (func $untaken-br-with-concrete-last-element
   (block $label$8
    (block $label$11
     (block $label$14
      (br_if $label$14
       (br $label$11
       )
      )
     )
    )
   )
  )
  (func $untaken-br-with-concrete-last-element2 (result i32)
   (block $label$8 (result i32)
    (block $label$11 (result i32)
     (block $label$14 (result i32)
      (br_if $label$14
       (i32.const 102)
       (br $label$11
        (i32.const 103)
       )
      )
     )
    )
   )
  )
  (func $untaken-br_if-then-if
   (block $label$0
    (br_if $label$0
     (unreachable)
    )
    (if
     (i32.const 0)
     (nop)
    )
   )
  )
  (func $unreachable-if-that-could-be-a-br_if (result i64)
   (loop $label$3 (result i64)
    (drop
     (if (result f64)
      (unreachable)
      (f64.const 1)
      (br $label$3)
     )
    )
    (i64.const 1)
   )
  )
  (func $nop-br-might-update-type
   (block $label$39
    (drop
     (if (result i32)
      (unreachable)
      (if (result i32)
       (i32.const 1)
       (br $label$39) ;; if we nop this, then the parent type must change
       (i32.const 0)
      )
      (i32.const 0)
     )
    )
   )
  )
  (func $no-flow-through-if-without-else (result f32)
   (local $0 i32)
   (local $2 f32)
   (block $label$0
    (if
     (get_local $0)
     (block $label$11
      (return
       (f32.const 239)
      )
      (if
       (i32.const 0)
       (return
        (get_local $2)
       )
      )
     )
     (return
      (f32.const -9223372036854775808)
     )
    )
   )
  )
  (func $unreachable-return-loop-value (result i64)
   (loop $loop
    (if
     (i32.const 1)
     (block $block
      (br_if $block
       (br $loop)
      )
      (br $loop)
     )
    )
    (br $loop) ;; we 100% go back to the loop top, the loop is never exited. but opts move code around so that is not obvious anymore, and the loop becomes a nop, but the func has a return value
   )
  )
  (func $obviously-flows-out-maybe (param $var$0 i32) (result f32)
   (block $label$1 (result f32)
    (br $label$1
     (f32.const 1)
    )
    (loop $label$5
     (if
      (i32.const 11)
      (block $label$8  ;; this block is none - it has a break, even if not taken - and so looks like it might flow out,
       (br_if $label$8 ;; and so we can't move it outside to be the end of the loop's block
        (unreachable)
       )
       (br $label$5)
      )
     )
     (br $label$5)
    )
   )
  )
  (func $br-to-table (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-too-few (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
        )
      )
    )
  )
  (func $br-to-table-one-more (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (br_if $x (i32.eq (get_local $a) (i32.const 3)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-overlap (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 1)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-overlap-start (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 0)))
          (br_if $z (i32.eq (get_local $a) (i32.const 1)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-offset (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 15)))
          (br_if $y (i32.eq (get_local $a) (i32.const 16)))
          (br_if $z (i32.eq (get_local $a) (i32.const 17)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-RANGE-high (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 10)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-RANGE-low (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 3)))
          (br_if $z (i32.eq (get_local $a) (i32.const 9)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-bad (param $a i32) (result i32)
    (block $value (result i32)
      (block $x
        (block $y
          (block $z
            (nop)
            (br $x)
            (br_if $x (i32.eq (get_local $a) (i32.const 0)))
            (br_if $y (i32.eq (get_local $a) (i32.const 1)))
            (br_if $z (i32.eq (get_local $a) (i32.const 2)))
            (unreachable)
          )
          (unreachable)
        )
        (unreachable)
      )
      (i32.const 2000)
    )
  )
  (func $br-to-table-bad2 (param $a i32) (result i32)
    (block $value (result i32)
      (block $x
        (block $y
          (block $z
            (nop)
            (drop (br_if $value (i32.const 1000) (i32.eq (get_local $a) (i32.const 0))))
            (br_if $x (i32.eq (get_local $a) (i32.const 0)))
            (br_if $y (i32.eq (get_local $a) (i32.const 1)))
            (br_if $z (i32.eq (get_local $a) (i32.const 2)))
            (unreachable)
          )
          (unreachable)
        )
        (unreachable)
      )
      (i32.const 2000)
    )
  )
  (func $br-to-table-bad3 (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (i32.const 10) (i32.const 0)))
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-multi (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $z (i32.eq (i32.const 10) (i32.const 5)))
          (br_if $y (i32.eq (i32.const 10) (i32.const 6)))
          (br_if $x (i32.eq (i32.const 10) (i32.const 7)))
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-bad4 (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.ne (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-bad5 (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (get_local $a)))
          (br_if $y (i32.eq (get_local $a) (get_local $a)))
          (br_if $z (i32.eq (get_local $a) (get_local $a)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-bad6 (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (call $b13) (i32.const 0)))
          (br_if $y (i32.eq (call $b13) (i32.const 1)))
          (br_if $z (i32.eq (call $b13) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-bad7 (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const -1))) ;; negative, we support only positive up to int32_max
          (br_if $y (i32.eq (get_local $a) (i32.const -1)))
          (br_if $z (i32.eq (get_local $a) (i32.const -1)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-defaultNameOverlaps (param $a i32)
    (block $x
      (block $tablify|0
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $tablify|0 (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-unreach (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (unreachable) (i32.const 0)))
          (br_if $y (i32.eq (unreachable) (i32.const 1)))
          (br_if $z (i32.eq (unreachable) (i32.const 2)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $br-to-table-overlap-but-later (param $a i32)
    (block $x
      (block $y
        (block $z
          (br_if $x (i32.eq (get_local $a) (i32.const 0)))
          (br_if $y (i32.eq (get_local $a) (i32.const 1)))
          (br_if $z (i32.eq (get_local $a) (i32.const 1)))
          (br_if $x (i32.eq (get_local $a) (i32.const 2)))
          (br_if $y (i32.eq (get_local $a) (i32.const 3)))
          (unreachable)
        )
        (unreachable)
      )
      (unreachable)
    )
    (unreachable)
  )
  (func $tiny-switch
    (block $x
      (block $y
        (br_table $x $y
          (i32.const 0)
        )
      )
    )
    (block $z
      (br_table $z
        (i32.const 0)
      )
    )
  )
  (func $trim-switch
    (block $A
      (block $y
        (br_table $y $y $A $y $A $y $A $y $y $y $y $y $y $y $y $y $y $y
          (i32.const 0)
        )
      )
      (call $trim-switch)
    )
  )
  (func $same-target-br_if-and-br
    (block $x
      (br_if $x
        (i32.const 0)
      )
      (br $x)
      (unreachable)
    )
  )
  (func $simple-switch (result i32)
    (block $A
      (block $B
        (block $y
          (br_table $A $y $y $y $y $y $A $y $y $y $y $A $y
            (i32.const 0)
          )
          (return (i32.const 0))
        )
        (return (i32.const 1))
      )
      (return (i32.const 2))
    )
    (return (i32.const 3))
  )
  (func $simple-switch-2 (result i32)
    (block $A
      (block $B
        (block $y
          (br_table $A $y $y $y $y $y $y $y $y $y $y $y $A $y
            (i32.const 0)
          )
          (return (i32.const 0))
        )
        (return (i32.const 1))
      )
      (return (i32.const 2))
    )
    (return (i32.const 3))
  )
  (func $simple-switch-3 (result i32)
    (block $A
      (block $B
        (block $y
          (br_table $A $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $B $y
            (i32.const 0)
          )
          (return (i32.const 0))
        )
        (return (i32.const 1))
      )
      (return (i32.const 2))
    )
    (return (i32.const 3))
  )
  (func $simple-switch43 (result i32)
    (block $A
      (block $B
        (block $y
          (br_table $A $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $B $y
            (i32.const 0)
          )
          (return (i32.const 0))
        )
        (return (i32.const 1))
      )
      (return (i32.const 2))
    )
    (return (i32.const 3))
  )
  (func $simple-switch-5 (result i32)
    (block $A
      (block $B
        (block $y
          (br_table $A $y $y $y $y $y $A $y $y $y $y $y $A $y
            (i32.const 0)
          )
          (return (i32.const 0))
        )
        (return (i32.const 1))
      )
      (return (i32.const 2))
    )
    (return (i32.const 3))
  )
  (func $undo-if-return (param $p i32) (result i32)
    (local $x i32)
    (block $out
      (set_local $x
        (if (result i32)
          (get_local $p)
          (br $out)
          (i32.const 1)
        )
      )
      (set_local $x
        (if (result i32)
          (get_local $p)
          (i32.const 2)
          (br $out)
        )
      )
      (set_local $x
        (if (result i32)
          (get_local $p)
          (br $out)
          (br $out)
        )
      )
    )
    (get_local $p)
  )
  (func $if-unreachable-but-declares-value (param $var$0 i32) (param $var$1 f64) (param $var$2 i32) (param $var$3 f64) (param $var$4 f32) (param $var$5 f32) (result i32)
   (local $var$6 f64)
   (if
    (i32.const 0)
    (drop
     (loop $label$3 (result i64)
      (block $label$4 (result i64)
       (block $label$5
        (block $label$6
         (set_local $var$1
          (if (result f64)
           (unreachable)
           (br $label$5)
           (f64.const 1)
          )
         )
        )
        (nop)
       )
       (i64.const 1)
      )
     )
    )
   )
   (i32.const 0)
  )
  (func $if-flow-1 (result i32)
    (if
      (i32.const 0)
      (return (i32.const 1))
      (return (i32.const 2))
    )
  )
  (func $if-flow-2 (result i32)
    (if
      (i32.const 0)
      (unreachable)
      (return (i32.const 2))
    )
  )
  (func $if-flow-3 (result i32)
    (if
      (i32.const 0)
      (return (i32.const 1))
      (unreachable)
    )
  )
  (func $if-flow-4 (result i32)
    (if
      (return (i32.const 0))
      (return (i32.const 1))
      (return (i32.const 2))
    )
  )
  (func $iff-flow-fuzz-bug (result i32)
   (loop $label$1
    (if
     (i32.const 1)
     (loop $label$2
      (unreachable)
      (if ;; a loop that is never reached at the end of a loop
       (i32.const 0)
       (nop)
       (return
        (i32.const 0)
       )
      )
     )
    )
    (br $label$1)
   )
  )
  (func $fuzz-block-unreachable-brs-with-values (result i32)
   (local $0 i32)
   (loop $label$1 (result i32)
    (block $label$2 (result i32)
     (if
      (get_local $0)
      (set_local $0
       (loop $label$5
        (br_if $label$5
         (br_if $label$2
          (unreachable)
          (i32.const 0)
         )
        )
       )
      )
     )
     (br $label$1)
    )
   )
  )
  (func $drop-restructure-if (param $x i32) (param $y i32) (result i32)
   (block $label$2 (result i32)
    (drop
     (br_if $label$2
      (get_local $x)
      (get_local $y)
     )
    )
    (i32.const 0)
   )
  )
  (func $drop-restructure-if-final (param $x i32) (param $y i32) (result i32)
   (block $label$2 (result i32)
    (drop
     (br_if $label$2
      (get_local $x)
      (get_local $y)
     )
    )
    (unreachable)
   )
  )
  (func $drop-restructure-if-middle (param $x i32) (param $y i32) (result i32)
   (block $label$2 (result i32)
    (drop
     (br_if $label$2
      (get_local $x)
      (get_local $y)
     )
    )
    (nop) ;; the middle
    (i32.const 0)
   )
  )
  (func $drop-restructure-if-bad (param $x i32) (param $y i32) (result i32)
   (block $label$2 (result i32)
    (drop
     (br_if $label$2
      (tee_local $y (get_local $x))
      (get_local $y)
     )
    )
    (i32.const 0)
   )
  )
  (func $drop-restructure-if-bad-2 (param $x i32) (param $y i32) (result i32)
   (block $label$2 (result i32)
    (drop
     (br_if $label$2
      (get_local $y)
      (tee_local $y (get_local $x))
     )
    )
    (i32.const 0)
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
  (func $switch-to-br
    (block $A
      (block $y
        (br_table $y $y $A $A
          (i32.const 0)
        )
      )
    )
  )
  (func $switch-to-br-value (result i32)
    (block $A (result i32)
      (block $y (result i32)
        (br_table $A $A $A
          (i32.const 0)
          (i32.const 1)
        )
      )
    )
  )
  (func $switch-threading-multi (param $x i32) (param $y i32) (result i32)
   (block $block$5$break
    (block $block$4$break
     (loop $shape$1$continue
      (block $block$3$break
       (block $switch$2$case$5
        (block $switch$2$case$4
         (block $switch$2$default
          (block $switch$2$case$2
           (br_table $switch$2$case$2 $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$case$5 $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$default $switch$2$case$4 $switch$2$default
            (get_local $x)
           )
          )
          (br $shape$1$continue)
         )
         (br $block$3$break)
        ) ;; switch$2$case$4
        (br $block$4$break)
       )
       (br $block$5$break)
      )
     )
     (unreachable)
    ) ;; block$4$break
    (set_local $y
     (i32.const 1)
    )
    (unreachable)
   )
   (set_local $y
    (i32.const 2)
   )
   (unreachable)
  )
  (func $fuzz-type-changes-in-our-cycles (result i32)
   (loop $label$1
    (if
     (i32.const 0)
     (block $label$3
      (if
       (i32.const 0)
       (block
        (nop)
        (br $label$3)
       )
       (return
        (i32.const -8192)
       )
      )
     )
    )
    (br $label$1)
   )
  )
)

