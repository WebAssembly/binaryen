(module
  (memory 208 4294967295 (segment 16 "1A\00") (segment 32 "1B\00") (segment 48 "1C\00") (segment 64 "1D\00") (segment 68 "\00\00\00\00\98\00\00\00\00\00\00\00\01\00\00\00\02\00\00\00") (segment 88 "\00\00\00\00\a0\00\00\00\00\00\00\00\03\00\00\00\04\00\00\00") (segment 108 "\00\00\00\00\b0\00\00\00\00\00\00\00\05\00\00\00\06\00\00\00") (segment 128 "\00\00\00\00\c0\00\00\00\00\00\00\00\07\00\00\00\08\00\00\00") (segment 152 "\00\00\00\00\10\00\00\00") (segment 160 "\00\00\00\00 \00\00\00\98\00\00\00") (segment 176 "\00\00\00\000\00\00\00\98\00\00\00") (segment 192 "\00\00\00\00@\00\00\00\a0\00\00\00") (segment 204 "\00\00\00\00"))
  (import $_ZdlPv "env" "_ZdlPv")
  (export "_ZN1A3fooEv" $_ZN1A3fooEv)
  (export "_ZN1B3fooEv" $_ZN1B3fooEv)
  (export "_ZN1C3fooEv" $_ZN1C3fooEv)
  (export "_ZN1D3fooEv" $_ZN1D3fooEv)
  (export "_ZN1AD0Ev" $_ZN1AD0Ev)
  (export "_ZN1BD0Ev" $_ZN1BD0Ev)
  (export "_ZN1CD0Ev" $_ZN1CD0Ev)
  (export "_ZN1AD2Ev" $_ZN1AD2Ev)
  (export "_ZN1DD0Ev" $_ZN1DD0Ev)
  (table $_ZN1AD2Ev $_ZN1AD0Ev $_ZN1A3fooEv $_ZN1BD0Ev $_ZN1B3fooEv $_ZN1CD0Ev $_ZN1C3fooEv $_ZN1DD0Ev $_ZN1D3fooEv)
  (func $_ZN1A3fooEv (param $$0 i32)
    (block $fake_return_waka123
      (block
        (i32.store offset=204 align=4
          (i32.const 0)
          (i32.const 2)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1B3fooEv (param $$0 i32)
    (block $fake_return_waka123
      (block
        (i32.store offset=204 align=4
          (i32.const 0)
          (i32.const 4)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1C3fooEv (param $$0 i32)
    (block $fake_return_waka123
      (block
        (i32.store offset=204 align=4
          (i32.const 0)
          (i32.const 6)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1D3fooEv (param $$0 i32)
    (block $fake_return_waka123
      (block
        (i32.store offset=204 align=4
          (i32.const 0)
          (i32.const 8)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1AD0Ev (param $$0 i32)
    (block $fake_return_waka123
      (block
        (call_import $_ZdlPv
          (get_local $$0)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1BD0Ev (param $$0 i32)
    (block $fake_return_waka123
      (block
        (call_import $_ZdlPv
          (get_local $$0)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1CD0Ev (param $$0 i32)
    (block $fake_return_waka123
      (block
        (call_import $_ZdlPv
          (get_local $$0)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $_ZN1AD2Ev (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
  (func $_ZN1DD0Ev (param $$0 i32)
    (block $fake_return_waka123
      (block
        (call_import $_ZdlPv
          (get_local $$0)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 207 }
