(module
  (memory 10)
  (type $ii (func (param i32 i32)))
  (type $1 (func))
  (table $call-me)
  (func $call-me (type $ii) (param $0 i32) (param $1 i32)
    (nop)
  )
  (func $code-to-kill (type $1)
    (local $x i32)
    (block $out
      (br $out)
      (drop
        (i32.const 0)
      )
      (if
        (i32.const 1)
        (drop
          (i32.const 2)
        )
      )
      (br_table $out $out $out $out
        (i32.const 3)
      )
      (call $code-to-kill)
    )
    (if
      (i32.const 0)
      (block $out
        (unreachable)
        (drop
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 0)
      (block $out
        (return)
        (drop
          (i32.const 0)
        )
      )
    )
    (block $out
      (br_table $out $out $out $out
        (i32.const 4)
      )
      (drop
        (i32.const 0)
      )
    )
    (block $out
      (br_if $out
        (i32.const 3)
      )
      (drop
        (i32.const 0)
      )
    )
    (if
      (i32.const 0)
      (block $block4
        (if
          (i32.const 0)
          (block $out
            (unreachable)
            (drop
              (i32.const 0)
            )
          )
          (block $out
            (unreachable)
            (drop
              (i32.const 0)
            )
          )
        )
        (drop
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 0)
      (block $out
        (br $out
          (unreachable)
        )
        (drop
          (i32.const 0)
        )
        (unreachable)
      )
    )
    (if
      (i32.const 0)
      (block $out
        (br_if $out
          (unreachable)
          (i32.const 0)
        )
        (drop
          (i32.const 0)
        )
        (unreachable)
      )
    )
    (if
      (i32.const 0)
      (block $out
        (br_if $out
          (unreachable)
          (unreachable)
        )
        (drop
          (i32.const 0)
        )
        (unreachable)
      )
    )
    (block $out
      (block $in
        (br_if $out
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (if
      (i32.const 0)
      (block $block11
        (block $out
          (block $in
            (br_if $in
              (i32.const 1)
            )
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (block $out
      (block $in
        (br_table $out $in
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (block $out
      (block $in
        (br_table $in $out
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (if
      (i32.const 0)
      (block $block13
        (block $out
          (block $in
            (br_table $in $in
              (i32.const 1)
            )
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (if
      (i32.const 0)
      (block $block15
        (drop
          (i32.const 10)
        )
        (drop
          (i32.const 42)
        )
        (unreachable)
        (return
          (unreachable)
        )
        (unreachable)
        (return)
      )
    )
    (if
      (i32.const 0)
      (loop $loop-in18
        (unreachable)
      )
    )
    (block $out
    (loop $in
      (br_if $out
        (i32.const 1)
      )
      (unreachable)
    )
    )
    (if
      (i32.const 0)
      (block $block20
        (loop $in
          (br_if $in
            (i32.const 1)
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (if
      (i32.const 1)
      (call $call-me
        (i32.const 123)
        (unreachable)
      )
    )
    (if
      (i32.const 2)
      (call $call-me
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const 3)
      (call $call-me
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const -1)
      (call_indirect $ii
        (i32.const 123)
        (i32.const 456)
        (unreachable)
      )
    )
    (if
      (i32.const -2)
      (call_indirect $ii
        (i32.const 139)
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const -3)
      (call_indirect $ii
        (i32.const 246)
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const -4)
      (call_indirect $ii
        (unreachable)
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 11)
      (set_local $x
        (unreachable)
      )
    )
    (if
      (i32.const 22)
      (drop
        (i32.load
          (unreachable)
        )
      )
    )
    (if
      (i32.const 33)
      (i32.store
        (i32.const 0)
        (unreachable)
      )
    )
    (if
      (i32.const 44)
      (i32.store
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const 55)
      (i32.store
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 66)
      (drop
        (i32.eqz
          (unreachable)
        )
      )
    )
    (if
      (i32.const 77)
      (drop
        (i32.add
          (unreachable)
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 88)
      (drop
        (i32.add
          (i32.const 0)
          (unreachable)
        )
      )
    )
    (if
      (i32.const 99)
      (i32.add
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 100)
      (drop
        (select
          (i32.const 123)
          (i32.const 456)
          (unreachable)
        )
      )
    )
    (if
      (i32.const 101)
      (drop
        (select
          (i32.const 123)
          (unreachable)
          (i32.const 456)
        )
      )
    )
    (if
      (i32.const 102)
      (drop
        (select
          (unreachable)
          (i32.const 123)
          (i32.const 456)
        )
      )
    )
    (drop
      (i32.const 1337)
    )
  )
  (func $killer (type $1)
    (unreachable)
    (drop
      (i32.const 1000)
    )
  )
  (func $target (type $1)
    (drop
      (i32.const 2000)
    )
  )
)
