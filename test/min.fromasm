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
  (func $neg (param $k i32) (param $p i32)
    (local $n f32)
    (set_local $n
      (f32.neg
        (block
          (i32.store align=4
            (get_local $k)
            (get_local $p)
          )
          (f32.load align=4
            (get_local $k)
          )
        )
      )
    )
  )
)
