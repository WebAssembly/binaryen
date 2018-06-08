(module
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (set_local $x (i32.const 1))
    (if (get_local $x) (nop))
    (if (get_local $x) (nop))
    (set_local $y (if (result i32) (i32.const 2) (i32.const 3) (i32.const 4)))
    (drop (get_local $y))
    (set_local $z (block (result i32) (i32.const 5)))
    (drop (get_local $z))
    (if (i32.const 6)
      (set_local $a (i32.const 7))
      (set_local $a (i32.const 8))
    )
    (drop (get_local $a))
    (block $val
      (if (i32.const 10)
        (block
          (set_local $b (i32.const 11))
          (br $val)
        )
      )
      (set_local $b (i32.const 12))
    )
    (drop (get_local $b))
  )
  (func $no-unreachable
    (local $x i32)
    (drop
      (tee_local $x
        (unreachable)
      )
    )
  )
  (func $implicit-trap-and-global-effects
    (local $var$0 i32)
    (set_local $var$0
     (i32.trunc_u/f64
      (f64.const -nan:0xfffffffffffc3) ;; this implicit trap will actually trap
     )
    )
    (f32.store align=1 ;; and if we move it across this store, the store will execute, having global side effects
     (i32.const 22)
     (f32.const 154)
    )
    (drop
     (get_local $var$0)
    )
  )
  (func $implicit-trap-and-local-effects
    (local $var$0 i32)
    (local $other i32)
    (set_local $var$0
     (i32.trunc_u/f64
      (f64.const -nan:0xfffffffffffc3) ;; this implicit trap will actually trap
     )
    )
    (set_local $other (i32.const 100)) ;; but it's fine to move it across a local effect, that vanishes anyhow
    (drop
     (get_local $var$0)
    )
    (if (i32.const 1)
     (drop
      (get_local $other)
     )
    )
  )
  (func $multi-pass-get-equivs-right (param $var$0 i32) (param $var$1 i32) (result f64)
   (local $var$2 i32)
   (set_local $var$2
    (get_local $var$0)
   )
   (i32.store
    (get_local $var$2)
    (i32.const 1)
   )
   (f64.promote/f32
    (f32.load
     (get_local $var$2)
    )
   )
  )
  (func $if-value-structure-equivalent (param $x i32) (result i32)
    (local $y i32)
    (if (i32.const 1)
      (set_local $x (i32.const 2))
      (block
        (set_local $y (get_local $x))
        (set_local $x (get_local $y))
      )
    )
    (get_local $x)
  )
)

