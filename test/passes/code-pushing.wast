(module
  (func $push1
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
  )
  (func $push2
    (local $x i32)
    (local $y i32)
    (block $out
      (set_local $x (i32.const 1))
      (set_local $y (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
      (drop (get_local $y))
    )
  )
  (func $push1-twice
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (br_if $out (i32.const 3))
      (drop (get_local $x))
    )
  )
  (func $push1-twiceb
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (nop)
      (br_if $out (i32.const 3))
      (drop (get_local $x))
    )
  )
  (func $push2-twice
    (local $x i32)
    (local $y i32)
    (block $out
      (set_local $x (i32.const 1))
      (set_local $y (i32.const 3))
      (br_if $out (i32.const 2))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
      (drop (get_local $y))
    )
  )
  (func $ignore-last
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
    )
  )
  (func $push-if
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (if (i32.const 2) (nop))
      (drop (get_local $x))
    )
  )
  (func $push-dropped (result i32)
    (local $x i32)
    (block $out i32
      (set_local $x (i32.const 1))
      (drop (br_if $out (i32.const 2) (i32.const 3)))
      (drop (get_local $x))
      (i32.const 4)
    )
  )
  ;; and now for stuff that should *not* be pushed
  (func $used
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (get_local $x))
      (drop (get_local $x))
    )
  )
  (func $not-sfa
    (local $x i32)
    (set_local $x (i32.const 1))
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
  )
  (func $not-sfa2
    (local $x i32)
    (drop (get_local $x))
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
  )
  (func $used-out
    (local $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
    (drop (get_local $x))
  )
  (func $value-might-interfere ;; but doesn't
    (local $x i32)
    (block $out
      (set_local $x (i32.load (i32.const 0)))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
  )
  (func $value-interferes
    (local $x i32)
    (block $out
      (set_local $x (i32.load (i32.const 0)))
      (i32.store (i32.const 1) (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
    )
  )
)

