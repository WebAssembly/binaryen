(module
  (memory 256 256)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$iiiii (func (param i32 i32 i32 i32) (result i32)))
  (type $FUNCSIG$iiiiii (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $4 (func (param i32)))
  (type $5 (func (param i32) (result i32)))
  (type $6 (func (param i32 i32 i32 i32 i32 i32)))
  (import $waka "env" "waka")
  (import $waka_int "env" "waka_int" (result i32))
  (import $_i64Subtract "env" "i64sub" (param i32 i32 i32 i32) (result i32))
  (import $___udivmoddi4 "env" "moddi" (param i32 i32 i32 i32 i32) (result i32))
  (import $lp "env" "lp" (param i32 i32) (result i32))
  (import "fuzzing-support" "log-f32" (func $fimport$0 (param f32)))
  (global $global$0 (mut i32) (i32.const 10))
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (local.set $x (i32.const 1))
    (if (local.get $x) (nop))
    (if (local.get $x) (nop))
    (local.set $y (if (result i32) (i32.const 2) (i32.const 3) (i32.const 4)))
    (drop (local.get $y))
    (local.set $z (block (result i32) (i32.const 5)))
    (drop (local.get $z))
    (if (i32.const 6)
      (local.set $a (i32.const 7))
      (local.set $a (i32.const 8))
    )
    (drop (local.get $a))
    (block $val
      (if (i32.const 10)
        (block
          (local.set $b (i32.const 11))
          (br $val)
        )
      )
      (local.set $b (i32.const 12))
    )
    (drop (local.get $b))
  )
  (func $b0-yes (type $4) (param $i1 i32)
    (local $x i32)
    (local $y i32)
    (local $a i32)
    (local $b i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (local $8 i32)
    (local.set $x
      (i32.const 5)
    )
    (drop
      (local.get $x)
    )
    (block $block0
      (local.set $x
        (i32.const 7)
      )
      (drop
        (local.get $x)
      )
    )
    (local.set $x
      (i32.const 11)
    )
    (drop
      (local.get $x)
    )
    (local.set $x
      (i32.const 9)
    )
    (drop
      (local.get $y)
    )
    (block $block1
      (local.set $x
        (i32.const 8)
      )
      (drop
        (local.get $y)
      )
    )
    (local.set $x
      (i32.const 11)
    )
    (drop
      (local.get $y)
    )
    (local.set $x
      (i32.const 17)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $x)
    )
    (drop
      (local.get $x)
    )
    (block $block2
      (local.set $a
        (i32.const 1)
      )
      (local.set $b
        (i32.const 2)
      )
      (drop
        (local.get $a)
      )
      (drop
        (local.get $b)
      )
      (local.set $a
        (i32.const 3)
      )
      (local.set $b
        (i32.const 4)
      )
      (local.set $a
        (i32.const 5)
      )
      (local.set $b
        (i32.const 6)
      )
      (drop
        (local.get $b)
      )
      (drop
        (local.get $a)
      )
      (local.set $a
        (i32.const 7)
      )
      (local.set $b
        (i32.const 8)
      )
      (local.set $a
        (i32.const 9)
      )
      (local.set $b
        (i32.const 10)
      )
      (call $waka)
      (drop
        (local.get $a)
      )
      (drop
        (local.get $b)
      )
      (local.set $a
        (i32.const 11)
      )
      (local.set $b
        (i32.const 12)
      )
      (local.set $a
        (i32.const 13)
      )
      (local.set $b
        (i32.const 14)
      )
      (drop
        (i32.load
          (i32.const 24)
        )
      )
      (drop
        (local.get $a)
      )
      (drop
        (local.get $b)
      )
      (local.set $a
        (i32.const 15)
      )
      (local.set $b
        (i32.const 16)
      )
      (local.set $a
        (i32.const 17)
      )
      (local.set $b
        (i32.const 18)
      )
      (i32.store
        (i32.const 48)
        (i32.const 96)
      )
      (drop
        (local.get $a)
      )
      (drop
        (local.get $b)
      )
    )
    (block $block3
      (local.set $a
        (call $waka_int)
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (call $waka_int)
      )
      (call $waka)
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (call $waka_int)
      )
      (drop
        (i32.load
          (i32.const 1)
        )
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (call $waka_int)
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (i32.load
          (i32.const 100)
        )
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (i32.load
          (i32.const 101)
        )
      )
      (drop
        (i32.load
          (i32.const 1)
        )
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (i32.load
          (i32.const 102)
        )
      )
      (call $waka)
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (i32.load
          (i32.const 103)
        )
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (block (result i32)
          (block
            (local.set $5
              (i32.const 105)
            )
            (i32.store
              (i32.const 104)
              (local.get $5)
            )
          )
          (local.get $5)
        )
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (block (result i32)
          (block
            (local.set $6
              (i32.const 107)
            )
            (i32.store
              (i32.const 106)
              (local.get $6)
            )
          )
          (local.get $6)
        )
      )
      (call $waka)
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (block (result i32)
          (block
            (local.set $7
              (i32.const 109)
            )
            (i32.store
              (i32.const 108)
              (local.get $7)
            )
          )
          (local.get $7)
        )
      )
      (drop
        (i32.load
          (i32.const 1)
        )
      )
      (drop
        (local.get $a)
      )
      (call $waka)
      (local.set $a
        (block (result i32)
          (block
            (local.set $8
              (i32.const 111)
            )
            (i32.store
              (i32.const 110)
              (local.get $8)
            )
          )
          (local.get $8)
        )
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (local.get $a)
      )
      (call $waka)
    )
    (block $out-of-block
      (local.set $a
        (i32.const 1337)
      )
      (block $b
        (block $c
          (br $b)
        )
        (local.set $a
          (i32.const 9876)
        )
      )
      (drop
        (local.get $a)
      )
    )
    (block $loopey
      (local.set $a
        (i32.const 1337)
      )
      (drop
        (loop $loop-in5 (result i32)
          (drop
            (local.get $a)
          )
          (local.tee $a
            (i32.const 9876)
          )
        )
      )
      (drop
        (local.get $a)
      )
    )
  )
  (func $Ia (type $5) (param $a i32) (result i32)
    (local $b i32)
    (block $switch$0
      (block $switch-default$6
        (local.set $b
          (i32.const 60)
        )
      )
    )
    (return
      (local.get $b)
    )
  )
  (func $memories (type $6) (param $i2 i32) (param $i3 i32) (param $bi2 i32) (param $bi3 i32) (param $ci3 i32) (param $di3 i32)
    (local $set_with_no_get i32)
    (local.set $i3
      (i32.const 1)
    )
    (i32.store8
      (local.get $i2)
      (local.get $i3)
    )
    (local.set $bi3
      (i32.const 1)
    )
    (i32.store8
      (local.get $bi3)
      (local.get $bi3)
    )
    (local.set $ci3
      (local.get $bi3)
    )
    (i32.store8
      (local.get $bi3)
      (local.get $ci3)
    )
    (local.set $di3
      (local.tee $bi3
        (i32.const 123)
      )
    )
    (i32.store8
      (local.get $bi3)
      (local.get $di3)
    )
    (local.set $set_with_no_get
      (i32.const 456)
    )
  )
  (func $___remdi3 (type $FUNCSIG$iiiii) (param $$a$0 i32) (param $$a$1 i32) (param $$b$0 i32) (param $$b$1 i32) (result i32)
    (local $$1$1 i32)
    (local $$1$0 i32)
    (local $$rem i32)
    (local $__stackBase__ i32)
    (local $$2$1 i32)
    (local $$2$0 i32)
    (local $$4$1 i32)
    (local $$4$0 i32)
    (local $$10$1 i32)
    (local $$10$0 i32)
    (local $$6$0 i32)
    (local.set $__stackBase__
      (i32.load
        (i32.const 8)
      )
    )
    (i32.store
      (i32.const 8)
      (i32.add
        (i32.load
          (i32.const 8)
        )
        (i32.const 16)
      )
    )
    (local.set $$rem
      (local.get $__stackBase__)
    )
    (local.set $$1$0
      (i32.or
        (i32.shr_s
          (local.get $$a$1)
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (local.get $$a$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (local.set $$1$1
      (i32.or
        (i32.shr_s
          (if (result i32)
            (i32.lt_s
              (local.get $$a$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (local.get $$a$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (local.set $$2$0
      (i32.or
        (i32.shr_s
          (local.get $$b$1)
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (local.get $$b$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (local.set $$2$1
      (i32.or
        (i32.shr_s
          (if (result i32)
            (i32.lt_s
              (local.get $$b$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (local.get $$b$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (local.set $$4$0
      (call $_i64Subtract
        (i32.xor
          (local.get $$1$0)
          (local.get $$a$0)
        )
        (i32.xor
          (local.get $$1$1)
          (local.get $$a$1)
        )
        (local.get $$1$0)
        (local.get $$1$1)
      )
    )
    (local.set $$4$1
      (i32.load
        (i32.const 168)
      )
    )
    (drop
      (call $___udivmoddi4
        (local.get $$4$0)
        (local.get $$4$1)
        (call $_i64Subtract
          (i32.xor
            (local.get $$2$0)
            (local.get $$b$0)
          )
          (i32.xor
            (local.get $$2$1)
            (local.get $$b$1)
          )
          (local.get $$2$0)
          (local.get $$2$1)
        )
        (i32.load
          (i32.const 168)
        )
        (local.get $$rem)
      )
    )
    (local.set $$10$0
      (call $_i64Subtract
        (i32.xor
          (i32.load
            (local.get $$rem)
          )
          (local.get $$1$0)
        )
        (i32.xor
          (i32.load offset=4
            (local.get $$rem)
          )
          (local.get $$1$1)
        )
        (local.get $$1$0)
        (local.get $$1$1)
      )
    )
    (local.set $$10$1
      (i32.load
        (i32.const 168)
      )
    )
    (i32.store
      (i32.const 8)
      (local.get $__stackBase__)
    )
    (return
      (block $block12 (result i32)
        (i32.store
          (i32.const 168)
          (local.get $$10$1)
        )
        (local.get $$10$0)
      )
    )
  )
  (func $block-returns (type $FUNCSIG$v)
    (local $x i32)
    (block $out
      (block $waka
        (local.set $x
          (i32.const 12)
        )
        (br_if $waka
          (i32.const 1)
        )
        (local.set $x
          (i32.const 34)
        )
      )
      (br_if $out
        (i32.const 1)
      )
      (drop
        (local.get $x)
      )
      (block $waka2
        (if
          (i32.const 1)
          (local.set $x
            (i32.const 13)
          )
          (local.set $x
            (i32.const 24)
          )
        )
        (if
          (i32.const 1)
          (block $block3
            (local.set $x
              (i32.const 14)
            )
          )
          (block $block5
            (local.set $x
              (i32.const 25)
            )
          )
        )
      )
      (br_if $out
        (i32.const 1)
      )
      (block $sink-out-of-me-i-have-but-one-exit
        (local.set $x
          (i32.const 99)
        )
      )
      (drop
        (local.get $x)
      )
    )
  )
  (func $multiple (type $6) (param $s i32) (param $r i32) (param $f i32) (param $p i32) (param $t i32) (param $m i32)
    (local.set $s
      (local.get $m)
    )
    (local.set $r
      (i32.add
        (local.get $f)
        (local.get $p)
      )
    )
    (local.set $t
      (local.get $p)
    )
    (local.set $p
      (i32.load
        (i32.const 0)
      )
    )
    (i32.store
      (local.get $r)
      (local.get $t)
    )
    (drop
      (local.get $s)
    )
    (drop
      (local.get $t)
    )
  )
  (func $switch-def (type $5) (param $i3 i32) (result i32)
    (local $i1 i32)
    (local.set $i1
      (i32.const 10)
    )
    (block $switch$def
      (block $switch-case$1
        (br_table $switch-case$1 $switch$def
          (local.get $i3)
        )
      )
      (local.set $i1
        (i32.const 1)
      )
    )
    (return
      (local.get $i1)
    )
  )
  (func $no-out-of-label (param $x i32) (param $y i32)
    (loop $moar
      (local.set $x
        (block (result i32)
          (br_if $moar (local.get $x))
          (i32.const 0)
        )
      )
    )
    (drop (local.get $x))
    (block $moar
      (local.set $y
        (block (result i32)
          (br_if $moar (local.get $y))
          (i32.const 0)
        )
      )
    )
    (drop (local.get $y))
  )
  (func $freetype-cd (param $a i32) (result i32)
    (local $e i32)
    (loop $while-in$1
      (block $while-out$0
        (local.set $e
          (local.get $a)
        )
        (local.set $a ;; this set must happen, so that if the br_if does not break, we have the right $a later down - once we use a block return value, the $a set's outside the block
          (i32.const 4)
        )
        (br_if $while-out$0
          (local.get $e)
        )
        (local.set $a
          (i32.add
            (local.get $a)
            (i32.const 0)
          )
        )
      )
    )
    (local.get $a)
  )
  (func $drop-if-value (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $temp i32)
    (drop
      (if (result i32)
        (local.get $x)
        (block $block53 (result i32)
          (nop)
          (local.set $temp
            (local.get $y)
          )
          (local.get $z)
        )
        (block $block54 (result i32)
          (nop)
          (local.set $temp
            (local.get $y)
          )
          (local.get $z)
        )
      )
    )
    (drop (local.get $temp))
    (return
      (i32.const 0)
    )
  )
  (func $drop-br_if (param $label i32) (param $$cond2 i32) (param $$$0151 i32) (result i32)
    (block $label$break$L4
      (if
        (i32.eq
          (local.get $label)
          (i32.const 15)
        )
        (block $block
          (local.set $label
            (i32.const 0)
          )
          (local.set $$cond2
            (i32.eq
              (local.get $$$0151)
              (i32.const 0)
            )
          )
          (br_if $label$break$L4 ;; when we add a value to this, its type changes as it returns the value too, so must be dropped
            (i32.eqz
              (local.get $$cond2)
            )
          )
        )
      )
      (local.set $label
        (i32.const 1)
      )
    )
    (local.get $label)
  )
  (func $drop-tee-unreachable
    (local $x i32)
    (drop
      (local.tee $x
        (unreachable)
      )
    )
    (drop
      (local.get $x)
    )
  )
  (func $if-return-but-unreachable (param $var$0 i64)
   (if
    (unreachable)
    (local.set $var$0
     (local.get $var$0)
    )
    (local.set $var$0
     (i64.const 1)
    )
   )
  )
  (func $if-one-side (result i32)
   (local $x i32)
   (if
    (i32.const 1)
    (local.set $x
     (i32.const 2)
    )
   )
   (local.get  $x)
  )
  (func $if-one-side-undo (result i32)
   (local $x i32)
   (local $y i32)
   (local.set $y
    (i32.const 0)
   )
   (if
    (i32.const 1)
    (local.set $x
     (i32.const 2)
    )
   )
   (local.get  $y)
  )
  (func $if-one-side-multi (param $0 i32) (result i32)
   (if
    (i32.lt_s
     (local.get $0)
     (i32.const -1073741824)
    )
    (local.set $0
     (i32.const -1073741824)
    )
    (if
     (i32.gt_s
      (local.get $0)
      (i32.const 1073741823)
     )
     (local.set $0
      (i32.const 1073741823)
     )
    )
   )
   (local.get $0)
  )
  (func $if-one-side-undo-but-its-a-tee (param $0 i32) (result i32)
   (local $1 i32)
   (local $2 i32)
   (local $3 i32)
   (local $4 i32)
   (local $x i32)
   (local $y i32)
   (local $z i32)
   ;; break these splittable ifs up
   (local.set $x
     (if (result i32)
       (i32.const -1)
       (i32.const -2)
       (local.get $x)
     )
   )
   ;; oops, this one is a tee
   (drop
    (call $if-one-side-undo-but-its-a-tee
     (local.tee $x
       (if (result i32)
         (i32.const -3)
         (i32.const -4)
         (local.get $x)
       )
     )
    )
   )
   ;; sinkable
   (local.set $y
     (if (result i32)
       (i32.const -5)
       (i32.const -6)
       (local.get $y)
     )
   )
   (drop (i32.eqz (local.get $y)))
   ;; tee-able at best
   (local.set $z
     (if (result i32)
       (i32.const -7)
       (i32.const -8)
       (local.get $z)
     )
   )
   (drop
    (i32.add
     (local.get $z)
     (local.get $z)
    )
   )
   (if
    (block $label$1 (result i32)
     (if
      (i32.const 1)
      (local.set $4
       (i32.const 2)
      )
     )
     (if
      (local.get $4)
      (local.set $4
       (i32.const 0)
      )
     )
     (local.get $4)
    )
    (unreachable)
   )
   (i32.const 0)
  )
  (func $splittable-ifs-multicycle (param $20 i32) (result i32)
   (local.set $20
    (if (result i32)
     (i32.const 1)
     (if (result i32)
      (i32.const 2)
      (if (result i32)
       (i32.const 3)
       (i32.const 4)
       (local.get $20)
      )
      (local.get $20)
     )
     (local.get $20)
    )
   )
   (local.get $20)
  )
  (func $update-getCounter (param $0 i32) (param $1 f64) (param $2 f64) (param $3 f32) (param $4 i32) (result f64)
   (global.set $global$0
    (i32.sub
     (global.get $global$0)
     (i32.const 1)
    )
   )
   (global.set $global$0
    (i32.sub
     (global.get $global$0)
     (i32.const 1)
    )
   )
   (loop $label$1 (result f64)
    (global.set $global$0
     (i32.sub
      (global.get $global$0)
      (i32.const 1)
     )
    )
    (global.set $global$0
     (i32.sub
      (global.get $global$0)
      (i32.const 1)
     )
    )
    (call $fimport$0
     (local.tee $3
      (if (result f32)
       (i32.eqz
        (local.get $0)
       )
       (f32.const 4623408228068004207103214e13)
       (local.get $3)
      )
     )
    )
    (global.set $global$0
     (i32.sub
      (global.get $global$0)
      (i32.const 1)
     )
    )
    (if (result f64)
     (global.get $global$0)
     (block
      (global.set $global$0
       (i32.sub
        (global.get $global$0)
        (i32.const 1)
       )
      )
      (local.set $0
       (i32.const -65)
      )
      (global.set $global$0
       (i32.sub
        (global.get $global$0)
        (i32.const 1)
       )
      )
      (br $label$1)
     )
     (f64.const -70)
    )
   )
  )
)
(module
  (memory (shared 256 256))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$iiiii (func (param i32 i32 i32 i32) (result i32)))
  (type $FUNCSIG$iiiiii (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $4 (func (param i32)))
  (type $5 (func (param i32) (result i32)))
  (type $6 (func (param i32 i32 i32 i32 i32 i32)))
  (import "fuzzing-support" "log1" (func $fimport$0 (result i32)))
  (import "fuzzing-support" "log2" (func $fimport$1 (param i32)))
  (import "fuzzing-support" "log3" (func $fimport$2 (param f32)))
  (global $global$0 (mut i32) (i32.const 10))
  (func $nonatomics (result i32) ;; loads are reordered
    (local $x i32)
    (local.set $x (i32.load (i32.const 1024)))
    (drop (i32.load (i32.const 1028)))
    (local.get $x)
  )
  (func $nonatomic-growmem (result i32) ;; memory.grow is modeled as modifying memory
    (local $x i32)
    (local.set $x (i32.load (memory.grow (i32.const 1))))
    (drop (i32.load (i32.const 1028)))
    (local.get $x)
  )
  (func $atomics ;; atomic loads don't pass each other
    (local $x i32)
    (local.set $x (i32.atomic.load (i32.const 1024)))
    (drop (i32.atomic.load (i32.const 1028)))
    (drop (local.get $x))
  )
  (func $one-atomic ;; atomic loads don't pass other loads
    (local $x i32)
    (local.set $x (i32.load (i32.const 1024)))
    (drop (i32.atomic.load (i32.const 1028)))
    (drop (local.get $x))
  )
  (func $other-atomic ;; atomic loads don't pass other loads
    (local $x i32)
    (local.set $x (i32.atomic.load (i32.const 1024)))
    (drop (i32.load (i32.const 1028)))
    (drop (local.get $x))
  )
  (func $atomic-growmem (result i32) ;; memory.grow is modeled as modifying memory
    (local $x i32)
    (local.set $x (i32.load (memory.grow (i32.const 1))))
    (drop (i32.atomic.load (i32.const 1028)))
    (local.get $x)
  )
  (func $atomicrmw ;; atomic rmw don't pass loads
    (local $x i32)
    (local.set $x (i32.atomic.rmw.add (i32.const 1024) (i32.const 1)))
    (drop (i32.atomic.load (i32.const 1028)))
    (drop (local.get $x))
  )
  (func $atomic-cmpxchg ;; cmpxchg don't pass loads
    (local $x i32)
    (local.set $x (i32.atomic.rmw.cmpxchg (i32.const 1024) (i32.const 1) (i32.const 2)))
    (drop (i32.atomic.load (i32.const 1028)))
    (drop (local.get $x))
  )
  (func $br-value-reordering (result i32)
   (local $temp i32)
   (block $outside
    (loop $loop ;; we should exit this loop, hit the unreachable outside
     ;; loop logic
     (br_if $outside ;; we should not create a block value that adds a value to a br, if the value&condition of the br cannot be reordered,
                     ;; as the value comes first
      (block (result i32)
       (br_if $loop
        (local.get $temp) ;; false, don't loop
       )
       (unreachable) ;; the end
       (local.set $temp
        (i32.const -1)
       )
       (i32.const 0)
      )
     )
    )
    (local.set $temp
     (i32.const -1)
    )
   )
   (unreachable)
  )
  (func $br-value-reordering-safe (result i32)
   (local $temp i32)
   (block $outside
    (loop $loop ;; we should exit this loop, hit the unreachable outside
     ;; loop logic
     (drop (local.get $temp)) ;; different from above - add a use here
     (br_if $outside ;; we should not create a block value that adds a value to a br, if the value&condition of the br cannot be reordered,
                     ;; as the value comes first
      (block (result i32)
       (local.set $temp ;; the use *is* in the condition, but it's ok, no conflicts
        (i32.const -1)
       )
       (i32.const 0)
      )
     )
    )
    (local.set $temp
     (i32.const -1)
    )
   )
   (unreachable)
  )
  (func $if-one-side-unreachable
   (local $x i32)
   (block $out
    (if
     (i32.const 1)
     (br $out)
     (local.set $x
      (i32.const 2)
     )
    )
    (if
     (i32.const 3)
     (local.set $x
      (i32.const 4)
     )
     (br $out)
    )
    (if
     (i32.const 5)
     (br $out)
     (br $out)
    )
   )
  )
  (func $if-one-side-unreachable-blocks
   (local $x i32)
   (local $y i32)
   (block $out
    (if
     (i32.const 1)
     (block
      (local.set $x
       (i32.const 2)
      )
      (local.set $y
       (i32.const 3)
      )
      (br $out)
     )
     (block
      (local.set $x
       (i32.const 4)
      )
      (local.set $y
       (i32.const 5)
      )
     )
    )
    (if
     (i32.const 6)
     (block
      (local.set $x
       (i32.const 7)
      )
      (local.set $y
       (i32.const 8)
      )
     )
     (block
      (local.set $x
       (i32.const 9)
      )
      (local.set $y
       (i32.const 10)
      )
      (br $out)
     )
    )
    (if
     (i32.const 11)
     (block
      (local.set $x
       (i32.const 12)
      )
      (local.set $y
       (i32.const 13)
      )
      (br $out)
     )
     (block
      (local.set $x
       (i32.const 14)
      )
      (local.set $y
       (i32.const 15)
      )
      (br $out)
     )
    )
   )
  )
  (func $loop-value (param $x i32) (result i32)
    (loop $loopy
      (local.set $x (unreachable))
    )
    (loop $loopy
      (local.set $x (i32.const 1))
    )
    (local.get $x)
  )
  (func $loop-loop-loopy-value (param $x i32) (result i32)
    (loop $loopy1
      (loop $loopy2
        (loop $loopy3
          (local.set $x (i32.const 1))
        )
      )
    )
    (local.get $x)
  )
  (func $loop-modified-during-main-pass-be-careful-fuzz (result i32)
   (local $0 i32)
   (if
    (i32.const 0)
    (local.set $0
     (i32.const 0)
    )
    (loop $label$4
     (br $label$4)
    )
   )
   (local.get $0)
  )
  (func $loop-later (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (param $var$3 i32) (param $var$4 i32) (result i32)
   (loop $label$1
    (block $label$2
     (if
      (i32.const 0)
      (block
       (local.set $var$0
        (i32.const -1)
       )
       (br $label$2)
      )
     )
     (local.set $var$0
      (i32.const -1)
     )
    )
   )
   (i32.const 0)
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
   (local.tee $var$2
    (local.get $var$2)
   )
  )
  (func $multi-pass-get-equivs-right (param $var$0 i32) (param $var$1 i32) (result f64)
   (local $var$2 i32)
   (local.set $var$2
    (local.get $var$0)
   )
   (i32.store
    (local.get $var$2)
    (i32.const 1)
   )
   (f64.promote_f32
    (f32.load
     (local.get $var$2)
    )
   )
  )
  (func $if-value-structure-equivalent (param $x i32) (result i32)
    (local $y i32)
    (if (i32.const 1)
      (local.set $x (i32.const 2))
      (block
        (local.set $y (local.get $x))
        (local.set $x (local.get $y))
      )
    )
    (local.get $x)
  )
  (func $set-tee-need-one-of-them (param $var$0 i32) (param $var$1 i32) (result i32)
   (local $var$2 i32)
   (local $var$3 i32)
   (local.set $var$0 ;; this is redundant
    (local.tee $var$2 ;; but this is not - we need this set, we read it at the end
     (local.get $var$0)
    )
   )
   (loop $loop
    (br_if $loop
     (local.get $var$1)
    )
   )
   (local.get $var$2)
  )
  (func $loop-value-harder (result i32)
   (local $0 i32)
   (local $1 i32)
   (local $2 i32)
   (local $3 f32)
   (local $4 f32)
   (local $5 f32)
   (local $6 f32)
   (local $7 f32)
   (local $8 f32)
   (local $9 f32)
   (local $10 f32)
   (block $label$1
    (loop $label$2
     (block $label$3
      (global.set $global$0
       (i32.const -1)
      )
      (block $label$4
       (local.set $0
        (call $fimport$0)
       )
       (if
        (local.get $0)
        (local.set $5
         (f32.const -2048)
        )
        (block
         (call $fimport$1
          (i32.const -25732)
         )
         (br $label$2)
        )
       )
      )
      (local.set $6
       (local.get $5)
      )
      (local.set $7
       (local.get $6)
      )
     )
     (local.set $8
      (local.get $7)
     )
     (local.set $9
      (local.get $8)
     )
    )
    (local.set $10
     (local.get $9)
    )
    (call $fimport$2
     (local.get $10)
    )
    (local.set $1
     (i32.const -5417091)
    )
   )
   (local.set $2
    (local.get $1)
   )
   (return
    (local.get $2)
   )
  )
  (func $tee-chain
    (param $x i32)
    (param $z i32)
    (param $t1 i32)
    (param $t2 i32)
    (param $t3 i32)
    (result i32)
    (local.set $x
      (local.get $x)
    )
    (local.set $z
      (local.tee $z
        (i32.const 10)
      )
    )
    (local.set $z
      (local.tee $z
        (i32.const 10)
      )
    )
    (local.set $t1
      (local.tee $t2
        (local.tee $t3
          (local.tee $t1
            (call $tee-chain (local.get $x) (local.get $z) (local.get $t1) (local.get $t2) (local.get $t3))
          )
        )
      )
    )
    (call $tee-chain (local.get $x) (local.get $z) (local.get $t1) (local.get $t2) (local.get $t3))
  )
)
(module
 (memory 256 256)
 (data passive "hello, there!")
 (func $memory-init-load
  (local $x i32)
  (local.set $x
   (i32.load (i32.const 0))
  )
  (memory.init 0 (i32.const 0) (i32.const 0) (i32.const 5))
  (drop
   (local.get $x)
  )
 )
 (func $memory-init-store
  (local $x i32)
  (local.set $x
   (block i32
    (i32.store (i32.const 0) (i32.const 42))
    (i32.const 0)
   )
  )
  (memory.init 0 (i32.const 0) (i32.const 0) (i32.const 5))
  (drop
   (local.get $x)
  )
 )
 (func $memory-copy-load
  (local $x i32)
  (local.set $x
   (i32.load (i32.const 0))
  )
  (memory.copy (i32.const 0) (i32.const 8) (i32.const 8))
  (drop
   (local.get $x)
  )
 )
 (func $memory-copy-store
  (local $x i32)
  (local.set $x
   (block i32
    (i32.store (i32.const 0) (i32.const 42))
    (i32.const 0)
   )
  )
  (memory.copy (i32.const 0) (i32.const 8) (i32.const 8))
  (drop
   (local.get $x)
  )
 )
 (func $memory-fill-load
  (local $x i32)
  (local.set $x
   (i32.load (i32.const 0))
  )
  (memory.fill (i32.const 0) (i32.const 42) (i32.const 8))
  (drop
   (local.get $x)
  )
 )
 (func $memory-fill-store
  (local $x i32)
  (local.set $x
   (block i32
    (i32.store (i32.const 0) (i32.const 42))
    (i32.const 0)
   )
  )
  (memory.fill (i32.const 0) (i32.const 8) (i32.const 8))
  (drop
   (local.get $x)
  )
 )
 (func $data-drop-load
  (local $x i32)
  (local.set $x
   (i32.load (i32.const 0))
  )
  (data.drop 0)
  (drop
   (local.get $x)
  )
 )
 (func $data-drop-store
  (local $x i32)
  (local.set $x
   (block i32
    (i32.store (i32.const 0) (i32.const 42))
    (i32.const 0)
   )
  )
  (data.drop 0)
  (drop
   (local.get $x)
  )
 )
 (func $data-drop-memory-init
  (local $x i32)
  (local.set $x
   (block i32
    (memory.init 0 (i32.const 0) (i32.const 0) (i32.const 5))
    (i32.const 0)
   )
  )
  (data.drop 0)
  (drop
   (local.get $x)
  )
 )
)
(module
 (func $subtype-test (result anyref)
  (local $0 funcref)
  (local $1 anyref)
  (local $2 anyref)
  (block
   (local.set $1
    (local.get $0)
   )
  )
  (local.set $2
   (local.get $1)
  )
  (local.get $1)
 )
)
