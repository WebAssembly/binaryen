(module
  (type $array (array (mut (ref null func))))

  (tag $foo (param f32))

  (tag $other (param f64))

  (memory $foo 50 60)

  (memory $other 70 80)

  (data $other (i32.const 3) "ghi")

  (data $bar (i32.const 4) "jkl")

  (elem $other (ref null func) $foo $other)

  (elem $bar (ref null func) $other $foo)

  (global $other i32 (i32.const 3))

  (global $bar i32 (i32.const 4))

  (func $foo
    (drop
      (i32.const 3)
    )
  )

  (func $other
    (drop
      (i32.const 4)
    )
  )

  (func $uses.second (param $array (ref $array))
    ;; Tags.
    (try
      (do)
      (catch $foo
        (drop
          (pop f32)
        )
      )
    )
    (try
      (do)
      (catch $other
        (drop
          (pop f64)
        )
      )
    )

    ;; Memories
    (drop
      (i32.load $foo
        (i32.const 3)
      )
    )
    (drop
      (i32.load $other
        (i32.const 4)
      )
    )

    ;; Data segments
    (data.drop $other)
    (data.drop $bar)

    ;; Globals
    (drop
      (global.get $other)
    )
    (drop
      (global.get $bar)
    )

    ;; Element segments
    (array.init_elem $array $other
      (local.get $array)
      (i32.const 7)
      (i32.const 8)
      (i32.const 9)
    )
    (array.init_elem $array $bar
      (local.get $array)
      (i32.const 10)
      (i32.const 11)
      (i32.const 12)
    )

    ;; Functions.
    (call $foo)
    (call $other)
  )
)
