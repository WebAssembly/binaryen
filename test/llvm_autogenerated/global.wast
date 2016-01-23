(module
  (memory 1184 4294967295 (segment 8 "9\05\00\00") (segment 24 "\01\00\00\00") (segment 28 "*\00\00\00") (segment 32 "\ff\ff\ff\ff") (segment 64 "\00\00\00\00\01\00\00\00") (segment 72 "\ff\ff\ff\ff\ff\ff\ff\ff") (segment 92 "\00\00\00\80") (segment 96 "\00\00\00@") (segment 128 "\00\00\00\00\00\00\00\80") (segment 136 "\00\00\00\00\00\00\00@") (segment 656 "\e0\00\00\00"))
  (type $FUNCSIG$viii (func (param i32 i32 i32)))
  (import $memcpy "env" "memcpy" (param i32 i32 i32))
  (export "foo" $foo)
  (export "call_memcpy" $call_memcpy)
  (func $foo (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load offset=28 align=4
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
;; METADATA: { "asmConsts": {},"staticBump": 1183 }
