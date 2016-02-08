(module
  (memory 20 4294967295)
  (export "single_block" $single_block)
  (export "foo" $foo)
  (export "bar" $bar)
  (export "fi_ret" $fi_ret)
  (func $single_block (param $$0 i32) (result i32)
    (return
      (i32.store align=4
        (get_local $$0)
        (i32.const 0)
      )
    )
  )
  (func $foo
    (local $$0 i32)
    (set_local $$0
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store offset=8 align=4
        (i32.const 0)
        (i32.const 0)
      )
      (set_local $$0
        (i32.add
          (get_local $$0)
          (i32.const 1)
        )
      )
      (br_if $label$0
        (i32.ne
          (get_local $$0)
          (i32.const 256)
        )
      )
    )
    (return)
  )
  (func $bar
    (local $$0 f32)
    (set_local $$0
      (f32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store offset=8 align=4
        (i32.const 0)
        (i32.const 0)
      )
      (set_local $$0
        (f32.add
          (get_local $$0)
          (f32.const 1)
        )
      )
      (br_if $label$0
        (f32.ne
          (get_local $$0)
          (f32.const 256)
        )
      )
    )
    (return)
  )
  (func $fi_ret (param $$0 i32) (result i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (set_local $$1
      (i32.const 1)
    )
    (set_local $$1
      (i32.load align=4
        (get_local $$1)
      )
    )
    (set_local $$2
      (i32.const 32)
    )
    (set_local $$4
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 1)
    )
    (set_local $$4
      (i32.store align=4
        (get_local $$2)
        (get_local $$4)
      )
    )
    (i32.store align=4
      (get_local $$0)
      (get_local $$4)
    )
    (set_local $$3
      (i32.const 32)
    )
    (set_local $$4
      (i32.add
        (get_local $$4)
        (get_local $$3)
      )
    )
    (set_local $$3
      (i32.const 1)
    )
    (set_local $$4
      (i32.store align=4
        (get_local $$3)
        (get_local $$4)
      )
    )
    (return
      (get_local $$4)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 19 }
