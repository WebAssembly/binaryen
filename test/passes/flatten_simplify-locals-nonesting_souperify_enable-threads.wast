(module
  (memory $0 (shared 1 1))
  ;; Figure 1a from the Souper paper https://arxiv.org/pdf/1711.04422.pdf
  (func $figure-1a (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (local.set $i
      (i64.eq
        (local.get $a)
        (local.get $x)
      )
    )
    (local.set $j
      (i64.ne
        (local.get $a)
        (local.get $y)
      )
    )
    (local.set $r
      (i32.and
        (local.get $i)
        (local.get $j)
      )
    )
    (return (local.get $r))
  )
  ;; Figure 1b, with a potential path condition
  (func $figure-1b (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (if
      (i64.lt_s
        (local.get $x)
        (local.get $y)
      )
      (block
        (local.set $i
          (i64.eq
            (local.get $a)
            (local.get $x)
          )
        )
        (local.set $j
          (i64.ne
            (local.get $a)
            (local.get $y)
          )
        )
        (local.set $r
          (i32.and
            (local.get $i)
            (local.get $j)
          )
        )
        (return (local.get $r))
      )
      (unreachable)
    )
  )
  ;; Figure 3, simplified to an if
  (func $figure-3-if (param $x i32) (result i32)
    (if
      (i32.and
        (local.get $x)
        (i32.const 1)
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (local.get $x)
        (i32.const 1)
      )
    )
  )
  (func $send-i32 (param i32))
  ;; flipping of greater than/or equals ops, which are not in Souper IR
  (func $flips
    (local $x i32)
    (local $y i32)
    (local $z i64)
    (local $w i64)
    (local.set $x (i32.ge_s (local.get $x) (local.get $y)))
    (local.set $x (i32.ge_u (local.get $x) (local.get $y)))
    (local.set $x (i32.gt_s (local.get $x) (local.get $y)))
    (local.set $x (i32.gt_u (local.get $x) (local.get $y)))
    (call $send-i32 (i64.ge_s (local.get $z) (local.get $w)))
    (call $send-i32 (i64.ge_u (local.get $z) (local.get $w)))
    (call $send-i32 (i64.gt_s (local.get $z) (local.get $w)))
    (call $send-i32 (i64.gt_u (local.get $z) (local.get $w)))
  )
  (func $various-conditions-1 (param $x i32)
    (if
      (local.get $x)
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
    )
  )
  (func $various-conditions-2 (param $x i32)
    (if
      (i32.lt_s
        (local.get $x)
        (i32.const 0)
      )
      (local.set $x
        (i32.sub
          (local.get $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $various-conditions-3 (param $x i32)
    (if
      (i32.reinterpret_f32 (f32.const 0))
      (local.set $x
        (i32.sub
          (local.get $x)
          (i32.const 4)
        )
      )
    )
  )
  (func $various-conditions-4 (param $x i32)
    (if
      (unreachable)
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 3)
        )
      )
    )
  )
  (func $unaries (param $x i32) (param $y i32)
    (if
      (i32.eqz
        (local.get $x)
      )
      (local.set $x
        (i32.add
          (i32.ctz
            (local.get $y)
          )
          (i32.sub
            (i32.clz
              (local.get $x)
            )
            (i32.popcnt
              (local.get $y)
            )
          )
        )
      )
    )
  )
  (func $unary-condition (param $x i32)
    (if
      (i32.ctz
        (i32.gt_u
          (local.get $x)
          (i32.const 1)
        )
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $unary-condition-2 (param $x i32)
    (if
      (i32.eqz
        (i32.gt_u
          (local.get $x)
          (i32.const 1)
        )
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $if-else-cond (param $x i32) (result i32)
    (if
      (i32.lt_s
        (local.get $x)
        (i32.const 1)
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (local.get $x)
        (i32.const 1)
      )
    )
  )
  (func $trivial-ret (result i32)
    (i32.add
      (i32.const 0)
      (i32.const 1)
    )
  )
  (func $trivial-const (result i32)
    (i32.const 0)
  )
  (func $trivial-const-block (result i32)
    (nop)
    (i32.const 0)
  )
  (func $bad-phi-value (result i32)
    (if (result i32)
      (if (result i32)
        (i32.const 1)
        (i32.load
          (i32.const 0)
        )
        (i32.const 0)
      )
      (i32.const 0)
      (i32.const 1)
    )
  )
  (func $bad-phi-value-2 (param $x i32) (result i32)
    (if
      (if (result i32)
        (i32.const 1)
        (i32.load
          (i32.const 0)
        )
        (i32.const 0)
      )
      (local.set $x (i32.const 1))
      (local.set $x (i32.const 2))
    )
    (local.get $x)
  )
  (func $select (param $x i32) (result i32)
    (return
      (select
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
      )
    )
  )
  (func $select-2 (param $x i32) (param $y i32) (result i32)
    (return
      (select
        (i32.add
          (local.get $x)
          (local.get $y)
        )
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
        (i32.add
          (i32.const 2)
          (local.get $y)
        )
      )
    )
  )
  (func $block-phi-1 (param $x i32) (param $y i32) (result i32)
    (block $out
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
      (br_if $out (local.get $y))
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 2)
        )
      )
    )
    (i32.add
      (local.get $x)
      (i32.const 3)
    )
  )
  (func $block-phi-2 (param $x i32) (param $y i32) (result i32)
    (block $out
      (local.set $x
        (i32.const 1)
      )
      (br_if $out (local.get $y))
      (local.set $x
        (i32.const 2)
      )
    )
    (i32.add
      (local.get $x)
      (i32.const 3)
    )
  )
  (func $zero_init-phi-bad_type (result f64)
    (local $x f64)
    (if
      (i32.const 0)
      (local.set $x
        (f64.const 1)
      )
    )
    (local.get $x)
  )
  (func $phi-bad-type  (result f64)
    (block $label$1 (result f64)
      (if (result f64)
        (i32.const 0)
        (f64.const 0)
        (f64.const 1)
      )
    )
  )
  (func $phi-one-side-i1 (param $x i32) (param $y i32) (result i32)
    (local $i i32)
    (if
      (i32.le_s
        (local.get $x)
        (local.get $y)
      )
      (local.set $i
        (i32.eq
          (local.get $x)
          (local.get $y)
        )
      )
      (local.set $i
        (i32.add
          (local.get $x)
          (local.get $y)
        )
      )
    )
    (local.get $i)
  )
  (func $call (result i32)
    (return
      (i32.mul
        (i32.add
          (call $call)
          (call $call)
        )
        (i32.add
          (i32.const 10)
          (call $call)
        )
      )
    )
  )
  (func $in-unreachable-1 (param $x i32) (param $y i32) (result i32)
    (if
      (local.get $x)
      (block
        (local.set $x
          (i32.const 1)
        )
        (return (local.get $x))
      )
      (local.set $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (local.get $x)
    )
  )
  (func $in-unreachable-2 (param $x i32) (param $y i32) (result i32)
    (if
      (local.get $x)
      (block
        (local.set $x
          (i32.const 1)
        )
        (unreachable)
      )
      (local.set $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (local.get $x)
    )
  )
  (func $in-unreachable-3 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (local.get $x)
        (block
          (local.set $x
            (i32.const 1)
          )
          (br $out)
        )
        (local.set $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (local.get $x)
      )
    )
    (return
      (local.get $x)
    )
  )
  (func $in-unreachable-4 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (local.get $x)
        (block
          (local.set $x
            (i32.const 1)
          )
          (br_table $out $out $out (i32.const 1))
        )
        (local.set $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (local.get $x)
      )
    )
    (return
      (local.get $x)
    )
  )
  (func $in-unreachable-br_if (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (local.get $x)
        (block
          (local.set $x
            (i32.const 1)
          )
          (br_if $out
            (local.get $x)
          )
        )
        (local.set $x
          (i32.const 2)
        )
      )
      ;; there *IS* a phi here since it was a br_if
      (return
        (local.get $x)
      )
    )
    (return
      (local.get $x)
    )
  )
  (func $in-unreachable-big (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
   (block $label$1
    (block $label$2
     (block $label$3
      (if
       (local.get $2)
       (if
        (local.get $0)
        (block
         (local.set $1
          (i32.const -8531)
         )
         (br $label$3)
        )
        (block
         (local.set $1
          (i32.const -8531)
         )
         (br $label$1)
        )
       )
      )
      (br $label$2)
     )
     (drop
      (i32.load
       (i32.const 0)
      )
     )
     (br $label$1)
    )
    (i32.store16
     (i32.const 1)
     (local.get $1)
    )
    (unreachable)
   )
   (i32.store16
    (i32.const 0)
    (i32.const -8531)
   )
  )
  (func $in-unreachable-operations (param $x i32) (param $y i32) (result i32)
    (block
      (unreachable)
      (if
        (local.get $x)
        (local.set $x
          (i32.const 1)
        )
        (local.set $x
          (i32.const 2)
        )
      )
      (return
        (local.get $x)
      )
    )
  )
  (func $merge-with-one-less (param $var$0 i32) (result i32)
   (block $label$1
    (block $label$2
     (block $label$3
      (block $label$4
       (block $label$5
        (br_table $label$5 $label$4 $label$3 $label$2
         (i32.load
          (i32.const 1)
         )
        )
       )
       (unreachable)
      )
      (br $label$1)
     )
     (f64.store
      (i32.load
       (local.tee $var$0
        (i32.const 8)
       )
      )
      (f64.const 0)
     )
     (br $label$1)
    )
    (unreachable)
   )
   (i32.store
    (local.get $var$0)
    (i32.const 16)
   )
   (i32.const 1)
  )
  (func $deep (param $x i32) (result i32)
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.set $x (i32.xor (local.get $x) (i32.const 1234)))
    (local.set $x (i32.mul (local.get $x) (i32.const 1234)))
    (local.get $x)
  )
  (func $two-pcs (param $x i64) (param $y i64) (param $t i64) (result i64)
    (if
      (i64.lt_s
        (local.get $x)
        (local.get $y)
      )
      (if
        (i64.eqz
          (local.get $x)
        )
        (local.set $t
          (i64.add
            (local.get $x)
            (local.get $y)
          )
        )
        (local.set $t
          (i64.sub
            (local.get $x)
            (local.get $y)
          )
        )
      )
      (if
        (i64.eqz
          (local.get $y)
        )
        (local.set $t
          (i64.mul
            (local.get $x)
            (local.get $y)
          )
        )
        (local.set $t
          (i64.div_s
            (local.get $x)
            (local.get $y)
          )
        )
      )
    )
    (return (local.get $t))
  )
  (func $loop-1 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
    )
    ;; neither needed a phi
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-2 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (local.set $y (i32.add (local.get $y) (i32.const 4)))
    )
    ;; neither needed a phi
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-3 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (local.set $y (i32.add (local.get $y) (i32.const 4)))
      (br_if $loopy (local.get $y))
    )
    ;; both needed
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-4 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (br_if $loopy (local.get $y))
    )
    ;; only x needed a phi
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-5 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (local.set $y (i32.const 2)) ;; same value
      (br_if $loopy (local.get $y))
    )
    ;; only x needed a phi
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-6 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (local.set $y (local.get $y)) ;; same value
      (br_if $loopy (local.get $y))
    )
    ;; only x needed a phi
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-7 (param $x i32) (param $y i32) (result i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 3)))
      (local.set $y (i32.const 5)) ;; different!
      (br_if $loopy (local.get $y))
    )
    ;; y changed but we don't need a phi for it
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-8 (param $x i32) (param $y i32) (result i32)
    (local $z i32)
    (local $w i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $z (local.get $x))
      (local.set $w (local.get $y))
      (local.set $x (i32.const 1)) ;; same!
      (local.set $y (i32.const 4)) ;; different!
      (br_if $loopy (local.get $y))
    )
    ;; x is always 3, and y needs a phi.
    ;; each is also copied to another local, which we need
    ;; to handle properly
    (return
      (i32.mul
        (i32.add
          (local.get $x)
          (local.get $y)
        )
        (i32.sub
          (local.get $z)
          (local.get $w)
        )
      )
    )
  )
  (func $loop-9 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (loop $loopy
      (local.set $t (local.get $x))
      (local.set $x (local.get $y))
      (local.set $y (local.get $t))
      (br_if $loopy (local.get $t))
    )
    ;; x and y swapped, so both need phis
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-10 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 1))
    (loop $loopy ;; we swap the values. but we need a deeper analysis to figure that out...
      (local.set $t (local.get $x))
      (local.set $x (local.get $y))
      (local.set $y (local.get $t))
      (br_if $loopy (local.get $t))
    )
    ;; x and y swapped, but the same constant was swapped
    (return (i32.add (local.get $x) (local.get $y)))
  )
  (func $loop-multicond-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (local.set $z (i32.const 3))
    (loop $loopy
      (local.set $x (i32.const 4))
      (br_if $loopy (local.get $t))
      (local.set $y (i32.const 5))
      (br_if $loopy (local.get $t))
      (local.set $z (i32.const 6))
    )
    (return (select (local.get $x) (local.get $y) (local.get $z)))
  )
  (func $loop-multicond-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (local.set $z (i32.const 3))
    (loop $loopy
      (local.set $x (i32.add (local.get $x) (i32.const 4)))
      (br_if $loopy (local.get $t))
      (local.set $y (i32.add (local.get $y) (i32.const 5)))
      (br_if $loopy (local.get $t))
      (local.set $z (i32.add (local.get $z) (i32.const 6)))
    )
    (return (select (local.get $x) (local.get $y) (local.get $z)))
  )
  (func $loop-block-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (local.set $z (i32.const 3))
    (loop $loopy
      (block $out
        (local.set $x (i32.add (local.get $x) (i32.const 4)))
        (br_if $out (local.get $t))
        (local.set $y (i32.add (local.get $y) (i32.const 5)))
        (br_if $out (local.get $t))
        (local.set $z (i32.add (local.get $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (local.get $x) (local.get $y) (local.get $z)))
  )
  (func $loop-block-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (local.set $z (i32.const 3))
    (block $out
      (loop $loopy
        (local.set $x (i32.add (local.get $x) (i32.const 4)))
        (br_if $out (local.get $t))
        (local.set $y (i32.add (local.get $y) (i32.const 5)))
        (br_if $out (local.get $t))
        (local.set $z (i32.add (local.get $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (local.get $x) (local.get $y) (local.get $z)))
  )
  (func $bad-phi-type (param $var$0 i64) (param $var$1 i64) (param $var$2 i32) (param $var$3 f32)
   (if
    (local.get $var$2)
    (drop
     (loop $label$2 (result f64)
      (if
       (block $label$3 (result i32)
        (if
         (i32.const 0)
         (unreachable)
        )
        (nop)
        (i32.const 0)
       )
       (unreachable)
      )
      (br_if $label$2
       (local.get $var$2)
      )
      (f64.const 0)
     )
    )
   )
  )
  (func $loop-unreachable
   (local $var$0 i32)
   (local $var$1 f64)
   (loop $label$1
    (local.set $var$1
     (block $label$2 (result f64)
      (block $label$3
       (local.set $var$0
        (block $label$4 (result i32)
         (if
          (i32.const 1337)
          (unreachable)
         )
         (local.get $var$0)
        )
       )
       (loop $label$6
        (br_if $label$6
         (block $label$7 (result i32)
          (drop
           (br_if $label$7
            (local.get $var$0)
            (i32.const 65535)
           )
          )
          (drop
           (br_if $label$7
            (local.get $var$0)
            (i32.const 0)
           )
          )
          (unreachable)
         )
        )
       )
      )
      (local.get $var$1)
     )
    )
    (br $label$1)
   )
  )
  (func $phi-value-turns-bad (result f64)
   (local $var$0 i32)
   (local $var$1 i32)
   (local $var$2 f32)
   (local.set $var$2
    (if (result f32)
     (local.tee $var$0
      (i32.atomic.rmw16.sub_u offset=22
       (i32.const 0)
       (i32.const 0)
      )
     )
     (unreachable)
     (block (result f32)
      (if
       (loop $label$3 (result i32)
        (block $label$4 (result i32)
         (i32.clz
          (br_if $label$4
           (local.get $var$0)
           (i32.const 1)
          )
         )
        )
       )
       (nop)
      )
      (f32.const 1)
     )
    )
   )
   (unreachable)
  )
  (func $multi-use (param $x i32) (result i32)
    (local $temp i32)
    (local.set $temp (i32.add (local.get $x) (i32.const 1)))
    (i32.add (local.get $temp) (local.get $temp))
  )
  (func $multi-use-2 (param $x i32) (result i32)
    (local $temp i32)
    (local.set $temp (i32.add (local.get $x) (i32.const 1)))
    (local.set $x (i32.mul (local.get $temp) (i32.const 2)))
    (i32.sub (local.get $x) (local.get $temp))
  )
  (func $many-single-uses-with-param (param $x i32) (result i32)
    (return
      (i32.eqz
        (i32.add
          (i32.mul
            (i32.const 10)
            (local.get $x)
          )
          (i32.sub
            (i32.ctz
              (local.get $x)
            )
            (i32.const 20)
          )
        )
      )
    )
  )
 (func "replaced-print-internal" (param $var$0 i32)
  (local $var$1 i32)
  (local $var$2 i32)
  (local $var$3 i32)
  (if
   (local.tee $var$0
    (i32.add
     (local.get $var$0)
     (i32.const -7)
    )
   )
   (block $label$2
    (block $label$3
     (local.set $var$1
      (local.get $var$0)
     )
     (br_if $label$3
      (local.tee $var$3
       (i32.const 12)
      )
     )
     (unreachable)
    )
    (br_if $label$2
     (i32.eqz
      (local.get $var$1)
     )
    )
    (if
     (i32.ne
      (i32.load
       (i32.const 0)
      )
      (local.get $var$0)
     )
     (unreachable)
    )
    (unreachable)
   )
  )
 )
 (func $multiple-uses-to-non-expression (param $x i32)
  (local $temp i32)
  (local.set $x
   (i32.add
    (local.get $x)
    (i32.const 10)
   )
  )
  (i32.store
   (i32.const 1)
   (local.get $x) ;; x+10 has two uses!
  )
  (i32.store
   (i32.const 2)
   (i32.add
    (local.get $x)
    (i32.const 20)
   )
  )
 )
 (func $nested-phi-forwarding (param $var$0 i32) (result i32)
  (local $var$1 i32)
  (local $var$2 i32)
  (block $label$1
   (block $label$2
    (loop $label$3
     (block $label$4
      (block $label$5
       (block $label$6
        (block $label$7
         (block $label$8
          (br_table $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$8 $label$2 $label$2 $label$2 $label$6 $label$2 $label$2 $label$7 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$2 $label$5 $label$4
           (local.get $var$0)
          )
         )
         (local.set $var$1
          (i32.const 1)
         )
        )
        (br $label$4)
       )
       (unreachable)
      )
      (br $label$1)
     )
     (br_if $label$3
      (local.tee $var$2
       (i32.const 1)
      )
     )
    )
   )
   (block $label$9
    (br_if $label$9
     (i32.or
      (i32.const 1)
      (local.get $var$1)
     )
    )
   )
   (unreachable)
  )
  (i32.store offset=176
   (i32.const 0)
   (local.get $var$2)
  )
  (i32.const 0)
 )
 (func $zext-numGets (param $var$0 i32) (param $var$1 i32)
  (if
   (i32.ctz
    (block $label$1 (result i32)
     (drop
      (br_if $label$1
       (i32.const 1)
       (i32.load
        (i32.const -8)
       )
      )
     )
     (i32.eqz
      (i32.load
       (i32.const -16)
      )
     )
    )
   )
   (unreachable)
  )
 )
 (func $zext-numGets-hasAnotherUse (param $var$0 i32) (param $var$1 i32)
  (local $temp i32)
  (if
   (i32.ctz
    (block $label$1 (result i32)
     (drop
      (br_if $label$1
       (i32.const 1)
       (i32.load
        (i32.const -8)
       )
      )
     )
     (local.set $temp
      (i32.eqz
       (i32.load
        (i32.const -16)
       )
      )
     )
     (drop
      (local.get $temp)
     )
     (local.get $temp)
    )
   )
   (unreachable)
  )
 )
 (func $flipped-needs-right-origin (param $var$0 i32) (result i32)
  (local $var$1 i32)
  (block $label$1
   (br_if $label$1
    (i32.load
     (i32.const 1)
    )
   )
   (local.set $var$1
    (i32.const 2)
   )
  )
  (if
   (i32.gt_s
    (i32.const 3)
    (i32.add
     (local.get $var$1)
     (i32.const 4)
    )
   )
   (unreachable)
  )
  (i32.const 5)
 )
 (func $non-expr-nodes-may-have-multiple-uses-too-its-the-ORIGIN (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (result i32)
  (i32.store
   (local.tee $var$1
    (i32.gt_u
     (local.get $var$1)
     (i32.const 1)
    )
   )
   (i32.const 2)
  )
  (i32.store offset=8
   (i32.const 3)
   (i32.sub
    (i32.const 4)
    (local.get $var$1)
   )
  )
  (unreachable)
 )
 (func $loop-of-set-connections (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (param $var$3 i32) (param $var$4 i32) (result i32)
  (loop $label$1
   (if
    (i32.const 0)
    (block
     (local.set $var$2
      (i32.add
       (i32.const 0)
       (i32.const 1)
      )
     )
     (br $label$1)
    )
   )
   (local.set $var$3
    (local.get $var$2)
   )
   (local.set $var$2
    (local.get $var$3)
   )
   (br $label$1)
  )
 )
 (func $conditions-in-conditions (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (result i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i32)
  (local $var$6 i32)
  (local $var$7 i32)
  (local $var$8 i32)
  (local.set $var$1
   (i32.const 1)
  )
  (if
   (i32.const 0)
   (loop $label$2
    (if
     (local.get $var$1)
     (nop)
    )
    (local.set $var$1
     (i32.sub
      (i32.const 0)
      (local.tee $var$3
       (i32.const 1)
      )
     )
    )
    (br_if $label$2
     (i32.const 0)
    )
   )
  )
  (if
   (local.get $var$1)
   (local.set $var$3
    (i32.const 1)
   )
  )
  (i32.store
   (i32.const 8)
   (i32.add
    (local.get $var$3)
    (i32.const 16)
   )
  )
  (i32.store
   (i32.const 8)
   (i32.const 64)
  )
  (unreachable)
 )
)
