(module
  (memory 0 4294967295)
  (export "alloca32" $alloca32)
  (export "alloca3264" $alloca3264)
  (export "allocarray" $allocarray)
  (export "allocarray_inbounds" $allocarray_inbounds)
  (export "dynamic_alloca" $dynamic_alloca)
  (func $alloca32
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (set_local $$0
          (i32.load align=4
            (get_local $$0)
          )
        )
        (set_local $$1
          (i32.const 16)
        )
        (set_local $$3
          (i32.sub
            (get_local $$0)
            (get_local $$1)
          )
        )
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$1)
            (get_local $$3)
          )
        )
        (i32.store offset=12 align=4
          (get_local $$3)
          (i32.const 0)
        )
        (set_local $$2
          (i32.const 16)
        )
        (set_local $$3
          (i32.add
            (get_local $$3)
            (get_local $$2)
          )
        )
        (set_local $$2
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (get_local $$3)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $alloca3264
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (set_local $$0
          (i32.load align=4
            (get_local $$0)
          )
        )
        (set_local $$1
          (i32.const 16)
        )
        (set_local $$3
          (i32.sub
            (get_local $$0)
            (get_local $$1)
          )
        )
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$1)
            (get_local $$3)
          )
        )
        (i32.store offset=12 align=4
          (get_local $$3)
          (i32.const 0)
        )
        (i64.store align=8
          (get_local $$3)
          (i64.const 0)
        )
        (set_local $$2
          (i32.const 16)
        )
        (set_local $$3
          (i32.add
            (get_local $$3)
            (get_local $$2)
          )
        )
        (set_local $$2
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (get_local $$3)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $allocarray
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$1
          (i32.load align=4
            (get_local $$1)
          )
        )
        (set_local $$2
          (i32.const 32)
        )
        (set_local $$5
          (i32.sub
            (get_local $$1)
            (get_local $$2)
          )
        )
        (set_local $$2
          (i32.const 0)
        )
        (set_local $$5
          (i32.store align=4
            (get_local $$2)
            (get_local $$5)
          )
        )
        (set_local $$0
          (i32.store offset=12 align=4
            (get_local $$5)
            (i32.const 1)
          )
        )
        (set_local $$4
          (i32.const 12)
        )
        (set_local $$4
          (i32.add
            (get_local $$5)
            (get_local $$4)
          )
        )
        (i32.store align=4
          (i32.add
            (get_local $$4)
            (i32.const 4)
          )
          (get_local $$0)
        )
        (set_local $$3
          (i32.const 32)
        )
        (set_local $$5
          (i32.add
            (get_local $$5)
            (get_local $$3)
          )
        )
        (set_local $$3
          (i32.const 0)
        )
        (set_local $$5
          (i32.store align=4
            (get_local $$3)
            (get_local $$5)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $allocarray_inbounds
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (set_local $$0
          (i32.load align=4
            (get_local $$0)
          )
        )
        (set_local $$1
          (i32.const 32)
        )
        (set_local $$3
          (i32.sub
            (get_local $$0)
            (get_local $$1)
          )
        )
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$1)
            (get_local $$3)
          )
        )
        (i32.store offset=16 align=4
          (get_local $$3)
          (i32.store offset=12 align=4
            (get_local $$3)
            (i32.const 1)
          )
        )
        (set_local $$2
          (i32.const 32)
        )
        (set_local $$3
          (i32.add
            (get_local $$3)
            (get_local $$2)
          )
        )
        (set_local $$2
          (i32.const 0)
        )
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (get_local $$3)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $dynamic_alloca (param $$0 i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
