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
  (func $b12-yes
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
  (func $b15
    (block $topmost
      (if
        (i32.const 18)
        (br $topmost (i32.const 0))
      )
    )
  )
  (func $b16
    (block $a
      (block $b
        (block $c
          (br $a)
        )
        (br $a)
      )
      (br $a)
    )
    (block $a
      (block $b
        (block $c
          (br $c)
        )
        (br $b)
      )
      (br $a)
    )
    (block $a
      (block $b
        (block $c
          (br $b)
        )
        (br $a)
      )
      (br $a)
    )
  )
  (func $b17
    (block $a
      (if
        (i32.const 0)
        (block
          (br $a)
        )
        (block
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (i32.const 1)
        (block
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (block
          (br $a)
        )
        (i32.const 1)
      )
    )
    (block $c
      (block $b
        (if
          (i32.const 0)
          (block
            (br $b)
          )
          (block
            (br $c)
          )
        )
      )
    )
  )
  (func $ret-1
    (return)
  )
  (func $ret-2
    (block
      (block
        (return)
      )
    )
  )
  (func $ret-3
    (block
      (if
        (i32.const 0)
        (return)
        (block
          (return)
        )
      )
    )
  )
  (func $ret-value (result i32)
    (block
      (block
        (return (i32.const 1))
      )
    )
  )
  (func $no-select-but-the-last
    (block $a
      (if
        (i32.const 0)
        (i32.const 1)
        (block
          (br $a (i32.const 2))
          (i32.const 3)
        )
      )
      (if
        (i32.const 0)
        (block
          (br $a (i32.const 2))
          (i32.const 3)
        )
        (i32.const 1)
      )
      (if
        (block
          (br $a (i32.const 2))
          (i32.const 3)
        )
        (i32.const 0)
        (i32.const 1)
      )
      (if ;; brs to the inner $a's get removed, the it is selectifiable
        (block $a
          (br $a (i32.const 0))
        )
        (block $a
          (br $a (i32.const 1))
        )
        (block $a
          (br $a (i32.const 2))
        )
      )
    )
  )
  (func $side-effects-and-order (result i32)
    (local $x i32)
    (block $do-once$0
      (if
        (call $b13)
        (br $do-once$0
          (i32.const 0)
        )
      )
      (i32.const 1)
    )
    (block $do-once$0
      (if
        (call $b13)
        (br $do-once$0
          (call $b14)
        )
      )
      (i32.const 1)
    )
    (block $do-once$0
      (if
        (i32.const 0)
        (br $do-once$0
          (call $b14)
        )
      )
      (i32.const 1)
    )
    (block $do-once$0
      (if
        (set_local $x (i32.const 1))
        (br $do-once$0
          (set_local $x (i32.const 2))
        )
      )
      (i32.const 1)
    )
  )
)

