(module
  (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
  (global $stack_ptr (mut i32) (get_global $STACKTOP$asm2wasm$import))
  (func $nothing
  )
  (func $not-alive
    (local $x i32)
    (local $y i64)
    (local $z f32)
    (local $w f64)
    (set_local $x (i32.const 1))
    (set_local $y (i64.const 1))
    (set_local $z (f32.const 1))
    (set_local $w (f64.const 1))
    (call $nothing)
  )
  (func $spill
    (local $x i32)
    (local $y i64)
    (local $z f32)
    (local $w f64)
    (set_local $x (i32.const 1))
    (set_local $y (i64.const 1))
    (set_local $z (f32.const 1))
    (set_local $w (f64.const 1))
    (call $nothing)
    (drop (get_local $x))
    (drop (get_local $y))
    (drop (get_local $z))
    (drop (get_local $w))
  )
)

