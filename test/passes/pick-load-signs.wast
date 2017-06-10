(module
  (func $a ;; load 8s, but use is 8u, so load should be signed
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
  )
  (func $b ;; load 16s, but use is 16u, so load should be signed
    (local $y i32)
    (set_local $y
      (i32.load16_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 65535)
      )
    )
  )
  (func $c ;; load 8u, keep
    (local $y i32)
    (set_local $y
      (i32.load8_u
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
  )
  (func $d ;; load 16u, keep
    (local $y i32)
    (set_local $y
      (i32.load16_u
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 65535)
      )
    )
  )
  (func $one-of-each ;; prefer the signed, potential code removal is bigger
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $more-of-one ;; prefer the signed even if 2x more unsigned
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $many-more-of-one ;; but not 3x
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $a-sign ;; load 8s, use is s, so keep
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $multivar
    (local $x i32)
    (local $y i32)
    (set_local $x
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $x)
        (i32.const 255)
      )
    )
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $corners
    (local $y i32)
    (drop
      (i32.load8_s ;; not sent into a set_local
        (i32.const 1024)
      )
    )
    (drop
      (i32.load8_u ;; not sent into a set_local
        (i32.const 1024)
      )
    )
    (set_local $y
      (i32.const 1024) ;; not a load
    )
  )
  (func $wrong-size ;; load 8s, but use is 16
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 65535)
      )
    )
  )
  (func $wrong-size_s ;; load 8s, but use is 16
    (local $y i32)
    (set_local $y
      (i32.load8_u
        (i32.const 1024)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (get_local $y)
          (i32.const 16)
        )
        (i32.const 16)
      )
    )
  )
  (func $non-sign-or-unsigned-use
    (local $y i32)
    (set_local $y
      (i32.load8_s
        (i32.const 1024)
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
    (drop
      (get_local $y)
    )
  )
  (func $toplevel-load (result i32)
    (i32.load8_s
      (i32.const 1024)
    )
  )
  (func $tees
    (local $y i32)
    (drop ;; a "use", so we can't alter the value
      (tee_local $y
        (i32.load8_s
          (i32.const 1024)
        )
      )
    )
    (drop
      (i32.and
        (get_local $y)
        (i32.const 255)
      )
    )
  )
)
