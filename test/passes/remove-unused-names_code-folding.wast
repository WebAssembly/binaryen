(module
  (func $ifs
    (if (i32.const 0) (nop))
    (if (i32.const 0) (nop) (nop))
    (if (i32.const 0) (nop) (unreachable))
    (drop
      (if (result i32) (i32.const 0)
        (i32.add (i32.const 1) (i32.const 2))
        (i32.add (i32.const 1) (i32.const 2))
      )
    )
    (drop
      (if (result i32) (i32.const 0)
        (i32.add (i32.const 1) (i32.const 2))
        (i32.add (i32.const 1) (i32.const 333333333))
      )
    )
  )
  (func $ifs-blocks
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (unreachable)
        (nop)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (unreachable)
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
        (unreachable)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (nop)
        (unreachable)
      )
    )
  )
  (func $ifs-blocks-big
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (unreachable)
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (unreachable)
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
        (unreachable)
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
        (unreachable)
      )
    )
  )
  (func $ifs-blocks-long
    (if (i32.const 1)
      (block
        (drop (i32.const -1234))
        (drop (i32.const -1000))
        (drop (i32.const 1))
        (nop)
        (unreachable)
      )
      (block
        (drop (i32.const 999))
        (drop (i32.const 1))
        (nop)
        (unreachable)
      )
    )
    (drop
      (if (result i32) (i32.const 2)
        (block (result i32)
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (drop (i32.const 1))
          (nop)
          (unreachable)
          (i32.const 2)
        )
        (block (result i32)
          (drop (i32.const 999))
          (drop (i32.const 1))
          (nop)
          (unreachable)
          (i32.const 2)
        )
      )
    )
    (drop
      (if (result i32) (i32.const 3)
        (block (result i32)
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (drop (i32.const 1))
          (nop)
          (i32.const 2)
        )
        (block (result i32)
          (drop (i32.const 999))
          (drop (i32.const 1))
          (nop)
          (i32.const 2)
        )
      )
    )
  )
  (func $if-worth-it-i-dunno
    ;; just 2, so not worth it
    (if (i32.const 0)
      (block
        (drop (i32.const -1234))
        (drop (i32.const -1000))
        (unreachable)
        (unreachable)
      )
      (block
        (drop (i32.const 999))
        (drop (i32.const 1))
        (unreachable)
        (unreachable)
      )
    )
    ;; 3, so why not
    (if (i32.const 0)
      (block
        (drop (i32.const -1234))
        (drop (i32.const -1000))
        (unreachable)
        (unreachable)
        (unreachable)
      )
      (block
        (drop (i32.const 999))
        (drop (i32.const 1))
        (unreachable)
        (unreachable)
        (unreachable)
      )
    )
    ;; just 2, but we'll empty out a block
    (if (i32.const 0)
      (block
        (unreachable)
        (unreachable)
      )
      (block
        (drop (i32.const 999))
        (drop (i32.const 1))
        (unreachable)
        (unreachable)
      )
    )
    ;; just 2, but we'll empty out a block
    (if (i32.const 0)
      (block
        (drop (i32.const -1234))
        (drop (i32.const -1000))
        (unreachable)
        (unreachable)
      )
      (block
        (unreachable)
        (unreachable)
      )
    )
  )
  (func $ifs-named-block (param $x i32) (param $y i32) (result i32)
    (block $out
      (block $out2
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
        )
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out2 (get_local $y i32))
            (nop)
          )
        )
        (if (get_local $x)
          (block $left
            (br_if $left (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
        )
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block $right
            (br_if $right (get_local $y i32))
            (nop)
          )
        )
      )
      (return (i32.const 10))
    )
    (return (i32.const 20))
  )
  (func $block
    (block $x
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      ;; no fallthrough, another thing to merge
      (drop (i32.const 1))
      (drop (i32.const 2))
      (br $x)
    )
  )
)
