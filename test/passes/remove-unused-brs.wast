(module
  (memory 256 256)
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
  (func $b6 (param $i1 i32)
    (block $topmost
      (br_if $topmost (i32.const 1))
    )
  )
  (func $b7 (param $i1 i32)
    (block $topmost
      (br_if $topmost
        (i32.const 0)
        (i32.const 1)
      )
    )
  )
  (func $b8 (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost (i32.const 1))
      )
    )
  )
  (func $b9 (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost (i32.const 1))
      )
    )
  )
  (func $b10 (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost
          (i32.const 0)
          (i32.const 1)
        )
      )
    )
  )
  (func $b11 (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $inner
          (i32.const 0)
          (i32.const 1)
        )
      )
    )
  )
  (func $b12-yes (result i32)
    (block $topmost
      (if_else (i32.const 1)
        (block
          (i32.const 12)
          (br $topmost
            (i32.const 1)
          )
        )
        (block
          (i32.const 27)
          (br $topmost
            (i32.const 2)
          )
        )
      )
    )
  )
  (func $b13 (result i32)
    (block $topmost
      (if_else (i32.const 1)
        (block
          (i32.const 12)
          (br_if $topmost
            (i32.const 1)
            (i32.const 1)
          )
        )
        (block
          (i32.const 27)
          (br $topmost
            (i32.const 2)
          )
        )
      )
      (i32.const 3)
    )
  )
  (func $b14 (result i32)
    (block $topmost
      (if_else (i32.const 1)
        (block
          (i32.const 12)
        )
        (block
          (i32.const 27)
        )
      )
    )
  )
  (func $b15
    (block $topmost
      (if
        (i32.const 17)
        (br $topmost)
      )
    )
  )
  (func $b15 (result i32)
    (block $topmost
      (if
        (i32.const 18)
        (br $topmost (i32.const 0))
      )
    )
  )
)

