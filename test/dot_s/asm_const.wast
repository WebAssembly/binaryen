(module
  (memory 1)
  (data (i32.const 16) "{ Module.print(\"hello, world!\"); }\00")
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (import $emscripten_asm_const_vi "env" "emscripten_asm_const_vi" (param i32))
  (export "main" $main)
  (func $main (result i32)
    (call_import $emscripten_asm_const_vi
      (i32.const 0)
    )
    (return
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["vi"]]},"staticBump": 51, "initializers": [] }
