(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (func $b0 (type $0) (param $x i32)
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 8)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1023)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 1024)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (get_local $x)
          (i32.const 2048)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (i32.const 4)
          (get_local $x)
        )
      )
    )
  )
)
