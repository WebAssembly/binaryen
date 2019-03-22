(module
  (global $global$0 (mut i32) (i32.const 1))
  (func $basics (param $x i32)
    (local $y i32)
    (local $z f32)
    (local $w i64)
    (local $t f64)
    (drop (local.get $x)) ;; keep as param get
    (drop (local.get $y)) ;; turn into get of 0-init
    (drop (local.get $z))
    (drop (local.get $w))
    (drop (local.get $t))
    (local.set $x (i32.const 100)) ;; overwrite param
    (drop (local.get $x)) ;; no longer a param!
    (local.set $t (f64.const 2)) ;; overwrite local
    (drop (local.get $t))
    (local.set $t (f64.const 33)) ;; overwrite local AGAIN
    (drop (local.get $t))
    (drop (local.get $t)) ;; use twice
  )
  (func $if (param $p i32)
    (local $x i32)
    (local $y i32)
    (drop
      (if i32
        (i32.const 1)
        (local.get $x)
        (local.get $y)
      )
    )
    (if
      (i32.const 1)
      (local.set $x (i32.const 1))
    )
    (drop (local.get $x))
    ;; same but with param
    (if
      (i32.const 1)
      (local.set $p (i32.const 1))
    )
    (drop (local.get $p))
    ;; if-else
    (if
      (i32.const 1)
      (local.set $x (i32.const 2))
      (nop)
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (nop)
      (local.set $x (i32.const 3))
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (local.set $x (i32.const 4))
      (local.set $x (i32.const 5))
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (local.set $x (i32.const 6))
      (block
        (local.set $x (i32.const 7))
        (local.set $x (i32.const 8))
      )
    )
    (drop (local.get $x))
  )
  (func $if2 (param $x i32)
    (if
      (i32.const 1)
      (block
        (local.set $x (i32.const 1))
        (drop (local.get $x)) ;; use between phi set and use
      )
    )
    (drop (local.get $x))
  )
  (func $nomerge (param $p i32) (param $q i32)
    (local $x i32)
    (local.set $x (i32.const 1)) ;; untangle this
    (call $nomerge (local.get $x) (local.get $x))
    (local.set $x (i32.const 2)) ;; and this
    (call $nomerge (local.get $x) (local.get $x))
    (local.set $x (i32.const 3)) ;; but this reaches a merge later
    (call $nomerge (local.get $x) (local.get $x))
    (if (i32.const 1)
      (local.set $x (i32.const 4))
    )
    (call $nomerge (local.get $x) (local.get $x))
    (local.set $x (i32.const 5)) ;; this is good again
    (call $nomerge (local.get $x) (local.get $x))
    (if (i32.const 1)
      (local.set $x (i32.const 6)) ;; these merge,
      (local.set $x (i32.const 7)) ;; so no
    )
    (call $nomerge (local.get $x) (local.get $x))
  )
)

