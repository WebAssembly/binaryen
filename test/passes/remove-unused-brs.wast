(module
  (memory 16777216 16777216)
  (func $b0-yes (param $i1 i32)
    (block $topmost
      (br $topmost)
    )
  )
  (func $b1 (param $i1 i32)
    (block $topmost
      (br $topmost
        (i32.const 0)
      )
    )
  )
  (func $b2 (param $i1 i32)
    (block $topmost
      (block $inner
        (br $topmost)
      )
    )
  )
  (func $b3-yes (param $i1 i32)
    (block $topmost
      (block $inner
        (br $inner)
      )
    )
  )
  (func $b4 (param $i1 i32)
    (block $topmost
      (block $inner
        (br $topmost
          (i32.const 0)
        )
      )
    )
  )
  (func $b5 (param $i1 i32)
    (block $topmost
      (block $inner
        (br $inner
          (i32.const 0)
        )
      )
    )
  )
)

