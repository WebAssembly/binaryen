(module
  (memory 51 4294967295 (segment 16 "{ Module.print(\"hello, world!\"); }\00"))
  (import $_emscripten_asm_const_vi "env" "_emscripten_asm_const_vi" (param i32))
  (export "main" $main)
  (func $main (result i32)
    (block $fake_return_waka123
      (block
        (call_import $_emscripten_asm_const_vi
          (i32.const 0)
        )
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["vi"]]},"staticBump": 50 }
