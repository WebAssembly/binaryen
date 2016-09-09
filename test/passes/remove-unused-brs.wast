(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (type $1 (func))
  (type $2 (func (result i32)))
  (func $b0-yes (type $0) (param $i1 i32)
    (block $topmost
      (br $topmost)
    )
  )
  (func $b1 (type $0) (param $i1 i32)
    (block $topmost
      (block
        (drop
          (i32.const 0)
        )
        (br $topmost)
      )
    )
  )
  (func $b2 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br $topmost)
      )
    )
  )
  (func $b3-yes (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br $inner)
      )
    )
  )
  (func $b4 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br $topmost)
        )
      )
    )
  )
  (func $b5 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br $inner)
        )
      )
    )
  )
  (func $b6 (type $0) (param $i1 i32)
    (block $topmost
      (br_if $topmost
        (i32.const 1)
      )
    )
  )
  (func $b7 (type $0) (param $i1 i32)
    (block $topmost
      (block
        (drop
          (i32.const 0)
        )
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b8 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b9 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (br_if $topmost
          (i32.const 1)
        )
      )
    )
  )
  (func $b10 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br_if $topmost
            (i32.const 1)
          )
        )
      )
    )
  )
  (func $b11 (type $0) (param $i1 i32)
    (block $topmost
      (block $inner
        (block
          (drop
            (i32.const 0)
          )
          (br_if $inner
            (i32.const 1)
          )
        )
      )
    )
  )
  (func $b12-yes (type $1)
    (block $topmost
      (if
        (i32.const 1)
        (block $block1
          (drop
            (i32.const 12)
          )
          (block
            (drop
              (i32.const 1)
            )
            (br $topmost)
          )
        )
        (block $block3
          (drop
            (i32.const 27)
          )
          (block
            (drop
              (i32.const 2)
            )
            (br $topmost)
          )
        )
      )
    )
  )
  (func $b13 (type $2) (result i32)
    (block $topmost
      (if
        (i32.const 1)
        (block $block1
          (drop
            (i32.const 12)
          )
          (br_if $topmost
            (i32.const 1)
            (i32.const 1)
          )
        )
        (block $block3
          (drop
            (i32.const 27)
          )
          (br $topmost
            (i32.const 2)
          )
        )
      )
      (i32.const 3)
    )
  )
  (func $b14 (type $2) (result i32)
    (block $topmost
      (if
        (i32.const 1)
        (block $block1
          (i32.const 12)
        )
        (block $block3
          (i32.const 27)
        )
      )
    )
  )
  (func $b15 (type $1)
    (block $topmost
      (if
        (i32.const 17)
        (br $topmost)
      )
    )
  )
  (func $b15 (type $1)
    (block $topmost
      (if
        (i32.const 18)
        (block
          (drop
            (i32.const 0)
          )
          (br $topmost)
        )
      )
    )
  )
  (func $b16 (type $1)
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
  (func $b17 (type $1)
    (block $a
      (if
        (i32.const 0)
        (block $block1
          (br $a)
        )
        (block $block3
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
        (block $block6
          (br $a)
        )
      )
    )
    (block $a
      (if
        (i32.const 0)
        (block $block8
          (br $a)
        )
        (drop
          (i32.const 1)
        )
      )
    )
    (block $c
      (block $b
        (if
          (i32.const 0)
          (block $block11
            (br $b)
          )
          (block $block13
            (br $c)
          )
        )
      )
    )
  )
  (func $ret-1 (type $1)
    (return)
  )
  (func $ret-2 (type $1)
    (block $block0
      (block $block1
        (return)
      )
    )
  )
  (func $ret-3 (type $1)
    (block $block0
      (if
        (i32.const 0)
        (return)
        (block $block3
          (return)
        )
      )
    )
  )
  (func $ret-value (type $2) (result i32)
    (block $block0
      (block $block1
        (return
          (i32.const 1)
        )
      )
    )
  )
  (func $no-select-but-the-last (type $1)
    (block $a
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
        (block $block2
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (drop
            (i32.const 3)
          )
        )
      )
      (if
        (i32.const 0)
        (block $block4
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (drop
            (i32.const 3)
          )
        )
        (drop
          (i32.const 1)
        )
      )
      (if
        (block $block6
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
          (i32.const 3)
        )
        (drop
          (i32.const 0)
        )
        (drop
          (i32.const 1)
        )
      )
      (if
        (block $a
          (br $a
            (i32.const 0)
          )
        )
        (block $a
          (block
            (drop
              (i32.const 1)
            )
            (br $a)
          )
        )
        (block $a
          (block
            (drop
              (i32.const 2)
            )
            (br $a)
          )
        )
      )
    )
  )
  (func $side-effects-and-order (type $2) (result i32)
    (local $x i32)
    (block $do-once$0
      (if
        (call $b13)
        (block
          (drop
            (i32.const 0)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0
      (if
        (call $b13)
        (block
          (drop
            (call $b14)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0
      (if
        (i32.const 0)
        (block
          (drop
            (call $b14)
          )
          (br $do-once$0)
        )
      )
      (drop
        (i32.const 1)
      )
    )
    (block $do-once$0
      (if
        (tee_local $x
          (i32.const 1)
        )
        (br $do-once$0
          (tee_local $x
            (i32.const 2)
          )
        )
      )
      (i32.const 1)
    )
  )
)
