(module
  (func $push1
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $push2
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (i32.const 1))
      (local.set $y (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )
  (func $push1-twice
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (br_if $out (i32.const 3))
      (drop (local.get $x))
    )
  )
  (func $push1-twiceb
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (nop)
      (br_if $out (i32.const 3))
      (drop (local.get $x))
    )
  )
  (func $push2-twice
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (i32.const 1))
      (local.set $y (i32.const 3))
      (br_if $out (i32.const 2))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )
  (func $ignore-last
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
    )
  )
  (func $ignore-last2
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (nop)
      (nop)
      (br_if $out (i32.const 2))
    )
  )
  (func $push-if
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (if (i32.const 2) (nop))
      (drop (local.get $x))
    )
  )
  (func $push-dropped (result i32)
    (local $x i32)
    (block $out (result i32)
      (local.set $x (i32.const 1))
      (drop (br_if $out (i32.const 2) (i32.const 3)))
      (drop (local.get $x))
      (i32.const 4)
    )
  )
  (func $push-past-stuff
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (call $push-past-stuff)
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $fail-then-push
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (i32.const 1))
      (drop (local.get $x))
      (br_if $out (i32.const 2))
      (local.set $y (i32.const 1))
      (br_if $out (i32.const 3))
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )
  ;; and now for stuff that should *not* be pushed
  (func $used
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (local.get $x))
      (drop (local.get $x))
    )
  )
  (func $not-sfa
    (local $x i32)
    (local.set $x (i32.const 1))
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $not-sfa2
    (local $x i32)
    (drop (local.get $x))
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $used-out
    (local $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
    (drop (local.get $x))
  )
  (func $value-might-interfere ;; but doesn't
    (local $x i32)
    (block $out
      (local.set $x (i32.load (i32.const 0)))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $value-interferes
    (local $x i32)
    (block $out
      (local.set $x (i32.load (i32.const 0)))
      (i32.store (i32.const 1) (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $value-interferes-accumulation
    (local $x i32)
    (block $out
      (local.set $x (i32.load (i32.const 0)))
      (nop)
      (i32.store (i32.const 1) (i32.const 3))
      (nop)
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
  (func $value-interferes-in-pushpoint
    (local $x i32)
    (block $out
      (local.set $x (i32.load (i32.const 0)))
      (if (i32.const 1)
        (call $value-interferes)
      )
      (drop (local.get $x))
    )
  )
  (func $values-might-interfere ;; they don't, as we keep the order - but here their side effects prevent pushing
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (call $push-dropped))
      (local.set $y (call $push-dropped))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )
  (func $unpushed-interferes
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (call $push-dropped))
      (local.set $y (call $push-dropped))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
    (drop (local.get $y)) ;; $y can't be pushed, so x can't be
  )
  (func $unpushed-ignorable
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (i32.const 1))
      (local.set $y (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
    (drop (local.get $x)) ;; $x can't be pushed, but y doesn't care
  )
  (func $unpushed-ignorable-side-effect
    (local $x i32)
    (local $y i32)
    (block $out
      (local.set $x (call $push-dropped)) ;; $x can't be pushed, but y doesn't care
      (local.set $y (i32.const 3))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )
  (func $unpushed-side-effect-into-drop
    (local $x i32)
    (block $out
      (local.set $x (call $push-dropped))
      (br_if $out (i32.const 1))
      (drop (local.get $x))
    )
  )
  (func $unpushed-side-effect-into-if
    (local $x i32)
    (block $out
      (local.set $x (call $push-dropped))
      (br_if $out (i32.const 1))
      (if
        (local.get $x)
        (nop)
      )
    )
  )
)

