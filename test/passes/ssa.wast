(module
  (func $basics (param $x i32)
    (local $y i32)
    (local $z f32)
    (local $w i64)
    (local $t f64)
    (drop (get_local $x)) ;; keep as param get
    (drop (get_local $y)) ;; turn into get of 0-init
    (drop (get_local $z))
    (drop (get_local $w))
    (drop (get_local $t))
    (set_local $x (i32.const 100)) ;; overwrite param
    (drop (get_local $x)) ;; no longer a param!
    (set_local $t (f64.const 2)) ;; overwrite local
    (drop (get_local $t))
    (set_local $t (f64.const 33)) ;; overwrite local AGAIN
    (drop (get_local $t))
    (drop (get_local $t)) ;; use twice
  )
  (func $if (param $p i32)
    (local $x i32)
    (local $y i32)
    (drop
      (if i32
        (i32.const 1)
        (get_local $x)
        (get_local $y)
      )
    )
    (if
      (i32.const 1)
      (set_local $x (i32.const 1))
    )
    (drop (get_local $x))
    ;; same but with param
    (if
      (i32.const 1)
      (set_local $p (i32.const 1))
    )
    (drop (get_local $p))
    ;; if-else
    (if
      (i32.const 1)
      (set_local $x (i32.const 2))
      (nop)
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (nop)
      (set_local $x (i32.const 3))
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (set_local $x (i32.const 4))
      (set_local $x (i32.const 5))
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (set_local $x (i32.const 6))
      (block
        (set_local $x (i32.const 7))
        (set_local $x (i32.const 8))
      )
    )
    (drop (get_local $x))
  )
  (func $if2 (param $x i32)
    (if
      (i32.const 1)
      (block
        (set_local $x (i32.const 1))
        (drop (get_local $x)) ;; use between phi set and use
      )
    )
    (drop (get_local $x))
  )
  (func $block (param $x i32)
    (block $out
      (br_if $out (i32.const 2))
      (set_local $x (i32.const 1))
    )
    (drop (get_local $x))
  )
)

