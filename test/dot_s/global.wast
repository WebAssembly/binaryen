(module
  (memory 1136 4294967295 (segment 4 "9\05\00\00") (segment 12 "\01\00\00\00") (segment 16 "*\00\00\00") (segment 20 "\ff\ff\ff\ff") (segment 32 "\00\00\00\00\00\00\00\00") (segment 40 "\ff\ff\ff\ff\ff\ff\ff\ff") (segment 52 "\00\00\00\80") (segment 56 "\00\00\00@") (segment 72 "\00\00\00\00\00\00\00\00") (segment 80 "\00\00\00\00\00\00\00\00") (segment 608 "\b0\00\00\00"))
  (import $memcpy "env" "memcpy")
  (export "foo" $foo)
  (export "call_memcpy" $call_memcpy)
  (func $foo (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=4 offset=16
            (i32.const 0)
          )
        )
      )
    )
  )
  (func $call_memcpy (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (call_import $memcpy
          (get_local $$0)
          (get_local $$1)
          (get_local $$2)
        )
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1135 }
