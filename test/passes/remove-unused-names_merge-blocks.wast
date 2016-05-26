(module
  (memory 256 256)
  (type $i (func (param i32)))
  (type $ii (func (param i32) (param i32)))
  (type $iii (func (param i32) (param i32) (param i32)))
  (table $call-i)
  (func $call-i (param i32)
  )
  (func $call-ii (param i32) (param i32)
  )
  (func $call-iii (param i32) (param i32) (param i32)
  )
  (func $b0-yes (param $i1 i32)
    (block $topmost
      (block
        (i32.const 10)
      )
    )
  )
  (func $b0-no (param $i1 i32)
    (block $topmost
      (block $block0
        (br $block0)
      )
      (br $topmost)
    )
  )
  (func $b0-br-but-ok (param $i1 i32)
    (block $topmost
      (block $block0
        (br $topmost)
      )
    )
  )
  (func $b1-yes (param $i1 i32)
    (block $topmost
      (block
        (block
          (i32.const 10)
        )
      )
    )
  )
  (func $b2-yes (param $i1 i32)
    (block $topmost
      (i32.const 5)
      (block
        (i32.const 10)
      )
      (i32.const 15)
    )
  )
  (func $b3-yes (param $i1 i32)
    (block $topmost
      (i32.const 3)
      (block
        (i32.const 6)
        (block
          (i32.const 10)
        )
        (i32.const 15)
      )
      (i32.const 20)
    )
  )
  (func $b4 (param $i1 i32)
    (block $topmost
      (block $inner
        (i32.const 10)
        (br $inner)
      )
    )
  )
  (func $b5 (param $i1 i32)
    (block $topmost
      (block $middle
        (block $inner
          (i32.const 10)
          (br $inner)
        )
        (br $middle)
      )
    )
  )
  (func $b6 (param $i1 i32)
    (block $topmost
      (i32.const 5)
      (block $inner
        (i32.const 10)
        (br $inner)
      )
      (i32.const 15)
    )
  )
  (func $b7 (param $i1 i32)
    (block $topmost
      (i32.const 3)
      (block $middle
        (i32.const 6)
        (block $inner
          (i32.const 10)
          (br $inner)
        )
        (i32.const 15)
        (br $middle)
      )
      (i32.const 20)
    )
  )
  (func $unary
    (local $x i32)
    (i32.eqz
      (block
        (i32.const 10)
      )
    )
    (i32.eqz
      (block
        (i32.const 10)
        (i32.const 20)
      )
    )
    (i32.eqz
      (block
        (i32.const 10)
        (i32.const 20)
        (i32.const 30)
      )
    )
    (set_local $x
      (block
        (i32.const 10)
        (i32.const 20)
      )
    )
    (i32.load
      (block
        (i32.const 10)
        (i32.const 20)
      )
    )
    (return
      (block
        (i32.const 10)
        (unreachable)
      )
    )
  )
  (func $binary
    (i32.add
      (block
        (i32.const 10)
      )
      (i32.const 20)
    )
    (i32.add
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (i32.const 30)
    )
    (i32.add
      (block
        (i32.const 10)
        (i32.const 20)
        (i32.const 30)
      )
      (i32.const 40)
    )
    (i32.add
      (i32.const 10)
      (block
        (i32.const 20)
      )
    )
    (i32.add
      (i32.const 10)
      (block
        (i32.const 20)
        (i32.const 30)
      )
    )
    (i32.add
      (i32.const 10)
      (block
        (i32.const 20)
        (i32.const 30)
        (i32.const 40)
      )
    )
    (i32.add
      (block
        (i32.const 10)
      )
      (block
        (i32.const 20)
      )
    )
    (i32.add
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
    )
    (i32.add
      (block
        (i32.const 10)
        (i32.const 20)
        (i32.const 30)
      )
      (block
        (i32.const 40)
        (i32.const 50)
        (i32.const 60)
      )
    )
    (i32.store
      (i32.const 10)
      (block
        (i32.const 20)
        (i32.const 30)
      )
    )
    (i32.store
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (i32.const 30)
    )
    (i32.add
      (unreachable) ;; do not move across this TODO: move non-side-effecting
      (block
        (i32.const 10)
        (i32.const 20)
      )
    )
    (i32.add
      (block
        (unreachable) ;; moves out, so does not block the rest
        (i32.const 10)
      )
      (block
        (i32.const 20)
        (i32.const 30)
      )
    )
  )
  (func $trinary
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
      )
      (block
        (i32.const 20)
        (i32.const 30)
      )
      (block
        (i32.const 40)
        (i32.const 50)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
      )
      (block
        (i32.const 40)
        (i32.const 50)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
      )
    )
    (select
      (block
        (i32.const 10)
      )
      (block
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
    )
    (select
      (block
        (i32.const 10)
      )
      (block
        (i32.const 20)
        (i32.const 30)
      )
      (block
        (i32.const 40)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
      )
      (block
        (i32.const 40)
      )
    )
    ;; now for bad stuff
    (select
      (block
        (unreachable)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
        (unreachable)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (unreachable)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (unreachable)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (unreachable)
        (i32.const 60)
      )
    )
    (select
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (unreachable)
      )
    )
  )
  (func $breaks
    (block $out
      (br $out
        (block
          (i32.const 10)
          (i32.const 20)
        )
      )
      (br_if $out
        (block
          (i32.const 10)
          (i32.const 20)
        )
      )
      (br_if $out
        (block
          (i32.const 10)
          (i32.const 20)
        )
        (block
          (i32.const 30)
          (i32.const 40)
        )
      )
      (br_table $out $out
        (block
          (i32.const 10)
          (i32.const 20)
        )
      )
      (br_table $out $out
        (block
          (i32.const 10)
          (i32.const 20)
        )
        (block
          (i32.const 30)
          (i32.const 40)
        )
      )
    )
  )
  (func $calls
    (call $call-i
      (block
        (i32.const 10)
      )
    )
    (call $call-i
      (block
        (i32.const 10)
        (i32.const 20)
      )
    )
    (call $call-i
      (block
        (i32.const 10)
        (i32.const 20)
        (i32.const 30)
      )
    )
    (call $call-ii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
    )
    (call $call-ii
      (block
        (unreachable)
        (i32.const 10)
      )
      (block
        (i32.const 20)
        (i32.const 30)
      )
    )
    (call $call-ii
      (block
        (i32.const 10)
        (unreachable)
      )
      (block
        (i32.const 20)
        (i32.const 30)
      )
    )
    (call $call-ii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (unreachable)
        (i32.const 30)
      )
    )
    (call $call-ii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (unreachable)
      )
    )
    (call $call-iii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (call $call-iii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (i32.const 30)
      (block
        (i32.const 40)
        (i32.const 50)
      )
    )
    (call_indirect $ii
      (block
        (i32.const 10)
        (i32.const 20)
      )
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
    (call_indirect $ii
      (unreachable)
      (block
        (i32.const 30)
        (i32.const 40)
      )
      (block
        (i32.const 50)
        (i32.const 60)
      )
    )
  )
  (func $block-type-change
    (local $0 f64)
    (local $1 f64)
    (if
      (f64.gt
        (get_local $0)
        (block
          (nop)
          (get_local $1)
        )
      )
      (nop)
    )
  )
)

