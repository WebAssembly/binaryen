(module
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
  ;; flipping of greater than/or equals ops, which are not in Souper IR
  (func $flips
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.ge_s (get_local $x) (get_local $y)))
    (set_local $x (i32.ge_u (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_s (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_u (get_local $x) (get_local $y)))
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
)
