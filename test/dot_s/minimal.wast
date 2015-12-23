(module
  (memory 0 4294967295)
  (export "main" $main)
  (func $main (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 5)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
