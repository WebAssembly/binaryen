(module
  (memory 0 4294967295)
  (export "unused_first" $unused_first)
  (export "unused_second" $unused_second)
  (export "call_something" $call_something)
  (func $unused_first (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (get_local $$1)
        )
      )
    )
  )
  (func $unused_second (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
  (func $call_something
    (block $fake_return_waka123
      (block
        (call $return_something)
        (br $fake_return_waka123)
      )
    )
  )
)
