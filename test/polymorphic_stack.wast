(module
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (import "env" "table" (table 9 9 anyfunc))
  (func $break-and-binary (result i32)
    (block $x (result i32)
      (f32.add
        (br_if $x
          (i32.trunc_u/f64
            (unreachable)
          )
          (i32.trunc_u/f64
            (unreachable)
          )
        )
        (f32.const 1)
      )
    )
  )
  (func $call-and-unary (param i32) (result i32)
    (drop
      (i64.eqz
        (call $call-and-unary
          (unreachable)
        )
      )
    )
    (drop
      (i64.eqz
        (i32.eqz
          (unreachable)
        )
      )
    )
    (drop
      (i64.eqz
        (call_indirect (type $FUNCSIG$ii)
          (unreachable)
          (unreachable)
        )
      )
    )
  )
  (func $tee (param $x i32)
    (local $y f32)
    (drop
      (i64.eqz
        (tee_local $x
          (unreachable)
        )
      )
    )
    (drop
      (tee_local $y
        (i64.eqz
          (unreachable)
        )
      )
    )
  )
  (func $tee2
    (local $0 f32)
    (if
      (i32.const 259)
      (set_local $0
        (unreachable)
      )
    )
  )
  (func $select
    (drop
      (i64.eqz
        (select
          (unreachable)
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
  )
  (func $untaken-break-should-have-value (result i32)
    (block $x (result i32)
      (block
        (br_if $x
          (i32.const 0)
          (unreachable)
        )
      )
    )
  )
  (func $unreachable-in-block-but-code-before (param $0 i32) (result i32)
   (if
    (get_local $0)
    (return
     (i32.const 127)
    )
   )
   (block $label$0 (result i32)
    (br_if $label$0
     (i32.const 0)
     (return
      (i32.const -32)
     )
    )
   )
  )
  (func $br_table_unreachable_to_also_unreachable (result i32)
    (block $a (result i32)
      (block $b (result i32)
        (br_table $a $b ;; seems to send a value, but is not taken
          (unreachable)
          (unreachable)
        )
      )
    )
  )
  (func $untaken-br_if (result i32)
    (block $label$8 (result i32)
     (block $label$9
      (drop
       (if
        (i32.const 0)
        (br_if $label$8
         (unreachable)
         (i32.const 0)
        )
        (unreachable)
       )
      )
     )
    )
  )
)

