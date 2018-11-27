(module
  (memory $0 (shared 1 1))
  ;; Figure 1a from the Souper paper https://arxiv.org/pdf/1711.04422.pdf
  (func $figure-1a (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (set_local $i
      (i64.eq
        (get_local $a)
        (get_local $x)
      )
    )
    (set_local $j
      (i64.ne
        (get_local $a)
        (get_local $y)
      )
    )
    (set_local $r
      (i32.and
        (get_local $i)
        (get_local $j)
      )
    )
    (return (get_local $r))
  )
  ;; Figure 1b, with a potential path condition
  (func $figure-1b (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (if
      (i64.lt_s
        (get_local $x)
        (get_local $y)
      )
      (block
        (set_local $i
          (i64.eq
            (get_local $a)
            (get_local $x)
          )
        )
        (set_local $j
          (i64.ne
            (get_local $a)
            (get_local $y)
          )
        )
        (set_local $r
          (i32.and
            (get_local $i)
            (get_local $j)
          )
        )
        (return (get_local $r))
      )
      (unreachable)
    )
  )
  ;; Figure 3, simplified to an if
  (func $figure-3-if (param $x i32) (result i32)
    (if
      (i32.and
        (get_local $x)
        (i32.const 1)
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (get_local $x)
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
    (set_local $x (i32.ge_s (get_local $x) (get_local $y)))
    (set_local $x (i32.ge_u (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_s (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_u (get_local $x) (get_local $y)))
    (call $send-i32 (i64.ge_s (get_local $z) (get_local $w)))
    (call $send-i32 (i64.ge_u (get_local $z) (get_local $w)))
    (call $send-i32 (i64.gt_s (get_local $z) (get_local $w)))
    (call $send-i32 (i64.gt_u (get_local $z) (get_local $w)))
  )
  (func $various-conditions-1 (param $x i32)
    (if
      (get_local $x)
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
    )
  )
  (func $various-conditions-2 (param $x i32)
    (if
      (i32.lt_s
        (get_local $x)
        (i32.const 0)
      )
      (set_local $x
        (i32.sub
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $various-conditions-3 (param $x i32)
    (if
      (i32.reinterpret/f32 (f32.const 0))
      (set_local $x
        (i32.sub
          (get_local $x)
          (i32.const 4)
        )
      )
    )
  )
  (func $various-conditions-4 (param $x i32)
    (if
      (unreachable)
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 3)
        )
      )
    )
  )
  (func $unaries (param $x i32) (param $y i32)
    (if
      (i32.eqz
        (get_local $x)
      )
      (set_local $x
        (i32.add
          (i32.ctz
            (get_local $y)
          )
          (i32.sub
            (i32.clz
              (get_local $x)
            )
            (i32.popcnt
              (get_local $y)
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
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $unary-condition-2 (param $x i32)
    (if
      (i32.eqz
        (i32.gt_u
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $if-else-cond (param $x i32) (result i32)
    (if
      (i32.lt_s
        (get_local $x)
        (i32.const 1)
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (get_local $x)
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
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 2))
    )
    (get_local $x)
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
          (get_local $x)
          (get_local $y)
        )
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
        (i32.add
          (i32.const 2)
          (get_local $y)
        )
      )
    )
  )
  (func $block-phi-1 (param $x i32) (param $y i32) (result i32)
    (block $out
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (br_if $out (get_local $y))
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (i32.add
      (get_local $x)
      (i32.const 3)
    )
  )
  (func $block-phi-2 (param $x i32) (param $y i32) (result i32)
    (block $out
      (set_local $x
        (i32.const 1)
      )
      (br_if $out (get_local $y))
      (set_local $x
        (i32.const 2)
      )
    )
    (i32.add
      (get_local $x)
      (i32.const 3)
    )
  )
  (func $zero_init-phi-bad_type (result f64)
    (local $x f64)
    (if
      (i32.const 0)
      (set_local $x
        (f64.const 1)
      )
    )
    (get_local $x)
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
        (get_local $x)
        (get_local $y)
      )
      (set_local $i
        (i32.eq
          (get_local $x)
          (get_local $y)
        )
      )
      (set_local $i
        (i32.add
          (get_local $x)
          (get_local $y)
        )
      )
    )
    (get_local $i)
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
      (get_local $x)
      (block
        (set_local $x
          (i32.const 1)
        )
        (return (get_local $x))
      )
      (set_local $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-2 (param $x i32) (param $y i32) (result i32)
    (if
      (get_local $x)
      (block
        (set_local $x
          (i32.const 1)
        )
        (unreachable)
      )
      (set_local $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-3 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br $out)
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-4 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br_table $out $out $out (i32.const 1))
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-br_if (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br_if $out
            (get_local $x)
          )
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; there *IS* a phi here since it was a br_if
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-big (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
   (block $label$1
    (block $label$2
     (block $label$3
      (if
       (get_local $2)
       (if
        (get_local $0)
        (block
         (set_local $1
          (i32.const -8531)
         )
         (br $label$3)
        )
        (block
         (set_local $1
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
     (get_local $1)
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
        (get_local $x)
        (set_local $x
          (i32.const 1)
        )
        (set_local $x
          (i32.const 2)
        )
      )
      (return
        (get_local $x)
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
       (tee_local $var$0
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
    (get_local $var$0)
    (i32.const 16)
   )
   (i32.const 1)
  )
  (func $deep (param $x i32) (result i32)
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (get_local $x)
  )
  (func $two-pcs (param $x i64) (param $y i64) (result i64)
    (param $t i64)
    (if
      (i64.lt_s
        (get_local $x)
        (get_local $y)
      )
      (if
        (i64.eqz
          (get_local $x)
        )
        (set_local $t
          (i64.add
            (get_local $x)
            (get_local $y)
          )
        )
        (set_local $t
          (i64.sub
            (get_local $x)
            (get_local $y)
          )
        )
      )
      (if
        (i64.eqz
          (get_local $y)
        )
        (set_local $t
          (i64.mul
            (get_local $x)
            (get_local $y)
          )
        )
        (set_local $t
          (i64.div_s
            (get_local $x)
            (get_local $y)
          )
        )
      )
    )
    (return (get_local $t))
  )
  (func $loop-1 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
    )
    ;; neither needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-2 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.add (get_local $y) (i32.const 4)))
    )
    ;; neither needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-3 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.add (get_local $y) (i32.const 4)))
      (br_if $loopy (get_local $y))
    )
    ;; both needed
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-4 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-5 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.const 2)) ;; same value
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-6 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (get_local $y)) ;; same value
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-7 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.const 5)) ;; different!
      (br_if $loopy (get_local $y))
    )
    ;; y changed but we don't need a phi for it
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-8 (param $x i32) (param $y i32) (result i32)
    (local $z i32)
    (local $w i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $z (get_local $x))
      (set_local $w (get_local $y))
      (set_local $x (i32.const 1)) ;; same!
      (set_local $y (i32.const 4)) ;; different!
      (br_if $loopy (get_local $y))
    )
    ;; x is always 3, and y needs a phi.
    ;; each is also copied to another local, which we need
    ;; to handle properly
    (return
      (i32.mul
        (i32.add
          (get_local $x)
          (get_local $y)
        )
        (i32.sub
          (get_local $z)
          (get_local $w)
        )
      )
    )
  )
  (func $loop-9 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $t (get_local $x))
      (set_local $x (get_local $y))
      (set_local $y (get_local $t))
      (br_if $loopy (get_local $t))
    )
    ;; x and y swapped, so both need phis
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-10 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 1))
    (loop $loopy ;; we swap the values. but we need a deeper analysis to figure that out...
      (set_local $t (get_local $x))
      (set_local $x (get_local $y))
      (set_local $y (get_local $t))
      (br_if $loopy (get_local $t))
    )
    ;; x and y swapped, but the same constant was swapped
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-multicond-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (set_local $x (i32.const 4))
      (br_if $loopy (get_local $t))
      (set_local $y (i32.const 5))
      (br_if $loopy (get_local $t))
      (set_local $z (i32.const 6))
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-multicond-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 4)))
      (br_if $loopy (get_local $t))
      (set_local $y (i32.add (get_local $y) (i32.const 5)))
      (br_if $loopy (get_local $t))
      (set_local $z (i32.add (get_local $z) (i32.const 6)))
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-block-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (block $out
        (set_local $x (i32.add (get_local $x) (i32.const 4)))
        (br_if $out (get_local $t))
        (set_local $y (i32.add (get_local $y) (i32.const 5)))
        (br_if $out (get_local $t))
        (set_local $z (i32.add (get_local $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-block-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (block $out
      (loop $loopy
        (set_local $x (i32.add (get_local $x) (i32.const 4)))
        (br_if $out (get_local $t))
        (set_local $y (i32.add (get_local $y) (i32.const 5)))
        (br_if $out (get_local $t))
        (set_local $z (i32.add (get_local $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $bad-phi-type (param $var$0 i64) (param $var$1 i64) (param $var$2 i32) (param $var$3 f32)
   (if
    (get_local $var$2)
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
       (get_local $var$2)
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
    (set_local $var$1
     (block $label$2 (result f64)
      (block $label$3
       (set_local $var$0
        (block $label$4 (result i32)
         (if
          (i32.const 1337)
          (unreachable)
         )
         (get_local $var$0)
        )
       )
       (loop $label$6
        (br_if $label$6
         (block $label$7 (result i32)
          (drop
           (br_if $label$7
            (get_local $var$0)
            (i32.const 65535)
           )
          )
          (drop
           (br_if $label$7
            (get_local $var$0)
            (i32.const 0)
           )
          )
          (unreachable)
         )
        )
       )
      )
      (get_local $var$1)
     )
    )
    (br $label$1)
   )
  )
  (func $phi-value-turns-bad (result f64)
   (local $var$0 i32)
   (local $var$1 i32)
   (local $var$2 f32)
   (set_local $var$2
    (if (result f32)
     (tee_local $var$0
      (i32.atomic.rmw16_u.sub offset=22
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
           (get_local $var$0)
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
    (set_local $temp (i32.add (get_local $x) (i32.const 1)))
    (i32.add (get_local $temp) (get_local $temp))
  )
  (func $multi-use-2 (param $x i32) (result i32)
    (local $temp i32)
    (set_local $temp (i32.add (get_local $x) (i32.const 1)))
    (set_local $x (i32.mul (get_local $temp) (i32.const 2)))
    (i32.sub (get_local $x) (get_local $temp))
  )
  (func $many-single-uses-with-param (param $x i32) (result i32)
    (return
      (i32.eqz
        (i32.add
          (i32.mul
            (i32.const 10)
            (get_local $x)
          )
          (i32.sub
            (i32.ctz
              (get_local $x)
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
   (tee_local $var$0
    (i32.add
     (get_local $var$0)
     (i32.const -7)
    )
   )
   (block $label$2
    (block $label$3
     (set_local $var$1
      (get_local $var$0)
     )
     (br_if $label$3
      (tee_local $var$3
       (i32.const 12)
      )
     )
     (unreachable)
    )
    (br_if $label$2
     (i32.eqz
      (get_local $var$1)
     )
    )
    (if
     (i32.ne
      (i32.load
       (i32.const 0)
      )
      (get_local $var$0)
     )
     (unreachable)
    )
    (unreachable)
   )
  )
 )
 (func $multiple-uses-to-non-expression (param $x i32)
  (local $temp i32)
  (set_local $x
   (i32.add
    (get_local $x)
    (i32.const 10)
   )
  )
  (i32.store
   (i32.const 1)
   (get_local $x) ;; x+10 has two uses!
  )
  (i32.store
   (i32.const 2)
   (i32.add
    (get_local $x)
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
           (get_local $var$0)
          )
         )
         (set_local $var$1
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
      (tee_local $var$2
       (i32.const 1)
      )
     )
    )
   )
   (block $label$9
    (br_if $label$9
     (i32.or
      (i32.const 1)
      (get_local $var$1)
     )
    )
   )
   (unreachable)
  )
  (i32.store offset=176
   (i32.const 0)
   (get_local $var$2)
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
     (set_local $temp
      (i32.eqz
       (i32.load
        (i32.const -16)
       )
      )
     )
     (drop
      (get_local $temp)
     )
     (get_local $temp)
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
   (set_local $var$1
    (i32.const 2)
   )
  )
  (if
   (i32.gt_s
    (i32.const 3)
    (i32.add
     (get_local $var$1)
     (i32.const 4)
    )
   )
   (unreachable)
  )
  (i32.const 5)
 )
 (func $non-expr-nodes-may-have-multiple-uses-too-its-the-ORIGIN (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (result i32)
  (i32.store
   (tee_local $var$1
    (i32.gt_u
     (get_local $var$1)
     (i32.const 1)
    )
   )
   (i32.const 2)
  )
  (i32.store offset=8
   (i32.const 3)
   (i32.sub
    (i32.const 4)
    (get_local $var$1)
   )
  )
  (unreachable)
 )
 (func $loop-of-set-connections (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (param $var$3 i32) (param $var$4 i32) (result i32)
  (loop $label$1
   (if
    (i32.const 0)
    (block
     (set_local $var$2
      (i32.add
       (i32.const 0)
       (i32.const 1)
      )
     )
     (br $label$1)
    )
   )
   (set_local $var$3
    (get_local $var$2)
   )
   (set_local $var$2
    (get_local $var$3)
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
  (set_local $var$1
   (i32.const 1)
  )
  (if
   (i32.const 0)
   (loop $label$2
    (if
     (get_local $var$1)
     (nop)
    )
    (set_local $var$1
     (i32.sub
      (i32.const 0)
      (tee_local $var$3
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
   (get_local $var$1)
   (set_local $var$3
    (i32.const 1)
   )
  )
  (i32.store
   (i32.const 8)
   (i32.add
    (get_local $var$3)
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
