(module
  (func $test
    (local $x i32)
    (local $y i64)
    (local $z f32)
    (local $w f64)
    (local $F funcref)
    (local $X externref)
    (local $E exnref)
    (local $S v128)

    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $z))
    (drop (local.get $w))
    (drop (local.get $F))
    (drop (local.get $X))
    (drop (local.get $E))

    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $z))
    (drop (local.get $w))
    (drop (local.get $F))
    (drop (local.get $X))
    (drop (local.get $E))

    (local.set $x (i32.const 1))
    (local.set $y (i64.const 2))
    (local.set $z (f32.const 3.21))
    (local.set $w (f64.const 4.321))
    (local.set $F (ref.func $test))
    (local.set $X (local.get $X))
    (local.set $E (local.get $E))

    (local.set $x (i32.const 11))
    (local.set $y (i64.const 22))
    (local.set $z (f32.const 33.21))
    (local.set $w (f64.const 44.321))
    (local.set $F (local.get $F))
    (local.set $X (local.get $X))
    (local.set $E (local.get $E))

    ;; Pop instructions should not be instrumented
    (local.set $F (funcref.pop))
    (local.set $X (externref.pop))
    (local.set $E (exnref.pop))

    ;; Add new instructions here so expected output doesn't change too much, it
    ;; depends on order of instructions in this file.
    (drop (local.get $S))
    (local.set $S (v128.const i32x4 0x00000000 0x00000001 0x00000002 0x00000003))
  )
)

