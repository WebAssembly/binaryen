(module
  (memory (shared 256 256))
  (type $i (func (param i32)))
  (type $ii (func (param i32 i32)))
  (type $iii (func (param i32 i32 i32)))
  (type $3 (func))
  (table 1 1 anyfunc)
  (elem (i32.const 0) $call-i)
  (func $call-i (type $i) (param $0 i32)
    (nop)
  )
  (func $call-ii (type $ii) (param $0 i32) (param $1 i32)
    (nop)
  )
  (func $call-iii (type $iii) (param $0 i32) (param $1 i32) (param $2 i32)
    (nop)
  )
  (func $b0-yes (type $i) (param $i1 i32)
    (block $topmost
      (block $block0
        (drop
          (i32.const 10)
        )
      )
    )
  )
  (func $b0-no (type $i) (param $i1 i32)
    (block $topmost
      (block $block0
        (br $block0)
      )
      (br $topmost)
    )
  )
  (func $b0-br-but-ok (type $i) (param $i1 i32)
    (block $topmost
      (block $block0
        (br $topmost)
      )
    )
  )
  (func $b1-yes (type $i) (param $i1 i32)
    (block $topmost
      (block $block0
        (block $block1
          (drop
            (i32.const 10)
          )
        )
      )
    )
  )
  (func $b2-yes (type $i) (param $i1 i32)
    (block $topmost
      (drop
        (i32.const 5)
      )
      (block $block0
        (drop
          (i32.const 10)
        )
      )
      (drop
        (i32.const 15)
      )
    )
  )
  (func $b3-yes (type $i) (param $i1 i32)
    (block $topmost
      (drop
        (i32.const 3)
      )
      (block $block0
        (drop
          (i32.const 6)
        )
        (block $block1
          (drop
            (i32.const 10)
          )
        )
        (drop
          (i32.const 15)
        )
      )
      (drop
        (i32.const 20)
      )
    )
  )
  (func $b4 (type $i) (param $i1 i32)
    (block $topmost
      (block $inner
        (drop
          (i32.const 10)
        )
        (br $inner)
      )
    )
  )
  (func $b5 (type $i) (param $i1 i32)
    (block $topmost
      (block $middle
        (block $inner
          (drop
            (i32.const 10)
          )
          (br $inner)
        )
        (br $middle)
      )
    )
  )
  (func $b6 (type $i) (param $i1 i32)
    (block $topmost
      (drop
        (i32.const 5)
      )
      (block $inner
        (drop
          (i32.const 10)
        )
        (br $inner)
      )
      (drop
        (i32.const 15)
      )
    )
  )
  (func $b7 (type $i) (param $i1 i32)
    (block $topmost
      (drop
        (i32.const 3)
      )
      (block $middle
        (drop
          (i32.const 6)
        )
        (block $inner
          (drop
            (i32.const 10)
          )
          (br $inner)
        )
        (drop
          (i32.const 15)
        )
        (br $middle)
      )
      (drop
        (i32.const 20)
      )
    )
  )
  (func $unary (type $3)
    (local $x i32)
    (drop
      (i32.eqz
        (block $block0 (result i32)
          (i32.const 10)
        )
      )
    )
    (drop
      (i32.eqz
        (block $block1 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.eqz
        (block $block2 (result i32)
          (drop
            (i32.const 10)
          )
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
      )
    )
    (set_local $x
      (block $block3 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i32.load
        (block $block4 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
      )
    )
    (return
      (block $block5
        (drop
          (i32.const 10)
        )
        (unreachable)
      )
    )
  )
  (func $binary (type $3)
    (drop
      (i32.add
        (block $block0 (result i32)
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i32.add
        (block $block1 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
    (drop
      (i32.add
        (block $block2 (result i32)
          (drop
            (i32.const 10)
          )
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
        (i32.const 40)
      )
    )
    (drop
      (i32.add
        (i32.const 10)
        (block $block3 (result i32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 10)
        (block $block4 (result i32)
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 10)
        (block $block5 (result i32)
          (drop
            (i32.const 20)
          )
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
      )
    )
    (drop
      (i32.add
        (block $block6 (result i32)
          (i32.const 10)
        )
        (block $block7 (result i32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.add
        (block $block8 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block9 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
      )
    )
    (drop
      (i32.add
        (block $block10 (result i32)
          (drop
            (i32.const 10)
          )
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
        (block $block11 (result i32)
          (drop
            (i32.const 40)
          )
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (i32.store
      (i32.const 10)
      (block $block12 (result i32)
        (drop
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
    (i32.store
      (block $block13 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (i32.const 30)
    )
    (drop
      (i32.add
        (unreachable)
        (block $block14 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.add
        (block $block15 (result i32)
          (unreachable)
          (i32.const 10)
        )
        (block $block16 (result i32)
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
      )
    )
  )
  (func $trinary (type $3)
    (drop
      (select
        (block $block0 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block1 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block2 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block3 (result i32)
          (i32.const 10)
        )
        (block $block4 (result i32)
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
        (block $block5 (result i32)
          (drop
            (i32.const 40)
          )
          (i32.const 50)
        )
      )
    )
    (drop
      (select
        (block $block6 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block7 (result i32)
          (i32.const 30)
        )
        (block $block8 (result i32)
          (drop
            (i32.const 40)
          )
          (i32.const 50)
        )
      )
    )
    (drop
      (select
        (block $block9 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block10 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block11 (result i32)
          (i32.const 50)
        )
      )
    )
    (drop
      (select
        (block $block12 (result i32)
          (i32.const 10)
        )
        (block $block13 (result i32)
          (i32.const 20)
        )
        (block $block14 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
      )
    )
    (drop
      (select
        (block $block15 (result i32)
          (i32.const 10)
        )
        (block $block16 (result i32)
          (drop
            (i32.const 20)
          )
          (i32.const 30)
        )
        (block $block17 (result i32)
          (i32.const 40)
        )
      )
    )
    (drop
      (select
        (block $block18 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block19 (result i32)
          (i32.const 30)
        )
        (block $block20 (result i32)
          (i32.const 40)
        )
      )
    )
    (drop
      (select
        (block $block21 (result i32)
          (unreachable)
          (i32.const 20)
        )
        (block $block22 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block23 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block24 (result i32)
          (drop
            (i32.const 10)
          )
          (unreachable)
        )
        (block $block25 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block26 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block27 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block28 (result i32)
          (unreachable)
          (i32.const 40)
        )
        (block $block29 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block30 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block31 (result i32)
          (drop
            (i32.const 30)
          )
          (unreachable)
        )
        (block $block32 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block33 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block34 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block35 (result i32)
          (unreachable)
          (i32.const 60)
        )
      )
    )
    (drop
      (select
        (block $block36 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block37 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block38 (result i32)
          (drop
            (i32.const 50)
          )
          (unreachable)
        )
      )
    )
  )
  (func $breaks (type $3)
    (block $out
      (block
        (drop
          (block $block0 (result i32)
            (drop
              (i32.const 10)
            )
            (i32.const 20)
          )
        )
        (br $out)
      )
      (br_if $out
        (block $block1 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
      )
      (block
        (drop
          (block $block2 (result i32)
            (drop
              (i32.const 10)
            )
            (i32.const 20)
          )
        )
        (br_if $out
          (block $block3 (result i32)
            (drop
              (i32.const 30)
            )
            (i32.const 40)
          )
        )
      )
      (br_table $out $out
        (block $block4 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
      )
      (drop
        (block $out2 (result i32)
          (br_table $out2 $out2
            (block $block5 (result i32)
              (drop
                (i32.const 10)
              )
              (i32.const 20)
            )
            (block $block6 (result i32)
              (drop
                (i32.const 30)
              )
              (i32.const 40)
            )
          )
        )
      )
      (unreachable)
    )
  )
  (func $calls (type $3)
    (call $call-i
      (block $block0 (result i32)
        (i32.const 10)
      )
    )
    (call $call-i
      (block $block1 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (call $call-i
      (block $block2 (result i32)
        (drop
          (i32.const 10)
        )
        (drop
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
    (call $call-ii
      (block $block3 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (block $block4 (result i32)
        (drop
          (i32.const 30)
        )
        (i32.const 40)
      )
    )
    (call $call-ii
      (block $block5 (result i32)
        (unreachable)
        (i32.const 10)
      )
      (block $block6 (result i32)
        (drop
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
    (call $call-ii
      (block $block7 (result i32)
        (drop
          (i32.const 10)
        )
        (unreachable)
      )
      (block $block8 (result i32)
        (drop
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
    (call $call-ii
      (block $block9 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (block $block10 (result i32)
        (unreachable)
        (i32.const 30)
      )
    )
    (call $call-ii
      (block $block11 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (block $block12 (result i32)
        (drop
          (i32.const 30)
        )
        (unreachable)
      )
    )
    (call $call-iii
      (block $block13 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (block $block14 (result i32)
        (drop
          (i32.const 30)
        )
        (i32.const 40)
      )
      (block $block15 (result i32)
        (drop
          (i32.const 50)
        )
        (i32.const 60)
      )
    )
    (call $call-iii
      (block $block16 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (i32.const 30)
      (block $block17 (result i32)
        (drop
          (i32.const 40)
        )
        (i32.const 50)
      )
    )
    (call_indirect (type $ii)
      (block $block18 (result i32)
        (drop
          (i32.const 10)
        )
        (i32.const 20)
      )
      (block $block19 (result i32)
        (drop
          (i32.const 30)
        )
        (i32.const 40)
      )
      (block $block20 (result i32)
        (drop
          (i32.const 50)
        )
        (i32.const 60)
      )
    )
    (call_indirect (type $ii)
      (unreachable)
      (block $block21 (result i32)
        (drop
          (i32.const 30)
        )
        (i32.const 40)
      )
      (block $block22 (result i32)
        (drop
          (i32.const 50)
        )
        (i32.const 60)
      )
    )
    (call_indirect (type $ii)
      (block $block21 (result i32)
        (drop
          (i32.const 31)
        )
        (i32.const 41)
      )
      (unreachable)
      (block $block22 (result i32)
        (drop
          (i32.const 51)
        )
        (i32.const 61)
      )
    )
    (call_indirect (type $ii)
      (block $block21 (result i32)
        (drop
          (i32.const 32)
        )
        (i32.const 42)
      )
      (block $block22 (result i32)
        (drop
          (i32.const 52)
        )
        (i32.const 62)
      )
      (unreachable)
    )
  )
  (func $atomics (type $3)
    (drop
      (i32.atomic.rmw.cmpxchg ;; mergeblock logic should be same as select
        (block $block0 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (block $block1 (result i32)
          (drop
            (i32.const 30)
          )
          (i32.const 40)
        )
        (block $block2 (result i32)
          (drop
            (i32.const 50)
          )
          (i32.const 60)
        )
      )
    )
    (drop
      (i32.atomic.rmw.add ;; atomicrmw is like a binary
        (block $block1 (result i32)
          (drop
            (i32.const 10)
          )
          (i32.const 20)
        )
        (i32.const 30)
      )
    )
  )
  (func $mix-select (param $x i32)
    (drop
      (select
        (get_local $x)
        (get_local $x)
        (block (result i32)
          (set_local $x ;; cannot be moved before the gets
            (i32.const 1)
          )
          (i32.const 2)
        )
      )
    )
  )
  (func $block-type-change (type $3)
    (local $0 f64)
    (local $1 f64)
    (if
      (f64.gt
        (get_local $0)
        (block $block0 (result f64)
          (nop)
          (get_local $1)
        )
      )
      (nop)
    )
  )
  (func $do-reorder (param $x i32)
    (local $y i32)
    (if (i32.const 1)
      (block
        (set_local $x
          (i32.le_u
            (get_local $x)
            (block (result i32)
              (set_local $y (i32.const 5))
              (i32.const 10)
            )
          )
        )
      )
    )
  )
  (func $do-not-reorder (param $x i32)
    (local $y i32)
    (if (i32.const 1)
      (block
        (set_local $x
          (i32.le_u
            (get_local $y)
            (block (result i32)
              (set_local $y (i32.const 5))
              (i32.const 10)
            )
          )
        )
      )
    )
  )
  (func $return-different-type (result i32)
    (drop
      (f64.abs
        (return
          (block (result i32) ;; when we flip the block out, it should have an ok type for the (dead) f64 op
            (drop (i32.const 2))
            (i32.const 1)
          )
        )
      )
    )
    (unreachable)
  )

 (func $drop-unreachable (result i32)
  (local $0 i32)
  (block $label$1 (result i32)
   (drop
    (block (result i32)
     (unreachable)
    )
   )
   (unreachable)
  )
 )
 (func $concrete_finale_in_unreachable (result f64)
  (block $label$0 (result f64)
   (drop
    (block (result f64)
     (unreachable)
     (f64.const 6.322092475576799e-96)
    )
   )
   (f64.const -1)
  )
 )
 (func $dont-move-unreachable
  (loop $label$0
   (drop
    (block $label$3 (result i32)
     (br $label$0)
     (i32.const 1)
    )
   )
  )
 )
 (func $dont-move-unreachable-last
  (loop $label$0
   (drop
    (block $label$3 (result i32)
     (call $dont-move-unreachable-last)
     (br $label$0)
    )
   )
  )
 )
 (func $move-around-unreachable-in-middle
  (loop $label$0
   (drop
    (block $label$2 (result i32)
     (block $block2
      (nop)
     )
     (block $label$3 (result i32)
      (drop
       (br_if $label$3
        (br $label$0)
        (i32.const 0)
       )
      )
      (i32.const 1)
     )
    )
   )
  )
 )
 (func $drop-unreachable-block-with-concrete-final
  (drop
   (block (result i32)
    (drop
     (block
      (drop
       (return)
      )
     )
    )
    (i32.const -452)
   )
  )
 )
 (func $merging-with-unreachable-in-middle (result i32)
  (block $label$1 (result i32)
   (block (result i32)
    (return
     (i32.const 21536)
    )
    (block $label$15
     (br $label$15)
    )
    (i32.const 19299)
   )
  )
 )
 (func $remove-br-after-unreachable
  (block $label$9
   (drop
    (block
     (block
      (return)
      (br $label$9) ;; removing this leads to the block becoming unreachable
     )
    )
   )
  )
 )
 (func $block-tails
  (block $l1
   (drop (i32.const -2))
   (drop (i32.const -1))
   (br $l1)
   (drop (i32.const 0))
   (drop (i32.const 1))
  )
  (block $l2
   (br_if $l2 (i32.const 2))
   (drop (i32.const 3))
  )
  (block $b1
   (block $l3
    (br_if $b1 (i32.const 4))
    (br_if $l3 (i32.const 5))
    (drop (i32.const 6))
   )
  )
  (block $b2
   (block $l4
    (br_if $l4 (i32.const 7))
    (br_if $b2 (i32.const 8))
    (drop (i32.const 9))
   )
  )
  (block $l5
   (if (i32.const 10)
    (br_if $l5 (i32.const 11))
   )
   (drop (i32.const 12))
  )
  (block $l6
   (block $l7
    (block $l8
     (br_if $l6 (i32.const 13))
     (br_if $l7 (i32.const 14))
     (br_if $l8 (i32.const 15))
     (drop (i32.const 16))
    )
   )
  )
  (block $l9
   (block $l10
    (block $l11
     (br_if $l11 (i32.const 17))
     (br_if $l10 (i32.const 18))
     (br_if $l9  (i32.const 19))
     (drop (i32.const 20))
    )
   )
  )
  (block $l12
   (block $l13
    (block $l14
     (br_if $l12 (i32.const 21))
     (br_if $l13 (i32.const 22))
     (br_if $l14 (i32.const 23))
     (drop (i32.const 24))
    )
    (drop (i32.const 25))
   )
   (drop (i32.const 26))
  )
  (block $l15
   (block $l16
    (block $l17
     (drop (i32.const 27))
     (br_if $l17 (i32.const 28))
     (drop (i32.const 29))
    )
    (br_if $l16 (i32.const 30))
    (drop (i32.const 31))
   )
   (br_if $l15 (i32.const 32))
   (drop (i32.const 33))
  )
 )
 (func $loop-tails
  (loop $l1
   (drop (i32.const -2))
   (drop (i32.const -1))
   (br $l1)
   (drop (i32.const 0))
   (drop (i32.const 1))
  )
  (loop $l2
   (br_if $l2 (i32.const 2))
   (drop (i32.const 3))
  )
  (block $b1
   (loop $l3
    (br_if $b1 (i32.const 4))
    (br_if $l3 (i32.const 5))
    (drop (i32.const 6))
   )
  )
  (block $b2
   (loop $l4
    (br_if $l4 (i32.const 7))
    (br_if $b2 (i32.const 8))
    (drop (i32.const 9))
   )
  )
  (loop $l5
   (if (i32.const 10)
    (br_if $l5 (i32.const 11))
   )
   (drop (i32.const 12))
  )
  (loop $l6
   (loop $l7
    (loop $l8
     (br_if $l6 (i32.const 13))
     (br_if $l7 (i32.const 14))
     (br_if $l8 (i32.const 15))
     (drop (i32.const 16))
    )
   )
  )
  (loop $l9
   (loop $l10
    (loop $l11
     (br_if $l11 (i32.const 17))
     (br_if $l10 (i32.const 18))
     (br_if $l9  (i32.const 19))
     (drop (i32.const 20))
    )
   )
  )
  (loop $l12
   (loop $l13
    (loop $l14
     (br_if $l12 (i32.const 21))
     (br_if $l13 (i32.const 22))
     (br_if $l14 (i32.const 23))
     (drop (i32.const 24))
    )
    (drop (i32.const 25))
   )
   (drop (i32.const 26))
  )
  (loop $l15
   (loop $l16
    (loop $l17
     (drop (i32.const 27))
     (br_if $l17 (i32.const 28))
     (drop (i32.const 29))
    )
    (br_if $l16 (i32.const 30))
    (drop (i32.const 31))
   )
   (br_if $l15 (i32.const 32))
   (drop (i32.const 33))
  )
 )
 (func $block-tail-one
  (block $outer
   (block $l1
    (drop (i32.const -2))
    (drop (i32.const -1))
    (br $l1)
    (drop (i32.const 0))
    (drop (i32.const 1))
   )
   (drop (i32.const 2))
  )
 )
 (func $loop-tail-one
  (block $outer
   (loop $l1
    (drop (i32.const -2))
    (drop (i32.const -1))
    (br $l1)
    (drop (i32.const 0))
    (drop (i32.const 1))
   )
   (drop (i32.const 2))
  )
 )
 (func $block-tail-value (result i32)
  (block $outer (result i32)
   (block $l1 (result i32)
    (drop (i32.const -1))
    (br $l1 (i32.const 0))
    (drop (i32.const 1))
    (i32.const 2)
   )
  )
 )
 (func $block-tail-empty
  (block $outer
   (block $l1
    (drop (i32.const -1))
    (br $l1)
   )
  )
 )
 (func $loop-tail-empty
  (block $outer
   (loop $l1
    (drop (i32.const -1))
    (br $l1)
   )
  )
 )
 (func $block-tail-unreachable (result i32)
  (block $outer (result i32)
   (block $l1 (result i32)
    (drop (i32.const -1))
    (drop (br_if $l1 (i32.const 0) (i32.const 1)))
    (drop (i32.const 1))
    (unreachable)
   )
  )
 )
 (func $loop-tail-unreachable (result i32)
  (block $outer (result i32)
   (loop $l1 (result i32)
    (drop (i32.const -1))
    (br_if $l1 (i32.const 1))
    (drop (i32.const 1))
    (unreachable)
   )
  )
 )
)
(module
 (func $unreachable-in-sub-block (param $0 f64) (param $1 i32) (result i32)
  (local $2 i32)
  (local $9 i32)
  (loop $label$1
   (set_local $9
    (tee_local $2
     (block $label$2 (result i32)
      (block
       (drop
        (br_if $label$2
         (tee_local $2
          (i32.const 0)
         )
         (i32.const 0)
        )
       )
      )
      (br_if $label$1
       (i32.const 0)
      )
      (block
       (unreachable)
       (nop) ;; bad if moved out to the outer block which is i32. current state works since this block is unreachable!
      )
     )
    )
   )
  )
  (nop)
  (get_local $9)
 )
 (func $trivial (result i32)
   (block (result i32)
     (block
       (unreachable)
       (nop)
     )
   )
 )
 (func $trivial-more (result i32)
   (block (result i32)
     (block
       (nop)
       (unreachable)
       (nop)
       (nop)
       (nop)
     )
     (block
       (nop)
       (unreachable)
       (nop)
     )
   )
 )
)
(module
 (func $merge-some-block
  (block $b1
   (drop (i32.const 1))
   (br_if $b1 (i32.const 0))
  )
  (block $b2
   (br_if $b2 (i32.const 0))
   (drop (i32.const 2))
  )
  (block $b3
   (drop (i32.const 3))
   (br_if $b3 (i32.const 0))
   (drop (i32.const 4))
  )
  (block $b3-dead-code-so-ignore
   (drop (i32.const 3))
   (br $b3-dead-code-so-ignore)
   (drop (i32.const 4))
  )
  (block $b4
   (drop (i32.const 5))
   (br_if $b4 (i32.const 0))
   (drop (i32.const 6))
   (br_if $b4 (i32.const 0))
  )
  (block $b5
   (br_if $b5 (i32.const 0))
   (drop (i32.const 7))
   (br_if $b5 (i32.const 0))
   (drop (i32.const 8))
  )
  (block $b6
   (drop (i32.const 9))
   (drop (i32.const 10))
   (br_if $b6 (i32.const 0))
  )
 )
 (func $merge-some-loop
  (loop $l1
   (block $b1
    (drop (i32.const 1))
    (br_if $b1 (i32.const 0))
   )
  )
  (loop $l2
   (block $b2
    (br_if $b2 (i32.const 0))
    (drop (i32.const 2))
   )
  )
  (loop $l3
   (block $b3
    (drop (i32.const 3))
    (br_if $b3 (i32.const 0))
    (drop (i32.const 4))
   )
  )
  (loop $l4
   (block $b4
    (drop (i32.const 5))
    (br_if $b4 (i32.const 0))
    (drop (i32.const 6))
    (br_if $b4 (i32.const 0))
   )
  )
  (loop $l5
   (block $b5
    (br_if $b5 (i32.const 0))
    (drop (i32.const 7))
    (br_if $b5 (i32.const 0))
    (drop (i32.const 8))
   )
  )
  (loop $l6
   (block $b6
    (drop (i32.const 9))
    (drop (i32.const 10))
    (br_if $b6 (i32.const 0))
   )
  )
 )
 (func $merge-some-loop-taken
  (loop $l1
   (block $b1
    (drop (i32.const 1))
    (br_if $l1 (i32.const 0))
    (drop (i32.const 2))
    (br_if $b1 (i32.const 0))
    (drop (i32.const 3))
   )
  )
  (loop $l2
   (block $b2
    (drop (i32.const 4))
    (br_if $b2 (i32.const 0))
    (drop (i32.const 5))
    (br_if $l2 (i32.const 0))
    (drop (i32.const 6))
   )
  )
  (loop $l3
   (block $b3
    (drop (i32.const 7))
    (br_if $b3 (i32.const 0))
    (drop (i32.const 8))
    (br_if $l3 (i32.const 0))
   )
  )
  (loop $l4
   (block $b4
    (br_if $l4 (i32.const 0))
    (drop (i32.const 9))
    (br_if $b4 (i32.const 0))
    (drop (i32.const 10))
   )
  )
  (loop $l5
   (block $b5
    (drop (i32.const 7))
    (br_if $b5 (i32.const 0))
    (br_if $l5 (i32.const 0))
   )
  )
  (loop $l6
   (block $b6
    (br_if $l6 (i32.const 0))
    (br_if $b6 (i32.const 0))
    (drop (i32.const 10))
   )
  )
  (loop $l7
   (block $b7
    (drop (i32.const 11))
    (br_if $l7 (i32.const 0))
    (br_if $b7 (i32.const 0))
    (drop (i32.const 13))
   )
  )
  (loop $l8
   (block $b8
    (drop (i32.const 14))
    (br_if $b8 (i32.const 0))
    (br_if $l8 (i32.const 0))
    (drop (i32.const 16))
   )
  )
  (loop $l9
   (block $b9
    (drop (i32.const 17))
    (br_if $l9 (i32.const 0))
    (drop (i32.const 18))
    (br_if $l9 (i32.const 0))
    (drop (i32.const 19))
   )
  )
  (loop $l10
   (block $b10
    (drop (i32.const 20))
    (br_if $l10 (i32.const 0))
    (drop (i32.const 21))
   )
  )
  (loop $l11
   (block $b11
    (br_if $l11 (i32.const 0))
    (drop (i32.const 23))
   )
  )
  (loop $l12
   (block $b12
    (drop (i32.const 24))
    (br_if $l12 (i32.const 0))
   )
  )
 )
)
