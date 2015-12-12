(module
  (memory 0 4294967295)
  (func $foo
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
)
