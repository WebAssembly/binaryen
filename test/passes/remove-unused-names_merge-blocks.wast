(module
  (memory 256 256)
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
    (call_indirect $ii
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
    (call_indirect $ii
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
)
