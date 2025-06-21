(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (type $1 (func))
  (type $2 (func (result i32)))
  (func $b14 (type $2)
    (drop
      (if (result i32) ;; with shrinking, this can become a select
        (i32.const 1)
        (then
          (block $block1 (result i32)
            (i32.const 12)
          )
        )
        (else
          (block $block3 (result i32)
            (i32.const 27)
          )
        )
      )
    )
    (drop
      (if (result i32)
        (i32.const 1)
        (then
          (i32.load (i32.const 10)) ;; load may have side effects, unless ignored
        )
        (else
          (i32.const 27)
        )
      )
    )
    (drop
      (if (result i32)
        (i32.const 1)
        (then
          (i32.rem_s (i32.const 11) (i32.const 12)) ;; rem may have side effects, unless ignored
        )
        (else
          (i32.const 27)
        )
      )
    )
    (drop
      (if (result i32)
        (i32.const 1)
        (then
          (i32.trunc_f64_u (f64.const 12.34)) ;; float to int may have side effects, unless ignored
        )
        (else
          (i32.const 27)
        )
      )
    )
    (i32.const 0)
  )
  (func $join-br_ifs
    (local $x i32)
    (block $out
      (br_if $out (local.get $x))
      (br_if $out (local.get $x))
      (br_if $out (local.get $x))
    )
    (block $out2
      (block $out3
        (br_if $out2 (local.get $x))
        (br_if $out3 (local.get $x))
        (br_if $out2 (local.get $x))
      )
      (unreachable)
    )
    (block $out4
      (block $out5
        (br_if $out4 (local.get $x))
        (br_if $out5 (local.get $x))
        (br_if $out5 (local.get $x))
      )
      (unreachable)
    )
    (block $out6
      (block $out7
        (br_if $out6 (local.get $x))
        (br_if $out6 (local.get $x))
        (br_if $out7 (local.get $x))
      )
      (unreachable)
    )
    (block $out8
      (br_if $out8 (call $b14)) ;; side effect
      (br_if $out8 (local.get $x))
    )
    (block $out8
      (br_if $out8 (local.get $x))
      (br_if $out8 (call $b14)) ;; side effect
    )
  )
)

