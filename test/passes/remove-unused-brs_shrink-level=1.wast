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
  (func $join-and-it-becomes-unreachable
   (block $label$1
    (block
     (br_if $label$1
      (i32.load8_u
       (i32.const -93487262)
      )
     )
     (br_if $label$1
      (loop $label$5 ;; this is unreachable (infinite loop, no exit)
       (br $label$5)
      )
     )
    )
   )
  )
  (func $br-if-unreachable-pair
   (local $x i32)
   (block $label$14
    (br_if $label$14
     (unreachable)
    )
    (br_if $label$14
     (local.get $x)
    )
   )
  )
  (func $br-if-unreachable-pair2
   (local $x i32)
   (block $label$14
    (br_if $label$14
     (local.get $x)
    )
    (br_if $label$14
     (unreachable)
    )
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
          (br_table $A $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $y $B $y
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
  (func $simple-switch-4 (result i32)
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
)
