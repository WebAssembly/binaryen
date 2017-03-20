(module
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "memory" (memory $0 1))
 (import "env" "emscripten_asm_const_v" (func $emscripten_asm_const_v (param i32)))
 (table 0 anyfunc)
 (data (i32.const 16) "{ Module.print(\"hello, world!\"); }\00")
 (export "main" (func $main))
 (func $main (result i32)
  (call $emscripten_asm_const_v
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
 )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["v"]]},"staticBump": 51, "initializers": [] }
