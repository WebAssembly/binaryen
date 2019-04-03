(module
  (memory 1)
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (local.set $x (i32.const 1))
    (if (local.get $x) (nop))
    (if (local.get $x) (nop))
    (local.set $y (if (result i32) (i32.const 2) (i32.const 3) (i32.const 4)))
    (drop (local.get $y))
    (local.set $z (block (result i32) (i32.const 5)))
    (drop (local.get $z))
    (if (i32.const 6)
      (local.set $a (i32.const 7))
      (local.set $a (i32.const 8))
    )
    (drop (local.get $a))
    (block $val
      (if (i32.const 10)
        (block
          (local.set $b (i32.const 11))
          (br $val)
        )
      )
      (local.set $b (i32.const 12))
    )
    (drop (local.get $b))
  )
  (func $no-unreachable
    (local $x i32)
    (drop
      (local.tee $x
        (unreachable)
      )
    )
  )
  (func $implicit-trap-and-global-effects
    (local $var$0 i32)
    (local.set $var$0
     (i32.trunc_f64_u
      (f64.const -nan:0xfffffffffffc3) ;; this implicit trap will actually trap
     )
    )
    (f32.store align=1 ;; and if we move it across this store, the store will execute, having global side effects
     (i32.const 22)
     (f32.const 154)
    )
    (drop
     (local.get $var$0)
    )
  )
  (func $implicit-trap-and-local-effects
    (local $var$0 i32)
    (local $other i32)
    (local.set $var$0
     (i32.trunc_f64_u
      (f64.const -nan:0xfffffffffffc3) ;; this implicit trap will actually trap
     )
    )
    (local.set $other (i32.const 100)) ;; but it's fine to move it across a local effect, that vanishes anyhow
    (drop
     (local.get $var$0)
    )
    (if (i32.const 1)
     (drop
      (local.get $other)
     )
    )
  )
  (func $multi-pass-get-equivs-right (param $var$0 i32) (param $var$1 i32) (result f64)
   (local $var$2 i32)
   (local.set $var$2
    (local.get $var$0)
   )
   (i32.store
    (local.get $var$2)
    (i32.const 1)
   )
   (f64.promote_f32
    (f32.load
     (local.get $var$2)
    )
   )
  )
  (func $if-value-structure-equivalent (param $x i32) (result i32)
    (local $y i32)
    (if (i32.const 1)
      (local.set $x (i32.const 2))
      (block
        (local.set $y (local.get $x))
        (local.set $x (local.get $y))
      )
    )
    (local.get $x)
  )
)

