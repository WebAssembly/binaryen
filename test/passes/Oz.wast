(module
  (memory 100 100)
  (func $basics (export "localcse") (param $x i32) ($param $y i32) (result i32) ;; -O3 does localcse
    (local $x2 i32)
    (local $y2 i32)
    (set_local $x2
      (i32.add (get_local $x) (get_local $y))
    )
    (set_local $y2
      (i32.add (get_local $x) (get_local $y))
    )
    (i32.add (get_local $x2) (get_local $y2))
  )
  (func $8 (export "localcse-2") (param $var$0 i32)
    (param $var$1 i32)
    (param $var$2 i32)
    (param $var$3 i32)
    (result i32)
    (block $label$0 (result i32)
      (i32.store
        (tee_local $var$2
          (i32.add
            (get_local $var$1)
            (i32.const 4)
          )
        )
        (i32.and
          (i32.load
            (get_local $var$2)
          )
          (i32.xor
            (tee_local $var$2
              (i32.const 74)
            )
            (i32.const -1)
          )
        )
      )
      (i32.store
        (tee_local $var$1
          (i32.add
            (get_local $var$1)
            (i32.const 4)
          )
        )
        (i32.or
          (i32.load
            (get_local $var$1)
          )
          (i32.and
            (get_local $var$2)
            (i32.const 8)
          )
        )
      )
      (i32.const 0)
    )
  )
)
