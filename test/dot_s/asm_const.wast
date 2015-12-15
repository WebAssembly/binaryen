(module
  (memory 0 4294967295 (segment 16 "{ Module.print(\"hello, world!\"); }\00"))
  (import $emscripten_asm_const "env" "emscripten_asm_const")
  (export "main" $main)
  (func $main (result i32)
    (block $fake_return_waka123
      (block
        (call_import $emscripten_asm_const_vi
          (i32.const 16)
        )
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
)
; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["vi"]]} }