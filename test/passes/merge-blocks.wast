(module
  (memory 16777216 16777216)
  (func $b0-yes (param $i1 i32)
    (block $topmost
      (block
        (i32.const 10)
      )
    )
  )
  (func $b1-yes (param $i1 i32)
    (block $topmost
      (block
        (block
          (i32.const 10)
        )
      )
    )
  )
  (func $b2-yes (param $i1 i32)
    (block $topmost
      (i32.const 5)
      (block
        (i32.const 10)
      )
      (i32.const 15)
    )
  )
  (func $b3-yes (param $i1 i32)
    (block $topmost
      (i32.const 3)
      (block
        (i32.const 6)
        (block
          (i32.const 10)
        )
        (i32.const 15)
      )
      (i32.const 20)
    )
  )
  (func $b4 (param $i1 i32)
    (block $topmost
      (block $inner
        (i32.const 10)
        (br $inner)
      )
    )
  )
  (func $b5 (param $i1 i32)
    (block $topmost
      (block $middle
        (block $inner
          (i32.const 10)
          (br $inner)
        )
        (br $middle)
      )
    )
  )
  (func $b6 (param $i1 i32)
    (block $topmost
      (i32.const 5)
      (block $inner
        (i32.const 10)
        (br $inner)
      )
      (i32.const 15)
    )
  )
  (func $b7 (param $i1 i32)
    (block $topmost
      (i32.const 3)
      (block $middle
        (i32.const 6)
        (block $inner
          (i32.const 10)
          (br $inner)
        )
        (i32.const 15)
        (br $middle)
      )
      (i32.const 20)
    )
  )
)

