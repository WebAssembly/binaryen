(module
  (memory 16777216 16777216)
  (export "floats" $floats)
  (func $floats (param $f f32) (result f32)
    (local $t f32)
    (f32.add
      (get_local $t)
      (get_local $f)
    )
  )
)
