(module
  (memory 51 4294967295
    (segment 16 "{ Module.print(\"hello, world!\"); }\00")
  )
  (type $FUNCSIG$vi (func (param i32)))
  (import $_emscripten_asm_const_vi "env" "_emscripten_asm_const_vi" (param i32))
  (export "main" $main)
  (func $main (result i32)
    (call_import $_emscripten_asm_const_vi
      (i32.const 0)
    )
    (return
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["vi"]]},"staticBump": 50 }
