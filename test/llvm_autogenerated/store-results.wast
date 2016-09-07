(module
  (memory 1)
  (data (i32.const 4) " \04\00\00")
  (export "memory" memory)
  (type $0 (func (param i32) (result i32)))
  (type $1 (func))
  (export "single_block" $single_block)
  (export "foo" $foo)
  (export "bar" $bar)
  (export "fi_ret" $fi_ret)
  (func $single_block (type $0) (param $0 i32) (result i32)
    (local $1 i32)
    (return
      (block
        (block
          (set_local $1
            (i32.const 0)
          )
          (i32.store
            (get_local $0)
            (get_local $1)
          )
        )
        (get_local $1)
      )
    )
  )
  (func $foo (type $1)
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
          (tee_local $0
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
  (func $bar (type $1)
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
          (tee_local $0
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
  (func $fi_ret (type $0) (param $0 i32) (result i32)
    (local $1 i32)
    (return
      (block
        (block
          (set_local $1
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 32)
            )
          )
          (i32.store
            (get_local $0)
            (get_local $1)
          )
        )
        (get_local $1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1056, "initializers": [] }
