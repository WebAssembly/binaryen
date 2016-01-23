(module
  (memory 20 4294967295 (segment 8 "\01\00\00\00\00\00\00\00\00\00\00\00"))
  (export "f" $f)
  (func $f (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store offset=12 align=4
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 19 }
