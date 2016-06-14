(module
  (memory 1
    (segment 4 " \04\00\00")
  )
  (export "memory" memory)
  (export "single_block" $single_block)
  (export "foo" $foo)
  (export "bar" $bar)
  (func $single_block (param $0 i32) (result i32)
    (return
      (i32.store
        (get_local $0)
        (i32.const 0)
      )
    )
  )
  (func $foo
    (local $0 i32)
    (set_local $0
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store offset=12
        (i32.const 0)
        (i32.const 0)
      )
      (br_if $label$0
        (i32.ne
          (set_local $0
            (i32.add
              (get_local $0)
              (i32.const 1)
            )
          )
          (i32.const 256)
        )
      )
    )
    (return)
  )
  (func $bar
    (local $0 f32)
    (set_local $0
      (f32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store offset=12
        (i32.const 0)
        (i32.const 0)
      )
      (br_if $label$0
        (f32.ne
          (set_local $0
            (f32.add
              (get_local $0)
              (f32.const 1)
            )
          )
          (f32.const 256)
        )
      )
    )
    (return)
  )
  (func $fi_ret (param $0 i32) (result i32)
    (return
      (i32.store
        (get_local $0)
        (i32.sub
          (i32.load
            (i32.const 4)
          )
          (i32.const 32)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1056, "initializers": [] }
