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
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (set_local $x (i32.const 1))
    (if (get_local $x) (nop))
    (if (get_local $x) (nop))
    (set_local $y (if (result i32) (i32.const 2) (i32.const 3) (i32.const 4)))
    (drop (get_local $y))
    (set_local $z (block (result i32) (i32.const 5)))
    (drop (get_local $z))
    (if (i32.const 6)
      (set_local $a (i32.const 7))
      (set_local $a (i32.const 8))
    )
    (drop (get_local $a))
    (block $val
      (if (i32.const 10)
        (block
          (set_local $b (i32.const 11))
          (br $val)
        )
      )
      (set_local $b (i32.const 12))
    )
    (drop (get_local $b))
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
    (set_local $x
      (i32.const 5)
    )
    (drop
      (get_local $x)
    )
    (block $block0
      (set_local $x
        (i32.const 7)
      )
      (drop
        (get_local $x)
      )
    )
    (set_local $x
      (i32.const 11)
    )
    (drop
      (get_local $x)
    )
    (set_local $x
      (i32.const 9)
    )
    (drop
      (get_local $y)
    )
    (block $block1
      (set_local $x
        (i32.const 8)
      )
      (drop
        (get_local $y)
      )
    )
    (set_local $x
      (i32.const 11)
    )
    (drop
      (get_local $y)
    )
    (set_local $x
      (i32.const 17)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $x)
    )
    (drop
      (get_local $x)
    )
    (block $block2
      (set_local $a
        (i32.const 1)
      )
      (set_local $b
        (i32.const 2)
      )
      (drop
        (get_local $a)
      )
      (drop
        (get_local $b)
      )
      (set_local $a
        (i32.const 3)
      )
      (set_local $b
        (i32.const 4)
      )
      (set_local $a
        (i32.const 5)
      )
      (set_local $b
        (i32.const 6)
      )
      (drop
        (get_local $b)
      )
      (drop
        (get_local $a)
      )
      (set_local $a
        (i32.const 7)
      )
      (set_local $b
        (i32.const 8)
      )
      (set_local $a
        (i32.const 9)
      )
      (set_local $b
        (i32.const 10)
      )
      (call $waka)
      (drop
        (get_local $a)
      )
      (drop
        (get_local $b)
      )
      (set_local $a
        (i32.const 11)
      )
      (set_local $b
        (i32.const 12)
      )
      (set_local $a
        (i32.const 13)
      )
      (set_local $b
        (i32.const 14)
      )
      (drop
        (i32.load
          (i32.const 24)
        )
      )
      (drop
        (get_local $a)
      )
      (drop
        (get_local $b)
      )
      (set_local $a
        (i32.const 15)
      )
      (set_local $b
        (i32.const 16)
      )
      (set_local $a
        (i32.const 17)
      )
      (set_local $b
        (i32.const 18)
      )
      (i32.store
        (i32.const 48)
        (i32.const 96)
      )
      (drop
        (get_local $a)
      )
      (drop
        (get_local $b)
      )
    )
    (block $block3
      (set_local $a
        (call $waka_int)
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (call $waka_int)
      )
      (call $waka)
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (call $waka_int)
      )
      (drop
        (i32.load
          (i32.const 1)
        )
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (call $waka_int)
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (i32.load
          (i32.const 100)
        )
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
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
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (i32.load
          (i32.const 102)
        )
      )
      (call $waka)
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (i32.load
          (i32.const 103)
        )
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (block (result i32)
          (block
            (set_local $5
              (i32.const 105)
            )
            (i32.store
              (i32.const 104)
              (get_local $5)
            )
          )
          (get_local $5)
        )
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (block (result i32)
          (block
            (set_local $6
              (i32.const 107)
            )
            (i32.store
              (i32.const 106)
              (get_local $6)
            )
          )
          (get_local $6)
        )
      )
      (call $waka)
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (block (result i32)
          (block
            (set_local $7
              (i32.const 109)
            )
            (i32.store
              (i32.const 108)
              (get_local $7)
            )
          )
          (get_local $7)
        )
      )
      (drop
        (i32.load
          (i32.const 1)
        )
      )
      (drop
        (get_local $a)
      )
      (call $waka)
      (set_local $a
        (block (result i32)
          (block
            (set_local $8
              (i32.const 111)
            )
            (i32.store
              (i32.const 110)
              (get_local $8)
            )
          )
          (get_local $8)
        )
      )
      (i32.store
        (i32.const 1)
        (i32.const 2)
      )
      (drop
        (get_local $a)
      )
      (call $waka)
    )
    (block $out-of-block
      (set_local $a
        (i32.const 1337)
      )
      (block $b
        (block $c
          (br $b)
        )
        (set_local $a
          (i32.const 9876)
        )
      )
      (drop
        (get_local $a)
      )
    )
    (block $loopey
      (set_local $a
        (i32.const 1337)
      )
      (drop
        (loop $loop-in5 (result i32)
          (drop
            (get_local $a)
          )
          (tee_local $a
            (i32.const 9876)
          )
        )
      )
      (drop
        (get_local $a)
      )
    )
  )
  (func $Ia (type $5) (param $a i32) (result i32)
    (local $b i32)
    (block $switch$0
      (block $switch-default$6
        (set_local $b
          (i32.const 60)
        )
      )
    )
    (return
      (get_local $b)
    )
  )
  (func $memories (type $6) (param $i2 i32) (param $i3 i32) (param $bi2 i32) (param $bi3 i32) (param $ci3 i32) (param $di3 i32)
    (local $set_with_no_get i32)
    (set_local $i3
      (i32.const 1)
    )
    (i32.store8
      (get_local $i2)
      (get_local $i3)
    )
    (set_local $bi3
      (i32.const 1)
    )
    (i32.store8
      (get_local $bi3)
      (get_local $bi3)
    )
    (set_local $ci3
      (get_local $bi3)
    )
    (i32.store8
      (get_local $bi3)
      (get_local $ci3)
    )
    (set_local $di3
      (tee_local $bi3
        (i32.const 123)
      )
    )
    (i32.store8
      (get_local $bi3)
      (get_local $di3)
    )
    (set_local $set_with_no_get
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
    (set_local $__stackBase__
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
    (set_local $$rem
      (get_local $__stackBase__)
    )
    (set_local $$1$0
      (i32.or
        (i32.shr_s
          (get_local $$a$1)
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (get_local $$a$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (set_local $$1$1
      (i32.or
        (i32.shr_s
          (if (result i32)
            (i32.lt_s
              (get_local $$a$1)
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
              (get_local $$a$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (set_local $$2$0
      (i32.or
        (i32.shr_s
          (get_local $$b$1)
          (i32.const 31)
        )
        (i32.shl
          (if (result i32)
            (i32.lt_s
              (get_local $$b$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (set_local $$2$1
      (i32.or
        (i32.shr_s
          (if (result i32)
            (i32.lt_s
              (get_local $$b$1)
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
              (get_local $$b$1)
              (i32.const 0)
            )
            (i32.const -1)
            (i32.const 0)
          )
          (i32.const 1)
        )
      )
    )
    (set_local $$4$0
      (call $_i64Subtract
        (i32.xor
          (get_local $$1$0)
          (get_local $$a$0)
        )
        (i32.xor
          (get_local $$1$1)
          (get_local $$a$1)
        )
        (get_local $$1$0)
        (get_local $$1$1)
      )
    )
    (set_local $$4$1
      (i32.load
        (i32.const 168)
      )
    )
    (drop
      (call $___udivmoddi4
        (get_local $$4$0)
        (get_local $$4$1)
        (call $_i64Subtract
          (i32.xor
            (get_local $$2$0)
            (get_local $$b$0)
          )
          (i32.xor
            (get_local $$2$1)
            (get_local $$b$1)
          )
          (get_local $$2$0)
          (get_local $$2$1)
        )
        (i32.load
          (i32.const 168)
        )
        (get_local $$rem)
      )
    )
    (set_local $$10$0
      (call $_i64Subtract
        (i32.xor
          (i32.load
            (get_local $$rem)
          )
          (get_local $$1$0)
        )
        (i32.xor
          (i32.load offset=4
            (get_local $$rem)
          )
          (get_local $$1$1)
        )
        (get_local $$1$0)
        (get_local $$1$1)
      )
    )
    (set_local $$10$1
      (i32.load
        (i32.const 168)
      )
    )
    (i32.store
      (i32.const 8)
      (get_local $__stackBase__)
    )
    (return
      (block $block12 (result i32)
        (i32.store
          (i32.const 168)
          (get_local $$10$1)
        )
        (get_local $$10$0)
      )
    )
  )
  (func $block-returns (type $FUNCSIG$v)
    (local $x i32)
    (block $out
      (block $waka
        (set_local $x
          (i32.const 12)
        )
        (br_if $waka
          (i32.const 1)
        )
        (set_local $x
          (i32.const 34)
        )
      )
      (br_if $out
        (i32.const 1)
      )
      (drop
        (get_local $x)
      )
      (block $waka2
        (if
          (i32.const 1)
          (set_local $x
            (i32.const 13)
          )
          (set_local $x
            (i32.const 24)
          )
        )
        (if
          (i32.const 1)
          (block $block3
            (set_local $x
              (i32.const 14)
            )
          )
          (block $block5
            (set_local $x
              (i32.const 25)
            )
          )
        )
      )
      (br_if $out
        (i32.const 1)
      )
      (block $sink-out-of-me-i-have-but-one-exit
        (set_local $x
          (i32.const 99)
        )
      )
      (drop
        (get_local $x)
      )
    )
  )
  (func $multiple (type $6) (param $s i32) (param $r i32) (param $f i32) (param $p i32) (param $t i32) (param $m i32)
    (set_local $s
      (get_local $m)
    )
    (set_local $r
      (i32.add
        (get_local $f)
        (get_local $p)
      )
    )
    (set_local $t
      (get_local $p)
    )
    (set_local $p
      (i32.load
        (i32.const 0)
      )
    )
    (i32.store
      (get_local $r)
      (get_local $t)
    )
    (drop
      (get_local $s)
    )
    (drop
      (get_local $t)
    )
  )
  (func $switch-def (type $5) (param $i3 i32) (result i32)
    (local $i1 i32)
    (set_local $i1
      (i32.const 10)
    )
    (block $switch$def
      (block $switch-case$1
        (br_table $switch-case$1 $switch$def
          (get_local $i3)
        )
      )
      (set_local $i1
        (i32.const 1)
      )
    )
    (return
      (get_local $i1)
    )
  )
  (func $no-out-of-label (param $x i32) (param $y i32)
    (loop $moar
      (set_local $x
        (block (result i32)
          (br_if $moar (get_local $x))
          (i32.const 0)
        )
      )
    )
    (drop (get_local $x))
    (block $moar
      (set_local $y
        (block (result i32)
          (br_if $moar (get_local $y))
          (i32.const 0)
        )
      )
    )
    (drop (get_local $y))
  )
  (func $freetype-cd (param $a i32) (result i32)
    (local $e i32)
    (loop $while-in$1
      (block $while-out$0
        (set_local $e
          (get_local $a)
        )
        (set_local $a ;; this set must happen, so that if the br_if does not break, we have the right $a later down - once we use a block return value, the $a set's outside the block
          (i32.const 4)
        )
        (br_if $while-out$0
          (get_local $e)
        )
        (set_local $a
          (i32.add
            (get_local $a)
            (i32.const 0)
          )
        )
      )
    )
    (get_local $a)
  )
  (func $drop-if-value (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $temp i32)
    (drop
      (if (result i32)
        (get_local $x)
        (block $block53 (result i32)
          (nop)
          (set_local $temp
            (get_local $y)
          )
          (get_local $z)
        )
        (block $block54 (result i32)
          (nop)
          (set_local $temp
            (get_local $y)
          )
          (get_local $z)
        )
      )
    )
    (drop (get_local $temp))
    (return
      (i32.const 0)
    )
  )
  (func $drop-br_if (param $label i32) (param $$cond2 i32) (param $$$0151 i32) (result i32)
    (block $label$break$L4
      (if
        (i32.eq
          (get_local $label)
          (i32.const 15)
        )
        (block $block
          (set_local $label
            (i32.const 0)
          )
          (set_local $$cond2
            (i32.eq
              (get_local $$$0151)
              (i32.const 0)
            )
          )
          (br_if $label$break$L4 ;; when we add a value to this, its type changes as it returns the value too, so must be dropped
            (i32.eqz
              (get_local $$cond2)
            )
          )
        )
      )
      (set_local $label
        (i32.const 1)
      )
    )
    (get_local $label)
  )
)
