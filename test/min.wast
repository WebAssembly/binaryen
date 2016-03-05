(module
  (memory 256 256)
  (export "floats" $floats)
  (func $floats (param $f f32) (result f32)
    (local $t f32)
    (f32.add
      (get_local $t)
      (get_local $f)
    )
  )
  (func $neg (param $k i32) (param $p i32) (result f32)
    (local $n f32)
    (set_local $n
      (f32.neg
        (block $block0
          (i32.store
            (get_local $k)
            (get_local $p)
          )
          (f32.load
            (get_local $k)
          )
        )
      )
    )
  )
  (func $littleswitch (param $x i32) (result i32)
    (block $topmost
      (block $switch-case$2
        (block $switch-case$1
          (br_table $switch-case$1 $switch-case$2 $switch-case$1
            (i32.sub
              (get_local $x)
              (i32.const 1)
            )
          )
        )
        (br $topmost
          (i32.const 1)
        )
      )
      (br $topmost
        (i32.const 2)
      )
      (i32.const 0)
    )
  )
  (func $f1 (param $i1 i32) (param $i2 i32) (param $i3 i32) (result i32)
    (block $topmost
      (get_local $i3)
    )
  )
)
