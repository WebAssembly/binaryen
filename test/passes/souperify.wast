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
    (return (get_local $r)) ;; a returned value is what we will try to infer
  )
)
(module
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
      (unreachable) ;; this means "we don't care about this path"
    )
  )
)
