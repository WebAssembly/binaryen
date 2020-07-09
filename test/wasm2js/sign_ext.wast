(module
  (func $test8 (param $x i32) (result i32)
    (i32.extend8_s (local.get $x))
  )
  (func $test16 (param $x i32) (result i32)
    (i32.extend16_s (local.get $x))
  )
)
