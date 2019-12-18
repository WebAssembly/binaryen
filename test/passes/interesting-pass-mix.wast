(module
  (func $trivial
    (nop)
  )
  (func $trivial2
    (call $trivial)
    (call $trivial)
  )
  (func $return-void
    (return)
  )
  (func $return-val (result i32)
    (return (i32.const 1))
  )
  (func $ifs (param $x i32) (result i32)
    (if
      (local.get $x)
      (if
        (local.get $x)
        (return (i32.const 2))
        (return (i32.const 3))
      )
    )
    (if
      (local.get $x)
      (return (i32.const 4))
    )
    (return (i32.const 5))
  )
  (func $loops (param $x i32)
    (if (local.get $x)
      (loop $top
        (call $trivial)
        (br $top)
      )
    )
    (loop $top2
      (call $trivial)
      (br_if $top2 (local.get $x))
    )
    (loop $top3
      (call $trivial)
      (if (local.get $x) (br $top3))
    )
  )
  (func $br-out (param $x i32)
    (block $out
      (call $br-out (i32.const 5))
      (br $out)
    )
  )
  (func $unreachable (param $x i32)
    (if (local.get $x)
      (if (local.get $x)
        (block
          (call $unreachable (i32.const 1))
          (unreachable)
          (call $unreachable (i32.const 2))
        )
        (block
          (call $unreachable (i32.const 3))
          (return)
          (call $unreachable (i32.const 4))
        )
      )
    )
    (block $out
      (call $unreachable (i32.const 5))
      (br $out)
      (call $unreachable (i32.const 6))
    )
  )
  (func $empty-blocks (param $x i32)
    (block)
    (block)
  )
  (func $before-and-after (param $x i32)
    (call $before-and-after (i32.const 1))
    (block
      (call $before-and-after (i32.const 2))
    )
    (call $before-and-after (i32.const 3))
    (block $out
      (call $before-and-after (i32.const 4))
      (br_if $out (local.get $x))
      (call $before-and-after (i32.const 5))
    )
    (call $before-and-after (i32.const 6))
    (loop)
    (call $before-and-after (i32.const 7))
    (loop $top)
    (call $before-and-after (i32.const 8))
    (loop $top2
      (call $before-and-after (i32.const 9))
      (br_if $top2 (local.get $x))
      (call $before-and-after (i32.const 10))
    )
    (call $before-and-after (i32.const 11))
    (if (local.get $x)
      (call $before-and-after (i32.const 12))
    )
    (call $before-and-after (i32.const 13))
    (if (local.get $x)
      (call $before-and-after (i32.const 14))
      (call $before-and-after (i32.const 15))
    )
    (if (local.get $x)
      (block
        (call $before-and-after (i32.const 16))
      )
    )
    (call $before-and-after (i32.const 17))
    (block
      (call $before-and-after (i32.const 18))
      (block
        (call $before-and-after (i32.const 19))
      )
      (call $before-and-after (i32.const 20))
    )
    (call $before-and-after (i32.const 21))
    (block
      (block
        (call $before-and-after (i32.const 22))
      )
    )
    (call $before-and-after (i32.const 23))
    (block $no1
      (block $no2
        (call $before-and-after (i32.const 24))
      )
    )
    (call $before-and-after (i32.const 25))
  )
  (func $switch (param $x i32)
    (block $out
      (block $a
        (br_table $a $a (local.get $x))
      )
      (call $switch (i32.const 1))
      (block $b
        (block $c
          (br_table $b $b $b $c (local.get $x))
        )
        (call $switch (i32.const 2))
      )
      (call $switch (i32.const 3))
    )
  )
  (func $no-return
    (if (i32.const 1)
      (drop (i32.const 2))
      (drop (i32.const 3))
    )
  )
  (func $if-br-wat (param $x i32)
   (call $if-br-wat
    (i32.const 0)
   )
   (block $label$2
    (if
     (local.get $x)
     (call $if-br-wat
      (i32.const 1)
     )
     (if
      (local.get $x)
      (br $label$2) ;; waka
     )
    )
    (call $if-br-wat
     (i32.const 2)
    )
   )
   (call $if-br-wat
    (i32.const 3)
   )
  )
)

