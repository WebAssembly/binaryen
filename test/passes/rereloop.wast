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
      (get_local $x)
      (if
        (get_local $x)
        (return (i32.const 2))
        (return (i32.const 3))
      )
    )
    (if
      (get_local $x)
      (return (i32.const 4))
    )
    (return (i32.const 5))
  )
  (func $loops (param $x i32)
    (if (get_local $x)
      (loop $top
        (call $trivial)
        (br $top)
      )
    )
    (loop $top2
      (call $trivial)
      (br_if $top2 (get_local $x))
    )
    (loop $top3
      (call $trivial)
      (if (get_local $x) (br $top3))
    )
  )
  (func $br-out (param $x i32)
    (block $out
      (call $br-out (i32.const 5))
      (br $out)
    )
  )
  (func $unreachable (param $x i32)
    (if (get_local $x)
      (if (get_local $x)
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
      (br_if $out (get_local $x))
      (call $before-and-after (i32.const 5))
    )
    (call $before-and-after (i32.const 6))
    (loop)
    (call $before-and-after (i32.const 7))
    (loop $top)
    (call $before-and-after (i32.const 8))
    (loop $top2
      (call $before-and-after (i32.const 9))
      (br_if $top2 (get_local $x))
      (call $before-and-after (i32.const 10))
    )
    (call $before-and-after (i32.const 11))
    (if (get_local $x)
      (call $before-and-after (i32.const 12))
    )
    (call $before-and-after (i32.const 13))
    (if (get_local $x)
      (call $before-and-after (i32.const 14))
      (call $before-and-after (i32.const 15))
    )
    (if (get_local $x)
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
        (br_table $a $a (get_local $x))
      )
      (call $switch (i32.const 1))
      (block $b
        (block $c
          (br_table $b $b $b $c (get_local $x))
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
     (get_local $x)
     (call $if-br-wat
      (i32.const 1)
     )
     (if
      (get_local $x)
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

 (func $switcher-to-nowhere (param $0 i32) (result i32)
  (block $switch
   (block $switch-case0
    (block $switch-case
     (br_table $switch-case $switch-case0 $switch
      (get_local $0)
     )
    )
    (return
     (i32.const 1)
    )
   )
   (return
    (i32.const 2)
   )
  )
  (return
   (i32.const 3)
  )
 )
)
(module
 (global $global$0 (mut i32) (i32.const 1))
 (export "one" (func $0))
 (export "two" (func $1))
 (func $0
  (block $outer
   (block
    (br_if $outer ;; taken - do not modify the global, stay it at 1
     (i32.const 1)
    )
    (set_global $global$0 ;; never get here!
     (i32.const 0)
    )
   )
   (unreachable)
  )
 )
 (func $1 (result i32)
  (return (get_global $global$0))
 )
)

