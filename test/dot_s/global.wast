(module
  (memory 0 4294967295 (segment 2 "9\05\00\00") (segment 6 "\00\00\00\00") (segment 10 "\01\00\00\00") (segment 14 "*\00\00\00") (segment 18 "\ff\ff\ff\ff") (segment 24 "\00\00\00\00\00\00\00\00") (segment 33 "\00\00\00\00\00\00\00\00") (segment 42 "\ff\ff\ff\ff\ff\ff\ff\ff") (segment 50 "\00\00\00\00") (segment 54 "\00\00\00\80") (segment 58 "\00\00\00@") (segment 63 "\00\00\00\00\00\00\00\00") (segment 72 "\00\00\00\00\00\00\00\00") (segment 81 "\00\00\00\00\00\00\00\00"))
  (import $memcpy "env" "memcpy")
  (export "foo" $foo)
  (export "call_memcpy" $call_memcpy)
  (func $foo (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=4
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
          (get_local $$2)
          (get_local $$1)
          (get_local $$0)
        )
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
)
; METADATA: { "asmConsts": {} }